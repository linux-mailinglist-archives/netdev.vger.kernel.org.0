Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF1728FDC8
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390627AbgJPFoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:44:04 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:33504
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390478AbgJPFny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:43:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmMqseSiJH/tqg2Qc+UEWfuqnC9M6B+hFpmzT4/QPzCD8979BKpZDKPFDItMXpB9C6MwRrW5bcDuzoglmoiV5rFZ2u7wCooqziH84lx2eMbt3CdY/Lsfnt3ESrssLQSrNeMba+UGo5jZQ+ZU9cfq2vYV/gvQHt5A/5r5vBh7U0Xsr8eBr4XOeKzGDamlmZpNrLQIxjhLPjeLwmtKrNAj+TWT6/S52WwLjvpNrLe+xo9mYt214/1BLYS26YXoQU9aZN4EkIuP9DTRzFrJ0ASy9vtZs/ySt4CWOeMV83m1jN7R1aN2qEFJzkCTU91D46xmXGUph+/9wjpDrlXRUANYsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Y/QS4M9MnQx3oyWz449uvx1QyEdxbAVuXtCNrp6lI4=;
 b=Fj7EZrvCONKjBnt0wzEKcGXrR9Yyvnfs5V31y+iN2XJHV5h8n58w620VAf5qVWGtROT8gm+dF4z/f9aJ7H2OuqUj7p67Q2skxOI4/VzaqeEVQS+f6/veaOMzkvRcpqcpKSbmPFgirrx2SXNFEQLDuCrQsjc5EK6A7DalKQnmUPP5cCwFEyAitHsfXecAafVfEmR3s+1JBtmsgjAU33ldayV0+O5TnvtAT/XPpkbHJZ8aI/Nw8t1Qfh8Uwg7FZZQh6znQ/PlwbqNo/sZbyU2SDfkLl4xsRdd4AmtLIajvliAfuq2XJYtkRwnCr81KrJ44iK8M9g/suR9gFCbbhCoErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Y/QS4M9MnQx3oyWz449uvx1QyEdxbAVuXtCNrp6lI4=;
 b=NRUvSiiEhEi9QI7eJ3O63y3w83CGUOaknJiBrIS8vZQmrn6nmExBewF3yeqQ7fQ4KK6bAu7iWyuvfBcZY6nDepMsImUaGrXMQDThxW7zy/HgJxfijsIMHxoqXla4osNWd6505B4BQ7+vsbuIU/b42FRy3l+CU0cZvEP6+nghb70=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:43:25 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:43:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] can: flexcan: fix ECC function on LS1021A/LX2160A
Date:   Fri, 16 Oct 2020 21:43:20 +0800
Message-Id: <20201016134320.20321-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:43:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e08a2a8e-e6b4-4bfe-67dd-08d8719665a8
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73331F1AA40DE0B513261FDDE6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEZcqxbOQSkrTr+1V7E8wPJs4cQOYoG5ei5W/sdwGLvjm9aYENNGO+hu0fWyLc+KJBiM/wyPuDvFyex6hL8iDNocOPECjWHahqEs7kt+m0nggAGdfjLOaL+5o/+vFQkkpF7zcpge0s6hnBdaGmumR7MeRDL+XAr1IOF5Qbikr0H5u4bKHEq4ZJZUwxKwRnEKUqe1cKn5kkhDN1aUrYVSo1511uJZlPc/NlhFaLG8zq0nkPIL1vkzjiEhaJ4qNjNt6hqEC24wckth7Fx2OPoYG49RdGZwC2eo0IZ9/TCsh4nlrybQH6T/TsTcwOCIu/Gk3NnZOKcaAjhIbBcwGCZY272TL1k/in00AJhhamh/Tu4pPV/IAwx0aMGt+Ju0rOUPcDEUXzieEIWgr1h7tC8mG6zckVa8Mn1SbRJrcagR7hg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EguAOlHjoxgedeTEUPygzYalZvoDlANpeTbLMZ9pxOBHGnv3lRnRblyJSBFz0MG9YbG69qM1pzJJA+1iCa2ll1Gcq5P+VNomEoDWL4gX9f/WWKUO2ESCoKVYD0veruFyJW9ipaNByEE9erIAoK4r6CaHU+bCXHhSVLwrRrN6HFmM7Sge2jbTcVNvxeoh70LJt6uavop+oBi00eaDQEEFBV9bFIxxnR9whZ7hV3lI1EK5WolsiOw664UKkw7bLfwcLIUNvL8dKs2ejziLbDQFcpQRgSQ6LJPj6C9cQyjWtJwz2rY86v6xeDpadFxx3ewIRKVHELv/dgHMRqEosZ3/sWroGNboCAVf2xIwez2K82poTvUV+dfBoVggyUVRM3Rs8gXf80xUkLvF+PAwseMXs3p9f6Enq0fLSPxduLXP3oW5oBDZrCzkCaHnRw2VCVzshzAtlFULNg9RE9LYPD+sV5GSikegiM1+Mat/IfXQQAPmm+xth4NFSyANy0J3IE/8ND/ODvgg++dFinqoIpvgefWMjK6ljxjyBQM8WjuYliQWNDS8oCHxM0+fC4ZxKH4MDEpPVkKDOoUo6zFUbLbcMPSqSRETkxUrYR21+haBSA1Fj8wOL0ZUA10ZZk+TfJoaAeiSYpPjeSEQA0fu00CUVA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e08a2a8e-e6b4-4bfe-67dd-08d8719665a8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:43:24.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpxDGS+D20yn9xz9S3C/koyVrz22IXObl+7gZJN5WKPfZXtaq4iziGq0D9/VE8f3J1fGORv8tomoxGzfd6PGqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After double check with Layerscape CAN owner (Pankaj Bansal), confirm
that LS1021A doesn't support ECC, and LX2160A indeed supports ECC.

For SoCs with ECC supported, even use FLEXCAN_QUIRK_DISABLE_MECR quirk to
disable non-correctable errors interrupt and freeze mode, had better use
FLEXCAN_QUIRK_SUPPORT_ECC quirk to initialize all memory.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index a55ea8f27f7c..7b0eb608fc9d 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -219,7 +219,7 @@
  *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
- * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
+ * LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes
  *
  * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
  */
@@ -408,19 +408,19 @@ static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
-- 
2.17.1

