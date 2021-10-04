Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32061421392
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 18:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhJDQH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 12:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhJDQHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 12:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD9061372;
        Mon,  4 Oct 2021 16:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633363536;
        bh=Y/XsuD5lPHQhKr6UrNsNLyJrh9iibmp/DtywjZj+Xdo=;
        h=From:To:Cc:Subject:Date:From;
        b=Zk8A5QCAXEkzSY2AzGmu+QYYOmycEkf97YrPMo1WX9oAj0KPVNXubQ5uugdDbAhnn
         y6e9azKA3saDdwUvY+XY4RRWUzQlJ0g4nk4wNP/D8sO966aFI6aYupGNV8MeB9rPfM
         8/sjnnKUJh+rVLXu0Hl/+uigog+aWAnxlD2IX8Y9oSoRwKyKBssvOlSWdRYuWIXuCz
         C3x9v9aFCuSRYgnS8NIuS+NICss8izezdPvZAe5qfe0d/ER6zDsXAjv7jsEbijYCqf
         BHp6WaAeOyk2Qc93l9JRhEOQNcaWx1AD9UcckPqkDrbOe4/Uf8/t6l+gIXyy91wac4
         InZkZUchRCx7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] ethernet: use eth_hw_addr_set() for dev->addr_len cases
Date:   Mon,  4 Oct 2021 09:05:21 -0700
Message-Id: <20211004160522.1974052-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert all Ethernet drivers from memcpy(... dev->addr_len)
to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, dev->addr_len)
  + eth_hw_addr_set(dev, np)

In theory addr_len may not be ETH_ALEN, but we don't expect
non-Ethernet devices to live under this directory, and only
the following cases of setting addr_len exist:
 - cxgb4 for mgmt device,
and the drivers which set it to ETH_ALEN: s2io, mlx4, vxge.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/8390/ne2k-pci.c                     | 2 +-
 drivers/net/ethernet/actions/owl-emac.c                  | 2 +-
 drivers/net/ethernet/aeroflex/greth.c                    | 2 +-
 drivers/net/ethernet/alteon/acenic.c                     | 2 +-
 drivers/net/ethernet/amd/amd8111e.c                      | 2 +-
 drivers/net/ethernet/amd/atarilance.c                    | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                 | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                | 2 +-
 drivers/net/ethernet/arc/emac_main.c                     | 2 +-
 drivers/net/ethernet/atheros/alx/main.c                  | 2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c          | 4 ++--
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c          | 4 ++--
 drivers/net/ethernet/atheros/atlx/atl1.c                 | 2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c                 | 4 ++--
 drivers/net/ethernet/atheros/atlx/atlx.c                 | 2 +-
 drivers/net/ethernet/broadcom/b44.c                      | 2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c               | 2 +-
 drivers/net/ethernet/broadcom/bnx2.c                     | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c          | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                | 2 +-
 drivers/net/ethernet/broadcom/tg3.c                      | 2 +-
 drivers/net/ethernet/calxeda/xgmac.c                     | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c          | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c       | 2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c         | 2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c          | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c          | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c      | 2 +-
 drivers/net/ethernet/cirrus/cs89x0.c                     | 2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c              | 2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c           | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c         | 4 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c      | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c          | 2 +-
 drivers/net/ethernet/freescale/fec_main.c                | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c             | 2 +-
 drivers/net/ethernet/freescale/ucc_geth.c                | 2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c              | 2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c            | 2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                | 2 +-
 drivers/net/ethernet/ibm/emac/core.c                     | 2 +-
 drivers/net/ethernet/intel/e100.c                        | 2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c            | 4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c               | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c                | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c                | 4 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c                | 8 +++-----
 drivers/net/ethernet/intel/igc/igc_main.c                | 4 ++--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c              | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c            | 4 ++--
 drivers/net/ethernet/jme.c                               | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           | 2 +-
 drivers/net/ethernet/micrel/ks8842.c                     | 5 ++---
 drivers/net/ethernet/microchip/encx24j600.c              | 2 +-
 drivers/net/ethernet/moxa/moxart_ether.c                 | 2 +-
 drivers/net/ethernet/neterion/s2io.c                     | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c           | 4 ++--
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c     | 4 ++--
 drivers/net/ethernet/pasemi/pasemi_mac.c                 | 2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c     | 2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                    | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c         | 2 +-
 drivers/net/ethernet/realtek/8139cp.c                    | 2 +-
 drivers/net/ethernet/realtek/8139too.c                   | 2 +-
 drivers/net/ethernet/rocker/rocker_main.c                | 2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                      | 2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                      | 2 +-
 drivers/net/ethernet/sun/niu.c                           | 2 +-
 drivers/net/ethernet/sun/sungem.c                        | 2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c        | 2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c           | 2 +-
 drivers/net/ethernet/tehuti/tehuti.c                     | 2 +-
 drivers/net/ethernet/ti/davinci_emac.c                   | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c            | 2 +-
 76 files changed, 90 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
