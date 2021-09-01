Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B573FD021
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhIAALZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:11:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18422 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243454AbhIAAJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:25 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18104MCj017476
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rgXlw79O5KWH41cwlhskB8Nx+HLW3z7nqzsBO2UiKLc=;
 b=QUqzMYzqXkKDL6iBvYsAADjHCscmQjhTyQPF4APHw5vhkKH+WRznADqx8BpDSq2DFO4V
 bTH9V/ygdZoHsH+riam10/+5n83NDFRoHFoCtTfCO/cREXdg8W2AmndTgEibNYcpfnCt
 P6P7DybVLGc4+9KsvyhmuCgzdvpAOQMckgk/9belF4WA6XeU6SpPwquHPwnAVJs45e8K
 nssPsHI5V5G6u9JhPHLD+O9sV6S5E1ne8SUhNF3IItm7bh07tV+uKvZoR6YaqgcG4x1h
 fuB27DN1EM9ZrsmN6t38mSx9tQA4wpQG2z/3/KOF0zm+pJoLQs2kn0yBmxcfEQbW4hYf SQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aswqgh3x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:29 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18107mRS005490
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:28 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3astd0xgxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:28 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108Q1p15270590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:26 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC2FB78066;
        Wed,  1 Sep 2021 00:08:26 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AF137805C;
        Wed,  1 Sep 2021 00:08:25 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:25 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 7/9] ibmvnic: Reuse LTB when possible
Date:   Tue, 31 Aug 2021 17:08:10 -0700
Message-Id: <20210901000812.120968-8-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 45mfETdDTHr0fZovSGqzWP0DdbR9I7yl
X-Proofpoint-ORIG-GUID: 45mfETdDTHr0fZovSGqzWP0DdbR9I7yl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the long term buffer during a reset as long as its size has
not changed. If the size has changed, free it and allocate a new
one of the appropriate size.

When we do this, alloc_long_term_buff() and reset_long_term_buff()
become identical. Drop reset_long_term_buff().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 122 ++++++++++++++---------------
 1 file changed, 59 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 30153a8bb5ec..1bb5996c4313 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -108,6 +108,8 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
 static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 					 struct ibmvnic_sub_crq_queue *tx_scrq);
+static void free_long_term_buff(struct ibmvnic_adapter *adapter,
+				struct ibmvnic_long_term_buff *ltb);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -214,23 +216,62 @@ static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
 	return -ETIMEDOUT;
 }
 
+/**
+ * Reuse long term buffer unless size has changed.
+ */
+static bool reuse_ltb(struct ibmvnic_long_term_buff *ltb, int size)
+{
+	return (ltb->buff && ltb->size == size);
+}
+
+/**
+ * Allocate a long term buffer of the specified size and notify VIOS.
+ *
+ * If the given @ltb already has the correct size, reuse it. Otherwise if
+ * its non-NULL, free it. Then allocate a new one of the correct size.
+ * Notify the VIOS either way since we may now be working with a new VIOS.
+ *
+ * Allocating larger chunks of memory during resets, specially LPM or under
+ * low memory situations can cause resets to fail/timeout and for LPAR to
+ * lose connectivity. So hold onto the LTB even if we fail to communicate
+ * with the VIOS and reuse it on next open. Free LTB when adapter is closed.
+ */
 static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb, int size)
 {
 	struct device *dev = &adapter->vdev->dev;
 	int rc;
 
-	ltb->size = size;
-	ltb->buff = dma_alloc_coherent(dev, ltb->size, &ltb->addr,
-				       GFP_KERNEL);
+	if (!reuse_ltb(ltb, size)) {
+		dev_dbg(dev,
+			"LTB size changed from 0x%llx to 0x%x, reallocating\n",
+			 ltb->size, size);
+		free_long_term_buff(adapter, ltb);
+	}
 
-	if (!ltb->buff) {
-		dev_err(dev, "Couldn't alloc long term buffer\n");
-		return -ENOMEM;
+	if (ltb->buff) {
+		dev_dbg(dev, "Reusing LTB [map %d, size 0x%llx]\n",
+			ltb->map_id, ltb->size);
+	} else {
+		ltb->buff = dma_alloc_coherent(dev, size, &ltb->addr,
+					       GFP_KERNEL);
+		if (!ltb->buff) {
+			dev_err(dev, "Couldn't alloc long term buffer\n");
+			return -ENOMEM;
+		}
+		ltb->size = size;
+
+		ltb->map_id = find_first_zero_bit(adapter->map_ids,
+						  MAX_MAP_ID);
+		bitmap_set(adapter->map_ids, ltb->map_id, 1);
+
+		dev_dbg(dev,
+			"Allocated new LTB [map %d, size 0x%llx]\n",
+			 ltb->map_id, ltb->size);
 	}
-	ltb->map_id = find_first_zero_bit(adapter->map_ids,
-					  MAX_MAP_ID);
-	bitmap_set(adapter->map_ids, ltb->map_id, 1);
+
+	/* Ensure ltb is zeroed - specially when reusing it. */
+	memset(ltb->buff, 0, ltb->size);
 
 	mutex_lock(&adapter->fw_lock);
 	adapter->fw_done_rc = 0;
@@ -257,10 +298,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	}
 	rc = 0;
 out:
-	if (rc) {
-		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
-		ltb->buff = NULL;
-	}
+	/* don't free LTB on communication error - see function header */
 	mutex_unlock(&adapter->fw_lock);
 	return rc;
 }
