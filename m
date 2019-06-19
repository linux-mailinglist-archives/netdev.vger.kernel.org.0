Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB98F4C05C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFSRz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:55:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43321 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726175AbfFSRz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:55:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D59C52222B;
        Wed, 19 Jun 2019 13:55:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 13:55:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cdRwB7b2QqNpoMnvu
        MO9vhi02LRs9PcEHqazLHPo+EI=; b=mlS97UB1A8hcEL1vB8CW3ufWWroYrLGM8
        /YtDvBNtSAFzGfPOAZb+hFSQoSZt9XmGFJsYOOeNU4NH13Qrdq8pnLzrwBWozNxK
        ztvbpYmy9WuS2cnRd1aQLJFMxad/xzqKO7MYHOY3DYWWyGcienvPyAAT6EfY6fNY
        Xmp3glyTlLmFZqUaORJGbGblT2snAv8TGmMje9du25vXRSDCxmRq7Dy0Sin9qwK9
        zTsawEZBCcqmJtA936qEHNcxphlVxzCGWkFBh2qW1kX3IdjUGNVmaKujHyE+Edyr
        6AB4u6GETonNdExwYdT3lqgxkcZ2nCWJS79i6ZF0mdtA4PKdyn6IA==
X-ME-Sender: <xms:DncKXYLEFMw-FbSVlIWvAsCKuk3QMjMDoU-TwsuEu7TPWKB9KY63NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddvgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:DncKXUZ4h-AaOgGcEjeJOSxwBcDF5MR1JIMmmqrmQl7KLA7pcWJw_w>
    <xmx:DncKXSWiLQCYLH6a_SHnDSIsYkGmNr3NOFrA9uhJUJMLQ2tUE7V1Mw>
    <xmx:DncKXVt5VhaUO9vEeX5ST9fbqmCzKbG1ah8sYG3H9SVIx2Rgih2uwA>
    <xmx:DncKXZ6ZblbqQ81B0ZXippMOXxxoRGlqTvTK0cIFKDYb9gz8g_8Y4A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8ABB0380074;
        Wed, 19 Jun 2019 13:55:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] ipv6: Check if route exists before notifying it
Date:   Wed, 19 Jun 2019 20:55:00 +0300
Message-Id: <20190619175500.7145-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When user space sends invalid information in RTA_MULTIPATH, the nexthop
list in ip6_route_multipath_add() is empty and there is no route to
notify.

The code that emits the netlink notifications correctly checks if the
route is not NULL, but I missed that for the in-kernel notifications.
Add the check to avoid NULL pointer dereference [1].

[1]
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9190 Comm: syz-executor149 Not tainted 5.2.0-rc5+ #38
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
RIP: 0010:call_fib6_multipath_entry_notifiers+0xd1/0x1a0
net/ipv6/ip6_fib.c:396
Code: 8b b5 30 ff ff ff 48 c7 85 68 ff ff ff 00 00 00 00 48 c7 85 70 ff ff
ff 00 00 00 00 89 45 88 4c 89 e0 48 c1 e8 03 4c 89 65 80 <42> 80 3c 28 00
0f 85 9a 00 00 00 48 b8 00 00 00 00 00 fc ff df 4d
RSP: 0018:ffff88809788f2c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff11012f11e59 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88809788f390 R08: ffff88809788f8c0 R09: 000000000000000c
R10: ffff88809788f5d8 R11: ffff88809788f527 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff88809788f8c0 R15: ffffffff89541d80
FS:  000055555632c880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000009ba7c000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip6_route_multipath_add+0xc55/0x1490 net/ipv6/route.c:5094
  inet6_rtm_newroute+0xed/0x180 net/ipv6/route.c:5208
  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5219
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5237
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:665
  ___sys_sendmsg+0x803/0x920 net/socket.c:2286
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2324
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg net/socket.c:2331 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2331
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc09fd0028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000

Reported-by: syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com
Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv6/ip6_fib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1d16a01eccf5..241a0e9a07c3 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -393,6 +393,8 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
 		.nsiblings = nsiblings,
 	};
 
+	if (!rt)
+		return -EINVAL;
 	rt->fib6_table->fib_seq++;
 	return call_fib6_notifiers(net, event_type, &info.info);
 }
-- 
2.20.1

