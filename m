Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47586136B4
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiJaMnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiJaMnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:43:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA29CFAC8
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:57 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v1so15779058wrt.11
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oyvSl0/JOr4Hdiy/AbuHvG9RSEqrcyVVPtegvmyFcGw=;
        b=2kOsuanVZ0kYcJyAxYCTyiolZ379/GwbVHHeryo4CpcJLtEheWyg5TJg96EQCm8y2t
         bCUQTPFLLUN2rdszGpZG+ZVTgSOnGuUnD7RAGDqoxAOUJFBTaVgsBzSLJETjakfvoGW1
         X5sn15n9wtfQlg9MQ+kLjA4rOuAeeBojMVIgadrJmKUs+fHjJKen216Mt9veR/JvCYaX
         YjlRioUOjLgxAB76JRgqSVH/xSBJ5RT0RtQeuGAZCW49xrTPk4xKs1ZUa0qUkDH9x9Cg
         Y0sp7F2dbHHE0cqxCgOPAXCwGs7eEBnYfB2gtkQqX78I0gbvLjFo2XwX6i9CgMPdmPpl
         /xig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oyvSl0/JOr4Hdiy/AbuHvG9RSEqrcyVVPtegvmyFcGw=;
        b=blSICBLdbciVgxJX1g0u/7zTYcaLMMvWRKOApTCeAr091RPM4SeZB3BIz0UJjdDSVT
         bZ9nyOo+k1a+8953sldNvcwbkbKLDMHPInIIRvs1Pdncb0dzsPvq5aypaHlIcTqCj5yA
         n4PqorLt3hUwZE2cLPsFhAzPzAxPNCJxli2vDz0xOb5VhoU0tZMnXivuzPbxwBJaCgAs
         6MwxSdZIfpMVxmI6U4neasiNHhytkOIuSOaA27CknkP8EGzX5kh0dnr0+1kuKJ/Xko5q
         YwvQTQTNynTXm/40fncxkkS+iewj7qDLHeaN86Zpu3r54gHihhP/2cg5q43hvFqa9NMX
         OrCg==
X-Gm-Message-State: ACrzQf0aEZXtc2g0jZ0WnQZBBIf9ucXQCwxByLZDvo4tFiGRXwPgHOvi
        28BrbAvOqJNTeAFphhVeSEhLHo+B3V+usGgj
X-Google-Smtp-Source: AMsMyM5iA+71g0nFUwEplYNU22DGGA9D0c+K/1C4dBTCasA+5oIx/7YbU/3sctcMY3iV/gnBrweLiQ==
X-Received: by 2002:a5d:6f1e:0:b0:236:63f8:d03d with SMTP id ay30-20020a5d6f1e000000b0023663f8d03dmr7990909wrb.646.1667220177156;
        Mon, 31 Oct 2022 05:42:57 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e9-20020adffd09000000b00236488f62d6sm7084179wrr.79.2022.10.31.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:42:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 06/13] net: make drivers to use SET_NETDEV_DEVLINK_PORT to set devlink_port
Date:   Mon, 31 Oct 2022 13:42:41 +0100
Message-Id: <20221031124248.484405-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Benefit from the previously implemented tracking of netdev events in
devlink code and instead of calling  devlink_port_type_eth_set() and
devlink_port_type_clear() to set devlink port type and link to related
netdev, use SET_NETDEV_DEVLINK_PORT() macro to assign devlink_port
pointer to netdevice which is about to be registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- removed no longer used variable ocelot_port from ocelot_vsc7514.c
v1->v2:
- moved call to mlxsw_core_port_netdev_link() in spectrum.c and
  minimal.c to work with initialized value
- removed couple of no longer used variables from ocelot_vsc7514.c
- removed no londer used variable dev from
  mlx5e_vport_uplink_rep_unload()
