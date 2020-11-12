Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C462B0D89
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKLTLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:11:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbgKLTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:36 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ2uaO154917;
        Thu, 12 Nov 2020 14:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=CP7hCIBfiOtgwvTwD8NObFX4LazsZ0w9VriHF9QUMb4=;
 b=oBnKg0GAW1O7ylE3Zsl7/J+Rv/B9oOCdt7BFrC2Dur/pnkh47xV5LzZSN/EhzQ2Ha6cQ
 BT80TJ6K547fBuvpu08yfYPyxllNJxUEIjLuRATp/9RAMueNdwfs8Ivkwzk7IUBPS4IN
 tHXKSsYfRqGCpti10Tg57v8+anoREgapJi6n+uXwhnJm3sDtNJJom+aQCAVpJKFTtZG3
 BT+gYpwJ7XmMMpmaK8sj07qjLtyfnmVYMHTKbZDz19PU2DqcxSeKb9AvfyMTMNu4lUOE
 33Pt6Ix08l2yGcyh5auJftesEiC3iT1WUfqgY27p1+bwW/g1hcKNRJolZvq2ceiHJPWA Uw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34s9c432uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:26 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ76Se011368;
        Thu, 12 Nov 2020 19:10:25 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 34nk79mv4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:25 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJAOW910289774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:24 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ED5BAE07A;
        Thu, 12 Nov 2020 19:10:24 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 442A5AE05F;
        Thu, 12 Nov 2020 19:10:23 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:23 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 03/12] ibmvnic: Introduce batched RX buffer descriptor transmission
Date:   Thu, 12 Nov 2020 13:09:58 -0600
Message-Id: <1605208207-1896-4-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_10:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=733 clxscore=1015 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=3 adultscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120112
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
index dd9ca06f355b..524020691ef8 100644
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

