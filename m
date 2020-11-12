Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5052B0D83
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgKLTKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726831AbgKLTKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:38 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ24dn081358;
        Thu, 12 Nov 2020 14:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=lQy3qgE/q2rRHAI5ypVu3ozb3wV9kFJ9dEjB2sLk9iw=;
 b=BP+ob0ARkFH5Q1sjzhgrdPw8Xk+siCMFYmo0o/4r7aihs/T8vRK9xpIjyzUJdtNi40uA
 ugGIGVLRUNU8mfzShlcECanVZC2Cm8lw9zVigDceCLqge1xvZj0wm9vVBeewBmDjUiQt
 Lr6uGkHjMB2Ug9JdQPz0pf+4SFeGNxBUrBlKXFcI2DCl77pQh5wEORyfhVKWeo5Zoz8A
 4D1ebqNA+PG4nDzDJL5URkfdnuZvl+Hgmn2J0pFkViaG/qn7I9N40BP/ri0vVOfbhZu2
 cOfRIKFTeK+pm0xZCuqARp75YB6sG8IJVytkeSlyUwsLB0MTcC5pkWVsJeSSUXZvJ2eP bQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sarugc17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:28 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ8BKE016290;
        Thu, 12 Nov 2020 19:10:27 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 34nk7b012n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:27 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJAP2T10748500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:25 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 567F7AE066;
        Thu, 12 Nov 2020 19:10:25 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6224DAE080;
        Thu, 12 Nov 2020 19:10:24 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:24 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 04/12] ibmvnic: Introduce xmit_more support using batched subCRQ hcalls
Date:   Thu, 12 Nov 2020 13:09:59 -0600
Message-Id: <1605208207-1896-5-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_09:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=3 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120109
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
 drivers/net/ethernet/ibm/ibmvnic.c | 151 +++++++++++++++++------------
 1 file changed, 91 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 524020691ef8..0f6aba760d65 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1165,6 +1165,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 		if (prev_state == VNIC_CLOSED)
 			enable_irq(adapter->tx_scrq[i]->irq);
 		enable_scrq_irq(adapter, adapter->tx_scrq[i]);
+		netdev_tx_reset_queue(netdev_get_tx_queue(netdev, i));
 	}
 
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
@@ -1529,10 +1530,12 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
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
@@ -1547,7 +1550,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int index = 0;
 	u8 proto = 0;
 	u64 handle;
-	netdev_tx_t ret = NETDEV_TX_OK;
+	int i;
 
 	if (test_bit(0, &adapter->resetting)) {
 		if (!netif_subqueue_stopped(netdev, skb))
@@ -1666,55 +1669,37 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
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
+	netdev_tx_sent_queue(txq, skb->len);
 
-		tx_send_failed++;
-		tx_dropped++;
-		ret = NETDEV_TX_OK;
-		goto tx_err_out;
+	tx_crq.v1.n_crq_elem = num_entries;
+	tx_buff->num_entries = num_entries;
+	ind_bufp = &tx_scrq->ind_buf;
+	/* flush buffer if current entry can not fit */
+	if (num_entries + ind_bufp->index > IBMVNIC_MAX_IND_DESCS) {
+		lpar_rc = send_subcrq_indirect(adapter, handle,
+					       (u64)ind_bufp->indir_dma,
+					       (u64)ind_bufp->index);
+		if (lpar_rc != H_SUCCESS)
+			goto tx_flush_err;
+		ind_bufp->index = 0;
+	}
+
+	tx_buff->indir_arr[0] = tx_crq;
+	memcpy(&ind_bufp->indir_arr[ind_bufp->index], tx_buff->indir_arr,
+	       num_entries * sizeof(struct ibmvnic_generic_scrq));
+	ind_bufp->index += num_entries;
+	if (!netdev_xmit_more() || netif_xmit_stopped(txq) ||
+	    ind_bufp->index == IBMVNIC_MAX_IND_DESCS) {
+		lpar_rc = send_subcrq_indirect(adapter, handle,
+					       (u64)ind_bufp->indir_dma,
+					       (u64)ind_bufp->index);
+		ind_bufp->index = 0;
+		if (lpar_rc != H_SUCCESS)
+			goto tx_err;
 	}
 
 	if (atomic_add_return(num_entries, &tx_scrq->used)
@@ -1729,14 +1714,51 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
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
+	for (i = ind_bufp->index - 1; i >= 0; --i) {
+		tx_crq = ind_bufp->indir_arr[i];
+		if (tx_crq.v1.type != IBMVNIC_TX_DESC)
+			continue;
+		index = be32_to_cpu(tx_crq.v1.correlator);
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
+		netdev->stats.tx_packets--;
+		netdev->stats.tx_bytes -= tx_buff->skb->len;
+		adapter->tx_stats_buffers[queue_num].packets--;
+		adapter->tx_stats_buffers[queue_num].bytes -= tx_buff->skb->len;
+		dev_kfree_skb_any(tx_buff->skb);
+		tx_buff->skb = NULL;
+		tx_dropped++;
+	}
+	ind_bufp->index = 0;
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
@@ -3115,6 +3137,7 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_tx_pool *tx_pool;
 	struct ibmvnic_tx_buff *txbuff;
+	struct netdev_queue *txq;
 	union sub_crq *next;
 	int index;
 	int i, j;
@@ -3123,6 +3146,8 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	while (pending_scrq(adapter, scrq)) {
 		unsigned int pool = scrq->pool_index;
 		int num_entries = 0;
+		int total_bytes = 0;
+		int num_packets = 0;
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		/* ensure that we are reading the correct queue entry */
@@ -3150,13 +3175,16 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
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
@@ -3165,6 +3193,9 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
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

