Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3E42F2E0F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbhALLf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:26 -0500
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:62622
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728953AbhALLfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjYymXVi2IlfhYrwRzPQmfo+MtIgQgoEoP9WooJrCo+tQUkIf0VE+kVaqA6b3XnhFtbZElBu8iKCAsJCN6AWaxmMvbco/WhedgXWz5LBKo8CMjfHojFX6ufag01Ws2DZJMU2mUzdoYOXLdtVy21H7Axy2PO3sfWqzHaTMdJ62TyOuFC5zQVvgJ2nuuqIiaQPtyfznD9pT3VWRHmh+f0TTOCEelhb1/sbhFjwU5K3fNbgiBbIjWx6RwBrdDn0HNyKooAku5X7ULRDqHCh5Y8/kdlFIxj7YMICsmXw+N/sGpS6AT1V9MfUr8ij0/yleIALXAKIYaMHC0cLvruchTt+yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5fBNq31F/BLnxHV8u15mka/jr/zcYzW7V2Yhf2HFFw=;
 b=TJnSydNNBIdy/HZqCUEYrdzVDS25Kss0KJnUXDTVIyVLrFY+wpfMZLCsu8QyMvLTogsypdAw+83cnvnD3HOF4U7vRlGujNyZ/pmf/fipb5f3U/ZFKX/1bo/4n4T4/z8bavhQtKTaR28RkTLhEsgrScBfb6zWmQ7x29FX4kmvmR+oqaXkD15FAxhSxXyuzAuHiF9WnqJ26JP0JrRbf9C3uQGkUa9vK+DYIhx3XILkF6QNmNji1pmlhv2nxDXgX7Qe5kE16bWcvFghB8Mh0B8llSBwXd/QFtLwGFMwRKWME9Ws09I3V3BnOBX5JPObNJxRIr890QqFv8drY371Fn362g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5fBNq31F/BLnxHV8u15mka/jr/zcYzW7V2Yhf2HFFw=;
 b=SRzHckXKFHeW2qE9kqzoxEYijgotXK2/+tQu0S/xoVDnruNIA2//mrQ8QsJSLl+h46ohMCP2tgnAYVzvZXlwTM/bg4Mvw7PgGcoy8T8soW+ijTVWpN/k+5fQQomXewWwWxakK/6S5IBLU8b/eM7XcL8DXjwXvTSQb0vCCwX5aao=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 11:34:18 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 2/6] net: stmmac: stop each tx channel independently
Date:   Tue, 12 Jan 2021 19:33:41 +0800
Message-Id: <20210112113345.12937-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca2250c5-7185-4a9a-640a-08d8b6edff51
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6139FFB0366D5AD83634757CE6AA0@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5SEONEp+QiCVR6DBZiMZ4i9Y5h7EGOUJw1jruGmnDZWuMkwa1oNNuf1L1CeSlSL2CmCme9dAxIjhMdr/8owq5xee5ZxoZX5wNWt0Z/Mtm9Uva+9mvrEFZ8yfLGGMJrIh3QSLRmZ4B19R7Qtjc0dGhuvLzHT2nNmub5aWbOg+HNwhGAfu5bK/CQ2bjdU+91f737lfNa2Pw54iDBMGQRvxWDaJ+9BsPRCGxNxggC9qo8ahUOvf0a99a0ayVnuwqGjCkNrndHxx3QafxGjnSUNTJnl2gBv83hdQUf/C1Tb2YQc4oxgUBvXsPrDpohm5r5Dh2Qf0EEUQpYztFvdIElPwD8Mf3c1M1UMcmaRFYc/LA03t9qJt+2ftbZZvWRWsWfjeLFTvccs/oYLzVWa7ohrfgjWdGXgSYN8fkKbVZSCjmwahRMI8soMgkRz/2gPoeOo6hpdJ8Zvafc6o9NnhqYZchg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(69590400011)(66946007)(8936002)(26005)(8676002)(6666004)(66556008)(66476007)(1076003)(186003)(2616005)(6506007)(498600001)(83380400001)(6512007)(16526019)(956004)(2906002)(86362001)(4744005)(36756003)(6486002)(4326008)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?z2m7kt5Nia9Dxf8nXkKbLMtNMdil2tPJ4/iwVqdgjdVmJ/5iGMwEEzjiSEx0?=
 =?us-ascii?Q?8fMud6R6vG/WrOccA2ttpHoY9ej0FWpahOJaHzgEk9yuPYzqbxwenNr3Mpt7?=
 =?us-ascii?Q?MaoNdwL4HArLuRD6FM2BYRgr+W2Ir3xnDBKbARUHtOd5TVdEPiH13Id/Hb6n?=
 =?us-ascii?Q?yr/U+6oLn4qc7UNikbdOS7eseRCCN4Z6nk2maq2lBlrAc7zlcF6Pr/n2Vwg4?=
 =?us-ascii?Q?PFelXI4B3baSdYpYHRO6ZizqGaUMwL0bF1EiPnqoDHG0KKHN1CNIsDnFaR2P?=
 =?us-ascii?Q?k4qlnGmHgIxMX/ynRwxIf6PVb6r0wVsB/NmWHxKxZCR/EABsxLuSOwuGaJhM?=
 =?us-ascii?Q?tnDAPrmBBM7D5nYS3SoI4Gl5/A12/AK6abE47iNCoQj0MyB+5xMGcr8YukTJ?=
 =?us-ascii?Q?P3Lql7dOqlBo4F7MXb4jPDdLLCn7/jCnF6d3H1TbA9QWYAB/8RdC7q1qm9vA?=
 =?us-ascii?Q?/FWWtS4cr9u57Asn7CZT2vEhpol9UYTJprds8w+MZyA3ve1omA4bWAf3iikM?=
 =?us-ascii?Q?Dv14y6pYNXnO6FWHqhuw5R1COzYwfw+PfydjGeXW2ferBP1tcW0804N66o1H?=
 =?us-ascii?Q?YR7Z1mfA2peZpMa0WJx9Sz5EIGsoTpzn+dSb0WuV7VhAb4Z+WYJGW1y/tqPW?=
 =?us-ascii?Q?D770s0hqp5cA4yA14l2NrJoE9p0cXLxov6RExaxJwQJQLf/LyS0NnCgX/z1H?=
 =?us-ascii?Q?mi7kF4X8Kg1uNzvPjs2fowuW2ct6jj9kf9krholrOBBiDcGGU3GguB6ldz1H?=
 =?us-ascii?Q?LYmYknRbTprV5wDq5Obayd+0a/WLQgUdkG4hl9UX10VmwcOW5fB8l5mH8JIB?=
 =?us-ascii?Q?TFlwhnpEx3TnrzC9oU4B7BK6eHzoecEfmYKxi72YnCe+s5lD0diM7eRhzfiu?=
 =?us-ascii?Q?4YdZKOaiJM1ww/Yaq/a9v5ETHVdfcW0Uyb5zPzE6bMjBxfXk2Xj99ZRhph8c?=
 =?us-ascii?Q?wK1Ys1ODpb4TPKlzAC86RMpwbc4c8kcHSPWvqTfZbdBE0DT/Wpq9fJR1hlJD?=
 =?us-ascii?Q?t0pE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:17.9615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2250c5-7185-4a9a-640a-08d8b6edff51
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnc1FI69Z7Drgr6BtqnxisW2GR1QMVwgoH9ML8nvsKk9HfbJUxxztOdlyvGkoRlCkpkIV7aVX38U/CqPNIvEJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
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

