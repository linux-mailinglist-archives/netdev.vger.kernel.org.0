Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2159D2F9150
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbhAQIKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:10:42 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55609 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727446AbhAQIEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:04:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 24D66184F;
        Sun, 17 Jan 2021 03:02:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 17 Jan 2021 03:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=3j7YQYmv+FvER+g5YLecMnQdGfyDuvQuIvMmt+yoYmc=; b=TkkPB3Ey
        02/K2cxyEy0Gex/ug0x8qKqkDxoEih4SFDNDy21TiaAR2f/E573ZE8Fjxn6Bau94
        tp30WyESPQJ31JvJ39RkGpgbrsQMdXSl6Row5pPFawJJY6BVILICsNTyJU8ZPuQR
        lpMM44TiOwpWCvyWYkSipMjk0QYr93F6sCtbH1eLRRJbI+q+rk1GAs0hpPM+d8dS
        PlbqByUDUc6FBdQ68kFZPO4lYOeP2qThFosc2B6m2UKS4qXq87NcnSINff83pgYg
        1KAc/AHGiN/EHq5DvDe8SHMyJ3eJSrIiod/7Ti6DFBxe3g7yiZ9AKVvq56SQtLGD
        9zNw9bOyfNUqfQ==
X-ME-Sender: <xms:MO8DYKfq3We58J87TJlSnTXNRYKKEKMaIjj9x0ZX7GqJq3bE1zLkig>
    <xme:MO8DYEMPOQYzchG_KZ8t1VDkaN6xO5hTI1G8f4D3qXtT2nzphHpVuVTtSedkYXOMV
    wFxTAJpTpe5vZk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MO8DYLgJJg12cHRuyJPbzCKwsG6faMgOJPL-QVloK-Xfr22kO0MJcA>
    <xmx:MO8DYH_fcJAXzKkSS9_h8EWLywYG1TKDRyVQVKpDPAccF5LZb2dVfg>
    <xmx:MO8DYGsHM1BVE2ZbJcu6OuY3vPkO1YI1aHLVct-zKs2MHj1N5OZ8UA>
    <xmx:MO8DYILLb6Tyq3u9GnkrgPpb5aBItQxMH650fEwpOg18C8bAjE5ddg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5BA5240057;
        Sun, 17 Jan 2021 03:02:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] mlxsw: spectrum_qdisc: Offload RED qevent mark
Date:   Sun, 17 Jan 2021 10:02:21 +0200
Message-Id: <20210117080223.2107288-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117080223.2107288-1-idosch@idosch.org>
References: <20210117080223.2107288-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The RED "mark" qevent can be offloaded under the same exact conditions as
the RED "tail_drop" qevent. Therefore recognize its binding type in the
TC_SETUP_BLOCK handler and translate to the right SPAN trigger.

The corresponding hardware trigger, MLXSW_SP_SPAN_TRIGGER_ECN, is
considered "egress", unlike the previously-offloaded _EARLY_DROP. Add a
helper to spectrum_span, mlxsw_sp_span_trigger_is_ingress(), to classify
triggers to ingress and egress. Pass result of this instead of hardcoding
true when calling mlxsw_sp_span_analyzed_port_get()/_put().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c   |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h   |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 14 +++++++++++---
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c  | 16 ++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h  |  1 +
 5 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1650d9852b5b..e93b96837a44 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -992,6 +992,8 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, false);
 	case FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP:
 		return mlxsw_sp_setup_tc_block_qevent_early_drop(mlxsw_sp_port, f);
+	case FLOW_BLOCK_BINDER_TYPE_RED_MARK:
+		return mlxsw_sp_setup_tc_block_qevent_mark(mlxsw_sp_port, f);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a6956cfc9cb1..0e5fd6a73da1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1109,6 +1109,8 @@ int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_fifo_qopt_offload *p);
 int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_port,
 					      struct flow_block_offload *f);
+int mlxsw_sp_setup_tc_block_qevent_mark(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct flow_block_offload *f);
 
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index fd672c6c9133..5cd8854e6070 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1327,6 +1327,7 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 					  const struct mlxsw_sp_span_agent_parms *agent_parms,
 					  int *p_span_id)
 {
+	bool ingress = mlxsw_sp_span_trigger_is_ingress(qevent_binding->span_trigger);
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
 	int span_id;
@@ -1336,7 +1337,7 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, true);
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, ingress);
 	if (err)
 		goto err_analyzed_port_get;
 
@@ -1358,7 +1359,7 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
 				   &trigger_parms);
 err_agent_bind:
-	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, ingress);
 err_analyzed_port_get:
 	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
 	return err;
@@ -1368,6 +1369,7 @@ static void mlxsw_sp_qevent_span_deconfigure(struct mlxsw_sp *mlxsw_sp,
 					     struct mlxsw_sp_qevent_binding *qevent_binding,
 					     int span_id)
 {
+	bool ingress = mlxsw_sp_span_trigger_is_ingress(qevent_binding->span_trigger);
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {
 		.span_id = span_id,
@@ -1377,7 +1379,7 @@ static void mlxsw_sp_qevent_span_deconfigure(struct mlxsw_sp *mlxsw_sp,
 				      qevent_binding->tclass_num);
 	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
 				   &trigger_parms);
-	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, ingress);
 	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
 }
 
@@ -1828,6 +1830,12 @@ int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_por
 	return mlxsw_sp_setup_tc_block_qevent(mlxsw_sp_port, f, MLXSW_SP_SPAN_TRIGGER_EARLY_DROP);
 }
 
+int mlxsw_sp_setup_tc_block_qevent_mark(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct flow_block_offload *f)
+{
+	return mlxsw_sp_setup_tc_block_qevent(mlxsw_sp_port, f, MLXSW_SP_SPAN_TRIGGER_ECN);
+}
+
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index c6c5826aba41..d44a93d69972 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1631,6 +1631,22 @@ void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
 	return trigger_entry->ops->disable(trigger_entry, mlxsw_sp_port, tc);
 }
 
+bool mlxsw_sp_span_trigger_is_ingress(enum mlxsw_sp_span_trigger trigger)
+{
+	switch (trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_INGRESS:
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP:
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP:
+		return true;
+	case MLXSW_SP_SPAN_TRIGGER_EGRESS:
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		return false;
+	}
+
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	size_t arr_size = ARRAY_SIZE(mlxsw_sp1_span_entry_ops_arr);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index d907718bc8c5..dbf54752d814 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -103,6 +103,7 @@ int mlxsw_sp_span_trigger_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 				 enum mlxsw_sp_span_trigger trigger, u8 tc);
 void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
 				   enum mlxsw_sp_span_trigger trigger, u8 tc);
+bool mlxsw_sp_span_trigger_is_ingress(enum mlxsw_sp_span_trigger trigger);
 
 extern const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops;
 extern const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops;
-- 
2.29.2

