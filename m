Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF451DE28
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444108AbiEFRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444105AbiEFRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:11:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3082C6EC66
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9535BB837E9
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756CFC385B3;
        Fri,  6 May 2022 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651856880;
        bh=LsGEHQDKdVIpkLv8+A4SlF8YwUiC1XbYloM6eGbXKjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy3CxbWztDFUXSK2BaMvLv9Lhvprua9xjRj0AqvVEoxeyhbGJXwtoYjuvRqojxhRM
         zLlPdhZQ/YZ5zJzQt/kuRgr+bUE8AXpYULATk3zexuB9c5XHc9ynJ8FmOeYP3r/gQ8
         yHxO7zH/k8Gln7EaLU1Z5fsRHLe3e4kkwgDXdQqi6Wbx5PKsSZbXqSkqzrSV9JhoYs
         xDqVBehMdnwyU+smh2vy9JHj4X4jyRMFl4nFCcDElRmEV0NN7JgE5m16Cn2Ga7Osp7
         rpip6KXi477l42MgpJ6bZQpMXMIx3k5OBQiElKO2Xnixn4j9RIDm/zhmuISmqb/NNT
         S87Bfw3cdcISw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, dave@thedillows.org,
        ionut@badula.org, pcnet32@frontier.com, chris.snook@gmail.com,
        f.fainelli@gmail.com, pantelis.antoniou@gmail.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        cforno12@linux.ibm.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        christopher.lee@cspi.com, jdmason@kudzu.us, vz@mleia.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        steve.glendinning@shawell.net, khalasa@piap.pl,
        masahiroy@kernel.org, tanghui20@huawei.com,
        chenhao288@hisilicon.com, tangmeng@uniontech.com,
        yangyingliang@huawei.com, nitesh@redhat.com,
        huangguangbin2@huawei.com, gustavoars@kernel.org, olek2@wp.pl,
        christophe.jaillet@wanadoo.fr, zhengyongjun3@huawei.com,
        hkallweit1@gmail.com, u.kleine-koenig@pengutronix.de
Subject: [PATCH net-next 3/6] eth: switch to netif_napi_add_weight()
Date:   Fri,  6 May 2022 10:07:48 -0700
Message-Id: <20220506170751.822862-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506170751.822862-1-kuba@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
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

