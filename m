Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9540F8B7
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhIQNEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:04:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57349 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235210AbhIQNEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:04:30 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D73655C01DA;
        Fri, 17 Sep 2021 09:03:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 17 Sep 2021 09:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2U3fIslTJuZNMwv6/
        VsBSBUBzjTdiwpRKnbQ/edRf1Y=; b=VA3k71tS02nJBKeSx0ozoPgO3CAPhXKjE
        Xuu9WrE18Bqd3maGY3VIyxuuKIOSaNijQI/xff0FSu4fgFSRr0i/k77woNGsgJTL
        3vZpYwHPOF1QFVyS/X0BWC2p9DwWar3cmvczzPk1rI2BxzE1T4syl2FfJejHxgog
        E10gFJ3u6sp5DDJ+N++5lKZdihb86AIG0RjAkXAPFY5CE4hvTlX6/otLGkpJQk2X
        MNMuYzzpSWsTsVUOeZL/gf1sxm/vjy+3Wl1tESgYkKVSDeAckSYMALWffG/4Sf4Y
        iEFmppiqibKJse06/fvWuj7VApbHKPZ+vUrAlul76igiJ69CiX2Qw==
X-ME-Sender: <xms:C5JEYSlbHBCeLnjGsKSzyLYtKFo84uso2sli2-RnXAVnTFmfn5zXOQ>
    <xme:C5JEYZ3CuzXI9sM8AtYn9OkrggMmO5p_IgP_CK6RbQP9V4S3n3dv7cN17yK095U0q
    Jn-eJbMRY_BaWk>
X-ME-Received: <xmr:C5JEYQpD5xcITgOLBxdIXPHNj3SXgChv4D4-UCu2R_QkLx68yv0WhQbiH2z9PUrZUxgEX9sGErk7Z0t7t08mjK6PqpEh8-tx5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:C5JEYWnzzbGAvClfHp0NDEyiiI23JQTHObmSese1oIY2D5P5xCLQGw>
    <xmx:C5JEYQ2-cGyanfSU6a4hQBmOW9L0GwvQLu7hCNLxPjggoGpjxoLhmg>
    <xmx:C5JEYds1o3EJ93g4AOjgXSt3VMhLlFJQVsp2O1kBWDBes5k4evjdZQ>
    <xmx:C5JEYU9YwI4DCgoStv59gGTx5ML6SlbLhhUUG-CK2khsSytuNAZn3w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 09:03:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH net] nexthop: Fix division by zero while replacing a resilient group
Date:   Fri, 17 Sep 2021 16:02:18 +0300
Message-Id: <20210917130218.560510-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The resilient nexthop group torture tests in fib_nexthop.sh exposed a
possible division by zero while replacing a resilient group [1]. The
division by zero occurs when the data path sees a resilient nexthop
group with zero buckets.

The tests replace a resilient nexthop group in a loop while traffic is
forwarded through it. The tests do not specify the number of buckets
while performing the replacement, resulting in the kernel allocating a
stub resilient table (i.e, 'struct nh_res_table') with zero buckets.

This table should never be visible to the data path, but the old nexthop
group (i.e., 'oldg') might still be used by the data path when the stub
table is assigned to it.

Fix this by only assigning the stub table to the old nexthop group after
making sure the group is no longer used by the data path.

Tested with fib_nexthops.sh:

Tests passed: 222
Tests failed:   0

[1]
 divide error: 0000 [#1] PREEMPT SMP KASAN
 CPU: 0 PID: 1850 Comm: ping Not tainted 5.14.0-custom-10271-ga86eb53057fe #1107
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
 RIP: 0010:nexthop_select_path+0x2d2/0x1a80
[...]
 Call Trace:
  fib_select_multipath+0x79b/0x1530
  fib_select_path+0x8fb/0x1c10
  ip_route_output_key_hash_rcu+0x1198/0x2da0
  ip_route_output_key_hash+0x190/0x340
  ip_route_output_flow+0x21/0x120
  raw_sendmsg+0x91d/0x2e10
  inet_sendmsg+0x9e/0xe0
  __sys_sendto+0x23d/0x360
  __x64_sys_sendto+0xe1/0x1b0
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: stable@vger.kernel.org
Fixes: 283a72a5599e ("nexthop: Add implementation of resilient next-hop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/ipv4/nexthop.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 75ca4b6e484f..0e75fd3e57b4 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1982,6 +1982,8 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 	rcu_assign_pointer(old->nh_grp, newg);
 
 	if (newg->resilient) {
+		/* Make sure concurrent readers are not using 'oldg' anymore. */
+		synchronize_net();
 		rcu_assign_pointer(oldg->res_table, tmp_table);
 		rcu_assign_pointer(oldg->spare->res_table, tmp_table);
 	}
-- 
2.31.1

