Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8557254076
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgH0IRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:17:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727786AbgH0IRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:17:16 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R845Be179915;
        Thu, 27 Aug 2020 04:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=KhL7DEOLCWjmYkYI8Arat3QGC71rlHY0QAeGWpTlP4s=;
 b=dhAJXETozAcwGTjWsYBmhhm0M20efBUZf7dlNTa+AFS5cpmbRQPwO/tFioLdO484T0bb
 PTEKzFMoJFrvN6ZFnwGqDBasN5qiN4h0Osl0M/v8tHz0wjT5ffMBPYSTfs5hwZ+YN4DK
 VZhETGpeW2MFvmTfs4p7PsVQmXKq8S2vQshbA2oZ6aDMcqFdBDQbCnWPhqAX2/A8tZMe
 D+N2YbcCzUkyRuua7zt2kAszPeLM1IkUlTR/vgw8nAm9xSjfVHy2Qd4TE232E9MvkAeo
 ar0HuAlJZyW5XN4t95du+G8boG6mcaGsfLV8yzv+Ac6QRS/z5eborv0uMnAjHiKiCfqr KA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3368aqhqgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:17:14 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8Cdh5004013;
        Thu, 27 Aug 2020 08:17:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 332utq3aw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8H9H523789956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4556D4C04E;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 039D44C058;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/8] s390/qeth: don't disable address events during initialization
Date:   Thu, 27 Aug 2020 10:17:01 +0200
Message-Id: <20200827081705.21922-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827081705.21922-1-jwi@linux.ibm.com>
References: <20200827081705.21922-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=861 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A newly initialized device is disabled for address events, there's no
need to explicitly disable them.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 8b342a88ff5c..ea966713ce7e 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -810,8 +810,6 @@ static void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 	if (card->options.sbp.hostnotification) {
 		if (qeth_bridgeport_an_set(card, 1))
 			card->options.sbp.hostnotification = 0;
-	} else {
-		qeth_bridgeport_an_set(card, 0);
 	}
 }
 
-- 
2.17.1