Switch all Ethernet drivers which use custom napi weights
to the new API.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: dave@thedillows.org
CC: ionut@badula.org
CC: pcnet32@frontier.com
CC: chris.snook@gmail.com
CC: f.fainelli@gmail.com
CC: pantelis.antoniou@gmail.com
CC: yisen.zhuang@huawei.com
CC: salil.mehta@huawei.com
CC: mpe@ellerman.id.au
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: cforno12@linux.ibm.com
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
CC: lars.povlsen@microchip.com
CC: Steen.Hegelund@microchip.com
CC: kys@microsoft.com
CC: haiyangz@microsoft.com
CC: sthemmin@microsoft.com
CC: wei.liu@kernel.org
CC: decui@microsoft.com
CC: vladimir.oltean@nxp.com
CC: claudiu.manoil@nxp.com
CC: alexandre.belloni@bootlin.com
CC: christopher.lee@cspi.com
CC: jdmason@kudzu.us
CC: vz@mleia.com
CC: ecree.xilinx@gmail.com
CC: habetsm.xilinx@gmail.com
CC: steve.glendinning@shawell.net
CC: khalasa@piap.pl
CC: masahiroy@kernel.org
CC: tanghui20@huawei.com
CC: chenhao288@hisilicon.com
CC: tangmeng@uniontech.com
CC: yangyingliang@huawei.com
CC: nitesh@redhat.com
CC: huangguangbin2@huawei.com
CC: gustavoars@kernel.org
CC: olek2@wp.pl
CC: christophe.jaillet@wanadoo.fr
CC: zhengyongjun3@huawei.com
CC: hkallweit1@gmail.com
CC: u.kleine-koenig@pengutronix.de
---
 drivers/net/ethernet/3com/typhoon.c                   | 2 +-
 drivers/net/ethernet/adaptec/starfire.c               | 2 +-
 drivers/net/ethernet/amd/amd8111e.c                   | 2 +-
 drivers/net/ethernet/amd/pcnet32.c                    | 3 ++-
 drivers/net/ethernet/arc/emac_main.c                  | 3 ++-
 drivers/net/ethernet/atheros/ag71xx.c                 | 3 ++-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c          | 4 ++--
 drivers/net/ethernet/broadcom/sb1250-mac.c            | 2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c           | 2 +-
 drivers/net/ethernet/ezchip/nps_enet.c                | 4 ++--
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 3 ++-
 drivers/net/ethernet/hisilicon/hisi_femac.c           | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c          | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c          | 3 ++-
 drivers/net/ethernet/ibm/emac/mal.c                   | 4 ++--
 drivers/net/ethernet/ibm/ibmveth.c                    | 2 +-
 drivers/net/ethernet/intel/e100.c                     | 2 +-
 drivers/net/ethernet/lantiq_etop.c                    | 8 ++++----
 drivers/net/ethernet/marvell/pxa168_eth.c             | 3 ++-
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c   | 3 ++-
 drivers/net/ethernet/microsoft/mana/mana_en.c         | 2 +-
 drivers/net/ethernet/moxa/moxart_ether.c              | 2 +-
 drivers/net/ethernet/mscc/ocelot_fdma.c               | 4 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c      | 4 ++--
 drivers/net/ethernet/neterion/vxge/vxge-main.c        | 9 +++++----
 drivers/net/ethernet/nxp/lpc_eth.c                    | 2 +-
 drivers/net/ethernet/realtek/8139cp.c                 | 2 +-
 drivers/net/ethernet/sfc/efx_channels.c               | 4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c                 | 4 ++--
 drivers/net/ethernet/smsc/smsc911x.c                  | 3 ++-
 drivers/net/ethernet/toshiba/tc35815.c                | 2 +-
 drivers/net/ethernet/wiznet/w5100.c                   | 2 +-
 drivers/net/ethernet/wiznet/w5300.c                   | 2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c              | 2 +-
 34 files changed, 58 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index ad57209007e1..cad4f354cc76 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2464,7 +2464,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* The chip-specific entries in the device structure. */
 	dev->netdev_ops		= &typhoon_netdev_ops;
