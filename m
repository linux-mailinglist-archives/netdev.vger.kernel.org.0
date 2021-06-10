Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036D73A31C0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhFJRMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:12:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229802AbhFJRMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:12:06 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AH3Ok6067330;
        Thu, 10 Jun 2021 13:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=VR35sys/p6xRs/LlY/B7wEAfX6VHYNn3j4Vt2vLQQrA=;
 b=flIkfQlC9EhxPRLvNQVvOYCXOFhvB+hXpxLWbnAa3yGG+3/yO/XEX8Fsf8fdbFHngSi8
 CeX6kPTYY9Wz102K6IGu1CnvDWaleYiCMy9wdYBEunaRxdz6koF+MdsHcciMsqXUJqgS
 j7NO+AppNOZ2lnJnaWajjTJVTUrqDi9odcfaqVfptJOpgnst/hqGv+9I4k1PKg8AHNlC
 /2n1WyfahHr7kezlCOdNFjfPDa4fZuGoBnzZ/mPbcTeSL4iNbuq5eUtTK/JF2Gpbnffk
 4eUf/FEp1+VwX91YR1w4yvoRbp4dU6bgIboGT8noRS9lQM9aOQUIOeUeg+hkDOOAq11U XQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393pjh8m5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 13:09:53 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AH97aA025582;
        Thu, 10 Jun 2021 17:09:52 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3900w9hut3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 17:09:52 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AH9p7826018130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 17:09:51 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C2D412405A;
        Thu, 10 Jun 2021 17:09:51 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EE04124053;
        Thu, 10 Jun 2021 17:09:50 +0000 (GMT)
Received: from Criss-MBP.home (unknown [9.163.26.182])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 17:09:50 +0000 (GMT)
From:   Cristobal Forno <cforno12@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        kuba@kernel.org, Cristobal Forno <cforno12@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH, net-next, v2] ibmvnic: Allow device probe if the device is not ready at boot
Date:   Thu, 10 Jun 2021 11:08:35 -0600
Message-Id: <20210610170835.10190-1-cforno12@linux.ibm.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: r-pmpVt8eCHEM8dMqYz9XtWM7Gdf_oHO
X-Proofpoint-GUID: r-pmpVt8eCHEM8dMqYz9XtWM7Gdf_oHO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_11:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1011 malwarescore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the device to be initialized at a later time if
it is not available at boot. The device will be allowed to probe but
will be given a "down" state. After completing device probe and
registering the net device, the driver will await an interrupt signal
from its partner device, indicating that it is ready for boot. The
driver will schedule a work event to perform the necessary procedure
and begin operation.

Co-developed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>

---
v2:
 - Correctly format the Co-developed-by tag
 - CC all the maintainers
 - tag patch as net-next
---
 drivers/net/ethernet/ibm/ibmvnic.c | 153 ++++++++++++++++++++++++-----
 drivers/net/ethernet/ibm/ibmvnic.h |   6 +-
 2 files changed, 132 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5788bb956d73..b12f0beb4892 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -141,6 +141,29 @@ static const struct ibmvnic_stat ibmvnic_stats[] = {
 	{"internal_mac_rx_errors", IBMVNIC_STAT_OFF(internal_mac_rx_errors)},
 };
 
+static int send_crq_init_complete(struct ibmvnic_adapter *adapter)
+{
+	union ibmvnic_crq crq;
+
+	memset(&crq, 0, sizeof(crq));
+	crq.generic.first = IBMVNIC_CRQ_INIT_CMD;
+	crq.generic.cmd = IBMVNIC_CRQ_INIT_COMPLETE;
+
+	return ibmvnic_send_crq(adapter, &crq);
+}
+
+static int send_version_xchg(struct ibmvnic_adapter *adapter)
+{
+	union ibmvnic_crq crq;
+
+	memset(&crq, 0, sizeof(crq));
+	crq.version_exchange.first = IBMVNIC_CRQ_CMD;
+	crq.version_exchange.cmd = VERSION_EXCHANGE;
+	crq.version_exchange.version = cpu_to_be16(ibmvnic_version);
+
+	return ibmvnic_send_crq(adapter, &crq);
+}
+
 static long h_reg_sub_crq(unsigned long unit_address, unsigned long token,
 			  unsigned long length, unsigned long *number,
 			  unsigned long *irq)
