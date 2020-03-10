Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66451804FC
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCJRiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:38:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726655AbgCJRiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:38:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AHZkSH088666
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 13:38:11 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ynr9dnchn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 13:38:11 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 10 Mar 2020 17:38:09 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Mar 2020 17:38:06 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AHb5WD45678856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 17:37:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0795CAE053;
        Tue, 10 Mar 2020 17:38:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4727AE057;
        Tue, 10 Mar 2020 17:38:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 17:38:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/3] s390/qeth: cancel RX reclaim work earlier
Date:   Tue, 10 Mar 2020 18:38:03 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310173803.91602-1-jwi@linux.ibm.com>
References: <20200310173803.91602-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031017-4275-0000-0000-000003AA4D6B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031017-4276-0000-0000-000038BF6769
Message-Id: <20200310173803.91602-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_12:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth's napi poll code fails to refill an entirely empty RX ring, it
kicks off buffer_reclaim_work to try again later.

Make sure that this worker is cancelled when setting the qeth device
offline. Otherwise a RX refill action can unexpectedly end up running
concurrently to bigger re-configurations (eg. resizing the buffer pool),
without any locking.

Fixes: b333293058aa ("qeth: add support for af_iucv HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 1 -
 drivers/s390/net/qeth_l2_main.c   | 1 +
 drivers/s390/net/qeth_l3_main.c   | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d8f0c610396e..a599801d7727 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2392,7 +2392,6 @@ static void qeth_free_qdio_queues(struct qeth_card *card)
 		return;
 
 	qeth_free_cq(card);
-	cancel_delayed_work_sync(&card->buffer_reclaim_work);
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
 		if (card->qdio.in_q->bufs[j].rx_skb)
 			dev_kfree_skb_any(card->qdio.in_q->bufs[j].rx_skb);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9972d96820f3..8fb29371788b 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -284,6 +284,7 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 	if (card->state == CARD_STATE_SOFTSETUP) {
 		qeth_clear_ipacmd_list(card);
 		qeth_drain_output_queues(card);
+		cancel_delayed_work_sync(&card->buffer_reclaim_work);
 		card->state = CARD_STATE_DOWN;
 	}
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 317d56647a4a..82f800d1d7b3 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1178,6 +1178,7 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		qeth_l3_clear_ip_htable(card, 1);
 		qeth_clear_ipacmd_list(card);
 		qeth_drain_output_queues(card);
+		cancel_delayed_work_sync(&card->buffer_reclaim_work);
 		card->state = CARD_STATE_DOWN;
 	}
 
-- 
2.17.1

