Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01436268F42
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgINPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgINPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:11:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6A3C06174A;
        Mon, 14 Sep 2020 08:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=j7XWRhy0vs73QAhmmo9ECqdtpkOgQXX6eorVEFIt+r0=; b=UjWRSa5CxPO1yuFKD/3Teydxxe
        4wL42Ha5vn8MXezA970FGn+tzbWJKKOInI4j4wRmq4DhoRhPDc0WVfk461mXEo5wMbi9Xfln0sEUm
        rWu0vIG32RefMPyhE3sjBvZJmaeH7t5XnLhHM0Cgy8tt0xhaZxh8JnlrR26na9LvOa+WvAOfFkl32
        3V2g4iZt8FCWuo9RujeHORWQ/X/m9Es3XQKKNBl/V4bWuD3d+nLBJjS71DJuSs8nqvxsBuElGHdEc
        he/9/yVT8FeXqHsu/8/aiSn90uA63stXCm2O8J7BEsblv2mnTZ0wWlFSGPMBAHNDfYPHbEtlPQECz
        U4uXSMsw==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHq83-0003Lc-VC; Mon, 14 Sep 2020 15:10:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 11/17] sgiseeq: convert to dma_alloc_noncoherent
Date:   Mon, 14 Sep 2020 16:44:27 +0200
Message-Id: <20200914144433.1622958-12-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914144433.1622958-1-hch@lst.de>
References: <20200914144433.1622958-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new non-coherent DMA API including proper ownership transfers.
This includes adding additional calls to dma_sync_desc_dev as the
old syncing was rather ad-hoc.

Thanks to Thomas Bogendoerfer for debugging the ownership transfer
issues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/i825xx/lasi_82596.c |  25 ++---
 drivers/net/ethernet/i825xx/lib82596.c   | 114 ++++++++++++++---------
 drivers/net/ethernet/i825xx/sni_82596.c  |   4 -
 drivers/net/ethernet/seeq/sgiseeq.c      |  28 ++++--
 drivers/scsi/53c700.c                    |   9 +-
 5 files changed, 103 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index a12218e940a2fa..96c6f4f36904ed 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -96,21 +96,14 @@
 
 #define OPT_SWAP_PORT	0x0001	/* Need to wordswp on the MPU port */
 
-#define DMA_WBACK(ndev, addr, len) \
-	do { dma_cache_sync((ndev)->dev.parent, (void *)addr, len, DMA_TO_DEVICE); } while (0)
-
-#define DMA_INV(ndev, addr, len) \
-	do { dma_cache_sync((ndev)->dev.parent, (void *)addr, len, DMA_FROM_DEVICE); } while (0)
-
-#define DMA_WBACK_INV(ndev, addr, len) \
-	do { dma_cache_sync((ndev)->dev.parent, (void *)addr, len, DMA_BIDIRECTIONAL); } while (0)
-
 #define SYSBUS      0x0000006c
 
 /* big endian CPU, 82596 "big" endian mode */
 #define SWAP32(x)   (((u32)(x)<<16) | ((((u32)(x)))>>16))
 #define SWAP16(x)   (x)
 
+#define NONCOHERENT_DMA 1
+
 #include "lib82596.c"
 
 MODULE_AUTHOR("Richard Hirst");
@@ -184,9 +177,9 @@ lan_init_chip(struct parisc_device *dev)
 
 	lp = netdev_priv(netdevice);
 	lp->options = dev->id.sversion == 0x72 ? OPT_SWAP_PORT : 0;
-	lp->dma = dma_alloc_attrs(&dev->dev, sizeof(struct i596_dma),
-			      &lp->dma_addr, GFP_KERNEL,
-			      DMA_ATTR_NON_CONSISTENT);
+	lp->dma = dma_alloc_noncoherent(&dev->dev,
+			sizeof(struct i596_dma), &lp->dma_addr,
+			DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!lp->dma)
 		goto out_free_netdev;
 
@@ -196,8 +189,8 @@ lan_init_chip(struct parisc_device *dev)
 	return 0;
 
 out_free_dma:
