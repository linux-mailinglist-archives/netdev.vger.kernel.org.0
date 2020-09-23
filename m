Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E03275358
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgIWIhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726359AbgIWIhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:17 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8VlJN118619;
        Wed, 23 Sep 2020 04:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=mSfUnr4+teauNKslG6ftKGQaU+SvUHLNnVs5sNhx6d8=;
 b=AmeUuaAMlTaMDrMt+hyW2Z24/lpJ5J+Lj11Wfgm6h+vCExumTimmnY+GZI5ZQXmPT2zd
 p5aaEVVPmdirs2BU0ufe8qhO2npbu4dw2LOnnkewhq2QByPVXzYcp5oL7CJTchRiUhOo
 PUCcnBrEnXJW9TOTwonVksA+gRsttOjtf0P3hXHTRpNULxXcOgz0b4gLyak8aLY/3bTo
 uKWFXDSPiRfPB7JLjlGiJ7/RBKq8zG7Cf2WsjJuS3qlOZ6eTC50nK1LxHh67Rsto1p1s
 k1wYR1J806ykuoK0sY9jxXj7lJZyjxrkiMP270crNbLNjO3yf6r+OIzo6F7G2PrNg7CZ zQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r2g791q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:13 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8YEoa016210;
        Wed, 23 Sep 2020 08:37:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 33n9m7t1s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b6If21299542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E20DE11C058;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9821411C04A;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 8/9] s390/qeth: consolidate teardown code
Date:   Wed, 23 Sep 2020 10:36:59 +0200
Message-Id: <20200923083700.44624-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=13 spamscore=0 phishscore=0
 mlxlogscore=795 bulkscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clarify which discipline-specific steps are needed to roll back after
error in qeth_l?_set_online(), and which are common to roll back
from qeth_hardsetup_card().

Some steps (cancelling the RX modeset, draining the TX queues) are only
necessary if the netdev was potentially UP before, so move them to the
common qeth_set_offline().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  4 ---
 drivers/s390/net/qeth_core_main.c | 24 ++++++++++-----
 drivers/s390/net/qeth_l2_main.c   | 50 +++++++++++--------------------
 drivers/s390/net/qeth_l3_main.c   | 46 ++++++++++------------------
 4 files changed, 50 insertions(+), 74 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 242558bdb5ac..f321eabefbe4 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1062,11 +1062,7 @@ void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason);
 void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
 int qeth_schedule_recovery(struct qeth_card *card);
-void qeth_flush_local_addrs(struct qeth_card *card);
 int qeth_poll(struct napi_struct *napi, int budget);
-int qeth_qdio_clear_card(struct qeth_card *, int);
-void qeth_clear_working_pool_list(struct qeth_card *);
-void qeth_drain_output_queues(struct qeth_card *card);
 void qeth_setadp_promisc_mode(struct qeth_card *card, bool enable);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *, unsigned int txqueue);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 5a132241b4dd..fc2c3db9259f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -201,7 +201,7 @@ int qeth_threads_running(struct qeth_card *card, unsigned long threads)
 }
 EXPORT_SYMBOL_GPL(qeth_threads_running);
 
-void qeth_clear_working_pool_list(struct qeth_card *card)
+static void qeth_clear_working_pool_list(struct qeth_card *card)
 {
 	struct qeth_buffer_pool_entry *pool_entry, *tmp;
 	struct qeth_qdio_q *queue = card->qdio.in_q;
@@ -216,7 +216,6 @@ void qeth_clear_working_pool_list(struct qeth_card *card)
 	for (i = 0; i < ARRAY_SIZE(queue->bufs); i++)
 		queue->bufs[i].pool_entry = NULL;
 }
-EXPORT_SYMBOL_GPL(qeth_clear_working_pool_list);
 
 static void qeth_free_pool_entry(struct qeth_buffer_pool_entry *entry)
 {
@@ -658,12 +657,11 @@ static void qeth_flush_local_addrs6(struct qeth_card *card)
 	spin_unlock_irq(&card->local_addrs6_lock);
 }
 
