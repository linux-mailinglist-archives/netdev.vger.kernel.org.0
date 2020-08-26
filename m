Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6073625355C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHZQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:48:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35723 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727881AbgHZQsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:48:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B4C735C010C;
        Wed, 26 Aug 2020 12:48:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=84XvK7zwQfzr9D2k6
        D6KviPpBZP3mGAbuZUi3djrvT4=; b=CVHoE4MNJSN08jOXffV0b3o4Exeb/yf/+
        FpWyamGCsriqqlVCvOyl6yiaQGwB91Mkl+jGKHNaY62FsFsjgHXJpchu4tuBagmD
        wo2Eayrjlzvx67KGqU161UH2Lvpm94paHmPpOshzYO8PPXfPa/2w4TrxzyX93Pzs
        0qanhIqYosDW8BFsf+CL97EcRPRXfPwUPaVdm8M5bmN1roUe0VLBMemBu0UoITek
        r5bh7LkzUV1HnDmZCXnvJFIQg5XEbyKljoPkLu+Vqgn3Y05NHsfhQ0uH76ISlfwm
        VcztrORwz5hoUIWhKAMywnMRQrGOya3J64AsnJQBpv9H5pCj1LYDg==
X-ME-Sender: <xms:a5JGXxTld540lEl5CrTkG7PWH-kRoVbitv1Dov1-kMtVN3ENt8T4sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrudeikeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:a5JGX6ydQv-yfR-dVcFgCcFRVSCQWEGcIZ6FGE4VnrDzY9E3edk2vw>
    <xmx:a5JGX20C9gKnFoeaHcLhZZmcbclw_ML5HOkV9Ddev-WAXhn44CVBXg>
    <xmx:a5JGX5BiTFCwTR-B3THx2azQF6M4i4rtBu1ke6-u8k5IJASFDdPyRg>
    <xmx:bJJGX-YvN5WzT_PtUWic7OX3Xc7S48B_vavqJm3CeEWkk-MmaTYXfA>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BC5C30600B2;
        Wed, 26 Aug 2020 12:48:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ipv4: Silence suspicious RCU usage warning
Date:   Wed, 26 Aug 2020 19:48:10 +0300
Message-Id: <20200826164810.1029595-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

fib_info_notify_update() is always called with RTNL held, but not from
an RCU read-side critical section. This leads to the following warning
[1] when the FIB table list is traversed with
hlist_for_each_entry_rcu(), but without a proper lockdep expression.

Since modification of the list is protected by RTNL, silence the warning
by adding a lockdep expression which verifies RTNL is held.

[1]
 =============================
 WARNING: suspicious RCU usage
 5.9.0-rc1-custom-14233-g2f26e122d62f #129 Not tainted
 -----------------------------
 net/ipv4/fib_trie.c:2124 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by ip/834:
  #0: ffffffff85a3b6b0 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0

 stack backtrace:
 CPU: 0 PID: 834 Comm: ip Not tainted 5.9.0-rc1-custom-14233-g2f26e122d62f #129
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
 Call Trace:
  dump_stack+0x100/0x184
  lockdep_rcu_suspicious+0x143/0x14d
  fib_info_notify_update+0x8d1/0xa60
  __nexthop_replace_notify+0xd2/0x290
  rtm_new_nexthop+0x35e2/0x5946
  rtnetlink_rcv_msg+0x4f7/0xbd0
  netlink_rcv_skb+0x17a/0x480
  rtnetlink_rcv+0x22/0x30
  netlink_unicast+0x5ae/0x890
  netlink_sendmsg+0x98a/0xf40
  ____sys_sendmsg+0x879/0xa00
  ___sys_sendmsg+0x122/0x190
  __sys_sendmsg+0x103/0x1d0
  __x64_sys_sendmsg+0x7d/0xb0
  do_syscall_64+0x32/0x50
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fde28c3be57
 Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51
c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
RSP: 002b:00007ffc09330028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fde28c3be57
RDX: 0000000000000000 RSI: 00007ffc09330090 RDI: 0000000000000003
RBP: 000000005f45f911 R08: 0000000000000001 R09: 00007ffc0933012c
R10: 0000000000000076 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffc09330290 R14: 00007ffc09330eee R15: 00005610e48ed020

Fixes: 1bff1a0c9bbd ("ipv4: Add function to send route updates")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_trie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index c89b46fec153..ffc5332f1390 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2121,7 +2121,8 @@ void fib_info_notify_update(struct net *net, struct nl_info *info)
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
 		struct fib_table *tb;
 
-		hlist_for_each_entry_rcu(tb, head, tb_hlist)
+		hlist_for_each_entry_rcu(tb, head, tb_hlist,
+					 lockdep_rtnl_is_held())
 			__fib_info_notify_update(net, tb, info);
 	}
 }
-- 
2.26.2

