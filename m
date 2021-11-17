Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F35454D29
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbhKQS3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240022AbhKQS3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:29:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5FA7630EF;
        Wed, 17 Nov 2021 18:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173611;
        bh=Zx6bnepzAQ2wHJg4YTH9cSBpJbS0LJl3ALw5zfqVGOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJJVTXS0cB8q2/0+qVBWbuFa2ZO3OUR1YlUGpK0gGonXq8nhOB8FivtYlcGAxXYXd
         BSD7p8TBTZO1gum21VzUz1pmUVfvx5NmEkULwwcPBd4de4Ed0I0n7Wf7lBBQn9yBpB
         bEmV3gAvQb3BwO4GsQ7V4jFEA4EbBo0Ek3i2U61Se/ZRbRVgvQSPs6HbskO5F5OOn2
         aDgTAse4R6CQeuwVHqeETr9fBdmWv6X49R8EkCxa5LWhieeu1RWhxPNHR7iVjOqH6W
         6zEbmG5ddN5h9PKHkE7bAwRrJoJa5MHzaB2NrFB4Mb1B2IKrZrvVNMZqKAXi8P/uVJ
         ZWNR+wnKD0BFA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 4/6] devlink: Clean registration of devlink port
Date:   Wed, 17 Nov 2021 20:26:20 +0200
Message-Id: <9c3eb77a90a2be10d5c637981a8047160845f60f.1637173517.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
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
should be void and devlink->lock was intended to protect addition to
port_list.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |  7 +---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 23 ++-----------
 .../marvell/prestera/prestera_devlink.c       |  8 +----
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
 18 files changed, 41 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 5c464ea73576..c4a7122ee1fd 100644
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
index b9bd9f9472f6..ba4c463cb276 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -498,10 +498,6 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
 	struct ice_vsi *vsi;
-	struct device *dev;
-	int err;
-
-	dev = ice_pf_to_dev(pf);
 
 	devlink_port = &pf->devlink_port;
 
@@ -514,13 +510,7 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
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
 
@@ -554,12 +544,9 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
 	struct ice_vsi *vsi;
-	struct device *dev;
 	struct ice_pf *pf;
-	int err;
 
 	pf = vf->pf;
-	dev = ice_pf_to_dev(pf);
 	vsi = ice_get_vf_vsi(vf);
 	devlink_port = &vf->devlink_port;
 
@@ -570,13 +557,7 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
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
index 06279cd6da67..91a4ff2e412b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -422,7 +422,6 @@ int prestera_devlink_port_register(struct prestera_port *port)
 	struct prestera_switch *sw = port->sw;
 	struct devlink *dl = priv_to_devlink(sw);
 	struct devlink_port_attrs attrs = {};
-	int err;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = port->fp_id;
@@ -431,12 +430,7 @@ int prestera_devlink_port_register(struct prestera_port *port)
 
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
index 0fcf359a6975..fc534b7c3a96 100644
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
index 08d7b465a0de..1f0c085d8f76 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1380,10 +1380,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
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
@@ -1413,7 +1411,6 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 err_dl_port_unregister:
 	devlink_port_unregister(devlink_port);
-err_port_free:
 	kfree(nsim_dev_port);
 	return err;
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f919545f5781..bc2bdff043a3 100644
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
index af94015b7424..356057ea2e52 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -239,12 +239,6 @@ static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
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
@@ -9203,30 +9197,28 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
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
 
@@ -9241,9 +9233,11 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 
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

