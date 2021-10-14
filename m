Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B142DFD2
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhJNRFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:05:14 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:20865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhJNRFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chyLb7opFpvkcXDULdscR48ExxKoYN4Qi19LeRJD7kMS7vKJb8mgyTYUTmARptMdPvh54TRHUvDvQtmGuhnnXXn6VTLV7VUbArVuPpQFKHwBAUB83SRFVw46Y/SVXshkaMXDy4LiweAFPAa5wq4W37qHLQ7VHsQ29xkYfdyJCcYJ2czs3PN8S5ZuLE3gdIPXijf95AVqeuUFXTEw4aQG0iA+K2A2jtG9gzGSIqD09KGuRvHNClqSk1mbUcjplmRzpsbFB1kArFVc1Ox1Po2nroBVHuARZ4NNLwO+LIGan2WDAwek4F2RiJGf5gCE5BGMGaJ/i7NLKk+AztIXrMyPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8pUa1Q0zTsDChUZUAuWKYgMX1rNQHvsHhHy7kExR68=;
 b=Os2xlK4pO9gImUSllsxnJU53yN10gFt/nyT9NLakt9Pk7n+yyoJK+2Y7Ok/HB6TC50HYvA8kfYxNA5eFeIPo7WXpPzp3gfTZcABCwAI4DIpjIvaKYab3MYK575xwxBPSbvz6tk6IuV3Fb/66nDEklGmFTlkAT215KP7SLs5JZWtt0jLb9fHENoQXpgU6Ll/2LX1ClSB6sGYz+3IMC0NbAhtZO+d1F5+Ht1aEoMb1RP12bif7RasgVOflcG8+4KEkcJls6eGPC0bUzmviy3jPSvKprkPPxuGOF+rAISwZg1a1eDFYHAVZQvYPT7X2F7ckE8lhOpWNcVjO6LEi/j7cGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8pUa1Q0zTsDChUZUAuWKYgMX1rNQHvsHhHy7kExR68=;
 b=RHC/rVvru/PCSUulXDeskjPQU06yv9EbZmSgLKHHYs2Cmc01hPDhYk2t5TA5Hr+l/7kJ+dxFs/NXYGPRt+qcsiOmsbLDvzvkzjLhp6L21nzzvg5LquYOG3QwH82zv50N/F8LXIM2Nt03g0N/jgeglQBaS5Ym8wiueW305s209KU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5825.eurprd04.prod.outlook.com
 (2603:10a6:208:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 14 Oct
 2021 17:02:59 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:02:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/5] soc: fsl: dpio: add support for irq coalescing per software portal
