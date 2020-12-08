Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572F72D2629
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgLHIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:33:34 -0500
Received: from first.geanix.com ([116.203.34.67]:58268 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgLHIdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 03:33:33 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Dec 2020 03:33:32 EST
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id E025B485564;
        Tue,  8 Dec 2020 08:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1607415959; bh=lsqzWpSkidQFbFC/2KHGEOpLIdIj+Y37q9lXRL1y3uA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=JYMikx4285LYqJCSnR5UbisXb2SFm4OF51KQyFhRCxBp7O4G9xyzPA2Xqm0N56ppL
         gfkcCMs+ET4QjEQ1hISVMq+o1odD0Vln+7wHJ4NGkU5poId5UrwvHYVunjNq6M+25h
         f+p4ogHTp9+M4i45EqHj47858PiOtbqgF/f2FaJW87xFJsZcdABrbEd5/u0FIfk4kF
         X36nUF3GtyXVQQtia5ArRVPbSsSRRngJW+GsJL9LIyz7v/0RHMtEHRBMiH3G9HVQQe
         6x+hxyN8RtQK/EkQH4l4UIlOL5ziYsdbRIiPpE11Ro8DB6utxz8VUvMmA3gmsqFW3Q
         g8PMZnutUwJEg==
From:   Esben Haabendal <esben@geanix.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: ll_temac: Fix potential NULL dereference in
 temac_probe()
References: <1607392422-20372-1-git-send-email-zhangchangzhong@huawei.com>
Date:   Tue, 08 Dec 2020 09:25:59 +0100
In-Reply-To: <1607392422-20372-1-git-send-email-zhangchangzhong@huawei.com>
        (Zhang Changzhong's message of "Tue, 8 Dec 2020 09:53:42 +0800")
Message-ID: <874kkw3drc.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> writes:

> platform_get_resource() may fail and in this case a NULL dereference
> will occur.
>
> Fix it to use devm_platform_ioremap_resource() instead of calling
> platform_get_resource() and devm_ioremap().
>
> This is detected by Coccinelle semantic patch.
>
> @@
> expression pdev, res, n, t, e, e1, e2;
> @@
>
> res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
> + if (!res)
> +   return -EINVAL;
> ... when != res == NULL
> e = devm_ioremap(e1, res->start, e2);
>
> Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/ll_temac_main.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 60c199f..0301853 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1351,7 +1351,6 @@ static int temac_probe(struct platform_device *pdev)
>  	struct device_node *temac_np = dev_of_node(&pdev->dev), *dma_np;
>  	struct temac_local *lp;
>  	struct net_device *ndev;
> -	struct resource *res;
>  	const void *addr;
>  	__be32 *p;
>  	bool little_endian;
> @@ -1500,13 +1499,11 @@ static int temac_probe(struct platform_device *pdev)
>  		of_node_put(dma_np);
>  	} else if (pdata) {
>  		/* 2nd memory resource specifies DMA registers */
> -		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
> -						     resource_size(res));
> -		if (!lp->sdma_regs) {
> +		lp->sdma_regs = devm_platform_ioremap_resource(pdev, 1);
> +		if (IS_ERR(lp->sdma_regs)) {
>  			dev_err(&pdev->dev,
>  				"could not map DMA registers\n");
> -			return -ENOMEM;
> +			return PTR_ERR(lp->sdma_regs);
>  		}
>  		if (pdata->dma_little_endian) {
>  			lp->dma_in = temac_dma_in32_le;

Acked-by: Esben Haabendal <esben@geanix.com>