-	netif_napi_add(dev, &tp->napi, typhoon_poll, 16);
+	netif_napi_add_weight(dev, &tp->napi, typhoon_poll, 16);
 	dev->watchdog_timeo	= TX_TIMEOUT;
 
 	dev->ethtool_ops = &typhoon_ethtool_ops;
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index c6982f7caf9b..8f0a6b9c518e 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -772,7 +772,7 @@ static int starfire_init_one(struct pci_dev *pdev,
 	dev->watchdog_timeo = TX_TIMEOUT;
 	dev->ethtool_ops = &ethtool_ops;
 
-	netif_napi_add(dev, &np->napi, netdev_poll, max_interrupt_work);
+	netif_napi_add_weight(dev, &np->napi, netdev_poll, max_interrupt_work);
 
 	if (mtu)
 		dev->mtu = mtu;
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 9421afb950f7..05ac8d9ccb2f 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1828,7 +1828,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	dev->watchdog_timeo = AMD8111E_TX_TIMEOUT;
 	dev->min_mtu = AMD8111E_MIN_MTU;
 	dev->max_mtu = AMD8111E_MAX_MTU;
-	netif_napi_add(dev, &lp->napi, amd8111e_rx_poll, 32);
+	netif_napi_add_weight(dev, &lp->napi, amd8111e_rx_poll, 32);
 
 #if AMD8111E_VLAN_TAG_USED
 	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index c20c369c7eb8..b5ff47283cfe 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1881,7 +1881,8 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 	/* napi.weight is used in both the napi and non-napi cases */
 	lp->napi.weight = lp->rx_ring_size / 2;
 
-	netif_napi_add(dev, &lp->napi, pcnet32_poll, lp->rx_ring_size / 2);
+	netif_napi_add_weight(dev, &lp->napi, pcnet32_poll,
+			      lp->rx_ring_size / 2);
 
 	if (fdx && !(lp->options & PCNET32_PORT_ASEL) &&
 	    ((cards_found >= MAX_UNITS) || full_duplex[cards_found]))
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index c642c3d3e600..288e2961823e 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -981,7 +981,8 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 	dev_info(dev, "connected to %s phy with id 0x%x\n",
 		 phydev->drv->name, phydev->phy_id);
 
-	netif_napi_add(ndev, &priv->napi, arc_emac_poll, ARC_EMAC_NAPI_WEIGHT);
+	netif_napi_add_weight(ndev, &priv->napi, arc_emac_poll,
+			      ARC_EMAC_NAPI_WEIGHT);
 
 	err = register_netdev(ndev);
 	if (err) {
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index ec167af0e3b2..cac509708e9d 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1922,7 +1922,8 @@ static int ag71xx_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	netif_napi_add(ndev, &ag->napi, ag71xx_poll, AG71XX_NAPI_WEIGHT);
+	netif_napi_add_weight(ndev, &ag->napi, ag71xx_poll,
+			      AG71XX_NAPI_WEIGHT);
 
 	err = clk_prepare_enable(ag->clk_eth);
 	if (err) {
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index c1b97e8c55ef..698438a2ee0f 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1859,7 +1859,7 @@ static int bcm_enet_probe(struct platform_device *pdev)
 
 	/* register netdevice */
 	dev->netdev_ops = &bcm_enet_ops;
-	netif_napi_add(dev, &priv->napi, bcm_enet_poll, 16);
+	netif_napi_add_weight(dev, &priv->napi, bcm_enet_poll, 16);
 
 	dev->ethtool_ops = &bcm_enet_ethtool_ops;
 	/* MTU range: 46 - 2028 */
@@ -2714,7 +2714,7 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
 
 	/* register netdevice */
 	dev->netdev_ops = &bcm_enetsw_ops;
-	netif_napi_add(dev, &priv->napi, bcm_enet_poll, 16);
+	netif_napi_add_weight(dev, &priv->napi, bcm_enet_poll, 16);
 	dev->ethtool_ops = &bcm_enetsw_ethtool_ops;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index 5d5f10180158..f02facb60fd1 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -2203,7 +2203,7 @@ static int sbmac_init(struct platform_device *pldev, long long base)
 	dev->min_mtu = 0;
 	dev->max_mtu = ENET_PACKET_SIZE;
 
-	netif_napi_add(dev, &sc->napi, sbmac_poll, 16);
+	netif_napi_add_weight(dev, &sc->napi, sbmac_poll, 16);
 
 	dev->irq		= UNIT_INT(idx);
 
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 79df5a72877b..434d8bf0e8f9 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1689,7 +1689,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops = &tulip_netdev_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 #ifdef CONFIG_TULIP_NAPI
-	netif_napi_add(dev, &tp->napi, tulip_poll, 16);
+	netif_napi_add_weight(dev, &tp->napi, tulip_poll, 16);
 #endif
 	dev->ethtool_ops = &ops;
 
diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 69dbf950d451..f1eb660aaee2 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -612,8 +612,8 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 		goto out_netdev;
 	}
 
-	netif_napi_add(ndev, &priv->napi, nps_enet_poll,
-		       NPS_ENET_NAPI_POLL_WEIGHT);
+	netif_napi_add_weight(ndev, &priv->napi, nps_enet_poll,
+			      NPS_ENET_NAPI_POLL_WEIGHT);
 
 	/* Register the driver. Should be the last thing in probe */
 	err = register_netdev(ndev);
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index bacf25318f87..b3dae17e067e 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1020,7 +1020,8 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	ndev->netdev_ops = &fs_enet_netdev_ops;
 	ndev->watchdog_timeo = 2 * HZ;
 	INIT_WORK(&fep->timeout_work, fs_timeout_work);
-	netif_napi_add(ndev, &fep->napi, fs_enet_napi, fpi->napi_weight);
+	netif_napi_add_weight(ndev, &fep->napi, fs_enet_napi,
+			      fpi->napi_weight);
 
 	ndev->ethtool_ops = &fs_ethtool_ops;
 
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index a6c18b6527f9..93846bace028 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -852,7 +852,8 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 	ndev->netdev_ops = &hisi_femac_netdev_ops;
 	ndev->ethtool_ops = &hisi_femac_ethtools_ops;
-	netif_napi_add(ndev, &priv->napi, hisi_femac_poll, FEMAC_POLL_WEIGHT);
+	netif_napi_add_weight(ndev, &priv->napi, hisi_femac_poll,
+			      FEMAC_POLL_WEIGHT);
 
 	hisi_femac_port_init(priv);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index b33ed4d92b71..24b7b819dbfb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -481,7 +481,8 @@ static void rx_add_napi(struct hinic_rxq *rxq)
 {
 	struct hinic_dev *nic_dev = netdev_priv(rxq->netdev);
 
-	netif_napi_add(rxq->netdev, &rxq->napi, rx_poll, nic_dev->rx_weight);
+	netif_napi_add_weight(rxq->netdev, &rxq->napi, rx_poll,
+			      nic_dev->rx_weight);
 	napi_enable(&rxq->napi);
 }
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 8d59babbf476..87408e7bb809 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -809,7 +809,8 @@ static int tx_request_irq(struct hinic_txq *txq)
 
 	qp = container_of(sq, struct hinic_qp, sq);
 
-	netif_napi_add(txq->netdev, &txq->napi, free_tx_poll, nic_dev->tx_weight);
+	netif_napi_add_weight(txq->netdev, &txq->napi, free_tx_poll,
+			      nic_dev->tx_weight);
 
 	hinic_hwdev_msix_set(nic_dev->hwdev, sq->msix_entry,
 			     TX_IRQ_NO_PENDING, TX_IRQ_NO_COALESC,
diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 075c07303f16..ff5487bbebe3 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -605,8 +605,8 @@ static int mal_probe(struct platform_device *ofdev)
 
 	init_dummy_netdev(&mal->dummy_dev);
 
-	netif_napi_add(&mal->dummy_dev, &mal->napi, mal_poll,
-		       CONFIG_IBM_EMAC_POLL_WEIGHT);
+	netif_napi_add_weight(&mal->dummy_dev, &mal->napi, mal_poll,
+			      CONFIG_IBM_EMAC_POLL_WEIGHT);
 
 	/* Load power-on reset defaults */
 	mal_reset(mal);
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 22fb0d109a68..5c6a04d29f5b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1674,7 +1674,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->pool_config = 0;
 	ibmveth_init_link_settings(netdev);
 
-	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
+	netif_napi_add_weight(netdev, &adapter->napi, ibmveth_poll, 16);
 
 	netdev->irq = dev->irq;
 	netdev->netdev_ops = &ibmveth_netdev_ops;
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 4a8013f20152..36418b510dde 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2848,7 +2848,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
 	nic = netdev_priv(netdev);
-	netif_napi_add(netdev, &nic->napi, e100_poll, E100_NAPI_WEIGHT);
+	netif_napi_add_weight(netdev, &nic->napi, e100_poll, E100_NAPI_WEIGHT);
 	nic->netdev = netdev;
 	nic->pdev = pdev;
 	nic->msg_enable = (1 << debug) - 1;
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 9b6fa27b7daf..7cedbe1fdfd7 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -701,11 +701,11 @@ ltq_etop_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
 		if (IS_TX(i))
-			netif_napi_add(dev, &priv->ch[i].napi,
-				       ltq_etop_poll_tx, 8);
+			netif_napi_add_weight(dev, &priv->ch[i].napi,
+					      ltq_etop_poll_tx, 8);
 		else if (IS_RX(i))
-			netif_napi_add(dev, &priv->ch[i].napi,
-				       ltq_etop_poll_rx, 32);
+			netif_napi_add_weight(dev, &priv->ch[i].napi,
+					      ltq_etop_poll_rx, 32);
 		priv->ch[i].netdev = dev;
 	}
 
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 52bef50f5a0d..349b8a94e939 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1486,7 +1486,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	/* Hardware supports only 3 ports */
 	BUG_ON(pep->port_num > 2);
-	netif_napi_add(dev, &pep->napi, pxa168_rx_poll, pep->rx_ring_size);
+	netif_napi_add_weight(dev, &pep->napi, pxa168_rx_poll,
+			      pep->rx_ring_size);
 
 	memset(&pep->timeout, 0, sizeof(struct timer_list));
 	timer_setup(&pep->timeout, rxq_refill_timer_wrapper, 0);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 1e9ff365459e..66360c8c5a38 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -381,7 +381,8 @@ static int sparx5_fdma_rx_alloc(struct sparx5 *sparx5)
 		}
 		sparx5_fdma_rx_add_dcb(rx, dcb, rx->dma + sizeof(*dcb) * idx);
 	}
