Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43C92F1198
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbhAKLhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:38 -0500
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:16480
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729760AbhAKLhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFeG1lNQnVJHw1mm8At0ZE/Db5S94rmIJPxXtvN0yJ7FXNY3uJcqm1D5Mdq/2d9qcXV8e4vhG4hE3GlJC06686H0M0XAcWXXEio9dZyKQ1iaO36Hrlku0fjJsvxrEJeNLnU4Xkqtsvgae+cx8fbiFA4RJFHmsuLatNrbuGW3y4DsEPymnPqzTajBkI6+dvokf9b0YFXLnDOg0iP6lowJ1VfbpSD6Zi00Oj4n/qf+2dEZSi7aV4olQWkX8d+SyQyFR0jMJS/iXaWesQPhVAnaF5OhHbIFTkHOVjrWhZH3YuqxZmdMgFpE5FJHpxo2uOnuxpNSEX4ws8fmKolaICBAAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6Cz6xIAd5hUTGHQNYSzeNm6ProxYK7NTFlETU5NANI=;
 b=JsoXEDi53abibFdzTEeSlPANMwog+odsHbbrj1N3t/DmzqXQ+lddBpjTTD9/DAqPcyn42jViXh/9mybNM+IKpTT+MqaPGqXQdkVOO55dhiPH4gsRdl8eDaNkQWMh1dhSTQ9FqRORNCPMGrrLMtBCUWhaCmJIxRGvF1r0faaYza9kAFy2dCDb+imlP7G+GU3OXwZWUpTsuqXeKeWBnsYYgdsoSPEzaMZs/jnotp5cdQPwiKDSy5H0eX2P/BRWneZcOSYxQ5gIvMgXNDROUIgs4zgKp7oJ2uYDjbwSHOmvFoPIVhKOUgZONmjCIiTM2ApdO6SghyJPlK/ZW/K1/EqC1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6Cz6xIAd5hUTGHQNYSzeNm6ProxYK7NTFlETU5NANI=;
 b=s2txCUS19xbItyY0ft8mHBAHdQyl5pmY4fQ2SpBgb3kfULOIGDkBaRlM9QjAp8C8JPpKJxa0mVceRH/oeBSKmV9/sqH/QYANSJLuYHzECJOB4N0okbZofLSF7Ts0vaCJiJqTvZN5WXD/XXEH0yxgCTW7PggknvVnik4cHBQSA7E=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2326.eurprd04.prod.outlook.com (2603:10a6:4:47::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 11:36:18 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:18 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 1/6] ethernet: stmmac: remove redundant null check for ptp clock
