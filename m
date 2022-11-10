Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B434624D09
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiKJVco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKJVcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:32:42 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D2511C03
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:32:41 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALOGU6019067
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DCq/H4lrRyx8vOUwNrm8i6OkXcAvH4/173SmydRlDq4=;
 b=omTX36JH3SF6n1rgmlulur8yNJz/eKxZjZOORHiSPqomG+lhmLf/V9pvg16C6IT/xat/
 FYPz3r345+gJeEGgkbwI8wNjpKQO1qSstOPP3dkYXQMSX9GUKcwT+hH4A3tKLtOANCrl
 6XR+2DquehK0DkOB9cQ9pivd74OHW7p/FC109qsDcGRaGNY5AG2xjh4nor2ZD8p9XuKq
 2OxSnmSiMlUdzt9G1WOqFlCHFMtN6RpKQVpFgSZcrD7xqRAGjmWSzeYMOLH3RX56BgsQ
 B/knuAN8x8MGJSKatVPBSPwfv4gPPnscINJbnTN1w1p8ivoDt3Tnt87Uadfes/Y/ph+3 Ag== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ks968g5dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:40 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AALM9kF007363
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:40 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3kngnf6tcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:40 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AALWeUi35062338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:32:40 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18CC358062;
        Thu, 10 Nov 2022 21:32:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F35E58060;
        Thu, 10 Nov 2022 21:32:37 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.178.220])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 21:32:36 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 1/3] ibmvnic: Assign IRQ affinity hints to device queues
Date:   Thu, 10 Nov 2022 15:32:16 -0600
Message-Id: <20221110213218.28662-2-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110213218.28662-1-nnac123@linux.ibm.com>
References: <20221110213218.28662-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4YvMr0tZdNTmfhGfC7peyfFmfcRHmSJ5
X-Proofpoint-GUID: 4YvMr0tZdNTmfhGfC7peyfFmfcRHmSJ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 clxscore=1011 mlxscore=0 phishscore=0
 mlxlogscore=896 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign affinity hints to ibmvnic device queue interrupts.
Affinity hints are assigned and removed during sub-crq init and
teardown, respectively. This update should improve latency if
utilized as interrupt lines and processing are more equally
distributed among CPU's. This implementation is based on the
virtio_net driver.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
Reviewed-by: Haren Myneni <haren@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 140 +++++++++++++++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |   1 +
 2 files changed, 141 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9282381a438f..0c969bdaf94d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -68,6 +68,7 @@
 #include <linux/workqueue.h>
 #include <linux/if_vlan.h>
 #include <linux/utsname.h>
+#include <linux/cpu.h>
 
 #include "ibmvnic.h"
 
@@ -171,6 +172,132 @@ static int send_version_xchg(struct ibmvnic_adapter *adapter)
 	return ibmvnic_send_crq(adapter, &crq);
 }
 
