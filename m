Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C8922189F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGOXwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:52:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgGOXwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 19:52:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FNW69j181355;
        Wed, 15 Jul 2020 19:52:03 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 329cum06h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 19:52:03 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06FNfMja018020;
        Wed, 15 Jul 2020 23:52:02 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 327528vfjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 23:52:02 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06FNpvof65208820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 23:51:58 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B40566A054;
        Wed, 15 Jul 2020 23:52:00 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E086D6A047;
        Wed, 15 Jul 2020 23:51:59 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.201.32])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jul 2020 23:51:59 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, drt@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: Increase driver logging
Date:   Wed, 15 Jul 2020 18:51:55 -0500
Message-Id: <1594857115-22380-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=3 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the ibmvnic driver's logging capabilities by providing
more informational messages to track driver operations, facilitating
first-pass debug.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 76 ++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0fd7eae25fe9..7382f11872fc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -561,6 +561,7 @@ static int init_rx_pools(struct net_device *netdev)
 	u64 *size_array;
 	int i, j;
 
+	netdev_info(netdev, "Initializing RX queue buffer pools.\n");
 	rxadd_subcrqs =
 		be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
 	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
@@ -618,6 +619,7 @@ static int init_rx_pools(struct net_device *netdev)
 		rx_pool->next_alloc = 0;
 		rx_pool->next_free = 0;
 	}
+	netdev_info(netdev, "RX queue buffer pools allocated successfully.\n");
 
 	return 0;
 }
@@ -738,6 +740,7 @@ static int init_tx_pools(struct net_device *netdev)
 	int tx_subcrqs;
 	int i, rc;
 
+	netdev_info(netdev, "Initializing TX queue buffer pools.\n");
 	tx_subcrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
 	adapter->tx_pool = kcalloc(tx_subcrqs,
 				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
@@ -768,7 +771,7 @@ static int init_tx_pools(struct net_device *netdev)
 			return rc;
 		}
 	}
-
+	netdev_info(netdev, "TX queue buffer pools allocated successfully.\n");
 	return 0;
 }
 
@@ -792,6 +795,7 @@ static void ibmvnic_napi_disable(struct ibmvnic_adapter *adapter)
 	if (!adapter->napi_enabled)
 		return;
 
+	netdev_info(adapter->netdev, "Disable all NAPI threads.\n");
 	for (i = 0; i < adapter->req_rx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Disabling napi[%d]\n", i);
 		napi_disable(&adapter->napi[i]);
@@ -910,12 +914,14 @@ static int ibmvnic_login(struct net_device *netdev)
 				return -1;
 			}
 		} else if (adapter->init_done_rc) {
-			netdev_warn(netdev, "Adapter login failed\n");
+			netdev_warn(netdev, "Adapter login failed, rc = %d\n",
+				    adapter->init_done_rc);
 			return -1;
 		}
 	} while (retry);
 
 	__ibmvnic_set_mac(netdev, adapter->mac_addr);
+	netdev_info(netdev, "Adapter login success!\n");
 
 	return 0;
 }
@@ -934,6 +940,7 @@ static void release_login_rsp_buffer(struct ibmvnic_adapter *adapter)
 
 static void release_resources(struct ibmvnic_adapter *adapter)
 {
+	netdev_info(adapter->netdev, "Releasing VNIC client device memory structures.\n");
 	release_vpd_data(adapter);
 
 	release_tx_pools(adapter);
@@ -941,6 +948,7 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 
 	release_napi(adapter);
 	release_login_rsp_buffer(adapter);
+	netdev_info(adapter->netdev, "VNIC client device memory released.\n");
 }
 
 static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
@@ -964,7 +972,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 		reinit_completion(&adapter->init_done);
 		rc = ibmvnic_send_crq(adapter, &crq);
 		if (rc) {
-			netdev_err(netdev, "Failed to set link state\n");
+			netdev_err(netdev, "Failed to set link state, rc = %d\n", rc);
 			return rc;
 		}
 
@@ -1098,6 +1106,8 @@ static int init_resources(struct ibmvnic_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	int rc;
 
+	netdev_info(netdev, "Allocate device resources.\n");
+
 	rc = set_real_num_queues(netdev);
 	if (rc)
 		return rc;
@@ -1126,7 +1136,11 @@ static int init_resources(struct ibmvnic_adapter *adapter)
 		return rc;
 
 	rc = init_tx_pools(netdev);
-	return rc;
+	if (rc)
+		return rc;
+
+	netdev_info(netdev, "Device resources allocated.\n");
+	return 0;
 }
 
 static int __ibmvnic_open(struct net_device *netdev)
@@ -1136,9 +1150,10 @@ static int __ibmvnic_open(struct net_device *netdev)
 	int i, rc;
 
 	adapter->state = VNIC_OPENING;
+	netdev_info(netdev, "Allocating RX buffer pools and enable NAPI structures.\n");
 	replenish_pools(adapter);
 	ibmvnic_napi_enable(adapter);
