Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FB85EC47E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiI0NcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiI0Nbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8336E1B053B;
        Tue, 27 Sep 2022 06:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA5D461983;
        Tue, 27 Sep 2022 13:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B84DC433D7;
        Tue, 27 Sep 2022 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664285277;
        bh=soMeDNPu75OALF3s8BnNe8DCW29Vqg391Q/puPBpjM0=;
        h=From:To:Cc:Subject:Date:From;
        b=ge45iwrmphVQOAKXOju3nO4mmxkEL56PXEB5M1KJfVMo6UqT0EoydccISPMXRF7V3
         oSmcSpGbFMx5hq7rha/CY3Ezdx64s+RT9Hph4sSKrhZckARCSf1wI1VVu5Zm7E4EtE
         UX/gzZXBSTJBm6BCdQdytFxQn400b89Dp727nC0buXRqk1YRw/zjLukKhZ+5UGWu3O
         Bhpj7AAo8tETl1lJ2wuJx8VKi4koF/sgKO5lSXdVY7S6z0xtg3qFb9OgDFfq20VOj5
         OA53CIeNA/hlUN1JPjOqr3yt0P3ubrXCRhi3dFxJd4vIx8GWlT0ljv6pxmCVufpxgE
         UuFdjQQkw4L6g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: drop the weight argument from netif_napi_add
Date:   Tue, 27 Sep 2022 06:27:53 -0700
Message-Id: <20220927132753.750069-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We tell driver developers to always pass NAPI_POLL_WEIGHT
as the weight to netif_napi_add(). This may be confusing
to newcomers, drop the weight argument, those who really
need to tweak the weight can use netif_napi_add_weight().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c      |  2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c         |  2 +-
 drivers/net/can/m_can/m_can.c                 |  3 +--
 drivers/net/ethernet/actions/owl-emac.c       |  2 +-
 drivers/net/ethernet/aeroflex/greth.c         |  2 +-
 drivers/net/ethernet/agere/et131x.c           |  2 +-
 drivers/net/ethernet/alacritech/slicoss.c     |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 ++----
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  4 ++--
 drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  6 ++----
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  3 +--
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  3 +--
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  2 +-
 drivers/net/ethernet/broadcom/b44.c           |  2 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c  |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  2 +-
 drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  6 ++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +++---
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  3 +--
 drivers/net/ethernet/broadcom/tg3.c           |  4 ++--
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/net/ethernet/cadence/macb_main.c      |  4 ++--
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../net/ethernet/cavium/liquidio/lio_core.c   |  2 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  3 +--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  3 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |  2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  9 +++++----
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/dnet.c                   |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  3 +--
 drivers/net/ethernet/engleder/tsnep_main.c    |  2 +-
 drivers/net/ethernet/ethoc.c                  |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 drivers/net/ethernet/faraday/ftmac100.c       |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  3 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 +--
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  5 ++---
 drivers/net/ethernet/freescale/enetc/enetc.c  |  3 +--
 drivers/net/ethernet/freescale/fec_main.c     |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c     |  2 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  3 +--
 drivers/net/ethernet/google/gve/gve_main.c    |  3 +--
 drivers/net/ethernet/hisilicon/hip04_eth.c    |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  6 ++----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  3 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  3 +--
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  3 +--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  3 +--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  3 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/jme.c                    |  2 +-
 drivers/net/ethernet/korina.c                 |  2 +-
 drivers/net/ethernet/lantiq_xrx200.c          |  3 +--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  5 ++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  6 ++----
 .../ethernet/marvell/octeon_ep/octep_main.c   |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  3 +--
 .../ethernet/marvell/prestera/prestera_rxtx.c |  2 +-
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  6 ++----
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  3 +--
 drivers/net/ethernet/mellanox/mlx4/en_cq.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  4 +---
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  3 +--
 drivers/net/ethernet/natsemi/natsemi.c        |  2 +-
 drivers/net/ethernet/neterion/s2io.c          |  4 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 +---
 drivers/net/ethernet/ni/nixge.c               |  2 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  2 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  3 +--
 drivers/net/ethernet/pasemi/pasemi_mac.c      |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 12 ++++--------
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  3 +--
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  3 +--
 drivers/net/ethernet/qlogic/qla3xxx.c         |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    | 19 +++++++------------
 drivers/net/ethernet/qualcomm/emac/emac.c     |  3 +--
 drivers/net/ethernet/rdc/r6040.c              |  2 +-
 drivers/net/ethernet/realtek/8139too.c        |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  4 ++--
 drivers/net/ethernet/renesas/sh_eth.c         |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  3 +--
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  2 +-
 drivers/net/ethernet/sfc/ef100_rep.c          |  3 +--
 drivers/net/ethernet/sfc/efx_channels.c       |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  2 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c |  2 +-
 drivers/net/ethernet/smsc/epic100.c           |  2 +-
 drivers/net/ethernet/smsc/smsc9420.c          |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 drivers/net/ethernet/socionext/sni_ave.c      |  3 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 ++----
 drivers/net/ethernet/sun/cassini.c            |  2 +-
 drivers/net/ethernet/sun/ldmvsw.c             |  3 +--
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 drivers/net/ethernet/sun/sunvnet.c            |  3 +--
 drivers/net/ethernet/sunplus/spl2sw_driver.c  |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  5 ++---
 drivers/net/ethernet/tehuti/tehuti.c          |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpmac.c               |  2 +-
 drivers/net/ethernet/ti/cpsw.c                |  3 +--
 drivers/net/ethernet/ti/cpsw_new.c            |  4 +---
 drivers/net/ethernet/ti/davinci_emac.c        |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  2 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  3 +--
 drivers/net/ethernet/tundra/tsi108_eth.c      |  2 +-
 drivers/net/ethernet/via/via-rhine.c          |  2 +-
 drivers/net/ethernet/via/via-velocity.c       |  2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  4 ++--
 drivers/net/fjes/fjes_main.c                  |  2 +-
 drivers/net/hyperv/netvsc.c                   |  3 +--
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/ipa/gsi.c                         |  2 +-
 drivers/net/thunderbolt.c                     |  2 +-
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/net/veth.c                            |  4 ++--
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 ++--
 drivers/net/wireguard/peer.c                  |  3 +--
 drivers/net/wireless/ath/ath10k/pci.c         |  3 +--
 drivers/net/wireless/ath/ath10k/sdio.c        |  3 +--
 drivers/net/wireless/ath/ath10k/snoc.c        |  3 +--
 drivers/net/wireless/ath/ath10k/usb.c         |  3 +--
 drivers/net/wireless/ath/ath11k/ahb.c         |  2 +-
 drivers/net/wireless/ath/ath11k/pcic.c        |  2 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |  6 ++----
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/dma.c      |  2 +-
 drivers/net/wireless/realtek/rtw88/pci.c      |  3 +--
 drivers/net/wireless/realtek/rtw89/core.c     |  2 +-
 drivers/net/xen-netback/interface.c           |  3 +--
 drivers/net/xen-netfront.c                    |  3 +--
 drivers/s390/net/qeth_l2_main.c               |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  2 +-
 drivers/staging/qlge/qlge_main.c              |  4 ++--
 include/linux/netdevice.h                     |  5 ++---
 net/core/gro_cells.c                          |  3 +--
 170 files changed, 207 insertions(+), 284 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index c4026712ab7d..b8da15ea6ad9 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -1424,7 +1424,7 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	priv->can.clock.freq = can_clk_rate;
 
-	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll);
 
 	ret = register_candev(ndev);
 	if (ret) {
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index ad7a89b95da7..8d42b7e6661f 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -973,7 +973,7 @@ static int ifi_canfd_plat_probe(struct platform_device *pdev)
 	priv->ndev = ndev;
 	priv->base = addr;
 
-	netif_napi_add(ndev, &priv->napi, ifi_canfd_poll, 64);
+	netif_napi_add(ndev, &priv->napi, ifi_canfd_poll);
 
 	priv->can.state = CAN_STATE_STOPPED;
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4709c012b1dc..dcb582563d5e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1467,8 +1467,7 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	}
 
 	if (!cdev->is_peripheral)
-		netif_napi_add(dev, &cdev->napi,
-			       m_can_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &cdev->napi, m_can_poll);
 
 	/* Shared properties of all M_CAN versions */
 	cdev->version = m_can_version;
diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index 1cfdd01b4c2e..cd4d71b83c33 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -1576,7 +1576,7 @@ static int owl_emac_probe(struct platform_device *pdev)
 	netdev->watchdog_timeo = OWL_EMAC_TX_TIMEOUT;
 	netdev->netdev_ops = &owl_emac_netdev_ops;
 	netdev->ethtool_ops = &owl_emac_ethtool_ops;
-	netif_napi_add(netdev, &priv->napi, owl_emac_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &priv->napi, owl_emac_poll);
 
 	ret = devm_register_netdev(dev, netdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c4fe25aca6c..e104fb02817d 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1507,7 +1507,7 @@ static int greth_of_probe(struct platform_device *ofdev)
 	}
 
 	/* setup NAPI */
-	netif_napi_add(dev, &greth->napi, greth_poll, 64);
+	netif_napi_add(dev, &greth->napi, greth_poll);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 28334b1e3d6b..5fab589b3ddf 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3969,7 +3969,7 @@ static int et131x_pci_setup(struct pci_dev *pdev,
 
 	et131x_init_send(adapter);
 
-	netif_napi_add(netdev, &adapter->napi, et131x_poll, 64);
+	netif_napi_add(netdev, &adapter->napi, et131x_poll);
 
 	eth_hw_addr_set(netdev, adapter->addr);
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 4cea61f16be3..a30d0f172986 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1803,7 +1803,7 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto unmap;
 	}
 
-	netif_napi_add(dev, &sdev->napi, slic_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &sdev->napi, slic_poll);
 	netif_carrier_off(dev);
 
 	err = register_netdev(dev);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 3cf409bdb283..7633b227b2ca 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1365,7 +1365,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 	/* setup NAPI interface */
