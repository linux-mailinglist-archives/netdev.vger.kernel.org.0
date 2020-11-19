Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E92B8956
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgKSBMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:12:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727145AbgKSBMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:12:51 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ13Ha4116904;
        Wed, 18 Nov 2020 20:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=d8bZ3fzy0yJQnmSznlI6b6YXWJkDAShRdkSuiEkQhjI=;
 b=CQ95f6T2DIiwJcrjuG0/pXN+pANdIEb03zJeTFd5s4EIWV1YjJn6tMONmJ8SnG0YjAoE
 NFqHWlbJhpidRId+xC6AhT6ebYgfTASfZg9ROOtFXAaRoAG7Gvj8oaz85SBIwF0uEuHI
 xwD3LUf1z7ObfKY/R0+fa+IkR980tGTMyGnxCmE5v6Ods4F7OZLQueBw5Zxz9Wt+UVAL
 ShlogQqzInMejEnIATy1u8b7FYyXYO4oCcWTQACuhYuMv7oryJoKnmSwQP1LuS5Mgxna
 hvHjwTQQC2b/CEIVEu0fYUmKlAmtglvqb8Rtj0Eu0n6WqD+bf2TASJq9M5xzcvth94/d xA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4rha2dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 20:12:47 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ1Ckkn013808;
        Thu, 19 Nov 2020 01:12:46 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjmp42j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 01:12:46 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ1Caer2032154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 01:12:36 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A2056A054;
        Thu, 19 Nov 2020 01:12:45 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8416A04D;
        Thu, 19 Nov 2020 01:12:43 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.199.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 01:12:42 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net-next v2 3/9] ibmvnic: Introduce xmit_more support using batched subCRQ hcalls
Date:   Wed, 18 Nov 2020 19:12:19 -0600
Message-Id: <1605748345-32062-4-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 clxscore=1015
 mlxscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include support for the xmit_more feature utilizing the
H_SEND_SUB_CRQ_INDIRECT hypervisor call which allows the sending
of multiple subordinate Command Response Queue descriptors in one
hypervisor call via a DMA-mapped buffer. This update reduces hypervisor
calls and thus hypervisor call overhead per TX descriptor.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 204 ++++++++++++++++++++---------
 1 file changed, 139 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 17ba6db6f5f9..650aaf100d65 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1165,6 +1165,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 		if (prev_state == VNIC_CLOSED)
 			enable_irq(adapter->tx_scrq[i]->irq);
 		enable_scrq_irq(adapter, adapter->tx_scrq[i]);
+		netdev_tx_reset_queue(netdev_get_tx_queue(netdev, i));
 	}
 
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
@@ -1523,16 +1524,93 @@ static int ibmvnic_xmit_workarounds(struct sk_buff *skb,
 	return 0;
 }
 
+static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
+					 struct ibmvnic_sub_crq_queue *tx_scrq)
+{
+	struct ibmvnic_ind_xmit_queue *ind_bufp;
+	struct ibmvnic_tx_buff *tx_buff;
+	struct ibmvnic_tx_pool *tx_pool;
+	union sub_crq tx_scrq_entry;
+	int queue_num;
+	int entries;
+	int index;
+	int i;
+
+	ind_bufp = &tx_scrq->ind_buf;
+	entries = (u64)ind_bufp->index;
+	queue_num = tx_scrq->pool_index;
+
+	for (i = entries - 1; i >= 0; --i) {
+		tx_scrq_entry = ind_bufp->indir_arr[i];
+		if (tx_scrq_entry.v1.type != IBMVNIC_TX_DESC)
+			continue;
+		index = be32_to_cpu(tx_scrq_entry.v1.correlator);
+		if (index & IBMVNIC_TSO_POOL_MASK) {
+			tx_pool = &adapter->tso_pool[queue_num];
+			index &= ~IBMVNIC_TSO_POOL_MASK;
+		} else {
+			tx_pool = &adapter->tx_pool[queue_num];
+		}
+		tx_pool->free_map[tx_pool->consumer_index] = index;
+		tx_pool->consumer_index = tx_pool->consumer_index == 0 ?
+					  tx_pool->num_buffers - 1 :
+					  tx_pool->consumer_index - 1;
+		tx_buff = &tx_pool->tx_buff[index];
+		adapter->netdev->stats.tx_packets--;
+		adapter->netdev->stats.tx_bytes -= tx_buff->skb->len;
+		adapter->tx_stats_buffers[queue_num].packets--;
+		adapter->tx_stats_buffers[queue_num].bytes -=
+						tx_buff->skb->len;
+		dev_kfree_skb_any(tx_buff->skb);
+		tx_buff->skb = NULL;
+		adapter->netdev->stats.tx_dropped++;
+	}
+	ind_bufp->index = 0;
+	if (atomic_sub_return(entries, &tx_scrq->used) <=
+	    (adapter->req_tx_entries_per_subcrq / 2) &&
+	    __netif_subqueue_stopped(adapter->netdev, queue_num)) {
+		netif_wake_subqueue(adapter->netdev, queue_num);
+		netdev_dbg(adapter->netdev, "Started queue %d\n",
+			   queue_num);
+	}
+}
+
+static int ibmvnic_tx_scrq_flush(struct ibmvnic_adapter *adapter,
+				 struct ibmvnic_sub_crq_queue *tx_scrq)
+{
+	struct ibmvnic_ind_xmit_queue *ind_bufp;
+	u64 dma_addr;
+	u64 entries;
+	u64 handle;
+	int rc;
+
+	ind_bufp = &tx_scrq->ind_buf;
+	dma_addr = (u64)ind_bufp->indir_dma;
+	entries = (u64)ind_bufp->index;
+	handle = tx_scrq->handle;
+
+	if (!entries)
+		return 0;
+	rc = send_subcrq_indirect(adapter, handle, dma_addr, entries);
+	if (rc)
+		ibmvnic_tx_scrq_clean_buffer(adapter, tx_scrq);
+	else
+		ind_bufp->index = 0;
+	return 0;
+}
+
 static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int queue_num = skb_get_queue_mapping(skb);
 	u8 *hdrs = (u8 *)&adapter->tx_rx_desc_req;
 	struct device *dev = &adapter->vdev->dev;
