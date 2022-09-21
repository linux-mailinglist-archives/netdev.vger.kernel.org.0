Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663EF5E557E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIUVv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiIUVvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:51:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE02A1D13
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:51:22 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LLmaoK028535
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Mb0yS5DJzRyi1CRfxX995gb+qo0ogTyV4nocK/L8zDQ=;
 b=rr9XF4HkFxjNQbzBXH9IlvUht9fGjy6S3ON2+yVjpzhYh7YOolIUTvfQ70pJHSLqtuFQ
 BYZWBIhHUV/pcesOOe6Sp8YRoUliOUNVE7hLa1P92jPIenQLhiQdm0QkS4Kmgk16AZPp
 l81ZlOuKC+PKj4SpAqK7oPeQ7oC4NlUiJqReE3swhlK92lU6oxVNaAnMyG7CKnVaPdeq
 z1pudsN6xE4si6vxjmkEw2f/+4wflCCIP3VBxCqk+l/QAYgUiqxH0bAkQN2Vqn+8qryp
 n5lnrH7DfsLIXF1wWEEB+idbj9Wiq3FaHSuZwwjJjLmEUJVeRC4yx1ZclBGtfzUsPzdc 9g== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jrauv8209-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:22 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28LLoBHU011724
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:21 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 3jn5v9mhcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 21:51:21 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28LLpJmS1835644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 21:51:20 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BF735805B;
        Wed, 21 Sep 2022 21:51:19 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E17858066;
        Wed, 21 Sep 2022 21:51:18 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.65.226.154])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Sep 2022 21:51:17 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next 3/3] ibmveth: Ethtool set queue support
Date:   Wed, 21 Sep 2022 16:50:56 -0500
Message-Id: <20220921215056.113516-3-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220921215056.113516-1-nnac123@linux.ibm.com>
References: <20220921215056.113516-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RXj28yoZsCXIACr8-dG3PSFNMA922rv_
X-Proofpoint-GUID: RXj28yoZsCXIACr8-dG3PSFNMA922rv_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_11,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210144
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
 drivers/net/ethernet/ibm/ibmveth.c | 168 ++++++++++++++++++++++++-----
 drivers/net/ethernet/ibm/ibmveth.h |   2 +-
 2 files changed, 140 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7abd67c2336e..2c5ded4f3b67 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -141,6 +141,13 @@ static inline int ibmveth_rxq_csum_good(struct ibmveth_adapter *adapter)
 	return ibmveth_rxq_flags(adapter) & IBMVETH_RXQ_CSUM_GOOD;
 }
 
+static unsigned int ibmveth_real_max_tx_queues(void)
+{
+	unsigned int n_cpu =  num_online_cpus();
+
+	return n_cpu > IBMVETH_MAX_QUEUES ? IBMVETH_MAX_QUEUES : n_cpu;
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
 
@@ -974,6 +992,88 @@ static void ibmveth_get_ethtool_stats(struct net_device *dev,
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
+
+	channels->max_other = 0;
+	channels->other_count = 0;
+	channels->max_combined = 0;
+	channels->combined_count = 0;
+}
+
+static int ibmveth_set_channels(struct net_device *netdev,
+				struct ethtool_channels *channels)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(netdev);
+	int rc, rc2, i;
+	unsigned int fallback_num, goal;
+
+	/* Higher levels will catch basic input errors */
+	if (channels->tx_count > ibmveth_real_max_tx_queues())
+		return -EINVAL;
+
+	if (channels->tx_count == netdev->real_num_tx_queues)
+		return 0;
+
+	/* We have IBMVETH_MAX_QUEUES netdev_queue's allocated
+	 * but we may need to alloc/free the ltb's.
+	 */
+	netif_tx_stop_all_queues(netdev);
+	fallback_num = netdev->real_num_tx_queues;
+	goal = channels->tx_count;
+
+setup_tx_queues:
+	/* Allocate any queue that we need */
+	for (i = 0; i < goal; i++) {
+		if (adapter->tx_ltb_ptr[i])
+			continue;
+
+		rc = ibmveth_allocate_tx_ltb(adapter, i);
+		if (!rc)
+			continue;
+
+		if (goal == fallback_num)
+			goto full_restart;
+
+		netdev_err(netdev, "Failed to allocate more tx queues, returning to %d queues\n",
+			   fallback_num);
+		goal = fallback_num;
+		goto setup_tx_queues;
+	}
+	/* Free any that are no longer needed */
+	for (; i < fallback_num; i++) {
+		if (adapter->tx_ltb_ptr[i])
+			ibmveth_free_tx_ltb(adapter, i);
+	}
+
+	rc = netif_set_real_num_tx_queues(netdev, goal);
+	if (rc) {
+		if (goal == fallback_num)
+			goto full_restart;
+		netdev_err(netdev, "Failed to set real tx queues, returning to %d queues\n",
+			   fallback_num);
+		goal = fallback_num;
+		goto setup_tx_queues;
+	}
+
+	netif_tx_wake_all_queues(netdev);
+	return rc;
+
+full_restart:
+	netdev_err(netdev, "Failed to fallback to old number of queues, restarting\n");
+	ibmveth_close(netdev);
+	rc2 = ibmveth_open(netdev);
+	if (rc2)
+		return rc2;
+	return rc;
+}
+
 static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_drvinfo		         = netdev_get_drvinfo,
 	.get_link		         = ethtool_op_get_link,
@@ -982,6 +1082,8 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_ethtool_stats	         = ibmveth_get_ethtool_stats,
 	.get_link_ksettings	         = ibmveth_get_link_ksettings,
 	.set_link_ksettings              = ibmveth_set_link_ksettings,
+	.get_channels			 = ibmveth_get_channels,
+	.set_channels			 = ibmveth_set_channels
 };
 
 static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -1609,7 +1711,6 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 
 	netdev = alloc_etherdev_mqs(sizeof(struct ibmveth_adapter), IBMVETH_MAX_QUEUES, 1);
-
 	if (!netdev)
 		return -ENOMEM;
 
@@ -1675,7 +1776,16 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
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
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 7f058a551577..610d7a8be28a 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -99,7 +99,7 @@ static inline long h_illan_attributes(unsigned long unit_address,
 #define IBMVETH_FILT_LIST_SIZE 4096
 #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
 #define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
-#define IBMVETH_MAX_QUEUES 8
+#define IBMVETH_MAX_QUEUES 16
 
 static int pool_size[] = { 512, 1024 * 2, 1024 * 16, 1024 * 32, 1024 * 64 };
 static int pool_count[] = { 256, 512, 256, 256, 256 };
-- 
2.31.1

