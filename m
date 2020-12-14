Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC92D9773
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437839AbgLNLca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:32:30 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44727 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437700AbgLNLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:31:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B43865C0062;
        Mon, 14 Dec 2020 06:31:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=CtMUIT84WUPYHfAsaFLG5bZb/gVZ25+d/yC+rTqb9UI=; b=Sq083ZrE
        MfXBxDe48oAoScScTaFrB6eueX6tl6dX5pO2f3Z8+P265e0kgzr4er8pZZcC9yKx
        NaDMXxJBlwWg8pRK/8LqQO6wBFxDv71XvJpzSZSlmS5CqOSP/2fSIk2Od7ojInmX
        9wmcfvF9Tkfb6k0i0oiROVyLLggiyWUTr9vCFeymzZZyxuEQnyFy6zvoXwW7KI17
        hsVwCv1UT76TkCfsU64ccHZCGFVGx+FUcrMKdxqlHi9UadRhaAY7qfTXnaKZ1tx4
        sQWhUC99dBkUkd19H1i4QA3Eq9jca0Ir270x5VqKKo0aphAgAJabsDWBE+s1OVGY
        iEiOdSC8ogSAuQ==
X-ME-Sender: <xms:-EzXX0aikoA3rHWKvJc3r9yZF3se0ko3bgUr8uzU1E9ezLHlPJCVQA>
    <xme:-EzXX_YXuBAZAOmU4tyLymKAuGQZR5OOvJO21f6OslRwkwgmyVxXWrDiqVUy-EdiQ
    RdPAjiIT1TIrG0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-EzXX--PEeYH6jK5jTrTcIsVO1n33fGcJ18nfmQo_DpMQC3VbWP7kw>
    <xmx:-EzXX-puAvTtKhlkW6DSRJTmi-7Nf_MoCwTgI32lRmIk_44NJ8_xbg>
    <xmx:-EzXX_o5q3zsA6ZB1dgl-xj4RQySdiog7PhP4XAxpAZjpzv7hY4W8g>
    <xmx:-EzXX23MAc-7g4cU-dXEzEdvyxF3RvEi2glJdEtDrCi-cwrPDRpGNg>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9414B1080059;
        Mon, 14 Dec 2020 06:31:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 03/15] mlxsw: spectrum_router: Introduce XM implementation of router low-level ops
Date:   Mon, 14 Dec 2020 13:30:29 +0200
Message-Id: <20201214113041.2789043-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In order to offload entries to XM, implement a set of low-level
functions to work with LPM trees in XM and also to pack and write
FIB entries into XM.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  11 +
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   4 +
 .../mellanox/mlxsw/spectrum_router_xm.c       | 234 ++++++++++++++++++
 4 files changed, 250 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index 892724380ea2..f545fd2c5896 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -15,6 +15,7 @@ mlxsw_switchx2-objs		:= switchx2.o
 obj-$(CONFIG_MLXSW_SPECTRUM)	+= mlxsw_spectrum.o
 mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_switchdev.o spectrum_router.o \
+				   spectrum_router_xm.o \
 				   spectrum1_kvdl.o spectrum2_kvdl.o \
 				   spectrum_kvdl.o \
 				   spectrum_acl_tcam.o spectrum_acl_ctcam.o \
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d671d961fc33..f132fa6cf7b7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -477,6 +477,12 @@ struct mlxsw_sp_vr {
 	refcount_t ul_rif_refcnt;
 };
 
+static int mlxsw_sp_router_ll_basic_init(struct mlxsw_sp *mlxsw_sp, u16 vr_id,
+					 enum mlxsw_sp_l3proto proto)
+{
+	return 0;
+}
+
 static int mlxsw_sp_router_ll_basic_ralta_write(struct mlxsw_sp *mlxsw_sp, char *xralta_pl)
 {
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta),
@@ -506,6 +512,10 @@ static struct mlxsw_sp_fib *mlxsw_sp_fib_create(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib *fib;
 	int err;
 
+	err = ll_ops->init(mlxsw_sp, vr->id, proto);
+	if (err)
+		return ERR_PTR(err);
+
 	lpm_tree = mlxsw_sp->router->lpm.proto_trees[proto];
 	fib = kzalloc(sizeof(*fib), GFP_KERNEL);
 	if (!fib)
@@ -9122,6 +9132,7 @@ static void __mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 }
 
 static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