-	netif_napi_add(ndev, &priv->napi, tse_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, tse_poll);
 
 	spin_lock_init(&priv->mac_cfg_lock);
 	spin_lock_init(&priv->tx_lock);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 371269e0b2b9..d350eeec8bad 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2265,10 +2265,8 @@ static void ena_init_napi_in_range(struct ena_adapter *adapter,
 	for (i = first_index; i < first_index + count; i++) {
 		struct ena_napi *napi = &adapter->ena_napi[i];
 
-		netif_napi_add(adapter->netdev,
-			       &napi->napi,
-			       ENA_IS_XDP_INDEX(adapter, i) ? ena_xdp_io_poll : ena_io_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(adapter->netdev, &napi->napi,
+			       ENA_IS_XDP_INDEX(adapter, i) ? ena_xdp_io_poll : ena_io_poll);
 
 		if (!ENA_IS_XDP_INDEX(adapter, i)) {
 			napi->rx_ring = &adapter->rx_ring[i];
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index f342bb853189..7b666106feee 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -952,14 +952,14 @@ static void xgbe_napi_enable(struct xgbe_prv_data *pdata, unsigned int add)
 			channel = pdata->channel[i];
 			if (add)
 				netif_napi_add(pdata->netdev, &channel->napi,
-					       xgbe_one_poll, NAPI_POLL_WEIGHT);
+					       xgbe_one_poll);
 
 			napi_enable(&channel->napi);
 		}
 	} else {
 		if (add)
 			netif_napi_add(pdata->netdev, &pdata->napi,
-				       xgbe_all_poll, NAPI_POLL_WEIGHT);
+				       xgbe_all_poll);
 
 		napi_enable(&pdata->napi);
 	}
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index d022b6db9e06..379d19d18dbe 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -672,7 +672,7 @@ static int xge_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	netif_napi_add(ndev, &pdata->napi, xge_napi, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &pdata->napi, xge_napi);
 
 	ret = register_netdev(ndev);
 	if (ret) {
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 53dc8d5fede8..d6cfea65a714 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1977,14 +1977,12 @@ static void xgene_enet_napi_add(struct xgene_enet_pdata *pdata)
 
 	for (i = 0; i < pdata->rxq_cnt; i++) {
 		napi = &pdata->rx_ring[i]->napi;
-		netif_napi_add(pdata->ndev, napi, xgene_enet_napi,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(pdata->ndev, napi, xgene_enet_napi);
 	}
 
 	for (i = 0; i < pdata->cq_cnt; i++) {
 		napi = &pdata->tx_ring[i]->cp_ring->napi;
-		netif_napi_add(pdata->ndev, napi, xgene_enet_napi,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(pdata->ndev, napi, xgene_enet_napi);
 	}
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 275324c9e51e..80b44043e6c5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1217,8 +1217,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 	atomic_set(&aq_ptp->offset_egress, 0);
 	atomic_set(&aq_ptp->offset_ingress, 0);
 
-	netif_napi_add(aq_nic_get_ndev(aq_nic), &aq_ptp->napi,
-		       aq_ptp_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(aq_nic_get_ndev(aq_nic), &aq_ptp->napi, aq_ptp_poll);
 
 	aq_ptp->idx_vector = idx_vec;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f0fdf20f01c1..f5db1c44e9b9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -119,8 +119,7 @@ struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 	self->tx_rings = 0;
 	self->rx_rings = 0;
 
-	netif_napi_add(aq_nic_get_ndev(aq_nic), &self->napi,
-		       aq_vec_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(aq_nic_get_ndev(aq_nic), &self->napi, aq_vec_poll);
 
 err_exit:
 	return self;
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index a89b93cb4e26..80bb8424e9a4 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -752,7 +752,7 @@ static int alx_alloc_napis(struct alx_priv *alx)
 			goto err_out;
 
 		np->alx = alx;
-		netif_napi_add(alx->dev, &np->napi, alx_poll, 64);
+		netif_napi_add(alx->dev, &np->napi, alx_poll);
 		alx->qnapi[i] = np;
 	}
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index be4b1f8eef29..40c781695d58 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2732,7 +2732,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev_set_threaded(netdev, true);
 	for (i = 0; i < adapter->rx_queue_count; ++i)
 		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
-			       atl1c_clean_rx, 64);
+			       atl1c_clean_rx);
 	for (i = 0; i < adapter->tx_queue_count; ++i)
 		netif_napi_add_tx(netdev, &adapter->tpd_ring[i].napi,
 				  atl1c_clean_tx);
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 57a51fb7746c..5db0f3495a32 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2354,7 +2354,7 @@ static int atl1e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->mii.phy_id_mask = 0x1f;
 	adapter->mii.reg_num_mask = MDIO_REG_ADDR_MASK;
 
-	netif_napi_add(netdev, &adapter->napi, atl1e_clean, 64);
+	netif_napi_add(netdev, &adapter->napi, atl1e_clean);
 
 	timer_setup(&adapter->phy_config_timer, atl1e_phy_config, 0);
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 7fcfba370fc3..c8444bcdf527 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2977,7 +2977,7 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->netdev_ops = &atl1_netdev_ops;
 	netdev->watchdog_timeo = 5 * HZ;
-	netif_napi_add(netdev, &adapter->napi, atl1_rings_clean, 64);
+	netif_napi_add(netdev, &adapter->napi, atl1_rings_clean);
 
 	netdev->ethtool_ops = &atl1_ethtool_ops;
 	adapter->bd_number = cards_found;
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 7821084c8fbe..7f876721596c 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2375,7 +2375,7 @@ static int b44_init_one(struct ssb_device *sdev,
 	bp->tx_pending = B44_DEF_TX_RING_PENDING;
 
 	dev->netdev_ops = &b44_netdev_ops;
-	netif_napi_add(dev, &bp->napi, b44_poll, 64);
+	netif_napi_add(dev, &bp->napi, b44_poll);
 	dev->watchdog_timeo = B44_TX_TIMEOUT;
 	dev->min_mtu = B44_MIN_MTU;
 	dev->max_mtu = B44_MAX_MTU;
diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 489367fa5748..93ccf549e2ed 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -725,7 +725,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	netdev->mtu = ETH_DATA_LEN;
 	netdev->max_mtu = ENET_MTU_MAX;
 	netif_napi_add_tx(netdev, &enet->tx_ring.napi, bcm4908_enet_poll_tx);
-	netif_napi_add(netdev, &enet->rx_ring.napi, bcm4908_enet_poll_rx, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &enet->rx_ring.napi, bcm4908_enet_poll_rx);
 
 	err = register_netdev(netdev);
 	if (err)
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 52144ea2bbf3..867f14c30e09 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2564,7 +2564,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, dev);
 	dev->ethtool_ops = &bcm_sysport_ethtool_ops;
 	dev->netdev_ops = &bcm_sysport_netdev_ops;
-	netif_napi_add(dev, &priv->napi, bcm_sysport_poll, 64);
+	netif_napi_add(dev, &priv->napi, bcm_sysport_poll);
 
 	dev->features |= NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
 			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 29a9ab20ff98..5fb3af5670ec 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1527,7 +1527,7 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	if (bcm47xx_nvram_getenv("et0_no_txint", NULL, 0) == 0)
 		bgmac->int_mask &= ~BGMAC_IS_TX_MASK;
 
-	netif_napi_add(net_dev, &bgmac->napi, bgmac_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(net_dev, &bgmac->napi, bgmac_poll);
 
 	err = bgmac_phy_connect(bgmac);
 	if (err) {
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b612781be893..9624c45026ed 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8522,7 +8522,7 @@ bnx2_init_napi(struct bnx2 *bp)
 		else
 			poll = bnx2_poll_msix;
 
-		netif_napi_add(bp->dev, &bp->bnx2_napi[i].napi, poll, 64);
+		netif_napi_add(bp->dev, &bp->bnx2_napi[i].napi, poll);
 		bnapi->bp = bp;
 	}
 }
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e704e42446aa..b6eb3ce976f0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -44,8 +44,7 @@ static void bnx2x_add_all_napi_cnic(struct bnx2x *bp)
 
 	/* Add NAPI objects */
 	for_each_rx_queue_cnic(bp, i) {
-		netif_napi_add(bp->dev, &bnx2x_fp(bp, i, napi),
-			       bnx2x_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(bp->dev, &bnx2x_fp(bp, i, napi), bnx2x_poll);
 	}
 }
 
@@ -55,8 +54,7 @@ static void bnx2x_add_all_napi(struct bnx2x *bp)
 
 	/* Add NAPI objects */
 	for_each_eth_queue(bp, i) {
-		netif_napi_add(bp->dev, &bnx2x_fp(bp, i, napi),
-			       bnx2x_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(bp->dev, &bnx2x_fp(bp, i, napi), bnx2x_poll);
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 96da0ba3d507..eed98c10ca9d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9366,16 +9366,16 @@ static void bnxt_init_napi(struct bnxt *bp)
 			cp_nr_rings--;
 		for (i = 0; i < cp_nr_rings; i++) {
 			bnapi = bp->bnapi[i];
-			netif_napi_add(bp->dev, &bnapi->napi, poll_fn, 64);
+			netif_napi_add(bp->dev, &bnapi->napi, poll_fn);
 		}
 		if (BNXT_CHIP_TYPE_NITRO_A0(bp)) {
 			bnapi = bp->bnapi[cp_nr_rings];
 			netif_napi_add(bp->dev, &bnapi->napi,
-				       bnxt_poll_nitroa0, 64);
+				       bnxt_poll_nitroa0);
 		}
 	} else {
 		bnapi = bp->bnapi[0];
-		netif_napi_add(bp->dev, &bnapi->napi, bnxt_poll, 64);
+		netif_napi_add(bp->dev, &bnapi->napi, bnxt_poll);
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 667e66079c73..25c450606985 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2707,8 +2707,7 @@ static int bcmgenet_init_rx_ring(struct bcmgenet_priv *priv,
 	bcmgenet_init_rx_coalesce(ring);
 
 	/* Initialize Rx NAPI */
-	netif_napi_add(priv->dev, &ring->napi, bcmgenet_rx_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(priv->dev, &ring->napi, bcmgenet_rx_poll);
 
 	bcmgenet_rdma_ring_writel(priv, index, 0, RDMA_PROD_INDEX);
 	bcmgenet_rdma_ring_writel(priv, index, 0, RDMA_CONS_INDEX);
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 59d2d907e989..4179a12fc881 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7380,9 +7380,9 @@ static void tg3_napi_init(struct tg3 *tp)
 {
 	int i;
 
-	netif_napi_add(tp->dev, &tp->napi[0].napi, tg3_poll, 64);
+	netif_napi_add(tp->dev, &tp->napi[0].napi, tg3_poll);
 	for (i = 1; i < tp->irq_cnt; i++)
-		netif_napi_add(tp->dev, &tp->napi[i].napi, tg3_poll_msix, 64);
+		netif_napi_add(tp->dev, &tp->napi[i].napi, tg3_poll_msix);
 }
 
 static void tg3_napi_fini(struct tg3 *tp)
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 29dd0f93d6c0..d6d90f9722a7 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1891,7 +1891,7 @@ bnad_napi_add(struct bnad *bnad, u32 rx_id)
 	for (i = 0; i <	bnad->num_rxp_per_rx; i++) {
 		rx_ctrl = &bnad->rx_info[rx_id].rx_ctrl[i];
 		netif_napi_add(bnad->netdev, &rx_ctrl->napi,
-			       bnad_napi_poll_rx, NAPI_POLL_WEIGHT);
+			       bnad_napi_poll_rx);
 	}
 }
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4769c8a0c73a..c39697bed2fa 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3978,8 +3978,8 @@ static int macb_init(struct platform_device *pdev)
 		queue = &bp->queues[q];
 		queue->bp = bp;
 		spin_lock_init(&queue->tx_ptr_lock);
-		netif_napi_add(dev, &queue->napi_rx, macb_rx_poll, NAPI_POLL_WEIGHT);
-		netif_napi_add(dev, &queue->napi_tx, macb_tx_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &queue->napi_rx, macb_rx_poll);
+		netif_napi_add(dev, &queue->napi_tx, macb_tx_poll);
 		if (hw_q) {
 			queue->ISR  = GEM_ISR(hw_q - 1);
 			queue->IER  = GEM_IER(hw_q - 1);
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 1281d1565ef8..f4f87dfa9687 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1792,7 +1792,7 @@ static int xgmac_probe(struct platform_device *pdev)
 		netdev_warn(ndev, "MAC address %pM not valid",
 			 ndev->dev_addr);
 
-	netif_napi_add(ndev, &priv->napi, xgmac_poll, 64);
+	netif_napi_add(ndev, &priv->napi, xgmac_poll);
 	ret = register_netdev(ndev);
 	if (ret)
 		goto err_reg;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 73cb03266549..882b2be06ea0 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -851,7 +851,7 @@ int liquidio_setup_io_queues(struct octeon_device *octeon_dev, int ifidx,
 		napi = &droq->napi;
 		dev_dbg(&octeon_dev->pci_dev->dev, "netif_napi_add netdev:%llx oct:%llx\n",
 			(u64)netdev, (u64)octeon_dev);
-		netif_napi_add(netdev, napi, liquidio_napi_poll, 64);
+		netif_napi_add(netdev, napi, liquidio_napi_poll);
 
 		/* designate a CPU for this droq */
 		droq->cpu_id = cpu_id;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 768ea426d49f..98f3dc460ca7 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1472,8 +1472,7 @@ int nicvf_open(struct net_device *netdev)
 		}
 		cq_poll->cq_idx = qidx;
 		cq_poll->nicvf = nic;
-		netif_napi_add(netdev, &cq_poll->napi, nicvf_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(netdev, &cq_poll->napi, nicvf_poll);
 		napi_enable(&cq_poll->napi);
 		nic->napi[qidx] = cq_poll;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 17043c4fce52..d2286adf09fe 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1053,7 +1053,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->hard_header_len += (netdev->hw_features & NETIF_F_TSO) ?
 			sizeof(struct cpl_tx_pkt_lso) : sizeof(struct cpl_tx_pkt);
 
-		netif_napi_add(netdev, &adapter->napi, t1_poll, 64);
+		netif_napi_add(netdev, &adapter->napi, t1_poll);
 
 		netdev->ethtool_ops = &t1_ethtool_ops;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index a46afc0bf5cc..a52e6b6e2876 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -609,8 +609,7 @@ static void init_napi(struct adapter *adap)
 		struct sge_qset *qs = &adap->sge.qs[i];
 
 		if (qs->adap)
-			netif_napi_add(qs->netdev, &qs->napi, qs->napi.poll,
-				       64);
+			netif_napi_add(qs->netdev, &qs->napi, qs->napi.poll);
 	}
 
 	/*
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index ee52e3b1d74f..46809e2d94ee 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -4467,7 +4467,7 @@ int t4_sge_alloc_rxq(struct adapter *adap, struct sge_rspq *iq, bool fwevtq,
 	if (ret)
 		goto err;
 
-	netif_napi_add(dev, &iq->napi, napi_rx_handler, 64);
+	netif_napi_add(dev, &iq->napi, napi_rx_handler);
 	iq->cur_desc = iq->desc;
 	iq->cidx = 0;
 	iq->gen = 1;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 43b2ceb6aa32..2d0cf76fb3c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -2336,7 +2336,7 @@ int t4vf_sge_alloc_rxq(struct adapter *adapter, struct sge_rspq *rspq,
 	if (ret)
 		goto err;
 
-	netif_napi_add(dev, &rspq->napi, napi_rx_handler, 64);
+	netif_napi_add(dev, &rspq->napi, napi_rx_handler);
 	rspq->cur_desc = rspq->desc;
 	rspq->cidx = 0;
 	rspq->gen = 1;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 888506185326..8627ab19d470 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -812,7 +812,7 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 	ep = netdev_priv(dev);
 	ep->dev = dev;
 	SET_NETDEV_DEV(dev, &pdev->dev);
-	netif_napi_add(dev, &ep->napi, ep93xx_poll, 64);
+	netif_napi_add(dev, &ep->napi, ep93xx_poll);
 
 	platform_set_drvdata(pdev, dev);
 
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 372fb7b3a282..29500d32e362 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2633,16 +2633,17 @@ static int enic_dev_init(struct enic *enic)
 
 	switch (vnic_dev_get_intr_mode(enic->vdev)) {
 	default:
-		netif_napi_add(netdev, &enic->napi[0], enic_poll, 64);
+		netif_napi_add(netdev, &enic->napi[0], enic_poll);
 		break;
 	case VNIC_DEV_INTR_MODE_MSIX:
 		for (i = 0; i < enic->rq_count; i++) {
 			netif_napi_add(netdev, &enic->napi[i],
-				enic_poll_msix_rq, NAPI_POLL_WEIGHT);
+				       enic_poll_msix_rq);
 		}
 		for (i = 0; i < enic->wq_count; i++)
-			netif_napi_add(netdev, &enic->napi[enic_cq_wq(enic, i)],
-				       enic_poll_msix_wq, NAPI_POLL_WEIGHT);
+			netif_napi_add(netdev,
+				       &enic->napi[enic_cq_wq(enic, i)],
+				       enic_poll_msix_wq);
 		break;
 	}
 
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6dae768671e3..fdf10318758b 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2471,7 +2471,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	netdev->max_mtu = 10236 - VLAN_ETH_HLEN;
 
 	port->freeq_refill = 0;
-	netif_napi_add(netdev, &port->napi, gmac_napi_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &port->napi, gmac_napi_poll);
 
 	ret = of_get_mac_address(np, mac);
 	if (!ret) {
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 99e6f76f6cc0..08184f20f510 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -788,7 +788,7 @@ static int dnet_probe(struct platform_device *pdev)
 	}
 
 	dev->netdev_ops = &dnet_netdev_ops;
-	netif_napi_add(dev, &bp->napi, dnet_poll, 64);
+	netif_napi_add(dev, &bp->napi, dnet_poll);
 	dev->ethtool_ops = &dnet_ethtool_ops;
 
 	dev->base_addr = (unsigned long)bp->regs;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 414362febbb9..a92a74761546 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2982,8 +2982,7 @@ static int be_evt_queues_create(struct be_adapter *adapter)
 			return -ENOMEM;
 		cpumask_set_cpu(cpumask_local_spread(i, numa_node),
 				eqo->affinity_mask);
-		netif_napi_add(adapter->netdev, &eqo->napi, be_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(adapter->netdev, &eqo->napi, be_poll);
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 19db8b1dddc4..fbb0243661bc 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -899,7 +899,7 @@ static int tsnep_netdev_open(struct net_device *netdev)
 
 	for (i = 0; i < adapter->num_queues; i++) {
 		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
-			       tsnep_poll, 64);
+			       tsnep_poll);
 		napi_enable(&adapter->queue[i].napi);
 
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 437c5acfe222..95cbad198b4b 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1224,7 +1224,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
-	netif_napi_add(netdev, &priv->napi, ethoc_poll, 64);
+	netif_napi_add(netdev, &priv->napi, ethoc_poll);
 
 	spin_lock_init(&priv->lock);
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index da04beee5865..a03879a27b04 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1506,7 +1506,7 @@ static int ftgmac100_open(struct net_device *netdev)
 		goto err_hw;
 
 	/* Initialize NAPI */
-	netif_napi_add(netdev, &priv->napi, ftgmac100_poll, 64);
+	netif_napi_add(netdev, &priv->napi, ftgmac100_poll);
 
 	/* Grab our interrupt */
 	err = request_irq(netdev->irq, ftgmac100_interrupt, 0, netdev->name, netdev);
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index bf6e664ffd43..d95d78230828 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -1091,7 +1091,7 @@ static int ftmac100_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->tx_lock);
 
 	/* initialize NAPI */
-	netif_napi_add(netdev, &priv->napi, ftmac100_poll, 64);
+	netif_napi_add(netdev, &priv->napi, ftmac100_poll);
 
 	/* map io memory */
 	priv->res = request_mem_region(res->start, resource_size(res),
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 0a180d17121c..31cfa121333d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -3183,8 +3183,7 @@ static int dpaa_napi_add(struct net_device *net_dev)
 	for_each_possible_cpu(cpu) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, cpu);
 
-		netif_napi_add(net_dev, &percpu_priv->np.napi,
-			       dpaa_eth_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(net_dev, &percpu_priv->np.napi, dpaa_eth_poll);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 75d51572693d..8d029addddad 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4565,8 +4565,7 @@ static void dpaa2_eth_add_ch_napi(struct dpaa2_eth_priv *priv)
 	for (i = 0; i < priv->num_channels; i++) {
 		ch = priv->channel[i];
 		/* NAPI weight *MUST* be a multiple of DPAA2_ETH_STORE_SIZE */
-		netif_napi_add(priv->net_dev, &ch->napi, dpaa2_eth_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(priv->net_dev, &ch->napi, dpaa2_eth_poll);
 	}
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index e507e9065214..2b5909fa93cf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3373,9 +3373,8 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	 * different queues for each switch ports.
 	 */
 	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
-		netif_napi_add(ethsw->ports[0]->netdev,
-			       &ethsw->fq[i].napi, dpaa2_switch_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(ethsw->ports[0]->netdev, &ethsw->fq[i].napi,
+			       dpaa2_switch_poll);
 
 	/* Setup IRQs */
 	err = dpaa2_switch_setup_irqs(sw_dev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9f5b921039bd..54bdf599ea05 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2759,8 +2759,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 			v->rx_dim_en = true;
 		}
 		INIT_WORK(&v->rx_dim.work, enetc_rx_dim_work);
-		netif_napi_add(priv->ndev, &v->napi, enetc_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(priv->ndev, &v->napi, enetc_poll);
 		v->count_tx_rings = v_tx_rings;
 
 		for (j = 0; j < v_tx_rings; j++) {
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 59921218a8a4..ff1950e96c6c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3608,7 +3608,7 @@ static int fec_enet_init(struct net_device *ndev)
 	ndev->ethtool_ops = &fec_enet_ethtool_ops;
 
 	writel(FEC_RX_DISABLED_IMASK, fep->hwp + FEC_IMASK);
-	netif_napi_add(ndev, &fep->napi, fec_enet_rx_napi, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &fep->napi, fec_enet_rx_napi);
 
 	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
 		/* enable hw VLAN support */
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index e7bf1524b68e..b2def295523a 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3233,7 +3233,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	/* Register for napi ...We are registering NAPI for each grp */
 	for (i = 0; i < priv->num_grps; i++) {
 		netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
-			       gfar_poll_rx_sq, NAPI_POLL_WEIGHT);
+			       gfar_poll_rx_sq);
 		netif_napi_add_tx_weight(dev, &priv->gfargrp[i].napi_tx,
 					 gfar_poll_tx_sq, 2);
 	}
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 823221c912ab..7a4cb4f07c32 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3712,7 +3712,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	dev->netdev_ops = &ucc_geth_netdev_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 	INIT_WORK(&ugeth->timeout_work, ucc_geth_timeout_work);
-	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll, 64);
+	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll);
 	dev->mtu = 1500;
 	dev->max_mtu = 1518;
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index b6de2ad82a32..673641601f61 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -339,8 +339,7 @@ static int fun_alloc_queue_irqs(struct net_device *dev, unsigned int ntx,
 			return PTR_ERR(irq);
 
 		fp->num_rx_irqs++;
-		netif_napi_add(dev, &irq->napi, fun_rxq_napi_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &irq->napi, fun_rxq_napi_poll);
 	}
 
 	netif_info(fp, intr, dev, "Reserved %u/%u IRQs for Tx/Rx queues\n",
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 044db3ebb071..d3e3ac242bfc 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -526,8 +526,7 @@ static void gve_add_napi(struct gve_priv *priv, int ntfy_idx,
 {
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
-	netif_napi_add(priv->dev, &block->napi, gve_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(priv->dev, &block->napi, gve_poll);
 }
 
 static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index ddeceb26fb79..50c3f5d6611f 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -990,7 +990,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	ndev->watchdog_timeo = TX_TIMEOUT;
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 	ndev->irq = irq;
-	netif_napi_add(ndev, &priv->napi, hip04_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, hip04_rx_poll);
 
 	hip04_reset_dreq(priv);
 	hip04_reset_ppe(priv);
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index d7e62eca050f..ffcf797dfa90 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1243,7 +1243,7 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_phy_node;
 
-	netif_napi_add(ndev, &priv->napi, hix5hd2_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, hix5hd2_poll);
 
 	if (HAS_CAP_TSO(priv->hw_cap)) {
 		ret = hix5hd2_init_sg_desc_queue(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index d94cc8c6681f..7cf10d1e2b31 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2109,8 +2109,7 @@ static int hns_nic_init_ring_data(struct hns_nic_priv *priv)
 		rd->fini_process = is_ver1 ? hns_nic_tx_fini_pro :
 			hns_nic_tx_fini_pro_v2;
 
-		netif_napi_add(priv->netdev, &rd->napi,
-			       hns_nic_common_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(priv->netdev, &rd->napi, hns_nic_common_poll);
 		rd->ring->irq_init_flag = RCB_IRQ_NOT_INITED;
 	}
 	for (i = h->q_num; i < h->q_num * 2; i++) {
@@ -2122,8 +2121,7 @@ static int hns_nic_init_ring_data(struct hns_nic_priv *priv)
 		rd->fini_process = is_ver1 ? hns_nic_rx_fini_pro :
 			hns_nic_rx_fini_pro_v2;
 
-		netif_napi_add(priv->netdev, &rd->napi,
-			       hns_nic_common_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(priv->netdev, &rd->napi, hns_nic_common_poll);
 		rd->ring->irq_init_flag = RCB_IRQ_NOT_INITED;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 39b75b68474c..4cb2421e71a7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4692,7 +4692,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 			goto map_ring_fail;
 
 		netif_napi_add(priv->netdev, &tqp_vector->napi,
-			       hns3_nic_common_poll, NAPI_POLL_WEIGHT);
+			       hns3_nic_common_poll);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 5dc302880f5f..294bdbbeacc3 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1546,7 +1546,7 @@ static int ehea_init_port_res(struct ehea_port *port, struct ehea_port_res *pr,
 
 	kfree(init_attr);
 
-	netif_napi_add(pr->port->netdev, &pr->napi, ehea_poll, 64);
+	netif_napi_add(pr->port->netdev, &pr->napi, ehea_poll);
 
 	ret = 0;
 	goto out;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5ab7c0f81e9a..65dbfbec487a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1262,7 +1262,7 @@ static int init_napi(struct ibmvnic_adapter *adapter)
 	for (i = 0; i < adapter->req_rx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Adding napi[%d]\n", i);
 		netif_napi_add(adapter->netdev, &adapter->napi[i],
-			       ibmvnic_poll, NAPI_POLL_WEIGHT);
+			       ibmvnic_poll);
 	}
 
 	adapter->num_active_rx_napi = adapter->req_rx_queues;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 23299fc56199..61e60e4de600 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1012,7 +1012,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &e1000_netdev_ops;
 	e1000_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
-	netif_napi_add(netdev, &adapter->napi, e1000_clean, 64);
+	netif_napi_add(netdev, &adapter->napi, e1000_clean);
 
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 56984803c957..49e926959ad3 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7479,7 +7479,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &e1000e_netdev_ops;
 	e1000e_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
-	netif_napi_add(netdev, &adapter->napi, e1000e_poll, 64);
+	netif_napi_add(netdev, &adapter->napi, e1000e_poll);
 	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
 	netdev->mem_start = mmio_start;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 3362f26d7f99..4a6630586ec9 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -1595,8 +1595,7 @@ static int fm10k_alloc_q_vector(struct fm10k_intfc *interface,
 		return -ENOMEM;
 
 	/* initialize NAPI */
-	netif_napi_add(interface->netdev, &q_vector->napi,
-		       fm10k_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(interface->netdev, &q_vector->napi, fm10k_poll);
 
 	/* tie q_vector and interface together */
 	interface->q_vector[v_idx] = q_vector;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3c8b70d31232..2c07fa8ecfc8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11941,8 +11941,7 @@ static int i40e_vsi_alloc_q_vector(struct i40e_vsi *vsi, int v_idx)
 	cpumask_copy(&q_vector->affinity_mask, cpu_possible_mask);
 
 	if (vsi->netdev)
-		netif_napi_add(vsi->netdev, &q_vector->napi,
-			       i40e_napi_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(vsi->netdev, &q_vector->napi, i40e_napi_poll);
 
 	/* tie q_vector and vsi together */
 	vsi->q_vectors[v_idx] = q_vector;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 79fef8c59d65..3fc572341781 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1831,7 +1831,7 @@ static int iavf_alloc_q_vectors(struct iavf_adapter *adapter)
 		q_vector->reg_idx = q_idx;
 		cpumask_copy(&q_vector->affinity_mask, cpu_possible_mask);
 		netif_napi_add(adapter->netdev, &q_vector->napi,
-			       iavf_napi_poll, NAPI_POLL_WEIGHT);
+			       iavf_napi_poll);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1e97242a8f85..9e36f01dfa4f 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -130,8 +130,7 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 	 * handler here (i.e. resume, reset/rebuild, etc.)
 	 */
 	if (vsi->netdev)
-		netif_napi_add(vsi->netdev, &q_vector->napi, ice_napi_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(vsi->netdev, &q_vector->napi, ice_napi_poll);
 
 out:
 	/* tie q_vector and VSI together */
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index e35371e61e07..f9f15acae90a 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -292,8 +292,8 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 		if (max_vsi_num < vsi->vsi_num)
 			max_vsi_num = vsi->vsi_num;
 
-		netif_napi_add(vf->repr->netdev, &vf->repr->q_vector->napi, ice_napi_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(vf->repr->netdev, &vf->repr->q_vector->napi,
+			       ice_napi_poll);
 
 		netif_keep_dst(vf->repr->netdev);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0ccc8a750374..f3fb50eb4a44 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3310,7 +3310,7 @@ static void ice_napi_add(struct ice_vsi *vsi)
 
 	ice_for_each_q_vector(vsi, v_idx)
 		netif_napi_add(vsi->netdev, &vsi->q_vectors[v_idx]->napi,
-			       ice_napi_poll, NAPI_POLL_WEIGHT);
+		               ice_napi_poll);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ff0c7f0bf07a..f8e32833226c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1211,8 +1211,7 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 		return -ENOMEM;
 
 	/* initialize NAPI */
-	netif_napi_add(adapter->netdev, &q_vector->napi,
-		       igb_poll, 64);
+	netif_napi_add(adapter->netdev, &q_vector->napi, igb_poll);
 
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] = q_vector;
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index f4e91db89fe5..3a32809510fc 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1109,7 +1109,7 @@ static int igbvf_alloc_queues(struct igbvf_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	netif_napi_add(netdev, &adapter->rx_ring->napi, igbvf_poll, 64);
+	netif_napi_add(netdev, &adapter->rx_ring->napi, igbvf_poll);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index bf6c461e1a2a..34889be63e78 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4394,8 +4394,7 @@ static int igc_alloc_q_vector(struct igc_adapter *adapter,
 		return -ENOMEM;
 
 	/* initialize NAPI */
-	netif_napi_add(adapter->netdev, &q_vector->napi,
-		       igc_poll, 64);
+	netif_napi_add(adapter->netdev, &q_vector->napi, igc_poll);
 
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] = q_vector;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 45be9a1ab6af..b4d47e7a76c8 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -414,7 +414,7 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &ixgb_netdev_ops;
 	ixgb_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
-	netif_napi_add(netdev, &adapter->napi, ixgb_clean, 64);
+	netif_napi_add(netdev, &adapter->napi, ixgb_clean);
 
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 86b11164655e..f8156fe4b1dc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -874,8 +874,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 
 #endif
 	/* initialize NAPI */
-	netif_napi_add(adapter->netdev, &q_vector->napi,
-		       ixgbe_poll, 64);
+	netif_napi_add(adapter->netdev, &q_vector->napi, ixgbe_poll);
 
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] = q_vector;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2f12fbe229c1..99933e89717a 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2733,7 +2733,7 @@ static int ixgbevf_alloc_q_vector(struct ixgbevf_adapter *adapter, int v_idx,
 		return -ENOMEM;
 
 	/* initialize NAPI */
-	netif_napi_add(adapter->netdev, &q_vector->napi, ixgbevf_poll, 64);
+	netif_napi_add(adapter->netdev, &q_vector->napi, ixgbevf_poll);
 
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] = q_vector;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index b56594407965..1732ec3c3dbd 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -3009,7 +3009,7 @@ jme_init_one(struct pci_dev *pdev,
 		jwrite32(jme, JME_APMC, apmc);
 	}
 
-	netif_napi_add(netdev, &jme->napi, jme_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &jme->napi, jme_poll);
 
 	spin_lock_init(&jme->phy_lock);
 	spin_lock_init(&jme->macaddr_lock);
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 27194398d8ba..2b9335cb4bb3 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1355,7 +1355,7 @@ static int korina_probe(struct platform_device *pdev)
 	dev->netdev_ops = &korina_netdev_ops;
 	dev->ethtool_ops = &netdev_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
-	netif_napi_add(dev, &lp->napi, korina_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &lp->napi, korina_poll);
 
 	lp->mii_if.dev = dev;
 	lp->mii_if.mdio_read = korina_mdio_read;
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 57f27cc7724e..8d646c7f8c82 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -620,8 +620,7 @@ static int xrx200_probe(struct platform_device *pdev)
 			 PMAC_HD_CTL);
 
 	/* setup NAPI */
-	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx);
 	netif_napi_add_tx(net_dev, &priv->chan_tx.napi,
 			  xrx200_tx_housekeeping);
 
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 8b9abe622489..707993b445d1 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3183,7 +3183,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 
 	INIT_WORK(&mp->tx_timeout_task, tx_timeout_task);
 
-	netif_napi_add(dev, &mp->napi, mv643xx_eth_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &mp->napi, mv643xx_eth_poll);
 
 	timer_setup(&mp->rx_oom, oom_timer_wrapper, 0);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b500fe1dfa81..ff3e361e06e7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5600,14 +5600,13 @@ static int mvneta_probe(struct platform_device *pdev)
 	 * operation, so only single NAPI should be initialized.
 	 */
 	if (pp->neta_armada3700) {
-		netif_napi_add(dev, &pp->napi, mvneta_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &pp->napi, mvneta_poll);
 	} else {
 		for_each_present_cpu(cpu) {
 			struct mvneta_pcpu_port *port =
 				per_cpu_ptr(pp->ports, cpu);
 
-			netif_napi_add(dev, &port->napi, mvneta_poll,
-				       NAPI_POLL_WEIGHT);
+			netif_napi_add(dev, &port->napi, mvneta_poll);
 			port->pp = pp;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 38e5b4be6a4d..daa890d6993e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5770,8 +5770,7 @@ static int mvpp2_simple_queue_vectors_init(struct mvpp2_port *port,
 	v->irq = irq_of_parse_and_map(port_node, 0);
 	if (v->irq <= 0)
 		return -EINVAL;
-	netif_napi_add(port->dev, &v->napi, mvpp2_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(port->dev, &v->napi, mvpp2_poll);
 
 	port->nqvecs = 1;
 
@@ -5831,8 +5830,7 @@ static int mvpp2_multi_queue_vectors_init(struct mvpp2_port *port,
 			goto err;
 		}
 
-		netif_napi_add(port->dev, &v->napi, mvpp2_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(port->dev, &v->napi, mvpp2_poll);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 97f080c66dd4..9089adcb75f9 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -410,7 +410,7 @@ static void octep_napi_add(struct octep_device *oct)
 	for (i = 0; i < oct->num_oqs; i++) {
 		netdev_dbg(oct->netdev, "Adding NAPI on Q-%d\n", i);
 		netif_napi_add(oct->netdev, &oct->ioq_vector[i]->napi,
-			       octep_napi_poll, 64);
+			       octep_napi_poll);
 		oct->oq[i]->napi = &oct->ioq_vector[i]->napi;
 	}
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 88ce472959b0..fa9348d6a4f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1661,8 +1661,7 @@ int otx2_open(struct net_device *netdev)
 		cq_poll->dev = (void *)pf;
 		cq_poll->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_CQE;
 		INIT_WORK(&cq_poll->dim.work, otx2_dim_work);
-		netif_napi_add(netdev, &cq_poll->napi,
-			       otx2_napi_handler, NAPI_POLL_WEIGHT);
+		netif_napi_add(netdev, &cq_poll->napi, otx2_napi_handler);
 		napi_enable(&cq_poll->napi);
 	}
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index dc3e3ddc60bf..42ee963e9f75 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -659,7 +659,7 @@ static int prestera_sdma_switch_init(struct prestera_switch *sw)
 
 	init_dummy_netdev(&sdma->napi_dev);
 
-	netif_napi_add(&sdma->napi_dev, &sdma->rx_napi, prestera_sdma_rx_poll, 64);
+	netif_napi_add(&sdma->napi_dev, &sdma->rx_napi, prestera_sdma_rx_poll);
 	napi_enable(&sdma->rx_napi);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index bcc4aa59d10a..1b43704baceb 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3832,7 +3832,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 		dev->features |= NETIF_F_HIGHDMA;
 
 	skge = netdev_priv(dev);
-	netif_napi_add(dev, &skge->napi, skge_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &skge->napi, skge_poll);
 	skge->netdev = dev;
 	skge->hw = hw;
 	skge->msg_enable = netif_msg_init(debug, default_msg);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e19acfcd84d4..ab33ba1c3023 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4937,7 +4937,7 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netif_napi_add(dev, &hw->napi, sky2_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &hw->napi, sky2_poll);
 
 	err = register_netdev(dev);
 	if (err) {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 49b7e8c1f4bd..4fba7cb0144b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4166,10 +4166,8 @@ static int mtk_probe(struct platform_device *pdev)
 	 * for NAPI to work
 	 */
 	init_dummy_netdev(&eth->dummy_dev);
-	netif_napi_add(&eth->dummy_dev, &eth->tx_napi, mtk_napi_tx,
-		       NAPI_POLL_WEIGHT);
-	netif_napi_add(&eth->dummy_dev, &eth->rx_napi, mtk_napi_rx,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(&eth->dummy_dev, &eth->tx_napi, mtk_napi_tx);
+	netif_napi_add(&eth->dummy_dev, &eth->rx_napi, mtk_napi_rx);
 
 	platform_set_drvdata(pdev, eth);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index f8db176c71ae..7e890f81148e 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1651,8 +1651,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &mtk_star_netdev_ops;
 	ndev->ethtool_ops = &mtk_star_ethtool_ops;
 
-	netif_napi_add(ndev, &priv->rx_napi, mtk_star_rx_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->rx_napi, mtk_star_rx_poll);
 	netif_napi_add_tx(ndev, &priv->tx_napi, mtk_star_tx_poll);
 
 	return devm_register_netdev(dev, ndev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index 6affbd241264..1184ac5751e1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -152,7 +152,7 @@ int mlx4_en_activate_cq(struct mlx4_en_priv *priv, struct mlx4_en_cq *cq,
 		break;
 	case RX:
 		cq->mcq.comp = mlx4_en_rx_irq;
-		netif_napi_add(cq->dev, &cq->napi, mlx4_en_poll_rx_cq, 64);
+		netif_napi_add(cq->dev, &cq->napi, mlx4_en_poll_rx_cq);
 		napi_enable(&cq->napi);
 		break;
 	case TX_XDP:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 6fefce30d296..8469e9c38670 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -725,7 +725,7 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (err)
 		goto err_free;
 
-	netif_napi_add(netdev, &c->napi, mlx5e_ptp_napi_poll, 64);
+	netif_napi_add(netdev, &c->napi, mlx5e_ptp_napi_poll);
 
 	mlx5e_ptp_build_params(c, cparams, params);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 46c2e5f9c05c..201ac7dd338f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -147,7 +147,7 @@ static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
 	t->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey);
 	t->stats    = &priv->trap_stats.ch;
 
-	netif_napi_add(netdev, &t->napi, mlx5e_trap_napi_poll, 64);
+	netif_napi_add(netdev, &t->napi, mlx5e_trap_napi_poll);
 
 	err = mlx5e_open_trap_rq(priv, t);
 	if (unlikely(err))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4503de92ac80..099a69d0ee4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2281,7 +2281,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->aff_mask = irq_get_effective_affinity_mask(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
 
-	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
+	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll);
 
 	err = mlx5e_open_queues(c, params, cparam);
 	if (unlikely(err))
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index b03e1c66bac0..2292d63a279c 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -156,7 +156,7 @@ static int mlxbf_gige_open(struct net_device *netdev)
 
 	phy_start(phydev);
 
-	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll);
 	napi_enable(&priv->napi);
 	netif_start_queue(netdev);
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 2599dfffd1da..50eeecba1f18 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2875,9 +2875,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
 	if (ret)
 		goto return_error;
 
-	netif_napi_add(adapter->netdev,
-		       &rx->napi, lan743x_rx_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(adapter->netdev, &rx->napi, lan743x_rx_napi_poll);
 
 	lan743x_csr_write(adapter, DMAC_CMD,
 			  DMAC_CMD_RX_SWR_(rx->channel_number));
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 51f8a0816377..7e4061c854f0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -787,8 +787,7 @@ void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev)
 		return;
 
 	lan966x->fdma_ndev = dev;
-	netif_napi_add(dev, &lan966x->napi, lan966x_fdma_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &lan966x->napi, lan966x_fdma_napi_poll);
 	napi_enable(&lan966x->napi);
 }
 
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 518b664a6908..650a5a166070 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -869,7 +869,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	np = netdev_priv(dev);
 	np->ioaddr = ioaddr;
 
-	netif_napi_add(dev, &np->napi, natsemi_poll, 64);
+	netif_napi_add(dev, &np->napi, natsemi_poll);
 	np->dev = dev;
 
 	np->pci_dev = pdev;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index d8a77b0db50d..804354e932d7 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7905,10 +7905,10 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 		for (i = 0; i < config->rx_ring_num ; i++) {
 			struct ring_info *ring = &mac_control->rings[i];
 
-			netif_napi_add(dev, &ring->napi, s2io_poll_msix, 64);
+			netif_napi_add(dev, &ring->napi, s2io_poll_msix);
 		}
 	} else {
-		netif_napi_add(dev, &sp->napi, s2io_poll_inta, 64);
+		netif_napi_add(dev, &sp->napi, s2io_poll_inta);
 	}
 
 	/* Not needed for Herc */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 469c3939c306..df1c61258da5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -771,9 +771,7 @@ nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec, int idx)
 {
 	if (dp->netdev)
 		netif_napi_add(dp->netdev, &r_vec->napi,
-			       nfp_net_has_xsk_pool_slow(dp, idx) ?
-			       dp->ops->xsk_poll : dp->ops->poll,
-			       NAPI_POLL_WEIGHT);
+		               nfp_net_has_xsk_pool_slow(dp, idx) ? dp->ops->xsk_poll : dp->ops->poll);
 	else
 		tasklet_enable(&r_vec->tasklet);
 }
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index cf2929fa525e..3db4a2431741 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1294,7 +1294,7 @@ static int nixge_probe(struct platform_device *pdev)
 	priv->ndev = ndev;
 	priv->dev = &pdev->dev;
 
-	netif_napi_add(ndev, &priv->napi, nixge_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, nixge_poll);
 	err = nixge_of_get_resources(pdev);
 	if (err)
 		goto free_netdev;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 7c0675ca337b..daa028729d44 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5876,7 +5876,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	else
 		dev->netdev_ops = &nv_netdev_ops_optimized;
 
-	netif_napi_add(dev, &np->napi, nv_napi_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &np->napi, nv_napi_poll);
 	dev->ethtool_ops = &ops;
 	dev->watchdog_timeo = NV_WATCHDOG_TIMEO;
 
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 46da937ad27f..3f2c30184752 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2516,8 +2516,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 
 	netdev->netdev_ops = &pch_gbe_netdev_ops;
 	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
-	netif_napi_add(netdev, &adapter->napi,
-		       pch_gbe_napi_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &adapter->napi, pch_gbe_napi_poll);
 	netdev->hw_features = NETIF_F_RXCSUM |
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	netdev->features = netdev->hw_features;
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index f0ace3a0e85c..aaab590ef548 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1697,7 +1697,7 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mac->pdev = pdev;
 	mac->netdev = dev;
 
-	netif_napi_add(dev, &mac->napi, pasemi_mac_poll, 64);
+	netif_napi_add(dev, &mac->napi, pasemi_mac_poll);
 
 	dev->features = NETIF_F_IP_CSUM | NETIF_F_LLTX | NETIF_F_SG |
 			NETIF_F_HIGHDMA | NETIF_F_GSO;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0be79c516781..5d58fd99be3c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -774,8 +774,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
-		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi);
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -830,11 +829,9 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
 
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
-		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi);
 	else
-		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi);
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -3165,8 +3162,7 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	dev_dbg(dev, "adminq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "adminq->hw_index %d\n", q->hw_index);
 
-	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi);
 
 	napi_enable(&qcq->napi);
 
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 4e6f00af17d9..de8d54b23f73 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -173,8 +173,7 @@ netxen_napi_add(struct netxen_adapter *adapter, struct net_device *netdev)
 
 	for (ring = 0; ring < adapter->max_sds_rings; ring++) {
 		sds_ring = &recv_ctx->sds_rings[ring];
-		netif_napi_add(netdev, &sds_ring->napi,
-				netxen_nic_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(netdev, &sds_ring->napi, netxen_nic_poll);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 3c1bfff29157..953f304b8588 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1904,8 +1904,7 @@ static void qede_napi_add_enable(struct qede_dev *edev)
 
 	/* Add NAPI objects */
 	for_each_queue(i) {
-		netif_napi_add(edev->ndev, &edev->fp_array[i].napi,
-			       qede_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(edev->ndev, &edev->fp_array[i].napi, qede_poll);
 		napi_enable(&edev->fp_array[i].napi);
 	}
 }
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 31e3ab149727..76072f8c3d2f 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3813,7 +3813,7 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 	ndev->ethtool_ops = &ql3xxx_ethtool_ops;
 	ndev->watchdog_timeo = 5 * HZ;
 
-	netif_napi_add(ndev, &qdev->napi, ql_poll, 64);
+	netif_napi_add(ndev, &qdev->napi, ql_poll);
 
 	ndev->irq = pdev->irq;
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 9da5e97f8a0a..92930a055cbc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1586,17 +1586,15 @@ int qlcnic_82xx_napi_add(struct qlcnic_adapter *adapter,
 		sds_ring = &recv_ctx->sds_rings[ring];
 		if (qlcnic_check_multi_tx(adapter) &&
 		    !adapter->ahw->diag_test) {
-			netif_napi_add(netdev, &sds_ring->napi, qlcnic_rx_poll,
-				       NAPI_POLL_WEIGHT);
+			netif_napi_add(netdev, &sds_ring->napi,
+				       qlcnic_rx_poll);
 		} else {
 			if (ring == (adapter->drv_sds_rings - 1))
 				netif_napi_add(netdev, &sds_ring->napi,
-					       qlcnic_poll,
-					       NAPI_POLL_WEIGHT);
+					       qlcnic_poll);
 			else
 				netif_napi_add(netdev, &sds_ring->napi,
-					       qlcnic_rx_poll,
-					       NAPI_POLL_WEIGHT);
+					       qlcnic_rx_poll);
 		}
 	}
 
@@ -2115,17 +2113,14 @@ int qlcnic_83xx_napi_add(struct qlcnic_adapter *adapter,
 		if (adapter->flags & QLCNIC_MSIX_ENABLED) {
 			if (!(adapter->flags & QLCNIC_TX_INTR_SHARED))
 				netif_napi_add(netdev, &sds_ring->napi,
-					       qlcnic_83xx_rx_poll,
-					       NAPI_POLL_WEIGHT);
+					       qlcnic_83xx_rx_poll);
 			else
 				netif_napi_add(netdev, &sds_ring->napi,
-					       qlcnic_83xx_msix_sriov_vf_poll,
-					       NAPI_POLL_WEIGHT);
+					       qlcnic_83xx_msix_sriov_vf_poll);
 
 		} else {
 			netif_napi_add(netdev, &sds_ring->napi,
-				       qlcnic_83xx_poll,
-				       NAPI_POLL_WEIGHT);
+				       qlcnic_83xx_poll);
 		}
 	}
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index a55c52696d49..3115b2c12898 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -684,8 +684,7 @@ static int emac_probe(struct platform_device *pdev)
 	/* Initialize queues */
 	emac_mac_rx_tx_ring_init_all(pdev, adpt);
 
-	netif_napi_add(netdev, &adpt->rx_q.napi, emac_napi_rtx,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &adpt->rx_q.napi, emac_napi_rtx);
 
 	ret = register_netdev(netdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 1aac2c3e5e0d..eecd52ed1ed2 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1127,7 +1127,7 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &netdev_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	netif_napi_add(dev, &lp->napi, r6040_poll, 64);
+	netif_napi_add(dev, &lp->napi, r6040_poll);
 
 	lp->mii_bus = mdiobus_alloc();
 	if (!lp->mii_bus) {
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index ab424b5b4920..469e2e229c6e 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -1002,7 +1002,7 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	dev->netdev_ops = &rtl8139_netdev_ops;
 	dev->ethtool_ops = &rtl8139_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
-	netif_napi_add(dev, &tp->napi, rtl8139_poll, 64);
+	netif_napi_add(dev, &tp->napi, rtl8139_poll);
 
 	/* note: the hardware is not capable of sg/csum/highdma, however
 	 * through the use of skb_copy_and_csum_dev we enable these
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9c21894d0518..3ec6d1319a8a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5240,7 +5240,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
 
-	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &tp->napi, rtl8169_poll);
 
 	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
 			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c992bf1c711e..36324126db6d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2841,9 +2841,9 @@ static int ravb_probe(struct platform_device *pdev)
 		goto out_dma_free;
 	}
 
-	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
+	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll);
 	if (info->nc_queues)
-		netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
+		netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll);
 
 	/* Network device register */
 	error = register_netdev(ndev);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 7fd8828d3a84..71a499113308 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3368,7 +3368,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 		goto out_release;
 	}
 
-	netif_napi_add(ndev, &mdp->napi, sh_eth_poll, 64);
+	netif_napi_add(ndev, &mdp->napi, sh_eth_poll);
 
 	/* network device register */
 	ret = register_netdev(ndev);
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 9e7b62750bb0..023682cd2768 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2574,8 +2574,7 @@ static int rocker_probe_port(struct rocker *rocker, unsigned int port_number)
 	dev->netdev_ops = &rocker_port_netdev_ops;
 	dev->ethtool_ops = &rocker_port_ethtool_ops;
 	netif_napi_add_tx(dev, &rocker_port->napi_tx, rocker_port_poll_tx);
-	netif_napi_add(dev, &rocker_port->napi_rx, rocker_port_poll_rx,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &rocker_port->napi_rx, rocker_port_poll_rx);
 	rocker_carrier_init(rocker_port);
 
 	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_SG;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index a1c10b61269b..9664f029fa16 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2143,7 +2143,7 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 		pr_info("Enable RX Mitigation via HW Watchdog Timer\n");
 	}
 
-	netif_napi_add(ndev, &priv->napi, sxgbe_poll, 64);
+	netif_napi_add(ndev, &priv->napi, sxgbe_poll);
 
 	spin_lock_init(&priv->stats_lock);
 
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 73ae4656a6e7..91d1a0d4bc6b 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -42,8 +42,7 @@ static int efx_ef100_rep_open(struct net_device *net_dev)
 {
 	struct efx_rep *efv = netdev_priv(net_dev);
 
-	netif_napi_add(net_dev, &efv->napi, efx_ef100_rep_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(net_dev, &efv->napi, efx_ef100_rep_poll);
 	napi_enable(&efv->napi);
 	return 0;
 }
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 5b4d661ab986..aaa381743bca 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1313,7 +1313,7 @@ void efx_init_napi_channel(struct efx_channel *channel)
 	struct efx_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add(channel->napi_dev, &channel->napi_str, efx_poll, 64);
+	netif_napi_add(channel->napi_dev, &channel->napi_str, efx_poll);
 }
 
 void efx_init_napi(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f18418e07eb8..e151b0957751 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2012,7 +2012,7 @@ static void ef4_init_napi_channel(struct ef4_channel *channel)
 	struct ef4_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add(channel->napi_dev, &channel->napi_str, ef4_poll, 64);
+	netif_napi_add(channel->napi_dev, &channel->napi_str, ef4_poll);
 }
 
 static void ef4_init_napi(struct ef4_nic *efx)
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index f54ebd007286..06ed74994e36 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -1317,7 +1317,7 @@ static void efx_init_napi_channel(struct efx_channel *channel)
 	struct efx_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add(channel->napi_dev, &channel->napi_str, efx_poll, 64);
+	netif_napi_add(channel->napi_dev, &channel->napi_str, efx_poll);
 }
 
 void efx_siena_init_napi(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 83fe53401453..013e90d69182 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -482,7 +482,7 @@ static int epic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops = &epic_netdev_ops;
 	dev->ethtool_ops = &netdev_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
-	netif_napi_add(dev, &ep->napi, epic_poll, 64);
+	netif_napi_add(dev, &ep->napi, epic_poll);
 
 	ret = register_netdev(dev);
 	if (ret < 0)
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 229180aa86de..71fbb358bb7d 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -1585,7 +1585,7 @@ smsc9420_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->netdev_ops = &smsc9420_netdev_ops;
 	dev->ethtool_ops = &smsc9420_ethtool_ops;
 
-	netif_napi_add(dev, &pd->napi, smsc9420_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &pd->napi, smsc9420_rx_poll);
 
 	result = register_netdev(dev);
 	if (result) {
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 85e62f5489b6..2240f6d0b89b 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2093,7 +2093,7 @@ static int netsec_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "hardware revision %d.%d\n",
 		 hw_ver >> 16, hw_ver & 0xffff);
 
-	netif_napi_add(ndev, &priv->napi, netsec_napi_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, netsec_napi_poll);
 
 	ndev->netdev_ops = &netsec_netdev_ops;
 	ndev->ethtool_ops = &netsec_ethtool_ops;
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index ee341a383e69..1fa09b49ba7f 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1687,8 +1687,7 @@ static int ave_probe(struct platform_device *pdev)
 		 pdev->name, pdev->id);
 
 	/* Register as a NAPI supported driver */
-	netif_napi_add(ndev, &priv->napi_rx, ave_napi_poll_rx,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi_rx, ave_napi_poll_rx);
 	netif_napi_add_tx(ndev, &priv->napi_tx, ave_napi_poll_tx);
 
 	platform_set_drvdata(pdev, ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8418e795cc21..5ec3d4537bae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6874,8 +6874,7 @@ static void stmmac_napi_add(struct net_device *dev)
 		spin_lock_init(&ch->lock);
 
 		if (queue < priv->plat->rx_queues_to_use) {
-			netif_napi_add(dev, &ch->rx_napi, stmmac_napi_poll_rx,
-				       NAPI_POLL_WEIGHT);
+			netif_napi_add(dev, &ch->rx_napi, stmmac_napi_poll_rx);
 		}
 		if (queue < priv->plat->tx_queues_to_use) {
 			netif_napi_add_tx(dev, &ch->tx_napi,
@@ -6884,8 +6883,7 @@ static void stmmac_napi_add(struct net_device *dev)
 		if (queue < priv->plat->rx_queues_to_use &&
 		    queue < priv->plat->tx_queues_to_use) {
 			netif_napi_add(dev, &ch->rxtx_napi,
-				       stmmac_napi_poll_rxtx,
-				       NAPI_POLL_WEIGHT);
+				       stmmac_napi_poll_rxtx);
 		}
 	}
 }
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 19a3eb6efc3a..0aca193d9550 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5050,7 +5050,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->watchdog_timeo = CAS_TX_TIMEOUT;
 
 #ifdef USE_NAPI
-	netif_napi_add(dev, &cp->napi, cas_poll, 64);
+	netif_napi_add(dev, &cp->napi, cas_poll);
 #endif
 	dev->irq = pdev->irq;
 	dev->dma = 0;
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index bc51a75a0e19..8addee6d04bd 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -354,8 +354,7 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	dev_set_drvdata(&vdev->dev, port);
 
-	netif_napi_add(dev, &port->napi, sunvnet_poll_common,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &port->napi, sunvnet_poll_common);
 
 	spin_lock_irqsave(&vp->lock, flags);
 	list_add_rcu(&port->list, &vp->port_list);
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 204a29e72292..e6144d963eaa 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9115,7 +9115,7 @@ static int niu_ldg_init(struct niu *np)
 	for (i = 0; i < np->num_ldg; i++) {
 		struct niu_ldg *lp = &np->ldg[i];
 
-		netif_napi_add(np->dev, &lp->napi, niu_poll, 64);
+		netif_napi_add(np->dev, &lp->napi, niu_poll);
 
 		lp->np = np;
 		lp->ldg_num = ldg_num_map[i];
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 6fb89c55f957..4154e68639ac 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2980,7 +2980,7 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_free_consistent;
 
 	dev->netdev_ops = &gem_netdev_ops;
-	netif_napi_add(dev, &gp->napi, gem_poll, 64);
+	netif_napi_add(dev, &gp->napi, gem_poll);
 	dev->ethtool_ops = &gem_ethtool_ops;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->dma = 0;
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 042b50227850..acda6cbd0238 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -467,8 +467,7 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if (err)
 		goto err_out_free_port;
 
-	netif_napi_add(port->vp->dev, &port->napi, sunvnet_poll_common,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(port->vp->dev, &port->napi, sunvnet_poll_common);
 
 	INIT_HLIST_NODE(&port->hash);
 	INIT_LIST_HEAD(&port->list);
diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 38e478aa415c..b89d72242002 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -493,7 +493,7 @@ static int spl2sw_probe(struct platform_device *pdev)
 	}
 
 	/* Add and enable napi. */
-	netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll);
 	napi_enable(&comm->rx_napi);
 	netif_napi_add_tx(ndev, &comm->tx_napi, spl2sw_tx_poll);
 	napi_enable(&comm->tx_napi);
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index e54ce73396ee..36b948820c1e 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -419,15 +419,14 @@ static void xlgmac_napi_enable(struct xlgmac_pdata *pdata, unsigned int add)
 		for (i = 0; i < pdata->channel_count; i++, channel++) {
 			if (add)
 				netif_napi_add(pdata->netdev, &channel->napi,
-					       xlgmac_one_poll,
-					       NAPI_POLL_WEIGHT);
+					       xlgmac_one_poll);
 
 			napi_enable(&channel->napi);
 		}
 	} else {
 		if (add)
 			netif_napi_add(pdata->netdev, &pdata->napi,
-				       xlgmac_all_poll, NAPI_POLL_WEIGHT);
+				       xlgmac_all_poll);
 
 		napi_enable(&pdata->napi);
 	}
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 08ba658db987..ca409515ead5 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1994,7 +1994,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		priv->nic = nic;
 		priv->msg_enable = BDX_DEF_MSG_ENABLE;
 
-		netif_napi_add(ndev, &priv->napi, bdx_poll, 64);
+		netif_napi_add(ndev, &priv->napi, bdx_poll);
 
 		if ((readl(nic->regs + FPGA_VER) & 0xFFF) == 308) {
 			DBG("HW statistics not supported\n");
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4f8f3dda7764..3cbe4ec46234 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2044,7 +2044,7 @@ static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
 	}
 
 	netif_napi_add(common->dma_ndev, &common->napi_rx,
-		       am65_cpsw_nuss_rx_poll, NAPI_POLL_WEIGHT);
+		       am65_cpsw_nuss_rx_poll);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index ce92d335927e..a16be21e3823 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -1109,7 +1109,7 @@ static int cpmac_probe(struct platform_device *pdev)
 	dev->netdev_ops = &cpmac_netdev_ops;
 	dev->ethtool_ops = &cpmac_ethtool_ops;
 
