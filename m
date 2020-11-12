Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E192B0D7F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgKLTKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbgKLTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:36 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ1WJs036354;
        Thu, 12 Nov 2020 14:10:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=D0jhVahsfHi0ccJG8yasCmYrTlA1T6oqrOt6tpG36Dk=;
 b=X9rbABIQDL7Payc1Z06lBPIZhfQmpvEJKoq0+nDP+poZIas9DBIlPvnGb+K9gOEeLr/K
 X+PwWgIpSU8yARGbjw2h/KGP5hUAiaeFNzTOX9cwAUQgqYgPvn9/J5kDPimFVJk2MF+D
 cHyt2BlXqz2dfyI9iEGJdLadxDYxjvgXka107j2824CkUDZuNr6N3cmjdYoZFEsZiqAo
 etBZ3/tG3GN0OqNMGB1duA9GQeCisU8wkz+7cn/3vS8hJBzhh3Lb7fI6+BCjuFNyoRhA
 fbVGaka0gGZ9Hh3z1QHjP9PFfZFKZp1HGSOwJiafKp9BfLucMO9cSBsU4uPFbXhXK8m8 PQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34s8x9ut97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:25 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ7fwJ007309;
        Thu, 12 Nov 2020 19:10:24 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 34nk7a4un1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:24 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJANhq33816880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:23 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17100AE06A;
        Thu, 12 Nov 2020 19:10:23 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B80AAE090;
        Thu, 12 Nov 2020 19:10:22 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:21 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 02/12] ibmvnic: Introduce indirect subordinate Command Response Queue buffer
Date:   Thu, 12 Nov 2020 13:09:57 -0600
Message-Id: <1605208207-1896-3-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_09:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=3
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the infrastructure to send batched subordinate
Command Response Queue descriptors, which are used by the ibmvnic
driver to send TX frame and RX buffer descriptors.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 +++++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5647f54bf387..dd9ca06f355b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2860,6 +2860,7 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
 	memset(scrq->msgs, 0, 4 * PAGE_SIZE);
 	atomic_set(&scrq->used, 0);
 	scrq->cur = 0;
+	scrq->ind_buf.index = 0;
 
 	rc = h_reg_sub_crq(adapter->vdev->unit_address, scrq->msg_token,
 			   4 * PAGE_SIZE, &scrq->crq_num, &scrq->hw_irq);
@@ -2911,6 +2912,11 @@ static void release_sub_crq_queue(struct ibmvnic_adapter *adapter,
 		}
 	}
 
+	dma_free_coherent(dev,
+			  IBMVNIC_IND_ARR_SZ,
+			  scrq->ind_buf.indir_arr,
+			  scrq->ind_buf.indir_dma);
+
 	dma_unmap_single(dev, scrq->msg_token, 4 * PAGE_SIZE,
 			 DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)scrq->msgs, 2);
@@ -2957,6 +2963,19 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 
 	scrq->adapter = adapter;
 	scrq->size = 4 * PAGE_SIZE / sizeof(*scrq->msgs);
+	scrq->ind_buf.index = 0;
+
+	scrq->ind_buf.indir_arr =
+		dma_alloc_coherent(dev,
+				   IBMVNIC_IND_ARR_SZ,
+				   &scrq->ind_buf.indir_dma,
+				   GFP_KERNEL);
+
+	if (!scrq->ind_buf.indir_arr) {
+		dev_err(dev, "Couldn't allocate indirect scrq buffer\n");
+		goto reg_failed;
+	}
+
 	spin_lock_init(&scrq->lock);
 
 	netdev_dbg(adapter->netdev,
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 217dcc7ded70..05bf212d387d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -31,6 +31,7 @@
 #define IBMVNIC_BUFFS_PER_POOL	100
 #define IBMVNIC_MAX_QUEUES	16
 #define IBMVNIC_MAX_QUEUE_SZ   4096
+#define IBMVNIC_MAX_IND_DESCS  128
 
 #define IBMVNIC_TSO_BUF_SZ	65536
 #define IBMVNIC_TSO_BUFS	64
@@ -861,6 +862,14 @@ union sub_crq {
 	struct ibmvnic_rx_buff_add_desc rx_add;
 };
 
+#define IBMVNIC_IND_ARR_SZ	(IBMVNIC_MAX_IND_DESCS * sizeof(union sub_crq))
+
+struct ibmvnic_ind_xmit_queue {
+	union sub_crq *indir_arr;
+	dma_addr_t indir_dma;
+	int index;
+};
+
 struct ibmvnic_sub_crq_queue {
 	union sub_crq *msgs;
 	int size, cur;
@@ -873,6 +882,7 @@ struct ibmvnic_sub_crq_queue {
 	spinlock_t lock;
 	struct sk_buff *rx_skb_top;
 	struct ibmvnic_adapter *adapter;
+	struct ibmvnic_ind_xmit_queue ind_buf;
 	atomic_t used;
 	char name[32];
 	u64 handle;
-- 
2.26.2