-
+	netdev_info(netdev, "Activating RX and TX interrupt lines.\n");
 	/* We're ready to receive frames, enable the sub-crq interrupts and
 	 * set the logical link state to up
 	 */
@@ -1155,7 +1170,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 			enable_irq(adapter->tx_scrq[i]->irq);
 		enable_scrq_irq(adapter, adapter->tx_scrq[i]);
 	}
-
+	netdev_info(netdev, "Inform system firmware that device is ready for packet transmission.\n");
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
 		for (i = 0; i < adapter->req_rx_queues; i++)
@@ -1163,7 +1178,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 		release_resources(adapter);
 		return rc;
 	}
-
+	netdev_info(netdev, "Activate net device TX queues.\n");
 	netif_tx_start_all_queues(netdev);
 
 	if (prev_state == VNIC_CLOSED) {
@@ -1180,6 +1195,7 @@ static int ibmvnic_open(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	netdev_info(netdev, "Opening VNIC client device.\n");
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
@@ -1202,7 +1218,7 @@ static int ibmvnic_open(struct net_device *netdev)
 	}
 
 	rc = __ibmvnic_open(netdev);
-
+	netdev_info(netdev, "VNIC client device opened.\n");
 	return rc;
 }
 
@@ -1216,7 +1232,7 @@ static void clean_rx_pools(struct ibmvnic_adapter *adapter)
 
 	if (!adapter->rx_pool)
 		return;
-
+	netdev_info(adapter->netdev, "Freeing all existing RX buffer pool memory.\n");
 	rx_scrqs = adapter->num_active_rx_pools;
 	rx_entries = adapter->req_rx_add_entries_per_subcrq;
 
@@ -1265,7 +1281,7 @@ static void clean_tx_pools(struct ibmvnic_adapter *adapter)
 
 	if (!adapter->tx_pool || !adapter->tso_pool)
 		return;
-
+	netdev_info(adapter->netdev, "Freeing all outstanding TX buffers awaiting completion.\n");
 	tx_scrqs = adapter->num_active_tx_pools;
 
 	/* Free any remaining skbs in the tx buffer pools */
