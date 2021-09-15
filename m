Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC0740BEA4
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhIODy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30346 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236279AbhIODyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F1TuLf005836
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9RTzSLJRzQr1R6OZD1Kd9en2LTJQUwi92pdoKS6C3SM=;
 b=AIb7BbPgQRqseHSonk1CQcThnWLpdX9k45+hxCJ0lqqwnFQIRWbXKfFSFncYvgov+aYo
 2x1U4S8weoqaipdjRrGaY3GiDWGrtYrOleoK3D28njiVw7tyfjXF6d9r/Rkjza5hrRHR
 TplzbbAdXiZDa//TMO4dwPGLOK+8u1YmZNPNQTNECoYYNUGf3Tu8ixpJZ/e0c+bh9qvA
 yvjWE5sGtjYF78K6IHRkDSE0UmkdM1ng7T8du67VQetSkMSRemMot0sw12JbRVgTkiUP
 S/gZV5KT+I2OUpjIn9bEaeInsppvT0oP+4oTVf7+rH5V0NunVK5CbNMzEwbnMEyCYlHo 3Q== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b377kj2d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:22 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3pw2L024179
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:21 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3b0m3a07r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:21 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3rJcl39584144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:19 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 986EB112062;
        Wed, 15 Sep 2021 03:53:19 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46D7F112066;
        Wed, 15 Sep 2021 03:53:18 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:18 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 9/9] ibmvnic: Reuse tx pools when possible
Date:   Tue, 14 Sep 2021 20:52:59 -0700
Message-Id: <20210915035259.355092-10-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OQubL1AKRx5WTM-l9O0doWmSQhrCxDTt
X-Proofpoint-GUID: OQubL1AKRx5WTM-l9O0doWmSQhrCxDTt
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

Rather than releasing the tx pools on every close and reallocating
them on open, reuse the tx pools unless the pool parameters (number
of pools, size of each pool or size of each buffer in a pool) have
changed.

If the pool parameters changed, then release the old pools (if
any) and allocate new ones.

Specifically release tx pools, if:
	- adapter is removed,
	- pool parameters change during reset,
	- we encounter an error when opening the adapter in response
	  to a user request (in ibmvnic_open()).

and don't release them:
	- in __ibmvnic_close() or
	- on errors in __ibmvnic_open()

in the hope that we can reuse them during this or next reset.

With these changes reset_tx_pools() can be dropped because its
optimization is now included in init_tx_pools() itself.

cleanup_tx_pools() releases all the skbs associated with the pool and
is called from ibmvnic_cleanup(), which is called on every reset. Since
we want to reuse skbs across resets, move cleanup_tx_pools() out of
ibmvnic_cleanup() and call it only when user closes the adapter.

Add two new adapter fields, ->prev_mtu, ->prev_tx_pool_size to track the
previous values and use them to decide whether to reuse or realloc the
pools.

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Changelog[v2]: [Jakub Kicinski] Fix kdoc issues
---
 drivers/net/ethernet/ibm/ibmvnic.c | 215 +++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |   2 +
 2 files changed, 147 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 05aabb0effef..d1be883f933a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -767,53 +767,6 @@ static int init_rx_pools(struct net_device *netdev)
 	return -1;
 }
 
