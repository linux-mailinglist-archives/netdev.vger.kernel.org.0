Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3A2A9FE9
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgKFWTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgKFWS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:57 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C8422202;
        Fri,  6 Nov 2020 22:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701131;
        bh=B5zPXdByfbHuyUATPofhcI5R+5Nr2Y6Anz3sdZWIz9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHA3gPX04KYG8X+H7ZZNFW2eyc9c/iMg/kht7WnSRjc/4HT4y0qtDGHB8sCA+W5X7
         orvlZAh+iq1NYFvalA3qiHkQwu6ZixrKPU/Eo39B/l9MkXPq8NpiguGKrHDpqMdKdM
         Q3kJuA4t7ZmiskE+BduQR1MybEAzFcvezIP+dNHs=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 20/28] dev_ioctl: split out ndo_eth_ioctl
Date:   Fri,  6 Nov 2020 23:17:35 +0100
Message-Id: <20201106221743.3271965-21-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/netdevices.rst       |  4 ++
 Documentation/networking/timestamping.rst     |  6 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  8 ++--
 drivers/net/bonding/bond_main.c               | 43 +++++++++++++------
 drivers/net/ethernet/3com/3c574_cs.c          |  2 +-
 drivers/net/ethernet/3com/3c59x.c             |  4 +-
 drivers/net/ethernet/8390/ax88796.c           |  2 +-
 drivers/net/ethernet/8390/axnet_cs.c          |  2 +-
 drivers/net/ethernet/8390/pcnet_cs.c          |  2 +-
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
 drivers/net/ethernet/aurora/nb8800.c          |  2 +-
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
 include/net/dsa.h                             | 14 +++---
 net/8021q/vlan_dev.c                          |  6 +--
 net/core/dev_ioctl.c                          | 38 +++++++++++-----
 net/dsa/master.c                              |  6 +--
 net/dsa/slave.c                               |  2 +-
 169 files changed, 265 insertions(+), 222 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..fff063270528 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -63,6 +63,10 @@ ndo_do_ioctl:
 	Synchronization: rtnl_lock() semaphore.
 	Context: process
 
+ndo_eth_ioctl:
+	Synchronization: rtnl_lock() semaphore.
+	Context: process
+
 ndo_get_stats:
 	Synchronization: dev_base_lock rwlock.
 	Context: nominally process, but don't sleep inside an rwlock
diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 03f7beade470..b4607bd8e4eb 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -624,7 +624,7 @@ interfaces of a DSA switch to share the same PHC.
 By design, PTP timestamping with a DSA switch does not need any special
 handling in the driver for the host port it is attached to.  However, when the
 host port also supports PTP timestamping, DSA will take care of intercepting
-the ``.ndo_do_ioctl`` calls towards the host port, and block attempts to enable
+the ``.ndo_eth_ioctl`` calls towards the host port, and block attempts to enable
 hardware timestamping on it. This is because the SO_TIMESTAMPING API does not
 allow the delivery of multiple hardware timestamps for the same packet, so
 anybody else except for the DSA switch port must be prevented from doing so.
@@ -672,7 +672,7 @@ ethtool ioctl operations for them need to be mediated by their respective MAC
 driver.  Therefore, as opposed to DSA switches, modifications need to be done
 to each individual MAC driver for PHY timestamping support. This entails:
 
-- Checking, in ``.ndo_do_ioctl``, whether ``phy_has_hwtstamp(netdev->phydev)``
+- Checking, in ``.ndo_eth_ioctl``, whether ``phy_has_hwtstamp(netdev->phydev)``
   is true or not. If it is, then the MAC driver should not process this request
   but instead pass it on to the PHY using ``phy_mii_ioctl()``.
 
@@ -731,7 +731,7 @@ For example, a typical driver design for TX timestamping might be to split the
 transmission part into 2 portions:
 
 1. "TX": checks whether PTP timestamping has been previously enabled through