- fixed over 80 cols warning in mlxsw/core.h
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 11 +------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  1 +
 .../ethernet/fungible/funeth/funeth_main.c    |  5 +--
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 14 ++------
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  3 +-
 .../marvell/prestera/prestera_devlink.c       | 10 ------
 .../marvell/prestera/prestera_devlink.h       |  3 --
 .../ethernet/marvell/prestera/prestera_main.c |  4 +--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  9 ++---
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  7 ----
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 33 ++++---------------
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 20 +++--------
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  7 ++--
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  6 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  5 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  9 -----
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 12 ++-----
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 11 ++-----
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  2 --
 .../ethernet/pensando/ionic/ionic_devlink.c   |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  6 ++--
 drivers/net/netdevsim/dev.c                   |  2 --
 drivers/net/netdevsim/netdev.c                |  1 +
 net/dsa/dsa2.c                                |  9 -----
 net/dsa/slave.c                               |  1 +
 30 files changed, 40 insertions(+), 167 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 04cf7684f1b0..9604294b67aa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13122,9 +13122,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
-	if (BNXT_PF(bp))
-		devlink_port_type_clear(&bp->dl_port);
-
 	bnxt_ptp_clear(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
@@ -13537,6 +13534,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	bp = netdev_priv(dev);
+	SET_NETDEV_DEVLINK_PORT(dev, &bp->dl_port);
 	bp->board_idx = ent->driver_data;
 	bp->msg_enable = BNXT_DEF_MSG_ENABLE;
 	bnxt_set_max_func_irqs(bp, max_irqs);
@@ -13712,8 +13710,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto init_err_cleanup;
 
-	if (BNXT_PF(bp))
-		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
 	bnxt_print_device_info(bp);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 7fefe1574b6a..5c6dd3029e2f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -226,25 +226,16 @@ int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv)
 {
 	struct devlink_port *devlink_port = &priv->devlink_port;
 	struct devlink_port_attrs attrs = {};
-	int err;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(devlink_port, &attrs);
-
-	err = devlink_port_register(priv->devlink, devlink_port, 0);
-	if (err)
-		return err;
-
-	devlink_port_type_eth_set(devlink_port, priv->net_dev);
-
-	return 0;
+	return devlink_port_register(priv->devlink, devlink_port, 0);
 }
 
 void dpaa2_eth_dl_port_del(struct dpaa2_eth_priv *priv)
 {
 	struct devlink_port *devlink_port = &priv->devlink_port;
 
-	devlink_port_type_clear(devlink_port);
 	devlink_port_unregister(devlink_port);
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 281d7e3905c1..c9ea37b81e4f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4780,6 +4780,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	priv = netdev_priv(net_dev);
 	priv->net_dev = net_dev;
+	SET_NETDEV_DEVLINK_PORT(net_dev, &priv->devlink_port);
 
 	priv->iommu_domain = iommu_get_domain_for_dev(dev);
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 095f51c4d9d9..208dc89f4972 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1760,6 +1760,7 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 		goto free_rss;
 
 	SET_NETDEV_DEV(netdev, fdev->dev);
+	SET_NETDEV_DEVLINK_PORT(netdev, &fp->dl_port);
 	netdev->netdev_ops = &fun_netdev_ops;
 
 	netdev->hw_features = NETIF_F_SG | NETIF_F_RXHASH | NETIF_F_RXCSUM;
@@ -1800,9 +1801,6 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	rc = register_netdev(netdev);
 	if (rc)
 		goto unreg_devlink;
-
-	devlink_port_type_eth_set(&fp->dl_port, netdev);
-
 	return 0;
 
 unreg_devlink:
@@ -1827,7 +1825,6 @@ static void fun_destroy_netdev(struct net_device *netdev)
 	struct funeth_priv *fp;
 
 	fp = netdev_priv(netdev);
-	devlink_port_type_clear(&fp->dl_port);
 	unregister_netdev(netdev);
 	devlink_port_unregister(&fp->dl_port);
 	fun_ktls_cleanup(fp);
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index e6ec20079ced..455489e9457d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1033,12 +1033,7 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
  */
 void ice_devlink_destroy_pf_port(struct ice_pf *pf)
 {
-	struct devlink_port *devlink_port;
-
-	devlink_port = &pf->devlink_port;
-
-	devlink_port_type_clear(devlink_port);
-	devlink_port_unregister(devlink_port);
+	devlink_port_unregister(&pf->devlink_port);
 }
 
 /**
@@ -1094,12 +1089,7 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
  */
 void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 {
-	struct devlink_port *devlink_port;
-
-	devlink_port = &vf->devlink_port;
-
-	devlink_port_type_clear(devlink_port);
-	devlink_port_unregister(devlink_port);
+	devlink_port_unregister(&vf->devlink_port);
 }
 
 #define ICE_DEVLINK_READ_BLK_SIZE (1024 * 1024)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1f27dc20b4f1..74d25fda11bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4603,6 +4603,7 @@ static int ice_register_netdev(struct ice_pf *pf)
 	if (err)
 		goto err_devlink_create;
 
+	SET_NETDEV_DEVLINK_PORT(vsi->netdev, &pf->devlink_port);
 	err = register_netdev(vsi->netdev);
 	if (err)
 		goto err_register_netdev;
@@ -4611,8 +4612,6 @@ static int ice_register_netdev(struct ice_pf *pf)
 	netif_carrier_off(vsi->netdev);
 	netif_tx_stop_all_queues(vsi->netdev);
 
-	devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
-
 	return 0;
 err_register_netdev:
 	ice_devlink_destroy_pf_port(pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index bd31748aae1b..663a7a0e1814 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -339,12 +339,11 @@ static int ice_repr_add(struct ice_vf *vf)
 	repr->netdev->max_mtu = ICE_MAX_MTU;
 
 	SET_NETDEV_DEV(repr->netdev, ice_pf_to_dev(vf->pf));
+	SET_NETDEV_DEVLINK_PORT(repr->netdev, &vf->devlink_port);
 	err = ice_repr_reg_netdev(repr->netdev);
 	if (err)
 		goto err_netdev;
 
-	devlink_port_type_eth_set(&vf->devlink_port, repr->netdev);
-
 	ice_virtchnl_set_repr_ops(vf);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 06279cd6da67..637b8fee65e7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -445,16 +445,6 @@ void prestera_devlink_port_unregister(struct prestera_port *port)
 	devlink_port_unregister(&port->dl_port);
 }
 
-void prestera_devlink_port_set(struct prestera_port *port)
-{
-	devlink_port_type_eth_set(&port->dl_port, port->dev);
-}
-
-void prestera_devlink_port_clear(struct prestera_port *port)
-{
-	devlink_port_type_clear(&port->dl_port);
-}
-
 struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
 {
 	struct prestera_port *port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
index b322295bad3a..04e8556f748a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -15,9 +15,6 @@ void prestera_devlink_unregister(struct prestera_switch *sw);
 int prestera_devlink_port_register(struct prestera_port *port);
 void prestera_devlink_port_unregister(struct prestera_port *port);
 
-void prestera_devlink_port_set(struct prestera_port *port);
-void prestera_devlink_port_clear(struct prestera_port *port);
-
 struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
 
 void prestera_devlink_trap_report(struct prestera_port *port,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 24f9d6024745..a76bf3606aa6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -644,6 +644,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 	SET_NETDEV_DEV(dev, sw->dev->dev);
+	SET_NETDEV_DEVLINK_PORT(dev, &port->dl_port);
 
 	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP)
 		netif_carrier_off(dev);
@@ -737,8 +738,6 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
-	prestera_devlink_port_set(port);
-
 	err = prestera_port_sfp_bind(port);
 	if (err)
 		goto err_sfp_bind;
@@ -761,7 +760,6 @@ static void prestera_port_destroy(struct prestera_port *port)
 	struct net_device *dev = port->dev;
 
 	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
-	prestera_devlink_port_clear(port);
 	unregister_netdev(dev);
 	prestera_port_list_del(port);
 	prestera_devlink_port_unregister(port);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index ca4b93a01034..8800d3f1f55c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2337,11 +2337,8 @@ void mlx4_en_destroy_netdev(struct net_device *dev)
 	en_dbg(DRV, priv, "Destroying netdev on port:%d\n", priv->port);
 
 	/* Unregister device - this will close the port if it was up */
-	if (priv->registered) {
-		devlink_port_type_clear(mlx4_get_devlink_port(mdev->dev,
-							      priv->port));
+	if (priv->registered)
 		unregister_netdev(dev);
-	}
 
 	if (priv->allocated)
 		mlx4_free_hwq_res(mdev->dev, &priv->res, MLX4_EN_PAGE_SIZE);
@@ -3474,6 +3471,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 				 mdev->profile.prof[priv->port].tx_ppp,
 				 mdev->profile.prof[priv->port].tx_pause);
 
+	SET_NETDEV_DEVLINK_PORT(dev,
+				mlx4_get_devlink_port(mdev->dev, priv->port));
 	err = register_netdev(dev);
 	if (err) {
 		en_err(priv, "Netdev registration failed for port %d\n", port);
@@ -3481,8 +3480,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	}
 
 	priv->registered = 1;
-	devlink_port_type_eth_set(mlx4_get_devlink_port(mdev->dev, priv->port),
-				  dev);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index b69f9d10ccbd..ce0e56f856d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -51,13 +51,6 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 	return ret;
 }
 
