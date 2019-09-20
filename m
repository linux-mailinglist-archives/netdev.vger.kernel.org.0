Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F7BB9863
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 22:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfITUWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 16:22:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729674AbfITUWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 16:22:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KKMKcN063618;
        Fri, 20 Sep 2019 16:22:26 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v53wf47wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 16:22:25 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KKJcO9007895;
        Fri, 20 Sep 2019 20:22:25 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 2v3vbuw2ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 20:22:25 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KKMNke45941060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 20:22:23 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F3326A047;
        Fri, 20 Sep 2019 20:22:23 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CE706A051;
        Fri, 20 Sep 2019 20:22:23 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 20:22:23 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, tlfalcon@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 2/2] net/ibmvnic: prevent more than one thread from running in reset
Date:   Fri, 20 Sep 2019 16:11:23 -0400
Message-Id: <20190920201123.18913-3-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
References: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code allows more than one thread to run in reset. This can 
corrupt struct adapter data. Check adapter->resetting before performing 
a reset, if there is another reset running delay (100 msec) before trying 
again.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 40 ++++++++++++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |  5 ++++-
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ba340aaff1b3..6aef574acdf2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1207,7 +1207,7 @@ static void ibmvnic_cleanup(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
 	/* ensure that transmissions are stopped if called by do_reset */
-	if (adapter->resetting)
+	if (test_bit(0, &adapter->resetting))
 		netif_tx_disable(netdev);
 	else
 		netif_tx_stop_all_queues(netdev);
@@ -1428,7 +1428,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	u8 proto = 0;
 	netdev_tx_t ret = NETDEV_TX_OK;
 
-	if (adapter->resetting) {
+	if (test_bit(0, &adapter->resetting)) {
 		if (!netif_subqueue_stopped(netdev, skb))
 			netif_stop_subqueue(netdev, queue_num);
 		dev_kfree_skb_any(skb);
@@ -2054,6 +2054,12 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
 
+	if (test_and_set_bit_lock(0, &adapter->resetting)) {
+		schedule_delayed_work(&adapter->ibmvnic_delayed_reset,
+				      IBMVNIC_RESET_DELAY);
+		return;
+	}
+
 	reset_state = adapter->state;
 
 	rwi = get_next_rwi(adapter);
@@ -2095,6 +2101,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 			break;
 
 		rwi = get_next_rwi(adapter);
+
+		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
+			    rwi->reset_reason == VNIC_RESET_MOBILITY))
+			adapter->force_reset_recovery = true;
 	}
 
 	if (adapter->wait_for_reset) {
@@ -2107,7 +2117,16 @@ static void __ibmvnic_reset(struct work_struct *work)
 		free_all_rwi(adapter);
 	}
 
-	adapter->resetting = false;
+	clear_bit_unlock(0, &adapter->resetting);
+}
+
+static void __ibmvnic_delayed_reset(struct work_struct *work)
+{
+	struct ibmvnic_adapter *adapter;
+
+	adapter = container_of(work, struct ibmvnic_adapter,
+			       ibmvnic_delayed_reset.work);
+	__ibmvnic_reset(&adapter->ibmvnic_reset);
 }
 
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
@@ -2162,7 +2181,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-	adapter->resetting = true;
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
@@ -2207,7 +2225,7 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		u16 offset;
 		u8 flags = 0;
 
-		if (unlikely(adapter->resetting &&
+		if (unlikely(test_bit(0, &adapter->resetting) &&
 			     adapter->reset_reason != VNIC_RESET_NON_FATAL)) {
 			enable_scrq_irq(adapter, adapter->rx_scrq[scrq_num]);
 			napi_complete_done(napi, frames_processed);
@@ -2858,7 +2876,7 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 		return 1;
 	}
 
-	if (adapter->resetting &&
+	if (test_bit(0, &adapter->resetting) &&
 	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
 		u64 val = (0xff000000) | scrq->hw_irq;
 
@@ -3408,7 +3426,7 @@ static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
 	if (rc) {
 		if (rc == H_CLOSED) {
 			dev_warn(dev, "CRQ Queue closed\n");
-			if (adapter->resetting)
+			if (test_bit(0, &adapter->resetting))
 				ibmvnic_reset(adapter, VNIC_RESET_FATAL);
 		}
 
@@ -4483,7 +4501,7 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 	case IBMVNIC_CRQ_XPORT_EVENT:
 		netif_carrier_off(netdev);
 		adapter->crq.active = false;
-		if (adapter->resetting)
+		if (test_bit(0, &adapter->resetting))
 			adapter->force_reset_recovery = true;
 		if (gen_crq->cmd == IBMVNIC_PARTITION_MIGRATED) {
 			dev_info(dev, "Migrated, re-enabling adapter\n");
@@ -4821,7 +4839,7 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 		return -1;
 	}
 
-	if (adapter->resetting && !adapter->wait_for_reset &&
+	if (test_bit(0, &adapter->resetting) && !adapter->wait_for_reset &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY) {
 		if (adapter->req_rx_queues != old_num_rx_queues ||
 		    adapter->req_tx_queues != old_num_tx_queues) {
@@ -4933,10 +4951,12 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	spin_lock_init(&adapter->stats_lock);
 
 	INIT_WORK(&adapter->ibmvnic_reset, __ibmvnic_reset);
+	INIT_DELAYED_WORK(&adapter->ibmvnic_delayed_reset,
+			  __ibmvnic_delayed_reset);
 	INIT_LIST_HEAD(&adapter->rwi_list);
 	spin_lock_init(&adapter->rwi_lock);
 	init_completion(&adapter->init_done);
-	adapter->resetting = false;
+	clear_bit(0, &adapter->resetting);
 
 	do {
 		rc = init_crq_queue(adapter);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 9d3d35cc91d6..ebc39248b334 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -39,6 +39,8 @@
 #define IBMVNIC_MAX_LTB_SIZE ((1 << (MAX_ORDER - 1)) * PAGE_SIZE)
 #define IBMVNIC_BUFFER_HLEN 500
 
+#define IBMVNIC_RESET_DELAY 100
+
 static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
 #define IBMVNIC_USE_SERVER_MAXES 0x1
 	"use-server-maxes"
@@ -1077,7 +1079,8 @@ struct ibmvnic_adapter {
 	spinlock_t rwi_lock;
 	struct list_head rwi_list;
 	struct work_struct ibmvnic_reset;
-	bool resetting;
+	struct delayed_work ibmvnic_delayed_reset;
+	unsigned long resetting;
 	bool napi_enabled, from_passive_init;
 
 	bool failover_pending;
-- 
2.16.4