index d6715008e04d..6a0a2039600a 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -390,7 +390,7 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 	dev->ethtool_ops = &ne2k_pci_ethtool_ops;
 	NS8390_init(dev, 0);
 
-	memcpy(dev->dev_addr, SA_prom, dev->addr_len);
+	eth_hw_addr_set(dev, SA_prom);
 
 	i = register_netdev(dev);
 	if (i)
diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index c4ecf4fcadf8..2c25ff3623cd 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -1173,7 +1173,7 @@ static int owl_emac_ndo_set_mac_addr(struct net_device *netdev, void *addr)
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	memcpy(netdev->dev_addr, skaddr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, skaddr->sa_data);
 	owl_emac_set_hw_mac_addr(netdev);
 
 	return owl_emac_setup_frame_xmit(netdev_priv(netdev));
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index c560ad06f0be..cc34eaf0491f 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1025,7 +1025,7 @@ static int greth_set_mac_add(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	GRETH_REGSAVE(regs->esa_msb, dev->dev_addr[0] << 8 | dev->dev_addr[1]);
 	GRETH_REGSAVE(regs->esa_lsb, dev->dev_addr[2] << 24 | dev->dev_addr[3] << 16 |
 		      dev->dev_addr[4] << 8 | dev->dev_addr[5]);
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 9dc12b13061f..7aaef593b031 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2718,7 +2718,7 @@ static int ace_set_mac_addr(struct net_device *dev, void *p)
 	if(netif_running(dev))
 		return -EBUSY;
 
-	memcpy(dev->dev_addr, addr->sa_data,dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	da = (u8 *)dev->dev_addr;
 
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 92e4246dc359..0b493467b042 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1500,7 +1500,7 @@ static int amd8111e_set_mac_address(struct net_device *dev, void *p)
 	int i;
 	struct sockaddr *addr = p;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	spin_lock_irq(&lp->lock);
 	/* Setting the MAC address to the device */
 	for (i = 0; i < ETH_ALEN; i++)
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 515e1f279da5..9c7d9690d00c 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -1123,7 +1123,7 @@ static int lance_set_mac_address( struct net_device *dev, void *addr )
 		return -EIO;
 	}
 
-	memcpy( dev->dev_addr, saddr->sa_data, dev->addr_len );
+	eth_hw_addr_set(dev, saddr->sa_data);
 	for( i = 0; i < 6; i++ )
 		MEM->init.hwaddr[i] = dev->dev_addr[i^1]; /* <- 16 bit swap! */
 	lp->memcpy_f( RIEBL_HWADDR_ADDR, dev->dev_addr, 6 );
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 17a585adfb49..b5bf5af8db5f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2016,7 +2016,7 @@ static int xgbe_set_mac_address(struct net_device *netdev, void *addr)
 	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, saddr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, saddr->sa_data);
 
 	hw_if->set_mac_address(pdata, netdev->dev_addr);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index a218dc6f2edd..0e8698928e4d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -267,7 +267,7 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 
 	netdev->irq = pdata->dev_irq;
 	netdev->base_addr = (unsigned long)pdata->xgmac_regs;
