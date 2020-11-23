Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75012C19B5
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgKWX6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728037AbgKWX6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:13 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNW4mb082105
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=eXWkKYgATA2Ssdx3rZxSblcPBycQY9f0aXRWboF+yTA=;
 b=tknrAPx7kXZjSb+gOsv8SfgqxEXA0JE4GC32qh4e8M3XWEkOddPTOYCxQ+ohknvH6QNv
 Do/P5RXsVkalRN2QaYSw6OCyraWUQP2RxngFCzWR0tQaZH+QAH2UqXnwa381J+Nd0k1G
 nGR/gM8yoFHtQ7gM0Qfw2nNDCqxQZZY0T5KlQWf4HzOP+F0B4ZGSs6wpwSNj/4IqOm7e
 5tysrun1XE+R5V+uwfWai2erac2/TYRY59A0deGd+EG5W+4yoFAmOLkSD158lxa8ennI
 ZTswgFhjfmDeU0oVar9DfYhB/qEp8fL+/DmIWMZKZ2yYao+Jr6p7fF8BfYdDb3uDSTzf dg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350ga2dcd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:13 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNqiBX001467
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:12 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 34xth8ysqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:12 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwBas15401546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:11 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75A0E2805C;
        Mon, 23 Nov 2020 23:58:11 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BD0128059;
        Mon, 23 Nov 2020 23:58:11 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:11 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 3/9] ibmvnic: avoid memset null scrq msgs
Date:   Mon, 23 Nov 2020 18:57:51 -0500
Message-Id: <20201123235757.6466-4-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=3 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

scrq->msgs could be NULL during device reset, causing Linux to crash.
So, check before memset scrq->msgs.

Fixes: c8b2ad0a4a901 ("ibmvnic: Sanitize entire SCRQ buffer on reset")

Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d5a927bb4954..e84255c2fc72 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2844,16 +2844,26 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
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
2.26.2

