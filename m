Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C825EE884
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiI1VoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiI1VoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:44:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F348FB2844
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:44:01 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SJ9tef028340
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 21:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7FqekyaxzjNT3SIUNeryuu2nYaJ7Zp8ReQbfBeyGaxE=;
 b=Lqk+5KZYHUGySdc54bWeaY5dg5u7lBb2oiCWpVBWVVZ80KHITZ0NyaDxfAephZK7UCzd
 KrHaaRqPD7Gd4s/JBIvokKAqmCF/hBZyGVgaaWKeEBh0bJS3IjbtgTKmg/Sxy82oM/7g
 /Wfk7BhbZhjsW8bC62XdXAePbMrtKsEdJ4Jujk0SUrsTFxQ0roOp2HBlbpf18fquZxsB
 svQ3kZs3FYe9eCm6iI7UHSbAcXlGlQEXwE8ziLfPxfBRpbZ6/oMQ5FHYwib5B6TS7u2G
 JPuHRcZqEb7bRcacP9mXvBgBNuxx5RV53QR/wudNTGYv9rVcQPcDvkZ1hX6SePxgLD4+ Vg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvqhhx3sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 21:44:01 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SLZP2n026681
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 21:44:00 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3jsshan1ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 21:44:00 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SLhxR610027524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 21:43:59 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D804F5805B;
        Wed, 28 Sep 2022 21:43:58 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AFB658065;
        Wed, 28 Sep 2022 21:43:58 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.14.153])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 21:43:58 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH v2 net-next 3/3] ibmveth: Ethtool set queue support
Date:   Wed, 28 Sep 2022 16:43:50 -0500
Message-Id: <20220928214350.29795-3-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220928214350.29795-1-nnac123@linux.ibm.com>
References: <20220928214350.29795-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qw2NkPLt9ZvgAB5qK8K-ye9IpmlKgfP8
X-Proofpoint-ORIG-GUID: Qw2NkPLt9ZvgAB5qK8K-ye9IpmlKgfP8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_09,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement channel management functions to allow dynamic addition and
removal of transmit queues. The `ethtool --show-channels` and
`ethtool --set-channels` commands can be used to get and set the
number of queues, respectively. Allow the ability to add as many
transmit queues as available processors but never allow more than the
hard maximum of 16. The number of receive queues is one and cannot be
modified.

Depending on whether the requested number of queues is larger or
smaller than the current value, either allocate or free long term
buffers. Since long term buffer construction and destruction can
occur in two different areas, from either channel set requests or
device open/close, define functions for performing this work. If
allocation of a new buffer fails, then attempt to revert back to the
previous number of queues.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 149 +++++++++++++++++++++++------
 1 file changed, 120 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7abd67c2336e..3b14dc93f59d 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -141,6 +141,13 @@ static inline int ibmveth_rxq_csum_good(struct ibmveth_adapter *adapter)
 	return ibmveth_rxq_flags(adapter) & IBMVETH_RXQ_CSUM_GOOD;
 }
 
+static unsigned int ibmveth_real_max_tx_queues(void)
+{
+	unsigned int n_cpu = num_online_cpus();
+
+	return min(n_cpu, IBMVETH_MAX_QUEUES);
+}
+
 /* setup the initial settings for a buffer pool */
 static void ibmveth_init_buffer_pool(struct ibmveth_buff_pool *pool,
 				     u32 pool_index, u32 pool_size,
@@ -456,6 +463,38 @@ static void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter)
 	}
 }
 
