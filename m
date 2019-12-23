Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F541296C2
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfLWODk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:03:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726754AbfLWODi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:03:38 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNE3NoS094531
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:03:37 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2x21kg42qr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:03:36 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 23 Dec 2019 14:03:35 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Dec 2019 14:03:32 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBNE3Ueb63897688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:03:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF2ACA4054;
        Mon, 23 Dec 2019 14:03:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82844A4062;
        Mon, 23 Dec 2019 14:03:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Dec 2019 14:03:30 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/6] s390/qeth: fix qdio teardown after early init error
Date:   Mon, 23 Dec 2019 15:03:21 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191223140326.16488-1-jwi@linux.ibm.com>
References: <20191223140326.16488-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19122314-0028-0000-0000-000003CB4F05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19122314-0029-0000-0000-0000248EAA13
Message-Id: <20191223140326.16488-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_06:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_l?_set_online() goes through a number of initialization steps, and
on any error uses qeth_l?_stop_card() to tear down the residual state.

The first initialization step is qeth_core_hardsetup_card(). When this
fails after having established a QDIO context on the device
(ie. somewhere after qeth_mpc_initialize()), qeth_l?_stop_card() doesn't
shut down this QDIO context again (since the card state hasn't
progressed from DOWN at this stage).

Even worse, we then call qdio_free() as final teardown step to free the
QDIO data structures - while some of them are still hooked into wider
QDIO infrastructure such as the IRQ list. This is inevitably followed by
use-after-frees and other nastyness.

Fix this by unconditionally calling qeth_qdio_clear_card() to shut down
the QDIO context, and also to halt/clear any pending activity on the
various IO channels.
Remove the naive attempt at handling the teardown in
qeth_mpc_initialize(), it clearly doesn't suffice and we're handling it
properly now in the wider teardown code.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 20 ++++++++------------
 drivers/s390/net/qeth_l2_main.c   |  2 +-
 drivers/s390/net/qeth_l3_main.c   |  2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index bc4158888af9..324cf22f9111 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2482,50 +2482,46 @@ static int qeth_mpc_initialize(struct qeth_card *card)
 	rc = qeth_cm_enable(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "2err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_cm_setup(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "3err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_ulp_enable(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "4err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_ulp_setup(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_alloc_qdio_queues(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_qdio_establish(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 		qeth_free_qdio_queues(card);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_qdio_activate(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "7err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_dm_act(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "8err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 
 	return 0;
-out_qdio:
-	qeth_qdio_clear_card(card, !IS_IQD(card));
-	qdio_free(CARD_DDEV(card));
-	return rc;
 }
 
 void qeth_print_status_message(struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 8c95e6019bac..15e2fd65d434 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -287,12 +287,12 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_HARDSETUP;
 	}
 	if (card->state == CARD_STATE_HARDSETUP) {
-		qeth_qdio_clear_card(card, 0);
 		qeth_drain_output_queues(card);
 		qeth_clear_working_pool_list(card);
 		card->state = CARD_STATE_DOWN;
 	}
 
+	qeth_qdio_clear_card(card, 0);
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
 	card->info.promisc_mode = 0;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 04e301de376f..5508ab89b518 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1307,12 +1307,12 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_HARDSETUP;
 	}
 	if (card->state == CARD_STATE_HARDSETUP) {
-		qeth_qdio_clear_card(card, 0);
 		qeth_drain_output_queues(card);
 		qeth_clear_working_pool_list(card);
 		card->state = CARD_STATE_DOWN;
 	}
 
+	qeth_qdio_clear_card(card, 0);
 	flush_workqueue(card->event_wq);
 	card->info.promisc_mode = 0;
 }
-- 
2.17.1

