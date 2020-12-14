Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12C52D9774
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437995AbgLNLfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:35:52 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54033 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437958AbgLNLcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4349D5C00B3;
        Mon, 14 Dec 2020 06:31:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/VT68u2PzB4G8IMNRkrtM9o9tTQV0d+egrVquk/jplE=; b=CC6sUTrQ
        3RKLtjsL0oVUewWc4RsrxJkxQugNY2+q+Jak5Atw20V7KZHX13/6+aQ5pR2rJrAh
        V28zhF13hYhQqmoPP7GwggLzrzcBWWKxUJh143YRzNVtypfFVTjiFcOq9FnTcxT7
        g+9vPnf0cRx6I0WS8WsK2i+9UsTpFDLQPqS7blYoGbNx99u2fPM/2pP1ExGP7Pmp
        3ILx9Y+5HyesW71g9AlnmwHNhO5VAaeIGkR1j1wfhw/zQBuSKkF7GkVBKiNr3ok0
        uUD5C/iiW71X3XygBtOckr7EutSfiI3XVmrpO4Ng39T7sX+AwM3TiIDZUmm40aUb
        QlH0UyGTgcY8aQ==
X-ME-Sender: <xms:_0zXX7DGYMKiPDZx-LOhpFoz_MpCxvo6f950wrzdScOSEDd2A_lbSA>
    <xme:_0zXXxjV7Mf4MwrFohVo1ClNUeC9oZCmlULwgBbrivSECATbkCMl1VqfDlPb6lpbU
    eajDzUTRiazKJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_0zXX2mjyiA62_B_KVyTy0-T3Uu5_Gu0nxI9FtHtlNCEn3_ZfBzHyQ>
    <xmx:_0zXX9xVx_z9DDsiRzKUwxkU-ofD3IrMW7LJXYzQCv_fH5JOTOp9XQ>
    <xmx:_0zXXwT7FuOvlm5_0s6GsCgp-BCX0_-zwz4kzJBgMIdu8i2B9ceSoQ>
    <xmx:_0zXX7fkPAyqh2Gj_FdHRswayltzL-NpzxLQTawjWFEln3ndE-8a-Q>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E9B91080059;
        Mon, 14 Dec 2020 06:31:09 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 08/15] mlxsw: spectrum_router: Introduce per-ASIC XM initialization
Date:   Mon, 14 Dec 2020 13:30:34 +0200
Message-Id: <20201214113041.2789043-9-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

During the router init flow, call into XM code and initialize couple of
items needed for XM functionality:

1) Query the capabilities and sizes. Check the XM device id.
2) Initialize the M-value. Note that currently the M-value is set fixed
   to 16 for IPv4. In future this may change to better cover the actual
   inserted routes.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  7 ++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  4 +
 .../mellanox/mlxsw/spectrum_router_xm.c       | 77 +++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f132fa6cf7b7..3b32d9648578 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9208,6 +9208,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp->router = router;
 	router->mlxsw_sp = mlxsw_sp;
 
+	err = mlxsw_sp_router_xm_init(mlxsw_sp);
+	if (err)
+		goto err_xm_init;
+
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
 
@@ -9340,6 +9344,8 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_router_init:
 	mlxsw_sp_router_ll_op_ctx_fini(router);
 err_ll_op_ctx_init:
+	mlxsw_sp_router_xm_fini(mlxsw_sp);
+err_xm_init:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 	return err;
@@ -9367,6 +9373,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
 	mlxsw_sp_router_ll_op_ctx_fini(mlxsw_sp->router);
+	mlxsw_sp_router_xm_fini(mlxsw_sp);
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index fe1b92110844..d6f7aba6eb9c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -76,6 +76,7 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
 	u16 lb_rif_index;
+	struct mlxsw_sp_router_xm *xm;
 };
 
 struct mlxsw_sp_fib_entry_priv {
@@ -223,4 +224,7 @@ int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
 
 extern const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops;
 
+int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp);
+void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp);
+
 #endif /* _MLXSW_ROUTER_H_*/
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
index f5b4c0edf99d..966a20f3bc0d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -9,6 +9,19 @@
 #include "reg.h"
 #include "spectrum_router.h"
 
+#define MLXSW_SP_ROUTER_XM_M_VAL 16
+
+static const u8 mlxsw_sp_router_xm_m_val[] = {
+	[MLXSW_SP_L3_PROTO_IPV4] = MLXSW_SP_ROUTER_XM_M_VAL,
+	[MLXSW_SP_L3_PROTO_IPV6] = 0, /* Currently unused. */
+};
+
+struct mlxsw_sp_router_xm {
+	bool ipv4_supported;
+	bool ipv6_supported;
+	unsigned int entries_size;
+};
+
 struct mlxsw_sp_router_xm_fib_entry {
 	bool committed;
 };
@@ -232,3 +245,67 @@ const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops = {
 	.fib_entry_commit = mlxsw_sp_router_ll_xm_fib_entry_commit,
 	.fib_entry_is_committed = mlxsw_sp_router_ll_xm_fib_entry_is_committed,
 };
+
+#define MLXSW_SP_ROUTER_XM_MINDEX_SIZE (64 * 1024)
+
+int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_router_xm *router_xm;
+	char rxltm_pl[MLXSW_REG_RXLTM_LEN];
+	char xltq_pl[MLXSW_REG_XLTQ_LEN];
+	u32 mindex_size;
+	u16 device_id;
+	int err;
+
+	if (!mlxsw_sp->bus_info->xm_exists)
+		return 0;
+
+	router_xm = kzalloc(sizeof(*router_xm), GFP_KERNEL);
+	if (!router_xm)
+		return -ENOMEM;
+
+	mlxsw_reg_xltq_pack(xltq_pl);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(xltq), xltq_pl);
+	if (err)
+		goto err_xltq_query;
+	mlxsw_reg_xltq_unpack(xltq_pl, &device_id, &router_xm->ipv4_supported,
+			      &router_xm->ipv6_supported, &router_xm->entries_size, &mindex_size);
+
+	if (device_id != MLXSW_REG_XLTQ_XM_DEVICE_ID_XLT) {
+		dev_err(mlxsw_sp->bus_info->dev, "Invalid XM device id\n");
+		err = -EINVAL;
+		goto err_device_id_check;
+	}
+
+	if (mindex_size != MLXSW_SP_ROUTER_XM_MINDEX_SIZE) {
+		dev_err(mlxsw_sp->bus_info->dev, "Unexpected M-index size\n");
+		err = -EINVAL;
+		goto err_mindex_size_check;
+	}
+
+	mlxsw_reg_rxltm_pack(rxltm_pl, mlxsw_sp_router_xm_m_val[MLXSW_SP_L3_PROTO_IPV4],
+			     mlxsw_sp_router_xm_m_val[MLXSW_SP_L3_PROTO_IPV6]);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rxltm), rxltm_pl);
+	if (err)
+		goto err_rxltm_write;
+
+	mlxsw_sp->router->xm = router_xm;
+	return 0;
+
+err_rxltm_write:
+err_mindex_size_check:
+err_device_id_check:
+err_xltq_query:
+	kfree(router_xm);
+	return err;
+}
+
+void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+
+	if (!mlxsw_sp->bus_info->xm_exists)
+		return;
+
+	kfree(router_xm);
+}
-- 
2.29.2

