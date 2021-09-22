Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA0041461E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhIVK1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:27:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55435 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229651AbhIVK1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:27:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 719BD5C009C;
        Wed, 22 Sep 2021 06:26:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Sep 2021 06:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZqL05DzhAo8e0+vl6
        2ZDDSJDGZl2VPAts3xSPMZDdU0=; b=S6YuflkhkfmR1A8O/8TDNyVhPUE67AKSz
        8SneRl0ZIPzCBgfx8uc8M9ZwsVoRMrfWjyYVh07jqQBi3pYaDxlcCeUnrsb30dHb
        gvd44VZUkC6gRbDklEGOmvqf4fvG/Yiq9gGBW6JhqfOVOJkxyuc82rb2/kBhRtTV
        7snkkOOkR2DXXrvUw4CBHPMkytguvXXgAZJ4RJ9/ZQ6U7DffdVetr1TSlRszPyqy
        8qxKz8GaCUUHEQrjtuh9zIOz6CXWEcBqTS09Y5vh3/iL2N603Ejs+uHOZSM3/8jW
        OPUryUuHq+ZgMz8JRx5VJmqnK3ORdexJ7yK/JNbGTkq/WvepTfOlQ==
X-ME-Sender: <xms:vQRLYZWJ747h57gafusnZmmBbxhi6TLBlhcpzRGRk8Mxc9OXBJVl3Q>
    <xme:vQRLYZmO62Rak9riaYb8pjGaWss16IJu7fqn9xOS0vOe_P83fhEka7-Vgg9AkuoQP
    Wqqwv1NZccVo_I>
X-ME-Received: <xmr:vQRLYVaF1bTkpAmExZ0H6mM6BYdI-rXvw8i4NbHZHwBCgl1E6DqItkNvBUHek3J0CLJ2KkxjvB8uKgYRE7E2P6r5hhR4rmwyCU2Zs_zHOvWNYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeijedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vQRLYcV14JhrRgZHybDnpR2vEZtE-atWm6uWlavIhSjc2iI4mQhWwg>
    <xmx:vQRLYTnnQGX6QuXvQ1SvhIA2fhZnymIrqGKEho1vZLKSOfOfE4C8rQ>
    <xmx:vQRLYZdF0oPZ1jvnx-MBJHrMQ9Ag7YleqvK99NqsuAd2E-rT1f3XpA>
    <xmx:vgRLYRZ-1gy1g6XORXSBtHf2bc0mcHWy2o0oNM1Fc8ITrsWd6PzzJg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 06:26:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, petrm@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] nexthop: Fix memory leaks in nexthop notification chain listeners
Date:   Wed, 22 Sep 2021 13:25:40 +0300
Message-Id: <20210922102540.808211-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

syzkaller discovered memory leaks [1] that can be reduced to the
following commands:

 # ip nexthop add id 1 blackhole
 # devlink dev reload pci/0000:06:00.0

As part of the reload flow, mlxsw will unregister its netdevs and then
unregister from the nexthop notification chain. Before unregistering
from the notification chain, mlxsw will receive delete notifications for
nexthop objects using netdevs registered by mlxsw or their uppers. mlxsw
will not receive notifications for nexthops using netdevs that are not
dismantled as part of the reload flow. For example, the blackhole
nexthop above that internally uses the loopback netdev as its nexthop
device.

One way to fix this problem is to have listeners flush their nexthop
tables after unregistering from the notification chain. This is
error-prone as evident by this patch and also not symmetric with the
registration path where a listener receives a dump of all the existing
nexthops.

Therefore, fix this problem by replaying delete notifications for the
listener being unregistered. This is symmetric to the registration path
and also consistent with the netdev notification chain.

The above means that unregister_nexthop_notifier(), like
register_nexthop_notifier(), will have to take RTNL in order to iterate
over the existing nexthops and that any callers of the function cannot
hold RTNL. This is true for mlxsw and netdevsim, but not for the VXLAN
driver. To avoid a deadlock, change the latter to unregister its nexthop
listener without holding RTNL, making it symmetric to the registration
path.

