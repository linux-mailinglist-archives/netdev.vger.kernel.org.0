Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822872B8958
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgKSBM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:12:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727252AbgKSBM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:12:58 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ13H76116913;
        Wed, 18 Nov 2020 20:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rdP0WlYRU05xnFX/GLwQ4bsCBVUl72sVKd2KQRLz3qc=;
 b=UMkNaldvJKrVkb9WHa9hgwyb6juM6p1/9+L2UbyS8PszplgG1exZ162PICB81xW1QZi/
 crj55vSB9o/6Oxo2At/pS5M8u2SH0R77JnGwSFFcTXxnVBWGpPERq031SqVt0QCvhL0z
 WR8eebgfE8wOduo47oNj7/A+W+2JLXKAOo0FhEt4XAj6tzbcJo1vpLVKD7j8SWIq7F7/
 aWLC3uBf/fsDs6qI4erGV4pRq3LKWNoxEB/V+rJnurm/tq3c/MhHxfSNOZll2EAbrau7
 AmGdo8P8NzuGJU4goopsjFNJk1z6A/cwr9ubKZfJxfjYk9RiyQ9z4eFliGlJ0IZ3CoMr IQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4rha2fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 20:12:54 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ1CmJT025938;
        Thu, 19 Nov 2020 01:12:53 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 34uttrqyuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 01:12:53 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ1CgaR41681158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 01:12:42 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F0886A04D;
        Thu, 19 Nov 2020 01:12:51 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BA976A04F;
        Thu, 19 Nov 2020 01:12:49 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.199.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 01:12:49 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net-next v2 6/9] ibmvnic: Ensure that device queue memory is cache-line aligned
Date:   Wed, 18 Nov 2020 19:12:22 -0600
Message-Id: <1605748345-32062-7-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 clxscore=1015
 mlxscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>

PCI bus slowdowns were observed on IBM VNIC devices as a result
of partial cache line writes and non-cache aligned full cache line writes.
Ensure that packet data buffers are cache-line aligned to avoid these
slowdowns.

Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c |  9 ++++++---
 drivers/net/ethernet/ibm/ibmvnic.h | 10 +++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e9b0cb6dfd9d..85df91c9861b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -498,7 +498,7 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 
 		if (rx_pool->buff_size != buff_size) {
 			free_long_term_buff(adapter, &rx_pool->long_term_buff);
-			rx_pool->buff_size = buff_size;
+			rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 			rc = alloc_long_term_buff(adapter,
 						  &rx_pool->long_term_buff,
 						  rx_pool->size *
@@ -592,7 +592,7 @@ static int init_rx_pools(struct net_device *netdev)
 
 		rx_pool->size = adapter->req_rx_add_entries_per_subcrq;
 		rx_pool->index = i;
-		rx_pool->buff_size = buff_size;
+		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 		rx_pool->active = 1;
 
 		rx_pool->free_map = kcalloc(rx_pool->size, sizeof(int),
@@ -745,6 +745,7 @@ static int init_tx_pools(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int tx_subcrqs;
+	u64 buff_size;
 	int i, rc;
 
 	tx_subcrqs = adapter->num_active_tx_scrqs;
@@ -761,9 +762,11 @@ static int init_tx_pools(struct net_device *netdev)
 	adapter->num_active_tx_pools = tx_subcrqs;
 
 	for (i = 0; i < tx_subcrqs; i++) {
+		buff_size = adapter->req_mtu + VLAN_HLEN;
+		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
 		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
 				      adapter->req_tx_entries_per_subcrq,
-				      adapter->req_mtu + VLAN_HLEN);
+				      buff_size);
 		if (rc) {
 			release_tx_pools(adapter);
 			return rc;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 16d892c3db0f..9911d926dd7f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -883,7 +883,7 @@ struct ibmvnic_sub_crq_queue {
 	atomic_t used;
 	char name[32];
 	u64 handle;
-};
+} ____cacheline_aligned;
 
 struct ibmvnic_long_term_buff {
 	unsigned char *buff;
@@ -907,7 +907,7 @@ struct ibmvnic_tx_pool {
 	struct ibmvnic_long_term_buff long_term_buff;
 	int num_buffers;
 	int buf_size;
-};
+} ____cacheline_aligned;
 
 struct ibmvnic_rx_buff {
 	struct sk_buff *skb;
@@ -928,7 +928,7 @@ struct ibmvnic_rx_pool {
 	int next_alloc;
 	int active;
 	struct ibmvnic_long_term_buff long_term_buff;
-};
+} ____cacheline_aligned;
 
 struct ibmvnic_vpd {
 	unsigned char *buff;
@@ -1015,8 +1015,8 @@ struct ibmvnic_adapter {
 	atomic_t running_cap_crqs;
 	bool wait_capability;
 
-	struct ibmvnic_sub_crq_queue **tx_scrq;
-	struct ibmvnic_sub_crq_queue **rx_scrq;
+	struct ibmvnic_sub_crq_queue **tx_scrq ____cacheline_aligned;
+	struct ibmvnic_sub_crq_queue **rx_scrq ____cacheline_aligned;
 
 	/* rx structs */
 	struct napi_struct *napi;
-- 
2.26.2

