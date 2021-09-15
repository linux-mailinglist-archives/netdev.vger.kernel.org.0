Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FE240BEA3
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbhIODy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17664 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232804AbhIODyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:38 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F1Tvua005867
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YkpBmgDxJtLNKDhEDlT+UIY0k1WsRxFY/fIk9yXGiVc=;
 b=SlNw9ygntVa3a20jQHQoQKJymRNtRvqM9qI/6iEaKJVgUuyoVL4ioQTP1ldk27+v+e/s
 NrnDHITMKAbl3xaQ/XoGd1nJQpICtqsU90H4S3zSlUPmcN2UWe8brJB/LFj5yI/uJqI7
 Oj0hjCWmUeIP52Fr2YjQ131AJk4LGoZOQk7sC2anqlbk03CIs+sWA0D2Zxe7jO0eUO3e
 GKVRbwzl/7a7Flo4cvNNM7K8MMwMVLx7aW3gTz1Km5tM2vC54zmUaoaB6Yl9n+fX/EDR
 dv3mw8TZEDBXx+ZN3ZigRsOHJkTl5YKGWoYKwCGAwKrMezPgEsKKwHWOkJIF76JzHRzH 8g== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b377kj2cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lOwo023322
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:18 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3b0m3bg58r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3rHed46531000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:17 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D72DD112061;
        Wed, 15 Sep 2021 03:53:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21BC3112065;
        Wed, 15 Sep 2021 03:53:16 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:15 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 8/9] ibmvnic: Reuse rx pools when possible
Date:   Tue, 14 Sep 2021 20:52:58 -0700
Message-Id: <20210915035259.355092-9-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XhsRKa59XFkIv5zMsJ3ZZ2zRDCyQOc1n
X-Proofpoint-GUID: XhsRKa59XFkIv5zMsJ3ZZ2zRDCyQOc1n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than releasing the rx pools on and reallocating them on every
reset, reuse the rx pools unless the pool parameters (number of pools,
size of each pool or size of each buffer in a pool) have changed.

If the pool parameters changed, then release the old pools (if any)
and allocate new ones.

Specifically release rx pools, if:
	- adapter is removed,
	- pool parameters change during reset,
	- we encounter an error when opening the adapter in response
	  to a user request (in ibmvnic_open()).

and don't release them:
	- in __ibmvnic_close() or
	- on errors in __ibmvnic_open()

in the hope that we can reuse them on the next reset.

With these, reset_rx_pools() can be dropped because its optimzation is
now included in init_rx_pools() itself.

cleanup_rx_pools() releases all the skbs associated with the pool and
is called from ibmvnic_cleanup(), which is called on every reset. Since
we want to reuse skbs across resets, move cleanup_rx_pools() out of
ibmvnic_cleanup() and call it only when user closes the adapter.

Add two new adapter fields, ->prev_rx_buf_sz, ->prev_rx_pool_size to
keep track of the previous values and use them to decide whether to
reuse or realloc the pools.

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Changelog[v2]: [Jakub Kicinski] Fix kdoc issues
---
 drivers/net/ethernet/ibm/ibmvnic.c | 198 +++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |   3 +
 2 files changed, 137 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index dafb36690fdc..05aabb0effef 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -383,20 +383,27 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	 * be 0.
 	 */
 	for (i = ind_bufp->index; i < count; ++i) {
-		skb = netdev_alloc_skb(adapter->netdev, pool->buff_size);
+		index = pool->free_map[pool->next_free];
+
+		/* We maybe reusing the skb from earlier resets. Allocate
+		 * only if necessary. But since the LTB may have changed
+		 * during reset (see init_rx_pools()), update LTB below
+		 * even if reusing skb.
+		 */
+		skb = pool->rx_buff[index].skb;
 		if (!skb) {
-			dev_err(dev, "Couldn't replenish rx buff\n");
-			adapter->replenish_no_mem++;
-			break;
+			skb = netdev_alloc_skb(adapter->netdev,
+					       pool->buff_size);
+			if (!skb) {
+				dev_err(dev, "Couldn't replenish rx buff\n");
+				adapter->replenish_no_mem++;
+				break;
+			}
 		}
 
-		index = pool->free_map[pool->next_free];
 		pool->free_map[pool->next_free] = IBMVNIC_INVALID_MAP;
 		pool->next_free = (pool->next_free + 1) % pool->size;
 
-		if (pool->rx_buff[index].skb)
-			dev_err(dev, "Inconsistent free_map!\n");
-
 		/* Copy the skb to the long term mapped DMA buffer */
 		offset = index * pool->buff_size;
 		dst = pool->long_term_buff.buff + offset;
@@ -547,45 +554,6 @@ static int init_stats_token(struct ibmvnic_adapter *adapter)
 	return 0;
 }
 
