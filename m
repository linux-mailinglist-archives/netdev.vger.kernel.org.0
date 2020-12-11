Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0062D7C7F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394392AbgLKRJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:09:30 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36475 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393974AbgLKRHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:07:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 27578B12;
        Fri, 11 Dec 2020 12:05:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=bnrwwkrss26l2M+IhJk5HBV5Z3nV+ObLc564KmeQpGg=; b=jnIp7DSn
        8ZgW79827SNOIjXj3iFZb2hi3/KQYVlIPjqdl9D2lB6ON/QIK9DWHpL+2xpU7ENw
        iPSthZVRSpQh7zgxSieQrhrrO5EuHlwPIrpDxf4WFO5YsvxA37d4ONZJpz19F1vl
        6/7spKfCvGkzQk3D6AKDbGDTWvh5N1vlpC2wUkZyN4vQ9b7QYQ4v9SR5zV1deOaZ
        I+Z8oysRRdGDQpdUpUQiWUKSOB/u9w4d7HMEBg3wzJyESoyjQiHFkw7RLVYjbtCf
        W5jHKwmTHUv8ff3iWxOrtLTL/VN9JRoBMOVjnsxS7LUzETnFU7fGxQo2InNMYY8Y
        jEK1FRFuwEtv1Q==
X-ME-Sender: <xms:1KbTX4Nm-F9J7vWuqnOqaNUIuc_ABDyTxg4f9mU9-66LTqJ1BSUdxA>
    <xme:1KbTX-9zl2t_x6weuRVs_1MxbPPF4Oj2j0UA9Ybp_sR2WmGqAVTZ_BgO-jfcAk5Za
    a7MBJF63FWdcc8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1KbTX_RuWfuxZ8mZOl5YPDr1TTTWrw34D0mFW51-J0K7oxx4wGbJxQ>
    <xmx:1KbTXwviloTGpQ7eXc2YPI01_ACCeYvtW9AnYLZJeogNSyteZDyv_g>
    <xmx:1KbTXwfluyuLkzpZ5rVsN8G-UyP-KnJebqjEhj9rb697r-zZ8gIS9w>
    <xmx:1KbTXxrsRYbD-SQ1YvkeLOC2oX8uvLUZyMa3EkUFzQxJ5BO6D1dInQ>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DFEF1080064;
        Fri, 11 Dec 2020 12:05:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/15] mlxsw: spectrum_router_xm: Implement L-value tracking for M-index
Date:   Fri, 11 Dec 2020 19:04:08 +0200
Message-Id: <20201211170413.2269479-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

There is a table that assigns L-value per M-index. The L is always the
biggest from the currently inserted prefixes. Setup a hashtable to track
the M-index information and the prefixes that are related to it. Ensure
the L-value is always correctly set.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 +
 .../mellanox/mlxsw/spectrum_router_xm.c       | 203 ++++++++++++++++++
 3 files changed, 205 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3b32d9648578..62d51b281b58 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7098,6 +7098,7 @@ static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 		op_ctx->bulk_ok = !list_is_last(&fib_event->list, &fib_event_queue) &&
 				  fib_event->family == next_fib_event->family &&
 				  fib_event->event == next_fib_event->event;
+		op_ctx->event = fib_event->event;
 
 		/* In case family of this and the previous entry are different, context
 		 * reinitialization is going to be needed now, indicate that.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index d6f7aba6eb9c..31612891ad48 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -24,6 +24,7 @@ struct mlxsw_sp_fib_entry_op_ctx {
 			   * the context priv is initialized.
 			   */
 	struct list_head fib_entry_priv_list;
+	unsigned long event;
 	unsigned long ll_priv[];
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
index 966a20f3bc0d..c069092aa5ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/rhashtable.h>
 
 #include "spectrum.h"
 #include "core.h"
@@ -16,14 +17,35 @@ static const u8 mlxsw_sp_router_xm_m_val[] = {
 	[MLXSW_SP_L3_PROTO_IPV6] = 0, /* Currently unused. */
 };
 
+#define MLXSW_SP_ROUTER_XM_L_VAL_MAX 16
+
 struct mlxsw_sp_router_xm {
 	bool ipv4_supported;
 	bool ipv6_supported;
 	unsigned int entries_size;
+	struct rhashtable ltable_ht;
+};
+
+struct mlxsw_sp_router_xm_ltable_node {
+	struct rhash_head ht_node; /* Member of router_xm->ltable_ht */
+	u16 mindex;
+	u8 current_lvalue;
+	refcount_t refcnt;
+	unsigned int lvalue_ref[MLXSW_SP_ROUTER_XM_L_VAL_MAX + 1];
+};
+
+static const struct rhashtable_params mlxsw_sp_router_xm_ltable_ht_params = {
+	.key_offset = offsetof(struct mlxsw_sp_router_xm_ltable_node, mindex),
+	.head_offset = offsetof(struct mlxsw_sp_router_xm_ltable_node, ht_node),
+	.key_len = sizeof(u16),
+	.automatic_shrinking = true,
 };
 
 struct mlxsw_sp_router_xm_fib_entry {
 	bool committed;
+	struct mlxsw_sp_router_xm_ltable_node *ltable_node; /* Parent node */
+	u16 mindex; /* Store for processing from commit op */
+	u8 lvalue;
 };
 
 #define MLXSW_SP_ROUTE_LL_XM_ENTRIES_MAX \
