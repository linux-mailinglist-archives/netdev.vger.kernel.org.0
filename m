Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF6547DDCB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 03:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345961AbhLWCl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 21:41:56 -0500
Received: from out162-62-57-252.mail.qq.com ([162.62.57.252]:41215 "EHLO
        out162-62-57-252.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhLWClx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 21:41:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1640227310;
        bh=RFID8+ycxmzO2J0FQX2MQtRWWdUVfIkevDd5CUUvUDs=;
        h=From:To:Cc:Subject:Date;
        b=w9nDlTD3/rMCjafGyycxO0xmCxYy5ShVpu/K3m3t/H/wpCR7fhxSKLt/cMTUk7jtK
         g5FmJidN0eh0WyJPeJ25Xh138d4dmWEEUhM9BTdstiTar2uO7EXCHE/h1LBRG2OoMI
         FyFttBzwcFi9Ngn7BbF9oTdQf3GHfAP2PzLW7xe4=
Received: from localhost.localdomain ([116.199.80.130])
        by newxmesmtplogicsvrsza5.qq.com (NewEsmtp) with SMTP
        id 99904C05; Thu, 23 Dec 2021 10:38:25 +0800
X-QQ-mid: xmsmtpt1640227105taswcvcsp
Message-ID: <tencent_8CA077D2028352FE2DFA26A2822836540F07@qq.com>
X-QQ-XMAILINFO: M1xqn9pGP6LNIUjw1HfxfaZeWVcbSB+akt/W0wv/q5J8Henc4q3IiJSKs5dlre
         hyahjfLIfoa9vQaE4eDoz4a/QoiKfBQ5LQhg1fBU0R0T912OSiIBLJ3LapwFo83ivA5A/7ILprUm
         sKvy57H8vO1VFWIxpXUpjRAB8FpcRO7aaSCNl/hcpFSXJy4WnOoKMWEJ82U79cDsgQEZpZtVlamH
         2x3Tuas5IzxYbilM3/mvn1O3AuA58BxFD51RkecAJl6/QRSiwRHtKX3pzggVKFHx7uFg8I5AiRmG
         tBOZJyXqSVryTM0D5dyjSBEkeP/0Eh4K+DLaUKwt2e3KjSDRcHa65WOIaR1kta8o4ihkYwf6gR/j
         wlDFW7F2AQKI56Dn36FgaByXyKZYsadX7batPBciO4caaoNRn5FfrVPNXem7jr6FtYmEkVx6l9rz
         jNaTM7Tc8s4aWF1wIs9khiTid0Ed66+5KsVzvchKiCuue0aS16NhTLMw90rrqltSjJPzZSL6r4nn
         ySkv44kn9KMs3cMKsIBPKAJuMnqISiV/zKtP/cePo7Krk/d0BGj4uLSFLJ1/iAFI/t3KxdyeZgav
         X6RaR9l4gbm6zuWLNAdeLaxcjIRRY6U7mcTi6CnlHC3GIWz4EGO1ibr9LiO9dTt36M1GZCNBtl7H
         qHkqiaFiPdaBINGmC4uS8qL7YVVjraeYAlo2IuvsgKfop9a5fiasD46eLtYyU1tmKOC9AHvHaMV3
         dUa8DlUOGk3lU34BvpPZVtwj4NZIdSZ2sV/omTlGQHGI7E5+oqSUEVTm7x4KyZxLISfluOeRzDe6
         iyNR8/wgTtbHtrJvKpcpJAusKxz5ltLPgVTG9XJAlrsNhgaZTo+C0zv6Ugvb2+sR3RXCIOZvfemg
         ==
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Conley Lee <conleylee@foxmail.com>
Subject: [PATCH v2] sun4i-emac.c: add dma support
Date:   Thu, 23 Dec 2021 10:38:19 +0800
X-OQ-MSGID: <20211223023819.21524-1-conleylee@foxmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Conley Lee <conleylee@foxmail.com>

This patch adds support for the emac rx dma present on sun4i.
The emac is able to move packets from rx fifo to RAM by using dma.

Signed-off-by: Conley Lee <conleylee@foxmail.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 391 ++++++++++++++------
 1 file changed, 284 insertions(+), 107 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 800ee022388f..04df097e4ef6 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -29,15 +29,17 @@
 #include <linux/platform_device.h>
 #include <linux/phy.h>
 #include <linux/soc/sunxi/sunxi_sram.h>
+#include <linux/dmaengine.h>
 
 #include "sun4i-emac.h"
 
-#define DRV_NAME		"sun4i-emac"
+#define DRV_NAME "sun4i-emac"
 
-#define EMAC_MAX_FRAME_LEN	0x0600
+#define EMAC_MAX_FRAME_LEN 0x600
 
 #define EMAC_DEFAULT_MSG_ENABLE 0x0000
-static int debug = -1;     /* defaults above */;
+static int debug = -1; /* defaults above */
+;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "debug message flags");
 
