Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252A0337287
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhCKMZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42601 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232894AbhCKMZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B03995C008B;
        Thu, 11 Mar 2021 07:25:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 07:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jpRulsbNpf0NmRTzlHinhyeQRdoXFjHo2jPhzlYL+fc=; b=PuOcexFD
        LiIPGT9D8vGjQgOlrGUC3nmxvYWJI7T95zQG4QmgVPTmTNQ4WM14dQNSSYAWO5ER
        3BeJi1Pj2kpc+V2gCVNSQC9ihB6y/YvAnfZ8tfhKyxJqNqofKKEn2TwiBk8VKyvI
        jMPNkg5rjgIMvMD+FOSzClhVcr562bbl7hLVItW3B2GtWVKwWR0TPdwOoiGxk91V
        0aa9d5X4rU9YcNLFQwhtFJqqvM5Qt8eTCifd3pwC5gI3PKAi9vxWN4bwHvGPXbMl
        NR0qJS95dXoG/Ri+0bAed0i1WH4oLYLZrydQmD1iviKWvZxRwXpuEnj4M8hRKqEL
        clRK5KV9vP6EhQ==
X-ME-Sender: <xms:JwxKYB7Fy-_54tM2Q2V0ETnJgO_sstEdKL0YRHyUmnWJlm5JFOp7CQ>
    <xme:JwxKYO79eTC0mLOv_Fqgcqkp7WJphHZakJzqiplrrqZOuWVNYsOv9nPSkn8Ac_CHx
    fOrlx1CCXpv5v0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JwxKYIdK3bDSPhX226WtIFGhrfOxgkfAicttkCnIyaRH3zEsL8BUjQ>
    <xmx:JwxKYKJxhSpCiUtjbz8mJ1yfvDrXz1Izkan21o0m6DwiqemFFWD9Mw>
    <xmx:JwxKYFKyhHjGogHcf4hjHNF-zKPXhbtwxpYuxVZlZEao8wHbNZ6S1A>
    <xmx:JwxKYMX3gGTs4o3mQ2-YeyyzUKB3JRrILjgrgS0093NO0xz1xi10Qg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DE0B108005C;
        Thu, 11 Mar 2021 07:25:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: spectrum_matchall: Split sampling support between ASICs
Date:   Thu, 11 Mar 2021 14:24:14 +0200
Message-Id: <20210311122416.2620300-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
References: <20210311122416.2620300-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Sampling of ingress packets is supported using a dedicated sampling
mechanism on all Spectrum ASICs. However, Spectrum-2 and later ASICs
support more sophisticated sampling by mirroring packets to the CPU.

As a preparation for more advanced sampling configurations, split the
sampling operations between Spectrum-1 and later ASICs.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 11 +++++++
 .../mellanox/mlxsw/spectrum_matchall.c        | 32 +++++++++++++++++--
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dbf95e52b341..93b15b8c007e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2804,6 +2804,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->span_ops = &mlxsw_sp1_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp1_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp1_trap_ops;
+	mlxsw_sp->mall_ops = &mlxsw_sp1_mall_ops;
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
@@ -2833,6 +2834,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
+	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -2860,6 +2862,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
+	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index d9d9e1f488f9..1ec9a3c48a42 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -179,6 +179,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_span_ops *span_ops;
 	const struct mlxsw_sp_policer_core_ops *policer_core_ops;
 	const struct mlxsw_sp_trap_ops *trap_ops;
+	const struct mlxsw_sp_mall_ops *mall_ops;
 	const struct mlxsw_listener *listeners;
 	size_t listeners_count;
 	u32 lowest_shaper_bs;
@@ -1033,6 +1034,16 @@ extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
 /* spectrum_matchall.c */
+struct mlxsw_sp_mall_ops {
+	int (*sample_add)(struct mlxsw_sp *mlxsw_sp,
+			  struct mlxsw_sp_port *mlxsw_sp_port, u32 rate);
+	void (*sample_del)(struct mlxsw_sp *mlxsw_sp,
+			   struct mlxsw_sp_port *mlxsw_sp_port);
+};
+
+extern const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops;
+extern const struct mlxsw_sp_mall_ops mlxsw_sp2_mall_ops;
+
 enum mlxsw_sp_mall_action_type {
 	MLXSW_SP_MALL_ACTION_TYPE_MIRROR,
 	MLXSW_SP_MALL_ACTION_TYPE_SAMPLE,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 2b7652b4b0bb..ad1209df81ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -96,6 +96,7 @@ static int
 mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_mall_entry *mall_entry)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	int err;
 
 	if (rtnl_dereference(mlxsw_sp_port->sample)) {
@@ -104,8 +105,8 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 	rcu_assign_pointer(mlxsw_sp_port->sample, &mall_entry->sample);
 
-	err = mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true,
-					    mall_entry->sample.rate);
+	err = mlxsw_sp->mall_ops->sample_add(mlxsw_sp, mlxsw_sp_port,
+					     mall_entry->sample.rate);
 	if (err)
 		goto err_port_sample_set;
 	return 0;
@@ -118,10 +119,12 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 static void
 mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+
 	if (!mlxsw_sp_port->sample)
 		return;
 
-	mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, false, 1);
+	mlxsw_sp->mall_ops->sample_del(mlxsw_sp, mlxsw_sp_port);
 	RCU_INIT_POINTER(mlxsw_sp_port->sample, NULL);
 }
 
@@ -356,3 +359,26 @@ int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
 	*p_max_prio = block->mall.max_prio;
 	return 0;
 }
+
+static int mlxsw_sp1_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_port *mlxsw_sp_port,
+				     u32 rate)
+{
+	return mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true, rate);
+}
+
+static void mlxsw_sp1_mall_sample_del(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, false, 1);
+}
+
+const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops = {
+	.sample_add = mlxsw_sp1_mall_sample_add,
+	.sample_del = mlxsw_sp1_mall_sample_del,
+};
+
+const struct mlxsw_sp_mall_ops mlxsw_sp2_mall_ops = {
+	.sample_add = mlxsw_sp1_mall_sample_add,
+	.sample_del = mlxsw_sp1_mall_sample_del,
+};
-- 
2.29.2