@@ -1282,6 +1298,7 @@ static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter)
 	int i;
 
 	if (adapter->tx_scrq) {
+		netdev_info(netdev, "Disabling all TX interrupt lines.\n");
 		for (i = 0; i < adapter->req_tx_queues; i++)
 			if (adapter->tx_scrq[i]->irq) {
 				netdev_dbg(netdev,
@@ -1292,6 +1309,7 @@ static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter)
 	}
 
 	if (adapter->rx_scrq) {
+		netdev_info(netdev, "Disabling all RX interrupt lines.\n");
 		for (i = 0; i < adapter->req_rx_queues; i++) {
 			if (adapter->rx_scrq[i]->irq) {
 				netdev_dbg(netdev,
@@ -1307,6 +1325,7 @@ static void ibmvnic_cleanup(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
+	netdev_info(netdev, "Halt net device TX queues.\n");
 	/* ensure that transmissions are stopped if called by do_reset */
 	if (test_bit(0, &adapter->resetting))
 		netif_tx_disable(netdev);
@@ -1326,6 +1345,7 @@ static int __ibmvnic_close(struct net_device *netdev)
 	int rc = 0;
 
 	adapter->state = VNIC_CLOSING;
+	netdev_info(netdev, "Halt incoming packets from system firmware.\n");
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
 	if (rc)
 		return rc;
@@ -1338,6 +1358,7 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	netdev_info(netdev, "Stopping VNIC client device.\n");
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
@@ -1348,7 +1369,7 @@ static int ibmvnic_close(struct net_device *netdev)
 
 	rc = __ibmvnic_close(netdev);
 	ibmvnic_cleanup(netdev);
-
+	netdev_info(netdev, "VNIC client device stopped.\n");
 	return rc;
 }
 
@@ -2941,9 +2962,11 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 
 static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 {
+	struct net_device *netdev = adapter->netdev;
 	int i;
 
 	if (adapter->tx_scrq) {
+		netdev_info(netdev, "Releasing TX subordinate Command-Response Queues.\n");
 		for (i = 0; i < adapter->num_active_tx_scrqs; i++) {
 			if (!adapter->tx_scrq[i])
 				continue;
@@ -2964,9 +2987,11 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 		kfree(adapter->tx_scrq);
 		adapter->tx_scrq = NULL;
 		adapter->num_active_tx_scrqs = 0;
+		netdev_info(netdev, "TX subordinate Command-Response Queues released.\n");
 	}
 
 	if (adapter->rx_scrq) {
+		netdev_info(netdev, "Releasing RX subordinate Command-Response Queues.\n");
 		for (i = 0; i < adapter->num_active_rx_scrqs; i++) {
 			if (!adapter->rx_scrq[i])
 				continue;
@@ -2987,6 +3012,7 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 		kfree(adapter->rx_scrq);
 		adapter->rx_scrq = NULL;
 		adapter->num_active_rx_scrqs = 0;
+		netdev_info(netdev, "RX subordinate Command-Response Queues released.\n");
 	}
 }
 
@@ -3149,6 +3175,7 @@ static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter)
 	int i = 0, j = 0;
 	int rc = 0;
 
+	netdev_info(adapter->netdev, "Request Subordinate Command-Response Queue interrupts.\n");
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Initializing tx_scrq[%d] irq\n",
 			   i);
@@ -3195,6 +3222,9 @@ static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter)
 			goto req_rx_irq_failed;
 		}
 	}
+
+	netdev_info(adapter->netdev, "Subordinate Command-Response Queue interrupts created.\n");
+
 	return rc;
 
 req_rx_irq_failed:
@@ -3221,6 +3251,8 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 	int more = 0;
 	int i;
 
+	netdev_info(adapter->netdev, "Creating Command-Response Queues.\n");
+
 	total_queues = adapter->req_tx_queues + adapter->req_rx_queues;
 
 	allqueues = kcalloc(total_queues, sizeof(*allqueues), GFP_KERNEL);
@@ -3285,6 +3317,8 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 	}
 
 	kfree(allqueues);
+
+	netdev_info(adapter->netdev, "Command-Response Queue creation complete.\n");
 	return 0;
 
 rx_failed:
@@ -3303,6 +3337,8 @@ static void ibmvnic_send_req_caps(struct ibmvnic_adapter *adapter, int retry)
 	union ibmvnic_crq crq;
 	int max_entries;
 
+	netdev_info(adapter->netdev, "Negotiate device capabilities.\n");
+
 	if (!retry) {
 		/* Sub-CRQ entries are 32 byte long */
 		int entries_page = 4 * PAGE_SIZE / (sizeof(u64) * 4);
@@ -3822,6 +3858,8 @@ static void send_cap_queries(struct ibmvnic_adapter *adapter)
 {
 	union ibmvnic_crq crq;
 
+	netdev_info(adapter->netdev, "Requesting device capabilities.\n");
+
 	atomic_set(&adapter->running_cap_crqs, 0);
 	memset(&crq, 0, sizeof(crq));
 	crq.query_capability.first = IBMVNIC_CRQ_CMD;
@@ -4115,7 +4153,8 @@ static void handle_query_ip_offload_rsp(struct ibmvnic_adapter *adapter)
 		adapter->netdev->features |=
 				tmp & adapter->netdev->wanted_features;
 	}
-
+	netdev_info(adapter->netdev,
+		    "Confirming device offload capabilities.\n");
 	memset(&crq, 0, sizeof(crq));
 	crq.control_ip_offload.first = IBMVNIC_CRQ_CMD;
 	crq.control_ip_offload.cmd = CONTROL_IP_OFFLOAD;
@@ -4263,6 +4302,9 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 		struct ibmvnic_query_ip_offload_buffer *ip_offload_buf =
 		    &adapter->ip_offload_buf;
 
+		netdev_info(adapter->netdev,
+			    "Query device offload features.\n");
+
 		adapter->wait_capability = false;
 		adapter->ip_offload_tok = dma_map_single(dev, ip_offload_buf,
 							 buf_sz,
@@ -4881,7 +4923,7 @@ static void release_crq_queue(struct ibmvnic_adapter *adapter)
 	if (!crq->msgs)
 		return;
 
-	netdev_dbg(adapter->netdev, "Releasing CRQ\n");
+	netdev_info(adapter->netdev, "Releasing VNIC Command-Response Queue.\n");
 	free_irq(vdev->irq, adapter);
 	tasklet_kill(&adapter->tasklet);
 	do {
@@ -4893,6 +4935,7 @@ static void release_crq_queue(struct ibmvnic_adapter *adapter)
 	free_page((unsigned long)crq->msgs);
 	crq->msgs = NULL;
 	crq->active = false;
+	netdev_info(adapter->netdev, "VNIC Command-Response Queue released.\n");
 }
 
 static int init_crq_queue(struct ibmvnic_adapter *adapter)
@@ -5193,6 +5236,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
 
+	netdev_info(netdev, "Attempting to remove VNIC client device.\n");
 	spin_lock_irqsave(&adapter->state_lock, flags);
 	if (adapter->state == VNIC_RESETTING) {
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
@@ -5206,22 +5250,26 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
 
 	rtnl_lock();
+	netdev_info(netdev, "Unregistering net device.\n");
 	unregister_netdevice(netdev);
 
+	netdev_info(netdev, "Releasing VNIC client device resources.\n");
 	release_resources(adapter);
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
 
 	release_stats_token(adapter);
 	release_stats_buffers(adapter);
-
+	netdev_info(netdev, "VNIC client device resources released.\n");
 	adapter->state = VNIC_REMOVED;
 
 	rtnl_unlock();
+	netdev_info(netdev, "Freeing net device and VNIC client driver data.\n");
 	mutex_destroy(&adapter->fw_lock);
 	device_remove_file(&dev->dev, &dev_attr_failover);
 	free_netdev(netdev);
 	dev_set_drvdata(&dev->dev, NULL);
+	netdev_info(netdev, "VNIC client device has been successfully removed.\n");
 
 	return 0;
 }
-- 
2.26.2

