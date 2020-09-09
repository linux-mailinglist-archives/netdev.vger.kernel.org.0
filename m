Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A666262AC4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgIIIqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbgIIIpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:51 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F6BC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:51 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so1555907pgm.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZEmlUg19qzoBm1BuvHVSKp+FeDxOQArVCaZ12ri1ZPo=;
        b=UQoXF0jJXo/QZPZi+O87UxeUf8IDHmfXjftSHkdgz7T5t3zcaNf0YArXFVEGgQbUDo
         BaRjrhW1VY5tmDwPDXHrlfIcWfCWL+rVEEv0ZSNpSmUGmZcPUQNT/lwu9wfhxZm9cZha
         FD0/NJavWkzCjW+uh0o1tVs7IC16NOFLSXTUDhkGV6C7+ITrt2XbPKnmJYsGXfCGdahw
         yMteFlxcJmOwOE2N4MDrqU7c1A0beqF4oULnV7sNwDKlVw7tH8yb4JnFqjWjwNZMmq0u
         R6NUvHAEvF3ZV/bBw8BKP82ja8zmo+AQAGO7cwJWmhaGHq53dFmGnOD2mj9H2XKar86V
         xFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZEmlUg19qzoBm1BuvHVSKp+FeDxOQArVCaZ12ri1ZPo=;
        b=mZBA98FmxJBz6Tmmk5gvCRsdyA3vUZiFQjP/BiokW50I/voox1KxaqRCAZGy7/DKnb
         RaTzqL7DcwVex9sLYChiQYpmf3+7T8jH7RtbSK1CimK3qnty3q3MzORpQcAbcjU9Ryd+
         oelPi/sGiD1Ev4TyK32InY0ykLQVPUKvQACejQTxO5cQo2KNTg1AA4OfzBzKB+muR8NY
         GCzMMLT3Z7Y8B0SiLmc8C/iEacdIQwP4EwGFBAOixpXMDSnYr6KKxk51bnGs5d8Kb0iv
         HXyTBFMOX4bqcl02JJ19uroQlRbkpq3QGXMYKZ4mRU8C262vApMhMfb9UXJue5nVCQCF
         5y2g==
X-Gm-Message-State: AOAM531H6pqpz0vUEFlld4Gl/pYL73MMv0Ostz6IJEamWZKqJf1akgus
        Tz85hnlDcD+k79YBoBx18vs=
X-Google-Smtp-Source: ABdhPJymLcOETdDB2iWln5YkeHdjdhZbqPhHEmger4K3hkucIqZKbgx9GQLwD6TKsQeE4wy8d2P5iQ==
X-Received: by 2002:a62:3083:: with SMTP id w125mr2699844pfw.81.1599641148143;
        Wed, 09 Sep 2020 01:45:48 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:47 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 07/20] ethernet: dlink: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:57 +0530
Message-Id: <20200909084510.648706-8-allen.lkml@gmail.com>
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
 drivers/net/ethernet/dlink/sundance.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index b3f8597e77aa..58022396b053 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -429,8 +429,8 @@ static void init_ring(struct net_device *dev);
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
@@ -537,8 +537,8 @@ static int sundance_probe1(struct pci_dev *pdev,
 	np->msg_enable = (1 << debug) - 1;
 	spin_lock_init(&np->lock);
 	spin_lock_init(&np->statlock);
-	tasklet_init(&np->rx_tasklet, rx_poll, (unsigned long)dev);
-	tasklet_init(&np->tx_tasklet, tx_poll, (unsigned long)dev);
+	tasklet_setup(&np->rx_tasklet, rx_poll);
+	tasklet_setup(&np->tx_tasklet, tx_poll);
 
 	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE,
 			&ring_dma, GFP_KERNEL);
@@ -1054,10 +1054,9 @@ static void init_ring(struct net_device *dev)
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
@@ -1312,10 +1311,11 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static void rx_poll(unsigned long data)
+static void rx_poll(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct netdev_private *np = netdev_priv(dev);
+	struct netdev_private *np = from_tasklet(np, t, rx_tasklet);
+	struct net_device *dev = (struct net_device *)((char *)np -
+				  ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	int entry = np->cur_rx % RX_RING_SIZE;
 	int boguscnt = np->budget;
 	void __iomem *ioaddr = np->base;
-- 
2.25.1

