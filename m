Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DD12967A
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLWN3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:29:08 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46931 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfLWN3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:29:07 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 900A921BF9;
        Mon, 23 Dec 2019 08:29:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=M8Irrlwr6XfIqF7+UPITSjn46t9qn27eqRLL7i6acOk=; b=vFjTcFji
        k2HzT1ICAbQoj8bMJvbbQdPSdAjzf78K+ys97Bu0264J+EvUHsr0HwrEAed9blmt
        lw0yzsNdHgyuU3PK1TmTtOSp7njyzj0MQBy2R+PtDoGbQmMwjYMD0g+DMWKLl1ab
        TPmqdmTgHpwb9wfnivyZH+N2y8nz7FCyIxlLHHHDc543ieZlfEILrT4s/HoiiLDe
        jj1//qw6ELGMFABM3xhaWZCeRK8K2oOxxLt1os7+zSvCeugwKzgvMW9LhOrAApbn
        4k6eINb406Ie6cDXP0ceRnFDMcyZLXG1Wkb1tpaTwNYYHnJZ89U6gYsKEAhZmheD
        aqHFUrZwcSrT6A==
X-ME-Sender: <xms:IcEAXjwHYevQ2uwdW2Bo_mIgtWKvG6peKIwu4kt3vrIEjj6ynr5Z1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:IcEAXoL0ZrOFyDXOQAHATNib4_IlshDCpDRdJ0hez_FPshgHtN6VeQ>
    <xmx:IcEAXuMD8WhvwMEVJ8pD2X1G-wVGuGg_2y17ZzS4Krpvd13u58zfZw>
    <xmx:IcEAXhqqL7hGQAQSVIAlATR8cKjjnsex12fAFqQDB6WYfCLc2pLYlw>
    <xmx:IcEAXmdITYu9R-G6yR9RSYRzTU_CnDrM-746vY5keXU4hz8lhSGiMQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 377DB3060A6E;
        Mon, 23 Dec 2019 08:29:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_router: Start using new IPv6 route notifications
Date:   Mon, 23 Dec 2019 15:28:19 +0200
Message-Id: <20191223132820.888247-9-idosch@idosch.org>
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

With the new notifications mlxsw does not need to handle identical
routes itself, as this is taken care of by the core IPv6 code.

Instead, mlxsw only needs to take care of inserting and removing routes
from the device.

Convert mlxsw to use the new IPv6 route notifications and simplify the
code.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 225 ++++++------------
 1 file changed, 76 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0678815efbf3..295cdcb1c4c0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4989,13 +4989,6 @@ static void mlxsw_sp_rt6_destroy(struct mlxsw_sp_rt6 *mlxsw_sp_rt6)
 	kfree(mlxsw_sp_rt6);
 }
 
-static bool mlxsw_sp_fib6_rt_can_mp(const struct fib6_info *rt)
-{
-	/* RTF_CACHE routes are ignored */
-	return !(rt->fib6_flags & RTF_ADDRCONF) &&
-		rt->fib6_nh->fib_nh_gw_family;
-}
-
 static struct fib6_info *
 mlxsw_sp_fib6_entry_rt(const struct mlxsw_sp_fib6_entry *fib6_entry)
 {
@@ -5003,37 +4996,6 @@ mlxsw_sp_fib6_entry_rt(const struct mlxsw_sp_fib6_entry *fib6_entry)
 				list)->rt;
 }
 
-static struct mlxsw_sp_fib6_entry *
-mlxsw_sp_fib6_node_mp_entry_find(const struct mlxsw_sp_fib_node *fib_node,
-				 const struct fib6_info *nrt, bool replace)
-{
-	struct mlxsw_sp_fib6_entry *fib6_entry;
-
-	if (!mlxsw_sp_fib6_rt_can_mp(nrt) || replace)
-		return NULL;
-
-	list_for_each_entry(fib6_entry, &fib_node->entry_list, common.list) {
-		struct fib6_info *rt = mlxsw_sp_fib6_entry_rt(fib6_entry);
-
-		/* RT6_TABLE_LOCAL and RT6_TABLE_MAIN share the same
-		 * virtual router.
-		 */
-		if (rt->fib6_table->tb6_id > nrt->fib6_table->tb6_id)
-			continue;
-		if (rt->fib6_table->tb6_id != nrt->fib6_table->tb6_id)
-			break;
-		if (rt->fib6_metric < nrt->fib6_metric)
-			continue;
-		if (rt->fib6_metric == nrt->fib6_metric &&
-		    mlxsw_sp_fib6_rt_can_mp(rt))
-			return fib6_entry;
-		if (rt->fib6_metric > nrt->fib6_metric)
-			break;
-	}
-
-	return NULL;
-}
-
 static struct mlxsw_sp_rt6 *
 mlxsw_sp_fib6_entry_rt_find(const struct mlxsw_sp_fib6_entry *fib6_entry,
 			    const struct fib6_info *rt)
@@ -5424,86 +5386,13 @@ static void mlxsw_sp_fib6_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 	kfree(fib6_entry);
 }
 
