Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA711247EC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfLRNSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:18:21 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:21984 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfLRNSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3076; q=dns/txt; s=iport;
  t=1576675100; x=1577884700;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=7dNGHeyUqKpYVYMYA64XXX88dWHaHKbDO5x/yR/XAMg=;
  b=gdGEJD2ZV3yCKAsxbKN/3FhMkhVwab9869ojuEDt01HKE8aZ8TcafRqN
   Lmc+byLaLzeqyNPtUmkUXlI252KVNZgNNtCX6B73Oq8Zz5K4WsJOJDV5X
   I1bRn/8cNRKUx96vfb7lZ56AAgowoeTS0IBcFHb7jDNYdtjIZ6XKemGQa
   s=;
X-IronPort-AV: E=Sophos;i="5.69,329,1571702400"; 
   d="scan'208";a="403697379"
Received: from rcdn-core-2.cisco.com ([173.37.93.153])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Dec 2019 13:18:20 +0000
Received: from sjc-ads-7483.cisco.com (sjc-ads-7483.cisco.com [10.30.221.19])
        by rcdn-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id xBIDIJVw018095;
        Wed, 18 Dec 2019 13:18:20 GMT
Received: by sjc-ads-7483.cisco.com (Postfix, from userid 838444)
        id AF47A159D; Wed, 18 Dec 2019 05:18:19 -0800 (PST)
From:   Aviraj CJ <acj@cisco.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        acj@cisco.com
Subject: [PATCH stable v4.14 2/2] net: stmmac: don't stop NAPI processing when dropping a packet
Date:   Wed, 18 Dec 2019 05:17:21 -0800
Message-Id: <20191218131720.12270-2-acj@cisco.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191218131720.12270-1-acj@cisco.com>
References: <20191218131720.12270-1-acj@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.30.221.19, sjc-ads-7483.cisco.com
X-Outbound-Node: rcdn-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

upstream 07b3975352374c3f5ebb4a42ef0b253fe370542d commit

Currently, if we drop a packet, we exit from NAPI loop before the budget
is consumed. In some situations this will make the RX processing stall
e.g. when flood pinging the system with oversized packets, as the
errorneous packets are not dropped efficiently.

If we drop a packet, we should just continue to the next one as long as
the budget allows.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[acj: backport v4.14 -stable
- adjust context]
Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index da5b5fc99c04..e6d16c48ffef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3323,9 +3323,8 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-	unsigned int entry = rx_q->cur_rx;
 	int coe = priv->hw->rx_csum;
-	unsigned int next_entry;
+	unsigned int next_entry = rx_q->cur_rx;
 	unsigned int count = 0;
 
 	if (netif_msg_rx_status(priv)) {
@@ -3340,10 +3339,12 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		priv->hw->desc->display_ring(rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
-		int status;
+		int entry, status;
 		struct dma_desc *p;
 		struct dma_desc *np;
 
+		entry = next_entry;
+
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(rx_q->dma_erx + entry);
 		else
@@ -3410,7 +3411,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						   "len %d larger than size (%d)\n",
 						   frame_len, priv->dma_buf_sz);
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -3446,7 +3447,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						dev_warn(priv->device,
 							 "packet dropped\n");
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 
 				dma_sync_single_for_cpu(priv->device,
@@ -3471,7 +3472,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   "%s: Inconsistent Rx chain\n",
 							   priv->dev->name);
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 				prefetch(skb->data - NET_IP_ALIGN);
 				rx_q->rx_skbuff[entry] = NULL;
@@ -3506,7 +3507,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv, queue);
-- 
2.19.1