@@ -69,24 +71,25 @@ MODULE_PARM_DESC(watchdog, "transmit timeout in milliseconds");
  */
 
 struct emac_board_info {
-	struct clk		*clk;
-	struct device		*dev;
-	struct platform_device	*pdev;
-	spinlock_t		lock;
-	void __iomem		*membase;
-	u32			msg_enable;
-	struct net_device	*ndev;
-	struct sk_buff		*skb_last;
-	u16			tx_fifo_stat;
-
-	int			emacrx_completed_flag;
-
-	struct device_node	*phy_node;
-	unsigned int		link;
-	unsigned int		speed;
-	unsigned int		duplex;
-
-	phy_interface_t		phy_interface;
+	struct clk *clk;
+	struct device *dev;
+	struct platform_device *pdev;
+	spinlock_t lock;
+	void __iomem *membase;
+	u32 msg_enable;
+	struct net_device *ndev;
+	u16 tx_fifo_stat;
+
+	int emacrx_completed_flag;
+
+	struct device_node *phy_node;
+	unsigned int link;
+	unsigned int speed;
+	unsigned int duplex;
+
+	phy_interface_t phy_interface;
+	struct dma_chan *rx_chan;
+	phys_addr_t emac_rx_fifo;
 };
 
 static void emac_update_speed(struct net_device *dev)
@@ -163,8 +166,7 @@ static int emac_mdio_probe(struct net_device *dev)
 
 	/* attach the mac to the phy */
 	phydev = of_phy_connect(db->ndev, db->phy_node,
-				&emac_handle_link_change, 0,
-				db->phy_interface);
+				&emac_handle_link_change, 0, db->phy_interface);
 	if (!phydev) {
 		netdev_err(db->ndev, "could not find the PHY\n");
 		return -ENODEV;
@@ -206,9 +208,121 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
 	readsl(reg, data, round_up(count, 4) / 4);
 }
 
