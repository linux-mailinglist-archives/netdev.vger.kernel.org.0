Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8AE5FBB6
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 18:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfGDQ2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 12:28:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48453 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbfGDQ2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 12:28:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E6C921B5A;
        Thu,  4 Jul 2019 12:28:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 12:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xhZhB+IK9Jl+Kpmzx
        yWonAJQy6PgpA/cvqVVPmT7tOU=; b=WCjozXmX/LIQL/EgElO0ttefHO1ZOhw7+
        8vT7KL+1AkS3IuKHW4BLqU80A2Oa7xjyjkQox9FGWeMw0gwLAOCAmYzKX02rxhMU
        63pHaJCZCinVTHnbqmycofDsoTKV1CMety5CL9i4lRii0gg3AvTplC5foPNkqWtS
        t7HNZmJE2i6eWkcGpOztgCqYdR+MUPSLbs3SiKu4iY7I0Q68qSkMx879M7jMnwRD
        ShdqlcQrqmTu8yVON71sYmWi/MUukV/IR22eCdFl5UeMtJ0gwBddSk9xDcK7xHBL
        esgA59qCwbDbII+cVWQKAi03qtmSLX5lE/YDHVLkoEiEDmn8HbFyg==
X-ME-Sender: <xms:JikeXYdM57hLDWYkJr7nO9gnVcbpAgI4gqHpHsSIHa4ibPU66bPTqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedvgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:JikeXefU1ch-aYPITNTJ1mn8HTcrjAi6yNOWSjXtp5kLPnWpYlZaYg>
    <xmx:JikeXUgd8viSGXpwD-A5Oi8oS04u7Jus5M7uTn8lS3ygfbj5QpjZiw>
    <xmx:JikeXSQxxALusVZHqGR6s7QvGjRp8iYYKPkYCwJoCpGgUCMC14lV-w>
    <xmx:JikeXQsKDCMR3CbcFuyPCtsyJP9uzcmfGhuUgfajgUtEWIbIOfjSXQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF96C8005C;
        Thu,  4 Jul 2019 12:28:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] ipv4: Fix NULL pointer dereference in ipv4_neigh_lookup()
Date:   Thu,  4 Jul 2019 19:26:38 +0300
Message-Id: <20190704162638.17913-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Both ip_neigh_gw4() and ip_neigh_gw6() can return either a valid pointer
or an error pointer, but the code currently checks that the pointer is
not NULL.

Fix this by checking that the pointer is not an error pointer, as this
can result in a NULL pointer dereference [1]. Specifically, I believe
that what happened is that ip_neigh_gw4() returned '-EINVAL'
(0xffffffffffffffea) to which the offset of 'refcnt' (0x70) was added,
which resulted in the address 0x000000000000005a.

[1]
 BUG: KASAN: null-ptr-deref in refcount_inc_not_zero_checked+0x6e/0x180
 Read of size 4 at addr 000000000000005a by task swapper/2/0

 CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.2.0-rc6-custom-reg-179657-gaa32d89 #396
 Hardware name: Mellanox Technologies Ltd. MSN2010/SA002610, BIOS 5.6.5 08/24/2017
 Call Trace:
 <IRQ>
 dump_stack+0x73/0xbb
 __kasan_report+0x188/0x1ea
 kasan_report+0xe/0x20
 refcount_inc_not_zero_checked+0x6e/0x180
 ipv4_neigh_lookup+0x365/0x12c0
 __neigh_update+0x1467/0x22f0
 arp_process.constprop.6+0x82e/0x1f00
 __netif_receive_skb_one_core+0xee/0x170
 process_backlog+0xe3/0x640
 net_rx_action+0x755/0xd90
 __do_softirq+0x29b/0xae7
 irq_exit+0x177/0x1c0
 smp_apic_timer_interrupt+0x164/0x5e0
 apic_timer_interrupt+0xf/0x20
 </IRQ>

Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8ea0735a6754..b2b35b38724d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -447,7 +447,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 		n = ip_neigh_gw4(dev, pkey);
 	}
 
-	if (n && !refcount_inc_not_zero(&n->refcnt))
+	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 
 	rcu_read_unlock_bh();
-- 
2.20.1