-static int reset_rx_pools(struct ibmvnic_adapter *adapter)
-{
-	struct ibmvnic_rx_pool *rx_pool;
-	u64 buff_size;
-	int rx_scrqs;
-	int i, j, rc;
-
-	if (!adapter->rx_pool)
-		return -1;
-
-	buff_size = adapter->cur_rx_buf_sz;
-	rx_scrqs = adapter->num_active_rx_pools;
-	for (i = 0; i < rx_scrqs; i++) {
-		rx_pool = &adapter->rx_pool[i];
-
-		netdev_dbg(adapter->netdev, "Re-setting rx_pool[%d]\n", i);
-
-		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
-		rc = alloc_long_term_buff(adapter,
-					  &rx_pool->long_term_buff,
-					  rx_pool->size * rx_pool->buff_size);
-		if (rc)
-			return rc;
-
-		for (j = 0; j < rx_pool->size; j++)
-			rx_pool->free_map[j] = j;
-
-		memset(rx_pool->rx_buff, 0,
-		       rx_pool->size * sizeof(struct ibmvnic_rx_buff));
-
-		atomic_set(&rx_pool->available, 0);
-		rx_pool->next_alloc = 0;
-		rx_pool->next_free = 0;
-		rx_pool->active = 1;
-	}
-
-	return 0;
-}
-
 /**
  * release_rx_pools() - Release any rx pools attached to @adapter.
  * @adapter: ibmvnic adapter
@@ -606,6 +574,7 @@ static void release_rx_pools(struct ibmvnic_adapter *adapter)
 		netdev_dbg(adapter->netdev, "Releasing rx_pool[%d]\n", i);
 
 		kfree(rx_pool->free_map);
+
 		free_long_term_buff(adapter, &rx_pool->long_term_buff);
 
 		if (!rx_pool->rx_buff)
@@ -624,8 +593,68 @@ static void release_rx_pools(struct ibmvnic_adapter *adapter)
 	kfree(adapter->rx_pool);
 	adapter->rx_pool = NULL;
 	adapter->num_active_rx_pools = 0;
+	adapter->prev_rx_pool_size = 0;
+}
+
+/**
+ * reuse_rx_pools() - Check if the existing rx pools can be reused.
+ * @adapter: ibmvnic adapter
+ *
+ * Check if the existing rx pools in the adapter can be reused. The
+ * pools can be reused if the pool parameters (number of pools,
+ * number of buffers in the pool and size of each buffer) have not
+ * changed.
+ *
+ * NOTE: This assumes that all pools have the same number of buffers
+ *       which is the case currently. If that changes, we must fix this.
+ *
+ * Return: true if the rx pools can be reused, false otherwise.
+ */
+static bool reuse_rx_pools(struct ibmvnic_adapter *adapter)
+{
+	u64 old_num_pools, new_num_pools;
+	u64 old_pool_size, new_pool_size;
+	u64 old_buff_size, new_buff_size;
+
+	if (!adapter->rx_pool)
+		return false;
+
+	old_num_pools = adapter->num_active_rx_pools;
+	new_num_pools = adapter->req_rx_queues;
+
+	old_pool_size = adapter->prev_rx_pool_size;
+	new_pool_size = adapter->req_rx_add_entries_per_subcrq;
+
+	old_buff_size = adapter->prev_rx_buf_sz;
+	new_buff_size = adapter->cur_rx_buf_sz;
+
+	/* Require buff size to be exactly same for now */
+	if (old_buff_size != new_buff_size)
+		return false;
+
+	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
+		return true;
+
+	if (old_num_pools < adapter->min_rx_queues ||
+	    old_num_pools > adapter->max_rx_queues ||
+	    old_pool_size < adapter->min_rx_add_entries_per_subcrq ||
+	    old_pool_size > adapter->max_rx_add_entries_per_subcrq)
+		return false;
+
+	return true;
 }
 