-void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
-{
-	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
-
-	devlink_port_type_eth_set(dl_port, priv->netdev);
-}
-
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 10b50feb9883..1c203257ac30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -9,7 +9,6 @@
 
 int mlx5e_devlink_port_register(struct mlx5e_priv *priv);
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
-void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv);
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev);
 
 static inline struct devlink_port *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 364f04309149..97e876472a06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5932,14 +5932,13 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 		goto err_profile_cleanup;
 	}
 
+	SET_NETDEV_DEVLINK_PORT(netdev, mlx5e_devlink_get_dl_port(priv));
 	err = register_netdev(netdev);
 	if (err) {
 		mlx5_core_err(mdev, "register_netdev failed, %d\n", err);
 		goto err_resume;
 	}
 
-	mlx5e_devlink_port_type_eth_set(priv);
-
 	mlx5e_dcbnl_init_app(priv);
 	mlx5_uplink_netdev_set(mdev, netdev);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 794cd8dfe9c9..e81d7fcd88e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1253,37 +1253,20 @@ mlx5e_vport_uplink_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *
 {
 	struct mlx5e_priv *priv = netdev_priv(mlx5_uplink_netdev_get(dev));
 	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
-	struct devlink_port *dl_port;
-	int err;
 
 	rpriv->netdev = priv->netdev;
-
-	err = mlx5e_netdev_change_profile(priv, &mlx5e_uplink_rep_profile,
-					  rpriv);
-	if (err)
-		return err;
-
-	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-	if (dl_port)
-		devlink_port_type_eth_set(dl_port, rpriv->netdev);
-
-	return 0;
+	return mlx5e_netdev_change_profile(priv, &mlx5e_uplink_rep_profile,
+					   rpriv);
 }
 
 static void
 mlx5e_vport_uplink_rep_unload(struct mlx5e_rep_priv *rpriv)
 {
 	struct net_device *netdev = rpriv->netdev;
-	struct devlink_port *dl_port;
-	struct mlx5_core_dev *dev;
 	struct mlx5e_priv *priv;
 
 	priv = netdev_priv(netdev);
-	dev = priv->mdev;
 
-	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-	if (dl_port)
-		devlink_port_type_clear(dl_port);
 	mlx5e_netdev_attach_nic_profile(priv);
 }
 
