Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2AA42DFD4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhJNRFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:05:17 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:20865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhJNRFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:05:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ba7QARNQLsrAWm3/yHLlNJkzq0av/9Lv4n5CPaKl0nStQKuqhXhfssq9Fx6F8Qod0VFULgHBo7WjLB9mzC8gxnyNeqEXEEabWlKRwk+YmGvPQHl0ZY7WTxV/9B9yJflrH/MOS/2zwoG6qZyDrKZl+BJ/R/rTpx9slLJwAeXzeJzdF4cUbS5UJ2gFjyqrFulx8EuF3HpSvoWb+1+wPjwvoe1++xWadLxcybTx8melUFMd6EzwO6/NCNFZrQ2w7/xVtJdEZ0J8QvNsbIJ3RomPu17WMLuBd9BayrQLA6tcEySSvTEEh99ENXhstK5WGlWCqJQNCJz1cHNwZnKP7t9LGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tD02XYiXEQj1av6QF9F5XF+1V5lt7LbSfkOHfJbIzU0=;
 b=bR336vWgdcpEBcwv89N1zyQJJAolaD9xYZ9mpBs+C8VCGvJ1Scve/7D/kfNM2Cz2YTgicRYoJly0HjrUwlCXam5o9c2+je/M7cTf859i/bdpDSgWhlFjpoRnKssuntQ0901zWGL58bTuag1AS8sRJt8S95V2Ri83Fp/Frmg51mv1P+09AnjqvlFDFT44XWWdaO6zTYiT10XMpUlvI8ftySmRQ8ej7AMSk+SWXiyJ0K5tWdhDN0Z7JyrK+BN/kzY8YbeGAdY2CpupPWQG2XCU6hFRYgwkLwpcdmTT+DPfMrOlY1GO5uHIvosnXWAyBqnXjofZ9zj4n2xnjp0MScmoXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tD02XYiXEQj1av6QF9F5XF+1V5lt7LbSfkOHfJbIzU0=;
 b=FG4qS2q4XFp4DDjHSNYNNJrtfaRcD9tEfMIQZ5hfRBsFqEoT/H0o97gktPeeLQd63tWQcP4zqXq1GlGm2u+knuyRAVXtNoTNedlCpFaEiLFgT8zLb/Tn2Joc/+j5C4CAtGKTlIlz8+23vLA0MRmvy+ZdqWulfKuDddUWGV92Nx4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5825.eurprd04.prod.outlook.com
 (2603:10a6:208:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 14 Oct
 2021 17:03:01 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:03:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/5] soc: fsl: dpio: add Net DIM integration
