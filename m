Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DFC1247BD
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfLRNLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:11:21 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:27034 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfLRNLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2837; q=dns/txt; s=iport;
  t=1576674680; x=1577884280;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=l/YYN2m/bA6a9KbNW0ZsecGB6ZPVLjJbxnAmtzZv7H4=;
  b=P8mv5E98RP3dIsYrV0E9Ok3dw8KZ4uT2fy/WofOO6swlQG7Z2/iY4yrm
   o97DyVnZ6ZPO8wT4QNm9HCCiNaNLnaFu3ag/ELMPU21rIqmdW4KKC8ul6
   v28hNxdQpqbyPVe006lmzKWyJJRResix7d7Z5jvPgU0J/Id1b99akcCSa
   E=;
X-IronPort-AV: E=Sophos;i="5.69,329,1571702400"; 
   d="scan'208";a="395169984"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Dec 2019 13:11:19 +0000
Received: from sjc-ads-7483.cisco.com (sjc-ads-7483.cisco.com [10.30.221.19])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTP id xBIDBIOd012762;
        Wed, 18 Dec 2019 13:11:19 GMT
Received: by sjc-ads-7483.cisco.com (Postfix, from userid 838444)
        id D36CA141D; Wed, 18 Dec 2019 05:11:18 -0800 (PST)
From:   Aviraj CJ <acj@cisco.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        acj@cisco.com
Subject: [PATCH stable v4.9 2/2] net: stmmac: don't stop NAPI processing when dropping a packet
Date:   Wed, 18 Dec 2019 05:10:10 -0800
Message-Id: <20191218131009.10968-2-acj@cisco.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191218131009.10968-1-acj@cisco.com>
References: <20191218131009.10968-1-acj@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.30.221.19, sjc-ads-7483.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
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

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[acj: backport v4.9 -stable
-adjust context]
Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f1844367ca5b..5ac48a594951 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2499,8 +2499,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv)
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit)
 {
-	unsigned int entry = priv->cur_rx;
-	unsigned int next_entry;
+	unsigned int next_entry = priv->cur_rx;
 	unsigned int count = 0;
 	int coe = priv->hw->rx_csum;
 
@@ -2516,10 +2515,12 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
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
 			p = (struct dma_desc *)(priv->dma_erx + entry);
 		else
@@ -2584,7 +2585,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 				       priv->dev->name, frame_len,
 				       priv->dma_buf_sz);
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -2615,7 +2616,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 						dev_warn(priv->device,
 							 "packet dropped\n");
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 
 				dma_sync_single_for_cpu(priv->device,
@@ -2638,7 +2639,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 					pr_err("%s: Inconsistent Rx chain\n",
 					       priv->dev->name);
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 				prefetch(skb->data - NET_IP_ALIGN);
 				priv->rx_skbuff[entry] = NULL;
@@ -2672,7 +2673,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv);
-- 
2.19.1

