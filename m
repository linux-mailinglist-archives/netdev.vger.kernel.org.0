Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23084280E1
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhJJLmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37799 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231892AbhJJLml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CBA745C00EA;
        Sun, 10 Oct 2021 07:40:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 10 Oct 2021 07:40:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=o1q+n3fLNwmq8MQY6x4n1k4zLoY9vPkoR7K+Vlentog=; b=eaw5l8/9
        07fny3XW3GO8X6wUE5XyyUC20R85wfJKUv8OU08zcWrd1vczsjJNvtXAMrDCeaJV
        Q5843xUNceAuRy1/13SNh+XGXU56c7FPeiDIiYNkA20rWMZzc5B1N6woc+KXVW+U
        vjzLO2D4x+0bsPdAqupZGCuV79PKQqwjeEtLibAv196t/Y+sdVkXOYn74oGxf3/S
        gEtLPaFc7WBv7xD94SGbk/qCtiLB0HkdtlQYb8uJH34d6tqEvW98S0eLgV/cjRCO
        AY57pDArMNo50x7SWEDGG2Ex1Oi0WdHzz4SuQOytdUzt0MugO3QpLzBLiSZDquOv
        U3ltadKAgkR4sQ==
X-ME-Sender: <xms:OtFiYWSomYq4jh5ZU-HPvwmjSlj_W0L0KeSMEjTzpBquixKReFzy1Q>
    <xme:OtFiYbym3EyGgPXgt37sPUqRl7HDXVlfX0oIA2CAriZVbCtmeHrZOibA55UT7NhFr
    LPsdXofn5QNJJs>
X-ME-Received: <xmr:OtFiYT0-cKwEKoKR90NAAtBrCGSj--Qg_yU6NxHwRy6YVGiPi1TmcDxq3cDFKvggzGADvHGyKgrQLwnyw6fUXbjw07fcJEZxIQeuFIkxOLgYuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OtFiYSC61M5pz2lMvf3VTq0Pnm6Lvjk2NDmqyrUNztbj0sKoLjubPw>
    <xmx:OtFiYfjDj8FBBi5xtPBDLnRzxjkxCp9tHuv9XlHrnc1JKZYPtNI3mQ>
    <xmx:OtFiYerczc1g9nReUif-8G4v51MPctMc9pASOSDoo09c4jxZolGxmQ>
    <xmx:OtFiYffoZwF0vdBrDILJJsTREjH7zhmLti_tudhqr6pcIzMdus3JbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: spectrum_qdisc: Distinguish between ingress and egress triggers
Date:   Sun, 10 Oct 2021 14:40:14 +0300
Message-Id: <20211010114018.190266-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
References: <20211010114018.190266-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The following patches will configure the MLXSW_SP_SPAN_TRIGGER_ECN
mirroring trigger. This trigger is considered "egress", unlike the
previously-offloaded _EARLY_DROP. Add a helper to spectrum_span,
mlxsw_sp_span_trigger_is_ingress(), to classify triggers to ingress and
egress. Pass result of this instead of hardcoding true when calling
mlxsw_sp_span_analyzed_port_get()/_put().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 23 ++++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 16 +++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  1 +
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 14b87d672a9d..3e3da5b909f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1482,8 +1482,10 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 					  const struct mlxsw_sp_span_agent_parms *agent_parms,
 					  int *p_span_id)
 {
+	enum mlxsw_sp_span_trigger span_trigger = qevent_binding->span_trigger;
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
+	bool ingress;
 	int span_id;
 	int err;
 
@@ -1491,18 +1493,19 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, true);
+	ingress = mlxsw_sp_span_trigger_is_ingress(span_trigger);
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, ingress);
 	if (err)
 		goto err_analyzed_port_get;
 
 	trigger_parms.span_id = span_id;
 	trigger_parms.probability_rate = 1;
-	err = mlxsw_sp_span_agent_bind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
+	err = mlxsw_sp_span_agent_bind(mlxsw_sp, span_trigger, mlxsw_sp_port,
 				       &trigger_parms);
 	if (err)
 		goto err_agent_bind;
 
-	err = mlxsw_sp_span_trigger_enable(mlxsw_sp_port, qevent_binding->span_trigger,
+	err = mlxsw_sp_span_trigger_enable(mlxsw_sp_port, span_trigger,
 					   qevent_binding->tclass_num);
 	if (err)
 		goto err_trigger_enable;
@@ -1511,10 +1514,10 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_trigger_enable:
-	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, span_trigger, mlxsw_sp_port,
 				   &trigger_parms);
 err_agent_bind:
-	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, ingress);
 err_analyzed_port_get:
 	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
 	return err;
@@ -1524,16 +1527,20 @@ static void mlxsw_sp_qevent_span_deconfigure(struct mlxsw_sp *mlxsw_sp,
 					     struct mlxsw_sp_qevent_binding *qevent_binding,
 					     int span_id)
 {
+	enum mlxsw_sp_span_trigger span_trigger = qevent_binding->span_trigger;
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {
 		.span_id = span_id,
 	};
+	bool ingress;
 
-	mlxsw_sp_span_trigger_disable(mlxsw_sp_port, qevent_binding->span_trigger,
+	ingress = mlxsw_sp_span_trigger_is_ingress(span_trigger);
+
+	mlxsw_sp_span_trigger_disable(mlxsw_sp_port, span_trigger,
 				      qevent_binding->tclass_num);
-	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, span_trigger, mlxsw_sp_port,
 				   &trigger_parms);
-	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, ingress);
 	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 3398cc01e5ec..f5f819aa9a65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1650,6 +1650,22 @@ void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
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
index efaefd1ae863..82e711afb02b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -120,6 +120,7 @@ int mlxsw_sp_span_trigger_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 				 enum mlxsw_sp_span_trigger trigger, u8 tc);
 void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
 				   enum mlxsw_sp_span_trigger trigger, u8 tc);
+bool mlxsw_sp_span_trigger_is_ingress(enum mlxsw_sp_span_trigger trigger);
 
 extern const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops;
 extern const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops;
-- 
2.31.1

