Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5BB3E4197
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhHIIcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:32:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55674 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233677AbhHIIcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:32:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17985bb2049620;
        Mon, 9 Aug 2021 04:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eoO8mKTqaeIYG06AqQu5qq8OmeMrEzFgcEoG+Wyw15c=;
 b=ZdopJMPi5Cnw6t2uZJ5DSurQwvi2AF3wMFBVBV5KuzUkp435vCo+RfvCSJEq9omKuya9
 yxR8fpvQ4S8eWp7XfGIddRbDZM+KAWSeC7433d4rFqRZKiTAok3nRTBrHHMP/BzeF0Oc
 MrR6cxzbI2J+KHBmvgpKTAP/mqY0WRSRReoJva3F/jmTAsr4AAyu9aM/5LHj4lK0II4X
 tQemoPLUn0U7HjPP6ZEXZHkA61h4hZuvSU9MF8sY8wyl7kWcPmGWLLzlL8NhT3EvKYwa
 2BrNa1W14Ny8lAAHm7sgMU5HNwjSeX74VO8T40QXIJuFybq6S8Ehe+ZXrc4D4lKrB8LH dQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa7fbrrm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:31:35 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798SZ6e001948;
        Mon, 9 Aug 2021 08:31:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3a9hehk9y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:31:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798SK3G59900162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:28:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AD17A404D;
        Mon,  9 Aug 2021 08:31:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3C56A405D;
        Mon,  9 Aug 2021 08:31:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:31:28 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 4/5] net/iucv: get rid of register asm usage
Date:   Mon,  9 Aug 2021 10:30:49 +0200
Message-Id: <20210809083050.2328336-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809083050.2328336-1-kgraul@linux.ibm.com>
References: <20210809083050.2328336-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: myB2_d_6ZgvgddBhY6J9ZDdimCiM5vqh
X-Proofpoint-GUID: myB2_d_6ZgvgddBhY6J9ZDdimCiM5vqh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Using register asm statements has been proven to be very error prone,
especially when using code instrumentation where gcc may add function
calls, which clobbers register contents in an unexpected way.

Therefore get rid of register asm statements in iucv code, even though
there is currently nothing wrong with it. This way we know for sure
that the above mentioned bug class won't be introduced here.

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/iucv.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index e6795d5a546a..bebc7d09815d 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -286,19 +286,19 @@ static union iucv_param *iucv_param_irq[NR_CPUS];
  */
 static inline int __iucv_call_b2f0(int command, union iucv_param *parm)
 {
-	register unsigned long reg0 asm ("0");
-	register unsigned long reg1 asm ("1");
-	int ccode;
+	int cc;
 
-	reg0 = command;
-	reg1 = (unsigned long)parm;
 	asm volatile(
-		"	.long 0xb2f01000\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (ccode), "=m" (*parm), "+d" (reg0), "+a" (reg1)
-		:  "m" (*parm) : "cc");
-	return ccode;
+		"	lgr	0,%[reg0]\n"
+		"	lgr	1,%[reg1]\n"
+		"	.long	0xb2f01000\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=&d" (cc), "+m" (*parm)
+		: [reg0] "d" ((unsigned long)command),
+		  [reg1] "d" ((unsigned long)parm)
+		: "cc", "0", "1");
+	return cc;
 }
 
 static inline int iucv_call_b2f0(int command, union iucv_param *parm)
@@ -319,19 +319,21 @@ static inline int iucv_call_b2f0(int command, union iucv_param *parm)
  */
 static int __iucv_query_maxconn(void *param, unsigned long *max_pathid)
 {
-	register unsigned long reg0 asm ("0");
-	register unsigned long reg1 asm ("1");
-	int ccode;
+	unsigned long reg1 = (unsigned long)param;
+	int cc;
 
-	reg0 = IUCV_QUERY;
-	reg1 = (unsigned long) param;
 	asm volatile (
+		"	lghi	0,%[cmd]\n"
+		"	lgr	1,%[reg1]\n"
 		"	.long	0xb2f01000\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (ccode), "+d" (reg0), "+d" (reg1) : : "cc");
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		"	lgr	%[reg1],1\n"
+		: [cc] "=&d" (cc), [reg1] "+&d" (reg1)
+		: [cmd] "K" (IUCV_QUERY)
+		: "cc", "0", "1");
 	*max_pathid = reg1;
-	return ccode;
+	return cc;
 }
 
 static int iucv_query_maxconn(void)
-- 
2.25.1

