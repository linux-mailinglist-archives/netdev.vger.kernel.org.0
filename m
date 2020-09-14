Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFD02685ED
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgINHba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgINHar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856ABC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:47 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so5018741pjb.4
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TWaq6bxLpQJZ/zgZGuC4pdM84E+FX91GixyZIz1H00g=;
        b=LtL6kIZYy+dCikd4hEqcaIhD+aLpxc1BIlg/P/FDcMZNVwpYZy0cy9Lg1WWedFZLs8
         9FSZoez1Sq7FCzqvcLkDW31sSkmtMNl1sDjERU9p1ZVF0sTQfqHOhjhCWNxtG6C+uMeC
         Jzlh9BfkdwSra99eTDWJiFBCL5PHQZQbC5hdissFvE27ZO4Un27F60tVAgBFvSUP2GP3
         J6Cc+DS3cQju3mKAmSfBjdUMW0nI2VuTwq8BhQAj8okF/F0q3cktzUn2kmv8xS/U5NVG
         WR82S4f52hknNC96evBJYYy24UzUo6jxXQYUKUDtehSQZQELV/pOu9iN3e0jYfdFGc9h
         hzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TWaq6bxLpQJZ/zgZGuC4pdM84E+FX91GixyZIz1H00g=;
        b=Gd2YAGXZmPPV5Camy7h0Brvtx6b10WIy6BdRNFUuq/8SRnZ7Wfk+aaC0wZlJ9TK6oi
         TJTRUVVf0g8bbydO8OGC1Q5hycI5Pe5wlaeX9JCfxPont6G+idlZ32Yk7QgQ0UtLB699
         YmC/+iaeTnZBD7o06JRE8gqXi/A/NY8c9c7tyZndbZWD+4tzQHzBoG4PcX3HB5WBHFYm
         ngy6dv1vuRb/tiPVkvbfi2oZfSV4vmILXAIbZMc0X88aoK2gd9klYPOKn45BrtmnMmAb
         r6qiDziG1PVvIe/KdmIYx38eCbL6SxtFLkiRSzEpaZEJkS9masLdhWXoKLn/+P5KoGKZ
         BzpQ==
X-Gm-Message-State: AOAM533LPTOK3tjmEm3S4rwkILUdfgnx+YtqPblX8Dmy2TI1tZlggeXj
        4R1P7Xzaub8HhqkAfaui3Jk=
X-Google-Smtp-Source: ABdhPJw5sPRJ0yM+90b1kMbcq6j7aeRs4V//zmMc/zoDUDnIVHZagq3V5cSVS495uL7XcouJrvNN6A==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr12604541pjx.90.1600068647166;
        Mon, 14 Sep 2020 00:30:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:46 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 14/20] net: micrel: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:33 +0530
Message-Id: <20200914072939.803280-15-allen.lkml@gmail.com>
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
 drivers/net/ethernet/micrel/ks8842.c  | 17 ++++++++---------
 drivers/net/ethernet/micrel/ksz884x.c | 14 ++++++--------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index f3f6dfe3eddc..caa251d0e381 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -587,10 +587,10 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 	return err;
 }
 
-static void ks8842_rx_frame_dma_tasklet(unsigned long arg)
+static void ks8842_rx_frame_dma_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *netdev = (struct net_device *)arg;
-	struct ks8842_adapter *adapter = netdev_priv(netdev);
+	struct ks8842_adapter *adapter = from_tasklet(adapter, t, dma_rx.tasklet);
+	struct net_device *netdev = adapter->netdev;
 	struct ks8842_rx_dma_ctl *ctl = &adapter->dma_rx;
 	struct sk_buff *skb = ctl->skb;
 	dma_addr_t addr = sg_dma_address(&ctl->sg);
@@ -720,10 +720,10 @@ static void ks8842_handle_rx_overrun(struct net_device *netdev,
 	netdev->stats.rx_fifo_errors++;
 }
 
-static void ks8842_tasklet(unsigned long arg)
+static void ks8842_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *netdev = (struct net_device *)arg;
-	struct ks8842_adapter *adapter = netdev_priv(netdev);
+	struct ks8842_adapter *adapter = from_tasklet(adapter, t, tasklet);
+	struct net_device *netdev = adapter->netdev;
 	u16 isr;
 	unsigned long flags;
 	u16 entry_bank;
@@ -953,8 +953,7 @@ static int ks8842_alloc_dma_bufs(struct net_device *netdev)
 		goto err;
 	}
 
-	tasklet_init(&rx_ctl->tasklet, ks8842_rx_frame_dma_tasklet,
-		(unsigned long)netdev);
+	tasklet_setup(&rx_ctl->tasklet, ks8842_rx_frame_dma_tasklet);
 
 	return 0;
 err:
@@ -1173,7 +1172,7 @@ static int ks8842_probe(struct platform_device *pdev)
 		adapter->dma_tx.channel = -1;
 	}
 
-	tasklet_init(&adapter->tasklet, ks8842_tasklet, (unsigned long)netdev);
+	tasklet_setup(&adapter->tasklet, ks8842_tasklet);
 	spin_lock_init(&adapter->lock);
 
 	netdev->netdev_ops = &ks8842_netdev_ops;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index bb646b65cc95..5130507bbf54 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5159,9 +5159,9 @@ static int dev_rcv_special(struct dev_info *hw_priv)
 	return received;
 }
 
-static void rx_proc_task(unsigned long data)
+static void rx_proc_task(struct tasklet_struct *t)
 {
-	struct dev_info *hw_priv = (struct dev_info *) data;
+	struct dev_info *hw_priv = from_tasklet(hw_priv, t, rx_tasklet);
 	struct ksz_hw *hw = &hw_priv->hw;
 
 	if (!hw->enabled)
@@ -5181,9 +5181,9 @@ static void rx_proc_task(unsigned long data)
 	}
 }
 
-static void tx_proc_task(unsigned long data)
+static void tx_proc_task(struct tasklet_struct *t)
 {
-	struct dev_info *hw_priv = (struct dev_info *) data;
+	struct dev_info *hw_priv = from_tasklet(hw_priv, t, tx_tasklet);
 	struct ksz_hw *hw = &hw_priv->hw;
 
 	hw_ack_intr(hw, KS884X_INT_TX_MASK);
@@ -5436,10 +5436,8 @@ static int prepare_hardware(struct net_device *dev)
 	rc = request_irq(dev->irq, netdev_intr, IRQF_SHARED, dev->name, dev);
 	if (rc)
 		return rc;
-	tasklet_init(&hw_priv->rx_tasklet, rx_proc_task,
-		     (unsigned long) hw_priv);
-	tasklet_init(&hw_priv->tx_tasklet, tx_proc_task,
-		     (unsigned long) hw_priv);
+	tasklet_setup(&hw_priv->rx_tasklet, rx_proc_task);
+	tasklet_setup(&hw_priv->tx_tasklet, tx_proc_task);
 
 	hw->promiscuous = 0;
 	hw->all_multi = 0;
-- 
2.25.1

