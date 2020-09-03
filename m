Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675BF25CC5F
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgICVfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:35:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33716 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728309AbgICVfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:35:39 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DFD9A600D0;
        Thu,  3 Sep 2020 21:35:38 +0000 (UTC)
Received: from us4-mdac16-38.ut7.mdlocal (unknown [10.7.66.157])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DEB048009E;
        Thu,  3 Sep 2020 21:35:38 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 623548005D;
        Thu,  3 Sep 2020 21:35:38 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F16034C0060;
        Thu,  3 Sep 2020 21:35:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep 2020
 22:35:33 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 5/6] sfc: rewrite efx_tx_may_pio
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Message-ID: <7ae8e153-49ed-5c2f-09c4-25ab0e60b8c3@solarflare.com>
Date:   Thu, 3 Sep 2020 22:35:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25642.007
X-TM-AS-Result: No-11.129200-8.000000-10
X-TMASE-MatchedRID: +0eKDNvbD445s4xK97Sm/8ZkWeHTuv2uDvc/j9oMIgWgJ1CKZ3CoSNAY
        WUo4HSIk8XVI39JCRnSjfNAVYAJRAq0iin8P0KjVPwKTD1v8YV5MkOX0UoduuZ+4ziUPq4Lxg6c
        H7aDJatZCY6mLc3Q3xdTWDiU7V0XtRGYk457itShI3TL4xxtmW8WLeiJW8Z+pvn1ivDdpAIfr7f
        jWKbC0RQcgrPmtZZiYqNhuFB/lXK/+0PrwrzfHMRYZoKAPfQ6CAKbvziCwm7jAJMh4mAwEG5AaN
        p2uvngxrpYdrzWjH/rBpVoBHc91GqF2E6v/FJwhlFSf//R6rYp9LQinZ4QefL6qvLNjDYTwmTDw
        p0zM3zoqtq5d3cxkNdpTQHOytsvtmBo9Xcygo9k1CbbnZgICbNgrdVYONZ7QpNo28YLPHb4=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.129200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25642.007
X-MDID: 1599168938-wis6Mt60J6eK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use efx_for_each_channel_tx_queue() rather than efx_tx_queue_partner().
Make some related simplifications of efx_nic_tx_is_empty() to remove
 entry points that aren't used.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/nic_common.h | 30 ++-------------------------
 drivers/net/ethernet/sfc/tx.c         | 26 ++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index 974107354087..3f88c6444fa1 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -65,8 +65,7 @@ efx_tx_desc(struct efx_tx_queue *tx_queue, unsigned int index)
 /* Report whether this TX queue would be empty for the given write_count.
  * May return false negative.
  */
-static inline bool __efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue,
-					 unsigned int write_count)
+static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue, unsigned int write_count)
 {
 	unsigned int empty_read_count = READ_ONCE(tx_queue->empty_read_count);
 
@@ -76,17 +75,6 @@ static inline bool __efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue,
 	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
 }
 
-/* Report whether the NIC considers this TX queue empty, using
- * packet_write_count (the write count recorded for the last completable
- * doorbell push).  May return false negative.  EF10 only, which is OK
- * because only EF10 supports PIO.
- */
-static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue)
-{
-	EFX_WARN_ON_ONCE_PARANOID(!tx_queue->efx->type->option_descriptors);
-	return __efx_nic_tx_is_empty(tx_queue, tx_queue->packet_write_count);
-}
-
 /* Get partner of a TX queue, seen as part of the same net core queue */
 /* XXX is this a thing on EF100? */
 static inline struct efx_tx_queue *efx_tx_queue_partner(struct efx_tx_queue *tx_queue)
@@ -97,20 +85,6 @@ static inline struct efx_tx_queue *efx_tx_queue_partner(struct efx_tx_queue *tx_
 		return tx_queue + EFX_TXQ_TYPE_OFFLOAD;
 }
 
-/* Decide whether we can use TX PIO, ie. write packet data directly into
- * a buffer on the device.  This can reduce latency at the expense of
- * throughput, so we only do this if both hardware and software TX rings
- * are empty.  This also ensures that only one packet at a time can be
- * using the PIO buffer.
- */
-static inline bool efx_nic_may_tx_pio(struct efx_tx_queue *tx_queue)
-{
-	struct efx_tx_queue *partner = efx_tx_queue_partner(tx_queue);
-
-	return tx_queue->piobuf && efx_nic_tx_is_empty(tx_queue) &&
-	       efx_nic_tx_is_empty(partner);
-}
-
 int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			bool *data_mapped);
 
@@ -125,7 +99,7 @@ int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 static inline bool efx_nic_may_push_tx_desc(struct efx_tx_queue *tx_queue,
 					    unsigned int write_count)
 {
-	bool was_empty = __efx_nic_tx_is_empty(tx_queue, write_count);
+	bool was_empty = efx_nic_tx_is_empty(tx_queue, write_count);
 
 	tx_queue->empty_read_count = 0;
 	return was_empty && tx_queue->write_count - write_count == 1;
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index b868920b680c..48d91b26f1a2 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -264,6 +264,30 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 	++tx_queue->insert_count;
 	return 0;
 }
+
+/* Decide whether we can use TX PIO, ie. write packet data directly into
+ * a buffer on the device.  This can reduce latency at the expense of
+ * throughput, so we only do this if both hardware and software TX rings
+ * are empty, including all queues for the channel.  This also ensures that
+ * only one packet at a time can be using the PIO buffer. If the xmit_more
+ * flag is set then we don't use this - there'll be another packet along
+ * shortly and we want to hold off the doorbell.
+ */
+static bool efx_tx_may_pio(struct efx_tx_queue *tx_queue)
+{
+	struct efx_channel *channel = tx_queue->channel;
+
+	if (!tx_queue->piobuf)
+		return false;
+
+	EFX_WARN_ON_ONCE_PARANOID(!channel->efx->type->option_descriptors);
+
+	efx_for_each_channel_tx_queue(tx_queue, channel)
+		if (!efx_nic_tx_is_empty(tx_queue, tx_queue->packet_write_count))
+			return false;
+
+	return true;
+}
 #endif /* EFX_USE_PIO */
 
 /* Send any pending traffic for a channel. xmit_more is shared across all
@@ -326,7 +350,7 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 			goto err;
 #ifdef EFX_USE_PIO
 	} else if (skb_len <= efx_piobuf_size && !xmit_more &&
-		   efx_nic_may_tx_pio(tx_queue)) {
+		   efx_tx_may_pio(tx_queue)) {
 		/* Use PIO for short packets with an empty queue. */
 		if (efx_enqueue_skb_pio(tx_queue, skb))
 			goto err;

