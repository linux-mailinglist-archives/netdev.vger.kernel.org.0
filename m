Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572E719243B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgCYJfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:35:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727285AbgCYJfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:35:19 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P9Y4TR087551
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:18 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbthr6ms-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:18 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 25 Mar 2020 09:35:13 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Mar 2020 09:35:09 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02P9ZAtt54919404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 09:35:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AACE4A405B;
        Wed, 25 Mar 2020 09:35:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FE9FA4055;
        Wed, 25 Mar 2020 09:35:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Mar 2020 09:35:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net-next 08/11] s390/qeth: add TX IRQ coalescing support for IQD devices
Date:   Wed, 25 Mar 2020 10:35:04 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325093507.20831-1-jwi@linux.ibm.com>
References: <20200325093507.20831-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032509-0008-0000-0000-000003638B59
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032509-0009-0000-0000-00004A84FA88
Message-Id: <20200325093507.20831-9-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since IQD devices complete (most of) their transmissions synchronously,
they don't offer TX completion IRQs and have no HW coalescing controls.
But we can fake the easy parts in SW, and give the user some control wrt
to how often the TX NAPI code should be triggered to process the TX
completions.

Having per-queue controls can in particular help the dedicated mcast
queue, as it likely benefits from different fine-tuning than what the
ucast queues need.