@@ -1326,6 +1309,10 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_cleanup_profile;
 	}
 
+	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
+	if (dl_port)
+		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
+
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_warn(netdev,
@@ -1334,9 +1321,6 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
-	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-	if (dl_port)
-		devlink_port_type_eth_set(dl_port, netdev);
 	return 0;
 
 err_detach_netdev:
@@ -1382,8 +1366,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5_core_dev *dev = priv->mdev;
-	struct devlink_port *dl_port;
 	void *ppriv = priv->ppriv;
 
 	if (rep->vport == MLX5_VPORT_UPLINK) {
@@ -1391,9 +1373,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 		goto free_ppriv;
 	}
 
-	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-	if (dl_port)
-		devlink_port_type_clear(dl_port);
 	unregister_netdev(netdev);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e2a985ec2c76..a83f6bc30072 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3172,29 +3172,17 @@ void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_cpu_port_fini);
 
-void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
-			     void *port_driver_priv, struct net_device *dev)
+void mlxsw_core_port_netdev_link(struct mlxsw_core *mlxsw_core, u16 local_port,
+				 void *port_driver_priv, struct net_device *dev)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
 	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
 
 	mlxsw_core_port->port_driver_priv = port_driver_priv;
-	devlink_port_type_eth_set(devlink_port, dev);
+	SET_NETDEV_DEVLINK_PORT(dev, devlink_port);
 }
