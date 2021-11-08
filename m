Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3894449A6B
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbhKHRIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238330AbhKHRIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F046120A;
        Mon,  8 Nov 2021 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391155;
        bh=OqoIKWyNaAHPenUA8WewEBpsj4ua1vpA7Yv2HzR1hfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eg2dL1x2mBU4mMAyKbmJctFPQ/L1Xq8V8NwYtdTKMW7KEb2ejMe2JN65T93rf22Mt
         lNey9IHSKDVGSNmab9CWY61oLL4nPiIfutrfFkzO/K1yqK9GCnu/xYcUaCAFKPYQYK
         otJrNzqZLkv97GWHscfL3g9RpXrSMOAccH1OVliqywlr1Bdv60WxAbc/rQGnxqBSxd
         LWlki/giV52+3svqRjyM/0wyybC15GDULRdL2zF+ix5Ub1n4dp9FGgYzqVUTBZyD3b
         ACdz0IlsV5M3pH5jpZ1jN+wjGVchgTF4Tr0Lo4zPVUCYFinCKwcpWMM98WwAv4jWer
         UsixOwrsCY/Wg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 04/16] devlink: Clean registration of devlink port
Date:   Mon,  8 Nov 2021 19:05:26 +0200
Message-Id: <3c73f365d81cf18adf846a4ef36e605ad52acd0a.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

devlink_port_register() is in-kernel API and as such can't really fail
as long as driver author didn't make a mistake by providing already existing
port index. Instead of relying on various error prints from the driver,
convert the existence check to be WARN_ON(), so such a mistake will be
caught easier.

As an outcome of this conversion, it was made clear that this function
should be void and devlink->rwsem was intended to protect addition to
port_list.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |  7 +---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 18 ++---------
 .../marvell/prestera/prestera_devlink.c       |  7 +---
 drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +--
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  5 ++-
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +---
 .../mellanox/mlx5/core/esw/devlink_port.c     |  9 ++----
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  7 ++--
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +--
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  4 +--
 .../ethernet/pensando/ionic/ionic_devlink.c   |  8 +----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 14 +-------
 drivers/net/netdevsim/dev.c                   |  7 ++--
 include/net/devlink.h                         |  6 ++--
 net/core/devlink.c                            | 32 ++++++++-----------
 net/dsa/dsa2.c                                |  9 ++----
 18 files changed, 41 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index ce790e9b45c3..048027955cef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -1209,11 +1209,7 @@ int bnxt_dl_register(struct bnxt *bp)
 	memcpy(attrs.switch_id.id, bp->dsn, sizeof(bp->dsn));
 	attrs.switch_id.id_len = sizeof(bp->dsn);
 	devlink_port_attrs_set(&bp->dl_port, &attrs);
-	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
-	if (rc) {
-		netdev_err(bp->dev, "devlink_port_register failed\n");
-		goto err_dl_free;
-	}
+	devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 
 	rc = bnxt_dl_params_register(bp);
 	if (rc)
@@ -1225,7 +1221,6 @@ int bnxt_dl_register(struct bnxt *bp)
 
 err_dl_port_unreg:
 	devlink_port_unregister(&bp->dl_port);
-err_dl_free:
 	devlink_free(dl);
 	return rc;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 7fefe1574b6a..d19423780e59 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -226,17 +226,12 @@ int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv)
 {
 	struct devlink_port *devlink_port = &priv->devlink_port;
 	struct devlink_port_attrs attrs = {};
-	int err;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(devlink_port, &attrs);
 
-	err = devlink_port_register(priv->devlink, devlink_port, 0);
-	if (err)
-		return err;
-
+	devlink_port_register(priv->devlink, devlink_port, 0);
 	devlink_port_type_eth_set(devlink_port, priv->net_dev);
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index b9bd9f9472f6..fb5d0f4ade4e 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -499,7 +499,6 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 	struct devlink *devlink;
 	struct ice_vsi *vsi;
 	struct device *dev;
-	int err;
 
 	dev = ice_pf_to_dev(pf);
 
@@ -514,13 +513,7 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 	devlink_port_attrs_set(devlink_port, &attrs);
 	devlink = priv_to_devlink(pf);
 
-	err = devlink_port_register(devlink, devlink_port, vsi->idx);
-	if (err) {
-		dev_err(dev, "Failed to create devlink port for PF %d, error %d\n",
-			pf->hw.pf_id, err);
-		return err;
-	}
-
+	devlink_port_register(devlink, devlink_port, vsi->idx);
 	return 0;
 }
 
@@ -556,7 +549,6 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
 	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_pf *pf;
-	int err;
 
 	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
@@ -570,13 +562,7 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
 	devlink_port_attrs_set(devlink_port, &attrs);
 	devlink = priv_to_devlink(pf);
 