-	memcpy(netdev->dev_addr, pdata->mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, pdata->mac_addr);
 
 	/* Initialize ECC timestamps */
 	pdata->tx_sec_period = jiffies;
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 38c288ec9059..215b5144b885 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -773,7 +773,7 @@ static int arc_emac_set_address(struct net_device *ndev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, addr->sa_data);
 
 	arc_emac_set_address_internal(ndev);
 
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index cf5903ac792b..4ad3fc72e74e 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -607,7 +607,7 @@ static int alx_set_mac_address(struct net_device *netdev, void *data)
 	if (netdev->addr_assign_type & NET_ADDR_RANDOM)
 		netdev->addr_assign_type ^= NET_ADDR_RANDOM;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(hw->mac_addr, addr->sa_data, netdev->addr_len);
 	alx_set_macaddr(hw, hw->mac_addr);
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1c258e4ddc96..da595242bc13 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -482,7 +482,7 @@ static int atl1c_set_mac_addr(struct net_device *netdev, void *p)
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(adapter->hw.mac_addr, addr->sa_data, netdev->addr_len);
 
 	atl1c_hw_set_mac_addr(&adapter->hw, adapter->hw.mac_addr);
@@ -2767,7 +2767,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* got a random MAC address, set NET_ADDR_RANDOM to netdev */
 		netdev->addr_assign_type = NET_ADDR_RANDOM;
 	}
-	memcpy(netdev->dev_addr, adapter->hw.mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, adapter->hw.mac_addr);
 	if (netif_msg_probe(adapter))
 		dev_dbg(&pdev->dev, "mac address : %pM\n",
 			adapter->hw.mac_addr);
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 2e22483a9040..56e5f440e666 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -374,7 +374,7 @@ static int atl1e_set_mac_addr(struct net_device *netdev, void *p)
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(adapter->hw.mac_addr, addr->sa_data, netdev->addr_len);
 
 	atl1e_hw_set_mac_addr(&adapter->hw);
@@ -2390,7 +2390,7 @@ static int atl1e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_eeprom;
 	}
 
-	memcpy(netdev->dev_addr, adapter->hw.mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, adapter->hw.mac_addr);
 	netdev_dbg(netdev, "mac address : %pM\n", adapter->hw.mac_addr);
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 68f6c0bbd945..b4c9e805e981 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3027,7 +3027,7 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* mark random mac */
 		netdev->addr_assign_type = NET_ADDR_RANDOM;
 	}
