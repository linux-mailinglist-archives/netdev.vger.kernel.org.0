Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C508407F95
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhILTFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhILTFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 15:05:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0143B6103D;
        Sun, 12 Sep 2021 19:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631473457;
        bh=1OUTp3LU5sr6YMJWSvBJzrKkQbU9FLlZnEdGkm0fnrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=na6oNA+5KeCeP56MibSWsm5dbcv4wSrasnDCdAeKV2Cu1nTb62o9ajyfZvsAU/0DG
         Q5gihgijxbOiX1Brc2ELNNVvk8wEJ0QZc7RXI2wSweElVBi80FcTOql21JR1+bndMx
         nYPREKJI5ESgBKTDWz8RRD+a2bo9QweOaTyMne/hAzWgeqKHzjU/de4V3lBMQjRUDx
         WomjZ4B2cJ+2ovMwTw6uT/9gKHfxijxDq/ERYrva93bsh+umGXw9pnxGCbTrBhzsZo
         szMtPLoIRZdMz3QQ2eZ9snpSuuYEf6j2T3azvzY7/0+9qs0NawdVLvFubt+9Y3n2KG
         LHYmBhwUic14g==
Date:   Sun, 12 Sep 2021 14:07:58 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: Prefer struct_size over open coded arithmetic
Message-ID: <20210912190758.GA146608@embeddedor>
References: <20210912131057.2285-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912131057.2285-1-len.baker@gmx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 03:10:57PM +0200, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() function.
> 
> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

I'll take this in my -next tree. :)

Thanks, Len.
--
Gustavo

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index 3b8e675087de..369f6ae700c7 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -499,8 +499,7 @@ struct nfp_reprs *nfp_reprs_alloc(unsigned int num_reprs)
>  {
>  	struct nfp_reprs *reprs;
> 
> -	reprs = kzalloc(sizeof(*reprs) +
> -			num_reprs * sizeof(struct net_device *), GFP_KERNEL);
> +	reprs = kzalloc(struct_size(reprs, reprs, num_reprs), GFP_KERNEL);
>  	if (!reprs)
>  		return NULL;
>  	reprs->num_reprs = num_reprs;
> --
> 2.25.1
> 
