Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF742B8955
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKSBMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:12:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727145AbgKSBMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:12:50 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ11c6D133835;
        Wed, 18 Nov 2020 20:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=3NnOZsOI08S9oGBY3FuTkv/H5k1bjjsGZ2mpGxw2ZCM=;
 b=omo3iiXiaIMwmZGeptVvWVnQJbvOYY3O1q0olk9d1RRKCg363YR54MunsbDuHBj/hNBR
 RUj+Mw8ckoUPCzIp8Emf8kvJqFk9aw93jStplstUTii2ekVIK7NYJM6X/VZcm/buRKp/
 6z4L7juMumqpTHGmW7L5CShrEGRiJAwIXqgPdfmDLltT3j9Fxv3sOyWUEs/8HtfGutQL
 TqnZ+1xE7WCv+fWI8QR2YASA0wFkbKRhHKKfSf2YELunn4LwZM4hHFtzJFpSAh0FURkr
 IKcf4R3VgiMhj+g6N2XklYCBfz8o7W7Ga/TOm55GmhB0ZRD58sp8b2Lf1FWrj4onPKrR wg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wc6ubtue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 20:12:45 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ1CiQO013786;
        Thu, 19 Nov 2020 01:12:44 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjmp42a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 01:12:44 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ1CgjK10355446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 01:12:43 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18796A05A;
        Thu, 19 Nov 2020 01:12:42 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8C436A058;
        Thu, 19 Nov 2020 01:12:40 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.199.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 01:12:40 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net-next v2 2/9] ibmvnic: Introduce batched RX buffer descriptor transmission
Date:   Wed, 18 Nov 2020 19:12:18 -0600
Message-Id: <1605748345-32062-3-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxlogscore=697 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the H_SEND_SUB_CRQ_INDIRECT hypervisor call to send
multiple RX buffer descriptors to the device in one hypervisor
call operation. This change will reduce the number of hypervisor
calls and thus hypervisor call overhead needed to transmit
RX buffer descriptors to the device.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 57 +++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3884f8a683a7..17ba6db6f5f9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -306,9 +306,11 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	int count = pool->size - atomic_read(&pool->available);
 	u64 handle = adapter->rx_scrq[pool->index]->handle;
 	struct device *dev = &adapter->vdev->dev;
+	struct ibmvnic_ind_xmit_queue *ind_bufp;
+	struct ibmvnic_sub_crq_queue *rx_scrq;
+	union sub_crq *sub_crq;
 	int buffers_added = 0;
 	unsigned long lpar_rc;
-	union sub_crq sub_crq;
 	struct sk_buff *skb;
 	unsigned int offset;
 	dma_addr_t dma_addr;
@@ -320,6 +322,8 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	if (!pool->active)
 		return;
 
+	rx_scrq = adapter->rx_scrq[pool->index];
+	ind_bufp = &rx_scrq->ind_buf;
 	for (i = 0; i < count; ++i) {
 		skb = alloc_skb(pool->buff_size, GFP_ATOMIC);
 		if (!skb) {
@@ -346,12 +350,13 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		pool->rx_buff[index].pool_index = pool->index;
 		pool->rx_buff[index].size = pool->buff_size;
 
-		memset(&sub_crq, 0, sizeof(sub_crq));
-		sub_crq.rx_add.first = IBMVNIC_CRQ_CMD;
-		sub_crq.rx_add.correlator =
+		sub_crq = &ind_bufp->indir_arr[ind_bufp->index++];
+		memset(sub_crq, 0, sizeof(*sub_crq));
+		sub_crq->rx_add.first = IBMVNIC_CRQ_CMD;
+		sub_crq->rx_add.correlator =
 		    cpu_to_be64((u64)&pool->rx_buff[index]);
-		sub_crq.rx_add.ioba = cpu_to_be32(dma_addr);
-		sub_crq.rx_add.map_id = pool->long_term_buff.map_id;
+		sub_crq->rx_add.ioba = cpu_to_be32(dma_addr);
+		sub_crq->rx_add.map_id = pool->long_term_buff.map_id;
 
 		/* The length field of the sCRQ is defined to be 24 bits so the
 		 * buffer size needs to be left shifted by a byte before it is
@@ -361,15 +366,20 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 #ifdef __LITTLE_ENDIAN__
 		shift = 8;
 #endif
-		sub_crq.rx_add.len = cpu_to_be32(pool->buff_size << shift);
-
-		lpar_rc = send_subcrq(adapter, handle, &sub_crq);
-		if (lpar_rc != H_SUCCESS)
-			goto failure;
-
-		buffers_added++;
-		adapter->replenish_add_buff_success++;
+		sub_crq->rx_add.len = cpu_to_be32(pool->buff_size << shift);
 		pool->next_free = (pool->next_free + 1) % pool->size;
+		if (ind_bufp->index == IBMVNIC_MAX_IND_DESCS ||
+		    i == count - 1) {
+			lpar_rc =
+				send_subcrq_indirect(adapter, handle,
+						     (u64)ind_bufp->indir_dma,
+						     (u64)ind_bufp->index);
+			if (lpar_rc != H_SUCCESS)
+				goto failure;
+			buffers_added += ind_bufp->index;
+			adapter->replenish_add_buff_success += ind_bufp->index;
+			ind_bufp->index = 0;
+		}
 	}
 	atomic_add(buffers_added, &pool->available);
 	return;
@@ -377,13 +387,20 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 failure:
 	if (lpar_rc != H_PARAMETER && lpar_rc != H_CLOSED)
 		dev_err_ratelimited(dev, "rx: replenish packet buffer failed\n");
-	pool->free_map[pool->next_free] = index;
-	pool->rx_buff[index].skb = NULL;
-
-	dev_kfree_skb_any(skb);
-	adapter->replenish_add_buff_failure++;
-	atomic_add(buffers_added, &pool->available);
+	for (i = ind_bufp->index - 1; i >= 0; --i) {
+		struct ibmvnic_rx_buff *rx_buff;
 
+		pool->next_free = pool->next_free == 0 ?
+				  pool->size - 1 : pool->next_free - 1;
+		sub_crq = &ind_bufp->indir_arr[i];
+		rx_buff = (struct ibmvnic_rx_buff *)
+				be64_to_cpu(sub_crq->rx_add.correlator);
+		index = (int)(rx_buff - pool->rx_buff);
+		pool->free_map[pool->next_free] = index;
+		dev_kfree_skb_any(pool->rx_buff[index].skb);
+		pool->rx_buff[index].skb = NULL;
+	}
+	ind_bufp->index = 0;
 	if (lpar_rc == H_CLOSED || adapter->failover_pending) {
 		/* Disable buffer pool replenishment and report carrier off if
 		 * queue is closed or pending failover.
-- 
2.26.2