@@ -68,6 +90,20 @@ static int mlxsw_sp_router_ll_xm_raltb_write(struct mlxsw_sp *mlxsw_sp, char *xr
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xraltb), xraltb_pl);
 }
 
+static u16 mlxsw_sp_router_ll_xm_mindex_get4(const u32 addr)
+{
+	/* Currently the M-index is set to linear mode. That means it is defined
+	 * as 16 MSB of IP address.
+	 */
+	return addr >> MLXSW_SP_ROUTER_XM_L_VAL_MAX;
+}
+
+static u16 mlxsw_sp_router_ll_xm_mindex_get6(const unsigned char *addr)
+{
+	WARN_ON_ONCE(1);
+	return 0; /* currently unused */
+}
+
 static void mlxsw_sp_router_ll_xm_op_ctx_check_init(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 						    struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
 {
@@ -114,11 +150,13 @@ static void mlxsw_sp_router_ll_xm_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ct
 		len = mlxsw_reg_xmdr_c_ltr_pack4(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
 						 op_ctx_xm->entries_count, xmdr_c_ltr_op,
 						 virtual_router, prefix_len, (u32 *) addr);
+		fib_entry->mindex = mlxsw_sp_router_ll_xm_mindex_get4(*((u32 *) addr));
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
 		len = mlxsw_reg_xmdr_c_ltr_pack6(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
 						 op_ctx_xm->entries_count, xmdr_c_ltr_op,
 						 virtual_router, prefix_len, addr);
+		fib_entry->mindex = mlxsw_sp_router_ll_xm_mindex_get6(addr);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -130,6 +168,9 @@ static void mlxsw_sp_router_ll_xm_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ct
 		WARN_ON_ONCE(op_ctx_xm->trans_item_len != len);
 
 	op_ctx_xm->entries[op_ctx_xm->entries_count] = fib_entry;
+
+	fib_entry->lvalue = prefix_len > mlxsw_sp_router_xm_m_val[proto] ?
+			       prefix_len - mlxsw_sp_router_xm_m_val[proto] : 0;
 }
 
 static void
@@ -172,6 +213,147 @@ mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_op_
 						tunnel_ptr);
 }
 
