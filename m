Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804FE2AD2D1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgKJJur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:47 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60551 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730741AbgKJJuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 95606CC3;
        Tue, 10 Nov 2020 04:50:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=B9yKKLPofdGm+dgccYKCfGHnzmqiIFOLvxA+4Avwoas=; b=l0jBoDmm
        n1heJEoowQ3LTQ+oOnlbTP5NFYRD9rg3vwBvXebVwmAGK4OIPXxSQkLcRwZJVcnu
        LPJStByMBEgRhaXywzlP99lNFt5ZUclqxRm+7/Iv0bQWMQMtUQf9WlNFj2KD3O1d
        qfTKBVeV/LRfNFtRezyU/AfCCOBOqzhezs3wdmiVOBrp+N/4hZC0UVfMjVinFdNn
        ojnsPjEtxULst5qr8ZhfDKGWmq3ue3OGHe5ankxx9NVcMxmnwpp5bRAX4W+/uNi8
        GzIEZcdBUjVWSNRYJUd4Iegu1t0L+S19DDQaPW3HbvAmC8hfnW+xq8c5ozNqb3OP
        MC69dKbsep5Ymw==
X-ME-Sender: <xms:bGKqX7WchQoydEyF8Nn2k1PcTeneBYrnB6hRlfJU2tHBcmwczLTeTg>
    <xme:bGKqXzlzgDpBDlKnZbXSNO-ZapicCCn1QTe-HUKVaOJyZjxfmHYcV6yj-fTZYNfIe
    uV7hyCiY-uzy8M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedufeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bGKqX3adIu6k99oflckRM1KPfcDMZLETgrMcVgEWdFHBClUH4a3ERQ>
    <xmx:bGKqX2V74D-_uOcuulIVMYUXEh_AT12bWFU59mSaCzevRlE8SjWwyg>
    <xmx:bGKqX1kM0XT2SXYPaKt2_p-K4U0b6TLIztn2t8kUwo8J8zOE78JG2w>
    <xmx:bGKqX6zrRbI9QjgMh-DYNO6uPZvBS6b5YSm_3FpIerm3GYgW8TAUQA>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id EFBFD328005A;
        Tue, 10 Nov 2020 04:50:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/15] mlxsw: spectrum_router: Track FIB entry committed state and skip uncommitted on delete
Date:   Tue, 10 Nov 2020 11:48:59 +0200
Message-Id: <20201110094900.1920158-15-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case bulking is used, the entry that was previously added may not
be yet committed to the HW as it waits in the queue for bulk send. For
such entries, skip the deletion.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9d3ead1ef561..ef95d126d29a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4453,6 +4453,12 @@ mlxsw_sp_router_ll_basic_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 			       op_ctx_basic->ralue_pl);
 }
 
+static bool
+mlxsw_sp_router_ll_basic_fib_entry_is_committed(struct mlxsw_sp_fib_entry_priv *priv)
+{
+	return true;
+}
+
 static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				    struct mlxsw_sp_fib_entry *fib_entry,
 				    enum mlxsw_sp_fib_entry_op op)
@@ -4712,6 +4718,10 @@ static int mlxsw_sp_fib_entry_del(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				  struct mlxsw_sp_fib_entry *fib_entry)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
+
+	if (!ll_ops->fib_entry_is_committed(fib_entry->priv))
+		return 0;
 	return mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry,
 				     MLXSW_SP_FIB_ENTRY_OP_DELETE);
 }
@@ -8370,6 +8380,7 @@ static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
 	.fib_entry_act_ip2me_pack = mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_pack,
 	.fib_entry_act_ip2me_tun_pack = mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack,
 	.fib_entry_commit = mlxsw_sp_router_ll_basic_fib_entry_commit,
+	.fib_entry_is_committed = mlxsw_sp_router_ll_basic_fib_entry_is_committed,
 };
 
 static int mlxsw_sp_router_ll_op_ctx_init(struct mlxsw_sp_router *router)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 4dacbeee3142..ed651b4200cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -112,6 +112,7 @@ struct mlxsw_sp_router_ll_ops {
 	int (*fib_entry_commit)(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				bool *postponed_for_bulk);
+	bool (*fib_entry_is_committed)(struct mlxsw_sp_fib_entry_priv *priv);
 };
 
 int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-- 
2.26.2

