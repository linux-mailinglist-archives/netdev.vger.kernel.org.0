Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C832C255F31
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgH1Qw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgH1Qw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:52:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 758DD20738;
        Fri, 28 Aug 2020 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598633545;
        bh=3q7Hv83sgerMv/jiTLKdlRZyiBuH0LM03o6zvpWtfkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Txo5EuDmwFnEOKzbM6KQ4YDC7ocb+HdZu6d2LjchzHLtAmkQqDXAQOgk1pOBmm87B
         szAC5UdRL/rLb9+Wrvnd7fU9OC5y4truiTPH0EOyds9eUpQ2i8WcvMxlnWIRaGunYN
         QrwqHGMvdHt2+F5+Yb1s1HvUxS75Ep+Ki4wR8sDM=
Date:   Fri, 28 Aug 2020 09:52:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yutaro Hayakawa <yhayakawa3720@gmail.com>
Cc:     netdev@vger.kernel.org, michio.honda@ed.ac.uk
Subject: Re: [PATCH RFC net-next] net/tls: Implement getsockopt SOL_TLS
 TLS_RX
Message-ID: <20200828095223.21d07617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818141224.5113-1-yhayakawa3720@gmail.com>
References: <20200818141224.5113-1-yhayakawa3720@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 14:12:24 +0000 Yutaro Hayakawa wrote:

> @@ -352,7 +352,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
>  	}
>  
>  	/* get user crypto info */
> -	crypto_info = &ctx->crypto_send.info;
> +	if (tx) {
> +		crypto_info = &ctx->crypto_send.info;
> +	} else {
> +		crypto_info = &ctx->crypto_recv.info;
> +	}

No need for parenthesis, if both branches have one line.

>  
>  	if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
>  		rc = -EBUSY;
> @@ -378,11 +382,19 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
>  			goto out;
>  		}
>  		lock_sock(sk);
> -		memcpy(crypto_info_aes_gcm_128->iv,
> -		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> -		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
> -		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
> -		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +		if (tx) {
> +			memcpy(crypto_info_aes_gcm_128->iv,
> +			       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> +			       TLS_CIPHER_AES_GCM_128_IV_SIZE);
> +			memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
> +			       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +		} else {
> +			memcpy(crypto_info_aes_gcm_128->iv,
> +			       ctx->rx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> +			       TLS_CIPHER_AES_GCM_128_IV_SIZE);
> +			memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->rx.rec_seq,
> +			       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +		}

Instead of all the duplication choose the right struct cipher_context
above, like we do for crypto_info.

>  		release_sock(sk);
>  		if (copy_to_user(optval,
>  				 crypto_info_aes_gcm_128,
> @@ -402,11 +414,19 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
>  			goto out;
>  		}
>  		lock_sock(sk);
> -		memcpy(crypto_info_aes_gcm_256->iv,
> -		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
> -		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
> -		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
> -		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
> +		if (tx) {
> +			memcpy(crypto_info_aes_gcm_256->iv,
> +			       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
> +			       TLS_CIPHER_AES_GCM_256_IV_SIZE);
> +			memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
> +			       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
> +		} else {
> +			memcpy(crypto_info_aes_gcm_256->iv,
> +			       ctx->rx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
> +			       TLS_CIPHER_AES_GCM_256_IV_SIZE);
> +			memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->rx.rec_seq,
> +			       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
> +		}

ditto.

>  		release_sock(sk);
>  		if (copy_to_user(optval,
>  				 crypto_info_aes_gcm_256,

