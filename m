Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2105E5579
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiIUVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiIUVvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:51:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CF49A9D4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:51:14 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LLAtgo017759
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oPphEQugotftpLAt8f1Ok+68D/6R+6Ih51OyQjDc1HY=;
 b=KGTS0QoZPZWbIZQWJlf/DhfnSB+PrKDXcDzg3Gnpy3DbuZ4+zAoCr0SA2yW7mH5c0xwp
 2zcbW3cyR/w3fKzhLqOojPfGcokMtGQAUG4BZuyGRW1vGUTS62U/qxkVnJduxKkfb97B
 aTPkwxJFDSupy47e4i9/QGXCXUAP6ptzuya8oh9CzSevuBy5rxkN8jULR9pqwzzBMfkH
 7ptGGqb/swh3J5R3sk3iw8Jhr9NrXlm0efUs7CMYfEipjn1ZfvbXTB1b7HcbWsGaASBY
 tJQfCCN1OFF7nGOHEA5CM59mYiFTzyff+bUthSFhxp+nQlcjG7V7gRb9D4f9Pb0W2AYw RQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jr99c2p13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:13 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28LLowIl009928
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:12 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3jn5v9mhn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:12 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28LLpBR010617362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 21:51:11 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 433935804B;
        Wed, 21 Sep 2022 21:51:11 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5FBF5805B;
        Wed, 21 Sep 2022 21:51:09 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.65.226.154])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Sep 2022 21:51:09 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next 1/3] ibmveth: Copy tx skbs into a premapped buffer
Date:   Wed, 21 Sep 2022 16:50:54 -0500
Message-Id: <20220921215056.113516-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yP1ieJwG7_3ZJSVECx8Gem2VdFGo5GzH
X-Proofpoint-GUID: yP1ieJwG7_3ZJSVECx8Gem2VdFGo5GzH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_11,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 impostorscore=0
 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209210144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than DMA mapping and unmapping every outgoing skb, copy the skb
into a buffer that was mapped during the drivers open function. Copying
the skb and its frags have proven to be more time efficient than
mapping and unmapping. As an effect, performance increases by 3-5
Gbits/s.

Allocate and DMA map one continuous 64KB buffer at `ndo_open`. This
buffer is maintained until `ibmveth_close` is called. This buffer is
large enough to hold the largest possible linnear skb. During
`ndo_start_xmit`, copy the skb and all of it's frags into the continuous
buffer. By manually linnearizing all the socket buffers, time is saved
during memcpy as well as allowing more efficient handling in FW.
As a result, we no longer need to worry about the firmware limitation
of handling a max of 6 frags. So, we only need to maintain one descriptor
instead of six and can hardcode zero for the other five descriptors
during h_send_logical_lan.

Since, DMA allocation/mapping issues can no longer arise in xmit
functions, we further reduce code size by removing the need for a
bounce buffer on DMA errors.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 185 ++++++++++-------------------
 drivers/net/ethernet/ibm/ibmveth.h |  22 ++--
 2 files changed, 74 insertions(+), 133 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index ee4548e08446..675eaeed7a7b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -538,6 +538,22 @@ static int ibmveth_open(struct net_device *netdev)
 		goto out_unmap_buffer_list;
 	}
 
+	adapter->tx_ltb_size = PAGE_ALIGN(IBMVETH_MAX_TX_BUF_SIZE);
+	adapter->tx_ltb_ptr = kzalloc(adapter->tx_ltb_size, GFP_KERNEL);
+	if (!adapter->tx_ltb_ptr) {
+		netdev_err(netdev,
+			   "unable to allocate transmit long term buffer\n");
+		goto out_unmap_buffer_list;
+	}
+	adapter->tx_ltb_dma = dma_map_single(dev, adapter->tx_ltb_ptr,
+					     adapter->tx_ltb_size,
+					     DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, adapter->tx_ltb_dma)) {
+		netdev_err(netdev,
+			   "unable to DMA map transmit long term buffer\n");
+		goto out_unmap_tx_dma;
+	}
+
 	adapter->rx_queue.index = 0;
 	adapter->rx_queue.num_slots = rxq_entries;
 	adapter->rx_queue.toggle = 1;
@@ -595,14 +611,6 @@ static int ibmveth_open(struct net_device *netdev)
 
 	rc = -ENOMEM;
 
