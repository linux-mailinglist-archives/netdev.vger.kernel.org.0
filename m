Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7976C3FE1B9
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346702AbhIASHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:07:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346661AbhIASHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:07:03 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I4QCC135911
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 14:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ftenm1l+iGD+nmAxRHfECJIdXtjMa7SfDZvMHSNvO60=;
 b=d5QWWJcgmtCMt96TE9XJWBkTv6zeaRJ0ilQod2tk4fOy06n5l/AEvLV+Iaxtfe0+S3b/
 4u5V0XzSLbv+v4sTRajrF6E4vUFgORUX8Z4innnG4NlJ02pGokkUKeTxHIIsxGpv9cZd
 R/YxcghXtfqzmQ0+qe8ODWzx4fbuhzYt++kGl3fY4cT7LU9faLaWoyZm3dKzxsW7WkzT
 jSS5JQfwW5SWm1kxkFS8xPKCZ3bkrd3C+0Q/umh2evl7ScSyILAtuP94XDng+fXuITaq
 ZW31KAbLqC5FnQ15jn4khCfSndo5mDly5gKoUV9ClVLuZerRm40mClXysQ3fPnIp8CuU rg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ate208s2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:06:05 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I2jEf029132
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 18:06:04 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 3atdxc8rhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:06:04 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I63x340108462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:06:03 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 250E512405B;
        Wed,  1 Sep 2021 18:06:03 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8B78124052;
        Wed,  1 Sep 2021 18:06:01 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.152.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 18:06:01 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next v2 7/9] ibmvnic: Reuse LTB when possible
Date:   Wed,  1 Sep 2021 11:05:49 -0700
Message-Id: <20210901180551.150126-8-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901180551.150126-1-sukadev@linux.ibm.com>
References: <20210901180551.150126-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2HzeDyX7tZ5qv1RoGjk0lrkoTASwLNdT
X-Proofpoint-ORIG-GUID: 2HzeDyX7tZ5qv1RoGjk0lrkoTASwLNdT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the long term buffer during a reset as long as its size has
not changed. If the size has changed, free it and allocate a new
one of the appropriate size.

When we do this, alloc_long_term_buff() and reset_long_term_buff()
become identical. Drop reset_long_term_buff().

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Changelog[v2]: [Jakub Kicinski] Fix kdoc issues
---
 drivers/net/ethernet/ibm/ibmvnic.c | 137 ++++++++++++++++-------------
 1 file changed, 74 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4603597a9c10..dafb36690fdc 100644
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
@@ -214,23 +216,77 @@ static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
 	return -ETIMEDOUT;
 }
 
+/**
+ * reuse_ltb() - Check if a long term buffer can be reused
+ * @ltb:  The long term buffer to be checked
+ * @size: The size of the long term buffer.
+ *
+ * An LTB can be reused unless its size has changed.
+ *
+ * Return: Return true if the LTB can be reused, false otherwise.
+ */
+static bool reuse_ltb(struct ibmvnic_long_term_buff *ltb, int size)
+{
+	return (ltb->buff && ltb->size == size);
+}
+
+/**
+ * alloc_long_term_buff() - Allocate a long term buffer (LTB)
+ *
+ * @adapter: ibmvnic adapter associated to the LTB
+ * @ltb:     container object for the LTB
+ * @size:    size of the LTB
+ *
+ * Allocate an LTB of the specified size and notify VIOS.
+ *
+ * If the given @ltb already has the correct size, reuse it. Otherwise if
+ * its non-NULL, free it. Then allocate a new one of the correct size.
+ * Notify the VIOS either way since we may now be working with a new VIOS.
+ *
+ * Allocating larger chunks of memory during resets, specially LPM or under
+ * low memory situations can cause resets to fail/timeout and for LPAR to
+ * lose connectivity. So hold onto the LTB even if we fail to communicate
+ * with the VIOS and reuse it on next open. Free LTB when adapter is closed.
+ *
+ * Return: 0 if we were able to allocate the LTB and notify the VIOS and
+ *	   a negative value otherwise.
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
@@ -257,10 +313,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
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
@@ -290,43 +343,6 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
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
@@ -548,18 +564,10 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 
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
 
@@ -694,9 +702,12 @@ static int init_rx_pools(struct net_device *netdev)
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
2.26.2