-	netif_napi_add(rx->ndev, &rx->napi, sparx5_fdma_napi_callback, FDMA_WEIGHT);
+	netif_napi_add_weight(rx->ndev, &rx->napi, sparx5_fdma_napi_callback,
+			      FDMA_WEIGHT);
 	napi_enable(&rx->napi);
 	sparx5_fdma_rx_activate(sparx5, rx);
 	return 0;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 06f853c5c141..b1d773823232 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1602,7 +1602,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-	netif_napi_add(ndev, &cq->napi, mana_poll, 1);
+	netif_napi_add_weight(ndev, &cq->napi, mana_poll, 1);
 
 	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq, ndev, rxq_idx,
 				 cq->napi.napi_id));
diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index afb7dcadb8d2..a3214a762e4b 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -533,7 +533,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	}
 
 	ndev->netdev_ops = &moxart_netdev_ops;
-	netif_napi_add(ndev, &priv->napi, moxart_rx_poll, RX_DESC_NUM);
+	netif_napi_add_weight(ndev, &priv->napi, moxart_rx_poll, RX_DESC_NUM);
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 	ndev->irq = irq;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index dffa597bffe6..083fddd263ec 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -799,8 +799,8 @@ void ocelot_fdma_netdev_init(struct ocelot *ocelot, struct net_device *dev)
 		return;
 
 	fdma->ndev = dev;
