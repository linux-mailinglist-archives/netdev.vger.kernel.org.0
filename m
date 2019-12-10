Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BBF118EB4
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLJROL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:14:11 -0500
Received: from alln-iport-5.cisco.com ([173.37.142.92]:18369 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfLJROL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:14:11 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2019 12:14:10 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2536; q=dns/txt; s=iport;
  t=1575998050; x=1577207650;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2UHhr3j7cOLUCeUZGeM0BsDKwuIN5yLjUryPAGTJU98=;
  b=XqLmKw4AUxxPXWOi2nSgVb9ujcFFQ76P7GclRYMfgdJMyYFJ+CI78skp
   lmo13uvExGN4ZtEWZNHqcfXVWum5PRdHZ0TXnY0GGYp1IPVWWlu3UsEhX
   Nv8kQxrmk/VegI/K/huOD+Ocgl4QMJdep7+E8Ym6HC9eJv6P9PfvVgodr
   U=;
X-IronPort-AV: E=Sophos;i="5.69,300,1571702400"; 
   d="scan'208";a="387584882"
Received: from alln-core-12.cisco.com ([173.36.13.134])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 10 Dec 2019 17:07:05 +0000
Received: from sjc-ads-7483.cisco.com (sjc-ads-7483.cisco.com [10.30.221.19])
        by alln-core-12.cisco.com (8.15.2/8.15.2) with ESMTP id xBAH741D012009;
        Tue, 10 Dec 2019 17:07:04 GMT
Received: by sjc-ads-7483.cisco.com (Postfix, from userid 838444)
        id C6974FAD; Tue, 10 Dec 2019 09:07:03 -0800 (PST)
From:   Aviraj CJ <acj@cisco.com>
To:     peppe.cavallaro@st.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, xe-linux-external@cisco.com
Cc:     Aviraj CJ <acj@cisco.com>
Subject: [PATCH 2/2] net: stmmac: don't stop NAPI processing when dropping a packet
Date:   Tue, 10 Dec 2019 09:06:59 -0800
Message-Id: <20191210170659.61829-2-acj@cisco.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191210170659.61829-1-acj@cisco.com>
References: <20191210170659.61829-1-acj@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.30.221.19, sjc-ads-7483.cisco.com
X-Outbound-Node: alln-core-12.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if we drop a packet, we exit from NAPI loop before the budget
is consumed. In some situations this will make the RX processing stall
e.g. when flood pinging the system with oversized packets, as the
errorneous packets are not dropped efficiently.

If we drop a packet, we should just continue to the next one as long as
the budget allows.

[ Adopted based on upstream commit 2170bbf19f6ef6b2740f186ee107827f31395218
("net: stmmac: don't stop NAPI processing when dropping a packet")
by Aaro Koskinen <aaro.koskinen@nokia.com> ]

Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e9d41e03121c..3b514ba570b8 100644
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
 
@@ -2191,6 +2190,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 	while (count < limit) {
 		int status;
 		struct dma_desc *p;
+		unsigned int entry;
+
+		entry = next_entry;
 
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(priv->dma_erx + entry);
@@ -2239,7 +2241,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 			/*  check if frame_len fits the preallocated memory */
 			if (frame_len > priv->dma_buf_sz) {
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -2260,7 +2262,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 				pr_err("%s: Inconsistent Rx descriptor chain\n",
 				       priv->dev->name);
 				priv->dev->stats.rx_dropped++;
-				break;
+				continue;
 			}
 			prefetch(skb->data - NET_IP_ALIGN);
 			priv->rx_skbuff[entry] = NULL;
@@ -2291,7 +2293,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit)
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv);
-- 
2.19.1

