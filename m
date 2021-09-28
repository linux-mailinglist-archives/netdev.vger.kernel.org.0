Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1441AECA
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbhI1MVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:40 -0400
Received: from mx24.baidu.com ([111.206.215.185]:34492 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240598AbhI1MVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:39 -0400
Received: from BC-Mail-Ex07.internal.baidu.com (unknown [172.31.51.47])
        by Forcepoint Email with ESMTPS id 0CAF91281473FE889426;
        Tue, 28 Sep 2021 20:19:56 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX07.internal.baidu.com (172.31.51.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 28 Sep 2021 20:19:55 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 28
 Sep 2021 20:19:55 +0800
Date:   Tue, 28 Sep 2021 20:19:54 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mdio: mscc-miim: Fix the mdio controller
Message-ID: <20210928121954.GA1845@LAPTOP-UKSR4ENP.internal.baidu.com>
References: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex05.internal.baidu.com (10.127.64.15) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 9月 21 09:17:20, Horatiu Vultur wrote:
> According to the documentation the second resource is optional. But the
> blamed commit ignores that and if the resource is not there it just
> fails.
> 
> This patch reverts that to still allow the second resource to be
> optional because other SoC have the some MDIO controller and doesn't
> need to second resource.
> 
> Fixes: 672a1c394950 ("net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Cai Huoqing <caihuoqing@baidu.com>

> ---
>  drivers/net/mdio/mdio-mscc-miim.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> index 1ee592d3eae4..17f98f609ec8 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -134,8 +134,9 @@ static int mscc_miim_reset(struct mii_bus *bus)
>  
>  static int mscc_miim_probe(struct platform_device *pdev)
>  {
> -	struct mii_bus *bus;
>  	struct mscc_miim_dev *dev;
> +	struct resource *res;
> +	struct mii_bus *bus;
>  	int ret;
>  
>  	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
> @@ -156,10 +157,14 @@ static int mscc_miim_probe(struct platform_device *pdev)
>  		return PTR_ERR(dev->regs);
>  	}
>  
> -	dev->phy_regs = devm_platform_ioremap_resource(pdev, 1);
> -	if (IS_ERR(dev->phy_regs)) {
> -		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
> -		return PTR_ERR(dev->phy_regs);
> +	/* This resource is optional */
Looks good to me,

Thanks,
Cai
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (res) {
> +		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(dev->phy_regs)) {
> +			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
> +			return PTR_ERR(dev->phy_regs);
> +		}
>  	}
>  
>  	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> -- 
> 2.33.0
> 
