Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3464361C43
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbhDPIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:48:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:46348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240940AbhDPIrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 04:47:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BB6A5AF3D;
        Fri, 16 Apr 2021 08:47:17 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v4 net-next 09/10] net: korina: Make driver COMPILE_TESTable
Date:   Fri, 16 Apr 2021 10:47:10 +0200
Message-Id: <20210416084712.62561-10-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416084712.62561-1-tsbogend@alpha.franken.de>
References: <20210416084712.62561-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move structs/defines for ethernet/dma register into driver, since they
are only used for this driver and remove any MIPS specific includes.
This makes it possible to COMPILE_TEST the driver.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/Kconfig  |   2 +-
 drivers/net/ethernet/korina.c | 249 ++++++++++++++++++++++++++++++++--
 2 files changed, 239 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index c059b4bd3f23..453d202a28c1 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -97,7 +97,7 @@ config JME
 
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
-	depends on MIKROTIK_RB532
+	depends on MIKROTIK_RB532 || COMPILE_TEST
 	select MII
 	help
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index e95c8d87d893..5f39a5bba531 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -59,18 +59,244 @@
 #include <linux/pgtable.h>
 #include <linux/clk.h>
 
-#include <asm/bootinfo.h>
-#include <asm/bitops.h>
-#include <asm/io.h>
-#include <asm/dma.h>
-
-#include <asm/mach-rc32434/eth.h>
-#include <asm/mach-rc32434/dma_v.h>
-
 #define DRV_NAME	"korina"
 #define DRV_VERSION	"0.20"
 #define DRV_RELDATE	"15Sep2017"
 