-	dma_free_attrs(&dev->dev, sizeof(struct i596_dma), lp->dma,
-			lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&dev->dev, sizeof(struct i596_dma),
+		       lp->dma, lp->dma_addr, DMA_BIDIRECTIONAL);
 out_free_netdev:
 	free_netdev(netdevice);
 	return retval;
@@ -209,8 +202,8 @@ static int __exit lan_remove_chip(struct parisc_device *pdev)
 	struct i596_private *lp = netdev_priv(dev);
 
 	unregister_netdev (dev);
-	dma_free_attrs(&pdev->dev, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, sizeof(struct i596_private), lp->dma,
+		       lp->dma_addr, DMA_BIDIRECTIONAL);
 	free_netdev (dev);
 	return 0;
 }
diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
index b4e4b3eb5758b5..ca2fb303fcc6f6 100644
--- a/drivers/net/ethernet/i825xx/lib82596.c
+++ b/drivers/net/ethernet/i825xx/lib82596.c
@@ -365,13 +365,44 @@ static int max_cmd_backlog = TX_RING_SIZE-1;
 static void i596_poll_controller(struct net_device *dev);
 #endif
 
+static inline dma_addr_t virt_to_dma(struct i596_private *lp, volatile void *v)
+{
+	return lp->dma_addr + ((unsigned long)v - (unsigned long)lp->dma);
+}
+
+#ifdef NONCOHERENT_DMA
+static inline void dma_sync_dev(struct net_device *ndev, volatile void *addr,
+		size_t len)
+{
+	dma_sync_single_for_device(ndev->dev.parent,
+			virt_to_dma(netdev_priv(ndev), addr), len,
+			DMA_BIDIRECTIONAL);
+}
+
+static inline void dma_sync_cpu(struct net_device *ndev, volatile void *addr,
+		size_t len)
+{
+	dma_sync_single_for_cpu(ndev->dev.parent,
+			virt_to_dma(netdev_priv(ndev), addr), len,
+			DMA_BIDIRECTIONAL);
+}
+#else
+static inline void dma_sync_dev(struct net_device *ndev, volatile void *addr,
+		size_t len)
+{
+}
+static inline void dma_sync_cpu(struct net_device *ndev, volatile void *addr,
+		size_t len)
+{
+}
+#endif /* NONCOHERENT_DMA */
 
 static inline int wait_istat(struct net_device *dev, struct i596_dma *dma, int delcnt, char *str)
 {
-	DMA_INV(dev, &(dma->iscp), sizeof(struct i596_iscp));
+	dma_sync_cpu(dev, &(dma->iscp), sizeof(struct i596_iscp));
 	while (--delcnt && dma->iscp.stat) {
 		udelay(10);
-		DMA_INV(dev, &(dma->iscp), sizeof(struct i596_iscp));
+		dma_sync_cpu(dev, &(dma->iscp), sizeof(struct i596_iscp));
 	}
 	if (!delcnt) {
 		printk(KERN_ERR "%s: %s, iscp.stat %04x, didn't clear\n",
@@ -384,10 +415,10 @@ static inline int wait_istat(struct net_device *dev, struct i596_dma *dma, int d
 
 static inline int wait_cmd(struct net_device *dev, struct i596_dma *dma, int delcnt, char *str)
 {
-	DMA_INV(dev, &(dma->scb), sizeof(struct i596_scb));
+	dma_sync_cpu(dev, &(dma->scb), sizeof(struct i596_scb));
 	while (--delcnt && dma->scb.command) {
 		udelay(10);
-		DMA_INV(dev, &(dma->scb), sizeof(struct i596_scb));
+		dma_sync_cpu(dev, &(dma->scb), sizeof(struct i596_scb));
 	}
 	if (!delcnt) {
 		printk(KERN_ERR "%s: %s, status %4.4x, cmd %4.4x.\n",
@@ -451,12 +482,9 @@ static void i596_display_data(struct net_device *dev)
 		       SWAP32(rbd->b_data), SWAP16(rbd->size));
 		rbd = rbd->v_next;
 	} while (rbd != lp->rbd_head);
-	DMA_INV(dev, dma, sizeof(struct i596_dma));
+	dma_sync_cpu(dev, dma, sizeof(struct i596_dma));
 }
 
-
-#define virt_to_dma(lp, v) ((lp)->dma_addr + (dma_addr_t)((unsigned long)(v)-(unsigned long)((lp)->dma)))
-
 static inline int init_rx_bufs(struct net_device *dev)
 {
 	struct i596_private *lp = netdev_priv(dev);
@@ -508,7 +536,7 @@ static inline int init_rx_bufs(struct net_device *dev)
 	rfd->b_next = SWAP32(virt_to_dma(lp, dma->rfds));
 	rfd->cmd = SWAP16(CMD_EOL|CMD_FLEX);
 
-	DMA_WBACK_INV(dev, dma, sizeof(struct i596_dma));
+	dma_sync_dev(dev, dma, sizeof(struct i596_dma));
 	return 0;
 }
 
@@ -547,7 +575,7 @@ static void rebuild_rx_bufs(struct net_device *dev)
 	lp->rbd_head = dma->rbds;
 	dma->rfds[0].rbd = SWAP32(virt_to_dma(lp, dma->rbds));
 
-	DMA_WBACK_INV(dev, dma, sizeof(struct i596_dma));
+	dma_sync_dev(dev, dma, sizeof(struct i596_dma));
 }
 
 
@@ -575,9 +603,9 @@ static int init_i596_mem(struct net_device *dev)
 
 	DEB(DEB_INIT, printk(KERN_DEBUG "%s: starting i82596.\n", dev->name));
 
-	DMA_WBACK(dev, &(dma->scp), sizeof(struct i596_scp));
-	DMA_WBACK(dev, &(dma->iscp), sizeof(struct i596_iscp));
-	DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
+	dma_sync_dev(dev, &(dma->scp), sizeof(struct i596_scp));
+	dma_sync_dev(dev, &(dma->iscp), sizeof(struct i596_iscp));
+	dma_sync_dev(dev, &(dma->scb), sizeof(struct i596_scb));
 
 	mpu_port(dev, PORT_ALTSCP, virt_to_dma(lp, &dma->scp));
 	ca(dev);
@@ -596,24 +624,24 @@ static int init_i596_mem(struct net_device *dev)
 	rebuild_rx_bufs(dev);
 
 	dma->scb.command = 0;
-	DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
+	dma_sync_dev(dev, &(dma->scb), sizeof(struct i596_scb));
 
 	DEB(DEB_INIT, printk(KERN_DEBUG
 			     "%s: queuing CmdConfigure\n", dev->name));
 	memcpy(dma->cf_cmd.i596_config, init_setup, 14);
 	dma->cf_cmd.cmd.command = SWAP16(CmdConfigure);
-	DMA_WBACK(dev, &(dma->cf_cmd), sizeof(struct cf_cmd));
+	dma_sync_dev(dev, &(dma->cf_cmd), sizeof(struct cf_cmd));
 	i596_add_cmd(dev, &dma->cf_cmd.cmd);
 
 	DEB(DEB_INIT, printk(KERN_DEBUG "%s: queuing CmdSASetup\n", dev->name));
 	memcpy(dma->sa_cmd.eth_addr, dev->dev_addr, ETH_ALEN);
 	dma->sa_cmd.cmd.command = SWAP16(CmdSASetup);
-	DMA_WBACK(dev, &(dma->sa_cmd), sizeof(struct sa_cmd));
+	dma_sync_dev(dev, &(dma->sa_cmd), sizeof(struct sa_cmd));
 	i596_add_cmd(dev, &dma->sa_cmd.cmd);
 
 	DEB(DEB_INIT, printk(KERN_DEBUG "%s: queuing CmdTDR\n", dev->name));
 	dma->tdr_cmd.cmd.command = SWAP16(CmdTDR);
-	DMA_WBACK(dev, &(dma->tdr_cmd), sizeof(struct tdr_cmd));
+	dma_sync_dev(dev, &(dma->tdr_cmd), sizeof(struct tdr_cmd));
 	i596_add_cmd(dev, &dma->tdr_cmd.cmd);
 
 	spin_lock_irqsave (&lp->lock, flags);
@@ -625,7 +653,7 @@ static int init_i596_mem(struct net_device *dev)
 	DEB(DEB_INIT, printk(KERN_DEBUG "%s: Issuing RX_START\n", dev->name));
 	dma->scb.command = SWAP16(RX_START);
 	dma->scb.rfd = SWAP32(virt_to_dma(lp, dma->rfds));
-	DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
+	dma_sync_dev(dev, &(dma->scb), sizeof(struct i596_scb));
 
 	ca(dev);
 
@@ -659,13 +687,13 @@ static inline int i596_rx(struct net_device *dev)
 
 	rfd = lp->rfd_head;		/* Ref next frame to check */
 
-	DMA_INV(dev, rfd, sizeof(struct i596_rfd));
+	dma_sync_cpu(dev, rfd, sizeof(struct i596_rfd));
 	while (rfd->stat & SWAP16(STAT_C)) {	/* Loop while complete frames */
 		if (rfd->rbd == I596_NULL)
 			rbd = NULL;
 		else if (rfd->rbd == lp->rbd_head->b_addr) {
 			rbd = lp->rbd_head;
-			DMA_INV(dev, rbd, sizeof(struct i596_rbd));
+			dma_sync_cpu(dev, rbd, sizeof(struct i596_rbd));
 		} else {
 			printk(KERN_ERR "%s: rbd chain broken!\n", dev->name);
 			/* XXX Now what? */
@@ -713,7 +741,7 @@ static inline int i596_rx(struct net_device *dev)
 							  DMA_FROM_DEVICE);
 				rbd->v_data = newskb->data;
 				rbd->b_data = SWAP32(dma_addr);
-				DMA_WBACK_INV(dev, rbd, sizeof(struct i596_rbd));
+				dma_sync_dev(dev, rbd, sizeof(struct i596_rbd));
 			} else {
 				skb = netdev_alloc_skb_ip_align(dev, pkt_len);
 			}
@@ -765,7 +793,7 @@ static inline int i596_rx(struct net_device *dev)
 		if (rbd != NULL && (rbd->count & SWAP16(0x4000))) {
 			rbd->count = 0;
 			lp->rbd_head = rbd->v_next;
-			DMA_WBACK_INV(dev, rbd, sizeof(struct i596_rbd));
+			dma_sync_dev(dev, rbd, sizeof(struct i596_rbd));
 		}
 
 		/* Tidy the frame descriptor, marking it as end of list */
@@ -779,14 +807,14 @@ static inline int i596_rx(struct net_device *dev)
 
 		lp->dma->scb.rfd = rfd->b_next;
 		lp->rfd_head = rfd->v_next;
-		DMA_WBACK_INV(dev, rfd, sizeof(struct i596_rfd));
+		dma_sync_dev(dev, rfd, sizeof(struct i596_rfd));
 
 		/* Remove end-of-list from old end descriptor */
 
 		rfd->v_prev->cmd = SWAP16(CMD_FLEX);
-		DMA_WBACK_INV(dev, rfd->v_prev, sizeof(struct i596_rfd));
+		dma_sync_dev(dev, rfd->v_prev, sizeof(struct i596_rfd));
 		rfd = lp->rfd_head;
-		DMA_INV(dev, rfd, sizeof(struct i596_rfd));
+		dma_sync_cpu(dev, rfd, sizeof(struct i596_rfd));
 	}
 
 	DEB(DEB_RXFRAME, printk(KERN_DEBUG "frames %d\n", frames));
@@ -827,12 +855,12 @@ static inline void i596_cleanup_cmd(struct net_device *dev, struct i596_private
 			ptr->v_next = NULL;
 			ptr->b_next = I596_NULL;
 		}
-		DMA_WBACK_INV(dev, ptr, sizeof(struct i596_cmd));
+		dma_sync_dev(dev, ptr, sizeof(struct i596_cmd));
 	}
 
 	wait_cmd(dev, lp->dma, 100, "i596_cleanup_cmd timed out");
 	lp->dma->scb.cmd = I596_NULL;
-	DMA_WBACK(dev, &(lp->dma->scb), sizeof(struct i596_scb));
+	dma_sync_dev(dev, &(lp->dma->scb), sizeof(struct i596_scb));
 }
 
 
