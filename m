Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D5A2F1197
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbhAKLh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:28 -0500
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:22789
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728731AbhAKLh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m66hrmv2DxXavgftaTWDpjHzF9AO+sEzRxKIL1pdPZ593aDC5ilyXhlnTo1dTEIw1ywZ1F2HAwJFkq9jhF1ZlojSCNoJN7ah14ZIuM9YU56VIxmiQ6SggoDwOo56fX1OFOGssBkBeql9vBmdfnIcZ+xbRcbOSBPvoDBYCK4wwzF1Wi6QL0as5/9tj50ycrA8NGQvW+rOWaJ+vDng1ze8mpP3uCAfEofAaalXGGyBABEcH+0DMWJD9ZxrZ0lFt3pjMpFq0R1qVZCDlCUwFKUIhOoQxDWszPunmBHADvQqolExBigF74glJqw1OMTDzEXng1yOlbsCyILoHFWZP48JVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VW0t89zZNGF+H+ySTgYr3rggt/tlnAucOmD85xc44Os=;
 b=QvA9QnaZKRouhTIZB9nGVis6GRKzTSNs9y3tAAYME/Qv+1hAtKVcBnSqPlI48JdkDCrF1qdyJEsVVvECwbNDFYxJazTC7kcNqIWmSNqL4Y5bDlW823IbhJQcvcsnMwWmn2IxD+1IjMvgZZKuS6ekuRDyAhrMu+vZxBg0bylqjqZBGqy1lWDSCauti/DvqGG+Cc95q5aAFIJWFtP21JKeuW2g2A26YFmxQmM0vxWzMzkpHmD/5FPaIaeeWyn5eLIrxpMgMGyufh+r/DOi65Bj4vFpftTOYYW/TvebdGxxbhDlTtAHnt1buwUOSwuIh+RhLTDSmh3JaxEvy0GyyUem+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VW0t89zZNGF+H+ySTgYr3rggt/tlnAucOmD85xc44Os=;
 b=R+rMk9xtxG4olfoTkqzoq4cpnISBk2wXI7R/AIWClpLM+wUe2OgPEMDiCD0JVpVfSAUDXtLLU/3BVhNFoTQCPtyUEjO2dMKk884+3zrLC3S9sTMoXUzNmz4lMdqhe8cuYjINXOVHc4MzSpunDEkfmKuZC/NSD6y7xM7fVwkXtn0=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2326.eurprd04.prod.outlook.com (2603:10a6:4:47::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 11:36:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 2/6] ethernet: stmmac: stop each tx channal independently