-	err = devlink_port_register(devlink, devlink_port, vsi->idx);
-	if (err) {
-		dev_err(dev, "Failed to create devlink port for VF %d, error %d\n",
-			vf->vf_id, err);
-		return err;
-	}
-
+	devlink_port_register(devlink, devlink_port, vsi->idx);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 06279cd6da67..b211b19460eb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -431,12 +431,7 @@ int prestera_devlink_port_register(struct prestera_port *port)
 
 	devlink_port_attrs_set(&port->dl_port, &attrs);
 
-	err = devlink_port_register(dl, &port->dl_port, port->fp_id);
-	if (err) {
-		dev_err(prestera_dev(sw), "devlink_port_register failed: %d\n", err);
-		return err;
-	}
-
+	devlink_port_register(dl, &port->dl_port, port->fp_id);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index b187c210d4d6..c88a586ecd8d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3033,9 +3033,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	int err;
 
-	err = devlink_port_register(devlink, &info->devlink_port, port);
-	if (err)
-		return err;
+	devlink_port_register(devlink, &info->devlink_port, port);
 
 	/* Ethernet and IB drivers will normally set the port type,
 	 * but if they are not built set the type now to prevent
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index ae52e7f38306..76326858db22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -14,7 +14,7 @@ mlx5e_devlink_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_i
 	memcpy(ppid->id, &parent_id, sizeof(parent_id));
 }
 
-int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
+void mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv->mdev);
 	struct devlink_port_attrs attrs = {};
@@ -40,8 +40,7 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 	dl_port = mlx5e_devlink_get_dl_port(priv);
 	memset(dl_port, 0, sizeof(*dl_port));
 	devlink_port_attrs_set(dl_port, &attrs);
-
-	return devlink_port_register(devlink, dl_port, dl_port_index);
+	devlink_port_register(devlink, dl_port, dl_port_index);
 }
 
 void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 10b50feb9883..04ada8624367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -7,7 +7,7 @@
 #include <net/devlink.h>
 #include "en.h"
 
-int mlx5e_devlink_port_register(struct mlx5e_priv *priv);
+void mlx5e_devlink_port_register(struct mlx5e_priv *priv);
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
 void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv);
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65571593ec5c..385533dce1bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5461,11 +5461,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->profile = profile;
 	priv->ppriv = NULL;
 
-	err = mlx5e_devlink_port_register(priv);
-	if (err) {
-		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
-		goto err_destroy_netdev;
-	}
+	mlx5e_devlink_port_register(priv);
 
 	err = profile->init(mdev, netdev);
 	if (err) {
@@ -5497,7 +5493,6 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	profile->cleanup(priv);
 err_devlink_cleanup:
 	mlx5e_devlink_port_unregister(priv);
-err_destroy_netdev:
 	mlx5e_destroy_netdev(priv);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 7f9b96d9537e..d1550f661644 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -87,9 +87,7 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
-	err = devlink_port_register(devlink, dl_port, dl_port_index);
-	if (err)
-		goto reg_err;
+	devlink_port_register(devlink, dl_port, dl_port_index);
 
 	err = devlink_rate_leaf_create(dl_port, vport);
 	if (err)
@@ -100,7 +98,6 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 
 rate_err:
 	devlink_port_unregister(dl_port);
-reg_err:
 	mlx5_esw_dl_port_free(dl_port);
 	return err;
 }
@@ -156,9 +153,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	devlink_port_attrs_pci_sf_set(dl_port, controller, pfnum, sfnum, !!controller);
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
-	err = devlink_port_register(devlink, dl_port, dl_port_index);
-	if (err)
-		return err;
+	devlink_port_register(devlink, dl_port, dl_port_index);
 
 	err = devlink_rate_leaf_create(dl_port, vport);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0d1f08bbf631..7684a86c1745 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2760,7 +2760,6 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 					&mlxsw_core->ports[local_port];
 	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
 	struct devlink_port_attrs attrs = {};
-	int err;
 
 	attrs.split = split;
 	attrs.lanes = lanes;
@@ -2772,10 +2771,8 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	attrs.switch_id.id_len = switch_id_len;
 	mlxsw_core_port->local_port = local_port;
 	devlink_port_attrs_set(devlink_port, &attrs);
-	err = devlink_port_register(devlink, devlink_port, local_port);
-	if (err)
-		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
-	return err;
+	devlink_port_register(devlink, devlink_port, local_port);
+	return 0;
 }
 
 static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index eaeba60b1bba..fc6db586a7ea 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -172,8 +172,8 @@ int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 	attrs.flavour = flavour;
 
 	devlink_port_attrs_set(dlp, &attrs);
-
-	return devlink_port_register(dl, dlp, port);
+	devlink_port_register(dl, dlp, port);
+	return 0;
 }
 
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index bea978df7713..ed53462ac9c2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -374,8 +374,8 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 	devlink_port_attrs_set(&port->dl_port, &attrs);
 
 	devlink = priv_to_devlink(app->pf);
-
-	return devlink_port_register(devlink, &port->dl_port, port->eth_id);
+	devlink_port_register(devlink, &port->dl_port, port->eth_id);
+	return 0;
 }
 
 void nfp_devlink_port_unregister(struct nfp_port *port)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 4297ed9024c0..f8c80856ca02 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -80,16 +80,10 @@ int ionic_devlink_register(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 	struct devlink_port_attrs attrs = {};
-	int err;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
-	err = devlink_port_register(dl, &ionic->dl_port, 0);
-	if (err) {
-		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-		return err;
-	}
-
+	devlink_port_register(dl, &ionic->dl_port, 0);
 	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
 	devlink_register(dl);
 	return 0;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c092cb61416a..2e3cc08da998 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2453,24 +2453,12 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 		memcpy(attrs.switch_id.id, common->switch_id, attrs.switch_id.id_len);
 		devlink_port_attrs_set(dl_port, &attrs);
 
-		ret = devlink_port_register(common->devlink, dl_port, port->port_id);
-		if (ret) {
-			dev_err(dev, "devlink_port reg fail for port %d, ret:%d\n",
-				port->port_id, ret);
-			goto dl_port_unreg;
-		}
+		devlink_port_register(common->devlink, dl_port, port->port_id);
 		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 	devlink_register(common->devlink);
 	return ret;
 
-dl_port_unreg:
-	for (i = i - 1; i >= 1; i--) {
-		port = am65_common_get_port(common, i);
-		dl_port = &port->devlink_port;
-
-		devlink_port_unregister(dl_port);
-	}
 dl_unreg:
 	devlink_free(common->devlink);
 	return ret;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 4a8ca4896d9d..a0152cfb2197 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1298,10 +1298,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
-	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    nsim_dev_port->port_index);
-	if (err)
-		goto err_port_free;
+	devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
+			      nsim_dev_port->port_index);
 
 	err = nsim_dev_port_debugfs_init(nsim_dev, nsim_dev_port);
 	if (err)
@@ -1331,7 +1329,6 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 err_dl_port_unregister:
 	devlink_port_unregister(devlink_port);
-err_port_free:
 	kfree(nsim_dev_port);
 	return err;
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index a888aa13e219..313553f73963 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1511,9 +1511,9 @@ void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
-int devlink_port_register(struct devlink *devlink,
-			  struct devlink_port *devlink_port,
-			  unsigned int port_index);
+void devlink_port_register(struct devlink *devlink,
+			   struct devlink_port *devlink_port,
+			   unsigned int port_index);
 void devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 56a1ee65bce5..b41ab8751635 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -237,12 +237,6 @@ static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 	return NULL;
 }
 
-static bool devlink_port_index_exists(struct devlink *devlink,
-				      unsigned int port_index)
-{
-	return devlink_port_get_by_index(devlink, port_index);
-}
-
 static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
 							struct nlattr **attrs)
 {
@@ -9201,30 +9195,28 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
  */