-	netif_napi_add(dev, &fdma->napi, ocelot_fdma_napi_poll,
-		       OCELOT_FDMA_WEIGHT);
+	netif_napi_add_weight(dev, &fdma->napi, ocelot_fdma_napi_poll,
+			      OCELOT_FDMA_WEIGHT);
 }
 
 void ocelot_fdma_netdev_deinit(struct ocelot *ocelot, struct net_device *dev)
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index fe5e77330f5f..61497c3e4cfb 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3586,8 +3586,8 @@ static int myri10ge_alloc_slices(struct myri10ge_priv *mgp)
 			goto abort;
 		ss->mgp = mgp;
 		ss->dev = mgp->dev;
-		netif_napi_add(ss->dev, &ss->napi, myri10ge_poll,
-			       myri10ge_napi_weight);
+		netif_napi_add_weight(ss->dev, &ss->napi, myri10ge_poll,
+				      myri10ge_napi_weight);
 	}
 	return 0;
 abort:
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index db4dfae8c01d..d2de8ac44f72 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2720,8 +2720,8 @@ static int vxge_open(struct net_device *dev)
 	}
 
 	if (vdev->config.intr_type != MSI_X) {
-		netif_napi_add(dev, &vdev->napi, vxge_poll_inta,
-			vdev->config.napi_weight);
+		netif_napi_add_weight(dev, &vdev->napi, vxge_poll_inta,
+				      vdev->config.napi_weight);
 		napi_enable(&vdev->napi);
 		for (i = 0; i < vdev->no_of_vpath; i++) {
 			vpath = &vdev->vpaths[i];
@@ -2730,8 +2730,9 @@ static int vxge_open(struct net_device *dev)
 	} else {
 		for (i = 0; i < vdev->no_of_vpath; i++) {
 			vpath = &vdev->vpaths[i];
-			netif_napi_add(dev, &vpath->ring.napi,
-			    vxge_poll_msix, vdev->config.napi_weight);
+			netif_napi_add_weight(dev, &vpath->ring.napi,
+					      vxge_poll_msix,
+					      vdev->config.napi_weight);
 			napi_enable(&vpath->ring.napi);
 			vpath->ring.napi_p = &vpath->ring.napi;
 		}
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 756f97dce85b..f606d75b33b4 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1373,7 +1373,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	pldat->duplex = DUPLEX_FULL;
 	__lpc_params_setup(pldat);
 
-	netif_napi_add(ndev, &pldat->napi, lpc_eth_poll, NAPI_WEIGHT);
+	netif_napi_add_weight(ndev, &pldat->napi, lpc_eth_poll, NAPI_WEIGHT);
 
 	ret = register_netdev(ndev);
 	if (ret) {
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index ad7b9e9d7f95..e0feeec13da6 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1986,7 +1986,7 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_hw_addr_set(dev, (u8 *)addr);
 
 	dev->netdev_ops = &cp_netdev_ops;
-	netif_napi_add(dev, &cp->napi, cp_rx_poll, 16);
+	netif_napi_add_weight(dev, &cp->napi, cp_rx_poll, 16);
 	dev->ethtool_ops = &cp_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index eec80b024195..3f28f9861dfa 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1316,8 +1316,8 @@ void efx_init_napi_channel(struct efx_channel *channel)
 	struct efx_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add(channel->napi_dev, &channel->napi_str,
-		       efx_poll, napi_weight);
+	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, efx_poll,
+			      napi_weight);
 }
 
 void efx_init_napi(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index b7282331faec..f619ffb26787 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2017,8 +2017,8 @@ static void ef4_init_napi_channel(struct ef4_channel *channel)
 	struct ef4_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add(channel->napi_dev, &channel->napi_str,
-		       ef4_poll, napi_weight);
+	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, ef4_poll,
+			      napi_weight);
 }
 
 static void ef4_init_napi(struct ef4_nic *efx)
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index c854efdf1f25..3bf20211cceb 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2304,7 +2304,8 @@ static int smsc911x_init(struct net_device *dev)
 		return -ENODEV;
 
 	dev->flags |= IFF_MULTICAST;
