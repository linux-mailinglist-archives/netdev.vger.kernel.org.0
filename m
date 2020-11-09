Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859F42AB577
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgKIKwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:52:51 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:50268 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbgKIKwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:52:50 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A9AqQMf011444;
        Mon, 9 Nov 2020 02:52:46 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v6 06/12] ch_ktls: missing handling of header alone
Date:   Mon,  9 Nov 2020 16:21:36 +0530
Message-Id: <20201109105142.15398-7-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109105142.15398-1-rohitm@chelsio.com>
References: <20201109105142.15398-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an skb has only header part which doesn't start from
beginning, is not being handled properly.

Fixes: dc05f3df8fac ("chcr: Handle first or middle part of record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 4286decce095..8a54fce9bfae 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1744,6 +1744,17 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_trimmed_pkts);
 	}
 
+	/* check if it is only the header part. */
+	if (tls_rec_offset + data_len <= (TLS_HEADER_SIZE + tx_info->iv_size)) {
+		if (chcr_ktls_tx_plaintxt(tx_info, skb, tcp_seq, mss,
+					  tcp_push_no_fin, q,
+					  tx_info->port_id, prior_data,
+					  data_len, skb_offset, prior_data_len))
+			goto out;
+
+		return 0;
+	}
+
 	/* check if the middle record's start point is 16 byte aligned. CTR
 	 * needs 16 byte aligned start point to start encryption.
 	 */
@@ -1812,20 +1823,6 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 			goto out;
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_middle_pkts);
 	} else {
-		/* Else means, its a partial first part of the record. Check if
-		 * its only the header, don't need to send for encryption then.
-		 */
-		if (data_len <= TLS_HEADER_SIZE + tx_info->iv_size) {
-			if (chcr_ktls_tx_plaintxt(tx_info, skb, tcp_seq, mss,
-						  tcp_push_no_fin, q,
-						  tx_info->port_id,
-						  prior_data,
-						  data_len, skb_offset,
-						  prior_data_len)) {
-				goto out;
-			}
-			return 0;
-		}
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_start_pkts);
 	}
 
-- 
2.18.1