-	netif_napi_add(dev, &priv->napi, cpmac_poll, 64);
+	netif_napi_add(dev, &priv->napi, cpmac_poll);
 
 	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->rx_lock);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 99be1228a4e0..709ca6dd6ecb 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1637,8 +1637,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
 	netif_napi_add(ndev, &cpsw->napi_rx,
-		       cpsw->quirk_irq ? cpsw_rx_poll : cpsw_rx_mq_poll,
-		       NAPI_POLL_WEIGHT);
+		       cpsw->quirk_irq ? cpsw_rx_poll : cpsw_rx_mq_poll);
 	netif_napi_add_tx(ndev, &cpsw->napi_tx,
 			  cpsw->quirk_irq ? cpsw_tx_poll : cpsw_tx_mq_poll);
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 14fd90da32fd..83596ec0c7cb 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1416,9 +1416,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 			 * accordingly.
 			 */
 			netif_napi_add(ndev, &cpsw->napi_rx,
-				       cpsw->quirk_irq ?
-				       cpsw_rx_poll : cpsw_rx_mq_poll,
-				       NAPI_POLL_WEIGHT);
+				       cpsw->quirk_irq ? cpsw_rx_poll : cpsw_rx_mq_poll);
 			netif_napi_add_tx(ndev, &cpsw->napi_tx,
 					  cpsw->quirk_irq ?
 					  cpsw_tx_poll : cpsw_tx_mq_poll);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index d45b118b732e..2eb9d5a32588 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1948,7 +1948,7 @@ static int davinci_emac_probe(struct platform_device *pdev)
 
 	ndev->netdev_ops = &emac_netdev_ops;
 	ndev->ethtool_ops = &ethtool_ops;
