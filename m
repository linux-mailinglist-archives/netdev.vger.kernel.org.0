Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A3C2685E4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgINHaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgINHaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:21 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35119C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:20 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k15so11850961pfc.12
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nf/wpYGcxGPNIFeOUg0i/7TcwomZlS6NuptwBPDpiRg=;
        b=GmQT+JNwQRr/Q3YUg8SFrP5whotmXNm3OL6LsyasE92mu3eeLoL5kpYxJLEtSGF4QY
         EKRWjiWmrcz+y4U09jIjkIjYadfTkaPYfQFTSxAd4s/4qt4h0WC/PzHiPCfLcRGn0tZw
         7LfnagBJUtZKpEOUPTdFiEyLGM3wm31BLq7cqdj/ALAJQa2fKNmgFOpuVVkrhxtur5FN
         zNFUyzBZehZBTYCiYRkd+JnZh7YiuB4v4Q2psUx7urLGaa5V8GHmHBhb5gsKdtspEkEw
         x/5iLZwe/anHk2J2tAUNKslVR5aU/RB0HECC/bItTkADoz6nNaEBr2F4t/0RCZjSkTBc
         RmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nf/wpYGcxGPNIFeOUg0i/7TcwomZlS6NuptwBPDpiRg=;
        b=RzUvaeAjC6wV4ufhUSy4/xM5T8kOCGpNsJZ91jjSg0QwsmvD5Qf8F//6A8js15CB9Z
         NVZa9O4DhXpP9yviEe2lzm5r8RoO97kPDrMckQEdypJaVmaD6YtPn+nMcQvq2YfVonXL
         BeJwYWQ3CZxVy/EhjFg4LSTdWB5+eoNeHRfSKGU7FxWnwv6B9EzvWFtACiChpEA+D17Y
         Y6QDmk1rgWDaglo5KkuSxg9eixh40urhOV6dPrppzVn54UcC+TxhtvsFg+N/LhglUDlP
         EW+Pp/bhoEIsGigyjJcOuBt/lKV0Qo4ssSk6cAPSutwNsAoXXY7ak8lKdzfWYwN7JzDh
         9zbQ==
X-Gm-Message-State: AOAM5339WuhmUQcl5FZQSQ1cK/lY0Dn/yNX+cIg5IFlVFDg/ga97F9/O
        JJmrBDGwpOiwh7HNHCtXZnK/WkRdpwmPJA==
X-Google-Smtp-Source: ABdhPJxo/UnavmNhNyX3PSmIBVTAtIYxRxM/StSiAiuf/uxY/QGHcfRg/uHcZsH5dUW90ttBtw+Jhg==
X-Received: by 2002:a63:5e01:: with SMTP id s1mr5492704pgb.421.1600068619794;
        Mon, 14 Sep 2020 00:30:19 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:19 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 07/20] net: sundance: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:26 +0530
Message-Id: <20200914072939.803280-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/dlink/sundance.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index b3f8597e77aa..e3a8858915b3 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -367,6 +367,7 @@ struct netdev_private {
         dma_addr_t tx_ring_dma;
         dma_addr_t rx_ring_dma;
 	struct timer_list timer;		/* Media monitoring timer. */
+	struct net_device *ndev;		/* backpointer */
 	/* ethtool extra stats */
 	struct {
 		u64 tx_multiple_collisions;
@@ -429,8 +430,8 @@ static void init_ring(struct net_device *dev);
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev);
 static int reset_tx (struct net_device *dev);
 static irqreturn_t intr_handler(int irq, void *dev_instance);
-static void rx_poll(unsigned long data);
-static void tx_poll(unsigned long data);
+static void rx_poll(struct tasklet_struct *t);
+static void tx_poll(struct tasklet_struct *t);
 static void refill_rx (struct net_device *dev);
 static void netdev_error(struct net_device *dev, int intr_status);
 static void netdev_error(struct net_device *dev, int intr_status);
@@ -531,14 +532,15 @@ static int sundance_probe1(struct pci_dev *pdev,
 			cpu_to_le16(eeprom_read(ioaddr, i + EEPROM_SA_OFFSET));
 
 	np = netdev_priv(dev);
+	np->ndev = dev;
 	np->base = ioaddr;
 	np->pci_dev = pdev;
 	np->chip_id = chip_idx;
 	np->msg_enable = (1 << debug) - 1;
 	spin_lock_init(&np->lock);
 	spin_lock_init(&np->statlock);
-	tasklet_init(&np->rx_tasklet, rx_poll, (unsigned long)dev);
-	tasklet_init(&np->tx_tasklet, tx_poll, (unsigned long)dev);
+	tasklet_setup(&np->rx_tasklet, rx_poll);
+	tasklet_setup(&np->tx_tasklet, tx_poll);
 
 	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE,
 			&ring_dma, GFP_KERNEL);
@@ -1054,10 +1056,9 @@ static void init_ring(struct net_device *dev)
 	}
 }
 
-static void tx_poll (unsigned long data)
+static void tx_poll(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct netdev_private *np = netdev_priv(dev);
+	struct netdev_private *np = from_tasklet(np, t, tx_tasklet);
 	unsigned head = np->cur_task % TX_RING_SIZE;
 	struct netdev_desc *txdesc =
 		&np->tx_ring[(np->cur_tx - 1) % TX_RING_SIZE];
@@ -1312,10 +1313,10 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static void rx_poll(unsigned long data)
+static void rx_poll(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct netdev_private *np = netdev_priv(dev);
+	struct netdev_private *np = from_tasklet(np, t, rx_tasklet);
+	struct net_device *dev = np->ndev;
 	int entry = np->cur_rx % RX_RING_SIZE;
 	int boguscnt = np->budget;
 	void __iomem *ioaddr = np->base;
-- 
2.25.1