@@ -850,7 +878,7 @@ static inline void i596_reset(struct net_device *dev, struct i596_private *lp)
 
 	/* FIXME: this command might cause an lpmc */
 	lp->dma->scb.command = SWAP16(CUC_ABORT | RX_ABORT);
-	DMA_WBACK(dev, &(lp->dma->scb), sizeof(struct i596_scb));
+	dma_sync_dev(dev, &(lp->dma->scb), sizeof(struct i596_scb));
 	ca(dev);
 
 	/* wait for shutdown */
@@ -878,20 +906,20 @@ static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd)
 	cmd->command |= SWAP16(CMD_EOL | CMD_INTR);
 	cmd->v_next = NULL;
 	cmd->b_next = I596_NULL;
-	DMA_WBACK(dev, cmd, sizeof(struct i596_cmd));
+	dma_sync_dev(dev, cmd, sizeof(struct i596_cmd));
 
 	spin_lock_irqsave (&lp->lock, flags);
 
 	if (lp->cmd_head != NULL) {
 		lp->cmd_tail->v_next = cmd;
 		lp->cmd_tail->b_next = SWAP32(virt_to_dma(lp, &cmd->status));
-		DMA_WBACK(dev, lp->cmd_tail, sizeof(struct i596_cmd));
+		dma_sync_dev(dev, lp->cmd_tail, sizeof(struct i596_cmd));
 	} else {
 		lp->cmd_head = cmd;
 		wait_cmd(dev, dma, 100, "i596_add_cmd timed out");
 		dma->scb.cmd = SWAP32(virt_to_dma(lp, &cmd->status));
 		dma->scb.command = SWAP16(CUC_START);
-		DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
+		dma_sync_dev(dev, &(dma->scb), sizeof(struct i596_scb));
 		ca(dev);
 	}
 	lp->cmd_tail = cmd;
