Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8283E5A7864
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiHaIDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiHaIDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:03:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2058.outbound.protection.outlook.com [40.107.21.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BD1B9F8A;
        Wed, 31 Aug 2022 01:03:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNESeeEZZu9lGjfQKwciNP2ZjhAkR5C5AD7gwx6DcsAcSMQNaFsH834a8K7Inf1OUcjK+Vl8uJ8CbbUJj9Tp6SL/7D8wQ1Y+vS+ELAbo1uuPyhNISWKxdMrvcEDMuUM8B3fQ59LpNd7pQmbVDlod16fHfsgD12L8cAcfmnUxWaWJaEoOPlQmVQmUk2fhbGu+zkpTvxxCgnH8Gp1agLypxXNLKD7hQpqK/PQsiW4dj2rJ4JYwreU4Kz7CXLEerEDeqwLIcWTuMNo8VTsV9tbL/Ity1xGDjJm6b5sGHfayLmh145cCLn1CIwmYMg8jKm8xEIWAxptg4UVaYJPDyxtOpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKM8lF50Kekz06qdN0izInd8fmkt4syGDxPDUMNPx9U=;
 b=MTwL6NM9OI2LbvbWl72kVKU52/eqfXqPJeo8HdplPD7C75N0xwgeNzLDcba9iJd7eI34ul5NBtid0oaY9KjApETc7plMcIpx9wqgRzpaUAL3wb03IajcjuZPCNaVP6kUJ5nnjoNcU4OqSzhANTGjmczyHEdFMonuSnPprtr0/8jmskmXfwjUfCyrJD1+CX6eY3VfDgOxRFnYwlpUtCNn0yK6T7eQWj4PTyuFL4X4CJXpnPU22sHK4xdFzadPwEFJ+Vx1HfiCQGtnRUS6pq7rjo5ZOscM50DquLTk8rAVi1wAZyTgU4aK3Ln0BA9MjiciMtD2LmI6I472HL56Lsi+OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKM8lF50Kekz06qdN0izInd8fmkt4syGDxPDUMNPx9U=;
 b=FWrj11jIkghvd07B6zG/KwzvUrBaVVwnmVakeZ7H7mZzQQyux0nhFBCKnEcp9aQfzGLGC17RekgxVwkGhp2pTYiSuFgrcwdVd4hnpE5yD2R3q5uxgnyPWEumpb9WE2uEvX0r9h8zmqeATtnwWj9DOBK1v7nvc40JJUoqjn/oZXo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB6PR04MB2997.eurprd04.prod.outlook.com (2603:10a6:6:a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.21; Wed, 31 Aug 2022 08:03:02 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:03:02 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: fec: add stop mode support for imx8 platform
Date:   Wed, 31 Aug 2022 16:02:37 +0800
Message-Id: <20220831080237.2073452-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::13)
 To DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc205802-6c9e-4e2d-5052-08da8b273a2d
X-MS-TrafficTypeDiagnostic: DB6PR04MB2997:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMEvgIRtEAAuQp9QuGkmiBYaCqwlvOQCfYQq0yy9XreN2nTUrjNdGaqgEZi/ZtSWY+SVHWdMXc5lpg8K6QHMRDqEUwzRYrpUA9epAK8lfYJWyfcAxHKCZCttwMS+jdaGQoTemNYCuHvdsexCfE9os3+uNahddHSJSpsPthCT0rUXZzoK0wDwlYRACl9+XFoALRwItIvl/fZ+z2WInDir11AaPpgW8Ipg2/zZbFtXqIqc9eI3mQvwGXDkqe0nTsL4CderQxdfM6CvWMyACt2eiSEQZ1JoQL1iRcxS65hXmReH3ftZyguMKgZmD3gyr774Ow3csosGb0QzqEkOkp7qe4szVzw6xbf+XAUweavr9791NMQY8ETFdjWNH714dvyDaJLbb9Z6s75vU7zoMZ/KbGdJrFX9msWz/7VIfHJ/81EmXWI69dbVbNKWfCmkebC7OZ8ZcZ/3cgVEHbYiPpzvFHRoL2MJ2a5clnTnQExq8PyxWtVIFuVuA/VuOJJPYchuse/OOYzkN5FTnKxcU9QmNQiErPEin+dV6eOpouu5DlTXOVhX/p2C/DlvM68omCkmcGatUcu0kIQT9brHfBsHZYUbVwnrAzweXHkAzgk7IvJKt0JTlwRX2ZKhcQRTAKMW+KKKvbt3v11G7ZZgb+sLVJKD+5ANob4wsD5xnj/GPBMybPv9t+kWCj6DA+mIwtHOs6D6dNM2qqbrU1nQfRw7cwe33sHTQHqzVjTTcv9P5WW6Eq0hyQ32X5ADhRhnjyIFv3T5qjWeX5HjzWFk8L4IdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(6666004)(9686003)(52116002)(41300700001)(6486002)(6512007)(186003)(6506007)(26005)(83380400001)(2616005)(2906002)(5660300002)(8936002)(1076003)(316002)(4326008)(8676002)(66476007)(66946007)(66556008)(478600001)(38350700002)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hTbpo9uh0aqg7vQCjqvadEogG7O/9R01T2fv9TVRS69C7lg94R6p9xc7vUcS?=
 =?us-ascii?Q?H1mYO6301i//OYu+2iLioOO/+JAN8XUiQBwzR+coCCFp5mFzYBf6iOO0vAj4?=
 =?us-ascii?Q?qJGcxVPo3DzhUrUAxZPY9YLGH7rmo1nN6OviH7qjpXhDX5QgX+xayiW7Qljo?=
 =?us-ascii?Q?V6ePY7H+n8c0ATcJ1dQO1d9omNc/xT0UGqU/gSTDYaUnvAtT1e/IjI9lFLhc?=
 =?us-ascii?Q?OfbgWwa1F4IL/mjCezbIei/8sVSAeaZzmKtkxLuIR0leDGw6Iy5S9usFvTVD?=
 =?us-ascii?Q?c/5z1hdub2id7+m2zG8TqlZ1tilR80NoWpQ3cNSviyjc+r/3haUSaJYoReaW?=
 =?us-ascii?Q?8r7snF2HfLQHPAz9KIZDVukiIAgDehknxKyc7Ci+wYydGjati+gepptnKMdE?=
 =?us-ascii?Q?4ULqLW6y4AdHCxTQx2a2hujg6Lxb6/HEOSvwMprXOes/+7JBnHgHI+EGzi4i?=
 =?us-ascii?Q?/xcJZ2pKYzVVlU/Em8QCvZj7s1zSqRlHDlC8forwG5whaDexvjbixq3o6OCA?=
 =?us-ascii?Q?Wp/PMHFlQyFZSub3Q7RjyoobtA8OIXUwft4sb7mKSfvC6SOjEGUIaPIsmMic?=
 =?us-ascii?Q?jlE3lfTDcUFPHqHkZ/NGxVgck5y/bQGdEgSpjpQxKXTT0US1PI+6FWi72OnG?=
 =?us-ascii?Q?75s+cesYJhj2d8wE3iM4yYyg1dHUfDss0m91TmswtgvpG+sO8PWSrrd26tui?=
 =?us-ascii?Q?tI733LhZqG4AHNnGqIGACitegWl0audPQFJHG7z5bL7IN3cn9yhFcCRIlk4b?=
 =?us-ascii?Q?dKYCzUVFRcw2nIOCb9yET8IGDkOkTtCmZWmdZhigOhx36kGIR3ME1QzpXbVU?=
 =?us-ascii?Q?LNIT+QSdxGHDNPu/j8HsfmwIG1YoqWKHck1U9tR9iRcP/HKDMSDI5YIT62Hp?=
 =?us-ascii?Q?QckEvajDUfJIl9oxzV0g8raI4zKpF/p0HKdvtANz6m8grbYil8y+Q8S9COFB?=
 =?us-ascii?Q?0AP+y7vNq17wKYzfxQYbTWInXxobthC0uqvTvHoDVyz4ibZjLdIDYN6XWY05?=
 =?us-ascii?Q?qH/TkjM8MpK5mtPItjRI5LFXTE9MES7L+R9srXrgX8FU0Ett3mrxMw7ZO9+E?=
 =?us-ascii?Q?KJZN3lOBNxJRtLVUMd5tgjDEMIWkhind2NXzNqEv08SBDaUyaj6sc8NFjhjX?=
 =?us-ascii?Q?hchDe5unAFvw34pD5lg8WCpfnESXdVv0de5vlh2JZJGZMZkO4FMcLTQ6ft9+?=
 =?us-ascii?Q?v+4lyPh6TK+6+MK/4Pi8/KgValGp0J2zWie//4Q1B/JqCny4dB3CULFkaFtL?=
 =?us-ascii?Q?C0b/Sc+67zoMjHkfGXB4VjWygpsK+pwqKh5LQQwF5DdyLhQtGgkToZxnhTFO?=
 =?us-ascii?Q?23NMJZMrJX0k211Mcneo0U+tt/uiIzkmzNSvkudYESyYre4X6lzmvbbPc85Y?=
 =?us-ascii?Q?9Lphnj0bM50dPgN+m2lWqdV/1Ofl31S+ONwmwaYrWPmFpwyUz+SCiw9cfXWq?=
 =?us-ascii?Q?CelqTLBoBxWtT0z4qy0LBlfTXgEtezWCxPZZXN+Rcf7fMphNqxdq/jaKL/YW?=
 =?us-ascii?Q?A78QxXEPc3LjXbPo9wVei1ecXNOP16sCly9+pImIvQDwqFln5jtR4ogTL0fK?=
 =?us-ascii?Q?hw/y1Ih1oELVtJEttmo2SOYyoazTRbtpdrXuGyWs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc205802-6c9e-4e2d-5052-08da8b273a2d
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 08:03:02.4098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzH73hlhisNYDVSflRMSPHKMcvXM6YShnD4XST0k7tdZHxFJFuPB5xZWVipSrA30eCPYpubTWjBvzs/LEKQtOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2997
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The current driver support stop mode by calling machine api.
The patch add dts support to set GPR register for stop request.

imx8mq enter stop/exit stop mode by setting GPR bit, which can
be accessed by A core.
imx8qm enter stop/exit stop mode by calling IMX_SC ipc APIs that
communicate with M core ipc service, and the M core set the related
GPR bit at last.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  4 +++
 drivers/net/ethernet/freescale/fec_main.c | 35 +++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index ed7301b69169..cbde8f148c16 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -18,6 +18,8 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
+#include <dt-bindings/firmware/imx/rsrc.h>
+#include <linux/firmware/imx/sci.h>
 
 #if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x) || \
     defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) || \
