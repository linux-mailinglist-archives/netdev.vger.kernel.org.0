Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEEF2640E5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgIJJFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:05:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbgIJJFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:05:30 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08A92L0S193439;
        Thu, 10 Sep 2020 05:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=5InhXhQG7H61LZ+HF/JHZjfvlg3sWNLWghtDoV2ZkzM=;
 b=FhmfaqtAApJdNY/BRyazQ5uz26uZZv102VbACOHxxJSAtrFLYmMb+rKp9f2yyPiVMdZn
 xJuBI1PEwiO3JpAKCdhMhC4VokLgK/N8xKsUrHSCCSh0EB84GPn76LaaaKszqHmj3shg
 SCQeVgOx+ieLvrFZJADd1boEUuR0DF9iSjpWJ8dKgtFCLoVtGhe2ZaKDD5EA7Ul1RRlD
 gr/zkcHYnfhP5VQjwPMqnqHzuiXAgD7aVO+vAwQ11u2C3pQXr4kqTGG8Aw1inBMref8B
 SIdM0BNC6NscrwzIdEi6sT5zXZzqOVQdUZNc6AfhfCEF+mdOThrlix+kmoNP7f8YjYOk Ew== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fh5nr2ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 05:05:27 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08A92h07022592;
        Thu, 10 Sep 2020 09:05:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8duv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 09:05:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08A95LhB27918782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 09:05:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9584A11C04A;
        Thu, 10 Sep 2020 09:05:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 521CD11C052;
        Thu, 10 Sep 2020 09:05:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 09:05:21 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] s390/qeth: delay draining the TX buffers
Date:   Thu, 10 Sep 2020 11:05:18 +0200
Message-Id: <20200910090518.71420-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wait until the QDIO data connection is severed. Otherwise the device
might still be processing the buffers, and end up accessing skb data
that we already freed.

Fixes: 8b5026bc1693 ("s390/qeth: fix qdio teardown after early init error")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 2 +-
 drivers/s390/net/qeth_l3_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 3a94f6cad167..6384f7adba66 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -284,11 +284,11 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 
 	if (card->state == CARD_STATE_SOFTSETUP) {
 		qeth_clear_ipacmd_list(card);
-		qeth_drain_output_queues(card);
 		card->state = CARD_STATE_DOWN;
 	}
 
 	qeth_qdio_clear_card(card, 0);
+	qeth_drain_output_queues(card);
 	qeth_clear_working_pool_list(card);
 	flush_workqueue(card->event_wq);
 	qeth_flush_local_addrs(card);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 4d461960370d..09ef518ca1ea 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1168,11 +1168,11 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 	if (card->state == CARD_STATE_SOFTSETUP) {
 		qeth_l3_clear_ip_htable(card, 1);
 		qeth_clear_ipacmd_list(card);
-		qeth_drain_output_queues(card);
 		card->state = CARD_STATE_DOWN;
 	}
 
 	qeth_qdio_clear_card(card, 0);
+	qeth_drain_output_queues(card);
 	qeth_clear_working_pool_list(card);
 	flush_workqueue(card->event_wq);
 	qeth_flush_local_addrs(card);
-- 
2.17.1

