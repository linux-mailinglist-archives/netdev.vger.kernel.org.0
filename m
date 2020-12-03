Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF5C2CCB63
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgLCBEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgLCBEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:04:41 -0500
Date:   Wed, 2 Dec 2020 17:03:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606957440;
        bh=e27nxQB6v2bR4jfkrSYiga7jg2DKJygkFb9Kd8AZ4A8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZBnOAi9moSb5Q48aM5+oabBxGmMJk1G6PX/ufjfMOskIVpIF7i7XT6c6ZVFfc9IM+
         /DhBdmUOnwVWskBIbnP+UMgOimZ7VchF6mgvTlZ8W0l8CfvdiBkpB/m/3dQhLv82KJ
         w2GNUw0On5aoTaoP+0KrnwLE0+cyrBmejs6jbnt5QVLqMNGevgfoujRuv7H+O7euBz
         MTyFGy8PL1RIc5FQMaf3ghHmHDvFT+7BUSEKbvKi6vsY+NA4f7mB2aEdZlArGZfTsl
         uw4c8mVvmT05e0CYutlnGtZIwsfEsJ+q7RfYrEWrgTKBPlKmdcUnNqa0jBuSCE4Ae2
         Q5z+lF3Ph5RSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <roopa@nvidia.com>, <nikolay@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: bridge: Fix a warning when del bridge sysfs
Message-ID: <20201202170359.19330bda@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201140114.67455-1-wanghai38@huawei.com>
References: <20201201140114.67455-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 22:01:14 +0800 Wang Hai wrote:
> If adding bridge sysfs fails, br->ifobj will be NULL, there is no
> need to delete its non-existent sysfs when deleting the bridge device,
> otherwise, it will cause a warning. So, when br->ifobj == NULL,
> directly return can fix this bug.
> 
> br_sysfs_addbr: can't create group bridge4/bridge
> ------------[ cut here ]------------
> sysfs group 'bridge' not found for kobject 'bridge4'
> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
> Modules linked in: iptable_nat
> ...
> Call Trace:
>   br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
>   br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
>   br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
>   __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
>   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
>   rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
>   netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
>   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>   netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
>   netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
>   sock_sendmsg_nosec net/socket.c:651 [inline]
>   sock_sendmsg+0x139/0x170 net/socket.c:671
>   ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
>   ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
>   __sys_sendmsg+0xd3/0x190 net/socket.c:2440
>   do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Nik, is this the way you want to handle this?

Should the notifier not fail if sysfs files cannot be created?
Currently br_sysfs_addbr() returns an int but the only caller 
ignores it.

> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 7db06e3f642a..1e9cbf31d904 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -991,6 +991,9 @@ void br_sysfs_delbr(struct net_device *dev)
>  	struct kobject *kobj = &dev->dev.kobj;
>  	struct net_bridge *br = netdev_priv(dev);
>  
> +	if (!br->ifobj)
> +		return;
> +
>  	kobject_put(br->ifobj);
>  	sysfs_remove_bin_file(kobj, &bridge_forward);
>  	sysfs_remove_group(kobj, &bridge_group);

