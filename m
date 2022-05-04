Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DB151A5AA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353519AbiEDQl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiEDQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B27915711;
        Wed,  4 May 2022 09:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B0776173C;
        Wed,  4 May 2022 16:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF45C385A5;
        Wed,  4 May 2022 16:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651682268;
        bh=V+QU5Ck1Av3E648KurQxRONGcMlBXtqGZJYSH/Lz7Jg=;
        h=From:To:Cc:Subject:Date:From;
        b=nV0ROtRk44A/R5zrV14YsrAh09tiQG/JDufZj3/l8WmfyIYkDeV8BCq2lUdirvl89
         D/q0zzHNIU6GuPv48nixEHv1pPomWMQ28PPi+d8B65ufAupleq1x3ziv1Ju4kM7Z96
         IKvlT1By591p1qHv5wDDZOxtkTuJgy90H+ZFHVWEaxIGRU66uu1dWoEt3+yK3kWDGw
         xc/MfPjZMSM9ZeRziHkMI7KCUldJGOLVpJs/gG9KYQAEKXs5JdDEk9zbY4Eem3lxC5
         iuXhX3h3iIDLCvv+JwmLkOgPN4wjdvQE7hYylTVKz2e6ITYGyksEuumgZK3T4Ar7fc
         Crb/+h7PpooZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, rafal@milecki.pl,
        f.fainelli@gmail.com, opendmb@gmail.com, dmichail@fungible.com,
        hauke@hauke-m.de, tariqt@nvidia.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, shshaikh@marvell.com, manishc@marvell.com,
        jiri@resnulli.us, hayashi.kunihiko@socionext.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        grygorii.strashko@ti.com, elder@kernel.org, wintera@linux.ibm.com,
        wenjia@linux.ibm.com, svens@linux.ibm.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        s-vadapalli@ti.com, chi.minghao@zte.com.cn,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 1/2] net: switch to netif_napi_add_tx()
Date:   Wed,  4 May 2022 09:37:24 -0700
Message-Id: <20220504163725.550782-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

Switch net callers to the new API not requiring
the NAPI_POLL_WEIGHT argument.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: rafal@milecki.pl
CC: f.fainelli@gmail.com
CC: opendmb@gmail.com
CC: dmichail@fungible.com
CC: hauke@hauke-m.de
CC: tariqt@nvidia.com
CC: kys@microsoft.com
CC: haiyangz@microsoft.com
CC: sthemmin@microsoft.com
CC: wei.liu@kernel.org
CC: decui@microsoft.com
CC: shshaikh@marvell.com
CC: manishc@marvell.com
CC: jiri@resnulli.us
CC: hayashi.kunihiko@socionext.com
CC: peppe.cavallaro@st.com
CC: alexandre.torgue@foss.st.com
CC: joabreu@synopsys.com
CC: mcoquelin.stm32@gmail.com
CC: grygorii.strashko@ti.com
CC: elder@kernel.org
CC: wintera@linux.ibm.com
CC: wenjia@linux.ibm.com
CC: svens@linux.ibm.com
CC: mathew.j.martineau@linux.intel.com
CC: matthieu.baerts@tessares.net
CC: s-vadapalli@ti.com
CC: chi.minghao@zte.com.cn
CC: linux-rdma@vger.kernel.org
CC: linux-hyperv@vger.kernel.org
CC: mptcp@lists.linux.dev
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c       | 2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 3 +--
 drivers/net/ethernet/fungible/funeth/funeth_main.c | 3 +--
 drivers/net/ethernet/lantiq_xrx200.c               | 4 ++--
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         | 3 +--
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     | 9 ++++-----
 drivers/net/ethernet/rocker/rocker_main.c          | 3 +--
 drivers/net/ethernet/socionext/sni_ave.c           | 3 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 5 ++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           | 4 ++--
 drivers/net/ethernet/ti/cpsw.c                     | 5 ++---
 drivers/net/ethernet/ti/cpsw_new.c                 | 5 ++---
 drivers/net/ethernet/ti/netcp_core.c               | 2 +-
 drivers/net/ipa/gsi.c                              | 4 ++--
 drivers/net/tun.c                                  | 3 +--
 drivers/s390/net/qeth_core_main.c                  | 3 +--
 net/mptcp/protocol.c                               | 4 ++--
 19 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 4a2622b05ee1..c131d8118489 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -722,7 +722,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	netdev->min_mtu = ETH_ZLEN;
 	netdev->mtu = ETH_DATA_LEN;
 	netdev->max_mtu = ENET_MTU_MAX;
