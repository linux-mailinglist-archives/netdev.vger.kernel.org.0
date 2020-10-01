Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D282E2804C8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbgJARL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:11:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732867AbgJARLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H3M5m108036;
        Thu, 1 Oct 2020 13:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=VpVZjLuzKfjVnICP31LL1nUCKHJcP7OerSmNfsTAgHU=;
 b=saRPyUa2vmzfEpzHA8L8vJz1otraALYb5sPfoNqLkCxm7kfON5FdTdymOSfYeBnwQaGB
 SgClLDuNIC9/cD1CEOVMaJ6W45yDVQwWXMEy9ralgKIJwEFlzzttvrrDMvOdPLz5qcBw
 Fcel7L3rkombAUrBwoJiaXHrMvYhHBwpxyVA3e5Bix1KbQEhT3lmBK1CJ9te3/iDcmjH
 /H+GD2dhf/Xr6WGm5a3GFcyQ7ElWdEjh7bajnZEza8ZO4m9/A19fz6/b1hZki4EdkZzC
 KojnLrJP8zl7lztE16S8fL69oqAxAQSALnY6f65KtiWcaZqOopHJUyd2NypTXmh2Y5ox vg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33wjepspwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:48 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H3tJh016657;
        Thu, 1 Oct 2020 17:11:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 33wgcu02wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBhfG29950454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 071DAA404D;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B11BBA4055;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/7] s390/qeth: allow configuration of TX queues for OSA devices
Date:   Thu,  1 Oct 2020 19:11:32 +0200
Message-Id: <20201001171136.46830-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_06:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=2 mlxlogscore=984 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For OSA devices that are _not_ configured in prio-queue mode, give users
the option of selecting the number of active TX queues.
This requires setting up the HW queues with a reasonable default QoS
value in the QIB's PQUE parm area.

As with the other device types, we bring up the device with a minimal
number of TX queues for compatibility reasons.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 18 +++++++++++++++++
 drivers/s390/net/qeth_core_main.c | 32 ++++++++++++++++++++-----------
 drivers/s390/net/qeth_core_sys.c  |  4 +++-
 drivers/s390/net/qeth_ethtool.c   |  8 ++++----
 drivers/s390/net/qeth_l2_main.c   |  5 +++--
 drivers/s390/net/qeth_l3_main.c   |  6 ++++--
 6 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 1e1e7104dade..707a1634f621 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -278,6 +278,10 @@ struct qeth_hdr {
 	} hdr;
 } __attribute__ ((packed));
 