@@ -2085,10 +2108,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			goto out;
 		}
 
-		/* If the adapter was in PROBE state prior to the reset,
+		/* If the adapter was in PROBE or DOWN state prior to the reset,
 		 * exit here.
 		 */
-		if (reset_state == VNIC_PROBED) {
+		if (reset_state == VNIC_PROBED || reset_state == VNIC_DOWN) {
 			rc = 0;
 			goto out;
 		}
@@ -2214,10 +2237,10 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	if (rc)
 		goto out;
 
-	/* If the adapter was in PROBE state prior to the reset,
+	/* If the adapter was in PROBE or DOWN state prior to the reset,
 	 * exit here.
 	 */
-	if (reset_state == VNIC_PROBED)
+	if (reset_state == VNIC_PROBED || reset_state == VNIC_DOWN)
 		goto out;
 
 	rc = ibmvnic_login(netdev);
@@ -2270,6 +2293,76 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
 	return rwi;
 }
 
+/**
+ * do_passive_init - complete probing when partner device is detected.
+ * @adapter: ibmvnic_adapter struct
+ *
+ * If the ibmvnic device does not have a partner device to communicate with at boot
+ * and that partner device comes online at a later time, this function is called
+ * to complete the initialization process of ibmvnic device.
+ * Caller is expected to hold rtnl_lock().
+ *
+ * Returns non-zero if sub-CRQs are not initialized properly leaving the device
+ * in the down state.
+ * Returns 0 upon success and the device is in PROBED state.
+ */
+
+static int do_passive_init(struct ibmvnic_adapter *adapter)
+{
+	unsigned long timeout = msecs_to_jiffies(30000);
+	struct net_device *netdev = adapter->netdev;
+	struct device *dev = &adapter->vdev->dev;
+	int rc;
+
+	netdev_dbg(netdev, "Partner device found, probing.\n");
+
+	adapter->state = VNIC_PROBING;
+	reinit_completion(&adapter->init_done);
+	adapter->init_done_rc = 0;
+	adapter->crq.active = true;
+
+	rc = send_crq_init_complete(adapter);
+	if (rc)
+		goto out;
+
+	rc = send_version_xchg(adapter);
+	if (rc)
+		netdev_dbg(adapter->netdev, "send_version_xchg failed, rc=%d\n", rc);
+
+	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
+		dev_err(dev, "Initialization sequence timed out\n");
+		rc = -ETIMEDOUT;
+		goto out;
+	}
+
+	rc = init_sub_crqs(adapter);
+	if (rc) {
+		dev_err(dev, "Initialization of sub crqs failed, rc=%d\n", rc);
+		goto out;
+	}
+
+	rc = init_sub_crq_irqs(adapter);
+	if (rc) {
+		dev_err(dev, "Failed to initialize sub crq irqs\n, rc=%d", rc);
+		goto init_failed;
+	}
+
+	netdev->mtu = adapter->req_mtu - ETH_HLEN;
+	netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
+	netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
+
+	adapter->state = VNIC_PROBED;
+	netdev_dbg(netdev, "Probed successfully. Waiting for signal from partner device.\n");
+
+	return 0;
+
+init_failed:
+	release_sub_crqs(adapter, 1);
+out:
+	adapter->state = VNIC_DOWN;
+	return rc;
+}
+
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_rwi *rwi;
@@ -2306,7 +2399,13 @@ static void __ibmvnic_reset(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-		if (adapter->force_reset_recovery) {
+		if (rwi->reset_reason == VNIC_RESET_PASSIVE_INIT) {
+			rtnl_lock();
+			rc = do_passive_init(adapter);
+			rtnl_unlock();
+			if (!rc)
+				netif_carrier_on(adapter->netdev);
+		} else if (adapter->force_reset_recovery) {
 			/* Since we are doing a hard reset now, clear the
 			 * failover_pending flag so we don't ignore any
 			 * future MOBILITY or other resets.
@@ -3776,18 +3875,6 @@ static int ibmvnic_send_crq_init(struct ibmvnic_adapter *adapter)
 	return 0;
 }
 
-static int send_version_xchg(struct ibmvnic_adapter *adapter)
-{
-	union ibmvnic_crq crq;
-
-	memset(&crq, 0, sizeof(crq));
-	crq.version_exchange.first = IBMVNIC_CRQ_CMD;
-	crq.version_exchange.cmd = VERSION_EXCHANGE;
-	crq.version_exchange.version = cpu_to_be16(ibmvnic_version);
-
-	return ibmvnic_send_crq(adapter, &crq);
-}
-
 struct vnic_login_client_data {
 	u8	type;
 	__be16	len;
@@ -4907,7 +4994,12 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
 			}
-			rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
+
+			if (adapter->state == VNIC_DOWN)
+				rc = ibmvnic_reset(adapter, VNIC_RESET_PASSIVE_INIT);
+			else
+				rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
+
 			if (rc && rc != -EBUSY) {
 				/* We were unable to schedule the failover
 				 * reset either because the adapter was still
@@ -5330,6 +5422,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	struct ibmvnic_adapter *adapter;
 	struct net_device *netdev;
 	unsigned char *mac_addr_p;
+	bool init_success;
 	int rc;
 
 	dev_dbg(&dev->dev, "entering ibmvnic_probe for UA 0x%x\n",
@@ -5376,6 +5469,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	init_completion(&adapter->stats_done);
 	clear_bit(0, &adapter->resetting);
 
+	init_success = false;
 	do {
 		rc = init_crq_queue(adapter);
 		if (rc) {
@@ -5385,10 +5479,16 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		}
 
 		rc = ibmvnic_reset_init(adapter, false);
-		if (rc && rc != EAGAIN)
-			goto ibmvnic_init_fail;
 	} while (rc == EAGAIN);
 
+	/* We are ignoring the error from ibmvnic_reset_init() assuming that the
+	 * partner is not ready. CRQ is not active. When the partner becomes
+	 * ready, we will do the passive init reset.
+	 */
+
+	if (!rc)
+		init_success = true;
+
 	rc = init_stats_buffers(adapter);
 	if (rc)
 		goto ibmvnic_init_fail;
@@ -5397,10 +5497,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (rc)
 		goto ibmvnic_stats_fail;
 
-	netdev->mtu = adapter->req_mtu - ETH_HLEN;
-	netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
-	netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
-
 	rc = device_create_file(&dev->dev, &dev_attr_failover);
 	if (rc)
 		goto ibmvnic_dev_file_err;
@@ -5413,7 +5509,14 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 	dev_info(&dev->dev, "ibmvnic registered\n");
 
-	adapter->state = VNIC_PROBED;
+	if (init_success) {
+		adapter->state = VNIC_PROBED;
+		netdev->mtu = adapter->req_mtu - ETH_HLEN;
+		netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
+		netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
+	} else {
+		adapter->state = VNIC_DOWN;
+	}
 
 	adapter->wait_for_reset = false;
 	adapter->last_reset_time = jiffies;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index c1d39a748546..22df602323bc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -851,14 +851,16 @@ enum vnic_state {VNIC_PROBING = 1,
 		 VNIC_CLOSING,
 		 VNIC_CLOSED,
 		 VNIC_REMOVING,
-		 VNIC_REMOVED};
+		 VNIC_REMOVED,
+		 VNIC_DOWN};
 
 enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
 			   VNIC_RESET_MOBILITY,
 			   VNIC_RESET_FATAL,
 			   VNIC_RESET_NON_FATAL,
 			   VNIC_RESET_TIMEOUT,
-			   VNIC_RESET_CHANGE_PARAM};
+			   VNIC_RESET_CHANGE_PARAM,
+			   VNIC_RESET_PASSIVE_INIT};
 
 struct ibmvnic_rwi {
 	enum ibmvnic_reset_reason reset_reason;
-- 
2.30.0

