Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75ED2BB93E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgKTWk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729034AbgKTWk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:56 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMXfro195146
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S1YeOM3UocK2Lmy7z6Dv9O/7aS4HjrG3gG398axVsZY=;
 b=WDjShMzPmZ+MqmBe02ACAIcOcZJIqP3Rmd+ccPpIiqy65555A4Uke7r3JnvoDl8GFvtE
 LPWTdifrhZ2kVsi9PLFKS/LEVICOrL640b9vu78MOqJeKTY24CLnaL8/nHTGS5r45YVn
 NJPRygLl0ogsIASIIXqp9Y+4ZeSIWxzvdHQL4yAwMSnCZAMLeZs45nIvGiBDJcv6MAoW
 VyJ0XxQEowU7+qEg3B3KkKzuUvILMthznNWepV25ptect6ZJW0l3tj0XLXr3cLsZdQ2L
 MdSG+UjGKSofjAQzILbDc1qubztkUfFmPTFDplDCHZV15dGVNp54hJOyELu8AJrgrHMo SQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34x0jpj3ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:54 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMasVH008087
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjn94uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:54 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMekMV6619730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:46 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E2A86E052;
        Fri, 20 Nov 2020 22:40:52 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 027F16E050;
        Fri, 20 Nov 2020 22:40:52 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:51 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 02/15] ibmvnic: process HMC disable command
Date:   Fri, 20 Nov 2020 16:40:36 -0600
Message-Id: <20201120224049.46933-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 suspectscore=1 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

Currently ibmvnic does not support the disable vnic command from the
Hardware Management Console. This patch enables ibmvnic to process
CRQ message 0x07, disable vnic adapter.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 40 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |  3 ++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index dcb23015b6b4..82074e503ba9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -109,6 +109,8 @@ static void release_crq_queue(struct ibmvnic_adapter *);
 static int __ibmvnic_set_mac(struct net_device *, u8 *);
 static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
+static void ibmvnic_disable(struct ibmvnic_adapter *adapter);
+static int ibmvnic_close(struct net_device *netdev);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1209,6 +1211,42 @@ static int ibmvnic_open(struct net_device *netdev)
 	return rc;
 }
 
+static void ibmvnic_disable(struct ibmvnic_adapter *adapter)
+{
+	struct list_head *entry, *tmp_entry;
+	struct net_device *netdev = adapter->netdev;
+	int rc = 0;
+
+	/* cancel all pending resets in the queue */
+	if (!list_empty(&adapter->rwi_list)) {
+		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list)
+			list_del(entry);
+	}
+
+	/* wait for current reset to finish */
+	flush_work(&adapter->ibmvnic_reset);
+	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
+
+	if (test_bit(0, &adapter->resetting) ||
+	    adapter->state == VNIC_PROBED ||
+	    adapter->state == VNIC_OPEN ||
+	    adapter->state == VNIC_OPENING) {
+		rc = ibmvnic_close(netdev);
+		/* Expect -EINVAL when crq is no longer active. Set link down
+		 * would fail.
+		 */
+		if (rc && rc != -EINVAL) {
+			netdev_err(netdev, "Failed to disable adapter, rc=%d\n", rc);
+			return;
+		}
+	} else {
+		netdev_dbg(netdev, "Disable adapter request ignored (state=%d)\n", adapter->state);
+		return;
+	}
+
+	netdev_dbg(netdev, "Adapter disabled\n");
+}
+
 static void clean_rx_pools(struct ibmvnic_adapter *adapter)
 {
 	struct ibmvnic_rx_pool *rx_pool;
@@ -4789,6 +4827,8 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		} else if (gen_crq->cmd == IBMVNIC_DEVICE_FAILOVER) {
 			dev_info(dev, "Backing device failover detected\n");
 			adapter->failover_pending = true;
+		} else if (gen_crq->cmd == IBMVNIC_DEVICE_DISABLE) {
+			ibmvnic_disable(adapter);
 		} else {
 			/* The adapter lost the connection */
 			dev_err(dev, "Virtual Adapter failed (rc=%d)\n",
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 217dcc7ded70..af68f85534bc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -834,10 +834,11 @@ enum ibmvnic_crq_type {
 	IBMVNIC_CRQ_XPORT_EVENT		= 0xFF,
 };
 
-enum ibmvfc_crq_format {
+enum ibmvnic_crq_format {
 	IBMVNIC_CRQ_INIT                 = 0x01,
 	IBMVNIC_CRQ_INIT_COMPLETE        = 0x02,
 	IBMVNIC_PARTITION_MIGRATED       = 0x06,
+	IBMVNIC_DEVICE_DISABLE		 = 0x07,
 	IBMVNIC_DEVICE_FAILOVER          = 0x08,
 };
 
-- 
2.23.0

