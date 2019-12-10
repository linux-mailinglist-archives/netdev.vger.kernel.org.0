Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43907118EF3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfLJRZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:25:07 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42579 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727211AbfLJRZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:25:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CC14D222E7;
        Tue, 10 Dec 2019 12:24:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ftLvUE4ApaHJkHUkgMK29i57XS0Rg7tG6DmzSBsjk3s=; b=rDhd5nIj
        nwt0/29C6fMnFSB9iAfwX+hSTIO4YMJPCKYymhdf4yrCXihrv5WklEWpqIPBJBib
        /2rgIBx4tL2UkuC7Ni20iEFId60ZH3SO2XcOBVGstHAur1OG3q4OZAuK1JqXld0s
        2OleS4Vpc+NNyeEABDDyZMkdyL+DLJo8s9NvXAmPySI/1pNCu2/+8Vd7yDDnZulc
        hwK+Bsvx6i0U43LZBG69epV4FRTWQKdwLP+hEHpr/rxHeWAK5Vt5aO1pigi4x0kA
        u2ui4XxTey3SQXA8i6NkATeiRpSgkJ4oQD5e3zYZE9BESVU5qqNDsikuwscH5GA8
        eg2HU65zmFlsDA==
X-ME-Sender: <xms:69TvXcZ2YPJpSUqeJ1cJxSUCoOc-YDFJmnDKrGM4QPaLcN7KXyh4rA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:69TvXayr8aLwvElCR2jFrlEupdD7UCSeW6nd4b8fOmQwUDJqfxFfGg>
    <xmx:69TvXdk12iCT1vH3ywzg7DvYHSY0-IXqWHlwrW3omNlCfs8Pz12EJA>
    <xmx:69TvXe9SGyX0i2Hltgc_U9kxfw6boYL_Q8kUgeVwt0LC4TufCQf2zA>
    <xmx:69TvXeMgAsr94XwFLGpRkNpy5jlxdgtvnMnLr4Gjgeru6Kzx7Cllxg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68A4E80059;
        Tue, 10 Dec 2019 12:24:58 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_router: Start using new IPv4 route notifications
Date:   Tue, 10 Dec 2019 19:24:01 +0200
Message-Id: <20191210172402.463397-9-idosch@idosch.org>
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

With the new notifications mlxsw does not need to handle identical
routes itself, as this is taken care of by the core IPv4 code.

Instead, mlxsw only needs to take care of inserting and removing routes
from the device.

Convert mlxsw to use the new IPv4 route notifications and simplify the
code.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 141 +++---------------
 1 file changed, 20 insertions(+), 121 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 30bfe3880faf..396b27b9cdb4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3845,7 +3845,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 
 	key.fib_nh = fib_nh;
 	nh = mlxsw_sp_nexthop_lookup(mlxsw_sp, key);
-	if (WARN_ON_ONCE(!nh))
+	if (!nh)
 		return;
 
 	switch (event) {
@@ -4780,95 +4780,6 @@ static void mlxsw_sp_fib_node_put(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
 }
 
-static struct mlxsw_sp_fib4_entry *
-mlxsw_sp_fib4_node_entry_find(const struct mlxsw_sp_fib_node *fib_node,
-			      const struct mlxsw_sp_fib4_entry *new4_entry)
-{
-	struct mlxsw_sp_fib4_entry *fib4_entry;
-
-	list_for_each_entry(fib4_entry, &fib_node->entry_list, common.list) {
-		if (fib4_entry->tb_id > new4_entry->tb_id)
-			continue;
-		if (fib4_entry->tb_id != new4_entry->tb_id)
-			break;
-		if (fib4_entry->tos > new4_entry->tos)
-			continue;
-		if (fib4_entry->prio >= new4_entry->prio ||
-		    fib4_entry->tos < new4_entry->tos)
-			return fib4_entry;
-	}
-
-	return NULL;
-}
-
-static int
-mlxsw_sp_fib4_node_list_append(struct mlxsw_sp_fib4_entry *fib4_entry,
-			       struct mlxsw_sp_fib4_entry *new4_entry)
-{
-	struct mlxsw_sp_fib_node *fib_node;
-
-	if (WARN_ON(!fib4_entry))
-		return -EINVAL;
-
-	fib_node = fib4_entry->common.fib_node;
-	list_for_each_entry_from(fib4_entry, &fib_node->entry_list,
-				 common.list) {
-		if (fib4_entry->tb_id != new4_entry->tb_id ||
-		    fib4_entry->tos != new4_entry->tos ||
-		    fib4_entry->prio != new4_entry->prio)
-			break;
-	}
-
-	list_add_tail(&new4_entry->common.list, &fib4_entry->common.list);
-	return 0;
-}
-
-static int
-mlxsw_sp_fib4_node_list_insert(struct mlxsw_sp_fib4_entry *new4_entry,
-			       bool replace, bool append)
-{
-	struct mlxsw_sp_fib_node *fib_node = new4_entry->common.fib_node;
-	struct mlxsw_sp_fib4_entry *fib4_entry;
-
-	fib4_entry = mlxsw_sp_fib4_node_entry_find(fib_node, new4_entry);
-
-	if (append)
-		return mlxsw_sp_fib4_node_list_append(fib4_entry, new4_entry);
-	if (replace && WARN_ON(!fib4_entry))
-		return -EINVAL;
-
-	/* Insert new entry before replaced one, so that we can later
-	 * remove the second.
-	 */
-	if (fib4_entry) {
-		list_add_tail(&new4_entry->common.list,
-			      &fib4_entry->common.list);
-	} else {
-		struct mlxsw_sp_fib4_entry *last;
-
-		list_for_each_entry(last, &fib_node->entry_list, common.list) {
-			if (new4_entry->tb_id > last->tb_id)
-				break;
-			fib4_entry = last;
-		}
-
-		if (fib4_entry)
-			list_add(&new4_entry->common.list,
-				 &fib4_entry->common.list);
-		else
-			list_add(&new4_entry->common.list,
-				 &fib_node->entry_list);
-	}
-
-	return 0;
-}
-
-static void
-mlxsw_sp_fib4_node_list_remove(struct mlxsw_sp_fib4_entry *fib4_entry)
-{
-	list_del(&fib4_entry->common.list);
-}
-
 static int mlxsw_sp_fib_node_entry_add(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_fib_entry *fib_entry)
 {
@@ -4912,14 +4823,12 @@ static void mlxsw_sp_fib_node_entry_del(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_fib4_node_entry_link(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_fib4_entry *fib4_entry,
-					 bool replace, bool append)
+					 struct mlxsw_sp_fib4_entry *fib4_entry)
 {
+	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
 	int err;
 
-	err = mlxsw_sp_fib4_node_list_insert(fib4_entry, replace, append);
-	if (err)
-		return err;
+	list_add(&fib4_entry->common.list, &fib_node->entry_list);
 
 	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, &fib4_entry->common);
 	if (err)
@@ -4928,7 +4837,7 @@ static int mlxsw_sp_fib4_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_fib_node_entry_add:
-	mlxsw_sp_fib4_node_list_remove(fib4_entry);
+	list_del(&fib4_entry->common.list);
 	return err;
 }
 
@@ -4937,20 +4846,19 @@ mlxsw_sp_fib4_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib4_entry *fib4_entry)
 {
 	mlxsw_sp_fib_node_entry_del(mlxsw_sp, &fib4_entry->common);
-	mlxsw_sp_fib4_node_list_remove(fib4_entry);
+	list_del(&fib4_entry->common.list);
 
 	if (fib4_entry->common.type == MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP)
 		mlxsw_sp_fib_entry_decap_fini(mlxsw_sp, &fib4_entry->common);
 }
 
 static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib4_entry *fib4_entry,