-EXPORT_SYMBOL(mlxsw_core_port_eth_set);
-
-void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
-			   void *port_driver_priv)
-{
-	struct mlxsw_core_port *mlxsw_core_port =
-					&mlxsw_core->ports[local_port];
-	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
-
-	mlxsw_core_port->port_driver_priv = port_driver_priv;
-	devlink_port_type_clear(devlink_port);
-}
-EXPORT_SYMBOL(mlxsw_core_port_clear);
+EXPORT_SYMBOL(mlxsw_core_port_netdev_link);
 
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index ca0c3d2bee6b..e0a6fcbbcb19 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -264,10 +264,9 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 			     const unsigned char *switch_id,
 			     unsigned char switch_id_len);
 void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
-void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
-			     void *port_driver_priv, struct net_device *dev);
-void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
-			   void *port_driver_priv);
+void mlxsw_core_port_netdev_link(struct mlxsw_core *mlxsw_core, u16 local_port,
+				 void *port_driver_priv,
+				 struct net_device *dev);
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u16 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 55b3c42bb007..177cf7e4db34 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -265,6 +265,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
 	SET_NETDEV_DEV(dev, mlxsw_m->bus_info->dev);
 	dev_net_set(dev, mlxsw_core_net(mlxsw_m->core));
 	mlxsw_m_port = netdev_priv(dev);
+	mlxsw_core_port_netdev_link(mlxsw_m->core, local_port,
+				    mlxsw_m_port, dev);
 	mlxsw_m_port->dev = dev;
 	mlxsw_m_port->mlxsw_m = mlxsw_m;
 	mlxsw_m_port->local_port = local_port;
@@ -298,9 +300,6 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
 		goto err_register_netdev;
 	}
 
-	mlxsw_core_port_eth_set(mlxsw_m->core, mlxsw_m_port->local_port,
-				mlxsw_m_port, dev);
-
 	return 0;
 
 err_register_netdev:
@@ -316,7 +315,6 @@ static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u16 local_port)
 {
 	struct mlxsw_m_port *mlxsw_m_port = mlxsw_m->ports[local_port];
 
-	mlxsw_core_port_clear(mlxsw_m->core, local_port, mlxsw_m);
 	unregister_netdev(mlxsw_m_port->dev); /* This calls ndo_stop */
 	mlxsw_m->ports[local_port] = NULL;
 	free_netdev(mlxsw_m_port->dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6ed496f6cbfb..b13739e1f8f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1651,6 +1651,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	SET_NETDEV_DEV(dev, mlxsw_sp->bus_info->dev);
 	dev_net_set(dev, mlxsw_sp_net(mlxsw_sp));
 	mlxsw_sp_port = netdev_priv(dev);
+	mlxsw_core_port_netdev_link(mlxsw_sp->core, local_port,
+				    mlxsw_sp_port, dev);
 	mlxsw_sp_port->dev = dev;
 	mlxsw_sp_port->mlxsw_sp = mlxsw_sp;
 	mlxsw_sp_port->local_port = local_port;
@@ -1839,8 +1841,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 		goto err_register_netdev;
 	}
 
-	mlxsw_core_port_eth_set(mlxsw_sp->core, mlxsw_sp_port->local_port,
-				mlxsw_sp_port, dev);
 	mlxsw_core_schedule_dw(&mlxsw_sp_port->periodic_hw_stats.update_dw, 0);
 	return 0;
 
@@ -1897,7 +1897,6 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
-	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
 	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_sp_port_vlan_classification_set(mlxsw_sp_port, true, true);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 50858cc10fef..5efc07751c8d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1873,6 +1873,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	if (ocelot->fdma)
 		ocelot_fdma_netdev_init(ocelot, dev);
 
+	SET_NETDEV_DEVLINK_PORT(dev, &ocelot->devlink_ports[port]);
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6f22aea08a64..93431d2ff4f1 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -377,9 +377,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		return -ENOMEM;
 
 	for_each_available_child_of_node(ports, portnp) {
-		struct ocelot_port_private *priv;
-		struct ocelot_port *ocelot_port;
-		struct devlink_port *dlp;
 		struct regmap *target;
 		struct resource *res;
 		char res_name[8];
@@ -420,12 +417,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		}
 
 		devlink_ports_registered |= BIT(port);
-
-		ocelot_port = ocelot->ports[port];
-		priv = container_of(ocelot_port, struct ocelot_port_private,
-				    port);
-		dlp = &ocelot->devlink_ports[port];
-		devlink_port_type_eth_set(dlp, priv->dev);
 	}
 
 	/* Initialize unused devlink ports at the end */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 405786c00334..f3f0f11d8b52 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -334,6 +334,8 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 	int serial_len;
 	int ret;
 
+	SET_NETDEV_DEVLINK_PORT(port->netdev, &port->dl_port);
+
 	rtnl_lock();
 	ret = nfp_devlink_fill_eth_port(port, &eth_port);
 	rtnl_unlock();
@@ -361,16 +363,6 @@ void nfp_devlink_port_unregister(struct nfp_port *port)
 	devl_port_unregister(&port->dl_port);
 }
 