-	adapter->bounce_buffer = dma_alloc_coherent(&adapter->vdev->dev,
-						    netdev->mtu + IBMVETH_BUFF_OH,
-						    &adapter->bounce_buffer_dma, GFP_KERNEL);
-	if (!adapter->bounce_buffer) {
-		netdev_err(netdev, "unable to alloc bounce buffer\n");
-		goto out_free_irq;
-	}
-
 	netdev_dbg(netdev, "initial replenish cycle\n");
 	ibmveth_interrupt(netdev->irq, netdev);
 
@@ -612,8 +620,6 @@ static int ibmveth_open(struct net_device *netdev)
 
 	return 0;
 
-out_free_irq:
-	free_irq(netdev->irq, netdev);
 out_free_buffer_pools:
 	while (--i >= 0) {
 		if (adapter->rx_buff_pool[i].active)
@@ -623,6 +629,10 @@ static int ibmveth_open(struct net_device *netdev)
 out_unmap_filter_list:
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
+
+out_unmap_tx_dma:
+	kfree(adapter->tx_ltb_ptr);
+
 out_unmap_buffer_list:
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
@@ -685,9 +695,9 @@ static int ibmveth_close(struct net_device *netdev)
 			ibmveth_free_buffer_pool(adapter,
 						 &adapter->rx_buff_pool[i]);
 
-	dma_free_coherent(&adapter->vdev->dev,
-			  adapter->netdev->mtu + IBMVETH_BUFF_OH,
-			  adapter->bounce_buffer, adapter->bounce_buffer_dma);
+	dma_unmap_single(dev, adapter->tx_ltb_dma, adapter->tx_ltb_size,
+			 DMA_TO_DEVICE);
+	kfree(adapter->tx_ltb_ptr);
 
 	netdev_dbg(netdev, "close complete\n");
 
@@ -969,7 +979,7 @@ static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 
 static int ibmveth_send(struct ibmveth_adapter *adapter,
-			union ibmveth_buf_desc *descs, unsigned long mss)
+			unsigned long desc, unsigned long mss)
 {
 	unsigned long correlator;
 	unsigned int retry_count;
@@ -982,12 +992,9 @@ static int ibmveth_send(struct ibmveth_adapter *adapter,
 	retry_count = 1024;
 	correlator = 0;
 	do {
-		ret = h_send_logical_lan(adapter->vdev->unit_address,
-					     descs[0].desc, descs[1].desc,
-					     descs[2].desc, descs[3].desc,
-					     descs[4].desc, descs[5].desc,
-					     correlator, &correlator, mss,
-					     adapter->fw_large_send_support);
+		ret = h_send_logical_lan(adapter->vdev->unit_address, desc,
+					 correlator, &correlator, mss,
+					 adapter->fw_large_send_support);
 	} while ((ret == H_BUSY) && (retry_count--));
 
 	if (ret != H_SUCCESS && ret != H_DROPPED) {
@@ -1021,33 +1028,14 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 {
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
 	unsigned int desc_flags;
-	union ibmveth_buf_desc descs[6];
-	int last, i;
-	int force_bounce = 0;
-	dma_addr_t dma_addr;
+	union ibmveth_buf_desc desc;
+	int i;
 	unsigned long mss = 0;
+	size_t total_bytes;
 
 	if (ibmveth_is_packet_unsupported(skb, netdev))
 		goto out;
 
-	/* veth doesn't handle frag_list, so linearize the skb.
-	 * When GRO is enabled SKB's can have frag_list.
-	 */
-	if (adapter->is_active_trunk &&
-	    skb_has_frag_list(skb) && __skb_linearize(skb)) {
-		netdev->stats.tx_dropped++;
-		goto out;
-	}
-
-	/*
-	 * veth handles a maximum of 6 segments including the header, so
-	 * we have to linearize the skb if there are more than this.
-	 */
-	if (skb_shinfo(skb)->nr_frags > 5 && __skb_linearize(skb)) {
-		netdev->stats.tx_dropped++;
-		goto out;
-	}
-
 	/* veth can't checksum offload UDP */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    ((skb->protocol == htons(ETH_P_IP) &&
@@ -1077,56 +1065,6 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 			desc_flags |= IBMVETH_BUF_LRG_SND;
 	}
 
-retry_bounce:
-	memset(descs, 0, sizeof(descs));
-
-	/*
-	 * If a linear packet is below the rx threshold then
-	 * copy it into the static bounce buffer. This avoids the
-	 * cost of a TCE insert and remove.
-	 */
-	if (force_bounce || (!skb_is_nonlinear(skb) &&
-				(skb->len < tx_copybreak))) {
-		skb_copy_from_linear_data(skb, adapter->bounce_buffer,
-					  skb->len);
-
-		descs[0].fields.flags_len = desc_flags | skb->len;
-		descs[0].fields.address = adapter->bounce_buffer_dma;
-
-		if (ibmveth_send(adapter, descs, 0)) {
-			adapter->tx_send_failed++;
-			netdev->stats.tx_dropped++;
-		} else {
-			netdev->stats.tx_packets++;
-			netdev->stats.tx_bytes += skb->len;
-		}
-
-		goto out;
-	}
-
-	/* Map the header */
-	dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
-				  skb_headlen(skb), DMA_TO_DEVICE);
-	if (dma_mapping_error(&adapter->vdev->dev, dma_addr))
-		goto map_failed;
-
-	descs[0].fields.flags_len = desc_flags | skb_headlen(skb);
-	descs[0].fields.address = dma_addr;
-
-	/* Map the frags */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-
-		dma_addr = skb_frag_dma_map(&adapter->vdev->dev, frag, 0,
-					    skb_frag_size(frag), DMA_TO_DEVICE);
-
-		if (dma_mapping_error(&adapter->vdev->dev, dma_addr))
-			goto map_failed_frags;
-
-		descs[i+1].fields.flags_len = desc_flags | skb_frag_size(frag);
-		descs[i+1].fields.address = dma_addr;
-	}
-
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_is_gso(skb)) {
 		if (adapter->fw_large_send_support) {
 			mss = (unsigned long)skb_shinfo(skb)->gso_size;
@@ -1143,7 +1081,36 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 		}
 	}
 
-	if (ibmveth_send(adapter, descs, mss)) {
+	/* Copy header into mapped buffer */
+	if (unlikely(skb->len > adapter->tx_ltb_size)) {
+		netdev_err(adapter->netdev, "tx: packet size (%u) exceeds ltb (%u)\n",
+			   skb->len, adapter->tx_ltb_size);
+		netdev->stats.tx_dropped++;
+		goto out;
+	}
+	memcpy(adapter->tx_ltb_ptr, skb->data, skb_headlen(skb));
+	total_bytes = skb_headlen(skb);
+	/* Copy frags into mapped buffers */
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+		memcpy(adapter->tx_ltb_ptr + total_bytes, skb_frag_address_safe(frag),
+		       skb_frag_size(frag));
+		total_bytes += skb_frag_size(frag);
+	}
+
+	if (unlikely(total_bytes != skb->len)) {
+		netdev_err(adapter->netdev, "tx: incorrect packet len copied into ltb (%u != %u)\n",
+			   skb->len, total_bytes);
+		netdev->stats.tx_dropped++;
+		goto out;
+	}
+	desc.fields.flags_len = desc_flags | skb->len;
+	desc.fields.address = adapter->tx_ltb_dma;
+	/* finish writing to long_term_buff before VIOS accessing it */
+	dma_wmb();
+
+	if (ibmveth_send(adapter, desc.desc, mss)) {
 		adapter->tx_send_failed++;
 		netdev->stats.tx_dropped++;
 	} else {
@@ -1151,41 +1118,11 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 		netdev->stats.tx_bytes += skb->len;
 	}
 
-	dma_unmap_single(&adapter->vdev->dev,
-			 descs[0].fields.address,
-			 descs[0].fields.flags_len & IBMVETH_BUF_LEN_MASK,
-			 DMA_TO_DEVICE);
-
-	for (i = 1; i < skb_shinfo(skb)->nr_frags + 1; i++)
-		dma_unmap_page(&adapter->vdev->dev, descs[i].fields.address,
-			       descs[i].fields.flags_len & IBMVETH_BUF_LEN_MASK,
-			       DMA_TO_DEVICE);
-
 out:
 	dev_consume_skb_any(skb);
 	return NETDEV_TX_OK;
 
-map_failed_frags:
-	last = i+1;
-	for (i = 1; i < last; i++)
-		dma_unmap_page(&adapter->vdev->dev, descs[i].fields.address,
-			       descs[i].fields.flags_len & IBMVETH_BUF_LEN_MASK,
-			       DMA_TO_DEVICE);
 
-	dma_unmap_single(&adapter->vdev->dev,
-			 descs[0].fields.address,
-			 descs[0].fields.flags_len & IBMVETH_BUF_LEN_MASK,
-			 DMA_TO_DEVICE);
-map_failed:
-	if (!firmware_has_feature(FW_FEATURE_CMO))
-		netdev_err(netdev, "tx: unable to map xmit buffer\n");
-	adapter->tx_map_failed++;
-	if (skb_linearize(skb)) {
-		netdev->stats.tx_dropped++;
-		goto out;
-	}
-	force_bounce = 1;
-	goto retry_bounce;
 }
 
 static void ibmveth_rx_mss_helper(struct sk_buff *skb, u16 mss, int lrg_pkt)
@@ -1568,6 +1505,8 @@ static unsigned long ibmveth_get_desired_dma(struct vio_dev *vdev)
 
 	ret = IBMVETH_BUFF_LIST_SIZE + IBMVETH_FILT_LIST_SIZE;
 	ret += IOMMU_PAGE_ALIGN(netdev->mtu, tbl);
+	/* add size of mapped tx buffers */
+	ret += IOMMU_PAGE_ALIGN(IBMVETH_MAX_TX_BUF_SIZE, tbl);
 
 	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++) {
 		/* add the size of the active receive buffers */
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 27dfff200166..a46ead9b31de 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -46,23 +46,23 @@
 #define h_add_logical_lan_buffer(ua, buf) \
   plpar_hcall_norets(H_ADD_LOGICAL_LAN_BUFFER, ua, buf)
 
+/* FW allows us to send 6 descriptors but we only use one so mark
+ * the other 5 as unused (0)
+ */
 static inline long h_send_logical_lan(unsigned long unit_address,
-		unsigned long desc1, unsigned long desc2, unsigned long desc3,
-		unsigned long desc4, unsigned long desc5, unsigned long desc6,
-		unsigned long corellator_in, unsigned long *corellator_out,
-		unsigned long mss, unsigned long large_send_support)
+		unsigned long desc, unsigned long corellator_in,
+		unsigned long *corellator_out, unsigned long mss,
+		unsigned long large_send_support)
 {
 	long rc;
 	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
 
 	if (large_send_support)
 		rc = plpar_hcall9(H_SEND_LOGICAL_LAN, retbuf, unit_address,
-				  desc1, desc2, desc3, desc4, desc5, desc6,
-				  corellator_in, mss);
+				  desc, 0, 0, 0, 0, 0, corellator_in, mss);
 	else
 		rc = plpar_hcall9(H_SEND_LOGICAL_LAN, retbuf, unit_address,
-				  desc1, desc2, desc3, desc4, desc5, desc6,
-				  corellator_in);
+				  desc, 0, 0, 0, 0, 0, corellator_in);
 
 	*corellator_out = retbuf[0];
 
