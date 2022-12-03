Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB15F641956
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiLCWLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCWLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:11:32 -0500
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90C81C434;
        Sat,  3 Dec 2022 14:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+1pzVMjrXxDSSspIV0bVsNsHo7Kcxn6MpXhlD84VVuA=; b=NztCf5W3A/M6JtoPjoe5TYiTxH
        lseg5GN5EMrfznnENXH+4W4Hfs1biB/NUz3ApYLg7xk03r4STXMJY8Y4PbYZTySKftb/surN3AMNQ
        +DueDahRdl7A+wKn8q1CeMqXFgAvZ4aOG6/Vk5BwZ7SLNwiVnspD0KACLRL2aJY3ee5c=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p1aSu-0003Ir-Ts; Sat, 03 Dec 2022 22:54:33 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 5/6] tsnep: Add RX queue info for XDP support
Date:   Sat,  3 Dec 2022 22:54:15 +0100
Message-Id: <20221203215416.13465-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221203215416.13465-1-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register xdp_rxq_info with page_pool memory model. This is needed for
XDP buffer handling.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  5 ++--
 drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 0e7fc36a64e1..70bc133d4a9d 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -127,6 +127,7 @@ struct tsnep_rx {
 	u32 owner_counter;
 	int increment_owner_counter;
 	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
 
 	u32 packets;
 	u32 bytes;
@@ -139,11 +140,11 @@ struct tsnep_queue {
 	struct tsnep_adapter *adapter;
 	char name[IFNAMSIZ + 9];
 
+	struct napi_struct napi;
+
 	struct tsnep_tx *tx;
 	struct tsnep_rx *rx;
 
-	struct napi_struct napi;
-
 	int irq;
 	u32 irq_mask;
 	void __iomem *irq_delay_addr;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index d7dcac641180..725b2a1e7be4 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -833,6 +833,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 		entry->page = NULL;
 	}
 
+	if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
+		xdp_rxq_info_unreg(&rx->xdp_rxq);
+
 	if (rx->page_pool)
 		page_pool_destroy(rx->page_pool);
 
@@ -848,7 +851,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 	}
 }
 
-static int tsnep_rx_ring_init(struct tsnep_rx *rx)
+static int tsnep_rx_ring_init(struct tsnep_rx *rx, unsigned int napi_id)
 {
 	struct device *dmadev = rx->adapter->dmadev;
 	struct tsnep_rx_entry *entry;
@@ -891,6 +894,15 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 		goto failed;
 	}
 
+	retval = xdp_rxq_info_reg(&rx->xdp_rxq, rx->adapter->netdev,
+				  rx->queue_index, napi_id);
+	if (retval)
+		goto failed;
+	retval = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					    rx->page_pool);
+	if (retval)
+		goto failed;
+
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &rx->entry[i];
 		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
@@ -1139,7 +1151,8 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 }
 
 static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 int queue_index, struct tsnep_rx *rx)
+			 unsigned int napi_id, int queue_index,
+			 struct tsnep_rx *rx)
 {
 	dma_addr_t dma;
 	int retval;
@@ -1149,7 +1162,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	rx->addr = addr;
 	rx->queue_index = queue_index;
 
-	retval = tsnep_rx_ring_init(rx);
+	retval = tsnep_rx_ring_init(rx, napi_id);
 	if (retval)
 		return retval;
 
@@ -1277,6 +1290,7 @@ int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
+	unsigned int napi_id;
 	void __iomem *addr;
 	int tx_queue_index = 0;
 	int rx_queue_index = 0;
@@ -1284,6 +1298,11 @@ int tsnep_netdev_open(struct net_device *netdev)
 
 	for (i = 0; i < adapter->num_queues; i++) {
 		adapter->queue[i].adapter = adapter;
+
+		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
+			       tsnep_poll);
+		napi_id = adapter->queue[i].napi.napi_id;
+
 		if (adapter->queue[i].tx) {
 			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
 			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
@@ -1294,7 +1313,7 @@ int tsnep_netdev_open(struct net_device *netdev)
 		}
 		if (adapter->queue[i].rx) {
 			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
-			retval = tsnep_rx_open(adapter, addr,
+			retval = tsnep_rx_open(adapter, addr, napi_id,
 					       rx_queue_index,
 					       adapter->queue[i].rx);
 			if (retval)
@@ -1326,8 +1345,6 @@ int tsnep_netdev_open(struct net_device *netdev)
 		goto phy_failed;
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
-			       tsnep_poll);
 		napi_enable(&adapter->queue[i].napi);
 
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
@@ -1348,6 +1365,8 @@ int tsnep_netdev_open(struct net_device *netdev)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
+
+		netif_napi_del(&adapter->queue[i].napi);
 	}
 	return retval;
 }
@@ -1366,7 +1385,6 @@ int tsnep_netdev_close(struct net_device *netdev)
 		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
 
 		napi_disable(&adapter->queue[i].napi);
-		netif_napi_del(&adapter->queue[i].napi);
 
 		tsnep_free_irq(&adapter->queue[i], i == 0);
 
@@ -1374,6 +1392,8 @@ int tsnep_netdev_close(struct net_device *netdev)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
+
+		netif_napi_del(&adapter->queue[i].napi);
 	}
 
 	return 0;
-- 
2.30.2

