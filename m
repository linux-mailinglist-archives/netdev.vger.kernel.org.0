Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E854251CF1A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388377AbiEFCzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388374AbiEFCzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:55:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61BF5E150
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 314D962072
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99890C385AC;
        Fri,  6 May 2022 02:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651805507;
        bh=LxgavARAqCgq00DJ9wzZvZ9zqGvgzqaJd8trGozDVqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYwHLIA4nxzYoBgGxbAQEuHMUsXOXNGuYo6fWlqljU9ygw43ZtszckpJMeJXVRUS4
         pq234sCFfZiG6HfGnya+782KfIhtpuSMTE8WS25kVfi0+2SlJLrZx8EFhPKyE8rOrx
         3W6Xm460/Gxd90W6hrgsxgHj16+rwnQv91Pbatj1qtryYYtgQVjTSdKrY4SmZcLeJI
         qKbjbOi/yvv2PuKK/uE1rp/V9Q6nKQnrT/M2mFTZtkqsackorX58qdkgj0Stlhd7dC
         f+GTWh/AnpXx93mc5V1Pj9g06upVf5i28Y2OgtEa/JldafdAgAhsYg9IvulK5ADzMO
         1E7j4IrN3fFBw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alexander.duyck@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, chris.snook@gmail.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, qiangqing.zhang@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        simon.horman@corigine.com, hkallweit1@gmail.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, woojung.huh@microchip.com,
        wintera@linux.ibm.com, roopa@nvidia.com, razor@blackwall.org,
        cai.huoqing@linux.dev, fei.qin@corigine.com,
        niklas.soderlund@corigine.com, yinjun.zhang@corigine.com,
        marcinguy@gmail.com, jesionowskigreg@gmail.com, jannh@google.com,
        hayeswang@realtek.com
Subject: [PATCH net-next 3/4] net: make drivers set the TSO limit not the GSO limit
Date:   Thu,  5 May 2022 19:51:33 -0700
Message-Id: <20220506025134.794537-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506025134.794537-1-kuba@kernel.org>
References: <20220506025134.794537-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should call the TSO setting helper, GSO is controllable
by user space.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: j.vosburgh@gmail.com
CC: vfalico@gmail.com
CC: andy@greyhouse.net
CC: chris.snook@gmail.com
CC: dchickles@marvell.com
CC: sburla@marvell.com
CC: fmanlunas@marvell.com
CC: ajit.khaparde@broadcom.com
CC: sriharsha.basavapatna@broadcom.com
CC: somnath.kotur@broadcom.com
CC: qiangqing.zhang@nxp.com
CC: yisen.zhuang@huawei.com
CC: salil.mehta@huawei.com
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
CC: sebastian.hesselbarth@gmail.com
CC: thomas.petazzoni@bootlin.com
CC: mw@semihalf.com
CC: linux@armlinux.org.uk
CC: sgoutham@marvell.com
CC: gakula@marvell.com
CC: sbhatta@marvell.com
CC: hkelam@marvell.com
CC: simon.horman@corigine.com
CC: hkallweit1@gmail.com
CC: ecree.xilinx@gmail.com
CC: habetsm.xilinx@gmail.com
CC: kys@microsoft.com
CC: haiyangz@microsoft.com
CC: sthemmin@microsoft.com
CC: wei.liu@kernel.org
CC: decui@microsoft.com
CC: woojung.huh@microchip.com
CC: wintera@linux.ibm.com
CC: roopa@nvidia.com
CC: razor@blackwall.org
CC: cai.huoqing@linux.dev
CC: fei.qin@corigine.com
CC: niklas.soderlund@corigine.com
CC: yinjun.zhang@corigine.com
CC: marcinguy@gmail.com
CC: jesionowskigreg@gmail.com
CC: jannh@google.com
CC: hayeswang@realtek.com
---
 drivers/net/bonding/bond_main.c                      | 12 ++++++------
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c      |  2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c      |  2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c   |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c          |  2 +-
 drivers/net/ethernet/freescale/fec_main.c            |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c        |  4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  4 ++--
 drivers/net/ethernet/marvell/mv643xx_eth.c           |  2 +-
 drivers/net/ethernet/marvell/mvneta.c                |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c            |  8 ++++----
 drivers/net/ethernet/sfc/ef100_nic.c                 |  9 ++++++---
 drivers/net/ethernet/sfc/efx.c                       |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                |  2 +-
 drivers/net/hyperv/rndis_filter.c                    |  2 +-
 drivers/net/usb/aqc111.c                             |  2 +-
 drivers/net/usb/ax88179_178a.c                       |  2 +-
 drivers/net/usb/lan78xx.c                            |  2 +-
 drivers/net/usb/r8152.c                              |  2 +-
 drivers/s390/net/qeth_l2_main.c                      |  2 +-
 drivers/s390/net/qeth_l3_main.c                      |  2 +-
 net/bridge/br_if.c                                   | 12 ++++++------
 net/core/dev.c                                       |  4 ++--
 28 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c9e75a9de282..f245e439f44c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1419,8 +1419,8 @@ static void bond_compute_features(struct bonding *bond)
 	struct list_head *iter;
 	struct slave *slave;
 	unsigned short max_hard_header_len = ETH_HLEN;