@@ -98,6 +98,7 @@ static inline long h_illan_attributes(unsigned long unit_address,
 #define IBMVETH_BUFF_LIST_SIZE 4096
 #define IBMVETH_FILT_LIST_SIZE 4096
 #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
+#define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
 
 static int pool_size[] = { 512, 1024 * 2, 1024 * 16, 1024 * 32, 1024 * 64 };
 static int pool_count[] = { 256, 512, 256, 256, 256 };
@@ -137,6 +138,9 @@ struct ibmveth_adapter {
     unsigned int mcastFilterSize;
     void * buffer_list_addr;
     void * filter_list_addr;
+    void *tx_ltb_ptr;
+    unsigned int tx_ltb_size;
+    dma_addr_t tx_ltb_dma;
     dma_addr_t buffer_list_dma;
     dma_addr_t filter_list_dma;
     struct ibmveth_buff_pool rx_buff_pool[IBMVETH_NUM_BUFF_POOLS];
@@ -145,8 +149,6 @@ struct ibmveth_adapter {
     int rx_csum;
     int large_send;
     bool is_active_trunk;
-    void *bounce_buffer;
-    dma_addr_t bounce_buffer_dma;
 
     u64 fw_ipv6_csum_support;
     u64 fw_ipv4_csum_support;
-- 
2.31.1