@@ -634,6 +636,8 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+	struct imx_sc_ipc *ipc_handle;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e8e2aa1e7f01..3be7ee67f379 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1167,6 +1167,34 @@ fec_restart(struct net_device *ndev)
 
 }
 
+static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)
+{
+	if (!(of_machine_is_compatible("fsl,imx8qm") ||
+	      of_machine_is_compatible("fsl,imx8qxp") ||
+	      of_machine_is_compatible("fsl,imx8dxl")))
+		return 0;
+
+	return imx_scu_get_handle(&fep->ipc_handle);
+}
+
+static void fec_enet_ipg_stop_set(struct fec_enet_private *fep, bool enabled)
+{
+	struct device_node *np = fep->pdev->dev.of_node;
+	u32 rsrc_id, val;
+	int idx;
+
+	if (!np || !fep->ipc_handle)
+		return;
+
+	idx = of_alias_get_id(np, "ethernet");
+	if (idx < 0)
+		idx = 0;
+	rsrc_id = idx ? IMX_SC_R_ENET_1 : IMX_SC_R_ENET_0;
+
+	val = enabled ? 1 : 0;
+	imx_sc_misc_set_control(fep->ipc_handle, rsrc_id, IMX_SC_C_IPG_STOP, val);
+}
+
 static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
 {
 	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
@@ -1182,6 +1210,8 @@ static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
 					   BIT(stop_gpr->bit), 0);
 	} else if (pdata && pdata->sleep_mode_enable) {
 		pdata->sleep_mode_enable(enabled);
+	} else {
+		fec_enet_ipg_stop_set(fep, enabled);
 	}
 }
 
@@ -3817,6 +3847,10 @@ fec_probe(struct platform_device *pdev)
 	    !of_property_read_bool(np, "fsl,err006687-workaround-present"))
 		fep->quirks |= FEC_QUIRK_ERR006687;
 
+	ret = fec_enet_ipc_handle_init(fep);
+	if (ret)
+		goto failed_ipc_init;
+
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
@@ -4014,6 +4048,7 @@ fec_probe(struct platform_device *pdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
 failed_stop_mode:
+failed_ipc_init:
 failed_phy:
 	dev_id--;
 failed_ioremap:
-- 
2.25.1

