Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21184630C36
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 06:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiKSFlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 00:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSFlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 00:41:10 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2586C56565;
        Fri, 18 Nov 2022 21:41:08 -0800 (PST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NDjDW2V6fzRpGg;
        Sat, 19 Nov 2022 13:40:43 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 19 Nov 2022 13:41:07 +0800
Received: from [10.67.109.54] (10.67.109.54) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 19 Nov
 2022 13:41:06 +0800
Subject: Re: [PATCH net v2] net: mdio-ipq4019: fix possible invalid pointer
 dereference
To:     Andrew Lunn <andrew@lunn.ch>
References: <20221117090514.118296-1-tanghui20@huawei.com>
 <Y3Y94/My9Al4pw+h@lunn.ch> <6cad3105-0e70-d890-162b-513855885fde@huawei.com>
 <Y3eMMc7maaPCKUNS@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <3cb5a576-8eb7-54fc-4f4b-9db360b6713d@huawei.com>
Date:   Sat, 19 Nov 2022 13:41:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y3eMMc7maaPCKUNS@lunn.ch>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.54]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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



On 2022/11/18 21:44, Andrew Lunn wrote:
>> So, the code should be as follows, is that right?
>>
>> +	void __iomem *devm_ioremap_resource_optional(struct device *dev,
>> +                                    	     const struct resource *res)
>> +	{
>> +		void __iomem *base;
>> +
>> +		base = __devm_ioremap_resource(dev, res, DEVM_IOREMAP);
>> +		if (IS_ERR(base) && PTR_ERR(base) == -ENOMEM)
>> +			return NULL;
>> +
>> +		return base;
>> +	}
>>
>>
>> [...]
>> 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> -	if (res)
>> +	if (res) {
>> +		priv->eth_ldo_rdy = devm_ioremap_resource_optional(&pdev->dev, res)
>> +		if (IS_ERR(priv->eth_ldo_rdy))
>> +			return PTR_ERR(priv->eth_ldo_rdy);
>> +	}
>> [...]
>
> Yes, that is the basic concept.
>
> The only thing i might change is the double meaning of -ENOMEM.
> __devm_ioremap_resource() allocates memory, and if that memory
> allocation fails, it returns -ENOMEM. If the resource does not exist,
> it also returns -ENOMEM. So you cannot tell these two error conditions
> apart. Most of the other get_foo() calls return -ENODEV if the
> gpio/regulator/clock does not exist, so you can tell if you are out of
> memory. But ioremap is specifically about memory so -ENOMEM actually
> makes sense.
>
> If you are out of memory, it seems likely the problem is not going to
> go away quickly, so the next allocation will also fail, and hopefully
> the error handling will then work. So i don't think it is major
> issue. So yes, go with the code above.
>

Hi, Andrew

My new patchset is ready, but I just found out that another patch has been
applied to netdev/net.git. Can I solve the problem in present way? And I
will add devm_ioremap_resource_optional() helper later to optimize related
drivers. How about this?

Thanks.

