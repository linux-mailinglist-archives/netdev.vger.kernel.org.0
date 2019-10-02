Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6443FC49C6
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfJBIlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56415 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbfJBIln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 76B842071B;
        Wed,  2 Oct 2019 04:41:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=H8j3MnfVGbPfVCPqO+m9F7a8P2wNnyUkyVDuiTAGzHA=; b=r4lMoIL7
        ovaCWiy0r8CScfpIXP//AHtaPo9KQhALD+2hGtyCTQyk1t8mSyPJpq4Z/pcE6pB0
        i8oZ5XtIwHIoWV+nH9BFBM36KnS8qJq3kireI7Drspl2MGCQCScd+92ak0EVs7bp
        E2txRiDk4yDfq5ccnX4DJhXqXVCWC9qhEc02PQmDBSGLrbLxW1tnq2hC3C8QM2fW
        fd1IvTlel33ympJL9m4HnhKaW8uaxzJ4H79KMN2zv+PuLqMiNaUMyU0iQXJndzoS
        3lQiGltzy4ixa/DHh/FhlXF0IWOfMLsmJwAIl6Iv99I7MdSl4k5oYzGF82VIq8TY
        tO/kz3HEE0/zyg==
X-ME-Sender: <xms:xmKUXUezcomF-KHXpYrMyk6W_ocnbE3gI-OrYPoKJ--YgKuQw_Vesg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:xmKUXTsCSuR9LfqzK5wZfyrjyiFh_Qi37OnTFkUxrtWd7mM_jpA2Lg>
    <xmx:xmKUXYLorYcGtNLYINitWwqwd0s1JTWu9E5kCeW8Kq67SShWI2FbFg>
    <xmx:xmKUXfYYQN97E5QVxUKVdowKKxxMCFjAsDogZZgkNDdXlj8MIMrqZw>
    <xmx:xmKUXeDIPg-q6nYHIwbkQXTzIjujel23gR20QL26PWWUVBeXf604bw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D97EAD6005E;
        Wed,  2 Oct 2019 04:41:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 08/15] mlxsw: spectrum_router: Start using new IPv4 route notifications
Date:   Wed,  2 Oct 2019 11:40:56 +0300
Message-Id: <20191002084103.12138-9-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
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
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 134 +++---------------
 1 file changed, 18 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0e99b64450ca..f5514fbae39e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3822,7 +3822,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 
 	key.fib_nh = fib_nh;
 	nh = mlxsw_sp_nexthop_lookup(mlxsw_sp, key);
-	if (WARN_ON_ONCE(!nh))
+	if (!nh)
 		return;
 
 	switch (event) {
@@ -4693,95 +4693,6 @@ static void mlxsw_sp_fib_node_put(struct mlxsw_sp *mlxsw_sp,
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
@@ -4825,14 +4736,12 @@ static void mlxsw_sp_fib_node_entry_del(struct mlxsw_sp *mlxsw_sp,
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
@@ -4841,7 +4750,7 @@ static int mlxsw_sp_fib4_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_fib_node_entry_add:
-	mlxsw_sp_fib4_node_list_remove(fib4_entry);
+	list_del(&fib4_entry->common.list);
 	return err;
 }
 
@@ -4850,20 +4759,19 @@ mlxsw_sp_fib4_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
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
@@ -4875,9 +4783,8 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
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
@@ -4902,14 +4809,13 @@ mlxsw_sp_router_fib4_add(struct mlxsw_sp *mlxsw_sp,
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
 
@@ -5997,7 +5903,6 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	struct mlxsw_sp_fib_event_work *fib_work =
 		container_of(work, struct mlxsw_sp_fib_event_work, work);
 	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
-	bool replace, append;
 	int err;
 
 	/* Protect internal structures from changes */
@@ -6005,18 +5910,14 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
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
@@ -6246,9 +6147,10 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		err = mlxsw_sp_router_fib_rule_event(event, info,
 						     router->mlxsw_sp);
 		return notifier_from_errno(err);
-	case FIB_EVENT_ENTRY_ADD:
+	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
 	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE_TMP:
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
 			return notifier_from_errno(-EINVAL);
-- 
2.21.0