-	unsigned int gso_max_size = GSO_MAX_SIZE;
-	u16 gso_max_segs = GSO_MAX_SEGS;
+	unsigned int tso_max_size = TSO_MAX_SIZE;
+	u16 tso_max_segs = TSO_MAX_SEGS;
 
 	if (!bond_has_slaves(bond))
 		goto done;
@@ -1449,8 +1449,8 @@ static void bond_compute_features(struct bonding *bond)
 		if (slave->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = slave->dev->hard_header_len;
 
-		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
-		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
+		tso_max_size = min(tso_max_size, slave->dev->tso_max_size);
+		tso_max_segs = min(tso_max_segs, slave->dev->tso_max_segs);
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
 
@@ -1463,8 +1463,8 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->mpls_features = mpls_features;
-	netif_set_gso_max_segs(bond_dev, gso_max_segs);
-	netif_set_gso_max_size(bond_dev, gso_max_size);
+	netif_set_tso_max_segs(bond_dev, tso_max_segs);
+	netif_set_tso_max_size(bond_dev, tso_max_size);
 
 	bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	if ((bond_dev->priv_flags & IFF_XMIT_DST_RELEASE_PERM) &&
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 56e5f440e666..20681860a599 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2395,7 +2395,7 @@ static int atl1e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task);
-	netif_set_gso_max_size(netdev, MAX_TSO_SEG_SIZE);
+	netif_set_tso_max_size(netdev, MAX_TSO_SEG_SIZE);
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register netdevice failed\n");
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index ba28aa444e5a..bee35ce60171 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3563,7 +3563,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					      | NETIF_F_TSO | NETIF_F_TSO6
 					      | NETIF_F_LRO;
 		}
