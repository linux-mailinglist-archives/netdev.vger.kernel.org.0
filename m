Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1758747DD36
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346478AbhLWBQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:32 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27320 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346235AbhLWBOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=9K23OxmeLxKKsYp1RLhSYgHLbwb5m0KZugzfOCo69HU=;
        b=bb1Vo/ue+ueORZkkzBGSWycDMJPWxoZCGqaiD2IKTAgwkfVWuJDdetlhCbDe/+VxYZOY
        u8AY4FKVaNfHgV0BSZbqgG/GcRChN4cfMlVZaJ3CrFDVooFijVU+9xvoCzEJ0ycQkNfgH1
        GVOTcpJa8V+JBWQi3V9ve/joe9qeG1+2/h0RVEgxSSVmRbY1kntR0IdlwSYO2DHGZnpUVd
        GvC4NBNvcb6VhGS0oZgQLxgIMwpvbfZ4sjAySCKvvTwq9XWHOmf/qDMt3SASwa+pIjKRrD
        bovRQVJ89AGbFKOL25UefXuABWPCoC3w5A1gZTRN7XVXd5v+39aIUWtNNy3KPp3g==
Received: by filterdrecv-656998cfdd-ptszh with SMTP id filterdrecv-656998cfdd-ptszh-1-61C3CD5E-2F
        2021-12-23 01:14:07.004679791 +0000 UTC m=+7955207.654607011
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id qGoUxNdPTmmUnBd6fUdlpA
        Thu, 23 Dec 2021 01:14:06.863 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id BC8777014EA; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 38/50] wilc1000: take advantage of chip queue
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-39-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBgZ7zOwzn4laz2B2?=
 =?us-ascii?Q?YR5jnghoHbnUyOMtWfZQXLA7QbOSeZLdzBFqeWm?=
 =?us-ascii?Q?DqHT1dKa0NWNHzFW9Kvr0mgeYzAt0icszWlHhcA?=
 =?us-ascii?Q?AvOgfxOXA1arVofiyh4w=2FJ03sKaT4fprc5tZPp9?=
 =?us-ascii?Q?Iv8SqxAGcxSnANOFC+1WlPboAKxRfpmUApSvmM?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than peeking at the access-category tx queues, move packets
scheduled for transmission onto the chip queue.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 102 +++++++++---------
 1 file changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 86b945e5ee076..eefc0d18c1b5c 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -672,74 +672,79 @@ static void set_header(struct wilc *wilc, struct sk_buff *tqe,
 }
 
 /**
- * fill_vmm_table() - Fill VMM table with packets to be sent
+ * fill_vmm_table() - fill VMM table with packets to be sent
  * @wilc: Pointer to the wilc structure.
  * @vmm_table: Pointer to the VMM table to fill.
- * @vmm_entries_ac: Pointer to the queue-number table to fill.
- *	For each packet added to the VMM table, this will be filled in
- *	with the queue-number (access-category) that the packet is coming
- *	from.
  *
  * Fill VMM table with packets waiting to be sent.  The packets are
  * added based on access category (priority) but also balanced to
  * provide fairness.
  *
- * Context: Since this function peeks at the packet queues, the
- * txq_add_to_head_cs mutex must be acquired before calling this
- * function.
- *
  * Return:
  *	The number of VMM entries filled in.  The table is 0-terminated
  *	so the returned number is at most WILC_VMM_TBL_SIZE-1.
  */