-static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
-			     struct ibmvnic_tx_pool *tx_pool)
-{
-	struct ibmvnic_long_term_buff *ltb;
-	int rc, i;
-
-	ltb = &tx_pool->long_term_buff;
-
-	rc = alloc_long_term_buff(adapter, ltb, ltb->size);
-	if (rc)
-		return rc;
-
-	memset(tx_pool->tx_buff, 0,
-	       tx_pool->num_buffers *
-	       sizeof(struct ibmvnic_tx_buff));
-
-	for (i = 0; i < tx_pool->num_buffers; i++)
-		tx_pool->free_map[i] = i;
-
-	tx_pool->consumer_index = 0;
-	tx_pool->producer_index = 0;
-
-	return 0;
-}
-
-static int reset_tx_pools(struct ibmvnic_adapter *adapter)
-{
-	int tx_scrqs;
-	int i, rc;
-
-	if (!adapter->tx_pool)
-		return -1;
-
-	tx_scrqs = adapter->num_active_tx_pools;
-	for (i = 0; i < tx_scrqs; i++) {
-		ibmvnic_tx_scrq_clean_buffer(adapter, adapter->tx_scrq[i]);
-		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
-		if (rc)
-			return rc;
-		rc = reset_one_tx_pool(adapter, &adapter->tx_pool[i]);
-		if (rc)
-			return rc;
-	}
-
-	return 0;
-}
-
 static void release_vpd_data(struct ibmvnic_adapter *adapter)
 {
 	if (!adapter->vpd)
@@ -859,13 +812,13 @@ static void release_tx_pools(struct ibmvnic_adapter *adapter)
 	kfree(adapter->tso_pool);
 	adapter->tso_pool = NULL;
 	adapter->num_active_tx_pools = 0;
+	adapter->prev_tx_pool_size = 0;
 }
 
 static int init_one_tx_pool(struct net_device *netdev,
 			    struct ibmvnic_tx_pool *tx_pool,
 			    int pool_size, int buf_size)
 {
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int i;
 
 	tx_pool->tx_buff = kcalloc(pool_size,
@@ -874,13 +827,12 @@ static int init_one_tx_pool(struct net_device *netdev,
 	if (!tx_pool->tx_buff)
 		return -1;
 
-	if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
-				 pool_size * buf_size))
-		return -1;
-
 	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
-	if (!tx_pool->free_map)
+	if (!tx_pool->free_map) {
+		kfree(tx_pool->tx_buff);
+		tx_pool->tx_buff = NULL;
 		return -1;
+	}
 
 	for (i = 0; i < pool_size; i++)
 		tx_pool->free_map[i] = i;
@@ -893,6 +845,62 @@ static int init_one_tx_pool(struct net_device *netdev,
 	return 0;
 }
 
+/**
+ * reuse_tx_pools() - Check if the existing tx pools can be reused.
+ * @adapter: ibmvnic adapter
+ *
+ * Check if the existing tx pools in the adapter can be reused. The
+ * pools can be reused if the pool parameters (number of pools,
+ * number of buffers in the pool and mtu) have not changed.
+ *
+ * NOTE: This assumes that all pools have the same number of buffers
+ *       which is the case currently. If that changes, we must fix this.
+ *
+ * Return: true if the tx pools can be reused, false otherwise.
+ */
+static bool reuse_tx_pools(struct ibmvnic_adapter *adapter)
+{
+	u64 old_num_pools, new_num_pools;
+	u64 old_pool_size, new_pool_size;
+	u64 old_mtu, new_mtu;
+
+	if (!adapter->tx_pool)
+		return false;
+
+	old_num_pools = adapter->num_active_tx_pools;
+	new_num_pools = adapter->num_active_tx_scrqs;
+	old_pool_size = adapter->prev_tx_pool_size;
+	new_pool_size = adapter->req_tx_entries_per_subcrq;
+	old_mtu = adapter->prev_mtu;
+	new_mtu = adapter->req_mtu;
+
+	/* Require MTU to be exactly same to reuse pools for now */
+	if (old_mtu != new_mtu)
+		return false;
+
+	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
+		return true;
+
+	if (old_num_pools < adapter->min_tx_queues ||
+	    old_num_pools > adapter->max_tx_queues ||
+	    old_pool_size < adapter->min_tx_entries_per_subcrq ||
+	    old_pool_size > adapter->max_tx_entries_per_subcrq)
+		return false;
+
+	return true;
+}
+
+/**
+ * init_tx_pools(): Initialize the set of transmit pools in the adapter.
+ * @netdev: net device associated with the vnic interface
+ *
+ * Initialize the set of transmit pools in the ibmvnic adapter associated
+ * with the net_device @netdev. If possible, reuse the existing tx pools.
+ * Otherwise free any existing pools and  allocate a new set of pools
+ * before initializing them.
+ *
+ * Return: 0 on success and negative value on error.
+ */
 static int init_tx_pools(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
@@ -900,7 +908,21 @@ static int init_tx_pools(struct net_device *netdev)
 	int num_pools;
 	u64 pool_size;		/* # of buffers in pool */
 	u64 buff_size;
-	int i, rc;
+	int i, j, rc;
+
+	num_pools = adapter->req_tx_queues;
+
+	/* We must notify the VIOS about the LTB on all resets - but we only
+	 * need to alloc/populate pools if either the number of buffers or
+	 * size of each buffer in the pool has changed.
+	 */
+	if (reuse_tx_pools(adapter)) {
+		netdev_dbg(netdev, "Reusing tx pools\n");
+		goto update_ltb;
+	}
+
+	/* Allocate/populate the pools. */
+	release_tx_pools(adapter);
 
 	pool_size = adapter->req_tx_entries_per_subcrq;
 	num_pools = adapter->num_active_tx_scrqs;
@@ -925,6 +947,7 @@ static int init_tx_pools(struct net_device *netdev)
 	 * allocation, release_tx_pools() will know how many to look for.
 	 */
 	adapter->num_active_tx_pools = num_pools;
+
 	buff_size = adapter->req_mtu + VLAN_HLEN;
 	buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 
@@ -934,21 +957,73 @@ static int init_tx_pools(struct net_device *netdev)
 
 		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
 				      pool_size, buff_size);
-		if (rc) {
-			release_tx_pools(adapter);
-			return rc;
-		}
+		if (rc)
+			goto out_release;
 
 		rc = init_one_tx_pool(netdev, &adapter->tso_pool[i],
 				      IBMVNIC_TSO_BUFS,
 				      IBMVNIC_TSO_BUF_SZ);
-		if (rc) {
-			release_tx_pools(adapter);
-			return rc;
-		}
+		if (rc)
+			goto out_release;
+	}
+
+	adapter->prev_tx_pool_size = pool_size;
+	adapter->prev_mtu = adapter->req_mtu;
+
+update_ltb:
+	/* NOTE: All tx_pools have the same number of buffers (which is
+	 *       same as pool_size). All tso_pools have IBMVNIC_TSO_BUFS
+	 *       buffers (see calls init_one_tx_pool() for these).
+	 *       For consistency, we use tx_pool->num_buffers and
+	 *       tso_pool->num_buffers below.
+	 */
+	rc = -1;
+	for (i = 0; i < num_pools; i++) {
+		struct ibmvnic_tx_pool *tso_pool;
+		struct ibmvnic_tx_pool *tx_pool;
+		u32 ltb_size;
+
+		tx_pool = &adapter->tx_pool[i];
+		ltb_size = tx_pool->num_buffers * tx_pool->buf_size;
+		if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
+					 ltb_size))
+			goto out;
+
+		dev_dbg(dev, "Updated LTB for tx pool %d [%p, %d, %d]\n",
+			i, tx_pool->long_term_buff.buff,
+			tx_pool->num_buffers, tx_pool->buf_size);
+
+		tx_pool->consumer_index = 0;
+		tx_pool->producer_index = 0;
+
+		for (j = 0; j < tx_pool->num_buffers; j++)
+			tx_pool->free_map[j] = j;
+
+		tso_pool = &adapter->tso_pool[i];
+		ltb_size = tso_pool->num_buffers * tso_pool->buf_size;
+		if (alloc_long_term_buff(adapter, &tso_pool->long_term_buff,
+					 ltb_size))
+			goto out;
+
+		dev_dbg(dev, "Updated LTB for tso pool %d [%p, %d, %d]\n",
+			i, tso_pool->long_term_buff.buff,
+			tso_pool->num_buffers, tso_pool->buf_size);
+
+		tso_pool->consumer_index = 0;
+		tso_pool->producer_index = 0;
+
+		for (j = 0; j < tso_pool->num_buffers; j++)
+			tso_pool->free_map[j] = j;
 	}
 
 	return 0;
