Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A0A47CD5C
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 08:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbhLVHK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 02:10:57 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:55355 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235892AbhLVHK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 02:10:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1640157053;
        bh=uKcwwQGs3p5cJj1MkH7zm62evchBCQSSg3ejDBwaE4Q=;
        h=From:To:Cc:Subject:Date;
        b=CAE4oPIpXg90snGTkHbholgLAj5eGIEqFnJq/xsWCeq7EIZvpXCdlRgjE9HFp9dGW
         FqDJEPCvfUac/9b9H1alt7sXlQe0AiMwtXMRLTDzuAIp29iKbOEXUj2hSyQ/y+5Rn2
         4A97bnLEXmAOpRzqazg7nYIoEWtM8DGDI4onZW1U=
Received: from localhost.localdomain ([116.199.80.130])
        by newxmesmtplogicsvrszc7.qq.com (NewEsmtp) with SMTP
        id 26589C8B; Wed, 22 Dec 2021 15:09:37 +0800
X-QQ-mid: xmsmtpt1640156977tgl5rcucy
Message-ID: <tencent_004AE1B7729BE20B02D8003D40DE850A9609@qq.com>
X-QQ-XMAILINFO: MPRquJFDOUjC9e0Nn81zVrPfygInVkMApiUe4YJ1bKzeRb1GxAT2+Xj82KWSlh
         aclyCspI9SIsztRvj4RO7xvfbSs6f+buNBZY4cjJ+Ofh9/gdmvYoHpHTk2GWEOY0+vvl8yKqhW6X
         mVqS8vY6iajy9pR8Q+DldooqV8lmd3kzMvuxJWk6Fdy0TXLxh1WBZXvrowtKdUBGzxYv1qa/cDpf
         9dAb3/2NWoP28v2UB2dvaC0rl0TYp8NSWWkUMVG9WQ77pbS6rDF/ElEdaj6U62ZtjsFspdP/ahOU
         +oylqjw3FQJzSYgWXlNv17BY3rykcegd8JLhvSA3XoFuzSuHrrO9BWA2zRCXMvg+pVp31L3Pe0um
         gA46f6R6sTeFyH95FhUwvQNl9yke5kfaD4PP3BePPKCXSV7Sl4RZpjuydEgr+OJIMVOZVrNkSVBJ
         5g2H4FlWlk4TZb2HA/KxXvKaljlswR/Lezz7bJFioy80kXAdqFWNn09O15+A3AgJ66J3Q0WzJCru
         kk1VzHh3mH3VeVJu63dhvD3uAdOlOqAz4+jGrpA+pEDrM2RBL2DbbU57Q4nNL85MY1G4DDv5UP71
         khlv5wfOW+jNjV7rpsoqpE9M16kmezxKqdARCsopQL3CxKzGrTRrmo2ptJtrFA4sF+6TcZtwPsax
         e1rmzEd23F0Khdk2LS9x0t+ZNhegSNPrhi8mRFsSlQ4BeE/ncTDWsJtueJ8ZXlv6lq982kiXhkN9
         1jyCNzjL0OH/rW4WewVKWOqt/GDcrxqfEKaWtGrL7aH6OWNFNZ9LHcQ7xlmjquaFY19Qi6sH4q7u
         jQhxNH5ToB3AucB8z8sMWOZCUvhsqit0nV+Fy1smGqDT4rdg88iISlJgVHjoQH+9uPVsHQMW3cgz
         23aq5fDJ9Xtq9I2s1bbZeLa0drz21KV+zYE5psTQd+BIGxJ60Sofk=
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Conley Lee <conleylee@foxmail.com>
Subject: [PATCH] sun4i-emac.c: add dma support
Date:   Wed, 22 Dec 2021 15:09:27 +0800
X-OQ-MSGID: <20211222070927.7366-1-conleylee@foxmail.com>
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
 drivers/net/ethernet/allwinner/sun4i-emac.c | 388 ++++++++++++++------
 1 file changed, 283 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 800ee022388f..feb5c154ba2d 100644
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
@@ -206,9 +208,120 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
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
@@ -229,12 +342,12 @@ static void emac_set_msglevel(struct net_device *dev, u32 value)
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
@@ -246,14 +359,14 @@ static unsigned int emac_setup(struct net_device *ndev)
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
@@ -267,15 +380,14 @@ static unsigned int emac_setup(struct net_device *ndev)
 
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
@@ -294,10 +406,11 @@ static void emac_set_rx_mode(struct net_device *ndev)
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
@@ -338,10 +451,12 @@ static unsigned int emac_powerup(struct net_device *ndev)
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
 
@@ -358,10 +473,12 @@ static int emac_set_mac_address(struct net_device *dev, void *p)
 
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
@@ -378,10 +495,12 @@ static void emac_init_device(struct net_device *dev)
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
@@ -433,8 +552,8 @@ static netdev_tx_t emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	writel(channel, db->membase + EMAC_TX_INS_REG);
 
