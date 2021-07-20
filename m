Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198B53D002E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhGTQqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:46:03 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:44174
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232770AbhGTQp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:45:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCZr5cSyKM25bj4+NXxJ7tn5uKljPytcE7ZzS1TnKrgdKUrTR88v2XwikXEchXusn+SnwWjh/3Qm/n2kYn9KsipxUxRC8LEncP5uou10hBzkA4G8lgjHrbZU/z227BkUfOlyMmr8x4sXy7rptxWAwM3jD3KTr6N95SIIFBvMQejBKcJm3XHG9z6glK1dQOL8l3N74Gkt8ACzOlx0QZkTTdeGf9YILCxgbcV/hQCCCivnBi+N/ojCdFjUsGXHFWhkprWaEZPl8W4m9zPDBJHlDXZX9RDZHepyX8xQ/s43PIVgHlfjlts1whmjAF4i1mEhf5GIv5yLBjHaXIcB9Em3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBUQlAofLdQhKNVlnTh/w3tvbzYRBbSFFzRGOJEG62E=;
 b=KyEGxh7u0kFWXjD/oV5j02gwYwsJJFNv4grmvihFegL85G1DNx6BZunYKrgFlANuDaT2sJfH9Bi8IbO86J8r2edT1cBuffJ58LojVo9GxLgtMChvUlTVm2qJOZcUvFrb0w1cESUpYdrxjXRcjYmBkHq33U3Jp4tGYaFQXW62XERCAccHWfSX1vDD2FQi9CfBJ++gDm6SkcSzDPHhWeyg8phd5Cu++Dfjvk/tEcJjJrx6GIRQ7w40EXcYYdLPUt/wsvTIQOG8BMzy13SDT2mTs6G33BQPqLBxXU5g+iYimgWsr2DG8aY/u3PR1Wie5o/+d/jQ1S6rlpoAfiidQYKKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBUQlAofLdQhKNVlnTh/w3tvbzYRBbSFFzRGOJEG62E=;
 b=b3Z/f6SfrgU4jm7O3+rsvr9TzAgmfz9q39RSH+/5u5HAzI3QZuTfRPsjNkxi84dNwCSB1smMfAb03B8XjQ3ZMpLR/lKjonGtoFPTpAXds38i0BzpozjEM7UJbFIL2rT1G5IDNE0qoGDZOYHDGyAafHUhxrxLxFtGxzhBHyXAOqA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Tue, 20 Jul
 2021 17:25:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 17:25:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] net: phy: at803x: finish the phy id checking simplification
