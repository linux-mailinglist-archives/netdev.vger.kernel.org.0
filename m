Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F242AD2C7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgKJJu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:28 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52863 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730209AbgKJJuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2FEE8E08;
        Tue, 10 Nov 2020 04:50:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jD9noV40odXofwL5g939LNtJBSstCkliXYzfnO0JoKo=; b=G/msqlJp
        BgjUpwFhF/+dmjtVAf/9NTLhAsf2M2ZjdQcc3Fx3N+Rs5g/H40Jr32bCDUiYiGF7
        G1zKcxt4BllHGZqGHL21p2bnCsErzQOHRaKgPcwgMdGBnidZwHFDnD9V5ChQjEQG
        muEg2OmRdWhbKcwQ0ObvuV6cFXnryw6U+axLIlzsAkK1bTVlIddQFNueCHJB7+43
        PbmLpMqJ7ZbLH153OK211lkfNFFqRHZlEg9GG17K6A1yCwsqfpNXCC5QjcVohdl+
        okUY4RXpugQD+1thWqVb8dwQgMJtGACGSbskpPNYKSLc5v/E7AxN2X1X2q3B/y+X
        C/W1WGgv15DOAQ==
X-ME-Sender: <xms:X2KqX9Vh0sp9dAfCIhV1qwIB1ccRdHQs2QADaQ4uYyz7T2oBH4gyDQ>
    <xme:X2KqX9khy42vosLH5f1TEHzWOZgSLifN8JhRi4mk7A8Q20742w3cEKPDWvfpZ9xsL
    OTQCUwU6WAhaTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:X2KqX5a3UjkB-q5xEJrPIzLht-FRX0vcLu2CHfmRSy9VHCMq38xBAQ>
    <xmx:X2KqXwVbVFDWsgIqSqOzoA1qDKffiGjjRH-ZLeaNoRqe_C9nkLYP-w>
    <xmx:X2KqX3kDkXioxPwywKxnex6_L5im8Og_DiINMPi2SfXTL5QdnBqoNw>
    <xmx:X2KqX8ymIQDGndP5DtGDj-f1OETbwkdRMNKzpEipyXJhULoSP-8bXg>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 878023280066;
        Tue, 10 Nov 2020 04:50:22 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/15] mlxsw: spectrum_router: Push out RALUE pack into separate helper
Date:   Tue, 10 Nov 2020 11:48:50 +0200
Message-Id: <20201110094900.1920158-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As the RALUE packing is going to be pushed into an op, in preparation
for that push the code into a separate function in the meantime.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 49 +++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9083c74c1904..cf186f1ff3f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4308,16 +4308,15 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void
-mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl,
-			      const struct mlxsw_sp_fib_entry *fib_entry,
-			      enum mlxsw_sp_fib_entry_op op)
+mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
+			      enum mlxsw_sp_fib_entry_op op, u16 virtual_router,
+			      u8 prefix_len, unsigned char *addr)
 {
-	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
-	enum mlxsw_reg_ralxx_protocol proto;
+	enum mlxsw_reg_ralxx_protocol ralxx_proto;
 	enum mlxsw_reg_ralue_op ralue_op;
 	u32 *p_dip;
 
-	proto = (enum mlxsw_reg_ralxx_protocol) fib->proto;
+	ralxx_proto = (enum mlxsw_reg_ralxx_protocol) proto;
 
 	switch (op) {
 	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
@@ -4331,21 +4330,31 @@ mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl,
 		return;
 	}
 
-	switch (fib->proto) {
+	switch (proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
-		p_dip = (u32 *) fib_entry->fib_node->key.addr;
-		mlxsw_reg_ralue_pack4(ralue_pl, proto, ralue_op, fib->vr->id,
-				      fib_entry->fib_node->key.prefix_len,
-				      *p_dip);
+		p_dip = (u32 *) addr;
+		mlxsw_reg_ralue_pack4(ralue_pl, ralxx_proto, ralue_op,
+				      virtual_router, prefix_len, *p_dip);
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
-		mlxsw_reg_ralue_pack6(ralue_pl, proto, ralue_op, fib->vr->id,
-				      fib_entry->fib_node->key.prefix_len,
-				      fib_entry->fib_node->key.addr);
+		mlxsw_reg_ralue_pack6(ralue_pl, ralxx_proto, ralue_op,
+				      virtual_router, prefix_len, addr);
 		break;
 	}
 }
 
+static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				    struct mlxsw_sp_fib_entry *fib_entry,
+				    enum mlxsw_sp_fib_entry_op op)
+{
+	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
+
+	mlxsw_sp_fib_entry_ralue_pack(op_ctx->ralue_pl, fib->proto, op,
+				      fib->vr->id,
+				      fib_entry->fib_node->key.prefix_len,
+				      fib_entry->fib_node->key.addr);
+}
+
 static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 {
 	enum mlxsw_reg_ratr_trap_action trap_action;
@@ -4414,7 +4423,7 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 		trap_id = MLXSW_TRAP_ID_RTR_INGRESS0;
 	}
 
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	mlxsw_reg_ralue_act_remote_pack(ralue_pl, trap_action, trap_id,
 					adjacency_index, ecmp_size);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
@@ -4439,7 +4448,7 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 		trap_id = MLXSW_TRAP_ID_RTR_INGRESS0;
 	}
 
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id,
 				       rif_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
@@ -4452,7 +4461,7 @@ static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
 {
 	char *ralue_pl = op_ctx->ralue_pl;
 
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
@@ -4466,7 +4475,7 @@ static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 	char *ralue_pl = op_ctx->ralue_pl;
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_DISCARD_ERROR;
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, 0, 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
@@ -4484,7 +4493,7 @@ mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
 	trap_id = MLXSW_TRAP_ID_RTR_INGRESS1;
 
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id, 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
@@ -4513,7 +4522,7 @@ static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
 {
 	char *ralue_pl = op_ctx->ralue_pl;
 
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl,
 					   fib_entry->decap.tunnel_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
-- 
2.26.2

