Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B07455256
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242347AbhKRBt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:49:28 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14951 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbhKRBt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:49:27 -0500
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HvjJJ55DHzZd6c;
        Thu, 18 Nov 2021 09:44:00 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 18 Nov 2021 09:46:24 +0800
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
To:     Petr Machata <petrm@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6i3t2zg.fsf@nvidia.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
Date:   Thu, 18 Nov 2021 09:46:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87a6i3t2zg.fsf@nvidia.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> On Mon, 15 Nov 2021 18:04:42 +0100 Petr Machata wrote:
>>> Ziyang Xuan <william.xuanziyang@huawei.com> writes:
>>>
>>>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
>>>> index 55275ef9a31a..a3a0a5e994f5 100644
>>>> --- a/net/8021q/vlan.c
>>>> +++ b/net/8021q/vlan.c
>>>> @@ -123,9 +123,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
>>>>  	}
>>>>  
>>>>  	vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
>>>> -
>>>> -	/* Get rid of the vlan's reference to real_dev */
>>>> -	dev_put(real_dev);
>>>>  }
>>>>  
>>>>  int vlan_check_real_dev(struct net_device *real_dev,
>>>> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
>>>> index 0c21d1fec852..aeeb5f90417b 100644
>>>> --- a/net/8021q/vlan_dev.c
>>>> +++ b/net/8021q/vlan_dev.c
>>>> @@ -843,6 +843,9 @@ static void vlan_dev_free(struct net_device *dev)
>>>>  
>>>>  	free_percpu(vlan->vlan_pcpu_stats);
>>>>  	vlan->vlan_pcpu_stats = NULL;
>>>> +
>>>> +	/* Get rid of the vlan's reference to real_dev */
>>>> +	dev_put(vlan->real_dev);
>>>>  }
>>>>  
>>>>  void vlan_setup(struct net_device *dev)  
>>>
>>> This is causing reference counting issues when vetoing is involved.
>>> Consider the following snippet:
>>>
>>>     ip link add name bond1 type bond mode 802.3ad
>>>     ip link set dev swp1 master bond1
>>>     ip link add name bond1.100 link bond1 type vlan protocol 802.1ad id 100
>>>     # ^ vetoed, no netdevice created
>>>     ip link del dev bond1
>>>
>>> The setup process goes like this: vlan_newlink() calls
>>> register_vlan_dev() calls netdev_upper_dev_link() calls
>>> __netdev_upper_dev_link(), which issues a notifier
>>> NETDEV_PRECHANGEUPPER, which yields a non-zero error,
>>> because a listener vetoed it.
>>>
>>> So it unwinds, skipping dev_hold(real_dev), but eventually the VLAN ends
>>> up decreasing reference count of the real_dev. Then when when the bond
>>> netdevice is removed, we get an endless loop of:
>>>
>>>     kernel:unregister_netdevice: waiting for bond1 to become free. Usage count = 0 
>>>
>>> Moving the dev_hold(real_dev) to always happen even if the
>>> netdev_upper_dev_link() call makes the issue go away.
>>
>> I think we should move the dev_hold() to ndo_init(), otherwise 
>> it's hard to reason if destructor was invoked or not if
>> register_netdevice() errors out.
> 
> Ziyang Xuan, do you intend to take care of this?
> .

I am reading the related processes according to the problem scenario.
And I will give a more clear sequence and root cause as soon as possible
by some necessary tests.

Thank you!
