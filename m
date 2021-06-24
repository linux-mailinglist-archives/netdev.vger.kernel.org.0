Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBF03B2619
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFXESS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:18:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhFXEQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O43bEh026107
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i4YeZl+UWit3mOWMLX93BjI4C+hV3l2AzO//0T+5GCQ=;
 b=SJ8EqsCLSA2UfNrPS8FZHmiknNaFfkmBeYHUaMx3X41Ok7wQlWFRoD4Kj6X/pt6XkygV
 9wqxlyJc5tqKKOgIy+5uxP7pC/SqLdhi8HRV9xyYevjVduJqh+8W20M+Wy3z+HCX1wJI
 7QgUx2C3dOABUObVI0qELW/mRVxXm1isZsxIjcNhtVkXNLd1WFKFaFlcN0O9EqK3ceiC
 5N2DJI0/Ro5c/u+gKBgIUo2EcQJaVLENCI8BacZv+ZBHOb3+sl1GYs+JfgT0xVI8AWr0
 xK5xmaGx4pevZ95Qn48xupMJodm8aYVuUXWdekoumV3XrZonRDoIMWPheoTCa5NJkcmd tA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ch58jfcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:28 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O49tJV025810
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:27 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 399879ns2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:27 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DQhL24576316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:26 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 024596A047;
        Thu, 24 Jun 2021 04:13:26 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E44F06A04D;
        Thu, 24 Jun 2021 04:13:24 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:24 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 6/7] ibmvnic: free tx_pool if tso_pool alloc fails
Date:   Wed, 23 Jun 2021 21:13:15 -0700
Message-Id: <20210624041316.567622-7-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xuc6NY6V_2--Tp54wNpu91PDIAw1DJ3y
X-Proofpoint-GUID: xuc6NY6V_2--Tp54wNpu91PDIAw1DJ3y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free tx_pool and clear it, if allocation of tso_pool fails.

release_tx_pools() assumes we have both tx and tso_pools if ->tx_pool is
non-NULL. If allocation of tso_pool fails in init_tx_pools(), the assumption
will not be true and we would end up dereferencing ->tx_buff, ->free_map
fields from a NULL pointer.

Fixes: 3205306c6b8d ("ibmvnic: Update TX pool initialization routine")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b56406ca90c0..363a5d5503ad 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -801,8 +801,11 @@ static int init_tx_pools(struct net_device *netdev)
 
 	adapter->tso_pool = kcalloc(tx_subcrqs,
 				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
-	if (!adapter->tso_pool)
+	if (!adapter->tso_pool) {
+		kfree(adapter->tx_pool);
+		adapter->tx_pool = NULL;
 		return -1;
+	}
 
 	adapter->num_active_tx_pools = tx_subcrqs;
 
-- 
2.31.1

