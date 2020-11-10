Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873C32AD2CC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgKJJuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:37 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:41707 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730876AbgKJJuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D2796DC3;
        Tue, 10 Nov 2020 04:50:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=MtCm8Fu8+tpYuE2BMmC/ptF5pleJSEXo0nisauaye/8=; b=RASssUTD
        cxtyVIKeCJ1V3cXyxGNyx7WZhcWQ3MQgAtd0I6Jh1fcnDSSuySodInJt1xqV1gIZ
        rm3qHmgU8vlAiWtFKChe7omcoaq3NSie7wr3I2TWGv9o6F+TV5QEfzH1w0Oe/UHj
        DgiLyqJs8uZBbjwpcQCtEU72J33KQofxTh2CxnOewgkeKGdt9iIFF9at8lk7eTxV
        If5FoPuf/ebMqw5KOsnS04SICnk/fpQBip9lQ6uFgKnXsvofZQ0tviMbZf3nyg0t
        EXeUgisDt/wZzXLWK4Q3LtYo9zgCLZJlhU0J08ounybs4DjvPMdSpvbB0S0sjxfS
        ZUmvhGQdAKFPCw==
X-ME-Sender: <xms:aWKqX83BRTl-CHJYVE_-bhVpPob4CPsnhCWit0t-0QGzxfG7krb0xQ>
    <xme:aWKqX3HOw8UjlxhIPHknMrb43PP93TfQ3nRSXPDlMPFyGWm7txKx7kUuueXViIO9R
    m6faDpzQ2ndYL0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:aWKqX07EZGWyh2qDLad4X9xPLs7ankTifuFV6QiFsSXGNO-O6EjrIA>
    <xmx:aWKqX10VEZXS1zxKcEc8dwOBu4RPDM18NYfMs3t9t_qPGwAw6BjakQ>
    <xmx:aWKqX_Fqd2Wh5Y-rAXKuDuVAw2SVfp_Pp6xvLj31vE2I1RmtAf_HRQ>
    <xmx:aWKqX0SFcCA-SE1nnfiOmYnPNz0RjRLit2VpkRH-Ozru_SfM6zgz3A>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 304243280068;
        Tue, 10 Nov 2020 04:50:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/15] mlxsw: spectrum_router: Have FIB entry op context allocated for the instance
Date:   Tue, 10 Nov 2020 11:48:57 +0200
Message-Id: <20201110094900.1920158-13-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Get the max size needed for FIB entry op context and allocate it once
for the instance. Use it repeatedly from the scheduled work.
By this, allow to extend the context to hold more data than it is wise
to do when it was on the stack. Make sure to signalize that the context
needs to be initialized in case families of subsequent FIB entries differ.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 120 ++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  24 +++-
 2 files changed, 114 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 39c04e45f253..43a4b6a34940 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4307,6 +4307,10 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+struct mlxsw_sp_fib_entry_op_ctx_basic {
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
+};
+
 static void
 mlxsw_sp_router_ll_basic_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					enum mlxsw_sp_l3proto proto,
@@ -4314,8 +4318,9 @@ mlxsw_sp_router_ll_basic_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx
 					u16 virtual_router, u8 prefix_len,
 					unsigned char *addr)
 {
+	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
 	enum mlxsw_reg_ralxx_protocol ralxx_proto;
-	char *ralue_pl = op_ctx->ralue_pl;
+	char *ralue_pl = op_ctx_basic->ralue_pl;
 	enum mlxsw_reg_ralue_op ralue_op;
 
 	ralxx_proto = (enum mlxsw_reg_ralxx_protocol) proto;
@@ -4349,8 +4354,10 @@ mlxsw_sp_router_ll_basic_fib_entry_act_remote_pack(struct mlxsw_sp_fib_entry_op_
 						   enum mlxsw_reg_ralue_trap_action trap_action,
 						   u16 trap_id, u32 adjacency_index, u16 ecmp_size)
 {
-	mlxsw_reg_ralue_act_remote_pack(op_ctx->ralue_pl, trap_action, trap_id,
-					adjacency_index, ecmp_size);
+	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_ralue_act_remote_pack(op_ctx_basic->ralue_pl, trap_action,
+					trap_id, adjacency_index, ecmp_size);
 }
 
 static void
@@ -4358,27 +4365,37 @@ mlxsw_sp_router_ll_basic_fib_entry_act_local_pack(struct mlxsw_sp_fib_entry_op_c
 						  enum mlxsw_reg_ralue_trap_action trap_action,
 						  u16 trap_id, u16 local_erif)
 {
-	mlxsw_reg_ralue_act_local_pack(op_ctx->ralue_pl, trap_action, trap_id, local_erif);
+	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_ralue_act_local_pack(op_ctx_basic->ralue_pl, trap_action,
+				       trap_id, local_erif);
 }
 
 static void
 mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
 {
-	mlxsw_reg_ralue_act_ip2me_pack(op_ctx->ralue_pl);
+	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_ralue_act_ip2me_pack(op_ctx_basic->ralue_pl);
 }
 
 static void
 mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 						      u32 tunnel_ptr)
 {
-	mlxsw_reg_ralue_act_ip2me_tun_pack(op_ctx->ralue_pl, tunnel_ptr);
+	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_ralue_act_ip2me_tun_pack(op_ctx_basic->ralue_pl, tunnel_ptr);
 }
 
 static int
 mlxsw_sp_router_ll_basic_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
 {
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), op_ctx->ralue_pl);
+	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue),
+			       op_ctx_basic->ralue_pl);
 }
 
 static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
