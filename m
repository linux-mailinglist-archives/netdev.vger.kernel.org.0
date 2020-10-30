Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1C22A0CC2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgJ3RrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:47:25 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:59964 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3RrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:47:24 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UHl9pO020669;
        Fri, 30 Oct 2020 10:47:19 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v3 02/10] ch_ktls: Correction in finding correct length
Date:   Fri, 30 Oct 2020 23:17:00 +0530
Message-Id: <20201030174708.9578-3-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201030174708.9578-1-rohitm@chelsio.com>
References: <20201030174708.9578-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possibility of linear skbs coming in. Correcting
the length extraction logic.

v2->v3:
- Separated un-related changes from this patch.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c     | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 43c723c72c61..447aec7ae954 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -967,7 +967,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	/* packet length = eth hdr len + ip hdr len + tcp hdr len
 	 * (including options).
 	 */
-	pktlen = skb->len - skb->data_len;
+	pktlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
 
 	ctrl = sizeof(*cpl) + pktlen;
 	len16 = DIV_ROUND_UP(sizeof(*wr) + ctrl, 16);
@@ -1860,6 +1860,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 /* nic tls TX handler */
 static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	u32 tls_end_offset, tcp_seq, skb_data_len, skb_offset;
 	struct ch_ktls_port_stats_debug *port_stats;
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
 	struct ch_ktls_stats_debug *stats;
@@ -1867,7 +1868,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	int data_len, qidx, ret = 0, mss;
 	struct tls_record_info *record;
 	struct chcr_ktls_info *tx_info;
-	u32 tls_end_offset, tcp_seq;
 	struct tls_context *tls_ctx;
 	struct sk_buff *local_skb;
 	struct sge_eth_txq *q;
@@ -1875,8 +1875,11 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 
 	tcp_seq = ntohl(th->seq);
+	skb_offset = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	skb_data_len = skb->len - skb_offset;
+	data_len = skb_data_len;
 
-	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : skb->data_len;
+	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : data_len;
 
 	tls_ctx = tls_get_ctx(skb->sk);
 	if (unlikely(tls_ctx->netdev != dev))
@@ -1922,8 +1925,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* copy skb contents into local skb */
 	chcr_ktls_skb_copy(skb, local_skb);
 
-	/* go through the skb and send only one record at a time. */
-	data_len = skb->data_len;
 	/* TCP segments can be in received either complete or partial.
 	 * chcr_end_part_handler will handle cases if complete record or end
 	 * part of the record is received. Incase of partial end part of record,
@@ -2020,9 +2021,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	} while (data_len > 0);
 
-	tx_info->prev_seq = ntohl(th->seq) + skb->data_len;
+	tx_info->prev_seq = ntohl(th->seq) + skb_data_len;
 	atomic64_inc(&port_stats->ktls_tx_encrypted_packets);
-	atomic64_add(skb->data_len, &port_stats->ktls_tx_encrypted_bytes);
+	atomic64_add(skb_data_len, &port_stats->ktls_tx_encrypted_bytes);
 
 	/* tcp finish is set, send a separate tcp msg including all the options
 	 * as well.
-- 
2.18.1

