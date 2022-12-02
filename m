Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2500F63FDB7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 02:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLBBiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 20:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLBBiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 20:38:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AE98FD4B
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 17:38:11 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNbCp6DJlzRnsM;
        Fri,  2 Dec 2022 09:37:26 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 09:38:09 +0800
Subject: Re: [PATCH net v2] net: mdiobus: fix double put fwnode in the error
 path
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ioana.ciornei@nxp.com>, <calvin.johnson@oss.nxp.com>,
        <grant.likely@arm.com>, <zengheng4@huawei.com>
References: <20221201033838.1938765-1-yangyingliang@huawei.com>
 <Y4jJQ3iKkico/xFX@lunn.ch>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <0d8d05e1-5145-e208-920f-858a86833ee0@huawei.com>
Date:   Fri, 2 Dec 2022 09:38:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y4jJQ3iKkico/xFX@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/1 23:33, Andrew Lunn wrote:
> On Thu, Dec 01, 2022 at 11:38:38AM +0800, Yang Yingliang wrote:
>> If phy_device_register() or fwnode_mdiobus_phy_device_register()
>> fail, phy_device_free() is called, the device refcount is decreased
>> to 0, then fwnode_handle_put() will be called in phy_device_release(),
>> but in the error path, fwnode_handle_put() has already been called,
>> so set fwnode to NULL after fwnode_handle_put() in the error path to
>> avoid double put.
>>
>> Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
>> Reported-by: Zeng Heng <zengheng4@huawei.com>
>> Tested-by: Zeng Heng <zengheng4@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>> v1 -> v2:
>>    Don't remove fwnode_handle_put() in the error path,
>>    set fwnode to NULL avoid double put.
>> ---
>>   drivers/net/mdio/fwnode_mdio.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
>> index eb344f6d4a7b..9df618577712 100644
>> --- a/drivers/net/mdio/fwnode_mdio.c
>> +++ b/drivers/net/mdio/fwnode_mdio.c
>> @@ -99,6 +99,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>>   	rc = phy_device_register(phy);
>>   	if (rc) {
>>   		fwnode_handle_put(child);
>> +		device_set_node(&phy->mdio.dev, NULL);
>>   		return rc;
>>   	}
> This looks better, it is balanced. But i would argue the order is
> wrong.
>
> 	fwnode_handle_get(child);
> 	device_set_node(&phy->mdio.dev, child);
>
> 	/* All data is now stored in the phy struct;
> 	 * register it
> 	 */
> 	rc = phy_device_register(phy);
> 	if (rc) {
> 		fwnode_handle_put(child);
> 		return rc;
> 	}
>
> In general you undo stuff in the opposite order to which you did
> it. So device_set_node() first, then fwnode_handle_put(). Otherwise
> you have a potential race condition.
OK, I will change the order in v3.

Thanks,
Yang
>
>      Andrew
> .
