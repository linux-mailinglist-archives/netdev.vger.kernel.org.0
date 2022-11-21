Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F929632EB9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiKUVY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiKUVYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:24:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2855CA414A;
        Mon, 21 Nov 2022 13:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669065884; x=1700601884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j2O7GMy+IIz1SySbZrYhpOJz3Xy8edTsWmZxxV8XFC4=;
  b=KSpywKXlNidutTVnX7OJ4cTLCUFXbR2y2yNGEimQsq3mB2VE7QMWNHxK
   RwW5nALcnTSoVx9iO59xYpvVPETnN46g80t7394hscDtMwDAGnA8WWMNj
   gWyP/lbgavYFC4Gzz7TcLxNqOjQ+j67zuL9KE+KwXIi05xKaNoV/B40G8
   sqxJzBHPE+bCFwSE2Ljf+Z9wifOH9emvkDrIegEKnko8suJhOf6iqTnrx
   uz18sL5WOT1q1SeaDgRvkIg/kb9CiHlzdZ/59rr6QYRLYjDa+pIKbo17Y
   p/Px2DPAb3OXR6+6HBCoU8uheZ/QjcSviU+L3PzOb5Q+QoJpzjY3R8602
   w==;
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="124468627"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 14:24:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 14:24:38 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 14:24:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/7] net: lan966x: Introduce helper functions
Date:   Mon, 21 Nov 2022 22:28:45 +0100
Message-ID: <20221121212850.3212649-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce lan966x_fdma_tx_setup_dcb and lan966x_fdma_tx_start functions
and use of them inside lan966x_fdma_xmit. There is no functional change
in here.
They are introduced to be used when XDP_TX/REDIRECT actions are
introduced.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 71 ++++++++++++-------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 3055124b4dd79..94c720e59caee 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -612,14 +612,53 @@ static int lan966x_fdma_get_next_dcb(struct lan966x_tx *tx)
 	return -1;
 }
 
+static void lan966x_fdma_tx_setup_dcb(struct lan966x_tx *tx,
+				      int next_to_use, int len,
+				      dma_addr_t dma_addr)
+{
+	struct lan966x_tx_dcb *next_dcb;
+	struct lan966x_db *next_db;
+
+	next_dcb = &tx->dcbs[next_to_use];
+	next_dcb->nextptr = FDMA_DCB_INVALID_DATA;
+
+	next_db = &next_dcb->db[0];
+	next_db->dataptr = dma_addr;
+	next_db->status = FDMA_DCB_STATUS_SOF |
+			  FDMA_DCB_STATUS_EOF |
+			  FDMA_DCB_STATUS_INTR |
+			  FDMA_DCB_STATUS_BLOCKO(0) |
+			  FDMA_DCB_STATUS_BLOCKL(len);
+}
+
+static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
+{
+	struct lan966x *lan966x = tx->lan966x;
+	struct lan966x_tx_dcb *dcb;
+
+	if (likely(lan966x->tx.activated)) {
+		/* Connect current dcb to the next db */
+		dcb = &tx->dcbs[tx->last_in_use];
+		dcb->nextptr = tx->dma + (next_to_use *
+					  sizeof(struct lan966x_tx_dcb));
+
+		lan966x_fdma_tx_reload(tx);
+	} else {
+		/* Because it is first time, then just activate */
+		lan966x->tx.activated = true;
+		lan966x_fdma_tx_activate(tx);
+	}
+
+	/* Move to next dcb because this last in use */
+	tx->last_in_use = next_to_use;
+}
+
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
 	struct lan966x_tx_dcb_buf *next_dcb_buf;
-	struct lan966x_tx_dcb *next_dcb, *dcb;
 	struct lan966x_tx *tx = &lan966x->tx;
-	struct lan966x_db *next_db;
 	int needed_headroom;
 	int needed_tailroom;
 	dma_addr_t dma_addr;
@@ -665,16 +704,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	}
 
 	/* Setup next dcb */
-	next_dcb = &tx->dcbs[next_to_use];
-	next_dcb->nextptr = FDMA_DCB_INVALID_DATA;
-
-	next_db = &next_dcb->db[0];
-	next_db->dataptr = dma_addr;
-	next_db->status = FDMA_DCB_STATUS_SOF |
-			  FDMA_DCB_STATUS_EOF |
-			  FDMA_DCB_STATUS_INTR |
-			  FDMA_DCB_STATUS_BLOCKO(0) |
-			  FDMA_DCB_STATUS_BLOCKL(skb->len);
+	lan966x_fdma_tx_setup_dcb(tx, next_to_use, skb->len, dma_addr);
 
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
@@ -688,21 +718,8 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
 		next_dcb_buf->ptp = true;
 
-	if (likely(lan966x->tx.activated)) {
-		/* Connect current dcb to the next db */
-		dcb = &tx->dcbs[tx->last_in_use];
-		dcb->nextptr = tx->dma + (next_to_use *
-					  sizeof(struct lan966x_tx_dcb));
-
-		lan966x_fdma_tx_reload(tx);
-	} else {
-		/* Because it is first time, then just activate */
-		lan966x->tx.activated = true;
-		lan966x_fdma_tx_activate(tx);
-	}
-
-	/* Move to next dcb because this last in use */
-	tx->last_in_use = next_to_use;
+	/* Start the transmission */
+	lan966x_fdma_tx_start(tx, next_to_use);
 
 	return NETDEV_TX_OK;
 
-- 
2.38.0

