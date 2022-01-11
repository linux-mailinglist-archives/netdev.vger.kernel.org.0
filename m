Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E348A534
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344502AbiAKBnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48768 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344385AbiAKBnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BEC16147C
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03E8C36AE9;
        Tue, 11 Jan 2022 01:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865427;
        bh=/3EOQNhGwsnx0hr8pft2nHbZAbJ/OqRIexlJaP0Kxbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4MOpUBwh4OIacEMHe9VPD65JL1ne1b+LaAgEfq2jYDFFPW51yTtfZcvuM7u3Sm4J
         /TQHDp4+ZnGuZ01ZK2JxMWL3RlEEJBmpuAN55V5vjmmHo3y1RrRcFE4bHV+ojHe/gZ
         WEnoTtlIB28JgZcId0z6F2WPl/c3yG/j4nt7D/ZTWmKHrD0neTR95sBNYx55IIz+Ik
         MsNecfQDt764SHC9zDoJc4j3KMh0nSCV88kM4WoBDjEv9El4hcdNKuGqAYOQfssl4d
         AC5z8OYTGwkACuBTdLRtxMZucudzHpML3hqsUtd0euUQ51QoGRP0BXaz6A0mx5d5n9
         gGtP37gy2vBew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/17] net/mlx5e: Move counter creation call to alloc_flow_attr_counter()
Date:   Mon, 10 Jan 2022 17:43:22 -0800
Message-Id: <20220111014335.178121-5-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move shared code to alloc_flow_attr_counter() for reuse by the next patches.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 33 +++++++++++--------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6f34eda35430..978c79912cc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1038,6 +1038,21 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	return ERR_CAST(rule);
 }
 
+static int
+alloc_flow_attr_counter(struct mlx5_core_dev *counter_dev,
+			struct mlx5_flow_attr *attr)
+
+{
+	struct mlx5_fc *counter;
+
+	counter = mlx5_fc_create(counter_dev, true);
+	if (IS_ERR(counter))
+		return PTR_ERR(counter);
+
+	attr->counter = counter;
+	return 0;
+}
+
 static int
 mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		      struct mlx5e_tc_flow *flow,
@@ -1046,7 +1061,6 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_core_dev *dev = priv->mdev;
-	struct mlx5_fc *counter;
 	int err;
 
 	parse_attr = attr->parse_attr;
@@ -1058,11 +1072,9 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-		counter = mlx5_fc_create(dev, true);
-		if (IS_ERR(counter))
-			return PTR_ERR(counter);
-
-		attr->counter = counter;
+		err = alloc_flow_attr_counter(dev, attr);
+		if (err)
+			return err;
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
@@ -1465,7 +1477,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
 	bool vf_tun, encap_valid;
-	struct mlx5_fc *counter;
 	u32 max_prio, max_chain;
 	int err = 0;
 
@@ -1577,13 +1588,9 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-		counter = mlx5_fc_create(esw_attr->counter_dev, true);
-		if (IS_ERR(counter)) {
-			err = PTR_ERR(counter);
+		err = alloc_flow_attr_counter(esw_attr->counter_dev, attr);
+		if (err)
 			goto err_out;
-		}
-
-		attr->counter = counter;
 	}
 
 	/* we get here if one of the following takes place:
-- 
2.34.1

