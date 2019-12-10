Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982D1118EF2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfLJRZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:25:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40719 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbfLJRZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:25:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5CA3722375;
        Tue, 10 Dec 2019 12:25:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zxIUP/JVEkB1dQn1sd9aWnt+QYkya8gVNu8VOC3JZWU=; b=ihFk/ARA
        JU4JhmDLhI9svTPANVibcp+KZVenpGJptNSpajdeVtCQZdJxVSqAd0t2HYwcMjvb
        9venThcTE6dFTGRuc/+ep5F8bkpJQxFCg8sHeUN7LzChjzJIVzzCMA4vcQMVQ/bm
        vGwKTN9jhO8IhDJnulsuFui3mWWommReoioZLhNBHBIYnRxjAlLUowa5oUDyIOPh
        H1JcPKI49kBwBXs012aBsUUFyM4x5uvss04OvzinP0qtxG5aDw0l7FGlEYf25R6O
        hhf/NmKWNzjDdaV7tD/WbYj+/HcjPVXlWBtzpI2okUNxceEr74IPEyGEmTUnvpft
        vxJAsHAmKYpKBQ==
X-ME-Sender: <xms:7dTvXUIWOC0iGIatwwOcHDmy5gvnB_ny-GdIZTjKGJbCSa7km7M7Yw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:7dTvXYa73Qa-ClIlYanGBO8F29I1mPV3dpKaGyahflCB8Oiqh7oXPQ>
    <xmx:7dTvXfsoFvjBcNk7A4HnQrPJ2cbmS8PbFmOBaJmY3E6WWdb-aqkCOA>
    <xmx:7dTvXVv-owooZF_AFaQGVAv-wJnn80GGl3JPGwa6lDXBZqE_-Mf6Jw>
    <xmx:7dTvXdaWUhMcdT1nhIvFQCuIRIXgbTqksjm9VX3VUbchv1DG2TBRNw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD7AC80059;
        Tue, 10 Dec 2019 12:24:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] ipv4: Remove old route notifications and convert listeners
Date:   Tue, 10 Dec 2019 19:24:02 +0200
Message-Id: <20191210172402.463397-10-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191210172402.463397-1-idosch@idosch.org>
References: <20191210172402.463397-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Unlike mlxsw, the other listeners to the FIB notification chain do not
require any special modifications as they never considered multiple
identical routes.

This patch removes the old route notifications and converts all the
listeners to use the new replace / delete notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  4 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 11 +++---
 drivers/net/ethernet/rocker/rocker_main.c     |  4 +-
 drivers/net/netdevsim/fib.c                   |  4 +-
 include/net/fib_notifier.h                    |  2 -
 net/ipv4/fib_trie.c                           | 38 ++++---------------
 6 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index b70afa310ad2..416676c35b1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -200,8 +200,6 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	rtnl_lock();
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
 					 fib_work->fen_info.fi);
@@ -259,8 +257,6 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 396b27b9cdb4..bba1c8215d06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6007,14 +6007,14 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE_TMP:
+	case FIB_EVENT_ENTRY_REPLACE:
 		err = mlxsw_sp_router_fib4_replace(mlxsw_sp,
 						   &fib_work->fen_info);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_ENTRY_DEL_TMP:
+	case FIB_EVENT_ENTRY_DEL:
 		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
@@ -6111,8 +6111,8 @@ static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event_work *fib_work,
 	struct fib_nh_notifier_info *fnh_info;
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE_TMP: /* fall through */
-	case FIB_EVENT_ENTRY_DEL_TMP:
+	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
 		fib_work->fen_info = *fen_info;
@@ -6243,8 +6243,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 						     router->mlxsw_sp);
 		return notifier_from_errno(err);
 	case FIB_EVENT_ENTRY_ADD: /* fall through */
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_REPLACE_TMP:
+	case FIB_EVENT_ENTRY_REPLACE:
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
 			return notifier_from_errno(-EINVAL);
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index bc4f951315da..7585cd2270ba 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2159,7 +2159,7 @@ static void rocker_router_fib_event_work(struct work_struct *work)
 	/* Protect internal structures from changes */
 	rtnl_lock();
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_ADD:
+	case FIB_EVENT_ENTRY_REPLACE:
 		err = rocker_world_fib4_add(rocker, &fib_work->fen_info);
 		if (err)
 			rocker_world_fib4_abort(rocker);
