Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E095162EE3B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 08:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiKRHVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 02:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiKRHV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 02:21:29 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEE07C46A;
        Thu, 17 Nov 2022 23:21:27 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ND7Vj2CxLzmW2P;
        Fri, 18 Nov 2022 15:21:01 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 15:21:26 +0800
Received: from [10.67.109.54] (10.67.109.54) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 18 Nov
 2022 15:21:25 +0800
Subject: Re: [PATCH net v2] net: mdio-ipq4019: fix possible invalid pointer
 dereference
To:     Andrew Lunn <andrew@lunn.ch>
References: <20221117090514.118296-1-tanghui20@huawei.com>
 <Y3Y94/My9Al4pw+h@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <6cad3105-0e70-d890-162b-513855885fde@huawei.com>
Date:   Fri, 18 Nov 2022 15:21:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y3Y94/My9Al4pw+h@lunn.ch>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.54]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/17 21:57, Andrew Lunn wrote:
> On Thu, Nov 17, 2022 at 05:05:14PM +0800, Hui Tang wrote:
>> priv->eth_ldo_rdy is saved the return value of devm_ioremap_resource(),
>> which !IS_ERR() should be used to check.
>>
>> Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>> ---
>> v1 -> v2: set priv->eth_ldo_rdy NULL, if devm_ioremap_resource() failed
>> ---
>>  drivers/net/mdio/mdio-ipq4019.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
>> index 4eba5a91075c..dfd1647eac36 100644
>> --- a/drivers/net/mdio/mdio-ipq4019.c
>> +++ b/drivers/net/mdio/mdio-ipq4019.c
>> @@ -231,8 +231,11 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>>  	/* The platform resource is provided on the chipset IPQ5018 */
>>  	/* This resource is optional */
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> -	if (res)
>> +	if (res) {
>>  		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
>> +		if (IS_ERR(priv->eth_ldo_rdy))
>> +			priv->eth_ldo_rdy = NULL;
>> +	}
>
> As i said, please add devm_ioremap_resource_optional().  Follow the
> concept of devm_clk_get_optional(), devm_gpiod_get_optional(),
> devm_reset_control_get_optional(), devm_reset_control_get_optional(),
> platform_get_irq_byname_optional() etc.
>
> All these will not return an error if the resource you are trying to
> get does not exist. They instead return NULL, or something which other
> API members understand as does not exist, but thats O.K.
>
> These functions however do return errors for real problem, ENOMEM,
> EINVAL etc. These should not be ignored.
>
> You should then use this new function for all your other patches where
> the resource is optional.


I finally understand what you mean now.

I need add devm_ioremap_resource_optional() helper, which return NULL
if the resource does not exist, and if it return other errors we need
to deal with errors. In my case, it returns -ENOMEM if the resource
does not exist.

So, the code should be as follows, is that right?

+	void __iomem *devm_ioremap_resource_optional(struct device *dev,
+                                    	     const struct resource *res)
+	{
+		void __iomem *base;
+
+		base = __devm_ioremap_resource(dev, res, DEVM_IOREMAP);
+		if (IS_ERR(base) && PTR_ERR(base) == -ENOMEM)
+			return NULL;
+
+		return base;
+	}


[...]
	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res)
+	if (res) {
+		priv->eth_ldo_rdy = devm_ioremap_resource_optional(&pdev->dev, res)
+		if (IS_ERR(priv->eth_ldo_rdy))
+			return PTR_ERR(priv->eth_ldo_rdy);
+	}
[...]

thanks.
