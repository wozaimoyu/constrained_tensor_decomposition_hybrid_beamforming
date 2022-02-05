function R = MUspectralEfficiency(H,F,W,Ns,rho,sigma2)
    [Nr,Nt,M,K] = size(H);
    R = 0;    
%     if K == 1
%         H = reshape(H(:,:,1),Nr,Nt);
%         F = reshape(F(:,:,1),Nt,Ns);
%         W = reshape(W(:,:,1),Nr,Ns);        
%         Rn = sigma2_n*(W'*W);
%         R = real( log2( det( eye(Ns) + (snr/(K*Ns))*pinv(Rn)*(W'*(H*(F*F')*H')*W) ) ));
%     else
	for m =1:M
        for k = 1:K 
            Hi = H(:,:,m,k);
            Fi = F(:,:,m,k);
            Wi = W(:,:,m,k);
            Raux = eye(Nr);            
            for j = setdiff(1:K,k)
                Fj = F(:,:,m,j);  
                if sum(sum(isnan(Fj*Fj')))
                    Raux = Raux;
                else
                    Raux = Raux + (rho/sigma2)*(Hi*(Fj*Fj')*Hi');
                end
            end 
            Rn = Wi'*Raux*Wi + eps*eye(Ns);
            R = R + (1/M) * real( log2( det( eye(Ns) + (rho/sigma2)*pinv(Rn)*(Wi'*(Hi*(Fi*Fi')*Hi')*Wi) ) ));
        end
	end
%     end    
end