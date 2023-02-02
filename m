Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7450D688950
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbjBBV4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBV4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:56:02 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC5565355
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 13:56:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEFnggO54DYv9e65LXCvF2paOTvcVMh2Ru22V8h4ulvP1Yrq8XeZtl0ZuYBv0HDxZcGarr/YYTr5gNnxynX1KOGJbkI6Fdr9Rgvr57CY0j6r9qs02ouJ6WW7Y1OL5vLXGLyYzbjwX3p/sw/nuvyoCq3yBFR2d4nv0C+ojHukK8W3+aaW5pMO3qNYwuqJD/p0jfl1K8oXgdvO/9MmjhbdBHRjsu779FJWeanfm3w5aoFy8JkUeKW3PrPOLGe/1+/XbJY51msw4++C20ex6xbDRhaghtZmQfeAQ4YgSv6gKgl55ydo1wsKCrxN5xz/+1wh49JUmFuSAHfL0dymJqt3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QhUSExTwynUmNcs6vD1oXZ/F7BZ+3XNTkLx0dOHJ48=;
 b=kFDwGOJX3ZaUEXgZkLLFMAStUR9sGHfBB1AKjxDmCdKrYehiWHAcYiDJDPLSlQh3sgeb+j+Bch2gBvywp+rfY/IHkRiM1biqcM5rPTtirfJKw9QAVkJ5hgrpfIMUuGt9FSKTUk+2WVcqLGdp4qkRbJe4V8SRnecr2n1PyAeb9umeVKhl96KiwUIu4OQOot/hipyxn4ycjP0cIYQ49eXixgn7Cf6n44SzOPiDRSV5hwqn4o186EPe46P2tAp2HxDQLf+VyxOVAnNmAuqFHweWo44qbxgoj646K2qx0OxEw/CHYDHtguJvPW8PKQpMv1XLyB4WO3JWZkDU7O/GgSFnxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QhUSExTwynUmNcs6vD1oXZ/F7BZ+3XNTkLx0dOHJ48=;
 b=gkgqWXM8mpnfs3UQg5Yk8a/SN4NJU35DgFUSpYNZvsy/gfxt8dPFAi2+g0jnIrc3I8iEKFPM7AWctkX/4GsnQ0h/niSByEzm7yVeRf68gqUdBySD9fWUbmfmFQ/zAk0Hca9JFmrgSgIHrQFOi0/wGf9BesXVCsW842+RHM4qgb0=
Received: from MW4PR04CA0129.namprd04.prod.outlook.com (2603:10b6:303:84::14)
 by MW4PR12MB6949.namprd12.prod.outlook.com (2603:10b6:303:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 21:55:57 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::46) by MW4PR04CA0129.outlook.office365.com
 (2603:10b6:303:84::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 21:55:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 21:55:57 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 15:55:55 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Allen Hubbe <allen.hubbe@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net 3/3] ionic: missed doorbell workaround
