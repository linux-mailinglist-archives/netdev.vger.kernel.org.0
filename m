Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B66576AD1
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiGOXoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGOXoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:44:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0BC13E06
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:44:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF50E6204D
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 23:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CA7C341C0;
        Fri, 15 Jul 2022 23:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657928659;
        bh=+DMHe8SSIn9I0C6Mi1SK0ytQbR8W/BxJwOC3n8ThWxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G87Cto2Z1dpkTXrklNVydoHtMtg0YvjJKgnHCjo3BG4C84e7ruKzsCCChyD/CTE2L
         3gMIbFyJs0+yi3FDXx75EU/xkvUJylBHXs9nqiR8NZNAUmbn7AwfM06OW/uKo92tBg
         fozhx2BtFi/rVf6UJXsobryMQyq0ynfI1J1tOmwy4preJYx1Z3+TutKdHMrvGA+G21
         EzPU4QMQVCczdfZSt7IQ4FTe2+oFNOQuFJTk58RSGLNm/gr5n8pfxhuiezZQ47mQ/L
         hlhXuIqs67FgSQxgQ5bE6zbOwT9u8ZsCXiFNRreJd/dryvWfYif64GMCleT+NQjMz5
         gVEvFIr739pLw==
Date:   Fri, 15 Jul 2022 16:44:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: altera: Handle dma_set_coherent_mask error codes
Message-ID: <20220715164417.577cbae3@kernel.org>
In-Reply-To: <20220714132342.13051-1-kda@linux-powerpc.org>
References: <20220714132342.13051-1-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 16:23:42 +0300 Denis Kirjanov wrote:
> handle the error in the case that DMA mask is not supportyed
> 
> Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/net/ethernet/altera/altera_tse_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
> index 8c5828582c21..7773d978321a 100644
> --- a/drivers/net/ethernet/altera/altera_tse_main.c
> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
> @@ -1439,10 +1439,14 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	}
>  
>  	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask))) {
> -		dma_set_coherent_mask(priv->device,
> +		ret = dma_set_coherent_mask(priv->device,
>  				      DMA_BIT_MASK(priv->dmaops->dmamask));
> +		if (ret)
> +			goto err_free_netdev;
>  	} else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32))) {
> -		dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
> +		ret = dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
> +		if (ret)
> +			goto err_free_netdev;
>  	} else {
>  		ret = -EIO;
>  		goto err_free_netdev;

Practically speaking this can't fail, see Christophe's patches like 
b6f2f0352c0302

If you want to be on the safe side just replace the dma_set_mask()
with dma_set_mask_and_coherent() and let the else branch handle the
failure.

Please CC maintainers when reposting.