-void nfp_devlink_port_type_eth_set(struct nfp_port *port)
-{
-	devlink_port_type_eth_set(&port->dl_port, port->netdev);
-}
-
-void nfp_devlink_port_type_clear(struct nfp_port *port)
-{
-	devlink_port_type_clear(&port->dl_port);
-}
-
 struct devlink_port *nfp_devlink_get_devlink_port(struct net_device *netdev)
 {
 	struct nfp_port *port;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 3bae92dc899e..7abf0c576868 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -156,22 +156,17 @@ nfp_net_pf_init_vnic(struct nfp_pf *pf, struct nfp_net *nn, unsigned int id)
 
 	nfp_net_debugfs_vnic_add(nn, pf->ddir);
 
-	if (nn->port)
-		nfp_devlink_port_type_eth_set(nn->port);
-
 	nfp_net_info(nn);
 
 	if (nfp_net_is_data_vnic(nn)) {
 		err = nfp_app_vnic_init(pf->app, nn);
 		if (err)
-			goto err_devlink_port_type_clean;
+			goto err_debugfs_vnic_clean;
 	}
 
 	return 0;
 
-err_devlink_port_type_clean:
-	if (nn->port)
-		nfp_devlink_port_type_clear(nn->port);
+err_debugfs_vnic_clean:
 	nfp_net_debugfs_dir_clean(&nn->debugfs_dir);
 	nfp_net_clean(nn);
 err_devlink_port_clean:
@@ -220,8 +215,6 @@ static void nfp_net_pf_clean_vnic(struct nfp_pf *pf, struct nfp_net *nn)
 {
 	if (nfp_net_is_data_vnic(nn))
 		nfp_app_vnic_clean(pf->app, nn);
-	if (nn->port)
-		nfp_devlink_port_type_clear(nn->port);
 	nfp_net_debugfs_dir_clean(&nn->debugfs_dir);
 	nfp_net_clean(nn);
 	if (nn->port)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index 6793cdf9ff11..f8cd157ca1d7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -129,8 +129,6 @@ int nfp_net_refresh_port_table_sync(struct nfp_pf *pf);
 
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port);
 void nfp_devlink_port_unregister(struct nfp_port *port);
-void nfp_devlink_port_type_eth_set(struct nfp_port *port);
-void nfp_devlink_port_type_clear(struct nfp_port *port);
 
 /* Mac stats (0x0000 - 0x0200)
  * all counters are 64bit.
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 4297ed9024c0..567f778433e2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -90,7 +90,7 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
-	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
+	SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
 	devlink_register(dl);
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8800c8a010ff..b2a08f3f0e93 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2534,7 +2534,6 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
-	struct devlink_port *dl_port;
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
@@ -2561,15 +2560,14 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		if (!port->ndev)
 			continue;
 
+		SET_NETDEV_DEVLINK_PORT(port->ndev, &port->devlink_port);
+
 		ret = register_netdev(port->ndev);
 		if (ret) {
 			dev_err(dev, "error registering slave net device%i %d\n",
 				i, ret);
 			goto err_cleanup_ndev;
 		}
-
-		dl_port = &port->devlink_port;
-		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 
 	ret = am65_cpsw_register_notifiers(common);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index a7880c7ce94c..387c05953a8b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1406,7 +1406,6 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 			goto err_nsim_destroy;
 	}
 
-	devlink_port_type_eth_set(devlink_port, nsim_dev_port->ns->netdev);
 	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
 
 	return 0;
@@ -1429,7 +1428,6 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 	list_del(&nsim_dev_port->list);
 	if (nsim_dev_port_is_vf(nsim_dev_port))
 		devl_rate_leaf_destroy(&nsim_dev_port->devlink_port);
-	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 	devl_port_unregister(devlink_port);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e470e3398abc..e7cbae743e86 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -360,6 +360,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	ns->nsim_dev_port = nsim_dev_port;
 	ns->nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	SET_NETDEV_DEV(dev, &ns->nsim_bus_dev->dev);
+	SET_NETDEV_DEVLINK_PORT(dev, &nsim_dev_port->devlink_port);
 	nsim_ethtool_init(ns);
 	if (nsim_dev_port_is_pf(nsim_dev_port))
 		err = nsim_init_netdevsim(ns);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index af0e2c0394ac..65d3ed16cf94 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -529,7 +529,6 @@ static void dsa_port_devlink_teardown(struct dsa_port *dp)
 
 static int dsa_port_setup(struct dsa_port *dp)
 {
-	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
 	struct dsa_switch *ds = dp->ds;
 	bool dsa_port_enabled = false;
@@ -585,10 +584,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 	case DSA_PORT_TYPE_USER:
 		of_get_mac_address(dp->dn, dp->mac);
 		err = dsa_slave_create(dp);
-		if (err)
-			break;
-
-		devlink_port_type_eth_set(dlp, dp->slave);
 		break;
 	}
 
@@ -608,13 +603,9 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
-	struct devlink_port *dlp = &dp->devlink_port;
-
 	if (!dp->setup)
 		return;
 
-	devlink_port_type_clear(dlp);
-
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		break;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 83e419afa89e..158bb3f1aa0b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2406,6 +2406,7 @@ int dsa_slave_create(struct dsa_port *port)
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
+	SET_NETDEV_DEVLINK_PORT(slave_dev, &port->devlink_port);
 	slave_dev->dev.of_node = port->dn;
 	slave_dev->vlan_features = master->vlan_features;
 
-- 
2.37.3