-	netif_napi_add(ndev, &priv->napi, emac_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &priv->napi, emac_poll);
 
 	pm_runtime_enable(&pdev->dev);
 	rc = pm_runtime_resume_and_get(&pdev->dev);
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b15d44261e76..aba70bef4894 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2095,7 +2095,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	}
 
 	/* NAPI register */
-	netif_napi_add(ndev, &netcp->rx_napi, netcp_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &netcp->rx_napi, netcp_rx_poll);
 	netif_napi_add_tx(ndev, &netcp->tx_napi, netcp_tx_poll);
 
 	/* Register the network device */
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 6e838e8f79d0..cf8de8a7a8a1 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1441,7 +1441,7 @@ static void gelic_ether_setup_netdev_ops(struct net_device *netdev,
 {
 	netdev->watchdog_timeo = GELIC_NET_WATCHDOG_TIMEOUT;
 	/* NAPI */
-	netif_napi_add(netdev, napi, gelic_net_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, napi, gelic_net_poll);
 	netdev->ethtool_ops = &gelic_ether_ethtool_ops;
 	netdev->netdev_ops = &gelic_netdevice_ops;
 }
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index bc4914c758ad..50d7eacfec58 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2270,8 +2270,7 @@ spider_net_setup_netdev(struct spider_net_card *card)
 	card->aneg_count = 0;
 	timer_setup(&card->aneg_timer, spider_net_link_phy, 0);
 
-	netif_napi_add(netdev, &card->napi,
-		       spider_net_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &card->napi, spider_net_poll);
 
 	spider_net_setup_netdev_ops(netdev);
 
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index c0b26b5cefe4..2cd2afc3fff0 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1585,7 +1585,7 @@ tsi108_init_one(struct platform_device *pdev)
 	data->phy_type = einfo->phy_type;
 	data->irq_num = einfo->irq_num;
 	data->id = pdev->id;
-	netif_napi_add(dev, &data->napi, tsi108_poll, 64);
+	netif_napi_add(dev, &data->napi, tsi108_poll);
 	dev->netdev_ops = &tsi108_netdev_ops;
 	dev->ethtool_ops = &tsi108_ethtool_ops;
 
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 29cde0bec4b1..0fb15a17b547 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -965,7 +965,7 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	dev->ethtool_ops = &netdev_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	netif_napi_add(dev, &rp->napi, rhine_napipoll, 64);
+	netif_napi_add(dev, &rp->napi, rhine_napipoll);
 
 	if (rp->quirks & rqRhineI)
 		dev->features |= NETIF_F_SG|NETIF_F_HW_CSUM;
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 5d710ebb9680..a502812ac418 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2846,7 +2846,7 @@ static int velocity_probe(struct device *dev, int irq,
 
 	netdev->netdev_ops = &velocity_netdev_ops;
 	netdev->ethtool_ops = &velocity_ethtool_ops;
-	netif_napi_add(netdev, &vptr->napi, velocity_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &vptr->napi, velocity_poll);
 
 	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			   NETIF_F_HW_VLAN_CTAG_TX;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 40581f40716a..d1d772580da9 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1879,8 +1879,8 @@ static int axienet_probe(struct platform_device *pdev)
 	u64_stats_init(&lp->rx_stat_sync);
 	u64_stats_init(&lp->tx_stat_sync);
 
-	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
-	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
+	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
 
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 2e2fac0e84da..1eff202f6a1f 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1057,7 +1057,7 @@ static int fjes_sw_init(struct fjes_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	netif_napi_add(netdev, &adapter->napi, fjes_poll, 64);
+	netif_napi_add(netdev, &adapter->napi, fjes_poll);
 
 	return 0;
 }
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 6e42cb03e226..f066de0da492 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1779,8 +1779,7 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	}
 
 	/* Enable NAPI handler before init callbacks */
-	netif_napi_add(ndev, &net_device->chan_table[0].napi,
-		       netvsc_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &net_device->chan_table[0].napi, netvsc_poll);
 
 	/* Open the channel */
 	device->channel->next_request_id_callback = vmbus_next_request_id;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 6da36cb8af80..11f767a20444 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1575,7 +1575,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 
 	for (i = 1; i < net_device->num_chn; i++)
 		netif_napi_add(net, &net_device->chan_table[i].napi,
-			       netvsc_poll, NAPI_POLL_WEIGHT);
+			       netvsc_poll);
 
 	return net_device;
 
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 3f97653450bb..f8036ee78647 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1607,7 +1607,7 @@ static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
 				  gsi_channel_poll);
 	else
 		netif_napi_add(&gsi->dummy_dev, &channel->napi,
-			       gsi_channel_poll, NAPI_POLL_WEIGHT);
+			       gsi_channel_poll);
 
 	return 0;
 
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index c058eabd7b36..83fcaeb2ac5e 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1282,7 +1282,7 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	dev->features = dev->hw_features | NETIF_F_HIGHDMA;
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
-	netif_napi_add(dev, &net->napi, tbnet_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(dev, &net->napi, tbnet_poll);
 
 	/* MTU range: 68 - 65522 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3226ab33afae..f18ab8e220db 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4374,7 +4374,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	netif_set_tso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
-	netif_napi_add(netdev, &dev->napi, lan78xx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &dev->napi, lan78xx_poll);
 
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 550c85a366a0..09682ea3354e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1070,7 +1070,7 @@ static int veth_enable_xdp_range(struct net_device *dev, int start, int end,
 		struct veth_rq *rq = &priv->rq[i];
 
 		if (!napi_already_on)
-			netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
+			netif_napi_add(dev, &rq->xdp_napi, veth_poll);
 		err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i, rq->xdp_napi.napi_id);
 		if (err < 0)
 			goto err_rxq_reg;
@@ -1184,7 +1184,7 @@ static int veth_napi_enable_range(struct net_device *dev, int start, int end)
 	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
-		netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &rq->xdp_napi, veth_poll);
 	}
 
 	err = __veth_napi_enable_range(dev, start, end);
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 53b3b241e027..d3e7b27eb933 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3882,11 +3882,11 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		for (i = 0; i < adapter->num_rx_queues; i++) {
 			netif_napi_add(adapter->netdev,
 				       &adapter->rx_queue[i].napi,
-				       vmxnet3_poll_rx_only, 64);
+				       vmxnet3_poll_rx_only);
 		}
 	} else {
 		netif_napi_add(adapter->netdev, &adapter->rx_queue[0].napi,
-			       vmxnet3_poll, 64);
+			       vmxnet3_poll);
 	}
 
 	netif_set_real_num_tx_queues(adapter->netdev, adapter->num_tx_queues);
diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index 1acd00ab2fbc..1cb502a932e0 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -54,8 +54,7 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 	skb_queue_head_init(&peer->staged_packet_queue);
 	wg_noise_reset_last_sent_handshake(&peer->last_sent_handshake);
 	set_bit(NAPI_STATE_NO_BUSY_POLL, &peer->napi.state);
-	netif_napi_add(wg->dev, &peer->napi, wg_packet_rx_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(wg->dev, &peer->napi, wg_packet_rx_poll);
 	napi_enable(&peer->napi);
 	list_add_tail(&peer->peer_list, &wg->peer_list);
 	INIT_LIST_HEAD(&peer->allowedips_list);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bf1c938be7d0..a77cb79a7a54 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3215,8 +3215,7 @@ static void ath10k_pci_free_irq(struct ath10k *ar)
 
 void ath10k_pci_init_napi(struct ath10k *ar)
 {
-	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_pci_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_pci_napi_poll);
 }
 
 static int ath10k_pci_init_irq(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 24283c02a5ef..e0e98f9f127e 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2531,8 +2531,7 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 		return -ENOMEM;
 	}
 
-	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_sdio_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_sdio_napi_poll);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "sdio new func %d vendor 0x%x device 0x%x block 0x%x/0x%x\n",
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 5576ad9fd116..cfcb759a87de 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1242,8 +1242,7 @@ static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 
 static void ath10k_snoc_init_napi(struct ath10k *ar)
 {
-	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_snoc_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_snoc_napi_poll);
 }
 
 static int ath10k_snoc_request_irq(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index ad6471b21796..b0067af685b1 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1014,8 +1014,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 		return -ENOMEM;
 	}
 
-	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_usb_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_usb_napi_poll);
 
 	usb_get_dev(dev);
 	vendor_id = le16_to_cpu(dev->descriptor.idVendor);
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index c47414710138..1be4a25947a3 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -541,7 +541,7 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 		irq_grp->grp_id = i;
 		init_dummy_netdev(&irq_grp->napi_ndev);
 		netif_napi_add(&irq_grp->napi_ndev, &irq_grp->napi,
-			       ath11k_ahb_ext_grp_napi_poll, NAPI_POLL_WEIGHT);
+			       ath11k_ahb_ext_grp_napi_poll);
 
 		for (j = 0; j < ATH11K_EXT_IRQ_NUM_MAX; j++) {
 			if (ab->hw_params.ring_mask->tx[i] & BIT(j)) {
diff --git a/drivers/net/wireless/ath/ath11k/pcic.c b/drivers/net/wireless/ath/ath11k/pcic.c
index 1adf20ebef27..825cd884e6cd 100644
--- a/drivers/net/wireless/ath/ath11k/pcic.c
+++ b/drivers/net/wireless/ath/ath11k/pcic.c
@@ -517,7 +517,7 @@ static int ath11k_pcic_ext_irq_config(struct ath11k_base *ab)
 		irq_grp->grp_id = i;
 		init_dummy_netdev(&irq_grp->napi_ndev);
 		netif_napi_add(&irq_grp->napi_ndev, &irq_grp->napi,
-			       ath11k_pcic_ext_grp_napi_poll, NAPI_POLL_WEIGHT);
+			       ath11k_pcic_ext_grp_napi_poll);
 
 		if (ab->hw_params.ring_mask->tx[i] ||
 		    ab->hw_params.ring_mask->rx[i] ||
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index e76b38ad1d44..ee7d7e9c2718 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -456,14 +456,12 @@ int wil_if_add(struct wil6210_priv *wil)
 	init_dummy_netdev(&wil->napi_ndev);
 	if (wil->use_enhanced_dma_hw) {
 		netif_napi_add(&wil->napi_ndev, &wil->napi_rx,
-			       wil6210_netdev_poll_rx_edma,
-			       NAPI_POLL_WEIGHT);
+			       wil6210_netdev_poll_rx_edma);
 		netif_napi_add_tx(&wil->napi_ndev,
 				  &wil->napi_tx, wil6210_netdev_poll_tx_edma);
 	} else {
 		netif_napi_add(&wil->napi_ndev, &wil->napi_rx,
-			       wil6210_netdev_poll_rx,
-			       NAPI_POLL_WEIGHT);
+			       wil6210_netdev_poll_rx);
 		netif_napi_add_tx(&wil->napi_ndev,
 				  &wil->napi_tx, wil6210_netdev_poll_tx);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 68a4572cee53..9c9f87fe8377 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1110,7 +1110,7 @@ static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 				poll = iwl_pcie_napi_poll_msix;
 
 			netif_napi_add(&trans_pcie->napi_dev, &rxq->napi,
-				       poll, NAPI_POLL_WEIGHT);
+				       poll);
 			napi_enable(&rxq->napi);
 		}
 
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 40cb91097b2e..4901aa02b4fb 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -758,7 +758,7 @@ mt76_dma_init(struct mt76_dev *dev,
 	dev->napi_dev.threaded = 1;
 
 	mt76_for_each_q_rx(dev, i) {
-		netif_napi_add(&dev->napi_dev, &dev->napi[i], poll, 64);
+		netif_napi_add(&dev->napi_dev, &dev->napi[i], poll);
 		mt76_dma_rx_fill(dev, &dev->q_rx[i]);
 		napi_enable(&dev->napi[i]);
 	}
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 7abb1e22b708..0975d27240e4 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1717,8 +1717,7 @@ static void rtw_pci_napi_init(struct rtw_dev *rtwdev)
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 
 	init_dummy_netdev(&rtwpci->netdev);
-	netif_napi_add(&rtwpci->netdev, &rtwpci->napi, rtw_pci_napi_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(&rtwpci->netdev, &rtwpci->napi, rtw_pci_napi_poll);
 }
 
 static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 71ee237a7c28..17133d97cd32 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1786,7 +1786,7 @@ void rtw89_core_napi_init(struct rtw89_dev *rtwdev)
 {
 	init_dummy_netdev(&rtwdev->netdev);
 	netif_napi_add(&rtwdev->netdev, &rtwdev->napi,
-		       rtwdev->hci.ops->napi_poll, NAPI_POLL_WEIGHT);
+		       rtwdev->hci.ops->napi_poll);
 }
 EXPORT_SYMBOL(rtw89_core_napi_init);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index fb32ae82d9b0..09238e2f5de8 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -723,8 +723,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 	init_waitqueue_head(&queue->dealloc_wq);
 	atomic_set(&queue->inflight_packets, 0);
 
-	netif_napi_add(queue->vif->dev, &queue->napi, xenvif_poll,
-			NAPI_POLL_WEIGHT);
+	netif_napi_add(queue->vif->dev, &queue->napi, xenvif_poll);
 
 	queue->stalled = true;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 2cb7e741e1a2..9af2b027c19c 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -2224,8 +2224,7 @@ static int xennet_create_queues(struct netfront_info *info,
 			return ret;
 		}
 
-		netif_napi_add(queue->info->netdev, &queue->napi,
-			       xennet_poll, 64);
+		netif_napi_add(queue->info->netdev, &queue->napi, xennet_poll);
 		if (netif_running(info->netdev))
 			napi_enable(&queue->napi);
 	}
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2d4436cbcb47..f673c6f0518c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1133,7 +1133,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 				       PAGE_SIZE * (QDIO_MAX_ELEMENTS_PER_BUFFER - 1));
 	}
 
-	netif_napi_add(card->dev, &card->napi, qeth_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(card->dev, &card->napi, qeth_poll);
 	return register_netdev(card->dev);
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8d44bce0477a..d8487a10cd55 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1910,7 +1910,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		netif_set_tso_max_size(card->dev,
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
-	netif_napi_add(card->dev, &card->napi, qeth_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(card->dev, &card->napi, qeth_poll);
 	return register_netdev(card->dev);
 }
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ca6b966f5dd3..1ead7793062a 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3041,8 +3041,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		/* Inbound completion handling rx_rings run in
 		 * separate NAPI contexts.
 		 */
-		netif_napi_add_weight(qdev->ndev, &rx_ring->napi,
-				      qlge_napi_poll_msix, 64);
+		netif_napi_add(qdev->ndev, &rx_ring->napi,
+			       qlge_napi_poll_msix);
 		cqicb->irq_delay = cpu_to_le16(qdev->rx_coalesce_usecs);
 		cqicb->pkt_delay = cpu_to_le16(qdev->rx_max_coalesced_frames);
 	} else {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f42fc871c3b..7a084a1c14e9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2553,16 +2553,15 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
  * @dev:  network device
  * @napi: NAPI context
  * @poll: polling function
- * @weight: default weight
  *
  * netif_napi_add() must be used to initialize a NAPI context prior to calling
  * *any* of the other NAPI-related functions.
  */
 static inline void
 netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-	       int (*poll)(struct napi_struct *, int), int weight)
+	       int (*poll)(struct napi_struct *, int))
 {
-	netif_napi_add_weight(dev, napi, poll, weight);
+	netif_napi_add_weight(dev, napi, poll, NAPI_POLL_WEIGHT);
 }
 
 static inline void
diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 21619c70a82b..ed5ec5de47f6 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -81,8 +81,7 @@ int gro_cells_init(struct gro_cells *gcells, struct net_device *dev)
 
 		set_bit(NAPI_STATE_NO_BUSY_POLL, &cell->napi.state);
 
-		netif_napi_add(dev, &cell->napi, gro_cell_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &cell->napi, gro_cell_poll);
 		napi_enable(&cell->napi);
 	}
 	return 0;
-- 
2.37.3