@@ -956,7 +984,7 @@ static void i596_tx_timeout (struct net_device *dev, unsigned int txqueue)
 		/* Issue a channel attention signal */
 		DEB(DEB_ERRORS, printk(KERN_DEBUG "Kicking board.\n"));
 		lp->dma->scb.command = SWAP16(CUC_START | RX_START);
-		DMA_WBACK_INV(dev, &(lp->dma->scb), sizeof(struct i596_scb));
+		dma_sync_dev(dev, &(lp->dma->scb), sizeof(struct i596_scb));
 		ca (dev);
 		lp->last_restart = dev->stats.tx_packets;
 	}
@@ -1014,8 +1042,8 @@ static netdev_tx_t i596_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		tbd->data = SWAP32(tx_cmd->dma_addr);
 
 		DEB(DEB_TXADDR, print_eth(skb->data, "tx-queued"));
-		DMA_WBACK_INV(dev, tx_cmd, sizeof(struct tx_cmd));
-		DMA_WBACK_INV(dev, tbd, sizeof(struct i596_tbd));
+		dma_sync_dev(dev, tx_cmd, sizeof(struct tx_cmd));
+		dma_sync_dev(dev, tbd, sizeof(struct i596_tbd));
 		i596_add_cmd(dev, &tx_cmd->cmd);
 
 		dev->stats.tx_packets++;
