Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3872CD81A
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgLCNoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:44:32 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9100 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbgLCNoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:44:32 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cmxqd0LtBzLxmb;
        Thu,  3 Dec 2020 21:43:09 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 21:43:38 +0800
Subject: Re: [PATCH net] net: bridge: Fix a warning when del bridge sysfs
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201201140114.67455-1-wanghai38@huawei.com>
 <20201202170359.19330bda@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <3d3c0206-c8c4-8a19-c821-2a0cbb941c6b@nvidia.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <5147798b-c1cf-ce5f-524c-4874eb854bc0@huawei.com>
Date:   Thu, 3 Dec 2020 21:43:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3d3c0206-c8c4-8a19-c821-2a0cbb941c6b@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/12/3 18:34, Nikolay Aleksandrov 写道:
> On 03/12/2020 03:03, Jakub Kicinski wrote:
>> On Tue, 1 Dec 2020 22:01:14 +0800 Wang Hai wrote:
>>> If adding bridge sysfs fails, br->ifobj will be NULL, there is no
>>> need to delete its non-existent sysfs when deleting the bridge device,
>>> otherwise, it will cause a warning. So, when br->ifobj == NULL,
>>> directly return can fix this bug.
>>>
>>> br_sysfs_addbr: can't create group bridge4/bridge
>>> ------------[ cut here ]------------
>>> sysfs group 'bridge' not found for kobject 'bridge4'
>>> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
>>> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
>>> Modules linked in: iptable_nat
>>> ...
>>> Call Trace:
>>>    br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
>>>    br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
>>>    br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
>>>    __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
>>>    rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
>>>    rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
>>>    netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
>>>    netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>>>    netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
>>>    netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
>>>    sock_sendmsg_nosec net/socket.c:651 [inline]
>>>    sock_sendmsg+0x139/0x170 net/socket.c:671
>>>    ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
>>>    ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
>>>    __sys_sendmsg+0xd3/0x190 net/socket.c:2440
>>>    do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> Nik, is this the way you want to handle this?
>>
>> Should the notifier not fail if sysfs files cannot be created?
>> Currently br_sysfs_addbr() returns an int but the only caller
>> ignores it.
>>
> Hi,
> The fix is wrong because this is not the only user of ifobj. The bridge
> port sysfs code also uses it and br_sysfs_addif() will create the new
> symlink in sysfs_root_kn due to NULL kobj passed which basically means
> only one port will be enslaved, the others will fail in creating their
> sysfs entries and thus fail to be added as ports.
>
> I'd prefer to just fail from the notifier based on the return value.
> The only catch would be to test it with br_vlan_bridge_event() which
> is called on bridge master device events, it should be fine as
> br_vlan_find() deals with NULL vlan groups but at least a comment
> above it in br.c's notifier would be good so if anyone decides to add
> any NETDEVICE_UNREGISTER handling would be warned about it.
Thanks for your advice, I will perfect my patch
> Also please add proper fixes tag, the bug seems to be since:
> bb900b27a2f4 ("bridge: allow creating bridge devices with netlink")
>
> It actually changed the behaviour, before that the return value of br_sysfs_addbr()
> was checked and the device got unregistered on failure.
>
> Thanks,
>   Nik
>
>
> .
>