-	netif_napi_add(dev, &pdata->napi, smsc911x_poll, SMSC_NAPI_WEIGHT);
+	netif_napi_add_weight(dev, &pdata->napi, smsc911x_poll,
+			      SMSC_NAPI_WEIGHT);
 	dev->netdev_ops = &smsc911x_netdev_ops;
 	dev->ethtool_ops = &smsc911x_ethtool_ops;
 
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index ce38f7515225..47aab9c132c8 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -804,7 +804,7 @@ static int tc35815_init_one(struct pci_dev *pdev,
 	dev->netdev_ops = &tc35815_netdev_ops;
 	dev->ethtool_ops = &tc35815_ethtool_ops;
 	dev->watchdog_timeo = TC35815_TX_TIMEOUT;
-	netif_napi_add(dev, &lp->napi, tc35815_poll, NAPI_WEIGHT);
+	netif_napi_add_weight(dev, &lp->napi, tc35815_poll, NAPI_WEIGHT);
 
 	dev->irq = pdev->irq;
 	dev->base_addr = (unsigned long)ioaddr;
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index 4fd7c39e1123..acd78120e53c 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1133,7 +1133,7 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 
 	ndev->netdev_ops = &w5100_netdev_ops;
 	ndev->ethtool_ops = &w5100_ethtool_ops;
-	netif_napi_add(ndev, &priv->napi, w5100_napi_poll, 16);
+	netif_napi_add_weight(ndev, &priv->napi, w5100_napi_poll, 16);
 
 	/* This chip doesn't support VLAN packets with normal MTU,
 	 * so disable VLAN for this device.
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 402d5036f266..773f8c77909a 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -603,7 +603,7 @@ static int w5300_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &w5300_netdev_ops;
 	ndev->ethtool_ops = &w5300_ethtool_ops;
 	ndev->watchdog_timeo = HZ;
-	netif_napi_add(ndev, &priv->napi, w5300_napi_poll, 16);
+	netif_napi_add_weight(ndev, &priv->napi, w5300_napi_poll, 16);
 
 	/* This chip doesn't support VLAN packets with normal MTU,
 	 * so disable VLAN for this device.
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index d947955621ee..89770c2e0ffb 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1480,7 +1480,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	ndev->dev.dma_mask = dev->dma_mask;
 	ndev->dev.coherent_dma_mask = dev->coherent_dma_mask;
 
-	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
+	netif_napi_add_weight(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
 	if (!(port->npe = npe_request(NPE_ID(port->id))))
 		return -EIO;
-- 
2.34.1