+struct emac_dma_req {
+	struct emac_board_info *db;
+	struct dma_async_tx_descriptor *desc;
+	struct sk_buff *sbk;
+	dma_addr_t rxbuf;
+	int count;
+};
+
+static struct emac_dma_req *
+alloc_emac_dma_req(struct emac_board_info *db,
+		   struct dma_async_tx_descriptor *desc, struct sk_buff *skb,
+		   dma_addr_t rxbuf, int count)
+{
+	struct emac_dma_req *req =
+		kzalloc(sizeof(struct emac_dma_req), GFP_KERNEL);
+	if (!req)
+		return NULL;
+
+	req->db = db;
+	req->desc = desc;
+	req->sbk = skb;
+	req->rxbuf = rxbuf;
+	req->count = count;
+	return req;
+}
+
+static void free_emac_dma_req(struct emac_dma_req *req)
+{
+	kfree(req);
+}
+
+static void emac_dma_done_callback(void *arg)
+{
+	struct emac_dma_req *req = arg;
+	struct emac_board_info *db = req->db;
+	struct sk_buff *skb = req->sbk;
+	struct net_device *dev = db->ndev;
+	int rxlen = req->count;
+	u32 reg_val;
+
+	dma_unmap_single(db->dev, req->rxbuf, rxlen, DMA_FROM_DEVICE);
+
+	skb->protocol = eth_type_trans(skb, dev);
+	netif_rx(skb);
+	dev->stats.rx_bytes += rxlen;
+	/* Pass to upper layer */
+	dev->stats.rx_packets++;
+
+	//re enable cpu receive
+	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
+	reg_val &= ~EMAC_RX_CTL_DMA_EN;
+	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
+
+	//re enable interrupt
+	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
+	reg_val |= (0x01 << 8);
+	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
+
+	db->emacrx_completed_flag = 1;
+	free_emac_dma_req(req);
+}
+
+static void emac_dma_inblk_32bit(struct emac_board_info *db,
+				 struct sk_buff *skb, int count)
+{
+	struct dma_async_tx_descriptor *desc;
+	dma_cookie_t cookie;
+	dma_addr_t rxbuf;
+	void *rdptr;
+	struct emac_dma_req *req;
+
+	rdptr = skb_put(skb, count - 4);
+	rxbuf = dma_map_single(db->dev, rdptr, count, DMA_FROM_DEVICE);
+
+	if (dma_mapping_error(db->dev, rxbuf)) {
+		dev_err(db->dev, "dma mapping error.\n");
+		return;
+	}
+
+	desc = dmaengine_prep_slave_single(db->rx_chan, rxbuf, count,
+					   DMA_DEV_TO_MEM,
+					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(db->dev, "prepare slave single failed\n");
+		goto prepare_err;
+	}
+
+	req = alloc_emac_dma_req(db, desc, skb, rxbuf, count);
+	if (!req) {
+		dev_err(db->dev, "alloc emac dma req error.\n");
+		goto prepare_err;
+	}
+
+	desc->callback_param = req;
+	desc->callback = emac_dma_done_callback;
+
+	cookie = dmaengine_submit(desc);
+	if (dma_submit_error(cookie)) {
+		dev_err(db->dev, "dma submit error.\n");
+		goto submit_err;
+	}
+
+	dma_async_issue_pending(db->rx_chan);
+	return;
+
+submit_err:
+	free_emac_dma_req(req);
+
+prepare_err:
+	dma_unmap_single(db->dev, rxbuf, count, DMA_FROM_DEVICE);
+}
+
 /* ethtool ops */
 static void emac_get_drvinfo(struct net_device *dev,
-			      struct ethtool_drvinfo *info)
+			     struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
 	strlcpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
@@ -229,12 +343,12 @@ static void emac_set_msglevel(struct net_device *dev, u32 value)
 }
 
 static const struct ethtool_ops emac_ethtool_ops = {
-	.get_drvinfo	= emac_get_drvinfo,
-	.get_link	= ethtool_op_get_link,
+	.get_drvinfo = emac_get_drvinfo,
+	.get_link = ethtool_op_get_link,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
-	.get_msglevel	= emac_get_msglevel,
-	.set_msglevel	= emac_set_msglevel,
+	.get_msglevel = emac_get_msglevel,
+	.set_msglevel = emac_set_msglevel,
 };
 
 static unsigned int emac_setup(struct net_device *ndev)
@@ -246,14 +360,14 @@ static unsigned int emac_setup(struct net_device *ndev)
 	reg_val = readl(db->membase + EMAC_TX_MODE_REG);
 
 	writel(reg_val | EMAC_TX_MODE_ABORTED_FRAME_EN,
-		db->membase + EMAC_TX_MODE_REG);
+	       db->membase + EMAC_TX_MODE_REG);
 
 	/* set MAC */
 	/* set MAC CTL0 */
 	reg_val = readl(db->membase + EMAC_MAC_CTL0_REG);
 	writel(reg_val | EMAC_MAC_CTL0_RX_FLOW_CTL_EN |
-		EMAC_MAC_CTL0_TX_FLOW_CTL_EN,
-		db->membase + EMAC_MAC_CTL0_REG);
+		       EMAC_MAC_CTL0_TX_FLOW_CTL_EN,
+	       db->membase + EMAC_MAC_CTL0_REG);
 
 	/* set MAC CTL1 */
 	reg_val = readl(db->membase + EMAC_MAC_CTL1_REG);
