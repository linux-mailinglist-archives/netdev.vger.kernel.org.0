Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7555945E425
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351845AbhKZBxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:53:40 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31907 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351657AbhKZBvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 20:51:39 -0500
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J0d1f5YV3zcbLh;
        Fri, 26 Nov 2021 09:48:22 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 26 Nov 2021 09:48:25 +0800
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
To:     Petr Machata <petrm@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6i3t2zg.fsf@nvidia.com> <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
 <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c240e0e0-256c-698b-4a98-47490869faa3@huawei.com> <8735nstq62.fsf@nvidia.com>
 <daae2fe3-997c-a390-afae-15ff33ba3d1c@huawei.com> <87k0gzrqw8.fsf@nvidia.com>
 <87v90gqxl4.fsf@nvidia.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <7d45a6bc-e900-e80e-917a-031bdd77bc69@huawei.com>
Date:   Fri, 26 Nov 2021 09:48:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87v90gqxl4.fsf@nvidia.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Petr Machata <petrm@nvidia.com> writes:
> 
>> Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:
>>
>>>>
>>>> Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:
>>>>
>>>>> I need some time to test my some ideas. And anyone has good ideas, please
>>>>> do not be stingy.
>>>>
>>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>>
>>>>> I think we should move the dev_hold() to ndo_init(), otherwise it's
>>>>> hard to reason if destructor was invoked or not if
>>>>> register_netdevice() errors out.
>>>>
>>>> That makes sense to me. We always put real_dev in the destructor, so we
>>>> should always hold it in the constructor...
>>>
>>> Inject error before dev_hold(real_dev) in register_vlan_dev(), and execute
>>> the following testcase:
>>>
>>> ip link add dev dummy1 type dummy
>>> ip link add name dummy1.100 link dummy1 type vlan id 100 // failed for error injection
>>> ip link del dev dummy1
>>>
>>> Make the problem repro. The problem is solved using the following fix
>>> according to the Jakub's suggestion:
>>>
>>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
>>> index a3a0a5e994f5..abaa5d96ded2 100644
>>> --- a/net/8021q/vlan.c
>>> +++ b/net/8021q/vlan.c
>>> @@ -184,9 +184,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
>>>         if (err)
>>>                 goto out_unregister_netdev;
>>>
>>> -       /* Account for reference in struct vlan_dev_priv */
>>> -       dev_hold(real_dev);
>>> -
>>>         vlan_stacked_transfer_operstate(real_dev, dev, vlan);
>>>         linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
>>>
>>> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
>>> index ab6dee28536d..a54535cbcf4c 100644
>>> --- a/net/8021q/vlan_dev.c
>>> +++ b/net/8021q/vlan_dev.c
>>> @@ -615,6 +615,9 @@ static int vlan_dev_init(struct net_device *dev)
>>>         if (!vlan->vlan_pcpu_stats)
>>>                 return -ENOMEM;
>>>
>>> +       /* Get vlan's reference to real_dev */
>>> +       dev_hold(real_dev);
>>>
>>>
>>> If there is not any other idea and objection, I will send the fix patch later.
>>>
>>> Thank you!
>>
>> This fixes the issue in my repro, and does not seems to break anything.
>> We'll take it to full regression overnight, I'll report back tomorrow
>> about the result.
> 
> Sorry, was AFK yesterday. It does look good.
> .

Thank you for your efforts very much! I have sent the fix patch.
