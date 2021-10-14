Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7442DFD1
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhJNRFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:05:13 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:20865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232160AbhJNRFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:05:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsD1IpG5rB1krveyg5FNcviirmc3VxYLaKOGzK+44M/IBKJxZGjDjdboxlE+htFFyuowYv97Ck/Cdxwqkr4dvgJcrVWPZk3Q54/aR4U3Mxk2WH963roJ+UoG+yEaWaf3BGlT8dkYcPkVgGdJxMJbOnHDSVLihZge0f+nuiI9p2rZPMw5HBf8BQ2k3L8a3TnJBh8NTVvca3QPxhIs75tm2pGNP8ppMX8AIBPZVHw6JQEwDxNcU/7vWiND+O5ScDNS81/GelaTt7q6TCXhT+tjoeEVITiUkLgDKloIei66XexAt1EbCHDUpTauVD7a27MPAQrVSLjYwM9v/oLWFrT/Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fix9iwjCIAMAcdBotycmKXXPc/JkaSXJzGoRioYI+B8=;
 b=M+OEab18iTIcN8H+UsIv500H4X8pPuStg5xs1DD9+gom83YBaQEG0tc5fEI+D4Azw/SdaQ3uMxhACcMWNsWJfYyjJMeExGh676I9yoDKTUP05m72ZM+jACtoJfEWMal4rl4vhAQkiP69YTUIZ9a4x+xTXI7Lmt4XveCeQ6uY9LZQIwyfDRq0TKlCK2uduAEKtdkSz+hNXI6lmfnu6h/WFzO9JhtS5dzMgqJWk+vbXK/h5k/QihwPcI0HtEjXCAg2x3eo9pi1GA69kmlgivRL354pgetVtRbzORZTD/Q1qrZ2xaOEOEe9O5xMlAeuy3aqUaDYz4ONC4/hvbxkayE4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fix9iwjCIAMAcdBotycmKXXPc/JkaSXJzGoRioYI+B8=;
 b=cEd3TBw0sOx49wf1bklp3SqrhWknswsyl4SftL6Zw7Q+/idp7O5f1Qb7MQSN8Ccskejo1YqavrOgJ7qBOTYN2M8SiwVjGpYu8ZTLx10lCutsX9YNSg31IzmNkyw6F2G83rrOmSBb06V7M428IRf9ivwKoYveXF1pxpi0dUmPvrA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5825.eurprd04.prod.outlook.com
 (2603:10a6:208:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 14 Oct
 2021 17:02:58 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:02:58 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/5] soc: fsl: dpio: extract the QBMAN clock frequency from the attributes
