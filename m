Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DFA245FD2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgHQIZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbgHQIZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A509FC061388;
        Mon, 17 Aug 2020 01:25:36 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mw10so7346717pjb.2;
        Mon, 17 Aug 2020 01:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t98B3iZn1A9NLqkiUAje/weBgNoNpyefzZebYfgmTtE=;
        b=jZLuecL8IeUDv5a24d46K3rjLGWcoQJj69HmdPY/DPKCZxH5u+GyxjZZU0tHjy6TcL
         q4HpfCzSZMtxa61vEN7/e/eDdpbmaZVqSDB73eonA+uwHWobDX7xGEC0NjwH81/fXTVK
         7ff3VxfI4HmSAE+59SQ7UN6yt952R0GQc/s9UOWICylm4KiIaXzaPAUDZFNUpWcFYUQ4
         h4QkOSWETXpxWR04vhc42wXGtQl7Pflsu2sYnuQWpvyDpJoPvYC6WGr5KRgcK/CANL8x
         VKrhuEQhsp7U8rTTGURn1Uij6MXbcuyNQQ9WVswpOdCZJH1lpE33edBog9aESZmbcyLV
         crfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t98B3iZn1A9NLqkiUAje/weBgNoNpyefzZebYfgmTtE=;
        b=ew/NFMYo4yOg+f5YNKkp0JqgLNC2D5+EsSy84q/hdcZUT7iks3vWMfr5Q69C960QrQ
         kdsTl4xLi/m0ZDxv+vQir9FNzhrAMPI8YSbGimgxbNleyZYu5vrskLEYARHbqd/um52p
         gfprTsai93UwRdFP32tPh2gm8QBHi0NZt45R1UI0fksdaVg0Nggb1IagqfdoeHlSi3Oi
         WlOrZsRnVmp4EjtnspGMG9VnZd+GT2QSp1CzHbPFz99QR/HJNTe/4624g+7Sww1tDuod
         cLVV0cUqp8ZSQ+A7TkgibIguAwvCWlLejl6ix/MyXesquR0IjoR+ypoJxgPn1e7Mbeq6
         YR9Q==
X-Gm-Message-State: AOAM533SWs+mVWRRLc3hfKVnPFoa7+Ai/j7tk7EqCIiDTbmbf7i3Einz
        KsrjOp4QcJ3/O1n1VrJlGaE=
X-Google-Smtp-Source: ABdhPJw4UfJp6v93zOfVhpwON1MyO9yehUVd0VaAZcFPqK5ou/peSYq27nwwshI4OGpbk3ZqbHihsw==
X-Received: by 2002:a17:90a:ff85:: with SMTP id hf5mr11460448pjb.79.1597652736154;
        Mon, 17 Aug 2020 01:25:36 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:35 -0700 (PDT)
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
Subject: [PATCH 07/20] ethernet: dlink: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:21 +0530
Message-Id: <20200817082434.21176-9-allen.lkml@gmail.com>
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
2.17.1