Date:   Thu, 14 Oct 2021 20:02:12 +0300
Message-Id: <20211014170215.132687-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014170215.132687-1-ioana.ciornei@nxp.com>
References: <20211014170215.132687-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:02:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39aa587f-eb51-489c-462b-08d98f347982
X-MS-TrafficTypeDiagnostic: AM0PR04MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB58257F42B7D5A546C2D541C0E0B89@AM0PR04MB5825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEnopxi6RV3Zu4itJ+f1GcENoAhcwaCAa8d31ReMDaxyvl6GaXYjEVWANtlXknsIn8ZFst9ziDeQ/mpBLPD4KA0ivSZtSI4LQ5NIRUt5/9g6/SJ059qA8MaFB3+fSkibIhlGLmLWThtfE3ypibmNEfQ4m6S+s+A08gpip10AzPLdCUBRmgwGBcvekMicf16gCJKd82bCt0obArHzMzt2ce0xy3RZOXoT+6Ub7e2NyjlDVb/D3YBc0eMQHm3Bn+qNkkF/nVBJM34RCNP4Pt0VpwVswnhX3IyslbbdolpO/pTGrvdu95CIQ6TJNprTJYsQ750LE5jC1ZWNw6SLP2MVUAhs7Rnx0XrVR1zJS920HkCGxucIvCXuMU0PW3qmSwB3kRMzDaSsvfikRmd4qySeZVr4663qy7kquA/QfWFZx/ga9OAleqY2VtQgCF0AjtmogC61UswW7JyT+8WIELrPltr4vfa5mwZIPV5NA24P02Sd0O/gqv4lXzQmfXbZ7siYYVSuDcnqh8uvEfgexdYDu/bsijzGcN7Z5H5Ui0zEf8mOQaG0JwIoicr0Rt5eljxo7oir8M4oSrwFvJIWtJJAo6UZ6zas22Ac1Y72SE1x7s4g4FFCyuNveV9FgJnfuv0CvKKxIAme7YyWfKWYJvf7EMQWzqhYg51tQNMrsKI+/EexiL8bbS/DJcTSVee2LRU5cuK72hSV4Gsg9hWJe8bYXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(2616005)(956004)(1076003)(8936002)(6666004)(66476007)(186003)(316002)(36756003)(8676002)(4326008)(26005)(2906002)(6506007)(38350700002)(66556008)(52116002)(86362001)(44832011)(38100700002)(83380400001)(66946007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lap5Z/PC3wdHe8ZX+cS9q5HIxX9ny5EELtPFfvv77W2KxmQWXD0v4pLus8uM?=
 =?us-ascii?Q?6Cfumvkd05y5F2lxKXjOu5CsixOUpSgLpETvyvrAHkZWFE37lSsSWyg9fmfS?=
 =?us-ascii?Q?8+ZCw/JUlnfW/CWFdgFoZkD3Mj5GzWivWuc3WwamykK8hX8vmZnW3crHaGNL?=
 =?us-ascii?Q?DR0/0WACpa89Y6Ssv283jXwSITAn7NhI1zcV/6IR5/2Zdk8dPNRq37LRe2n1?=
 =?us-ascii?Q?g1ud8c0ns4wyxY3TslsPLUmnJ+8KWMlNin+bFk1uSc+o8aMaFaDrnBqtK/e5?=
 =?us-ascii?Q?rVyl0mlXx5PGd8DTGNoVVVn/3cKr1LpT3iN8qt6zXpVw+exed+d6244k35Td?=
 =?us-ascii?Q?T6MJbehUaQ3YdViESbE7C6PUZUCOUt0oZ2cZmGhxKhjGrKp+QINlLMV5j6DO?=
 =?us-ascii?Q?OfkQkbxJ/XZC3X8p66U/YyhRTiP+J99RSVlbhgIsGBv59wX4LncfoLsh6UGe?=
 =?us-ascii?Q?80HQJXznQnSWei7rdhR4CQKZjhlkPuzkY5pmDGosfWka0dcChCwM/zIc8D6U?=
 =?us-ascii?Q?E9ViL5uhoZi8lhKyNrAqVY9Kq5Wt+mrEusXh3xLuTLFmS5rfTxEHVZ2MszCc?=
 =?us-ascii?Q?0mvuQfMAFyFhfjW8kT1JJqcdVe2lBQ9AyVzgu+Ets83ctIpe1Et+r/05e8dy?=
 =?us-ascii?Q?hHBe6K9VQyUy1I42lV5wlnldzhDxQiEvGWvx0A+8GptrNFOEPpciHPrY4lva?=
 =?us-ascii?Q?HEyCwd56uuyCyt49R+nF97vgFsSP7yyzgeM4zNx3zTcroECT6Q+z7bg/I0wF?=
 =?us-ascii?Q?1JAy2z/UnCAKmFDUalqY2M5wDDeR0+/bEvgMHnVtCzsg1/AecemOVbe8EhCF?=
 =?us-ascii?Q?B9jpWW9/sxvQ6HLYhl4aceDg1T6uIXMdDWB1ZMJ1AaqG+CT3OKIlwzoP2gjm?=
 =?us-ascii?Q?w36mWwxfT1JVTprHfdLJ+AIS38dN5kGRwtCn0azkHal1cnRQffZ3Z68ZPxV5?=
 =?us-ascii?Q?rkR+IHmAoenr+4BAX0KMe79EvGoIvM4oh0ru+qDkDUPBrfWuN8LLMo91LMk3?=
 =?us-ascii?Q?Kf/3IZzBxNqXK/iOwMw3BbwcWaTTgCzNkPADj8Ckz0tdjxYH0iOKe4qsKhKN?=
 =?us-ascii?Q?X1wpOR8Hi60t4yMfX7KwuLwrYF58bQtVIlsIZICx84APXmhy9esWpZBCH5Nr?=
 =?us-ascii?Q?UaAFSbZywIC0kXYUT/SVoskIYj5Wrz5nYXZfaQZ743dJDrMiS5MoEPvUMjxC?=
 =?us-ascii?Q?KZ6SPyrMkpM+Ex+xXjdEHalak+cpDK15YbfrlYjbafQ0FaixP9AwLkriS166?=
 =?us-ascii?Q?5RsQe9WcvKZCl6REIG4VpycVjWGbXerW+x0rsM8tgnizyxlRAiPhpdBoz/5E?=
 =?us-ascii?Q?NTDzmaenwkHV3m6DF0PEge6I?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39aa587f-eb51-489c-462b-08d98f347982
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:02:59.1517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gK77vIrqcb0xkBquONbP8p+s5oqYh2uBujnt+utP4JqFJes7a9IuLhqDZkGIiM1Kt38GeSMT9uCTBZf3hV7E8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In DPAA2 based SoCs, the IRQ coalesing support per software portal has 2
configurable parameters:
 - the IRQ timeout period (QBMAN_CINH_SWP_ITPR): how many 256 QBMAN
   cycles need to pass until a dequeue interrupt is asserted.
 - the IRQ threshold (QBMAN_CINH_SWP_DQRR_ITR): how many dequeue
   responses in the DQRR ring would generate an IRQ.

Add support for setting up and querying these IRQ coalescing related
parameters.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/soc/fsl/dpio/dpio-service.c | 37 ++++++++++++++++++
 drivers/soc/fsl/dpio/qbman-portal.c | 59 +++++++++++++++++++++++++++++
 drivers/soc/fsl/dpio/qbman-portal.h | 11 ++++++
 include/soc/fsl/dpaa2-io.h          |  4 ++
 4 files changed, 111 insertions(+)

diff --git a/drivers/soc/fsl/dpio/dpio-service.c b/drivers/soc/fsl/dpio/dpio-service.c
index 2acbb96c5e45..44fafed045ca 100644
--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -114,6 +114,7 @@ struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
 				 struct device *dev)
 {
 	struct dpaa2_io *obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+	u32 qman_256_cycles_per_ns;
 
 	if (!obj)
 		return NULL;
@@ -129,6 +130,13 @@ struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
 	obj->swp_desc.cinh_bar = obj->dpio_desc.regs_cinh;
 	obj->swp_desc.qman_clk = obj->dpio_desc.qman_clk;
 	obj->swp_desc.qman_version = obj->dpio_desc.qman_version;
+
+	/* Compute how many 256 QBMAN cycles fit into one ns. This is because
+	 * the interrupt timeout period register needs to be specified in QBMAN
+	 * clock cycles in increments of 256.
+	 */
+	qman_256_cycles_per_ns = 256000 / (obj->swp_desc.qman_clk / 1000000);
+	obj->swp_desc.qman_256_cycles_per_ns = qman_256_cycles_per_ns;
 	obj->swp = qbman_swp_init(&obj->swp_desc);
 
 	if (!obj->swp) {
@@ -780,3 +788,32 @@ int dpaa2_io_query_bp_count(struct dpaa2_io *d, u16 bpid, u32 *num)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dpaa2_io_query_bp_count);
+
+/**
+ * dpaa2_io_set_irq_coalescing() - Set new IRQ coalescing values
+ * @d: the given DPIO object
+ * @irq_holdoff: interrupt holdoff (timeout) period in us
+ *
+ * Return 0 for success, or negative error code on error.
+ */
+int dpaa2_io_set_irq_coalescing(struct dpaa2_io *d, u32 irq_holdoff)
+{
+	struct qbman_swp *swp = d->swp;
+
+	return qbman_swp_set_irq_coalescing(swp, swp->dqrr.dqrr_size - 1,
+					    irq_holdoff);
+}
+EXPORT_SYMBOL(dpaa2_io_set_irq_coalescing);
+
+/**
+ * dpaa2_io_get_irq_coalescing() - Get the current IRQ coalescing parameters
+ * @d: the given DPIO object
+ * @irq_holdoff: interrupt holdoff (timeout) period in us
+ */
+void dpaa2_io_get_irq_coalescing(struct dpaa2_io *d, u32 *irq_holdoff)
+{
+	struct qbman_swp *swp = d->swp;
+
+	qbman_swp_get_irq_coalescing(swp, NULL, irq_holdoff);
+}
+EXPORT_SYMBOL(dpaa2_io_get_irq_coalescing);
diff --git a/drivers/soc/fsl/dpio/qbman-portal.c b/drivers/soc/fsl/dpio/qbman-portal.c
index f13da4d7d1c5..d3c58df6240d 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.c
+++ b/drivers/soc/fsl/dpio/qbman-portal.c
@@ -29,6 +29,7 @@
 #define QBMAN_CINH_SWP_EQCR_AM_RT   0x980
 #define QBMAN_CINH_SWP_RCR_AM_RT    0x9c0
 #define QBMAN_CINH_SWP_DQPI    0xa00
+#define QBMAN_CINH_SWP_DQRR_ITR     0xa80
 #define QBMAN_CINH_SWP_DCAP    0xac0
 #define QBMAN_CINH_SWP_SDQCR   0xb00
 #define QBMAN_CINH_SWP_EQCR_AM_RT2  0xb40
@@ -38,6 +39,7 @@
 #define QBMAN_CINH_SWP_IER     0xe40
 #define QBMAN_CINH_SWP_ISDR    0xe80
 #define QBMAN_CINH_SWP_IIR     0xec0
+#define QBMAN_CINH_SWP_ITPR    0xf40
 
 /* CENA register offsets */
 #define QBMAN_CENA_SWP_EQCR(n) (0x000 + ((u32)(n) << 6))
@@ -355,6 +357,9 @@ struct qbman_swp *qbman_swp_init(const struct qbman_swp_desc *d)
 			& p->eqcr.pi_ci_mask;
 	p->eqcr.available = p->eqcr.pi_ring_size;
 
+	/* Initialize the software portal with a irq timeout period of 0us */
+	qbman_swp_set_irq_coalescing(p, p->dqrr.dqrr_size - 1, 0);
+
 	return p;
 }
 