@@ -267,15 +381,14 @@ static unsigned int emac_setup(struct net_device *ndev)
 
 	/* set up IPGR */
 	writel((EMAC_MAC_IPGR_IPG1 << 8) | EMAC_MAC_IPGR_IPG2,
-		db->membase + EMAC_MAC_IPGR_REG);
+	       db->membase + EMAC_MAC_IPGR_REG);
 
 	/* set up Collison window */
 	writel((EMAC_MAC_CLRT_COLLISION_WINDOW << 8) | EMAC_MAC_CLRT_RM,
-		db->membase + EMAC_MAC_CLRT_REG);
+	       db->membase + EMAC_MAC_CLRT_REG);
 
 	/* set up Max Frame Length */
-	writel(EMAC_MAX_FRAME_LEN,
-		db->membase + EMAC_MAC_MAXF_REG);
+	writel(EMAC_MAX_FRAME_LEN, db->membase + EMAC_MAC_MAXF_REG);
 
 	return 0;
 }
@@ -294,10 +407,11 @@ static void emac_set_rx_mode(struct net_device *ndev)
 		reg_val &= ~EMAC_RX_CTL_PASS_ALL_EN;
 
 	writel(reg_val | EMAC_RX_CTL_PASS_LEN_OOR_EN |
-		EMAC_RX_CTL_ACCEPT_UNICAST_EN | EMAC_RX_CTL_DA_FILTER_EN |
-		EMAC_RX_CTL_ACCEPT_MULTICAST_EN |
-		EMAC_RX_CTL_ACCEPT_BROADCAST_EN,
-		db->membase + EMAC_RX_CTL_REG);
+		       EMAC_RX_CTL_ACCEPT_UNICAST_EN |
+		       EMAC_RX_CTL_DA_FILTER_EN |
+		       EMAC_RX_CTL_ACCEPT_MULTICAST_EN |
+		       EMAC_RX_CTL_ACCEPT_BROADCAST_EN,
+	       db->membase + EMAC_RX_CTL_REG);
 }
 
 static unsigned int emac_powerup(struct net_device *ndev)
@@ -338,10 +452,12 @@ static unsigned int emac_powerup(struct net_device *ndev)
 	emac_setup(ndev);
 
 	/* set mac_address to chip */
-	writel(ndev->dev_addr[0] << 16 | ndev->dev_addr[1] << 8 | ndev->
-	       dev_addr[2], db->membase + EMAC_MAC_A1_REG);
-	writel(ndev->dev_addr[3] << 16 | ndev->dev_addr[4] << 8 | ndev->
-	       dev_addr[5], db->membase + EMAC_MAC_A0_REG);
+	writel(ndev->dev_addr[0] << 16 | ndev->dev_addr[1] << 8 |
+		       ndev->dev_addr[2],
+	       db->membase + EMAC_MAC_A1_REG);
+	writel(ndev->dev_addr[3] << 16 | ndev->dev_addr[4] << 8 |
+		       ndev->dev_addr[5],
+	       db->membase + EMAC_MAC_A0_REG);
 
 	mdelay(1);
 
@@ -358,10 +474,12 @@ static int emac_set_mac_address(struct net_device *dev, void *p)
 
 	eth_hw_addr_set(dev, addr->sa_data);
 
-	writel(dev->dev_addr[0] << 16 | dev->dev_addr[1] << 8 | dev->
-	       dev_addr[2], db->membase + EMAC_MAC_A1_REG);
-	writel(dev->dev_addr[3] << 16 | dev->dev_addr[4] << 8 | dev->
-	       dev_addr[5], db->membase + EMAC_MAC_A0_REG);
+	writel(dev->dev_addr[0] << 16 | dev->dev_addr[1] << 8 |
+		       dev->dev_addr[2],
+	       db->membase + EMAC_MAC_A1_REG);
+	writel(dev->dev_addr[3] << 16 | dev->dev_addr[4] << 8 |
+		       dev->dev_addr[5],
+	       db->membase + EMAC_MAC_A0_REG);
 
 	return 0;
 }
@@ -378,10 +496,12 @@ static void emac_init_device(struct net_device *dev)
 	emac_update_speed(dev);
 	emac_update_duplex(dev);
 
