Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE189636B37
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbiKWUbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbiKWUbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:31:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF732AF0B6;
        Wed, 23 Nov 2022 12:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669235232; x=1700771232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j2O7GMy+IIz1SySbZrYhpOJz3Xy8edTsWmZxxV8XFC4=;
  b=uOSQUKGYGezkVtyPIaB4oz9nJnGRBHlrOtXROYCUSyAHF5epZ8wpIysv
   4GMlXifdWYwLv9SDOtV91YBBnfAiYowWMw5sMBGRkuy/dt672DN4iQU9K
   fKCRyFSRqMq/IAb2pDnfW31VzkMK3eVk0AY7NGcKwwwtuANrAilj0FguW
   ncD+R5oPfcNV4cYP7UDcWuDXqW6vXAW706F8JM30BZ2SYDLU+WC6MP7M/
   frDalrSIdzj96XUjtG4dthJO/CPT3gq3yR2zVgGrxpwpOHJU+QV5k6yj6
   epMtGjyEGBizlJ4eaMVxDCQ/0IMm72LbQZYWhLM9xGv2Vej0ljlqESKYk
   g==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="190333689"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 13:27:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 13:27:12 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 13:27:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 2/7] net: lan966x: Introduce helper functions
Date:   Wed, 23 Nov 2022 21:31:34 +0100
Message-ID: <20221123203139.3828548-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
References: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

