Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4776B26B03C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgIOWFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49F921D80;
        Tue, 15 Sep 2020 20:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201559;
        bh=m6rs5ILt3u66PeGoJsfzJOjhBXLgEI0aIIIlRX6t8Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUIplKrAeVvPbTw1ROS4/R+s2nEEt3NYy5V4h50DgT1NHAEFqfa6wPg1m8PlnVPvc
         AUVSncZ3fDieU3MWyqLkx9wWeEwaNUcgEo4qeOntz3VJgUlp1y6T8rp5Whm2+/KIKP
         qy6Rt8wWGKNTZyMoi8QFYA9GYXFcMxxJ/6Rwqlio=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5: E-Switch, Check and enable metadata support flag before using
Date:   Tue, 15 Sep 2020 13:25:27 -0700
Message-Id: <20200915202533.64389-11-saeed@kernel.org>
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

Check E-Switch capabilities and enable metadata support flag
before using it to setup other features that need metadata.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c         | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b381cbca5852..4cbadb15297c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1968,16 +1968,9 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
-	int err;
-
-	if (esw_use_vport_metadata(esw))
-		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
-	err = esw_vport_create_offloads_acl_tables(esw, vport);
-	if (err)
-		esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
-	return err;
+	return esw_vport_create_offloads_acl_tables(esw, vport);
 }
 
 static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
@@ -1986,7 +1979,6 @@ static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 
 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
 	esw_vport_destroy_offloads_acl_tables(esw, vport);
-	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 }
 
 static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
@@ -2146,6 +2138,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vport_metadata;
 
+	if (esw_use_vport_metadata(esw))
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
+
 	err = esw_set_passing_vport_metadata(esw, true);
 	if (err)
 		goto err_vport_metadata;
@@ -2178,6 +2173,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 err_steering_init:
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
+	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	return err;
@@ -2211,6 +2207,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
+	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
-- 
2.26.2