+#define QETH_QIB_PQUE_ORDER_RR		0
+#define QETH_QIB_PQUE_UNITS_SBAL	2
+#define QETH_QIB_PQUE_PRIO_DEFAULT	4
+
 struct qeth_qib_parms {
 	char pcit_magic[4];
 	u32 pcit_a;
@@ -287,6 +291,11 @@ struct qeth_qib_parms {
 	u32 blkt_total;
 	u32 blkt_inter_packet;
 	u32 blkt_inter_packet_jumbo;
+	char pque_magic[4];
+	u8 pque_order;
+	u8 pque_units;
+	u16 reserved;
+	u32 pque_priority[4];
 };
 
 /*TCP Segmentation Offload header*/
@@ -492,6 +501,7 @@ struct qeth_qdio_out_q {
 	struct qdio_outbuf_state *bufstates; /* convenience pointer */
 	struct qeth_out_q_stats stats;
 	spinlock_t lock;
+	unsigned int priority;
 	u8 next_buf_to_fill;
 	u8 max_elements;
 	u8 queue_no;
@@ -885,10 +895,18 @@ struct qeth_trap_id {
 /*some helper functions*/
 #define QETH_CARD_IFNAME(card) (((card)->dev)? (card)->dev->name : "")
 
+static inline bool qeth_uses_tx_prio_queueing(struct qeth_card *card)
+{
+	return card->qdio.do_prio_queueing != QETH_NO_PRIO_QUEUEING;
+}
+
 static inline unsigned int qeth_tx_actual_queues(struct qeth_card *card)
 {
 	struct qeth_priv *priv = netdev_priv(card->dev);
 
+	if (qeth_uses_tx_prio_queueing(card))
+		return min(card->dev->num_tx_queues, card->qdio.no_out_queues);
+
 	return min(priv->tx_wanted_queues, card->qdio.no_out_queues);
 }
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 81f02a70680e..9e9c229e2780 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2683,6 +2683,7 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
 		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
+		queue->priority = QETH_QIB_PQUE_PRIO_DEFAULT;
 
 		/* give outbound qeth_qdio_buffers their qdio_buffers */
 		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
@@ -2746,6 +2747,9 @@ static void qeth_free_qdio_queues(struct qeth_card *card)
 static void qeth_fill_qib_parms(struct qeth_card *card,
 				struct qeth_qib_parms *parms)
 {
+	struct qeth_qdio_out_q *queue;
+	unsigned int i;
+
 	parms->pcit_magic[0] = 'P';
 	parms->pcit_magic[1] = 'C';
 	parms->pcit_magic[2] = 'I';
@@ -2763,6 +2767,21 @@ static void qeth_fill_qib_parms(struct qeth_card *card,
 	parms->blkt_total = card->info.blkt.time_total;
 	parms->blkt_inter_packet = card->info.blkt.inter_packet;
 	parms->blkt_inter_packet_jumbo = card->info.blkt.inter_packet_jumbo;
+
+	/* Prio-queueing implicitly uses the default priorities: */
+	if (qeth_uses_tx_prio_queueing(card) || card->qdio.no_out_queues == 1)
+		return;
+
+	parms->pque_magic[0] = 'P';
+	parms->pque_magic[1] = 'Q';
+	parms->pque_magic[2] = 'U';
+	parms->pque_magic[3] = 'E';
+	ASCEBC(parms->pque_magic, sizeof(parms->pque_magic));
+	parms->pque_order = QETH_QIB_PQUE_ORDER_RR;
+	parms->pque_units = QETH_QIB_PQUE_UNITS_SBAL;
+
+	qeth_for_each_output_queue(card, queue, i)
+		parms->pque_priority[i] = queue->priority;
 }
 
 static int qeth_qdio_activate(struct qeth_card *card)
@@ -5298,19 +5317,9 @@ static int qeth_set_online(struct qeth_card *card)
 
 	qeth_print_status_message(card);
 
-	if (card->dev->reg_state != NETREG_REGISTERED) {
-		struct qeth_priv *priv = netdev_priv(card->dev);
-
-		if (IS_IQD(card))
-			priv->tx_wanted_queues = QETH_IQD_MIN_TXQ;
-		else if (IS_VM_NIC(card))
-			priv->tx_wanted_queues = 1;
-		else
-			priv->tx_wanted_queues = card->dev->num_tx_queues;
-
+	if (card->dev->reg_state != NETREG_REGISTERED)
 		/* no need for locking / error handling at this early stage: */
 		qeth_set_real_num_tx_queues(card, qeth_tx_actual_queues(card));
-	}
 
 	rc = card->discipline->set_online(card, carrier_ok);
 	if (rc)
@@ -6236,6 +6245,7 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 
 	priv = netdev_priv(dev);
 	priv->rx_copybreak = QETH_RX_COPYBREAK;
+	priv->tx_wanted_queues = IS_IQD(card) ? QETH_IQD_MIN_TXQ : 1;
 
 	dev->ml_priv = card;
 	dev->watchdog_timeo = QETH_TX_TIMEOUT;
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 74c70364edc1..7cc5649dfffe 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -164,9 +164,11 @@ static ssize_t qeth_dev_prioqing_show(struct device *dev,
 		return sprintf(buf, "%s\n", "by skb-priority");
 	case QETH_PRIO_Q_ING_VLAN:
 		return sprintf(buf, "%s\n", "by VLAN headers");
-	default:
+	case QETH_PRIO_Q_ING_FIXED:
 		return sprintf(buf, "always queue %i\n",
 			       card->qdio.default_out_queue);
+	default:
+		return sprintf(buf, "disabled\n");
 	}
 }
 
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index bc3ea0efb58b..b5caa723326e 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -220,6 +220,10 @@ static int qeth_set_channels(struct net_device *dev,
 	if (channels->tx_count > card->qdio.no_out_queues)
 		return -EINVAL;
 
+	/* Prio-queueing needs all TX queues: */
+	if (qeth_uses_tx_prio_queueing(card))
+		return -EPERM;
+
 	if (IS_IQD(card)) {
 		if (channels->tx_count < QETH_IQD_MIN_TXQ)
 			return -EINVAL;
@@ -230,10 +234,6 @@ static int qeth_set_channels(struct net_device *dev,
 		if (netif_running(dev) &&
 		    channels->tx_count < dev->real_num_tx_queues)
 			return -EPERM;
-	} else {
-		/* OSA still uses the legacy prio-queue mechanism: */
-		if (!IS_VM_NIC(card))
-			return -EOPNOTSUPP;
 	}
 
 	rc = qeth_set_real_num_tx_queues(card, channels->tx_count);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 290389fc7e79..c0ceeddd1549 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -571,9 +571,10 @@ static u16 qeth_l2_select_queue(struct net_device *dev, struct sk_buff *skb,
 		return qeth_iqd_select_queue(dev, skb,
 					     qeth_get_ether_cast_type(skb),
 					     sb_dev);
+	if (qeth_uses_tx_prio_queueing(card))
+		return qeth_get_priority_queue(card, skb);
 
-	return IS_VM_NIC(card) ? netdev_pick_tx(dev, skb, sb_dev) :
-				 qeth_get_priority_queue(card, skb);
+	return netdev_pick_tx(dev, skb, sb_dev);
 }
 
 static void qeth_l2_set_rx_mode(struct net_device *dev)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index ea5f25857aff..803ccbcf3511 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1831,8 +1831,10 @@ static u16 qeth_l3_osa_select_queue(struct net_device *dev, struct sk_buff *skb,
 {
 	struct qeth_card *card = dev->ml_priv;
 
-	return IS_VM_NIC(card) ? netdev_pick_tx(dev, skb, sb_dev) :
-				 qeth_get_priority_queue(card, skb);
+	if (qeth_uses_tx_prio_queueing(card))
+		return qeth_get_priority_queue(card, skb);
+
+	return netdev_pick_tx(dev, skb, sb_dev);
 }
 
 static const struct net_device_ops qeth_l3_netdev_ops = {
-- 
2.17.1