-	netif_tx_napi_add(netdev, &enet->tx_ring.napi, bcm4908_enet_poll_tx, NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(netdev, &enet->tx_ring.napi, bcm4908_enet_poll_tx);
 	netif_napi_add(netdev, &enet->rx_ring.napi, bcm4908_enet_poll_rx, NAPI_POLL_WEIGHT);
 
 	err = register_netdev(netdev);
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 60dde29974bf..a4ce96bb3903 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1517,7 +1517,7 @@ static int bcm_sysport_init_tx_ring(struct bcm_sysport_priv *priv,
 	/* Initialize SW view of the ring */
 	spin_lock_init(&ring->lock);
 	ring->priv = priv;
-	netif_tx_napi_add(priv->netdev, &ring->napi, bcm_sysport_tx_poll, 64);
+	netif_napi_add_tx(priv->netdev, &ring->napi, bcm_sysport_tx_poll);
 	ring->index = index;
 	ring->size = size;
 	ring->clean_index = 0;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index bf1ec8fdc2ad..65606351634e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2671,8 +2671,7 @@ static void bcmgenet_init_tx_ring(struct bcmgenet_priv *priv,
 				  DMA_END_ADDR);
 
 	/* Initialize Tx NAPI */
-	netif_tx_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
-			  NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(priv->dev, &ring->napi, bcmgenet_tx_poll);
 }
 
 /* Initialize a RDMA ring */
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 67dd02ed1fa3..9485cf699c5d 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -330,8 +330,7 @@ static int fun_alloc_queue_irqs(struct net_device *dev, unsigned int ntx,
 			return PTR_ERR(irq);
 
 		fp->num_tx_irqs++;
-		netif_tx_napi_add(dev, &irq->napi, fun_txq_napi_poll,
-				  NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(dev, &irq->napi, fun_txq_napi_poll);
 	}
 
 	for (i = fp->num_rx_irqs; i < nrx; i++) {
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 5712c3e94be8..5edb68a8aab1 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -615,8 +615,8 @@ static int xrx200_probe(struct platform_device *pdev)
 	/* setup NAPI */
 	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx,
 		       NAPI_POLL_WEIGHT);
-	netif_tx_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping,
-			  NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(net_dev, &priv->chan_tx.napi,
+			  xrx200_tx_housekeeping);
 
 	platform_set_drvdata(pdev, priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index d5fc72b1a36f..6affbd241264 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -147,8 +147,7 @@ int mlx4_en_activate_cq(struct mlx4_en_priv *priv, struct mlx4_en_cq *cq,
 	switch (cq->type) {
 	case TX:
 		cq->mcq.comp = mlx4_en_tx_irq;
-		netif_tx_napi_add(cq->dev, &cq->napi, mlx4_en_poll_tx_cq,
-				  NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(cq->dev, &cq->napi, mlx4_en_poll_tx_cq);
 		napi_enable(&cq->napi);
 		break;
 	case RX:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index b7d3ba1b4d17..06f853c5c141 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1371,7 +1371,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-		netif_tx_napi_add(net, &cq->napi, mana_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(net, &cq->napi, mana_poll);
 		napi_enable(&cq->napi);
 
 		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index bcf3746220df..8d43ca282956 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1608,8 +1608,8 @@ int qlcnic_82xx_napi_add(struct qlcnic_adapter *adapter,
 	if (qlcnic_check_multi_tx(adapter) && !adapter->ahw->diag_test) {
 		for (ring = 0; ring < adapter->drv_tx_rings; ring++) {
 			tx_ring = &adapter->tx_ring[ring];
-			netif_tx_napi_add(netdev, &tx_ring->napi, qlcnic_tx_poll,
-				       NAPI_POLL_WEIGHT);
+			netif_napi_add_tx(netdev, &tx_ring->napi,
+					  qlcnic_tx_poll);
 		}
 	}
 
@@ -2138,9 +2138,8 @@ int qlcnic_83xx_napi_add(struct qlcnic_adapter *adapter,
 	    !(adapter->flags & QLCNIC_TX_INTR_SHARED)) {
 		for (ring = 0; ring < adapter->drv_tx_rings; ring++) {
 			tx_ring = &adapter->tx_ring[ring];
-			netif_tx_napi_add(netdev, &tx_ring->napi,
-				       qlcnic_83xx_msix_tx_poll,
-				       NAPI_POLL_WEIGHT);
+			netif_napi_add_tx(netdev, &tx_ring->napi,
+					  qlcnic_83xx_msix_tx_poll);
 		}
 	}
 
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 3fcea211716c..fc83ec23bd1d 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2573,8 +2573,7 @@ static int rocker_probe_port(struct rocker *rocker, unsigned int port_number)
 	rocker_port_dev_addr_init(rocker_port);
 	dev->netdev_ops = &rocker_port_netdev_ops;
 	dev->ethtool_ops = &rocker_port_ethtool_ops;
-	netif_tx_napi_add(dev, &rocker_port->napi_tx, rocker_port_poll_tx,
-			  NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(dev, &rocker_port->napi_tx, rocker_port_poll_tx);
 	netif_napi_add(dev, &rocker_port->napi_rx, rocker_port_poll_rx,
 		       NAPI_POLL_WEIGHT);
 	rocker_carrier_init(rocker_port);
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 2c48f8b8ab71..f0c8de2c6075 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1689,8 +1689,7 @@ static int ave_probe(struct platform_device *pdev)
 	/* Register as a NAPI supported driver */
 	netif_napi_add(ndev, &priv->napi_rx, ave_napi_poll_rx,
 		       NAPI_POLL_WEIGHT);
-	netif_tx_napi_add(ndev, &priv->napi_tx, ave_napi_poll_tx,
-			  NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(ndev, &priv->napi_tx, ave_napi_poll_tx);
 
 	platform_set_drvdata(pdev, ndev);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7c834c02e084..99fa1bd43f47 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6759,9 +6759,8 @@ static void stmmac_napi_add(struct net_device *dev)
 				       NAPI_POLL_WEIGHT);
 		}
 		if (queue < priv->plat->tx_queues_to_use) {
-			netif_tx_napi_add(dev, &ch->tx_napi,
-					  stmmac_napi_poll_tx,
-					  NAPI_POLL_WEIGHT);
+			netif_napi_add_tx(dev, &ch->tx_napi,
+					  stmmac_napi_poll_tx);
 		}
 		if (queue < priv->plat->rx_queues_to_use &&
 		    queue < priv->plat->tx_queues_to_use) {
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b7ebd741f284..34197c67f8d9 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2032,8 +2032,8 @@ static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		netif_tx_napi_add(common->dma_ndev, &tx_chn->napi_tx,
-				  am65_cpsw_nuss_tx_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(common->dma_ndev, &tx_chn->napi_tx,
+				  am65_cpsw_nuss_tx_poll);
 
 		ret = devm_request_irq(dev, tx_chn->irq,
 				       am65_cpsw_nuss_tx_irq,
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 662435e36805..ed66c4d4d830 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1640,9 +1640,8 @@ static int cpsw_probe(struct platform_device *pdev)
 	netif_napi_add(ndev, &cpsw->napi_rx,
 		       cpsw->quirk_irq ? cpsw_rx_poll : cpsw_rx_mq_poll,
 		       NAPI_POLL_WEIGHT);
-	netif_tx_napi_add(ndev, &cpsw->napi_tx,
-			  cpsw->quirk_irq ? cpsw_tx_poll : cpsw_tx_mq_poll,
-			  NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(ndev, &cpsw->napi_tx,
+			  cpsw->quirk_irq ? cpsw_tx_poll : cpsw_tx_mq_poll);
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index b33781ed760e..12341796af2f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1417,10 +1417,9 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 				       cpsw->quirk_irq ?
 				       cpsw_rx_poll : cpsw_rx_mq_poll,
 				       NAPI_POLL_WEIGHT);
-			netif_tx_napi_add(ndev, &cpsw->napi_tx,
+			netif_napi_add_tx(ndev, &cpsw->napi_tx,
 					  cpsw->quirk_irq ?
-					  cpsw_tx_poll : cpsw_tx_mq_poll,
-					  NAPI_POLL_WEIGHT);
+					  cpsw_tx_poll : cpsw_tx_mq_poll);
 		}
 
 		napi_ndev = ndev;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 21b0e961eab5..b15d44261e76 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2096,7 +2096,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 
 	/* NAPI register */
 	netif_napi_add(ndev, &netcp->rx_napi, netcp_rx_poll, NAPI_POLL_WEIGHT);
-	netif_tx_napi_add(ndev, &netcp->tx_napi, netcp_tx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(ndev, &netcp->tx_napi, netcp_tx_poll);
 
 	/* Register the network device */
 	ndev->dev_id		= 0;
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index bc981043cc80..db4cb2de218c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1614,8 +1614,8 @@ static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
 	gsi_channel_program(channel, true);
 
 	if (channel->toward_ipa)
-		netif_tx_napi_add(&gsi->dummy_dev, &channel->napi,
-				  gsi_channel_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(&gsi->dummy_dev, &channel->napi,
+				  gsi_channel_poll);
 	else
 		netif_napi_add(&gsi->dummy_dev, &channel->napi,
 			       gsi_channel_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dbe4c0a4be2c..87a635aac008 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -268,8 +268,7 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 	tfile->napi_enabled = napi_en;
 	tfile->napi_frags_enabled = napi_en && napi_frags;
 	if (napi_en) {
-		netif_tx_napi_add(tun->dev, &tfile->napi, tun_napi_poll,
-				  NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(tun->dev, &tfile->napi, tun_napi_poll);
 		napi_enable(&tfile->napi);
 	}
 }
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ae85179ca49a..9e54fe76a9b2 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -7099,8 +7099,7 @@ int qeth_open(struct net_device *dev)
 
 	local_bh_disable();
 	qeth_for_each_output_queue(card, queue, i) {
-		netif_tx_napi_add(dev, &queue->napi, qeth_tx_poll,
-				  NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(dev, &queue->napi, qeth_tx_poll);
 		napi_enable(&queue->napi);
 		napi_schedule(&queue->napi);
 	}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 52ed2c0ac901..7a9e2545884f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3786,8 +3786,8 @@ void __init mptcp_proto_init(void)
 	for_each_possible_cpu(cpu) {
 		delegated = per_cpu_ptr(&mptcp_delegated_actions, cpu);
 		INIT_LIST_HEAD(&delegated->head);
-		netif_tx_napi_add(&mptcp_napi_dev, &delegated->napi, mptcp_napi_poll,
-				  NAPI_POLL_WEIGHT);
+		netif_napi_add_tx(&mptcp_napi_dev, &delegated->napi,
+				  mptcp_napi_poll);
 		napi_enable(&delegated->napi);
 	}
 
-- 
2.34.1

