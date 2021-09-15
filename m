Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7040BEA2
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbhIODy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236190AbhIODyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:36 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F05C4S011645
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ftenm1l+iGD+nmAxRHfECJIdXtjMa7SfDZvMHSNvO60=;
 b=eBJKOOpFAEIv26lZqQedQ2qhqEpEpDPkpmpLIRyuLzHeFhzIW2VSmB3mzw71Znc2Jy3G
 vDOHJSTRaFidKPTIe5FM9PhgEjVVIR1FZlun15fRiQd8iPirwmOwUahZnd9kgO33t9zW
 9GTezi8A38vCngilevLkOxpNRQ/R5aPCydSNkkuqO7d6zgCw/rqoa9Gc0qX0O2zMwYBZ
 uMkwtwRxK2ff5Cf4nrPSass4Zk8sJdPAlPULNrXqquhdY0TLjEBroYxnEOQYj1eblr5C
 XCzTqbzZpJOn4w3pfjwY247ymv94iwPrdUk5SuaJVuM92Lj9iwXdZ0Bs+kHAMlYXwDEg ww== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b35yvkeqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:17 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lMIU023148
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:16 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3b0m3bg58a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:16 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3rFf012321688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:15 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B28BA112067;
        Wed, 15 Sep 2021 03:53:15 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CDC4112061;
        Wed, 15 Sep 2021 03:53:14 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:14 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 7/9] ibmvnic: Reuse LTB when possible
Date:   Tue, 14 Sep 2021 20:52:57 -0700
Message-Id: <20210915035259.355092-8-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FFVKACflJAw-cb9fjqONnyIChnffXZ7A
X-Proofpoint-GUID: FFVKACflJAw-cb9fjqONnyIChnffXZ7A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140131
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

