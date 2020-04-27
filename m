Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14A01BA078
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 11:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgD0JzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 05:55:22 -0400
Received: from first.geanix.com ([116.203.34.67]:51892 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgD0JzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 05:55:22 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 05:55:21 EDT
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 750221F60926;
        Mon, 27 Apr 2020 09:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1587980771; bh=AwtusWpYt0LjMAEEufQD2qMu5uEH4zwOOrUFXhxnuNo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=A1BmdL+VtH0e0/3aFPtJlxa6fTvYjW4SNEsJQrx3/q3i87z27fb3KcWUDicBz1b/b
         AUUvhQH4zT5Kgt/u/HpT/cN6kImVutqs9cyBWkLVezLWstRpuXVrrEZbPPnEOMr2k/
         eCTOTYngvFURE9wY2gcdvQkiDCTURK4uUNHCQOsiC5V2Hux9r6Acxs+yim/MrDQU1O
         XS8XThsWPcqd+DAqY/Z3BZZPHQMV6NUReVKIBMF36FPAGfz8lZll02r2ic4LU2fPvH
         WBnRj1ViXSsnisSuaLvOR1LnCrHHrp42jvd9iVu38wmGelUGiPFCBCZRMW451xz1vi
         aEtUjg3Y13/8Q==
From:   Esben Haabendal <esben@geanix.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     <michal.simek@xilinx.com>, <andrew@lunn.ch>, <ynezz@true.cz>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ll_temac: Fix return value check in temac_probe()
References: <20200427094052.181554-1-weiyongjun1@huawei.com>
Date:   Mon, 27 Apr 2020 11:46:10 +0200
In-Reply-To: <20200427094052.181554-1-weiyongjun1@huawei.com> (Wei Yongjun's
        message of "Mon, 27 Apr 2020 09:40:52 +0000")
Message-ID: <87sggpp8gt.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 581450de519a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Esben Haabendal <esben@geanix.com>

Wei Yongjun <weiyongjun1@huawei.com> writes:

> In case of error, the function devm_ioremap() returns NULL pointer
> not ERR_PTR(). The IS_ERR() test in the return value check should
> be replaced with NULL test.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/ll_temac_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 3e313e71ae36..929244064abd 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1410,9 +1410,9 @@ static int temac_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	lp->regs = devm_ioremap(&pdev->dev, res->start,
>  					resource_size(res));
> -	if (IS_ERR(lp->regs)) {
> +	if (!lp->regs) {
>  		dev_err(&pdev->dev, "could not map TEMAC registers\n");
> -		return PTR_ERR(lp->regs);
> +		return -ENOMEM;
>  	}
>  
>  	/* Select register access functions with the specified
> @@ -1505,10 +1505,10 @@ static int temac_probe(struct platform_device *pdev)
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>  		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
>  						     resource_size(res));
> -		if (IS_ERR(lp->sdma_regs)) {
> +		if (!lp->sdma_regs) {
>  			dev_err(&pdev->dev,
>  				"could not map DMA registers\n");
> -			return PTR_ERR(lp->sdma_regs);
> +			return -ENOMEM;
>  		}
>  		if (pdata->dma_little_endian) {
>  			lp->dma_in = temac_dma_in32_le;