@@ -290,43 +328,6 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	ltb->map_id = 0;
 }
 
-static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
-				struct ibmvnic_long_term_buff *ltb)
-{
-	struct device *dev = &adapter->vdev->dev;
-	int rc;
-
-	memset(ltb->buff, 0, ltb->size);
-
-	mutex_lock(&adapter->fw_lock);
-	adapter->fw_done_rc = 0;
-
-	reinit_completion(&adapter->fw_done);
-	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
-	if (rc) {
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
-	}
-
-	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
-	if (rc) {
-		dev_info(dev,
-			 "Reset failed, long term map request timed out or aborted\n");
-		mutex_unlock(&adapter->fw_lock);
-		return rc;
-	}
-
-	if (adapter->fw_done_rc) {
-		dev_info(dev,
-			 "Reset failed, attempting to free and reallocate buffer\n");
-		free_long_term_buff(adapter, ltb);
-		mutex_unlock(&adapter->fw_lock);
-		return alloc_long_term_buff(adapter, ltb, ltb->size);
-	}
-	mutex_unlock(&adapter->fw_lock);
-	return 0;
-}
-
 static void deactivate_rx_pools(struct ibmvnic_adapter *adapter)
 {
 	int i;
@@ -548,18 +549,10 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 
 		netdev_dbg(adapter->netdev, "Re-setting rx_pool[%d]\n", i);
 
-		if (rx_pool->buff_size != buff_size) {
-			free_long_term_buff(adapter, &rx_pool->long_term_buff);
-			rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
-			rc = alloc_long_term_buff(adapter,
-						  &rx_pool->long_term_buff,
-						  rx_pool->size *
-						  rx_pool->buff_size);
-		} else {
-			rc = reset_long_term_buff(adapter,
-						  &rx_pool->long_term_buff);
-		}
-
+		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
+		rc = alloc_long_term_buff(adapter,
+					  &rx_pool->long_term_buff,
+					  rx_pool->size * rx_pool->buff_size);
 		if (rc)
 			return rc;
 
@@ -692,9 +685,12 @@ static int init_rx_pools(struct net_device *netdev)
 static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
 			     struct ibmvnic_tx_pool *tx_pool)
 {
+	struct ibmvnic_long_term_buff *ltb;
 	int rc, i;
 
-	rc = reset_long_term_buff(adapter, &tx_pool->long_term_buff);
+	ltb = &tx_pool->long_term_buff;
+
+	rc = alloc_long_term_buff(adapter, ltb, ltb->size);
 	if (rc)
 		return rc;
 
-- 
2.31.1

