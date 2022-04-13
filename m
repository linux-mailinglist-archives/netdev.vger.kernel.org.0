Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F5B4FFC26
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiDMRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbiDMRMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:12:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB191B796
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:10:33 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DGqumx008052
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9XGRGsr658xNP0ek+14sHAMMfuO9oE836xNJqCG71ig=;
 b=rr7lHrDXzXwBNVGiP79o/H9vF5ISyI/uAUYIQaGRkhXcEC0Iw5d/HawGGuMVgcYnYv5Z
 a1EYIPrk26TZkUlp6VP9zMMrv1PuA46eIOczebfYUYbMthe+ICrJLtlhYgVmHhMZ1tJb
 xug8MMH9wiFpTYjyLhHF4w8spYe8uGtB44o7bExgfEQit875fSNv3/WgxukUwp+o7qM8
 hVU1/ZtAufk1bMaE4bxRdPxN7iHB+vkoE1ZnD/N75r8yCwLqmD8AHsD1+y5CETsN3CXa
 tlrNuaLjgEktsWHRggqzo66+BC4m1Gm/tz2cfL0A6vMM4PAHfhuRZzqonOMphQBUmfAY uw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe14rj96s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DGs9I5002171
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3fb1sa9sf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:10:32 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DHAV0C38863164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 17:10:31 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0840512405A;
        Wed, 13 Apr 2022 17:10:31 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFBE012406B;
        Wed, 13 Apr 2022 17:10:30 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 17:10:30 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com
Subject: [PATCH net-next 4/6] ibmvnic: convert rxpool ltb to a set of ltbs
Date:   Wed, 13 Apr 2022 13:10:24 -0400
Message-Id: <20220413171026.1264294-5-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
References: <20220413171026.1264294-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J9nlWc0YD4lGv9k-4d8XsqJ-B2yociLP
X-Proofpoint-GUID: J9nlWc0YD4lGv9k-4d8XsqJ-B2yociLP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_03,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

Define and use interfaces that treat the long term buffer (LTB) of an
rxpool as a set of LTBs rather than a single LTB. The set only has one
LTB for now.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 44 ++++++++++++++++++++++++++----
 drivers/net/ethernet/ibm/ibmvnic.h |  7 ++++-
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2e6042409585..765a48833b3b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -345,6 +345,41 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	ltb->map_id = 0;
 }
 
+static void free_ltb_set(struct ibmvnic_adapter *adapter,
+			 struct ibmvnic_ltb_set *ltb_set)
+{
+	int i;
+
+	for (i = 0; i < ltb_set->num_ltbs; i++)
+		free_long_term_buff(adapter, &ltb_set->ltbs[i]);
+
+	kfree(ltb_set->ltbs);
+	ltb_set->ltbs = NULL;
+	ltb_set->num_ltbs = 0;
+}
+
+static int alloc_ltb_set(struct ibmvnic_adapter *adapter,
+			 struct ibmvnic_ltb_set *ltb_set, int num_buffs,
+			 int buff_size)
+{
+	struct ibmvnic_long_term_buff *ltb;
+	int ltb_size;
+	int size;
+
+	size = sizeof(struct ibmvnic_long_term_buff);
+
+	ltb_set->ltbs = kmalloc(size, GFP_KERNEL);
+	if (!ltb_set->ltbs)
+		return -ENOMEM;
+
+	ltb_set->num_ltbs = 1;
+	ltb = &ltb_set->ltbs[0];
+
+	ltb_size = num_buffs * buff_size;
+
+	return alloc_long_term_buff(adapter, ltb, ltb_size);
+}
+
 /**
  * map_rxpool_buf_to_ltb - Map given rxpool buffer to offset in an LTB.
  * @rxpool: The receive buffer pool containing buffer
@@ -360,7 +395,7 @@ static void map_rxpool_buf_to_ltb(struct ibmvnic_rx_pool *rxpool,
 				  struct ibmvnic_long_term_buff **ltbp,
 				  unsigned int *offset)
 {
-	*ltbp = &rxpool->long_term_buff;
+	*ltbp = &rxpool->ltb_set.ltbs[0];
 	*offset = bufidx * rxpool->buff_size;
 }
 
@@ -618,7 +653,7 @@ static void release_rx_pools(struct ibmvnic_adapter *adapter)
 
 		kfree(rx_pool->free_map);
 
-		free_long_term_buff(adapter, &rx_pool->long_term_buff);
+		free_ltb_set(adapter, &rx_pool->ltb_set);
 
 		if (!rx_pool->rx_buff)
 			continue;
@@ -763,9 +798,8 @@ static int init_rx_pools(struct net_device *netdev)
 		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
 			i, rx_pool->size, rx_pool->buff_size);
 
-		rc = alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
-					  rx_pool->size * rx_pool->buff_size);
-		if (rc)
+		if (alloc_ltb_set(adapter, &rx_pool->ltb_set,
+				  rx_pool->size, rx_pool->buff_size))
 			goto out;
 
 		for (j = 0; j < rx_pool->size; ++j) {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 8f5cefb932dd..7d430fdf47c0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -798,6 +798,11 @@ struct ibmvnic_long_term_buff {
 	u8 map_id;
 };
 
+struct ibmvnic_ltb_set {
+	int num_ltbs;
+	struct ibmvnic_long_term_buff *ltbs;
+};
+
 struct ibmvnic_tx_buff {
 	struct sk_buff *skb;
 	int index;
@@ -833,7 +838,7 @@ struct ibmvnic_rx_pool {
 	int next_free;
 	int next_alloc;
 	int active;
-	struct ibmvnic_long_term_buff long_term_buff;
+	struct ibmvnic_ltb_set ltb_set;
 } ____cacheline_aligned;
 
 struct ibmvnic_vpd {
-- 
2.27.0

