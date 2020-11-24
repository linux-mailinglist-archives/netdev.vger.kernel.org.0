Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33C92C2E7A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390826AbgKXR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:26:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390777AbgKXR0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:26:37 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOH1u0s057647;
        Tue, 24 Nov 2020 12:26:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jgPr9DpKUXRYYRM7d5HIgT94yT1HbuulKGlIcP83Pcg=;
 b=Yf8LMoBQ10UDYOty31iYeBprYIFBv0EI4Cf2weJQphBNGlejlKbYu3lEdkixwG68Hnmh
 KqY1tWG8aaUe3+0aNHWbiC8eBcV2Zp6oxInI0cSeu/HbstJJKdIesGtjXnq2W2hEQGFP
 qJLIyqRmiQSEd18uJyx7p119W2oQCPlM2Cdaj+atMCPvvOxbhoec8aDnfl9uYKYwgTya
 juoO0n+goYdOoWHXJQSaDvpx5Jwh8TvlgNQsRrZL3mR2LxmpbGuUpGT5//H9eWZEwcT7
 Rz7rLBCeG+VA6t80j4ancOzvtlPpJM3gCc20PDUx+c7vn07Szoj7IgbfFQJyd2/qHrwn jg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3513uwe7p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:26:32 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHN7uN022134;
        Tue, 24 Nov 2020 17:26:31 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 34xth9yb30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:26:31 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHQUn955181624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:26:30 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 178B36A057;
        Tue, 24 Nov 2020 17:26:30 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECF276A047;
        Tue, 24 Nov 2020 17:26:27 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.17.166])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:26:27 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, drt@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tlfalcon@linux.ibm.com
Subject: [PATCH net 1/2] ibmvnic: Ensure that SCRQ entry reads are correctly ordered
Date:   Tue, 24 Nov 2020 11:26:15 -0600
Message-Id: <1606238776-30259-2-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606238776-30259-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1606238776-30259-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that received Subordinate Command-Response Queue (SCRQ)
entries are properly read in order by the driver. These queues
are used in the ibmvnic device to process RX buffer and TX completion
descriptors. dma_rmb barriers have been added after checking for a
pending descriptor to ensure the correct descriptor entry is checked
and after reading the SCRQ descriptor to ensure the entire
descriptor is read before processing.

Fixes: 032c5e828 ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2aa40b2..489ed5e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2403,6 +2403,8 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
 		if (!pending_scrq(adapter, adapter->rx_scrq[scrq_num]))
 			break;
+		/* ensure that we do not prematurely exit the polling loop */
+		dma_rmb();
 		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
@@ -3098,6 +3100,9 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		unsigned int pool = scrq->pool_index;
 		int num_entries = 0;
 
+		/* ensure that the correct descriptor entry is read */
+		dma_rmb();
+
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
 			if (next->tx_comp.rcs[i]) {
@@ -3498,6 +3503,9 @@ static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
 	}
 	spin_unlock_irqrestore(&scrq->lock, flags);
 
+	/* ensure that the entire SCRQ descriptor is read */
+	dma_rmb();
+
 	return entry;
 }
 
-- 
1.8.3.1

