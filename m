Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719FB4FFC1D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiDMRNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbiDMRM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388281B7A8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:34 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DGqtqs030707
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iLUiv2KuWFDlO/82AeGSem8If0bIvKBiXYJAgQhYnUo=;
 b=XIHwcMFZJgezNSPiPVNjDFb28rm/jvuPfLSukxRM+B+EjPr4jikEP8pE28KoLPzTT4wn
 PZx2xVKE6pdrAKHqH0sfBmQOJrLBgTvR0NSMz4Z6OlUx3/02rBXH5tbHB3tAQE7dHxj8
 EnHSPFGi7IKV9xF2qdmQG7XxGiEhtJWOFzsNEk/HJaNSyKkf4AExXYfsL15uY0L9c16k
 hXiA58cFv0iWwc9VgtLHQ/PYcGCM0fMRnm6NtTZO3sg4zwbf/5zOYiQVFP0/oMm7FVYJ
 Ecjwx5pSqVgtNEMRe9fUL/hl/ztpDlkiaxZ6NKKBACvJLE8lGIKM/4nbGucr3SLc+Zcf 3w== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fe23arvqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:33 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGrNqF014125
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 3fb1s9su9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHAVFX14680466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:31 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DAE1124069;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 212B3124062;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 5/6] ibmvnic: Allow multiple ltbs in rxpool ltb_set
Date:   Wed, 13 Apr 2022 13:10:25 -0400
Message-Id: <20220413171026.1264294-6-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
References: <20220413171026.1264294-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BH2RXxi1dfXS9GknHDPFg5V7rCIY2ttk
X-Proofpoint-ORIG-GUID: BH2RXxi1dfXS9GknHDPFg5V7rCIY2ttk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Allow multiple LTBs in the rxpool's ltb_set. The first n-1 LTBs will all
be of the same size. The size of the last LTB in the set depends on the
number of buffers and buffer (mtu) size.

Having a set of LTBs per pool provides a couple of benefits.

First, with the current value of IBMVNIC_MAX_LTB_SIZE of 16MB, with an
MTU of 9000, we need a LTB (DMA buffer) of that size but the allocation
can fail in low memory conditions. With a set of LTBs per pool, we can
use several smaller (8MB) LTBs and hopefully have fewer allocation
failures. (See also comments in ibmvnic.h on the trade-off with smaller
LTBs)

Second since the kernel limits the size of the DMA buffer to 16MB (based
on MAX_ORDER), with a single DMA buffer per pool, the pool is also limited
to 16MB. This in turn limits the number of buffers per pool to 1763 when
MTU is 9000. With a set of LTBs per pool, we can have upto the max of 4096
buffers per pool even when MTU is 9000.

Suggested-by: Brian King <brking@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 152 +++++++++++++++++++++++++----
 drivers/net/ethernet/ibm/ibmvnic.h |  45 ++++++++-
 2 files changed, 177 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 765a48833b3b..16fd1f1f1228 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -345,6 +345,14 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	ltb->map_id = 0;
 }
 