-		netif_set_gso_max_size(netdev, OCTNIC_GSO_MAX_SIZE);
+		netif_set_tso_max_size(netdev, OCTNIC_GSO_MAX_SIZE);
 
 		/*  Copy of transmit encapsulation capabilities:
 		 *  TSO, TSO6, Checksums for this device
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 568f211d91cc..ac196883f07e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2094,7 +2094,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 				      | NETIF_F_TSO | NETIF_F_TSO6
 				      | NETIF_F_GRO
 				      | NETIF_F_LRO;
-		netif_set_gso_max_size(netdev, OCTNIC_GSO_MAX_SIZE);
+		netif_set_tso_max_size(netdev, OCTNIC_GSO_MAX_SIZE);
 
 		/* Copy of transmit encapsulation capabilities:
 		 * TSO, TSO6, Checksums for this device
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 5939068a8f62..cd4e243da5fa 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5204,7 +5204,7 @@ static void be_netdev_init(struct net_device *netdev)
 
 	netdev->flags |= IFF_MULTICAST;
 
-	netif_set_gso_max_size(netdev, BE_MAX_GSO_SIZE - ETH_HLEN);
+	netif_set_tso_max_size(netdev, BE_MAX_GSO_SIZE - ETH_HLEN);
 
 	netdev->netdev_ops = &be_netdev_ops;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9f33ec838b52..6e52f3ad182f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3566,7 +3566,7 @@ static int fec_enet_init(struct net_device *ndev)
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (fep->quirks & FEC_QUIRK_HAS_CSUM) {
-		netif_set_gso_max_segs(ndev, FEC_MAX_TSO_SEGS);
+		netif_set_tso_max_segs(ndev, FEC_MAX_TSO_SEGS);
 
 		/* enable hw accelerator */
 		ndev->features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 22a463e15678..2f0bd21a9082 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1782,7 +1782,7 @@ static int hns_nic_set_features(struct net_device *netdev,
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* The chip only support 7*4096 */
-			netif_set_gso_max_size(netdev, 7 * 4096);
+			netif_set_tso_max_size(netdev, 7 * 4096);
 		} else {
 			priv->ops.fill_desc = fill_v2_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
@@ -2168,7 +2168,7 @@ static void hns_nic_set_priv_ops(struct net_device *netdev)
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* This chip only support 7*4096 */
-			netif_set_gso_max_size(netdev, 7 * 4096);
+			netif_set_tso_max_size(netdev, 7 * 4096);
 		} else {
 			priv->ops.fill_desc = fill_v2_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..292a025e5423 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5051,12 +5051,12 @@ static void ixgbe_configure_dcb(struct ixgbe_adapter *adapter)
 
 	if (!(adapter->flags & IXGBE_FLAG_DCB_ENABLED)) {
 		if (hw->mac.type == ixgbe_mac_82598EB)
-			netif_set_gso_max_size(adapter->netdev, 65536);
+			netif_set_tso_max_size(adapter->netdev, 65536);
 		return;
 	}
 
 	if (hw->mac.type == ixgbe_mac_82598EB)
-		netif_set_gso_max_size(adapter->netdev, 32768);
+		netif_set_tso_max_size(adapter->netdev, 32768);
 
 #ifdef IXGBE_FCOE
 	if (adapter->netdev->features & NETIF_F_FCOE_MTU)
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index c18801490649..57eff4e9e6de 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3207,7 +3207,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	dev->hw_features = dev->features;
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
-	netif_set_gso_max_segs(dev, MV643XX_MAX_TSO_SEGS);
+	netif_set_tso_max_segs(dev, MV643XX_MAX_TSO_SEGS);
 
 	/* MTU range: 64 - 9500 */
 	dev->min_mtu = 64;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f6a54c7f0c69..384f5a16753d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5617,7 +5617,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-	netif_set_gso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
+	netif_set_tso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
 	/* MTU range: 68 - 9676 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1a835b48791b..2b7eade373be 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6861,7 +6861,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
 	dev->vlan_features |= features;
-	netif_set_gso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
+	netif_set_tso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 68 - 9704 */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 441aafc26a08..53b2706d65a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2704,7 +2704,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
 
-	netif_set_gso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
+	netif_set_tso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 9e87836ed8bf..86653bb8e403 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -652,7 +652,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->hw_features |= NETIF_F_RXALL;
 	netdev->hw_features |= NETIF_F_HW_TC;
 
-	netif_set_gso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
+	netif_set_tso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2vf_netdev_ops;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5528d12d1f48..c60ead337d06 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2320,7 +2320,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = nn->max_mtu;
 
-	netif_set_gso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
+	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netif_carrier_off(netdev);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 790e1d5e4b4a..75b5018f2e1b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -380,7 +380,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	/* Advertise but disable TSO by default. */
 	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
-	netif_set_gso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
+	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
 	netdev->features |= NETIF_F_LLTX;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 33f5c5698ccb..3098d6672192 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5442,12 +5442,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
 		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
-		netif_set_gso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
-		netif_set_gso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
+		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
+		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
 		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
-		netif_set_gso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
-		netif_set_gso_max_segs(dev, RTL_GSO_MAX_SEGS_V1);
+		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
+		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V1);
 	}
 
 	dev->hw_features |= NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index b04911bc8c57..a69d756e09b9 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1009,11 +1009,13 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN:
 		nic_data->tso_max_payload_len = min_t(u64, reader->value, GSO_MAX_SIZE);
