Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3C254079
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgH0IR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:17:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgH0IRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:17:17 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R852Cb045660;
        Thu, 27 Aug 2020 04:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xBouKza3uqgoCKGzgbYgwHUeIGRQ2fggV62Hutvx+7I=;
 b=QMLRiHRh5j2zAaZNxFjpC0LGW+ViKrBZPreIooprVMISQgSkGoerXwOBKvIY9T9Ftl4A
 IX3KgiHf8ra8OXTt7LLB/iUyse/bD6rd8BcCRd6rWiRAz9rc1qPS3D2TlrB9mdNa828F
 od1/qB1BAdbWO7HENGorFE8/GjRTXphTCnUMrQ+SP56rLvgMwBSLFPMdHl/vNIgKLOnP
 /05xn87E/q7Piz+KI09sUo5liaDCNkxSljuZ75k5F4nHx03G7/WFLwUNY3gQ1KqXZf8e
 CDFrlDGaUKMeX+ZaqkPQtHgXdZaAZ+25S89U0zEg0O75dFzBKRi9g+8sBkNBLev0DnEq Eg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3367tsjfry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:17:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8CVKS017682;
        Thu, 27 Aug 2020 08:17:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujkwekt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8HAtR54722980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D0F54C05A;
        Thu, 27 Aug 2020 08:17:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 542184C05C;
        Thu, 27 Aug 2020 08:17:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 8/8] s390/qeth: strictly order bridge address events
Date:   Thu, 27 Aug 2020 10:17:05 +0200
Message-Id: <20200827081705.21922-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827081705.21922-1-jwi@linux.ibm.com>
References: <20200827081705.21922-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=2 spamscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code for bridge address events has two shortcomings in its
control sequence:

1. after disabling address events via PNSO, we don't flush the remaining
   events from the event_wq. So if the feature is re-enabled fast
   enough, stale events could leak over.
2. PNSO and the events' arrival via the READ ccw device are unordered.
   So even if we flushed the workqueue, it's difficult to say whether
   the READ device might produce more events onto the workqueue
   afterwards.

Fix this by
1. explicitly fencing off the events when we no longer care, in the
   READ device's event handler. This ensures that once we flush the
   workqueue, it doesn't get additional address events.
2. Flush the workqueue after disabling the events & fencing them off.
   As the code that triggers the flush will typically hold the sbp_lock,
   we need to rework the worker code to avoid a deadlock here in case
   of a 'notifications-stopped' event. In case of lock contention,
   requeue such an event with a delay. We'll eventually aquire the lock,
   or spot that the feature has been disabled and the event can thus be
   discarded.

This leaves the theoretical race that a stale event could arrive
_after_ we re-enabled ourselves to receive events again. Such an event
would be impossible to distinguish from a 'good' event, nothing we can
do about it.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  6 ++++
 drivers/s390/net/qeth_l2_main.c | 53 ++++++++++++++++++++++++++++-----
 drivers/s390/net/qeth_l2_sys.c  |  1 +
 3 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 00ed58428163..da46af682af8 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -674,6 +674,11 @@ struct qeth_card_blkt {
 	int inter_packet_jumbo;
 };
 
