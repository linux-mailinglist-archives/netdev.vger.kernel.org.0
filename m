Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435022C19B6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgKWX6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbgKWX6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:13 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNXGXW123485
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=T8u6cizX0S78DfiyW0z+kf2a1iC98+7EPKj6ICAPdtI=;
 b=rwcmEDu7eqdsLzPHI0rONSplDbrnKqOpQQ0zbH6SKcvyNpGGgVvFCrvtkssNXnuWMHtp
 vC1wOhSLmnsG+NTOvN0QKgZ1t1qqenWjVmHU8lOjPRcx0W/77pHiNPnQy1N4mk/GKT4N
 KRexO6KSSGEs3ZGFg1mmt8Co2bXfz2tXEfAOaCkWTA2X9+bWHrRNF25sdNomWxGHRYNT
 onO7hCHrZDbPQ7uX0dhiSjcm7IiTC7tbVWTGf+FNyUVIh3NbnNHXNA90DlOuK/kqTkLT
 UVi1FfoabqBIFSMjePe7tCwYnZlSaDwSIaIh9gF+VlPZ6A+egYW9WIQJq+LCMWJsNMDk Xw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350pqv0jss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:12 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNwBDk028206
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:11 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 34ym4fup3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwBMr15401544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:11 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09C152805C;
        Mon, 23 Nov 2020 23:58:11 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B403D28059;
        Mon, 23 Nov 2020 23:58:10 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:10 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 2/9] ibmvnic: stop free_all_rwi on failed reset
Date:   Mon, 23 Nov 2020 18:57:50 -0500
Message-Id: <20201123235757.6466-3-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=3 mlxlogscore=959 mlxscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ibmvnic fails to reset, it breaks out of the reset loop and frees
all of the remaining resets from the workqueue. Doing so prevents the
adapter from recovering if no reset is scheduled after that. Instead,
have the driver continue to process resets on the workqueue.

Remove the no longer need free_all_rwi().

Fixes: ed651a10875f1 ("ibmvnic: Updated reset handling")

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index dcb23015b6b4..d5a927bb4954 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2173,17 +2173,6 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
 	return rwi;
 }
 
-static void free_all_rwi(struct ibmvnic_adapter *adapter)
-{
-	struct ibmvnic_rwi *rwi;
-
-	rwi = get_next_rwi(adapter);
-	while (rwi) {
-		kfree(rwi);
-		rwi = get_next_rwi(adapter);
-	}
-}
-
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_rwi *rwi;
@@ -2253,9 +2242,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 			else
 				adapter->state = reset_state;
 			rc = 0;
-		} else if (rc && rc != IBMVNIC_INIT_FAILED &&
-		    !adapter->force_reset_recovery)
-			break;
+		}
+		if (rc)
+			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
 
 		rwi = get_next_rwi(adapter);
 
@@ -2269,11 +2258,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 		complete(&adapter->reset_done);
 	}
 
-	if (rc) {
-		netdev_dbg(adapter->netdev, "Reset failed\n");
-		free_all_rwi(adapter);
-	}
-
 	clear_bit_unlock(0, &adapter->resetting);
 }
 
-- 
2.26.2

