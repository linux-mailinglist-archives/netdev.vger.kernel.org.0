Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C77A3D776C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhG0NsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236667AbhG0Nqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0986861ACE;
        Tue, 27 Jul 2021 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393608;
        bh=gdV/5mjQ8OF1C32fpTx1AXLflGSjm7xnajsVCGg8mXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSZQNp9/eyAe3rpX/Z5EnDvGjsFCAeAVRJl4ZsUzDFUaiEF6RJhoFPmHorchbi/6h
         zNnAhOuApF1vh+xeUenuRsPB6BD4j0EMuean5umFdetNR+aJwNLMtkO6HuzOskcqR3
         LrY4NYTADj/8OM6nkK6B/+MPKhkPja3zgoJq0edcq88czeVpf7rV3RL6HDD1+1DzUi
         HUbkKrHJy31ntTo46pyCT2fCfOJA2BPC8SqPvPX6wtUYv9jPjDZFjhTo6qadaOtg5C
         1YF1YW6cOvb0WpwEJ6Li3DByv2WUpzihQ6J1zVhPs8mgZ4VLbv6clNCHCFtlN3tOjW
         cG9CuZ3qVm19Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 27/31] dev_ioctl: split out ndo_eth_ioctl
Date:   Tue, 27 Jul 2021 15:45:13 +0200
Message-Id: <20210727134517.1384504-28-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Most users of ndo_do_ioctl are ethernet drivers that implement
the MII commands SIOCGMIIPHY/SIOCGMIIREG/SIOCSMIIREG, or hardware
timestamping with SIOCSHWTSTAMP/SIOCGHWTSTAMP.

Separate these from the few drivers that use ndo_do_ioctl to
implement SIOCBOND, SIOCBR and SIOCWANDEV commands.

This is a purely cosmetic change intended to help readers find
their way through the implementation.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/netdevices.rst       |  4 ++
 Documentation/networking/timestamping.rst     |  6 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  8 ++--
 drivers/net/bonding/bond_main.c               | 42 +++++++++++++------
 drivers/net/ethernet/3com/3c574_cs.c          |  2 +-
 drivers/net/ethernet/3com/3c59x.c             |  4 +-
 drivers/net/ethernet/8390/ax88796.c           |  2 +-
 drivers/net/ethernet/8390/axnet_cs.c          |  2 +-
 drivers/net/ethernet/8390/pcnet_cs.c          |  2 +-
 drivers/net/ethernet/actions/owl-emac.c       |  6 +--
 drivers/net/ethernet/adaptec/starfire.c       |  2 +-
 drivers/net/ethernet/agere/et131x.c           |  2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c   |  2 +-
 drivers/net/ethernet/amd/amd8111e.c           |  2 +-
 drivers/net/ethernet/amd/au1000_eth.c         |  2 +-
 drivers/net/ethernet/amd/pcnet32.c            |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  2 +-
 drivers/net/ethernet/arc/emac_main.c          |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  2 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  2 +-
 drivers/net/ethernet/broadcom/b44.c           |  2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  |  4 +-
 drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c    |  2 +-
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 drivers/net/ethernet/cadence/macb_main.c      |  4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  2 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |  2 +-
 drivers/net/ethernet/davicom/dm9000.c         |  2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c   |  2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c  |  2 +-
 drivers/net/ethernet/dlink/dl2k.c             |  2 +-
 drivers/net/ethernet/dlink/sundance.c         |  2 +-
 drivers/net/ethernet/dnet.c                   |  2 +-
 drivers/net/ethernet/ethoc.c                  |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 drivers/net/ethernet/faraday/ftmac100.c       |  2 +-
 drivers/net/ethernet/fealnx.c                 |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  2 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c  |  2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c     |  2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 drivers/net/ethernet/ibm/emac/core.c          |  4 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  2 +-
 drivers/net/ethernet/intel/e100.c             |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  6 +--
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 drivers/net/ethernet/jme.c                    |  2 +-
 drivers/net/ethernet/korina.c                 |  2 +-
 drivers/net/ethernet/lantiq_etop.c            |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c     |  2 +-
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |  2 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +-
 drivers/net/ethernet/micrel/ks8851_common.c   |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 drivers/net/ethernet/natsemi/natsemi.c        |  2 +-
 drivers/net/ethernet/neterion/s2io.c          |  2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |  2 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  2 +-
 drivers/net/ethernet/packetengines/hamachi.c  |  2 +-
 .../net/ethernet/packetengines/yellowfin.c    |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 drivers/net/ethernet/rdc/r6040.c              |  2 +-
 drivers/net/ethernet/realtek/8139cp.c         |  2 +-
 drivers/net/ethernet/realtek/8139too.c        |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  2 +-
 drivers/net/ethernet/sfc/efx.c                |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  2 +-
 drivers/net/ethernet/sgi/meth.c               |  2 +-
 drivers/net/ethernet/sis/sis190.c             |  2 +-
 drivers/net/ethernet/sis/sis900.c             |  2 +-
 drivers/net/ethernet/smsc/epic100.c           |  2 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c       |  2 +-
 drivers/net/ethernet/smsc/smsc911x.c          |  2 +-
 drivers/net/ethernet/smsc/smsc9420.c          |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 drivers/net/ethernet/socionext/sni_ave.c      |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/ethernet/sun/cassini.c            |  2 +-
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpmac.c               |  2 +-
 drivers/net/ethernet/ti/cpsw.c                |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 drivers/net/ethernet/ti/davinci_emac.c        |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/ti/tlan.c                |  2 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  2 +-
 drivers/net/ethernet/toshiba/tc35815.c        |  2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |  2 +-
 drivers/net/ethernet/via/via-rhine.c          |  2 +-
 drivers/net/ethernet/via/via-velocity.c       |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c      |  2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  2 +-
 drivers/net/macvlan.c                         |  8 ++--
 drivers/net/phy/phy.c                         |  4 +-
 drivers/net/usb/asix_devices.c                |  6 +--
 drivers/net/usb/ax88172a.c                    |  2 +-
 drivers/net/usb/ax88179_178a.c                |  2 +-
 drivers/net/usb/dm9601.c                      |  2 +-
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/net/usb/mcs7830.c                     |  2 +-
 drivers/net/usb/r8152.c                       |  2 +-
 drivers/net/usb/smsc75xx.c                    |  2 +-
 drivers/net/usb/smsc95xx.c                    |  2 +-
 drivers/net/usb/sr9700.c                      |  2 +-
 drivers/net/usb/sr9800.c                      |  2 +-
 drivers/s390/net/qeth_l2_main.c               |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  4 +-
 drivers/staging/octeon/ethernet.c             | 12 +++---
 include/linux/netdevice.h                     |  6 +++
 include/net/dsa.h                             | 14 +++----
 net/8021q/vlan_dev.c                          |  6 +--
 net/core/dev_ioctl.c                          | 38 ++++++++++++-----
 net/dsa/master.c                              |  6 +--
 net/dsa/slave.c                               |  2 +-
 172 files changed, 273 insertions(+), 231 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 02f1faac839a..f57f255f2397 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -229,6 +229,10 @@ ndo_siocdevprivate:
 	This is used to implement SIOCDEVPRIVATE ioctl helpers.
 	These should not be added to new drivers, so don't use.
 
