Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C32C4FFC20
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbiDMRNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbiDMRMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8C4B87F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:32 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DGqqbl039959
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=B/XIN2SQdAKsX6JmrEHTbxOZaa+4DW4y2nJV2XI80vg=;
 b=BU29D5b4ZlYmrV6GqJzWK8NhuCiB/Ig/4rFDFaJA+5cBHGHU9XUE4AiN2kMZDpXZaXj0
 ycRtYYX1a7kPQPbOuRRkc41z3NX3DBoMYGOLMYTRIws6JRi+h1LSE/kjhJSOIPpILsIa
 mqw7FyZhxzbYjfmqwPXpHh24RES/nnuaJsy4caHP+eKuyEf85YDf1NaexZBVLL/N/hT+
 3g7ugmR2qXR5mKM5YQY80DjtaEIuK9r8UuGOeGl11E7svSue+GeXquwwrcMP0typ8VNY
 805/nHFrSLh2hct8DH9rFO+bTJZhSQh8gkNXQ2QJCbEFhQcsHmDiQTHfVbMwsc88Mxvv oQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe1nb9kx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGrMnE014113
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3fb1s9su9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHAUpG26804562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:30 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B48D124053;
        Wed, 13 Apr 2022 17:10:30 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F21F3124069;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:29 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 2/6] ibmvnic: define map_rxpool_buf_to_ltb()
Date:   Wed, 13 Apr 2022 13:10:22 -0400
Message-Id: <20220413171026.1264294-3-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
References: <20220413171026.1264294-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fmlG2FKjDI1K_QDF3bX0kmMno-qRd-hM
X-Proofpoint-GUID: fmlG2FKjDI1K_QDF3bX0kmMno-qRd-hM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Define a helper to map a given rx pool buffer into its corresponding long
term buffer (LTB) and offset. Currently there is just one LTB per pool so
the mapping is trivial. When we add support for multiple LTBs per pool,
this helper will be more useful.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 7fd9dd3759df..753afda76296 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -345,6 +345,25 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	ltb->map_id = 0;
 }
 
+/**
+ * map_rxpool_buf_to_ltb - Map given rxpool buffer to offset in an LTB.
+ * @rxpool: The receive buffer pool containing buffer
+ * @bufidx: Index of buffer in rxpool
+ * @ltbp: (Output) pointer to the long term buffer containing the buffer
+ * @offset: (Output) offset of buffer in the LTB from @ltbp
+ *
+ * Map the given buffer identified by [rxpool, bufidx] to an LTB in the
+ * pool and its corresponding offset.
+ */
+static void map_rxpool_buf_to_ltb(struct ibmvnic_rx_pool *rxpool,
+				  unsigned int bufidx,
+				  struct ibmvnic_long_term_buff **ltbp,
+				  unsigned int *offset)
+{
+	*ltbp = &rxpool->long_term_buff;
+	*offset = bufidx * rxpool->buff_size;
+}
+
 static void deactivate_rx_pools(struct ibmvnic_adapter *adapter)
 {
 	int i;
@@ -361,6 +380,7 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_ind_xmit_queue *ind_bufp;
 	struct ibmvnic_sub_crq_queue *rx_scrq;
+	struct ibmvnic_long_term_buff *ltb;
 	union sub_crq *sub_crq;
 	int buffers_added = 0;
 	unsigned long lpar_rc;
@@ -407,10 +427,10 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		pool->next_free = (pool->next_free + 1) % pool->size;
 
 		/* Copy the skb to the long term mapped DMA buffer */
-		offset = bufidx * pool->buff_size;
-		dst = pool->long_term_buff.buff + offset;
+		map_rxpool_buf_to_ltb(pool, bufidx, &ltb, &offset);
+		dst = ltb->buff + offset;
 		memset(dst, 0, pool->buff_size);
-		dma_addr = pool->long_term_buff.addr + offset;
+		dma_addr = ltb->addr + offset;
 
 		/* add the skb to an rx_buff in the pool */
 		pool->rx_buff[bufidx].data = dst;
@@ -426,7 +446,7 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		sub_crq->rx_add.correlator =
 		    cpu_to_be64((u64)&pool->rx_buff[bufidx]);
 		sub_crq->rx_add.ioba = cpu_to_be32(dma_addr);
-		sub_crq->rx_add.map_id = pool->long_term_buff.map_id;
+		sub_crq->rx_add.map_id = ltb->map_id;
 
 		/* The length field of the sCRQ is defined to be 24 bits so the
 		 * buffer size needs to be left shifted by a byte before it is
-- 
2.27.0

