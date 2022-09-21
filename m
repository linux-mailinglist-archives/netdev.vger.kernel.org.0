Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA55E5581
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiIUVvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiIUVvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E089BA6C44
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:51:19 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LKhr5S016730
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xZayKFHvyMZpzlPe+2sVSeoPYSjCEcLLQp+vw//t6iA=;
 b=GTHWg6BSOs+O/IEhvaNhDMzFbcUdns/foFxwd5XnCyi3Wm3VRbGhYUTB/BGni9GzDqaD
 f+aa9Z5NWvdOH2pGwTsFEtNAFVJgHGzysroUb4Z7kNTvHPz8aBeNHMCbwDKZOxCBZ/8L
 rluUw6FZJ8gbyTwdgq4WkL1xKd3VDaa9+L/lbJwlbSEpMU7QKIkLm0vdfD5FXaKL7he8
 XN/UkmzOdciunJ1Y91x1FMfnBy0neHc0BiWl/gbNZ+s87G23dJpB6io+cR4DsRS7jj26
 /MCL/wCvU5P97pMPKdNbiVn10THnQm1ZyyPb6JnIjkYDltY7Ime1/aZYYO10FmLyrRe3 7Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jr94eu2s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:18 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28LLp3ft012546
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3jn5va3ngg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:17 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28LLpG8E56033640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 21:51:16 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9785805B;
        Wed, 21 Sep 2022 21:51:16 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AF465804B;
        Wed, 21 Sep 2022 21:51:14 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.65.226.154])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Sep 2022 21:51:14 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next 2/3] ibmveth: Implement multi queue on xmit
Date:   Wed, 21 Sep 2022 16:50:55 -0500
Message-Id: <20220921215056.113516-2-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220921215056.113516-1-nnac123@linux.ibm.com>
References: <20220921215056.113516-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yMGLYHhpq0j_LgXwjC3FinuRSnWBZSv6
X-Proofpoint-ORIG-GUID: yMGLYHhpq0j_LgXwjC3FinuRSnWBZSv6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_11,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=407 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209210144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `ndo_start_xmit` function is protected by a spinlock on the tx queue
being used to transmit the skb. Allow concurrent calls to
`ndo_start_xmit` by using more than one tx queue. This allows for
greater throughput when several jobs are trying to transmit data.

Introduce 8 tx queues (leave single rx queue as is) which each
correspond to one DMA mapped long term buffer.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 69 +++++++++++++++++-------------
 drivers/net/ethernet/ibm/ibmveth.h |  5 ++-
 2 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 675eaeed7a7b..7abd67c2336e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -538,20 +538,22 @@ static int ibmveth_open(struct net_device *netdev)
 		goto out_unmap_buffer_list;
 	}
 
-	adapter->tx_ltb_size = PAGE_ALIGN(IBMVETH_MAX_TX_BUF_SIZE);
-	adapter->tx_ltb_ptr = kzalloc(adapter->tx_ltb_size, GFP_KERNEL);
-	if (!adapter->tx_ltb_ptr) {
-		netdev_err(netdev,
-			   "unable to allocate transmit long term buffer\n");
-		goto out_unmap_buffer_list;
-	}
-	adapter->tx_ltb_dma = dma_map_single(dev, adapter->tx_ltb_ptr,
-					     adapter->tx_ltb_size,
-					     DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, adapter->tx_ltb_dma)) {
-		netdev_err(netdev,
-			   "unable to DMA map transmit long term buffer\n");
-		goto out_unmap_tx_dma;
+	for (i = 0; i < IBMVETH_MAX_QUEUES; i++) {
+		adapter->tx_ltb_ptr[i] = kzalloc(adapter->tx_ltb_size,
+						 GFP_KERNEL);
+		if (!adapter->tx_ltb_ptr[i]) {
+			netdev_err(netdev,
+				   "unable to allocate transmit long term buffer\n");
+			goto out_free_tx_ltb_ptrs;
+		}
+		adapter->tx_ltb_dma[i] = dma_map_single(dev,
+							adapter->tx_ltb_ptr[i],
+							adapter->tx_ltb_size,
+							DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, adapter->tx_ltb_dma[i])) {
+			netdev_err(netdev, "unable to DMA map transmit long term buffer\n");
+			goto out_unmap_tx_dma;
+		}
 	}
 
 	adapter->rx_queue.index = 0;
@@ -614,7 +616,7 @@ static int ibmveth_open(struct net_device *netdev)
 	netdev_dbg(netdev, "initial replenish cycle\n");
 	ibmveth_interrupt(netdev->irq, netdev);
 
-	netif_start_queue(netdev);
+	netif_tx_start_all_queues(netdev);
 
 	netdev_dbg(netdev, "open complete\n");
 
@@ -631,7 +633,14 @@ static int ibmveth_open(struct net_device *netdev)
 			 DMA_BIDIRECTIONAL);
 
 out_unmap_tx_dma:
