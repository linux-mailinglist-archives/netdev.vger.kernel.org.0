Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2195742ED08
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhJOJED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:04:03 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:52805
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhJOJD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:03:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQVHK6T1XIbxTw1wqxhGnf042LnfnfydPDw9NjDHliKOCtCyJuAg6Hj26shvhyPzzNc/7+2L/4/egeJDtGqZtMPJvPl6g0G1STrjgvuEoba1JS/MObaBiGkclQCgfLabIGLaNq5JFEXsOHPvgNKGyV1oCoEqrc7qGyL5i1smGF8VfAgIWUcy/GzZqu/Yz0c0TSJwQOIU5eVvh5ZeJO5hcPwJIAahZND7Y5npyDHFVKoVoVzw6j6MIR0QtpIqxLMXec3ZDkpSpj748vTot9HuUgm+r1KJGUFWF94UapyH4P5SYZUev/1GofJp/PHVcULtk83Fa66E+71sb8FZasSvMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBCmD8ANAOZIIIenGTsXzvehvmR46R2+ZXexGhZxOoc=;
 b=Ngst2O56OLaIb6l7vrrx4l6+wB5v9rBZcQq5nj1xdyI7WTtZ6DnvUzJolvIfzG8RXveroKSchLyCLGOCijjJlcI7VZemvXnsJNR9HdQuSpu64vVZZasQp9o+wlrhdwhsaX9myHDTZuS9AhUz6fWrBRmb/I0caWCeisXsSE1/sEZxfsD7NNKNmXODeTSN4SfNERWTRm5nKUN5oFDbtOEpvw3mcN00ETms5JP3zk7vDlACYEw4Oc0ZiO4QZpKhJ2RDwDJriAd7nFiLPRBxy41R3Dd3qrpKPs/pxbb/63723G6yoCtmOZCfzSynQaHWwwFGKcyA5wy3sycpEGQ2ctVsBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBCmD8ANAOZIIIenGTsXzvehvmR46R2+ZXexGhZxOoc=;
 b=F+8f96KqFp3qt1d/sc/zKXHvlJpOsSwSawwKAuZ+Y6bbBACU96Q5uWKHzf2KM7wTZe91ybFKFrDZxL+jDZbB6l+FcA0Wvr40MwEgALs7cYgDm6fHZ9L7EhIGsk1KXxk8GnDpUHV5egcdNUeXYjuJm7aUL2p8MP2ZXgvk33vUDRs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5988.eurprd04.prod.outlook.com
 (2603:10a6:208:11b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:01:49 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 09:01:49 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 4/5] soc: fsl: dpio: add Net DIM integration
