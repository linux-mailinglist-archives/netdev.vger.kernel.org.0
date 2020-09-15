Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E8726B03B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgIOWFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDCF21D95;
        Tue, 15 Sep 2020 20:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201560;
        bh=eOIgJ3K5fKzjDwbyfKRxAW5sRKnnAo83yf+Zt09mhK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpSjtKPvs1WN4/rXnkdqZM7s9d/eobwQ63cvbGfJsMZefiok+7RwyoCWXGgZxwmVR
         kBt+oPGvWEboicUndyMl4oet0UUaUBY+ozkgQ6tsI1r4WnVlnD+1enhfpWJq2XYMP8
         2cpp3IHLqcB4uEvuIAKPZcrl0d+Xy+e0byTq3z94=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Bodong Wang <bodong@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5: E-Switch, Setup all vports' metadata to support peer miss rule
Date:   Tue, 15 Sep 2020 13:25:29 -0700
Message-Id: <20200915202533.64389-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

In merged eswitch configuration, peer miss rule is setup for all
vports. If metadata is enabled, peer miss rule with metadata matching
will be configured instead of source port matching; however, some
vports that have not yet been enabled don't have default_metadata
setup and their default_metadata will be zero.

Hence, setup/cleanup default metadata for all vports when eswitch moves
in/out of offloads mode.

Fixes: 133dcfc577ea ("net/mlx5: E-Switch, Alloc and free unique metadata for match")
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 51 +++++++++++++++----
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9c740ce73085..3321bb1f188d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1923,19 +1923,49 @@ static void esw_offloads_vport_metadata_cleanup(struct mlx5_eswitch *esw,
 	mlx5_esw_match_metadata_free(esw, vport->default_metadata);
 }
 
+static void esw_offloads_metadata_uninit(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	int i;
+
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
+		return;
+
+	mlx5_esw_for_all_vports_reverse(esw, i, vport)
+		esw_offloads_vport_metadata_cleanup(esw, vport);
+}
+
+static int esw_offloads_metadata_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	int err;
+	int i;
+
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
+		return 0;
+
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		err = esw_offloads_vport_metadata_setup(esw, vport);
+		if (err)
+			goto metadata_err;
+	}
+
+	return 0;
+
+metadata_err:
+	esw_offloads_metadata_uninit(esw);
+	return err;
+}
+
 int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
 {
 	int err;
 
-	err = esw_offloads_vport_metadata_setup(esw, vport);
-	if (err)
-		goto metadata_err;
-
 	err = esw_acl_ingress_ofld_setup(esw, vport);
 	if (err)
-		goto ingress_err;
+		return err;
 
 	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
 		err = esw_acl_egress_ofld_setup(esw, vport);
@@ -1947,9 +1977,6 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 
 egress_err:
 	esw_acl_ingress_ofld_cleanup(esw, vport);
-ingress_err:
-	esw_offloads_vport_metadata_cleanup(esw, vport);
-metadata_err:
 	return err;
 }
 
@@ -1959,7 +1986,6 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 {
 	esw_acl_egress_ofld_cleanup(vport);
 	esw_acl_ingress_ofld_cleanup(esw, vport);
-	esw_offloads_vport_metadata_cleanup(esw, vport);
 }
 
 static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
@@ -2138,6 +2164,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (esw_use_vport_metadata(esw))
 		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
+	err = esw_offloads_metadata_init(esw);
+	if (err)
+		goto err_metadata;
+
 	err = esw_set_passing_vport_metadata(esw, true);
 	if (err)
 		goto err_vport_metadata;
@@ -2170,6 +2200,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 err_steering_init:
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
+	esw_offloads_metadata_uninit(esw);
+err_metadata:
 	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
@@ -2204,6 +2236,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
+	esw_offloads_metadata_uninit(esw);
 	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
-- 
2.26.2

