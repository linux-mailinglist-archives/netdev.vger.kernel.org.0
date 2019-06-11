Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080653D268
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405640AbfFKQiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404377AbfFKQiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:13 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGRJVY021964
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:12 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2enacfvf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:12 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:07 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc5jU35979352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E6CD4C052;
        Tue, 11 Jun 2019 16:38:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FDAD4C044;
        Tue, 11 Jun 2019 16:38:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 03/13] s390/qeth: simplify DOWN state handling
Date:   Tue, 11 Jun 2019 18:37:50 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0016-0000-0000-000002882EC8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0017-0000-0000-000032E55E9A
Message-Id: <20190611163800.64730-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the tear down sequence in qeth_l?_stop_card() has finished, the
card is guaranteed to be in DOWN state and we don't have to check for
it again.
With this insight we can also remove the redundant setting of
card->state in qeth_l?_set_online()'s error path.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 7 ++-----
 drivers/s390/net/qeth_l3_main.c | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index ff8a6cd790b1..40e2f6bd0f09 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -292,11 +292,9 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 		qeth_clear_working_pool_list(card);
 		card->state = CARD_STATE_DOWN;
 	}
-	if (card->state == CARD_STATE_DOWN) {
-		qeth_clear_cmd_buffers(&card->read);
-		qeth_clear_cmd_buffers(&card->write);
-	}
 
+	qeth_clear_cmd_buffers(&card->read);
+	qeth_clear_cmd_buffers(&card->write);
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
 }
@@ -882,7 +880,6 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	ccw_device_set_offline(CARD_WDEV(card));
 	ccw_device_set_offline(CARD_RDEV(card));
 	qdio_free(CARD_DDEV(card));
-	card->state = CARD_STATE_DOWN;
 
 	mutex_unlock(&card->conf_mutex);
 	mutex_unlock(&card->discipline_mutex);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 13bf3e2e9cea..99ca38164b99 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1436,11 +1436,9 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		qeth_clear_working_pool_list(card);
 		card->state = CARD_STATE_DOWN;
 	}
-	if (card->state == CARD_STATE_DOWN) {
-		qeth_clear_cmd_buffers(&card->read);
-		qeth_clear_cmd_buffers(&card->write);
-	}
 
+	qeth_clear_cmd_buffers(&card->read);
+	qeth_clear_cmd_buffers(&card->write);
 	flush_workqueue(card->event_wq);
 }
 
@@ -2420,7 +2418,6 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 	ccw_device_set_offline(CARD_WDEV(card));
 	ccw_device_set_offline(CARD_RDEV(card));
 	qdio_free(CARD_DDEV(card));
-	card->state = CARD_STATE_DOWN;
 
 	mutex_unlock(&card->conf_mutex);
 	mutex_unlock(&card->discipline_mutex);
-- 
2.17.1

