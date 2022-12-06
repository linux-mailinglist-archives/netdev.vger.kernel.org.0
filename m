Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8B644277
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiLFLuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiLFLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:50:18 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F76D27FC5
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:50:17 -0800 (PST)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRJXw3Rt9zJp6d;
        Tue,  6 Dec 2022 19:46:40 +0800 (CST)
Received: from [10.174.179.163] (10.174.179.163) by
 kwepemi500024.china.huawei.com (7.221.188.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 19:49:37 +0800
Message-ID: <dc48342f-7a01-13e3-18c3-7c7a9f1ec41b@huawei.com>
Date:   Tue, 6 Dec 2022 19:49:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, <hkallweit1@gmail.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <linux@armlinux.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
CC:     <liwei391@huawei.com>, <netdev@vger.kernel.org>
References: <20221203073441.3885317-1-zengheng4@huawei.com>
 <a1df3cb4676ce4f51680b9ead3dcf01d561eed99.camel@redhat.com>
From:   Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <a1df3cb4676ce4f51680b9ead3dcf01d561eed99.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.163]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500024.china.huawei.com (7.221.188.100)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/6 19:34, Paolo Abeni wrote:
> Hello,
> On Sat, 2022-12-03 at 15:34 +0800, Zeng Heng wrote:
>> There is warning report about of_node refcount leak
>> while probing mdio device:
>>
>> OF: ERROR: memory leak, expected refcount 1 instead of 2,
>> of_node_get()/of_node_put() unbalanced - destroy cset entry:
>> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
>>
>> In of_mdiobus_register_device(), we increase fwnode refcount
>> by fwnode_handle_get() before associating the of_node with
>> mdio device, but it has never been decreased in normal path.
>> Since that, in mdio_device_release(), it needs to call
>> fwnode_handle_put() in addition instead of calling kfree()
>> directly.
>>
>> After above, just calling mdio_device_free() in the error handle
>> path of of_mdiobus_register_device() is enough to keep the
>> refcount balanced.
>>
>> Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
>> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
>> Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   changes in v2:
>>    - Add operation about setting device node as NULL-pointer.
>>      There is no practical changes.
>>    - Add reviewed-by tag.
>> ---
>>   drivers/net/mdio/of_mdio.c    | 3 ++-
>>   drivers/net/phy/mdio_device.c | 2 ++
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
>> index 796e9c7857d0..510822d6d0d9 100644
>> --- a/drivers/net/mdio/of_mdio.c
>> +++ b/drivers/net/mdio/of_mdio.c
>> @@ -68,8 +68,9 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
>>   	/* All data is now stored in the mdiodev struct; register it. */
>>   	rc = mdio_device_register(mdiodev);
>>   	if (rc) {
>> +		device_set_node(&mdiodev->dev, NULL);
>> +		fwnode_handle_put(fwnode);
>>   		mdio_device_free(mdiodev);
>> -		of_node_put(child);
>>   		return rc;
>>   	}
>>   
>> diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
>> index 250742ffdfd9..044828d081d2 100644
>> --- a/drivers/net/phy/mdio_device.c
>> +++ b/drivers/net/phy/mdio_device.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/string.h>
>>   #include <linux/unistd.h>
>> +#include <linux/property.h>
>>   
>>   void mdio_device_free(struct mdio_device *mdiodev)
>>   {
>> @@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
>>   
>>   static void mdio_device_release(struct device *dev)
>>   {
>> +	fwnode_handle_put(dev->fwnode);
>>   	kfree(to_mdio_device(dev));
>>   }
>>
> The patch LGTM, but I'll wait a bit more just in case Andrew want to
> comment on it.
>
> Cheers,
>
> Paolo
+CC Yang Yingliang <yangyingliang@huawei.com>