+enum qeth_pnso_mode {
+	QETH_PNSO_NONE,
+	QETH_PNSO_BRIDGEPORT,
+};
+
 #define QETH_BROADCAST_WITH_ECHO    0x01
 #define QETH_BROADCAST_WITHOUT_ECHO 0x02
 struct qeth_card_info {
@@ -690,6 +695,7 @@ struct qeth_card_info {
 	/* no bitfield, we take a pointer on these two: */
 	u8 has_lp2lp_cso_v6;
 	u8 has_lp2lp_cso_v4;
+	enum qeth_pnso_mode pnso_mode;
 	enum qeth_card_types type;
 	enum qeth_link_types link_type;
 	int broadcast_capable;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 1e3d64ab5e46..b5bef5345dd6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -273,6 +273,17 @@ static int qeth_l2_vlan_rx_kill_vid(struct net_device *dev,
 	return qeth_l2_send_setdelvlan(card, vid, IPA_CMD_DELVLAN);
 }
 
+static void qeth_l2_set_pnso_mode(struct qeth_card *card,
+				  enum qeth_pnso_mode mode)
+{
+	spin_lock_irq(get_ccwdev_lock(CARD_RDEV(card)));
+	WRITE_ONCE(card->info.pnso_mode, mode);
+	spin_unlock_irq(get_ccwdev_lock(CARD_RDEV(card)));
+
+	if (mode == QETH_PNSO_NONE)
+		drain_workqueue(card->event_wq);
+}
+
 static void qeth_l2_stop_card(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 2, "stopcard");
@@ -290,7 +301,7 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 
 	qeth_qdio_clear_card(card, 0);
 	qeth_clear_working_pool_list(card);
-	flush_workqueue(card->event_wq);
+	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
 	qeth_flush_local_addrs(card);
 	card->info.promisc_mode = 0;
 }
@@ -1153,19 +1164,34 @@ static void qeth_bridge_state_change(struct qeth_card *card,
 }
 
 struct qeth_addr_change_data {
-	struct work_struct worker;
+	struct delayed_work dwork;
 	struct qeth_card *card;
 	struct qeth_ipacmd_addr_change ac_event;
 };
 
 static void qeth_addr_change_event_worker(struct work_struct *work)
 {
-	struct qeth_addr_change_data *data =
-		container_of(work, struct qeth_addr_change_data, worker);
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct qeth_addr_change_data *data;
+	struct qeth_card *card;
 	int i;
 
+	data = container_of(dwork, struct qeth_addr_change_data, dwork);
+	card = data->card;
+
 	QETH_CARD_TEXT(data->card, 4, "adrchgew");
+
+	if (READ_ONCE(card->info.pnso_mode) == QETH_PNSO_NONE)
+		goto free;
+
 	if (data->ac_event.lost_event_mask) {
+		/* Potential re-config in progress, try again later: */
+		if (!mutex_trylock(&card->sbp_lock)) {
+			queue_delayed_work(card->event_wq, dwork,
+					   msecs_to_jiffies(100));
+			return;
+		}
+
 		dev_info(&data->card->gdev->dev,
 			 "Address change notification stopped on %s (%s)\n",
 			 data->card->dev->name,
@@ -1174,8 +1200,9 @@ static void qeth_addr_change_event_worker(struct work_struct *work)
 			: (data->ac_event.lost_event_mask == 0x02)
 			? "Bridge port state change"
 			: "Unknown reason");
-		mutex_lock(&data->card->sbp_lock);
+
 		data->card->options.sbp.hostnotification = 0;
+		card->info.pnso_mode = QETH_PNSO_NONE;
 		mutex_unlock(&data->card->sbp_lock);
 		qeth_bridge_emit_host_event(data->card, anev_abort,
 					    0, NULL, NULL);
@@ -1189,6 +1216,8 @@ static void qeth_addr_change_event_worker(struct work_struct *work)
 						    &entry->token,
 						    &entry->addr_lnid);
 		}
+
+free:
 	kfree(data);
 }
 
@@ -1200,6 +1229,9 @@ static void qeth_addr_change_event(struct qeth_card *card,
 	struct qeth_addr_change_data *data;
 	int extrasize;
 
+	if (card->info.pnso_mode == QETH_PNSO_NONE)
+		return;
+
 	QETH_CARD_TEXT(card, 4, "adrchgev");
 	if (cmd->hdr.return_code != 0x0000) {
 		if (cmd->hdr.return_code == 0x0010) {
@@ -1219,11 +1251,11 @@ static void qeth_addr_change_event(struct qeth_card *card,
 		QETH_CARD_TEXT(card, 2, "ACNalloc");
 		return;
 	}
-	INIT_WORK(&data->worker, qeth_addr_change_event_worker);
+	INIT_DELAYED_WORK(&data->dwork, qeth_addr_change_event_worker);
 	data->card = card;
 	memcpy(&data->ac_event, hostevs,
 			sizeof(struct qeth_ipacmd_addr_change) + extrasize);
-	queue_work(card->event_wq, &data->worker);
+	queue_delayed_work(card->event_wq, &data->dwork, 0);
 }
 
 /* SETBRIDGEPORT support; sending commands */
@@ -1545,9 +1577,14 @@ int qeth_bridgeport_an_set(struct qeth_card *card, int enable)
 
 	if (enable) {
 		qeth_bridge_emit_host_event(card, anev_reset, 0, NULL, NULL);
+		qeth_l2_set_pnso_mode(card, QETH_PNSO_BRIDGEPORT);
 		rc = qeth_l2_pnso(card, 1, qeth_bridgeport_an_set_cb, card);
-	} else
+		if (rc)
+			qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+	} else {
 		rc = qeth_l2_pnso(card, 0, NULL, NULL);
+		qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+	}
 	return rc;
 }
 
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index 86bcae992f72..4695d25e54f2 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -157,6 +157,7 @@ static ssize_t qeth_bridgeport_hostnotification_store(struct device *dev,
 		rc = -EBUSY;
 	else if (qeth_card_hw_is_reachable(card)) {
 		rc = qeth_bridgeport_an_set(card, enable);
+		/* sbp_lock ensures ordering vs notifications-stopped events */
 		if (!rc)
 			card->options.sbp.hostnotification = enable;
 	} else
-- 
2.17.1

