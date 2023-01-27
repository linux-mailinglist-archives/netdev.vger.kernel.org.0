Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B9E67F098
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 22:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjA0VoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 16:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjA0VoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 16:44:08 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8143A7AE40
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 13:44:07 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RLJcB0020133
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 21:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=NbxRuBYeoieTeB/mjKc8iNHPYmBJkSRxGaqRiyU40Ys=;
 b=W2M2a56SunhVPno4r+hsN50M6wa8JPgizCJdRV86f0TT/JfTl7fV77u62nFLdgoI6aZo
 AF6FXUTJU0cDwZW+v2RDqJOcDYwp5y7g8/y6Q2SHjJl0sRTIHcW82Xg3pGfN8rt54qD3
 5M41oY7oibmQEFd+jYzrgxMTwEUaTSS6Yq45eQf7O3iufunQGeJDWVHAXDzPPLIcrrm6
 NYxtFNqFbYQhy8HdTmc+HxYcJVUaswrB+BwQbWk3BJzG1T/T4liBvgq5QxcXAOVE1Av3
 znOmA6yP2uuOeTNR3Jqd7Dn3/ptOw6XVRPMaYYoGoBLrnNTXtoLmcp8vrzF7G/6MZBn+ IQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ncnrh19p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 21:44:06 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30RKWlYi012727
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 21:44:05 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3n87p84fxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 21:44:05 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30RLi2ab9699968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 21:44:02 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE6F458059;
        Fri, 27 Jan 2023 21:44:02 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79E9B58063;
        Fri, 27 Jan 2023 21:44:01 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.65.211.86])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Jan 2023 21:44:01 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH v2 net-next] ibmvnic: Toggle between queue types in affinity mapping
Date:   Fri, 27 Jan 2023 15:43:58 -0600
Message-Id: <20230127214358.318152-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cGzGa1Bo2CLchbngoBObVYH7Kzag5UAP
X-Proofpoint-ORIG-GUID: cGzGa1Bo2CLchbngoBObVYH7Kzag5UAP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_14,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 clxscore=1015 mlxscore=0 mlxlogscore=848 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270197
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, ibmvnic IRQs were assigned to CPU numbers by assigning all
the IRQs for transmit queues then assigning all the IRQs for receive
queues. With multi-threaded processors, in a heavy RX or TX environment,
physical cores would either be overloaded or underutilized (due to the
IRQ assignment algorithm). This approach is sub-optimal because IRQs for
the same subprocess (RX or TX) would be bound to adjacent CPU numbers,
meaning they were more likely to be contending for the same core.

For example, in a system with 64 CPU's and 32 queues, the IRQs would
be bound to CPU in the following pattern:

IRQ type |  CPU number
-----------------------
TX0	 |	0-1
TX1	 |	2-3
<etc>
RX0	 |	32-33
RX1	 |	34-35
<etc>

Observe that in SMT-8, the first 4 tx queues would be sharing the
same core.

A more optimal algorithm would balance the number RX and TX IRQ's across
the physical cores. Therefore, to increase performance, distribute RX and
TX IRQs across cores by alternating between assigning IRQs for RX and TX
queues to CPUs.
With a system with 64 CPUs and 32 queues, this results in the following
pattern:

IRQ type |  CPU number
-----------------------
TX0	 |	0-1
RX0	 |	2-3
TX1	 |	4-5
RX1	 |	6-7
<etc>

Observe that in SMT-8, there is equal distribution of RX and TX IRQs
per core. In the above case, each core handles 2 TX and 2 RX IRQ's.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Haren Myneni <haren@linux.ibm.com>
---
Changes from v1[1]:
 - Assign from first queue instead of last queue
[1] https://lore.kernel.org/netdev/20230125101423.7b9590fe@kernel.org/T/#t

 drivers/net/ethernet/ibm/ibmvnic.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e19a6bb3f444..146ca1d8031b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -250,10 +250,11 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 	struct ibmvnic_sub_crq_queue **rxqs = adapter->rx_scrq;
 	struct ibmvnic_sub_crq_queue **txqs = adapter->tx_scrq;
 	struct ibmvnic_sub_crq_queue *queue;
-	int num_rxqs = adapter->num_active_rx_scrqs;
-	int num_txqs = adapter->num_active_tx_scrqs;
+	int num_rxqs = adapter->num_active_rx_scrqs, i_rxqs = 0;
+	int num_txqs = adapter->num_active_tx_scrqs, i_txqs = 0;
 	int total_queues, stride, stragglers, i;
 	unsigned int num_cpu, cpu;
+	bool is_rx_queue;
 	int rc = 0;
 
 	netdev_dbg(adapter->netdev, "%s: Setting irq affinity hints", __func__);
@@ -273,14 +274,24 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 	/* next available cpu to assign irq to */
 	cpu = cpumask_next(-1, cpu_online_mask);
 
-	for (i = 0; i < num_txqs; i++) {
-		queue = txqs[i];
+	for (i = 0; i < total_queues; i++) {
+		is_rx_queue = false;
+		/* balance core load by alternating rx and tx assignments
+		 * ex: TX0 -> RX0 -> TX1 -> RX1 etc.
+		 */
+		if ((i % 2 == 1 && i_rxqs < num_rxqs) || i_txqs == num_txqs) {
+			queue = rxqs[i_rxqs++];
+			is_rx_queue = true;
+		} else {
+			queue = txqs[i_txqs++];
+		}
+
 		rc = ibmvnic_set_queue_affinity(queue, &cpu, &stragglers,
 						stride);
 		if (rc)
 			goto out;
 
-		if (!queue)
+		if (!queue || is_rx_queue)
 			continue;
 
 		rc = __netif_set_xps_queue(adapter->netdev,
@@ -291,14 +302,6 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 				    __func__, i, rc);
 	}
 
-	for (i = 0; i < num_rxqs; i++) {
-		queue = rxqs[i];
-		rc = ibmvnic_set_queue_affinity(queue, &cpu, &stragglers,
-						stride);
-		if (rc)
-			goto out;
-	}
-
 out:
 	if (rc) {
 		netdev_warn(adapter->netdev,
-- 
2.31.1

