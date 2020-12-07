Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9BD2D0E70
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgLGKwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:52:33 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:34337
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbgLGKwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 05:52:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EERGnoYdDXuHWcTrg0uYPL//15ypcjS4ox8mMlA7ngsdPeKM74RAgU8GF66xY4De/Ew103tQu0CGFOSdsuDU13yi1ZHoOlanCySXWBV6BMy5MDUQsZT0LAmpwdd3itOiSV93+JftutNbUv0WujrBYhxn2JHvpOIh6lF55OOWcLxUGFjoQAVo3muMLXOLMFgwfvOhAP2S1FTdlnsGAO5YNTGnpheHmENZMmt5AjqpoSX2VaHMHCf+nBscOsohP9LgFepm1mVpJrYsT8H1pxU946FEIFSzTHGE7yoacdsCsQbh7bvq1MV76IEtJK2HstTRhqtWhyhDZ0LYBsBFu8r+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3fvrFeNCKOZe1LfevmI8lb66EX3HQ/9xsBhU0yn488=;
 b=aVqmpTBNFrkEfxzI96UejD1R0xLaOTZme8rH1eVfXg8myParFr67K8U0V/8Aes6MWwRfrh/MjnTC4IUxzCTRwqj3FtaHvdcV4yOtSEePWBND9WszDMdskcG1yEP4d/2c0IeWF8wTPMscYlfIv3NfObjvjoXjXRbhq1uWsbZnk4qqrVMRpTgZeUAsvzJUJrZv5Sewe+XLTJM+dnXPuOpTwcN9TiQXvxQoZxdr7BzvYU1mMP6pac0Awrjhr/VUlR95BELV7o2NbEt1W/+zmlvZRKMh2omWtHLaTHhOTzhF5gULHnLxtjvagk1VWTGCD1SIUvwKyryND6oJIaRCkNOGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3fvrFeNCKOZe1LfevmI8lb66EX3HQ/9xsBhU0yn488=;
 b=lPmGN19/YZoxkt5ji/lHJUHx3MqeEMLaK+4eC4AJiR3lS4t3TRGqzwoCrsnFz3k4Xk2POjbgxC2z/ZW3/80WoBHEvPGuHcpWYk7eAk1xj2opy/fceRlCZXkXgnpzmE0+ZnGDIeuImPCHSBdE8zWfDMpE5bYzfkS8ppDTpkiJ9iI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 10:51:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 10:51:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 1/5] net: stmmac: increase the timeout for dma reset