+	//emac set rx
+
 	/* enable RX/TX */
 	reg_val = readl(db->membase + EMAC_CTL_REG);
 	writel(reg_val | EMAC_CTL_RESET | EMAC_CTL_TX_EN | EMAC_CTL_RX_EN,
-		db->membase + EMAC_CTL_REG);
+	       db->membase + EMAC_CTL_REG);
 
 	/* enable RX/TX0/RX Hlevel interrup */
 	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
@@ -433,8 +553,8 @@ static netdev_tx_t emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	writel(channel, db->membase + EMAC_TX_INS_REG);
 
-	emac_outblk_32bit(db->membase + EMAC_TX_IO_DATA_REG,
-			skb->data, skb->len);
+	emac_outblk_32bit(db->membase + EMAC_TX_IO_DATA_REG, skb->data,
+			  skb->len);
 	dev->stats.tx_bytes += skb->len;
 
 	db->tx_fifo_stat |= 1 << channel;
@@ -476,7 +596,7 @@ static netdev_tx_t emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
  * receive the packet to upper layer, free the transmitted packet
  */
 static void emac_tx_done(struct net_device *dev, struct emac_board_info *db,
-			  unsigned int tx_status)
+			 unsigned int tx_status)
 {
 	/* One packet sent complete */
 	db->tx_fifo_stat &= ~(tx_status & 3);
@@ -497,9 +617,8 @@ static void emac_rx(struct net_device *dev)
 {
 	struct emac_board_info *db = netdev_priv(dev);
 	struct sk_buff *skb;
-	u8 *rdptr;
+	static u8 *rdptr;
 	bool good_packet;
-	static int rxlen_last;
 	unsigned int reg_val;
 	u32 rxhdr, rxstatus, rxcount, rxlen;
 
@@ -514,22 +633,6 @@ static void emac_rx(struct net_device *dev)
 		if (netif_msg_rx_status(db))
 			dev_dbg(db->dev, "RXCount: %x\n", rxcount);
 
-		if ((db->skb_last != NULL) && (rxlen_last > 0)) {
-			dev->stats.rx_bytes += rxlen_last;
-
-			/* Pass to upper layer */
-			db->skb_last->protocol = eth_type_trans(db->skb_last,
-								dev);
-			netif_rx(db->skb_last);
-			dev->stats.rx_packets++;
-			db->skb_last = NULL;
-			rxlen_last = 0;
-
-			reg_val = readl(db->membase + EMAC_RX_CTL_REG);
-			reg_val &= ~EMAC_RX_CTL_DMA_EN;
-			writel(reg_val, db->membase + EMAC_RX_CTL_REG);
-		}
-
 		if (!rxcount) {
 			db->emacrx_completed_flag = 1;
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
@@ -613,24 +716,32 @@ static void emac_rx(struct net_device *dev)
 
 		/* Move data from EMAC */
 		if (good_packet) {
-			skb = netdev_alloc_skb(dev, rxlen + 4);
+			//skb = netdev_alloc_skb(dev, rxlen + 4);
+			skb = dev_alloc_skb(rxlen + 4);
 			if (!skb)
 				continue;
 			skb_reserve(skb, 2);
-			rdptr = skb_put(skb, rxlen - 4);
-
 			/* Read received packet from RX SRAM */
 			if (netif_msg_rx_status(db))
 				dev_dbg(db->dev, "RxLen %x\n", rxlen);
 
-			emac_inblk_32bit(db->membase + EMAC_RX_IO_DATA_REG,
-					rdptr, rxlen);
-			dev->stats.rx_bytes += rxlen;
-
-			/* Pass to upper layer */
-			skb->protocol = eth_type_trans(skb, dev);
-			netif_rx(skb);
-			dev->stats.rx_packets++;
+			if (rxlen < dev->mtu || !db->rx_chan) {
+				rdptr = skb_put(skb, rxlen - 4);
+				emac_inblk_32bit(db->membase +
+							 EMAC_RX_IO_DATA_REG,
+						 rdptr, rxlen);
+				skb->protocol = eth_type_trans(skb, dev);
+				netif_rx(skb);
+				dev->stats.rx_bytes += rxlen;
+				/* Pass to upper layer */
+				dev->stats.rx_packets++;
+			} else {
+				reg_val = readl(db->membase + EMAC_RX_CTL_REG);
+				reg_val |= EMAC_RX_CTL_DMA_EN;
+				writel(reg_val, db->membase + EMAC_RX_CTL_REG);
+				emac_dma_inblk_32bit(db, skb, rxlen);
+				break;
+			}
 		}
 	}
 }
@@ -677,7 +788,12 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
 		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
 		reg_val |= (0xf << 0) | (0x01 << 8);
 		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
+	} else {
+		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
+		reg_val |= (0xf << 0);
+		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 	}
+
 	spin_unlock(&db->lock);
 
 	return IRQ_HANDLED;