-	memcpy(netdev->dev_addr, adapter->hw.mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, adapter->hw.mac_addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		err = -EIO;
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index b69298ddb647..bbc4d7b08a49 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -931,7 +931,7 @@ static int atl2_set_mac(struct net_device *netdev, void *p)
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(adapter->hw.mac_addr, addr->sa_data, netdev->addr_len);
 
 	atl2_set_mac_addr(&adapter->hw);
@@ -1405,7 +1405,7 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* copy the MAC address out of the EEPROM */
 	atl2_read_mac_addr(&adapter->hw);
-	memcpy(netdev->dev_addr, adapter->hw.mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, adapter->hw.mac_addr);
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		err = -EIO;
 		goto err_eeprom;
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 0941d07d0833..e8cfbf4ff1b5 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -69,7 +69,7 @@ static int atlx_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(adapter->hw.mac_addr, addr->sa_data, netdev->addr_len);
 
 	atlx_set_mac_addr(&adapter->hw);
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 20f439aaac1a..55c9e6fcb471 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1383,7 +1383,7 @@ static int b44_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EINVAL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	spin_lock_irq(&bp->lock);
 
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 7fa1b695400d..0c34bef1a431 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1850,7 +1850,7 @@ static int bcm_sysport_change_mac(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EINVAL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	/* interface is disabled, changes to MAC will be reflected on next
 	 * open call
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b1d7076e4c9a..248b81249cb0 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7910,7 +7910,7 @@ bnx2_change_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	if (netif_running(dev))
 		bnx2_set_mac_addr(bp, bp->dev->dev_addr, 0);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index b5d954cb409a..e8e8c2d593c5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4336,7 +4336,7 @@ int bnx2x_change_mac_addr(struct net_device *dev, void *p)
 			return rc;
 	}
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	if (netif_running(dev))
 		rc = bnx2x_set_eth_mac(bp, true);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 50c975bb7c49..f05f4271d4c1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12369,7 +12369,7 @@ static int bnxt_change_mac_addr(struct net_device *dev, void *p)
 	if (rc)
 		return rc;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	if (netif_running(dev)) {
 		bnxt_close_nic(bp, false, false);
 		rc = bnxt_open_nic(bp, false, false);
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5e0e0e70d801..d95b11480865 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -9366,7 +9366,7 @@ static int tg3_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	if (!netif_running(dev))
 		return 0;
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index b6a066404f4b..dc51f36fdf2a 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1479,7 +1479,7 @@ static int xgmac_set_mac_address(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	xgmac_set_mac_addr(ioaddr, dev->dev_addr, 0);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 5d865ba7aed4..1daf63e437ce 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2024,7 +2024,7 @@ static int liquidio_set_mac(struct net_device *netdev, void *p)
 		return -EIO;
 	}
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(((u8 *)&lio->linfo.hw_addr) + 2, addr->sa_data, ETH_ALEN);
 
 	return 0;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 8a969a9d4b63..c607756b731f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1168,7 +1168,7 @@ static int liquidio_set_mac(struct net_device *netdev, void *p)
 		return -EPERM;
 	}
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	ether_addr_copy(((u8 *)&lio->linfo.hw_addr) + 2, addr->sa_data);
 
 	return 0;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 5ef704c8d839..35021281882c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1611,7 +1611,7 @@ static int nicvf_set_mac_address(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	if (nic->pdev->msix_enabled) {
 		if (nicvf_hw_set_mac_addr(nic, netdev))
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index d246eee4b6d5..609820e214a3 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -853,7 +853,7 @@ static int t1_set_mac_addr(struct net_device *dev, void *p)
 	if (!mac->ops->macaddress_set)
 		return -EOPNOTSUPP;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	mac->ops->macaddress_set(mac, dev->dev_addr);
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 38e47703f9ab..9cf9e33664e4 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2586,7 +2586,7 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	t3_mac_set_address(&pi->mac, LAN_MAC_IDX, dev->dev_addr);
 	if (offload_running(adapter))
 		write_smt_entry(adapter, pi->port_id);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0d9cda4ab303..dde1cf51d0ab 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3468,7 +3468,7 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 	if (ret < 0)
 		return ret;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 4920a80a0460..64479c464b4e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1218,7 +1218,7 @@ static int cxgb4vf_set_mac_addr(struct net_device *dev, void *_addr)
 	if (ret < 0)
 		return ret;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index d0c4c8b7a15a..bd7920ab166f 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1227,7 +1227,7 @@ static int set_mac_address(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	cs89_dbg(0, debug, "%s: Setting MAC address to %pM\n",
 		 dev->name, dev->dev_addr);
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 13dbdd5d07b4..66348cc3aaaf 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -985,7 +985,7 @@ static int enic_set_mac_addr(struct net_device *netdev, char *addr)
 			return -EADDRNOTAVAIL;
 	}
 
-	memcpy(netdev->dev_addr, addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 685d2d8a3b36..cd8a7d94f60c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -268,7 +268,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 
 	if (is_valid_ether_addr(mac_addr)) {
 		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
-		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		eth_hw_addr_random(net_dev);
 		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 03c168b1712f..34f189271ef2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4013,7 +4013,7 @@ static int dpaa2_eth_set_mac_addr(struct dpaa2_eth_priv *priv)
 				return err;
 			}
 		}
-		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+		eth_hw_addr_set(net_dev, mac_addr);
 	} else if (is_zero_ether_addr(dpni_mac_addr)) {
 		/* No MAC address configured, fill in net_dev->dev_addr
 		 * with a random one
@@ -4038,7 +4038,7 @@ static int dpaa2_eth_set_mac_addr(struct dpaa2_eth_priv *priv)
 		/* NET_ADDR_PERM is default, all we have to do is
 		 * fill in the device addr.
 		 */
-		memcpy(net_dev->dev_addr, dpni_mac_addr, net_dev->addr_len);
+		eth_hw_addr_set(net_dev, dpni_mac_addr);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 175f15c46842..d039457928b0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -980,7 +980,7 @@ static int dpaa2_switch_port_set_mac_addr(struct ethsw_port_priv *port_priv)
 
 	/* First check if firmware has any address configured by bootloader */
 	if (!is_zero_ether_addr(mac_addr)) {
-		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		/* No MAC address configured, fill in net_dev->dev_addr
 		 * with a random one
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 8c6fa1345996..628a74ba630c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -40,7 +40,7 @@ static int enetc_pf_set_mac_addr(struct net_device *ndev, void *addr)
 	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(ndev->dev_addr, saddr->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, saddr->sa_data);
 	enetc_pf_set_primary_mac_addr(&priv->si->hw, 0, saddr->sa_data);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a8280005b50b..47a6fc702ac7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3326,7 +3326,7 @@ fec_set_mac_address(struct net_device *ndev, void *p)
 	if (addr) {
 		if (!is_valid_ether_addr(addr->sa_data))
 			return -EADDRNOTAVAIL;
-		memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
+		eth_hw_addr_set(ndev, addr->sa_data);
 	}
 
 	/* Add netif status check here to avoid system hang in below case:
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index 73ff359a15f1..5e418850d32d 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -112,7 +112,7 @@ static int mpc52xx_fec_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *sock = addr;
 
-	memcpy(dev->dev_addr, sock->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, sock->sa_data);
 
 	mpc52xx_fec_set_paddr(dev, sock->sa_data);
 	return 0;
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 3eb288d10b0c..e84517a4d245 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3205,7 +3205,7 @@ static int ucc_geth_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	/*
 	 * If device is not running, we will set mac addr register
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 22bf914f2dbd..c4057de39523 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -555,7 +555,7 @@ static int hisi_femac_set_mac_address(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(skaddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, skaddr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, skaddr->sa_data);
 	dev->addr_assign_type &= ~NET_ADDR_RANDOM;
 
 	hisi_femac_set_hw_mac_addr(priv, dev->dev_addr);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 343c605c4be8..2c4801e49aa1 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1194,7 +1194,7 @@ static int hns_nic_net_set_mac_address(struct net_device *ndev, void *p)
 		return ret;
 	}
 
-	memcpy(ndev->dev_addr, mac_addr->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, mac_addr->sa_data);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 323ed40d7d1c..49e8de42af9a 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1741,7 +1741,7 @@ static int ehea_set_mac_addr(struct net_device *dev, void *sa)
 		goto out_free;
 	}
 
-	memcpy(dev->dev_addr, mac_addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, mac_addr->sa_data);
 
 	/* Deregister old MAC in pHYP */
 	if (port->state == EHEA_PORT_UP) {
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 523c488c71f6..8db0ec38bbee 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -1013,7 +1013,7 @@ static int emac_set_mac_address(struct net_device *ndev, void *sa)
 
 	mutex_lock(&dev->link_lock);
 
-	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, addr->sa_data);
 
 	emac_rx_disable(dev);
 	emac_tx_disable(dev);
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index b620fdfb15b9..5039a2536951 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2259,7 +2259,7 @@ static int e100_set_mac_address(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	e100_exec_cb(nic, NULL, e100_setup_iaaddr);
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index bed4f040face..669060a2e6aa 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1103,7 +1103,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			e_err(probe, "EEPROM Read Error\n");
 	}
 	/* don't block initialization here due to bad MAC address */
-	memcpy(netdev->dev_addr, hw->mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, hw->mac_addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr))
 		e_err(probe, "Invalid MAC Address\n");
@@ -2209,7 +2209,7 @@ static int e1000_set_mac(struct net_device *netdev, void *p)
 	if (hw->mac_type == e1000_82542_rev2_0)
 		e1000_enter_82542_rst(adapter);
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(hw->mac_addr, addr->sa_data, netdev->addr_len);
 
 	e1000_rar_set(hw, hw->mac_addr, 0);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 900b3ab998bd..ff8672ae2b6c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4786,7 +4786,7 @@ static int e1000_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(adapter->hw.mac.addr, addr->sa_data, netdev->addr_len);
 
 	hw->mac.ops.rar_set(&adapter->hw, adapter->hw.mac.addr, 0);
@@ -7589,7 +7589,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev,
 			"NVM Read Error while reading MAC address\n");
 
-	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		dev_err(&pdev->dev, "Invalid MAC Address: %pM\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 57e24aeffbc5..cabe84bb29fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5144,7 +5144,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	netif_addr_lock_bh(netdev);
 	ether_addr_copy(old_mac, netdev->dev_addr);
 	/* change the netdev's MAC address */
-	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	eth_hw_addr_set(netdev, mac);
 	netif_addr_unlock_bh(netdev);
 
 	/* Clean up old MAC filter. Not an error if old filter doesn't exist */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 751de06019a0..e67a71c3f141 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3356,7 +3356,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			dev_err(&pdev->dev, "NVM Read Error\n");
 	}
 
-	memcpy(netdev->dev_addr, hw->mac.addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		dev_err(&pdev->dev, "Invalid MAC Address\n");
@@ -4988,7 +4988,7 @@ static int igb_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(hw->mac.addr, addr->sa_data, netdev->addr_len);
 
 	/* set the correct pool for the new PF MAC address in entry 0 */
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index d32e72d953c8..74ccd622251a 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1527,8 +1527,7 @@ static void igbvf_reset(struct igbvf_adapter *adapter)
 	spin_unlock_bh(&hw->mbx_lock);
 
 	if (is_valid_ether_addr(adapter->hw.mac.addr)) {
-		memcpy(netdev->dev_addr, adapter->hw.mac.addr,
-		       netdev->addr_len);
+		eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 		memcpy(netdev->perm_addr, adapter->hw.mac.addr,
 		       netdev->addr_len);
 	}
@@ -1813,7 +1812,7 @@ static int igbvf_set_mac(struct net_device *netdev, void *p)
 	if (!ether_addr_equal(addr->sa_data, hw->mac.addr))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	return 0;
 }
@@ -2816,8 +2815,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		else if (is_zero_ether_addr(adapter->hw.mac.addr))
 			dev_info(&pdev->dev,
 				 "MAC address not assigned by administrator.\n");
-		memcpy(netdev->dev_addr, adapter->hw.mac.addr,
-		       netdev->addr_len);
+		eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 	}
 
 	spin_unlock_bh(&hw->mbx_lock);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0e19b4d02e62..7ffb1045f00c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -949,7 +949,7 @@ static int igc_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(hw->mac.addr, addr->sa_data, netdev->addr_len);
 
 	/* set the correct pool for the new PF MAC address in entry 0 */
