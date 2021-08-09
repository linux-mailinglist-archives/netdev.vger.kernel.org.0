Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC283E419C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhHIIcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:32:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233963AbhHIIcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:32:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798V3l3155658;
        Mon, 9 Aug 2021 04:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wuCNE5hszSOK1eC97D97HL/5AOJuP9fMOyFaEs1Jdp8=;
 b=SF6BV5MlONKesI2kRHZaswLWvUGVkjfE2SdeY8p2PjBgAcoB0jf7S5eJUM5PzOhza1n0
 6lWfUb020wYwSeONL7+wPsKCxC4DzwcRfB3CS0XqXcSoRVqT/qhgqMB2EibQVdXoGNl4
 +Bjn3jCZOjGKobUj2nOShtrSFHJ/4kD7Zo++ZA3sX3djxHqKrhH8g2BVCBa+dR68NTwZ
 zsIYBYl2XD8lUitypVhp6zhNY0ar0hsBZUzM0f1/kwtwoVz0AqHGubEhYl4wPvj0tqIk
 oGstqNCxd61KN0CutHzpEtePI9Rviupn++1QEx9/rbB9xcauUvQFjKcFa4J5ZOuuphnQ qA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab0x180em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:31:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798S72T023791;
        Mon, 9 Aug 2021 08:31:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8umcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:31:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798VSar50135480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:31:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EF86A4078;
        Mon,  9 Aug 2021 08:31:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A66C1A4072;
        Mon,  9 Aug 2021 08:31:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:31:27 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 3/5] net/af_iucv: remove wrappers around iucv (de-)registration
Date:   Mon,  9 Aug 2021 10:30:48 +0200
Message-Id: <20210809083050.2328336-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809083050.2328336-1-kgraul@linux.ibm.com>
References: <20210809083050.2328336-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IJgbbE_vsFKanumNV55LvsDVbce4MQVh
X-Proofpoint-ORIG-GUID: IJgbbE_vsFKanumNV55LvsDVbce4MQVh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

These wrappers are just unnecessary obfuscation.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/af_iucv.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 4bff26f7faff..18316ee3c692 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2264,16 +2264,6 @@ static struct packet_type iucv_packet_type = {
 	.func = afiucv_hs_rcv,
 };
 
-static int afiucv_iucv_init(void)
-{
-	return pr_iucv->iucv_register(&af_iucv_handler, 0);
-}
-
-static void afiucv_iucv_exit(void)
-{
-	pr_iucv->iucv_unregister(&af_iucv_handler, 0);
-}
-
 static int __init afiucv_init(void)
 {
 	int err;
@@ -2300,7 +2290,7 @@ static int __init afiucv_init(void)
 		goto out_proto;
 
 	if (pr_iucv) {
-		err = afiucv_iucv_init();
+		err = pr_iucv->iucv_register(&af_iucv_handler, 0);
 		if (err)
 			goto out_sock;
 	}
@@ -2314,7 +2304,7 @@ static int __init afiucv_init(void)
 
 out_notifier:
 	if (pr_iucv)
-		afiucv_iucv_exit();
+		pr_iucv->iucv_unregister(&af_iucv_handler, 0);
 out_sock:
 	sock_unregister(PF_IUCV);
 out_proto:
@@ -2326,7 +2316,7 @@ static int __init afiucv_init(void)
 static void __exit afiucv_exit(void)
 {
 	if (pr_iucv)
-		afiucv_iucv_exit();
+		pr_iucv->iucv_unregister(&af_iucv_handler, 0);
 
 	unregister_netdevice_notifier(&afiucv_netdev_notifier);
 	dev_remove_pack(&iucv_packet_type);
-- 
2.25.1