+	.init = mlxsw_sp_router_ll_basic_init,
 	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
 	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
 	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index d8aed866af21..fe1b92110844 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -94,6 +94,8 @@ enum mlxsw_sp_fib_entry_op {
  * register sets to work with ordinary and XM trees and FIB entries.
  */
 struct mlxsw_sp_router_ll_ops {
+	int (*init)(struct mlxsw_sp *mlxsw_sp, u16 vr_id,
+		    enum mlxsw_sp_l3proto proto);
 	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
 	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
@@ -219,4 +221,6 @@ static inline bool mlxsw_sp_l3addr_eq(const union mlxsw_sp_l3addr *addr1,
 int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
 
+extern const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops;
+
 #endif /* _MLXSW_ROUTER_H_*/
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
new file mode 100644
index 000000000000..f5b4c0edf99d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Mellanox Technologies. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#include "spectrum.h"
+#include "core.h"
+#include "reg.h"
+#include "spectrum_router.h"
+
+struct mlxsw_sp_router_xm_fib_entry {
+	bool committed;
+};
+
+#define MLXSW_SP_ROUTE_LL_XM_ENTRIES_MAX \
+	(MLXSW_REG_XMDR_TRANS_LEN / MLXSW_REG_XMDR_C_LT_ROUTE_V4_LEN)
+
+struct mlxsw_sp_fib_entry_op_ctx_xm {
+	bool initialized;
+	char xmdr_pl[MLXSW_REG_XMDR_LEN];
+	unsigned int trans_offset; /* Offset of the current command within one
+				    * transaction of XMDR register.
+				    */
+	unsigned int trans_item_len; /* The current command length. This is used
+				      * to advance 'trans_offset' when the next
+				      * command is appended.
+				      */
+	unsigned int entries_count;
+	struct mlxsw_sp_router_xm_fib_entry *entries[MLXSW_SP_ROUTE_LL_XM_ENTRIES_MAX];
+};
+
+static int mlxsw_sp_router_ll_xm_init(struct mlxsw_sp *mlxsw_sp, u16 vr_id,
+				      enum mlxsw_sp_l3proto proto)
+{
+	char rxlte_pl[MLXSW_REG_RXLTE_LEN];
+
+	mlxsw_reg_rxlte_pack(rxlte_pl, vr_id,
+			     (enum mlxsw_reg_rxlte_protocol) proto, true);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rxlte), rxlte_pl);
+}
+
+static int mlxsw_sp_router_ll_xm_ralta_write(struct mlxsw_sp *mlxsw_sp, char *xralta_pl)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xralta), xralta_pl);
+}
+
+static int mlxsw_sp_router_ll_xm_ralst_write(struct mlxsw_sp *mlxsw_sp, char *xralst_pl)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xralst), xralst_pl);
+}
+
+static int mlxsw_sp_router_ll_xm_raltb_write(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xraltb), xraltb_pl);
+}
+
+static void mlxsw_sp_router_ll_xm_op_ctx_check_init(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						    struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
+{
+	if (op_ctx->initialized)
+		return;
+	op_ctx->initialized = true;
+
+	mlxsw_reg_xmdr_pack(op_ctx_xm->xmdr_pl, true);
+	op_ctx_xm->trans_offset = 0;
+	op_ctx_xm->entries_count = 0;
+}
+
+static void mlxsw_sp_router_ll_xm_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						 enum mlxsw_sp_l3proto proto,
+						 enum mlxsw_sp_fib_entry_op op,
+						 u16 virtual_router, u8 prefix_len,
+						 unsigned char *addr,
+						 struct mlxsw_sp_fib_entry_priv *priv)
+{
+	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
+	struct mlxsw_sp_router_xm_fib_entry *fib_entry = (void *) priv->priv;
+	enum mlxsw_reg_xmdr_c_ltr_op xmdr_c_ltr_op;
+	unsigned int len;
+
+	mlxsw_sp_router_ll_xm_op_ctx_check_init(op_ctx, op_ctx_xm);
+
+	switch (op) {
+	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
+		xmdr_c_ltr_op = MLXSW_REG_XMDR_C_LTR_OP_WRITE;
+		break;
+	case MLXSW_SP_FIB_ENTRY_OP_UPDATE:
+		xmdr_c_ltr_op = MLXSW_REG_XMDR_C_LTR_OP_UPDATE;
+		break;
+	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
+		xmdr_c_ltr_op = MLXSW_REG_XMDR_C_LTR_OP_DELETE;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	switch (proto) {
+	case MLXSW_SP_L3_PROTO_IPV4:
+		len = mlxsw_reg_xmdr_c_ltr_pack4(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
+						 op_ctx_xm->entries_count, xmdr_c_ltr_op,
+						 virtual_router, prefix_len, (u32 *) addr);
+		break;
+	case MLXSW_SP_L3_PROTO_IPV6:
+		len = mlxsw_reg_xmdr_c_ltr_pack6(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
+						 op_ctx_xm->entries_count, xmdr_c_ltr_op,
+						 virtual_router, prefix_len, addr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+	if (!op_ctx_xm->trans_offset)
+		op_ctx_xm->trans_item_len = len;
+	else
+		WARN_ON_ONCE(op_ctx_xm->trans_item_len != len);
+
+	op_ctx_xm->entries[op_ctx_xm->entries_count] = fib_entry;
+}
+
+static void
+mlxsw_sp_router_ll_xm_fib_entry_act_remote_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						enum mlxsw_reg_ralue_trap_action trap_action,
+						u16 trap_id, u32 adjacency_index, u16 ecmp_size)
+{
+	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_xmdr_c_ltr_act_remote_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
+					     trap_action, trap_id, adjacency_index, ecmp_size);
+}
+
+static void
+mlxsw_sp_router_ll_xm_fib_entry_act_local_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					      enum mlxsw_reg_ralue_trap_action trap_action,
+					       u16 trap_id, u16 local_erif)
+{
+	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_xmdr_c_ltr_act_local_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
+					    trap_action, trap_id, local_erif);
+}
+
+static void
+mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
+{
+	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_xmdr_c_ltr_act_ip2me_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset);
+}
+
+static void
+mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						   u32 tunnel_ptr)
+{
+	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
+
+	mlxsw_reg_xmdr_c_ltr_act_ip2me_tun_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
+						tunnel_ptr);
+}
+
+static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
+						  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						  bool *postponed_for_bulk)
+{
+	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
+	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
+	u8 num_rec;
+	int err;
+	int i;
+
+	op_ctx_xm->trans_offset += op_ctx_xm->trans_item_len;
+	op_ctx_xm->entries_count++;
+
+	/* Check if bulking is possible and there is still room for another
+	 * FIB entry record. The size of 'trans_item_len' is either size of IPv4
+	 * command or size of IPv6 command. Not possible to mix those in a
+	 * single XMDR write.
+	 */
+	if (op_ctx->bulk_ok &&
+	    op_ctx_xm->trans_offset + op_ctx_xm->trans_item_len <= MLXSW_REG_XMDR_TRANS_LEN) {
+		if (postponed_for_bulk)
+			*postponed_for_bulk = true;
+		return 0;
+	}
+
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xmdr), op_ctx_xm->xmdr_pl);
+	if (err)
+		goto out;
+	num_rec = mlxsw_reg_xmdr_num_rec_get(op_ctx_xm->xmdr_pl);
+	if (num_rec > op_ctx_xm->entries_count) {
+		dev_err(mlxsw_sp->bus_info->dev, "Invalid XMDR number of records\n");
+		err = -EIO;
+		goto out;
+	}
+	for (i = 0; i < num_rec; i++) {
+		if (!mlxsw_reg_xmdr_reply_vect_get(op_ctx_xm->xmdr_pl, i)) {
+			dev_err(mlxsw_sp->bus_info->dev, "Command send over XMDR failed\n");
+			err = -EIO;
+			goto out;
+		} else {
+			fib_entry = op_ctx_xm->entries[i];
+			fib_entry->committed = true;
+		}
+	}
+
+out:
+	/* Next pack call is going to do reinitialization */
+	op_ctx->initialized = false;
+	return err;
+}
+
+static bool mlxsw_sp_router_ll_xm_fib_entry_is_committed(struct mlxsw_sp_fib_entry_priv *priv)
+{
+	struct mlxsw_sp_router_xm_fib_entry *fib_entry = (void *) priv->priv;
+
+	return fib_entry->committed;
+}
+
+const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops = {
+	.init = mlxsw_sp_router_ll_xm_init,
+	.ralta_write = mlxsw_sp_router_ll_xm_ralta_write,
+	.ralst_write = mlxsw_sp_router_ll_xm_ralst_write,
+	.raltb_write = mlxsw_sp_router_ll_xm_raltb_write,
+	.fib_entry_op_ctx_size = sizeof(struct mlxsw_sp_fib_entry_op_ctx_xm),
+	.fib_entry_priv_size = sizeof(struct mlxsw_sp_router_xm_fib_entry),
+	.fib_entry_pack = mlxsw_sp_router_ll_xm_fib_entry_pack,
+	.fib_entry_act_remote_pack = mlxsw_sp_router_ll_xm_fib_entry_act_remote_pack,
+	.fib_entry_act_local_pack = mlxsw_sp_router_ll_xm_fib_entry_act_local_pack,
+	.fib_entry_act_ip2me_pack = mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_pack,
+	.fib_entry_act_ip2me_tun_pack = mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_tun_pack,
+	.fib_entry_commit = mlxsw_sp_router_ll_xm_fib_entry_commit,
+	.fib_entry_is_committed = mlxsw_sp_router_ll_xm_fib_entry_is_committed,
+};
-- 
2.29.2

