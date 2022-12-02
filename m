Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF96863FE06
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiLBCOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiLBCOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:14:51 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F2AD4ADE
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 18:14:50 -0800 (PST)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NNbyD23JQzqSM5;
        Fri,  2 Dec 2022 10:10:44 +0800 (CST)
Received: from [10.174.179.163] (10.174.179.163) by
 kwepemi500024.china.huawei.com (7.221.188.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 10:14:47 +0800
Message-ID: <d7f2266a-12c0-7369-952b-fbaa787de125@huawei.com>
Date:   Fri, 2 Dec 2022 10:14:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>
CC:     <f.fainelli@gmail.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <liwei391@huawei.com>
References: <20221201092202.3394119-1-zengheng4@huawei.com>
 <Y4jH1Z8UdA/h+WlE@lunn.ch>
From:   Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <Y4jH1Z8UdA/h+WlE@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.163]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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


On 2022/12/1 23:27, Andrew Lunn wrote:
> On Thu, Dec 01, 2022 at 05:22:02PM +0800, Zeng Heng wrote:
>> There is warning report about of_node refcount leak
>> while probing mdio device:
>>
>> OF: ERROR: memory leak, expected refcount 1 instead of 2,
>> of_node_get()/of_node_put() unbalanced - destroy cset entry:
>> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
>>
>> In of_mdiobus_register_device(), we increase fwnode refcount
>> by fwnode_handle_get() before associating the of_node with
>> mdio device, but it has never been decreased after that.
>> Since that, in mdio_device_release(), it needs to call
>> fwnode_handle_put() in addition instead of calling kfree()
>> directly.
>>
>> After above, just calling mdio_device_free() in the error handle
>> path of of_mdiobus_register_device() is enough to keep the
>> refcount balanced.
> How does this interact with:
>
> https://lore.kernel.org/netdev/20221201033838.1938765-1-yangyingliang@huawei.com/T/
>
> 	Andrew

No, they don't interact with each other, because they fix different 
issues respectively.


The patch sent by me is about eliminating refcount warning in the normal 
and error

handling route of mdio_device_register(), while the one sent by 
Yingliang (as you concern about)

is fixing refcount warning in the error handle path of 
phy_device_register().


Yingliang and I work on cleaning the warning report and enhancing the 
quality of kernel.

I am not sure, for your convenience, shall I need to send my patch to 
Yingliang and let him

edit them into a set of patches?


With best regards,

Zeng Heng