-static struct mlxsw_sp_fib6_entry *
-mlxsw_sp_fib6_node_entry_find(const struct mlxsw_sp_fib_node *fib_node,
-			      const struct fib6_info *nrt, bool replace)
-{
-	struct mlxsw_sp_fib6_entry *fib6_entry, *fallback = NULL;
-
-	list_for_each_entry(fib6_entry, &fib_node->entry_list, common.list) {
-		struct fib6_info *rt = mlxsw_sp_fib6_entry_rt(fib6_entry);
-
-		if (rt->fib6_table->tb6_id > nrt->fib6_table->tb6_id)
-			continue;
-		if (rt->fib6_table->tb6_id != nrt->fib6_table->tb6_id)
-			break;
-		if (replace && rt->fib6_metric == nrt->fib6_metric) {
-			if (mlxsw_sp_fib6_rt_can_mp(rt) ==
-			    mlxsw_sp_fib6_rt_can_mp(nrt))
-				return fib6_entry;
-			if (mlxsw_sp_fib6_rt_can_mp(nrt))
-				fallback = fallback ?: fib6_entry;
-		}
-		if (rt->fib6_metric > nrt->fib6_metric)
-			return fallback ?: fib6_entry;
-	}
-
-	return fallback;
-}
-
-static int
-mlxsw_sp_fib6_node_list_insert(struct mlxsw_sp_fib6_entry *new6_entry,
-			       bool *p_replace)
-{
-	struct mlxsw_sp_fib_node *fib_node = new6_entry->common.fib_node;
-	struct fib6_info *nrt = mlxsw_sp_fib6_entry_rt(new6_entry);
-	struct mlxsw_sp_fib6_entry *fib6_entry;
-
-	fib6_entry = mlxsw_sp_fib6_node_entry_find(fib_node, nrt, *p_replace);
-
-	if (*p_replace && !fib6_entry)
-		*p_replace = false;
-
-	if (fib6_entry) {
-		list_add_tail(&new6_entry->common.list,
-			      &fib6_entry->common.list);
-	} else {
-		struct mlxsw_sp_fib6_entry *last;
-
-		list_for_each_entry(last, &fib_node->entry_list, common.list) {
-			struct fib6_info *rt = mlxsw_sp_fib6_entry_rt(last);
-
-			if (nrt->fib6_table->tb6_id > rt->fib6_table->tb6_id)
-				break;
-			fib6_entry = last;
-		}
-
-		if (fib6_entry)
-			list_add(&new6_entry->common.list,
-				 &fib6_entry->common.list);
-		else
-			list_add(&new6_entry->common.list,
-				 &fib_node->entry_list);
-	}
-
-	return 0;
-}
-
-static void
-mlxsw_sp_fib6_node_list_remove(struct mlxsw_sp_fib6_entry *fib6_entry)
-{
-	list_del(&fib6_entry->common.list);
-}
-
 static int mlxsw_sp_fib6_node_entry_link(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_fib6_entry *fib6_entry,
-					 bool *p_replace)
+					 struct mlxsw_sp_fib6_entry *fib6_entry)
 {
+	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
 	int err;
 
-	err = mlxsw_sp_fib6_node_list_insert(fib6_entry, p_replace);
-	if (err)
-		return err;
+	list_add(&fib6_entry->common.list, &fib_node->entry_list);
 
 	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, &fib6_entry->common);
 	if (err)
@@ -5512,7 +5401,7 @@ static int mlxsw_sp_fib6_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_fib_node_entry_add:
-	mlxsw_sp_fib6_node_list_remove(fib6_entry);
+	list_del(&fib6_entry->common.list);
 	return err;
 }
 
@@ -5521,7 +5410,7 @@ mlxsw_sp_fib6_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib6_entry *fib6_entry)
 {
 	mlxsw_sp_fib_node_entry_del(mlxsw_sp, &fib6_entry->common);
-	mlxsw_sp_fib6_node_list_remove(fib6_entry);
+	list_del(&fib6_entry->common.list);
 }
 
 static struct mlxsw_sp_fib6_entry *
@@ -5557,15 +5446,15 @@ mlxsw_sp_fib6_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp_fib6_entry_replace(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib6_entry *fib6_entry,
-					bool replace)
+					struct mlxsw_sp_fib6_entry *fib6_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
 	struct mlxsw_sp_fib6_entry *replaced;
 
-	if (!replace)
+	if (list_is_singular(&fib_node->entry_list))
 		return;
 
+	/* We inserted the new entry before replaced one */
 	replaced = list_next_entry(fib6_entry, common.list);
 
 	mlxsw_sp_fib6_node_entry_unlink(mlxsw_sp, replaced);
@@ -5573,9 +5462,9 @@ static void mlxsw_sp_fib6_entry_replace(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
 
-static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
-				    struct fib6_info **rt_arr,
-				    unsigned int nrt6, bool replace)
+static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
+					struct fib6_info **rt_arr,
+					unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
@@ -5599,18 +5488,6 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 	if (IS_ERR(fib_node))
 		return PTR_ERR(fib_node);
 