@@ -1071,7 +1099,7 @@ static int i82596_probe(struct net_device *dev)
 	lp->dma->scb.rfd = I596_NULL;
 	spin_lock_init(&lp->lock);
 
-	DMA_WBACK_INV(dev, lp->dma, sizeof(struct i596_dma));
+	dma_sync_dev(dev, lp->dma, sizeof(struct i596_dma));
 
 	ret = register_netdev(dev);
 	if (ret)
@@ -1141,7 +1169,7 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 				   dev->name, status & 0x0700));
 
 		while (lp->cmd_head != NULL) {
-			DMA_INV(dev, lp->cmd_head, sizeof(struct i596_cmd));
+			dma_sync_cpu(dev, lp->cmd_head, sizeof(struct i596_cmd));
 			if (!(lp->cmd_head->status & SWAP16(STAT_C)))
 				break;
 
@@ -1223,7 +1251,7 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 			}
 			ptr->v_next = NULL;
 			ptr->b_next = I596_NULL;
-			DMA_WBACK(dev, ptr, sizeof(struct i596_cmd));
+			dma_sync_dev(dev, ptr, sizeof(struct i596_cmd));
 			lp->last_cmd = jiffies;
 		}
 
@@ -1237,13 +1265,13 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 
 			ptr->command &= SWAP16(0x1fff);
 			ptr = ptr->v_next;
