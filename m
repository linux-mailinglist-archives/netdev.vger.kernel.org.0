Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5012262AD3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgIIIqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbgIIIqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A8EC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so1539614pfn.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CcGH3OaKGIRV140OK3AVmjY82UA6At2MB1ivUZ6U1Vk=;
        b=tbMjEAwlSq5Ehc8uFj4k5xBZWtMdkl4zXBiw9GxPqRDK1osoaoT2aXhC8goKziroxr
         /S8P/qpGba65Jwg6EFeZ+evy+oWFoMMc+9uSKSo0+RIdOKO6JRrfiUbaaSxVy9Z/TWys
         feYCZ36korQh6tfcEakBdUV1IpSjcM+12Q/jqt7qBwc8TfWlCTPM5LJHDkFhuPjwa/fE
         z2/mAa8zG2/DkKbJhQZoH/0N5PB1ZLaxd1Z1l10g1HHwY+kXb10LboyVXG5MHspZ6z9E
         GFCyJZv7TYdAbuA5LtfMjsD9T62yQPMFPPqLQX4TCIgmkXgHB5FJ+Rlxi8kiydLa6drI
         4L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CcGH3OaKGIRV140OK3AVmjY82UA6At2MB1ivUZ6U1Vk=;
        b=faPkf6aPxGNlpiF3AtFRwsIGn0AQ+un3KyRR7yloeU+z4LgVE/o9wCMlTnxA7ii0yx
         2ph4E1+Nxox2ASWcyscUXBKu27dQZahbjZ0xMizxUhNOkLXt62PxAr8PnUQq93dQFtpe
         PxnE5YkMAP1DByN3lQwnZnu/ar6CE9a5qLTmVo079uyAlt/k3xO2VbFvYqzFvTdN7aJw
         bNRwQfmfObpWaqWKikcsVLaiHGYlhs5ztGZ1jIOExLtnRKZEGM0YEL/V3ZtmUaxRGUMm
         F+FOyYZ1Ya8JX3seWocq/TKmUStV4+xuXznm5z3Ay7dktAxawqC8HrJE8OgH/q60H5ZB
         KneQ==
X-Gm-Message-State: AOAM533OVYekYwLAVSuRWSzKK9BpSZTFh0q+WOime3hP/RBy8QXy2ETi
        vRJtxO1pMtzrI4nlEbBeX9s=
X-Google-Smtp-Source: ABdhPJzlLr6tw7ZMzn+va94clj7N9h60keyjZGcVK7ABhTy3T124GKtM6yAhnOu7N3vz4DivZXMqxQ==
X-Received: by 2002:a62:8349:: with SMTP id h70mr2806346pfe.47.1599641172937;
        Wed, 09 Sep 2020 01:46:12 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:12 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 14/20] ethernet: micrel: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:04 +0530
Message-Id: <20200909084510.648706-15-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/micrel/ks8842.c  | 19 ++++++++++---------
 drivers/net/ethernet/micrel/ksz884x.c | 14 ++++++--------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index f3f6dfe3eddc..8fd32f98c494 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -587,10 +587,11 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 	return err;
 }
 
-static void ks8842_rx_frame_dma_tasklet(unsigned long arg)
+static void ks8842_rx_frame_dma_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *netdev = (struct net_device *)arg;
-	struct ks8842_adapter *adapter = netdev_priv(netdev);
+	struct ks8842_adapter *adapter = from_tasklet(adapter, t, dma_rx.tasklet);
+	struct net_device *netdev = (struct net_device *)((char *)adapter -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	struct ks8842_rx_dma_ctl *ctl = &adapter->dma_rx;
 	struct sk_buff *skb = ctl->skb;
 	dma_addr_t addr = sg_dma_address(&ctl->sg);
@@ -720,10 +721,11 @@ static void ks8842_handle_rx_overrun(struct net_device *netdev,
 	netdev->stats.rx_fifo_errors++;
 }
 
-static void ks8842_tasklet(unsigned long arg)
+static void ks8842_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *netdev = (struct net_device *)arg;
-	struct ks8842_adapter *adapter = netdev_priv(netdev);
+	struct ks8842_adapter *adapter = from_tasklet(adapter, t, tasklet);
+	struct net_device *netdev = (struct net_device *)((char *)adapter -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	u16 isr;
 	unsigned long flags;
 	u16 entry_bank;
@@ -953,8 +955,7 @@ static int ks8842_alloc_dma_bufs(struct net_device *netdev)
 		goto err;
 	}
 
-	tasklet_init(&rx_ctl->tasklet, ks8842_rx_frame_dma_tasklet,
-		(unsigned long)netdev);
+	tasklet_setup(&rx_ctl->tasklet, ks8842_rx_frame_dma_tasklet);
 
 	return 0;
 err:
@@ -1173,7 +1174,7 @@ static int ks8842_probe(struct platform_device *pdev)
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