-static int fill_vmm_table(const struct wilc *wilc,
-			  u32 vmm_table[WILC_VMM_TBL_SIZE],
-			  u8 vmm_entries_ac[WILC_VMM_TBL_SIZE])
+static int fill_vmm_table(struct wilc *wilc,
+			  u32 vmm_table[WILC_VMM_TBL_SIZE])
 {
 	int i;
 	u8 k, ac;
-	u32 sum;
 	static const u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
 	u8 ac_desired_ratio[NQUEUES];
 	const u8 *num_pkts_to_add;
 	bool ac_exist = 0;
 	int vmm_sz = 0;
-	struct sk_buff *tqe_q[NQUEUES];
+	struct sk_buff *tqe;
 	struct wilc_skb_tx_cb *tx_cb;
 
-	for (ac = 0; ac < NQUEUES; ac++)
-		tqe_q[ac] = skb_peek(&wilc->txq[ac]);
-
 	i = 0;
-	sum = 0;
+
+	if (unlikely(wilc->chipq_bytes > 0)) {
+		/* fill in packets that are already on the chipq: */
+		skb_queue_walk(&wilc->chipq, tqe) {
+			tx_cb = WILC_SKB_TX_CB(tqe);
+			vmm_sz = tx_hdr_len(tx_cb->type);
+			vmm_sz += tqe->len;
+			vmm_sz = ALIGN(vmm_sz, 4);
+			vmm_table[i++] = vmm_table_entry(tqe, vmm_sz);
+		}
+	}
 
 	ac_balance(wilc, ac_desired_ratio);
 	num_pkts_to_add = ac_desired_ratio;
 	do {
 		ac_exist = 0;
 		for (ac = 0; ac < NQUEUES; ac++) {
-			if (!tqe_q[ac])
+			if (skb_queue_len(&wilc->txq[ac]) < 1)
 				continue;
 
 			ac_exist = 1;
-			for (k = 0; k < num_pkts_to_add[ac] && tqe_q[ac]; k++) {
+			for (k = 0; k < num_pkts_to_add[ac]; k++) {
 				if (i >= WILC_VMM_TBL_SIZE - 1)
 					goto out;
 
-				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
+				tqe = skb_dequeue(&wilc->txq[ac]);
+				if (!tqe)
+					continue;
+
+				tx_cb = WILC_SKB_TX_CB(tqe);
 				vmm_sz = tx_hdr_len(tx_cb->type);
-				vmm_sz += tqe_q[ac]->len;
+				vmm_sz += tqe->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
-				if (sum + vmm_sz > WILC_TX_BUFF_SIZE)
+				if (wilc->chipq_bytes + vmm_sz > WILC_TX_BUFF_SIZE) {
+					/* return packet to its queue */
+					skb_queue_head(&wilc->txq[ac], tqe);
 					goto out;
-				vmm_table[i] = vmm_table_entry(tqe_q[ac], vmm_sz);
-				vmm_entries_ac[i] = ac;
+				}
+				atomic_dec(&wilc->txq_entries);
+
+				__skb_queue_tail(&wilc->chipq, tqe);
+				wilc->chipq_bytes += tqe->len;
 
+				vmm_table[i] = vmm_table_entry(tqe, vmm_sz);
 				i++;
-				sum += vmm_sz;
-				tqe_q[ac] = skb_peek_next(tqe_q[ac],
-							  &wilc->txq[ac]);
+
 			}
 		}
 		num_pkts_to_add = ac_preserve_ratio;
@@ -837,14 +842,11 @@ static int send_vmm_table(struct wilc *wilc,
 }
 
 /**
- * copy_packets() - Copy packets to the transmit buffer
+ * copy_packets() - copy packets to the transmit buffer
  * @wilc: Pointer to the wilc structure.
- * @entries: The number of packets to send from the VMM table.
- * @vmm_table: The VMM table to send.
- * @vmm_entries_ac: Table index i contains the number of the queue to
- *	take the i-th packet from.
+ * @entries: The number of packets to copy from the chip queue.
  *
- * Copy a set of packets to the transmit buffer.
+ * Copy a number of packets to the transmit buffer.
  *
  * Context: The txq_add_to_head_cs mutex must still be held when
  * calling this function.
@@ -852,8 +854,7 @@ static int send_vmm_table(struct wilc *wilc,
  * Return: Number of bytes copied to the transmit buffer (always
  *	non-negative).
  */
-static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
-			u8 *vmm_entries_ac)
+static int copy_packets(struct wilc *wilc, int entries)
 {
 	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
 	struct wilc_skb_tx_cb *tx_cb;
@@ -867,21 +868,19 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 		struct sk_buff *tqe;
 		u32 buffer_offset;
 
-		tqe = skb_dequeue(&wilc->txq[vmm_entries_ac[i]]);
-		if (!tqe)
+		tqe = __skb_dequeue(&wilc->chipq);
+		if (WARN_ON(!tqe))
 			break;
+		wilc->chipq_bytes -= tqe->len;
 
-		atomic_dec(&wilc->txq_entries);
-		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		tx_cb = WILC_SKB_TX_CB(tqe);
-		if (vmm_table[i] == 0)
-			break;
-
-		le32_to_cpus(&vmm_table[i]);
-		vmm_sz = FIELD_GET(WILC_VMM_BUFFER_SIZE, vmm_table[i]);
-		vmm_sz *= 4;
+		ac_pkt_num_to_chip[tx_cb->q_num]++;
 
 		buffer_offset = tx_hdr_len(tx_cb->type);
+		vmm_sz = buffer_offset;
+		vmm_sz += tqe->len;
+		vmm_sz = ALIGN(vmm_sz, 4);
+
 		set_header(wilc, tqe, vmm_sz, txb + offset);
 		memcpy(&txb[offset + buffer_offset], tqe->data, tqe->len);
 		offset += vmm_sz;
@@ -916,13 +915,11 @@ static int send_packets(struct wilc *wilc, int len)
 	return func->hif_block_tx_ext(wilc, 0, wilc->tx_buffer, len);
 }
 
-static int copy_and_send_packets(struct wilc *wilc, int entries,
-				 u32 vmm_table[WILC_VMM_TBL_SIZE],
-				 u8 vmm_entries_ac[WILC_VMM_TBL_SIZE])
+static int copy_and_send_packets(struct wilc *wilc, int entries)
 {
 	int len, ret;
 
-	len = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
+	len = copy_packets(wilc, entries);
 	if (len <= 0)
 		return len;
 
@@ -935,7 +932,6 @@ static int copy_and_send_packets(struct wilc *wilc, int entries,
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 {
 	int vmm_table_len, entries;
-	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
 	int ret = 0;
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
 	int srcu_idx;
@@ -951,7 +947,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		wilc_wlan_txq_filter_dup_tcp_ack(vif->ndev);
 	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
-	vmm_table_len = fill_vmm_table(wilc, vmm_table, vmm_entries_ac);
+	vmm_table_len = fill_vmm_table(wilc, vmm_table);
 	if (vmm_table_len == 0)
 		goto out_unlock;
 
@@ -966,7 +962,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (entries <= 0) {
 		ret = entries;
 	} else {
-		ret = copy_and_send_packets(wilc, entries, vmm_table, vmm_entries_ac);
+		ret = copy_and_send_packets(wilc, entries);
 	}
 	if (ret >= 0 && entries < vmm_table_len)
 		ret = WILC_VMM_ENTRY_FULL_RETRY;
-- 
2.25.1