+/**
+ * init_rx_pools(): Initialize the set of receiver pools in the adapter.
+ * @netdev: net device associated with the vnic interface
+ *
+ * Initialize the set of receiver pools in the ibmvnic adapter associated
+ * with the net_device @netdev. If possible, reuse the existing rx pools.
+ * Otherwise free any existing pools and  allocate a new set of pools
+ * before initializing them.
+ *
+ * Return: 0 on success and negative value on error.
+ */
 static int init_rx_pools(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
@@ -636,10 +665,18 @@ static int init_rx_pools(struct net_device *netdev)
 	u64 buff_size;
 	int i, j;
 
-	num_pools = adapter->num_active_rx_scrqs;
 	pool_size = adapter->req_rx_add_entries_per_subcrq;
+	num_pools = adapter->req_rx_queues;
 	buff_size = adapter->cur_rx_buf_sz;
 
+	if (reuse_rx_pools(adapter)) {
+		dev_dbg(dev, "Reusing rx pools\n");
+		goto update_ltb;
+	}
+
+	/* Allocate/populate the pools. */
+	release_rx_pools(adapter);
+
 	adapter->rx_pool = kcalloc(num_pools,
 				   sizeof(struct ibmvnic_rx_pool),
 				   GFP_KERNEL);
@@ -663,14 +700,12 @@ static int init_rx_pools(struct net_device *netdev)
 		rx_pool->size = pool_size;
 		rx_pool->index = i;
 		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
-		rx_pool->active = 1;
 
 		rx_pool->free_map = kcalloc(rx_pool->size, sizeof(int),
 					    GFP_KERNEL);
 		if (!rx_pool->free_map) {
 			dev_err(dev, "Couldn't alloc free_map %d\n", i);
-			release_rx_pools(adapter);
-			return -1;
+			goto out_release;
 		}
 
 		rx_pool->rx_buff = kcalloc(rx_pool->size,
@@ -678,25 +713,58 @@ static int init_rx_pools(struct net_device *netdev)
 					   GFP_KERNEL);
 		if (!rx_pool->rx_buff) {
 			dev_err(dev, "Couldn't alloc rx buffers\n");
-			release_rx_pools(adapter);
-			return -1;
+			goto out_release;
 		}
+	}
+
+	adapter->prev_rx_pool_size = pool_size;
+	adapter->prev_rx_buf_sz = adapter->cur_rx_buf_sz;
+
+update_ltb:
+	for (i = 0; i < num_pools; i++) {
+		rx_pool = &adapter->rx_pool[i];
+		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
+			i, rx_pool->size, rx_pool->buff_size);
 
 		if (alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
-					 rx_pool->size * rx_pool->buff_size)) {
-			release_rx_pools(adapter);
-			return -1;
-		}
+					 rx_pool->size * rx_pool->buff_size))
+			goto out;
+
+		for (j = 0; j < rx_pool->size; ++j) {
+			struct ibmvnic_rx_buff *rx_buff;
 
-		for (j = 0; j < rx_pool->size; ++j)
 			rx_pool->free_map[j] = j;
 
+			/* NOTE: Don't clear rx_buff->skb here - will leak
+			 * memory! replenish_rx_pool() will reuse skbs or
+			 * allocate as necessary.
+			 */
+			rx_buff = &rx_pool->rx_buff[j];
+			rx_buff->dma = 0;
+			rx_buff->data = 0;
+			rx_buff->size = 0;
+			rx_buff->pool_index = 0;
+		}
+
+		/* Mark pool "empty" so replenish_rx_pools() will
+		 * update the LTB info for each buffer
+		 */
 		atomic_set(&rx_pool->available, 0);
 		rx_pool->next_alloc = 0;
 		rx_pool->next_free = 0;
