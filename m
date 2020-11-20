Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35882BB940
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgKTWlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729061AbgKTWk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:58 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMY8MF140810
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vE6TD4vKB88qepzH4YUluYyyFAvlIjrzRTQTM9yH+mU=;
 b=AWLOfh7nPDPOpQNy3xNM81vHfuO1NbGdtnA7YyoJsHr6tzqTVQ6UcW6YySg9F/DEuk2n
 28AOs8i+Q5Ir1CD05AkrTzbnAbHQ3PgeKLNcgf0BD6pxlJFmWFnmZE2SfJ4Q7jeKj9j4
 iuPnR6/HWkEfL//2T9U8DbJpDQbgVMNmkGzuIGJ9w9M2FEoFgHeg5iu9w62+jCuWUXVj
 YNYwCzFYGFv5L9mD6Dhi8t09VijSxzxS9R3wpSrIRJZ8S8je1TIp8hcPVrolkUdRkLxD
 ezxEIHGnpeFoIDaJZNT4G2YviLp61mTnDTKWmxRmhQZw6uQXQGLXdXqiaeuUTqS6tf+w 8g== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xj7v78s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:57 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMeADV017279
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 34w5w8tndy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:56 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMenvq13828732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:49 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E7A96E053;
        Fri, 20 Nov 2020 22:40:55 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D6566E050;
        Fri, 20 Nov 2020 22:40:54 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:54 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 05/15] ibmvnic: avoid memset null scrq msgs
Date:   Fri, 20 Nov 2020 16:40:39 -0600
Message-Id: <20201120224049.46933-6-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=3 lowpriorityscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

scrq->msgs could be NULL during device reset, causing Linux to crash.
So, check before memset scrq->msgs.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f0924019e617..ceafd999a1ac 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2882,16 +2882,26 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
 				   struct ibmvnic_sub_crq_queue *scrq)
 {
 	int rc;
+	if (!scrq) {
+		netdev_dbg(adapter->netdev,
+			   "Invalid scrq reset. irq (%d) or msgs (%p).\n",
+			   scrq->irq, scrq->msgs);
+		return -EINVAL;
+	}
 
 	if (scrq->irq) {
 		free_irq(scrq->irq, scrq);
 		irq_dispose_mapping(scrq->irq);
 		scrq->irq = 0;
 	}
-
-	memset(scrq->msgs, 0, 4 * PAGE_SIZE);
-	atomic_set(&scrq->used, 0);
-	scrq->cur = 0;
+	if (scrq->msgs) {
+		memset(scrq->msgs, 0, 4 * PAGE_SIZE);
+		atomic_set(&scrq->used, 0);
+		scrq->cur = 0;
+	} else {
+		netdev_dbg(adapter->netdev, "Invalid scrq reset\n");
+		return -EINVAL;
+	}
 
 	rc = h_reg_sub_crq(adapter->vdev->unit_address, scrq->msg_token,
 			   4 * PAGE_SIZE, &scrq->crq_num, &scrq->hw_irq);
-- 
2.23.0