Date:   Thu, 2 Feb 2023 13:55:37 -0800
Message-ID: <20230202215537.69756-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202215537.69756-1-shannon.nelson@amd.com>
References: <20230202215537.69756-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|MW4PR12MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b0aa3d9-f85f-4391-2180-08db056843f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfJRUNVUr7EP96/Vi1EZmaHw6/6EgaSyMzFnk+56VDu5wLUAAiQQFzxYt38cgwfRJzJYj3H0P7kw47NQN7kWHmW8egxxhOFAZ+e6EYNKvzg/gyaImxH+HCmbO1LjsCFdKVnriZ0TgGeKQMrPt5a3EmklS61mW/q7T3XIw+qYduyU0Rpgqv8OdrIeIwyvNxGnjRqIWi0HDWSliOp6IcjJhmvEUQlVFav1Ua6QUy9h5WrEwVwe80y3DFSc0JXZIrvfeMjTmyRfvnAS1ONDXDd1V3VQMTEEsBxq5UZSkE8zX6f1pc3enYsPcikgFak8wP7ko812zxrEEnWPnKXiBELbsj0y8nHm78hfFyMdWeHTmAsTDdoF8W9w9kZZUmsW1v2JET0S5kqmMCkmgfBFFoNKdNqWIdJcyy2TedSM45EgJQy95Y39RPnQ9/6V4HnCdSGvRgRsD/ySxh6vwRVoUBYpSJXzlhRQ/521zn6F6/k1Sz+h1Td4bCDqk32zOjdd6SBq+6zIPF/Jud++rRdc2o0tzxn9NoCbUNGfcFHPY5sy1bu2sc/zv2TMtOe5UocfpWyaivsKAFcmaGY8vFq5vVHviZk0geVFINMgIr8WGMadZI2jscenxwIkJLSunv+QAdX/Q+yesUCivb0U6LVBXe9emLc9bWDdzEeJbXmkuXXYOLQ8xuMtFjAu/VZkSet3Y0OJi3TUnJteBo1ob8dIwhOc0VM9mbiPLJo/oj4CSowxs+g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(478600001)(47076005)(16526019)(2616005)(186003)(1076003)(426003)(40460700003)(83380400001)(6666004)(26005)(336012)(5660300002)(44832011)(30864003)(2906002)(36756003)(82310400005)(316002)(8676002)(54906003)(110136005)(40480700001)(41300700001)(8936002)(4326008)(70586007)(70206006)(81166007)(82740400003)(356005)(36860700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 21:55:57.6239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0aa3d9-f85f-4391-2180-08db056843f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6949
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Hubbe <allen.hubbe@amd.com>

In one version of the HW there is a remote possibility that it
will miss the doorbell ring.  This adds a bit of protection to
be sure we don't stall a queue from a missed doorbell.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  9 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 12 +++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 ++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 29 +++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 87 ++++++++++++++++++-
 6 files changed, 176 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 626b9113e7c4..d911f4fd9af6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -708,9 +708,16 @@ void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		q->lif->index, q->name, q->hw_type, q->hw_index,
 		q->head_idx, ring_doorbell);
 
-	if (ring_doorbell)
+	if (ring_doorbell) {
 		ionic_dbell_ring(lif->kern_dbpage, q->hw_type,
 				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = jiffies;
+
+		if (q_to_qcq(q)->napi_qcq)
+			mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+				  jiffies + IONIC_NAPI_DEADLINE);
+	}
 }
 
 static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 2a1d7b9c07e7..bce3ca38669b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -25,6 +25,12 @@
 #define IONIC_DEV_INFO_REG_COUNT	32
 #define IONIC_DEV_CMD_REG_COUNT		32
 
+#define IONIC_NAPI_DEADLINE		(HZ / 200)	/* 5ms */
+#define IONIC_ADMIN_DOORBELL_DEADLINE	(HZ / 2)	/* 500ms */
+#define IONIC_TX_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MIN_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MAX_DOORBELL_DEADLINE	(HZ * 5)	/* 5s */
+
 struct ionic_dev_bar {
 	void __iomem *vaddr;
 	phys_addr_t bus_addr;
@@ -216,6 +222,8 @@ struct ionic_queue {
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
 	u64 dbval;
+	unsigned long dbell_deadline;
+	unsigned long dbell_jiffies;
 	u16 head_idx;
 	u16 tail_idx;
 	unsigned int index;
@@ -361,4 +369,8 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 int ionic_heartbeat_check(struct ionic *ionic);
 bool ionic_is_fw_running(struct ionic_dev *idev);
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q);
+bool ionic_txq_poke_doorbell(struct ionic_queue *q);
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e51d8be7911c..63a78a9ac241 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -16,6 +16,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_dev.h"
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 #include "ionic_ethtool.h"
@@ -200,6 +201,13 @@ void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
 	}
 }
 