@@ -1796,3 +1801,57 @@ u32 qbman_bp_info_num_free_bufs(struct qbman_bp_query_rslt *a)
 {
 	return le32_to_cpu(a->fill);
 }
+
+/**
+ * qbman_swp_set_irq_coalescing() - Set new IRQ coalescing values
+ * @p: the software portal object
+ * @irq_threshold: interrupt threshold
+ * @irq_holdoff: interrupt holdoff (timeout) period in us
+ *
+ * Return 0 for success, or negative error code on error.
+ */
+int qbman_swp_set_irq_coalescing(struct qbman_swp *p, u32 irq_threshold,
+				 u32 irq_holdoff)
+{
+	u32 itp, max_holdoff;
+
+	/* Convert irq_holdoff value from usecs to 256 QBMAN clock cycles
+	 * increments. This depends to the QBMAN internal frequency.
+	 */
+	itp = (irq_holdoff * 1000) / p->desc->qman_256_cycles_per_ns;
+	if (itp < 0 || itp > 4096) {
+		max_holdoff = (p->desc->qman_256_cycles_per_ns * 4096) / 1000;
+		pr_err("irq_holdoff must be between 0..%dus\n", max_holdoff);
+		return -EINVAL;
+	}
+
+	if (irq_threshold >= p->dqrr.dqrr_size || irq_threshold < 0) {
+		pr_err("irq_threshold must be between 0..%d\n",
+		       p->dqrr.dqrr_size - 1);
+		return -EINVAL;
+	}
+
+	p->irq_threshold = irq_threshold;
+	p->irq_holdoff = irq_holdoff;
+
+	qbman_write_register(p, QBMAN_CINH_SWP_DQRR_ITR, irq_threshold);
+	qbman_write_register(p, QBMAN_CINH_SWP_ITPR, itp);
+
+	return 0;
+}
+
+/**
+ * qbman_swp_get_irq_coalescing() - Get the current IRQ coalescing parameters
+ * @p: the software portal object
+ * @irq_threshold: interrupt threshold (an IRQ is generated when there are more
+ * DQRR entries in the portal than the threshold)
+ * @irq_holdoff: interrupt holdoff (timeout) period in us
+ */
+void qbman_swp_get_irq_coalescing(struct qbman_swp *p, u32 *irq_threshold,
+				  u32 *irq_holdoff)
+{
+	if (irq_threshold)
+		*irq_threshold = p->irq_threshold;
+	if (irq_holdoff)
+		*irq_holdoff = p->irq_holdoff;
+}
diff --git a/drivers/soc/fsl/dpio/qbman-portal.h b/drivers/soc/fsl/dpio/qbman-portal.h
index f058289416af..4ea2dd950a2a 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.h
+++ b/drivers/soc/fsl/dpio/qbman-portal.h
@@ -25,6 +25,7 @@ struct qbman_swp_desc {
 	void __iomem *cinh_bar; /* Cache-inhibited portal base address */
 	u32 qman_version;
 	u32 qman_clk;
+	u32 qman_256_cycles_per_ns;
 };
 
 #define QBMAN_SWP_INTERRUPT_EQRI 0x01