+		/* replenish_rx_pool() may have called deactivate_rx_pools()
+		 * on failover. Ensure pool is active now.
+		 */
+		rx_pool->active = 1;
 	}
-
 	return 0;
+out_release:
+	release_rx_pools(adapter);
+out:
+	/* We failed to allocate one or more LTBs or map them on the VIOS.
+	 * Hold onto the pools and any LTBs that we did allocate/map.
+	 */
+	return -1;
 }
 
 static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
@@ -1072,7 +1140,6 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 	release_vpd_data(adapter);
 
 	release_tx_pools(adapter);
-	release_rx_pools(adapter);
 
 	release_napi(adapter);
 	release_login_buffer(adapter);
@@ -1345,6 +1412,7 @@ static int ibmvnic_open(struct net_device *netdev)
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
 			release_resources(adapter);
+			release_rx_pools(adapter);
 			goto out;
 		}
 	}
@@ -1474,7 +1542,6 @@ static void ibmvnic_cleanup(struct net_device *netdev)
 	ibmvnic_napi_disable(adapter);
 	ibmvnic_disable_irqs(adapter);
 
-	clean_rx_pools(adapter);
 	clean_tx_pools(adapter);
 }
 
@@ -1509,6 +1576,7 @@ static int ibmvnic_close(struct net_device *netdev)
 
 	rc = __ibmvnic_close(netdev);
 	ibmvnic_cleanup(netdev);
+	clean_rx_pools(adapter);
 
 	return rc;
 }
@@ -2237,7 +2305,6 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		    !adapter->rx_pool ||
 		    !adapter->tso_pool ||
 		    !adapter->tx_pool) {
-			release_rx_pools(adapter);
 			release_tx_pools(adapter);
 			release_napi(adapter);
 			release_vpd_data(adapter);
@@ -2254,9 +2321,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 				goto out;
 			}
 
-			rc = reset_rx_pools(adapter);
+			rc = init_rx_pools(netdev);
 			if (rc) {
-				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
+				netdev_dbg(netdev,
+					   "init rx pools failed (%d)\n",
 					   rc);
 				goto out;
 			}
@@ -5592,6 +5660,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	init_completion(&adapter->reset_done);
 	init_completion(&adapter->stats_done);
 	clear_bit(0, &adapter->resetting);
+	adapter->prev_rx_buf_sz = 0;
 
 	init_success = false;
 	do {
@@ -5692,6 +5761,7 @@ static void ibmvnic_remove(struct vio_dev *dev)
 	unregister_netdevice(netdev);
 
 	release_resources(adapter);
+	release_rx_pools(adapter);
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index e97f1aa98c05..b73a1b812368 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -986,7 +986,10 @@ struct ibmvnic_adapter {
 	u32 num_active_rx_napi;
 	u32 num_active_tx_scrqs;
 	u32 num_active_tx_pools;
+
+	u32 prev_rx_pool_size;
 	u32 cur_rx_buf_sz;
+	u32 prev_rx_buf_sz;
 
 	struct tasklet_struct tasklet;
 	enum vnic_state state;
-- 
2.26.2

