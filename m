Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF20742CB44
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJMUqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229883AbhJMUqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EC8E6054F;
        Wed, 13 Oct 2021 20:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157884;
        bh=VvvjwXNCbZrl5wuBADz1sL1DFQJPZadVit3HdivrQjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rp3VdZ19uh++jfeahPeYD2IH+pQo/cu14fCRgLcSutFE9XQP2tFld/k5aia9okLQK
         IaX/BjHaLMGBCQwOhNq8J2vzrfosgUe++mFrKiBhytjyYZ4Q0Q7PRsSmXzXXb5nLBE
         FnK488sbl3cqC8Mg3njHIU58qAkb5FmFMQzBnxnFqjiepZHvHJ4/mje4u6fqgf3bNd
         bodfyVzAYr5l7TRbrXdxs+Qmu2h6CaCV7OvSDQf1P010guZKObHBmerv+BUNxXPKGV
         2/e1qgs0Q2pgQKcdTWAh796lP+kURRyFCw4hLcMoiGRdQPnbnlS2ne8Fhj5WCn5dg/
         RCD6TT2pyLZLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/7] ethernet: constify references to netdev->dev_addr in drivers
Date:   Wed, 13 Oct 2021 13:44:29 -0700
Message-Id: <20211013204435.322561-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This big patch sprinkles const on local variables and
function arguments which may refer to netdev->dev_addr.

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Some of the changes here are not strictly required - const
is sometimes cast off but pointer is not used for writing.
It seems like it's still better to add the const in case
the code changes later or relevant -W flags get enabled
for the build.

No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
This patch is on the big side, but I figured time is better
invested in splitting up the patches which actually make
code changes.
---
 drivers/net/ethernet/actions/owl-emac.c              |  2 +-
 drivers/net/ethernet/adaptec/starfire.c              | 10 +++++-----
 drivers/net/ethernet/alacritech/slicoss.c            |  2 +-
 drivers/net/ethernet/alteon/acenic.c                 |  4 ++--
 drivers/net/ethernet/altera/altera_tse_main.c        |  2 +-
 drivers/net/ethernet/amd/nmclan_cs.c                 |  3 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c             |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h                 |  2 +-
 drivers/net/ethernet/apm/xgene-v2/mac.c              |  2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c       |  2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c    |  2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c    |  2 +-
 drivers/net/ethernet/apple/bmac.c                    |  8 ++++----
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h       |  6 +++---
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c   |  2 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c    |  4 ++--
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    |  4 ++--
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h    |  2 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c |  4 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c     |  4 ++--
 .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c |  2 +-
 drivers/net/ethernet/broadcom/b44.c                  |  6 ++++--
 drivers/net/ethernet/broadcom/bcmsysport.c           |  2 +-
 drivers/net/ethernet/broadcom/bgmac.c                |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c                 |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h          |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c     |  4 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h    |  3 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c      |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h      |  2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c       |  4 ++--
 drivers/net/ethernet/calxeda/xgmac.c                 |  2 +-
 drivers/net/ethernet/chelsio/cxgb/gmac.h             |  2 +-
 drivers/net/ethernet/chelsio/cxgb/pm3393.c           |  2 +-
 drivers/net/ethernet/chelsio/cxgb/vsc7326.c          |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h          |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/xgmac.c           |  2 +-
 drivers/net/ethernet/cisco/enic/enic_pp.c            |  2 +-
 drivers/net/ethernet/dlink/dl2k.c                    |  2 +-
 drivers/net/ethernet/dnet.c                          |  6 +++---
 drivers/net/ethernet/emulex/benet/be_cmds.c          |  2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h          |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c          |  2 +-
 drivers/net/ethernet/ethoc.c                         |  2 +-
 drivers/net/ethernet/fealnx.c                        |  2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c       |  4 ++--
 drivers/net/ethernet/freescale/fman/fman_dtsec.c     |  8 ++++----
 drivers/net/ethernet/freescale/fman/fman_dtsec.h     |  2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c     |  8 ++++----
 drivers/net/ethernet/freescale/fman/fman_memac.h     |  2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c      |  8 ++++----
 drivers/net/ethernet/freescale/fman/fman_tgec.h      |  2 +-
 drivers/net/ethernet/freescale/fman/mac.h            |  2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c          |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c        |  2 +-
 drivers/net/ethernet/hisilicon/hns/hnae.h            |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h    |  5 +++--
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c  |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h          |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c    |  2 +-
 drivers/net/ethernet/i825xx/sun3_82586.c             |  2 +-
 drivers/net/ethernet/intel/i40e/i40e.h               |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c            |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.h            |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c           |  2 +-
 drivers/net/ethernet/marvell/mvneta.c                |  4 ++--
 drivers/net/ethernet/marvell/pxa168_eth.c            |  6 +++---
 drivers/net/ethernet/mediatek/mtk_star_emac.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c      |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    |  2 +-
 drivers/net/ethernet/micrel/ks8842.c                 |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c                |  4 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c     |  3 ++-
 drivers/net/ethernet/neterion/s2io.c                 |  2 +-
 drivers/net/ethernet/neterion/s2io.h                 |  2 +-
 .../net/ethernet/netronome/nfp/flower/tunnel_conf.c  |  6 +++---
 drivers/net/ethernet/nxp/lpc_eth.c                   |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c            |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h        |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c             |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c           |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c            |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h            |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c           |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c             |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.h             |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c       |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c        |  2 +-
 drivers/net/ethernet/rdc/r6040.c                     | 12 ++++++------
 drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h    |  2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c      |  3 ++-
 drivers/net/ethernet/sfc/ef10.c                      |  4 ++--
 drivers/net/ethernet/sfc/ef10_sriov.c                |  2 +-
 drivers/net/ethernet/sfc/ef10_sriov.h                |  6 +++---
 drivers/net/ethernet/sfc/net_driver.h                |  2 +-
 drivers/net/ethernet/sfc/siena_sriov.c               |  2 +-
 drivers/net/ethernet/sfc/siena_sriov.h               |  2 +-
 drivers/net/ethernet/sis/sis900.c                    |  2 +-
 drivers/net/ethernet/smsc/smsc911x.c                 |  2 +-
 drivers/net/ethernet/smsc/smsc9420.c                 |  2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h         |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c  |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c     |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c      |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c  |  3 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h           |  3 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c   |  4 ++--
 drivers/net/ethernet/sun/sunbmac.c                   |  2 +-
 drivers/net/ethernet/sun/sunqe.c                     |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c        |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h           |  2 +-
 drivers/net/ethernet/ti/tlan.c                       |  4 ++--
 drivers/net/ethernet/toshiba/tc35815.c               |  3 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c        |  7 ++++---
 drivers/net/ethernet/xircom/xirc2ps_cs.c             |  2 +-
 drivers/net/phy/mscc/mscc_main.c                     |  2 +-
 drivers/net/usb/aqc111.c                             |  2 +-
 drivers/net/usb/ax88179_178a.c                       |  8 ++++----
 drivers/net/usb/catc.c                               |  2 +-
 drivers/net/usb/dm9601.c                             |  3 ++-
 drivers/net/usb/mcs7830.c                            |  3 ++-
 drivers/net/usb/sr9700.c                             |  3 ++-
 include/linux/qed/qed_eth_if.h                       |  2 +-
 include/linux/qed/qed_if.h                           |  2 +-
 include/linux/qed/qed_rdma_if.h                      |  3 ++-
 134 files changed, 202 insertions(+), 187 deletions(-)

diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index dce93acd1644..1cfdd01b4c2e 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -342,7 +342,7 @@ static u32 owl_emac_dma_cmd_stop(struct owl_emac_priv *priv)
 static void owl_emac_set_hw_mac_addr(struct net_device *netdev)
 {
 	struct owl_emac_priv *priv = netdev_priv(netdev);
-	u8 *mac_addr = netdev->dev_addr;
+	const u8 *mac_addr = netdev->dev_addr;
 	u32 addr_high, addr_low;
 
 	addr_high = mac_addr[0] << 8 | mac_addr[1];
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index e0f6cc910bd2..16b6b83f670b 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -955,7 +955,7 @@ static int netdev_open(struct net_device *dev)
 	writew(0, ioaddr + PerfFilterTable + 4);
 	writew(0, ioaddr + PerfFilterTable + 8);
 	for (i = 1; i < 16; i++) {
-		__be16 *eaddrs = (__be16 *)dev->dev_addr;
+		const __be16 *eaddrs = (const __be16 *)dev->dev_addr;
 		void __iomem *setup_frm = ioaddr + PerfFilterTable + i * 16;
 		writew(be16_to_cpu(eaddrs[2]), setup_frm); setup_frm += 4;
 		writew(be16_to_cpu(eaddrs[1]), setup_frm); setup_frm += 4;
@@ -1787,14 +1787,14 @@ static void set_rx_mode(struct net_device *dev)
 	} else if (netdev_mc_count(dev) <= 14) {
 		/* Use the 16 element perfect filter, skip first two entries. */
 		void __iomem *filter_addr = ioaddr + PerfFilterTable + 2 * 16;
-		__be16 *eaddrs;
+		const __be16 *eaddrs;
 		netdev_for_each_mc_addr(ha, dev) {
 			eaddrs = (__be16 *) ha->addr;
 			writew(be16_to_cpu(eaddrs[2]), filter_addr); filter_addr += 4;
 			writew(be16_to_cpu(eaddrs[1]), filter_addr); filter_addr += 4;
 			writew(be16_to_cpu(eaddrs[0]), filter_addr); filter_addr += 8;
 		}
-		eaddrs = (__be16 *)dev->dev_addr;
+		eaddrs = (const __be16 *)dev->dev_addr;
 		i = netdev_mc_count(dev) + 2;
 		while (i++ < 16) {
 			writew(be16_to_cpu(eaddrs[0]), filter_addr); filter_addr += 4;
@@ -1805,7 +1805,7 @@ static void set_rx_mode(struct net_device *dev)
 	} else {
 		/* Must use a multicast hash table. */
 		void __iomem *filter_addr;
-		__be16 *eaddrs;
+		const __be16 *eaddrs;
 		__le16 mc_filter[32] __attribute__ ((aligned(sizeof(long))));	/* Multicast hash filter */
 
 		memset(mc_filter, 0, sizeof(mc_filter));
@@ -1819,7 +1819,7 @@ static void set_rx_mode(struct net_device *dev)
 		}
 		/* Clear the perfect filter list, skip first two entries. */
 		filter_addr = ioaddr + PerfFilterTable + 2 * 16;
-		eaddrs = (__be16 *)dev->dev_addr;
+		eaddrs = (const __be16 *)dev->dev_addr;
 		for (i = 2; i < 16; i++) {
 			writew(be16_to_cpu(eaddrs[0]), filter_addr); filter_addr += 4;
 			writew(be16_to_cpu(eaddrs[1]), filter_addr); filter_addr += 4;
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 82f4f2608102..1fc9a1cd3ef8 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1008,7 +1008,7 @@ static void slic_set_link_autoneg(struct slic_device *sdev)
 
 static void slic_set_mac_address(struct slic_device *sdev)
 {
-	u8 *addr = sdev->netdev->dev_addr;
+	const u8 *addr = sdev->netdev->dev_addr;
 	u32 val;
 
 	val = addr[5] | addr[4] << 8 | addr[3] << 16 | addr[2] << 24;
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 7aaef593b031..eeb86bd851f9 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2712,7 +2712,7 @@ static int ace_set_mac_addr(struct net_device *dev, void *p)
 	struct ace_private *ap = netdev_priv(dev);
 	struct ace_regs __iomem *regs = ap->regs;
 	struct sockaddr *addr=p;
-	u8 *da;
+	const u8 *da;
 	struct cmd cmd;
 
 	if(netif_running(dev))
@@ -2720,7 +2720,7 @@ static int ace_set_mac_addr(struct net_device *dev, void *p)
 
 	eth_hw_addr_set(dev, addr->sa_data);
 
-	da = (u8 *)dev->dev_addr;
+	da = (const u8 *)dev->dev_addr;
 
 	writel(da[0] << 8 | da[1], &regs->MacAddrHi);
 	writel((da[2] << 24) | (da[3] << 16) | (da[4] << 8) | da[5],
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 7b75b0cd7ac9..d75d95a97dd9 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -849,7 +849,7 @@ static int init_phy(struct net_device *dev)
 	return 0;
 }
 
-static void tse_update_mac_addr(struct altera_tse_private *priv, u8 *addr)
+static void tse_update_mac_addr(struct altera_tse_private *priv, const u8 *addr)
 {
 	u32 msb;
 	u32 lsb;
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 2c07d15c8dfe..30ee5329bd7c 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -529,7 +529,8 @@ static void mace_write(mace_private *lp, unsigned int ioaddr, int reg,
 mace_init
 	Resets the MACE chip.
 ---------------------------------------------------------------------------- */
-static int mace_init(mace_private *lp, unsigned int ioaddr, char *enet_addr)
+static int mace_init(mace_private *lp, unsigned int ioaddr,
+		     const char *enet_addr)
 {
   int i;
   int ct = 0;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index d5fd49dd25f3..3936543a74d8 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -1080,7 +1080,7 @@ static int xgbe_add_mac_addresses(struct xgbe_prv_data *pdata)
 	return 0;
 }
 
-static int xgbe_set_mac_address(struct xgbe_prv_data *pdata, u8 *addr)
+static int xgbe_set_mac_address(struct xgbe_prv_data *pdata, const u8 *addr)
 {
 	unsigned int mac_addr_hi, mac_addr_lo;
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 3305979a9f7c..607a2c90513b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -729,7 +729,7 @@ struct xgbe_ext_stats {
 struct xgbe_hw_if {
 	int (*tx_complete)(struct xgbe_ring_desc *);
 
-	int (*set_mac_address)(struct xgbe_prv_data *, u8 *addr);
+	int (*set_mac_address)(struct xgbe_prv_data *, const u8 *addr);
 	int (*config_rx_mode)(struct xgbe_prv_data *);
 
 	int (*enable_rx_csum)(struct xgbe_prv_data *);
diff --git a/drivers/net/ethernet/apm/xgene-v2/mac.c b/drivers/net/ethernet/apm/xgene-v2/mac.c
index 2da979e4fad1..6423e22e05b2 100644
--- a/drivers/net/ethernet/apm/xgene-v2/mac.c
+++ b/drivers/net/ethernet/apm/xgene-v2/mac.c
@@ -65,7 +65,7 @@ void xge_mac_set_speed(struct xge_pdata *pdata)
 
 void xge_mac_set_station_addr(struct xge_pdata *pdata)
 {
-	u8 *dev_addr = pdata->ndev->dev_addr;
+	const u8 *dev_addr = pdata->ndev->dev_addr;
 	u32 addr0, addr1;
 
 	addr0 = (dev_addr[3] << 24) | (dev_addr[2] << 16) |
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
index 5f657879134e..e641dbbea1e2 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
@@ -378,8 +378,8 @@ u32 xgene_enet_rd_stat(struct xgene_enet_pdata *pdata, u32 rd_addr)
 
 static void xgene_gmac_set_mac_addr(struct xgene_enet_pdata *pdata)
 {
+	const u8 *dev_addr = pdata->ndev->dev_addr;
 	u32 addr0, addr1;
-	u8 *dev_addr = pdata->ndev->dev_addr;
 
 	addr0 = (dev_addr[3] << 24) | (dev_addr[2] << 16) |
 		(dev_addr[1] << 8) | dev_addr[0];
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
index f482ced2cadd..72b5e8eb0ec7 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -165,8 +165,8 @@ static void xgene_sgmac_reset(struct xgene_enet_pdata *p)
 
 static void xgene_sgmac_set_mac_addr(struct xgene_enet_pdata *p)
 {
+	const u8 *dev_addr = p->ndev->dev_addr;
 	u32 addr0, addr1;
-	u8 *dev_addr = p->ndev->dev_addr;
 
 	addr0 = (dev_addr[3] << 24) | (dev_addr[2] << 16) |
 		(dev_addr[1] << 8) | dev_addr[0];
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
index 304b5d43f236..86607b79c09f 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
@@ -207,8 +207,8 @@ static void xgene_pcs_reset(struct xgene_enet_pdata *pdata)
 
 static void xgene_xgmac_set_mac_addr(struct xgene_enet_pdata *pdata)
 {
+	const u8 *dev_addr = pdata->ndev->dev_addr;
 	u32 addr0, addr1;
-	u8 *dev_addr = pdata->ndev->dev_addr;
 
 	addr0 = (dev_addr[3] << 24) | (dev_addr[2] << 16) |
 		(dev_addr[1] << 8) | dev_addr[0];
diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a989d2df59ad..a63ec2005af3 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -308,7 +308,7 @@ bmac_init_registers(struct net_device *dev)
 {
 	struct bmac_data *bp = netdev_priv(dev);
 	volatile unsigned short regValue;
-	unsigned short *pWord16;
+	const unsigned short *pWord16;
 	int i;
 
 	/* XXDEBUG(("bmac: enter init_registers\n")); */
@@ -371,7 +371,7 @@ bmac_init_registers(struct net_device *dev)
 	bmwrite(dev, BHASH1, bp->hash_table_mask[2]); 	/* bits 47 - 32 */
 	bmwrite(dev, BHASH0, bp->hash_table_mask[3]); 	/* bits 63 - 48 */
 
-	pWord16 = (unsigned short *)dev->dev_addr;
+	pWord16 = (const unsigned short *)dev->dev_addr;
 	bmwrite(dev, MADD0, *pWord16++);
 	bmwrite(dev, MADD1, *pWord16++);
 	bmwrite(dev, MADD2, *pWord16);
@@ -522,7 +522,7 @@ static int bmac_set_address(struct net_device *dev, void *addr)
 {
 	struct bmac_data *bp = netdev_priv(dev);
 	unsigned char *p = addr;
-	unsigned short *pWord16;
+	const unsigned short *pWord16;
 	unsigned long flags;
 	int i;
 
@@ -533,7 +533,7 @@ static int bmac_set_address(struct net_device *dev, void *addr)
 		dev->dev_addr[i] = p[i];
 	}
 	/* load up the hardware address */
-	pWord16  = (unsigned short *)dev->dev_addr;
+	pWord16  = (const unsigned short *)dev->dev_addr;
 	bmwrite(dev, MADD0, *pWord16++);
 	bmwrite(dev, MADD1, *pWord16++);
 	bmwrite(dev, MADD2, *pWord16);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index bed481816ea3..062a300a566a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -217,7 +217,7 @@ struct aq_hw_ops {
 	int (*hw_ring_tx_head_update)(struct aq_hw_s *self,
 				      struct aq_ring_s *aq_ring);
 
-	int (*hw_set_mac_address)(struct aq_hw_s *self, u8 *mac_addr);
+	int (*hw_set_mac_address)(struct aq_hw_s *self, const u8 *mac_addr);
 
 	int (*hw_soft_reset)(struct aq_hw_s *self);
 
@@ -226,7 +226,7 @@ struct aq_hw_ops {
 
 	int (*hw_reset)(struct aq_hw_s *self);
 
-	int (*hw_init)(struct aq_hw_s *self, u8 *mac_addr);
+	int (*hw_init)(struct aq_hw_s *self, const u8 *mac_addr);
 
 	int (*hw_start)(struct aq_hw_s *self);
 
@@ -373,7 +373,7 @@ struct aq_fw_ops {
 	int (*set_phyloopback)(struct aq_hw_s *self, u32 mode, bool enable);
 
 	int (*set_power)(struct aq_hw_s *self, unsigned int power_state,
-			 u8 *mac);
+			 const u8 *mac);
 
 	int (*send_fw_request)(struct aq_hw_s *self,
 			       const struct hw_fw_request_iface *fw_req,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 4a6dfac857ca..02058fe79f52 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -35,7 +35,7 @@ static int aq_apply_macsec_cfg(struct aq_nic_s *nic);
 static int aq_apply_secy_cfg(struct aq_nic_s *nic,
 			     const struct macsec_secy *secy);
 
-static void aq_ether_addr_to_mac(u32 mac[2], unsigned char *emac)
+static void aq_ether_addr_to_mac(u32 mac[2], const unsigned char *emac)
 {
 	u32 tmp[2] = { 0 };
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 611875ef2cd1..4625ccb79499 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -322,7 +322,7 @@ static int hw_atl_a0_hw_init_rx_path(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_a0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
+static int hw_atl_a0_hw_mac_addr_set(struct aq_hw_s *self, const u8 *mac_addr)
 {
 	unsigned int h = 0U;
 	unsigned int l = 0U;
@@ -348,7 +348,7 @@ static int hw_atl_a0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 	return err;
 }
 
-static int hw_atl_a0_hw_init(struct aq_hw_s *self, u8 *mac_addr)
+static int hw_atl_a0_hw_init(struct aq_hw_s *self, const u8 *mac_addr)
 {
 	static u32 aq_hw_atl_igcr_table_[4][2] = {
 		[AQ_HW_IRQ_INVALID] = { 0x20000000U, 0x20000000U },
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 9f1b15077e7d..d875ce3ec759 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -533,7 +533,7 @@ static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
-int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
+int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, const u8 *mac_addr)
 {
 	unsigned int h = 0U;
 	unsigned int l = 0U;
@@ -558,7 +558,7 @@ int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 	return err;
 }
 
-static int hw_atl_b0_hw_init(struct aq_hw_s *self, u8 *mac_addr)
+static int hw_atl_b0_hw_init(struct aq_hw_s *self, const u8 *mac_addr)
 {
 	static u32 aq_hw_atl_igcr_table_[4][2] = {
 		[AQ_HW_IRQ_INVALID] = { 0x20000000U, 0x20000000U },
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index d8db972113ec..5298846dd9f7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -58,7 +58,7 @@ int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring);
 
 void hw_atl_b0_hw_init_rx_rss_ctrl1(struct aq_hw_s *self);
 
-int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
+int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, const u8 *mac_addr);
 
 int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc);
 int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool enable);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 404cbf60d3f2..fc0e66006644 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -944,7 +944,7 @@ u32 hw_atl_utils_get_fw_version(struct aq_hw_s *self)
 }
 
 static int aq_fw1x_set_wake_magic(struct aq_hw_s *self, bool wol_enabled,
-				  u8 *mac)
+				  const u8 *mac)
 {
 	struct hw_atl_utils_fw_rpc *prpc = NULL;
 	unsigned int rpc_size = 0U;
@@ -987,7 +987,7 @@ static int aq_fw1x_set_wake_magic(struct aq_hw_s *self, bool wol_enabled,
 }
 
 static int aq_fw1x_set_power(struct aq_hw_s *self, unsigned int power_state,
-			     u8 *mac)
+			     const u8 *mac)
 {
 	struct hw_atl_utils_fw_rpc *prpc = NULL;
 	unsigned int rpc_size = 0U;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index ee0c22d04935..eac631c45c56 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -358,7 +358,7 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self, int *temp)
 	return 0;
 }
 
-static int aq_fw2x_set_wol(struct aq_hw_s *self, u8 *mac)
+static int aq_fw2x_set_wol(struct aq_hw_s *self, const u8 *mac)
 {
 	struct hw_atl_utils_fw_rpc *rpc = NULL;
 	struct offload_info *info = NULL;
@@ -404,7 +404,7 @@ static int aq_fw2x_set_wol(struct aq_hw_s *self, u8 *mac)
 }
 
 static int aq_fw2x_set_power(struct aq_hw_s *self, unsigned int power_state,
-			     u8 *mac)
+			     const u8 *mac)
 {
 	int err = 0;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 92f64048bf69..c98708bb044c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -516,7 +516,7 @@ static int hw_atl2_hw_init_rx_path(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
+static int hw_atl2_hw_init(struct aq_hw_s *self, const u8 *mac_addr)
 {
 	static u32 aq_hw_atl2_igcr_table_[4][2] = {
 		[AQ_HW_IRQ_INVALID] = { 0x20000000U, 0x20000000U },
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 55c9e6fcb471..969591bbc066 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -218,7 +218,8 @@ static inline void __b44_cam_read(struct b44 *bp, unsigned char *data, int index
 	data[1] = (val >> 0) & 0xFF;
 }
 
-static inline void __b44_cam_write(struct b44 *bp, unsigned char *data, int index)
+static inline void __b44_cam_write(struct b44 *bp,
+				   const unsigned char *data, int index)
 {
 	u32 val;
 
@@ -1507,7 +1508,8 @@ static void bwfilter_table(struct b44 *bp, u8 *pp, u32 bytes, u32 table_offset)
 	}
 }
 
-static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
+static int b44_magic_pattern(const u8 *macaddr, u8 *ppattern, u8 *pmask,
+			     int offset)
 {
 	int magicsync = 6;
 	int k, j, len = offset;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b813745e8de3..40933bf5a710 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1818,7 +1818,7 @@ static inline void umac_reset(struct bcm_sysport_priv *priv)
 }
 
 static void umac_set_hw_addr(struct bcm_sysport_priv *priv,
-			     unsigned char *addr)
+			     const unsigned char *addr)
 {
 	u32 mac0 = (addr[0] << 24) | (addr[1] << 16) | (addr[2] << 8) |
 		    addr[3];
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index d2c7834850cc..7b525c65bacb 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -768,7 +768,7 @@ static void bgmac_umac_cmd_maskset(struct bgmac *bgmac, u32 mask, u32 set,
 	udelay(2);
 }
 
-static void bgmac_write_mac_address(struct bgmac *bgmac, u8 *addr)
+static void bgmac_write_mac_address(struct bgmac *bgmac, const u8 *addr)
 {
 	u32 tmp;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 248b81249cb0..babc955ba64e 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -2704,7 +2704,7 @@ bnx2_alloc_bad_rbuf(struct bnx2 *bp)
 }
 
 static void
-bnx2_set_mac_addr(struct bnx2 *bp, u8 *mac_addr, u32 pos)
+bnx2_set_mac_addr(struct bnx2 *bp, const u8 *mac_addr, u32 pos)
 {
 	u32 val;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index e789430f407c..2b06d78baa08 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1994,7 +1994,7 @@ int bnx2x_idle_chk(struct bnx2x *bp);
  * operation has been successfully scheduled and a negative - if a requested
  * operations has failed.
  */
-int bnx2x_set_mac_one(struct bnx2x *bp, u8 *mac,
+int bnx2x_set_mac_one(struct bnx2x *bp, const u8 *mac,
 		      struct bnx2x_vlan_mac_obj *obj, bool set,
 		      int mac_type, unsigned long *ramrod_flags);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index ef49e38ae027..27e712178f95 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8417,7 +8417,7 @@ int bnx2x_alloc_mem(struct bnx2x *bp)
  * Init service functions
  */
 
-int bnx2x_set_mac_one(struct bnx2x *bp, u8 *mac,
+int bnx2x_set_mac_one(struct bnx2x *bp, const u8 *mac,
 		      struct bnx2x_vlan_mac_obj *obj, bool set,
 		      int mac_type, unsigned long *ramrod_flags)
 {
@@ -9146,7 +9146,7 @@ u32 bnx2x_send_unload_req(struct bnx2x *bp, int unload_mode)
 
 	else if (bp->wol) {
 		u32 emac_base = port ? GRCBASE_EMAC1 : GRCBASE_EMAC0;
-		u8 *mac_addr = bp->dev->dev_addr;
+		const u8 *mac_addr = bp->dev->dev_addr;
 		struct pci_dev *pdev = bp->pdev;
 		u32 val;
 		u16 pmc;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index 966d5722c5e2..8c2cf5519787 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -508,7 +508,8 @@ int bnx2x_vfpf_init(struct bnx2x *bp);
 void bnx2x_vfpf_close_vf(struct bnx2x *bp);
 int bnx2x_vfpf_setup_q(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 		       bool is_leading);
-int bnx2x_vfpf_config_mac(struct bnx2x *bp, u8 *addr, u8 vf_qid, bool set);
+int bnx2x_vfpf_config_mac(struct bnx2x *bp, const u8 *addr, u8 vf_qid,
+			  bool set);
 int bnx2x_vfpf_config_rss(struct bnx2x *bp,
 			  struct bnx2x_config_rss_params *params);
 int bnx2x_vfpf_set_mcast(struct net_device *dev);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index 7c96f943c6f3..c9129b9ba446 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -721,7 +721,7 @@ static int bnx2x_vfpf_teardown_queue(struct bnx2x *bp, int qidx)
 }
 
 /* request pf to add a mac for the vf */
-int bnx2x_vfpf_config_mac(struct bnx2x *bp, u8 *addr, u8 vf_qid, bool set)
+int bnx2x_vfpf_config_mac(struct bnx2x *bp, const u8 *addr, u8 vf_qid, bool set)
 {
 	struct vfpf_set_q_filters_tlv *req = &bp->vf2pf_mbox->req.set_q_filters;
 	struct pfvf_general_resp_tlv *resp = &bp->vf2pf_mbox->resp.general_resp;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 800020f4d79d..66263aa0d96b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4869,7 +4869,7 @@ static int bnxt_hwrm_cfa_ntuple_filter_alloc(struct bnxt *bp,
 #endif
 
 static int bnxt_hwrm_set_vnic_filter(struct bnxt *bp, u16 vnic_id, u16 idx,
-				     u8 *mac_addr)
+				     const u8 *mac_addr)
 {
 	struct hwrm_cfa_l2_filter_alloc_output *resp;
 	struct hwrm_cfa_l2_filter_alloc_input *req;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index d4ebc5d710ba..69bff23cc867 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -1151,7 +1151,7 @@ void bnxt_hwrm_exec_fwd_req(struct bnxt *bp)
 	}
 }
 
-int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
+int bnxt_approve_mac(struct bnxt *bp, const u8 *mac, bool strict)
 {
 	struct hwrm_func_vf_cfg_input *req;
 	int rc = 0;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
index 995535e4c11b..9a4bacba477b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
@@ -41,5 +41,5 @@ int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset);
 void bnxt_sriov_disable(struct bnxt *);
 void bnxt_hwrm_exec_fwd_req(struct bnxt *);
 void bnxt_update_vf_mac(struct bnxt *);
-int bnxt_approve_mac(struct bnxt *, u8 *, bool);
+int bnxt_approve_mac(struct bnxt *, const u8 *, bool);
 #endif
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 83c55e7b099f..ed53859b6f7d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3266,7 +3266,7 @@ static void bcmgenet_umac_reset(struct bcmgenet_priv *priv)
 }
 
 static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
-				 unsigned char *addr)
+				 const unsigned char *addr)
 {
 	bcmgenet_umac_writel(priv, get_unaligned_be32(&addr[0]), UMAC_MAC0);
 	bcmgenet_umac_writel(priv, get_unaligned_be16(&addr[4]), UMAC_MAC1);
@@ -3560,7 +3560,7 @@ static void bcmgenet_timeout(struct net_device *dev, unsigned int txqueue)
 #define MAX_MDF_FILTER	17
 
 static inline void bcmgenet_set_mdf_addr(struct bcmgenet_priv *priv,
-					 unsigned char *addr,
+					 const unsigned char *addr,
 					 int *i)
 {
 	bcmgenet_umac_writel(priv, addr[0] << 8 | addr[1],
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index dc51f36fdf2a..9ad89a53c3e6 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -607,7 +607,7 @@ static inline void xgmac_mac_disable(void __iomem *ioaddr)
 	writel(value, ioaddr + XGMAC_CONTROL);
 }
 
-static void xgmac_set_mac_addr(void __iomem *ioaddr, unsigned char *addr,
+static void xgmac_set_mac_addr(void __iomem *ioaddr, const unsigned char *addr,
 			       int num)
 {
 	u32 data;
diff --git a/drivers/net/ethernet/chelsio/cxgb/gmac.h b/drivers/net/ethernet/chelsio/cxgb/gmac.h
index dfa77491a910..5913eaf442b5 100644
--- a/drivers/net/ethernet/chelsio/cxgb/gmac.h
+++ b/drivers/net/ethernet/chelsio/cxgb/gmac.h
@@ -117,7 +117,7 @@ struct cmac_ops {
 	const struct cmac_statistics *(*statistics_update)(struct cmac *, int);
 
 	int (*macaddress_get)(struct cmac *, u8 mac_addr[6]);
-	int (*macaddress_set)(struct cmac *, u8 mac_addr[6]);
+	int (*macaddress_set)(struct cmac *, const u8 mac_addr[6]);
 };
 
 typedef struct _cmac_instance cmac_instance;
diff --git a/drivers/net/ethernet/chelsio/cxgb/pm3393.c b/drivers/net/ethernet/chelsio/cxgb/pm3393.c
index c27908e66f5e..0bb37e4680c7 100644
--- a/drivers/net/ethernet/chelsio/cxgb/pm3393.c
+++ b/drivers/net/ethernet/chelsio/cxgb/pm3393.c
@@ -496,7 +496,7 @@ static int pm3393_macaddress_get(struct cmac *cmac, u8 mac_addr[6])
 	return 0;
 }
 
-static int pm3393_macaddress_set(struct cmac *cmac, u8 ma[6])
+static int pm3393_macaddress_set(struct cmac *cmac, const u8 ma[6])
 {
 	u32 val, lo, mid, hi, enabled = cmac->instance->enabled;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/vsc7326.c b/drivers/net/ethernet/chelsio/cxgb/vsc7326.c
index a19284bdb80e..2ad3efb550c2 100644
--- a/drivers/net/ethernet/chelsio/cxgb/vsc7326.c
+++ b/drivers/net/ethernet/chelsio/cxgb/vsc7326.c
@@ -379,7 +379,7 @@ static int mac_intr_clear(struct cmac *mac)
 }
 
 /* Expect MAC address to be in network byte order. */
-static int mac_set_address(struct cmac* mac, u8 addr[6])
+static int mac_set_address(struct cmac* mac, const u8 addr[6])
 {
 	u32 val;
 	int port = mac->instance->index;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/common.h b/drivers/net/ethernet/chelsio/cxgb3/common.h
index b706f2fbe4f4..a309016f7f8c 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/common.h
@@ -710,7 +710,7 @@ int t3_mac_enable(struct cmac *mac, int which);
 int t3_mac_disable(struct cmac *mac, int which);
 int t3_mac_set_mtu(struct cmac *mac, unsigned int mtu);
 int t3_mac_set_rx_mode(struct cmac *mac, struct net_device *dev);
-int t3_mac_set_address(struct cmac *mac, unsigned int idx, u8 addr[6]);
+int t3_mac_set_address(struct cmac *mac, unsigned int idx, const u8 addr[6]);
 int t3_mac_set_num_ucast(struct cmac *mac, int n);
 const struct mac_stats *t3_mac_update_stats(struct cmac *mac);
 int t3_mac_set_speed_duplex_fc(struct cmac *mac, int speed, int duplex, int fc);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/xgmac.c b/drivers/net/ethernet/chelsio/cxgb3/xgmac.c
index 3af19a550372..1bdc6cad1e49 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/xgmac.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/xgmac.c
@@ -240,7 +240,7 @@ static void set_addr_filter(struct cmac *mac, int idx, const u8 * addr)
 }
 
 /* Set one of the station's unicast MAC addresses. */
-int t3_mac_set_address(struct cmac *mac, unsigned int idx, u8 addr[6])
+int t3_mac_set_address(struct cmac *mac, unsigned int idx, const u8 addr[6])
 {
 	if (idx >= mac->nucast)
 		return -EINVAL;
diff --git a/drivers/net/ethernet/cisco/enic/enic_pp.c b/drivers/net/ethernet/cisco/enic/enic_pp.c
index e6a83198c3dd..80f46dbd5117 100644
--- a/drivers/net/ethernet/cisco/enic/enic_pp.c
+++ b/drivers/net/ethernet/cisco/enic/enic_pp.c
@@ -73,9 +73,9 @@ static int enic_set_port_profile(struct enic *enic, int vf)
 	struct vic_provinfo *vp;
 	const u8 oui[3] = VIC_PROVINFO_CISCO_OUI;
 	const __be16 os_type = htons(VIC_GENERIC_PROV_OS_TYPE_LINUX);
+	const u8 *client_mac;
 	char uuid_str[38];
 	char client_mac_str[18];
-	u8 *client_mac;
 	int err;
 
 	ENIC_PP_BY_INDEX(enic, vf, pp, &err);
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 202ecb132053..993bba0ffb16 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -567,7 +567,7 @@ static void rio_hw_init(struct net_device *dev)
 	 */
 	for (i = 0; i < 3; i++)
 		dw16(StationAddr0 + 2 * i,
-		     cpu_to_le16(((u16 *)dev->dev_addr)[i]));
+		     cpu_to_le16(((const u16 *)dev->dev_addr)[i]));
 
 	set_multicast (dev);
 	if (np->coalesce) {
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 6c51cf991dad..3ed21ba4eb99 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -60,11 +60,11 @@ static void __dnet_set_hwaddr(struct dnet *bp)
 {
 	u16 tmp;
 
-	tmp = be16_to_cpup((__be16 *)bp->dev->dev_addr);
+	tmp = be16_to_cpup((const __be16 *)bp->dev->dev_addr);
 	dnet_writew_mac(bp, DNET_INTERNAL_MAC_ADDR_0_REG, tmp);
-	tmp = be16_to_cpup((__be16 *)(bp->dev->dev_addr + 2));
+	tmp = be16_to_cpup((const __be16 *)(bp->dev->dev_addr + 2));
 	dnet_writew_mac(bp, DNET_INTERNAL_MAC_ADDR_1_REG, tmp);
-	tmp = be16_to_cpup((__be16 *)(bp->dev->dev_addr + 4));
+	tmp = be16_to_cpup((const __be16 *)(bp->dev->dev_addr + 4));
 	dnet_writew_mac(bp, DNET_INTERNAL_MAC_ADDR_2_REG, tmp);
 }
 
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 649c5c429bd7..528eb0f223b1 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1080,7 +1080,7 @@ int be_cmd_mac_addr_query(struct be_adapter *adapter, u8 *mac_addr,
 }
 
 /* Uses synchronous MCCQ */
-int be_cmd_pmac_add(struct be_adapter *adapter, u8 *mac_addr,
+int be_cmd_pmac_add(struct be_adapter *adapter, const u8 *mac_addr,
 		    u32 if_id, u32 *pmac_id, u32 domain)
 {
 	struct be_mcc_wrb *wrb;
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.h b/drivers/net/ethernet/emulex/benet/be_cmds.h
index c30d6d6f0f3a..db1f3b908582 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.h
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.h
@@ -2385,7 +2385,7 @@ int be_pci_fnum_get(struct be_adapter *adapter);
 int be_fw_wait_ready(struct be_adapter *adapter);
 int be_cmd_mac_addr_query(struct be_adapter *adapter, u8 *mac_addr,
 			  bool permanent, u32 if_handle, u32 pmac_id);
-int be_cmd_pmac_add(struct be_adapter *adapter, u8 *mac_addr, u32 if_id,
+int be_cmd_pmac_add(struct be_adapter *adapter, const u8 *mac_addr, u32 if_id,
 		    u32 *pmac_id, u32 domain);
 int be_cmd_pmac_del(struct be_adapter *adapter, u32 if_id, int pmac_id,
 		    u32 domain);
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 736a6ea86eb1..d51f24c9e1b8 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -272,7 +272,7 @@ void be_cq_notify(struct be_adapter *adapter, u16 qid, bool arm, u16 num_popped)
 	iowrite32(val, adapter->db + DB_CQ_OFFSET);
 }
 
-static int be_dev_mac_add(struct be_adapter *adapter, u8 *mac)
+static int be_dev_mac_add(struct be_adapter *adapter, const u8 *mac)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index cd3a3b8f23b6..ed2ef167cdb2 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -802,8 +802,8 @@ static int ethoc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static void ethoc_do_set_mac_address(struct net_device *dev)
 {
+	const unsigned char *mac = dev->dev_addr;
 	struct ethoc *priv = netdev_priv(dev);
-	unsigned char *mac = dev->dev_addr;
 
 	ethoc_write(priv, MAC_ADDR0, (mac[2] << 24) | (mac[3] << 16) |
 				     (mac[4] <<  8) | (mac[5] <<  0));
diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index 25c91b3c5fd3..63c935e7b625 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -827,7 +827,7 @@ static int netdev_open(struct net_device *dev)
 		return -EAGAIN;
 
 	for (i = 0; i < 3; i++)
-		iowrite16(((unsigned short*)dev->dev_addr)[i],
+		iowrite16(((const unsigned short *)dev->dev_addr)[i],
 				ioaddr + PAR0 + i*2);
 
 	init_ring(dev);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index cd8a7d94f60c..6b2927d863e2 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -272,7 +272,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	} else {
 		eth_hw_addr_random(net_dev);
 		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
-			(enet_addr_t *)net_dev->dev_addr);
+			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
 			return -EINVAL;
@@ -452,7 +452,7 @@ static int dpaa_set_mac_address(struct net_device *net_dev, void *addr)
 	mac_dev = priv->mac_dev;
 
 	err = mac_dev->change_addr(mac_dev->fman_mac,
-				   (enet_addr_t *)net_dev->dev_addr);
+				   (const enet_addr_t *)net_dev->dev_addr);
 	if (err < 0) {
 		netif_err(priv, drv, net_dev, "mac_dev->change_addr() = %d\n",
 			  err);
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index bce3c9398887..1950a8936bc0 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -366,7 +366,7 @@ static void set_dflts(struct dtsec_cfg *cfg)
 	cfg->maximum_frame = DEFAULT_MAXIMUM_FRAME;
 }
 
-static void set_mac_address(struct dtsec_regs __iomem *regs, u8 *adr)
+static void set_mac_address(struct dtsec_regs __iomem *regs, const u8 *adr)
 {
 	u32 tmp;
 
@@ -516,7 +516,7 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 
 	if (addr) {
 		MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
-		set_mac_address(regs, (u8 *)eth_addr);
+		set_mac_address(regs, (const u8 *)eth_addr);
 	}
 
 	/* HASH */
@@ -1022,7 +1022,7 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 	return 0;
 }
 
-int dtsec_modify_mac_address(struct fman_mac *dtsec, enet_addr_t *enet_addr)
+int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	enum comm_mode mode = COMM_MODE_NONE;
@@ -1041,7 +1041,7 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, enet_addr_t *enet_addr)
 	 * Station address have to be swapped (big endian to little endian
 	 */
 	dtsec->addr = ENET_ADDR_TO_UINT64(*enet_addr);
-	set_mac_address(dtsec->regs, (u8 *)(*enet_addr));
+	set_mac_address(dtsec->regs, (const u8 *)(*enet_addr));
 
 	graceful_start(dtsec, mode);
 
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index 5149d96ec2c1..68512c3bd6e5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -37,7 +37,7 @@
 
 struct fman_mac *dtsec_config(struct fman_mac_params *params);
 int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val);
-int dtsec_modify_mac_address(struct fman_mac *dtsec, enet_addr_t *enet_addr);
+int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr);
 int dtsec_adjust_link(struct fman_mac *dtsec,
 		      u16 speed);
 int dtsec_restart_autoneg(struct fman_mac *dtsec);
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 62f42921933d..2216b7f51d26 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -354,7 +354,7 @@ struct fman_mac {
 	bool allmulti_enabled;
 };
 
-static void add_addr_in_paddr(struct memac_regs __iomem *regs, u8 *adr,
+static void add_addr_in_paddr(struct memac_regs __iomem *regs, const u8 *adr,
 			      u8 paddr_num)
 {
 	u32 tmp0, tmp1;
@@ -897,12 +897,12 @@ int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	return 0;
 }
 
-int memac_modify_mac_address(struct fman_mac *memac, enet_addr_t *enet_addr)
+int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(memac->memac_drv_param))
 		return -EINVAL;
 
-	add_addr_in_paddr(memac->regs, (u8 *)(*enet_addr), 0);
+	add_addr_in_paddr(memac->regs, (const u8 *)(*enet_addr), 0);
 
 	return 0;
 }
@@ -1058,7 +1058,7 @@ int memac_init(struct fman_mac *memac)
 	/* MAC Address */
 	if (memac->addr != 0) {
 		MAKE_ENET_ADDR_FROM_UINT64(memac->addr, eth_addr);
-		add_addr_in_paddr(memac->regs, (u8 *)eth_addr, 0);
+		add_addr_in_paddr(memac->regs, (const u8 *)eth_addr, 0);
 	}
 
 	fixed_link = memac_drv_param->fixed_link;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index b2c671ec0ce7..3820f7a22983 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -40,7 +40,7 @@
 
 struct fman_mac *memac_config(struct fman_mac_params *params);
 int memac_set_promiscuous(struct fman_mac *memac, bool new_val);
-int memac_modify_mac_address(struct fman_mac *memac, enet_addr_t *enet_addr);
+int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr);
 int memac_adjust_link(struct fman_mac *memac, u16 speed);
 int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val);
 int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 41946b16f6c7..311c1906e044 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -221,7 +221,7 @@ struct fman_mac {
 	bool allmulti_enabled;
 };
 
-static void set_mac_address(struct tgec_regs __iomem *regs, u8 *adr)
+static void set_mac_address(struct tgec_regs __iomem *regs, const u8 *adr)
 {
 	u32 tmp0, tmp1;
 
@@ -514,13 +514,13 @@ int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 	return 0;
 }
 
-int tgec_modify_mac_address(struct fman_mac *tgec, enet_addr_t *p_enet_addr)
+int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_addr)
 {
 	if (!is_init_done(tgec->cfg))
 		return -EINVAL;
 
 	tgec->addr = ENET_ADDR_TO_UINT64(*p_enet_addr);
-	set_mac_address(tgec->regs, (u8 *)(*p_enet_addr));
+	set_mac_address(tgec->regs, (const u8 *)(*p_enet_addr));
 
 	return 0;
 }
@@ -704,7 +704,7 @@ int tgec_init(struct fman_mac *tgec)
 
 	if (tgec->addr) {
 		MAKE_ENET_ADDR_FROM_UINT64(tgec->addr, eth_addr);
-		set_mac_address(tgec->regs, (u8 *)eth_addr);
+		set_mac_address(tgec->regs, (const u8 *)eth_addr);
 	}
 
 	/* interrupts */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 3bfd1062b386..b28b20b26148 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -37,7 +37,7 @@
 
 struct fman_mac *tgec_config(struct fman_mac_params *params);
 int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val);
-int tgec_modify_mac_address(struct fman_mac *tgec, enet_addr_t *enet_addr);
+int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *enet_addr);
 int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val);
 int tgec_enable(struct fman_mac *tgec, enum comm_mode mode);
 int tgec_disable(struct fman_mac *tgec, enum comm_mode mode);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 824a81a9f350..daa285a9b8b2 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -66,7 +66,7 @@ struct mac_device {
 	int (*stop)(struct mac_device *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
-	int (*change_addr)(struct fman_mac *mac_dev, enet_addr_t *enet_addr);
+	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
 	int (*set_allmulti)(struct fman_mac *mac_dev, bool enable);
 	int (*set_tstamp)(struct fman_mac *mac_dev, bool enable);
 	int (*set_multi)(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 29190eb890c8..a6c18b6527f9 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -427,7 +427,7 @@ static void hisi_femac_free_skb_rings(struct hisi_femac_priv *priv)
 }
 
 static int hisi_femac_set_hw_mac_addr(struct hisi_femac_priv *priv,
-				      unsigned char *mac)
+				      const unsigned char *mac)
 {
 	u32 reg;
 
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 5f7ccdc834b7..d7e62eca050f 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -429,7 +429,7 @@ static void hix5hd2_port_disable(struct hix5hd2_priv *priv)
 static void hix5hd2_hw_set_mac_addr(struct net_device *dev)
 {
 	struct hix5hd2_priv *priv = netdev_priv(dev);
-	unsigned char *mac = dev->dev_addr;
+	const unsigned char *mac = dev->dev_addr;
 	u32 val;
 
 	val = mac[1] | (mac[0] << 8);
diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.h b/drivers/net/ethernet/hisilicon/hns/hnae.h
index d46e8f999019..d72657444ef3 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.h
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
@@ -499,7 +499,7 @@ struct hnae_ae_ops {
 				   u32 *tx_usecs_high, u32 *rx_usecs_high);
 	void (*set_promisc_mode)(struct hnae_handle *handle, u32 en);
 	int (*get_mac_addr)(struct hnae_handle *handle, void **p);
-	int (*set_mac_addr)(struct hnae_handle *handle, void *p);
+	int (*set_mac_addr)(struct hnae_handle *handle, const void *p);
 	int (*add_uc_addr)(struct hnae_handle *handle,
 			   const unsigned char *addr);
 	int (*rm_uc_addr)(struct hnae_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
index e81116ad9bdf..bc3e406f0139 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
@@ -206,7 +206,7 @@ static void hns_ae_fini_queue(struct hnae_queue *q)
 		hns_rcb_reset_ring_hw(q);
 }
 
-static int hns_ae_set_mac_address(struct hnae_handle *handle, void *p)
+static int hns_ae_set_mac_address(struct hnae_handle *handle, const void *p)
 {
 	int ret;
 	struct hns_mac_cb *mac_cb = hns_get_mac_cb(handle);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
index f387a859a201..8f391e2adcc0 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
@@ -450,7 +450,7 @@ static void hns_gmac_update_stats(void *mac_drv)
 		+= dsaf_read_dev(drv, GMAC_TX_PAUSE_FRAMES_REG);
 }
 
-static void hns_gmac_set_mac_addr(void *mac_drv, char *mac_addr)
+static void hns_gmac_set_mac_addr(void *mac_drv, const char *mac_addr)
 {
 	struct mac_driver *drv = (struct mac_driver *)mac_drv;
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index f41379de2186..7edf8569514c 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -240,7 +240,7 @@ int hns_mac_get_inner_port_num(struct hns_mac_cb *mac_cb, u8 vmid, u8 *port_num)
  *@addr:mac address
  */
 int hns_mac_change_vf_addr(struct hns_mac_cb *mac_cb,
-			   u32 vmid, char *addr)
+			   u32 vmid, const char *addr)
 {
 	int ret;
 	struct mac_driver *mac_ctrl_drv = hns_mac_get_drv(mac_cb);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
index 8943ffab4418..e3bb05959ba9 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
@@ -348,7 +348,7 @@ struct mac_driver {
 	/*disable mac when disable nic or dsaf*/
 	void (*mac_disable)(void *mac_drv, enum mac_commom_mode mode);
 	/* config mac address*/
-	void (*set_mac_addr)(void *mac_drv,	char *mac_addr);
+	void (*set_mac_addr)(void *mac_drv,	const char *mac_addr);
 	/*adjust mac mode of port,include speed and duplex*/
 	int (*adjust_link)(void *mac_drv, enum mac_speed speed,
 			   u32 full_duplex);
@@ -425,7 +425,8 @@ int hns_mac_init(struct dsaf_device *dsaf_dev);
 void mac_adjust_link(struct net_device *net_dev);
 bool hns_mac_need_adjust_link(struct hns_mac_cb *mac_cb, int speed, int duplex);
 void hns_mac_get_link_status(struct hns_mac_cb *mac_cb,	u32 *link_status);
-int hns_mac_change_vf_addr(struct hns_mac_cb *mac_cb, u32 vmid, char *addr);
+int hns_mac_change_vf_addr(struct hns_mac_cb *mac_cb, u32 vmid,
+			   const char *addr);
 int hns_mac_set_multi(struct hns_mac_cb *mac_cb,
 		      u32 port_num, char *addr, bool enable);
 int hns_mac_vm_config_bc_en(struct hns_mac_cb *mac_cb, u32 vm, bool enable);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index 401fef5f1d07..fc26ffaae620 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -255,7 +255,7 @@ static void hns_xgmac_pausefrm_cfg(void *mac_drv, u32 rx_en, u32 tx_en)
 	dsaf_write_dev(drv, XGMAC_MAC_PAUSE_CTRL_REG, origin);
 }
 
-static void hns_xgmac_set_pausefrm_mac_addr(void *mac_drv, char *mac_addr)
+static void hns_xgmac_set_pausefrm_mac_addr(void *mac_drv, const char *mac_addr)
 {
 	struct mac_driver *drv = (struct mac_driver *)mac_drv;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 5d188573c433..98d63e804903 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -595,7 +595,7 @@ struct hnae3_ae_ops {
 				   u32 *tx_usecs_high, u32 *rx_usecs_high);
 
 	void (*get_mac_addr)(struct hnae3_handle *handle, u8 *p);
-	int (*set_mac_addr)(struct hnae3_handle *handle, void *p,
+	int (*set_mac_addr)(struct hnae3_handle *handle, const void *p,
 			    bool is_first);
 	int (*do_ioctl)(struct hnae3_handle *handle,
 			struct ifreq *ifr, int cmd);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cd981b33d4ff..7bb34af3981e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9442,7 +9442,7 @@ int hclge_update_mac_node_for_dev_addr(struct hclge_vport *vport,
 	return 0;
 }
 
-static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
+static int hclge_set_mac_addr(struct hnae3_handle *handle, const void *p,
 			      bool is_first)
 {
 	const unsigned char *new_addr = (const unsigned char *)p;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5fdac8685f95..2e6dcf75fba6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1349,7 +1349,7 @@ static void hclgevf_get_mac_addr(struct hnae3_handle *handle, u8 *p)
 		ether_addr_copy(p, hdev->hw.mac.mac_addr);
 }
 
-static int hclgevf_set_mac_addr(struct hnae3_handle *handle, void *p,
+static int hclgevf_set_mac_addr(struct hnae3_handle *handle, const void *p,
 				bool is_first)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 0696f723228a..18d32302c3c7 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -461,7 +461,7 @@ static int init586(struct net_device *dev)
 	ias_cmd->cmd_cmd	= swab16(CMD_IASETUP | CMD_LAST);
 	ias_cmd->cmd_link	= 0xffff;
 
-	memcpy((char *)&ias_cmd->iaddr,(char *) dev->dev_addr,ETH_ALEN);
+	memcpy((char *)&ias_cmd->iaddr,(const char *) dev->dev_addr,ETH_ALEN);
 
 	p->scb->cbl_offset = make16(ias_cmd);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 39fb3d57c057..3d528fba754b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -435,7 +435,7 @@ static inline bool i40e_is_channel_macvlan(struct i40e_channel *ch)
 	return !!ch->fwd;
 }
 
-static inline u8 *i40e_channel_mac(struct i40e_channel *ch)
+static inline const u8 *i40e_channel_mac(struct i40e_channel *ch)
 {
 	if (i40e_is_channel_macvlan(ch))
 		return ch->fwd->netdev->dev_addr;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
index a430871d1c27..c8d1e815ec6b 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
@@ -549,7 +549,7 @@ ixgb_mta_set(struct ixgb_hw *hw,
  *****************************************************************************/
 void
 ixgb_rar_set(struct ixgb_hw *hw,
-		  u8 *addr,
+		  const u8 *addr,
 		  u32 index)
 {
 	u32 rar_low, rar_high;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_hw.h b/drivers/net/ethernet/intel/ixgb/ixgb_hw.h
index 6064583095da..70bcff5fb3db 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_hw.h
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_hw.h
@@ -740,7 +740,7 @@ bool ixgb_adapter_start(struct ixgb_hw *hw);
 void ixgb_check_for_link(struct ixgb_hw *hw);
 bool ixgb_check_for_bad_link(struct ixgb_hw *hw);
 
-void ixgb_rar_set(struct ixgb_hw *hw, u8 *addr, u32 index);
+void ixgb_rar_set(struct ixgb_hw *hw, const u8 *addr, u32 index);
 
 /* Filters (multicast, vlan, receive) */
 void ixgb_mc_addr_list_update(struct ixgb_hw *hw, u8 *mc_addr_list,
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 654ec25e6705..a63d9a5c8059 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1770,7 +1770,7 @@ static void uc_addr_get(struct mv643xx_eth_private *mp, unsigned char *addr)
 	addr[5] = mac_l & 0xff;
 }
 
-static void uc_addr_set(struct mv643xx_eth_private *mp, unsigned char *addr)
+static void uc_addr_set(struct mv643xx_eth_private *mp, const u8 *addr)
 {
 	wrlp(mp, MAC_ADDR_HIGH,
 		(addr[0] << 24) | (addr[1] << 16) | (addr[2] << 8) | addr[3]);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 761155af25d8..e2ce84ecb7a6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1623,8 +1623,8 @@ static void mvneta_set_ucast_addr(struct mvneta_port *pp, u8 last_nibble,
 }
 
 /* Set mac address */
-static void mvneta_mac_addr_set(struct mvneta_port *pp, unsigned char *addr,
-				int queue)
+static void mvneta_mac_addr_set(struct mvneta_port *pp,
+				const unsigned char *addr, int queue)
 {
 	unsigned int mac_h;
 	unsigned int mac_l;
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 898b513f74e0..bb5341020803 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -389,7 +389,7 @@ static void inverse_every_nibble(unsigned char *mac_addr)
  * Outputs
  * return the calculated entry.
  */
-static u32 hash_function(unsigned char *mac_addr_orig)
+static u32 hash_function(const unsigned char *mac_addr_orig)
 {
 	u32 hash_result;
 	u32 addr0;
@@ -434,7 +434,7 @@ static u32 hash_function(unsigned char *mac_addr_orig)
  * -ENOSPC if table full
  */
 static int add_del_hash_entry(struct pxa168_eth_private *pep,
-			      unsigned char *mac_addr,
+			      const unsigned char *mac_addr,
 			      u32 rd, u32 skip, int del)
 {
 	struct addr_table_entry *entry, *start;
@@ -521,7 +521,7 @@ static int add_del_hash_entry(struct pxa168_eth_private *pep,
  */
 static void update_hash_table_mac_address(struct pxa168_eth_private *pep,
 					  unsigned char *oaddr,
-					  unsigned char *addr)
+					  const unsigned char *addr)
 {
 	/* Delete old entry */
 	if (oaddr)
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index e2ebfd8115a0..89ca7960b225 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -523,7 +523,7 @@ static void mtk_star_dma_resume_tx(struct mtk_star_priv *priv)
 static void mtk_star_set_mac_addr(struct net_device *ndev)
 {
 	struct mtk_star_priv *priv = netdev_priv(ndev);
-	u8 *mac_addr = ndev->dev_addr;
+	const u8 *mac_addr = ndev->dev_addr;
 	unsigned int high, low;
 
 	high = mac_addr[0] << 8 | mac_addr[1] << 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index c06b4b938ae7..73a377c8a2da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -71,12 +71,12 @@ struct mlx5e_l2_hash_node {
 	bool   mpfs;
 };
 
-static inline int mlx5e_hash_l2(u8 *addr)
+static inline int mlx5e_hash_l2(const u8 *addr)
 {
 	return addr[5];
 }
 
-static void mlx5e_add_l2_to_hash(struct hlist_head *hash, u8 *addr)
+static void mlx5e_add_l2_to_hash(struct hlist_head *hash, const u8 *addr)
 {
 	struct mlx5e_l2_hash_node *hn;
 	int ix = mlx5e_hash_l2(addr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 269ebb53eda6..f7ebc1f9283f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -219,7 +219,7 @@ void mlx5i_uninit_underlay_qp(struct mlx5e_priv *priv)
 
 int mlx5i_create_underlay_qp(struct mlx5e_priv *priv)
 {
-	unsigned char *dev_addr = priv->netdev->dev_addr;
+	const unsigned char *dev_addr = priv->netdev->dev_addr;
 	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(create_qp_in)] = {};
 	struct mlx5i_priv *ipriv = priv->ppriv;
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 37ccf8c570b5..0f2cdcd4a4c0 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -380,7 +380,7 @@ static void ks8842_read_mac_addr(struct ks8842_adapter *adapter, u8 *dest)
 	}
 }
 
-static void ks8842_write_mac_addr(struct ks8842_adapter *adapter, u8 *mac)
+static void ks8842_write_mac_addr(struct ks8842_adapter *adapter, const u8 *mac)
 {
 	unsigned long flags;
 	unsigned i;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index a1f7f45b9d08..03ad8bdc1f0d 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -4033,7 +4033,7 @@ static void hw_set_add_addr(struct ksz_hw *hw)
 	}
 }
 
-static int hw_add_addr(struct ksz_hw *hw, u8 *mac_addr)
+static int hw_add_addr(struct ksz_hw *hw, const u8 *mac_addr)
 {
 	int i;
 	int j = ADDITIONAL_ENTRIES;
@@ -4054,7 +4054,7 @@ static int hw_add_addr(struct ksz_hw *hw, u8 *mac_addr)
 	return -1;
 }
 
-static int hw_del_addr(struct ksz_hw *hw, u8 *mac_addr)
+static int hw_del_addr(struct ksz_hw *hw, const u8 *mac_addr)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 32760f87bf8a..5ae59b1e5b48 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -796,7 +796,8 @@ static int myri10ge_load_firmware(struct myri10ge_priv *mgp, int adopt)
 	return status;
 }
 
-static int myri10ge_update_mac_address(struct myri10ge_priv *mgp, u8 * addr)
+static int myri10ge_update_mac_address(struct myri10ge_priv *mgp,
+				       const u8 * addr)
 {
 	struct myri10ge_cmd cmd;
 	int status;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 5454c1c2f8ad..ea0b2f3fd9c6 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5217,7 +5217,7 @@ static int s2io_set_mac_addr(struct net_device *dev, void *p)
  *  as defined in errno.h file on failure.
  */
 
-static int do_s2io_prog_unicast(struct net_device *dev, u8 *addr)
+static int do_s2io_prog_unicast(struct net_device *dev, const u8 *addr)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
 	register u64 mac_addr = 0, perm_addr = 0;
diff --git a/drivers/net/ethernet/neterion/s2io.h b/drivers/net/ethernet/neterion/s2io.h
index 5a6032212c19..a4266d1544ab 100644
--- a/drivers/net/ethernet/neterion/s2io.h
+++ b/drivers/net/ethernet/neterion/s2io.h
@@ -1073,7 +1073,7 @@ static void s2io_reset(struct s2io_nic * sp);
 static int s2io_poll_msix(struct napi_struct *napi, int budget);
 static int s2io_poll_inta(struct napi_struct *napi, int budget);
 static void s2io_init_pci(struct s2io_nic * sp);
-static int do_s2io_prog_unicast(struct net_device *dev, u8 *addr);
+static int do_s2io_prog_unicast(struct net_device *dev, const u8 *addr);
 static void s2io_alarm_handle(struct timer_list *t);
 static irqreturn_t
 s2io_msix_ring_handle(int irq, void *dev_id);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index ab70179728f6..dfb4468fe287 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -837,7 +837,7 @@ nfp_tunnel_put_ipv6_off(struct nfp_app *app, struct nfp_ipv6_addr_entry *entry)
 }
 
 static int
-__nfp_tunnel_offload_mac(struct nfp_app *app, u8 *mac, u16 idx, bool del)
+__nfp_tunnel_offload_mac(struct nfp_app *app, const u8 *mac, u16 idx, bool del)
 {
 	struct nfp_tun_mac_addr_offload payload;
 
@@ -886,7 +886,7 @@ static bool nfp_tunnel_is_mac_idx_global(u16 nfp_mac_idx)
 }
 
 static struct nfp_tun_offloaded_mac *
-nfp_tunnel_lookup_offloaded_macs(struct nfp_app *app, u8 *mac)
+nfp_tunnel_lookup_offloaded_macs(struct nfp_app *app, const u8 *mac)
 {
 	struct nfp_flower_priv *priv = app->priv;
 
@@ -1005,7 +1005,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 
 static int
 nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
-			  u8 *mac, bool mod)
+			  const u8 *mac, bool mod)
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_flower_repr_priv *repr_priv;
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 43fd569aa5f1..fbfbf94e0377 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -419,7 +419,7 @@ struct netdata_local {
 /*
  * MAC support functions
  */
-static void __lpc_set_mac(struct netdata_local *pldat, u8 *mac)
+static void __lpc_set_mac(struct netdata_local *pldat, const u8 *mac)
 {
 	u32 tmp;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 6823016ab5a3..18f3bf7c4dfe 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -952,7 +952,7 @@ qed_llh_remove_filter(struct qed_hwfn *p_hwfn,
 }
 
 int qed_llh_add_mac_filter(struct qed_dev *cdev,
-			   u8 ppfid, u8 mac_addr[ETH_ALEN])
+			   u8 ppfid, const u8 mac_addr[ETH_ALEN])
 {
 	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
 	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index 6582bfc1b4a9..f8682356d0cf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -364,7 +364,7 @@ int qed_llh_set_roce_affinity(struct qed_dev *cdev, enum qed_eng eng);
  * Return: Int.
  */
 int qed_llh_add_mac_filter(struct qed_dev *cdev,
-			   u8 ppfid, u8 mac_addr[ETH_ALEN]);
+			   u8 ppfid, const u8 mac_addr[ETH_ALEN]);
 
 /**
  * qed_llh_remove_mac_filter(): Remove a LLH MAC filter from the given
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index a116fbc59725..2edd6bf64a3c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2848,7 +2848,7 @@ static int qed_fp_cqe_completion(struct qed_dev *dev,
 				      cqe);
 }
 
-static int qed_req_bulletin_update_mac(struct qed_dev *cdev, u8 *mac)
+static int qed_req_bulletin_update_mac(struct qed_dev *cdev, const u8 *mac)
 {
 	int i, ret;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 5e7242304ee2..29f9711bf438 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2887,7 +2887,7 @@ static int qed_update_drv_state(struct qed_dev *cdev, bool active)
 	return status;
 }
 
-static int qed_update_mac(struct qed_dev *cdev, u8 *mac)
+static int qed_update_mac(struct qed_dev *cdev, const u8 *mac)
 {
 	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
 	struct qed_ptt *ptt;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 11a52a4a673b..64678a256f3b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -2851,7 +2851,7 @@ int qed_mcp_ov_update_mtu(struct qed_hwfn *p_hwfn,
 }
 
 int qed_mcp_ov_update_mac(struct qed_hwfn *p_hwfn,
-			  struct qed_ptt *p_ptt, u8 *mac)
+			  struct qed_ptt *p_ptt, const u8 *mac)
 {
 	struct qed_mcp_mb_params mb_params;
 	u32 mfw_mac[2];
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 9e1de1191bd4..564723800d15 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -536,7 +536,7 @@ int qed_mcp_ov_update_mtu(struct qed_hwfn *p_hwfn,
  * Return: Int - 0 - Operation was successul.
  */
 int qed_mcp_ov_update_mac(struct qed_hwfn *p_hwfn,
-			  struct qed_ptt *p_ptt, u8 *mac);
+			  struct qed_ptt *p_ptt, const u8 *mac);
 
 /**
  * qed_mcp_ov_update_wol(): Send WOL mode to MFW.
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index fe0bb11d0e43..7f3e84b8622d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1965,7 +1965,7 @@ static void qed_rdma_remove_user(void *rdma_cxt, u16 dpi)
 
 static int qed_roce_ll2_set_mac_filter(struct qed_dev *cdev,
 				       u8 *old_mac_address,
-				       u8 *new_mac_address)
+				       const u8 *new_mac_address)
 {
 	int rc = 0;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 220a95fa96e1..597cd9cd57b5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -1373,7 +1373,7 @@ int qed_vf_pf_get_coalesce(struct qed_hwfn *p_hwfn,
 
 int
 qed_vf_pf_bulletin_update_mac(struct qed_hwfn *p_hwfn,
-			      u8 *p_mac)
+			      const u8 *p_mac)
 {
 	struct qed_vf_iov *p_iov = p_hwfn->vf_iov_info;
 	struct vfpf_bulletin_update_mac_tlv *p_req;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.h b/drivers/net/ethernet/qlogic/qed/qed_vf.h
index 8718760443be..551176509daf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.h
@@ -1070,7 +1070,7 @@ u32 qed_vf_hw_bar_size(struct qed_hwfn *p_hwfn, enum BAR_ID bar_id);
  *
  * Return: Int.
  */
-int qed_vf_pf_bulletin_update_mac(struct qed_hwfn *p_hwfn, u8 *p_mac);
+int qed_vf_pf_bulletin_update_mac(struct qed_hwfn *p_hwfn, const u8 *p_mac);
 
 #else
 static inline void qed_vf_get_link_params(struct qed_hwfn *p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 03c51dd37e1f..3010833ddde3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -617,7 +617,7 @@ void qede_fill_rss_params(struct qede_dev *edev,
 
 static int qede_set_ucast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
-				 unsigned char mac[ETH_ALEN])
+				 const unsigned char mac[ETH_ALEN])
 {
 	struct qed_filter_ucast_params ucast;
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 87b8c032195d..06104d2ff5b3 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -420,7 +420,7 @@ static void emac_mac_dma_config(struct emac_adapter *adpt)
 }
 
 /* set MAC address */
-static void emac_set_mac_address(struct emac_adapter *adpt, u8 *addr)
+static void emac_set_mac_address(struct emac_adapter *adpt, const u8 *addr)
 {
 	u32 sta;
 
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 01ef5efd7bc2..a8f282c43a78 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -453,7 +453,7 @@ static void r6040_down(struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
-	u16 *adrp;
+	const u16 *adrp;
 
 	/* Stop MAC */
 	iowrite16(MSK_INT, ioaddr + MIER);	/* Mask Off Interrupt */
@@ -462,7 +462,7 @@ static void r6040_down(struct net_device *dev)
 	r6040_reset_mac(lp);
 
 	/* Restore MAC Address to MIDx */
-	adrp = (u16 *) dev->dev_addr;
+	adrp = (const u16 *) dev->dev_addr;
 	iowrite16(adrp[0], ioaddr + MID_0L);
 	iowrite16(adrp[1], ioaddr + MID_0M);
 	iowrite16(adrp[2], ioaddr + MID_0H);
@@ -731,13 +731,13 @@ static void r6040_mac_address(struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
-	u16 *adrp;
+	const u16 *adrp;
 
 	/* Reset MAC */
 	r6040_reset_mac(lp);
 
 	/* Restore MAC Address */
-	adrp = (u16 *) dev->dev_addr;
+	adrp = (const u16 *) dev->dev_addr;
 	iowrite16(adrp[0], ioaddr + MID_0L);
 	iowrite16(adrp[1], ioaddr + MID_0M);
 	iowrite16(adrp[2], ioaddr + MID_0H);
@@ -849,13 +849,13 @@ static void r6040_multicast_list(struct net_device *dev)
 	unsigned long flags;
 	struct netdev_hw_addr *ha;
 	int i;
-	u16 *adrp;
+	const u16 *adrp;
 	u16 hash_table[4] = { 0 };
 
 	spin_lock_irqsave(&lp->lock, flags);
 
 	/* Keep our MAC Address */
-	adrp = (u16 *)dev->dev_addr;
+	adrp = (const u16 *)dev->dev_addr;
 	iowrite16(adrp[0], ioaddr + MID_0L);
 	iowrite16(adrp[1], ioaddr + MID_0M);
 	iowrite16(adrp[2], ioaddr + MID_0H);
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
index 049dc6cf4611..0f45107db8dd 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
@@ -329,7 +329,7 @@ struct sxgbe_core_ops {
 	/* Set power management mode (e.g. magic frame) */
 	void (*pmt)(void __iomem *ioaddr, unsigned long mode);
 	/* Set/Get Unicast MAC addresses */
-	void (*set_umac_addr)(void __iomem *ioaddr, unsigned char *addr,
+	void (*set_umac_addr)(void __iomem *ioaddr, const unsigned char *addr,
 			      unsigned int reg_n);
 	void (*get_umac_addr)(void __iomem *ioaddr, unsigned char *addr,
 			      unsigned int reg_n);
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c
index e96e2bd295ef..7d9f257de92a 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c
@@ -85,7 +85,8 @@ static void sxgbe_core_pmt(void __iomem *ioaddr, unsigned long mode)
 }
 
 /* Set/Get Unicast MAC addresses */
-static void sxgbe_core_set_umac_addr(void __iomem *ioaddr, unsigned char *addr,
+static void sxgbe_core_set_umac_addr(void __iomem *ioaddr,
+				     const unsigned char *addr,
 				     unsigned int reg_n)
 {
 	u32 high_word, low_word;
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index e7e2223aebbf..cf366ed2557c 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1038,7 +1038,7 @@ int efx_ef10_vadaptor_free(struct efx_nic *efx, unsigned int port_id)
 }
 
 int efx_ef10_vport_add_mac(struct efx_nic *efx,
-			   unsigned int port_id, u8 *mac)
+			   unsigned int port_id, const u8 *mac)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_VPORT_ADD_MAC_ADDRESS_IN_LEN);
 
@@ -1050,7 +1050,7 @@ int efx_ef10_vport_add_mac(struct efx_nic *efx,
 }
 
 int efx_ef10_vport_del_mac(struct efx_nic *efx,
-			   unsigned int port_id, u8 *mac)
+			   unsigned int port_id, const u8 *mac)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_VPORT_DEL_MAC_ADDRESS_IN_LEN);
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 06d23c708a5f..7f5aa4a8c451 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -480,7 +480,7 @@ static int efx_ef10_vport_del_vf_mac(struct efx_nic *efx, unsigned int port_id,
 	return rc;
 }
 
-int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, u8 *mac)
+int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, const u8 *mac)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct ef10_vf *vf;
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.h b/drivers/net/ethernet/sfc/ef10_sriov.h
index cfe556d17313..3c703ca878b0 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.h
+++ b/drivers/net/ethernet/sfc/ef10_sriov.h
@@ -39,7 +39,7 @@ static inline void efx_ef10_sriov_reset(struct efx_nic *efx) {}
 void efx_ef10_sriov_fini(struct efx_nic *efx);
 static inline void efx_ef10_sriov_flr(struct efx_nic *efx, unsigned vf_i) {}
 
-int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf, u8 *mac);
+int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf, const u8 *mac);
 
 int efx_ef10_sriov_set_vf_vlan(struct efx_nic *efx, int vf_i,
 			       u16 vlan, u8 qos);
@@ -60,9 +60,9 @@ int efx_ef10_vswitching_restore_vf(struct efx_nic *efx);
 void efx_ef10_vswitching_remove_pf(struct efx_nic *efx);
 void efx_ef10_vswitching_remove_vf(struct efx_nic *efx);
 int efx_ef10_vport_add_mac(struct efx_nic *efx,
-			   unsigned int port_id, u8 *mac);
+			   unsigned int port_id, const u8 *mac);
 int efx_ef10_vport_del_mac(struct efx_nic *efx,
-			   unsigned int port_id, u8 *mac);
+			   unsigned int port_id, const u8 *mac);
 int efx_ef10_vadaptor_alloc(struct efx_nic *efx, unsigned int port_id);
 int efx_ef10_vadaptor_query(struct efx_nic *efx, unsigned int port_id,
 			    u32 *port_flags, u32 *vadaptor_flags,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index f6981810039d..cc15ee8812d9 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1440,7 +1440,7 @@ struct efx_nic_type {
 	bool (*sriov_wanted)(struct efx_nic *efx);
 	void (*sriov_reset)(struct efx_nic *efx);
 	void (*sriov_flr)(struct efx_nic *efx, unsigned vf_i);
-	int (*sriov_set_vf_mac)(struct efx_nic *efx, int vf_i, u8 *mac);
+	int (*sriov_set_vf_mac)(struct efx_nic *efx, int vf_i, const u8 *mac);
 	int (*sriov_set_vf_vlan)(struct efx_nic *efx, int vf_i, u16 vlan,
 				 u8 qos);
 	int (*sriov_set_vf_spoofchk)(struct efx_nic *efx, int vf_i,
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index 83dcfcae3d4b..e9095cf06368 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -1591,7 +1591,7 @@ void efx_fini_sriov(void)
 	destroy_workqueue(vfdi_workqueue);
 }
 
-int efx_siena_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, u8 *mac)
+int efx_siena_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, const u8 *mac)
 {
 	struct siena_nic_data *nic_data = efx->nic_data;
 	struct siena_vf *vf;
diff --git a/drivers/net/ethernet/sfc/siena_sriov.h b/drivers/net/ethernet/sfc/siena_sriov.h
index e441c89c25ce..e548c4daf189 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.h
+++ b/drivers/net/ethernet/sfc/siena_sriov.h
@@ -46,7 +46,7 @@ bool efx_siena_sriov_wanted(struct efx_nic *efx);
 void efx_siena_sriov_reset(struct efx_nic *efx);
 void efx_siena_sriov_flr(struct efx_nic *efx, unsigned flr);
 
-int efx_siena_sriov_set_vf_mac(struct efx_nic *efx, int vf, u8 *mac);
+int efx_siena_sriov_set_vf_mac(struct efx_nic *efx, int vf, const u8 *mac);
 int efx_siena_sriov_set_vf_vlan(struct efx_nic *efx, int vf,
 				u16 vlan, u8 qos);
 int efx_siena_sriov_set_vf_spoofchk(struct efx_nic *efx, int vf,
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 60a0c0e9ded2..d105779ba3b2 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1098,7 +1098,7 @@ sis900_init_rxfilter (struct net_device * net_dev)
 
 	/* load MAC addr to filter data register */
 	for (i = 0 ; i < 3 ; i++) {
-		u32 w = (u32) *((u16 *)(net_dev->dev_addr)+i);
+		u32 w = (u32) *((const u16 *)(net_dev->dev_addr)+i);
 
 		sw32(rfcr, i << RFADDR_shift);
 		sw32(rfdr, w);
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index fa387510c189..73bcc6f2bb6e 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1503,7 +1503,7 @@ static int smsc911x_soft_reset(struct smsc911x_data *pdata)
 
 /* Sets the device MAC address to dev_addr, called with mac_lock held */
 static void
-smsc911x_set_hw_mac_address(struct smsc911x_data *pdata, u8 dev_addr[6])
+smsc911x_set_hw_mac_address(struct smsc911x_data *pdata, const u8 dev_addr[6])
 {
 	u32 mac_high16 = (dev_addr[5] << 8) | dev_addr[4];
 	u32 mac_low32 = (dev_addr[3] << 24) | (dev_addr[2] << 16) |
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 3d1176588f7d..d207c0b463ab 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -404,7 +404,7 @@ static const struct ethtool_ops smsc9420_ethtool_ops = {
 static void smsc9420_set_mac_address(struct net_device *dev)
 {
 	struct smsc9420_pdata *pd = netdev_priv(dev);
-	u8 *dev_addr = dev->dev_addr;
+	const u8 *dev_addr = dev->dev_addr;
 	u32 mac_high16 = (dev_addr[5] << 8) | dev_addr[4];
 	u32 mac_low32 = (dev_addr[3] << 24) | (dev_addr[2] << 16) |
 	    (dev_addr[1] << 8) | dev_addr[0];
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index b6d945ea903d..9160f9ed363a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -546,13 +546,13 @@ int dwmac4_setup(struct stmmac_priv *priv);
 int dwxgmac2_setup(struct stmmac_priv *priv);
 int dwxlgmac2_setup(struct stmmac_priv *priv);
 
-void stmmac_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
+void stmmac_set_mac_addr(void __iomem *ioaddr, const u8 addr[6],
 			 unsigned int high, unsigned int low);
 void stmmac_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
 			 unsigned int high, unsigned int low);
 void stmmac_set_mac(void __iomem *ioaddr, bool enable);
 
-void stmmac_dwmac4_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
+void stmmac_dwmac4_set_mac_addr(void __iomem *ioaddr, const u8 addr[6],
 				unsigned int high, unsigned int low);
 void stmmac_dwmac4_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
 				unsigned int high, unsigned int low);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 4422baeed3d8..617d0e4c6495 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -634,7 +634,7 @@ static void sun8i_dwmac_set_mac(void __iomem *ioaddr, bool enable)
  * If addr is NULL, clear the slot
  */
 static void sun8i_dwmac_set_umac_addr(struct mac_device_info *hw,
-				      unsigned char *addr,
+				      const unsigned char *addr,
 				      unsigned int reg_n)
 {
 	void __iomem *ioaddr = hw->pcsr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index fc8759f146c7..76edb9b72675 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -104,7 +104,7 @@ static void dwmac1000_dump_regs(struct mac_device_info *hw, u32 *reg_space)
 }
 
 static void dwmac1000_set_umac_addr(struct mac_device_info *hw,
-				    unsigned char *addr,
+				    const unsigned char *addr,
 				    unsigned int reg_n)
 {
 	void __iomem *ioaddr = hw->pcsr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
index ebcad8dd99db..75071a7d551a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
@@ -68,7 +68,7 @@ static int dwmac100_irq_status(struct mac_device_info *hw,
 }
 
 static void dwmac100_set_umac_addr(struct mac_device_info *hw,
-				   unsigned char *addr,
+				   const unsigned char *addr,
 				   unsigned int reg_n)
 {
 	void __iomem *ioaddr = hw->pcsr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index b21745368983..fd41db65fe1d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -322,7 +322,7 @@ static void dwmac4_pmt(struct mac_device_info *hw, unsigned long mode)
 }
 
 static void dwmac4_set_umac_addr(struct mac_device_info *hw,
-				 unsigned char *addr, unsigned int reg_n)
+				 const unsigned char *addr, unsigned int reg_n)
 {
 	void __iomem *ioaddr = hw->pcsr;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 9292a1fab7d3..d1c605777985 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -187,7 +187,7 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 	return ret;
 }
 
-void stmmac_dwmac4_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
+void stmmac_dwmac4_set_mac_addr(void __iomem *ioaddr, const u8 addr[6],
 				unsigned int high, unsigned int low)
 {
 	unsigned long data;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index d1c31200bb91..caa4bfc4c1d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -239,7 +239,7 @@ void dwmac_dma_flush_tx_fifo(void __iomem *ioaddr)
 	do {} while ((readl(ioaddr + DMA_CONTROL) & DMA_CONTROL_FTF));
 }
 
-void stmmac_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
+void stmmac_set_mac_addr(void __iomem *ioaddr, const u8 addr[6],
 			 unsigned int high, unsigned int low)
 {
 	unsigned long data;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index c4d78fa93663..c6c4d7948fe5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -335,7 +335,8 @@ static void dwxgmac2_pmt(struct mac_device_info *hw, unsigned long mode)
 }
 
 static void dwxgmac2_set_umac_addr(struct mac_device_info *hw,
-				   unsigned char *addr, unsigned int reg_n)
+				   const unsigned char *addr,
+				   unsigned int reg_n)
 {
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 6dc1c98ebec8..6cf2c2107197 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -330,7 +330,8 @@ struct stmmac_ops {
 	/* Set power management mode (e.g. magic frame) */
 	void (*pmt)(struct mac_device_info *hw, unsigned long mode);
 	/* Set/Get Unicast MAC addresses */
-	void (*set_umac_addr)(struct mac_device_info *hw, unsigned char *addr,
+	void (*set_umac_addr)(struct mac_device_info *hw,
+			      const unsigned char *addr,
 			      unsigned int reg_n);
 	void (*get_umac_addr)(struct mac_device_info *hw, unsigned char *addr,
 			      unsigned int reg_n);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index e649a3e6a529..be3cb63675a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -36,7 +36,7 @@ struct stmmac_packet_attrs {
 	int vlan_id_in;
 	int vlan_id_out;
 	unsigned char *src;
-	unsigned char *dst;
+	const unsigned char *dst;
 	u32 ip_src;
 	u32 ip_dst;
 	int tcp;
@@ -249,8 +249,8 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 					 struct net_device *orig_ndev)
 {
 	struct stmmac_test_priv *tpriv = pt->af_packet_priv;
+	const unsigned char *dst = tpriv->packet->dst;
 	unsigned char *src = tpriv->packet->src;
-	unsigned char *dst = tpriv->packet->dst;
 	struct stmmachdr *shdr;
 	struct ethhdr *ehdr;
 	struct udphdr *uhdr;
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index c646575e79d5..d70426670c37 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -623,7 +623,7 @@ static int bigmac_init_hw(struct bigmac *bp, bool non_blocking)
 	void __iomem *cregs        = bp->creg;
 	void __iomem *bregs        = bp->bregs;
 	__u32 bblk_dvma = (__u32)bp->bblock_dvma;
-	unsigned char *e = &bp->dev->dev_addr[0];
+	const unsigned char *e = &bp->dev->dev_addr[0];
 
 	/* Latch current counters into statistics. */
 	bigmac_get_counters(bp, bregs);
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index 52b1053a0a77..efe0d33f6024 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -144,7 +144,7 @@ static int qe_init(struct sunqe *qep, int from_irq)
 	void __iomem *cregs = qep->qcregs;
 	void __iomem *mregs = qep->mregs;
 	void __iomem *gregs = qecp->gregs;
-	unsigned char *e = &qep->dev->dev_addr[0];
+	const unsigned char *e = &qep->dev->dev_addr[0];
 	__u32 qblk_dvma = (__u32)qep->qblock_dvma;
 	u32 tmp;
 	int i;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
index bf6c1c6779ff..76eb7db80f13 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
@@ -57,7 +57,7 @@ static int xlgmac_enable_rx_csum(struct xlgmac_pdata *pdata)
 	return 0;
 }
 
-static int xlgmac_set_mac_address(struct xlgmac_pdata *pdata, u8 *addr)
+static int xlgmac_set_mac_address(struct xlgmac_pdata *pdata, const u8 *addr)
 {
 	unsigned int mac_addr_hi, mac_addr_lo;
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac.h b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
index 8598aaf3ec99..98e3a271e017 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac.h
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
@@ -410,7 +410,7 @@ struct xlgmac_hw_ops {
 	void (*dev_xmit)(struct xlgmac_channel *channel);
 	int (*dev_read)(struct xlgmac_channel *channel);
 
-	int (*set_mac_address)(struct xlgmac_pdata *pdata, u8 *addr);
+	int (*set_mac_address)(struct xlgmac_pdata *pdata, const u8 *addr);
 	int (*config_rx_mode)(struct xlgmac_pdata *pdata);
 	int (*enable_rx_csum)(struct xlgmac_pdata *pdata);
 	int (*disable_rx_csum)(struct xlgmac_pdata *pdata);
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 77c448ad67ce..eab7d78d7c72 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -184,7 +184,7 @@ static void	tlan_print_list(struct tlan_list *, char *, int);
 static void	tlan_read_and_clear_stats(struct net_device *, int);
 static void	tlan_reset_adapter(struct net_device *);
 static void	tlan_finish_reset(struct net_device *);
-static void	tlan_set_mac(struct net_device *, int areg, char *mac);
+static void	tlan_set_mac(struct net_device *, int areg, const char *mac);
 
 static void	__tlan_phy_print(struct net_device *);
 static void	tlan_phy_print(struct net_device *);
@@ -2346,7 +2346,7 @@ tlan_finish_reset(struct net_device *dev)
  *
  **************************************************************/
 
-static void tlan_set_mac(struct net_device *dev, int areg, char *mac)
+static void tlan_set_mac(struct net_device *dev, int areg, const char *mac)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 93453e5713b2..f8b9d10dc056 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1859,7 +1859,8 @@ static struct net_device_stats *tc35815_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
-static void tc35815_set_cam_entry(struct net_device *dev, int index, unsigned char *addr)
+static void tc35815_set_cam_entry(struct net_device *dev, int index,
+				  const unsigned char *addr)
 {
 	struct tc35815_local *lp = netdev_priv(dev);
 	struct tc35815_regs __iomem *tr =
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index b95aee8607a4..0815de581c7f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -206,12 +206,13 @@ static void xemaclite_disable_interrupts(struct net_local *drvdata)
  * This function writes data from a 16-bit aligned buffer to a 32-bit aligned
  * address in the EmacLite device.
  */
-static void xemaclite_aligned_write(void *src_ptr, u32 *dest_ptr,
+static void xemaclite_aligned_write(const void *src_ptr, u32 *dest_ptr,
 				    unsigned length)
 {
+	const u16 *from_u16_ptr;
 	u32 align_buffer;
 	u32 *to_u32_ptr;
-	u16 *from_u16_ptr, *to_u16_ptr;
+	u16 *to_u16_ptr;
 
 	to_u32_ptr = dest_ptr;
 	from_u16_ptr = src_ptr;
@@ -470,7 +471,7 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
  * buffers (if configured).
  */
 static void xemaclite_update_address(struct net_local *drvdata,
-				     u8 *address_ptr)
+				     const u8 *address_ptr)
 {
 	void __iomem *addr;
 	u32 reg_data;
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index ae611e46da6a..ab513dcc3b22 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1271,7 +1271,7 @@ struct set_address_info {
 	unsigned int ioaddr;
 };
 
-static void set_address(struct set_address_info *sa_info, char *addr)
+static void set_address(struct set_address_info *sa_info, const char *addr)
 {
 	unsigned int ioaddr = sa_info->ioaddr;
 	int i;
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6e32da28e138..ebfeeb3c67c1 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -273,12 +273,12 @@ static int vsc85xx_downshift_set(struct phy_device *phydev, u8 count)
 static int vsc85xx_wol_set(struct phy_device *phydev,
 			   struct ethtool_wolinfo *wol)
 {
+	const u8 *mac_addr = phydev->attached_dev->dev_addr;
 	int rc;
 	u16 reg_val;
 	u8  i;
 	u16 pwd[3] = {0, 0, 0};
 	struct ethtool_wolinfo *wol_conf = wol;
-	u8 *mac_addr = phydev->attached_dev->dev_addr;
 
 	mutex_lock(&phydev->lock);
 	rc = phy_select_page(phydev, MSCC_PHY_PAGE_EXTENDED_2);
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 981ac1c33780..ea06d10e1c21 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -119,7 +119,7 @@ static int aqc111_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 }
 
 static int aqc111_write_cmd(struct usbnet *dev, u8 cmd, u16 value,
-			    u16 index, u16 size, void *data)
+			    u16 index, u16 size, const void *data)
 {
 	int ret;
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5ed59d9dd631..ea8aa8c33241 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -209,7 +209,7 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 }
 
 static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			       u16 size, void *data, int in_pm)
+			       u16 size, const void *data, int in_pm)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
@@ -272,7 +272,7 @@ static int ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 }
 
 static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				  u16 index, u16 size, void *data)
+				  u16 index, u16 size, const void *data)
 {
 	int ret;
 
@@ -313,7 +313,7 @@ static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 }
 
 static int ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			     u16 size, void *data)
+			     u16 size, const void *data)
 {
 	int ret;
 
@@ -463,7 +463,7 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 	u16 tmp16;
 	u8 tmp8;
 	int (*fnr)(struct usbnet *, u8, u16, u16, u16, void *);
-	int (*fnw)(struct usbnet *, u8, u16, u16, u16, void *);
+	int (*fnw)(struct usbnet *, u8, u16, u16, u16, const void *);
 
 	if (!in_pm) {
 		fnr = ax88179_read_cmd;
diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 97ba67042d12..24db5768a3c0 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -615,7 +615,7 @@ static void catc_stats_timer(struct timer_list *t)
  * Receive modes. Broadcast, Multicast, Promisc.
  */
 
-static void catc_multicast(unsigned char *addr, u8 *multicast)
+static void catc_multicast(const unsigned char *addr, u8 *multicast)
 {
 	u32 crc;
 
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index dcdb46314685..48d7d278631e 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -93,7 +93,8 @@ static int dm_write_reg(struct usbnet *dev, u8 reg, u8 value)
 				value, reg, NULL, 0);
 }
 
-static void dm_write_async(struct usbnet *dev, u8 reg, u16 length, void *data)
+static void dm_write_async(struct usbnet *dev, u8 reg, u16 length,
+			   const void *data)
 {
 	usbnet_write_cmd_async(dev, DM_WRITE_REGS,
 			       USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index cead742da381..5f42db26d200 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -132,7 +132,8 @@ static int mcs7830_hif_get_mac_address(struct usbnet *dev, unsigned char *addr)
 	return 0;
 }
 
-static int mcs7830_hif_set_mac_address(struct usbnet *dev, unsigned char *addr)
+static int mcs7830_hif_set_mac_address(struct usbnet *dev,
+				       const unsigned char *addr)
 {
 	int ret = mcs7830_set_reg(dev, HIF_REG_ETHERNET_ADDR, ETH_ALEN, addr);
 
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 068f197f1786..15209de1849e 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -56,7 +56,8 @@ static int sr_write_reg(struct usbnet *dev, u8 reg, u8 value)
 				value, reg, NULL, 0);
 }
 
-static void sr_write_async(struct usbnet *dev, u8 reg, u16 length, void *data)
+static void sr_write_async(struct usbnet *dev, u8 reg, u16 length,
+			   const void *data)
 {
 	usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
 			       0, reg, data, length);
diff --git a/include/linux/qed/qed_eth_if.h b/include/linux/qed/qed_eth_if.h
index 4df0bf0a0864..e1bf3219b4e6 100644
--- a/include/linux/qed/qed_eth_if.h
+++ b/include/linux/qed/qed_eth_if.h
@@ -331,7 +331,7 @@ struct qed_eth_ops {
 	int (*configure_arfs_searcher)(struct qed_dev *cdev,
 				       enum qed_filter_config_mode mode);
 	int (*get_coalesce)(struct qed_dev *cdev, u16 *coal, void *handle);
-	int (*req_bulletin_update_mac)(struct qed_dev *cdev, u8 *mac);
+	int (*req_bulletin_update_mac)(struct qed_dev *cdev, const u8 *mac);
 };
 
 const struct qed_eth_ops *qed_get_eth_ops(void);
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index ad220d5da18f..0dae7fcc5ef2 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1113,7 +1113,7 @@ struct qed_common_ops {
  *
  * Return: Int.
  */
-	int (*update_mac)(struct qed_dev *cdev, u8 *mac);
+	int (*update_mac)(struct qed_dev *cdev, const u8 *mac);
 
 /**
  * update_mtu(): API to inform the change in the mtu.
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index aeb242cefebf..3b76c07fbcf8 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -662,7 +662,8 @@ struct qed_rdma_ops {
 			     u8 connection_handle,
 			     struct qed_ll2_stats *p_stats);
 	int (*ll2_set_mac_filter)(struct qed_dev *cdev,
-				  u8 *old_mac_address, u8 *new_mac_address);
+				  u8 *old_mac_address,
+				  const u8 *new_mac_address);
 
 	int (*iwarp_set_engine_affin)(struct qed_dev *cdev, bool b_reset);
 
-- 
2.31.1

