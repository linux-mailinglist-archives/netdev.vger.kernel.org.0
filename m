Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEF7DA5D0
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404879AbfJQG4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:56:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39287 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390955AbfJQG4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:56:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7921321FB7;
        Thu, 17 Oct 2019 02:56:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=gAWKD5ShKoGYqbOQkSPVaibHLY00v0exTysFCBQVgZw=; b=FRMJvGWb
        yyomRbfhlx5xsMnGSg66CAnq/o4X7O/f8K2FnuK1VqNhm9UBmcJBb76TIgtEApXR
        kqDIQM0eaQP2dxh/+nM+oOwBgYqsEXWIVgv4WtOtSzb8ANjBhqj0zXEAnyufMA17
        hEXRtqWVVctgHVw3AER3uB1dtK+d5vjGpJdN6UakV4y7Jyi7eN6bxBEmPojii75c
        ndDAp/LyaQhv1GFHT1fmYnaeSClh/f1dgYkTDFQBetJIaxpy7iGESGVzoEUP2eTg
        bsXQMGc+0lGm7jBFQtcQLeoQFp35lEBnKQsESQxJ0FIUyp/dYhpvAnAO/M6mCs9P
        B16EIOs53BHz/g==
X-ME-Sender: <xms:ixCoXRB6St3mpfevNTRjaOwIOGAF05GHqTz2BFeOPGriPezP5bpcOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:ixCoXbKPQYYzdTmvHqiwdRfP79mT4QYzMxflp44kargOnCsBP1FvQw>
    <xmx:ixCoXXCR_n9JB5cNuLqIK00eDMlePL4od9jjdLEbkbo09DakqFFIRA>
    <xmx:ixCoXZqlvcyKshF2RZFOeKbBaCuQJNUs_C4UkPEcEfBiACwGiZKxpw>
    <xmx:ixCoXcqvSFEFZbKYhwBcScPdznvBg37jvoDbdOTtYt0zBUdH-zdlew>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CEDED6005B;
        Thu, 17 Oct 2019 02:56:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] mlxsw: spectrum: Register switched port analyzers (SPAN) as resource
Date:   Thu, 17 Oct 2019 09:55:14 +0300
Message-Id: <20191017065518.27008-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017065518.27008-1-idosch@idosch.org>
References: <20191017065518.27008-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

The switch supports an enhanced switched port analyzer that enables
selecting network traffic for analysis by a network analyzer.

SPAN agents are configured and consumed whenever a tc filter is added
with a mirror action to a new destination. The destination can either be
a physical port (e.g., swp1), a VLAN device or a gretap.

Expose the maximum number of SPAN agents and their current usage to the
user.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 51 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 21 ++++++++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ae3c4da11520..1275d21e8fbd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5202,14 +5202,61 @@ static int mlxsw_sp2_resources_kvd_register(struct mlxsw_core *mlxsw_core)
 					 &kvd_size_params);
 }
 
+static int mlxsw_sp_resources_span_register(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_resource_size_params span_size_params;
+	u32 max_span;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, MAX_SPAN))
+		return -EIO;
+
+	max_span = MLXSW_CORE_RES_GET(mlxsw_core, MAX_SPAN);
+	devlink_resource_size_params_init(&span_size_params, max_span, max_span,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	return devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_SPAN,
+					 max_span, MLXSW_SP_RESOURCE_SPAN,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP,
+					 &span_size_params);
+}
+
 static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 {
-	return mlxsw_sp1_resources_kvd_register(mlxsw_core);
+	int err;
+
+	err = mlxsw_sp1_resources_kvd_register(mlxsw_core);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_resources_span_register(mlxsw_core);
+	if (err)
+		goto err_resources_span_register;
+
+	return 0;
+
+err_resources_span_register:
+	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
+	return err;
 }
 
 static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 {
-	return mlxsw_sp2_resources_kvd_register(mlxsw_core);
+	int err;
+
+	err = mlxsw_sp2_resources_kvd_register(mlxsw_core);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_resources_span_register(mlxsw_core);
+	if (err)
+		goto err_resources_span_register;
+
+	return 0;
+
+err_resources_span_register:
+	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
+	return err;
 }
 
 static int mlxsw_sp_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8f99d70d6b8b..a5fdd84b4ca7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -48,6 +48,8 @@
 #define MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_CHUNKS "chunks"
 #define MLXSW_SP_RESOURCE_NAME_KVD_LINEAR_LARGE_CHUNKS "large_chunks"
 
+#define MLXSW_SP_RESOURCE_NAME_SPAN "span_agents"
+
 enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_KVD = 1,
 	MLXSW_SP_RESOURCE_KVD_LINEAR,
@@ -56,6 +58,7 @@ enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_KVD_LINEAR_SINGLE,
 	MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS,
 	MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS,
+	MLXSW_SP_RESOURCE_SPAN,
 };
 
 struct mlxsw_sp_port;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 560a60e522f9..200d324e6d99 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -14,8 +14,23 @@
 #include "spectrum_span.h"
 #include "spectrum_switchdev.h"
 
+static u64 mlxsw_sp_span_occ_get(void *priv)
+{
+	const struct mlxsw_sp *mlxsw_sp = priv;
+	u64 occ = 0;
+	int i;
+
+	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
+		if (mlxsw_sp->span.entries[i].ref_count)
+			occ++;
+	}
+
+	return occ;
+}
+
 int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_SPAN))
@@ -36,13 +51,19 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 		curr->id = i;
 	}
 
+	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
+					  mlxsw_sp_span_occ_get, mlxsw_sp);
+
 	return 0;
 }
 
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
+	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_SPAN);
+
 	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
 		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
 
-- 
2.21.0