+/**
+ * free_ltb_set - free the given set of long term buffers (LTBS)
+ * @adapter: The ibmvnic adapter containing this ltb set
+ * @ltb_set: The ltb_set to be freed
+ *
+ * Free the set of LTBs in the given set.
+ */
+
 static void free_ltb_set(struct ibmvnic_adapter *adapter,
 			 struct ibmvnic_ltb_set *ltb_set)
 {
@@ -358,26 +366,117 @@ static void free_ltb_set(struct ibmvnic_adapter *adapter,
 	ltb_set->num_ltbs = 0;
 }
 
+/**
+ * alloc_ltb_set() - Allocate a set of long term buffers (LTBs)
+ *
+ * @adapter: ibmvnic adapter associated to the LTB
+ * @ltb_set: container object for the set of LTBs
+ * @num_buffs: Number of buffers in the LTB
+ * @buff_size: Size of each buffer in the LTB
+ *
+ * Allocate a set of LTBs to accommodate @num_buffs buffers of @buff_size
+ * each. We currently cap size each LTB to IBMVNIC_ONE_LTB_SIZE. If the
+ * new set of LTBs have fewer LTBs than the old set, free the excess LTBs.
+ * If new set needs more than in old set, allocate the remaining ones.
+ * Try and reuse as many LTBs as possible and avoid reallocation.
+ *
+ * Any changes to this allocation strategy must be reflected in
+ * map_rxpool_buff_to_ltb() and map_txpool_buff_to_ltb().
+ */
 static int alloc_ltb_set(struct ibmvnic_adapter *adapter,
 			 struct ibmvnic_ltb_set *ltb_set, int num_buffs,
 			 int buff_size)
 {
-	struct ibmvnic_long_term_buff *ltb;
-	int ltb_size;
-	int size;
+	struct device *dev = &adapter->vdev->dev;
+	struct ibmvnic_ltb_set old_set;
+	struct ibmvnic_ltb_set new_set;
+	int rem_size;
+	int tot_size;		/* size of all ltbs */
+	int ltb_size;		/* size of one ltb */
+	int nltbs;
+	int rc;
+	int n;
+	int i;
 
-	size = sizeof(struct ibmvnic_long_term_buff);
+	dev_dbg(dev, "%s() num_buffs %d, buff_size %d\n", __func__, num_buffs,
+		buff_size);
 
-	ltb_set->ltbs = kmalloc(size, GFP_KERNEL);
-	if (!ltb_set->ltbs)
-		return -ENOMEM;
+	ltb_size = rounddown(IBMVNIC_ONE_LTB_SIZE, buff_size);
+	tot_size = num_buffs * buff_size;
+
+	if (ltb_size > tot_size)
+		ltb_size = tot_size;
+
+	nltbs = tot_size / ltb_size;
+	if (tot_size % ltb_size)
+		nltbs++;
+
+	old_set = *ltb_set;
+
+	if (old_set.num_ltbs == nltbs) {
+		new_set = old_set;
+	} else {
+		int tmp = nltbs * sizeof(struct ibmvnic_long_term_buff);
+
+		new_set.ltbs = kzalloc(tmp, GFP_KERNEL);
+		if (!new_set.ltbs)
+			return -ENOMEM;
+
+		new_set.num_ltbs = nltbs;
+
+		/* Free any excess ltbs in old set */
+		for (i = new_set.num_ltbs; i < old_set.num_ltbs; i++)
+			free_long_term_buff(adapter, &old_set.ltbs[i]);
+
+		/* Copy remaining ltbs to new set. All LTBs except the
+		 * last one are of the same size. alloc_long_term_buff()
+		 * will realloc if the size changes.
+		 */
+		n = min(old_set.num_ltbs, new_set.num_ltbs);
+		for (i = 0; i < n; i++)
+			new_set.ltbs[i] = old_set.ltbs[i];
 
-	ltb_set->num_ltbs = 1;
-	ltb = &ltb_set->ltbs[0];
+		/* Any additional ltbs in new set will have NULL ltbs for
+		 * now and will be allocated in alloc_long_term_buff().
+		 */
+
+		/* We no longer need the old_set so free it. Note that we
+		 * may have reused some ltbs from old set and freed excess
+		 * ltbs above. So we only need to free the container now
+		 * not the LTBs themselves. (i.e. dont free_ltb_set()!)
+		 */
+		kfree(old_set.ltbs);
+		old_set.ltbs = NULL;
+		old_set.num_ltbs = 0;
+
+		/* Install the new set. If allocations fail below, we will
+		 * retry later and know what size LTBs we need.
+		 */
+		*ltb_set = new_set;
+	}
+
+	i = 0;
+	rem_size = tot_size;
+	while (rem_size) {
+		if (ltb_size > rem_size)
+			ltb_size = rem_size;
+
+		rem_size -= ltb_size;
+
+		rc = alloc_long_term_buff(adapter, &new_set.ltbs[i], ltb_size);
+		if (rc)
+			goto out;
+		i++;
+	}
 
-	ltb_size = num_buffs * buff_size;
+	WARN_ON(i != new_set.num_ltbs);
 
-	return alloc_long_term_buff(adapter, ltb, ltb_size);
+	return 0;
+out:
+	/* We may have allocated one/more LTBs before failing and we
+	 * want to try and reuse on next reset. So don't free ltb set.
+	 */
+	return rc;
 }
 
 /**
@@ -388,14 +487,30 @@ static int alloc_ltb_set(struct ibmvnic_adapter *adapter,
  * @offset: (Output) offset of buffer in the LTB from @ltbp
  *
  * Map the given buffer identified by [rxpool, bufidx] to an LTB in the
- * pool and its corresponding offset.
+ * pool and its corresponding offset. Assume for now that each LTB is of
+ * different size but could possibly be optimized based on the allocation
+ * strategy in alloc_ltb_set().
  */
 static void map_rxpool_buf_to_ltb(struct ibmvnic_rx_pool *rxpool,
 				  unsigned int bufidx,
 				  struct ibmvnic_long_term_buff **ltbp,
 				  unsigned int *offset)
 {
-	*ltbp = &rxpool->ltb_set.ltbs[0];
+	struct ibmvnic_long_term_buff *ltb;
+	int nbufs;	/* # of buffers in one ltb */
+	int i;
+
+	WARN_ON(bufidx >= rxpool->size);
+
+	for (i = 0; i < rxpool->ltb_set.num_ltbs; i++) {
+		ltb = &rxpool->ltb_set.ltbs[i];
+		nbufs = ltb->size / rxpool->buff_size;
+		if (bufidx < nbufs)
+			break;
+		bufidx -= nbufs;
+	}
+
+	*ltbp = ltb;
 	*offset = bufidx * rxpool->buff_size;
 }
 
@@ -798,8 +913,9 @@ static int init_rx_pools(struct net_device *netdev)
 		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
 			i, rx_pool->size, rx_pool->buff_size);
 
