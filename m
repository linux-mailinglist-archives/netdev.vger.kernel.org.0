Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADEF27535C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgIWIhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726537AbgIWIhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:16 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8VlJL118619;
        Wed, 23 Sep 2020 04:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ajmWX1Gjz1o85OdFsa0sy7SvFZ+ZhUVjrGo2Yq+jGxk=;
 b=gtrXzULuPSCP3/8DbIYvSMHMguOilUl2oNI7MHX8+OWFFYoHQIKM68C/IK/PQh7vmN90
 nWc4K1eNZLIQiKbDmC4KYbKF/Nh25yAnvBZPdQTAyHnO9wGHtEz3O7HdNW8j/Rcir8du
 soANQpVUI5thxiawZAr1Uu8X+QaDGawZAebQyk6EC+YvPQrocAHTgdIME5V3R1OgNgqI
 GaB668Nby1nGY6p/R+YiXTNsq/lhvsNXqAuab0gv9rO+BRybWFix1mmCqND7GRyvAU0F
 SHLRWBR0ny5u9rz2zKvsipdYkjvKqrM4Y4khgrfAfzf2o6Jng/IzEfrtU5Sct/egjKwb aQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r2g791q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:10 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8YwLW016628;
        Wed, 23 Sep 2020 08:37:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 33n9m7t1s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b58v27525408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B9911C052;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E251011C05C;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/9] s390/qeth: cancel cmds earlier during teardown
Date:   Wed, 23 Sep 2020 10:36:57 +0200
Message-Id: <20200923083700.44624-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originators of cmd IO typically hold the rtnl or conf_mutex to protect
against a concurrent teardown.
Since qeth_set_offline() already holds the conf_mutex, the main reason
why we still care about cancelling pending cmds is so that they release
the rtnl when we need it ourselves.

So move this step a little earlier into the teardown sequence.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 1 -
 drivers/s390/net/qeth_core_main.c | 6 ++++--
 drivers/s390/net/qeth_l2_main.c   | 4 +---
 drivers/s390/net/qeth_l3_main.c   | 1 -
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f931b764d6a4..711ab5097bd1 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1067,7 +1067,6 @@ void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 int qeth_schedule_recovery(struct qeth_card *card);
 void qeth_flush_local_addrs(struct qeth_card *card);
 int qeth_poll(struct napi_struct *napi, int budget);
-void qeth_clear_ipacmd_list(struct qeth_card *);
 int qeth_qdio_clear_card(struct qeth_card *, int);
 void qeth_clear_working_pool_list(struct qeth_card *);
 void qeth_drain_output_queues(struct qeth_card *card);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 7cd0cbf8a4f0..286787845cae 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -965,7 +965,7 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	}
 }
 
-void qeth_clear_ipacmd_list(struct qeth_card *card)
+static void qeth_clear_ipacmd_list(struct qeth_card *card)
 {
 	struct qeth_cmd_buffer *iob;
 	unsigned long flags;
@@ -977,7 +977,6 @@ void qeth_clear_ipacmd_list(struct qeth_card *card)
 		qeth_notify_cmd(iob, -ECANCELED);
 	spin_unlock_irqrestore(&card->lock, flags);
 }
-EXPORT_SYMBOL_GPL(qeth_clear_ipacmd_list);
 
 static int qeth_check_idx_response(struct qeth_card *card,
 	unsigned char *buffer)
@@ -5334,6 +5333,9 @@ int qeth_set_offline(struct qeth_card *card, bool resetting)
 		card->info.hwtrap = 1;
 	}
 
+	/* cancel any stalled cmd that might block the rtnl: */
+	qeth_clear_ipacmd_list(card);
+
 	rtnl_lock();
 	card->info.open_when_online = card->dev->flags & IFF_UP;
 	dev_close(card->dev);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index e12ac32b8b47..cbd1ab71e785 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -315,10 +315,8 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 	cancel_work_sync(&card->rx_mode_work);
 	qeth_l2_drain_rx_mode_cache(card);
 
-	if (card->state == CARD_STATE_SOFTSETUP) {
-		qeth_clear_ipacmd_list(card);
+	if (card->state == CARD_STATE_SOFTSETUP)
 		card->state = CARD_STATE_DOWN;
-	}
 
 	qeth_qdio_clear_card(card, 0);
 	qeth_drain_output_queues(card);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 0815b64c9797..410c35ca8f4a 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1158,7 +1158,6 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 	if (card->state == CARD_STATE_SOFTSETUP) {
 		card->state = CARD_STATE_DOWN;
 		qeth_l3_clear_ip_htable(card, 1);
-		qeth_clear_ipacmd_list(card);
 	}
 
 	qeth_qdio_clear_card(card, 0);
-- 
2.17.1