-int devlink_port_register(struct devlink *devlink,
-			  struct devlink_port *devlink_port,
-			  unsigned int port_index)
+void devlink_port_register(struct devlink *devlink,
+			   struct devlink_port *devlink_port,
+			   unsigned int port_index)
 {
-	mutex_lock(&devlink->lock);
-	if (devlink_port_index_exists(devlink, port_index)) {
-		mutex_unlock(&devlink->lock);
-		return -EEXIST;
-	}
-
+	WARN_ON(devlink_port_get_by_index(devlink, port_index));
 	WARN_ON(devlink_port->devlink);
+
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
-	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	INIT_LIST_HEAD(&devlink_port->region_list);
-	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
-	devlink_port_type_warn_schedule(devlink_port);
+
+	mutex_lock(&devlink->lock);
+	list_add_tail(&devlink_port->list, &devlink->port_list);
+	mutex_unlock(&devlink->lock);
+
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-	return 0;
+	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
@@ -9239,9 +9231,11 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
+
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_port->list);
 	mutex_unlock(&devlink->lock);
+
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 826957b6442b..29f39f761e05 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -504,7 +504,6 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 	struct devlink *dl = dp->ds->devlink;
 	const unsigned char *id;
 	unsigned char len;
-	int err;
 
 	id = (const unsigned char *)&dst->index;
 	len = sizeof(dst->index);
@@ -530,12 +529,10 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 	}
 
 	devlink_port_attrs_set(dlp, &attrs);
-	err = devlink_port_register(dl, dlp, dp->index);
-
-	if (!err)
-		dp->devlink_port_setup = true;
+	devlink_port_register(dl, dlp, dp->index);
+	dp->devlink_port_setup = true;
 
-	return err;
+	return 0;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
-- 
2.33.1

