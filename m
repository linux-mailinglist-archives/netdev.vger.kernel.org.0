Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641805F1A1A
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJAGCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJAGCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:02 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E90FDDDB7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id nb11so12938572ejc.5
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=IZ/T+Jo4/iNXyfkuoWGGo7JyJu0/3mqEzaXgv4JixB4=;
        b=IpTEquSCGsFcvgvrlP/w7T49zgjfK7+tSgAyPGyIs+a5HZVjXXPnZ6tXOn+eEeuy8K
         PhmQTfYB++qluE+OyGzbV3hf0vJfUcKJr44K9b6XptUDV5sBSdHXhtrqZiXsaq44Jant
         gEYz4zLlktN7ZQiMQnocdNqftXAtamJoEjfnuab65BTWsDdn0HyIwUgoDAXdNw49EE4E
         yDG0l+0O/+ti/VfI/gl6v9BNBwFlzgI5gJ8/jtn6M5zDD3/7Ez32HcOy9PxmErTGAR/i
         l8Wo7ASyNHmZWFp+asnIp/YDIK/0E+OT5rNDE/38d9qxnJy3DenguRtFVAqXeUywr5wP
         tYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IZ/T+Jo4/iNXyfkuoWGGo7JyJu0/3mqEzaXgv4JixB4=;
        b=qmw1Ii4kSJwfyfnK7ENd6ShcGuD9Z0qFLm40FpWXbfSo1J6tX0Y2FKLDdxguuGgqI7
         g0vP1fvyQCQ3BIPvNMN60diXg0Ylb8s75p7Qnp9nQaNbL9+g19wurZ7SjkslzMYusLz7
         XTMJ/iuwIxl6yepHI3v22H36dYrnrqATB03HwJ7hkioNqBJaFGtTmTk3QiForsTktPXR
         MF5ayh/UiZd89J2Ooec78SosMo8nMwBiuHjo8EEG9Lmdt1gwkyupCSW+HZnhP+CAsjgt
         TRRPDyD6y5KcJgMLAbOwGqpgdXnK6HdPorRQk2IBqfzYmw6uvqjiZQ6zYFH+9F4G1taz
         gISA==
X-Gm-Message-State: ACrzQf379CPXjpepMV1u9ksogYU3F40wiNqaIKSRtZFDsPoB3VqMMVIT
        jXICmmF1eKnS5d7ZdrhfvRK9WePwIWXx4TT2
X-Google-Smtp-Source: AMsMyM5IQEHBh1QhqQaS5k+EKyrYE16PHweM4vUpwz7Di9HnFGTMryiGI2T1zv6l861sRdadnxLRrA==
X-Received: by 2002:a17:906:5a4c:b0:76f:3e98:b453 with SMTP id my12-20020a1709065a4c00b0076f3e98b453mr8692514ejc.509.1664604117485;
        Fri, 30 Sep 2022 23:01:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k4-20020a170906158400b0073d87068042sm2199661ejd.110.2022.09.30.23.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 06/13] net: make drivers to use SET_NETDEV_DEVLINK_PORT to set devlink_port
Date:   Sat,  1 Oct 2022 08:01:38 +0200
Message-Id: <20221001060145.3199964-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 11 +------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  1 +
 .../ethernet/fungible/funeth/funeth_main.c    |  5 +--
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 14 ++-------
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  3 +-
 .../marvell/prestera/prestera_devlink.c       | 10 ------
 .../marvell/prestera/prestera_devlink.h       |  3 --
 .../ethernet/marvell/prestera/prestera_main.c |  4 +--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  9 ++----
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  7 -----
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 31 ++++---------------
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 20 +++---------
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  6 ++--
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  7 ++---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  5 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  1 -
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 12 ++-----
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 11 ++-----
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  2 --
 .../ethernet/pensando/ionic/ionic_devlink.c   |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  6 ++--
 drivers/net/netdevsim/dev.c                   |  2 --
 drivers/net/netdevsim/netdev.c                |  1 +
 net/dsa/dsa2.c                                |  9 ------
 net/dsa/slave.c                               |  1 +
 30 files changed, 39 insertions(+), 158 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index eed98c10ca9d..59d211fb01ba 100644
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
index 8d029addddad..d86182fcd832 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4601,6 +4601,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
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
index 0f6718719453..a4d5a6969f10 100644
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
index 639d3e940a88..18fefb27a356 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -633,6 +633,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 	SET_NETDEV_DEV(dev, sw->dev->dev);
+	SET_NETDEV_DEVLINK_PORT(dev, &port->dl_port);
 
 	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP)
 		netif_carrier_off(dev);
@@ -726,8 +727,6 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
-	prestera_devlink_port_set(port);
-
 	err = prestera_port_sfp_bind(port);
 	if (err)
 		goto err_sfp_bind;
