Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA484177C28
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgCCQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:42:43 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47962 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729335AbgCCQmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:42:43 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1613C4C0059;
        Tue,  3 Mar 2020 16:42:40 +0000 (UTC)
Received: from [10.17.20.221] (10.17.20.221) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 3 Mar 2020
 16:42:35 +0000
From:   Tom Zhao <tzhao@solarflare.com>
Subject: [PATCH net-next v2] sfc: complete the next packet when we receive a
 timestamp
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <scrum-linux@solarflare.com>
Message-ID: <be473840-506f-29f2-b373-a2aa829091c3@solarflare.com>
Date:   Tue, 3 Mar 2020 16:42:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.221]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25266.003
X-TM-AS-Result: No-6.746300-8.000000-10
X-TMASE-MatchedRID: vFHe2GnEhBgqYYRg3clvBqo2fOuRT7aab1d/zpzApVqk3COeFIImbVOb
        R+eKTMWbnbBGF6l7a+27hw59i5efeNvRJLD/GixsddPPQcdMrYUA+JHhu0IR5mMunwKby/AXCh5
        FGEJlYgHJ/hRSI+YUuoo243wxl3VEIeFIFB+CV+wD2WXLXdz+AWcCy3wC35zdRjHvrQ40NxYeXV
        AMcD8vuXrQAdigWROjCrlTCdJM65G5rzEqaXlmzVtTO+xodboGAp+UH372RZW8rUtbtWe8+jDHx
        nr5pBtw0fh0NNTQxKqt8/SSH+XT0vJrU+I+8hTAKrDHzH6zmUUvV5f7P0HVDKjxqhyDxmYjfT1m
        V/nu2fPryF/mQs3+JkBggEfJoaepkquk8+1EFNtWfOVCJoTbWmf6wD367VgtlwFBEZ/7LUPZULV
        BYooo+v9OXONwzM4oyqZz22qm4DmRehYFOG64KOn1HxC6hVB/BGvINcfHqheExk6c4qzx8qnmO7
        xAT+YkYFJmL4S5TwZI8zQSH9zPCm1A5vznb2t5ZacDbE73ZSlC3iRApcRQCsAkyHiYDAQbsKFvJ
        aID/xTyMlKSI9bURZGTpe1iiCJqb5ic6rRyh48LbigRnpKlKWxlRJiH43975mMMtIsbYMh1ZBma
        BpsTO2XOjPWVoum6Du7FFBSExmT5Zh4ZAndGLA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.746300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25266.003
X-MDID: 1583253762-nZwOlXzgkNJY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We now ignore the "completion" event when using tx queue timestamping, and only
pay attention to the two (high and low) timestamp events. The NIC will send a
pair of timestamp events for every packet transmitted. The current firmware may
merge the completion events, and it is possible that future versions may
reorder the completion and timestamp events. As such the completion event is
not useful.

Without this patch in place a merged completion event on a queue with
timestamping will cause a "spurious TX completion" error.

Signed-off-by: Tom Zhao <tzhao@solarflare.com>
---
v2: apply to correct head
---
 drivers/net/ethernet/sfc/ef10.c       | 36 ++++++++++---------
 drivers/net/ethernet/sfc/efx.h        |  1 +
 drivers/net/ethernet/sfc/net_driver.h |  3 --
 drivers/net/ethernet/sfc/tx.c         | 68 +++++++++++++++++++++++++++++------
 4 files changed, 77 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4d9bbcc..984de5c 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3713,11 +3713,24 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
 	}
 
 	/* Transmit timestamps are only available for 8XXX series. They result
-	 * in three events per packet. These occur in order, and are:
-	 *  - the normal completion event
+	 * in up to three events per packet. These occur in order, and are:
+	 *  - the normal completion event (may be omitted)
 	 *  - the low part of the timestamp
 	 *  - the high part of the timestamp
 	 *
+	 * It's possible for multiple completion events to appear before the
+	 * corresponding timestamps. So we can for example get:
+	 *  COMP N
+	 *  COMP N+1
+	 *  TS_LO N
+	 *  TS_HI N
+	 *  TS_LO N+1
+	 *  TS_HI N+1
+	 *
+	 * In addition it's also possible for the adjacent completions to be
+	 * merged, so we may not see COMP N above. As such, the completion
+	 * events are not very useful here.
+	 *
 	 * Each part of the timestamp is itself split across two 16 bit
 	 * fields in the event.
 	 */
@@ -3725,18 +3738,8 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
 
 	switch (tx_ev_type) {
 	case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
-		/* In case of Queue flush or FLR, we might have received
-		 * the previous TX completion event but not the Timestamp
-		 * events.
-		 */
-		if (tx_queue->completed_desc_ptr != tx_queue->ptr_mask)
-			efx_xmit_done(tx_queue, tx_queue->completed_desc_ptr);
-
-		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event,
-						 ESF_DZ_TX_DESCR_INDX);
-		tx_queue->completed_desc_ptr =
-					tx_ev_desc_ptr & tx_queue->ptr_mask;
-		break;
+		/* Ignore this event - see above. */
+        break;
 
 	case TX_TIMESTAMP_EVENT_TX_EV_TSTAMP_LO:
 		ts_part = efx_ef10_extract_event_ts(event);