-			DMA_WBACK_INV(dev, prev, sizeof(struct i596_cmd));
+			dma_sync_dev(dev, prev, sizeof(struct i596_cmd));
 		}
 
 		if (lp->cmd_head != NULL)
 			ack_cmd |= CUC_START;
 		dma->scb.cmd = SWAP32(virt_to_dma(lp, &lp->cmd_head->status));
-		DMA_WBACK_INV(dev, &dma->scb, sizeof(struct i596_scb));
+		dma_sync_dev(dev, &dma->scb, sizeof(struct i596_scb));
 	}
 	if ((status & 0x1000) || (status & 0x4000)) {
 		if ((status & 0x4000))
@@ -1268,7 +1296,7 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 	}
 	wait_cmd(dev, dma, 100, "i596 interrupt, timeout");
 	dma->scb.command = SWAP16(ack_cmd);
-	DMA_WBACK(dev, &dma->scb, sizeof(struct i596_scb));
+	dma_sync_dev(dev, &dma->scb, sizeof(struct i596_scb));
 
 	/* DANGER: I suspect that some kind of interrupt
 	 acknowledgement aside from acking the 82596 might be needed
@@ -1299,7 +1327,7 @@ static int i596_close(struct net_device *dev)
 
 	wait_cmd(dev, lp->dma, 100, "close1 timed out");
 	lp->dma->scb.command = SWAP16(CUC_ABORT | RX_ABORT);
-	DMA_WBACK(dev, &lp->dma->scb, sizeof(struct i596_scb));
+	dma_sync_dev(dev, &lp->dma->scb, sizeof(struct i596_scb));
 
 	ca(dev);
 
@@ -1358,7 +1386,7 @@ static void set_multicast_list(struct net_device *dev)
 			       dev->name);
 		else {
 			dma->cf_cmd.cmd.command = SWAP16(CmdConfigure);
-			DMA_WBACK_INV(dev, &dma->cf_cmd, sizeof(struct cf_cmd));
+			dma_sync_dev(dev, &dma->cf_cmd, sizeof(struct cf_cmd));
 			i596_add_cmd(dev, &dma->cf_cmd.cmd);
 		}
 	}
@@ -1390,7 +1418,7 @@ static void set_multicast_list(struct net_device *dev)
 					   dev->name, cp));
 			cp += ETH_ALEN;
 		}
-		DMA_WBACK_INV(dev, &dma->mc_cmd, sizeof(struct mc_cmd));
+		dma_sync_dev(dev, &dma->mc_cmd, sizeof(struct mc_cmd));
 		i596_add_cmd(dev, &cmd->cmd);
 	}
 }
diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index 4b9ac0c6557731..27937c5d795673 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -24,10 +24,6 @@
 
 static const char sni_82596_string[] = "snirm_82596";
 
-#define DMA_WBACK(priv, addr, len)     do { } while (0)
-#define DMA_INV(priv, addr, len)       do { } while (0)
-#define DMA_WBACK_INV(priv, addr, len) do { } while (0)
-
 #define SYSBUS      0x00004400
 
 /* big endian CPU, 82596 little endian */
diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 8507ff2420143a..37ff25a84030eb 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -112,14 +112,18 @@ struct sgiseeq_private {
 
 static inline void dma_sync_desc_cpu(struct net_device *dev, void *addr)
 {
-	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
-		       DMA_FROM_DEVICE);
+	struct sgiseeq_private *sp = netdev_priv(dev);
+
+	dma_sync_single_for_cpu(dev->dev.parent, VIRT_TO_DMA(sp, addr),
+			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
 }
 
 static inline void dma_sync_desc_dev(struct net_device *dev, void *addr)
 {
-	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
-		       DMA_TO_DEVICE);
+	struct sgiseeq_private *sp = netdev_priv(dev);
+
+	dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
+			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
 }
 
 static inline void hpc3_eth_reset(struct hpc3_ethregs *hregs)
