Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923C266BA4C
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjAPJ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjAPJ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:27:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9706C166F4;
        Mon, 16 Jan 2023 01:27:27 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8gXtJ004150;
        Mon, 16 Jan 2023 09:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rOduHI9j75NcY66Gt/8WiNTHeUT21xyF119FCQ6qhA8=;
 b=Khc5PY1eEqGUTc8R5GHxpqM1tnjJpYDHhbmkkzuepwTQZxmaOTA8nxYiO8/6Y5ab3QG1
 QEWz+U9TMBFmZ44x6p+e8KdyQIlCMcOVNxRGDvnF3HQZ/jYNSzlUI93exuOIMOfKFH6s
 lDq7j8fw4BoGrNq0IB1q/EcXQ+a4eO/FEeAGNJe1m0DQk+nmGwQFijau2P0e/hDcDQ1E
 5iBhhD6Or4MfVDJMoRZygMBGedtZ2diQQMDCngh3SXIpKLsuWmiMhF+Xc9tJkCr27DPy
 5IkwdvvdadLQPrScbG+Ja4hKGYEccyHP8vxs1zyIhvYd6qPr2M907wYEp2XTuhGq1D+B IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n53a3s3x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30G9GdMI027729;
        Mon, 16 Jan 2023 09:27:24 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n53a3s3w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30FEjHFM025842;
        Mon, 16 Jan 2023 09:27:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16hke4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:21 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30G9RFeb21234226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 09:27:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18BE20040;
        Mon, 16 Jan 2023 09:27:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ABA32004D;
        Mon, 16 Jan 2023 09:27:15 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.177.79])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 09:27:15 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: [net-next 1/8] net/smc: Terminate connections prior to device removal
Date:   Mon, 16 Jan 2023 10:27:05 +0100
Message-Id: <20230116092712.10176-2-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116092712.10176-1-jaka@linux.ibm.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DK1BJ_H2EnDScdvluxi-sHiVUPm_mdkQ
X-Proofpoint-ORIG-GUID: amp44JwqdzH727S4poFRu0ut81oLG8v0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_07,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Removing an ISM device prior to terminating its associated connections
doesn't end well.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 net/smc/smc_ism.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 911fe08bc54b..28e1641f990c 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -462,11 +462,11 @@ void smcd_unregister_dev(struct smcd_dev *smcd)
 {
 	pr_warn_ratelimited("smc: removing smcd device %s\n",
 			    dev_name(&smcd->dev));
+	smcd->going_away = 1;
+	smc_smcd_terminate_all(smcd);
 	mutex_lock(&smcd_dev_list.mutex);
 	list_del_init(&smcd->list);
 	mutex_unlock(&smcd_dev_list.mutex);
-	smcd->going_away = 1;
-	smc_smcd_terminate_all(smcd);
 	destroy_workqueue(smcd->event_wq);
 
 	device_del(&smcd->dev);
-- 
2.25.1