-	emac_outblk_32bit(db->membase + EMAC_TX_IO_DATA_REG,
-			skb->data, skb->len);
+	emac_outblk_32bit(db->membase + EMAC_TX_IO_DATA_REG, skb->data,
+			  skb->len);
 	dev->stats.tx_bytes += skb->len;
 
 	db->tx_fifo_stat |= 1 << channel;
@@ -476,7 +595,7 @@ static netdev_tx_t emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
  * receive the packet to upper layer, free the transmitted packet
  */
 static void emac_tx_done(struct net_device *dev, struct emac_board_info *db,
-			  unsigned int tx_status)
+			 unsigned int tx_status)
 {
 	/* One packet sent complete */
 	db->tx_fifo_stat &= ~(tx_status & 3);
@@ -497,9 +616,8 @@ static void emac_rx(struct net_device *dev)
 {
 	struct emac_board_info *db = netdev_priv(dev);
 	struct sk_buff *skb;
-	u8 *rdptr;
+	static u8 *rdptr;
 	bool good_packet;
-	static int rxlen_last;
 	unsigned int reg_val;
 	u32 rxhdr, rxstatus, rxcount, rxlen;
 
@@ -514,22 +632,6 @@ static void emac_rx(struct net_device *dev)
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
@@ -613,24 +715,32 @@ static void emac_rx(struct net_device *dev)
 
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
@@ -677,7 +787,12 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
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
@@ -723,6 +838,8 @@ static int emac_open(struct net_device *dev)
 	phy_start(dev->phydev);
 	netif_start_queue(dev);
 
+	dev_info(&dev->dev, "open emac, mtu = %u, max mtu = %u\n", dev->mtu,
+		 dev->max_mtu);
 	return 0;
 }
 
@@ -769,19 +886,68 @@ static int emac_stop(struct net_device *ndev)
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
@@ -789,6 +955,7 @@ static int emac_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct emac_board_info *db;
 	struct net_device *ndev;
+
 	int ret = 0;
 
 	ndev = alloc_etherdev(sizeof(struct emac_board_info));
@@ -810,7 +977,7 @@ static int emac_probe(struct platform_device *pdev)
 
 	db->membase = of_iomap(np, 0);
 	if (!db->membase) {
-		dev_err(&pdev->dev, "failed to remap registers\n");
+		netdev_err(ndev, "failed to remap registers\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -824,6 +991,9 @@ static int emac_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
+	if (emac_configure_dma(db))
+		netdev_info(ndev, "configure dma failed. disable dma.\n");
+
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
@@ -832,13 +1002,13 @@ static int emac_probe(struct platform_device *pdev)
 
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
 
@@ -846,7 +1016,7 @@ static int emac_probe(struct platform_device *pdev)
 	if (!db->phy_node)
 		db->phy_node = of_parse_phandle(np, "phy", 0);
 	if (!db->phy_node) {
-		dev_err(&pdev->dev, "no associated PHY\n");
+		netdev_err(ndev, "no associated PHY\n");
 		ret = -ENODEV;
 		goto out_release_sram;
 	}
@@ -856,8 +1026,8 @@ static int emac_probe(struct platform_device *pdev)
 	if (ret) {
 		/* if the MAC address is invalid get a random one */
 		eth_hw_addr_random(ndev);
-		dev_warn(&pdev->dev, "using random MAC address %pM\n",
-			 ndev->dev_addr);
+		netdev_warn(ndev, "using random MAC address %pM\n",
+			    ndev->dev_addr);
 	}
 
 	db->emacrx_completed_flag = 1;
@@ -875,13 +1045,13 @@ static int emac_probe(struct platform_device *pdev)
 
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
 
@@ -894,10 +1064,9 @@ static int emac_probe(struct platform_device *pdev)
 out_iounmap:
 	iounmap(db->membase);
 out:
-	dev_err(db->dev, "not found (%d).\n", ret);
+	netdev_err(ndev, "not found (%d).\n", ret);
 
 	free_netdev(ndev);
-
 	return ret;
 }
 
@@ -906,6 +1075,11 @@ static int emac_remove(struct platform_device *pdev)
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
@@ -941,10 +1115,14 @@ static int emac_resume(struct platform_device *dev)
 }
 
 static const struct of_device_id emac_of_match[] = {
-	{.compatible = "allwinner,sun4i-a10-emac",},
+	{
+		.compatible = "allwinner,sun4i-a10-emac",
+	},
 
 	/* Deprecated */
-	{.compatible = "allwinner,sun4i-emac",},
+	{
+		.compatible = "allwinner,sun4i-emac",
+	},
 	{},
 };
 
@@ -952,9 +1130,9 @@ MODULE_DEVICE_TABLE(of, emac_of_match);
 
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