Date:   Mon,  7 Dec 2020 18:51:37 +0800
Message-Id: <20201207105141.12550-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
References: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 10:51:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6928c28-e007-40f1-b23d-08d89a9e0df3
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB23288FDCAA160464257646D9E6CE0@DB6PR0401MB2328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgMRqIeDPJioKEFrWIhlTAUfif234NgutSM3LLCeniAY4URpLFCuWsC14xUz6++urkuZKOEX4D8kTN1Qd6YqTcjJKYn48LxdeXO4EyX1hKsz/xi0nrvLAg2nwaQsVjo8bA1Vx/mugGmhIJqbUcO2YpYZqsERL9BXMJwtt4eUA+d7A5GTlrGNk4d3ChUSpiJAJ5uONu2f1TuJQty1sHjXuqyIUkHCtTByM49l7wPCtaNT7LVQF/JbSWSSKW5AAiqNNb8lMrFgbUR2iCErRYYzS9LemwlPyvlU0uIEbpHOZve35VoK6DJXo0sxtd1DYYFoUnBpjt8jSThtYoOcAU5PllcJrZyrOpX7Kb2bYm8VUV0m/AccZSLYoTtafIFblAGX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(66556008)(66476007)(6486002)(186003)(956004)(16526019)(6506007)(8936002)(1076003)(86362001)(26005)(4326008)(8676002)(66946007)(316002)(83380400001)(2906002)(52116002)(478600001)(69590400008)(5660300002)(6512007)(4744005)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6qZ/GnBLR5IzLNwf2T0RRGiepbAoZSLzztXGR34s1BUseuQngYt7Q7mrj3bV?=
 =?us-ascii?Q?p2UitlMorLL6eVOOU5AYEkJT9ZwzT2h/s8gNaJU+DKdPEbu1zaQjHp27u/TI?=
 =?us-ascii?Q?DjzbbiIVqKvHqKprD3eUozpRgLdE1+Y7Uru/YkOqkPKd0pc8NhnjklRYI9Ig?=
 =?us-ascii?Q?LWRR771unuBxCfiCtvQldACp6eNQW9l7O+5XTuFGPj17LjRvVAeM6CjdquV7?=
 =?us-ascii?Q?TQNxuiuEAvgS4guy0sn27zV4gXsPangoKPvYUC8hR1U/7LflKbNiePCZb+lz?=
 =?us-ascii?Q?d9HlwfheWPbIU1P5SMSD1zX1WcgzdShRim8c+VCuK+RaaXHftnEttrN6YC5Y?=
 =?us-ascii?Q?pnHzEjmQVgi4dCCVDa9jwjzfIQzAHUAxEcpfwDlH1afMIKeO890TPLx5XGFG?=
 =?us-ascii?Q?yHx/Ik3oNUITkINo2WWJ0+wZ/7uSKBwPfnUSOFE9dBEAiuCK68Z9D/Mp4A9h?=
 =?us-ascii?Q?MHGq/bqRRnoseTBKmfPAHZs5Erwam7KkjXRQYzSrGfp2taT5ytRsD043GJa9?=
 =?us-ascii?Q?Zx5GpxQiLjnVZDUqfpheXnnjeojPgmMUJd6BKFZ23YyTGIhV8cEAy7mOZcWG?=
 =?us-ascii?Q?BRCHbJ7m6Hncw25QYZ391RtwOIIe9AL9QnHPdWf2RUfT+NtvpvHxHyI0E7sC?=
 =?us-ascii?Q?m87q4b1zq8Pp89Rx0APbJatwHn2rLGt425QH3NIx9fMFlVp6AalbyMgD4gDB?=
 =?us-ascii?Q?Mv4iXAyhiwDlysSj3npFMFx+HZ656Z8pDChKWHrUBxR66I9KCLx58xVNf+3a?=
 =?us-ascii?Q?BOnGVatD20NFB6oYb4p1NW+vhP5X0v5Oin55VxWkhq1mmW4RcE9XtsegE70n?=
 =?us-ascii?Q?4uWUidZol+k1Uf2JA/5RjWcF1TQ52OeBaGi1EwhAvbgIhf9EGkNPYoI3tiH5?=
 =?us-ascii?Q?a+niwj0hK28U7q4hnrqgqumUZL6o8+Ly2DrGWHoo1fEhoDZJd0fzhtAEZMJX?=
 =?us-ascii?Q?auRkLNh+GCZ0yAHTHaTDCVgJQcBSMVdRYrEhf9ctq8NdE57YVV6MWZ0oQ3mb?=
 =?us-ascii?Q?Bo1e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6928c28-e007-40f1-b23d-08d89a9e0df3
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 10:51:30.5706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cC/JPlagM/MlRmrecUgFky7miuP3yCH69YONPMzovjIxOuJRXA1XlOLhp/+64OVT97lKnayIoG2BgDhrDzg4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Current timeout value is not enough for gmac5 dma reset
on imx8mp platform, increase the timeout range.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 6e30d7eb4983..0b4ee2dbb691 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -22,7 +22,7 @@ int dwmac4_dma_reset(void __iomem *ioaddr)
 
 	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
 				 !(value & DMA_BUS_MODE_SFT_RESET),
-				 10000, 100000);
+				 10000, 1000000);
 }
 
 void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
-- 
2.17.1

