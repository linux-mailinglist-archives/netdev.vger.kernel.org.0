Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9112CCDC1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgLCELY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:11:24 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:11550
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726977AbgLCELY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 23:11:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N28OTV7fZ+488ghvEstlZbaPUY5ZQe8N/4mAXWftHDvEP4S73/4vmm1yXjgw7zoinracSOjjFdTKWkDQ8v6td8kBn0xqnsszTEmQruOwtX301WN2vFlJB5UGuT5Weoagl0TgZX5JZZDDehKP5hSiibC2JlQgViBq2kvMcJHgdviwTnhnJPkmaOIT04ZmjPx5VWu9K0CJGmWFQbETQRM0QBqxl8+9c6Q4fRkiJLCUCyogPrEuSEmuYmcl44vMG9GDeOhWH0Res/GOIuqutP9EbN8uXwKuTVveHGW8gJCa/3lnMYjVURG717Ze5MCdeX5/U618vN2ZpViJxxpPz3RvSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwDrqQIS8Zzc31so7i12rjVAVaraGYQW8sn9/AcIGhw=;
 b=g70yAw8DU2Ic1lUukCUsubB8JyDrtaz0CX3cjXGr4CKjC99f1b/bKUnpsrVxUn7PX4/+ENZUFNzHLI+y/vW0Gj7FIGiz1/pvMLkMIV5tYyWHDyGG0XKoSsKtJ5GMA6IB47euV3/r6GbIHPJ5e+bVdwf1TJNQDTZyIKoHh9LZ9it+55maKS2qf/ZGFMzP4t8wvsj5YLT5FdCEKPiorpJdmAAEZYh479GLWGjPnJgYTUHgZt4OqdWPrRR6swRHqmLT5aaUIwIuUSC+WSzmbk4QJZKr+fL/d/lphR3GfxKTILYSN2KbCzS+l46ABeW8jLYIsX+K3orFG28i3nmwdlqaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwDrqQIS8Zzc31so7i12rjVAVaraGYQW8sn9/AcIGhw=;
 b=m5EBHdyHVhcEEAVv6wYdYjDAfxQxHk9YRzep5tdWijGBUsChJivMeV7pKNy/MizHT4Bq8Dw9xuWqBjKQZiVQ7wsrWaBrGfm/IMvx56QYJUxEcCrd/rqPCOvOa0BJClTHEcnK3Mv/+B6qHeAdJ9Kr+IPwe6KUZ9o+QD0efjOOkwI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2727.eurprd04.prod.outlook.com (2603:10a6:4:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 04:10:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Thu, 3 Dec 2020
 04:10:33 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH] net: stmmac: implement .set_intf_mode() callback for imx8dxl
