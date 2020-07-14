Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA5F21F3EB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgGNOXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728713AbgGNOXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE3Ml5009935;
        Tue, 14 Jul 2020 10:23:18 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 327tnac04b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:18 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEHSBe021597;
        Tue, 14 Jul 2020 14:23:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgub5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENDOu22544522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C654A4C050;
        Tue, 14 Jul 2020 14:23:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DBF54C059;
        Tue, 14 Jul 2020 14:23:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:23:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 04/10] s390/qeth: don't clear the configured isolation mode
Date:   Tue, 14 Jul 2020 16:22:59 +0200
Message-Id: <20200714142305.29297-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth_set_access_ctrl_online() is called during the device's
initialization and discovers that isolation mode isn't supported, don't
clear the user's currently configured mode.
They intentionally choose to operate the device in this specific mode,
and degrading the isolation is not an option.

Only adjust the configuration when called via sysfs (ie. fallback = 1),
and here follow the common pattern and restore it from prev_isolation.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 514795c5eaad..782a5128ac04 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4663,19 +4663,19 @@ int qeth_set_access_ctrl_online(struct qeth_card *card, int fallback)
 
 	QETH_CARD_TEXT(card, 4, "setactlo");
 
-	if (qeth_adp_supported(card, IPA_SETADP_SET_ACCESS_CONTROL)) {
-		rc = qeth_setadpparms_set_access_ctrl(card,
-			card->options.isolation, fallback);
-		if (rc) {
-			QETH_DBF_MESSAGE(3, "IPA(SET_ACCESS_CTRL(%d) on device %x: sent failed\n",
-					 rc, CARD_DEVID(card));
-			rc = -EOPNOTSUPP;
-		}
-	} else if (card->options.isolation != ISOLATION_MODE_NONE) {
-		card->options.isolation = ISOLATION_MODE_NONE;
-
+	if (!qeth_adp_supported(card, IPA_SETADP_SET_ACCESS_CONTROL)) {
 		dev_err(&card->gdev->dev, "Adapter does not "
 			"support QDIO data connection isolation\n");
+		if (fallback)
+			card->options.isolation = card->options.prev_isolation;
+		return -EOPNOTSUPP;
+	}
+
+	rc = qeth_setadpparms_set_access_ctrl(card, card->options.isolation,
+					      fallback);
+	if (rc) {
+		QETH_DBF_MESSAGE(3, "IPA(SET_ACCESS_CTRL(%d) on device %x: sent failed\n",
+				 rc, CARD_DEVID(card));
 		rc = -EOPNOTSUPP;
 	}
 	return rc;
-- 
2.17.1

