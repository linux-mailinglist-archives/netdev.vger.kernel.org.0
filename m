Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B083E2C19B7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgKWX65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728487AbgKWX6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:55 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNW4Zr082122
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=W3a1v+EC6qe1z8aUcDcx45+aS6a1eR9nyebqeHWxC2o=;
 b=Uwv9fP07tF6YpXZoeHuLHkJIHcQCsUfGoZGpIVg38NM5jQpbloFelXxrIavxYipGfqan
 MSRW4We9AKe4rz7bjkHj/7BHBWMBd6M2MkZmAbL4Z6d7INguzoIuvQ4uLr49Yho56lvu
 Vd7Qjsbq23cG6wz3aGO4lDNkTbTBRuO1g0ESxgeTYkNzR0mZ6H4frTn6Aee2t2mIS6VZ
 SKf6QprUNgmcHgWVVwhI9FyHnMxAvKhnoC+EHVU9nbQ6gXgywiaJ4rVtXplBurYnP0qD
 3mqyuURPeH9lFJ04GVbJ7PEnOMz51D1UHKlcDiWNqvLsC721g5f5/e1IeX8m90haEL1U dg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350ga2dcrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:55 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNwdbw007380
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 34xth8ysu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:54 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwr2F21431196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:53 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F1EB124053;
        Mon, 23 Nov 2020 23:58:53 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11836124052;
        Mon, 23 Nov 2020 23:58:53 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:52 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net-next v2] ibmvnic: process HMC disable command
Date:   Mon, 23 Nov 2020 18:58:41 -0500
Message-Id: <20201123235841.6515-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=1 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ibmvnic does not support the "Disable vNIC" command from
the Hardware Management Console. The HMC uses this command to disconnect
the adapter from the network if the adapter is misbehaving or sending
malicious traffic. The effect of this command is equivalent to setting
the link to the "down" state on the linux client.

Enable support in ibmvnic driver for the Disable vNIC command.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
V2 changes based on Jakub Kicinski's feedback:
- Broke from "[PATCH net 00/15] ibmvnic: assorted bug fixes" sent by Lijun Pan.
- Expanded on the description
- Submitting to net-next
---
 drivers/net/ethernet/ibm/ibmvnic.c | 40 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |  3 ++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 63b39744a07a..47446e5f8ec5 100644
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
@@ -1207,6 +1209,42 @@ static int ibmvnic_open(struct net_device *netdev)
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
@@ -4825,6 +4863,8 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		} else if (gen_crq->cmd == IBMVNIC_DEVICE_FAILOVER) {
 			dev_info(dev, "Backing device failover detected\n");
 			adapter->failover_pending = true;
+		} else if (gen_crq->cmd == IBMVNIC_DEVICE_DISABLE) {
+			ibmvnic_disable(adapter);
 		} else {
 			/* The adapter lost the connection */
 			dev_err(dev, "Virtual Adapter failed (rc=%d)\n",
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b21092f5f9c1..d15866cbc2a6 100644
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
2.26.2