@@ -4615,9 +4632,10 @@ static int __mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
+	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
 
-	return __mlxsw_sp_fib_entry_update(mlxsw_sp, &op_ctx, fib_entry);
+	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
+	return __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry);
 }
 
 static int mlxsw_sp_fib_entry_del(struct mlxsw_sp *mlxsw_sp,
@@ -5012,9 +5030,10 @@ static void __mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 					   struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
+	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
 
-	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &op_ctx, fib_entry);
+	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
+	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, fib_entry);
 }
 
 static bool mlxsw_sp_fib4_allow_replace(struct mlxsw_sp_fib4_entry *fib4_entry)
@@ -5793,19 +5812,20 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 		return err;
 
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
+		struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
 		struct mlxsw_sp_vr *vr = &mlxsw_sp->router->vrs[i];
-		struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
 		char xraltb_pl[MLXSW_REG_XRALTB_LEN];
 
+		mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
 		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, ralxx_proto, tree_id);
 		err = ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
 		if (err)
 			return err;
 
-		ll_ops->fib_entry_pack(&op_ctx, proto, MLXSW_SP_FIB_ENTRY_OP_WRITE,
+		ll_ops->fib_entry_pack(op_ctx, proto, MLXSW_SP_FIB_ENTRY_OP_WRITE,
 				       vr->id, 0, NULL);
-		ll_ops->fib_entry_act_ip2me_pack(&op_ctx);
-		err = ll_ops->fib_entry_commit(mlxsw_sp, &op_ctx);
+		ll_ops->fib_entry_act_ip2me_pack(op_ctx);
+		err = ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 		if (err)
 			return err;
 	}
@@ -6092,7 +6112,6 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 {
 	int err;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_event->event) {
@@ -6112,7 +6131,6 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 		fib_info_put(fib_event->fnh_info.fib_nh->nh_parent);
 		break;
 	}
