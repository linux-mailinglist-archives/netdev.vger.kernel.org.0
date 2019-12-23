Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2378112967B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLWN3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:29:10 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42305 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfLWN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:29:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0728A21B7C;
        Mon, 23 Dec 2019 08:29:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8ORQ3bOrK9bhDUtKMt8YY5bN+s801J/n7zefuNttFeM=; b=WSrdrowG
        3Iw9pm5PZhVDxvrZ7/QTKvIuUaabulLoq5yh93MFjlGLifp/WH9A27JN6zMzbXzi
        OtIzXh0011EBFw88AamHGcpx5+x+VU7fbdYWoLFHa6DFvapsUGb/sbOTs8Lx8o2y
        Pzw11hOLDsClKNK1r6f9IPFacepQGjDbOSRKJJQ5s/6HWD9QU5QRIfW9G8AKPPK/
        n3G4w/kfMMCZPqws+h4KBgcZHNImhUgQksLF7UDb1iItum5H6bDI2gUvrR+3BC2R
        WO3x69lsSynY6ZLGkRgwVsKxhb1UA/DAjvEGIfbplNcTv9GUiJDb/zTJ0Uhpc8fF
        qhBHKvRCZl7k7A==
X-ME-Sender: <xms:IsEAXmo4JtfM-2rJ-MDtP3tdTTpCavUKto_LrD-WQGbATCFbCsScLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeek
X-ME-Proxy: <xmx:IsEAXo420oBducMt-0vkHXGQvzB5gygsHy8DfF3yDJCx1YaD6WH0AA>
    <xmx:IsEAXmO7F-c1wEIblpaN-IEFNgYYwZnbPxRhKKqdNvIkFMDPVg-1yw>
    <xmx:IsEAXqPEuF-PvkA9OMSWOwZMeVxroLM55oR-4QZP6zQs1n1wNXCVUw>
    <xmx:I8EAXn6gZ063Vg0Mcmkd1BBb2rQzRsUjlHNa_qYxIKX_MoyVsWR1pg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A56E03060802;
        Mon, 23 Dec 2019 08:29:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] ipv6: Remove old route notifications and convert listeners
Date:   Mon, 23 Dec 2019 15:28:20 +0200
Message-Id: <20191223132820.888247-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223132820.888247-1-idosch@idosch.org>
References: <20191223132820.888247-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Now that mlxsw is converted to use the new FIB notifications it is
possible to delete the old ones and use the new replace / append /
delete notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  9 ++-
 drivers/net/netdevsim/fib.c                   |  1 -
 include/net/fib_notifier.h                    |  2 -
 net/ipv6/ip6_fib.c                            | 61 +++++--------------
 net/ipv6/route.c                              | 18 +-----
 5 files changed, 21 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 295cdcb1c4c0..f62e8d67348c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5966,7 +5966,7 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE_TMP:
+	case FIB_EVENT_ENTRY_REPLACE:
 		err = mlxsw_sp_router_fib6_replace(mlxsw_sp,
 						   fib_work->fib6_work.rt_arr,
 						   fib_work->fib6_work.nrt6);
@@ -5982,7 +5982,7 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
-	case FIB_EVENT_ENTRY_DEL_TMP:
+	case FIB_EVENT_ENTRY_DEL:
 		mlxsw_sp_router_fib6_del(mlxsw_sp,
 					 fib_work->fib6_work.rt_arr,
 					 fib_work->fib6_work.nrt6);
@@ -6068,9 +6068,9 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 	int err;
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE_TMP: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
 	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_DEL_TMP:
