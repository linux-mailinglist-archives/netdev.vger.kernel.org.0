Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767A630913F
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhA3BX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 20:23:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233067AbhA3BUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 20:20:24 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10U1GYJK168072
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 20:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g1GjSV9W64x1/kbE7nM1b3jXSxPHNbzais7TI9ZM180=;
 b=OFi2dAxBciFXdJIJQ8A2r4SsW9I02GEatsFrwtYt8iRkZnzZJBBafJn4a5yLw150PlR3
 ZpN/roeXZdXbjJbkFpp29ng81oTgyWTBogdVhmxiljPowXaJwavOgPdRVwMrtK8FQj9G
 l/3MmP3sCJ7iPFsWrXHy0LCpSMqDbGovINgBiv6SFwIkxTpH+6A7Qv8yaczy+V0fAQHk
 auIuiHSUEklkRoY+Xwi6Ap7HmDFR70VUgUJxTvyEtKyvyqO04jLxFSp0LHzw5zo+rYQQ
 u4Y5J5x3paGxnDwGzJ0y0/15iHvrmfZSqdM0+CsQwAn4f2VMeQWqNT7zHzr1FTLxzrf+ sw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36cwnar0q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 20:19:12 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10U1GBkT029726
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 01:19:11 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 36a8uhx868-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 01:19:11 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10U1J8JB25690570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 01:19:08 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BFA0BE04F;
        Sat, 30 Jan 2021 01:19:08 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98EF3BE051;
        Sat, 30 Jan 2021 01:19:07 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.192.149])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 30 Jan 2021 01:19:07 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        brking@linux.vnet.ibm.com, dnbanerg@us.ibm.com,
        tlfalcon@linux.ibm.com, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 1/2] ibmvnic: rework to ensure SCRQ entry reads are properly ordered
Date:   Fri, 29 Jan 2021 19:19:04 -0600
Message-Id: <20210130011905.1485-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210130011905.1485-1-ljp@linux.ibm.com>
References: <20210130011905.1485-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-29_12:2021-01-29,2021-01-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101300000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the dma_rmb() between pending_scrq() and ibmvnic_next_scrq()
into the end of pending_scrq() to save the duplicated code since
this dma_rmb will be used 3 times.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a40af510018a..331ebca2f57a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2444,12 +2444,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
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
@@ -3189,13 +3183,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
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
@@ -3569,11 +3556,16 @@ static int pending_scrq(struct ibmvnic_adapter *adapter,
 			struct ibmvnic_sub_crq_queue *scrq)
 {
 	union sub_crq *entry = &scrq->msgs[scrq->cur];
+	int rc;
 
-	if (entry->generic.first & IBMVNIC_CRQ_CMD_RSP)
-		return 1;
-	else
-		return 0;
+	rc = !!(entry->generic.first & IBMVNIC_CRQ_CMD_RSP);
+
+	/* Ensure that the SCRQ valid flag is loaded prior to loading the
+	 * contents of the SCRQ descriptor
+	 */
+	dma_rmb();
+
+	return rc;
 }
 
 static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
@@ -3592,8 +3584,8 @@ static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
 	}
 	spin_unlock_irqrestore(&scrq->lock, flags);
 
-	/* Ensure that the entire buffer descriptor has been
-	 * loaded before reading its contents
+	/* Ensure that the SCRQ valid flag is loaded prior to loading the
+	 * contents of the SCRQ descriptor
 	 */
 	dma_rmb();
 
-- 
2.23.0