@@ -723,6 +839,8 @@ static int emac_open(struct net_device *dev)
 	phy_start(dev->phydev);
 	netif_start_queue(dev);
 
+	dev_info(&dev->dev, "open emac, mtu = %u, max mtu = %u\n", dev->mtu,
+		 dev->max_mtu);
 	return 0;
 }
 
@@ -769,19 +887,71 @@ static int emac_stop(struct net_device *ndev)
 }
 
 static const struct net_device_ops emac_netdev_ops = {
-	.ndo_open		= emac_open,
-	.ndo_stop		= emac_stop,
-	.ndo_start_xmit		= emac_start_xmit,
-	.ndo_tx_timeout		= emac_timeout,
-	.ndo_set_rx_mode	= emac_set_rx_mode,
-	.ndo_eth_ioctl		= phy_do_ioctl_running,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_mac_address	= emac_set_mac_address,
+	.ndo_open = emac_open,
+	.ndo_stop = emac_stop,
+	.ndo_start_xmit = emac_start_xmit,
+	.ndo_tx_timeout = emac_timeout,
+	.ndo_set_rx_mode = emac_set_rx_mode,
+	.ndo_eth_ioctl = phy_do_ioctl_running,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_set_mac_address = emac_set_mac_address,
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= emac_poll_controller,
+	.ndo_poll_controller = emac_poll_controller,
 #endif
 };
 
+static int emac_configure_dma(struct emac_board_info *db)
+{
+	struct platform_device *pdev = db->pdev;
+	struct net_device *ndev = db->ndev;
+	struct dma_slave_config conf = {};
+	struct resource *regs;
+	int err = 0;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		netdev_err(ndev, "get io resource from device failed.\n");
+		err = -ENOMEM;
+		goto out_clear_chan;
+	}
+
+	netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
+		    regs->start, resource_size(regs));
+	db->emac_rx_fifo = regs->start + EMAC_RX_IO_DATA_REG;
+
+	db->rx_chan = dma_request_chan(&pdev->dev, "rx");
+	if (IS_ERR(db->rx_chan)) {
+		netdev_err(ndev,
+			   "failed to request dma channel. dma is disabled");
+		err = PTR_ERR(db->rx_chan);
+		goto out_clear_chan;
+	}
+
+	conf.direction = DMA_DEV_TO_MEM;
+	conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	conf.src_addr = db->emac_rx_fifo;
+	conf.dst_maxburst = 4;
+	conf.src_maxburst = 4;
+	conf.device_fc = false;
+
+	err = dmaengine_slave_config(db->rx_chan, &conf);
+	if (err) {
+		netdev_err(ndev, "config dma slave failed\n");
+		err = -EINVAL;
+		goto out_slave_configure_err;
+	}
+
+	return err;
+
+out_slave_configure_err:
+	dma_release_channel(db->rx_chan);
+
+out_clear_chan:
+	db->rx_chan = NULL;
+	return err;
+}
+
 /* Search EMAC board, allocate space and register it
  */
 static int emac_probe(struct platform_device *pdev)
@@ -789,6 +959,7 @@ static int emac_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct emac_board_info *db;
 	struct net_device *ndev;
+
 	int ret = 0;
 
 	ndev = alloc_etherdev(sizeof(struct emac_board_info));
