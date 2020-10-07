Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1100B285CEB
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgJGKdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgJGKdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:33:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816D4C061755;
        Wed,  7 Oct 2020 03:33:23 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x5so784904plo.6;
        Wed, 07 Oct 2020 03:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GiAFzJgpITFLl8DNyaqxwaKWLXI8iKCzBup4CTb/x7E=;
        b=qLcB06mGpKCpFn89yyQeR/W88C3WoIeD7oHjbV50SUtHd/nVfeQRkqw+xcZNQ4KCOk
         Yl8diuJ7iFn7acc1f/6DJ44WQ1aaLtILMUq37iBXTg2E0cOHt/i2SeV2tagKol/VfZix
         PBm9w1W6UWWNLqiI1cLZXon+MAfwPParbZc5enIOizqx46/m03ZcbmDlX+3zjEcLjEXq
         y07TGaXJ7mRS2EEXEWgXKb/Jx2315RqraCW+P+6KjkDNxYJ3cDFfvNw4aBnIM47khhjQ
         dLIRUpaLQKnfV59Os0cbsXDNCjeBcHFHKBbP0+ZapaSrz+D4lLXApe5UVJqRO2paLIqH
         MWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GiAFzJgpITFLl8DNyaqxwaKWLXI8iKCzBup4CTb/x7E=;
        b=AY/6K/v6Yp99gL8GkSY0zIiz47XMpRQxJnSw8ZmyXjGggQ9YWO7p488Zn1SwAn9+Y8
         uLAXBA4TwMW6qB88bOu7iaMbI3+0NWhYpsFEKg3wtzOwsu2Vp2PhqxyCVQJLft5CYRvE
         HqwDdIQMgfTd73zQO4wAqocXs0wI8wBLsrBvoA1ATmtMyqm4Og7/nAnaXFzG423GkJ8q
         bmift2tM2mg/MlpCpvBx8pBhUJDMZ/L/neFgQsqi5kfmkq5zLSAiF6t8Usot+AUCBQ3B
         NLnCcHxh3m6a/y2Ql50rJqNghpf93fLjh9B6BYkJlNVcvu3eYVG2adHY2opmMkdqv2Pl
         EdKA==
X-Gm-Message-State: AOAM531ujLgDeCi8ilTzDTKNvRwnsQgB3D07ZC14LNvaX/UOe4DFe/8f
        6nYyq6uKzed85tNxirta6kA=
X-Google-Smtp-Source: ABdhPJxzeveexeUhUMzWHQAk4pI8Qgkic9bWywtLXLagNOQa8pgqLn+V95LwMRW9CCGIHFgkir4p6g==
X-Received: by 2002:a17:902:9a09:b029:d3:df24:2011 with SMTP id v9-20020a1709029a09b02900d3df242011mr2210458plp.39.1602066803056;
        Wed, 07 Oct 2020 03:33:23 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id v129sm2705327pfc.76.2020.10.07.03.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:33:22 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 1/3] wireless: mt76: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 16:03:07 +0530
Message-Id: <20201007103309.363737-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007103309.363737-1-allen.lkml@gmail.com>
References: <20201007103309.363737-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  7 +++----
 drivers/net/wireless/mediatek/mt76/usb.c           |  6 +++---
 7 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index d728c5e43..53c229cad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -64,9 +64,9 @@ mt7603_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	data->count[mvif->idx]++;
 }
 
-void mt7603_pre_tbtt_tasklet(unsigned long arg)
+void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct mt7603_dev *dev = (struct mt7603_dev *)arg;
+	struct mt7603_dev *dev = from_tasklet(dev, t, mt76.pre_tbtt_tasklet);
 	struct mt76_queue *q;
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index c4848fafd..126f7c95f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -533,8 +533,7 @@ int mt7603_register_device(struct mt7603_dev *dev)
 	spin_lock_init(&dev->ps_lock);
 
 	INIT_DELAYED_WORK(&dev->mt76.mac_work, mt7603_mac_work);
-	tasklet_init(&dev->mt76.pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->mt76.pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet);
 
 	dev->slottime = 9;
 	dev->sensitivity_limit = 28;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 2a6e4332a..6e0a92a28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -256,7 +256,7 @@ void mt7603_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 void mt7603_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 