+static void ibmvnic_clean_queue_affinity(struct ibmvnic_adapter *adapter,
+					 struct ibmvnic_sub_crq_queue *queue)
+{
+	if (!(queue && queue->irq))
+		return;
+
+	cpumask_clear(queue->affinity_mask);
+
+	if (irq_set_affinity_and_hint(queue->irq, NULL))
+		netdev_warn(adapter->netdev,
+			    "%s: Clear affinity failed, queue addr = %p, IRQ = %d\n",
+			    __func__, queue, queue->irq);
+}
+
+static void ibmvnic_clean_affinity(struct ibmvnic_adapter *adapter)
+{
+	struct ibmvnic_sub_crq_queue **rxqs;
+	struct ibmvnic_sub_crq_queue **txqs;
+	int num_rxqs, num_txqs;
+	int rc, i;
+
+	rc = 0;
+	rxqs = adapter->rx_scrq;
+	txqs = adapter->tx_scrq;
+	num_txqs = adapter->num_active_tx_scrqs;
+	num_rxqs = adapter->num_active_rx_scrqs;
+
+	netdev_dbg(adapter->netdev, "%s: Cleaning irq affinity hints", __func__);
+	if (txqs) {
+		for (i = 0; i < num_txqs; i++)
+			ibmvnic_clean_queue_affinity(adapter, txqs[i]);
+	}
+	if (rxqs) {
+		for (i = 0; i < num_rxqs; i++)
+			ibmvnic_clean_queue_affinity(adapter, rxqs[i]);
+	}
+}
+
+static int ibmvnic_set_queue_affinity(struct ibmvnic_sub_crq_queue *queue,
+				      unsigned int *cpu, int *stragglers,
+				      int stride)
+{
+	cpumask_var_t mask;
+	int i;
+	int rc = 0;
+
+	if (!(queue && queue->irq))
+		return rc;
+
+	/* cpumask_var_t is either a pointer or array, allocation works here */
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	/* while we have extra cpu give one extra to this irq */
+	if (*stragglers) {
+		stride++;
+		(*stragglers)--;
+	}
+	/* atomic write is safer than writing bit by bit directly */
+	for (i = 0; i < stride; i++) {
+		cpumask_set_cpu(*cpu, mask);
+		*cpu = cpumask_next_wrap(*cpu, cpu_online_mask,
+					 nr_cpu_ids, false);
+	}
+	/* set queue affinity mask */
+	cpumask_copy(queue->affinity_mask, mask);
+	rc = irq_set_affinity_and_hint(queue->irq, queue->affinity_mask);
+	free_cpumask_var(mask);
+
+	return rc;
+}
+
+/* assumes cpu read lock is held */
+static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
+{
+	struct ibmvnic_sub_crq_queue **rxqs = adapter->rx_scrq;
+	struct ibmvnic_sub_crq_queue **txqs = adapter->tx_scrq;
+	struct ibmvnic_sub_crq_queue *queue;
+	int num_rxqs = adapter->num_active_rx_scrqs;
+	int num_txqs = adapter->num_active_tx_scrqs;
+	int total_queues, stride, stragglers, i;
+	unsigned int num_cpu, cpu;
+	int rc = 0;
+
+	netdev_dbg(adapter->netdev, "%s: Setting irq affinity hints", __func__);
+	if (!(adapter->rx_scrq && adapter->tx_scrq)) {
+		netdev_warn(adapter->netdev,
+			    "%s: Set affinity failed, queues not allocated\n",
+			    __func__);
+		return;
+	}
+
+	total_queues = num_rxqs + num_txqs;
+	num_cpu = num_online_cpus();
+	/* number of cpu's assigned per irq */
+	stride = max_t(int, num_cpu / total_queues, 1);
+	/* number of leftover cpu's */
+	stragglers = num_cpu >= total_queues ? num_cpu % total_queues : 0;
+	/* next available cpu to assign irq to */
+	cpu = cpumask_next(-1, cpu_online_mask);
+
+	for (i = 0; i < num_txqs; i++) {
+		queue = txqs[i];
+		rc = ibmvnic_set_queue_affinity(queue, &cpu, &stragglers,
+						stride);
+		if (rc)
+			goto out;
+	}
+
+	for (i = 0; i < num_rxqs; i++) {
+		queue = rxqs[i];
+		rc = ibmvnic_set_queue_affinity(queue, &cpu, &stragglers,
+						stride);
+		if (rc)
+			goto out;
+	}
+
+out:
+	if (rc) {
+		netdev_warn(adapter->netdev,
+			    "%s: Set affinity failed, queue addr = %p, IRQ = %d, rc = %d.\n",
+			    __func__, queue, queue->irq, rc);
+		ibmvnic_clean_affinity(adapter);
+	}
+}
+
 static long h_reg_sub_crq(unsigned long unit_address, unsigned long token,
 			  unsigned long length, unsigned long *number,
 			  unsigned long *irq)
@@ -3626,6 +3753,8 @@ static int reset_sub_crq_queues(struct ibmvnic_adapter *adapter)
 	if (!adapter->tx_scrq || !adapter->rx_scrq)
 		return -EINVAL;
 
+	ibmvnic_clean_affinity(adapter);
+
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Re-setting tx_scrq[%d]\n", i);
 		rc = reset_one_sub_crq_queue(adapter, adapter->tx_scrq[i]);
@@ -3675,6 +3804,7 @@ static void release_sub_crq_queue(struct ibmvnic_adapter *adapter,
 	dma_unmap_single(dev, scrq->msg_token, 4 * PAGE_SIZE,
 			 DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)scrq->msgs, 2);
+	free_cpumask_var(scrq->affinity_mask);
 	kfree(scrq);
 }
 
@@ -3695,6 +3825,8 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 		dev_warn(dev, "Couldn't allocate crq queue messages page\n");
 		goto zero_page_failed;
 	}
+	if (!zalloc_cpumask_var(&scrq->affinity_mask, GFP_KERNEL))
+		goto cpumask_alloc_failed;
 
 	scrq->msg_token = dma_map_single(dev, scrq->msgs, 4 * PAGE_SIZE,
 					 DMA_BIDIRECTIONAL);
@@ -3747,6 +3879,8 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 	dma_unmap_single(dev, scrq->msg_token, 4 * PAGE_SIZE,
 			 DMA_BIDIRECTIONAL);
 map_failed:
+	free_cpumask_var(scrq->affinity_mask);
+cpumask_alloc_failed:
 	free_pages((unsigned long)scrq->msgs, 2);
 zero_page_failed:
 	kfree(scrq);
@@ -3758,6 +3892,7 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 {
 	int i;
 
+	ibmvnic_clean_affinity(adapter);
 	if (adapter->tx_scrq) {
 		for (i = 0; i < adapter->num_active_tx_scrqs; i++) {
 			if (!adapter->tx_scrq[i])
@@ -4035,6 +4170,11 @@ static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter)
 			goto req_rx_irq_failed;
 		}
 	}
+
+	cpus_read_lock();
+	ibmvnic_set_affinity(adapter);
+	cpus_read_unlock();
+
 	return rc;
 
 req_rx_irq_failed:
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index e5c6ff3d0c47..6720fec1ae67 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -825,6 +825,7 @@ struct ibmvnic_sub_crq_queue {
 	atomic_t used;
 	char name[32];
 	u64 handle;
+	cpumask_var_t affinity_mask;
 } ____cacheline_aligned;
 
 struct ibmvnic_long_term_buff {
-- 
2.31.1