@@ -810,7 +981,7 @@ static int emac_probe(struct platform_device *pdev)
 
 	db->membase = of_iomap(np, 0);
 	if (!db->membase) {
-		dev_err(&pdev->dev, "failed to remap registers\n");
+		netdev_err(ndev, "failed to remap registers\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -824,6 +995,9 @@ static int emac_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
+	if (emac_configure_dma(db))
+		netdev_info(ndev, "configure dma failed. disable dma.\n");
+
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
@@ -832,13 +1006,13 @@ static int emac_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(db->clk);
 	if (ret) {
-		dev_err(&pdev->dev, "Error couldn't enable clock (%d)\n", ret);
+		netdev_err(ndev, "Error couldn't enable clock (%d)\n", ret);
 		goto out_dispose_mapping;
 	}
 
 	ret = sunxi_sram_claim(&pdev->dev);
 	if (ret) {
-		dev_err(&pdev->dev, "Error couldn't map SRAM to device\n");
+		netdev_err(ndev, "Error couldn't map SRAM to device\n");
 		goto out_clk_disable_unprepare;
 	}
 
@@ -846,7 +1020,7 @@ static int emac_probe(struct platform_device *pdev)
 	if (!db->phy_node)
 		db->phy_node = of_parse_phandle(np, "phy", 0);
 	if (!db->phy_node) {
-		dev_err(&pdev->dev, "no associated PHY\n");
+		netdev_err(ndev, "no associated PHY\n");
 		ret = -ENODEV;
 		goto out_release_sram;
 	}
@@ -856,8 +1030,8 @@ static int emac_probe(struct platform_device *pdev)
 	if (ret) {
 		/* if the MAC address is invalid get a random one */
 		eth_hw_addr_random(ndev);
-		dev_warn(&pdev->dev, "using random MAC address %pM\n",
-			 ndev->dev_addr);
+		netdev_warn(ndev, "using random MAC address %pM\n",
+			    ndev->dev_addr);
 	}
 
 	db->emacrx_completed_flag = 1;
@@ -875,13 +1049,13 @@ static int emac_probe(struct platform_device *pdev)
 
 	ret = register_netdev(ndev);
 	if (ret) {
-		dev_err(&pdev->dev, "Registering netdev failed!\n");
+		netdev_err(ndev, "Registering netdev failed!\n");
 		ret = -ENODEV;
 		goto out_release_sram;
 	}
 
-	dev_info(&pdev->dev, "%s: at %p, IRQ %d MAC: %pM\n",
-		 ndev->name, db->membase, ndev->irq, ndev->dev_addr);
+	netdev_info(ndev, "%s: at %p, IRQ %d MAC: %pM\n", ndev->name,
+		    db->membase, ndev->irq, ndev->dev_addr);
 
 	return 0;
 
@@ -894,10 +1068,9 @@ static int emac_probe(struct platform_device *pdev)
 out_iounmap:
 	iounmap(db->membase);
 out:
-	dev_err(db->dev, "not found (%d).\n", ret);
+	netdev_err(ndev, "not found (%d).\n", ret);
 
 	free_netdev(ndev);
-
 	return ret;
 }
 
@@ -906,6 +1079,11 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct emac_board_info *db = netdev_priv(ndev);
 
+	if (db->rx_chan) {
+		dmaengine_terminate_all(db->rx_chan);
+		dma_release_channel(db->rx_chan);
+	}
+
 	unregister_netdev(ndev);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
@@ -941,10 +1119,9 @@ static int emac_resume(struct platform_device *dev)
 }
 
 static const struct of_device_id emac_of_match[] = {
-	{.compatible = "allwinner,sun4i-a10-emac",},
-
-	/* Deprecated */
-	{.compatible = "allwinner,sun4i-emac",},
+	{
+		.compatible = "allwinner,sun4i-a10-emac",
+	},
 	{},
 };
 
@@ -952,9 +1129,9 @@ MODULE_DEVICE_TABLE(of, emac_of_match);
 
 static struct platform_driver emac_driver = {
 	.driver = {
-		.name = "sun4i-emac",
-		.of_match_table = emac_of_match,
-	},
+			.name = "sun4i-emac",
+			.of_match_table = emac_of_match,
+		},
 	.probe = emac_probe,
 	.remove = emac_remove,
 	.suspend = emac_suspend,
-- 
2.34.1