+static void ionic_napi_deadline(struct timer_list *timer)
+{
+	struct ionic_qcq *qcq = container_of(timer, struct ionic_qcq, napi_deadline);
+
+	napi_schedule(&qcq->napi);
+}
+
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -325,6 +333,7 @@ static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int f
 		synchronize_irq(qcq->intr.vector);
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		napi_disable(&qcq->napi);
+		del_timer_sync(&qcq->napi_deadline);
 	}
 
 	/* If there was a previous fw communcation error, don't bother with
@@ -460,6 +469,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 
 	n_qcq->intr.vector = src_qcq->intr.vector;
 	n_qcq->intr.index = src_qcq->intr.index;
+	n_qcq->napi_qcq = src_qcq->napi_qcq;
 }
 
 static int ionic_alloc_qcq_interrupt(struct ionic_lif *lif, struct ionic_qcq *qcq)
@@ -784,8 +794,14 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
-	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+	q->dbell_deadline = IONIC_TX_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi);
+		qcq->napi_qcq = qcq;
+		timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+	}
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -839,11 +855,17 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi);
 	else
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -1161,6 +1183,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev = &lif->ionic->idev;
 	unsigned long irqflags;
 	unsigned int flags = 0;
+	bool resched = false;
 	int rx_work = 0;
 	int tx_work = 0;
 	int n_work = 0;
@@ -1198,6 +1221,16 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 		ionic_intr_credits(idev->intr_ctrl, intr->index, credits, flags);
 	}
 
+	if (!a_work && ionic_adminq_poke_doorbell(&lif->adminqcq->q))
+		resched = true;
+	if (lif->hwstamp_rxq && !rx_work && ionic_rxq_poke_doorbell(&lif->hwstamp_rxq->q))
+		resched = true;
+	if (lif->hwstamp_txq && !tx_work && ionic_txq_poke_doorbell(&lif->hwstamp_txq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&lif->adminqcq->napi_deadline,
+			  jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -3256,8 +3289,14 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	dev_dbg(dev, "adminq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "adminq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_ADMIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	napi_enable(&qcq->napi);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a53984bf3544..734519895614 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -74,8 +74,10 @@ struct ionic_qcq {
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
+	struct timer_list napi_deadline;
 	struct napi_struct napi;
 	unsigned int flags;
+	struct ionic_qcq *napi_qcq;
 	struct dentry *dentry;
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a13530ec4dd8..08c42b039d92 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -289,6 +289,35 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 	complete_all(&ctx->work);
 }
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q)
+{
+	struct ionic_lif *lif = q->lif;
+	unsigned long now, then, dif;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
+
+	if (q->tail_idx == q->head_idx) {
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+
+	return true;
+}
+
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
 	struct ionic_desc_info *desc_info;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0c3977416cd1..f761780f0162 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -22,6 +22,67 @@ static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
 
+bool ionic_txq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+	struct netdev_queue *netdev_txq;
+	struct net_device *netdev;
+
+	netdev = q->lif->netdev;
+	netdev_txq = netdev_get_tx_queue(netdev, q->index);
+
+	HARD_TX_LOCK(netdev, netdev_txq, smp_processor_id());
+
+	if (q->tail_idx == q->head_idx) {
+		HARD_TX_UNLOCK(netdev, netdev_txq);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	HARD_TX_UNLOCK(netdev, netdev_txq);
+
+	return true;
+}
+
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+
+	/* no lock, called from rx napi or txrx napi, nothing else can fill */
+
+	if (q->tail_idx == q->head_idx)
+		return false;
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+
+		dif = 2 * q->dbell_deadline;
+		if (dif > IONIC_RX_MAX_DOORBELL_DEADLINE)
+			dif = IONIC_RX_MAX_DOORBELL_DEADLINE;
+
+		q->dbell_deadline = dif;
+	}
+
+	return true;
+}
+
 static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 {
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
@@ -424,6 +485,12 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 	ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
 			 q->dbval | q->head_idx);
+
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+		  jiffies + IONIC_NAPI_DEADLINE);
 }
 
 void ionic_rx_empty(struct ionic_queue *q)
@@ -511,6 +578,9 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_txq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -544,23 +614,29 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_rxq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
 int ionic_txrx_napi(struct napi_struct *napi, int budget)
 {
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_qcq *rxqcq = napi_to_qcq(napi);
 	struct ionic_cq *rxcq = napi_to_cq(napi);
 	unsigned int qi = rxcq->bound_q->index;
+	struct ionic_qcq *txqcq;
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
+	bool resched = false;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
+	txqcq = lif->txqcqs[qi];
 	txcq = &lif->txqcqs[qi]->cq;
 
 	tx_work_done = ionic_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT,
@@ -572,7 +648,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
-		ionic_dim_update(qcq, 0);
+		ionic_dim_update(rxqcq, 0);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		rxcq->bound_intr->rearm_count++;
 	}
@@ -583,6 +659,13 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 				   tx_work_done + rx_work_done, flags);
 	}
 
+	if (!rx_work_done && ionic_rxq_poke_doorbell(&rxqcq->q))
+		resched = true;
+	if (!tx_work_done && ionic_txq_poke_doorbell(&txqcq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&rxqcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return rx_work_done;
 }
 
-- 
2.17.1