Date:   Thu, 14 Oct 2021 20:02:14 +0300
Message-Id: <20211014170215.132687-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014170215.132687-1-ioana.ciornei@nxp.com>
References: <20211014170215.132687-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa6d3009-0051-4805-949f-08d98f347a95
X-MS-TrafficTypeDiagnostic: AM0PR04MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5825F760950346D996D50CF6E0B89@AM0PR04MB5825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OlFh40AdkxvaE+bYc4/1cQvOsxJr14THHVrBxiQkaBG238MUChQ9U8bDZk57rxT956NMNGRNVjqjQbDrOs7LUGOMB/pBOeuVM6wG+BwIfuwxgoWQPEfiF9jRXvstp7Vs780uJx4xcUqrV4ZE40pe6IvEmPD4DBn+bNJ2GOzVvhJm2EDr7cNyeIi6ONHkAGv0G+ZjiGja3ArBh7rDeoQaVtqDXLLiumlqhsu5KxLc18wVw+N0vmPw2b3OWf6gYGXYA1J8o2407+bAK4d71ewSQvHskAD+mLOuAWebeW06wliwhRJdV4v0hB0RyJ3LunvzLGlisdsHQS+dGnghFf+21rghg3NknoPQMYoFEifcAc9rDn51DGBY4p3FeKVH+kDJt2J5Pz+w3XAE4Ce6DfCMhm4ovzOLPrMefk2bl3+gnRytR6A7n0MWJLAWIZ23liEjPbcu88r9n7P2cTEDd9xu0qeLUv2wvja5YvSzbPxDtx8GBBdtm8gFgUW3M8vCofLjgvvLR5yZOdD6bpfI0UKdKLKKtV0EwThTxeNhbDY0WrOz+aBLsy5bHE9LbygyS1lnOrVCvYlt8zVSU6eP2FyZkPi5U4+VGeSW0/P6b0loKyoDOdjiaZKD3GFDBsND4LzpUXM37g6j/40UioaSEP4fxcK8R2oJIVddECOiDuki3roZdHo89r41DQ9v54SYlYj+0VXc8s0rl0BB0T1l93jnFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(2616005)(956004)(1076003)(8936002)(6666004)(66476007)(186003)(316002)(36756003)(8676002)(4326008)(26005)(2906002)(6506007)(38350700002)(66556008)(52116002)(86362001)(44832011)(38100700002)(83380400001)(66946007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q6fEGbSB3Ct1VE6OtGueMkXwy0abstRu3vURWRYnuMHRcp5gTPGwBws5Z5H2?=
 =?us-ascii?Q?xzSe6pVomv3o8fgWHB1FYI9w1fQCvdSrLp8yVXMFzYJMm2RdKjpIoS2pxbez?=
 =?us-ascii?Q?huLaNwFatEQauXOr7mm2I82QY8RYn2K+AAcqidgi3sxSGEkgKV4ccGJruL0y?=
 =?us-ascii?Q?0U8UTI5kd3L7AHSMbinb+6DI1qX8X4NmwDcYqw8HahJOyLU94B/7n/w2C83N?=
 =?us-ascii?Q?Vn/c9D3Igb3YllDoX2keNB2OcIseu6Aczw6AzbHngDR8ieEaSeEAV/WaY2Mw?=
 =?us-ascii?Q?gJb2XLrV4Xm+kmYmC5dgp2VjJP6knwg6u0h6eUyFyIGo/7G0gRvQZMrT101l?=
 =?us-ascii?Q?/twrG8desssnifq0MHBGXR8Heuak4NBXpY0Zz1tSZmfpRtOTEXxovi/C166b?=
 =?us-ascii?Q?toDXnOrDr9fMsvfEOgMGQ4fILTTNg8IBEjMYZloKpF1Kf82OFleoGvTwb+E+?=
 =?us-ascii?Q?NO/JEOG3EhX2k/+V0mDftWHO2+UbIwCkDAeJBbF35Ub660HQrx32ZBt14zhI?=
 =?us-ascii?Q?KPsNkt4wMeFloY0urRkMe5jF5pSBBwLmAYgAltE7K9rHyDaOrFJVqthh+MHq?=
 =?us-ascii?Q?U+IAD8v67lmQa3UFUApwghbzy4H7PIQV94gy+MjT+UHOxlzfwKp66fUMwAco?=
 =?us-ascii?Q?wO8w++FwyhbtFVTpdtH5s1u2JRZfkFP7+Ak48B5CzD9o4Vv1r17t3ozKzKf1?=
 =?us-ascii?Q?Kvirk8Cq6o6l7alT3RTMjtiOHfeprUQR+mjwt36c7iZzzH39ANAmmAsbx9wn?=
 =?us-ascii?Q?uIaYmp3UZWlf8IKARNFV+7SpaQSOrEIEYoWCrBLPOj0iokcK6LVWVbDXJoDc?=
 =?us-ascii?Q?ovWv3uhCn42jWTThwRNDgOoAcjooYxcC7VumIRwE7C+Zx2EWaZhiyteTk8Hq?=
 =?us-ascii?Q?Lv5hHwnYrT1o+zStqouRRU7o+t6CtqruiaQdFWWuHPooIKf1NZ3AYJFBWcI7?=
 =?us-ascii?Q?4hngjgl88f/ShkPQ6tmLcaJu4HcOhKc6EWlAun3+7QYeG71BBxnNaMZL3dCM?=
 =?us-ascii?Q?r4I4TRKKq7r6aqprU1/UyRZgl59q8vl1Fxj8LbyArh+LDws/Hg4DO+7TDDwd?=
 =?us-ascii?Q?0vQJNyekIiD4oyVDYsh49zy2uBenVDsoqBLEvadxm/Y5Cg7uALXDnodmJjuU?=
 =?us-ascii?Q?RE50zN0wBeJ239Ahvif8lDCIwjEr0B5uCE4U/+qxwbAwk+Jr+r7lfXPsIf0U?=
 =?us-ascii?Q?cSGmiVA35ppIEX7LYYyJHU1AYpkQ3r5ee41IVBU/E/ey3DP/nGYFS7X6Yees?=
 =?us-ascii?Q?enPVpV5f+eQSrfxVV2PBkj8tFQHI8Z7Ug/jiS593k8q67u3qZBcEJ+OEq9vQ?=
 =?us-ascii?Q?PJBLjKwkq19+r+xD34myxcXW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6d3009-0051-4805-949f-08d98f347a95
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:03:00.9219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkNZmDv8jKF5zahG/WLLDHBNEGiC5tH8oLCNIx5BQ0fscylf7Mc9aIs5Vgb0CrWA2WKnh6OfI5wdjG0MKrCSlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the generic dynamic interrupt moderation (dim) framework to
implement adaptive interrupt coalescing on Rx. With the per-packet
interrupt scheme, a high interrupt rate has been noted for moderate
traffic flows leading to high CPU utilization.

The dpio driver exports new functions to enable/disable adaptive IRQ
coalescing on a DPIO object, to query the state or to update Net DIM
with a new set of bytes and frames dequeued.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/soc/fsl/Kconfig             |  1 +
 drivers/soc/fsl/dpio/dpio-service.c | 79 +++++++++++++++++++++++++++++
 drivers/soc/fsl/dpio/qbman-portal.h |  1 +
 include/soc/fsl/dpaa2-io.h          |  5 +-
 4 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
index 4df32bc4c7a6..07d52cafbb31 100644
--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select DIMLIB
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and
 	  buffer management facilities for software to interact with
diff --git a/drivers/soc/fsl/dpio/dpio-service.c b/drivers/soc/fsl/dpio/dpio-service.c
index 44fafed045ca..3fd0d0840287 100644
--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
+#include <linux/dim.h>
 #include <linux/slab.h>
 
 #include "dpio.h"
@@ -28,6 +29,14 @@ struct dpaa2_io {
 	spinlock_t lock_notifications;
 	struct list_head notifications;
 	struct device *dev;
+
+	/* Net DIM */
+	struct dim rx_dim;
+	/* protect against concurrent Net DIM updates */
+	spinlock_t dim_lock;
+	u16 event_ctr;
+	u64 bytes;
+	u64 frames;
 };
 
 struct dpaa2_io_store {
@@ -100,6 +109,17 @@ struct dpaa2_io *dpaa2_io_service_select(int cpu)
 }
 EXPORT_SYMBOL_GPL(dpaa2_io_service_select);
 
+static void dpaa2_io_dim_work(struct work_struct *w)
+{
+	struct dim *dim = container_of(w, struct dim, work);
+	struct dim_cq_moder moder =
+		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	struct dpaa2_io *d = container_of(dim, struct dpaa2_io, rx_dim);
+
+	dpaa2_io_set_irq_coalescing(d, moder.usec);
+	dim->state = DIM_START_MEASURE;
+}
+
 /**
  * dpaa2_io_create() - create a dpaa2_io object.
  * @desc: the dpaa2_io descriptor
@@ -147,6 +167,7 @@ struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
 	INIT_LIST_HEAD(&obj->node);
 	spin_lock_init(&obj->lock_mgmt_cmd);
 	spin_lock_init(&obj->lock_notifications);
+	spin_lock_init(&obj->dim_lock);
 	INIT_LIST_HEAD(&obj->notifications);
 
 	/* For now only enable DQRR interrupts */
@@ -164,6 +185,12 @@ struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
 
 	obj->dev = dev;
 
+	memset(&obj->rx_dim, 0, sizeof(obj->rx_dim));
+	INIT_WORK(&obj->rx_dim.work, dpaa2_io_dim_work);
+	obj->event_ctr = 0;
+	obj->bytes = 0;
+	obj->frames = 0;
+
 	return obj;
 }
 
