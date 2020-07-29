Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A2F231B54
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgG2Ih3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:37:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47141 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbgG2Ih3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:37:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A2525C00D2;
        Wed, 29 Jul 2020 04:37:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 04:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rcHvGqoRvxGA+qowQ
        3CrsYywfdh4/2qvnuoqaWX+Ltc=; b=d9utg2+/oOZSrybgeXXTEXAubLYeRz6KF
        gXPS7ngjEKmhm0LBa/LBdrNl7R6KJqYAm/9kvv7KDKDuYLjZQZVMQ0EXTqiASrWd
        ov9VUcQm6PfSPm1ofVupGNtTCxAJ7hQyUhIgt0h2azbktMX8Y6HhCujeoN5IU9ni
        IC58yHVS/1KSwZYQEX/xtBEHrroG1AfTbFRsmqfWofN5Ylgev9hwbfHbtyHrmgoL
        fP2pHasTJ+JryUnFItZugyedpJhu++bnHdUd6E3ZObvjDsUNI1QaaqzuRmVoX5AY
        cQMbY9gNtt5tMq7cwoBDC2VTAmBg2MKur4hDvmkUuaLtiSyphi+6Q==
X-ME-Sender: <xms:RzUhX6g4wOp5SnF4AhsXTse_ImlQWvxYihH-zjHdQZTRj--nrDhv0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieehrddufeejrddvhedtnecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RzUhX7ArldmYbHseUDLJ2F7VAORigxunZuTPPY1GwDMoWP8JRfVPGw>
    <xmx:RzUhXyESZIebAPNZKzrrJLH34nqr7ioK1c8urtbk2ZC9iORzkM5tTg>
    <xmx:RzUhXzTKNCcTVA-Z_JPaIHtycJ6nRasfJDFT9lZTo67w-xMnHYUTEA>
    <xmx:SDUhXy81W4GRBm4salS0VXqfTNmVrdaw_33T-kBxpnRNGcq8fr4ZXQ>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF4C030600B4;
        Wed, 29 Jul 2020 04:37:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.h.duyck@intel.com,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] ipv4: Silence suspicious RCU usage warning
Date:   Wed, 29 Jul 2020 11:37:13 +0300
Message-Id: <20200729083713.2051435-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

fib_trie_unmerge() is called with RTNL held, but not from an RCU
read-side critical section. This leads to the following warning [1] when
the FIB alias list in a leaf is traversed with
hlist_for_each_entry_rcu().

Since the function is always called with RTNL held and since
modification of the list is protected by RTNL, simply use
hlist_for_each_entry() and silence the warning.

[1]
WARNING: suspicious RCU usage
5.8.0-rc4-custom-01520-gc1f937f3f83b #30 Not tainted
-----------------------------
net/ipv4/fib_trie.c:1867 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/164:
 #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0

stack backtrace:
CPU: 0 PID: 164 Comm: ip Not tainted 5.8.0-rc4-custom-01520-gc1f937f3f83b #30
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
Call Trace:
 dump_stack+0x100/0x184
 lockdep_rcu_suspicious+0x153/0x15d
 fib_trie_unmerge+0x608/0xdb0
 fib_unmerge+0x44/0x360
 fib4_rule_configure+0xc8/0xad0
 fib_nl_newrule+0x37a/0x1dd0
 rtnetlink_rcv_msg+0x4f7/0xbd0
 netlink_rcv_skb+0x17a/0x480
 rtnetlink_rcv+0x22/0x30
 netlink_unicast+0x5ae/0x890
 netlink_sendmsg+0x98a/0xf40
 ____sys_sendmsg+0x879/0xa00
 ___sys_sendmsg+0x122/0x190
 __sys_sendmsg+0x103/0x1d0
 __x64_sys_sendmsg+0x7d/0xb0
 do_syscall_64+0x54/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc80a234e97
Code: Bad RIP value.
RSP: 002b:00007ffef8b66798 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc80a234e97
RDX: 0000000000000000 RSI: 00007ffef8b66800 RDI: 0000000000000003
RBP: 000000005f141b1c R08: 0000000000000001 R09: 0000000000000000
R10: 00007fc80a2a8ac0 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007ffef8b67008 R15: 0000556fccb10020

Fixes: 0ddcf43d5d4a ("ipv4: FIB Local/MAIN table collapse")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv4/fib_trie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 248f1c1959a6..3c65f71d0e82 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1864,7 +1864,7 @@ struct fib_table *fib_trie_unmerge(struct fib_table *oldtb)
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
 		struct key_vector *local_l = NULL, *local_tp;
 
-		hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
+		hlist_for_each_entry(fa, &l->leaf, fa_list) {
 			struct fib_alias *new_fa;
 
 			if (local_tb->tb_id != fa->tb_id)
-- 
2.26.2

