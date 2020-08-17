Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DCD245FDC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHQI02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgHQI0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:18 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809D8C061388;
        Mon, 17 Aug 2020 01:26:18 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so1164890plp.4;
        Mon, 17 Aug 2020 01:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NGc9GivMW4Gl2PZYS1sshtdVeD119m/l6GvQX46weos=;
        b=LBLxHBYXHHShApS1V6EqhqlERMx39IJoGg9XyyNS0xxKKPf7wzJlvUp7OZH7MsJNbk
         Hhy8KpiRMnmdXLU49x03cAV9Hb30GjB3mLnkNXIVN7t7SxDQ0pzRJNjp101YiuBGrc6h
         +OaSLNfkE2xI7g79vNgCQ+sgLmy75Y0bBKtNhkfSvXuudjABMDUQL5Enx7nI0chgO32d
         t5Vq04PRATxJxYQ15CIpAo/xswWJNmoEItx+gz7uWetOIqMKbHGTpI5tFRruhMbNCxzv
         d36pjAk2F3GLgsY9HZ1tEBwdbzTGHHfWhsaWugChVMUm6Bu0PrSMhwW9pPUh7m5In5hF
         8d0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NGc9GivMW4Gl2PZYS1sshtdVeD119m/l6GvQX46weos=;
        b=WbehfnymTJS+u/d4NtI1QlPz8bVfbZnnukB/8Dmkm7zzrQDKwUv0uSpi1YFNI6+sxs
         yZ72oSii+Ayeg7m7c0V4MpeGJfyTQirk8cpW/AUeQuzHSxY95hz9CROweSEgOcat4Pcf
         ByfCHyJK8Nyjhd6mRDLsJOFXNh414yJRztuZAtb6/DsiKFV1/YoeoBz8sg+nNyjZNH2i
         05hDaw7kmrQrryG26Tide2RvnV3vwev+aOK7Y76i+QouvBae/sNh4FYXkXjc471vL7dD
         55aGbE8n6mFr7vunfROoFAiul2hxEcqg6jzAm1ei6uh/bbl5gLQ0EW0xm1uJGUxXWniw
         TTtw==
X-Gm-Message-State: AOAM531tIP2JDNXu3V/jpXaJVFJ0H5/xd8YK4tt2KCoYPmN3N7d97v4T
        xcPcmcWDcIrKk8NEGgEKgG0=
X-Google-Smtp-Source: ABdhPJwRCnCkq0qh6UezjQA0oYu6vWfa6QDQxH8Q19OL3Crbp/QUQGdhIqlSJxXrujdjDsmyU1xEDw==
X-Received: by 2002:a17:90b:208:: with SMTP id fy8mr11168449pjb.131.1597652778097;
        Mon, 17 Aug 2020 01:26:18 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:17 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 14/20] ethernet: micrel: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:28 +0530
Message-Id: <20200817082434.21176-16-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
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
2.17.1

