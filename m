Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5266F3A3C6E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhFKG7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:59:50 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:6267 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhFKG7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:59:48 -0400
Received: from dggeml759-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G1Wkb3Txxz1BLPf;
        Fri, 11 Jun 2021 14:52:55 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:57:49 +0800
Subject: Re: [PATCH net-next v2] net: mdio: mscc-miim: Use
 devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
References: <20210611045049.3905429-1-yangyingliang@huawei.com>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <72e99523-b1f0-bff4-ad96-0d71b3901480@huawei.com>
Date:   Fri, 11 Jun 2021 14:57:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210611045049.3905429-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>    only convert the first platform_get_resource()
> ---
>   drivers/net/mdio/mdio-mscc-miim.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> index b36e5ea04ddf..071c654bab29 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -139,10 +139,6 @@ static int mscc_miim_probe(struct platform_device *pdev)
>   	struct mscc_miim_dev *dev;
>   	int ret;
>   
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENODEV;
> -
>   	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
>   	if (!bus)
>   		return -ENOMEM;
> @@ -155,7 +151,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
>   	bus->parent = &pdev->dev;
>   
>   	dev = bus->priv;
> -	dev->regs = devm_ioremap_resource(&pdev->dev, res);
> +	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);


res not used later, so should be

dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);


>   	if (IS_ERR(dev->regs)) {
>   		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
>   		return PTR_ERR(dev->regs);
