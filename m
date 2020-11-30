Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6489E2C8DB1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbgK3TIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:08:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39140 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgK3TIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:08:23 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ1mNf164833;
        Mon, 30 Nov 2020 14:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=EZWTFGro04oEtz5pg4Ckd/01mafqCzMu7ZNtjhdnNOk=;
 b=STeElyygk9FcMI0ALiWarl5ibmcuIlgCsAKpUlaq2jVrE9RKwF7B2ur2dncl2KD/bvYQ
 OC678+nGaFsaRVnLn/+4LbBaqZXo/WUNedq5aaAYrZ9m18mrompjogLJJm4e62L71Crq
 u0YBVKsyZXvD2j113zCwqiFYTk8PX4w8RkfpFEljwBTewxui/iJrPBSZRLNKmDIcDr4B
 TGZpkepShqgOQFKfbCi72Xacn+yUV4UvMntlmVrnebS0r9hDB8OgI2LFGcyAS41mPY/d
 1CjaMfHuTgKZiEie5KYtCtYogbZlislPWfIS+qBATmIGz/p7v6DPgJyripdd8CVFsrC6 mg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3556640t9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 14:07:32 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ28Eg012973;
        Mon, 30 Nov 2020 19:07:32 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 353e68t2bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 19:07:32 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUJ7Vko50594302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:07:31 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D0812805E;
        Mon, 30 Nov 2020 19:07:31 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3449628065;
        Mon, 30 Nov 2020 19:07:30 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.4.131])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 19:07:30 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net v2 1/2] ibmvnic: Ensure that SCRQ entry reads are correctly ordered
Date:   Mon, 30 Nov 2020 13:07:23 -0600
Message-Id: <1606763244-28111-2-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606763244-28111-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1606763244-28111-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_08:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 clxscore=1015
 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300120
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
 drivers/net/ethernet/ibm/ibmvnic.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2aa40b2..5ea9f5c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2403,6 +2403,12 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
 		if (!pending_scrq(adapter, adapter->rx_scrq[scrq_num]))
 			break;
+		/* The queue entry at the current index is peeked at above
+		 * to determine that there is a valid descriptor awaiting
+		 * processing. We want to be sure that the current slot
+		 * holds a valid descriptor before reading its contents.
+		 */
+		dma_rmb();
 		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
@@ -3098,6 +3104,13 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		unsigned int pool = scrq->pool_index;
 		int num_entries = 0;
 
+		/* The queue entry at the current index is peeked at above
+		 * to determine that there is a valid descriptor awaiting
+		 * processing. We want to be sure that the current slot
+		 * holds a valid descriptor before reading its contents.
+		 */
+		dma_rmb();
+
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
 			if (next->tx_comp.rcs[i]) {
@@ -3498,6 +3511,11 @@ static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,
 	}
 	spin_unlock_irqrestore(&scrq->lock, flags);
 
+	/* Ensure that the entire buffer descriptor has been
+	 * loaded before reading its contents
+	 */
+	dma_rmb();
+
 	return entry;
 }
 
-- 
1.8.3.1

