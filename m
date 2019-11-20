Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A841103B4A
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfKTNXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:23:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728530AbfKTNVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:21:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKDIPKp133559
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 08:21:07 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf57g43p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 08:21:07 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 20 Nov 2019 13:21:04 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 20 Nov 2019 13:21:02 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAKDL1SF57475304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 13:21:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7E7852051;
        Wed, 20 Nov 2019 13:21:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A14FA52054;
        Wed, 20 Nov 2019 13:21:00 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/2] s390/qeth: return proper errno on IO error
Date:   Wed, 20 Nov 2019 14:20:57 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120132057.1788-1-jwi@linux.ibm.com>
References: <20191120132057.1788-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19112013-0020-0000-0000-0000038C5EE8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112013-0021-0000-0000-000021E29293
Message-Id: <20191120132057.1788-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_03:2019-11-15,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911200120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When propagating IO errors back to userspace, one error path in
qeth_irq() currently returns '1' instead of a proper errno.

Fixes: 54daaca7024d ("s390/qeth: cancel cmd on early error")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index dda274351c21..83794d7494d4 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -901,30 +901,30 @@ static int qeth_get_problem(struct qeth_card *card, struct ccw_device *cdev,
 				 CCW_DEVID(cdev), dstat, cstat);
 		print_hex_dump(KERN_WARNING, "qeth: irb ", DUMP_PREFIX_OFFSET,
 				16, 1, irb, 64, 1);
-		return 1;
+		return -EIO;
 	}
 
 	if (dstat & DEV_STAT_UNIT_CHECK) {
 		if (sense[SENSE_RESETTING_EVENT_BYTE] &
 		    SENSE_RESETTING_EVENT_FLAG) {
 			QETH_CARD_TEXT(card, 2, "REVIND");
-			return 1;
+			return -EIO;
 		}
 		if (sense[SENSE_COMMAND_REJECT_BYTE] &
 		    SENSE_COMMAND_REJECT_FLAG) {
 			QETH_CARD_TEXT(card, 2, "CMDREJi");
-			return 1;
+			return -EIO;
 		}
 		if ((sense[2] == 0xaf) && (sense[3] == 0xfe)) {
 			QETH_CARD_TEXT(card, 2, "AFFE");
-			return 1;
+			return -EIO;
 		}
 		if ((!sense[0]) && (!sense[1]) && (!sense[2]) && (!sense[3])) {
 			QETH_CARD_TEXT(card, 2, "ZEROSEN");
 			return 0;
 		}
 		QETH_CARD_TEXT(card, 2, "DGENCHK");
-			return 1;
+			return -EIO;
 	}
 	return 0;
 }
-- 
2.17.1