-					bool replace)
+					struct mlxsw_sp_fib4_entry *fib4_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
 	struct mlxsw_sp_fib4_entry *replaced;
 
-	if (!replace)
+	if (list_is_singular(&fib_node->entry_list))
 		return;
 
 	/* We inserted the new entry before replaced one */
@@ -4962,9 +4870,8 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int
-mlxsw_sp_router_fib4_add(struct mlxsw_sp *mlxsw_sp,
-			 const struct fib_entry_notifier_info *fen_info,
-			 bool replace, bool append)
+mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
+			     const struct fib_entry_notifier_info *fen_info)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry;
 	struct mlxsw_sp_fib_node *fib_node;
@@ -4989,14 +4896,13 @@ mlxsw_sp_router_fib4_add(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib4_entry_create;
 	}
 
-	err = mlxsw_sp_fib4_node_entry_link(mlxsw_sp, fib4_entry, replace,
-					    append);
+	err = mlxsw_sp_fib4_node_entry_link(mlxsw_sp, fib4_entry);
 	if (err) {
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to link FIB entry to node\n");
 		goto err_fib4_node_entry_link;
 	}
 
-	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry, replace);
+	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry);
 
 	return 0;
 
@@ -6094,7 +6000,6 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	struct mlxsw_sp_fib_event_work *fib_work =
 		container_of(work, struct mlxsw_sp_fib_event_work, work);
 	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
-	bool replace, append;
 	int err;
 
 	/* Protect internal structures from changes */
@@ -6102,18 +6007,14 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_ADD:
-		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
-		append = fib_work->event == FIB_EVENT_ENTRY_APPEND;
-		err = mlxsw_sp_router_fib4_add(mlxsw_sp, &fib_work->fen_info,
-					       replace, append);
+	case FIB_EVENT_ENTRY_REPLACE_TMP:
+		err = mlxsw_sp_router_fib4_replace(mlxsw_sp,
+						   &fib_work->fen_info);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_ENTRY_DEL:
+	case FIB_EVENT_ENTRY_DEL_TMP:
 		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
@@ -6210,10 +6111,8 @@ static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event_work *fib_work,
 	struct fib_nh_notifier_info *fnh_info;
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
-	case FIB_EVENT_ENTRY_DEL:
+	case FIB_EVENT_ENTRY_REPLACE_TMP: /* fall through */
+	case FIB_EVENT_ENTRY_DEL_TMP:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
 		fib_work->fen_info = *fen_info;
@@ -6343,9 +6242,9 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		err = mlxsw_sp_router_fib_rule_event(event, info,
 						     router->mlxsw_sp);
 		return notifier_from_errno(err);
-	case FIB_EVENT_ENTRY_ADD:
+	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE_TMP:
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
 			return notifier_from_errno(-EINVAL);
-- 
2.23.0

