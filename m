Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9229941AB40
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbhI1I4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 04:56:01 -0400
Received: from mx22.baidu.com ([220.181.50.185]:34848 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235918AbhI1I4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 04:56:00 -0400
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id E802520A90A62FF4BC50;
        Tue, 28 Sep 2021 16:54:16 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 28 Sep 2021 16:54:16 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 28
 Sep 2021 16:54:16 +0800
Date:   Tue, 28 Sep 2021 16:54:14 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <caihuoqing@baidu.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net] net: mdio: mscc-miim: Fix the mdio controller
Message-ID: <20210928085414.GA1723@LAPTOP-UKSR4ENP.internal.baidu.com>
References: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex24.internal.baidu.com (172.31.51.18) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 9月 21 09:17:20, Horatiu Vultur wrote:
Hi Horatiu,

Thank for your feedback.

I'm sorry for this commit, my mistake.

After I have checked my recent submission history

the commit-
commit fa14d03e014a130839f9dc1b97ea61fe598d873d
drivers/net/mdio/mdio-ipq4019.c 225 line

has the same issue, an optional phy-regs
Are you willing to fix it at the same time:)

Many thanks.

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