+struct eth_regs {
+	u32 ethintfc;
+	u32 ethfifott;
+	u32 etharc;
+	u32 ethhash0;
+	u32 ethhash1;
+	u32 ethu0[4];		/* Reserved. */
+	u32 ethpfs;
+	u32 ethmcp;
+	u32 eth_u1[10];		/* Reserved. */
+	u32 ethspare;
+	u32 eth_u2[42];		/* Reserved. */
+	u32 ethsal0;
+	u32 ethsah0;
+	u32 ethsal1;
+	u32 ethsah1;
+	u32 ethsal2;
+	u32 ethsah2;
+	u32 ethsal3;
+	u32 ethsah3;
+	u32 ethrbc;
+	u32 ethrpc;
+	u32 ethrupc;
+	u32 ethrfc;
+	u32 ethtbc;
+	u32 ethgpf;
+	u32 eth_u9[50];		/* Reserved. */
+	u32 ethmac1;
+	u32 ethmac2;
+	u32 ethipgt;
+	u32 ethipgr;
+	u32 ethclrt;
+	u32 ethmaxf;
+	u32 eth_u10;		/* Reserved. */
+	u32 ethmtest;
+	u32 miimcfg;
+	u32 miimcmd;
+	u32 miimaddr;
+	u32 miimwtd;
+	u32 miimrdd;
+	u32 miimind;
+	u32 eth_u11;		/* Reserved. */
+	u32 eth_u12;		/* Reserved. */
+	u32 ethcfsa0;
+	u32 ethcfsa1;
+	u32 ethcfsa2;
+};
+
+/* Ethernet interrupt registers */
+#define ETH_INT_FC_EN		BIT(0)
+#define ETH_INT_FC_ITS		BIT(1)
+#define ETH_INT_FC_RIP		BIT(2)
+#define ETH_INT_FC_JAM		BIT(3)
+#define ETH_INT_FC_OVR		BIT(4)
+#define ETH_INT_FC_UND		BIT(5)
+#define ETH_INT_FC_IOC		0x000000c0
+
+/* Ethernet FIFO registers */
+#define ETH_FIFI_TT_TTH_BIT	0
+#define ETH_FIFO_TT_TTH		0x0000007f
+
+/* Ethernet ARC/multicast registers */
+#define ETH_ARC_PRO		BIT(0)
+#define ETH_ARC_AM		BIT(1)
+#define ETH_ARC_AFM		BIT(2)
+#define ETH_ARC_AB		BIT(3)
+
+/* Ethernet SAL registers */
+#define ETH_SAL_BYTE_5		0x000000ff
+#define ETH_SAL_BYTE_4		0x0000ff00
+#define ETH_SAL_BYTE_3		0x00ff0000
+#define ETH_SAL_BYTE_2		0xff000000
+
+/* Ethernet SAH registers */
+#define ETH_SAH_BYTE1		0x000000ff
+#define ETH_SAH_BYTE0		0x0000ff00
+
+/* Ethernet GPF register */
+#define ETH_GPF_PTV		0x0000ffff
+
+/* Ethernet PFG register */
+#define ETH_PFS_PFD		BIT(0)
+
+/* Ethernet CFSA[0-3] registers */
+#define ETH_CFSA0_CFSA4		0x000000ff
+#define ETH_CFSA0_CFSA5		0x0000ff00
+#define ETH_CFSA1_CFSA2		0x000000ff
+#define ETH_CFSA1_CFSA3		0x0000ff00
+#define ETH_CFSA1_CFSA0		0x000000ff
+#define ETH_CFSA1_CFSA1		0x0000ff00
+
+/* Ethernet MAC1 registers */
+#define ETH_MAC1_RE		BIT(0)
+#define ETH_MAC1_PAF		BIT(1)
+#define ETH_MAC1_RFC		BIT(2)
+#define ETH_MAC1_TFC		BIT(3)
+#define ETH_MAC1_LB		BIT(4)
+#define ETH_MAC1_MR		BIT(31)
+
+/* Ethernet MAC2 registers */
+#define ETH_MAC2_FD		BIT(0)
+#define ETH_MAC2_FLC		BIT(1)
+#define ETH_MAC2_HFE		BIT(2)
+#define ETH_MAC2_DC		BIT(3)
+#define ETH_MAC2_CEN		BIT(4)
+#define ETH_MAC2_PE		BIT(5)
+#define ETH_MAC2_VPE		BIT(6)
+#define ETH_MAC2_APE		BIT(7)
+#define ETH_MAC2_PPE		BIT(8)
+#define ETH_MAC2_LPE		BIT(9)
+#define ETH_MAC2_NB		BIT(12)
+#define ETH_MAC2_BP		BIT(13)
+#define ETH_MAC2_ED		BIT(14)
+
+/* Ethernet IPGT register */
+#define ETH_IPGT		0x0000007f
+
+/* Ethernet IPGR registers */
+#define ETH_IPGR_IPGR2		0x0000007f
+#define ETH_IPGR_IPGR1		0x00007f00
+
+/* Ethernet CLRT registers */
+#define ETH_CLRT_MAX_RET	0x0000000f
+#define ETH_CLRT_COL_WIN	0x00003f00
+
+/* Ethernet MAXF register */
+#define ETH_MAXF		0x0000ffff
+
+/* Ethernet test registers */
+#define ETH_TEST_REG		BIT(2)
+#define ETH_MCP_DIV		0x000000ff
+
+/* MII registers */
+#define ETH_MII_CFG_RSVD	0x0000000c
+#define ETH_MII_CMD_RD		BIT(0)
+#define ETH_MII_CMD_SCN		BIT(1)
+#define ETH_MII_REG_ADDR	0x0000001f
+#define ETH_MII_PHY_ADDR	0x00001f00
+#define ETH_MII_WTD_DATA	0x0000ffff
+#define ETH_MII_RDD_DATA	0x0000ffff
+#define ETH_MII_IND_BSY		BIT(0)
+#define ETH_MII_IND_SCN		BIT(1)
+#define ETH_MII_IND_NV		BIT(2)
+
+/* Values for the DEVCS field of the Ethernet DMA Rx and Tx descriptors. */
+#define ETH_RX_FD		BIT(0)
+#define ETH_RX_LD		BIT(1)
+#define ETH_RX_ROK		BIT(2)
+#define ETH_RX_FM		BIT(3)
+#define ETH_RX_MP		BIT(4)
+#define ETH_RX_BP		BIT(5)
+#define ETH_RX_VLT		BIT(6)
+#define ETH_RX_CF		BIT(7)
+#define ETH_RX_OVR		BIT(8)
+#define ETH_RX_CRC		BIT(9)
+#define ETH_RX_CV		BIT(10)
+#define ETH_RX_DB		BIT(11)
+#define ETH_RX_LE		BIT(12)
+#define ETH_RX_LOR		BIT(13)
+#define ETH_RX_CES		BIT(14)
+#define ETH_RX_LEN_BIT		16
+#define ETH_RX_LEN		0xffff0000
+
+#define ETH_TX_FD		BIT(0)
+#define ETH_TX_LD		BIT(1)
+#define ETH_TX_OEN		BIT(2)
+#define ETH_TX_PEN		BIT(3)
+#define ETH_TX_CEN		BIT(4)
+#define ETH_TX_HEN		BIT(5)
+#define ETH_TX_TOK		BIT(6)
+#define ETH_TX_MP		BIT(7)
+#define ETH_TX_BP		BIT(8)
+#define ETH_TX_UND		BIT(9)
+#define ETH_TX_OF		BIT(10)
+#define ETH_TX_ED		BIT(11)
+#define ETH_TX_EC		BIT(12)
+#define ETH_TX_LC		BIT(13)
+#define ETH_TX_TD		BIT(14)
+#define ETH_TX_CRC		BIT(15)
+#define ETH_TX_LE		BIT(16)
+#define ETH_TX_CC		0x001E0000
+
+/* DMA descriptor (in physical memory). */
+struct dma_desc {
+	u32 control;			/* Control. use DMAD_* */
+	u32 ca;				/* Current Address. */
+	u32 devcs;			/* Device control and status. */
+	u32 link;			/* Next descriptor in chain. */
+};
+
+#define DMA_DESC_COUNT_BIT		0
+#define DMA_DESC_COUNT_MSK		0x0003ffff
+#define DMA_DESC_DS_BIT			20
+#define DMA_DESC_DS_MSK			0x00300000
+
+#define DMA_DESC_DEV_CMD_BIT		22
+#define DMA_DESC_DEV_CMD_MSK		0x01c00000
+
+/* DMA descriptors interrupts */
+#define DMA_DESC_COF			BIT(25) /* Chain on finished */
+#define DMA_DESC_COD			BIT(26) /* Chain on done */
+#define DMA_DESC_IOF			BIT(27) /* Interrupt on finished */
+#define DMA_DESC_IOD			BIT(28) /* Interrupt on done */
+#define DMA_DESC_TERM			BIT(29) /* Terminated */
+#define DMA_DESC_DONE			BIT(30) /* Done */
+#define DMA_DESC_FINI			BIT(31) /* Finished */
+
+/* DMA register (within Internal Register Map).  */
+struct dma_reg {
+	u32 dmac;		/* Control. */
+	u32 dmas;		/* Status. */
+	u32 dmasm;		/* Mask. */
+	u32 dmadptr;		/* Descriptor pointer. */
+	u32 dmandptr;		/* Next descriptor pointer. */
+};
+
+/* DMA channels specific registers */
+#define DMA_CHAN_RUN_BIT		BIT(0)
+#define DMA_CHAN_DONE_BIT		BIT(1)
+#define DMA_CHAN_MODE_BIT		BIT(2)
+#define DMA_CHAN_MODE_MSK		0x0000000c
+#define	 DMA_CHAN_MODE_AUTO		0
+#define	 DMA_CHAN_MODE_BURST		1
+#define	 DMA_CHAN_MODE_XFRT		2
+#define	 DMA_CHAN_MODE_RSVD		3
+#define DMA_CHAN_ACT_BIT		BIT(4)
+
+/* DMA status registers */
+#define DMA_STAT_FINI			BIT(0)
+#define DMA_STAT_DONE			BIT(1)
+#define DMA_STAT_CHAIN			BIT(2)
+#define DMA_STAT_ERR			BIT(3)
+#define DMA_STAT_HALT			BIT(4)
+
 #define STATION_ADDRESS_HIGH(dev) (((dev)->dev_addr[0] << 8) | \
 				   ((dev)->dev_addr[1]))
 #define STATION_ADDRESS_LOW(dev)  (((dev)->dev_addr[2] << 24) | \