-		netif_set_gso_max_size(efx->net_dev, nic_data->tso_max_payload_len);
+		netif_set_tso_max_size(efx->net_dev,
+				       nic_data->tso_max_payload_len);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS:
 		nic_data->tso_max_payload_num_segs = min_t(u64, reader->value, 0xffff);
-		netif_set_gso_max_segs(efx->net_dev, nic_data->tso_max_payload_num_segs);
+		netif_set_tso_max_segs(efx->net_dev,
+				       nic_data->tso_max_payload_num_segs);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES:
 		nic_data->tso_max_frames = min_t(u64, reader->value, 0xffff);
@@ -1138,7 +1140,8 @@ static int ef100_probe_main(struct efx_nic *efx)
 	nic_data->tso_max_frames = ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES_DEFAULT;
 	nic_data->tso_max_payload_num_segs = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS_DEFAULT;
 	nic_data->tso_max_payload_len = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN_DEFAULT;
-	netif_set_gso_max_segs(net_dev, ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
+	netif_set_tso_max_segs(net_dev,
+			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
 	/* Read design parameters */
 	rc = ef100_check_design_params(efx);
 	if (rc) {
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 5e7fe75cb1d4..5a772354da83 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -710,7 +710,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
 		net_dev->priv_flags |= IFF_UNICAST_FLT;
 	net_dev->ethtool_ops = &efx_ethtool_ops;
-	netif_set_gso_max_segs(net_dev, EFX_TSO_MAX_SEGS);
+	netif_set_tso_max_segs(net_dev, EFX_TSO_MAX_SEGS);
 	net_dev->min_mtu = EFX_MIN_MTU;
 	net_dev->max_mtu = EFX_MAX_MTU;
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 60c595ef7589..b7282331faec 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2267,7 +2267,7 @@ static int ef4_register_netdev(struct ef4_nic *efx)
 	net_dev->irq = efx->pci_dev->irq;
 	net_dev->netdev_ops = &ef4_netdev_ops;
 	net_dev->ethtool_ops = &ef4_ethtool_ops;
-	netif_set_gso_max_segs(net_dev, EF4_TSO_MAX_SEGS);
+	netif_set_tso_max_segs(net_dev, EF4_TSO_MAX_SEGS);
 	net_dev->min_mtu = EF4_MIN_MTU;
 	net_dev->max_mtu = EF4_MAX_MTU;
 
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 448fcc325ed7..866af2cc27a3 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1431,7 +1431,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	 */
 	net->features &= ~NETVSC_SUPPORTED_HW_FEATURES | net->hw_features;
 
-	netif_set_gso_max_size(net, gso_max_size);
+	netif_set_tso_max_size(net, gso_max_size);
 
 	ret = rndis_filter_set_offload_params(net, nvdev, &offloads);
 
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index ca409d450a29..3020e81159d0 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -735,7 +735,7 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->features |= AQ_SUPPORT_FEATURE;
 	dev->net->vlan_features |= AQ_SUPPORT_VLAN_FEATURE;
 
-	netif_set_gso_max_size(dev->net, 65535);
+	netif_set_tso_max_size(dev->net, 65535);
 
 	aqc111_read_fw_version(dev, aqc111_data);
 	aqc111_data->autoneg = AUTONEG_ENABLE;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index e2fa56b92685..7a8c11a26eb5 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1382,7 +1382,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	dev->net->hw_features |= dev->net->features;
 
-	netif_set_gso_max_size(dev->net, 16384);
+	netif_set_tso_max_size(dev->net, 16384);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 94e571fb61da..636a405844c5 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4372,7 +4372,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	/* MTU range: 68 - 9000 */
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
 
-	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
+	netif_set_tso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
 	netif_napi_add(netdev, &dev->napi, lan78xx_poll, NAPI_POLL_WEIGHT);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ee41088c5251..d3b53db57c26 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9658,7 +9658,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	}
 
 	netdev->ethtool_ops = &ops;
-	netif_set_gso_max_size(netdev, RTL_LIMITED_TSO_SIZE);
+	netif_set_tso_max_size(netdev, RTL_LIMITED_TSO_SIZE);
 
 	/* MTU range: 68 - 1500 or 9194 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 92698f79a4e0..2d4436cbcb47 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1129,7 +1129,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6)) {
 		card->dev->needed_headroom = sizeof(struct qeth_hdr_tso);
 		netif_keep_dst(card->dev);
-		netif_set_gso_max_size(card->dev,
+		netif_set_tso_max_size(card->dev,
 				       PAGE_SIZE * (QDIO_MAX_ELEMENTS_PER_BUFFER - 1));
 	}
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index ea3b6b18aa6e..8d44bce0477a 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1907,7 +1907,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 
 	netif_keep_dst(card->dev);
 	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6))
-		netif_set_gso_max_size(card->dev,
+		netif_set_tso_max_size(card->dev,
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
 	netif_napi_add(card->dev, &card->napi, qeth_poll, NAPI_POLL_WEIGHT);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 55f47cadb114..47fcbade7389 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -517,16 +517,16 @@ void br_mtu_auto_adjust(struct net_bridge *br)
 
 static void br_set_gso_limits(struct net_bridge *br)
 {
-	unsigned int gso_max_size = GSO_MAX_SIZE;
-	u16 gso_max_segs = GSO_MAX_SEGS;
+	unsigned int tso_max_size = TSO_MAX_SIZE;
 	const struct net_bridge_port *p;
+	u16 tso_max_segs = TSO_MAX_SEGS;
 
 	list_for_each_entry(p, &br->port_list, list) {
-		gso_max_size = min(gso_max_size, p->dev->gso_max_size);
-		gso_max_segs = min(gso_max_segs, p->dev->gso_max_segs);
+		tso_max_size = min(tso_max_size, p->dev->tso_max_size);
+		tso_max_segs = min(tso_max_segs, p->dev->tso_max_segs);
 	}
-	netif_set_gso_max_size(br->dev, gso_max_size);
-	netif_set_gso_max_segs(br->dev, gso_max_segs);
+	netif_set_tso_max_size(br->dev, tso_max_size);
+	netif_set_tso_max_segs(br->dev, tso_max_segs);
 }
 
 /*
diff --git a/net/core/dev.c b/net/core/dev.c
index 6ae085b11373..f036ccb61da4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3032,8 +3032,8 @@ EXPORT_SYMBOL(netif_set_tso_max_segs);
  */
 void netif_inherit_tso_max(struct net_device *to, const struct net_device *from)
 {
-	netif_set_gso_max_size(to, from->gso_max_size);
-	netif_set_gso_max_segs(to, from->gso_max_segs);
+	netif_set_tso_max_size(to, from->tso_max_size);
+	netif_set_tso_max_segs(to, from->tso_max_segs);
 }
 EXPORT_SYMBOL(netif_inherit_tso_max);
 
-- 
2.34.1