@@ -750,7 +749,6 @@ static void prestera_port_destroy(struct prestera_port *port)
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
index 2719247b18db..05e7fcba15a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5841,14 +5841,13 @@ static int mlx5e_probe(struct auxiliary_device *adev,
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
index 83b2febe8a7b..d99382f6a43e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1256,37 +1256,22 @@ mlx5e_vport_uplink_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *
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
 	struct mlx5_core_dev *dev;
 	struct mlx5e_priv *priv;
 
 	priv = netdev_priv(netdev);
 	dev = priv->mdev;
 
-	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-	if (dl_port)
-		devlink_port_type_clear(dl_port);
 	mlx5e_netdev_attach_nic_profile(priv);
 }
 
@@ -1329,6 +1314,10 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_cleanup_profile;
 	}
 
+	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
+	if (dl_port)
+		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
+
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_warn(netdev,
@@ -1337,9 +1326,6 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
-	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
-	if (dl_port)
-		devlink_port_type_eth_set(dl_port, netdev);
 	return 0;
 
 err_detach_netdev:
@@ -1385,8 +1371,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5_core_dev *dev = priv->mdev;
-	struct devlink_port *dl_port;
 	void *ppriv = priv->ppriv;
 
 	if (rep->vport == MLX5_VPORT_UPLINK) {
@@ -1394,9 +1378,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
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
index ca0c3d2bee6b..f0911d9c425c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -264,10 +264,8 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 			     const unsigned char *switch_id,
 			     unsigned char switch_id_len);
 void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
-void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
-			     void *port_driver_priv, struct net_device *dev);
-void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
-			   void *port_driver_priv);
+void mlxsw_core_port_netdev_link(struct mlxsw_core *mlxsw_core, u16 local_port,
+				 void *port_driver_priv, struct net_device *dev);
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u16 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 55b3c42bb007..d3e2c88ba677 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -261,7 +261,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
 		err = -ENOMEM;
 		goto err_alloc_etherdev;
 	}
-
+	mlxsw_core_port_netdev_link(mlxsw_m->core, mlxsw_m_port->local_port,
+				    mlxsw_m_port, dev);
 	SET_NETDEV_DEV(dev, mlxsw_m->bus_info->dev);
 	dev_net_set(dev, mlxsw_core_net(mlxsw_m->core));
 	mlxsw_m_port = netdev_priv(dev);
@@ -298,9 +299,6 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
 		goto err_register_netdev;
 	}
 
-	mlxsw_core_port_eth_set(mlxsw_m->core, mlxsw_m_port->local_port,
-				mlxsw_m_port, dev);
-
 	return 0;
 
 err_register_netdev:
@@ -316,7 +314,6 @@ static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u16 local_port)
 {
 	struct mlxsw_m_port *mlxsw_m_port = mlxsw_m->ports[local_port];
 
-	mlxsw_core_port_clear(mlxsw_m->core, local_port, mlxsw_m);
 	unregister_netdev(mlxsw_m_port->dev); /* This calls ndo_stop */
 	mlxsw_m->ports[local_port] = NULL;
 	free_netdev(mlxsw_m_port->dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5bcf5bceff71..01bb3238c558 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1648,6 +1648,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 		err = -ENOMEM;
 		goto err_alloc_etherdev;
 	}
+	mlxsw_core_port_netdev_link(mlxsw_sp->core, mlxsw_sp_port->local_port,
+				    mlxsw_sp_port, dev);
 	SET_NETDEV_DEV(dev, mlxsw_sp->bus_info->dev);
 	dev_net_set(dev, mlxsw_sp_net(mlxsw_sp));
 	mlxsw_sp_port = netdev_priv(dev);
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
index 6f22aea08a64..07a628750534 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -425,7 +425,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 		dlp = &ocelot->devlink_ports[port];
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
index 3cbe4ec46234..43d1fba22d41 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2531,7 +2531,6 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
-	struct devlink_port *dl_port;
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
@@ -2558,15 +2557,14 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
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
index 794fc0cc73b8..07a26c86da8e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1397,7 +1397,6 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 			goto err_nsim_destroy;
 	}
 
-	devlink_port_type_eth_set(devlink_port, nsim_dev_port->ns->netdev);
 	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
 
 	return 0;
@@ -1420,7 +1419,6 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 	list_del(&nsim_dev_port->list);
 	if (nsim_dev_port_is_vf(nsim_dev_port))
 		devl_rate_leaf_destroy(&nsim_dev_port->devlink_port);
-	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 	devl_port_unregister(devlink_port);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 9a1a5b203624..4eb90cc49e22 100644
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
index 1a59918d3b30..a72f6e3c9ed6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2406,6 +2406,7 @@ int dsa_slave_create(struct dsa_port *port)
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
+	SET_NETDEV_DEVLINK_PORT(slave_dev, &port->devlink_port);
 	slave_dev->dev.of_node = port->dn;
 	slave_dev->vlan_features = master->vlan_features;
 
-- 
2.37.1

