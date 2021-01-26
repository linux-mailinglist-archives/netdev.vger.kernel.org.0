Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF421303C60
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405578AbhAZMBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:01:37 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:42486
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392367AbhAZMAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:00:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6voaz0jlxJZZBRiV/SQKtSOhbds78NGPTmAfob1rxcDGTKb1HX6iW7LM4uE6i1Xt44qIdDbnM5n2TKMOcKm4cAuN+sDdxVJ50Vul47rhNlGdOdP1GczKWMbTzwv05IvdPuqEpOrOEpbGmlsojYTZOfMWxItR32LMGYh8XbR2nr8VECQqD2t6GzUplJqykyd5+p2T6AIN7iZ0qxXFDl+Cc9UbuQL/fo+q6yp/BINBHKU0mIVyk0LpoD0GZVZGjJWEeYH6bGwt7fYjvY0SUK4mESVWbz4JYev/7uWidpp5EjNPS/8SMrpytVzi6BH1n3cuylBOOJeCLzBpWPKN1pdDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5fBNq31F/BLnxHV8u15mka/jr/zcYzW7V2Yhf2HFFw=;
 b=C2Qx/5hCLt0/EnBD5F9pLurzOTRkJNlXU+KmlDG8lHSJ2ABvIk8oopFYtejfGf/TbMebhtRr/8JQ4H7l9F8dtO32O4PQIpJzp14B2Bd535h1G1pTl35nPzv2NwgJFp4WmPny3VPaj+xcC0dS+udBslhNUo0ARX0ZlXVTVNCkc4hj5JJcwbQ/e/cVW5xtJjFBR6V5Kq84nPsL/HDxyJYxMFJptWRHwaN+3C2j4aGw3dsDM0tL0vuOlC0pF8qtU9Qpyi6bs39ELAVJ53OBjkf7jinYuVWctMvOdU2SS3W/ZXMs3vmAEWl1Janx1lLL3ehAYeHyiQt74C8mN8ufuUXt8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5fBNq31F/BLnxHV8u15mka/jr/zcYzW7V2Yhf2HFFw=;
 b=S94DrXpQP35meLnOfp70zekfe46E6/y3UGfVzRWQB+VrSP0XeBDsXBsJtipDc9GR6YQRUik4PDcPG97I1RWp5DgnDszqVRSZdhq2bU8q/6fgSt1J1ckGPwYFZL+Ns0iiHQXcOQYy6iaaEXL20aYb06bS2ULrJPuOLM4MT27Qh9U=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 11:59:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 2/6] net: stmmac: stop each tx channel independently
