Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCE633E266
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCPXvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhCPXvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6714664F92;
        Tue, 16 Mar 2021 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938679;
        bh=hbnQjnvu//vfmoCDwsYvX5qghwx2u4WJcf+d8fufV6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lkf4V+wzNUXc0qGu7DTHyelCwjNpvOyVtocjP51gtJNBzK9yXBcJ6cbPRQ6hOOhgt
         bNBtu3DBDt1k5asUoIkV8nH0Ax4xIk5IIT7umMG8I76PRYafdu/bUCJoCyFrzRGHmD
         PMkgeGOWsDMk6Q3RAo/56HdODqbV2LI+7xLJr4TNIsc1EtTVMw+f3gVFGlrcl2wwEX
         Kf4Dq34pjeDzOr8azpb3VyFQYag9d46qtP5hYm3C2V+xeC4bhktPZybxp6j6PehKP3
         C9kRKuL10REGMYzY661Mobk6qMvUooItTQhPq5U+2KnRO45E/B69+kBik8uumEnNi4
         BqPXl4NtUNHvQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Move devlink port register and unregister calls
Date:   Tue, 16 Mar 2021 16:51:05 -0700
Message-Id: <20210316235112.72626-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We will re-use the native NIC port net device instance for the Uplink
representor. As such we also don't want to unregister/register the
devlink port as part of the profile.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +++++++++++------
 .../mellanox/mlx5/core/eswitch_offloads.c       | 15 ++++++++++-----
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index efe8af49b908..3e8434dcc1df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5306,10 +5306,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
-	err = mlx5e_devlink_port_register(priv);
-	if (err)
-		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
-
 	mlx5e_health_create_reporters(priv);
 
 	return 0;
@@ -5318,7 +5314,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
-	mlx5e_devlink_port_unregister(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 }
@@ -5829,10 +5824,17 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 
 	priv->profile = profile;
 	priv->ppriv = NULL;
+
+	err = mlx5e_devlink_port_register(priv);
+	if (err) {
+		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
+		goto err_destroy_netdev;
+	}
+
 	err = profile->init(mdev, netdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_nic_profile init failed, %d\n", err);
-		goto err_destroy_netdev;
+		goto err_devlink_cleanup;
 	}
 
 	err = mlx5e_resume(adev);
@@ -5856,6 +5858,8 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	mlx5e_suspend(adev, state);
 err_profile_cleanup:
 	profile->cleanup(priv);
+err_devlink_cleanup:
+	mlx5e_devlink_port_unregister(priv);
 err_destroy_netdev:
 	mlx5e_destroy_netdev(priv);
 	return err;
@@ -5870,6 +5874,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
 	priv->profile->cleanup(priv);
+	mlx5e_devlink_port_unregister(priv);
 	mlx5e_destroy_netdev(priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a215ccee3e61..e1e33e991123 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2259,9 +2259,11 @@ int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return 0;
 
-	err = mlx5_esw_offloads_devlink_port_register(esw, vport_num);
-	if (err)
-		return err;
+	if (vport_num != MLX5_VPORT_UPLINK) {
+		err = mlx5_esw_offloads_devlink_port_register(esw, vport_num);
+		if (err)
+			return err;
+	}
 
 	err = mlx5_esw_offloads_rep_load(esw, vport_num);
 	if (err)
@@ -2269,7 +2271,8 @@ int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 	return err;
 
 load_err:
-	mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
+	if (vport_num != MLX5_VPORT_UPLINK)
+		mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
 	return err;
 }
 
@@ -2279,7 +2282,9 @@ void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 		return;
 
 	mlx5_esw_offloads_rep_unload(esw, vport_num);
-	mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
+
+	if (vport_num != MLX5_VPORT_UPLINK)
+		mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
 }
 
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
-- 
2.30.2