-		if (alloc_ltb_set(adapter, &rx_pool->ltb_set,
-				  rx_pool->size, rx_pool->buff_size))
+		rc = alloc_ltb_set(adapter, &rx_pool->ltb_set,
+				   rx_pool->size, rx_pool->buff_size);
+		if (rc)
 			goto out;
 
 		for (j = 0; j < rx_pool->size; ++j) {
@@ -4106,16 +4222,16 @@ static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 			adapter->desired.rx_entries =
 					adapter->max_rx_add_entries_per_subcrq;
 
-		max_entries = IBMVNIC_MAX_LTB_SIZE /
+		max_entries = IBMVNIC_LTB_SET_SIZE /
 			      (adapter->req_mtu + IBMVNIC_BUFFER_HLEN);
 
 		if ((adapter->req_mtu + IBMVNIC_BUFFER_HLEN) *
-			adapter->desired.tx_entries > IBMVNIC_MAX_LTB_SIZE) {
+			adapter->desired.tx_entries > IBMVNIC_LTB_SET_SIZE) {
 			adapter->desired.tx_entries = max_entries;
 		}
 
 		if ((adapter->req_mtu + IBMVNIC_BUFFER_HLEN) *
-			adapter->desired.rx_entries > IBMVNIC_MAX_LTB_SIZE) {
+			adapter->desired.rx_entries > IBMVNIC_LTB_SET_SIZE) {
 			adapter->desired.rx_entries = max_entries;
 		}
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 7d430fdf47c0..178035872c32 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -36,9 +36,50 @@
 #define IBMVNIC_TSO_BUFS	64
 #define IBMVNIC_TSO_POOL_MASK	0x80000000
 
-#define IBMVNIC_MAX_LTB_SIZE ((1 << (MAX_ORDER - 1)) * PAGE_SIZE)
-#define IBMVNIC_BUFFER_HLEN 500
+/* A VNIC adapter has set of Rx and Tx pools (aka queues). Each Rx/Tx pool
+ * has a set of buffers. The size of each buffer is determined by the MTU.
+ *
+ * Each Rx/Tx pool is also associated with a DMA region that is shared
+ * with the "hardware" (VIOS) and used to send/receive packets. The DMA
+ * region is also referred to as a Long Term Buffer or LTB.
+ *
+ * The size of the DMA region required for an Rx/Tx pool depends on the
+ * number and size (MTU) of the buffers in the pool. At the max levels
+ * of 4096 jumbo frames (MTU=9000) we will need about 9K*4K = 36MB plus
+ * some padding.
+ *
+ * But the size of a single DMA region is limited by MAX_ORDER in the
+ * kernel (about 16MB currently).  To support say 4K Jumbo frames, we
+ * use a set of LTBs (struct ltb_set) per pool.
+ *
+ * IBMVNIC_ONE_LTB_MAX  - max size of each LTB supported by kernel
+ * IBMVNIC_ONE_LTB_SIZE - current max size of each LTB in an ltb_set
+ * (must be <= IBMVNIC_ONE_LTB_MAX)
+ * IBMVNIC_LTB_SET_SIZE - current size of all LTBs in an ltb_set
+ *
+ * Each VNIC can have upto 16 Rx, 16 Tx and 16 TSO pools. The TSO pools
+ * are of fixed length (IBMVNIC_TSO_BUF_SZ * IBMVNIC_TSO_BUFS) of 4MB.
+ *
+ * The Rx and Tx pools can have upto 4096 buffers. The max size of these
+ * buffers is about 9588 (for jumbo frames, including IBMVNIC_BUFFER_HLEN).
+ * So, setting the IBMVNIC_LTB_SET_SIZE for a pool to 4096 * 9588 ~= 38MB.
+ *
+ * There is a trade-off in setting IBMVNIC_ONE_LTB_SIZE. If it is large,
+ * the allocation of the LTB can fail when system is low in memory. If
+ * its too small, we would need several mappings for each of the Rx/
+ * Tx/TSO pools but there is a limit of 255 mappings per vnic in the
+ * VNIC protocol.
+ *
+ * So setting IBMVNIC_ONE_LTB_SIZE to 8MB. With IBMVNIC_LTB_SET_SIZE set
+ * to 38MB, we will need 5 LTBs per Rx and Tx pool and 1 LTB per TSO
+ * pool for the 4MB. Thus the 16 Rx and Tx queues require 32 * 5 = 160
+ * plus 16 for the TSO pools for a total of 176 LTB mappings per VNIC.
+ */
+#define IBMVNIC_ONE_LTB_MAX	((u32)((1 << (MAX_ORDER - 1)) * PAGE_SIZE))
+#define IBMVNIC_ONE_LTB_SIZE	min((u32)(8 << 20), IBMVNIC_ONE_LTB_MAX)
+#define IBMVNIC_LTB_SET_SIZE	(38 << 20)
 
+#define IBMVNIC_BUFFER_HLEN		500
 #define IBMVNIC_RESET_DELAY 100
 
 static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
-- 
2.27.0

