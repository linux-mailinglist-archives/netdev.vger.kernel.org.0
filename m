Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687D92FE2B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbhAUGYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:24:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbhAUGR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 01:17:58 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L62Em2195805
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yTAID7Fk6K00Ro5v5rHXdUPvJSa31PhxTFbpS6n4bdI=;
 b=bvh84Otl8Bv/Q/qWDUyPN3C4MJd/j4RkPs5EDV0+elVhReAUQz/Mi5EnLsCLFo6UdAMq
 nFDJn6sZGHW+iqCKNyAWlWAkMGumgvW0jIfcogjpxUZMEXcXb84J4fEPJ/FsAbeurWW7
 kpdRy6Bo7OLz8sg/u3Ii9CeYU6v09ng6PdcKme8f3yG38hAgSOGbBi/YcoReFxJw5Wtb
 tAw4xBTDNY9Bh155TzoFv7CZ9Z8oBSx8USEUX26eTx4DZLSG1+yfY10TekSAx6MAro3r
 VEojlMz1xZDxzEsW2xPVK+1UierG+8jC+S12HKe3fYTziQNbI47IlTFgpByVl1ocYqgO 3g== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3673921ew4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:14 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L6CUrN015482
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:13 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3668nw4br4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:13 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L6HCrC21299670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 06:17:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 466F878064;
        Thu, 21 Jan 2021 06:17:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C23367805F;
        Thu, 21 Jan 2021 06:17:11 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.137.249])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 06:17:11 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 1/3] ibmvnic: rework to ensure SCRQ entry reads are properly ordered
Date:   Thu, 21 Jan 2021 00:17:08 -0600
Message-Id: <20210121061710.53217-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210121061710.53217-1-ljp@linux.ibm.com>
References: <20210121061710.53217-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_02:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=837
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the dma_rmb() between pending_scrq() and ibmvnic_next_scrq()
into the end of pending_scrq(), and explain why.
Explain in detail why the dma_rmb() is placed at the end of
ibmvnic_next_scrq().

Fixes: b71ec9522346 ("ibmvnic: Ensure that SCRQ entry reads are correctly ordered")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 41 +++++++++++++++++-------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9778c83150f1..8e043683610f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2511,12 +2511,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
 		if (!pending_scrq(adapter, rx_scrq))
 			break;
-		/* The queue entry at the current index is peeked at above
-		 * to determine that there is a valid descriptor awaiting
-		 * processing. We want to be sure that the current slot
-		 * holds a valid descriptor before reading its contents.
-		 */
-		dma_rmb();
 		next = ibmvnic_next_scrq(adapter, rx_scrq);
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
@@ -3256,13 +3250,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		int total_bytes = 0;
 		int num_packets = 0;
 
-		/* The queue entry at the current index is peeked at above
-		 * to determine that there is a valid descriptor awaiting
-		 * processing. We want to be sure that the current slot
-		 * holds a valid descriptor before reading its contents.
-		 */
-		dma_rmb();
-
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
 			if (next->tx_comp.rcs[i])
@@ -3636,11 +3623,25 @@ static int pending_scrq(struct ibmvnic_adapter *adapter,
 			struct ibmvnic_sub_crq_queue *scrq)
 {
 	union sub_crq *entry = &scrq->msgs[scrq->cur];
+	int rc;
 
 	if (entry->generic.first & IBMVNIC_CRQ_CMD_RSP)
-		return 1;
+		rc = 1;
 	else
-		return 0;
+		rc = 0;
+
+	/* Ensure that the entire SCRQ descriptor scrq->msgs
+	 * has been loaded before reading its contents.
+	 * This barrier makes sure this function's entry, esp.
+	 * entry->generic.first & IBMVNIC_CRQ_CMD_RSP
+	 * 1. is loaded before ibmvnic_next_scrq()'s
+	 * entry->generic.first & IBMVNIC_CRQ_CMD_RSP;
+	 * 2. OR is loaded before ibmvnic_poll()'s
+	 * disable_scrq_irq()'s scrq->hw_irq.
+	 */
+	dma_rmb();
+
+	return rc;
 }
 
 static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
@@ -3659,8 +3660,14 @@ static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
 	}
 	spin_unlock_irqrestore(&scrq->lock, flags);
 
-	/* Ensure that the entire buffer descriptor has been
-	 * loaded before reading its contents
+	/* Ensure that the entire SCRQ descriptor scrq->msgs
+	 * has been loaded before reading its contents.
+	 * This barrier makes sure this function's entry, esp.
+	 * entry->generic.first & IBMVNIC_CRQ_CMD_RSP
+	 * 1. is loaded before ibmvnic_poll()'s
+	 * be64_to_cpu(next->rx_comp.correlator);
+	 * 2. OR is loaded before ibmvnic_complet_tx()'s
+	 * be32_to_cpu(next->tx_comp.correlators[i]).
 	 */
 	dma_rmb();
 
-- 
2.23.0

