Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B522B0D82
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgKLTKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42050 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgKLTKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:39 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ3L91189212;
        Thu, 12 Nov 2020 14:10:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=22iEbyHcksRTaVOTux7kjaif80Xc0DapVVPnvXtImok=;
 b=OyQcvvAAWEwr/H6aPAqDRt2SbXmgQ8oHlirsdFaUCxevF5lLJAqy8QgzhUlkeM2pFsCy
 MR6xTUFLkSxMmbOZDwgTAEsb5iLvYJsDTOdCMKLl7YM+ftXx6xqQ/wEanvCyOWtxvuiy
 r1JALOFzhEfYvzdH6zgcd6/04GB1US1HqaBXAVUv1zZdsMKnNsFuDaffs+xSaP5q1wdu
 8E6vtmO1fZgOkhRBTuDYMZnxRhhCPZNdtFxARfpQJuSRFc3iY5AamRtFQYpyFzjP0VsT
 +pXW5fNvU01W+2akL7VhHpbEx7d3Qok90JpqwLg3mgMKRucGbuzYTmik7sLCqgmD2LOP 9w== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34s5jwv651-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:34 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ8BUm016294;
        Thu, 12 Nov 2020 19:10:34 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 34nk7b013m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:34 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJAWW67340556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:32 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20D71AE07D;
        Thu, 12 Nov 2020 19:10:32 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C83EAE08E;
        Thu, 12 Nov 2020 19:10:31 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:31 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 10/12] ibmvnic: Correctly re-enable interrupts in NAPI polling routine
Date:   Thu, 12 Nov 2020 13:10:05 -0600
Message-Id: <1605208207-1896-11-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_10:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=897
 suspectscore=1 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>

If the current NAPI polling loop exits without completing it's
budget, only re-enable interrupts if there are no entries remaining
in the queue and napi_complete_done is successful. If there are entries
remaining on the queue that were missed, restart the polling loop.

Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 37 +++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index dc42bdc6d3e1..e48a44d8884c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2387,10 +2387,17 @@ static void remove_buff_from_pool(struct ibmvnic_adapter *adapter,
 
 static int ibmvnic_poll(struct napi_struct *napi, int budget)
 {
-	struct net_device *netdev = napi->dev;
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int scrq_num = (int)(napi - adapter->napi);
-	int frames_processed = 0;
+	struct ibmvnic_sub_crq_queue *rx_scrq;
+	struct ibmvnic_adapter *adapter;
+	struct net_device *netdev;
+	int frames_processed;
+	int scrq_num;
+
+	netdev = napi->dev;
+	adapter = netdev_priv(netdev);
+	scrq_num = (int)(napi - adapter->napi);
+	frames_processed = 0;
+	rx_scrq = adapter->rx_scrq[scrq_num];
 
 restart_poll:
 	while (frames_processed < budget) {
@@ -2403,16 +2410,16 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
 		if (unlikely(test_bit(0, &adapter->resetting) &&
 			     adapter->reset_reason != VNIC_RESET_NON_FATAL)) {
-			enable_scrq_irq(adapter, adapter->rx_scrq[scrq_num]);
+			enable_scrq_irq(adapter, rx_scrq);
 			napi_complete_done(napi, frames_processed);
 			return frames_processed;
 		}
 
-		if (!pending_scrq(adapter, adapter->rx_scrq[scrq_num]))
+		if (!pending_scrq(adapter, rx_scrq))
 			break;
 		/* ensure that we do not prematurely exit the polling loop */
 		dma_rmb();
-		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
+		next = ibmvnic_next_scrq(adapter, rx_scrq);
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
 							  rx_comp.correlator);
@@ -2471,14 +2478,16 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
 	if (adapter->state != VNIC_CLOSING)
 		replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
-
 	if (frames_processed < budget) {
-		enable_scrq_irq(adapter, adapter->rx_scrq[scrq_num]);
-		napi_complete_done(napi, frames_processed);
-		if (pending_scrq(adapter, adapter->rx_scrq[scrq_num]) &&
-		    napi_reschedule(napi)) {
-			disable_scrq_irq(adapter, adapter->rx_scrq[scrq_num]);
-			goto restart_poll;
+		if (napi_complete_done(napi, frames_processed)) {
+			enable_scrq_irq(adapter, rx_scrq);
+			if (pending_scrq(adapter, rx_scrq)) {
+				rmb();
+				if (napi_reschedule(napi)) {
+					disable_scrq_irq(adapter, rx_scrq);
+					goto restart_poll;
+				}
+			}
 		}
 	}
 	return frames_processed;
-- 
2.26.2

