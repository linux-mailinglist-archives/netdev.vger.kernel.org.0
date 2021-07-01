Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA9F3B943B
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhGAPrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:47:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233421AbhGAPrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:47:01 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161FXL4e012876;
        Thu, 1 Jul 2021 11:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=43UWVjmq7/8olSR+8svPSjiK1548/+S6Z7TqTNBbhf0=;
 b=l7PE7+OKNLKsXHbsaR3Lmd68SRqGR42mMTvpdZlGpo04ssahzmu9GhFRZt/ZZ0RQ2bjY
 8FEPtWhjuc1oeT0nZHIjw7PWgQZqnCJ+cajtRXTtJn2xAsVOVFCfOC5XqN69UYRcRgfh
 XlTRj1rgPTpdWKImUFL/Uy/ra9kVfaNyJf7l8OgtJgjOchzYpWyATaWX6PyBlSVDDUOR
 4gxvtj7wjLEAFwk5GxzJ6xKazWTSFtxXVJ8/wxz//ZrnqfYPkx6y2cI7B7PJLvgndRFR
 +nFKRWhHN272J9zq8NAcj27QUC8g7sn6IaRL2R9PEmKBNlXQWhEfq1/3g6gZwscbetAG tg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39hed8mjcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 11:44:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 161Fcguq000720;
        Thu, 1 Jul 2021 15:44:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 39h19bgfqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 15:44:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 161Fgh8615663538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jul 2021 15:42:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F0B0AE070;
        Thu,  1 Jul 2021 15:44:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC67CAE087;
        Thu,  1 Jul 2021 15:44:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jul 2021 15:44:21 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next] s390: iucv: Avoid field over-reading memcpy()
Date:   Thu,  1 Jul 2021 17:44:07 +0200
Message-Id: <20210701154407.3889397-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jopWbVSmZLjOJNk56ieopXI6kTsD2lzS
X-Proofpoint-ORIG-GUID: jopWbVSmZLjOJNk56ieopXI6kTsD2lzS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_08:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=790 mlxscore=0
 clxscore=1011 bulkscore=0 phishscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

Add a wrapping struct to serve as the memcpy() source so the compiler
can perform appropriate bounds checking, avoiding this future warning:

In function '__fortify_memcpy',
    inlined from 'iucv_message_pending' at net/iucv/iucv.c:1663:4:
./include/linux/fortify-string.h:246:4: error: call to '__read_overflow2_field' declared with attribute error: detected read beyond size of field (2nd parameter)

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/iucv.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 349c6ac3313f..e6795d5a546a 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1635,14 +1635,16 @@ struct iucv_message_pending {
 	u8  iptype;
 	u32 ipmsgid;
 	u32 iptrgcls;
-	union {
-		u32 iprmmsg1_u32;
-		u8  iprmmsg1[4];
-	} ln1msg1;
-	union {
-		u32 ipbfln1f;
-		u8  iprmmsg2[4];
-	} ln1msg2;
+	struct {
+		union {
+			u32 iprmmsg1_u32;
+			u8  iprmmsg1[4];
+		} ln1msg1;
+		union {
+			u32 ipbfln1f;
+			u8  iprmmsg2[4];
+		} ln1msg2;
+	} rmmsg;
 	u32 res1[3];
 	u32 ipbfln2f;
 	u8  ippollfg;
@@ -1660,10 +1662,10 @@ static void iucv_message_pending(struct iucv_irq_data *data)
 		msg.id = imp->ipmsgid;
 		msg.class = imp->iptrgcls;
 		if (imp->ipflags1 & IUCV_IPRMDATA) {
-			memcpy(msg.rmmsg, imp->ln1msg1.iprmmsg1, 8);
+			memcpy(msg.rmmsg, &imp->rmmsg, 8);
 			msg.length = 8;
 		} else
-			msg.length = imp->ln1msg2.ipbfln1f;
+			msg.length = imp->rmmsg.ln1msg2.ipbfln1f;
 		msg.reply_size = imp->ipbfln2f;
 		path->handler->message_pending(path, &msg);
 	}
-- 
2.25.1

