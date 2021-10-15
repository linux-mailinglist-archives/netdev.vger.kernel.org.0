Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8442ED05
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhJOJD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:03:56 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:52805
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhJOJD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:03:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9x0gbz0dAqpsIiTFbJVQfpZDjiGXAxSZhl3eGEzdTG+qxByyk/SsiCYDi4xJtjTwrCpWESECkGkwux5+6PW2zA8NlbKEhnUcLBFFwaln0AB6ZZxpGAJZ/EF5485D8J7ePRqxS06UmR1hNlZ/bGVyDcg4kqkIJYYtnKaOsb2AhDsWD4cZmUrLexW8xJZaS0oWemY6/0wGTfcKdPzHyuRznxYL9jMggegKXEd/OAJcOUUnDfyRu6H5SRlKRWCxK+/huXLPNx5b/NJMELWMVF1q/pZFhvtENl5ckroggduLEVSB00LN/4Ul/CHWKRWY03ZsJ08XfglbI7ksZKy7zo/cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHNORdNXVUgtZ4Eloi0aQcNZ2wrKDj+KePPScf2Q3tA=;
 b=XqmHcSyn+uR4zdbLj+ZjFEEoUTsX1NO7N3E39cZgTwcU9CDHZgJ0/Hs81uIDnPjse2f4KgdhRBTXsldLl5W8OoX82OYF/A8DZytEto7g145W02dYzr4RVrc+rhOu6BHS4o7fF7IVJZdiYrtN1hv79mKpAw6e+BjhT0kEZj79rm87rjMl1mvbB3jmSQjqqctnn7hHO9OFaPK6grByS//nPboFp3Env73fn26M7pDcajugB5yIZwJhCIhnJDrmmYX/opsimj4hMz3PQzoNbJmv5N0JNyKfP3g7QYKMUe1NbxS4sIHM8FDnLcETU5JYAnjFBNIphPL52otWjA6MgYWZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHNORdNXVUgtZ4Eloi0aQcNZ2wrKDj+KePPScf2Q3tA=;
 b=dvxmfhsBAPLuFIfBSyucragMuNKJ3cG9u1tvDyh9T3dpu1WxXYhxYCAe/rhBsVDJ4yYt+K3hIIbvUzBVa8RqaWK8vnzt1lMvejZE/Adnnveiav9C6CGVrQCr3T0GSmCfNyb1V4eD1pJjucDJAWnwcRHhfeIQaqjLfrgecaI0Jms=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5988.eurprd04.prod.outlook.com
 (2603:10a6:208:11b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:01:47 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 09:01:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 2/5] soc: fsl: dpio: add support for irq coalescing per software portal