@@ -6377,7 +6377,7 @@ static int igc_probe(struct pci_dev *pdev,
 			dev_err(&pdev->dev, "NVM Read Error\n");
 	}
 
-	memcpy(netdev->dev_addr, hw->mac.addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, hw->mac.addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		dev_err(&pdev->dev, "Invalid MAC Address\n");
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 1588376d4c67..5e1e2f0db82a 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -1030,7 +1030,7 @@ ixgb_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	ixgb_rar_set(&adapter->hw, addr->sa_data, 0);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 69e8bd9aa1a8..0f9f022260d7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8792,7 +8792,7 @@ static int ixgbe_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	memcpy(hw->mac.addr, addr->sa_data, netdev->addr_len);
 
 	ixgbe_mac_set_default_filter(adapter);
@@ -10927,7 +10927,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	eth_platform_get_mac_address(&adapter->pdev->dev,
 				     adapter->hw.mac.perm_addr);
 
-	memcpy(netdev->dev_addr, hw->mac.perm_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, hw->mac.perm_addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		e_dev_err("invalid MAC address\n");
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 3ecee2058a40..439674fc9765 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2254,7 +2254,7 @@ jme_set_macaddr(struct net_device *netdev, void *p)
 		return -EBUSY;
 
 	spin_lock_bh(&jme->macaddr_lock);
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	jme_set_unicastaddr(netdev);
 	spin_unlock_bh(&jme->macaddr_lock);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9826a9012737..0c89eb8a670b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -203,7 +203,7 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 		return -EADDRNOTAVAIL;
 
 	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data)) {
-		memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+		eth_hw_addr_set(netdev, addr->sa_data);
 		/* update dmac field in vlan offload rule */
 		if (netif_running(netdev) &&
 		    pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0e81ae723bc8..d366786ce0f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -674,7 +674,7 @@ static int mlxsw_sp_port_set_mac_address(struct net_device *dev, void *p)
 	err = mlxsw_sp_port_dev_addr_set(mlxsw_sp_port, addr->sa_data);
 	if (err)
 		return err;
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index b27713906d3a..37ccf8c570b5 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1064,7 +1064,7 @@ static int ks8842_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	eth_hw_addr_set(netdev, mac);
 
 	ks8842_write_mac_addr(adapter, mac);
 	return 0;
@@ -1191,8 +1191,7 @@ static int ks8842_probe(struct platform_device *pdev)
 
 		if (i < netdev->addr_len)
 			/* an address was passed, use it */
-			memcpy(netdev->dev_addr, pdata->macaddr,
-				netdev->addr_len);
+			eth_hw_addr_set(netdev, pdata->macaddr);
 	}
 
 	if (i == netdev->addr_len) {
diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index c548e6372352..d4680113e249 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -761,7 +761,7 @@ static int encx24j600_set_mac_address(struct net_device *dev, void *addr)
 	if (!is_valid_ether_addr(address->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, address->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, address->sa_data);
 	return encx24j600_set_hw_macaddr(dev);
 }
 
diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 49def6934cad..15179b9529e1 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -65,7 +65,7 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 	if (!is_valid_ether_addr(address->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(ndev->dev_addr, address->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, address->sa_data);
 	moxart_update_mac_address(ndev);
 
 	return 0;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 7e325d1697a9..5454c1c2f8ad 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5202,7 +5202,7 @@ static int s2io_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	/* store the MAC address in CAM */
 	return do_s2io_prog_unicast(dev, dev->dev_addr);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index f3ee51bf0e56..1969009a91e7 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -1328,7 +1328,7 @@ static int vxge_set_mac_addr(struct net_device *dev, void *p)
 	}
 
 	if (unlikely(!is_vxge_card_up(vdev))) {
-		memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+		eth_hw_addr_set(dev, addr->sa_data);
 		return VXGE_HW_OK;
 	}
 
@@ -1341,7 +1341,7 @@ static int vxge_set_mac_addr(struct net_device *dev, void *p)
 			return -EINVAL;
 	}
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return status;
 }
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ec3e558f890e..71d234291fc5 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2137,7 +2137,7 @@ static int pch_gbe_set_mac(struct net_device *netdev, void *addr)
 	if (!is_valid_ether_addr(skaddr->sa_data)) {
 		ret_val = -EADDRNOTAVAIL;
 	} else {
-		memcpy(netdev->dev_addr, skaddr->sa_data, netdev->addr_len);
+		eth_hw_addr_set(netdev, skaddr->sa_data);
 		memcpy(adapter->hw.mac.addr, skaddr->sa_data, netdev->addr_len);
 		pch_gbe_mac_mar_set(&adapter->hw, adapter->hw.mac.addr, 0);
 		ret_val = 0;
@@ -2555,7 +2555,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 		goto err_free_adapter;
 	}
 
-	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		/*
 		 * If the MAC is invalid (or just missing), display a warning
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 7e096b2888b9..5512e43bafc1 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -221,7 +221,7 @@ static int pasemi_mac_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	adr0 = dev->dev_addr[2] << 24 |
 	       dev->dev_addr[3] << 16 |
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 344ea1143454..b4e094e6f58c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -500,7 +500,7 @@ static int netxen_nic_set_mac(struct net_device *netdev, void *p)
 	}
 
 	memcpy(adapter->mac_addr, addr->sa_data, netdev->addr_len);
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	adapter->macaddr_set(adapter, addr->sa_data);
 
 	if (netif_running(netdev)) {
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index c00ad57575ea..395f054e9e0c 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3564,7 +3564,7 @@ static int ql3xxx_set_mac_address(struct net_device *ndev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, addr->sa_data);
 
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 	/* Program lower 32 bits of the MAC address */
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 73996f47b1e4..ed84f0f97623 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -356,7 +356,7 @@ static int qlcnic_set_mac(struct net_device *netdev, void *p)
 
 	qlcnic_delete_adapter_mac(adapter);
 	memcpy(adapter->mac_addr, addr->sa_data, netdev->addr_len);
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	qlcnic_set_multi(adapter->netdev);
 
 	if (test_bit(__QLCNIC_DEV_UP, &adapter->state)) {
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 2b84b4565e64..614aac780b6b 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1624,7 +1624,7 @@ static int cp_set_mac_address(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	spin_lock_irq(&cp->lock);
 
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 2e6923cc653e..75b5ac91132b 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2238,7 +2238,7 @@ static int rtl8139_set_mac_address(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	spin_lock_irq(&tp->lock);
 
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 3364b6a56bd1..f28c0c36b606 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1954,7 +1954,7 @@ static int rocker_port_set_mac_address(struct net_device *dev, void *p)
 	err = rocker_cmd_set_port_settings_macaddr(rocker_port, addr->sa_data);
 	if (err)
 		return err;
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 16f7410bb714..96065dfc747b 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -167,7 +167,7 @@ static int sgiseeq_set_mac_address(struct net_device *dev, void *addr)
 	struct sgiseeq_private *sp = netdev_priv(dev);
 	struct sockaddr *sa = addr;
 
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, sa->sa_data);
 
 	spin_lock_irq(&sp->tx_lock);
 	__sgiseeq_set_mac_address(dev);
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 6220616937a7..e2d009866a7b 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -243,7 +243,7 @@ static int ioc3_set_mac_address(struct net_device *dev, void *addr)
 	struct ioc3_private *ip = netdev_priv(dev);
 	struct sockaddr *sa = addr;
 
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, sa->sa_data);
 
 	spin_lock_irq(&ip->ioc3_lock);
 	__ioc3_set_mac_address(dev);
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 825aca3c68fa..1a73a9401347 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9235,7 +9235,7 @@ static int niu_get_of_props(struct niu *np)
 		netdev_err(dev, "%pOF: OF MAC address prop len (%d) is wrong\n",
 			   dp, prop_len);
 	}
-	memcpy(dev->dev_addr, mac_addr, dev->addr_len);
+	eth_hw_addr_set(dev, mac_addr);
 	if (!is_valid_ether_addr(&dev->dev_addr[0])) {
 		netdev_err(dev, "%pOF: OF MAC address is invalid\n", dp);
 		netdev_err(dev, "%pOF: [ %pM ]\n", dp, dev->dev_addr);
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index a5bda9b34fba..5f786d6fa150 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2437,7 +2437,7 @@ static int gem_set_mac_address(struct net_device *dev, void *addr)
 	if (!is_valid_ether_addr(macaddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, macaddr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, macaddr->sa_data);
 
 	/* We'll just catch it later when the device is up'd or resumed */
 	if (!netif_running(dev) || !netif_device_present(dev))
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index df26cea45904..5c9b6c90942b 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -78,7 +78,7 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 	netdev->irq = pdata->dev_irq;
 	netdev->base_addr = (unsigned long)pdata->mac_regs;
 	xlgmac_read_mac_addr(pdata);
-	memcpy(netdev->dev_addr, pdata->mac_addr, netdev->addr_len);
+	eth_hw_addr_set(netdev, pdata->mac_addr);
 
 	/* Set all the function pointers */
 	xlgmac_init_all_ops(pdata);
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 1db7104fef3a..d435519236e4 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -798,7 +798,7 @@ static int xlgmac_set_mac_address(struct net_device *netdev, void *addr)
 	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(netdev->dev_addr, saddr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, saddr->sa_data);
 
 	hw_ops->set_mac_address(pdata, netdev->dev_addr);
 
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 6b409f9c5863..3e8a3fde8302 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -832,7 +832,7 @@ static int bdx_set_mac(struct net_device *ndev, void *p)
 	   if (netif_running(dev))
 	   return -EBUSY
 	 */
-	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, addr->sa_data);
 	bdx_restore_mac(ndev, priv);
 	RET(0);
 }
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index e4b4624be2ae..4538e597eefe 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1132,7 +1132,7 @@ static int emac_dev_setmac_addr(struct net_device *ndev, void *addr)
 
 	/* Store mac addr in priv and rx channel and set it in EMAC hw */
 	memcpy(priv->mac_addr, sa->sa_data, ndev->addr_len);
-	memcpy(ndev->dev_addr, sa->sa_data, ndev->addr_len);
+	eth_hw_addr_set(ndev, sa->sa_data);
 
 	/* MAC address is configured only after the interface is enabled. */
 	if (netif_running(ndev)) {
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index b780aad3550a..0d4394125d51 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -511,7 +511,7 @@ static int xemaclite_set_mac_address(struct net_device *dev, void *address)
 	if (netif_running(dev))
 		return -EBUSY;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 	xemaclite_update_address(lp, dev->dev_addr);
 	return 0;
 }
-- 
2.31.1

