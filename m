Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E314262D57B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiKQIu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239566AbiKQIux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:50:53 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41548BC6;
        Thu, 17 Nov 2022 00:50:49 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCYXL3R0tzRpFK;
        Thu, 17 Nov 2022 16:50:26 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 16:50:47 +0800
Received: from [10.67.109.54] (10.67.109.54) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 16:50:46 +0800
Subject: Re: [PATCH] net: mdio-ipq4019: fix possible invalid pointer
 dereference
To:     Andrew Lunn <andrew@lunn.ch>
References: <20221115045028.182441-1-tanghui20@huawei.com>
 <Y3OV4og418SxPF7+@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <d31663c5-8ac1-f424-b0ad-737e86b4595b@huawei.com>
Date:   Thu, 17 Nov 2022 16:50:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y3OV4og418SxPF7+@lunn.ch>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.54]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/11/15 21:36, Andrew Lunn wrote:
> On Tue, Nov 15, 2022 at 12:50:28PM +0800, Hui Tang wrote:
>> priv->eth_ldo_rdy is saved the return value of devm_ioremap_resource(),
>> which !IS_ERR() should be used to check.
>>
>> Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>> ---
>>  drivers/net/mdio/mdio-ipq4019.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
>> index 4eba5a91075c..d7a1f7c56f97 100644
>> --- a/drivers/net/mdio/mdio-ipq4019.c
>> +++ b/drivers/net/mdio/mdio-ipq4019.c
>> @@ -188,7 +188,7 @@ static int ipq_mdio_reset(struct mii_bus *bus)
>>  	/* To indicate CMN_PLL that ethernet_ldo has been ready if platform resource 1
>>  	 * is specified in the device tree.
>>  	 */
>> -	if (priv->eth_ldo_rdy) {
>> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
>>  		val = readl(priv->eth_ldo_rdy);
>>  		val |= BIT(0);
>>  		writel(val, priv->eth_ldo_rdy);
>
> There is a general pattern in the kernel that optional things are set
> to NULL if the resource does not exist. Often there is a
> get_foo_optional() which will return a NULL point if the things does
> not exist, the thing if it does exist, or an error code if a real
> error happened.
>
> So please follow this patterns. Check the return value in
> ipq4019_mdio_probe(). Looking at __devm_ioremap_resource() i _think_
> it returns -ENOMEM if the resource does not exist? So maybe any other
> error is a real error, and should be reported, and -ENOMEM should
> result in eth_ldo_rdy set to NULL?

Thanks, I will resend it according to the style you said.