Date:   Fri, 15 Oct 2021 12:01:24 +0300
Message-Id: <20211015090127.241910-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015090127.241910-1-ioana.ciornei@nxp.com>
References: <20211015090127.241910-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 09:01:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4af7c91-56ab-4a0e-d842-08d98fba6b47
X-MS-TrafficTypeDiagnostic: AM0PR04MB5988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5988534169E674E40736C861E0B99@AM0PR04MB5988.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wuYuxR2/Xsd0xE+JYqRnWiQZYY8Ib15r+atV9TQeNxbAx9nJ3CUu6dVgRcGgE5auyoRcAu4uk091qa2J4EKcIeKiLBL4IsvSi8Uf5nTJkuZ445w58y2KEXdCUvpQrsAf4a20Shu9LAmlOd6XClaX6/u7xFCEiRTzXycdQbx4hV3VEOr33ClqdjDyuBgMr36hGAi8NyDKD56RHMWvFpubFeLUG6CjbbBMn85lsaS3N0IYaDYOGilCyrQzlxTGUZzSuouUnkIpESVVqcbh+sl9mUKYgSrShwNfi7UfrqdsBxRcqTNgCxDG1ScouPDQyDopSVBSsIx0hW0wVdNZ0BXgEWx3moXUSnFUhkmzVegEjcGcT2uokcPJ+a21pOGZFgLdT8djETKkbiok0ilbgh2ZnbDjdwCNpVjdDEzdQqQloe0aEcJ+5Dju5RvSv+/+976V8TYLmgf+3s3L+UrA+42CqKpRlPpuDihqz5cz4zyOatbF+u2bzne3fs9UeutglbRjFET2gFqekWGK+bXFkpjvqGs4wRcyitGAxJqr2I+71QO6ZNM7G6JdVsYG5jqnDLVj8dX4jBvfE4xRn008fSVeYHE/8OrXQoqHIUyE4tcYHnowDoKvCAZCEskgT/NRtf/k5kj/i/7qfcGBepLMw/67RzpwYGA6Ob//ooDJdOvdatLULdYiOsulhVAuZCBgpcvxh+45GK0alA3paOAjBz2zTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(956004)(4326008)(44832011)(6486002)(8936002)(36756003)(8676002)(86362001)(2906002)(6506007)(186003)(66946007)(66476007)(66556008)(26005)(1076003)(52116002)(38100700002)(38350700002)(6666004)(508600001)(6512007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fY0cjno2H/rF3GqewDXIeAbl2pQ91IPblExG0r27iD29OL5Td5te2+LmD+R0?=
 =?us-ascii?Q?uEXYGQNiP626uMqNHmyBo08W5qWQQANSZHGcOXkggHVdbHHR7yZlEuC4N9sb?=
 =?us-ascii?Q?q+uHjv7iE/mhR32rvG5HOucICgUEncPUF3CKRsADqfGF28wlucX9KLuyueFp?=
 =?us-ascii?Q?KJ5cKy8xp7rsJS/rFly+upr8Px20DnQgT5K0BeJZgGMNBw51XM66BLisAsie?=
 =?us-ascii?Q?weyBIn4JPRVk8LD7GEfC3hrvQWZXp5PKgIeL6cuFZE4z/9WYo31J/uM07EJ3?=
 =?us-ascii?Q?jzekTTWu4MDPq++C235KzkkxBCTfAXrxDZt22ClEZkaqo1XqHMnnVt2QkeuQ?=
 =?us-ascii?Q?0dDTTFAryGKKp4QQoUuyooTaEwFaB4hNDh0KX2IkQA1awEi4lPUr8aDBLnP7?=
 =?us-ascii?Q?xrnKCVDjJKbCdEZZGVJ1CEPssLmhUNFDAEG/SJIdXPbAdX2ROFjIHX3cRhiw?=
 =?us-ascii?Q?YsNYyrBYV4AAXSUsDxHwVIBBRrRV8MpSNCNZHlJaKa23Cxf7S5LxEZEAkvKA?=
 =?us-ascii?Q?QszX5g5xOF8fokwZFaOwKlKI3TAFWJqlJj0NzgBglw1Jh0Xga/MGI6ZNU+VG?=
 =?us-ascii?Q?IB1++vKAM0qc27cT25e8CsXQXyR/9MrFlMHquoM5xHXdi4eH9seKXZKfd45u?=
 =?us-ascii?Q?3qoh2NOdE90KDtvC1o8Dl1grjnOGLxTfkQ5wrEimM2tcmnxaR+873mDSUfzC?=
 =?us-ascii?Q?a+VFZwz6BHxBJK8g3KwE0z38+jukET+g7778UEuMnaVkIUUNn6nsBDknQhhY?=
 =?us-ascii?Q?e3ivsDcZ9vIXsNvfJ+IBdQTRFZIn2R7nDdPqon4C12Fr/9hzIXDNXUwPQl7N?=
 =?us-ascii?Q?lHod8BIg5Xa5pwwefoiXXuf+DzcZYEAEuZ81Crxmr8GPPQdBEhkqJw0QC+So?=
 =?us-ascii?Q?UsHVkAhyxJcy3AGPDAgk1ERqU3EUxIcfkcFBPebnoZ2iWZxRTRH8jnkcXLOw?=
 =?us-ascii?Q?qL7krpmUE39dg9QCz4V4Q867uMkXwRMS5zW1loOb1IHKrwenB+OnBcnODjr/?=
 =?us-ascii?Q?CVjbsCyILf0NeqEgoY150OuHfNdurrIyI5vRspg5ot+j6TDaSi3oQprqmKgY?=
 =?us-ascii?Q?ZO+zq58xtjcBVjN8+V1ud95pLdrQqq9zYeX9Fq7PUL0CgQf0oqoomty9OYiI?=
 =?us-ascii?Q?B1J+g/+QHJhRFHeaS8AJdCgmXrsc9t8XpFuibto8HEth26UsIJ4yD3tarx8b?=
 =?us-ascii?Q?reYK+DlS3VQ78oKgxtudEyEbR0SiGrHXxef43gH3rFzBzTmJ4VxHlHIK8JH5?=
 =?us-ascii?Q?rSti9UF7B2yBd8TzjFNAXUT/gZQTCdDt0JyJbzggZm005I5SJXmo4MD2V/pK?=
 =?us-ascii?Q?4u6LWfOw6uViYeofuinmBcSk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4af7c91-56ab-4a0e-d842-08d98fba6b47
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 09:01:47.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zheNbAVc3jT74TzTZx5HLnNNyMrQA3WPwMtJZyjeR3DF3ebiEI2oms5kQmowlNbLjfpdy7UFIwGSdkHmiH6Q5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
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
Changes in v2:
 - none

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
index 041ebf7d804c..9bff280fe8f4 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -131,4 +131,8 @@ int dpaa2_io_query_fq_count(struct dpaa2_io *d, u32 fqid,
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