-void mt7603_pre_tbtt_tasklet(unsigned long arg);
+void mt7603_pre_tbtt_tasklet(struct tasklet_struct *t);
 
 void mt7603_update_channel(struct mt76_dev *mdev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
index 6de492a4c..b108324aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
@@ -98,9 +98,9 @@ static irqreturn_t mt7615_irq_handler(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
-static void mt7615_irq_tasklet(unsigned long data)
+static void mt7615_irq_tasklet(struct tasklet_struct *t)
 {
-	struct mt7615_dev *dev = (struct mt7615_dev *)data;
+	struct mt7615_dev *dev = from_tasklet(dev, t, irq_tasklet);
 	u32 intr, mask = 0, tx_mcu_mask = mt7615_tx_mcu_int_mask(dev);
 
 	mt76_wr(dev, MT_INT_MASK_CSR, 0);
@@ -203,7 +203,7 @@ int mt7615_mmio_probe(struct device *pdev, void __iomem *mem_base,
 
 	dev = container_of(mdev, struct mt7615_dev, mt76);
 	mt76_mmio_init(&dev->mt76, mem_base);
-	tasklet_init(&dev->irq_tasklet, mt7615_irq_tasklet, (unsigned long)dev);
+	tasklet_setup(&dev->irq_tasklet, mt7615_irq_tasklet);
 
 	dev->reg_map = map;
 	dev->ops = ops;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index b29cd39dc..a60135053 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -609,10 +609,11 @@ static void mt76x02_dfs_check_event_window(struct mt76x02_dev *dev)
 	}
 }
 
-static void mt76x02_dfs_tasklet(unsigned long arg)
+static void mt76x02_dfs_tasklet(struct tasklet_struct *t)
 {
-	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
-	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = from_tasklet(dfs_pd, t,
+								   dfs_tasklet);
+	struct mt76x02_dev *dev = container_of(dfs_pd, typeof(*dev), dfs_pd);
 	u32 engine_mask;
 	int i;
 
@@ -860,8 +861,7 @@ void mt76x02_dfs_init_detector(struct mt76x02_dev *dev)
 	INIT_LIST_HEAD(&dfs_pd->seq_pool);
 	dev->mt76.region = NL80211_DFS_UNSET;
 	dfs_pd->last_sw_check = jiffies;
-	tasklet_init(&dfs_pd->dfs_tasklet, mt76x02_dfs_tasklet,
-		     (unsigned long)dev);
+	tasklet_setup(&dfs_pd->dfs_tasklet, mt76x02_dfs_tasklet);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index cf68731bd..67911c021 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -11,9 +11,9 @@
 #include "mt76x02_mcu.h"
 #include "trace.h"
 
-static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
+static void mt76x02_pre_tbtt_tasklet(struct tasklet_struct *t)
 {
-	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
+	struct mt76x02_dev *dev = from_tasklet(dev, t, mt76.pre_tbtt_tasklet);
 	struct mt76_queue *q = dev->mt76.q_tx[MT_TXQ_PSD];
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
@@ -198,8 +198,7 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 		return -ENOMEM;
 
 	dev->mt76.tx_worker.fn = mt76x02_tx_worker;
-	tasklet_init(&dev->mt76.pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->mt76.pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet);
 
 	spin_lock_init(&dev->txstatus_fifo_lock);
 	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7d3f0a2e5..911fb61df 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -669,9 +669,9 @@ mt76u_process_rx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 		mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
 }
 
-static void mt76u_rx_tasklet(unsigned long data)
+static void mt76u_rx_tasklet(struct tasklet_struct *t)
 {
-	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76_dev *dev = from_tasklet(dev, t, usb.rx_tasklet);
 	int i;
 
 	rcu_read_lock();
@@ -1110,7 +1110,7 @@ int mt76u_init(struct mt76_dev *dev,
 	mt76u_ops.write_copy = ext ? mt76u_copy_ext : mt76u_copy;
 
 	dev->tx_worker.fn = mt76u_tx_worker;
-	tasklet_init(&usb->rx_tasklet, mt76u_rx_tasklet, (unsigned long)dev);
+	tasklet_setup(&usb->rx_tasklet, mt76u_rx_tasklet);
 	INIT_WORK(&usb->stat_work, mt76u_tx_status_data);
 
 	usb->data_len = usb_maxpacket(udev, usb_sndctrlpipe(udev, 0), 1);
-- 
2.25.1