@@ -403,6 +407,8 @@ static inline void sgiseeq_rx(struct net_device *dev, struct sgiseeq_private *sp
 		rd = &sp->rx_desc[sp->rx_new];
 		dma_sync_desc_cpu(dev, rd);
 	}
+	dma_sync_desc_dev(dev, rd);
+
 	dma_sync_desc_cpu(dev, &sp->rx_desc[orig_end]);
 	sp->rx_desc[orig_end].rdma.cntinfo &= ~(HPCDMA_EOR);
 	dma_sync_desc_dev(dev, &sp->rx_desc[orig_end]);
@@ -443,6 +449,7 @@ static inline void kick_tx(struct net_device *dev,
 		dma_sync_desc_cpu(dev, td);
 	}
 	if (td->tdma.cntinfo & HPCDMA_XIU) {
+		dma_sync_desc_dev(dev, td);
 		hregs->tx_ndptr = VIRT_TO_DMA(sp, td);
 		hregs->tx_ctrl = HPC3_ETXCTRL_ACTIVE;
 	}
@@ -476,6 +483,7 @@ static inline void sgiseeq_tx(struct net_device *dev, struct sgiseeq_private *sp
 		if (!(td->tdma.cntinfo & (HPCDMA_XIU)))
 			break;
 		if (!(td->tdma.cntinfo & (HPCDMA_ETXD))) {
+			dma_sync_desc_dev(dev, td);
 			if (!(status & HPC3_ETXCTRL_ACTIVE)) {
 				hregs->tx_ndptr = VIRT_TO_DMA(sp, td);
 				hregs->tx_ctrl = HPC3_ETXCTRL_ACTIVE;
@@ -740,8 +748,8 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */
-	sr = dma_alloc_attrs(&pdev->dev, sizeof(*sp->srings), &sp->srings_dma,
-			     GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	sr = dma_alloc_noncoherent(&pdev->dev, sizeof(*sp->srings),
+			&sp->srings_dma, DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!sr) {
 		printk(KERN_ERR "Sgiseeq: Page alloc failed, aborting.\n");
 		err = -ENOMEM;
@@ -802,8 +810,8 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_free_attrs:
-	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
-		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_BIDIRECTIONAL);
 err_out_free_dev:
 	free_netdev(dev);
 
@@ -817,8 +825,8 @@ static int sgiseeq_remove(struct platform_device *pdev)
 	struct sgiseeq_private *sp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
-		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_BIDIRECTIONAL);
 	free_netdev(dev);
 
 	return 0;
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index c59226d7e2f6b5..9a343f8ecb6c3e 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -300,8 +300,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	memory = dma_alloc_coherent(dev, TOTAL_MEM_SIZE, &pScript, GFP_KERNEL);
 	if (!memory) {
 		hostdata->noncoherent = 1;
-		memory = dma_alloc_attrs(dev, TOTAL_MEM_SIZE, &pScript,
-					 GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+		memory = dma_alloc_noncoherent(dev, TOTAL_MEM_SIZE, &pScript,
+					 DMA_BIDIRECTIONAL, GFP_KERNEL);
 	}
 	if (!memory) {
 		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
@@ -414,8 +414,9 @@ NCR_700_release(struct Scsi_Host *host)
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 	if (hostdata->noncoherent)
-		dma_free_attrs(hostdata->dev, TOTAL_MEM_SIZE, hostdata->script,
-			       hostdata->pScript, DMA_ATTR_NON_CONSISTENT);
+		dma_free_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
+				hostdata->script, hostdata->pScript,
+				DMA_BIDIRECTIONAL);
 	else
 		dma_free_coherent(hostdata->dev, TOTAL_MEM_SIZE,
 				  hostdata->script, hostdata->pScript);
-- 
2.28.0