-	kfree(adapter->tx_ltb_ptr);
+	kfree(adapter->tx_ltb_ptr[i]);
+
+out_free_tx_ltb_ptrs:
+	while (--i >= 0) {
+		dma_unmap_single(dev, adapter->tx_ltb_dma[i],
+				 adapter->tx_ltb_size, DMA_TO_DEVICE);
+		kfree(adapter->tx_ltb_ptr[i]);
+	}
 
 out_unmap_buffer_list:
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,
@@ -661,7 +670,7 @@ static int ibmveth_close(struct net_device *netdev)
 	napi_disable(&adapter->napi);
 
 	if (!adapter->pool_config)
-		netif_stop_queue(netdev);
+		netif_tx_stop_all_queues(netdev);
 
 	h_vio_signal(adapter->vdev->unit_address, VIO_IRQ_DISABLE);
 
@@ -695,9 +704,11 @@ static int ibmveth_close(struct net_device *netdev)
 			ibmveth_free_buffer_pool(adapter,
 						 &adapter->rx_buff_pool[i]);
 
-	dma_unmap_single(dev, adapter->tx_ltb_dma, adapter->tx_ltb_size,
-			 DMA_TO_DEVICE);
-	kfree(adapter->tx_ltb_ptr);
+	for (i = 0; i < IBMVETH_MAX_QUEUES; i++) {
+		dma_unmap_single(dev, adapter->tx_ltb_dma[i],
+				 adapter->tx_ltb_size, DMA_TO_DEVICE);
+		kfree(adapter->tx_ltb_ptr[i]);
+	}
 
 	netdev_dbg(netdev, "close complete\n");
 
@@ -1027,15 +1038,13 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 				      struct net_device *netdev)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
-	unsigned int desc_flags;
+	unsigned int desc_flags, total_bytes;
 	union ibmveth_buf_desc desc;
-	int i;
+	int i, queue_num = skb_get_queue_mapping(skb);
 	unsigned long mss = 0;
-	size_t total_bytes;
 
 	if (ibmveth_is_packet_unsupported(skb, netdev))
 		goto out;
-
 	/* veth can't checksum offload UDP */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    ((skb->protocol == htons(ETH_P_IP) &&
@@ -1088,14 +1097,14 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 		netdev->stats.tx_dropped++;
 		goto out;
 	}
-	memcpy(adapter->tx_ltb_ptr, skb->data, skb_headlen(skb));
+	memcpy(adapter->tx_ltb_ptr[queue_num], skb->data, skb_headlen(skb));
 	total_bytes = skb_headlen(skb);
 	/* Copy frags into mapped buffers */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		memcpy(adapter->tx_ltb_ptr + total_bytes, skb_frag_address_safe(frag),
-		       skb_frag_size(frag));
+		memcpy(adapter->tx_ltb_ptr[queue_num] + total_bytes,
+		       skb_frag_address_safe(frag), skb_frag_size(frag));
 		total_bytes += skb_frag_size(frag);
 	}
 
@@ -1106,7 +1115,7 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 		goto out;
 	}
 	desc.fields.flags_len = desc_flags | skb->len;
-	desc.fields.address = adapter->tx_ltb_dma;
+	desc.fields.address = adapter->tx_ltb_dma[queue_num];
 	/* finish writing to long_term_buff before VIOS accessing it */
 	dma_wmb();
 
@@ -1599,7 +1608,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		return -EINVAL;
 	}
 
-	netdev = alloc_etherdev(sizeof(struct ibmveth_adapter));
+	netdev = alloc_etherdev_mqs(sizeof(struct ibmveth_adapter), IBMVETH_MAX_QUEUES, 1);
 
 	if (!netdev)
 		return -ENOMEM;
@@ -1666,6 +1675,8 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			kobject_uevent(kobj, KOBJ_ADD);
 	}
 
+	adapter->tx_ltb_size = PAGE_ALIGN(IBMVETH_MAX_TX_BUF_SIZE);
+
 	netdev_dbg(netdev, "adapter @ 0x%p\n", adapter);
 	netdev_dbg(netdev, "registering netdev...\n");
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index a46ead9b31de..7f058a551577 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -99,6 +99,7 @@ static inline long h_illan_attributes(unsigned long unit_address,
 #define IBMVETH_FILT_LIST_SIZE 4096
 #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
 #define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
+#define IBMVETH_MAX_QUEUES 8
 
 static int pool_size[] = { 512, 1024 * 2, 1024 * 16, 1024 * 32, 1024 * 64 };
 static int pool_count[] = { 256, 512, 256, 256, 256 };
@@ -138,9 +139,9 @@ struct ibmveth_adapter {
     unsigned int mcastFilterSize;
     void * buffer_list_addr;
     void * filter_list_addr;
-    void *tx_ltb_ptr;
+    void *tx_ltb_ptr[IBMVETH_MAX_QUEUES];
     unsigned int tx_ltb_size;
-    dma_addr_t tx_ltb_dma;
+    dma_addr_t tx_ltb_dma[IBMVETH_MAX_QUEUES];
     dma_addr_t buffer_list_dma;
     dma_addr_t filter_list_dma;
     struct ibmveth_buff_pool rx_buff_pool[IBMVETH_NUM_BUFF_POOLS];
-- 
2.31.1