Date:   Thu, 14 Oct 2021 20:02:11 +0300
Message-Id: <20211014170215.132687-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014170215.132687-1-ioana.ciornei@nxp.com>
References: <20211014170215.132687-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2011ef6c-91d3-4f81-2c95-08d98f3478e5
X-MS-TrafficTypeDiagnostic: AM0PR04MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB58250DFDE8AF328633DC875CE0B89@AM0PR04MB5825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lbDLn0GHd8SKWRvRwD2Fy1ihiMIioeW2EG7LStcEpFKlq9L4ESiGB6SYeN1qgVmuR3H6zbqaJ/OZ5NIXykHXTUokeGY+dGffjC8JBAn4zsMytCfYNyr621cnoJCeED6JbZYj6f2ixAgmxORV2W3Ceh7rPBD13PqeoWaQeMjUJeswY3R3LSjRYuD6dElFAN9JQEQNruMj8jUX4tVliYnGEoN4/htlDaaLHICkWXkEtVkxvuX3RpyZw0HTUubKhlKv6DeUPyjR3d1MUa7BJjrdnTpoQ+gZIXjrUmwwc5AWbBoUCSi2y9VGRjKK01cxM5z9JsuYeYsVaCxzEGVD/6bxgL4GjbfaUGInO+fGtNlrUSs4d/7YmOTthrWKy5jrIE/hkJj8aCaDscW7MXXQH2DTE6L7F1E7g6iIp7M4QNQLqKbLs+Ol7463pzs77ByF31aNWWNREN+7UA/lQqGdkBoaFeUgkY3uWF5BHGGOkyOSdhpMXzic6kBTrFYsm6E+ewoTtzFRlcg4H315LDDr8it0/nu81cmcVxSj8QCMeUjVny55H8TpLXOXqXco1npaFrSQfOhQLeHM8U9L2yV37MQ3csqqYV/D/Pp+EwsrWUOGwFphpkKXbe7mEkHvUaHBP+ZDF8KkE82pOBDFEjugFIOFlD7bwlLnK5o6ep213KTkUmPSie1XYBH78p/eGGakAKh1LwR3EtWNJc6zHk4F51gxug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(2616005)(956004)(1076003)(8936002)(6666004)(66476007)(186003)(316002)(36756003)(8676002)(4326008)(26005)(2906002)(6506007)(38350700002)(66556008)(52116002)(86362001)(44832011)(38100700002)(83380400001)(66946007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vS1dA00qoAJOQh//4yY04OblGIunlWsK6wjDMFYMLPqI8wt6vRtOfznzydwW?=
 =?us-ascii?Q?6/U7tVdfWmKP3WcbrRUAgS03f9ljpGVF7BUg7+jTEdgSyVpuGsTWobUjXst6?=
 =?us-ascii?Q?uRTITiA+VijYmxF752+zOaLIxDmX/zOw9ztPk+Nja+JermqgePNdwKWxxEjJ?=
 =?us-ascii?Q?3IycF5Ri+uEAEY9UdDtSej9YD8YcvJCh/izySwrs+Jxw9dLYTtTY/7PNmLaV?=
 =?us-ascii?Q?zE5f8PKYKEgywfKkMQGQYoRI5/WHWZDJwQayqZX1r/bJ9GdxzJMr+5bbzNED?=
 =?us-ascii?Q?0zl6ttBW5OX7DhThPv36vRJaFKxS/LOwEhBIuflaKWL/CeWASGqsKqBwlU1S?=
 =?us-ascii?Q?+JDI9OCrijxkY5FGbD90BGn+G+qjhCkC/99EChHgpewuy+v1qdqAtZMGtQTr?=
 =?us-ascii?Q?ZkucFACbzzSU5efv64eWLfC0XQF6JqLQYFw+vZ0puW6j07F0GNHUY3ubsYh+?=
 =?us-ascii?Q?Ack6e3CSgrAmzDPEOXWilsHcQPeTP45TKhqbHXOENQl13jN0eV6dgsu9C93/?=
 =?us-ascii?Q?La4Y29ymZ24FGQm3TtEweHd/w81UocjyAo/K8qJVUldj2BtEl7r5oJ2DdL0R?=
 =?us-ascii?Q?eeWVmTiUUaydnPtEjjRXF7DXlwMOZzJvklzksoHLR/KqJ+A4CGzl5d2ixnlv?=
 =?us-ascii?Q?PO03rSZsPKIOfuEBiodOy45aKLNgpO8GtifmCYynhovaWOwZ+RQbjhnokkwQ?=
 =?us-ascii?Q?nFfd1BslSTGew8glCot7nmtzd9Gv2N0wvD1XUcHgsfUnPwmoSS1X+foSx88A?=
 =?us-ascii?Q?+II6wcYHgCr8Baa+S+T5uIpnK8XYmle6j/QUYMNWJ2qeO+s+kozFeF3VCBHn?=
 =?us-ascii?Q?rZY0T8JS0ZjrrEkWzmrXAGvo0aUp13ixdF3Wvs2t83xGXUMTZjtOZOHc6/84?=
 =?us-ascii?Q?GEB9ojSi2BlvYd48GNEw3kFwDnPVNVWl+a8uldL6M2aK+ySn9UtGkrwKs4kJ?=
 =?us-ascii?Q?rVxc9xN2mkQsMiqDmDNFtxWXPetKuyZo7n0MkcXQ98+pLNX2v/pugPlIgMV+?=
 =?us-ascii?Q?JFOldeWlgfal/XMEFb4B5ThsZ2xMn7207x0YEBa96hD/YqT8dRhjNPm8vbCQ?=
 =?us-ascii?Q?FaQgPTesVJt3mY9fmlsqG79ghmsTGis19lIdwt2BSmG1Ub6kIM0IC/8QLtfP?=
 =?us-ascii?Q?rVQnVuCmknTArmP4xcxRD0ZHyulZ641an17yVpzGxXuJpsEfaIktmtOTUOlS?=
 =?us-ascii?Q?Zq6nDo5cQE9EYfvELZfltprtvVAgr5MJDz3yiqTs2EDQ1ex+V5gPjn0MmgRC?=
 =?us-ascii?Q?hjkojURdmtsgkhY0+cgCv8MQPwuc6XTELKBl8gc+N6QdgJnaPSU1EL7Qg4FP?=
 =?us-ascii?Q?kLgciVzle9KfRcbRwVzDOJn9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2011ef6c-91d3-4f81-2c95-08d98f3478e5
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:02:58.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swvpDGiY8zVhsMJzhoQob6GJNWE9Dvdc4PqRqxMsQuvLUOkEfFUz7s6+9+NVMfUTjWk94GUHrotvOH4x/ECT7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through the dpio_get_attributes() firmware call the dpio driver has
access to the QBMAN clock frequency. Extend the structure which holds
the firmware's response so that we can have access to this information.

This will be needed in the next patches which also add support for
interrupt coalescing which needs to be configured based on the
frequency.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/soc/fsl/dpio/dpio-cmd.h     | 3 +++
 drivers/soc/fsl/dpio/dpio-driver.c  | 1 +
 drivers/soc/fsl/dpio/dpio-service.c | 1 +
 drivers/soc/fsl/dpio/dpio.c         | 1 +
 drivers/soc/fsl/dpio/dpio.h         | 2 ++
 drivers/soc/fsl/dpio/qbman-portal.h | 1 +
 include/soc/fsl/dpaa2-io.h          | 1 +
 7 files changed, 10 insertions(+)

diff --git a/drivers/soc/fsl/dpio/dpio-cmd.h b/drivers/soc/fsl/dpio/dpio-cmd.h
index e13fd3ac1939..2fbcb78cdaaf 100644
--- a/drivers/soc/fsl/dpio/dpio-cmd.h
+++ b/drivers/soc/fsl/dpio/dpio-cmd.h
@@ -46,6 +46,9 @@ struct dpio_rsp_get_attr {
 	__le64 qbman_portal_ci_addr;
 	/* cmd word 3 */
 	__le32 qbman_version;
+	__le32 pad1;
+	/* cmd word 4 */
+	__le32 clk;
 };
 
 struct dpio_stashing_dest {
diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 7f397b4ad878..dd948889eeab 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -162,6 +162,7 @@ static int dpaa2_dpio_probe(struct fsl_mc_device *dpio_dev)
 		goto err_get_attr;
 	}
 	desc.qman_version = dpio_attrs.qbman_version;
+	desc.qman_clk = dpio_attrs.clk;
 
 	err = dpio_enable(dpio_dev->mc_io, 0, dpio_dev->mc_handle);
 	if (err) {
diff --git a/drivers/soc/fsl/dpio/dpio-service.c b/drivers/soc/fsl/dpio/dpio-service.c
index 7351f3030550..2acbb96c5e45 100644
--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -127,6 +127,7 @@ struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
 	obj->dpio_desc = *desc;
 	obj->swp_desc.cena_bar = obj->dpio_desc.regs_cena;
 	obj->swp_desc.cinh_bar = obj->dpio_desc.regs_cinh;
+	obj->swp_desc.qman_clk = obj->dpio_desc.qman_clk;
 	obj->swp_desc.qman_version = obj->dpio_desc.qman_version;
 	obj->swp = qbman_swp_init(&obj->swp_desc);
 
diff --git a/drivers/soc/fsl/dpio/dpio.c b/drivers/soc/fsl/dpio/dpio.c
index af74c597a675..8ed606ffaac5 100644
--- a/drivers/soc/fsl/dpio/dpio.c
+++ b/drivers/soc/fsl/dpio/dpio.c
@@ -162,6 +162,7 @@ int dpio_get_attributes(struct fsl_mc_io *mc_io,
 	attr->qbman_portal_ci_offset =
 		le64_to_cpu(dpio_rsp->qbman_portal_ci_addr);
 	attr->qbman_version = le32_to_cpu(dpio_rsp->qbman_version);
+	attr->clk = le32_to_cpu(dpio_rsp->clk);
 
 	return 0;
 }
diff --git a/drivers/soc/fsl/dpio/dpio.h b/drivers/soc/fsl/dpio/dpio.h
index da06f7258098..7fda44f0d7f4 100644
--- a/drivers/soc/fsl/dpio/dpio.h
+++ b/drivers/soc/fsl/dpio/dpio.h
@@ -59,6 +59,7 @@ int dpio_disable(struct fsl_mc_io	*mc_io,
  * @num_priorities: Number of priorities for the notification channel (1-8);
  *			relevant only if 'channel_mode = DPIO_LOCAL_CHANNEL'
  * @qbman_version: QBMAN version
+ * @clk: QBMAN clock frequency value in Hz
  */
 struct dpio_attr {
 	int			id;
@@ -68,6 +69,7 @@ struct dpio_attr {
 	enum dpio_channel_mode	channel_mode;
 	u8			num_priorities;
 	u32		qbman_version;
+	u32		clk;
 };
 
 int dpio_get_attributes(struct fsl_mc_io	*mc_io,
diff --git a/drivers/soc/fsl/dpio/qbman-portal.h b/drivers/soc/fsl/dpio/qbman-portal.h
index c7c2225b7d91..f058289416af 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.h
+++ b/drivers/soc/fsl/dpio/qbman-portal.h
@@ -24,6 +24,7 @@ struct qbman_swp_desc {
 	void *cena_bar; /* Cache-enabled portal base address */
 	void __iomem *cinh_bar; /* Cache-inhibited portal base address */
 	u32 qman_version;
+	u32 qman_clk;
 };
 
 #define QBMAN_SWP_INTERRUPT_EQRI 0x01
diff --git a/include/soc/fsl/dpaa2-io.h b/include/soc/fsl/dpaa2-io.h
index c9d849924f89..45de23daefb7 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -55,6 +55,7 @@ struct dpaa2_io_desc {
 	void __iomem *regs_cinh;
 	int dpio_id;
 	u32 qman_version;
+	u32 qman_clk;
 };
 
 struct dpaa2_io *dpaa2_io_create(const struct dpaa2_io_desc *desc,
-- 
2.31.1

