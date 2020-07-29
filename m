Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB969231B46
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgG2Iey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:34:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48185 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgG2Iey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:34:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A8EF85C017C;
        Wed, 29 Jul 2020 04:34:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 04:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eKnQxsyvbgY3QZ47Z
        WjR3srT5DsQTZGMdLwnvRy6+SM=; b=CmW0aJQCxNMR99KR9TXd+j9Z+moxuxsX4
        waBLacIaiVbM00qo0S9FK+lLZFWCX79L4drVKFafZ/QZffpFgqC/lY/6G+Fcodl4
        NIkkD1IGsV06SQOhT8aijftGCUWo/F/XnNL6t0GME1LXsjeUGwmnXVLT7RL4daO9
        5A3XMsFCePnQcme3lbyjzlWyygrduhcU7kjp91BxHX/lJtdkxfcSLXIVXTNlW5hY
        dw2EWtBjbnDKiGQCaR8DRva34LrO/5/FRIszC0vRUyx4R/8vMEIj4tRDrGH2U9bO
        5g1ay/swelhNdpvQQxlB/Bx3y0C2aIPpTi5+d238IrZEpliMs3M6w==
X-ME-Sender: <xms:rTQhX-Vi3K6wjbPLv2fIhSTG7M88OIQpplLYK1vMPiQK9fmAuCxRQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieehrddufeejrddvhedtnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rTQhX6n1wX2ScrHtQFnqlRiOyx0Xo6E2GNUrHgvbOxYZVKKBc9vFVg>
    <xmx:rTQhXybHd8u0aM241URgWbXCJ3m6aYT5oH3oiowGDnr1VQciB5ilvQ>
    <xmx:rTQhX1Vb1w7I7hgDRMgcvmeNhgwhq_uwJBVDeWK6HUicXAEIpbO9aA>
    <xmx:rTQhX9zaaII0UN2vVUwT1fKJxHkV2BpMBMIS1EVgg36EIbirwI1Wyg>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB15C3060067;
        Wed, 29 Jul 2020 04:34:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] vxlan: Ensure FDB dump is performed under RCU
Date:   Wed, 29 Jul 2020 11:34:36 +0300
Message-Id: <20200729083436.2050768-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The commit cited below removed the RCU read-side critical section from
rtnl_fdb_dump() which means that the ndo_fdb_dump() callback is invoked
without RCU protection.

This results in the following warning [1] in the VXLAN driver, which
relied on the callback being invoked from an RCU read-side critical
section.

Fix this by calling rcu_read_lock() in the VXLAN driver, as already done
in the bridge driver.

[1]
WARNING: suspicious RCU usage
5.8.0-rc4-custom-01521-g481007553ce6 #29 Not tainted
-----------------------------
drivers/net/vxlan.c:1379 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by bridge/166:
 #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: netlink_dump+0xea/0x1090

stack backtrace:
CPU: 1 PID: 166 Comm: bridge Not tainted 5.8.0-rc4-custom-01521-g481007553ce6 #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
Call Trace:
 dump_stack+0x100/0x184
 lockdep_rcu_suspicious+0x153/0x15d
 vxlan_fdb_dump+0x51e/0x6d0
 rtnl_fdb_dump+0x4dc/0xad0
 netlink_dump+0x540/0x1090
 __netlink_dump_start+0x695/0x950
 rtnetlink_rcv_msg+0x802/0xbd0
 netlink_rcv_skb+0x17a/0x480
 rtnetlink_rcv+0x22/0x30
 netlink_unicast+0x5ae/0x890
 netlink_sendmsg+0x98a/0xf40
 __sys_sendto+0x279/0x3b0
 __x64_sys_sendto+0xe6/0x1a0
 do_syscall_64+0x54/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fe14fa2ade0
Code: Bad RIP value.
RSP: 002b:00007fff75bb5b88 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00005614b1ba0020 RCX: 00007fe14fa2ade0
RDX: 000000000000011c RSI: 00007fff75bb5b90 RDI: 0000000000000003
RBP: 00007fff75bb5b90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00005614b1b89160
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Fixes: 5e6d24358799 ("bridge: netlink dump interface at par with brctl")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/vxlan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 89d85dcb200e..5efe1e28f270 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1376,6 +1376,7 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		struct vxlan_fdb *f;
 
+		rcu_read_lock();
 		hlist_for_each_entry_rcu(f, &vxlan->fdb_head[h], hlist) {
 			struct vxlan_rdst *rd;
 
@@ -1387,8 +1388,10 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 						     cb->nlh->nlmsg_seq,
 						     RTM_NEWNEIGH,
 						     NLM_F_MULTI, NULL);
-				if (err < 0)
+				if (err < 0) {
+					rcu_read_unlock();
 					goto out;
+				}
 skip_nh:
 				*idx += 1;
 				continue;
@@ -1403,12 +1406,15 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 						     cb->nlh->nlmsg_seq,
 						     RTM_NEWNEIGH,
 						     NLM_F_MULTI, rd);
-				if (err < 0)
+				if (err < 0) {
+					rcu_read_unlock();
 					goto out;
+				}
 skip:
 				*idx += 1;
 			}
 		}
+		rcu_read_unlock();
 	}
 out:
 	return err;
-- 
2.26.2

