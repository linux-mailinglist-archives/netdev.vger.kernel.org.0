Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E279096BA5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbfHTVnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:43:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729900AbfHTVnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 17:43:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KLgAfu005888
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 17:43:07 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugpem6f8j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 17:43:06 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <julietk@linux.vnet.ibm.com>;
        Tue, 20 Aug 2019 22:43:05 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 22:43:03 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KLh2as13697604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 21:43:02 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D157AE05F;
        Tue, 20 Aug 2019 21:43:02 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34D78AE05C;
        Tue, 20 Aug 2019 21:43:02 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 21:43:02 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/2] net/ibmvnic: prevent more than one thread from running in reset
Date:   Tue, 20 Aug 2019 17:31:20 -0400
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190820213120.19880-1-julietk@linux.vnet.ibm.com>
References: <20190820213120.19880-1-julietk@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082021-0052-0000-0000-000003EC9434
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011625; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01249694; UDB=6.00659734; IPR=6.01031243;
 MB=3.00028250; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-20 21:43:04
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082021-0053-0000-0000-00006226BBCC
Message-Id: <20190820213120.19880-2-julietk@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code allows more than one thread to run in reset. This can 
corrupt struct adapter data. Check adapter->resetting before performing 
a reset, if there is another reset running delay (100 msec) before trying 
again.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 ++++++++++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h |  3 +++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a3e2fbb9c5db..7db7a44eeeb9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2049,6 +2049,13 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
 
+	if (adapter->resetting) {
+		schedule_delayed_work(&adapter->ibmvnic_delayed_reset,
+				      IBMVNIC_RESET_DELAY);
+		return;
+	}
+
+	adapter->resetting = true;
 	reset_state = adapter->state;
 
 	rwi = get_next_rwi(adapter);
@@ -2085,6 +2092,15 @@ static void __ibmvnic_reset(struct work_struct *work)
 	adapter->resetting = false;
 }
 
+static void __ibmvnic_delayed_reset(struct work_struct *work)
+{
+	struct ibmvnic_adapter *adapter;
+
+	adapter = container_of(work, struct ibmvnic_adapter,
+			       ibmvnic_delayed_reset.work);
+	__ibmvnic_reset(&adapter->ibmvnic_reset);
+}
+
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
@@ -2137,7 +2153,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-	adapter->resetting = true;
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
@@ -4910,6 +4925,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	spin_lock_init(&adapter->stats_lock);
 
 	INIT_WORK(&adapter->ibmvnic_reset, __ibmvnic_reset);
+	INIT_DELAYED_WORK(&adapter->ibmvnic_delayed_reset,
+			  __ibmvnic_delayed_reset);
 	INIT_LIST_HEAD(&adapter->rwi_list);
 	spin_lock_init(&adapter->rwi_lock);
 	init_completion(&adapter->init_done);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 70bd286f8932..0e1fadbcffc0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -38,6 +38,8 @@
 #define IBMVNIC_MAX_LTB_SIZE ((1 << (MAX_ORDER - 1)) * PAGE_SIZE)
 #define IBMVNIC_BUFFER_HLEN 500
 
+#define IBMVNIC_RESET_DELAY 100
+
 static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
 #define IBMVNIC_USE_SERVER_MAXES 0x1
 	"use-server-maxes"
@@ -1076,6 +1078,7 @@ struct ibmvnic_adapter {
 	spinlock_t rwi_lock;
 	struct list_head rwi_list;
 	struct work_struct ibmvnic_reset;
+	struct delayed_work ibmvnic_delayed_reset;
 	bool resetting;
 	bool napi_enabled, from_passive_init;
 
-- 
2.16.4

