Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C60045575E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbhKRIzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244846AbhKRIzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 03:55:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC71E61BD4;
        Thu, 18 Nov 2021 08:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637225534;
        bh=pBFHTfmMpV+4xz2kRPJx1nuXWX2XIqhAY7r2gl0lchE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ust0WsoXRZj/ibO2y49sF3+A/014lW8dpQwbaJ5tpZayjxfB7dVGpdqzrnSBBZl7/
         5dcNOxnnbrRW11Zct0uKI+gD02s1sP83KDUOtJV1eaHqRXkRlvv3p/qDjf44+SxAUD
         9A/LreFIFYOZ4Txapy4uDvDfme0oOokkvm0Y1DLLn3d+kZT7CSpYL2xsBNPtj93uB0
         0OHHzI3KrllU5IW49NUkeqBHq5W8wt1A8hwNFFuOKPoduqIGBMUMfmzfIYEbRkJOTo
         SYEGZ/Tv73I+P34PozVyXJwb7yTGPwwphkSXesGZM7hdFMEE/PdyPXOURGWJ+s5Pam
         msGZQZ/Ho0onw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mnd9B-0006Kd-FP; Thu, 18 Nov 2021 09:51:58 +0100
Date:   Thu, 18 Nov 2021 09:51:57 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnx2x: fix variable dereferenced before check
Message-ID: <YZYULWjK34xL6BeW@hovoldconsulting.com>
References: <20211113223636.11446-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211113223636.11446-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Adding Dan. ]

On Sun, Nov 14, 2021 at 01:36:36AM +0300, Pavel Skripkin wrote:
> Smatch says:
> 	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
> 	warn: variable dereferenced before check 'ilt' (see line 638)
> 
> Move ilt_cli variable initialization _after_ ilt validation, because
> it's unsafe to deref the pointer before validation check.

It seems smatch is confused here. There is no dereference happening
until after the check, we're just determining the address when
initialising ilt_cli.

I know this has been applied, and the change itself is fine, but the
patch description is wrong and the Fixes tag is unwarranted.
 
> Fixes: 523224a3b3cd ("bnx2x, cnic, bnx2i: use new FW/HSI")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
> index 1835d2e451c0..fc7fce642666 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
> @@ -635,11 +635,13 @@ static int bnx2x_ilt_client_mem_op(struct bnx2x *bp, int cli_num,
>  {
>  	int i, rc;
>  	struct bnx2x_ilt *ilt = BP_ILT(bp);
> -	struct ilt_client_info *ilt_cli = &ilt->clients[cli_num];
> +	struct ilt_client_info *ilt_cli;
>  
>  	if (!ilt || !ilt->lines)
>  		return -1;
>  
> +	ilt_cli = &ilt->clients[cli_num];
> +
>  	if (ilt_cli->flags & (ILT_CLIENT_SKIP_INIT | ILT_CLIENT_SKIP_MEM))
>  		return 0;

Johan
