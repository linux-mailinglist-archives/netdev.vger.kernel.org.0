Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC763603B2
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhDOHtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:49:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:28667 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhDOHtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:49:11 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13F7mBm1023347;
        Thu, 15 Apr 2021 00:48:43 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 4/4] ch_ktls: do not send snd_una update to TCB in middle
Date:   Thu, 15 Apr 2021 13:17:48 +0530
Message-Id: <20210415074748.421098-5-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415074748.421098-1-vinay.yadav@chelsio.com>
References: <20210415074748.421098-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

snd_una update should not be done when the same skb is being
sent out.chcr_short_record_handler() sends it again even
though SND_UNA update is already sent for the skb in
chcr_ktls_xmit(), which causes mismatch in un-acked
TCP seq number, later causes problem in sending out
complete record.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 53 -------------------
 1 file changed, 53 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 8559eec161f0..a3f5b80888e5 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1644,54 +1644,6 @@ static void chcr_ktls_copy_record_in_skb(struct sk_buff *nskb,
 	refcount_add(nskb->truesize, &nskb->sk->sk_wmem_alloc);
 }
 
-/*
- * chcr_ktls_update_snd_una:  Reset the SEND_UNA. It will be done to avoid
- * sending the same segment again. It will discard the segment which is before
- * the current tx max.
- * @tx_info - driver specific tls info.
- * @q - TX queue.
- * return: NET_TX_OK/NET_XMIT_DROP.
- */
-static int chcr_ktls_update_snd_una(struct chcr_ktls_info *tx_info,
-				    struct sge_eth_txq *q)
-{
-	struct fw_ulptx_wr *wr;
-	unsigned int ndesc;
-	int credits;
-	void *pos;
-	u32 len;
-
-	len = sizeof(*wr) + roundup(CHCR_SET_TCB_FIELD_LEN, 16);
-	ndesc = DIV_ROUND_UP(len, 64);
-
-	credits = chcr_txq_avail(&q->q) - ndesc;
-	if (unlikely(credits < 0)) {
-		chcr_eth_txq_stop(q);
-		return NETDEV_TX_BUSY;
-	}
-
-	pos = &q->q.desc[q->q.pidx];
-
-	wr = pos;
-	/* ULPTX wr */
-	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
-	wr->cookie = 0;
-	/* fill len in wr field */
-	wr->flowid_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
-
-	pos += sizeof(*wr);
-
-	pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
-					 TCB_SND_UNA_RAW_W,
-					 TCB_SND_UNA_RAW_V(TCB_SND_UNA_RAW_M),
-					 TCB_SND_UNA_RAW_V(0), 0);
-
-	chcr_txq_advance(&q->q, ndesc);
-	cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
-
-	return 0;
-}
-
 /*
  * chcr_end_part_handler: This handler will handle the record which
  * is complete or if record's end part is received. T6 adapter has a issue that
@@ -1892,11 +1844,6 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 			/* reset tcp_seq as per the prior_data_required len */
 			tcp_seq -= prior_data_len;
 		}
-		/* reset snd una, so the middle record won't send the already
-		 * sent part.
-		 */
-		if (chcr_ktls_update_snd_una(tx_info, q))
-			goto out;
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_middle_pkts);
 	} else {
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_start_pkts);
-- 
2.30.2

