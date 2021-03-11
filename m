Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A25337289
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhCKMZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50647 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233104AbhCKMZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A09FD5C008B;
        Thu, 11 Mar 2021 07:25:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 07:25:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+Fep2oDVd/rBU2UDXbwSyLWBg6PrLWaUjY6wngluK3E=; b=oSSc3eIi
        2iyMmuspzlhtGUrUcBxnWlxS5JGly7KPM6SaLnWeaRZj6hkGRDkGnDxo7LMIwmrN
        etsQpgJeRmtaDky5Ts2Ikyw8i8f86kBwTMxjowg3/aeQtCBiLellOpdEG/QrvR0s
        +j11mCUg6G2Q0d2dE1oiiQ89o8NaBGAPSjpNUq4nd/FRfWckqXFXWiq+/lCbQOJU
        rPvyKPS46uU34LmX1Xz0Grb/vYHapPrt9Mar1mk2cQj892AKg2G0rBD8xv8+Cz0G
        Jz0Y1EMCC2CjpLbxjZfJ0JtHBPLwqY6gfO90FoPDx8CrSukzSrSlw4l5eW5lVMAH
        Iw+6QJ+wKb3G4A==
X-ME-Sender: <xms:KgxKYCB7tkI1veYZWwJoihUGeGOLw_u5wSd3AqIgCVkdiDS5W_zBGw>
    <xme:KgxKYMhIx-PkgCuD9Rbjn0-3PvPaLHRXi9psbqie5rBdu-VaYm-NSAWMxL-IaCm9e
    jVOkMZF8WLfTpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KgxKYFkF_oa812FC9CO9y1pTYrBbKyKGYIg1TPKLzUrLKKlWfvhr3w>
    <xmx:KgxKYAyp5ROW2bcuHFsB6ILJyFUQ6VDPBxuQL0gJnQG4-3lJZGDP5g>
    <xmx:KgxKYHSG_UmbvIbZYa4YUgOOaO6skGh3rYmfOrhgTZEqLys3sIZE1A>
    <xmx:KgxKYCduvzeJysbJyTpTVOryrZRXu2MklpjaVFRtqsTBRj4uI5bpCw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5106C1080057;
        Thu, 11 Mar 2021 07:25:13 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: spectrum_matchall: Implement sampling using mirroring
Date:   Thu, 11 Mar 2021 14:24:16 +0200
Message-Id: <20210311122416.2620300-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
References: <20210311122416.2620300-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Spectrum-2 and later ASICs support sampling of packets by mirroring to
the CPU with probability. There are several advantages compared to the
legacy dedicated sampling mechanism:

* Extra metadata per-packet: Egress port, egress traffic class, traffic
  class occupancy and end-to-end latency
* Ability to sample packets on egress / per-flow

Convert Spectrum-2 and later ASICs to perform sampling by mirroring to
the CPU with probability.

Subsequent patches will add support for egress / per-flow sampling and
expose the extra metadata.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../mellanox/mlxsw/spectrum_matchall.c        | 57 ++++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  8 ++-
 4 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 1ec9a3c48a42..bc7006de7873 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -238,6 +238,7 @@ struct mlxsw_sp_port_sample {
 	u32 trunc_size;
 	u32 rate;
 	bool truncate;
+	int span_id;	/* Relevant for Spectrum-2 onwards. */
 };
 
 struct mlxsw_sp_bridge_port;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index ad1209df81ea..841a2de37f36 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -378,7 +378,60 @@ const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops = {
 	.sample_del = mlxsw_sp1_mall_sample_del,
 };
 
+static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_port *mlxsw_sp_port,
+				     u32 rate)
+{
+	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
+	struct mlxsw_sp_span_agent_parms agent_parms = {
+		.to_dev = NULL,	/* Mirror to CPU. */
+		.session_id = MLXSW_SP_SPAN_SESSION_ID_SAMPLING,
+	};
+	struct mlxsw_sp_port_sample *sample;
+	int err;
+
+	sample = rtnl_dereference(mlxsw_sp_port->sample);
+
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, &sample->span_id, &agent_parms);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, true);
+	if (err)
+		goto err_analyzed_port_get;
+
+	trigger_parms.span_id = sample->span_id;
+	trigger_parms.probability_rate = rate;
+	err = mlxsw_sp_span_agent_bind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
+				       mlxsw_sp_port, &trigger_parms);
+	if (err)
+		goto err_agent_bind;
+
+	return 0;
+
+err_agent_bind:
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+err_analyzed_port_get:
+	mlxsw_sp_span_agent_put(mlxsw_sp, sample->span_id);
+	return err;
+}
+
+static void mlxsw_sp2_mall_sample_del(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
+	struct mlxsw_sp_port_sample *sample;
+
+	sample = rtnl_dereference(mlxsw_sp_port->sample);
+
+	trigger_parms.span_id = sample->span_id;
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
+				   mlxsw_sp_port, &trigger_parms);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_agent_put(mlxsw_sp, sample->span_id);
+}
+
 const struct mlxsw_sp_mall_ops mlxsw_sp2_mall_ops = {
-	.sample_add = mlxsw_sp1_mall_sample_add,
-	.sample_del = mlxsw_sp1_mall_sample_del,
+	.sample_add = mlxsw_sp2_mall_sample_add,
+	.sample_del = mlxsw_sp2_mall_sample_del,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index dea1c0d31310..efaefd1ae863 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -21,6 +21,7 @@ struct mlxsw_sp_port;
  */
 enum mlxsw_sp_span_session_id {
 	MLXSW_SP_SPAN_SESSION_ID_BUFFER,
+	MLXSW_SP_SPAN_SESSION_ID_SAMPLING,
 
 	__MLXSW_SP_SPAN_SESSION_ID_MAX = 8,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 6ecc77fde095..e0e6ee58d31a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -49,6 +49,8 @@ enum {
 #define MLXSW_SP_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
 
 enum {
+	/* Packet was mirrored from ingress. */
+	MLXSW_SP_MIRROR_REASON_INGRESS = 1,
 	/* Packet was early dropped. */
 	MLXSW_SP_MIRROR_REASON_INGRESS_WRED = 9,
 };
@@ -1753,6 +1755,7 @@ mlxsw_sp2_trap_group_items_arr[] = {
 		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_SAMPLE, 0),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
 		.priority = 0,
+		.fixed_policer = true,
 	},
 };
 
@@ -1769,8 +1772,9 @@ mlxsw_sp2_trap_items_arr[] = {
 		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_SAMPLE, ACL_SAMPLE,
 					      MIRROR),
 		.listeners_arr = {
-			MLXSW_RXL(mlxsw_sp_rx_sample_listener, PKT_SAMPLE,
-				  MIRROR_TO_CPU, false, SP_PKT_SAMPLE, DISCARD),
+			MLXSW_RXL_MIRROR(mlxsw_sp_rx_sample_listener, 1,
+					 SP_PKT_SAMPLE,
+					 MLXSW_SP_MIRROR_REASON_INGRESS),
 		},
 	},
 };
-- 
2.29.2