Date:   Tue, 26 Jan 2021 19:58:50 +0800
Message-Id: <20210126115854.2530-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab49722e-654f-4070-c186-08d8c1f1dd10
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB697146E6948AD3C78551180EE6BC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0m9dh+QDcFE7r2Qta851e9WaS9Z4IiHf5iROoGaVRq4u82LtLqZkI+G7pw6S/9yfjdofQwKsGFg7/P7i4tpjJ4DnVOUNYnsoHL4/PEawBbIGo6f7J5wf/IheN1e+9GQpscwU6euEAeb/SbNYQ/wL6OQ+eVHsMtDTU2fzZKHE5z2PlLR19gqqYf49ww6IxbLHbgjkZeQjtoMrQY7nlaf//KBgdmWL4dAwtREW9qGZVPmoYfVlJPAeqK5wXshIQUf9REnniOl1AdfCnlHxsN1ANEUE5TzRHMSEURUt8EirpbBopkPg1XHKOI7HXqLvLX2QjCFMIrR9teDxJ3tHNWfAetuDhTUjoLj7Omla3sKZ5PJhq7LtLXFYuQGc/GglEu53o8uV38rr1CSgycpyAe9Wio94pCbfMnUnjdMtp2efkSaSSfdC0w2WrjQ8NLDCaADlHnZVTZutimKLFXrRhaYeVpduODYIgOSycuyfRfyqWet4SWrNd4GXWt97ne0AnjK6F+VBpKqmy/DeVhnPWFoxjgA8lRFkc+LbXTR8W2wkB8In0W1PYhNz5h8TtERgt5iiktnjG1B6NJ1BJFYr5gfdFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(52116002)(6512007)(4744005)(66556008)(86362001)(6666004)(66476007)(478600001)(2616005)(6486002)(956004)(66946007)(186003)(2906002)(16526019)(1076003)(26005)(4326008)(6506007)(8936002)(316002)(69590400011)(83380400001)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m9CmuHToeMomjqbwtwlGnzU5+wfnwdnS8kn5PBl1lIeJcoVmzUoOVVjyVfft?=
 =?us-ascii?Q?V8PW7qOOoDk1Y8BMhlwyhzR6O/FlXlgJmWVXS/Ig9ALou/miil+LkGdOijxw?=
 =?us-ascii?Q?fbhsGbB53NtbQsudikPNYgkMEov/XDziPSxLVyklJBbMe1/FCcjSjv0ST9Gj?=
 =?us-ascii?Q?gPwUVHa5qEyVI1LSVj9wV6189NWX2E1cCLGPAefYBcSLE5WjaS7m0zVmy400?=
 =?us-ascii?Q?aQSUxFmHGpTXzcEJZbVjVb2FaOdQqJxKxkVaMc/FfGtfr4rx0Hwid+TWZpay?=
 =?us-ascii?Q?KjkvV1qAKvrkJ6O491Tt26XfmJrEKoPE0owVM+25+6VrFuWPq433Wl6u098N?=
 =?us-ascii?Q?nvYd23YIKk7S4Ka7+rGLJdFLCJprOeR4QW1pLKXpq3tkFiO59m1FF4FidPt/?=
 =?us-ascii?Q?cVecvIh8FnweydWoEqDz7DYAII9mV9iol6/xTd1ViUL44MUjq/0rBlxdZiSq?=
 =?us-ascii?Q?pcwna0wfcmX1BNQi+nvgnuyF0cu+zQbTdr+UVPnmLt09dcPfdNxakaw9SQtY?=
 =?us-ascii?Q?NAXsLgBPbG4L15i3HNdEJFRRWeTJ7M2quSxwTgINFMeez/thaOAFyi+n7o55?=
 =?us-ascii?Q?mDp6ybx64t57S4iw0PvOo+GXDmd8h8pmo/iV5jHb5AxtGgCJGVZNoXl0SbAb?=
 =?us-ascii?Q?B39izNm78wAh2hoxvGxsQrhCGlvh37rD2rI89QgFH2klLBfDLX+EAroBAAYn?=
 =?us-ascii?Q?izNU8IirMW+jxPdojKSwakA2plBA/Vt65D4I6arJ0H5JRE+Xpv4BLvRrwN+j?=
 =?us-ascii?Q?8k56zP2/oiO0DycEXQuRz7eXa6RqF3ROTmN1fXCpA8zf9TkDTNa4Y89sRxqG?=
 =?us-ascii?Q?+MYDA58w+EVMG5kJGozndB1bTrOUZUGz7jcIUvoiypfm2KtgJZ8CZe/FtIez?=
 =?us-ascii?Q?nTOUpiCVEzwtASHFHlDkQ6ttScBzrLBFt8vwiBY+yu8mBFrO3y1whKTIL3OP?=
 =?us-ascii?Q?IDbYU9vbAdzZs9f29FOJB4m8LAnssJn3rpSk/L4XbBBkj38MWOmne1drJvfw?=
 =?us-ascii?Q?UW02dYE7goxgtZIH/n+0UeLFT+Pwi8OMREZHt5uRes4GaDeVpXzHfgztTzH5?=
 =?us-ascii?Q?OvHxk002?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab49722e-654f-4070-c186-08d8c1f1dd10
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:41.6900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIbmHJOv0qXLme4Yywe5kbWIjiQ8b2I+ipOqI6WyHMWsRm4JYo5UrFM/0wcBG01o9p/jMpFkoywmzFmZ8EhhIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If clear GMAC_CONFIG_TE bit, it would stop all tx channels, but users
may only want to stop secific tx channel.

Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 0b4ee2dbb691..71e50751ef2d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -53,10 +53,6 @@ void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
-
-	value = readl(ioaddr + GMAC_CONFIG);
-	value &= ~GMAC_CONFIG_TE;
-	writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)
-- 
2.17.1