+out_release:
+	release_tx_pools(adapter);
+out:
+	/* We failed to allocate one or more LTBs or map them on the VIOS.
+	 * Hold onto the pools and any LTBs that we did allocate/map.
+	 */
+	return rc;
 }
 
 static void ibmvnic_napi_enable(struct ibmvnic_adapter *adapter)
@@ -1139,8 +1214,6 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 {
 	release_vpd_data(adapter);
 
-	release_tx_pools(adapter);
-
 	release_napi(adapter);
 	release_login_buffer(adapter);
 	release_login_rsp_buffer(adapter);
@@ -1413,6 +1486,7 @@ static int ibmvnic_open(struct net_device *netdev)
 			netdev_err(netdev, "failed to initialize resources\n");
 			release_resources(adapter);
 			release_rx_pools(adapter);
+			release_tx_pools(adapter);
 			goto out;
 		}
 	}
@@ -1541,8 +1615,6 @@ static void ibmvnic_cleanup(struct net_device *netdev)
 
 	ibmvnic_napi_disable(adapter);
 	ibmvnic_disable_irqs(adapter);
-
-	clean_tx_pools(adapter);
 }
 
 static int __ibmvnic_close(struct net_device *netdev)
@@ -1577,6 +1649,7 @@ static int ibmvnic_close(struct net_device *netdev)
 	rc = __ibmvnic_close(netdev);
 	ibmvnic_cleanup(netdev);
 	clean_rx_pools(adapter);
