Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73CF3B2616
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFXEQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:16:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229944AbhFXEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O43ugK146823
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qzToLNn0DFpuAvjwAcOr/2H7dENYPV5Ip4tXiOEJNqE=;
 b=EBgA0XGA9NqO6YWEx0nj+CJtQqYuaoURqYX7NY+oaI4lvItQcs6sbclHErmrNnYtOn8l
 N/AACzIwCAQ0Z9GgijjSPnin0j/mtQxtpIK23ijsufnqGKvkQLhuFuGpl2XGZ6VHlZs1
 30P+hVGJ/35aRpjD9UBi1AIy4zO69Ysr3uw9l1H+B7JHybBuKaGiMDSgPlMtIyfW31K7
 GGhjVq12Y/9MqmdpIOO9otKuVjE6F84eHbrztO/NUGxx3XURJM/KvAz/pKr1MveMgVY1
 SX+ICvDnTM6jlpuK/UgXVWRaG8IGfNKoe3pmyudmiJnDyYMQUmWzXiREnzVTgaR/o2Vh zg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39cg7cbjbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:24 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O4BFo4017919
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:23 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04wdc.us.ibm.com with ESMTP id 399879ns7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:23 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DMhb31195418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:22 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E4EF6A047;
        Thu, 24 Jun 2021 04:13:22 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 147456A04F;
        Thu, 24 Jun 2021 04:13:21 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:20 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 3/7] ibmvnic: clean pending indirect buffs during reset
Date:   Wed, 23 Jun 2021 21:13:12 -0700
Message-Id: <20210624041316.567622-4-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sjl0JpW60M-nqOj2RFIIwSr7WpsSqhl7
X-Proofpoint-GUID: sjl0JpW60M-nqOj2RFIIwSr7WpsSqhl7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We batch subordinate command response queue (scrq) descriptors that we
need to send to the VIOS using an "indirect" buffer. If after we queue
one or more scrqs in the indirect buffer encounter an error (say fail
to allocate an skb), we leave the queued scrq descriptors in the
indirect buffer until the next call to ibmvnic_xmit().

On the next call to ibmvnic_xmit(), it is possible that the adapter is
going through a reset and it is possible that the long term  buffers
have been unmapped on the VIOS side. If we proceed to flush (send) the
packets that are in the indirect buffer, we will end up using the old
map ids and this can cause the VIOS to trigger an unnecessary FATAL
error reset.

Instead of flushing packets remaining on the indirect_buff, discard
(clean) them instead.

Fixes: 0d973388185d4 ("ibmvnic: Introduce xmit_more support using batched subCRQ hcalls")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index fe1627ea9762..fa402e20c137 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -106,6 +106,8 @@ static void release_crq_queue(struct ibmvnic_adapter *);
 static int __ibmvnic_set_mac(struct net_device *, u8 *);
 static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
+static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
+					 struct ibmvnic_sub_crq_queue *tx_scrq);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -691,6 +693,7 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 
 	tx_scrqs = adapter->num_active_tx_pools;
 	for (i = 0; i < tx_scrqs; i++) {
+		ibmvnic_tx_scrq_clean_buffer(adapter, adapter->tx_scrq[i]);
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
 		if (rc)
 			return rc;
@@ -1643,7 +1646,8 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 	ind_bufp->index = 0;
 	if (atomic_sub_return(entries, &tx_scrq->used) <=
 	    (adapter->req_tx_entries_per_subcrq / 2) &&
-	    __netif_subqueue_stopped(adapter->netdev, queue_num)) {
+	    __netif_subqueue_stopped(adapter->netdev, queue_num) &&
+	    !test_bit(0, &adapter->resetting)) {
 		netif_wake_subqueue(adapter->netdev, queue_num);
 		netdev_dbg(adapter->netdev, "Started queue %d\n",
 			   queue_num);
@@ -1713,7 +1717,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
-		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 
@@ -3276,6 +3279,7 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 
 			netdev_dbg(adapter->netdev, "Releasing tx_scrq[%d]\n",
 				   i);
+			ibmvnic_tx_scrq_clean_buffer(adapter, adapter->tx_scrq[i]);
 			if (adapter->tx_scrq[i]->irq) {
 				free_irq(adapter->tx_scrq[i]->irq,
 					 adapter->tx_scrq[i]);
-- 
2.31.1