@@ -100,6 +326,7 @@ enum chain_status {
 	desc_empty
 };
 
+#define DMA_COUNT(count)	((count) & DMA_DESC_COUNT_MSK)
 #define IS_DMA_FINISHED(X)	(((X) & (DMA_DESC_FINI)) != 0)
 #define IS_DMA_DONE(X)		(((X) & (DMA_DESC_DONE)) != 0)
 #define RCVPKT_LENGTH(X)	(((X) & ETH_RX_LEN) >> ETH_RX_LEN_BIT)
@@ -453,14 +680,14 @@ static int korina_rx(struct net_device *dev, int limit)
 
 		lp->rx_next_done = (lp->rx_next_done + 1) & KORINA_RDS_MASK;
 		rd = &lp->rd_ring[lp->rx_next_done];
-		writel(~DMA_STAT_DONE, &lp->rx_dma_regs->dmas);
+		writel((u32)~DMA_STAT_DONE, &lp->rx_dma_regs->dmas);
 	}
 
 	dmas = readl(&lp->rx_dma_regs->dmas);
 
 	if (dmas & DMA_STAT_HALT) {
-		writel(~(DMA_STAT_HALT | DMA_STAT_ERR),
-				&lp->rx_dma_regs->dmas);
+		writel((u32)~(DMA_STAT_HALT | DMA_STAT_ERR),
+		       &lp->rx_dma_regs->dmas);
 
 		lp->dma_halt_cnt++;
 		rd->devcs = 0;
-- 
2.29.2