@@ -3747,9 +3750,8 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
 		ts_part = efx_ef10_extract_event_ts(event);
 		tx_queue->completed_timestamp_major = ts_part;
 
-		efx_xmit_done(tx_queue, tx_queue->completed_desc_ptr);
-		tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
-		break;
+		efx_xmit_done_single(tx_queue);
+        break;
 
 	default:
 		netif_err(efx, hw, efx->net_dev,
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 2dd8d50..dc1c375 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -24,6 +24,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *net_dev);
 netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
+void efx_xmit_done_single(struct efx_tx_queue *tx_queue);
 int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 		 void *type_data);
 unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index dfd5182..d6e3115 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -207,8 +207,6 @@ struct efx_tx_buffer {
  *	avoid cache-line ping-pong between the xmit path and the
  *	completion path.
  * @merge_events: Number of TX merged completion events
- * @completed_desc_ptr: Most recent completed pointer - only used with
- *      timestamping.
  * @completed_timestamp_major: Top part of the most recent tx timestamp.
  * @completed_timestamp_minor: Low part of the most recent tx timestamp.
  * @insert_count: Current insert pointer
@@ -268,7 +266,6 @@ struct efx_tx_queue {
 	unsigned int merge_events;
 	unsigned int bytes_compl;
 	unsigned int pkts_compl;
-	unsigned int completed_desc_ptr;
 	u32 completed_timestamp_major;
 	u32 completed_timestamp_minor;
 
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 00c1c44..a23a3ca 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -687,6 +687,11 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	return i;
 }
 
+static bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
+{
+	return buffer->len || (buffer->flags & EFX_TX_BUF_OPTION);
+}
+
 /* Remove packets from the TX queue
  *
  * This removes packets from the TX queue, up to and including the
@@ -706,10 +711,9 @@ static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
 	while (read_ptr != stop_index) {
 		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
 
-		if (!(buffer->flags & EFX_TX_BUF_OPTION) &&
-		    unlikely(buffer->len == 0)) {
+		if (!efx_tx_buffer_in_use(buffer)) {
 			netif_err(efx, tx_err, efx->net_dev,
-				  "TX queue %d spurious TX completion id %x\n",
+				  "TX queue %d spurious TX completion id %d\n",
 				  tx_queue->queue, read_ptr);
 			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
 			return;
@@ -835,6 +839,18 @@ int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 	return 0;
 }
 
+static void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
+{
+	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
+		tx_queue->old_write_count = ACCESS_ONCE(tx_queue->write_count);
+		if (tx_queue->read_count == tx_queue->old_write_count) {
+			smp_mb();
+			tx_queue->empty_read_count =
+				tx_queue->read_count | EFX_EMPTY_COUNT_VALID;
+		}
+	}
+}
+
 void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 {
 	unsigned fill_level;
@@ -866,15 +882,46 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 			netif_tx_wake_queue(tx_queue->core_txq);
 	}
 
-	/* Check whether the hardware queue is now empty */
-	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
-		tx_queue->old_write_count = READ_ONCE(tx_queue->write_count);
-		if (tx_queue->read_count == tx_queue->old_write_count) {
-			smp_mb();
-			tx_queue->empty_read_count =
-				tx_queue->read_count | EFX_EMPTY_COUNT_VALID;
+	efx_xmit_done_check_empty(tx_queue);
+}
+
+void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
+{
+	unsigned int pkts_compl = 0, bytes_compl = 0;
+	unsigned int read_ptr;
+	bool finished = false;
+
+	read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
+
+	while (!finished) {
+		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
+
+		if (!efx_tx_buffer_in_use(buffer)) {
+			struct efx_nic *efx = tx_queue->efx;
+
+			netif_err(efx, hw, efx->net_dev,
+				  "TX queue %d spurious single TX completion\n",
+				  tx_queue->queue);
+			atomic_inc(&efx->errors.spurious_tx);
+			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
+			return;
 		}
+
+		/* Need to check the flag before dequeueing. */
+		if (buffer->flags & EFX_TX_BUF_SKB)
+			finished = true;
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+
+		++tx_queue->read_count;
+		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
 	}
+
+	tx_queue->pkts_compl += pkts_compl;
+	tx_queue->bytes_compl += bytes_compl;
+
+	EFX_WARN_ON_PARANOID(pkts_compl != 1);
+
+	efx_xmit_done_check_empty(tx_queue);
 }
 
 static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)
@@ -943,7 +990,6 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->xmit_more_available = false;
 	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
 				  tx_queue->channel == efx_ptp_channel(efx));
-	tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
 	tx_queue->completed_timestamp_major = 0;
 	tx_queue->completed_timestamp_minor = 0;
 
-- 
1.8.3.1