@@ -2201,7 +2201,7 @@ static int rocker_router_fib_event(struct notifier_block *nb,
 	fib_work->event = event;
 
 	switch (event) {
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		if (info->family == AF_INET) {
 			struct fib_entry_notifier_info *fen_info = ptr;
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 13540dee7364..4e02a4231fcb 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -177,10 +177,10 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 					  event == FIB_EVENT_RULE_ADD);
 		break;
 
+	case FIB_EVENT_ENTRY_REPLACE:  /* fall through */
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
-		err = nsim_fib_event(data, info,
-				     event == FIB_EVENT_ENTRY_ADD);
+		err = nsim_fib_event(data, info, event != FIB_EVENT_ENTRY_DEL);
 		break;
 	}
 
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
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index eff45e7795ba..ed9141d4725a 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1143,7 +1143,6 @@ static void fib_remove_alias(struct trie *t, struct key_vector *tp,
 int fib_table_insert(struct net *net, struct fib_table *tb,
 		     struct fib_config *cfg, struct netlink_ext_ack *extack)
 {
-	enum fib_event_type event = FIB_EVENT_ENTRY_ADD;
 	struct trie *t = (struct trie *)tb->tb_data;
 	struct fib_alias *fa, *new_fa;
 	struct key_vector *l, *tp;
@@ -1242,19 +1241,13 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 						 tb->tb_id) == fa) {
 				enum fib_event_type fib_event;
 
-				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+				fib_event = FIB_EVENT_ENTRY_REPLACE;
 				err = call_fib_entry_notifiers(net, fib_event,
 							       key, plen,
 							       new_fa, extack);
 				if (err)
 					goto out_free_new_fa;
 			}
-			err = call_fib_entry_notifiers(net,
-						       FIB_EVENT_ENTRY_REPLACE,
-						       key, plen, new_fa,
-						       extack);
-			if (err)
-				goto out_free_new_fa;
 
 			rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen,
 				  tb->tb_id, &cfg->fc_nlinfo, nlflags);
@@ -1276,12 +1269,10 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		if (fa_match)
 			goto out;
 
-		if (cfg->fc_nlflags & NLM_F_APPEND) {
-			event = FIB_EVENT_ENTRY_APPEND;
+		if (cfg->fc_nlflags & NLM_F_APPEND)
 			nlflags |= NLM_F_APPEND;
-		} else {
+		else
 			fa = fa_first;
-		}
 	}
 	err = -ENOENT;
 	if (!(cfg->fc_nlflags & NLM_F_CREATE))
@@ -1315,15 +1306,12 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	    new_fa) {
 		enum fib_event_type fib_event;
 
-		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		fib_event = FIB_EVENT_ENTRY_REPLACE;
 		err = call_fib_entry_notifiers(net, fib_event, key, plen,
 					       new_fa, extack);
 		if (err)
 			goto out_remove_new_fa;
 	}
-	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
-	if (err)
-		goto out_remove_new_fa;
 
 	if (!plen)
 		tb->tb_num_default++;
@@ -1606,10 +1594,10 @@ static void fib_notify_alias_delete(struct net *net, u32 key,
 	fa_next = hlist_entry_safe(fa_to_delete->fa_list.next,
 				   struct fib_alias, fa_list);
 	if (fa_next && fa_next->fa_slen == slen && fa_next->tb_id == tb_id) {
-		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		fib_event = FIB_EVENT_ENTRY_REPLACE;
 		fa_to_notify = fa_next;
 	} else {
-		fib_event = FIB_EVENT_ENTRY_DEL_TMP;
+		fib_event = FIB_EVENT_ENTRY_DEL;
 		fa_to_notify = fa_to_delete;
 	}
 	call_fib_entry_notifiers(net, fib_event, key, KEYLENGTH - slen,
@@ -1670,8 +1658,6 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 		return -ESRCH;
 
 	fib_notify_alias_delete(net, key, &l->leaf, fa_to_delete, extack);
-	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key, plen,
-				 fa_to_delete, extack);
 	rtmsg_fib(RTM_DELROUTE, htonl(key), fa_to_delete, plen, tb->tb_id,
 		  &cfg->fc_nlinfo, 0);
 
@@ -1997,10 +1983,6 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 
 			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
 						NULL);
-			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
-						 n->key,
-						 KEYLENGTH - fa->fa_slen, fa,
-						 NULL);
 			hlist_del_rcu(&fa->fa_list);
 			fib_release_info(fa->fa_info);
 			alias_free_mem_rcu(fa);
@@ -2111,17 +2093,11 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 		if (tb->tb_id != fa->tb_id)
 			continue;
 
-		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
-					      KEYLENGTH - fa->fa_slen,
-					      fa, extack);
-		if (err)
-			return err;
-
 		if (fa->fa_slen == last_slen)
 			continue;
 
 		last_slen = fa->fa_slen;
-		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE_TMP,
+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE,
 					      l->key, KEYLENGTH - fa->fa_slen,
 					      fa, extack);
 		if (err)
-- 
2.23.0

