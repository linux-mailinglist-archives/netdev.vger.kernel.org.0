Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0563603AF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhDOHsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:48:55 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:14850 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhDOHsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:48:54 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13F7mBlw023347;
        Thu, 15 Apr 2021 00:48:23 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 1/4] ch_ktls: Fix kernel panic
Date:   Thu, 15 Apr 2021 13:17:45 +0530
Message-Id: <20210415074748.421098-2-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415074748.421098-1-vinay.yadav@chelsio.com>
References: <20210415074748.421098-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taking page refcount is not ideal and causes kernel panic
sometimes. It's better to take tx_ctx lock for the complete
skb transmit, to avoid page cleanup if ACK received in middle.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 24 ++++---------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 1115b8f9ea4e..e39fa0940367 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -2010,12 +2010,11 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * we will send the complete record again.
 	 */
 
+	spin_lock_irqsave(&tx_ctx->base.lock, flags);
+
 	do {
-		int i;
 
 		cxgb4_reclaim_completed_tx(adap, &q->q, true);
-		/* lock taken */
-		spin_lock_irqsave(&tx_ctx->base.lock, flags);
 		/* fetch the tls record */
 		record = tls_get_record(&tx_ctx->base, tcp_seq,
 					&tx_info->record_no);
@@ -2074,11 +2073,11 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 						    tls_end_offset, skb_offset,
 						    0);
 
-			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 			if (ret) {
 				/* free the refcount taken earlier */
 				if (tls_end_offset < data_len)
 					dev_kfree_skb_any(skb);
+				spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 				goto out;
 			}
 
@@ -2088,16 +2087,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			continue;
 		}
 
-		/* increase page reference count of the record, so that there
-		 * won't be any chance of page free in middle if in case stack
-		 * receives ACK and try to delete the record.
-		 */
-		for (i = 0; i < record->num_frags; i++)
-			__skb_frag_ref(&record->frags[i]);
-		/* lock cleared */
-		spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
-
-
 		/* if a tls record is finishing in this SKB */
 		if (tls_end_offset <= data_len) {
 			ret = chcr_end_part_handler(tx_info, skb, record,
@@ -2122,13 +2111,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			data_len = 0;
 		}
 
-		/* clear the frag ref count which increased locally before */
-		for (i = 0; i < record->num_frags; i++) {
-			/* clear the frag ref count */
-			__skb_frag_unref(&record->frags[i]);
-		}
 		/* if any failure, come out from the loop. */
 		if (ret) {
+			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 			if (th->fin)
 				dev_kfree_skb_any(skb);
 
@@ -2143,6 +2128,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	} while (data_len > 0);
 
+	spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 	atomic64_inc(&port_stats->ktls_tx_encrypted_packets);
 	atomic64_add(skb_data_len, &port_stats->ktls_tx_encrypted_bytes);
 
-- 
2.30.2