@@ -203,6 +230,8 @@ irqreturn_t dpaa2_io_irq(struct dpaa2_io *obj)
 	struct qbman_swp *swp;
 	u32 status;
 
+	obj->event_ctr++;
+
 	swp = obj->swp;
 	status = qbman_swp_interrupt_read_status(swp);
 	if (!status)
@@ -817,3 +846,53 @@ void dpaa2_io_get_irq_coalescing(struct dpaa2_io *d, u32 *irq_holdoff)
 	qbman_swp_get_irq_coalescing(swp, NULL, irq_holdoff);
 }
 EXPORT_SYMBOL(dpaa2_io_get_irq_coalescing);
+
+/**
+ * dpaa2_io_set_adaptive_coalescing() - Enable/disable adaptive coalescing
+ * @d: the given DPIO object
+ * @use_adaptive_rx_coalesce: adaptive coalescing state
+ */
+void dpaa2_io_set_adaptive_coalescing(struct dpaa2_io *d,
+				      int use_adaptive_rx_coalesce)
+{
+	d->swp->use_adaptive_rx_coalesce = use_adaptive_rx_coalesce;
+}
+EXPORT_SYMBOL(dpaa2_io_set_adaptive_coalescing);
+
+/**
+ * dpaa2_io_get_adaptive_coalescing() - Query adaptive coalescing state
+ * @d: the given DPIO object
+ *
+ * Return 1 when adaptive coalescing is enabled on the DPIO object and 0
+ * otherwise.
+ */
+int dpaa2_io_get_adaptive_coalescing(struct dpaa2_io *d)
+{
+	return d->swp->use_adaptive_rx_coalesce;
+}
+EXPORT_SYMBOL(dpaa2_io_get_adaptive_coalescing);
+
+/**
+ * dpaa2_io_update_net_dim() - Update Net DIM
+ * @d: the given DPIO object
+ * @frames: how many frames have been dequeued by the user since the last call
+ * @bytes: how many bytes have been dequeued by the user since the last call
+ */
+void dpaa2_io_update_net_dim(struct dpaa2_io *d, __u64 frames, __u64 bytes)
+{
+	struct dim_sample dim_sample = {};
+
+	if (!d->swp->use_adaptive_rx_coalesce)
+		return;
+
+	spin_lock(&d->dim_lock);
+
+	d->bytes += bytes;
+	d->frames += frames;
+
+	dim_update_sample(d->event_ctr, d->frames, d->bytes, &dim_sample);
+	net_dim(&d->rx_dim, dim_sample);
+
+	spin_unlock(&d->dim_lock);
+}
+EXPORT_SYMBOL(dpaa2_io_update_net_dim);
diff --git a/drivers/soc/fsl/dpio/qbman-portal.h b/drivers/soc/fsl/dpio/qbman-portal.h
index 4ea2dd950a2a..b23883dd2725 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.h
+++ b/drivers/soc/fsl/dpio/qbman-portal.h
@@ -162,6 +162,7 @@ struct qbman_swp {
 	/* Interrupt coalescing */
 	u32 irq_threshold;
 	u32 irq_holdoff;
+	int use_adaptive_rx_coalesce;
 };
 
 /* Function pointers */
diff --git a/include/soc/fsl/dpaa2-io.h b/include/soc/fsl/dpaa2-io.h
index 31303ff32808..0f20853be167 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -133,5 +133,8 @@ int dpaa2_io_query_bp_count(struct dpaa2_io *d, u16 bpid,
 
 int dpaa2_io_set_irq_coalescing(struct dpaa2_io *d, u32 irq_holdoff);
 void dpaa2_io_get_irq_coalescing(struct dpaa2_io *d, u32 *irq_holdoff);
-
+void dpaa2_io_set_adaptive_coalescing(struct dpaa2_io *d,
+				      int use_adaptive_rx_coalesce);
+int dpaa2_io_get_adaptive_coalescing(struct dpaa2_io *d);
+void dpaa2_io_update_net_dim(struct dpaa2_io *d, __u64 frames, __u64 bytes);
 #endif /* __FSL_DPAA2_IO_H */
-- 
2.31.1