-	/* Before creating a new entry, try to append route to an existing
-	 * multipath entry.
-	 */
-	fib6_entry = mlxsw_sp_fib6_node_mp_entry_find(fib_node, rt, replace);
-	if (fib6_entry) {
-		err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry,
-						      rt_arr, nrt6);
-		if (err)
-			goto err_fib6_entry_nexthop_add;
-		return 0;
-	}
-
 	fib6_entry = mlxsw_sp_fib6_entry_create(mlxsw_sp, fib_node, rt_arr,
 						nrt6);
 	if (IS_ERR(fib6_entry)) {
@@ -5618,17 +5495,61 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib6_entry_create;
 	}
 
-	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry, &replace);
+	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry);
 	if (err)
 		goto err_fib6_node_entry_link;
 
-	mlxsw_sp_fib6_entry_replace(mlxsw_sp, fib6_entry, replace);
+	mlxsw_sp_fib6_entry_replace(mlxsw_sp, fib6_entry);
 
 	return 0;
 
 err_fib6_node_entry_link:
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 err_fib6_entry_create:
+	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+	return err;
+}
+
+static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
+				       struct fib6_info **rt_arr,
+				       unsigned int nrt6)
+{
+	struct mlxsw_sp_fib6_entry *fib6_entry;
+	struct mlxsw_sp_fib_node *fib_node;
+	struct fib6_info *rt = rt_arr[0];
+	int err;
+
+	if (mlxsw_sp->router->aborted)
+		return 0;
+
+	if (rt->fib6_src.plen)
+		return -EINVAL;
+
+	if (mlxsw_sp_fib6_rt_should_ignore(rt))
+		return 0;
+
+	fib_node = mlxsw_sp_fib_node_get(mlxsw_sp, rt->fib6_table->tb6_id,
+					 &rt->fib6_dst.addr,
+					 sizeof(rt->fib6_dst.addr),
+					 rt->fib6_dst.plen,
+					 MLXSW_SP_L3_PROTO_IPV6);
+	if (IS_ERR(fib_node))
+		return PTR_ERR(fib_node);
+
+	if (WARN_ON_ONCE(list_empty(&fib_node->entry_list))) {
+		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+		return -EINVAL;
+	}
+
+	fib6_entry = list_first_entry(&fib_node->entry_list,
+				      struct mlxsw_sp_fib6_entry, common.list);
+	err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry, rt_arr,
+					      nrt6);
+	if (err)
+		goto err_fib6_entry_nexthop_add;
+
+	return 0;
+
 err_fib6_entry_nexthop_add:
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 	return err;
@@ -6039,25 +5960,29 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	struct mlxsw_sp_fib_event_work *fib_work =
 		container_of(work, struct mlxsw_sp_fib_event_work, work);
 	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
-	bool replace;
 	int err;
 
 	rtnl_lock();
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_ADD:
-		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
-		err = mlxsw_sp_router_fib6_add(mlxsw_sp,
-					       fib_work->fib6_work.rt_arr,
-					       fib_work->fib6_work.nrt6,
-					       replace);
+	case FIB_EVENT_ENTRY_REPLACE_TMP:
+		err = mlxsw_sp_router_fib6_replace(mlxsw_sp,
+						   fib_work->fib6_work.rt_arr,
+						   fib_work->fib6_work.nrt6);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
-	case FIB_EVENT_ENTRY_DEL:
+	case FIB_EVENT_ENTRY_APPEND:
+		err = mlxsw_sp_router_fib6_append(mlxsw_sp,
+						  fib_work->fib6_work.rt_arr,
+						  fib_work->fib6_work.nrt6);
+		if (err)
+			mlxsw_sp_router_fib_abort(mlxsw_sp);
+		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
+		break;
+	case FIB_EVENT_ENTRY_DEL_TMP:
 		mlxsw_sp_router_fib6_del(mlxsw_sp,
 					 fib_work->fib6_work.rt_arr,
 					 fib_work->fib6_work.nrt6);
@@ -6143,9 +6068,9 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 	int err;
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
-	case FIB_EVENT_ENTRY_DEL:
+	case FIB_EVENT_ENTRY_REPLACE_TMP: /* fall through */
+	case FIB_EVENT_ENTRY_APPEND: /* fall through */
+	case FIB_EVENT_ENTRY_DEL_TMP:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
 					 info);
 		err = mlxsw_sp_router_fib6_work_init(&fib_work->fib6_work,
@@ -6248,7 +6173,9 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 						     router->mlxsw_sp);
 		return notifier_from_errno(err);
 	case FIB_EVENT_ENTRY_ADD: /* fall through */
-	case FIB_EVENT_ENTRY_REPLACE:
+	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE_TMP: /* fall through */
+	case FIB_EVENT_ENTRY_APPEND:
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
 			return notifier_from_errno(-EINVAL);
-- 
2.24.1

