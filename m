Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C5812244C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 06:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfLQFws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 00:52:48 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:51448 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfLQFwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 00:52:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2634; q=dns/txt; s=iport;
  t=1576561966; x=1577771566;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=bGXWBeyhHcB2dqzyzM3uIDWKAkmJQndzdgQJb340dK0=;
  b=f5Stb8/e1F2jR6L4YJu29ElkYdxFBgjAdwy+Tvau362FLS80mrxvSSkD
   zEQcGnhZP3G+9YF57lQWpdE7uoZjJY23yF2xe70LzjL04C3KhuKv8nTx3
   WFQeeo/Z59643k3ygOX4ky6OPuDxqHfF+ojeN3Ag00muTLWoQKBkdHDrK
   s=;
X-IronPort-AV: E=Sophos;i="5.69,324,1571702400"; 
   d="scan'208";a="686174188"
Received: from rcdn-core-2.cisco.com ([173.37.93.153])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Dec 2019 05:52:46 +0000
Received: from sjc-ads-7483.cisco.com (sjc-ads-7483.cisco.com [10.30.221.19])
        by rcdn-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id xBH5qjqo030490;
        Tue, 17 Dec 2019 05:52:46 GMT
Received: by sjc-ads-7483.cisco.com (Postfix, from userid 838444)
        id ACFE8128F; Mon, 16 Dec 2019 21:52:45 -0800 (PST)
From:   Aviraj CJ <acj@cisco.com>
To:     peppe.cavallaro@st.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, xe-linux-external@cisco.com, acj@cisco.com
Subject: [PATCH stable v4.4 2/2] net: stmmac: don't stop NAPI processing when dropping a packet
Date:   Mon, 16 Dec 2019 21:52:28 -0800
Message-Id: <20191217055228.57282-2-acj@cisco.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191217055228.57282-1-acj@cisco.com>
References: <20191217055228.57282-1-acj@cisco.com>
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
[acj: backport v4.4 -stable
-adjust context]
Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e9d41e03121c..28a6b7764044 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2176,8 +2176,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv)
 static int stmmac_rx(struct stmmac_priv *priv, int limit)
 {
 	unsigned int rxsize = priv->dma_rx_size;
-	unsigned int entry = priv->cur_rx % rxsize;
-	unsigned int next_entry;
+	unsigned int next_entry = priv->cur_rx % rxsize;
 	unsigned int count = 0;
 	int coe = priv->hw->rx_csum;
 
@@ -2189,9 +2188,11 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 			stmmac_display_ring((void *)priv->dma_rx, rxsize, 0);
 	}
 	while (count < limit) {
-		int status;
+		int status, entry;
 		struct dma_desc *p;
 
+		entry = next_entry;
+
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(priv->dma_erx + entry);
 		else
@@ -2239,7 +2240,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 			/*  check if frame_len fits the preallocated memory */
 			if (frame_len > priv->dma_buf_sz) {
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -2260,7 +2261,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 				pr_err("%s: Inconsistent Rx descriptor chain\n",
 				       priv->dev->name);
 				priv->dev->stats.rx_dropped++;
-				break;
+				continue;
 			}
 			prefetch(skb->data - NET_IP_ALIGN);
 			priv->rx_skbuff[entry] = NULL;
@@ -2291,7 +2292,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv);
-- 
2.19.1