CC: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 15 ++++---
 drivers/s390/net/qeth_core_main.c | 20 +++++++--
 drivers/s390/net/qeth_ethtool.c   | 75 +++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f56670bfcd0a..a6553e78af08 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -459,6 +459,7 @@ struct qeth_out_q_stats {
 	u64 packing_mode_switch;
 	u64 stopped;
 	u64 doorbell;
+	u64 coal_frames;
 	u64 completion_yield;
 	u64 completion_timer;
 
@@ -469,6 +470,8 @@ struct qeth_out_q_stats {
 	u64 tx_dropped;
 };
 
+#define QETH_TX_MAX_COALESCED_FRAMES	1
+#define QETH_TX_COALESCE_USECS		25
 #define QETH_TX_TIMER_USECS		500
 
 struct qeth_qdio_out_q {
@@ -492,9 +495,13 @@ struct qeth_qdio_out_q {
 	struct napi_struct napi;
 	struct timer_list timer;
 	struct qeth_hdr *prev_hdr;
+	unsigned int coalesced_frames;
 	u8 bulk_start;
 	u8 bulk_count;
 	u8 bulk_max;
+
+	unsigned int coalesce_usecs;
+	unsigned int max_coalesced_frames;
 };
 
 #define qeth_for_each_output_queue(card, q, i)		\
@@ -503,12 +510,10 @@ struct qeth_qdio_out_q {
 
 #define	qeth_napi_to_out_queue(n) container_of(n, struct qeth_qdio_out_q, napi)
 
-static inline void qeth_tx_arm_timer(struct qeth_qdio_out_q *queue)
+static inline void qeth_tx_arm_timer(struct qeth_qdio_out_q *queue,
+				     unsigned long usecs)
 {
-	if (timer_pending(&queue->timer))
-		return;
-	mod_timer(&queue->timer, usecs_to_jiffies(QETH_TX_TIMER_USECS) +
-				 jiffies);
+	timer_reduce(&queue->timer, usecs_to_jiffies(usecs) + jiffies);
 }
 
 static inline bool qeth_out_queue_is_full(struct qeth_qdio_out_q *queue)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 108dd9a34f30..0c9f1464a778 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2404,6 +2404,8 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		queue->card = card;
 		queue->queue_no = i;
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
+		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
+		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
 
 		/* give outbound qeth_qdio_buffers their qdio_buffers */
 		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
@@ -2762,6 +2764,7 @@ static int qeth_init_qdio_queues(struct qeth_card *card)
 		queue->next_buf_to_fill = 0;
 		queue->do_pack = 0;
 		queue->prev_hdr = NULL;
+		queue->coalesced_frames = 0;
 		queue->bulk_start = 0;
 		queue->bulk_count = 0;
 		queue->bulk_max = qeth_tx_select_bulk_max(card, queue);
@@ -3357,6 +3360,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		buf = queue->bufs[bidx];
 		buf->buffer->element[buf->next_element_to_fill - 1].eflags |=
 				SBAL_EFLAGS_LAST_ENTRY;
+		queue->coalesced_frames += buf->frames;
 
 		if (queue->bufstates)
 			queue->bufstates[bidx].user = buf;
@@ -3401,8 +3405,18 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		     queue->queue_no, index, count);
 
 	/* Fake the TX completion interrupt: */
-	if (IS_IQD(card))
-		napi_schedule(&queue->napi);
+	if (IS_IQD(card)) {
+		unsigned int frames = READ_ONCE(queue->max_coalesced_frames);
+		unsigned int usecs = READ_ONCE(queue->coalesce_usecs);
+
+		if (frames && queue->coalesced_frames >= frames) {
+			napi_schedule(&queue->napi);
+			queue->coalesced_frames = 0;
+			QETH_TXQ_STAT_INC(queue, coal_frames);
+		} else if (usecs) {
+			qeth_tx_arm_timer(queue, usecs);
+		}
+	}
 
 	if (rc) {
 		/* ignore temporary SIGA errors without busy condition */
@@ -5667,7 +5681,7 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 		if (completed <= 0) {
 			/* Ensure we see TX completion for pending work: */
 			if (napi_complete_done(napi, 0))
-				qeth_tx_arm_timer(queue);
+				qeth_tx_arm_timer(queue, QETH_TX_TIMER_USECS);
 			return 0;
 		}
 
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 6f0cc6fcc759..ebdc03210608 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -40,6 +40,7 @@ static const struct qeth_stats txq_stats[] = {
 	QETH_TXQ_STAT("Packing mode switches", packing_mode_switch),
 	QETH_TXQ_STAT("Queue stopped", stopped),
 	QETH_TXQ_STAT("Doorbell", doorbell),
+	QETH_TXQ_STAT("IRQ for frames", coal_frames),
 	QETH_TXQ_STAT("Completion yield", completion_yield),
 	QETH_TXQ_STAT("Completion timer", completion_timer),
 };
@@ -109,6 +110,38 @@ static void qeth_get_ethtool_stats(struct net_device *dev,
 				   txq_stats, TXQ_STATS_LEN);
 }
 
+static void __qeth_set_coalesce(struct net_device *dev,
+				struct qeth_qdio_out_q *queue,
+				struct ethtool_coalesce *coal)
+{
+	WRITE_ONCE(queue->coalesce_usecs, coal->tx_coalesce_usecs);
+	WRITE_ONCE(queue->max_coalesced_frames, coal->tx_max_coalesced_frames);
+
+	if (coal->tx_coalesce_usecs &&
+	    netif_running(dev) &&
+	    !qeth_out_queue_is_empty(queue))
+		qeth_tx_arm_timer(queue, coal->tx_coalesce_usecs);
+}
+
+static int qeth_set_coalesce(struct net_device *dev,
+			     struct ethtool_coalesce *coal)
+{
+	struct qeth_card *card = dev->ml_priv;
+	struct qeth_qdio_out_q *queue;
+	unsigned int i;
+
+	if (!IS_IQD(card))
+		return -EOPNOTSUPP;
+
+	if (!coal->tx_coalesce_usecs && !coal->tx_max_coalesced_frames)
+		return -EINVAL;
+
+	qeth_for_each_output_queue(card, queue, i)
+		__qeth_set_coalesce(dev, queue, coal);
+
+	return 0;
+}
+
 static void qeth_get_ringparam(struct net_device *dev,
 			       struct ethtool_ringparam *param)
 {
@@ -244,6 +277,43 @@ static int qeth_set_tunable(struct net_device *dev,
 	}
 }
 
+static int qeth_get_per_queue_coalesce(struct net_device *dev, u32 __queue,
+				       struct ethtool_coalesce *coal)
+{
+	struct qeth_card *card = dev->ml_priv;
+	struct qeth_qdio_out_q *queue;
+
+	if (!IS_IQD(card))
+		return -EOPNOTSUPP;
+
+	if (__queue >= card->qdio.no_out_queues)
+		return -EINVAL;
+
+	queue = card->qdio.out_qs[__queue];
+
+	coal->tx_coalesce_usecs = queue->coalesce_usecs;
+	coal->tx_max_coalesced_frames = queue->max_coalesced_frames;
+	return 0;
+}
+
+static int qeth_set_per_queue_coalesce(struct net_device *dev, u32 queue,
+				       struct ethtool_coalesce *coal)
+{
+	struct qeth_card *card = dev->ml_priv;
+
+	if (!IS_IQD(card))
+		return -EOPNOTSUPP;
+
+	if (queue >= card->qdio.no_out_queues)
+		return -EINVAL;
+
+	if (!coal->tx_coalesce_usecs && !coal->tx_max_coalesced_frames)
+		return -EINVAL;
+
+	__qeth_set_coalesce(dev, card->qdio.out_qs[queue], coal);
+	return 0;
+}
+
 /* Helper function to fill 'advertising' and 'supported' which are the same. */
 /* Autoneg and full-duplex are supported and advertised unconditionally.     */
 /* Always advertise and support all speeds up to specified, and only one     */
@@ -443,7 +513,10 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 }
 
 const struct ethtool_ops qeth_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_TX_USECS |
+				     ETHTOOL_COALESCE_TX_MAX_FRAMES,
 	.get_link = ethtool_op_get_link,
+	.set_coalesce = qeth_set_coalesce,
 	.get_ringparam = qeth_get_ringparam,
 	.get_strings = qeth_get_strings,
 	.get_ethtool_stats = qeth_get_ethtool_stats,
@@ -454,6 +527,8 @@ const struct ethtool_ops qeth_ethtool_ops = {
 	.get_ts_info = qeth_get_ts_info,
 	.get_tunable = qeth_get_tunable,
 	.set_tunable = qeth_set_tunable,
+	.get_per_queue_coalesce = qeth_get_per_queue_coalesce,
+	.set_per_queue_coalesce = qeth_set_per_queue_coalesce,
 	.get_link_ksettings = qeth_get_link_ksettings,
 };
 
-- 
2.17.1