Date:   Thu,  3 Dec 2020 12:10:38 +0800
Message-Id: <20201203041038.32440-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0095.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::21) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0095.apcprd01.prod.exchangelabs.com (2603:1096:3:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 04:10:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1dcda2fe-79f9-4a43-9c74-08d897416126
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2727764EA9272061169BD091E6F20@DB6PR0402MB2727.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTlPzt3XYRePiRrS5qOY+A8ss9j/6BOdBo/J6MhthX9Bnw0xkSKiEeNI1CmMLA8+HMj2z5YgYg5rUGl2D8pvM6TFdYPuBPuoJnvvXA1PImrEY0BqgIpVi8FdUxTcw/F1no53odiv2s3xsBM/3VBS/wpPU9Ed18etehNUjJ5ZBD/A5MQFW4ffq8+4hCPT+UDEoVYlFM5jK0iJRh+S/RhvvjUE+BFRkUTj1h1euiwB5h3FXAHFpZu1r6qUBDjevTaQNIOldpqyOcLuGgDi34xcD2YyDJGM4z/jZyllwC+ITb+4K+vKcS1xOmmrTzhwVJO0amuhhhZVtzz1wJy3yT9387MCBiyxLgNo+Z6Pdb7XxJQQUC3Z+h9Z6Shqtf5pHeNKXpZpGFPvlg8REH2Vge5X2u4N9i5HanFL3R7fYF2BiXBzKI75SySkeUcPHDFE9cOU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(69590400008)(6506007)(26005)(2906002)(86362001)(6512007)(6486002)(8676002)(8936002)(5660300002)(956004)(2616005)(36756003)(186003)(16526019)(66556008)(66476007)(478600001)(52116002)(83380400001)(1076003)(316002)(4326008)(66946007)(142923001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DH1Snknk5FHAnr2quz/xrugfcRNE5xKqUMcj8qqHqKGG0YffZgA0mIf5LuTl?=
 =?us-ascii?Q?sjRmnPJoae6iDrhv27MCB/A48OOxjMEB83RlteHWOBuvX+aX9lRcKjc95fse?=
 =?us-ascii?Q?OeclP5SH5q+NTsn2cwDXJLaVUA66gcJhqBSWsSAFD+6iOpv4q+AYTy41R9WK?=
 =?us-ascii?Q?BWmLf8yfGy3wN4gSvgjXTgBghHbWtPC8+ADy6d5x6G1vcVx5e/cP3guk9fOe?=
 =?us-ascii?Q?8bbAfRhdY7QGVeg2sS6UZPikrjo1jwSr37hD+j5/nLScSQtISZ2iAJkIalGN?=
 =?us-ascii?Q?ZFKGTuQPJfdjblYoq3Q1phZRhU3bePrsuE71z6PO4xxsy/k2kMDYkCmTZ3q9?=
 =?us-ascii?Q?C4EM+p5dhg8Np6eSAMSaZ7kNeTC+QqIwTQk8kf+IMYUi+hl7SumSUIIgO/aI?=
 =?us-ascii?Q?XOiydCX5sZ63sZIn69VagJD1Y3KesOYxMdPebQ3tWZnaBXi/47fEOtBkLgcD?=
 =?us-ascii?Q?MnL3cKwXmgP07OWG5FJNQHHOCSrOPdih3YFvRkHRXd4AcfcaJDpnQ/FSdjJR?=
 =?us-ascii?Q?BqhZSdCPhMbfMuKVBNF35MTbvQcA0IWkqrBX6fQXOL5gmvrBClSXLrXVHysy?=
 =?us-ascii?Q?uNXyFrfhtlqMXYSYXzrPT9ZREWVNkgnr3uKhaG0KHeJSqG7ajXmlE7D1q05h?=
 =?us-ascii?Q?c0Z5xRpc5jU2iXrWKdun+DkWp7p4TpoWuYPrZWqBFsGVUbWWNLK1MGibTRay?=
 =?us-ascii?Q?rahix8RD1tRJ3d/sz8471JFHB+SLyTh0/Ay4FLzBySziMNZH28VrUgiRFs0e?=
 =?us-ascii?Q?AFXLdCv+UH4WfKyV8CgnJTvUXmuokhA1AXgbzBGasZdXSySF/+zbxw6o+PxG?=
 =?us-ascii?Q?6DjatXmW+LKhqmAZnecqK0BKbJJD02LZUWob8cQBasmRFpwwNEruma3fUaTn?=
 =?us-ascii?Q?3rY8dQCa2jlX986olGnhkyMngJ2DJM6/+VAidK//I16THQ9LY8KCuYt+n5b2?=
 =?us-ascii?Q?mXXc5wMvH5i6Ic8Tdti0MLjks3b9Lagxcfr0/s2DySkkBMTJ0SqskeRsZnca?=
 =?us-ascii?Q?w1jq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcda2fe-79f9-4a43-9c74-08d897416126
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 04:10:33.4719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vW0qzSmL05UQN6ElMx5o0M2fA68B4UCu82lsZP4zfu4i6kYFaeKslCaoYqp+ew/cvuH6N1PD69ieaur9cGYjuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2727
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Implement .set_intf_mode() callback for imx8dxl.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 34 ++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 223f69da7e95..1d0a4d73add6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -6,7 +6,9 @@
  *
  */
 
+#include <dt-bindings/firmware/imx/rsrc.h>
 #include <linux/clk.h>
+#include <linux/firmware/imx/sci.h>
 #include <linux/gpio/consumer.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
@@ -86,7 +88,37 @@ imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
 {
 	int ret = 0;
 
-	/* TBD: depends on imx8dxl scu interfaces to be upstreamed */
+	struct imx_sc_ipc *ipc_handle;
+	int val;
+
+	ret = imx_scu_get_handle(&ipc_handle);
+	if (ret)
+		return ret;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		val = GPR_ENET_QOS_INTF_SEL_MII;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		val = GPR_ENET_QOS_INTF_SEL_RMII;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = GPR_ENET_QOS_INTF_SEL_RGMII;
+		break;
+	default:
+		pr_debug("imx dwmac doesn't support %d interface\n",
+			 plat_dat->interface);
+		return -EINVAL;
+	}
+
+	ret = imx_sc_misc_set_control(ipc_handle, IMX_SC_R_ENET_1,
+				      IMX_SC_C_INTF_SEL, val >> 16);
+	ret |= imx_sc_misc_set_control(ipc_handle, IMX_SC_R_ENET_1,
+				       IMX_SC_C_CLK_GEN_EN, 0x1);
+
 	return ret;
 }
 
-- 
2.17.1

