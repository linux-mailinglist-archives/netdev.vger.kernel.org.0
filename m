Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2983122A8
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBGI2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:28:01 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35239 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230063AbhBGIYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:24:44 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9C1625801A3;
        Sun,  7 Feb 2021 03:23:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=CQbxn4Sb0oV57l3yryIjq0LekeuK20jkrPISN5CFMus=; b=nZYbG5Ea
        TB4nRANCjI0Z0/eydUq9kHjIMfWwuD9UPQ/XYf59u7WKao2gGg1u335CuZhofhjD
        Yo3VkQLsemxYmTFXGZUlACt1ob0GKdnn0AuLSkRcW6NFpJv8yRFEy6XEf6JSPdRy
        QitDJloVLIRS+3VeJDfv8PBUosW4EkbaTEsyhhOU/fWrPMc0pF4xbKVyJklE/bLl
        d9sO6iWhO8krB/gcGHdMo2SLWac6zXMkwx3WQMHUkyYSqpOTFQUEzBJLTB62bN3T
        654YyIgGZg4TDxMB8pyKD/Kq3Uy9rQB9dfVFqTxDJgwOmOgaDdDlBDkC4DeejFQQ
        ftR3gv/yHToLpw==
X-ME-Sender: <xms:iaMfYHjjVkVMoxlTR7uqqDgacT9pGMpYferJgGabHhVvbwcblQKgXQ>
    <xme:iaMfYEDG8qAghwcdtNH42K7tjpAeTN4PqTPBUwlF64NHCdDdhhrcVtPwiTtjW46yR
    yxO1X-mUzSMXmo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:iaMfYHFB3N_yvg4x-L0srZVVpyYN7x0_tClFyhV0ohu5kl2tXgXc1w>
    <xmx:iaMfYETPospnCIQKupDwgUx9W9zFIPHtuc6wKihxzWzMHmTrEwQGdg>
    <xmx:iaMfYEwcfdQpiucIEKbcpUdw3XrhDmqVk-EkKWEJZrRP2KYoWQxQjg>
    <xmx:iaMfYDloUs57qpryRPQS0weLRAcEwoiOcykmtPNslxR1n4794Q3vQQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3D651080064;
        Sun,  7 Feb 2021 03:23:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] IPv4: Add "offload failed" indication to routes
Date:   Sun,  7 Feb 2021 10:22:50 +0200
Message-Id: <20210207082258.3872086-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After installing a route to the kernel, user space receives an
acknowledgment, which means the route was installed in the kernel, but not
necessarily in hardware.

The asynchronous nature of route installation in hardware can lead to a
routing daemon advertising a route before it was actually installed in
hardware. This can result in packet loss or mis-routed packets until the
route is installed in hardware.

To avoid such cases, previous patch set added the ability to emit
RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
are changed, this behavior is controlled by sysctl.

With the above mentioned behavior, it is possible to know from user-space
if the route was offloaded, but if the offload fails there is no indication
to user-space. Following a failure, a routing daemon will wait indefinitely
for a notification that will never come.

This patch adds an "offload_failed" indication to IPv4 routes, so that
users will have better visibility into the offload process.

'struct fib_alias', and 'struct fib_rt_info' are extended with new field
that indicates if route offload failed. Note that the new field is added
using unused bit and therefore there is no need to increase structs size.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 ++
 drivers/net/netdevsim/fib.c                           | 1 +
 include/net/ip_fib.h                                  | 3 ++-
 net/ipv4/fib_lookup.h                                 | 3 ++-
 net/ipv4/fib_semantics.c                              | 3 +++
 net/ipv4/fib_trie.c                                   | 7 ++++++-
 net/ipv4/route.c                                      | 1 +
 7 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index cf111e73f81e..ac9a174372cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4963,6 +4963,7 @@ mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 	fri.type = fib4_entry->type;
 	fri.offload = should_offload;
 	fri.trap = !should_offload;
+	fri.offload_failed = false;
 	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
 }
 
@@ -4985,6 +4986,7 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fri.type = fib4_entry->type;
 	fri.offload = false;
 	fri.trap = false;
+	fri.offload_failed = false;
 	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
 }
 
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 1779146926a5..ca19da169853 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -319,6 +319,7 @@ static void nsim_fib4_rt_hw_flags_set(struct net *net,
 	fri.type = fib4_rt->type;
 	fri.offload = false;
 	fri.trap = trap;
+	fri.offload_failed = false;
 	fib_alias_hw_flags_set(net, &fri);
 }
 
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 2ec062aaa978..a914f33f3ed5 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -213,7 +213,8 @@ struct fib_rt_info {
 	u8			type;
 	u8			offload:1,
 				trap:1,
-				unused:6;
+				offload_failed:1,
+				unused:5;
 };
 
 struct fib_entry_notifier_info {
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index aff454ef0fa3..b58db1ca4bfb 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -18,7 +18,8 @@ struct fib_alias {
 	s16			fa_default;
 	u8			offload:1,
 				trap:1,
-				unused:6;
+				offload_failed:1,
+				unused:5;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4c38facf91c0..a632b66bc13a 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -521,6 +521,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.type = fa->fa_type;
 	fri.offload = fa->offload;
 	fri.trap = fa->trap;
+	fri.offload_failed = fa->offload_failed;
 	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
@@ -1811,6 +1812,8 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		rtm->rtm_flags |= RTM_F_OFFLOAD;
 	if (fri->trap)
 		rtm->rtm_flags |= RTM_F_TRAP;
+	if (fri->offload_failed)
+		rtm->rtm_flags |= RTM_F_OFFLOAD_FAILED;
 
 	nlmsg_end(skb, nlh);
 	return 0;
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 60559b708158..80147caa9bfd 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1047,11 +1047,13 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	if (!fa_match)
 		goto out;
 
-	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap)
+	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap &&
+	    fa_match->offload_failed == fri->offload_failed)
 		goto out;
 
 	fa_match->offload = fri->offload;
 	fa_match->trap = fri->trap;
+	fa_match->offload_failed = fri->offload_failed;
 
 	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
 		goto out;
@@ -1290,6 +1292,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->fa_default = -1;
 			new_fa->offload = 0;
 			new_fa->trap = 0;
+			new_fa->offload_failed = 0;
 
 			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
 
@@ -1350,6 +1353,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	new_fa->fa_default = -1;
 	new_fa->offload = 0;
 	new_fa->trap = 0;
+	new_fa->offload_failed = 0;
 
 	/* Insert new entry to the list. */
 	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
@@ -2289,6 +2293,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.type = fa->fa_type;
 				fri.offload = fa->offload;
 				fri.trap = fa->trap;
+				fri.offload_failed = fa->offload_failed;
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index be31e2446470..02d81d79deeb 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3304,6 +3304,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		fri.type = rt->rt_type;
 		fri.offload = 0;
 		fri.trap = 0;
+		fri.offload_failed = 0;
 		if (res.fa_head) {
 			struct fib_alias *fa;
 
-- 
2.29.2