Date:   Tue, 20 Jul 2021 20:24:33 +0300
Message-Id: <20210720172433.995912-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by FR0P281CA0055.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend Transport; Tue, 20 Jul 2021 17:25:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cac79c3f-7984-4533-1af8-08d94ba35038
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2512:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2512B7178DFDCC6E9338D18EE0E29@VI1PR0401MB2512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vk7hwZ2mOyiaENX0VKY//BkyvefjaStNitGC0QJvlR6pRYB3zMi5BcI193INY31T4wPmgnrn/RisqAHCywTmf9UZluzcRDVrgdFdJn/fsaS+7PcAKBtEX1Cg+HOFtwINW47aqNVSlmKBJJp1B3qCeHrUPD0d44xOSXS4xJEdert8tu/zAUMK4exxRk4ww9fF5rBF0eaYOrbTIADKrKyPRMTyDRLVamMXBqiurHUWoWQQjJVML6Bb3VmV16p4sbr4KnM63jKFSdC1iwBoJAQx0c65STdZ/icJz+QFvCnOkyZq/YYLN5wHS5m6QqhFJqLF7Yqsv1JVhdZki3VmX8/lWXtHadT3HvEXP2kiQO1gjpH9Pob/ByH8Slabv1UiRY3HfSxxL+AkmJNFF8KQw3uGbMZGGA95bDCFo6Z/2TcgMheG4Hf2IEsaW/oytYZd4ODlicSdENJ7+oiJS0LeuyQEap5Njaj9B+tPE1wztstArzQAlmjlHPSmEaodgQeDJI3KJcLIbKIRGQXbh3AadHH4a6SKBM7HJZ1R6IdnEv+ykLHQnqVYv+TfhFr6Mvv3HN8X3nZdDedk+v72SZkPvim2Kl/H/3bjWNNK+fottCaIQzGwj9wBv6h0GEjuayEAG6ZpW0u7Z2THi3UTjvaRaTQpPkPwKZVAcHjalJa6pXw078ezy1VUTdsR8yQTfuaPMcjs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(83380400001)(4744005)(86362001)(54906003)(52116002)(4326008)(316002)(26005)(956004)(6666004)(2906002)(44832011)(6506007)(2616005)(8936002)(6486002)(38100700002)(38350700002)(8676002)(6512007)(110136005)(186003)(66556008)(66476007)(1076003)(508600001)(36756003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8gBXSFeLTHkvTub/34H+IF7xsm1A/5qg8jBNLHWSk7hPYRbpSXJDSMKhrMN6?=
 =?us-ascii?Q?Xh4cnLAlZ4euoSiKASaQXNWPpLpGruY4Cr0Z/xZcnSI3x6j+dA6P64gL13sj?=
 =?us-ascii?Q?9XLiEhJ34G2bHd/oOd/W4tumA9bqVeWz5ILnMmN5flejA9odPj1qyclGV2TN?=
 =?us-ascii?Q?cF3KKVdiXgdXCFnzO8L1NR5Vz2XK3UwAQtIlWj5b96IkWs4PlFfGL/jh4xjJ?=
 =?us-ascii?Q?MF+nJGThaGD4qAXdlGNYXtCShZ2TOseqkEBGhZDvq2mnEHfwCJjQrTMQoWs/?=
 =?us-ascii?Q?Tksd47ereQFdQKwft1mPlJXLY0lQC1TK3o2bpuqFBdshLK1gXZHiD4Iws86T?=
 =?us-ascii?Q?2DsbHp4g/PLxtCWTO3JXp47l4RCnaV5QEVvp19MB5zpZyeATbqHJj92AgGta?=
 =?us-ascii?Q?Za6vNWzSp7DXuR/8WoCdrBG8K+NeuIzckBnRZPViHmFWriQ4xCDNj1DyMBzJ?=
 =?us-ascii?Q?HzGa2pXqLRd3m1WFUA6UehjiT9nu1O1pUd0l/jCIsnEQ3ukd0qWTbYNy4mWz?=
 =?us-ascii?Q?Yd0RdIOSgTdypAERjls636ziT5ehCpVvx6Ic3GlBPuyAb0JTzWCXVgF5M0sQ?=
 =?us-ascii?Q?GKKF7ZtuKAsdLiU6nl1MPa/0WlzDweTR9mWENEKpYbXZjWFek0YSPJsMW9Mb?=
 =?us-ascii?Q?Zpm2JBN3DISC/K9sdYdcGMH5dmYSH2KkSzqggnkb1ELxpmdw3vecjgUcdjdJ?=
 =?us-ascii?Q?BGkOCczEMZx92eAu3YWjKgOHtYgqS23+5hM7IHQCN96p3pDl3VUXMBvZq9ww?=
 =?us-ascii?Q?JvM9h9LZsBwxWcs6vmgwpY0Pn9lnHGAPvfgppwbu2TYObDB+plivXbGNjVCd?=
 =?us-ascii?Q?oLvbpyNAw016ID0kGV2HRqjDFT4Lp/2y6Wn7pQhTyIZWR3xJZmsuG8xx2uXw?=
 =?us-ascii?Q?OIrsM5oJqqmHv2TQ7b7AAUys2kOZ4boJ3nkwpGHEMdxK9JtFZsLCLaXaVB88?=
 =?us-ascii?Q?ZsYeUaCEc+EnbnVcWNahQY6sHTpVVviJMO17YjyZ0aYM3Hl0xp7z2rQ2P2IL?=
 =?us-ascii?Q?rvS2rMB5fQAVg1MaDb0hGtRj0FIJmzthh7k70tPRS+CLNSbRyjx83sBybQHL?=
 =?us-ascii?Q?s2sULJ5R9xzqaxKGftT0UNk/3UY/GMjay/e9PzHsqgAcGavSMOJs4unrZHeC?=
 =?us-ascii?Q?my0JWz9vbBOxRebAMWdIia2KdxWPtzmtRT0HCFBh/WWPRBAOj+IWan7WYemB?=
 =?us-ascii?Q?npVNfGR9ZENCXYEqsgljaEVkMhdjhpnH8/cQvj0IC3d6hrLcuTcyH9uQeK17?=
 =?us-ascii?Q?/4KUkQP2SkjV4JW7mjX8dgkz9ptVoLynsyub5dwOgVMVY4RfxHCLceSnsYim?=
 =?us-ascii?Q?M+QcUg/v69dQHdWhBEYdUFPn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac79c3f-7984-4533-1af8-08d94ba35038
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 17:25:04.9281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMpBxZazzPiK6jI0/Oi+sQ+wyKYp+jjYiXLrUkKFsdetYjGCWw0wQikB5k0acqFT9EG+KbCx/mCRIILhVX014Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit was probably not tested on net-next, since it did not
refactor the extra phy id check introduced in commit b856150c8098 ("net:
phy: at803x: mask 1000 Base-X link mode").

Fixes: 8887ca5474bd ("net: phy: at803x: simplify custom phy id matching")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/at803x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 0790ffcd3db6..bdac087058b2 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -703,7 +703,7 @@ static int at803x_get_features(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
+	if (phydev->drv->phy_id != ATH8031_PHY_ID)
 		return 0;
 
 	/* AR8031/AR8033 have different status registers
-- 
2.25.1

