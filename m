Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF396641CE8
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiLDMc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLDMc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:32:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1B512ABC
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 04:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C7960E77
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 12:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E67FC433D6;
        Sun,  4 Dec 2022 12:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670157176;
        bh=iQ+pz5jxkUQV3CQlFhNyB/esFfXV4PiszQqeGxj1DHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LtdtNu9OpHfq9fmUT8vSQ/4j3F8FCbpsUfleSd8jgScmW0L3IhW+/CgAfXGAmlQQj
         NI3783c/zSBwPyVXkfum5N5f+5YpPfZe8unYzVxx0lMAV00xJMgPHLfphaEw4ghJ0T
         rpAUlGlJwtDmvmpaswutbd56utsIDzJCch8ksxpFUi/ppTPRNRo9opImNQERh91vRb
         CG0GLGBCge/9b9A+1/fELSbmSz0ovHoIFTJgONxIKlg8XbzFkmlzQ7fTTcrVZjk8zP
         UhrAtskiR8Gu1CGZpS555coRgnEfX66qLf1PQB2n1iZXJBWH4DcusRYO4d2BkniM34
         eZQ4bbPXkO6xw==
Date:   Sun, 4 Dec 2022 14:32:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, sujuan.chen@mediatek.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mtk_wed: Fix missing of_node_put() in
 mtk_wed_wo_hardware_init()
Message-ID: <Y4yTbO0+7MmhTvVT@unreal>
References: <20221202083029.87834-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202083029.87834-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 08:30:29AM +0000, Yuan Can wrote:
> The np needs to be released through of_node_put() in the error handling
> path of mtk_wed_wo_hardware_init().
> 
> Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed_wo.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Please use [PATCH net-next] ... format in title.

> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> index 4754b6db009e..d61bd0b11331 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> @@ -407,8 +407,10 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
>  		return -ENODEV;
>  
>  	wo->mmio.regs = syscon_regmap_lookup_by_phandle(np, NULL);
> -	if (IS_ERR_OR_NULL(wo->mmio.regs))

syscon_regmap_lookup_by_phandle() returns or error or valid pointer.
The right check needs to be IS_ERR(wo->mmio.regs)

Thanks

> -		return PTR_ERR(wo->mmio.regs);
> +	if (IS_ERR_OR_NULL(wo->mmio.regs)) {
> +		ret = PTR_ERR(wo->mmio.regs);
> +		goto error_put;
> +	}
>  
>  	wo->mmio.irq = irq_of_parse_and_map(np, 0);
>  	wo->mmio.irq_mask = MTK_WED_WO_ALL_INT_MASK;
> @@ -456,7 +458,8 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
>  
>  error:
>  	devm_free_irq(wo->hw->dev, wo->mmio.irq, wo);
> -
> +error_put:
> +	of_node_put(np);
>  	return ret;
>  }
>  
> -- 
> 2.17.1
> 
