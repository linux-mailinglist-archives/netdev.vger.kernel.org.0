Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFA12A0D0C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgJ3SDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:03:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:3118 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgJ3SDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:03:13 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UI2Sv1020754;
        Fri, 30 Oct 2020 11:03:09 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v4 07/10] ch_ktls: packet handling prior to start marker
Date:   Fri, 30 Oct 2020 23:32:22 +0530
Message-Id: <20201030180225.11089-8-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201030180225.11089-1-rohitm@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There could be a case where ACK for tls exchanges prior to start
marker is missed out, and by the time tls is offloaded. This pkt
should not be discarded and handled carefully. It could be
plaintext alone or plaintext + finish as well.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 36 +++++++++++++++----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 2c92ded79b49..06a22813f466 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1828,12 +1828,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto out;
 		}
 
-		if (unlikely(tls_record_is_start_marker(record))) {
-			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
-			atomic64_inc(&port_stats->ktls_tx_skip_no_sync_data);
-			goto out;
-		}
-
 		tls_end_offset = record->end_seq - tcp_seq;
 
 		pr_debug("seq %#x, start %#x end %#x prev %#x, datalen %d offset %d\n",
@@ -1877,6 +1871,36 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 				skb_get(skb);
 		}
 
+		if (unlikely(tls_record_is_start_marker(record))) {
+			atomic64_inc(&port_stats->ktls_tx_skip_no_sync_data);
+			/* If tls_end_offset < data_len, means there is some
+			 * data after start marker, which needs encryption, send
+			 * plaintext first and take skb refcount. else send out
+			 * complete pkt as plaintext.
+			 */
+			if (tls_end_offset < data_len)
+				skb_get(skb);
+			else
+				tls_end_offset = data_len;
+
+			ret = chcr_ktls_tx_plaintxt(tx_info, skb, tcp_seq, mss,
+						    (!th->fin && th->psh), q,
+						    tls_end_offset, skb_offset);
+			if (ret) {
+				/* free the refcount taken earlier */
+				if (tls_end_offset < data_len)
+					dev_kfree_skb_any(skb);
+				spin_unlock_irqrestore(&tx_ctx->base.lock,
+						       flags);
+				goto out;
+			}
+
+			data_len -= tls_end_offset;
+			tcp_seq = record->end_seq;
+			skb_offset += tls_end_offset;
+			continue;
+		}
+
 		/* if a tls record is finishing in this SKB */
 		if (tls_end_offset <= data_len) {
 			ret = chcr_end_part_handler(tx_info, skb, record,
-- 
2.18.1