+ndo_eth_ioctl:
+	Synchronization: rtnl_lock() semaphore.
+	Context: process
+
 ndo_get_stats:
 	Synchronization: rtnl_lock() semaphore, dev_base_lock rwlock, or RCU.
 	Context: atomic (can't sleep under rwlock or RCU)
diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 7db3985359bc..a722eb30e014 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -625,7 +625,7 @@ interfaces of a DSA switch to share the same PHC.
 By design, PTP timestamping with a DSA switch does not need any special
 handling in the driver for the host port it is attached to.  However, when the
 host port also supports PTP timestamping, DSA will take care of intercepting
-the ``.ndo_do_ioctl`` calls towards the host port, and block attempts to enable
+the ``.ndo_eth_ioctl`` calls towards the host port, and block attempts to enable
 hardware timestamping on it. This is because the SO_TIMESTAMPING API does not
 allow the delivery of multiple hardware timestamps for the same packet, so
 anybody else except for the DSA switch port must be prevented from doing so.
@@ -688,7 +688,7 @@ ethtool ioctl operations for them need to be mediated by their respective MAC
 driver.  Therefore, as opposed to DSA switches, modifications need to be done
 to each individual MAC driver for PHY timestamping support. This entails:
 
-- Checking, in ``.ndo_do_ioctl``, whether ``phy_has_hwtstamp(netdev->phydev)``
+- Checking, in ``.ndo_eth_ioctl``, whether ``phy_has_hwtstamp(netdev->phydev)``
   is true or not. If it is, then the MAC driver should not process this request
   but instead pass it on to the PHY using ``phy_mii_ioctl()``.
 
@@ -747,7 +747,7 @@ For example, a typical driver design for TX timestamping might be to split the
 transmission part into 2 portions:
 
 1. "TX": checks whether PTP timestamping has been previously enabled through
-   the ``.ndo_do_ioctl`` ("``priv->hwtstamp_tx_enabled == true``") and the
+   the ``.ndo_eth_ioctl`` ("``priv->hwtstamp_tx_enabled == true``") and the
    current skb requires a TX timestamp ("``skb_shinfo(skb)->tx_flags &
    SKBTX_HW_TSTAMP``"). If this is true, it sets the
    "``skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS``" flag. Note: as
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index abf60f4d9203..0aa8629fdf62 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1745,10 +1745,10 @@ static int ipoib_ioctl(struct net_device *dev, struct ifreq *ifr,
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
-	if (!priv->rn_ops->ndo_do_ioctl)
+	if (!priv->rn_ops->ndo_eth_ioctl)
 		return -EOPNOTSUPP;
 
-	return priv->rn_ops->ndo_do_ioctl(dev, ifr, cmd);
+	return priv->rn_ops->ndo_eth_ioctl(dev, ifr, cmd);
 }
 
 static int ipoib_dev_init(struct net_device *dev)
@@ -2078,7 +2078,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
 	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
 	.ndo_set_mac_address	 = ipoib_set_mac,
 	.ndo_get_stats64	 = ipoib_get_stats,
-	.ndo_do_ioctl		 = ipoib_ioctl,
+	.ndo_eth_ioctl		 = ipoib_ioctl,
 };
 
 static const struct net_device_ops ipoib_netdev_ops_vf = {
@@ -2093,7 +2093,7 @@ static const struct net_device_ops ipoib_netdev_ops_vf = {
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 	.ndo_get_iflink		 = ipoib_get_iflink,
 	.ndo_get_stats64	 = ipoib_get_stats,
-	.ndo_do_ioctl		 = ipoib_ioctl,
+	.ndo_eth_ioctl		 = ipoib_ioctl,
 };
 
 static const struct net_device_ops ipoib_netdev_default_pf = {
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 96864183f92e..23769e937c28 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -732,7 +732,7 @@ static int bond_check_dev_link(struct bonding *bond,
 			BMSR_LSTATUS : 0;
 
 	/* Ethtool can't be used, fallback to MII ioctls. */
-	ioctl = slave_ops->ndo_do_ioctl;
+	ioctl = slave_ops->ndo_eth_ioctl;
 	if (ioctl) {
 		/* TODO: set pointer to correct ioctl on a per team member
 		 *       bases to make this more efficient. that is, once
@@ -756,7 +756,7 @@ static int bond_check_dev_link(struct bonding *bond,
 		}
 	}
 
-	/* If reporting, report that either there's no dev->do_ioctl,
+	/* If reporting, report that either there's no ndo_eth_ioctl,
 	 * or both SIOCGMIIREG and get_link failed (meaning that we
 	 * cannot report link status).  If not reporting, pretend
 	 * we're ok.
@@ -1733,7 +1733,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	if (!bond->params.use_carrier &&
 	    slave_dev->ethtool_ops->get_link == NULL &&
-	    slave_ops->ndo_do_ioctl == NULL) {
+	    slave_ops->ndo_eth_ioctl == NULL) {
 		slave_warn(bond_dev, slave_dev, "no link monitoring support\n");
 	}
 
@@ -3962,20 +3962,13 @@ static void bond_get_stats(struct net_device *bond_dev,
 	rcu_read_unlock();
 }
 
-static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
+static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct net_device *slave_dev = NULL;
-	struct ifbond k_binfo;
-	struct ifbond __user *u_binfo = NULL;
-	struct ifslave k_sinfo;
-	struct ifslave __user *u_sinfo = NULL;
 	struct mii_ioctl_data *mii = NULL;
-	struct bond_opt_value newval;
-	struct net *net;
-	int res = 0;
+	int res;
 
-	netdev_dbg(bond_dev, "bond_ioctl: cmd=%d\n", cmd);
+	netdev_dbg(bond_dev, "bond_eth_ioctl: cmd=%d\n", cmd);
 
 	switch (cmd) {
 	case SIOCGMIIPHY:
@@ -4000,6 +3993,28 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 		}
 
 		return 0;
+	default:
+		res = -EOPNOTSUPP;
+	}
+
+	return res;
+}
+
+static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
+{
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct net_device *slave_dev = NULL;
+	struct ifbond k_binfo;
+	struct ifbond __user *u_binfo = NULL;
+	struct ifslave k_sinfo;
+	struct ifslave __user *u_sinfo = NULL;
+	struct bond_opt_value newval;
+	struct net *net;
+	int res = 0;
+
+	netdev_dbg(bond_dev, "bond_ioctl: cmd=%d\n", cmd);
+
+	switch (cmd) {
 	case SIOCBONDINFOQUERY:
 		u_binfo = (struct ifbond __user *)ifr->ifr_data;
 
@@ -4972,6 +4987,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_start_xmit		= bond_start_xmit,
 	.ndo_select_queue	= bond_select_queue,
 	.ndo_get_stats64	= bond_get_stats,
+	.ndo_eth_ioctl		= bond_eth_ioctl,
 	.ndo_do_ioctl		= bond_do_ioctl,
 	.ndo_siocdevprivate	= bond_siocdevprivate,
 	.ndo_change_rx_flags	= bond_change_rx_flags,
diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3com/3c574_cs.c
index f66e7fb9a2bb..dd4d3c48b98d 100644
--- a/drivers/net/ethernet/3com/3c574_cs.c
+++ b/drivers/net/ethernet/3com/3c574_cs.c
@@ -252,7 +252,7 @@ static const struct net_device_ops el3_netdev_ops = {
 	.ndo_start_xmit		= el3_start_xmit,
 	.ndo_tx_timeout 	= el3_tx_timeout,
 	.ndo_get_stats		= el3_get_stats,
-	.ndo_do_ioctl		= el3_ioctl,
+	.ndo_eth_ioctl		= el3_ioctl,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 7d7d3ffe25c3..17c16333a412 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1052,7 +1052,7 @@ static const struct net_device_ops boomrang_netdev_ops = {
 	.ndo_tx_timeout		= vortex_tx_timeout,
 	.ndo_get_stats		= vortex_get_stats,
 #ifdef CONFIG_PCI
-	.ndo_do_ioctl 		= vortex_ioctl,
+	.ndo_eth_ioctl		= vortex_ioctl,
 #endif
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_set_mac_address 	= eth_mac_addr,
@@ -1069,7 +1069,7 @@ static const struct net_device_ops vortex_netdev_ops = {
 	.ndo_tx_timeout		= vortex_tx_timeout,
 	.ndo_get_stats		= vortex_get_stats,
 #ifdef CONFIG_PCI
-	.ndo_do_ioctl 		= vortex_ioctl,
+	.ndo_eth_ioctl		= vortex_ioctl,
 #endif
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_set_mac_address 	= eth_mac_addr,
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 172947fc051a..9595dd1f32ca 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -635,7 +635,7 @@ static void ax_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 static const struct net_device_ops ax_netdev_ops = {
 	.ndo_open		= ax_open,
 	.ndo_stop		= ax_close,
-	.ndo_do_ioctl		= ax_ioctl,
+	.ndo_eth_ioctl		= ax_ioctl,
 
 	.ndo_start_xmit		= ax_ei_start_xmit,
 	.ndo_tx_timeout		= ax_ei_tx_timeout,
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index 8c321dfc7b3b..3c370e686ec3 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -128,7 +128,7 @@ static inline struct axnet_dev *PRIV(struct net_device *dev)
 static const struct net_device_ops axnet_netdev_ops = {
 	.ndo_open 		= axnet_open,
 	.ndo_stop		= axnet_close,
-	.ndo_do_ioctl		= axnet_ioctl,
+	.ndo_eth_ioctl		= axnet_ioctl,
 	.ndo_start_xmit		= axnet_start_xmit,
 	.ndo_tx_timeout		= axnet_tx_timeout,
 	.ndo_get_stats		= get_stats,
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index cac036706382..96ad72abd373 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -223,7 +223,7 @@ static const struct net_device_ops pcnet_netdev_ops = {
 	.ndo_set_config		= set_config,
 	.ndo_start_xmit 	= ei_start_xmit,
 	.ndo_get_stats		= ei_get_stats,
-	.ndo_do_ioctl 		= ei_ioctl,
+	.ndo_eth_ioctl		= ei_ioctl,
 	.ndo_set_rx_mode	= ei_set_multicast_list,
 	.ndo_tx_timeout 	= ei_tx_timeout,
 	.ndo_set_mac_address 	= eth_mac_addr,
diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index b8e771c2bc40..c4ecf4fcadf8 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -1179,8 +1179,8 @@ static int owl_emac_ndo_set_mac_addr(struct net_device *netdev, void *addr)
 	return owl_emac_setup_frame_xmit(netdev_priv(netdev));
 }
 
-static int owl_emac_ndo_do_ioctl(struct net_device *netdev,
-				 struct ifreq *req, int cmd)
+static int owl_emac_ndo_eth_ioctl(struct net_device *netdev,
+				  struct ifreq *req, int cmd)
 {
 	if (!netif_running(netdev))
 		return -EINVAL;
@@ -1224,7 +1224,7 @@ static const struct net_device_ops owl_emac_netdev_ops = {
 	.ndo_set_rx_mode	= owl_emac_ndo_set_rx_mode,
 	.ndo_set_mac_address	= owl_emac_ndo_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= owl_emac_ndo_do_ioctl,
+	.ndo_eth_ioctl		= owl_emac_ndo_eth_ioctl,
 	.ndo_tx_timeout         = owl_emac_ndo_tx_timeout,
 	.ndo_get_stats		= owl_emac_ndo_get_stats,
 };
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 7965e5e3c985..e0f6cc910bd2 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -625,7 +625,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_tx_timeout		= tx_timeout,
 	.ndo_get_stats		= get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef VLAN_SUPPORT
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 41f8821f792d..920633161174 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3882,7 +3882,7 @@ static const struct net_device_ops et131x_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_get_stats		= et131x_stats,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 };
 
 static int et131x_pci_setup(struct pci_dev *pdev,
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index f99ae317c188..037baea1c738 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -774,7 +774,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_start_xmit		= emac_start_xmit,
 	.ndo_tx_timeout		= emac_timeout,
 	.ndo_set_rx_mode	= emac_set_rx_mode,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= emac_set_mac_address,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 9cac5aa75a73..92e4246dc359 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1729,7 +1729,7 @@ static const struct net_device_ops amd8111e_netdev_ops = {
 	.ndo_set_rx_mode	= amd8111e_set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= amd8111e_set_mac_address,
-	.ndo_do_ioctl		= amd8111e_ioctl,
+	.ndo_eth_ioctl		= amd8111e_ioctl,
 	.ndo_change_mtu		= amd8111e_change_mtu,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	 = amd8111e_poll,
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 19e195420e24..9c1636222b99 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1051,7 +1051,7 @@ static const struct net_device_ops au1000_netdev_ops = {
 	.ndo_stop		= au1000_close,
 	.ndo_start_xmit		= au1000_tx,
 	.ndo_set_rx_mode	= au1000_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_tx_timeout		= au1000_tx_timeout,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 4100ab07e6b7..70d76fdb9f56 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1572,7 +1572,7 @@ static const struct net_device_ops pcnet32_netdev_ops = {
 	.ndo_tx_timeout		= pcnet32_tx_timeout,
 	.ndo_get_stats		= pcnet32_get_stats,
 	.ndo_set_rx_mode	= pcnet32_set_multicast_list,
-	.ndo_do_ioctl		= pcnet32_ioctl,
+	.ndo_eth_ioctl		= pcnet32_ioctl,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 4f714f874c4f..17a585adfb49 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2284,7 +2284,7 @@ static const struct net_device_ops xgbe_netdev_ops = {
 	.ndo_set_rx_mode	= xgbe_set_rx_mode,
 	.ndo_set_mac_address	= xgbe_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= xgbe_ioctl,
+	.ndo_eth_ioctl		= xgbe_ioctl,
 	.ndo_change_mtu		= xgbe_change_mtu,
 	.ndo_tx_timeout		= xgbe_tx_timeout,
 	.ndo_get_stats64	= xgbe_get_stats64,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 4af0cd9530de..e22935ce9573 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -421,7 +421,7 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_change_mtu = aq_ndev_change_mtu,
 	.ndo_set_mac_address = aq_ndev_set_mac_address,
 	.ndo_set_features = aq_ndev_set_features,
-	.ndo_do_ioctl = aq_ndev_ioctl,
+	.ndo_eth_ioctl = aq_ndev_ioctl,
 	.ndo_vlan_rx_add_vid = aq_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = aq_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc = aq_ndo_setup_tc,
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 67b8113a2b53..38c288ec9059 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -844,7 +844,7 @@ static const struct net_device_ops arc_emac_netdev_ops = {
 	.ndo_set_mac_address	= arc_emac_set_address,
 	.ndo_get_stats		= arc_emac_stats,
 	.ndo_set_rx_mode	= arc_emac_set_rx_mode,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= arc_emac_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 1ba81b1eb6fd..02ae98aabf91 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1851,7 +1851,7 @@ static const struct net_device_ops ag71xx_netdev_ops = {
 	.ndo_open		= ag71xx_open,
 	.ndo_stop		= ag71xx_stop,
 	.ndo_start_xmit		= ag71xx_hard_start_xmit,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= ag71xx_tx_timeout,
 	.ndo_change_mtu		= ag71xx_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 11ef1fbe7aee..4ea157efca86 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1701,7 +1701,7 @@ static const struct net_device_ops alx_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = alx_set_mac_address,
 	.ndo_change_mtu         = alx_change_mtu,
-	.ndo_do_ioctl           = alx_ioctl,
+	.ndo_eth_ioctl           = alx_ioctl,
 	.ndo_tx_timeout         = alx_tx_timeout,
 	.ndo_fix_features	= alx_fix_features,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1c6246a5dc22..3b51b172b317 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2609,7 +2609,7 @@ static const struct net_device_ops atl1c_netdev_ops = {
 	.ndo_change_mtu		= atl1c_change_mtu,
 	.ndo_fix_features	= atl1c_fix_features,
 	.ndo_set_features	= atl1c_set_features,
-	.ndo_do_ioctl		= atl1c_ioctl,
+	.ndo_eth_ioctl		= atl1c_ioctl,
 	.ndo_tx_timeout		= atl1c_tx_timeout,
 	.ndo_get_stats		= atl1c_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 2eb0a2ab69f6..753973ac922e 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2247,7 +2247,7 @@ static const struct net_device_ops atl1e_netdev_ops = {
 	.ndo_fix_features	= atl1e_fix_features,
 	.ndo_set_features	= atl1e_set_features,
 	.ndo_change_mtu		= atl1e_change_mtu,
-	.ndo_do_ioctl		= atl1e_ioctl,
+	.ndo_eth_ioctl		= atl1e_ioctl,
 	.ndo_tx_timeout		= atl1e_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= atl1e_netpoll,
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index c67201a13cf5..68f6c0bbd945 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2885,7 +2885,7 @@ static const struct net_device_ops atl1_netdev_ops = {
 	.ndo_change_mtu		= atl1_change_mtu,
 	.ndo_fix_features	= atlx_fix_features,
 	.ndo_set_features	= atlx_set_features,
-	.ndo_do_ioctl		= atlx_ioctl,
+	.ndo_eth_ioctl		= atlx_ioctl,
 	.ndo_tx_timeout		= atlx_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= atl1_poll_controller,
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 0cc0db04c27d..b69298ddb647 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1293,7 +1293,7 @@ static const struct net_device_ops atl2_netdev_ops = {
 	.ndo_change_mtu		= atl2_change_mtu,
 	.ndo_fix_features	= atl2_fix_features,
 	.ndo_set_features	= atl2_set_features,
-	.ndo_do_ioctl		= atl2_ioctl,
+	.ndo_eth_ioctl		= atl2_ioctl,
 	.ndo_tx_timeout		= atl2_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= atl2_poll_controller,
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index ad2655efe423..fa784953c601 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2198,7 +2198,7 @@ static const struct net_device_ops b44_netdev_ops = {
 	.ndo_set_rx_mode	= b44_set_rx_mode,
 	.ndo_set_mac_address	= b44_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= b44_ioctl,
+	.ndo_eth_ioctl		= b44_ioctl,
 	.ndo_tx_timeout		= b44_tx_timeout,
 	.ndo_change_mtu		= b44_change_mtu,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 977f097fc7bf..5ec056a26cf8 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1699,7 +1699,7 @@ static const struct net_device_ops bcm_enet_ops = {
 	.ndo_start_xmit		= bcm_enet_start_xmit,
 	.ndo_set_mac_address	= bcm_enet_set_mac_address,
 	.ndo_set_rx_mode	= bcm_enet_set_multicast_list,
-	.ndo_do_ioctl		= bcm_enet_ioctl,
+	.ndo_eth_ioctl		= bcm_enet_ioctl,
 	.ndo_change_mtu		= bcm_enet_change_mtu,
 };
 
@@ -2446,7 +2446,7 @@ static const struct net_device_ops bcm_enetsw_ops = {
 	.ndo_stop		= bcm_enetsw_stop,
 	.ndo_start_xmit		= bcm_enet_start_xmit,
 	.ndo_change_mtu		= bcm_enet_change_mtu,
-	.ndo_do_ioctl		= bcm_enetsw_ioctl,
+	.ndo_eth_ioctl		= bcm_enetsw_ioctl,
 };
 
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 075f6e146b29..fe4d99abd548 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1263,7 +1263,7 @@ static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_set_rx_mode	= bgmac_set_rx_mode,
 	.ndo_set_mac_address	= bgmac_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl           = phy_do_ioctl_running,
+	.ndo_eth_ioctl           = phy_do_ioctl_running,
 	.ndo_change_mtu		= bgmac_change_mtu,
 };
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index bee6cfad9fc6..89ee1c0e9c79 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8546,7 +8546,7 @@ static const struct net_device_ops bnx2_netdev_ops = {
 	.ndo_stop		= bnx2_close,
 	.ndo_get_stats64	= bnx2_get_stats64,
 	.ndo_set_rx_mode	= bnx2_set_rx_mode,
-	.ndo_do_ioctl		= bnx2_ioctl,
+	.ndo_eth_ioctl		= bnx2_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= bnx2_change_mac_addr,
 	.ndo_change_mtu		= bnx2_change_mtu,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2acbc73dcd18..6d98134913cd 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13048,7 +13048,7 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_set_rx_mode	= bnx2x_set_rx_mode,
 	.ndo_set_mac_address	= bnx2x_change_mac_addr,
 	.ndo_validate_addr	= bnx2x_validate_addr,
-	.ndo_do_ioctl		= bnx2x_ioctl,
+	.ndo_eth_ioctl		= bnx2x_ioctl,
 	.ndo_change_mtu		= bnx2x_change_mtu,
 	.ndo_fix_features	= bnx2x_fix_features,
 	.ndo_set_features	= bnx2x_set_features,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4db162cee911..e34c362a3c58 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12667,7 +12667,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_stop		= bnxt_close,
 	.ndo_get_stats64	= bnxt_get_stats64,
 	.ndo_set_rx_mode	= bnxt_set_rx_mode,
-	.ndo_do_ioctl		= bnxt_ioctl,
+	.ndo_eth_ioctl		= bnxt_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= bnxt_change_mac_addr,
 	.ndo_change_mtu		= bnxt_change_mtu,
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index db74241935ab..63e2237e0cb4 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3659,7 +3659,7 @@ static const struct net_device_ops bcmgenet_netdev_ops = {
 	.ndo_tx_timeout		= bcmgenet_timeout,
 	.ndo_set_rx_mode	= bcmgenet_set_rx_mode,
 	.ndo_set_mac_address	= bcmgenet_set_mac_addr,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_features	= bcmgenet_set_features,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= bcmgenet_poll_controller,
diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index 5b4568c2ad1c..f38f40eb966e 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -2136,7 +2136,7 @@ static const struct net_device_ops sbmac_netdev_ops = {
 	.ndo_start_xmit		= sbmac_start_tx,
 	.ndo_set_rx_mode	= sbmac_set_rx_mode,
 	.ndo_tx_timeout		= sbmac_tx_timeout,
-	.ndo_do_ioctl		= sbmac_mii_ioctl,
+	.ndo_eth_ioctl		= sbmac_mii_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b0e49643f483..6f82eeaa4b9f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14290,7 +14290,7 @@ static const struct net_device_ops tg3_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= tg3_set_rx_mode,
 	.ndo_set_mac_address	= tg3_set_mac_addr,
-	.ndo_do_ioctl		= tg3_ioctl,
+	.ndo_eth_ioctl		= tg3_ioctl,
 	.ndo_tx_timeout		= tg3_tx_timeout,
 	.ndo_change_mtu		= tg3_change_mtu,
 	.ndo_fix_features	= tg3_fix_features,
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7d2fe13a52f8..181ebc235925 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3664,7 +3664,7 @@ static const struct net_device_ops macb_netdev_ops = {
 	.ndo_start_xmit		= macb_start_xmit,
 	.ndo_set_rx_mode	= macb_set_rx_mode,
 	.ndo_get_stats		= macb_get_stats,
-	.ndo_do_ioctl		= macb_ioctl,
+	.ndo_eth_ioctl		= macb_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= macb_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
@@ -4323,7 +4323,7 @@ static const struct net_device_ops at91ether_netdev_ops = {
 	.ndo_get_stats		= macb_get_stats,
 	.ndo_set_rx_mode	= macb_set_rx_mode,
 	.ndo_set_mac_address	= eth_mac_addr,
-	.ndo_do_ioctl		= macb_ioctl,
+	.ndo_eth_ioctl		= macb_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= at91ether_poll_controller,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 591229b96257..a4a5209a9386 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3223,7 +3223,7 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_vlan_rx_add_vid    = liquidio_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = liquidio_vlan_rx_kill_vid,
 	.ndo_change_mtu		= liquidio_change_mtu,
-	.ndo_do_ioctl		= liquidio_ioctl,
+	.ndo_eth_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
 	.ndo_set_vf_mac		= liquidio_set_vf_mac,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index ffddb3126a32..3085dd455a17 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1889,7 +1889,7 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_vlan_rx_add_vid    = liquidio_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = liquidio_vlan_rx_kill_vid,
 	.ndo_change_mtu		= liquidio_change_mtu,
-	.ndo_do_ioctl		= liquidio_ioctl,
+	.ndo_eth_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
 };
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 48ff6fb0eed9..30463a6d1f8c 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1373,7 +1373,7 @@ static const struct net_device_ops octeon_mgmt_ops = {
 	.ndo_start_xmit =		octeon_mgmt_xmit,
 	.ndo_set_rx_mode =		octeon_mgmt_set_rx_filtering,
 	.ndo_set_mac_address =		octeon_mgmt_set_mac_address,
-	.ndo_do_ioctl =			octeon_mgmt_ioctl,
+	.ndo_eth_ioctl =			octeon_mgmt_ioctl,
 	.ndo_change_mtu =		octeon_mgmt_change_mtu,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller =		octeon_mgmt_poll_controller,
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index e2b290135fd9..efaaa57d4ed5 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2096,7 +2096,7 @@ static const struct net_device_ops nicvf_netdev_ops = {
 	.ndo_fix_features       = nicvf_fix_features,
 	.ndo_set_features       = nicvf_set_features,
 	.ndo_bpf		= nicvf_xdp,
-	.ndo_do_ioctl           = nicvf_ioctl,
+	.ndo_eth_ioctl           = nicvf_ioctl,
 	.ndo_set_rx_mode        = nicvf_set_rx_mode,
 };
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 512da98019c6..e7575d41f4f5 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -924,7 +924,7 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_get_stats		= t1_get_stats,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= t1_set_rxmode,
-	.ndo_do_ioctl		= t1_ioctl,
+	.ndo_eth_ioctl		= t1_ioctl,
 	.ndo_change_mtu		= t1_change_mtu,
 	.ndo_set_mac_address	= t1_set_mac_addr,
 	.ndo_fix_features	= t1_fix_features,
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index eae893d7d840..72af9d2a00ae 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3184,7 +3184,7 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_get_stats		= cxgb_get_stats,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= cxgb_set_rxmode,
-	.ndo_do_ioctl		= cxgb_ioctl,
+	.ndo_eth_ioctl		= cxgb_ioctl,
 	.ndo_siocdevprivate	= cxgb_siocdevprivate,
 	.ndo_change_mtu		= cxgb_change_mtu,
 	.ndo_set_mac_address	= cxgb_set_mac_addr,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index dbf9a0e6601d..aa8573202c37 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3872,7 +3872,7 @@ static const struct net_device_ops cxgb4_netdev_ops = {
 	.ndo_set_mac_address  = cxgb_set_mac_addr,
 	.ndo_set_features     = cxgb_set_features,
 	.ndo_validate_addr    = eth_validate_addr,
-	.ndo_do_ioctl         = cxgb_ioctl,
+	.ndo_eth_ioctl         = cxgb_ioctl,
 	.ndo_change_mtu       = cxgb_change_mtu,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller  = cxgb_netpoll,
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 2820a0bb971b..2842628ad2c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2837,7 +2837,7 @@ static const struct net_device_ops cxgb4vf_netdev_ops	= {
 	.ndo_set_rx_mode	= cxgb4vf_set_rxmode,
 	.ndo_set_mac_address	= cxgb4vf_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= cxgb4vf_do_ioctl,
+	.ndo_eth_ioctl		= cxgb4vf_do_ioctl,
 	.ndo_change_mtu		= cxgb4vf_change_mtu,
 	.ndo_fix_features	= cxgb4vf_fix_features,
 	.ndo_set_features	= cxgb4vf_set_features,
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 9f5e5ec69991..072fac5f5d24 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -733,7 +733,7 @@ static const struct net_device_ops ep93xx_netdev_ops = {
 	.ndo_open		= ep93xx_open,
 	.ndo_stop		= ep93xx_close,
 	.ndo_start_xmit		= ep93xx_xmit,
-	.ndo_do_ioctl		= ep93xx_ioctl,
+	.ndo_eth_ioctl		= ep93xx_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 };
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 2a8bf53c2f75..e842de6f6635 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1372,7 +1372,7 @@ static const struct net_device_ops dm9000_netdev_ops = {
 	.ndo_start_xmit		= dm9000_start_xmit,
 	.ndo_tx_timeout		= dm9000_timeout,
 	.ndo_set_rx_mode	= dm9000_hash_table,
-	.ndo_do_ioctl		= dm9000_ioctl,
+	.ndo_eth_ioctl		= dm9000_ioctl,
 	.ndo_set_features	= dm9000_set_features,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index c1dcd6ca1457..fcedd733bacb 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1271,7 +1271,7 @@ static const struct net_device_ops tulip_netdev_ops = {
 	.ndo_tx_timeout		= tulip_tx_timeout,
 	.ndo_stop		= tulip_close,
 	.ndo_get_stats		= tulip_get_stats,
-	.ndo_do_ioctl 		= private_ioctl,
+	.ndo_eth_ioctl		= private_ioctl,
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index f6ff1f76eacb..07a48f6bf0fa 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -341,7 +341,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_start_xmit		= start_tx,
 	.ndo_get_stats		= get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_tx_timeout		= tx_timeout,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 734acb834c98..202ecb132053 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -95,7 +95,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_set_rx_mode	= set_multicast,
-	.ndo_do_ioctl		= rio_ioctl,
+	.ndo_eth_ioctl		= rio_ioctl,
 	.ndo_tx_timeout		= rio_tx_timeout,
 };
 
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index ee0ca712dd1c..c36d186dffed 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -479,7 +479,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_start_xmit		= start_tx,
 	.ndo_get_stats 		= get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl 		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_tx_timeout		= tx_timeout,
 	.ndo_change_mtu		= change_mtu,
 	.ndo_set_mac_address 	= sundance_set_mac_addr,
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 48c6eb142dcc..6c51cf991dad 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -742,7 +742,7 @@ static const struct net_device_ops dnet_netdev_ops = {
 	.ndo_stop		= dnet_close,
 	.ndo_get_stats		= dnet_get_stats,
 	.ndo_start_xmit		= dnet_start_xmit,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index e1b43b07755b..ed1ed48e7483 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1009,7 +1009,7 @@ static const struct ethtool_ops ethoc_ethtool_ops = {
 static const struct net_device_ops ethoc_netdev_ops = {
 	.ndo_open = ethoc_open,
 	.ndo_stop = ethoc_stop,
-	.ndo_do_ioctl = ethoc_ioctl,
+	.ndo_eth_ioctl = ethoc_ioctl,
 	.ndo_set_mac_address = ethoc_set_mac_address,
 	.ndo_set_rx_mode = ethoc_set_multicast_list,
 	.ndo_change_mtu = ethoc_change_mtu,
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 11dbbfd38770..ff76e401a014 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1616,7 +1616,7 @@ static const struct net_device_ops ftgmac100_netdev_ops = {
 	.ndo_start_xmit		= ftgmac100_hard_start_xmit,
 	.ndo_set_mac_address	= ftgmac100_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= ftgmac100_tx_timeout,
 	.ndo_set_rx_mode	= ftgmac100_set_rx_mode,
 	.ndo_set_features	= ftgmac100_set_features,
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 5a1a8f2ea63c..8a341e2d5833 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -1043,7 +1043,7 @@ static const struct net_device_ops ftmac100_netdev_ops = {
 	.ndo_start_xmit		= ftmac100_hard_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= ftmac100_do_ioctl,
+	.ndo_eth_ioctl		= ftmac100_do_ioctl,
 };
 
 /******************************************************************************
diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index 0f141c14d72d..25c91b3c5fd3 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -463,7 +463,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_start_xmit		= start_tx,
 	.ndo_get_stats 		= get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl		= mii_ioctl,
+	.ndo_eth_ioctl		= mii_ioctl,
 	.ndo_tx_timeout		= fealnx_tx_timeout,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e6826561cf11..685d2d8a3b36 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -3157,7 +3157,7 @@ static const struct net_device_ops dpaa_ops = {
 	.ndo_set_mac_address = dpaa_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
-	.ndo_do_ioctl = dpaa_ioctl,
+	.ndo_eth_ioctl = dpaa_ioctl,
 	.ndo_setup_tc = dpaa_setup_tc,
 	.ndo_change_mtu = dpaa_change_mtu,
 	.ndo_bpf = dpaa_xdp,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 973352393bd4..f664021c3ad1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2594,7 +2594,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_get_stats64 = dpaa2_eth_get_stats,
 	.ndo_set_rx_mode = dpaa2_eth_set_rx_mode,
 	.ndo_set_features = dpaa2_eth_set_features,
-	.ndo_do_ioctl = dpaa2_eth_ioctl,
+	.ndo_eth_ioctl = dpaa2_eth_ioctl,
 	.ndo_change_mtu = dpaa2_eth_change_mtu,
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c84f6c226743..60d94e0a07d6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -735,7 +735,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_vlan	= enetc_pf_set_vf_vlan,
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
-	.ndo_do_ioctl		= enetc_ioctl,
+	.ndo_eth_ioctl		= enetc_ioctl,
 	.ndo_setup_tc		= enetc_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 03090ba7e226..1a9d1e8b772c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -99,7 +99,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_get_stats		= enetc_get_stats,
 	.ndo_set_mac_address	= enetc_vf_set_mac_addr,
 	.ndo_set_features	= enetc_vf_set_features,
-	.ndo_do_ioctl		= enetc_ioctl,
+	.ndo_eth_ioctl		= enetc_ioctl,
 	.ndo_setup_tc		= enetc_setup_tc,
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 8aea707a65a7..e361be85f26f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3280,7 +3280,7 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
 	.ndo_set_mac_address	= fec_set_mac_address,
-	.ndo_do_ioctl		= fec_enet_ioctl,
+	.ndo_eth_ioctl		= fec_enet_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index 02c47658a215..73ff359a15f1 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -792,7 +792,7 @@ static const struct net_device_ops mpc52xx_fec_netdev_ops = {
 	.ndo_set_rx_mode = mpc52xx_fec_set_multicast_list,
 	.ndo_set_mac_address = mpc52xx_fec_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = phy_do_ioctl,
+	.ndo_eth_ioctl = phy_do_ioctl,
 	.ndo_tx_timeout = mpc52xx_fec_tx_timeout,
 	.ndo_get_stats = mpc52xx_fec_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 6ee325ad35c5..2db6e38a772e 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -900,7 +900,7 @@ static const struct net_device_ops fs_enet_netdev_ops = {
 	.ndo_start_xmit		= fs_enet_start_xmit,
 	.ndo_tx_timeout		= fs_timeout,
 	.ndo_set_rx_mode	= fs_set_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 9646483137c4..af6ad94bf24a 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3184,7 +3184,7 @@ static const struct net_device_ops gfar_netdev_ops = {
 	.ndo_set_features = gfar_set_features,
 	.ndo_set_rx_mode = gfar_set_multi,
 	.ndo_tx_timeout = gfar_timeout,
-	.ndo_do_ioctl = gfar_ioctl,
+	.ndo_eth_ioctl = gfar_ioctl,
 	.ndo_get_stats64 = gfar_get_stats64,
 	.ndo_change_carrier = fixed_phy_change_carrier,
 	.ndo_set_mac_address = gfar_set_mac_addr,
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 0acfafb73db1..3eb288d10b0c 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3516,7 +3516,7 @@ static const struct net_device_ops ucc_geth_netdev_ops = {
 	.ndo_set_mac_address	= ucc_geth_set_mac_addr,
 	.ndo_set_rx_mode	= ucc_geth_set_multi,
 	.ndo_tx_timeout		= ucc_geth_timeout,
-	.ndo_do_ioctl		= ucc_geth_ioctl,
+	.ndo_eth_ioctl		= ucc_geth_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= ucc_netpoll,
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 3c4db4a6b431..22bf914f2dbd 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -685,7 +685,7 @@ static const struct net_device_ops hisi_femac_netdev_ops = {
 	.ndo_open		= hisi_femac_net_open,
 	.ndo_stop		= hisi_femac_net_close,
 	.ndo_start_xmit		= hisi_femac_net_xmit,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= hisi_femac_set_mac_address,
 	.ndo_set_rx_mode	= hisi_femac_net_set_rx_mode,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index ad534f9e41ab..343c605c4be8 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1945,7 +1945,7 @@ static const struct net_device_ops hns_nic_netdev_ops = {
 	.ndo_tx_timeout = hns_nic_net_timeout,
 	.ndo_set_mac_address = hns_nic_net_set_mac_address,
 	.ndo_change_mtu = hns_nic_change_mtu,
-	.ndo_do_ioctl = phy_do_ioctl_running,
+	.ndo_eth_ioctl = phy_do_ioctl_running,
 	.ndo_set_features = hns_nic_set_features,
 	.ndo_fix_features = hns_nic_fix_features,
 	.ndo_get_stats64 = hns_nic_get_stats64,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cdb5f14fb6bc..cb8d5da3654f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2852,7 +2852,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_start_xmit		= hns3_nic_net_xmit,
 	.ndo_tx_timeout		= hns3_nic_net_timeout,
 	.ndo_set_mac_address	= hns3_nic_net_set_mac_address,
-	.ndo_do_ioctl		= hns3_nic_do_ioctl,
+	.ndo_eth_ioctl		= hns3_nic_do_ioctl,
 	.ndo_change_mtu		= hns3_nic_change_mtu,
 	.ndo_set_features	= hns3_nic_set_features,
 	.ndo_features_check	= hns3_features_check,
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 471be6ec7e8a..664a91af662d 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3011,7 +3011,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_stop		= emac_close,
 	.ndo_get_stats		= emac_stats,
 	.ndo_set_rx_mode	= emac_set_multicast_list,
-	.ndo_do_ioctl		= emac_ioctl,
+	.ndo_eth_ioctl		= emac_ioctl,
 	.ndo_tx_timeout		= emac_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= emac_set_mac_address,
@@ -3023,7 +3023,7 @@ static const struct net_device_ops emac_gige_netdev_ops = {
 	.ndo_stop		= emac_close,
 	.ndo_get_stats		= emac_stats,
 	.ndo_set_rx_mode	= emac_set_multicast_list,
-	.ndo_do_ioctl		= emac_ioctl,
+	.ndo_eth_ioctl		= emac_ioctl,
 	.ndo_tx_timeout		= emac_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= emac_set_mac_address,
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 737ba85e409f..3d9b4f99d357 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1630,7 +1630,7 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 	.ndo_stop		= ibmveth_close,
 	.ndo_start_xmit		= ibmveth_start_xmit,
 	.ndo_set_rx_mode	= ibmveth_set_multicast_list,
-	.ndo_do_ioctl		= ibmveth_ioctl,
+	.ndo_eth_ioctl		= ibmveth_ioctl,
 	.ndo_change_mtu		= ibmveth_change_mtu,
 	.ndo_fix_features	= ibmveth_fix_features,
 	.ndo_set_features	= ibmveth_set_features,
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1ec924c556c5..373eb027b925 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2809,7 +2809,7 @@ static const struct net_device_ops e100_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= e100_set_multicast_list,
 	.ndo_set_mac_address	= e100_set_mac_address,
-	.ndo_do_ioctl		= e100_do_ioctl,
+	.ndo_eth_ioctl		= e100_do_ioctl,
 	.ndo_tx_timeout		= e100_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= e100_netpoll,
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index c2a109126c27..bed4f040face 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -832,7 +832,7 @@ static const struct net_device_ops e1000_netdev_ops = {
 	.ndo_set_mac_address	= e1000_set_mac,
 	.ndo_tx_timeout		= e1000_tx_timeout,
 	.ndo_change_mtu		= e1000_change_mtu,
-	.ndo_do_ioctl		= e1000_ioctl,
+	.ndo_eth_ioctl		= e1000_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_vlan_rx_add_vid	= e1000_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= e1000_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 3c22b509fa79..900b3ab998bd 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7354,7 +7354,7 @@ static const struct net_device_ops e1000e_netdev_ops = {
 	.ndo_set_rx_mode	= e1000e_set_rx_mode,
 	.ndo_set_mac_address	= e1000_set_mac,
 	.ndo_change_mtu		= e1000_change_mtu,
-	.ndo_do_ioctl		= e1000_ioctl,
+	.ndo_eth_ioctl		= e1000_ioctl,
 	.ndo_tx_timeout		= e1000_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 53c1fbeee62a..5b4012a09acb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13256,7 +13256,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= i40e_set_mac,
 	.ndo_change_mtu		= i40e_change_mtu,
-	.ndo_do_ioctl		= i40e_ioctl,
+	.ndo_eth_ioctl		= i40e_ioctl,
 	.ndo_tx_timeout		= i40e_tx_timeout,
 	.ndo_vlan_rx_add_vid	= i40e_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= i40e_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ef8d1815af56..33916ed9e874 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6558,12 +6558,12 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 }
 
 /**
- * ice_do_ioctl - Access the hwtstamp interface
+ * ice_eth_ioctl - Access the hwtstamp interface
  * @netdev: network interface device structure
  * @ifr: interface request data
  * @cmd: ioctl command
  */
-static int ice_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+static int ice_eth_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_pf *pf = np->vsi->back;
@@ -7229,7 +7229,7 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
 	.ndo_set_tx_maxrate = ice_set_tx_maxrate,
-	.ndo_do_ioctl = ice_do_ioctl,
+	.ndo_eth_ioctl = ice_eth_ioctl,
 	.ndo_set_vf_spoofchk = ice_set_vf_spoofchk,
 	.ndo_set_vf_mac = ice_set_vf_mac,
 	.ndo_get_vf_config = ice_get_vf_cfg,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 171a7a629b20..751de06019a0 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2991,7 +2991,7 @@ static const struct net_device_ops igb_netdev_ops = {
 	.ndo_set_rx_mode	= igb_set_rx_mode,
 	.ndo_set_mac_address	= igb_set_mac,
 	.ndo_change_mtu		= igb_change_mtu,
-	.ndo_do_ioctl		= igb_ioctl,
+	.ndo_eth_ioctl		= igb_ioctl,
 	.ndo_tx_timeout		= igb_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_vlan_rx_add_vid	= igb_vlan_rx_add_vid,
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 1bbe9862a758..d32e72d953c8 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2657,7 +2657,7 @@ static const struct net_device_ops igbvf_netdev_ops = {
 	.ndo_set_rx_mode	= igbvf_set_rx_mode,
 	.ndo_set_mac_address	= igbvf_set_mac,
 	.ndo_change_mtu		= igbvf_change_mtu,
-	.ndo_do_ioctl		= igbvf_ioctl,
+	.ndo_eth_ioctl		= igbvf_ioctl,
 	.ndo_tx_timeout		= igbvf_tx_timeout,
 	.ndo_vlan_rx_add_vid	= igbvf_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= igbvf_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 5c95bf82eaf7..b7aab35c1132 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6013,7 +6013,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
 	.ndo_features_check	= igc_features_check,
-	.ndo_do_ioctl		= igc_ioctl,
+	.ndo_eth_ioctl		= igc_ioctl,
 	.ndo_setup_tc		= igc_setup_tc,
 	.ndo_bpf		= igc_bpf,
 	.ndo_xdp_xmit		= igc_xdp_xmit,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 14aea40da50f..24e06ba6f5e9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10247,7 +10247,7 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_set_tx_maxrate	= ixgbe_tx_maxrate,
 	.ndo_vlan_rx_add_vid	= ixgbe_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= ixgbe_vlan_rx_kill_vid,
-	.ndo_do_ioctl		= ixgbe_ioctl,
+	.ndo_eth_ioctl		= ixgbe_ioctl,
 	.ndo_set_vf_mac		= ixgbe_ndo_set_vf_mac,
 	.ndo_set_vf_vlan	= ixgbe_ndo_set_vf_vlan,
 	.ndo_set_vf_rate	= ixgbe_ndo_set_vf_bw,
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index f1b9284e0bea..1251b74fe0e2 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2901,7 +2901,7 @@ static const struct net_device_ops jme_netdev_ops = {
 	.ndo_open		= jme_open,
 	.ndo_stop		= jme_close,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= jme_ioctl,
+	.ndo_eth_ioctl		= jme_ioctl,
 	.ndo_start_xmit		= jme_start_xmit,
 	.ndo_set_mac_address	= jme_set_macaddr,
 	.ndo_set_rx_mode	= jme_set_multi,
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index b30a45725374..3e9f324f1061 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1272,7 +1272,7 @@ static const struct net_device_ops korina_netdev_ops = {
 	.ndo_start_xmit		= korina_send_packet,
 	.ndo_set_rx_mode	= korina_multicast_list,
 	.ndo_tx_timeout		= korina_tx_timeout,
-	.ndo_do_ioctl		= korina_ioctl,
+	.ndo_eth_ioctl		= korina_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 2d0c52f7106b..62f8c5212182 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -609,7 +609,7 @@ static const struct net_device_ops ltq_eth_netdev_ops = {
 	.ndo_stop = ltq_etop_stop,
 	.ndo_start_xmit = ltq_etop_tx,
 	.ndo_change_mtu = ltq_etop_change_mtu,
-	.ndo_do_ioctl = phy_do_ioctl,
+	.ndo_eth_ioctl = phy_do_ioctl,
 	.ndo_set_mac_address = ltq_etop_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = ltq_etop_set_multicast_list,
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index d207bfcaf31d..6502c5c2ebca 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3060,7 +3060,7 @@ static const struct net_device_ops mv643xx_eth_netdev_ops = {
 	.ndo_set_rx_mode	= mv643xx_eth_set_rx_mode,
 	.ndo_set_mac_address	= mv643xx_eth_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= mv643xx_eth_ioctl,
+	.ndo_eth_ioctl		= mv643xx_eth_ioctl,
 	.ndo_change_mtu		= mv643xx_eth_change_mtu,
 	.ndo_set_features	= mv643xx_eth_set_features,
 	.ndo_tx_timeout		= mv643xx_eth_tx_timeout,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 975a1a77d445..ff8db311963c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4994,7 +4994,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_change_mtu      = mvneta_change_mtu,
 	.ndo_fix_features    = mvneta_fix_features,
 	.ndo_get_stats64     = mvneta_get_stats64,
-	.ndo_do_ioctl        = mvneta_ioctl,
+	.ndo_eth_ioctl        = mvneta_ioctl,
 	.ndo_bpf	     = mvneta_xdp,
 	.ndo_xdp_xmit        = mvneta_xdp_xmit,
 	.ndo_setup_tc	     = mvneta_setup_tc,
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 878fb17dea41..99bd8b8aa0e2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5702,7 +5702,7 @@ static const struct net_device_ops mvpp2_netdev_ops = {
 	.ndo_set_mac_address	= mvpp2_set_mac_address,
 	.ndo_change_mtu		= mvpp2_change_mtu,
 	.ndo_get_stats64	= mvpp2_get_stats64,
-	.ndo_do_ioctl		= mvpp2_ioctl,
+	.ndo_eth_ioctl		= mvpp2_ioctl,
 	.ndo_vlan_rx_add_vid	= mvpp2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= mvpp2_vlan_rx_kill_vid,
 	.ndo_set_features	= mvpp2_set_features,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f300b807a85b..3f03bbdd8d04 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2326,7 +2326,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_set_features	= otx2_set_features,
 	.ndo_tx_timeout		= otx2_tx_timeout,
 	.ndo_get_stats64	= otx2_get_stats64,
-	.ndo_do_ioctl		= otx2_ioctl,
+	.ndo_eth_ioctl		= otx2_ioctl,
 	.ndo_set_vf_mac		= otx2_set_vf_mac,
 	.ndo_set_vf_vlan	= otx2_set_vf_vlan,
 	.ndo_get_vf_config	= otx2_get_vf_config,
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 9b48ae4bac39..fab53c9b8380 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1377,7 +1377,7 @@ static const struct net_device_ops pxa168_eth_netdev_ops = {
 	.ndo_set_rx_mode	= pxa168_eth_set_rx_mode,
 	.ndo_set_mac_address	= pxa168_eth_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_change_mtu		= pxa168_eth_change_mtu,
 	.ndo_tx_timeout		= pxa168_eth_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index d4bb27ba1419..150c06ee3627 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3787,7 +3787,7 @@ static const struct net_device_ops skge_netdev_ops = {
 	.ndo_open		= skge_up,
 	.ndo_stop		= skge_down,
 	.ndo_start_xmit		= skge_xmit_frame,
-	.ndo_do_ioctl		= skge_ioctl,
+	.ndo_eth_ioctl		= skge_ioctl,
 	.ndo_get_stats		= skge_get_stats,
 	.ndo_tx_timeout		= skge_tx_timeout,
 	.ndo_change_mtu		= skge_change_mtu,
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 8b8bff59c8fe..743ca96527fa 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4693,7 +4693,7 @@ static const struct net_device_ops sky2_netdev_ops[2] = {
 	.ndo_open		= sky2_open,
 	.ndo_stop		= sky2_close,
 	.ndo_start_xmit		= sky2_xmit_frame,
-	.ndo_do_ioctl		= sky2_ioctl,
+	.ndo_eth_ioctl		= sky2_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= sky2_set_mac_address,
 	.ndo_set_rx_mode	= sky2_set_multicast,
@@ -4710,7 +4710,7 @@ static const struct net_device_ops sky2_netdev_ops[2] = {
 	.ndo_open		= sky2_open,
 	.ndo_stop		= sky2_close,
 	.ndo_start_xmit		= sky2_xmit_frame,
-	.ndo_do_ioctl		= sky2_ioctl,
+	.ndo_eth_ioctl		= sky2_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= sky2_set_mac_address,
 	.ndo_set_rx_mode	= sky2_set_multicast,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 64adfd24e134..398c23cec815 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2933,7 +2933,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 	.ndo_start_xmit		= mtk_start_xmit,
 	.ndo_set_mac_address	= mtk_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= mtk_do_ioctl,
+	.ndo_eth_ioctl		= mtk_do_ioctl,
 	.ndo_change_mtu		= mtk_change_mtu,
 	.ndo_tx_timeout		= mtk_tx_timeout,
 	.ndo_get_stats64        = mtk_get_stats64,
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 96d2891f1675..1d5dd2015453 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1162,7 +1162,7 @@ static const struct net_device_ops mtk_star_netdev_ops = {
 	.ndo_start_xmit		= mtk_star_netdev_start_xmit,
 	.ndo_get_stats64	= mtk_star_netdev_get_stats64,
 	.ndo_set_rx_mode	= mtk_star_set_rx_mode,
-	.ndo_do_ioctl		= mtk_star_netdev_ioctl,
+	.ndo_eth_ioctl		= mtk_star_netdev_ioctl,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 5d0c9c62382d..a2f61a87cef8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2828,7 +2828,7 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_set_mac_address	= mlx4_en_set_mac,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= mlx4_en_change_mtu,
-	.ndo_do_ioctl		= mlx4_en_ioctl,
+	.ndo_eth_ioctl		= mlx4_en_ioctl,
 	.ndo_tx_timeout		= mlx4_en_tx_timeout,
 	.ndo_vlan_rx_add_vid	= mlx4_en_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= mlx4_en_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b9a0459b58f1..b6c1e3124f96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4417,7 +4417,7 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_set_features        = mlx5e_set_features,
 	.ndo_fix_features        = mlx5e_fix_features,
 	.ndo_change_mtu          = mlx5e_change_nic_mtu,
-	.ndo_do_ioctl            = mlx5e_ioctl,
+	.ndo_eth_ioctl            = mlx5e_ioctl,
 	.ndo_set_tx_maxrate      = mlx5e_set_tx_maxrate,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 6535c636ae22..a126cbc6f0d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -50,7 +50,7 @@ static const struct net_device_ops mlx5i_netdev_ops = {
 	.ndo_init                = mlx5i_dev_init,
 	.ndo_uninit              = mlx5i_dev_cleanup,
 	.ndo_change_mtu          = mlx5i_change_mtu,
-	.ndo_do_ioctl            = mlx5i_ioctl,
+	.ndo_eth_ioctl            = mlx5i_ioctl,
 };
 
 /* IPoIB mlx5 netdev profile */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 18ee21b06a00..5308f23702bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -149,7 +149,7 @@ static const struct net_device_ops mlx5i_pkey_netdev_ops = {
 	.ndo_get_stats64         = mlx5i_get_stats,
 	.ndo_uninit              = mlx5i_pkey_dev_cleanup,
 	.ndo_change_mtu          = mlx5i_pkey_change_mtu,
-	.ndo_do_ioctl            = mlx5i_pkey_ioctl,
+	.ndo_eth_ioctl            = mlx5i_pkey_ioctl,
 };
 
 /* Child NDOs */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index a0a059e0154f..d22219613719 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -199,7 +199,7 @@ static int mlxbf_gige_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int mlxbf_gige_do_ioctl(struct net_device *netdev,
+static int mlxbf_gige_eth_ioctl(struct net_device *netdev,
 			       struct ifreq *ifr, int cmd)
 {
 	if (!(netif_running(netdev)))
@@ -253,7 +253,7 @@ static const struct net_device_ops mlxbf_gige_netdev_ops = {
 	.ndo_start_xmit		= mlxbf_gige_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= mlxbf_gige_do_ioctl,
+	.ndo_eth_ioctl		= mlxbf_gige_eth_ioctl,
 	.ndo_set_rx_mode        = mlxbf_gige_set_rx_mode,
 	.ndo_get_stats64        = mlxbf_gige_get_stats64,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 88699e678544..081408e892d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1207,7 +1207,7 @@ static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= mlxsw_sp_port_kill_vid,
 	.ndo_set_features	= mlxsw_sp_set_features,
 	.ndo_get_devlink_port	= mlxsw_sp_port_get_devlink_port,
-	.ndo_do_ioctl		= mlxsw_sp_port_ioctl,
+	.ndo_eth_ioctl		= mlxsw_sp_port_ioctl,
 };
 
 static int
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 831518466de2..3f69bb59ba49 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -689,7 +689,7 @@ static int ks8851_net_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 static const struct net_device_ops ks8851_netdev_ops = {
 	.ndo_open		= ks8851_net_open,
 	.ndo_stop		= ks8851_net_stop,
-	.ndo_do_ioctl		= ks8851_net_ioctl,
+	.ndo_eth_ioctl		= ks8851_net_ioctl,
 	.ndo_start_xmit		= ks8851_start_xmit,
 	.ndo_set_mac_address	= ks8851_set_mac_address,
 	.ndo_set_rx_mode	= ks8851_set_rx_mode,
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 7945eb5e2fe8..a0ee155f9f51 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6738,7 +6738,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_set_features	= netdev_set_features,
 	.ndo_set_mac_address	= netdev_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_set_rx_mode	= netdev_set_rx_mode,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= netdev_netpoll,
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index dae10328c6cf..9e8561cdc32a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2655,7 +2655,7 @@ static const struct net_device_ops lan743x_netdev_ops = {
 	.ndo_open		= lan743x_netdev_open,
 	.ndo_stop		= lan743x_netdev_close,
 	.ndo_start_xmit		= lan743x_netdev_xmit_frame,
-	.ndo_do_ioctl		= lan743x_netdev_ioctl,
+	.ndo_eth_ioctl		= lan743x_netdev_ioctl,
 	.ndo_set_rx_mode	= lan743x_netdev_set_multicast,
 	.ndo_change_mtu		= lan743x_netdev_change_mtu,
 	.ndo_get_stats64	= lan743x_netdev_get_stats64,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c52f175df389..de900ea70fd4 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -823,7 +823,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
 	.ndo_set_features		= ocelot_set_features,
 	.ndo_setup_tc			= ocelot_setup_tc,
-	.ndo_do_ioctl			= ocelot_ioctl,
+	.ndo_eth_ioctl			= ocelot_ioctl,
 	.ndo_get_devlink_port		= ocelot_get_devlink_port,
 };
 
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 51b4b25d15ad..bd9d026e609d 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -790,7 +790,7 @@ static const struct net_device_ops natsemi_netdev_ops = {
 	.ndo_get_stats		= get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_change_mtu		= natsemi_change_mtu,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_tx_timeout 	= ns_tx_timeout,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 0b017d4f5c08..09c0e839cca5 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7625,7 +7625,7 @@ static const struct net_device_ops s2io_netdev_ops = {
 	.ndo_start_xmit    	= s2io_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= s2io_ndo_set_multicast,
-	.ndo_do_ioctl	   	= s2io_ioctl,
+	.ndo_eth_ioctl		= s2io_ioctl,
 	.ndo_set_mac_address    = s2io_set_mac_addr,
 	.ndo_change_mtu	   	= s2io_change_mtu,
 	.ndo_set_features	= s2io_set_features,
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 82eef4c72f01..20fb4ad29865 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3339,7 +3339,7 @@ static const struct net_device_ops vxge_netdev_ops = {
 	.ndo_start_xmit         = vxge_xmit,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_rx_mode	= vxge_set_multicast,
-	.ndo_do_ioctl           = vxge_ioctl,
+	.ndo_eth_ioctl           = vxge_ioctl,
 	.ndo_set_mac_address    = vxge_set_mac_addr,
 	.ndo_change_mtu         = vxge_change_mtu,
 	.ndo_fix_features	= vxge_fix_features,
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 64c6842bd452..d29fe562b3de 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1219,7 +1219,7 @@ static const struct net_device_ops lpc_netdev_ops = {
 	.ndo_stop		= lpc_eth_close,
 	.ndo_start_xmit		= lpc_eth_hard_start_xmit,
 	.ndo_set_rx_mode	= lpc_eth_set_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= lpc_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index e351f3d1608f..bc35d5703bd2 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2333,7 +2333,7 @@ static const struct net_device_ops pch_gbe_netdev_ops = {
 	.ndo_tx_timeout = pch_gbe_tx_timeout,
 	.ndo_change_mtu = pch_gbe_change_mtu,
 	.ndo_set_features = pch_gbe_set_features,
-	.ndo_do_ioctl = pch_gbe_ioctl,
+	.ndo_eth_ioctl = pch_gbe_ioctl,
 	.ndo_set_rx_mode = pch_gbe_set_multi,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = pch_gbe_netpoll,
diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
index 94823c5f7dff..1a6336a56d3d 100644
--- a/drivers/net/ethernet/packetengines/hamachi.c
+++ b/drivers/net/ethernet/packetengines/hamachi.c
@@ -573,7 +573,7 @@ static const struct net_device_ops hamachi_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_tx_timeout		= hamachi_tx_timeout,
-	.ndo_do_ioctl		= hamachi_ioctl,
+	.ndo_eth_ioctl		= hamachi_ioctl,
 	.ndo_siocdevprivate	= hamachi_siocdevprivate,
 };
 
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index d1dd9bc1bc7f..f5cd8f51be7c 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -362,7 +362,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
-	.ndo_do_ioctl 		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_tx_timeout 	= yellowfin_tx_timeout,
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index af3a5368529c..537c2907b91e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2264,7 +2264,7 @@ static int ionic_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int ionic_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+static int ionic_eth_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
@@ -2526,7 +2526,7 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
-	.ndo_do_ioctl		= ionic_do_ioctl,
+	.ndo_eth_ioctl		= ionic_eth_ioctl,
 	.ndo_start_xmit		= ionic_start_xmit,
 	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_ndo_set_rx_mode,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 01ac1e93d27a..173878696143 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -644,7 +644,7 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_set_mac_address	= qede_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= qede_change_mtu,
-	.ndo_do_ioctl		= qede_ioctl,
+	.ndo_eth_ioctl		= qede_ioctl,
 	.ndo_tx_timeout		= qede_tx_timeout,
 #ifdef CONFIG_QED_SRIOV
 	.ndo_set_vf_mac		= qede_set_vf_mac,
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index ad655f0a4965..9015a38eaced 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -377,7 +377,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_start_xmit		= emac_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu		= emac_change_mtu,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_tx_timeout		= emac_tx_timeout,
 	.ndo_get_stats64	= emac_get_stats64,
 	.ndo_set_features       = emac_set_features,
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 47e9998b62f0..4b2eca5e08e2 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -954,7 +954,7 @@ static const struct net_device_ops r6040_netdev_ops = {
 	.ndo_set_rx_mode	= r6040_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= r6040_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= r6040_poll_controller,
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 9677e257e9a1..edc61906694f 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1869,7 +1869,7 @@ static const struct net_device_ops cp_netdev_ops = {
 	.ndo_set_mac_address 	= cp_set_mac_address,
 	.ndo_set_rx_mode	= cp_set_rx_mode,
 	.ndo_get_stats		= cp_get_stats,
-	.ndo_do_ioctl		= cp_ioctl,
+	.ndo_eth_ioctl		= cp_ioctl,
 	.ndo_start_xmit		= cp_start_xmit,
 	.ndo_tx_timeout		= cp_tx_timeout,
 	.ndo_set_features	= cp_set_features,
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index f0608f050050..2e6923cc653e 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -932,7 +932,7 @@ static const struct net_device_ops rtl8139_netdev_ops = {
 	.ndo_set_mac_address 	= rtl8139_set_mac_address,
 	.ndo_start_xmit		= rtl8139_start_xmit,
 	.ndo_set_rx_mode	= rtl8139_set_rx_mode,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_tx_timeout		= rtl8139_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= rtl8139_poll_controller,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c7af5bc3b8af..fa2dab6980bb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4979,7 +4979,7 @@ static const struct net_device_ops rtl_netdev_ops = {
 	.ndo_fix_features	= rtl8169_fix_features,
 	.ndo_set_features	= rtl8169_set_features,
 	.ndo_set_mac_address	= rtl_set_mac_address,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode	= rtl_set_rx_mode,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= rtl8169_netpoll,
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 805397088850..f4dfe9f71d06 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1872,7 +1872,7 @@ static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_get_stats		= ravb_get_stats,
 	.ndo_set_rx_mode	= ravb_set_rx_mode,
 	.ndo_tx_timeout		= ravb_tx_timeout,
-	.ndo_do_ioctl		= ravb_do_ioctl,
+	.ndo_eth_ioctl		= ravb_do_ioctl,
 	.ndo_change_mtu		= ravb_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 840478692a37..6c8ba916d1a6 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3141,7 +3141,7 @@ static const struct net_device_ops sh_eth_netdev_ops = {
 	.ndo_get_stats		= sh_eth_get_stats,
 	.ndo_set_rx_mode	= sh_eth_set_rx_mode,
 	.ndo_tx_timeout		= sh_eth_tx_timeout,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_change_mtu		= sh_eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
@@ -3157,7 +3157,7 @@ static const struct net_device_ops sh_eth_netdev_ops_tsu = {
 	.ndo_vlan_rx_add_vid	= sh_eth_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= sh_eth_vlan_rx_kill_vid,
 	.ndo_tx_timeout		= sh_eth_tx_timeout,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_change_mtu		= sh_eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 090bcd2fb758..6781aa636d58 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1964,7 +1964,7 @@ static const struct net_device_ops sxgbe_netdev_ops = {
 	.ndo_set_features	= sxgbe_set_features,
 	.ndo_set_rx_mode	= sxgbe_set_rx_mode,
 	.ndo_tx_timeout		= sxgbe_tx_timeout,
-	.ndo_do_ioctl		= sxgbe_ioctl,
+	.ndo_eth_ioctl		= sxgbe_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= sxgbe_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 37fcf2eb0741..a295e2621cf3 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -591,7 +591,7 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_tx_timeout		= efx_watchdog,
 	.ndo_start_xmit		= efx_hard_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= efx_ioctl,
+	.ndo_eth_ioctl		= efx_ioctl,
 	.ndo_change_mtu		= efx_change_mtu,
 	.ndo_set_mac_address	= efx_set_mac_address,
 	.ndo_set_rx_mode	= efx_set_rx_mode,
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 9ec752a43c75..c177ea0f301e 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2219,7 +2219,7 @@ static const struct net_device_ops ef4_netdev_ops = {
 	.ndo_tx_timeout		= ef4_watchdog,
 	.ndo_start_xmit		= ef4_hard_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= ef4_ioctl,
+	.ndo_eth_ioctl		= ef4_ioctl,
 	.ndo_change_mtu		= ef4_change_mtu,
 	.ndo_set_mac_address	= ef4_set_mac_address,
 	.ndo_set_rx_mode	= ef4_set_rx_mode,
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 2b29fd4cbdf4..062f7844c496 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -820,7 +820,7 @@ static const struct net_device_ops ioc3_netdev_ops = {
 	.ndo_tx_timeout		= ioc3_timeout,
 	.ndo_get_stats		= ioc3_get_stats,
 	.ndo_set_rx_mode	= ioc3_set_multicast_list,
-	.ndo_do_ioctl		= ioc3_ioctl,
+	.ndo_eth_ioctl		= ioc3_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= ioc3_set_mac_address,
 };
diff --git a/drivers/net/ethernet/sgi/meth.c b/drivers/net/ethernet/sgi/meth.c
index 0c396ecd3389..efce834d8ee6 100644
--- a/drivers/net/ethernet/sgi/meth.c
+++ b/drivers/net/ethernet/sgi/meth.c
@@ -812,7 +812,7 @@ static const struct net_device_ops meth_netdev_ops = {
 	.ndo_open		= meth_open,
 	.ndo_stop		= meth_release,
 	.ndo_start_xmit		= meth_tx,
-	.ndo_do_ioctl		= meth_ioctl,
+	.ndo_eth_ioctl		= meth_ioctl,
 	.ndo_tx_timeout		= meth_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 676b193833c0..3d1a18a01ce5 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1841,7 +1841,7 @@ static int sis190_mac_addr(struct net_device  *dev, void *p)
 static const struct net_device_ops sis190_netdev_ops = {
 	.ndo_open		= sis190_open,
 	.ndo_stop		= sis190_close,
-	.ndo_do_ioctl		= sis190_ioctl,
+	.ndo_eth_ioctl		= sis190_ioctl,
 	.ndo_start_xmit		= sis190_start_xmit,
 	.ndo_tx_timeout		= sis190_tx_timeout,
 	.ndo_set_rx_mode	= sis190_set_rx_mode,
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index ca9c00b7f588..ec6f7f993eb7 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -404,7 +404,7 @@ static const struct net_device_ops sis900_netdev_ops = {
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
-	.ndo_do_ioctl		= mii_ioctl,
+	.ndo_eth_ioctl		= mii_ioctl,
 	.ndo_tx_timeout		= sis900_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
         .ndo_poll_controller	= sis900_poll,
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 51cd7dca91cd..44daf79a8f97 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -312,7 +312,7 @@ static const struct net_device_ops epic_netdev_ops = {
 	.ndo_tx_timeout 	= epic_tx_timeout,
 	.ndo_get_stats		= epic_get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl 		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index f2a50eb3c1e0..42fc37c7887a 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -294,7 +294,7 @@ static const struct net_device_ops smc_netdev_ops = {
 	.ndo_tx_timeout 	= smc_tx_timeout,
 	.ndo_set_config 	= s9k_config,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl		= smc_ioctl,
+	.ndo_eth_ioctl		= smc_ioctl,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 556a9790cdcf..199a97339280 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2148,7 +2148,7 @@ static const struct net_device_ops smsc911x_netdev_ops = {
 	.ndo_start_xmit		= smsc911x_hard_start_xmit,
 	.ndo_get_stats		= smsc911x_get_stats,
 	.ndo_set_rx_mode	= smsc911x_set_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= smsc911x_set_mac_address,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index c1dab009415d..fdbd2a43e267 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -1482,7 +1482,7 @@ static const struct net_device_ops smsc9420_netdev_ops = {
 	.ndo_start_xmit		= smsc9420_hard_start_xmit,
 	.ndo_get_stats		= smsc9420_get_stats,
 	.ndo_set_rx_mode	= smsc9420_set_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 20d148c019d8..d15f7b3a3f10 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1831,7 +1831,7 @@ static const struct net_device_ops netsec_netdev_ops = {
 	.ndo_set_features	= netsec_netdev_set_features,
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_xdp_xmit		= netsec_xdp_xmit,
 	.ndo_bpf		= netsec_xdp,
 };
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 5eb6bb4f7b6c..ae31ed93aaf0 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1543,7 +1543,7 @@ static const struct net_device_ops ave_netdev_ops = {
 	.ndo_open		= ave_open,
 	.ndo_stop		= ave_stop,
 	.ndo_start_xmit		= ave_start_xmit,
-	.ndo_do_ioctl		= ave_ioctl,
+	.ndo_eth_ioctl		= ave_ioctl,
 	.ndo_set_rx_mode	= ave_set_rx_mode,
 	.ndo_get_stats64	= ave_get_stats64,
 	.ndo_set_mac_address	= ave_set_mac_address,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544..a2aa75cb184e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6451,7 +6451,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_set_features = stmmac_set_features,
 	.ndo_set_rx_mode = stmmac_set_rx_mode,
 	.ndo_tx_timeout = stmmac_tx_timeout,
-	.ndo_do_ioctl = stmmac_ioctl,
+	.ndo_eth_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
 	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 981685c88308..287ae4c538aa 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4876,7 +4876,7 @@ static const struct net_device_ops cas_netdev_ops = {
 	.ndo_start_xmit		= cas_start_xmit,
 	.ndo_get_stats 		= cas_get_stats,
 	.ndo_set_rx_mode	= cas_set_multicast,
-	.ndo_do_ioctl		= cas_ioctl,
+	.ndo_eth_ioctl		= cas_ioctl,
 	.ndo_tx_timeout		= cas_tx_timeout,
 	.ndo_change_mtu		= cas_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 74e748662ec0..006fd4237725 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9667,7 +9667,7 @@ static const struct net_device_ops niu_netdev_ops = {
 	.ndo_set_rx_mode	= niu_set_rx_mode,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= niu_set_mac_addr,
-	.ndo_do_ioctl		= niu_ioctl,
+	.ndo_eth_ioctl		= niu_ioctl,
 	.ndo_tx_timeout		= niu_tx_timeout,
 	.ndo_change_mtu		= niu_change_mtu,
 };
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index cfb9e21b18b7..d72018a60c0f 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2831,7 +2831,7 @@ static const struct net_device_ops gem_netdev_ops = {
 	.ndo_start_xmit		= gem_start_xmit,
 	.ndo_get_stats		= gem_get_stats,
 	.ndo_set_rx_mode	= gem_set_multicast,
-	.ndo_do_ioctl		= gem_ioctl,
+	.ndo_eth_ioctl		= gem_ioctl,
 	.ndo_tx_timeout		= gem_tx_timeout,
 	.ndo_change_mtu		= gem_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 26d178f8616b..1db7104fef3a 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -933,7 +933,7 @@ static const struct net_device_ops xlgmac_netdev_ops = {
 	.ndo_change_mtu		= xlgmac_change_mtu,
 	.ndo_set_mac_address	= xlgmac_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= xlgmac_ioctl,
+	.ndo_eth_ioctl		= xlgmac_ioctl,
 	.ndo_vlan_rx_add_vid	= xlgmac_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= xlgmac_vlan_rx_kill_vid,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 229e2f09d605..dffb6839f0fa 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1480,7 +1480,7 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_tx_timeout		= am65_cpsw_nuss_ndo_host_tx_timeout,
 	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
-	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
+	.ndo_eth_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
 	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
 };
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index c20715107075..02d4e51f7306 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -1044,7 +1044,7 @@ static const struct net_device_ops cpmac_netdev_ops = {
 	.ndo_start_xmit		= cpmac_start_xmit,
 	.ndo_tx_timeout		= cpmac_tx_timeout,
 	.ndo_set_rx_mode	= cpmac_set_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 };
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index cbbd0f665796..abf9a2a6f7eb 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1159,7 +1159,7 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_stop		= cpsw_ndo_stop,
 	.ndo_start_xmit		= cpsw_ndo_start_xmit,
 	.ndo_set_mac_address	= cpsw_ndo_set_mac_address,
-	.ndo_do_ioctl		= cpsw_ndo_ioctl,
+	.ndo_eth_ioctl		= cpsw_ndo_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= cpsw_ndo_tx_timeout,
 	.ndo_set_rx_mode	= cpsw_ndo_set_rx_mode,
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 4448a91cce54..b4f55ff4e84f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1128,7 +1128,7 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_stop		= cpsw_ndo_stop,
 	.ndo_start_xmit		= cpsw_ndo_start_xmit,
 	.ndo_set_mac_address	= cpsw_ndo_set_mac_address,
-	.ndo_do_ioctl		= cpsw_ndo_ioctl,
+	.ndo_eth_ioctl		= cpsw_ndo_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= cpsw_ndo_tx_timeout,
 	.ndo_set_rx_mode	= cpsw_ndo_set_rx_mode,
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index c674e34b6839..637796670746 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1670,7 +1670,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_start_xmit		= emac_dev_xmit,
 	.ndo_set_rx_mode	= emac_dev_mcast_set,
 	.ndo_set_mac_address	= emac_dev_setmac_addr,
-	.ndo_do_ioctl		= emac_devioctl,
+	.ndo_eth_ioctl		= emac_devioctl,
 	.ndo_tx_timeout		= emac_dev_tx_timeout,
 	.ndo_get_stats		= emac_dev_getnetstats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 97942b0e3897..eda2961c0fe2 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1944,7 +1944,7 @@ static const struct net_device_ops netcp_netdev_ops = {
 	.ndo_stop		= netcp_ndo_stop,
 	.ndo_start_xmit		= netcp_ndo_start_xmit,
 	.ndo_set_rx_mode	= netcp_set_rx_mode,
-	.ndo_do_ioctl           = netcp_ndo_ioctl,
+	.ndo_eth_ioctl           = netcp_ndo_ioctl,
 	.ndo_get_stats64        = netcp_get_stats,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index e0cb713193ea..77c448ad67ce 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -749,7 +749,7 @@ static const struct net_device_ops tlan_netdev_ops = {
 	.ndo_tx_timeout		= tlan_tx_timeout,
 	.ndo_get_stats		= tlan_get_stats,
 	.ndo_set_rx_mode	= tlan_set_multicast_list,
-	.ndo_do_ioctl		= tlan_ioctl,
+	.ndo_eth_ioctl		= tlan_ioctl,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 226a76633e65..087f0af56c50 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2214,7 +2214,7 @@ static const struct net_device_ops spider_net_ops = {
 	.ndo_start_xmit		= spider_net_xmit,
 	.ndo_set_rx_mode	= spider_net_set_multi,
 	.ndo_set_mac_address	= spider_net_set_mac,
-	.ndo_do_ioctl		= spider_net_do_ioctl,
+	.ndo_eth_ioctl		= spider_net_do_ioctl,
 	.ndo_tx_timeout		= spider_net_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	/* HW VLAN */
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index fedb2bf69261..52245ac60fc7 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -750,7 +750,7 @@ static const struct net_device_ops tc35815_netdev_ops = {
 	.ndo_get_stats		= tc35815_get_stats,
 	.ndo_set_rx_mode	= tc35815_set_multicast_list,
 	.ndo_tx_timeout		= tc35815_tx_timeout,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index c62f474b6d08..cf0917b29e30 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1538,7 +1538,7 @@ static const struct net_device_ops tsi108_netdev_ops = {
 	.ndo_start_xmit		= tsi108_send_packet,
 	.ndo_set_rx_mode	= tsi108_set_rx_mode,
 	.ndo_get_stats		= tsi108_get_stats,
-	.ndo_do_ioctl		= tsi108_do_ioctl,
+	.ndo_eth_ioctl		= tsi108_do_ioctl,
 	.ndo_set_mac_address	= tsi108_set_mac,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 73ca597ebd1b..961b623b7880 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -884,7 +884,7 @@ static const struct net_device_ops rhine_netdev_ops = {
 	.ndo_set_rx_mode	 = rhine_set_rx_mode,
 	.ndo_validate_addr	 = eth_validate_addr,
 	.ndo_set_mac_address 	 = eth_mac_addr,
-	.ndo_do_ioctl		 = netdev_ioctl,
+	.ndo_eth_ioctl		 = netdev_ioctl,
 	.ndo_tx_timeout 	 = rhine_tx_timeout,
 	.ndo_vlan_rx_add_vid	 = rhine_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	 = rhine_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 88426b5e410b..278f49518d3f 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2637,7 +2637,7 @@ static const struct net_device_ops velocity_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_set_rx_mode	= velocity_set_multi,
 	.ndo_change_mtu		= velocity_change_mtu,
-	.ndo_do_ioctl		= velocity_ioctl,
+	.ndo_eth_ioctl		= velocity_ioctl,
 	.ndo_vlan_rx_add_vid	= velocity_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= velocity_vlan_rx_kill_vid,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 60a4f79b8fa1..db1994fb51c5 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1237,7 +1237,7 @@ static const struct net_device_ops temac_netdev_ops = {
 	.ndo_set_rx_mode = temac_set_multicast_list,
 	.ndo_set_mac_address = temac_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = phy_do_ioctl_running,
+	.ndo_eth_ioctl = phy_do_ioctl_running,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = temac_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 13cd799541aa..348c0ba5edcf 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1227,7 +1227,7 @@ static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = axienet_ioctl,
+	.ndo_eth_ioctl = axienet_ioctl,
 	.ndo_set_rx_mode = axienet_set_multicast_list,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = axienet_poll_controller,
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index b06377fe7293..b780aad3550a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1263,7 +1263,7 @@ static const struct net_device_ops xemaclite_netdev_ops = {
 	.ndo_start_xmit		= xemaclite_send,
 	.ndo_set_mac_address	= xemaclite_set_mac_address,
 	.ndo_tx_timeout		= xemaclite_tx_timeout,
-	.ndo_do_ioctl		= xemaclite_ioctl,
+	.ndo_eth_ioctl		= xemaclite_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = xemaclite_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 4f6db6f5c272..ae611e46da6a 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -464,7 +464,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_start_xmit		= do_start_xmit,
 	.ndo_tx_timeout 	= xirc_tx_timeout,
 	.ndo_set_config		= do_config,
-	.ndo_do_ioctl		= do_ioctl,
+	.ndo_eth_ioctl		= do_ioctl,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 7ae754eadf22..ff50305d6e13 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1357,7 +1357,7 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_stop = eth_close,
 	.ndo_start_xmit = eth_xmit,
 	.ndo_set_rx_mode = eth_set_mcast_list,
-	.ndo_do_ioctl = eth_ioctl,
+	.ndo_eth_ioctl = eth_ioctl,
 	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
 };
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 80de9768ecd4..35f46ad040b0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -829,7 +829,7 @@ static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int macvlan_eth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct net_device *real_dev = macvlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
@@ -845,8 +845,8 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			break;
 		fallthrough;
 	case SIOCGHWTSTAMP:
-		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
-			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
+		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
+			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 		break;
 	}
 
@@ -1151,7 +1151,7 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_stop		= macvlan_stop,
 	.ndo_start_xmit		= macvlan_start_xmit,
 	.ndo_change_mtu		= macvlan_change_mtu,
-	.ndo_do_ioctl		= macvlan_do_ioctl,
+	.ndo_eth_ioctl		= macvlan_eth_ioctl,
 	.ndo_fix_features	= macvlan_fix_features,
 	.ndo_change_rx_flags	= macvlan_change_rx_flags,
 	.ndo_set_mac_address	= macvlan_set_mac_address,
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8eeb26d8aeb7..f124a8a58bd4 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -426,7 +426,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 EXPORT_SYMBOL(phy_mii_ioctl);
 
 /**
- * phy_do_ioctl - generic ndo_do_ioctl implementation
+ * phy_do_ioctl - generic ndo_eth_ioctl implementation
  * @dev: the net_device struct
  * @ifr: &struct ifreq for socket ioctl's
  * @cmd: ioctl cmd to execute
@@ -441,7 +441,7 @@ int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 EXPORT_SYMBOL(phy_do_ioctl);
 
 /**
- * phy_do_ioctl_running - generic ndo_do_ioctl implementation but test first
+ * phy_do_ioctl_running - generic ndo_eth_ioctl implementation but test first
  *
  * @dev: the net_device struct
  * @ifr: &struct ifreq for socket ioctl's
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 9b914765c2de..cb01897c7a5d 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -197,7 +197,7 @@ static const struct net_device_ops ax88172_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= asix_ioctl,
+	.ndo_eth_ioctl		= asix_ioctl,
 	.ndo_set_rx_mode	= ax88172_set_multicast,
 };
 
@@ -589,7 +589,7 @@ static const struct net_device_ops ax88772_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode        = asix_set_multicast,
 };
 
@@ -1095,7 +1095,7 @@ static const struct net_device_ops ax88178_netdev_ops = {
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= asix_set_multicast,
-	.ndo_do_ioctl 		= asix_ioctl,
+	.ndo_eth_ioctl		= asix_ioctl,
 	.ndo_change_mtu 	= ax88178_change_mtu,
 };
 
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 530947d7477b..d9777d9a7c5d 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -109,7 +109,7 @@ static const struct net_device_ops ax88172a_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode        = asix_set_multicast,
 };
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index c1316718304d..f25448a08870 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1035,7 +1035,7 @@ static const struct net_device_ops ax88179_netdev_ops = {
 	.ndo_change_mtu		= ax88179_change_mtu,
 	.ndo_set_mac_address	= ax88179_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= ax88179_ioctl,
+	.ndo_eth_ioctl		= ax88179_ioctl,
 	.ndo_set_rx_mode	= ax88179_set_multicast,
 	.ndo_set_features	= ax88179_set_features,
 };
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 89cc61d7a675..907f98b1eefe 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -345,7 +345,7 @@ static const struct net_device_ops dm9601_netdev_ops = {
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= dm9601_ioctl,
+	.ndo_eth_ioctl		= dm9601_ioctl,
 	.ndo_set_rx_mode	= dm9601_set_multicast,
 	.ndo_set_mac_address	= dm9601_set_mac_address,
 };
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 25489389ea49..13f86368b78a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3601,7 +3601,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
 	.ndo_change_mtu		= lan78xx_change_mtu,
 	.ndo_set_mac_address	= lan78xx_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode	= lan78xx_set_multicast,
 	.ndo_set_features	= lan78xx_set_features,
 	.ndo_vlan_rx_add_vid	= lan78xx_vlan_rx_add_vid,
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 2469bdcb1a04..66866bef25df 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -464,7 +464,7 @@ static const struct net_device_ops mcs7830_netdev_ops = {
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= mcs7830_ioctl,
+	.ndo_eth_ioctl		= mcs7830_ioctl,
 	.ndo_set_rx_mode	= mcs7830_set_multicast,
 	.ndo_set_mac_address	= mcs7830_set_mac_address,
 };
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e09b107b5c99..d7fbc81b518a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9173,7 +9173,7 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 static const struct net_device_ops rtl8152_netdev_ops = {
 	.ndo_open		= rtl8152_open,
 	.ndo_stop		= rtl8152_close,
-	.ndo_do_ioctl		= rtl8152_ioctl,
+	.ndo_eth_ioctl		= rtl8152_ioctl,
 	.ndo_start_xmit		= rtl8152_start_xmit,
 	.ndo_tx_timeout		= rtl8152_tx_timeout,
 	.ndo_set_features	= rtl8152_set_features,
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 13141dbfa3a8..76f7af161313 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1439,7 +1439,7 @@ static const struct net_device_ops smsc75xx_netdev_ops = {
 	.ndo_change_mtu		= smsc75xx_change_mtu,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= smsc75xx_ioctl,
+	.ndo_eth_ioctl		= smsc75xx_ioctl,
 	.ndo_set_rx_mode	= smsc75xx_set_multicast,
 	.ndo_set_features	= smsc75xx_set_features,
 };
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 4c8ee1cff4d4..7d953974eb9b 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1044,7 +1044,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= smsc95xx_ioctl,
+	.ndo_eth_ioctl		= smsc95xx_ioctl,
 	.ndo_set_rx_mode	= smsc95xx_set_multicast,
 	.ndo_set_features	= smsc95xx_set_features,
 };
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index ce29261263cd..6516a37893e2 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -310,7 +310,7 @@ static const struct net_device_ops sr9700_netdev_ops = {
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= sr9700_ioctl,
+	.ndo_eth_ioctl		= sr9700_ioctl,
 	.ndo_set_rx_mode	= sr9700_set_multicast,
 	.ndo_set_mac_address	= sr9700_set_mac_address,
 };
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index a822d81310d5..576401c8b1be 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -684,7 +684,7 @@ static const struct net_device_ops sr9800_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address	= sr_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= sr_ioctl,
+	.ndo_eth_ioctl		= sr_ioctl,
 	.ndo_set_rx_mode        = sr_set_multicast,
 };
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index d50d3cba238e..69afc0311dd1 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -836,7 +836,7 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_select_queue	= qeth_l2_select_queue,
 	.ndo_validate_addr	= qeth_l2_validate_addr,
 	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
-	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
 	.ndo_siocdevprivate	= qeth_siocdevprivate,
 	.ndo_set_mac_address    = qeth_l2_set_mac_address,
 	.ndo_vlan_rx_add_vid	= qeth_l2_vlan_rx_add_vid,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d7a895372f19..3a523e700a5a 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1841,7 +1841,7 @@ static const struct net_device_ops qeth_l3_netdev_ops = {
 	.ndo_select_queue	= qeth_l3_iqd_select_queue,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
-	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
 	.ndo_siocdevprivate	= qeth_siocdevprivate,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
@@ -1857,7 +1857,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_select_queue	= qeth_l3_osa_select_queue,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
-	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
 	.ndo_siocdevprivate	= qeth_siocdevprivate,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index dcbba9621b21..5d24c1b6663b 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -524,7 +524,7 @@ static const struct net_device_ops cvm_oct_npi_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -540,7 +540,7 @@ static const struct net_device_ops cvm_oct_xaui_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -556,7 +556,7 @@ static const struct net_device_ops cvm_oct_sgmii_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -570,7 +570,7 @@ static const struct net_device_ops cvm_oct_spi_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -586,7 +586,7 @@ static const struct net_device_ops cvm_oct_rgmii_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -599,7 +599,7 @@ static const struct net_device_ops cvm_oct_pow_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit_pow,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 658d8cf57342..b6e062a3b0d4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1090,6 +1090,10 @@ struct netdev_net_notifier {
  *	the generic interface code. If not defined ioctls return
  *	not supported error code.
  *
+ * * int (*ndo_eth_ioctl)(struct net_device *dev, struct ifreq *ifr, int cmd);
+ *	Called for ethernet specific ioctls: SIOCGMIIPHY, SIOCGMIIREG,
+ *	SIOCSMIIREG, SIOCSHWTSTAMP and SIOCGHWTSTAMP.
+ *
  * int (*ndo_set_config)(struct net_device *dev, struct ifmap *map);
  *	Used to set network devices bus interface parameters. This interface
  *	is retained for legacy reasons; new devices should use the bus
@@ -1361,6 +1365,8 @@ struct net_device_ops {
 	int			(*ndo_validate_addr)(struct net_device *dev);
 	int			(*ndo_do_ioctl)(struct net_device *dev,
 					        struct ifreq *ifr, int cmd);
+	int			(*ndo_eth_ioctl)(struct net_device *dev,
+						 struct ifreq *ifr, int cmd);
 	int			(*ndo_siocdevprivate)(struct net_device *dev,
 						      struct ifreq *ifr,
 						      void __user *data, int cmd);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 55fcac854058..2af6ee2f2bfb 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -106,8 +106,8 @@ struct dsa_device_ops {
  * function pointers.
  */
 struct dsa_netdevice_ops {
-	int (*ndo_do_ioctl)(struct net_device *dev, struct ifreq *ifr,
-			    int cmd);
+	int (*ndo_eth_ioctl)(struct net_device *dev, struct ifreq *ifr,
+			     int cmd);
 };
 
 #define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
@@ -1019,8 +1019,8 @@ static inline int __dsa_netdevice_ops_check(struct net_device *dev)
 	return 0;
 }
 
-static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
-				   int cmd)
+static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
+				    int cmd)
 {
 	const struct dsa_netdevice_ops *ops;
 	int err;
@@ -1031,11 +1031,11 @@ static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	ops = dev->dsa_ptr->netdev_ops;
 
-	return ops->ndo_do_ioctl(dev, ifr, cmd);
+	return ops->ndo_eth_ioctl(dev, ifr, cmd);
 }
 #else
-static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
-				   int cmd)
+static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
+				    int cmd)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index a0367b37512d..0c21d1fec852 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -372,8 +372,8 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
 	case SIOCGHWTSTAMP:
-		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
-			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
+		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
+			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 		break;
 	}
 
@@ -814,7 +814,7 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_set_mac_address	= vlan_dev_set_mac_address,
 	.ndo_set_rx_mode	= vlan_dev_set_rx_mode,
 	.ndo_change_rx_flags	= vlan_dev_change_rx_flags,
-	.ndo_do_ioctl		= vlan_dev_ioctl,
+	.ndo_eth_ioctl		= vlan_dev_ioctl,
 	.ndo_neigh_setup	= vlan_dev_neigh_setup,
 	.ndo_get_stats64	= vlan_dev_get_stats64,
 #if IS_ENABLED(CONFIG_FCOE)
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 3ace1e4f6b80..8e30fe8b5645 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -239,19 +239,19 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	return 0;
 }
 
-static int dev_do_ioctl(struct net_device *dev,
-			struct ifreq *ifr, unsigned int cmd)
+static int dev_eth_ioctl(struct net_device *dev,
+			 struct ifreq *ifr, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
-	err = dsa_ndo_do_ioctl(dev, ifr, cmd);
+	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
 	if (err == 0 || err != -EOPNOTSUPP)
 		return err;
 
-	if (ops->ndo_do_ioctl) {
+	if (ops->ndo_eth_ioctl) {
 		if (netif_device_present(dev))
-			err = ops->ndo_do_ioctl(dev, ifr, cmd);
+			err = ops->ndo_eth_ioctl(dev, ifr, cmd);
 		else
 			err = -ENODEV;
 	}
@@ -259,6 +259,21 @@ static int dev_do_ioctl(struct net_device *dev,
 	return err;
 }
 
+static int dev_do_ioctl(struct net_device *dev,
+			struct ifreq *ifr, unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (ops->ndo_do_ioctl) {
+		if (netif_device_present(dev))
+			return ops->ndo_do_ioctl(dev, ifr, cmd);
+		else
+			return -ENODEV;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			      void __user *data, unsigned int cmd)
 {
@@ -358,19 +373,20 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd <= SIOCDEVPRIVATE + 15)
 			return dev_siocdevprivate(dev, ifr, data, cmd);
 
-		if (cmd == SIOCBONDENSLAVE ||
+		if (cmd == SIOCGMIIPHY ||
+		    cmd == SIOCGMIIREG ||
+		    cmd == SIOCSMIIREG ||
+		    cmd == SIOCSHWTSTAMP ||
+		    cmd == SIOCGHWTSTAMP) {
+			err = dev_eth_ioctl(dev, ifr, cmd);
+		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
 		    cmd == SIOCBONDSETHWADDR ||
 		    cmd == SIOCBONDSLAVEINFOQUERY ||
 		    cmd == SIOCBONDINFOQUERY ||
 		    cmd == SIOCBONDCHANGEACTIVE ||
-		    cmd == SIOCGMIIPHY ||
-		    cmd == SIOCGMIIREG ||
-		    cmd == SIOCSMIIREG ||
 		    cmd == SIOCBRADDIF ||
 		    cmd == SIOCBRDELIF ||
-		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP ||
 		    cmd == SIOCWANDEV) {
 			err = dev_do_ioctl(dev, ifr, cmd);
 		} else
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 3fc90e36772d..e8e19857621b 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -210,14 +210,14 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 	}
 
-	if (dev->netdev_ops->ndo_do_ioctl)
-		err = dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+	if (dev->netdev_ops->ndo_eth_ioctl)
+		err = dev->netdev_ops->ndo_eth_ioctl(dev, ifr, cmd);
 
 	return err;
 }
 
 static const struct dsa_netdevice_ops dsa_netdev_ops = {
-	.ndo_do_ioctl = dsa_master_ioctl,
+	.ndo_eth_ioctl = dsa_master_ioctl,
 };
 
 static int dsa_master_ethtool_setup(struct net_device *dev)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8c112d7d5b0a..6e1135d3ee33 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1687,7 +1687,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_set_rx_mode	= dsa_slave_set_rx_mode,
 	.ndo_set_mac_address	= dsa_slave_set_mac_address,
 	.ndo_fdb_dump		= dsa_slave_fdb_dump,
-	.ndo_do_ioctl		= dsa_slave_ioctl,
+	.ndo_eth_ioctl		= dsa_slave_ioctl,
 	.ndo_get_iflink		= dsa_slave_get_iflink,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_netpoll_setup	= dsa_slave_netpoll_setup,
-- 
2.29.2

