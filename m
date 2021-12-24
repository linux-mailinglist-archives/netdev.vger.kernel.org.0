Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52C247EFAF
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 15:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241680AbhLXOsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 09:48:08 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:57625 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231836AbhLXOsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 09:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1640357284;
        bh=PHa+q4PYs1zgZJIhUqyJCadOd99iaCWFD+t7+7ZAnz0=;
        h=From:To:Cc:Subject:Date;
        b=PgNyJf2UOGGH2321jhOfA2+qIyyUz5KsHrMI/LSSa5nR6wZ/4cJlEm8nq4Lyw8va1
         ybJmajrtaL0jCfx035vFec6uGRh7WfFUSOPamQNBtF4FffIYya0YmcS6UD8HWP7jus
         ZKBK9zGHb8MtytE5SERRdyqNxDaCuGvMwzK1Zx4Y=
Received: from localhost.localdomain ([116.199.80.130])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id B23B7482; Fri, 24 Dec 2021 22:44:35 +0800
X-QQ-mid: xmsmtpt1640357075tvvca0rys
Message-ID: <tencent_95A0609A0DC523F7DDAE60A8746EABAA8905@qq.com>
X-QQ-XMAILINFO: NVU+YIPuXA1FsUCb1RennwU4f3XMiM8T9y0/LPStsQDRbY3r9W6g7QxKbIpkt0
         BZxI11Sytwmkqw0GvjCNYL6cs98TUTQouGa9kjMeyWuvy6Vmj6NgBRNcVWkr/3/J083dHmc30msH
         asYj/fFEsF/I2SEdr6ixRPIRUhegnX4x61x82ktgZuimhuEC9jrY7A3PA1Lt3pqAG9SV3BChxzeX
         MxlLvLD6z6kulNSN2BCqoSgU6M4OHUp+ooONwYvSqu14HP83ji7g28kw3oPs5Xcizij1DWj6vlai
         D32EybISeoa0GlWKcdZh7HCKQ/NVZYWe5Wz8uAuPkmpp1Ad4a54LWSXUufR3LiSI3r1uzMFmax6D
         s+YL+vypPlpcA5Y0j2C3nS6W4Z4F1saTQYRSS4gfm804kiets7alDmysINZHBTxKuZ+xGum2Duzq
         RLosdOk3wturF421TJK7YvoRyAHQAdGNR4NBVXrn/Yi/IpzS/bDL1niwbBGPhkT69Su70X5x8QKO
         wamdrnQM3XXPdejlxoWdF9no4q3VxGwXHlsEBSawdglysuXprXGKlqgQ6aPNplUEIcAMq4P5jaVj
         +/A/7zoHOPPEFhMedi23UJCcNq33BwyRXEXsK8K6Fqiq0zmkPIP7Gyzs2C82od6A+AzQar+8AZSh
         CO26pURmFxWkWwVjKjfwz5TIzYRQFo3JYP5D/4x3abcnBUpDAuG/FuORZOYgJPmZAcqKmrWMqiWG
         CXtliLTHTIqs+NOAF03xaI8Upiig0mZYlzooZ61f/lYBo6ylijxy9tgA6wyPdXm/xsnRFwaDlybq
         UcO0B/lu0lbOMxD5ouUM99ov2aM4GuS0lhGA/iokgQNtOt9gleNO2cmL0edPtkyhbs6DIWdScADe
         3bycKgXskAtH0MHDLS4m5m4LTpaSsVUx+ShCSnKBDp4kBOjpqeoobsX+1Ai5uAMw==
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, Conley Lee <conleylee@foxmail.com>
Subject: [PATCH v4] sun4i-emac.c: add dma support
Date:   Fri, 24 Dec 2021 22:44:31 +0800
X-OQ-MSGID: <20211224144431.22962-1-conleylee@foxmail.com>
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
 drivers/net/ethernet/allwinner/sun4i-emac.c | 209 +++++++++++++++++++-
 1 file changed, 200 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index cccf8a3ead5e..b17d2df17335 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/phy.h>
 #include <linux/soc/sunxi/sunxi_sram.h>
+#include <linux/dmaengine.h>
 
 #include "sun4i-emac.h"
 
@@ -86,6 +87,16 @@ struct emac_board_info {
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
@@ -205,6 +216,113 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
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
+		goto alloc_req_err;
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
+alloc_req_err:
+	dmaengine_desc_free(desc);
+
+prepare_err:
+	dma_unmap_single(db->dev, rxbuf, count, DMA_FROM_DEVICE);
+}
+
 /* ethtool ops */
 static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
@@ -599,20 +717,28 @@ static void emac_rx(struct net_device *dev)
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
@@ -659,7 +785,12 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
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
@@ -764,6 +895,58 @@ static const struct net_device_ops emac_netdev_ops = {
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
@@ -806,6 +989,9 @@ static int emac_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
+	if (emac_configure_dma(db))
+		netdev_info(ndev, "configure dma failed. disable dma.\n");
+
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
@@ -888,6 +1074,11 @@ static int emac_remove(struct platform_device *pdev)
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

