Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E84624A5C5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHSSQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:16:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60252 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHSSQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:16:45 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JI3JSi189163
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 14:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=P1GCC/FtraPe6P8kgfJZohiVVhLAXMr8E4XHfhsFUbY=;
 b=qn7Tb2ONHgHzLT5cYKH9+A61PIxETUex5BJkg+vC8sPsjr7ZlKOB3TRxxzuFXUDm+VuG
 siVyhfHjQNFhG5CJadAWBthuy+eD0XoTnWEqyn/E/dLWzgdUUVpxect76hWEC8dJ7gcT
 U8YSYshSD7ViqbHK6xfEZfUDUawG4Das4NIqBz2dMX+KDdZjYkFKbNGl1NiScrQ1eyOe
 CC+OH9AwJFwxO7KezV3HlvQy+FtF9StUTuPpgigAVYhERqG03KvGxNCkeGTZGGhwjVkC
 s3wX1KoEdRk/Upy1m6wUWfBkpPHm6OXJhJBh0E/6Q4/AIR1ArlbPPx7vMXHMihHfOfqh mg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r4rtvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 14:16:44 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JIAlL6004408
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 18:16:31 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 3304tknw6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 18:16:31 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JIGVOT53870994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 18:16:31 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB4CAC05B;
        Wed, 19 Aug 2020 18:16:31 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97620AC059;
        Wed, 19 Aug 2020 18:16:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.211.59.12])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 18:16:30 +0000 (GMT)
From:   Cristobal Forno <cforno12@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, Cristobal Forno <cforno12@linux.ibm.com>
Subject: [PATCH, net-next, v3] ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct
Date:   Wed, 19 Aug 2020 13:16:23 -0500
Message-Id: <20200819181623.57821-1-cforno12@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_11:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 priorityscore=1501 suspectscore=3 mlxlogscore=729 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the driver reads RX and TX subCRQ handle array directly from
a DMA-mapped buffer address when it needs to make a H_SEND_SUBCRQ
hcall. This patch stores that information in the ibmvnic_sub_crq_queue
structure instead of reading from the buffer received at login. The
overall goal of this patch is to parse relevant information from the
login response buffer and store it in the driver's private data
structures so that we don't need to read directly from the buffer and
can then free up that memory.

Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 38 ++++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |  1 +
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5afb3c9c52d2..597801e7e8ba 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -306,6 +306,7 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 			      struct ibmvnic_rx_pool *pool)
 {
 	int count = pool->size - atomic_read(&pool->available);
+	u64 handle = adapter->rx_scrq[pool->index]->handle;
 	struct device *dev = &adapter->vdev->dev;
 	int buffers_added = 0;
 	unsigned long lpar_rc;
@@ -314,7 +315,6 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	unsigned int offset;
 	dma_addr_t dma_addr;
 	unsigned char *dst;
-	u64 *handle_array;
 	int shift = 0;
 	int index;
 	int i;
@@ -322,10 +322,6 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	if (!pool->active)
 		return;
 
-	handle_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-				      be32_to_cpu(adapter->login_rsp_buf->
-				      off_rxadd_subcrqs));
-
 	for (i = 0; i < count; ++i) {
 		skb = alloc_skb(pool->buff_size, GFP_ATOMIC);
 		if (!skb) {
@@ -369,8 +365,7 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 #endif
 		sub_crq.rx_add.len = cpu_to_be32(pool->buff_size << shift);
 
-		lpar_rc = send_subcrq(adapter, handle_array[pool->index],
-				      &sub_crq);
+		lpar_rc = send_subcrq(adapter, handle, &sub_crq);
 		if (lpar_rc != H_SUCCESS)
 			goto failure;
 
@@ -1524,9 +1519,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned int offset;
 	int num_entries = 1;
 	unsigned char *dst;
-	u64 *handle_array;
 	int index = 0;
 	u8 proto = 0;
+	u64 handle;
 	netdev_tx_t ret = NETDEV_TX_OK;
 
 	if (test_bit(0, &adapter->resetting)) {
@@ -1553,8 +1548,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	tx_scrq = adapter->tx_scrq[queue_num];
 	txq = netdev_get_tx_queue(netdev, skb_get_queue_mapping(skb));
-	handle_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-		be32_to_cpu(adapter->login_rsp_buf->off_txsubm_subcrqs));
+	handle = tx_scrq->handle;
 
 	index = tx_pool->free_map[tx_pool->consumer_index];
 
@@ -1666,14 +1660,14 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 			ret = NETDEV_TX_OK;
 			goto tx_err_out;
 		}
-		lpar_rc = send_subcrq_indirect(adapter, handle_array[queue_num],
+		lpar_rc = send_subcrq_indirect(adapter, handle,
 					       (u64)tx_buff->indir_dma,
 					       (u64)num_entries);
 		dma_unmap_single(dev, tx_buff->indir_dma,
 				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
 	} else {
 		tx_buff->num_entries = num_entries;
-		lpar_rc = send_subcrq(adapter, handle_array[queue_num],
+		lpar_rc = send_subcrq(adapter, handle,
 				      &tx_crq);
 	}
 	if (lpar_rc != H_SUCCESS) {
@@ -4292,6 +4286,10 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	struct net_device *netdev = adapter->netdev;
 	struct ibmvnic_login_rsp_buffer *login_rsp = adapter->login_rsp_buf;
 	struct ibmvnic_login_buffer *login = adapter->login_buf;
+	u64 *tx_handle_array;
+	u64 *rx_handle_array;
+	int num_tx_pools;
+	int num_rx_pools;
 	int i;
 
 	dma_unmap_single(dev, adapter->login_buf_token, adapter->login_buf_sz,
@@ -4326,6 +4324,22 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 		ibmvnic_remove(adapter->vdev);
 		return -EIO;
 	}
+
+	num_tx_pools = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
+	num_rx_pools = be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
+
+	tx_handle_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
+				  be32_to_cpu(adapter->login_rsp_buf->off_txsubm_subcrqs));
+	rx_handle_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
+				  be32_to_cpu(adapter->login_rsp_buf->off_rxadd_subcrqs));
+
+	for (i = 0; i < num_tx_pools; i++)
+		adapter->tx_scrq[i]->handle = tx_handle_array[i];
+
+	for (i = 0; i < num_rx_pools; i++)
+		adapter->rx_scrq[i]->handle = rx_handle_array[i];
+
+	release_login_rsp_buffer(adapter);
 	release_login_buffer(adapter);
 	complete(&adapter->init_done);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index f8416e1d4cf0..d99820212edd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -875,6 +875,7 @@ struct ibmvnic_sub_crq_queue {
 	struct ibmvnic_adapter *adapter;
 	atomic_t used;
 	char name[32];
+	u64 handle;
 };
 
 struct ibmvnic_long_term_buff {
-- 
2.28.0

