Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC3125408E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgH0IST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:18:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60344 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgH0ISS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:18:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R83bpW020231;
        Thu, 27 Aug 2020 04:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+T+fe5ec/9x4bAraqPd2GnHnBU79p9no59SS8rgF3qc=;
 b=KLddOiq9a6OYGzo1y/yKHch+LVdAulSR1bCiOLdRF6p02UbKrkL3RyQXGD4T7QeBpCmT
 PmTomWjLAVGMRGoprRch6rHfN6NNI8k8DH1OcmOJPk+qxpMAbdeBglPjriXZGE9LS/iU
 V3MwO36yW19+hr6+5KuKEDpUpte+/rujjUBBV3ie1YKWozVdA/eQOvjbV0C/5Mxh9fEF
 7UN9YGvkcOrxiTjXqsMDMJgvMhx24/xhXGIGU34dmk6J1e/igObjeIFjfh5QWn5mbuCt
 QMnpQ6JLHxn7VmKBCAtSy0FS8WFzliHNORzsKejKfZaRmAwne5KzpYfW9gF+qyHvBuEU Zg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3368t9rvqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:18:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8BvA1008286;
        Thu, 27 Aug 2020 08:17:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 332ujjub70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8HAb264029114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2D054C044;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9F374C052;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/8] s390/qeth: copy less data from bridge state events
Date:   Thu, 27 Aug 2020 10:17:03 +0200
Message-Id: <20200827081705.21922-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827081705.21922-1-jwi@linux.ibm.com>
References: <20200827081705.21922-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008270060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code copies _all_ entries from the event into a worker, when we
later only need specific data from the first entry.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 5a023fc499eb..d96636369b4c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1088,15 +1088,14 @@ static void qeth_bridge_emit_host_event(struct qeth_card *card,
 struct qeth_bridge_state_data {
 	struct work_struct worker;
 	struct qeth_card *card;
-	struct qeth_sbp_state_change qports;
+	u8 role;
+	u8 state;
 };
 
 static void qeth_bridge_state_change_worker(struct work_struct *work)
 {
 	struct qeth_bridge_state_data *data =
 		container_of(work, struct qeth_bridge_state_data, worker);
-	/* We are only interested in the first entry - local port */
-	struct qeth_sbp_port_entry *entry = &data->qports.entry[0];
 	char env_locrem[32];
 	char env_role[32];
 	char env_state[32];
@@ -1109,14 +1108,14 @@ static void qeth_bridge_state_change_worker(struct work_struct *work)
 
 	snprintf(env_locrem, sizeof(env_locrem), "BRIDGEPORT=statechange");
 	snprintf(env_role, sizeof(env_role), "ROLE=%s",
-		(entry->role == QETH_SBP_ROLE_NONE) ? "none" :
-		(entry->role == QETH_SBP_ROLE_PRIMARY) ? "primary" :
-		(entry->role == QETH_SBP_ROLE_SECONDARY) ? "secondary" :
+		(data->role == QETH_SBP_ROLE_NONE) ? "none" :
+		(data->role == QETH_SBP_ROLE_PRIMARY) ? "primary" :
+		(data->role == QETH_SBP_ROLE_SECONDARY) ? "secondary" :
 		"<INVALID>");
 	snprintf(env_state, sizeof(env_state), "STATE=%s",
-		(entry->state == QETH_SBP_STATE_INACTIVE) ? "inactive" :
-		(entry->state == QETH_SBP_STATE_STANDBY) ? "standby" :
-		(entry->state == QETH_SBP_STATE_ACTIVE) ? "active" :
+		(data->state == QETH_SBP_STATE_INACTIVE) ? "inactive" :
+		(data->state == QETH_SBP_STATE_STANDBY) ? "standby" :
+		(data->state == QETH_SBP_STATE_ACTIVE) ? "active" :
 		"<INVALID>");
 	kobject_uevent_env(&data->card->gdev->dev.kobj,
 				KOBJ_CHANGE, env);
@@ -1129,7 +1128,6 @@ static void qeth_bridge_state_change(struct qeth_card *card,
 	struct qeth_sbp_state_change *qports =
 		 &cmd->data.sbp.data.state_change;
 	struct qeth_bridge_state_data *data;
-	int extrasize;
 
 	QETH_CARD_TEXT(card, 2, "brstchng");
 	if (qports->num_entries == 0) {
@@ -1140,17 +1138,18 @@ static void qeth_bridge_state_change(struct qeth_card *card,
 		QETH_CARD_TEXT_(card, 2, "BPsz%04x", qports->entry_length);
 		return;
 	}
-	extrasize = sizeof(struct qeth_sbp_port_entry) * qports->num_entries;
-	data = kzalloc(sizeof(struct qeth_bridge_state_data) + extrasize,
-		GFP_ATOMIC);
+
+	data = kzalloc(sizeof(*data), GFP_ATOMIC);
 	if (!data) {
 		QETH_CARD_TEXT(card, 2, "BPSalloc");
 		return;
 	}
 	INIT_WORK(&data->worker, qeth_bridge_state_change_worker);
 	data->card = card;
-	memcpy(&data->qports, qports,
-			sizeof(struct qeth_sbp_state_change) + extrasize);
+	/* Information for the local port: */
+	data->role = qports->entry[0].role;
+	data->state = qports->entry[0].state;
+
 	queue_work(card->event_wq, &data->worker);
 }
 
-- 
2.17.1