+	case FIB_EVENT_ENTRY_DEL:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
 					 info);
 		err = mlxsw_sp_router_fib6_work_init(&fib_work->fib6_work,
@@ -6174,7 +6174,6 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		return notifier_from_errno(err);
 	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_REPLACE_TMP: /* fall through */
 	case FIB_EVENT_ENTRY_APPEND:
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 4e02a4231fcb..b5df308b4e33 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -178,7 +178,6 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 		break;
 
 	case FIB_EVENT_ENTRY_REPLACE:  /* fall through */
-	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		err = nsim_fib_event(data, info, event != FIB_EVENT_ENTRY_DEL);
 		break;
diff --git a/include/net/fib_notifier.h b/include/net/fib_notifier.h
index b3c54325caec..6d59221ff05a 100644
--- a/include/net/fib_notifier.h
+++ b/include/net/fib_notifier.h
@@ -23,8 +23,6 @@ enum fib_event_type {
 	FIB_EVENT_NH_DEL,
 	FIB_EVENT_VIF_ADD,
 	FIB_EVENT_VIF_DEL,
-	FIB_EVENT_ENTRY_REPLACE_TMP,
-	FIB_EVENT_ENTRY_DEL_TMP,
 };
 
 struct fib_notifier_ops {
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 67ddee539f77..b1e9a10e1133 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -423,8 +423,7 @@ int call_fib6_entry_notifiers_replace(struct net *net, struct fib6_info *rt)
 	};
 
 	rt->fib6_table->fib_seq++;
-	return call_fib6_notifiers(net, FIB_EVENT_ENTRY_REPLACE_TMP,
-				   &info.info);
+	return call_fib6_notifiers(net, FIB_EVENT_ENTRY_REPLACE, &info.info);
 }
 
 struct fib6_dump_arg {
@@ -435,15 +434,7 @@ struct fib6_dump_arg {
 
 static int fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
 {
-	if (rt == arg->net->ipv6.fib6_null_entry)
-		return 0;
-	return call_fib6_entry_notifier(arg->nb, FIB_EVENT_ENTRY_ADD,
-					rt, arg->extack);
-}
-
-static int fib6_rt_dump_tmp(struct fib6_info *rt, struct fib6_dump_arg *arg)
-{
-	enum fib_event_type fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+	enum fib_event_type fib_event = FIB_EVENT_ENTRY_REPLACE;
 	int err;
 
 	if (!rt || rt == arg->net->ipv6.fib6_null_entry)
@@ -463,19 +454,9 @@ static int fib6_rt_dump_tmp(struct fib6_info *rt, struct fib6_dump_arg *arg)
 
 static int fib6_node_dump(struct fib6_walker *w)
 {
-	struct fib6_info *rt;
-	int err = 0;
-
-	err = fib6_rt_dump_tmp(w->leaf, w->args);
-	if (err)
-		goto out;
+	int err;
 
-	for_each_fib6_walker_rt(w) {
-		err = fib6_rt_dump(rt, w->args);
-		if (err)
-			break;
-	}
-out:
+	err = fib6_rt_dump(w->leaf, w->args);
 	w->leaf = NULL;
 	return err;
 }
@@ -1220,25 +1201,21 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 add:
 		nlflags |= NLM_F_CREATE;
 
-		if (!info->skip_notify_kernel) {
+		/* The route should only be notified if it is the first
+		 * route in the node or if it is added as a sibling
+		 * route to the first route in the node.
+		 */
+		if (!info->skip_notify_kernel &&
+		    (notify_sibling_rt || ins == &fn->leaf)) {
 			enum fib_event_type fib_event;
 
 			if (notify_sibling_rt)
 				fib_event = FIB_EVENT_ENTRY_APPEND;
 			else
-				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
-			/* The route should only be notified if it is the first
-			 * route in the node or if it is added as a sibling
-			 * route to the first route in the node.
-			 */
-			if (notify_sibling_rt || ins == &fn->leaf)
-				err = call_fib6_entry_notifiers(info->nl_net,
-								fib_event, rt,
-								extack);
-
+				fib_event = FIB_EVENT_ENTRY_REPLACE;
 			err = call_fib6_entry_notifiers(info->nl_net,
-							FIB_EVENT_ENTRY_ADD,
-							rt, extack);
+							fib_event, rt,
+							extack);
 			if (err) {
 				struct fib6_info *sibling, *next_sibling;
 
@@ -1282,14 +1259,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			return -ENOENT;
 		}
 
-		if (!info->skip_notify_kernel) {
-			enum fib_event_type fib_event;
-
-			fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
-			if (ins == &fn->leaf)
-				err = call_fib6_entry_notifiers(info->nl_net,
-								fib_event, rt,
-								extack);
+		if (!info->skip_notify_kernel && ins == &fn->leaf) {
 			err = call_fib6_entry_notifiers(info->nl_net,
 							FIB_EVENT_ENTRY_REPLACE,
 							rt, extack);
@@ -2007,11 +1977,10 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 
 	if (!info->skip_notify_kernel) {
 		if (notify_del)
-			call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL_TMP,
+			call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
 						  rt, NULL);
 		else if (replace_rt)
 			call_fib6_entry_notifiers_replace(net, replace_rt);
-		call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, rt, NULL);
 	}
 	if (!info->skip_notify)
 		inet6_rt_notify(RTM_DELROUTE, rt, info, 0);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 646716a47cc9..4b8659e077d3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3787,15 +3787,10 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 								  replace_rt);
 			else
 				call_fib6_multipath_entry_notifiers(net,
-						       FIB_EVENT_ENTRY_DEL_TMP,
+						       FIB_EVENT_ENTRY_DEL,
 						       rt, rt->fib6_nsiblings,
 						       NULL);
 		}
-		call_fib6_multipath_entry_notifiers(net,
-						    FIB_EVENT_ENTRY_DEL,
-						    rt,
-						    rt->fib6_nsiblings,
-						    NULL);
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings,
 					 fib6_siblings) {
@@ -5074,7 +5069,6 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 {
 	struct fib6_info *rt_notif = NULL, *rt_last = NULL;
 	struct nl_info *info = &cfg->fc_nlinfo;
-	enum fib_event_type event_type;
 	struct fib6_config r_cfg;
 	struct rtnexthop *rtnh;
 	struct fib6_info *rt;
@@ -5210,7 +5204,7 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 		if (rt_notif->fib6_nsiblings != nhn - 1)
 			fib_event = FIB_EVENT_ENTRY_APPEND;
 		else
-			fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+			fib_event = FIB_EVENT_ENTRY_REPLACE;
 
 		err = call_fib6_multipath_entry_notifiers(info->nl_net,
 							  fib_event, rt_notif,
@@ -5221,14 +5215,6 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 			goto add_errout;
 		}
 	}
-	event_type = replace ? FIB_EVENT_ENTRY_REPLACE : FIB_EVENT_ENTRY_ADD;
-	err = call_fib6_multipath_entry_notifiers(info->nl_net, event_type,
-						  rt_notif, nhn - 1, extack);
-	if (err) {
-		/* Delete all the siblings that were just added */
-		err_nh = NULL;
-		goto add_errout;
-	}
 
 	/* success ... tell user about new route */
 	ip6_route_mpath_notify(rt_notif, rt_last, info, nlflags);
-- 
2.24.1

