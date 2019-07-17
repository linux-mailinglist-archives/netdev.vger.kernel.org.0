Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748A86C241
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfGQUkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:40:10 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39309 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfGQUkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:40:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9DB2D21F7D;
        Wed, 17 Jul 2019 16:40:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 17 Jul 2019 16:40:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aaVkMWhVxNnPlmeFg
        /m9luoM0yAPmRnnVb6o6erhhfc=; b=yzSLHrfPuWXODy2rBzNf/akfFgPA0Xs65
        DQU+zD/K7epSan/IOnjnwIkeIZue1iMdDy2bfpTvBbi74JonI51i2SKY8sZi2pG2
        HGPc3IObgNGQFeEYcdpzairrZzcpCks9opnPSZCMGcFPibtdVj4YImC3W8i7dDMa
        qcA/rsBcy0rTdFRiYhKXc1T5+EYPiACkO6pUoWt9P6RyvEw0wHN+Yp64lRdOpucN
        do2VjM9RtXm7WVdqLkG+0gdYdqtV7Kj4W2nNIq9OFfT+8hF8tDfTA7SlV9sNdRxh
        LEZu4naWcsbckNbkn56pKbERao6W+oVrvoxbEH+guAr8MuEk10YMQ==
X-ME-Sender: <xms:qIcvXWEMyVHHDkrUaGZdPyHhpA5cfiaJ1H5O1SlgCRtxN2xVMrfjxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrieefgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehnvggvuggvugdrqddqqdhnvghtnecukfhppeejje
    drudefkedrvdegledrvddtleenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:qIcvXblgSpyPaBoCk1okiLGYkpnG5jNh5oMAJi8YIyFffeY7yRa6Tg>
    <xmx:qIcvXbJRyLgVac7SrIAO-eEsHlsi8gljCTKyyeXMCxx9AFOkC_1SUg>
    <xmx:qIcvXUa-x2G6sClydTTH4Nr-EX11hcyyfqzX53jGV8KbXKxNHb3-wA>
    <xmx:qIcvXQX7hwF91fGi2jpcOy_GF9sj83xat6_8vk76p46yde2Pll4XKw>
Received: from localhost.localdomain (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id D172280060;
        Wed, 17 Jul 2019 16:40:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] ipv6: Unlink sibling route in case of failure
Date:   Wed, 17 Jul 2019 23:39:33 +0300
Message-Id: <20190717203933.3073-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When a route needs to be appended to an existing multipath route,
fib6_add_rt2node() first appends it to the siblings list and increments
the number of sibling routes on each sibling.

Later, the function notifies the route via call_fib6_entry_notifiers().
In case the notification is vetoed, the route is not unlinked from the
siblings list, which can result in a use-after-free.

Fix this by unlinking the route from the siblings list before returning
an error.

Audited the rest of the call sites from which the FIB notification chain
is called and could not find more problems.

Fixes: 2233000cba40 ("net/ipv6: Move call_fib6_entry_notifiers up for route adds")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alexander Petrovskiy <alexpe@mellanox.com>
---
Dave, this will not apply cleanly to stable trees due to recent changes
in net-next. I can prepare another patch for stable if needed.
---
 net/ipv6/ip6_fib.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 49884f96232b..87f47bc55c5e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1151,8 +1151,24 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			err = call_fib6_entry_notifiers(info->nl_net,
 							FIB_EVENT_ENTRY_ADD,
 							rt, extack);
-			if (err)
+			if (err) {
+				struct fib6_info *sibling, *next_sibling;
+
+				/* If the route has siblings, then it first
+				 * needs to be unlinked from them.
+				 */
+				if (!rt->fib6_nsiblings)
+					return err;
+
+				list_for_each_entry_safe(sibling, next_sibling,
+							 &rt->fib6_siblings,
+							 fib6_siblings)
+					sibling->fib6_nsiblings--;
+				rt->fib6_nsiblings = 0;
+				list_del_init(&rt->fib6_siblings);
+				rt6_multipath_rebalance(next_sibling);
 				return err;
+			}
 		}
 
 		rcu_assign_pointer(rt->fib6_next, iter);
-- 
2.21.0

