Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F371EDE86
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgFDHfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:35:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:31665 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgFDHfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 03:35:03 -0400
IronPort-SDR: +covTZqTKJjsylkR2uAaW1v3hJ6cS3hy7heb3ge2LC7hbO2ivq05QxKfDeI05w/TSlQvAJO6I5
 g4FFUz7ss0lg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 00:35:03 -0700
IronPort-SDR: sZBtJNGzFr/dYLMCMm3jJazdZoV38Q4BYE13EVmXO46q7i10byYh7YeBO/SUJgiferM0a/LrTc
 djwg84pVkPxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="348021631"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2020 00:35:00 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCH v3 07/10] net: eth: altera: change tx functions to type netdev_tx_t
Date:   Thu,  4 Jun 2020 15:32:53 +0800
Message-Id: <20200604073256.25702-8-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200604073256.25702-1-joyce.ooi@intel.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@linux.intel.com>

Modify all msgdma and sgdma tx_buffer functions to be of type
netdev_tx_t, and also modify main tx function to be of
netdev_tx_t type.

Signed-off-by: Dalon Westergreen <dalon.westergreen@linux.intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: this patch is added in patch version 2
v3: no change
---
 drivers/net/ethernet/altera/altera_msgdma.c   | 5 +++--
 drivers/net/ethernet/altera/altera_msgdma.h   | 4 ++--
 drivers/net/ethernet/altera/altera_sgdma.c    | 5 +++--
 drivers/net/ethernet/altera/altera_sgdma.h    | 4 ++--
 drivers/net/ethernet/altera/altera_tse.h      | 4 ++--
 drivers/net/ethernet/altera/altera_tse_main.c | 2 +-
 6 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_msgdma.c b/drivers/net/ethernet/altera/altera_msgdma.c
index ac1efd08267a..ac68151a7f47 100644
--- a/drivers/net/ethernet/altera/altera_msgdma.c
+++ b/drivers/net/ethernet/altera/altera_msgdma.c
@@ -106,7 +106,8 @@ void msgdma_clear_txirq(struct altera_tse_private *priv)
 }
 
 /* return 0 to indicate transmit is pending */
-int msgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
+netdev_tx_t
+msgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 {
 	csrwr32(lower_32_bits(buffer->dma_addr), priv->tx_dma_desc,
 		msgdma_descroffs(read_addr_lo));
@@ -120,7 +121,7 @@ int msgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 		msgdma_descroffs(stride));
 	csrwr32(MSGDMA_DESC_CTL_TX_SINGLE, priv->tx_dma_desc,
 		msgdma_descroffs(control));
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 u32 msgdma_tx_completions(struct altera_tse_private *priv)
diff --git a/drivers/net/ethernet/altera/altera_msgdma.h b/drivers/net/ethernet/altera/altera_msgdma.h
index 23f5b2a13898..d816b24dfa7f 100644
--- a/drivers/net/ethernet/altera/altera_msgdma.h
+++ b/drivers/net/ethernet/altera/altera_msgdma.h
@@ -16,8 +16,8 @@ void msgdma_clear_txirq(struct altera_tse_private *priv);
 u32 msgdma_tx_completions(struct altera_tse_private *priv);
 void msgdma_add_rx_desc(struct altera_tse_private *priv,
 			struct tse_buffer *buffer);
-int msgdma_tx_buffer(struct altera_tse_private *priv,
-		     struct tse_buffer *buffer);
+netdev_tx_t msgdma_tx_buffer(struct altera_tse_private *priv,
+			     struct tse_buffer *buffer);
 u32 msgdma_rx_status(struct altera_tse_private *priv);
 int msgdma_initialize(struct altera_tse_private *priv);
 void msgdma_uninitialize(struct altera_tse_private *priv);
diff --git a/drivers/net/ethernet/altera/altera_sgdma.c b/drivers/net/ethernet/altera/altera_sgdma.c
index fe6276c7e4a3..6898ec682425 100644
--- a/drivers/net/ethernet/altera/altera_sgdma.c
+++ b/drivers/net/ethernet/altera/altera_sgdma.c
@@ -166,7 +166,8 @@ void sgdma_clear_txirq(struct altera_tse_private *priv)
  *   will now actually look at the code, so from now, 0 is good and return
  *   NETDEV_TX_BUSY when busy.
  */
-int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
+netdev_tx_t
+sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 {
 	struct sgdma_descrip __iomem *descbase =
 		(struct sgdma_descrip __iomem *)priv->tx_dma_desc;
@@ -196,7 +197,7 @@ int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 	/* enqueue the request to the pending transmit queue */
 	queue_tx(priv, buffer);
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 
diff --git a/drivers/net/ethernet/altera/altera_sgdma.h b/drivers/net/ethernet/altera/altera_sgdma.h
index 3fb201417820..6a41833f0965 100644
--- a/drivers/net/ethernet/altera/altera_sgdma.h
+++ b/drivers/net/ethernet/altera/altera_sgdma.h
@@ -13,8 +13,8 @@ void sgdma_disable_rxirq(struct altera_tse_private *priv);
 void sgdma_disable_txirq(struct altera_tse_private *priv);
 void sgdma_clear_rxirq(struct altera_tse_private *priv);
 void sgdma_clear_txirq(struct altera_tse_private *priv);
-int sgdma_tx_buffer(struct altera_tse_private *priv,
-		    struct tse_buffer *buffer);
+netdev_tx_t sgdma_tx_buffer(struct altera_tse_private *priv,
+			    struct tse_buffer *buffer);
 u32 sgdma_tx_completions(struct altera_tse_private *priv);
 void sgdma_add_rx_desc(struct altera_tse_private *priv,
 		       struct tse_buffer *buffer);
diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index fa24ab3c7d6a..79d02748c89d 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -392,8 +392,8 @@ struct altera_dmaops {
 	void (*disable_rxirq)(struct altera_tse_private *priv);
 	void (*clear_txirq)(struct altera_tse_private *priv);
 	void (*clear_rxirq)(struct altera_tse_private *priv);
-	int (*tx_buffer)(struct altera_tse_private *priv,
-			 struct tse_buffer *buffer);
+	netdev_tx_t (*tx_buffer)(struct altera_tse_private *priv,
+				 struct tse_buffer *buffer);
 	u32 (*tx_completions)(struct altera_tse_private *priv);
 	void (*add_rx_desc)(struct altera_tse_private *priv,
 			    struct tse_buffer *buffer);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 87f789e42b6e..24a1d30c6780 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -553,7 +553,7 @@ static irqreturn_t altera_isr(int irq, void *dev_id)
  * physically contiguous fragment starting at
  * skb->data, for length of skb_headlen(skb).
  */
-static int tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
 	unsigned int txsize = priv->tx_ring_size;
-- 
2.13.0