-   the ``.ndo_do_ioctl`` ("``priv->hwtstamp_tx_enabled == true``") and the
+   the ``.ndo_eth_ioctl`` ("``priv->hwtstamp_tx_enabled == true``") and the
    current skb requires a TX timestamp ("``skb_shinfo(skb)->tx_flags &
    SKBTX_HW_TSTAMP``"). If this is true, it sets the
    "``skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS``" flag. Note: as
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index abfab89423f4..979b19dc19be 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1736,10 +1736,10 @@ static int ipoib_ioctl(struct net_device *dev, struct ifreq *ifr,
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
-	if (!priv->rn_ops->ndo_do_ioctl)
+	if (!priv->rn_ops->ndo_eth_ioctl)
 		return -EOPNOTSUPP;
 
-	return priv->rn_ops->ndo_do_ioctl(dev, ifr, cmd);
+	return priv->rn_ops->ndo_eth_ioctl(dev, ifr, cmd);
 }
 
 static int ipoib_dev_init(struct net_device *dev)
@@ -2069,7 +2069,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
 	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
 	.ndo_set_mac_address	 = ipoib_set_mac,
 	.ndo_get_stats64	 = ipoib_get_stats,
-	.ndo_do_ioctl		 = ipoib_ioctl,
+	.ndo_eth_ioctl		 = ipoib_ioctl,
 };
 
 static const struct net_device_ops ipoib_netdev_ops_vf = {
@@ -2084,7 +2084,7 @@ static const struct net_device_ops ipoib_netdev_ops_vf = {
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 	.ndo_get_iflink		 = ipoib_get_iflink,
 	.ndo_get_stats64	 = ipoib_get_stats,
-	.ndo_do_ioctl		 = ipoib_ioctl,
+	.ndo_eth_ioctl		 = ipoib_ioctl,
 };
 
 static const struct net_device_ops ipoib_netdev_default_pf = {
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5a2956fec025..3ada1853a7f9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -589,7 +589,7 @@ static int bond_check_dev_link(struct bonding *bond,
 			BMSR_LSTATUS : 0;
 
 	/* Ethtool can't be used, fallback to MII ioctls. */
-	ioctl = slave_ops->ndo_do_ioctl;
+	ioctl = slave_ops->ndo_eth_ioctl;
 	if (ioctl) {
 		/* TODO: set pointer to correct ioctl on a per team member
 		 *       bases to make this more efficient. that is, once
@@ -613,7 +613,7 @@ static int bond_check_dev_link(struct bonding *bond,
 		}
 	}
 
-	/* If reporting, report that either there's no dev->do_ioctl,
+	/* If reporting, report that either there's no ndo_eth_ioctl,
 	 * or both SIOCGMIIREG and get_link failed (meaning that we
 	 * cannot report link status).  If not reporting, pretend
 	 * we're ok.
@@ -1552,7 +1552,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	if (!bond->params.use_carrier &&
 	    slave_dev->ethtool_ops->get_link == NULL &&
-	    slave_ops->ndo_do_ioctl == NULL) {
+	    slave_ops->ndo_eth_ioctl == NULL) {
 		slave_warn(bond_dev, slave_dev, "no link monitoring support\n");
 	}
 
@@ -3743,20 +3743,13 @@ static void bond_get_stats(struct net_device *bond_dev,
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
@@ -3781,6 +3774,29 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 		}
 
 		return 0;
+	default:
+		res = -EOPNOTSUPP;
+	}
+
+	return res;
+}
+
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
 
@@ -4657,6 +4673,7 @@ static const struct net_device_ops bond_netdev_ops = {
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
index 741c67e546d4..fe65e701131b 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1052,7 +1052,7 @@ static const struct net_device_ops boomrang_netdev_ops = {
 	.ndo_tx_timeout		= vortex_tx_timeout,
 	.ndo_get_stats		= vortex_get_stats,
 #ifdef CONFIG_PCI
-	.ndo_do_ioctl 		= vortex_ioctl,
+	.ndo_eth_ioctl 		= vortex_ioctl,
 #endif
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_set_mac_address 	= eth_mac_addr,
@@ -1069,7 +1069,7 @@ static const struct net_device_ops vortex_netdev_ops = {
 	.ndo_tx_timeout		= vortex_tx_timeout,
 	.ndo_get_stats		= vortex_get_stats,
 #ifdef CONFIG_PCI
-	.ndo_do_ioctl 		= vortex_ioctl,
+	.ndo_eth_ioctl 		= vortex_ioctl,
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
index 2488bfdb9133..91a0740e9794 100644
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
index 9d3b1e0e425c..b1fa71e54c9d 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -223,7 +223,7 @@ static const struct net_device_ops pcnet_netdev_ops = {
 	.ndo_set_config		= set_config,
 	.ndo_start_xmit 	= ei_start_xmit,
 	.ndo_get_stats		= ei_get_stats,
-	.ndo_do_ioctl 		= ei_ioctl,
+	.ndo_eth_ioctl 		= ei_ioctl,
 	.ndo_set_rx_mode	= ei_set_multicast_list,
 	.ndo_tx_timeout 	= ei_tx_timeout,
 	.ndo_set_mac_address 	= eth_mac_addr,
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 555299737b51..a27b6c38fc19 100644
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
index 862ea44beea7..2b875507fb67 100644
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
index 960d483e8997..1e26051e8dbf 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1737,7 +1737,7 @@ static const struct net_device_ops amd8111e_netdev_ops = {
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
index 187b0b9a6e1d..bcc224cf0738 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1571,7 +1571,7 @@ static const struct net_device_ops pcnet32_netdev_ops = {
 	.ndo_tx_timeout		= pcnet32_tx_timeout,
 	.ndo_get_stats		= pcnet32_get_stats,
 	.ndo_set_rx_mode	= pcnet32_set_multicast_list,
-	.ndo_do_ioctl		= pcnet32_ioctl,
+	.ndo_eth_ioctl		= pcnet32_ioctl,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2709a2db5657..9eb9f30c98bd 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2283,7 +2283,7 @@ static const struct net_device_ops xgbe_netdev_ops = {
 	.ndo_set_rx_mode	= xgbe_set_rx_mode,
 	.ndo_set_mac_address	= xgbe_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= xgbe_ioctl,
+	.ndo_eth_ioctl		= xgbe_ioctl,
 	.ndo_change_mtu		= xgbe_change_mtu,
 	.ndo_tx_timeout		= xgbe_tx_timeout,
 	.ndo_get_stats64	= xgbe_get_stats64,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 8f70a3909929..2478f63c9f0b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -419,7 +419,7 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_change_mtu = aq_ndev_change_mtu,
 	.ndo_set_mac_address = aq_ndev_set_mac_address,
 	.ndo_set_features = aq_ndev_set_features,
-	.ndo_do_ioctl = aq_ndev_ioctl,
+	.ndo_eth_ioctl = aq_ndev_ioctl,
 	.ndo_vlan_rx_add_vid = aq_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = aq_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc = aq_ndo_setup_tc,
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index b56a9e2aecd9..7d1e4751a1e0 100644
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
index dd5c8a9038bb..f18afb1735da 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1841,7 +1841,7 @@ static const struct net_device_ops ag71xx_netdev_ops = {
 	.ndo_open		= ag71xx_open,
 	.ndo_stop		= ag71xx_stop,
 	.ndo_start_xmit		= ag71xx_hard_start_xmit,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= ag71xx_tx_timeout,
 	.ndo_change_mtu		= ag71xx_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9b7f1af5f574..df166db85646 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1680,7 +1680,7 @@ static const struct net_device_ops alx_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = alx_set_mac_address,
 	.ndo_change_mtu         = alx_change_mtu,
-	.ndo_do_ioctl           = alx_ioctl,
+	.ndo_eth_ioctl           = alx_ioctl,
 	.ndo_tx_timeout         = alx_tx_timeout,
 	.ndo_fix_features	= alx_fix_features,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 0c12cf7bda50..4fbb373b5720 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2478,7 +2478,7 @@ static const struct net_device_ops atl1c_netdev_ops = {
 	.ndo_change_mtu		= atl1c_change_mtu,
 	.ndo_fix_features	= atl1c_fix_features,
 	.ndo_set_features	= atl1c_set_features,
-	.ndo_do_ioctl		= atl1c_ioctl,
+	.ndo_eth_ioctl		= atl1c_ioctl,
 	.ndo_tx_timeout		= atl1c_tx_timeout,
 	.ndo_get_stats		= atl1c_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 098b0328e3cb..808b49a711cc 100644
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
index eaf96d002fa5..c8b3caf47635 100644
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
index 7b80d924632a..891c0b8f3949 100644
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
diff --git a/drivers/net/ethernet/aurora/nb8800.c b/drivers/net/ethernet/aurora/nb8800.c
index 5b20185cbd62..1bac47214c37 100644
--- a/drivers/net/ethernet/aurora/nb8800.c
+++ b/drivers/net/ethernet/aurora/nb8800.c
@@ -1011,7 +1011,7 @@ static const struct net_device_ops nb8800_netdev_ops = {
 	.ndo_start_xmit		= nb8800_xmit,
 	.ndo_set_mac_address	= nb8800_set_mac_address,
 	.ndo_set_rx_mode	= nb8800_set_rx_mode,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 74c1778d841e..b866e0873f2a 100644
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
index 916824cca3fd..50ee49c176d3 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1677,7 +1677,7 @@ static const struct net_device_ops bcm_enet_ops = {
 	.ndo_start_xmit		= bcm_enet_start_xmit,
 	.ndo_set_mac_address	= bcm_enet_set_mac_address,
 	.ndo_set_rx_mode	= bcm_enet_set_multicast_list,
-	.ndo_do_ioctl		= bcm_enet_ioctl,
+	.ndo_eth_ioctl		= bcm_enet_ioctl,
 	.ndo_change_mtu		= bcm_enet_change_mtu,
 };
 
@@ -2443,7 +2443,7 @@ static const struct net_device_ops bcm_enetsw_ops = {
 	.ndo_stop		= bcm_enetsw_stop,
 	.ndo_start_xmit		= bcm_enet_start_xmit,
 	.ndo_change_mtu		= bcm_enet_change_mtu,
-	.ndo_do_ioctl		= bcm_enetsw_ioctl,
+	.ndo_eth_ioctl		= bcm_enetsw_ioctl,
 };
 
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 98ec1b8a7d8e..515c2d038bf7 100644
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
index 3e8a179f39db..37b1145e04e3 100644
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
index 28069b290862..1aae99b2c72f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13050,7 +13050,7 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_set_rx_mode	= bnx2x_set_rx_mode,
 	.ndo_set_mac_address	= bnx2x_change_mac_addr,
 	.ndo_validate_addr	= bnx2x_validate_addr,
-	.ndo_do_ioctl		= bnx2x_ioctl,
+	.ndo_eth_ioctl		= bnx2x_ioctl,
 	.ndo_change_mtu		= bnx2x_change_mtu,
 	.ndo_fix_features	= bnx2x_fix_features,
 	.ndo_set_features	= bnx2x_set_features,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fa147865e33f..2ba63c185f41 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12071,7 +12071,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_stop		= bnxt_close,
 	.ndo_get_stats64	= bnxt_get_stats64,
 	.ndo_set_rx_mode	= bnxt_set_rx_mode,
-	.ndo_do_ioctl		= bnxt_ioctl,
+	.ndo_eth_ioctl		= bnxt_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= bnxt_change_mac_addr,
 	.ndo_change_mtu		= bnxt_change_mtu,
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index be85dad2e3bc..d97eaefb9cab 100644
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
index 5143cdd0eeca..fe0d15f67902 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14304,7 +14304,7 @@ static const struct net_device_ops tg3_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= tg3_set_rx_mode,
 	.ndo_set_mac_address	= tg3_set_mac_addr,
-	.ndo_do_ioctl		= tg3_ioctl,
+	.ndo_eth_ioctl		= tg3_ioctl,
 	.ndo_tx_timeout		= tg3_tx_timeout,
 	.ndo_change_mtu		= tg3_change_mtu,
 	.ndo_fix_features	= tg3_fix_features,
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 883e47c5b1a7..8c04c9fd8b09 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3495,7 +3495,7 @@ static const struct net_device_ops macb_netdev_ops = {
 	.ndo_start_xmit		= macb_start_xmit,
 	.ndo_set_rx_mode	= macb_set_rx_mode,
 	.ndo_get_stats		= macb_get_stats,
-	.ndo_do_ioctl		= macb_ioctl,
+	.ndo_eth_ioctl		= macb_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= macb_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
@@ -4166,7 +4166,7 @@ static const struct net_device_ops at91ether_netdev_ops = {
 	.ndo_get_stats		= macb_get_stats,
 	.ndo_set_rx_mode	= macb_set_rx_mode,
 	.ndo_set_mac_address	= eth_mac_addr,
-	.ndo_do_ioctl		= macb_ioctl,
+	.ndo_eth_ioctl		= macb_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= at91ether_poll_controller,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7d00d3a8ded4..273565b3d745 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3216,7 +3216,7 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_vlan_rx_add_vid    = liquidio_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = liquidio_vlan_rx_kill_vid,
 	.ndo_change_mtu		= liquidio_change_mtu,
-	.ndo_do_ioctl		= liquidio_ioctl,
+	.ndo_eth_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
 	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 103440f97bc8..a6dde3806da6 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1876,7 +1876,7 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_vlan_rx_add_vid    = liquidio_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = liquidio_vlan_rx_kill_vid,
 	.ndo_change_mtu		= liquidio_change_mtu,
-	.ndo_do_ioctl		= liquidio_ioctl,
+	.ndo_eth_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
 	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 5e50bb19bf26..798e8eef4222 100644
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
index f3b7b443f964..9bdf86bf5ba4 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2098,7 +2098,7 @@ static const struct net_device_ops nicvf_netdev_ops = {
 	.ndo_fix_features       = nicvf_fix_features,
 	.ndo_set_features       = nicvf_set_features,
 	.ndo_bpf		= nicvf_xdp,
-	.ndo_do_ioctl           = nicvf_ioctl,
+	.ndo_eth_ioctl           = nicvf_ioctl,
 	.ndo_set_rx_mode        = nicvf_set_rx_mode,
 };
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 0e4a0f413960..0c8cda51ebd2 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -968,7 +968,7 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_get_stats		= t1_get_stats,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= t1_set_rxmode,
-	.ndo_do_ioctl		= t1_ioctl,
+	.ndo_eth_ioctl		= t1_ioctl,
 	.ndo_change_mtu		= t1_change_mtu,
 	.ndo_set_mac_address	= t1_set_mac_addr,
 	.ndo_fix_features	= t1_fix_features,
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index c79a70d370bd..4ebf67989d53 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3183,7 +3183,7 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_get_stats		= cxgb_get_stats,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= cxgb_set_rxmode,
-	.ndo_do_ioctl		= cxgb_ioctl,
+	.ndo_eth_ioctl		= cxgb_ioctl,
 	.ndo_siocdevprivate	= cxgb_siocdevprivate,
 	.ndo_change_mtu		= cxgb_change_mtu,
 	.ndo_set_mac_address	= cxgb_set_mac_addr,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a952fe198eb9..71bb41216d69 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3870,7 +3870,7 @@ static const struct net_device_ops cxgb4_netdev_ops = {
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
index 5c6c8c5ec747..a89d144e8ec5 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1373,7 +1373,7 @@ static const struct net_device_ops dm9000_netdev_ops = {
 	.ndo_start_xmit		= dm9000_start_xmit,
 	.ndo_tx_timeout		= dm9000_timeout,
 	.ndo_set_rx_mode	= dm9000_hash_table,
-	.ndo_do_ioctl		= dm9000_ioctl,
+	.ndo_eth_ioctl		= dm9000_ioctl,
 	.ndo_set_features	= dm9000_set_features,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index e7b0d7de40fd..4ac0c31c31a0 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1271,7 +1271,7 @@ static const struct net_device_ops tulip_netdev_ops = {
 	.ndo_tx_timeout		= tulip_tx_timeout,
 	.ndo_stop		= tulip_close,
 	.ndo_get_stats		= tulip_get_stats,
-	.ndo_do_ioctl 		= private_ioctl,
+	.ndo_eth_ioctl 		= private_ioctl,
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 89cbdc1f4857..538bfd743625 100644
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
index e3a8858915b3..1f5b440f20b7 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -479,7 +479,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_start_xmit		= start_tx,
 	.ndo_get_stats 		= get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl 		= netdev_ioctl,
+	.ndo_eth_ioctl 		= netdev_ioctl,
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
index 0981fe9652e5..a5a5ad42cef5 100644
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
index 00024dd41147..ff956e4567b7 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1586,7 +1586,7 @@ static const struct net_device_ops ftgmac100_netdev_ops = {
 	.ndo_start_xmit		= ftgmac100_hard_start_xmit,
 	.ndo_set_mac_address	= ftgmac100_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= ftgmac100_tx_timeout,
 	.ndo_set_rx_mode	= ftgmac100_set_rx_mode,
 	.ndo_set_features	= ftgmac100_set_features,
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 473b337b2e3b..0f14bacefa78 100644
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
index c696651dd735..fb1969557451 100644
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
index 06cc863f4dd6..254313310490 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2724,7 +2724,7 @@ static const struct net_device_ops dpaa_ops = {
 	.ndo_set_mac_address = dpaa_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
-	.ndo_do_ioctl = dpaa_ioctl,
+	.ndo_eth_ioctl = dpaa_ioctl,
 	.ndo_setup_tc = dpaa_setup_tc,
 };
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d..552e30aa6b9d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2502,7 +2502,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_get_stats64 = dpaa2_eth_get_stats,
 	.ndo_set_rx_mode = dpaa2_eth_set_rx_mode,
 	.ndo_set_features = dpaa2_eth_set_features,
-	.ndo_do_ioctl = dpaa2_eth_ioctl,
+	.ndo_eth_ioctl = dpaa2_eth_ioctl,
 	.ndo_change_mtu = dpaa2_eth_change_mtu,
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 419306342ac5..83085fa80463 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -693,7 +693,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_vlan	= enetc_pf_set_vf_vlan,
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
-	.ndo_do_ioctl		= enetc_ioctl,
+	.ndo_eth_ioctl		= enetc_ioctl,
 	.ndo_setup_tc		= enetc_setup_tc,
 };
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 7b5c82c7e4e5..dc9bdc3bf179 100644
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
index 8f7eca1e7716..285c86653d1d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3228,7 +3228,7 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
 	.ndo_set_mac_address	= fec_set_mac_address,
-	.ndo_do_ioctl		= fec_enet_ioctl,
+	.ndo_eth_ioctl		= fec_enet_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index b3bad429e03b..be8495d48272 100644
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
index 78e008b81374..9c04fedaf81d 100644
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
index 41dd3d0f3452..237e50a20004 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3291,7 +3291,7 @@ static const struct net_device_ops gfar_netdev_ops = {
 	.ndo_set_features = gfar_set_features,
 	.ndo_set_rx_mode = gfar_set_multi,
 	.ndo_tx_timeout = gfar_timeout,
-	.ndo_do_ioctl = gfar_ioctl,
+	.ndo_eth_ioctl = gfar_ioctl,
 	.ndo_get_stats = gfar_get_stats,
 	.ndo_change_carrier = fixed_phy_change_carrier,
 	.ndo_set_mac_address = gfar_set_mac_addr,
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 714b501be7d0..add8792877a3 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3679,7 +3679,7 @@ static const struct net_device_ops ucc_geth_netdev_ops = {
 	.ndo_set_mac_address	= ucc_geth_set_mac_addr,
 	.ndo_set_rx_mode	= ucc_geth_set_multi,
 	.ndo_tx_timeout		= ucc_geth_timeout,
-	.ndo_do_ioctl		= ucc_geth_ioctl,
+	.ndo_eth_ioctl		= ucc_geth_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= ucc_netpoll,
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 57c3bc4f7089..96f781ed077e 100644
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
index 858cb293152a..5081b222391a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1943,7 +1943,7 @@ static const struct net_device_ops hns_nic_netdev_ops = {
 	.ndo_tx_timeout = hns_nic_net_timeout,
 	.ndo_set_mac_address = hns_nic_net_set_mac_address,
 	.ndo_change_mtu = hns_nic_change_mtu,
-	.ndo_do_ioctl = phy_do_ioctl_running,
+	.ndo_eth_ioctl = phy_do_ioctl_running,
 	.ndo_set_features = hns_nic_set_features,
 	.ndo_fix_features = hns_nic_fix_features,
 	.ndo_get_stats64 = hns_nic_get_stats64,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a362516a3185..14b909a0df86 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2029,7 +2029,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_start_xmit		= hns3_nic_net_xmit,
 	.ndo_tx_timeout		= hns3_nic_net_timeout,
 	.ndo_set_mac_address	= hns3_nic_net_set_mac_address,
-	.ndo_do_ioctl		= hns3_nic_do_ioctl,
+	.ndo_eth_ioctl		= hns3_nic_do_ioctl,
 	.ndo_change_mtu		= hns3_nic_change_mtu,
 	.ndo_set_features	= hns3_nic_set_features,
 	.ndo_features_check	= hns3_features_check,
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index c00b9097eeea..dd3c69cc0e25 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3010,7 +3010,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_stop		= emac_close,
 	.ndo_get_stats		= emac_stats,
 	.ndo_set_rx_mode	= emac_set_multicast_list,
-	.ndo_do_ioctl		= emac_ioctl,
+	.ndo_eth_ioctl		= emac_ioctl,
 	.ndo_tx_timeout		= emac_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= emac_set_mac_address,
@@ -3022,7 +3022,7 @@ static const struct net_device_ops emac_gige_netdev_ops = {
 	.ndo_stop		= emac_close,
 	.ndo_get_stats		= emac_stats,
 	.ndo_set_rx_mode	= emac_set_multicast_list,
-	.ndo_do_ioctl		= emac_ioctl,
+	.ndo_eth_ioctl		= emac_ioctl,
 	.ndo_tx_timeout		= emac_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= emac_set_mac_address,
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7ef3369953b6..69c513bb451e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1631,7 +1631,7 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 	.ndo_stop		= ibmveth_close,
 	.ndo_start_xmit		= ibmveth_start_xmit,
 	.ndo_set_rx_mode	= ibmveth_set_multicast_list,
-	.ndo_do_ioctl		= ibmveth_ioctl,
+	.ndo_eth_ioctl		= ibmveth_ioctl,
 	.ndo_change_mtu		= ibmveth_change_mtu,
 	.ndo_fix_features	= ibmveth_fix_features,
 	.ndo_set_features	= ibmveth_set_features,
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 8cc651d37a7f..14a340466bb5 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2803,7 +2803,7 @@ static const struct net_device_ops e100_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= e100_set_multicast_list,
 	.ndo_set_mac_address	= e100_set_mac_address,
-	.ndo_do_ioctl		= e100_do_ioctl,
+	.ndo_eth_ioctl		= e100_do_ioctl,
 	.ndo_tx_timeout		= e100_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= e100_netpoll,
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 5e28cf4fa2cd..53125bace3d3 100644
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
index b30f00891c03..87dd3b5f3e96 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7331,7 +7331,7 @@ static const struct net_device_ops e1000e_netdev_ops = {
 	.ndo_set_rx_mode	= e1000e_set_rx_mode,
 	.ndo_set_mac_address	= e1000_set_mac,
 	.ndo_change_mtu		= e1000_change_mtu,
-	.ndo_do_ioctl		= e1000_ioctl,
+	.ndo_eth_ioctl		= e1000_ioctl,
 	.ndo_tx_timeout		= e1000_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4f8a2154b93f..ed6c6c9e7613 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12769,7 +12769,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= i40e_set_mac,
 	.ndo_change_mtu		= i40e_change_mtu,
-	.ndo_do_ioctl		= i40e_ioctl,
+	.ndo_eth_ioctl		= i40e_ioctl,
 	.ndo_tx_timeout		= i40e_tx_timeout,
 	.ndo_vlan_rx_add_vid	= i40e_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= i40e_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..0e5ae3ca43de 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2973,7 +2973,7 @@ static const struct net_device_ops igb_netdev_ops = {
 	.ndo_set_rx_mode	= igb_set_rx_mode,
 	.ndo_set_mac_address	= igb_set_mac,
 	.ndo_change_mtu		= igb_change_mtu,
-	.ndo_do_ioctl		= igb_ioctl,
+	.ndo_eth_ioctl		= igb_ioctl,
 	.ndo_tx_timeout		= igb_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_vlan_rx_add_vid	= igb_vlan_rx_add_vid,
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index ee9f8c1dca83..4db23abbc07d 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2669,7 +2669,7 @@ static const struct net_device_ops igbvf_netdev_ops = {
 	.ndo_set_rx_mode	= igbvf_set_rx_mode,
 	.ndo_set_mac_address	= igbvf_set_mac,
 	.ndo_change_mtu		= igbvf_change_mtu,
-	.ndo_do_ioctl		= igbvf_ioctl,
+	.ndo_eth_ioctl		= igbvf_ioctl,
 	.ndo_tx_timeout		= igbvf_tx_timeout,
 	.ndo_vlan_rx_add_vid	= igbvf_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= igbvf_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9112dff075cf..31b45a65f90c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4859,7 +4859,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
 	.ndo_features_check	= igc_features_check,
-	.ndo_do_ioctl		= igc_ioctl,
+	.ndo_eth_ioctl		= igc_ioctl,
 	.ndo_setup_tc		= igc_setup_tc,
 };
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45ae33e15303..11d3e5ae794e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10241,7 +10241,7 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_set_tx_maxrate	= ixgbe_tx_maxrate,
 	.ndo_vlan_rx_add_vid	= ixgbe_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= ixgbe_vlan_rx_kill_vid,
-	.ndo_do_ioctl		= ixgbe_ioctl,
+	.ndo_eth_ioctl		= ixgbe_ioctl,
 	.ndo_set_vf_mac		= ixgbe_ndo_set_vf_mac,
 	.ndo_set_vf_vlan	= ixgbe_ndo_set_vf_vlan,
 	.ndo_set_vf_rate	= ixgbe_ndo_set_vf_bw,
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index e9efe074edc1..d512edd24bf9 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2902,7 +2902,7 @@ static const struct net_device_ops jme_netdev_ops = {
 	.ndo_open		= jme_open,
 	.ndo_stop		= jme_close,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= jme_ioctl,
+	.ndo_eth_ioctl		= jme_ioctl,
 	.ndo_start_xmit		= jme_start_xmit,
 	.ndo_set_mac_address	= jme_set_macaddr,
 	.ndo_set_rx_mode	= jme_set_multi,
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index bf48f0ded9c7..cd23d706542b 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1012,7 +1012,7 @@ static const struct net_device_ops korina_netdev_ops = {
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
index 90e6111ce534..1f14dad4225a 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3061,7 +3061,7 @@ static const struct net_device_ops mv643xx_eth_netdev_ops = {
 	.ndo_set_rx_mode	= mv643xx_eth_set_rx_mode,
 	.ndo_set_mac_address	= mv643xx_eth_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= mv643xx_eth_ioctl,
+	.ndo_eth_ioctl		= mv643xx_eth_ioctl,
 	.ndo_change_mtu		= mv643xx_eth_change_mtu,
 	.ndo_set_features	= mv643xx_eth_set_features,
 	.ndo_tx_timeout		= mv643xx_eth_tx_timeout,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..9926d2bb6f45 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4904,7 +4904,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_change_mtu      = mvneta_change_mtu,
 	.ndo_fix_features    = mvneta_fix_features,
 	.ndo_get_stats64     = mvneta_get_stats64,
-	.ndo_do_ioctl        = mvneta_ioctl,
+	.ndo_eth_ioctl        = mvneta_ioctl,
 	.ndo_bpf	     = mvneta_xdp,
 	.ndo_xdp_xmit        = mvneta_xdp_xmit,
 };
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8933ca..0a24f9aab1aa 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5299,7 +5299,7 @@ static const struct net_device_ops mvpp2_netdev_ops = {
 	.ndo_set_mac_address	= mvpp2_set_mac_address,
 	.ndo_change_mtu		= mvpp2_change_mtu,
 	.ndo_get_stats64	= mvpp2_get_stats64,
-	.ndo_do_ioctl		= mvpp2_ioctl,
+	.ndo_eth_ioctl		= mvpp2_ioctl,
 	.ndo_vlan_rx_add_vid	= mvpp2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= mvpp2_vlan_rx_kill_vid,
 	.ndo_set_features	= mvpp2_set_features,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 66f1a212f1f4..e645b6a573de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1913,7 +1913,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_set_features	= otx2_set_features,
 	.ndo_tx_timeout		= otx2_tx_timeout,
 	.ndo_get_stats64	= otx2_get_stats64,
-	.ndo_do_ioctl		= otx2_ioctl,
+	.ndo_eth_ioctl		= otx2_ioctl,
 };
 
 static int otx2_wq_init(struct otx2_nic *pf)
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index d1e4d42e497d..3de0fb929098 100644
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
index 8a9c0f490bfb..719ae06d0245 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3786,7 +3786,7 @@ static const struct net_device_ops skge_netdev_ops = {
 	.ndo_open		= skge_up,
 	.ndo_stop		= skge_down,
 	.ndo_start_xmit		= skge_xmit_frame,
-	.ndo_do_ioctl		= skge_ioctl,
+	.ndo_eth_ioctl		= skge_ioctl,
 	.ndo_get_stats		= skge_get_stats,
 	.ndo_tx_timeout		= skge_tx_timeout,
 	.ndo_change_mtu		= skge_change_mtu,
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 25981a7a43b5..4639cfbd49c2 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4690,7 +4690,7 @@ static const struct net_device_ops sky2_netdev_ops[2] = {
 	.ndo_open		= sky2_open,
 	.ndo_stop		= sky2_close,
 	.ndo_start_xmit		= sky2_xmit_frame,
-	.ndo_do_ioctl		= sky2_ioctl,
+	.ndo_eth_ioctl		= sky2_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= sky2_set_mac_address,
 	.ndo_set_rx_mode	= sky2_set_multicast,
@@ -4707,7 +4707,7 @@ static const struct net_device_ops sky2_netdev_ops[2] = {
 	.ndo_open		= sky2_open,
 	.ndo_stop		= sky2_close,
 	.ndo_start_xmit		= sky2_xmit_frame,
-	.ndo_do_ioctl		= sky2_ioctl,
+	.ndo_eth_ioctl		= sky2_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= sky2_set_mac_address,
 	.ndo_set_rx_mode	= sky2_set_multicast,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675ffd..891e9b803046 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2794,7 +2794,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 	.ndo_start_xmit		= mtk_start_xmit,
 	.ndo_set_mac_address	= mtk_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= mtk_do_ioctl,
+	.ndo_eth_ioctl		= mtk_do_ioctl,
 	.ndo_tx_timeout		= mtk_tx_timeout,
 	.ndo_get_stats64        = mtk_get_stats64,
 	.ndo_fix_features	= mtk_fix_features,
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 13250553263b..5ead0183b3b5 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1161,7 +1161,7 @@ static const struct net_device_ops mtk_star_netdev_ops = {
 	.ndo_start_xmit		= mtk_star_netdev_start_xmit,
 	.ndo_get_stats64	= mtk_star_netdev_get_stats64,
 	.ndo_set_rx_mode	= mtk_star_set_rx_mode,
-	.ndo_do_ioctl		= mtk_star_netdev_ioctl,
+	.ndo_eth_ioctl		= mtk_star_netdev_ioctl,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 106513f772c3..f382b39cd19b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2822,7 +2822,7 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_set_mac_address	= mlx4_en_set_mac,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= mlx4_en_change_mtu,
-	.ndo_do_ioctl		= mlx4_en_ioctl,
+	.ndo_eth_ioctl		= mlx4_en_ioctl,
 	.ndo_tx_timeout		= mlx4_en_tx_timeout,
 	.ndo_vlan_rx_add_vid	= mlx4_en_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= mlx4_en_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b3f02aac7f26..01fe4e6d0412 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4568,7 +4568,7 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_set_features        = mlx5e_set_features,
 	.ndo_fix_features        = mlx5e_fix_features,
 	.ndo_change_mtu          = mlx5e_change_nic_mtu,
-	.ndo_do_ioctl            = mlx5e_ioctl,
+	.ndo_eth_ioctl            = mlx5e_ioctl,
 	.ndo_set_tx_maxrate      = mlx5e_set_tx_maxrate,
 	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
 	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 97b5fcb1f406..f08993ed22cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -49,7 +49,7 @@ static const struct net_device_ops mlx5i_netdev_ops = {
 	.ndo_init                = mlx5i_dev_init,
 	.ndo_uninit              = mlx5i_dev_cleanup,
 	.ndo_change_mtu          = mlx5i_change_mtu,
-	.ndo_do_ioctl            = mlx5i_ioctl,
+	.ndo_eth_ioctl            = mlx5i_ioctl,
 };
 
 /* IPoIB mlx5 netdev profile */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 7163d9f6c4a6..abb73d2daee8 100644
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
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 16b47fce540b..54c576a202d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1164,7 +1164,7 @@ static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= mlxsw_sp_port_kill_vid,
 	.ndo_set_features	= mlxsw_sp_set_features,
 	.ndo_get_devlink_port	= mlxsw_sp_port_get_devlink_port,
-	.ndo_do_ioctl		= mlxsw_sp_port_ioctl,
+	.ndo_eth_ioctl		= mlxsw_sp_port_ioctl,
 };
 
 static int
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index d65872172229..76ff356d0c44 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -691,7 +691,7 @@ static int ks8851_net_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 static const struct net_device_ops ks8851_netdev_ops = {
 	.ndo_open		= ks8851_net_open,
 	.ndo_stop		= ks8851_net_stop,
-	.ndo_do_ioctl		= ks8851_net_ioctl,
+	.ndo_eth_ioctl		= ks8851_net_ioctl,
 	.ndo_start_xmit		= ks8851_start_xmit,
 	.ndo_set_mac_address	= ks8851_set_mac_address,
 	.ndo_set_rx_mode	= ks8851_set_rx_mode,
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 9ed264ed7070..2e95d591cc42 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6813,7 +6813,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_set_features	= netdev_set_features,
 	.ndo_set_mac_address	= netdev_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_eth_ioctl		= netdev_ioctl,
 	.ndo_set_rx_mode	= netdev_set_rx_mode,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= netdev_netpoll,
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a1938842f828..5be8e9818336 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2698,7 +2698,7 @@ static const struct net_device_ops lan743x_netdev_ops = {
 	.ndo_open		= lan743x_netdev_open,
 	.ndo_stop		= lan743x_netdev_close,
 	.ndo_start_xmit		= lan743x_netdev_xmit_frame,
-	.ndo_do_ioctl		= lan743x_netdev_ioctl,
+	.ndo_eth_ioctl		= lan743x_netdev_ioctl,
 	.ndo_set_rx_mode	= lan743x_netdev_set_multicast,
 	.ndo_change_mtu		= lan743x_netdev_change_mtu,
 	.ndo_get_stats64	= lan743x_netdev_get_stats64,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index b34da11acf65..199c67dbe172 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -653,7 +653,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_set_features		= ocelot_set_features,
 	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
 	.ndo_setup_tc			= ocelot_setup_tc,
-	.ndo_do_ioctl			= ocelot_ioctl,
+	.ndo_eth_ioctl			= ocelot_ioctl,
 };
 
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index b81e1487945c..00e5dd28ce95 100644
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
index d13d92bf7447..4d7a12e6a1e6 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7614,7 +7614,7 @@ static const struct net_device_ops s2io_netdev_ops = {
 	.ndo_start_xmit    	= s2io_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= s2io_set_multicast,
-	.ndo_do_ioctl	   	= s2io_ioctl,
+	.ndo_eth_ioctl	   	= s2io_ioctl,
 	.ndo_set_mac_address    = s2io_set_mac_addr,
 	.ndo_change_mtu	   	= s2io_change_mtu,
 	.ndo_set_features	= s2io_set_features,
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd992b1..999d4812b395 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3354,7 +3354,7 @@ static const struct net_device_ops vxge_netdev_ops = {
 	.ndo_start_xmit         = vxge_xmit,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_rx_mode	= vxge_set_multicast,
-	.ndo_do_ioctl           = vxge_ioctl,
+	.ndo_eth_ioctl           = vxge_ioctl,
 	.ndo_set_mac_address    = vxge_set_mac_addr,
 	.ndo_change_mtu         = vxge_change_mtu,
 	.ndo_fix_features	= vxge_fix_features,
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d3cbb4215f5c..47f3d9b4700d 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1218,7 +1218,7 @@ static const struct net_device_ops lpc_netdev_ops = {
 	.ndo_stop		= lpc_eth_close,
 	.ndo_start_xmit		= lpc_eth_hard_start_xmit,
 	.ndo_set_rx_mode	= lpc_eth_set_multicast_list,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= lpc_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ade8c44c01cd..690560d0ea28 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2350,7 +2350,7 @@ static const struct net_device_ops pch_gbe_netdev_ops = {
 	.ndo_tx_timeout = pch_gbe_tx_timeout,
 	.ndo_change_mtu = pch_gbe_change_mtu,
 	.ndo_set_features = pch_gbe_set_features,
-	.ndo_do_ioctl = pch_gbe_ioctl,
+	.ndo_eth_ioctl = pch_gbe_ioctl,
 	.ndo_set_rx_mode = pch_gbe_set_multi,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = pch_gbe_netpoll,
diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
index f6980fac8407..5faa6cd84039 100644
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
index d1dd9bc1bc7f..01a7dd4eaf3e 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -362,7 +362,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_set_rx_mode	= set_rx_mode,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
-	.ndo_do_ioctl 		= netdev_ioctl,
+	.ndo_eth_ioctl 		= netdev_ioctl,
 	.ndo_tx_timeout 	= yellowfin_tx_timeout,
 };
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 05e3a3b60269..8ac193d70fc1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -645,7 +645,7 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_set_mac_address	= qede_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= qede_change_mtu,
-	.ndo_do_ioctl		= qede_ioctl,
+	.ndo_eth_ioctl		= qede_ioctl,
 	.ndo_tx_timeout		= qede_tx_timeout,
 #ifdef CONFIG_QED_SRIOV
 	.ndo_set_vf_mac		= qede_set_vf_mac,
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 8543bf3c3484..7959e69396f0 100644
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
index 7c74318620b1..647baaf88b52 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -953,7 +953,7 @@ static const struct net_device_ops r6040_netdev_ops = {
 	.ndo_set_rx_mode	= r6040_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= r6040_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= r6040_poll_controller,
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 4e44313b7651..855825467db1 100644
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
index 1e5a453dea14..1477ce2c3387 100644
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
index 3b6ddc706e92..51d10fc75005 100644
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
index 9c4df4ede011..7cd93182214d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1877,7 +1877,7 @@ static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_get_stats		= ravb_get_stats,
 	.ndo_set_rx_mode	= ravb_set_rx_mode,
 	.ndo_tx_timeout		= ravb_tx_timeout,
-	.ndo_do_ioctl		= ravb_do_ioctl,
+	.ndo_eth_ioctl		= ravb_do_ioctl,
 	.ndo_change_mtu		= ravb_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index c63304632935..529bd749b967 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3108,7 +3108,7 @@ static const struct net_device_ops sh_eth_netdev_ops = {
 	.ndo_get_stats		= sh_eth_get_stats,
 	.ndo_set_rx_mode	= sh_eth_set_rx_mode,
 	.ndo_tx_timeout		= sh_eth_tx_timeout,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_change_mtu		= sh_eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
@@ -3124,7 +3124,7 @@ static const struct net_device_ops sh_eth_netdev_ops_tsu = {
 	.ndo_vlan_rx_add_vid	= sh_eth_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= sh_eth_vlan_rx_kill_vid,
 	.ndo_tx_timeout		= sh_eth_tx_timeout,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_change_mtu		= sh_eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 971f1e54b652..d7e4d1c6f7aa 100644
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
index 718308076341..341e04d7e901 100644
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
index f8979991970e..bf8b8ecb65d2 100644
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
index 6eef0f45b133..4fbbf5bc7900 100644
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
index 620c26f71be8..b29d051cb514 100644
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
index 51cd7dca91cd..a5f2a4bbb7e0 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -312,7 +312,7 @@ static const struct net_device_ops epic_netdev_ops = {
 	.ndo_tx_timeout 	= epic_tx_timeout,
 	.ndo_get_stats		= epic_get_stats,
 	.ndo_set_rx_mode	= set_rx_mode,
-	.ndo_do_ioctl 		= netdev_ioctl,
+	.ndo_eth_ioctl 		= netdev_ioctl,
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
index 823d9a7184fe..d451bfc7a556 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2140,7 +2140,7 @@ static const struct net_device_ops smsc911x_netdev_ops = {
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
index 1503cc9ec6e2..10eed5d3d98d 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1826,7 +1826,7 @@ static const struct net_device_ops netsec_netdev_ops = {
 	.ndo_set_features	= netsec_netdev_set_features,
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_eth_ioctl		= phy_do_ioctl,
 	.ndo_xdp_xmit		= netsec_xdp_xmit,
 	.ndo_bpf		= netsec_xdp,
 };
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 501b9c7aba56..cf524617abe6 100644
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
index 220626a8d499..486de5909975 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4601,7 +4601,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_set_features = stmmac_set_features,
 	.ndo_set_rx_mode = stmmac_set_rx_mode,
 	.ndo_tx_timeout = stmmac_tx_timeout,
-	.ndo_do_ioctl = stmmac_ioctl,
+	.ndo_eth_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
 	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 9ff894ba8d3e..1fbb9f4dfb4c 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4875,7 +4875,7 @@ static const struct net_device_ops cas_netdev_ops = {
 	.ndo_start_xmit		= cas_start_xmit,
 	.ndo_get_stats 		= cas_get_stats,
 	.ndo_set_rx_mode	= cas_set_multicast,
-	.ndo_do_ioctl		= cas_ioctl,
+	.ndo_eth_ioctl		= cas_ioctl,
 	.ndo_tx_timeout		= cas_tx_timeout,
 	.ndo_change_mtu		= cas_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 68695d4afacd..bba2057cfe6c 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9661,7 +9661,7 @@ static const struct net_device_ops niu_netdev_ops = {
 	.ndo_set_rx_mode	= niu_set_rx_mode,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= niu_set_mac_addr,
-	.ndo_do_ioctl		= niu_ioctl,
+	.ndo_eth_ioctl		= niu_ioctl,
 	.ndo_tx_timeout		= niu_tx_timeout,
 	.ndo_change_mtu		= niu_change_mtu,
 };
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 58f142ee78a3..6aac3b9debe9 100644
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
index 26aa7f32151f..ce22a5bc9130 100644
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
index 501d676fd88b..53de0bbdd0d7 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1405,7 +1405,7 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_tx_timeout		= am65_cpsw_nuss_ndo_host_tx_timeout,
 	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
-	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
+	.ndo_eth_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
 	.ndo_set_features	= am65_cpsw_nuss_ndo_slave_set_features,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
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
index 9fd1f77190ad..b0d3b0cf97e3 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1166,7 +1166,7 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_stop		= cpsw_ndo_stop,
 	.ndo_start_xmit		= cpsw_ndo_start_xmit,
 	.ndo_set_mac_address	= cpsw_ndo_set_mac_address,
-	.ndo_do_ioctl		= cpsw_ndo_ioctl,
+	.ndo_eth_ioctl		= cpsw_ndo_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= cpsw_ndo_tx_timeout,
 	.ndo_set_rx_mode	= cpsw_ndo_set_rx_mode,
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index f779d2e1b5c5..48d8087ee84d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1133,7 +1133,7 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_stop		= cpsw_ndo_stop,
 	.ndo_start_xmit		= cpsw_ndo_start_xmit,
 	.ndo_set_mac_address	= cpsw_ndo_set_mac_address,
-	.ndo_do_ioctl		= cpsw_ndo_ioctl,
+	.ndo_eth_ioctl		= cpsw_ndo_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= cpsw_ndo_tx_timeout,
 	.ndo_set_rx_mode	= cpsw_ndo_set_rx_mode,
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index c7031e1960d4..0f52b07add26 100644
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
index d7a144b4a09f..08d3ff0e7e71 100644
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
index 267c080ee084..06869c8cd234 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -750,7 +750,7 @@ static const struct net_device_ops tlan_netdev_ops = {
 	.ndo_tx_timeout		= tlan_tx_timeout,
 	.ndo_get_stats		= tlan_get_stats,
 	.ndo_set_rx_mode	= tlan_set_multicast_list,
-	.ndo_do_ioctl		= tlan_ioctl,
+	.ndo_eth_ioctl		= tlan_ioctl,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 5f5b33e6653b..165ae574c42b 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2197,7 +2197,7 @@ static const struct net_device_ops spider_net_ops = {
 	.ndo_start_xmit		= spider_net_xmit,
 	.ndo_set_rx_mode	= spider_net_set_multi,
 	.ndo_set_mac_address	= spider_net_set_mac,
-	.ndo_do_ioctl		= spider_net_do_ioctl,
+	.ndo_eth_ioctl		= spider_net_do_ioctl,
 	.ndo_tx_timeout		= spider_net_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	/* HW VLAN */
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 7a6e5ff8e5d4..de01d307617f 100644
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
index b65767f9e499..84ecc1ffa1c7 100644
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
index 60c199fcb91e..92328baf6389 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1218,7 +1218,7 @@ static const struct net_device_ops temac_netdev_ops = {
 	.ndo_set_rx_mode = temac_set_multicast_list,
 	.ndo_set_mac_address = temac_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = phy_do_ioctl_running,
+	.ndo_eth_ioctl = phy_do_ioctl_running,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = temac_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9aafd3ecdaa4..9d4e12f8f502 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1236,7 +1236,7 @@ static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = axienet_ioctl,
+	.ndo_eth_ioctl = axienet_ioctl,
 	.ndo_set_rx_mode = axienet_set_multicast_list,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = axienet_poll_controller,
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5bcc523..24126208cd29 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1266,7 +1266,7 @@ static const struct net_device_ops xemaclite_netdev_ops = {
 	.ndo_start_xmit		= xemaclite_send,
 	.ndo_set_mac_address	= xemaclite_set_mac_address,
 	.ndo_tx_timeout		= xemaclite_tx_timeout,
-	.ndo_do_ioctl		= xemaclite_ioctl,
+	.ndo_eth_ioctl		= xemaclite_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = xemaclite_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 3e337142b516..7d4360a37213 100644
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
index 2e5202923510..eef33fdae671 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1354,7 +1354,7 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_stop = eth_close,
 	.ndo_start_xmit = eth_xmit,
 	.ndo_set_rx_mode = eth_set_mcast_list,
-	.ndo_do_ioctl = eth_ioctl,
+	.ndo_eth_ioctl = eth_ioctl,
 	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
 };
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c8d803d3616c..aa466e04cb57 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -828,7 +828,7 @@ static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int macvlan_eth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct net_device *real_dev = macvlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
@@ -844,8 +844,8 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			break;
 		fallthrough;
 	case SIOCGHWTSTAMP:
-		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
-			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
+		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
+			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 		break;
 	}
 
@@ -1150,7 +1150,7 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_stop		= macvlan_stop,
 	.ndo_start_xmit		= macvlan_start_xmit,
 	.ndo_change_mtu		= macvlan_change_mtu,
-	.ndo_do_ioctl		= macvlan_do_ioctl,
+	.ndo_eth_ioctl		= macvlan_eth_ioctl,
 	.ndo_fix_features	= macvlan_fix_features,
 	.ndo_change_rx_flags	= macvlan_change_rx_flags,
 	.ndo_set_mac_address	= macvlan_set_mac_address,
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35525a671400..3f2721eb9e84 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -442,7 +442,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 EXPORT_SYMBOL(phy_mii_ioctl);
 
 /**
- * phy_do_ioctl - generic ndo_do_ioctl implementation
+ * phy_do_ioctl - generic ndo_eth_ioctl implementation
  * @dev: the net_device struct
  * @ifr: &struct ifreq for socket ioctl's
  * @cmd: ioctl cmd to execute
@@ -457,7 +457,7 @@ int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 EXPORT_SYMBOL(phy_do_ioctl);
 
 /**
- * phy_do_ioctl_running - generic ndo_do_ioctl implementation but test first
+ * phy_do_ioctl_running - generic ndo_eth_ioctl implementation but test first
  *
  * @dev: the net_device struct
  * @ifr: &struct ifreq for socket ioctl's
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index ef548beba684..9a14025535f9 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -197,7 +197,7 @@ static const struct net_device_ops ax88172_netdev_ops = {
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= asix_ioctl,
+	.ndo_eth_ioctl		= asix_ioctl,
 	.ndo_set_rx_mode	= ax88172_set_multicast,
 };
 
@@ -583,7 +583,7 @@ static const struct net_device_ops ax88772_netdev_ops = {
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= asix_ioctl,
+	.ndo_eth_ioctl		= asix_ioctl,
 	.ndo_set_rx_mode        = asix_set_multicast,
 };
 
@@ -1054,7 +1054,7 @@ static const struct net_device_ops ax88178_netdev_ops = {
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= asix_set_multicast,
-	.ndo_do_ioctl 		= asix_ioctl,
+	.ndo_eth_ioctl 		= asix_ioctl,
 	.ndo_change_mtu 	= ax88178_change_mtu,
 };
 
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index fd3a04d98dc1..8d491a897f0b 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -123,7 +123,7 @@ static const struct net_device_ops ax88172a_netdev_ops = {
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode        = asix_set_multicast,
 };
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5541f3faedbc..50ce53062320 100644
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
index 915ac75b55fc..e1b8900b0019 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -345,7 +345,7 @@ static const struct net_device_ops dm9601_netdev_ops = {
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= dm9601_ioctl,
+	.ndo_eth_ioctl 		= dm9601_ioctl,
 	.ndo_set_rx_mode	= dm9601_set_multicast,
 	.ndo_set_mac_address	= dm9601_set_mac_address,
 };
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 65b315bc60ab..2217d0bb25da 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3612,7 +3612,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
 	.ndo_change_mtu		= lan78xx_change_mtu,
 	.ndo_set_mac_address	= lan78xx_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= phy_do_ioctl_running,
+	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode	= lan78xx_set_multicast,
 	.ndo_set_features	= lan78xx_set_features,
 	.ndo_vlan_rx_add_vid	= lan78xx_vlan_rx_add_vid,
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 09bfa6a4dfbc..43443835fc6a 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -464,7 +464,7 @@ static const struct net_device_ops mcs7830_netdev_ops = {
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= mcs7830_ioctl,
+	.ndo_eth_ioctl 		= mcs7830_ioctl,
 	.ndo_set_rx_mode	= mcs7830_set_multicast,
 	.ndo_set_mac_address	= mcs7830_set_mac_address,
 };
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca5..c00581436d52 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6466,7 +6466,7 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 static const struct net_device_ops rtl8152_netdev_ops = {
 	.ndo_open		= rtl8152_open,
 	.ndo_stop		= rtl8152_close,
-	.ndo_do_ioctl		= rtl8152_ioctl,
+	.ndo_eth_ioctl		= rtl8152_ioctl,
 	.ndo_start_xmit		= rtl8152_start_xmit,
 	.ndo_tx_timeout		= rtl8152_tx_timeout,
 	.ndo_set_features	= rtl8152_set_features,
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 8689835a5214..e6155698ce33 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1439,7 +1439,7 @@ static const struct net_device_ops smsc75xx_netdev_ops = {
 	.ndo_change_mtu		= smsc75xx_change_mtu,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= smsc75xx_ioctl,
+	.ndo_eth_ioctl 		= smsc75xx_ioctl,
 	.ndo_set_rx_mode	= smsc75xx_set_multicast,
 	.ndo_set_features	= smsc75xx_set_features,
 };
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index ea0d5f04dc3a..fc115d330f50 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1044,7 +1044,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl 		= smsc95xx_ioctl,
+	.ndo_eth_ioctl 		= smsc95xx_ioctl,
 	.ndo_set_rx_mode	= smsc95xx_set_multicast,
 	.ndo_set_features	= smsc95xx_set_features,
 };
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index e04c8054c2cf..f044efb1cdb7 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -310,7 +310,7 @@ static const struct net_device_ops sr9700_netdev_ops = {
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= sr9700_ioctl,
+	.ndo_eth_ioctl		= sr9700_ioctl,
 	.ndo_set_rx_mode	= sr9700_set_multicast,
 	.ndo_set_mac_address	= sr9700_set_mac_address,
 };
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index 681e0def6356..06239fcd9291 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -684,7 +684,7 @@ static const struct net_device_ops sr9800_netdev_ops = {
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address	= sr_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= sr_ioctl,
+	.ndo_eth_ioctl		= sr_ioctl,
 	.ndo_set_rx_mode        = sr_set_multicast,
 };
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 28f6dda95736..53ddabad1286 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -873,7 +873,7 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_select_queue	= qeth_l2_select_queue,
 	.ndo_validate_addr	= qeth_l2_validate_addr,
 	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
-	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
 	.ndo_set_mac_address    = qeth_l2_set_mac_address,
 	.ndo_vlan_rx_add_vid	= qeth_l2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = qeth_l2_vlan_rx_kill_vid,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 546bebd264f2..d543a7b302b8 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1847,7 +1847,7 @@ static const struct net_device_ops qeth_l3_netdev_ops = {
 	.ndo_select_queue	= qeth_l3_iqd_select_queue,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
-	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_vlan_rx_add_vid	= qeth_l3_vlan_rx_add_vid,
@@ -1864,7 +1864,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_select_queue	= qeth_l3_osa_select_queue,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
-	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_vlan_rx_add_vid	= qeth_l3_vlan_rx_add_vid,
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 204f0b1e2739..ed6e8fbd797a 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -527,7 +527,7 @@ static const struct net_device_ops cvm_oct_npi_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -543,7 +543,7 @@ static const struct net_device_ops cvm_oct_xaui_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -559,7 +559,7 @@ static const struct net_device_ops cvm_oct_sgmii_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -573,7 +573,7 @@ static const struct net_device_ops cvm_oct_spi_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -589,7 +589,7 @@ static const struct net_device_ops cvm_oct_rgmii_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -602,7 +602,7 @@ static const struct net_device_ops cvm_oct_pow_netdev_ops = {
 	.ndo_start_xmit		= cvm_oct_xmit_pow,
 	.ndo_set_rx_mode	= cvm_oct_common_set_multicast_list,
 	.ndo_set_mac_address	= cvm_oct_common_set_mac_address,
-	.ndo_do_ioctl		= cvm_oct_ioctl,
+	.ndo_eth_ioctl		= cvm_oct_ioctl,
 	.ndo_change_mtu		= cvm_oct_common_change_mtu,
 	.ndo_get_stats		= cvm_oct_common_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 931a4a0668f6..387ab545069e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1019,6 +1019,10 @@ struct netdev_net_notifier {
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
@@ -1301,6 +1305,8 @@ struct net_device_ops {
 	int			(*ndo_validate_addr)(struct net_device *dev);
 	int			(*ndo_do_ioctl)(struct net_device *dev,
 					        struct ifreq *ifr, int cmd);
+	int			(*ndo_eth_ioctl)(struct net_device *dev,
+					        struct ifreq *ifr, int cmd);
 	int			(*ndo_siocdevprivate)(struct net_device *dev,
 						struct ifreq *ifr,
 						void __user *data, int cmd);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35429a140dfa..0c1286808e0c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -99,8 +99,8 @@ struct dsa_device_ops {
  * function pointers.
  */
 struct dsa_netdevice_ops {
-	int (*ndo_do_ioctl)(struct net_device *dev, struct ifreq *ifr,
-			    int cmd);
+	int (*ndo_eth_ioctl)(struct net_device *dev, struct ifreq *ifr,
+			     int cmd);
 };
 
 #define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
@@ -781,8 +781,8 @@ static inline int __dsa_netdevice_ops_check(struct net_device *dev)
 	return 0;
 }
 
-static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
-				   int cmd)
+static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
+				    int cmd)
 {
 	const struct dsa_netdevice_ops *ops;
 	int err;
@@ -793,11 +793,11 @@ static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
 
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
index ec8408d1638f..94d29cc958d4 100644
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
 
@@ -785,7 +785,7 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_set_mac_address	= vlan_dev_set_mac_address,
 	.ndo_set_rx_mode	= vlan_dev_set_rx_mode,
 	.ndo_change_rx_flags	= vlan_dev_change_rx_flags,
-	.ndo_do_ioctl		= vlan_dev_ioctl,
+	.ndo_eth_ioctl		= vlan_dev_ioctl,
 	.ndo_neigh_setup	= vlan_dev_neigh_setup,
 	.ndo_get_stats64	= vlan_dev_get_stats64,
 #if IS_ENABLED(CONFIG_FCOE)
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1fdacd7ab210..99efe8e2e0ce 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -249,19 +249,19 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	return 0;
 }
 
-static int dev_do_ioctl(struct net_device *dev,
-			struct ifreq *ifr, unsigned int cmd)
+static int dev_eth_ioctl(struct net_device *dev,
+			 struct ifreq *ifr, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = -EOPNOTSUPP;
 
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
@@ -269,6 +269,21 @@ static int dev_do_ioctl(struct net_device *dev,
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
@@ -368,19 +383,20 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
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
index c91de041a91d..fae8657b578d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -209,14 +209,14 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
index 3bc5ca40c9fb..c6e92530f777 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1592,7 +1592,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_fdb_add		= dsa_legacy_fdb_add,
 	.ndo_fdb_del		= dsa_legacy_fdb_del,
 	.ndo_fdb_dump		= dsa_slave_fdb_dump,
-	.ndo_do_ioctl		= dsa_slave_ioctl,
+	.ndo_eth_ioctl		= dsa_slave_ioctl,
 	.ndo_get_iflink		= dsa_slave_get_iflink,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_netpoll_setup	= dsa_slave_netpoll_setup,
-- 
2.27.0

