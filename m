Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B531447DEF8
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 07:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhLWGO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 01:14:57 -0500
Received: from out162-62-57-210.mail.qq.com ([162.62.57.210]:46171 "EHLO
        out162-62-57-210.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232070AbhLWGOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 01:14:54 -0500
X-Greylist: delayed 12913 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 01:14:53 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1640240086;
        bh=hoEccdzgT+hTFuDDMPF0ayD1KF9Q5Q3E+vRq58AJges=;
        h=From:To:Cc:Subject:Date;
        b=f3Vd1gikPWdNnF3x3BBHW507AeVchzllYQlcxaCbW7PtyFU4KEYGuG+4qUp9yDIcg
         oYxQoC4pL2dCR2zM+2mLvplhl5KJKl0YCtnDqE9rjdnBxRsFib0S9p2LlSWxmDWkDV
         QkjcsbI97CHW6WdXsKlUFEWgQj47hlnX+B8NDCIM=
Received: from localhost.localdomain ([116.199.80.130])
        by newxmesmtplogicsvrszb6.qq.com (NewEsmtp) with SMTP
        id 2DAA1E6A; Thu, 23 Dec 2021 14:11:26 +0800
X-QQ-mid: xmsmtpt1640239886thy6d3jfr
Message-ID: <tencent_4535911418B2B9790CBC57166C94A26F650A@qq.com>
X-QQ-XMAILINFO: NzOHSugmTg7Xb44ONWmkLAsu4mEYmHxACTmqKQ8p8OnfwLofN2F46lqDK86gPQ
         X0nevqbDzjr/33mHsNXr8Wg4jBxQo89hTpgINLFjx7QqP9P/zc0DrZwSBVJ0fkoXnaI+LEZYcsID
         PGjEfjQlxEZR1RMPQ2+ooR4hwc5i/qxfmEOpLCAc+cgaowwOQCXy6QyvhIzrX0C2loxMwLO964or
         V8US9VCsgWvOpHs40bmyFGA8LxWBnJywmi9SccCztCrAyA9Ov9mzycoYSaFwzdAMdCelXGRJICYJ
         xw+ALM3FK0YTut+tNvHWUN/InNEGlxx6yGH8B/FtWb4Osy4/HNh8A3EHX6EUSNzcj2YuYZIXwCv4
         qEtedShAaG7gjwOFuRFg4Nz88wWTZI3KxvP7DiFnui/yLWANDlJSaqdtT7r2QG/2VZJNQojgle/Y
         O1zJXWv0cVvN2yubbfLZq6zM7Y+rpcNrFY1nTns6POAiNiqAqvBMTuciFYn6u/VXuGrELlzc0HjK
         iDiixdwOqk2lrG2JmlRX7AW2e7btY8rKhWQ67l3eFGfKTm7EgrfH3gZx/RlI5bIqQVlUQeLze3yP
         8jSyiYFJFD1Gun3TSB/qaAH1EjGtwLEUxZKu7DmpuUF5q+/X/NLu2eDQvcAHVHUGFGCqIHdiVe18
         Yg7tdBPIT999UGV0eZM15Pf7DFJ5IbrEBWTrsMRRxbNCjiN3Pguyxj2xhuMJJj81dYv2cWTufDjL
         L30oAEYehJmAjCUDWG0jpKX2dhhu7efCKFwtgoxMZhsnWBLdRKhEVWzENiewXxLbX422UJ/PdE5i
         9kmNOZeClZTjpi6ux/61+g7mnGf3NRQ9I0Ob66Cw/ZaNvLFSqq3WW4wulVBoQySofTqPQ1HMJCRK
         kbfk64yU1r3NigVtD6GWKPyZ7lrlVnqgfaXvjhz6Wxh2rAs5QFg5Y=
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, Conley Lee <conleylee@foxmail.com>
Subject: [PATCH v3] sun4i-emac.c: add dma support
Date:   Thu, 23 Dec 2021 14:11:22 +0800
X-OQ-MSGID: <20211223061122.14975-1-conleylee@foxmail.com>
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
 drivers/net/ethernet/allwinner/sun4i-emac.c | 224 +++++++++++++++++---
 1 file changed, 197 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 800ee022388f..f86a4a02157b 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/phy.h>
 #include <linux/soc/sunxi/sunxi_sram.h>
+#include <linux/dmaengine.h>
 
 #include "sun4i-emac.h"
 
@@ -76,7 +77,6 @@ struct emac_board_info {
 	void __iomem		*membase;
 	u32			msg_enable;
 	struct net_device	*ndev;
-	struct sk_buff		*skb_last;
 	u16			tx_fifo_stat;
 
 	int			emacrx_completed_flag;
@@ -87,6 +87,16 @@ struct emac_board_info {
 	unsigned int		duplex;
 
 	phy_interface_t		phy_interface;
+	struct dma_chan	*rx_chan;
+	phys_addr_t emac_rx_fifo;
+};
+
+struct emac_dma_req {
+	struct emac_board_info *db;
+	struct dma_async_tx_descriptor *desc;
+	struct sk_buff *sbk;
+	dma_addr_t rxbuf;
+	int count;
 };
 
 static void emac_update_speed(struct net_device *dev)
@@ -206,6 +216,110 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
 	readsl(reg, data, round_up(count, 4) / 4);
 }
 
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
 			      struct ethtool_drvinfo *info)
@@ -499,7 +613,6 @@ static void emac_rx(struct net_device *dev)
 	struct sk_buff *skb;
 	u8 *rdptr;
 	bool good_packet;
-	static int rxlen_last;
 	unsigned int reg_val;
 	u32 rxhdr, rxstatus, rxcount, rxlen;
 
@@ -514,22 +627,6 @@ static void emac_rx(struct net_device *dev)
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
@@ -617,20 +714,28 @@ static void emac_rx(struct net_device *dev)
 			if (!skb)
 				continue;
 			skb_reserve(skb, 2);
-			rdptr = skb_put(skb, rxlen - 4);
 
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
+				emac_inblk_32bit(db->membase + EMAC_RX_IO_DATA_REG,
+						rdptr, rxlen);
+				dev->stats.rx_bytes += rxlen;
+
+				/* Pass to upper layer */
+				skb->protocol = eth_type_trans(skb, dev);
+				netif_rx(skb);
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
@@ -677,7 +782,12 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
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
@@ -782,6 +892,58 @@ static const struct net_device_ops emac_netdev_ops = {
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
@@ -824,6 +986,9 @@ static int emac_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
+	if (emac_configure_dma(db))
+		netdev_info(ndev, "configure dma failed. disable dma.\n");
+
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
@@ -906,6 +1071,11 @@ static int emac_remove(struct platform_device *pdev)
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
-- 
2.34.1