+	struct ibmvnic_ind_xmit_queue *ind_bufp;
 	struct ibmvnic_tx_buff *tx_buff = NULL;
 	struct ibmvnic_sub_crq_queue *tx_scrq;
 	struct ibmvnic_tx_pool *tx_pool;
 	unsigned int tx_send_failed = 0;
+	netdev_tx_t ret = NETDEV_TX_OK;
 	unsigned int tx_map_failed = 0;
 	unsigned int tx_dropped = 0;
 	unsigned int tx_packets = 0;
@@ -1546,8 +1624,10 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned char *dst;
 	int index = 0;
 	u8 proto = 0;
-	u64 handle;
-	netdev_tx_t ret = NETDEV_TX_OK;
+
+	tx_scrq = adapter->tx_scrq[queue_num];
+	txq = netdev_get_tx_queue(netdev, queue_num);
+	ind_bufp = &tx_scrq->ind_buf;
 
 	if (test_bit(0, &adapter->resetting)) {
 		if (!netif_subqueue_stopped(netdev, skb))
@@ -1557,6 +1637,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
+		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 
@@ -1564,6 +1645,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_dropped++;
 		tx_send_failed++;
 		ret = NETDEV_TX_OK;
+		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 	if (skb_is_gso(skb))
@@ -1571,10 +1653,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	else
 		tx_pool = &adapter->tx_pool[queue_num];
 
-	tx_scrq = adapter->tx_scrq[queue_num];
-	txq = netdev_get_tx_queue(netdev, skb_get_queue_mapping(skb));
-	handle = tx_scrq->handle;
-
 	index = tx_pool->free_map[tx_pool->consumer_index];
 
 	if (index == IBMVNIC_INVALID_MAP) {
@@ -1582,6 +1660,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
+		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 
@@ -1666,55 +1745,29 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_crq.v1.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
 		hdrs += 2;
 	}
-	/* determine if l2/3/4 headers are sent to firmware */
-	if ((*hdrs >> 7) & 1) {
+
+	if ((*hdrs >> 7) & 1)
 		build_hdr_descs_arr(tx_buff, &num_entries, *hdrs);
-		tx_crq.v1.n_crq_elem = num_entries;
-		tx_buff->num_entries = num_entries;
-		tx_buff->indir_arr[0] = tx_crq;
-		tx_buff->indir_dma = dma_map_single(dev, tx_buff->indir_arr,
-						    sizeof(tx_buff->indir_arr),
-						    DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, tx_buff->indir_dma)) {
-			dev_kfree_skb_any(skb);
-			tx_buff->skb = NULL;
-			if (!firmware_has_feature(FW_FEATURE_CMO))
-				dev_err(dev, "tx: unable to map descriptor array\n");
-			tx_map_failed++;
-			tx_dropped++;
-			ret = NETDEV_TX_OK;
-			goto tx_err_out;
-		}
-		lpar_rc = send_subcrq_indirect(adapter, handle,
-					       (u64)tx_buff->indir_dma,
-					       (u64)num_entries);
-		dma_unmap_single(dev, tx_buff->indir_dma,
-				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
-	} else {
-		tx_buff->num_entries = num_entries;
-		lpar_rc = send_subcrq(adapter, handle,
-				      &tx_crq);
-	}
-	if (lpar_rc != H_SUCCESS) {
-		if (lpar_rc != H_CLOSED && lpar_rc != H_PARAMETER)
-			dev_err_ratelimited(dev, "tx: send failed\n");
-		dev_kfree_skb_any(skb);
-		tx_buff->skb = NULL;
 
-		if (lpar_rc == H_CLOSED || adapter->failover_pending) {
-			/* Disable TX and report carrier off if queue is closed
-			 * or pending failover.
-			 * Firmware guarantees that a signal will be sent to the
-			 * driver, triggering a reset or some other action.
-			 */
-			netif_tx_stop_all_queues(netdev);
-			netif_carrier_off(netdev);
-		}
+	tx_crq.v1.n_crq_elem = num_entries;
+	tx_buff->num_entries = num_entries;
+	/* flush buffer if current entry can not fit */
+	if (num_entries + ind_bufp->index > IBMVNIC_MAX_IND_DESCS) {
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		if (lpar_rc != H_SUCCESS)
+			goto tx_flush_err;
+	}
 
-		tx_send_failed++;
-		tx_dropped++;
-		ret = NETDEV_TX_OK;
-		goto tx_err_out;
+	tx_buff->indir_arr[0] = tx_crq;
+	memcpy(&ind_bufp->indir_arr[ind_bufp->index], tx_buff->indir_arr,
+	       num_entries * sizeof(struct ibmvnic_generic_scrq));
+	ind_bufp->index += num_entries;
+	if (__netdev_tx_sent_queue(txq, skb->len,
+				   netdev_xmit_more() &&
+				   ind_bufp->index < IBMVNIC_MAX_IND_DESCS)) {
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		if (lpar_rc != H_SUCCESS)
+			goto tx_err;
 	}
 
 	if (atomic_add_return(num_entries, &tx_scrq->used)
@@ -1729,14 +1782,26 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	ret = NETDEV_TX_OK;
 	goto out;
 
-tx_err_out:
-	/* roll back consumer index and map array*/
-	if (tx_pool->consumer_index == 0)
-		tx_pool->consumer_index =
-			tx_pool->num_buffers - 1;
-	else
-		tx_pool->consumer_index--;
-	tx_pool->free_map[tx_pool->consumer_index] = index;
+tx_flush_err:
+	dev_kfree_skb_any(skb);
+	tx_buff->skb = NULL;
+	tx_pool->consumer_index = tx_pool->consumer_index == 0 ?
+				  tx_pool->num_buffers - 1 :
+				  tx_pool->consumer_index - 1;
+	tx_dropped++;
+tx_err:
+	if (lpar_rc != H_CLOSED && lpar_rc != H_PARAMETER)
+		dev_err_ratelimited(dev, "tx: send failed\n");
+
+	if (lpar_rc == H_CLOSED || adapter->failover_pending) {
+		/* Disable TX and report carrier off if queue is closed
+		 * or pending failover.
+		 * Firmware guarantees that a signal will be sent to the
+		 * driver, triggering a reset or some other action.
+		 */
+		netif_tx_stop_all_queues(netdev);
+		netif_carrier_off(netdev);
+	}
 out:
 	netdev->stats.tx_dropped += tx_dropped;
 	netdev->stats.tx_bytes += tx_bytes;
@@ -3117,6 +3182,7 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_tx_pool *tx_pool;
 	struct ibmvnic_tx_buff *txbuff;
+	struct netdev_queue *txq;
 	union sub_crq *next;
 	int index;
 	int i, j;
@@ -3125,6 +3191,8 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	while (pending_scrq(adapter, scrq)) {
 		unsigned int pool = scrq->pool_index;
 		int num_entries = 0;
+		int total_bytes = 0;
+		int num_packets = 0;
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
@@ -3150,13 +3218,16 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 				txbuff->data_dma[j] = 0;
 			}
 
-			if (txbuff->last_frag) {
-				dev_kfree_skb_any(txbuff->skb);
+			num_packets++;
+			num_entries += txbuff->num_entries;
+			if (txbuff->skb) {
+				total_bytes += txbuff->skb->len;
+				dev_consume_skb_irq(txbuff->skb);
 				txbuff->skb = NULL;
+			} else {
+				netdev_warn(adapter->netdev,
+					    "TX completion received with NULL socket buffer\n");
 			}
-
-			num_entries += txbuff->num_entries;
-
 			tx_pool->free_map[tx_pool->producer_index] = index;
 			tx_pool->producer_index =
 				(tx_pool->producer_index + 1) %
@@ -3165,6 +3236,9 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		/* remove tx_comp scrq*/
 		next->tx_comp.first = 0;
 
+		txq = netdev_get_tx_queue(adapter->netdev, scrq->pool_index);
+		netdev_tx_completed_queue(txq, num_packets, total_bytes);
+
 		if (atomic_sub_return(num_entries, &scrq->used) <=
 		    (adapter->req_tx_entries_per_subcrq / 2) &&
 		    __netif_subqueue_stopped(adapter->netdev,
-- 
2.26.2

