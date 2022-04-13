Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC444FFC1E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbiDMRNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237355AbiDMRM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9153C4B87F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:34 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DGqo9K003856
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NSZFBKjLp85cdIVoHXhnLf2wLLwrBKl3MRDN9qnZLGg=;
 b=Ragj+MCWg6uPN7vZsInUfW5r9+fDpC++kMhgCT/85hmHp84kNKHFYNCmqFUZvfe6Jliu
 wz6zuDFxwxgA56orxSpUxVk/e3wdJq74QTtWl5CCLNy2qLRUN0QETT0x2SUe9hb9y2IY
 yiO2MMzzt65qzZPFw56GG712LWcNemITeKYWNob7iiJrXB3f4keg9h8JlJ/78eQachQG
 jv/a80UBraMrvjFcPBXM56heCV+D8F8pEcSwsk5BYDDbUJ3DYAIJXM883IZVvoMKspW0
 ctewVpuQD59InaCEZ04M+/ATJ8cmrdI9eDrnlRwz5wLbnFOjXmNkUMEbIx7lyGRfWe8a jg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fe1du1yhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:33 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGs8Xp002020
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3fb1sa9sf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHAVPq46924136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:31 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B347F124062;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 765A3124053;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 6/6] ibmvnic: Allow multiple ltbs in txpool ltb_set
Date:   Wed, 13 Apr 2022 13:10:26 -0400
Message-Id: <20220413171026.1264294-7-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
References: <20220413171026.1264294-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3ilW0EUzHh639oiKGvxRJzLmgH5KUpvM
X-Proofpoint-ORIG-GUID: 3ilW0EUzHh639oiKGvxRJzLmgH5KUpvM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Allow multiple LTBs in the txpool's ltb_set. i.e rather than using
a single large LTB, use several smaller LTBs.

The first n-1 LTBs will all be of the same size. The size of the last
LTB in the set depends on the number of buffers and buffer (mtu) size.
This strategy hopefully allows more reuse of the initial LTBs and also
reduces the chances of an allocation failure (of the large LTB) when
system is low in memory.

Suggested-by: Brian King <brking@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 53 +++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |  2 +-
 2 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 16fd1f1f1228..4840ad4ccd10 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -257,12 +257,14 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb, int size)
 {
 	struct device *dev = &adapter->vdev->dev;
+	u64 prev = 0;
 	int rc;
 
 	if (!reuse_ltb(ltb, size)) {
 		dev_dbg(dev,
 			"LTB size changed from 0x%llx to 0x%x, reallocating\n",
 			 ltb->size, size);
+		prev = ltb->size;
 		free_long_term_buff(adapter, ltb);
 	}
 
@@ -283,8 +285,8 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 		bitmap_set(adapter->map_ids, ltb->map_id, 1);
 
 		dev_dbg(dev,
-			"Allocated new LTB [map %d, size 0x%llx]\n",
-			 ltb->map_id, ltb->size);
+			"Allocated new LTB [map %d, size 0x%llx was 0x%llx]\n",
+			 ltb->map_id, ltb->size, prev);
 	}
 
 	/* Ensure ltb is zeroed - specially when reusing it. */
@@ -529,7 +531,21 @@ static void map_txpool_buf_to_ltb(struct ibmvnic_tx_pool *txpool,
 				  struct ibmvnic_long_term_buff **ltbp,
 				  unsigned int *offset)
 {
-	*ltbp = &txpool->long_term_buff;
+	struct ibmvnic_long_term_buff *ltb;
+	int nbufs;	/* # of buffers in one ltb */
+	int i;
+
+	WARN_ON_ONCE(bufidx >= txpool->num_buffers);
+
+	for (i = 0; i < txpool->ltb_set.num_ltbs; i++) {
+		ltb = &txpool->ltb_set.ltbs[i];
+		nbufs = ltb->size / txpool->buf_size;
+		if (bufidx < nbufs)
+			break;
+		bufidx -= nbufs;
+	}
+
+	*ltbp = ltb;
 	*offset = bufidx * txpool->buf_size;
 }
 
@@ -971,7 +987,7 @@ static void release_one_tx_pool(struct ibmvnic_adapter *adapter,
 {
 	kfree(tx_pool->tx_buff);
 	kfree(tx_pool->free_map);
-	free_long_term_buff(adapter, &tx_pool->long_term_buff);
+	free_ltb_set(adapter, &tx_pool->ltb_set);
 }
 
 /**
@@ -1161,17 +1177,16 @@ static int init_tx_pools(struct net_device *netdev)
 	for (i = 0; i < num_pools; i++) {
 		struct ibmvnic_tx_pool *tso_pool;
 		struct ibmvnic_tx_pool *tx_pool;
-		u32 ltb_size;
 
 		tx_pool = &adapter->tx_pool[i];
-		ltb_size = tx_pool->num_buffers * tx_pool->buf_size;
-		if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
-					 ltb_size))
-			goto out;
 
-		dev_dbg(dev, "Updated LTB for tx pool %d [%p, %d, %d]\n",
-			i, tx_pool->long_term_buff.buff,
-			tx_pool->num_buffers, tx_pool->buf_size);
+		dev_dbg(dev, "Updating LTB for tx pool %d [%d, %d]\n",
+			i, tx_pool->num_buffers, tx_pool->buf_size);
+
+		rc = alloc_ltb_set(adapter, &tx_pool->ltb_set,
+				   tx_pool->num_buffers, tx_pool->buf_size);
+		if (rc)
+			goto out;
 
 		tx_pool->consumer_index = 0;
 		tx_pool->producer_index = 0;
@@ -1180,14 +1195,14 @@ static int init_tx_pools(struct net_device *netdev)
 			tx_pool->free_map[j] = j;
 
 		tso_pool = &adapter->tso_pool[i];
-		ltb_size = tso_pool->num_buffers * tso_pool->buf_size;
-		if (alloc_long_term_buff(adapter, &tso_pool->long_term_buff,
-					 ltb_size))
-			goto out;
 
-		dev_dbg(dev, "Updated LTB for tso pool %d [%p, %d, %d]\n",
-			i, tso_pool->long_term_buff.buff,
-			tso_pool->num_buffers, tso_pool->buf_size);
+		dev_dbg(dev, "Updating LTB for tso pool %d [%d, %d]\n",
+			i, tso_pool->num_buffers, tso_pool->buf_size);
+
+		rc = alloc_ltb_set(adapter, &tso_pool->ltb_set,
+				   tso_pool->num_buffers, tso_pool->buf_size);
+		if (rc)
+			goto out;
 
 		tso_pool->consumer_index = 0;
 		tso_pool->producer_index = 0;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 178035872c32..90d6833fb1db 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -856,7 +856,7 @@ struct ibmvnic_tx_pool {
 	int *free_map;
 	int consumer_index;
 	int producer_index;
-	struct ibmvnic_long_term_buff long_term_buff;
+	struct ibmvnic_ltb_set ltb_set;
 	int num_buffers;
 	int buf_size;
 } ____cacheline_aligned;
-- 
2.27.0

