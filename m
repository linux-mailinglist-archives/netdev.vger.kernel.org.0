Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC18F2AB27D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgKIIek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:34:40 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:41909 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729438AbgKIIej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:34:39 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A98XwJd010868;
        Mon, 9 Nov 2020 00:34:25 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v5 08/12] ch_ktls: packet handling prior to start marker
Date:   Mon,  9 Nov 2020 14:03:52 +0530
Message-Id: <20201109083356.11117-9-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109083356.11117-1-rohitm@chelsio.com>
References: <20201109083356.11117-1-rohitm@chelsio.com>
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
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 38 ++++++++++++++++---
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 026c66599d1e..bbda71b7f98b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1909,11 +1909,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto out;
 		}
 
-		if (unlikely(tls_record_is_start_marker(record))) {
-			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
-			atomic64_inc(&port_stats->ktls_tx_skip_no_sync_data);
-			goto out;
-		}
 		tls_end_offset = record->end_seq - tcp_seq;
 
 		pr_debug("seq 0x%x, end_seq 0x%x prev_seq 0x%x, datalen 0x%x\n",
@@ -1938,6 +1933,39 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 				goto out;
 			}
 		}
+
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
+						    tx_info->port_id, NULL,
+						    tls_end_offset, skb_offset,
+						    0);
+
+			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
+			if (ret) {
+				/* free the refcount taken earlier */
+				if (tls_end_offset < data_len)
+					dev_kfree_skb_any(skb);
+				goto out;
+			}
+
+			data_len -= tls_end_offset;
+			tcp_seq = record->end_seq;
+			skb_offset += tls_end_offset;
+			continue;
+		}
+
 		/* increase page reference count of the record, so that there
 		 * won't be any chance of page free in middle if in case stack
 		 * receives ACK and try to delete the record.
-- 
2.18.1