+	clean_tx_pools(adapter);
 
 	return rc;
 }
@@ -2153,9 +2226,9 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 static int do_reset(struct ibmvnic_adapter *adapter,
 		    struct ibmvnic_rwi *rwi, u32 reset_state)
 {
+	struct net_device *netdev = adapter->netdev;
 	u64 old_num_rx_queues, old_num_tx_queues;
 	u64 old_num_rx_slots, old_num_tx_slots;
-	struct net_device *netdev = adapter->netdev;
 	int rc;
 
 	netdev_dbg(adapter->netdev,
@@ -2305,7 +2378,6 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		    !adapter->rx_pool ||
 		    !adapter->tso_pool ||
 		    !adapter->tx_pool) {
-			release_tx_pools(adapter);
 			release_napi(adapter);
 			release_vpd_data(adapter);
 
@@ -2314,9 +2386,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 				goto out;
 
 		} else {
-			rc = reset_tx_pools(adapter);
+			rc = init_tx_pools(netdev);
 			if (rc) {
-				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
+				netdev_dbg(netdev,
+					   "init tx pools failed (%d)\n",
 					   rc);
 				goto out;
 			}
@@ -5661,6 +5734,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	init_completion(&adapter->stats_done);
 	clear_bit(0, &adapter->resetting);
 	adapter->prev_rx_buf_sz = 0;
+	adapter->prev_mtu = 0;
 
 	init_success = false;
 	do {
@@ -5762,6 +5836,7 @@ static void ibmvnic_remove(struct vio_dev *dev)
 
 	release_resources(adapter);
 	release_rx_pools(adapter);
+	release_tx_pools(adapter);
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b73a1b812368..b8e42f67d897 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -967,6 +967,7 @@ struct ibmvnic_adapter {
 	u64 min_mtu;
 	u64 max_mtu;
 	u64 req_mtu;
+	u64 prev_mtu;
 	u64 max_multicast_filters;
 	u64 vlan_header_insertion;
 	u64 rx_vlan_header_insertion;
@@ -988,6 +989,7 @@ struct ibmvnic_adapter {
 	u32 num_active_tx_pools;
 
 	u32 prev_rx_pool_size;
+	u32 prev_tx_pool_size;
 	u32 cur_rx_buf_sz;
 	u32 prev_rx_buf_sz;
 
-- 
2.26.2