Date:   Mon, 11 Jan 2021 19:35:33 +0800
Message-Id: <20210111113538.12077-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4aebac91-0457-46f1-b213-08d8b6251ca7
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2326204BC84A99251693CE3CE6AB0@DB6PR0401MB2326.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VN+W5clgbNLcNcuy3MnIyyVLqqbIAnMo9SKiV65mZXlmOQyWHAkexfwGQiFOMwsjZSKMEt/7ZXmZ0aHgWslGSDIzCYd2fXgTNLPcDNCca4noY5qmmbJKpx2TcFMV7OVFP4us0nz9VkH/T7DHrtzogm/ITKAkhCNVYifLKCDsQcke7xRkHPN6hUfTCOeSfuFKmfcxX2UktrrbZ1OdPXBV3ZNJ0ZRLoFY4bsg0Wvly8reytd0itX1fF/XvrOsTqkjHm2erX3/xwvp/a2HsAn+cweDV8fMYWeU5mOnSkxjjY31iKOt7NXV+DT4QT8HHFIsWpQVc6fmeTwCpsE5Nd8RHvLQCv84woKRX6YLkw0FxZDrQOiS7vNyEjYHuZyOpjjCbAcJhf6zTsl5sfvvWPXaKlfJ8aQbv7InbyCOXIB4GvntbnP6Shd6SQKcfB34O306cgiasbHoRlYzD4iQaRXCHAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(66476007)(4326008)(66556008)(8676002)(4744005)(86362001)(316002)(1076003)(69590400011)(6512007)(6486002)(52116002)(5660300002)(36756003)(478600001)(8936002)(16526019)(956004)(186003)(2616005)(26005)(2906002)(6506007)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hAjSRb4xpLNavO+r+V8jztz4MxGHHZEOkmCDfeZDB/ShpZeWrlV1tmqr7ATC?=
 =?us-ascii?Q?kLA6WmOsXaQ7sL+qr6b9OnGgWA1k3GUd42MFQdEUmeC+cfobS+ZyCeXTCGUf?=
 =?us-ascii?Q?QS20jFScgu3SWbdKW9KYQbBQOwhlawDZPssL/LfBmxJOKoWKT8nn+D9k+JjS?=
 =?us-ascii?Q?T/cCfqRxnP6Z40NIy4yHNk/SekVNfvqyfbrLVC4nz9iHAwxgwUEuQv9sHdlx?=
 =?us-ascii?Q?GUxXEaMDqauUhgZIeFex1MC+2uIhY3sb10tpTagTFsgIneMODL2/vJRs2wfY?=
 =?us-ascii?Q?FJlaCieBuhhpALACJlYo/0G2yFRFUGkLVrXp+hIo/w5u1Z7RujWtAoWlDGTp?=
 =?us-ascii?Q?A9KlU3WXZ352jT3OKnQ2VRrWM8IeTaTTOJlMNRigVn20G15niFZI9Vh59gNw?=
 =?us-ascii?Q?M0dd4+mgcWyuACUh2NfjzpeaKrICrFMNRldKXMYBTzuI9Nf/Jx3R05JViMzv?=
 =?us-ascii?Q?wXNr9wMaekJTrXko/XeRpvyGHiFwjzdpM7qC9jzigeZFD4+sI+bxXfzKUo0r?=
 =?us-ascii?Q?Aq2vVY5owW1IeY2PSoLeRSW656Qkn8NtkxEb7H9PWyTAU9Nc4rwfbySq4/UO?=
 =?us-ascii?Q?XXqyllKjv+EnC665uvsLakuHFiUUWhSwDe2nAxaAxdVLLnkNj76QpYilW5Hd?=
 =?us-ascii?Q?gTGc+eNiTso7yQx5cjNEL1dZvLNPTGjCEUrHi8ppfXg3Hxdv3ZMzAua+T7dL?=
 =?us-ascii?Q?pqemnlE4m1ZrdtAEkLjgKhLFAZX+ZsT0lHHKr5F+FsNa0e2wMVo0bYRoVj7m?=
 =?us-ascii?Q?ZMBCMMF++HfdnhhrcpriMtQ2fRaNcromgHrpoMoIe1VY4jmG+MYH0x/BnciX?=
 =?us-ascii?Q?kco3JZCuekI1/2DokW94uJCt20GoXqhPfhMQogUfUvzQPqXQ5oqM5bcIToqY?=
 =?us-ascii?Q?lJ59HAsNxgeMcQn3mM+3TjJiLmzStowemcgCbAN+v9nexB3ZxRgpsM265ZWF?=
 =?us-ascii?Q?f1IZckCKnIHuNA79MMfI3zKYgcuoVeQm0FdkA5OA+gCcfXklDVz2u/sFgIu2?=
 =?us-ascii?Q?Ee5i?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:18.2418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aebac91-0457-46f1-b213-08d8b6251ca7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/xQi0qZLp40ibbXfjLm2K4zLh1I8xyhi0I+fynvRop2fN20zncHMhCkvlri3AenSDSUmNIBZrLrYWqSaiCF1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant null check for ptp clock.

Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5b1c12ff98c0..a0bd064a8421 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5290,8 +5290,7 @@ int stmmac_resume(struct device *dev)
 		/* enable the clk previously disabled */
 		clk_prepare_enable(priv->plat->stmmac_clk);
 		clk_prepare_enable(priv->plat->pclk);
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
-- 
2.17.1