-void qeth_flush_local_addrs(struct qeth_card *card)
+static void qeth_flush_local_addrs(struct qeth_card *card)
 {
 	qeth_flush_local_addrs4(card);
 	qeth_flush_local_addrs6(card);
 }
-EXPORT_SYMBOL_GPL(qeth_flush_local_addrs);
 
 static void qeth_add_local_addrs4(struct qeth_card *card,
 				  struct qeth_ipacmd_local_addrs4 *cmd)
@@ -1501,7 +1499,7 @@ static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 	}
 }
 
-void qeth_drain_output_queues(struct qeth_card *card)
+static void qeth_drain_output_queues(struct qeth_card *card)
 {
 	int i;
 
@@ -1512,7 +1510,6 @@ void qeth_drain_output_queues(struct qeth_card *card)
 			qeth_drain_output_queue(card->qdio.out_qs[i], false);
 	}
 }
-EXPORT_SYMBOL_GPL(qeth_drain_output_queues);
 
 static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 {
@@ -1840,7 +1837,7 @@ static int qeth_clear_halt_card(struct qeth_card *card, int halt)
 	return qeth_clear_channels(card);
 }
 
-int qeth_qdio_clear_card(struct qeth_card *card, int use_halt)
+static int qeth_qdio_clear_card(struct qeth_card *card, int use_halt)
 {
 	int rc = 0;
 
@@ -1868,7 +1865,6 @@ int qeth_qdio_clear_card(struct qeth_card *card, int use_halt)
 		QETH_CARD_TEXT_(card, 3, "2err%d", rc);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(qeth_qdio_clear_card);
 
 static enum qeth_discipline_id qeth_vm_detect_layer(struct qeth_card *card)
 {
@@ -5333,6 +5329,10 @@ static int qeth_set_online(struct qeth_card *card)
 
 err_online:
 err_hardsetup:
+	qeth_qdio_clear_card(card, 0);
+	qeth_clear_working_pool_list(card);
+	qeth_flush_local_addrs(card);
+
 	qeth_stop_channel(&card->data);
 	qeth_stop_channel(&card->write);
 	qeth_stop_channel(&card->read);
@@ -5366,8 +5366,16 @@ int qeth_set_offline(struct qeth_card *card, bool resetting)
 	netif_carrier_off(card->dev);
 	rtnl_unlock();
 
+	cancel_work_sync(&card->rx_mode_work);
+
 	card->discipline->set_offline(card);
 
+	qeth_qdio_clear_card(card, 0);
+	qeth_drain_output_queues(card);
+	qeth_clear_working_pool_list(card);
+	qeth_flush_local_addrs(card);
+	card->info.promisc_mode = 0;
+
 	rc  = qeth_stop_channel(&card->data);
 	rc2 = qeth_stop_channel(&card->write);
 	rc3 = qeth_stop_channel(&card->read);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 6e8d5113d435..fd6891494c69 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -304,34 +304,6 @@ static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
 				 card->dev, &info.info, NULL);
 }
 
