Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236AB3A2553
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFJHZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5475 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFJHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0wNm2qnkzZdCy;
        Thu, 10 Jun 2021 15:20:24 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/8] net: ixp4xx_hss: move out assignment in if condition
Date:   Thu, 10 Jun 2021 15:20:01 +0800
Message-ID: <1623309605-15671-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
References: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 66 +++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 48bc914..d657bca 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -510,10 +510,12 @@ static int hss_load_firmware(struct port *port)
 	if (port->initialized)
 		return 0;
 
-	if (!npe_running(port->npe) &&
-	    (err = npe_load_firmware(port->npe, npe_name(port->npe),
-				     port->dev)))
-		return err;
+	if (!npe_running(port->npe)) {
+		err = npe_load_firmware(port->npe, npe_name(port->npe),
+					port->dev);
+		if (err)
+			return err;
+	}
 
 	/* HDLC mode configuration */
 	memset(&msg, 0, sizeof(msg));
@@ -579,7 +581,8 @@ static inline int queue_get_desc(unsigned int queue, struct port *port,
 	u32 phys, tab_phys, n_desc;
 	struct desc *tab;
 
-	if (!(phys = qmgr_get_entry(queue)))
+	phys = qmgr_get_entry(queue);
+	if (!phys)
 		return -1;
 
 	BUG_ON(phys & 0x1F);
@@ -664,7 +667,8 @@ static int hss_hdlc_poll(struct napi_struct *napi, int budget)
 		u32 phys;
 #endif
 
-		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
+		n = queue_get_desc(rxq, port, 0);
+		if (n < 0) {
 #if DEBUG_RX
 			printk(KERN_DEBUG "%s: hss_hdlc_poll"
 			       " napi_complete\n", dev->name);
@@ -699,7 +703,8 @@ static int hss_hdlc_poll(struct napi_struct *napi, int budget)
 		switch (desc->status) {
 		case 0:
 #ifdef __ARMEB__
-			if ((skb = netdev_alloc_skb(dev, RX_SIZE)) != NULL) {
+			skb = netdev_alloc_skb(dev, RX_SIZE);
+			if (skb) {
 				phys = dma_map_single(&dev->dev, skb->data,
 						      RX_SIZE,
 						      DMA_FROM_DEVICE);
@@ -847,7 +852,8 @@ static int hss_hdlc_xmit(struct sk_buff *skb, struct net_device *dev)
 #else
 	offset = (int)skb->data & 3; /* keep 32-bit alignment */
 	bytes = ALIGN(offset + len, 4);
-	if (!(mem = kmalloc(bytes, GFP_ATOMIC))) {
+	mem = kmalloc(bytes, GFP_ATOMIC);
+	if (!mem) {
 		dev_kfree_skb(skb);
 		dev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
@@ -966,8 +972,9 @@ static int init_hdlc_queues(struct port *port)
 			return -ENOMEM;
 	}
 
-	if (!(port->desc_tab = dma_pool_alloc(dma_pool, GFP_KERNEL,
-					      &port->desc_tab_phys)))
+	port->desc_tab = dma_pool_alloc(dma_pool, GFP_KERNEL,
+					&port->desc_tab_phys);
+	if (!port->desc_tab)
 		return -ENOMEM;
 	memset(port->desc_tab, 0, POOL_ALLOC_SIZE);
 	memset(port->rx_buff_tab, 0, sizeof(port->rx_buff_tab)); /* tables */
@@ -979,11 +986,13 @@ static int init_hdlc_queues(struct port *port)
 		buffer_t *buff;
 		void *data;
 #ifdef __ARMEB__
-		if (!(buff = netdev_alloc_skb(port->netdev, RX_SIZE)))
+		buff = netdev_alloc_skb(port->netdev, RX_SIZE);
+		if (!buff)
 			return -ENOMEM;
 		data = buff->data;
 #else
-		if (!(buff = kmalloc(RX_SIZE, GFP_KERNEL)))
+		buff = kmalloc(RX_SIZE, GFP_KERNEL);
+		if (!buff)
 			return -ENOMEM;
 		data = buff;
 #endif
@@ -1041,23 +1050,29 @@ static int hss_hdlc_open(struct net_device *dev)
 	unsigned long flags;
 	int i, err = 0;
 
-	if ((err = hdlc_open(dev)))
+	err = hdlc_open(dev);
+	if (err)
 		return err;
 
-	if ((err = hss_load_firmware(port)))
+	err = hss_load_firmware(port);
+	if (err)
 		goto err_hdlc_close;
 
-	if ((err = request_hdlc_queues(port)))
+	err = request_hdlc_queues(port);
+	if (err)
 		goto err_hdlc_close;
 
-	if ((err = init_hdlc_queues(port)))
+	err = init_hdlc_queues(port);
+	if (err)
 		goto err_destroy_queues;
 
 	spin_lock_irqsave(&npe_lock, flags);
-	if (port->plat->open)
-		if ((err = port->plat->open(port->id, dev,
-					    hss_hdlc_set_carrier)))
+	if (port->plat->open) {
+		err = port->plat->open(port->id, dev, hss_hdlc_set_carrier);
+		if (err)
 			goto err_unlock;
+	}
+
 	spin_unlock_irqrestore(&npe_lock, flags);
 
 	/* Populate queues with buffers, no failure after this point */
@@ -1328,15 +1343,19 @@ static int hss_init_one(struct platform_device *pdev)
 	hdlc_device *hdlc;
 	int err;
 
-	if ((port = kzalloc(sizeof(*port), GFP_KERNEL)) == NULL)
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
 		return -ENOMEM;
 
-	if ((port->npe = npe_request(0)) == NULL) {
+	port->npe = npe_request(0);
+	if (!port->npe) {
 		err = -ENODEV;
 		goto err_free;
 	}
 
-	if ((port->netdev = dev = alloc_hdlcdev(port)) == NULL) {
+	dev = alloc_hdlcdev(port);
+	port->netdev = alloc_hdlcdev(port);
+	if (!port->netdev) {
 		err = -ENOMEM;
 		goto err_plat;
 	}
@@ -1355,7 +1374,8 @@ static int hss_init_one(struct platform_device *pdev)
 	port->plat = pdev->dev.platform_data;
 	netif_napi_add(dev, &port->napi, hss_hdlc_poll, NAPI_WEIGHT);
 
-	if ((err = register_hdlc_device(dev)))
+	err = register_hdlc_device(dev);
+	if (err)
 		goto err_free_netdev;
 
 	platform_set_drvdata(pdev, port);
-- 
2.8.1