+static struct mlxsw_sp_router_xm_ltable_node *
+mlxsw_sp_router_xm_ltable_node_get(struct mlxsw_sp_router_xm *router_xm, u16 mindex)
+{
+	struct mlxsw_sp_router_xm_ltable_node *ltable_node;
+	int err;
+
+	ltable_node = rhashtable_lookup_fast(&router_xm->ltable_ht, &mindex,
+					     mlxsw_sp_router_xm_ltable_ht_params);
+	if (ltable_node) {
+		refcount_inc(&ltable_node->refcnt);
+		return ltable_node;
+	}
+	ltable_node = kzalloc(sizeof(*ltable_node), GFP_KERNEL);
+	if (!ltable_node)
+		return ERR_PTR(-ENOMEM);
+	ltable_node->mindex = mindex;
+	refcount_set(&ltable_node->refcnt, 1);
+
+	err = rhashtable_insert_fast(&router_xm->ltable_ht, &ltable_node->ht_node,
+				     mlxsw_sp_router_xm_ltable_ht_params);
+	if (err)
+		goto err_insert;
+
+	return ltable_node;
+
+err_insert:
+	kfree(ltable_node);
+	return ERR_PTR(err);
+}
+
+static void mlxsw_sp_router_xm_ltable_node_put(struct mlxsw_sp_router_xm *router_xm,
+					       struct mlxsw_sp_router_xm_ltable_node *ltable_node)
+{
+	if (!refcount_dec_and_test(&ltable_node->refcnt))
+		return;
+	rhashtable_remove_fast(&router_xm->ltable_ht, &ltable_node->ht_node,
+			       mlxsw_sp_router_xm_ltable_ht_params);
+	kfree(ltable_node);
+}
+
+static int mlxsw_sp_router_xm_ltable_lvalue_set(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_router_xm_ltable_node *ltable_node)
+{
+	char xrmt_pl[MLXSW_REG_XRMT_LEN];
+
+	mlxsw_reg_xrmt_pack(xrmt_pl, ltable_node->mindex, ltable_node->current_lvalue);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xrmt), xrmt_pl);
+}
+
+static int
+mlxsw_sp_router_xm_ml_entry_add(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_router_xm_fib_entry *fib_entry)
+{
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+	struct mlxsw_sp_router_xm_ltable_node *ltable_node;
+	u8 lvalue = fib_entry->lvalue;
+	int err;
+
+	ltable_node = mlxsw_sp_router_xm_ltable_node_get(router_xm,
+							 fib_entry->mindex);
+	if (IS_ERR(ltable_node))
+		return PTR_ERR(ltable_node);
+	if (lvalue > ltable_node->current_lvalue) {
+		/* The L-value is bigger then the one currently set, update. */
+		ltable_node->current_lvalue = lvalue;
+		err = mlxsw_sp_router_xm_ltable_lvalue_set(mlxsw_sp,
+							   ltable_node);
+		if (err)
+			goto err_lvalue_set;
+	}
+
+	ltable_node->lvalue_ref[lvalue]++;
+	fib_entry->ltable_node = ltable_node;
+	return 0;
+
+err_lvalue_set:
+	mlxsw_sp_router_xm_ltable_node_put(router_xm, ltable_node);
+	return err;
+}
+
+static void
+mlxsw_sp_router_xm_ml_entry_del(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_router_xm_fib_entry *fib_entry)
+{
+	struct mlxsw_sp_router_xm_ltable_node *ltable_node =
+							fib_entry->ltable_node;
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+	u8 lvalue = fib_entry->lvalue;
+
+	ltable_node->lvalue_ref[lvalue]--;
+	if (lvalue == ltable_node->current_lvalue && lvalue &&
+	    !ltable_node->lvalue_ref[lvalue]) {
+		u8 new_lvalue = lvalue - 1;
+
+		/* Find the biggest L-value left out there. */
+		while (new_lvalue > 0 && !ltable_node->lvalue_ref[lvalue])
+			new_lvalue--;
+
+		ltable_node->current_lvalue = new_lvalue;
+		mlxsw_sp_router_xm_ltable_lvalue_set(mlxsw_sp, ltable_node);
+	}
+	mlxsw_sp_router_xm_ltable_node_put(router_xm, ltable_node);
+}
+
+static int
+mlxsw_sp_router_xm_ml_entries_add(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
+{
+	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
+	int err;
+	int i;
+
+	for (i = 0; i < op_ctx_xm->entries_count; i++) {
+		fib_entry = op_ctx_xm->entries[i];
+		err = mlxsw_sp_router_xm_ml_entry_add(mlxsw_sp, fib_entry);
+		if (err)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	for (i--; i >= 0; i--) {
+		fib_entry = op_ctx_xm->entries[i];
+		mlxsw_sp_router_xm_ml_entry_del(mlxsw_sp, fib_entry);
+	}
+	return err;
+}
+
+static void
+mlxsw_sp_router_xm_ml_entries_del(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
+{
+	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
+	int i;
+
+	for (i = 0; i < op_ctx_xm->entries_count; i++) {
+		fib_entry = op_ctx_xm->entries[i];
+		mlxsw_sp_router_xm_ml_entry_del(mlxsw_sp, fib_entry);
+	}
+}
+
 static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 						  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 						  bool *postponed_for_bulk)
@@ -197,6 +379,15 @@ static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	}
 
+	if (op_ctx->event == FIB_EVENT_ENTRY_REPLACE) {
+		/* The L-table is updated inside. It has to be done before
+		 * the prefix is inserted.
+		 */
+		err = mlxsw_sp_router_xm_ml_entries_add(mlxsw_sp, op_ctx_xm);
+		if (err)
+			goto out;
+	}
+
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xmdr), op_ctx_xm->xmdr_pl);
 	if (err)
 		goto out;
@@ -217,6 +408,12 @@ static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 		}
 	}
 
+	if (op_ctx->event == FIB_EVENT_ENTRY_DEL)
+		/* The L-table is updated inside. It has to be done after
+		 * the prefix was removed.
+		 */
+		mlxsw_sp_router_xm_ml_entries_del(mlxsw_sp, op_ctx_xm);
+
 out:
 	/* Next pack call is going to do reinitialization */
 	op_ctx->initialized = false;
@@ -289,9 +486,14 @@ int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_rxltm_write;
 
+	err = rhashtable_init(&router_xm->ltable_ht, &mlxsw_sp_router_xm_ltable_ht_params);
+	if (err)
+		goto err_ltable_ht_init;
+
 	mlxsw_sp->router->xm = router_xm;
 	return 0;
 
+err_ltable_ht_init:
 err_rxltm_write:
 err_mindex_size_check:
 err_device_id_check:
@@ -307,5 +509,6 @@ void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->bus_info->xm_exists)
 		return;
 
+	rhashtable_destroy(&router_xm->ltable_ht);
 	kfree(router_xm);
 }
-- 
2.29.2

