Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE3E678A9D
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjAWWR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAWWR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:17:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAEDEC5C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:17:56 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLFnIV015001
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/mQsbsgGdXZt5fXO2hhdnqBD41cUv/HTX1FIdWJcQ3Q=;
 b=XsJ9yOChC6W76JJw0YsFFNzifdUuRPmvmlBM6QDnwUW98ZPpT7mLnt1dyQiSKEDM06TK
 dEiQ3jCKfJtuo86p1+HVVUqLB0coNuXmD7LGvzTz6cI7MG3S3YrLT4tg1duUrbAd5Yyg
 K6cuc2FhgAEYEYd5WqlxwHj/uiQiS6Jk9bgvYIeQEKeE85ra7VzuDKkf+qHsr9Dn3wy1
 4MIHDnK527Ejwmy/4+js5vM7f3ii6SARv2v8rSRaw4ysVfqeeJafpBs0iYaFeBIplUng
 438HdcPcMbPyaE5bUog5eAjN1Noi/wqVL34h2Q8ov0spDI0/vcFWiCcZOBC9GZaDvW0n JA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3na20ghe8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:17:55 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30NKg0s6025680
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:17:55 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3n87p7adtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:17:54 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NMHpg954198634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:17:51 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0185805C;
        Mon, 23 Jan 2023 22:17:51 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1625158059;
        Mon, 23 Jan 2023 22:17:50 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.160.97.87])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 22:17:49 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: Toggle between queue types in affinity mapping
Date:   Mon, 23 Jan 2023 16:17:27 -0600
Message-Id: <20230123221727.30423-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nyjgSXyRwMmdSQKXgKBC7QZBQ7PaMOuG
X-Proofpoint-ORIG-GUID: nyjgSXyRwMmdSQKXgKBC7QZBQ7PaMOuG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=984 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230209
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
pattern (binding is done in reverse order for readable code):

IRQ type |  CPU number
-----------------------
TX15	 |	0-1
RX15	 |	2-3
TX14	 |	4-5
RX14	 |	6-7
<etc>

Observe that in SMT-8, there is equal distribution of RX and TX IRQs
per core. In the above case, each core handles 2 TX and 2 RX IRQ's.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Haren Myneni <haren@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e19a6bb3f444..314a72cef592 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -254,6 +254,7 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 	int num_txqs = adapter->num_active_tx_scrqs;
 	int total_queues, stride, stragglers, i;
 	unsigned int num_cpu, cpu;
+	bool is_rx_queue;
 	int rc = 0;
 
 	netdev_dbg(adapter->netdev, "%s: Setting irq affinity hints", __func__);
@@ -273,14 +274,22 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 	/* next available cpu to assign irq to */
 	cpu = cpumask_next(-1, cpu_online_mask);
 
-	for (i = 0; i < num_txqs; i++) {
-		queue = txqs[i];
+	for (i = 0; i < total_queues; i++) {
+		is_rx_queue = false;
+		/* balance core load by alternating rx and tx assignments */
+		if ((i % 2 == 1 && num_rxqs > 0) || num_txqs == 0) {
+			queue = rxqs[--num_rxqs];
+			is_rx_queue = true;
+		} else {
+			queue = txqs[--num_txqs];
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
@@ -291,14 +300,6 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
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