Date:   Mon, 11 Jan 2021 19:35:34 +0800
Message-Id: <20210111113538.12077-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23cc4d27-a118-4c36-c386-08d8b6251e93
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB232628F80ABDE7316D409ED0E6AB0@DB6PR0401MB2326.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nyvMtFfYkZFBZplWtPdm8q/irL+qrNMQ33Dyl7jayJa2fLMrvQfTOaHsEB7IJ/hsNVOlPY9vD+C5XdjFo0Mn8QV/9dzc5Bi/ciP6Xvb2NZ11Gl+q4W8GaboIZRebKqr5ndrAeSO+BAKLhnwfVsldmKa5nuK/s8pH8Ugfd+AZEnjadSdKBcxoFzv4IItRqR2nF2j4hndRl34hrbxjmykE1CZWpHXWpFSmlGDITGr/ZVhE62Qg/pgCkOK30bRXNGP+hT+C714L5NT3RElOAOW6qiSTlfqcCxFG9GFTGCqBfKRzD4t7oz/MeJ01T1cpWdmmhTVIDtEneqbuFsPMnz1Z8grcq6q43vlNrQsr4eVfFufJlKcjFm+KrHVeEN/C9t+13NIqdFaS6JRb4rLcDnG0rXJOCYcQH3e+n7++gkqZDCNaj7fQMkICAzilNULxqMU5E5FB8C+hqkOMqT/HLZt4Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(66476007)(4326008)(66556008)(8676002)(4744005)(86362001)(316002)(1076003)(69590400011)(6512007)(6486002)(52116002)(5660300002)(36756003)(478600001)(8936002)(16526019)(956004)(186003)(2616005)(26005)(2906002)(6506007)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sTXNgKaY9Pry8YjHAxxF/b8VmvzH8FYk8Udioc9zfsXvnFn/fjuG2UkrJCdv?=
 =?us-ascii?Q?CUsn/KuA/9P/f8HTfjCRIcaebxsMI2jhmTZPzG5f2M2QBkKCC9E+f8YkvlPe?=
 =?us-ascii?Q?GDGeqZNhwNxUHICFM8LM1CGsrkFsf+dYJvhiBj8qJa9QapnDXn0b17VeBQ7I?=
 =?us-ascii?Q?h45Fc6YH5HuaOskyLMrDRIeZEMPVqj2lTkRCxIYfm+8bffFtVdIM4pbPhcgY?=
 =?us-ascii?Q?YujzfCz16Uf7OKfMXVjO6HrZpAz+bA2sC5wBM63CuSREVrjLU4706qPGe20T?=
 =?us-ascii?Q?X9PCrF0Gu99fO1g7mhQGhFsvgJaz7jXCKyXuLwQStAoks/4qDhZNxzCMLPHI?=
 =?us-ascii?Q?qfXMmLQj5KnvkFbVlXDtmGtaSPzdtlx3gpI0XN7w/PqX08XDsWM+6E7BY0bi?=
 =?us-ascii?Q?8X0LNc8OPhtKRtZxTzfdXfoPcIf3VlathN+UYBt6Tb/EinhmLB+YH1l/ArPJ?=
 =?us-ascii?Q?nzqVSBf9M2nNTCxe3DC3KLrcUhaHC/MU21dmEDnZH7+SiYqQcpMTwSmTIMvP?=
 =?us-ascii?Q?1pqpqBWnMOqnK6pb9AUkdE9eOYMoV35xLKg3NiCO3RIu5Kajj5U/DtxqLyXj?=
 =?us-ascii?Q?z275y2+bIOyxc7VRJZJChhvkgdRSrT/0OEKbC2T4ClR1I7vkjKf//uvWy8vj?=
 =?us-ascii?Q?FfydfLYvZ4FWyhCdyI+nEf3Mm1CQGtYiNjO1qUsVpr2E19dKjR+bZCu4MV75?=
 =?us-ascii?Q?HxHqGTJBTA7/wPKks3Cd23rSMeaojvsmoUSVwsv2VatOvn7khRGy3kZcV1I3?=
 =?us-ascii?Q?IbwQIXsDpiwm6/8uOMcWJldVyMW7cGWycjQdVnRHVXaz9YakGwnEH/JkLojy?=
 =?us-ascii?Q?fdDOdsqqdmJiVZ+0fhtIqwKdPfE1sgB4Z8dVFjLp9zYcHoKNo4yBNkPXfxgH?=
 =?us-ascii?Q?Z32A5G9jwPjVGVtmdClBoOp4hHuti9jVoBGXDFk8skuA1cQBBCXurwf9Kvpj?=
 =?us-ascii?Q?at6+419MjCa79zA2T2mZb1yhhaqLvEKJNn2+URb8anfrwk6H0P2ZStf4P8FO?=
 =?us-ascii?Q?xWB6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:21.4775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cc4d27-a118-4c36-c386-08d8b6251e93
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2FxpEt7BC719X+kb1QpjKu5gYrpTc1JqlbRMjxZ2Ucgvw59Z3psPZ6iN7IwPpssnnTI9PFAT7D/E599HK3zrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If clear GMAC_CONFIG_TE bit, it would stop all tx channals, but users
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

