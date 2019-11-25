Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D601096A3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfKYXNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:13:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727187AbfKYXNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:13:13 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPMvBD0175564;
        Mon, 25 Nov 2019 18:13:08 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wf19x1aqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 18:13:08 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAPMtS4w003771;
        Mon, 25 Nov 2019 23:13:07 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 2wevd662k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 23:13:07 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAPND5OE27263474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 23:13:06 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5E0ABE054;
        Mon, 25 Nov 2019 23:13:05 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0AAEBE04F;
        Mon, 25 Nov 2019 23:13:04 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.224.141])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Nov 2019 23:13:04 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2 3/4] ibmvnic: Bound waits for device queries
Date:   Mon, 25 Nov 2019 17:12:55 -0600
Message-Id: <1574723576-27553-4-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
References: <20191125112359.7a468352@cakuba.hsd1.ca.comcast.net>
 <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 suspectscore=4 phishscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911250181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a wrapper for wait_for_completion calls with additional
driver checks to ensure that the driver does not wait on a
disabled device. In those cases or if the device does not respond
in an extended amount of time, this will allow the driver an
opportunity to recover.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 112 ++++++++++++++++++++++++++++++++-----
 1 file changed, 97 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 78a3ef70f1ef..4504f96ee07d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -159,6 +159,40 @@ static long h_reg_sub_crq(unsigned long unit_address, unsigned long token,
 	return rc;
 }
 
+/**
+ * ibmvnic_wait_for_completion - Check device state and wait for completion
+ * @adapter: private device data
+ * @comp_done: completion structure to wait for
+ * @timeout: time to wait in milliseconds
+ *
+ * Wait for a completion signal or until the timeout limit is reached
+ * while checking that the device is still active.
+ */
+static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
+				       struct completion *comp_done,
+				       unsigned long timeout)
+{
+	struct net_device *netdev;
+	unsigned long div_timeout;
+	u8 retry;
+
+	netdev = adapter->netdev;
+	retry = 5;
+	div_timeout = msecs_to_jiffies(timeout / retry);
+	while (true) {
+		if (!adapter->crq.active) {
+			netdev_err(netdev, "Device down!\n");
+			return -ENODEV;
+		}
+		if (retry--)
+			break;
+		if (wait_for_completion_timeout(comp_done, div_timeout))
+			return 0;
+	}
+	netdev_err(netdev, "Operation timed out.\n");
+	return -ETIMEDOUT;
+}
+
 static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb, int size)
 {
@@ -183,7 +217,15 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 		return rc;
 	}
-	wait_for_completion(&adapter->fw_done);
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		dev_err(dev,
+			"Long term map request aborted or timed out,rc = %d\n",
+			rc);
+		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+		return rc;
+	}
 
 	if (adapter->fw_done_rc) {
 		dev_err(dev, "Couldn't map long term buffer,rc = %d\n",
@@ -211,6 +253,7 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb)
 {
+	struct device *dev = &adapter->vdev->dev;
 	int rc;
 
 	memset(ltb->buff, 0, ltb->size);
@@ -219,10 +262,16 @@ static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
 	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
 	if (rc)
 		return rc;
-	wait_for_completion(&adapter->fw_done);
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		dev_info(dev,
+			 "Reset failed, long term map request timed out or aborted\n");
+		return rc;
+	}
 
 	if (adapter->fw_done_rc) {
-		dev_info(&adapter->vdev->dev,
+		dev_info(dev,
 			 "Reset failed, attempting to free and reallocate buffer\n");
 		free_long_term_buff(adapter, ltb);
 		return alloc_long_term_buff(adapter, ltb, ltb->size);
@@ -949,7 +998,12 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc)
 		return rc;
-	wait_for_completion(&adapter->fw_done);
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		dev_err(dev, "Could not retrieve VPD size, rc = %d\n", rc);
+		return rc;
+	}
 
 	if (!adapter->vpd->len)
 		return -ENODATA;
@@ -987,7 +1041,14 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 		adapter->vpd->buff = NULL;
 		return rc;
 	}
-	wait_for_completion(&adapter->fw_done);
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		dev_err(dev, "Unable to retrieve VPD, rc = %d\n", rc);
+		kfree(adapter->vpd->buff);
+		adapter->vpd->buff = NULL;
+		return rc;
+	}
 
 	return 0;
 }
@@ -1696,9 +1757,9 @@ static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
 		goto err;
 	}
 
-	wait_for_completion(&adapter->fw_done);
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
 	/* netdev->dev_addr is changed in handle_change_mac_rsp function */
-	if (adapter->fw_done_rc) {
+	if (rc || adapter->fw_done_rc) {
 		rc = -EIO;
 		goto err;
 	}
@@ -2319,9 +2380,16 @@ static int wait_for_reset(struct ibmvnic_adapter *adapter)
 	reinit_completion(&adapter->reset_done);
 	adapter->wait_for_reset = true;
 	rc = ibmvnic_reset(adapter, VNIC_RESET_CHANGE_PARAM);
-	if (rc)
-		return rc;
-	wait_for_completion(&adapter->reset_done);
+
+	if (rc) {
+		ret = rc;
+		goto out;
+	}
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->reset_done, 60000);
+	if (rc) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	ret = 0;
 	if (adapter->reset_done_rc) {
@@ -2335,10 +2403,18 @@ static int wait_for_reset(struct ibmvnic_adapter *adapter)
 		reinit_completion(&adapter->reset_done);
 		adapter->wait_for_reset = true;
 		rc = ibmvnic_reset(adapter, VNIC_RESET_CHANGE_PARAM);
-		if (rc)
-			return ret;
-		wait_for_completion(&adapter->reset_done);
+		if (rc) {
+			ret = rc;
+			goto out;
+		}
+		rc = ibmvnic_wait_for_completion(adapter, &adapter->reset_done,
+						 60000);
+		if (rc) {
+			ret = -ENODEV;
+			goto out;
+		}
 	}
+out:
 	adapter->wait_for_reset = false;
 
 	return ret;
@@ -2607,7 +2683,9 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc)
 		return;
-	wait_for_completion(&adapter->stats_done);
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->stats_done, 10000);
+	if (rc)
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++)
 		data[i] = be64_to_cpu(IBMVNIC_GET_STAT(adapter,
@@ -4407,7 +4485,11 @@ static int send_query_phys_parms(struct ibmvnic_adapter *adapter)
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc)
 		return rc;
-	wait_for_completion(&adapter->fw_done);
+
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc)
+		return rc;
+
 	return adapter->fw_done_rc ? -EIO : 0;
 }
 
-- 
2.12.3