+static void ibmveth_free_tx_ltb(struct ibmveth_adapter *adapter, int idx)
+{
+	dma_unmap_single(&adapter->vdev->dev, adapter->tx_ltb_dma[idx],
+			 adapter->tx_ltb_size, DMA_TO_DEVICE);
+	kfree(adapter->tx_ltb_ptr[idx]);
+	adapter->tx_ltb_ptr[idx] = NULL;
+}
+
+static int ibmveth_allocate_tx_ltb(struct ibmveth_adapter *adapter, int idx)
+{
+	adapter->tx_ltb_ptr[idx] = kzalloc(adapter->tx_ltb_size,
+					   GFP_KERNEL);
+	if (!adapter->tx_ltb_ptr[idx]) {
+		netdev_err(adapter->netdev,
+			   "unable to allocate tx long term buffer\n");
+		return -ENOMEM;
+	}
+	adapter->tx_ltb_dma[idx] = dma_map_single(&adapter->vdev->dev,
+						  adapter->tx_ltb_ptr[idx],
+						  adapter->tx_ltb_size,
+						  DMA_TO_DEVICE);
+	if (dma_mapping_error(&adapter->vdev->dev, adapter->tx_ltb_dma[idx])) {
+		netdev_err(adapter->netdev,
+			   "unable to DMA map tx long term buffer\n");
+		kfree(adapter->tx_ltb_ptr[idx]);
+		adapter->tx_ltb_ptr[idx] = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int ibmveth_register_logical_lan(struct ibmveth_adapter *adapter,
         union ibmveth_buf_desc rxq_desc, u64 mac_address)
 {
@@ -538,22 +577,9 @@ static int ibmveth_open(struct net_device *netdev)
 		goto out_unmap_buffer_list;
 	}
 
-	for (i = 0; i < IBMVETH_MAX_QUEUES; i++) {
-		adapter->tx_ltb_ptr[i] = kzalloc(adapter->tx_ltb_size,
-						 GFP_KERNEL);
-		if (!adapter->tx_ltb_ptr[i]) {
-			netdev_err(netdev,
-				   "unable to allocate transmit long term buffer\n");
-			goto out_free_tx_ltb_ptrs;
-		}
-		adapter->tx_ltb_dma[i] = dma_map_single(dev,
-							adapter->tx_ltb_ptr[i],
-							adapter->tx_ltb_size,
-							DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, adapter->tx_ltb_dma[i])) {
-			netdev_err(netdev, "unable to DMA map transmit long term buffer\n");
-			goto out_unmap_tx_dma;
-		}
+	for (i = 0; i < netdev->real_num_tx_queues; i++) {
+		if (ibmveth_allocate_tx_ltb(adapter, i))
+			goto out_free_tx_ltb;
 	}
 
 	adapter->rx_queue.index = 0;
@@ -632,14 +658,9 @@ static int ibmveth_open(struct net_device *netdev)
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
 
-out_unmap_tx_dma:
-	kfree(adapter->tx_ltb_ptr[i]);
-
-out_free_tx_ltb_ptrs:
+out_free_tx_ltb:
 	while (--i >= 0) {
-		dma_unmap_single(dev, adapter->tx_ltb_dma[i],
-				 adapter->tx_ltb_size, DMA_TO_DEVICE);
-		kfree(adapter->tx_ltb_ptr[i]);
+		ibmveth_free_tx_ltb(adapter, i);
 	}
 
 out_unmap_buffer_list:
@@ -704,11 +725,8 @@ static int ibmveth_close(struct net_device *netdev)
 			ibmveth_free_buffer_pool(adapter,
 						 &adapter->rx_buff_pool[i]);
 
-	for (i = 0; i < IBMVETH_MAX_QUEUES; i++) {
-		dma_unmap_single(dev, adapter->tx_ltb_dma[i],
-				 adapter->tx_ltb_size, DMA_TO_DEVICE);
-		kfree(adapter->tx_ltb_ptr[i]);
-	}
+	for (i = 0; i < netdev->real_num_tx_queues; i++)
+		ibmveth_free_tx_ltb(adapter, i);
 
 	netdev_dbg(netdev, "close complete\n");
 
@@ -974,6 +992,69 @@ static void ibmveth_get_ethtool_stats(struct net_device *dev,
 		data[i] = IBMVETH_GET_STAT(adapter, ibmveth_stats[i].offset);
 }
 
+static void ibmveth_get_channels(struct net_device *netdev,
+				 struct ethtool_channels *channels)
+{
+	channels->max_tx = ibmveth_real_max_tx_queues();
+	channels->tx_count = netdev->real_num_tx_queues;
+
+	channels->max_rx = netdev->real_num_rx_queues;
+	channels->rx_count = netdev->real_num_rx_queues;
+}
+
+static int ibmveth_set_channels(struct net_device *netdev,
+				struct ethtool_channels *channels)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(netdev);
+	unsigned int old = netdev->real_num_tx_queues,
+		     goal = channels->tx_count;
+	int rc, i;
+
+	/* If ndo_open has not been called yet then don't allocate, just set
+	 * desired netdev_queue's and return
+	 */
+	if (!(netdev->flags & IFF_UP))
+		return netif_set_real_num_tx_queues(netdev, goal);
+
+	/* We have IBMVETH_MAX_QUEUES netdev_queue's allocated
+	 * but we may need to alloc/free the ltb's.
+	 */
+	netif_tx_stop_all_queues(netdev);
+
+	/* Allocate any queue that we need */
+	for (i = old; i < goal; i++) {
+		if (adapter->tx_ltb_ptr[i])
+			continue;
+
+		rc = ibmveth_allocate_tx_ltb(adapter, i);
+		if (!rc)
+			continue;
+
+		/* if something goes wrong, free everything we just allocated */
+		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
+			   old);
+		goal = old;
+		old = i;
+		break;
+	}
+	rc = netif_set_real_num_tx_queues(netdev, goal);
+	if (rc) {
+		netdev_err(netdev, "Failed to set real tx queues, returning to %d queues\n",
+			   old);
+		goal = old;
+		old = i;
+	}
+	/* Free any that are no longer needed */
+	for (i = old; i > goal; i--) {
+		if (adapter->tx_ltb_ptr[i - 1])
+			ibmveth_free_tx_ltb(adapter, i - 1);
+	}
+
+	netif_tx_wake_all_queues(netdev);
+
+	return rc;
+}
+
 static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_drvinfo		         = netdev_get_drvinfo,
 	.get_link		         = ethtool_op_get_link,
@@ -982,6 +1063,8 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_ethtool_stats	         = ibmveth_get_ethtool_stats,
 	.get_link_ksettings	         = ibmveth_get_link_ksettings,
 	.set_link_ksettings              = ibmveth_set_link_ksettings,
+	.get_channels			 = ibmveth_get_channels,
+	.set_channels			 = ibmveth_set_channels
 };
 
 static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -1609,7 +1692,6 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 
 	netdev = alloc_etherdev_mqs(sizeof(struct ibmveth_adapter), IBMVETH_MAX_QUEUES, 1);
-
 	if (!netdev)
 		return -ENOMEM;
 
@@ -1675,7 +1757,16 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			kobject_uevent(kobj, KOBJ_ADD);
 	}
 
+	rc = netif_set_real_num_tx_queues(netdev, ibmveth_real_max_tx_queues());
+	if (rc) {
+		netdev_dbg(netdev, "failed to set number of tx queues rc=%d\n",
+			   rc);
+		free_netdev(netdev);
+		return rc;
+	}
 	adapter->tx_ltb_size = PAGE_ALIGN(IBMVETH_MAX_TX_BUF_SIZE);
+	for (i = 0; i < IBMVETH_MAX_QUEUES; i++)
+		adapter->tx_ltb_ptr[i] = NULL;
 
 	netdev_dbg(netdev, "adapter @ 0x%p\n", adapter);
 	netdev_dbg(netdev, "registering netdev...\n");
-- 
2.31.1

