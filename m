Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC0F3D6590
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhGZQjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241616AbhGZQiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FCDF60F44;
        Mon, 26 Jul 2021 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627319928;
        bh=+CcyGlBerMfsxhJmCjzpCHhYPHtnbheE5VAiT7m0sD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cMdXdUt+CvBSYxDSnrQorpRVcY1ZNvej7RshO7wd1QCv16CHs3y6qAKft2Ovg700A
         xI7OKeDepoOpQ4QwY6N8GW//KuH04x6HPkhBsqItB1deTenz7JDrvEKyPgiFAh7xAD
         r+3N0XVKXcElx7j5z48ex2fx83WND6c7ZpnG0jHgRsIWh8vGzioT1YdYFQ7eNw1/Vd
         6HXDDpftr3orjRkCyNfIdkRjezZRQRFTcMyg3bBOrQRb0zQjW0oX5W716bpJYu25CK
         eaKZ4CSEIbfOSwVUQl/D7f2mzFLxWjNdOszJ7+Dlo/AcdzH3an/hZ0DmE6YHNLItk5
         oiflbICyt7+Aw==
Date:   Mon, 26 Jul 2021 10:18:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccm - avoid negative wrapping of integers
Message-ID: <YP7udzoj4vVQHlYv@gmail.com>
References: <20210726170120.410705-1-jordy@pwning.systems>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726170120.410705-1-jordy@pwning.systems>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 07:01:20PM +0200, Jordy Zomer wrote:
> Set csize to unsigned int to avoid it from wrapping as a negative number (since format input sends an unsigned integer to this function). This would also result in undefined behavior in the left shift when msg len is checked, potentially resulting in a buffer overflow in the memcpy call.
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> ---
> To address was corrected, and ccm was added to the topic to indicate that this is just for ccm.
> 
>  crypto/ccm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 6b815ece51c6..e14201edf9db 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -66,7 +66,7 @@ static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
>  	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
>  }
>  
> -static int set_msg_len(u8 *block, unsigned int msglen, int csize)
> +static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
>  {
>  	__be32 data;

This isn't necessarily a bad change, but the value of csize is clearly in
[1, 256] if you read format_input(), and in fact is in [2, 8] if you read the
whole file, so please don't claim this is actually fixing anything, as it's not.
Also please line wrap your commit message.

- Eric