-static void qeth_l2_stop_card(struct qeth_card *card)
-{
-	struct qeth_priv *priv = netdev_priv(card->dev);
-
-	QETH_CARD_TEXT(card, 2, "stopcard");
-
-	qeth_set_allowed_threads(card, 0, 1);
-
-	cancel_work_sync(&card->rx_mode_work);
-	qeth_l2_drain_rx_mode_cache(card);
-
-	if (card->state == CARD_STATE_SOFTSETUP)
-		card->state = CARD_STATE_DOWN;
-
-	qeth_qdio_clear_card(card, 0);
-	qeth_drain_output_queues(card);
-	qeth_clear_working_pool_list(card);
-	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
-	qeth_flush_local_addrs(card);
-	card->info.promisc_mode = 0;
-
-	if (priv->brport_features & BR_LEARNING_SYNC) {
-		rtnl_lock();
-		qeth_l2_dev2br_fdb_flush(card);
-		rtnl_unlock();
-	}
-}
-
 static int qeth_l2_request_initial_mac(struct qeth_card *card)
 {
 	int rc = 0;
@@ -1172,7 +1144,7 @@ static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 	if (dev->reg_state != NETREG_REGISTERED) {
 		rc = qeth_l2_setup_netdev(card);
 		if (rc)
-			goto out_remove;
+			goto err_setup;
 
 		if (carrier_ok)
 			netif_carrier_on(dev);
@@ -1195,14 +1167,28 @@ static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 	}
 	return 0;
 
-out_remove:
-	qeth_l2_stop_card(card);
+err_setup:
+	qeth_set_allowed_threads(card, 0, 1);
+	card->state = CARD_STATE_DOWN;
 	return rc;
 }
 
 static void qeth_l2_set_offline(struct qeth_card *card)
 {
-	qeth_l2_stop_card(card);
+	struct qeth_priv *priv = netdev_priv(card->dev);
+
+	qeth_set_allowed_threads(card, 0, 1);
+	qeth_l2_drain_rx_mode_cache(card);
+
+	if (card->state == CARD_STATE_SOFTSETUP)
+		card->state = CARD_STATE_DOWN;
+
+	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+	if (priv->brport_features & BR_LEARNING_SYNC) {
+		rtnl_lock();
+		qeth_l2_dev2br_fdb_flush(card);
+		rtnl_unlock();
+	}
 }
 
 static int __init qeth_l2_init(void)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 08285af6a5ff..a6f8878b55c6 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1142,32 +1142,6 @@ static int qeth_l3_vlan_rx_kill_vid(struct net_device *dev,
 	return 0;
 }
 
-static void qeth_l3_stop_card(struct qeth_card *card)
-{
-	QETH_CARD_TEXT(card, 2, "stopcard");
-
-	qeth_set_allowed_threads(card, 0, 1);
-
-	cancel_work_sync(&card->rx_mode_work);
-	qeth_l3_drain_rx_mode_cache(card);
-
-	if (card->options.sniffer &&
-	    (card->info.promisc_mode == SET_PROMISC_MODE_ON))
-		qeth_diags_trace(card, QETH_DIAGS_CMD_TRACE_DISABLE);
-
-	if (card->state == CARD_STATE_SOFTSETUP) {
-		card->state = CARD_STATE_DOWN;
-		qeth_l3_clear_ip_htable(card, 1);
-	}
-
-	qeth_qdio_clear_card(card, 0);
-	qeth_drain_output_queues(card);
-	qeth_clear_working_pool_list(card);
-	flush_workqueue(card->event_wq);
-	qeth_flush_local_addrs(card);
-	card->info.promisc_mode = 0;
-}
-
 static void qeth_l3_set_promisc_mode(struct qeth_card *card)
 {
 	bool enable = card->dev->flags & IFF_PROMISC;
@@ -2042,7 +2016,7 @@ static int qeth_l3_set_online(struct qeth_card *card, bool carrier_ok)
 	if (dev->reg_state != NETREG_REGISTERED) {
 		rc = qeth_l3_setup_netdev(card);
 		if (rc)
-			goto out_remove;
+			goto err_setup;
 
 		if (carrier_ok)
 			netif_carrier_on(dev);
@@ -2064,14 +2038,26 @@ static int qeth_l3_set_online(struct qeth_card *card, bool carrier_ok)
 	}
 	return 0;
 
-out_remove:
-	qeth_l3_stop_card(card);
+err_setup:
+	qeth_set_allowed_threads(card, 0, 1);
+	card->state = CARD_STATE_DOWN;
+	qeth_l3_clear_ip_htable(card, 1);
 	return rc;
 }
 
 static void qeth_l3_set_offline(struct qeth_card *card)
 {
-	qeth_l3_stop_card(card);
+	qeth_set_allowed_threads(card, 0, 1);
+	qeth_l3_drain_rx_mode_cache(card);
+
+	if (card->options.sniffer &&
+	    (card->info.promisc_mode == SET_PROMISC_MODE_ON))
+		qeth_diags_trace(card, QETH_DIAGS_CMD_TRACE_DISABLE);
+
+	if (card->state == CARD_STATE_SOFTSETUP) {
+		card->state = CARD_STATE_DOWN;
+		qeth_l3_clear_ip_htable(card, 1);
+	}
 }
 
 /* Returns zero if the command is successfully "consumed" */
-- 
2.17.1

