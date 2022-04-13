Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AF24FFC1C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbiDMRND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiDMRMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E340C58384
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:32 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DH3j8H010819
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hOclaZ8EaBPiUdAf0y+9KIZMFrL86GCjMjzcI5xUan0=;
 b=ebxEVI66FDuYDX43x8KEnqEhAlrZgZlp6iCTvzCxLsuwR7C2qWsFqA6YzmdCB3DvabmN
 jY4i3GOjuC0DVuQK38rQ51tPvu2WAQWOPm71TPqkNPVbu/fZKreUOln3gVbA/awk3xvd
 hHurnwAvrHCtVUcsFfftL8w+bisXqbaRFG9mmgWJ1wUxvGbKph7P/4IT9h/lPKL4j/G/
 XTVKKJPbUa7LksLbSJ1xZPCT7XMhmWaWfklrXtRlmDwu/HS2TJwqX0ISCYKpYiSXGk8O
 3F8zJLkyjM/j3Nka6eElcvZDD0uiItXNpMXpbCu3Nme9IFUmnDNKbwkEE5w1rHuYNaFO NQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe2k3056p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGs8sF002023
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3fb1sa9sf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:31 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHAUZH26214800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:30 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90FA5124060;
        Wed, 13 Apr 2022 17:10:30 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53CEA12405A;
        Wed, 13 Apr 2022 17:10:30 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:30 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 3/6] ibmvnic: define map_txpool_buf_to_ltb()
Date:   Wed, 13 Apr 2022 13:10:23 -0400
Message-Id: <20220413171026.1264294-4-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
References: <20220413171026.1264294-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yk1MpjHGIt1gdFBAlPb0DkjX0rnLdWgb
X-Proofpoint-ORIG-GUID: Yk1MpjHGIt1gdFBAlPb0DkjX0rnLdWgb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 phishscore=0 mlxlogscore=941 priorityscore=1501 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130086
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

Define a helper to map a given txpool buffer into its corresponding long
term buffer (LTB) and offset. Currently there is just one LTB per txpool
so the mapping is trivial. When we add support for multiple LTBs per
txpool, this helper will be more useful.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 753afda76296..2e6042409585 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -364,6 +364,25 @@ static void map_rxpool_buf_to_ltb(struct ibmvnic_rx_pool *rxpool,
 	*offset = bufidx * rxpool->buff_size;
 }
 
+/**
+ * map_txpool_buf_to_ltb - Map given txpool buffer to offset in an LTB.
+ * @txpool: The transmit buffer pool containing buffer
+ * @bufidx: Index of buffer in txpool
+ * @ltbp: (Output) pointer to the long term buffer (LTB) containing the buffer
+ * @offset: (Output) offset of buffer in the LTB from @ltbp
+ *
+ * Map the given buffer identified by [txpool, bufidx] to an LTB in the
+ * pool and its corresponding offset.
+ */
+static void map_txpool_buf_to_ltb(struct ibmvnic_tx_pool *txpool,
+				  unsigned int bufidx,
+				  struct ibmvnic_long_term_buff **ltbp,
+				  unsigned int *offset)
+{
+	*ltbp = &txpool->long_term_buff;
+	*offset = bufidx * txpool->buf_size;
+}
+
 static void deactivate_rx_pools(struct ibmvnic_adapter *adapter)
 {
 	int i;
@@ -1931,6 +1950,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct ibmvnic_ind_xmit_queue *ind_bufp;
 	struct ibmvnic_tx_buff *tx_buff = NULL;
 	struct ibmvnic_sub_crq_queue *tx_scrq;
+	struct ibmvnic_long_term_buff *ltb;
 	struct ibmvnic_tx_pool *tx_pool;
 	unsigned int tx_send_failed = 0;
 	netdev_tx_t ret = NETDEV_TX_OK;
@@ -1993,10 +2013,11 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	tx_pool->free_map[tx_pool->consumer_index] = IBMVNIC_INVALID_MAP;
 
-	offset = bufidx * tx_pool->buf_size;
-	dst = tx_pool->long_term_buff.buff + offset;
+	map_txpool_buf_to_ltb(tx_pool, bufidx, &ltb, &offset);
+
+	dst = ltb->buff + offset;
 	memset(dst, 0, tx_pool->buf_size);
-	data_dma_addr = tx_pool->long_term_buff.addr + offset;
+	data_dma_addr = ltb->addr + offset;
 
 	if (skb_shinfo(skb)->nr_frags) {
 		int cur, i;
@@ -2040,7 +2061,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 			cpu_to_be32(bufidx | IBMVNIC_TSO_POOL_MASK);
 	else
 		tx_crq.v1.correlator = cpu_to_be32(bufidx);
-	tx_crq.v1.dma_reg = cpu_to_be16(tx_pool->long_term_buff.map_id);
+	tx_crq.v1.dma_reg = cpu_to_be16(ltb->map_id);
 	tx_crq.v1.sge_len = cpu_to_be32(skb->len);
 	tx_crq.v1.ioba = cpu_to_be64(data_dma_addr);
 
-- 
2.27.0

