Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CECA6E872F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjDTBKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjDTBKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBED46B7
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ABA464444
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A80EC433A0;
        Thu, 20 Apr 2023 01:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953019;
        bh=EkegsSDJVSussE35ZjffduOom+57M9Wr2pAyG3KNo8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI/UjlJaXfwpHiz/lDkDoaXU30gFXUDjhayQqC7LzvvlfOC8qNZKkRHQfWVzEYp1l
         NJh0vtRnWu0kBbwY1Z0PjsCadDuJLSHI/DSkiMZV0XRZ1w0hN7dqgi7mZXifJ1b5Cq
         y0y/ZPVHgGyePWuTM9vosR/4aRLLV9pEyES3bXIemxWv+dplJqAUaZ6DslsYlViBM/
         2XQ8yO4dQh93JaEylAn5bwl+C5vqMvX9oDYR8GFkZr8lxj0+W910lKdjKlK9paxB5q
         NJx/yOS2+D5h7GXjei2WmgpwkfD4Od0l5QdnfCznJeJuRafysmu9ySGTiTyarOXAJk
         gEdGN8z3RgRdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net 03/10] net/mlx5: E-switch, Create per vport table based on devlink encap mode
Date:   Wed, 19 Apr 2023 18:09:52 -0700
Message-Id: <20230420010959.276760-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420010959.276760-1-saeed@kernel.org>
References: <20230420010959.276760-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently when creating per vport table, create flags are hardcoded.
Devlink encap mode is set based on user input and HW capability.
Create per vport table based on devlink encap mode.

Fixes: c796bb7cd230 ("net/mlx5: E-switch, Generalize per vport table API")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/esw/vporttbl.c   | 12 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   |  2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 558a776359af..5db239cae814 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -14,10 +14,10 @@
 
 #define MLX5_ESW_VPORT_TBL_SIZE_SAMPLE (64 * 1024)
 
-static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
+static struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
 	.max_fte = MLX5_ESW_VPORT_TBL_SIZE_SAMPLE,
 	.max_num_groups = 0,    /* default num of groups */
-	.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT | MLX5_FLOW_TABLE_TUNNEL_EN_DECAP,
+	.flags = 0,
 };
 
 struct mlx5e_tc_psample {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
index 9e72118f2e4c..b3fb3ba2684a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
@@ -11,7 +11,7 @@ struct mlx5_vport_key {
 	u16 prio;
 	u16 vport;
 	u16 vhca_id;
-	const struct esw_vport_tbl_namespace *vport_ns;
+	struct esw_vport_tbl_namespace *vport_ns;
 } __packed;
 
 struct mlx5_vport_table {
@@ -21,6 +21,14 @@ struct mlx5_vport_table {
 	struct mlx5_vport_key key;
 };
 
+static inline void
+esw_vport_tbl_init(struct mlx5_eswitch *esw, struct esw_vport_tbl_namespace *ns)
+{
+	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
+		ns->flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+			      MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
+}
+
 static struct mlx5_flow_table *
 esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns,
 		     const struct esw_vport_tbl_namespace *vport_ns)
@@ -80,6 +88,7 @@ mlx5_esw_vporttbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 	u32 hkey;
 
 	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	esw_vport_tbl_init(esw, attr->vport_ns);
 	hkey = flow_attr_to_vport_key(esw, attr, &skey);
 	e = esw_vport_tbl_lookup(esw, &skey, hkey);
 	if (e) {
@@ -127,6 +136,7 @@ mlx5_esw_vporttbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 	u32 hkey;
 
 	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	esw_vport_tbl_init(esw, attr->vport_ns);
 	hkey = flow_attr_to_vport_key(esw, attr, &key);
 	e = esw_vport_tbl_lookup(esw, &key, hkey);
 	if (!e || --e->num_rules)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 19e9a77c4633..9d5a5756a15a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -674,7 +674,7 @@ struct mlx5_vport_tbl_attr {
 	u32 chain;
 	u16 prio;
 	u16 vport;
-	const struct esw_vport_tbl_namespace *vport_ns;
+	struct esw_vport_tbl_namespace *vport_ns;
 };
 
 struct mlx5_flow_table *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 25a8076a77bf..706746cd10af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -73,7 +73,7 @@
 
 #define MLX5_ESW_FT_OFFLOADS_DROP_RULE (1)
 
-static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
+static struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
 	.max_fte = MLX5_ESW_VPORT_TBL_SIZE,
 	.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS,
 	.flags = 0,
-- 
2.39.2