-	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
@@ -6121,7 +6139,6 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 {
 	int err;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_event->event) {
@@ -6145,7 +6162,6 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	}
-	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
@@ -6189,16 +6205,23 @@ static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 {
 	struct mlxsw_sp_router *router = container_of(work, struct mlxsw_sp_router, fib_event_work);
-	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
+	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = router->ll_op_ctx;
 	struct mlxsw_sp *mlxsw_sp = router->mlxsw_sp;
 	struct mlxsw_sp_fib_event *next_fib_event;
 	struct mlxsw_sp_fib_event *fib_event;
+	int last_family = AF_UNSPEC;
 	LIST_HEAD(fib_event_queue);
 
 	spin_lock_bh(&router->fib_event_queue_lock);
 	list_splice_init(&router->fib_event_queue, &fib_event_queue);
 	spin_unlock_bh(&router->fib_event_queue_lock);
 
+	/* Router lock is held here to make sure per-instance
+	 * operation context is not used in between FIB4/6 events
+	 * processing.
+	 */
+	mutex_lock(&router->lock);
+	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
 	list_for_each_entry_safe(fib_event, next_fib_event,
 				 &fib_event_queue, list) {
 		/* Check if the next entry in the queue exists and it is
@@ -6206,30 +6229,46 @@ static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 		 * In that case it is permitted to do the bulking
 		 * of multiple FIB entries to a single register write.
 		 */
-		op_ctx.bulk_ok = !list_is_last(&fib_event->list, &fib_event_queue) &&
-				 fib_event->family == next_fib_event->family &&
-				 fib_event->event == next_fib_event->event;
+		op_ctx->bulk_ok = !list_is_last(&fib_event->list, &fib_event_queue) &&
+				  fib_event->family == next_fib_event->family &&
+				  fib_event->event == next_fib_event->event;
+
+		/* In case family of this and the previous entry are different, context
+		 * reinitialization is going to be needed now, indicate that.
+		 * Note that since last_family is initialized to AF_UNSPEC, this is always
+		 * going to happen for the first entry processed in the work.
+		 */
+		if (fib_event->family != last_family)
+			op_ctx->initialized = false;
 
 		switch (fib_event->family) {
 		case AF_INET:
-			mlxsw_sp_router_fib4_event_process(mlxsw_sp, &op_ctx,
+			mlxsw_sp_router_fib4_event_process(mlxsw_sp, op_ctx,
 							   fib_event);
 			break;
 		case AF_INET6:
-			mlxsw_sp_router_fib6_event_process(mlxsw_sp, &op_ctx,
+			mlxsw_sp_router_fib6_event_process(mlxsw_sp, op_ctx,
 							   fib_event);
 			break;
 		case RTNL_FAMILY_IP6MR:
 		case RTNL_FAMILY_IPMR:
+			/* Unlock here as inside FIBMR the lock is taken again
+			 * under RTNL. The per-instance operation context
+			 * is not used by FIBMR.
+			 */
+			mutex_unlock(&router->lock);
 			mlxsw_sp_router_fibmr_event_process(mlxsw_sp,
 							    fib_event);
+			mutex_lock(&router->lock);
 			break;
 		default:
 			WARN_ON_ONCE(1);
 		}
+		last_family = fib_event->family;
 		kfree(fib_event);
 		cond_resched();
 	}
+	mutex_unlock(&router->lock);
 }
 
 static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event *fib_event,
@@ -8213,6 +8252,7 @@ static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
 	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
 	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
 	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
+	.fib_entry_op_ctx_size = sizeof(struct mlxsw_sp_fib_entry_op_ctx_basic),
 	.fib_entry_pack = mlxsw_sp_router_ll_basic_fib_entry_pack,
 	.fib_entry_act_remote_pack = mlxsw_sp_router_ll_basic_fib_entry_act_remote_pack,
 	.fib_entry_act_local_pack = mlxsw_sp_router_ll_basic_fib_entry_act_local_pack,
@@ -8221,6 +8261,29 @@ static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
 	.fib_entry_commit = mlxsw_sp_router_ll_basic_fib_entry_commit,
 };
 
+static int mlxsw_sp_router_ll_op_ctx_init(struct mlxsw_sp_router *router)
+{
+	size_t max_size = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP_L3_PROTO_MAX; i++) {
+		size_t size = router->proto_ll_ops[i]->fib_entry_op_ctx_size;
+
+		if (size > max_size)
+			max_size = size;
+	}
+	router->ll_op_ctx = kzalloc(sizeof(*router->ll_op_ctx) + max_size,
+				    GFP_KERNEL);
+	if (!router->ll_op_ctx)
+		return -ENOMEM;
+	return 0;
+}
+
+static void mlxsw_sp_router_ll_op_ctx_fini(struct mlxsw_sp_router *router)
+{
+	kfree(router->ll_op_ctx);
+}
+
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack)
 {
@@ -8237,6 +8300,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
 
+	err = mlxsw_sp_router_ll_op_ctx_init(router);
+	if (err)
+		goto err_ll_op_ctx_init;
+
 	INIT_LIST_HEAD(&mlxsw_sp->router->nexthop_neighs_list);
 	err = __mlxsw_sp_router_init(mlxsw_sp);
 	if (err)
@@ -8343,6 +8410,8 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_rifs_init:
 	__mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
+	mlxsw_sp_router_ll_op_ctx_fini(router);
+err_ll_op_ctx_init:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 	return err;
@@ -8366,6 +8435,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_ipips_fini(mlxsw_sp);
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
+	mlxsw_sp_router_ll_op_ctx_fini(mlxsw_sp->router);
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 859a5c5d51d0..9db1e3da0e0c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -15,6 +15,23 @@ struct mlxsw_sp_router_nve_decap {
 	u8 valid:1;
 };
 
+struct mlxsw_sp_fib_entry_op_ctx {
+	u8 bulk_ok:1, /* Indicate to the low-level op it is ok to bulk
+		       * the actual entry with the one that is the next
+		       * in queue.
+		       */
+	   initialized:1; /* Bit that the low-level op sets in case
+			   * the context priv is initialized.
+			   */
+	unsigned long ll_priv[];
+};
+
+static inline void
+mlxsw_sp_fib_entry_op_ctx_clear(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
+{
+	memset(op_ctx, 0, sizeof(*op_ctx));
+}
+
 struct mlxsw_sp_router {
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif **rifs;
@@ -53,6 +70,7 @@ struct mlxsw_sp_router {
 	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
 	/* One set of ops for each protocol: IPv4 and IPv6 */
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
+	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
 };
 
 enum mlxsw_sp_fib_entry_op {
@@ -60,11 +78,6 @@ enum mlxsw_sp_fib_entry_op {
 	MLXSW_SP_FIB_ENTRY_OP_DELETE,
 };
 
-struct mlxsw_sp_fib_entry_op_ctx {
-	u8 bulk_ok:1;
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
-};
-
 /* Low-level router ops. Basically this is to handle the different
  * register sets to work with ordinary and XM trees and FIB entries.
  */
@@ -72,6 +85,7 @@ struct mlxsw_sp_router_ll_ops {
 	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
 	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
+	size_t fib_entry_op_ctx_size;
 	void (*fib_entry_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			       enum mlxsw_sp_l3proto proto, enum mlxsw_sp_fib_entry_op op,
 			       u16 virtual_router, u8 prefix_len, unsigned char *addr);
-- 
2.26.2

