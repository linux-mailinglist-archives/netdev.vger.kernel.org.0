Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDDA3B2617
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFXERs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:17:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59702 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230036AbhFXEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:14 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O42hq5034607
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mTkIR3j3GpBgnLHUqivbNRewGZEgbD+PaY6bu2hkrcI=;
 b=TWiq9XEj8oy9TycysAiDSYFvO2/6XD4rIa2sNH8XIF52E6OGMz4wBXAyVEqfp1LM+H54
 XBAlXm9dPFebdMO33k1RB+J3+tzpvp71VXeUeaOkclfFG5I+FQgKw+tTsQK9adWzanX0
 1MnRyR16m7RLS58F5WXuDJm2TYOZmtEkSgNufV52TQl8ePsOspW300WdmLb+aWH6mT9A
 tflWQOJhHBCqZEBHM11lytuniV5wZcLJ0g/S55pUcGVY1/hCpYuBAl4GQeMRld698vT8
 XeiOmPuz1wE8IDG3j6yuUgzoNnkQRKVoS/N5b4utMpNxjuGP+cpTtWqZybPC2wyUaX/5 hw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cjk78drp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:26 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O4Aigc003539
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:26 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 399879wqww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:26 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DO7135586372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:24 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7CCB6A047;
        Thu, 24 Jun 2021 04:13:24 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EE076A04F;
        Thu, 24 Jun 2021 04:13:23 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:23 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 5/7] ibmvnic: set ltb->buff to NULL after freeing
Date:   Wed, 23 Jun 2021 21:13:14 -0700
Message-Id: <20210624041316.567622-6-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NiPLmQwn569PfgrUcODPs8f2kOrC7Tv2
X-Proofpoint-GUID: NiPLmQwn569PfgrUcODPs8f2kOrC7Tv2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

free_long_term_buff() checks ltb->buff to decide whether we have a long
term buffer to free. So set ltb->buff to NULL afer freeing. While here,
also clear ->map_id, fix up some coding style and log an error.

Fixes: 9c4eaabd1bb39 ("Check CRQ command return codes")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b1d7caaa4fb7..b56406ca90c0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -234,12 +234,11 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	mutex_lock(&adapter->fw_lock);
 	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
-	rc = send_request_map(adapter, ltb->addr,
-			      ltb->size, ltb->map_id);
+
+	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
 	if (rc) {
-		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
+		dev_err(dev, "send_request_map failed, rc = %d\n", rc);
+		goto out;
 	}
 
 	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
@@ -247,20 +246,23 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 		dev_err(dev,
 			"Long term map request aborted or timed out,rc = %d\n",
 			rc);
-		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
+		goto out;
 	}
 
 	if (adapter->fw_done_rc) {
 		dev_err(dev, "Couldn't map long term buffer,rc = %d\n",
 			adapter->fw_done_rc);
+		rc = -1;
+		goto out;
+	}
+	rc = 0;
+out:
+	if (rc) {
 		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		mutex_unlock(&adapter->fw_lock);
-		return -1;
+		ltb->buff = NULL;
 	}
 	mutex_unlock(&adapter->fw_lock);
-	return 0;
+	return rc;
 }
 
 static void free_long_term_buff(struct ibmvnic_adapter *adapter,
@@ -280,6 +282,8 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
 		send_request_unmap(adapter, ltb->map_id);
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+	ltb->buff = NULL;
+	ltb->map_id = 0;
 }
 
 static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
-- 
2.31.1

