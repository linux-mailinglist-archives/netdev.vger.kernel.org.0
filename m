Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9DC6276E3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 08:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbiKNH72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 02:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiKNH70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 02:59:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBD9226
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 23:59:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3583FB80D3C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53915C433C1;
        Mon, 14 Nov 2022 07:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668412762;
        bh=2xMod9AjS+k2n/Wm7+JPa6ousSSe0m8eAb4ePkgOB2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eit9UlkAAd7e97K6/F1AxTlkBS96S/U85FfNsMDTjgMk/hnmz9SLJjh8YRfigznqQ
         olUp4XQ2QE9voBKJgj3Okc2+Q7uonpjM6y68eYEiBHyMWmrgPu4++sViI6hTBtlwkG
         bk5vKyo+AJg51vyqvZ6XUNSmlV2/YW3cqxR7Zb6lyE/DWfO+tYccx0rZ19UQqBHZ2n
         dOErDGatbIsHO/X8OI6MauTEuBHC6J6T6pRNIfrGqfm+H+Dx4UE0CPQrMntJmMRxDq
         PJfi6SJ6JC2ELpfguzA6+SZ6fS7qHJ8CfkVZ+a3qhhG6XAHEH15ysf96eLBg7v87f4
         J96VaeJsZxAnQ==
Date:   Mon, 14 Nov 2022 09:59:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yan Cangang <nalanzeyu@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix memory leak in
 mtk_ppe_init()
Message-ID: <Y3H1VgVOJB5kHbaa@unreal>
References: <20221112233239.824389-1-nalanzeyu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112233239.824389-1-nalanzeyu@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 07:32:39AM +0800, Yan Cangang wrote:
>     When dmam_alloc_coherent() or devm_kzalloc() failed, the rhashtable
>     ppe->l2_flows isn't destroyed. Fix it.
 ^^^^^
Please fix indentation in commit message.

> 
> Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
> index 2d8ca99f2467..8da4c8be59fd 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -737,7 +737,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
>  				  MTK_PPE_ENTRIES * soc->foe_entry_size,
>  				  &ppe->foe_phys, GFP_KERNEL);
>  	if (!foe)
> -		return NULL;
> +		goto err_free_l2_flows;
>  
>  	ppe->foe_table = foe;
>  
> @@ -745,11 +745,15 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
>  			sizeof(*ppe->foe_flow);
>  	ppe->foe_flow = devm_kzalloc(dev, foe_flow_size, GFP_KERNEL);
>  	if (!ppe->foe_flow)
> -		return NULL;
> +		goto err_free_l2_flows;
>  
>  	mtk_ppe_debugfs_init(ppe, index);
>  
>  	return ppe;
> +
> +err_free_l2_flows:
> +	rhashtable_destroy(&ppe->l2_flows);

I expect the same change to be in mtk_mdio_cleanup() too.

Thanks


> +	return NULL;
>  }
>  
>  static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
> -- 
> 2.30.2
> 
