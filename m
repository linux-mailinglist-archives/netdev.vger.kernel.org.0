Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75A6124DD3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLRQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727185AbfLRQfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:01 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYVk1152836
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:01 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wyq5r1cmu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:00 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:59 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:56 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYswX59965538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8723FA4057;
        Wed, 18 Dec 2019 16:34:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 431AEA4053;
        Wed, 18 Dec 2019 16:34:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 9/9] s390/qeth: make use of napi_schedule_irqoff()
Date:   Wed, 18 Dec 2019 17:34:50 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-4275-0000-0000-0000039064DB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-4276-0000-0000-000038A42F17
Message-Id: <20191218163450.36731-10-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=629
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_qdio_start_poll() is called from the qdio layer's IRQ handler,
while IRQs are masked.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6b55271091cb..78349355c582 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3402,7 +3402,7 @@ static void qeth_qdio_start_poll(struct ccw_device *ccwdev, int queue,
 	struct qeth_card *card = (struct qeth_card *)card_ptr;
 
 	if (card->dev->flags & IFF_UP)
-		napi_schedule(&card->napi);
+		napi_schedule_irqoff(&card->napi);
 }
 
 int qeth_configure_cq(struct qeth_card *card, enum qeth_cq cq)
-- 
2.17.1