[1]
unreferenced object 0xffff88806173d600 (size 512):
  comm "syz-executor.0", pid 1290, jiffies 4295583142 (age 143.507s)
  hex dump (first 32 bytes):
    41 9d 1e 60 80 88 ff ff 08 d6 73 61 80 88 ff ff  A..`......sa....
    08 d6 73 61 80 88 ff ff 01 00 00 00 00 00 00 00  ..sa............
  backtrace:
    [<ffffffff81a6b576>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<ffffffff81a6b576>] slab_post_alloc_hook+0x96/0x490 mm/slab.h:522
    [<ffffffff81a716d3>] slab_alloc_node mm/slub.c:3206 [inline]
    [<ffffffff81a716d3>] slab_alloc mm/slub.c:3214 [inline]
    [<ffffffff81a716d3>] kmem_cache_alloc_trace+0x163/0x370 mm/slub.c:3231
    [<ffffffff82e8681a>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff82e8681a>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff82e8681a>] mlxsw_sp_nexthop_obj_group_create drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:4918 [inline]
    [<ffffffff82e8681a>] mlxsw_sp_nexthop_obj_new drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:5054 [inline]
    [<ffffffff82e8681a>] mlxsw_sp_nexthop_obj_event+0x59a/0x2910 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:5239
    [<ffffffff813ef67d>] notifier_call_chain+0xbd/0x210 kernel/notifier.c:83
    [<ffffffff813f0662>] blocking_notifier_call_chain kernel/notifier.c:318 [inline]
    [<ffffffff813f0662>] blocking_notifier_call_chain+0x72/0xa0 kernel/notifier.c:306
    [<ffffffff8384b9c6>] call_nexthop_notifiers+0x156/0x310 net/ipv4/nexthop.c:244
    [<ffffffff83852bd8>] insert_nexthop net/ipv4/nexthop.c:2336 [inline]
    [<ffffffff83852bd8>] nexthop_add net/ipv4/nexthop.c:2644 [inline]
    [<ffffffff83852bd8>] rtm_new_nexthop+0x14e8/0x4d10 net/ipv4/nexthop.c:2913
    [<ffffffff833e9a78>] rtnetlink_rcv_msg+0x448/0xbf0 net/core/rtnetlink.c:5572
    [<ffffffff83608703>] netlink_rcv_skb+0x173/0x480 net/netlink/af_netlink.c:2504
    [<ffffffff833de032>] rtnetlink_rcv+0x22/0x30 net/core/rtnetlink.c:5590
    [<ffffffff836069de>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
    [<ffffffff836069de>] netlink_unicast+0x5ae/0x7f0 net/netlink/af_netlink.c:1340
    [<ffffffff83607501>] netlink_sendmsg+0x8e1/0xe30 net/netlink/af_netlink.c:1929
    [<ffffffff832fde84>] sock_sendmsg_nosec net/socket.c:704 [inline]
    [<ffffffff832fde84>] sock_sendmsg net/socket.c:724 [inline]
    [<ffffffff832fde84>] ____sys_sendmsg+0x874/0x9f0 net/socket.c:2409
    [<ffffffff83304a44>] ___sys_sendmsg+0x104/0x170 net/socket.c:2463
    [<ffffffff83304c01>] __sys_sendmsg+0x111/0x1f0 net/socket.c:2492
    [<ffffffff83304d5d>] __do_sys_sendmsg net/socket.c:2501 [inline]
    [<ffffffff83304d5d>] __se_sys_sendmsg net/socket.c:2499 [inline]
    [<ffffffff83304d5d>] __x64_sys_sendmsg+0x7d/0xc0 net/socket.c:2499

Fixes: 2a014b200bbd ("mlxsw: spectrum_router: Add support for nexthop objects")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/vxlan.c |  2 +-
 net/ipv4/nexthop.c  | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5a8df5a195cb..141635a35c28 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4756,12 +4756,12 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 	LIST_HEAD(list);
 	unsigned int h;
 
-	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list) {
 		struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 
 		unregister_nexthop_notifier(net, &vn->nexthop_notifier_block);
 	}
+	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list)
 		vxlan_destroy_tunnels(net, &list);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0e75fd3e57b4..9e8100728d46 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3567,6 +3567,7 @@ static struct notifier_block nh_netdev_notifier = {
 };
 
 static int nexthops_dump(struct net *net, struct notifier_block *nb,
+			 enum nexthop_event_type event_type,
 			 struct netlink_ext_ack *extack)
 {
 	struct rb_root *root = &net->nexthop.rb_root;
@@ -3577,8 +3578,7 @@ static int nexthops_dump(struct net *net, struct notifier_block *nb,
 		struct nexthop *nh;
 
 		nh = rb_entry(node, struct nexthop, rb_node);
-		err = call_nexthop_notifier(nb, net, NEXTHOP_EVENT_REPLACE, nh,
-					    extack);
+		err = call_nexthop_notifier(nb, net, event_type, nh, extack);
 		if (err)
 			break;
 	}
@@ -3592,7 +3592,7 @@ int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
 	int err;
 
 	rtnl_lock();
-	err = nexthops_dump(net, nb, extack);
+	err = nexthops_dump(net, nb, NEXTHOP_EVENT_REPLACE, extack);
 	if (err)
 		goto unlock;
 	err = blocking_notifier_chain_register(&net->nexthop.notifier_chain,
@@ -3605,8 +3605,17 @@ EXPORT_SYMBOL(register_nexthop_notifier);
 
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
 {
-	return blocking_notifier_chain_unregister(&net->nexthop.notifier_chain,
-						  nb);
+	int err;
+
+	rtnl_lock();
+	err = blocking_notifier_chain_unregister(&net->nexthop.notifier_chain,
+						 nb);
+	if (err)
+		goto unlock;
+	nexthops_dump(net, nb, NEXTHOP_EVENT_DEL, NULL);
+unlock:
+	rtnl_unlock();
+	return err;
 }
 EXPORT_SYMBOL(unregister_nexthop_notifier);
 
-- 
2.31.1