@@ -157,6 +158,10 @@ struct qbman_swp {
 	} eqcr;
 
 	spinlock_t access_spinlock;
+
+	/* Interrupt coalescing */
+	u32 irq_threshold;
+	u32 irq_holdoff;
 };
 
 /* Function pointers */
@@ -649,4 +654,10 @@ static inline const struct dpaa2_dq *qbman_swp_dqrr_next(struct qbman_swp *s)
 	return qbman_swp_dqrr_next_ptr(s);
 }
 
+int qbman_swp_set_irq_coalescing(struct qbman_swp *p, u32 irq_threshold,
+				 u32 irq_holdoff);
+
+void qbman_swp_get_irq_coalescing(struct qbman_swp *p, u32 *irq_threshold,
+				  u32 *irq_holdoff);
+
 #endif /* __FSL_QBMAN_PORTAL_H */
diff --git a/include/soc/fsl/dpaa2-io.h b/include/soc/fsl/dpaa2-io.h
index 45de23daefb7..31303ff32808 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -130,4 +130,8 @@ int dpaa2_io_query_fq_count(struct dpaa2_io *d, u32 fqid,
 			    u32 *fcnt, u32 *bcnt);
 int dpaa2_io_query_bp_count(struct dpaa2_io *d, u16 bpid,
 			    u32 *num);
+
+int dpaa2_io_set_irq_coalescing(struct dpaa2_io *d, u32 irq_holdoff);
+void dpaa2_io_get_irq_coalescing(struct dpaa2_io *d, u32 *irq_holdoff);
+
 #endif /* __FSL_DPAA2_IO_H */
-- 
2.31.1