Date:   Fri, 15 Oct 2021 12:01:26 +0300
Message-Id: <20211015090127.241910-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015090127.241910-1-ioana.ciornei@nxp.com>
References: <20211015090127.241910-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 09:01:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ac2aadc-01fd-471f-3382-08d98fba6c67
X-MS-TrafficTypeDiagnostic: AM0PR04MB5988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB59885201BE970E5210D69217E0B99@AM0PR04MB5988.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEF5sGIwesc/HUwRAWd7wZQD1dUljUmHitko4Yrvg0yfG35pLHpWkmvMqO5tKW8vJmqD3CzZrGeBYKCIuQ2hvUG5T4quTWBaaXS90OdImSigYpPoGLNqu1um2ldkbzII0/F70h/x6G9rjn4QFx2XX61iybEEePuV+BDn5Mc2OMtUtvV81asHzn4IBnhWVcL96nkZG8SdWsvHS5zI1RCGdfr/hDn6LS7TuU+2b2DncWOGG7Pj3AvFfKSF3FuMYCE9M5m/NN6ocvv5S8Knw8a069G8lkz8wjUwh3LHIZ1RBL/A+mkV5uBJNKkdGMeDojHXIKxTeUzIcPmoLwJZCWeSrcurZpKymBSlqhUHYzyJzjAN/yYupyNE9Tc/MZ3dE9iBm6AznAiyj2eP7TV3Z7S8uKmHEwViA+EGtZdC12K7yJ5MURocO4MzdmhhZNQdgif50BhnvSGprALs63Gmzr8HDf6f6MMafyJMX/AK2QcGfpNrnybJU8f/te9gHewbH5Oux0GwjYlZNgALg+e8PRnV/1rSBSexHbwr0nsMgkvJPBIy7dys0zyf1r9mkVmIwnqn8NEMH13gMm1McWw5mCOpZ8qWXiLE2fo/+LPsC8DeqrSO5ehkR1SjIJqFJaCyIHUdcjIpO4lisqNZrya+wPRuWCKMCnk/Su226/dkYvG+3PPB49t/T3bK88GQS5TUkuWerbmEbD9cm6NLA4244B6TVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(956004)(4326008)(44832011)(6486002)(8936002)(36756003)(8676002)(86362001)(2906002)(6506007)(186003)(66946007)(66476007)(66556008)(26005)(1076003)(52116002)(38100700002)(38350700002)(6666004)(508600001)(6512007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ss28xkmS1pwinYEXIiQNDNPLLdZcB9X53qiA2Z3oMD8uoOem5WU2ONAp4FIa?=
 =?us-ascii?Q?t9B/kIvwAtDdfLMvSyHlIhpKdSOEp7Tfh1Q5JR75uwfYyWX9lpO9Js8KLlr7?=
 =?us-ascii?Q?7kRxgjIqe1jGJaJ4AutqItBpufe26FDM9kikc8ifxkHSEcbdVcpg9SEXG8xi?=
 =?us-ascii?Q?x6fSFXzEqpO/oqvQTpmN+08vb9TFA2+K4PmO6jKkhNSzStAGuTQ9OnOvgK6Z?=
 =?us-ascii?Q?InANC5CgVg2Rnlyw/r6kWphTP3dlvPYkpyfN1wwrd9+QjgFenQrvRFhw4aVP?=
 =?us-ascii?Q?jJ2zLn0v5oq8aHg+ha2Z9pYBNyqdKWjfn6ouDBTCZXZfJd8m3Q84Jyf71r4I?=
 =?us-ascii?Q?1bQ30CJJH3ynMG3kxmoJvWjrfApp7GIzpo0VY17xlpQgZLbkY9lHeLj+EmQr?=
 =?us-ascii?Q?t5A0PmOhsafdF9BI/Lcr6cp9A4LhhKeYn5DU3/ABE7jHV0dEMWwscn48ofq9?=
 =?us-ascii?Q?BBAZSgl81YSZumgj/QQaCaWDDDpaio8G58KHbpuqmefU75Qw8JdCxFgM2U+J?=
 =?us-ascii?Q?EXVqqrbq0XNa+aU/SKBRJ/rfMkMAF6DVuhHeJLRAHHGIFn3pGB2yF7M/MCbZ?=
 =?us-ascii?Q?1TAiLquXmyuO303GkzTy2O1Aa14YltPT2LiNvPpODYz4FxXCRMR/0WH0Q8T+?=
 =?us-ascii?Q?dHrC8PpcXk73AVlL/fWXRbAIQI2Rr1AP+CIp8BLid3Leow/8Yy9vY/Nwfrp6?=
 =?us-ascii?Q?RvrUxmqjOSd9Pu5StOpVrspk5+w80ZWmuKFXx4UPDyZVu/0Z0slFofGRI3qd?=
 =?us-ascii?Q?h2LfwWcOveaJAp9b4Ruyg6KdYx3NZEt3wWRelgAZM5Kpapt9jMWJpit7UiFE?=
 =?us-ascii?Q?qc13NdC3PGi5CEhnRLg7W27qUK/E5EIo81U6p8HSl430eJnUGlvAdDMaIuRJ?=
 =?us-ascii?Q?GfQuZd37G7k/XHyBye/uz8Zlk45LCKZO4YJVHwv3qHotaqlpX8vxTsX/lmZ5?=
 =?us-ascii?Q?eEZ1Ck7PTh9dR6c2DFnHnh37sEa9W5ViCr5Q3VepbZGNb+CKA12h0bxkvJfT?=
 =?us-ascii?Q?XvwW2+gV4WD2nV94vQ2TMKx4HCy+xstMjAH0Qoks/NorNEVaOWNODINiPzhz?=
 =?us-ascii?Q?XqZlJ9GBpTDcnfjL9v6WvfrirxmFKr2NDKBHyuu1nnEDB7K8b8usHAOu3RGK?=
 =?us-ascii?Q?WWJWFR/TmlPpych/1pzqU7dpCD+Y199zknC8ImaD1TFj1DqBvHn8B9noyEIV?=
 =?us-ascii?Q?dRVbheUTnMeBu6SkpCugn4XbxXj7ygzaomROoylr09o04ZhRjaiC6s8kN1aU?=
 =?us-ascii?Q?sQ3kUb4LH/05TMITj2JvpBbfKSZorWnHv0MDoRMq97j4/qKiPS7rpO6cq32F?=
 =?us-ascii?Q?LbxcHusLSRdc4acqzDMCsXII?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac2aadc-01fd-471f-3382-08d98fba6c67
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 09:01:49.7696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EN3snhpftYKQo7clyOMNmdnnzJv+ICWZMi9B2i/aO1+HXFsHpBYe8A717ZgWCXKKMUDUZ3OqTuHT5CX+nY/GXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
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
Changes in v2:
 - none

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
index 9bff280fe8f4..4bf62de2e00e 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -134,5 +134,8 @@ int dpaa2_io_query_bp_count(struct dpaa2_io *d, u16 bpid,
 
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

