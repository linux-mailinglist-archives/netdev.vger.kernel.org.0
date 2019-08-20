Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF054962C5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfHTOrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:47:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730159AbfHTOq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:46:59 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEXk64146360
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:57 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uggvty2gh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:57 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:56 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:53 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEkqKq37486754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E616711C052;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A831711C04C;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/9] s390/qeth: keep cmd alive after IO completion
Date:   Tue, 20 Aug 2019 16:46:38 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820144643.64041-1-jwi@linux.ibm.com>
References: <20190820144643.64041-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082014-0028-0000-0000-00000391B9E2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0029-0000-0000-00002453DE3A
Message-Id: <20190820144643.64041-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code releases the cmd struct after its initial IO has completed.
Any reply processing is done independently, using a separate qeth_reply
struct.
In preparation for merging the cmd and reply structs together, take an
additional reference on the cmd object so that it stays around all the
way until qeth_send_control_data() returns.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 49e85d2e79c2..3fc14f222dc3 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1742,6 +1742,9 @@ static int qeth_send_control_data(struct qeth_card *card,
 
 	qeth_enqueue_reply(card, reply);
 
+	/* This pairs with iob->callback, and keeps the iob alive after IO: */
+	qeth_get_cmd(iob);
+
 	QETH_CARD_TEXT(card, 6, "noirqpnd");
 	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
 	rc = ccw_device_start_timeout(channel->ccwdev, __ccw_from_cmd(iob),
@@ -1752,11 +1755,10 @@ static int qeth_send_control_data(struct qeth_card *card,
 				 CARD_DEVID(card), rc);
 		QETH_CARD_TEXT_(card, 2, " err%d", rc);
 		qeth_dequeue_reply(card, reply);
-		qeth_put_reply(reply);
 		qeth_put_cmd(iob);
 		atomic_set(&channel->irq_pending, 0);
 		wake_up(&card->wait_q);
-		return rc;
+		goto out;
 	}
 
 	timeout = wait_for_completion_interruptible_timeout(&reply->received,
@@ -1777,7 +1779,10 @@ static int qeth_send_control_data(struct qeth_card *card,
 
 	if (!rc)
 		rc = reply->rc;
+
+out:
 	qeth_put_reply(reply);
+	qeth_put_cmd(iob);
 	return rc;
 }
 
-- 
2.17.1

