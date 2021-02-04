Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3161930F051
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 11:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhBDKRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 05:17:05 -0500
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:56708
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235355AbhBDKQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 05:16:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKK+5Nyo/4Mr0Kwv8cfMmFWvfWfo18mAgaTf1Fb29HHoMmYj3wDYorE5GjduSScdCaccFgrer2t17bsuu9QPK3YpjUCXROh1+DPygiFszTXHcmdbz0DZDknmeaHvG2S4LaF30RncBwtyQ6rN3tiAPAeVuBxpyM79IgFk7/9p8UbFFYiQxw9jSPDS1ed1E4IxDn/2mevFUhsPJDdMjioqgbqYoMXcfyyRYDpI/zqtR0yI8DwBAmqVCSOYMeNGgFlNPp4vNEdoGLj87WaB3DNc4uHs9mvvPmUWpfqzrmSfTEBqpBiNeWLH4STU/cP+BUvaKvVVIyR4tWuBkd9A1Z7oYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WnIxNW4i7FFy2C3Lfgx396jI5NpYMlWEFbXwFYw33Q=;
 b=KsirxvuzIyUrDA8MwDlUDJct4O7GisN6a5EzbrL5dhLGhz/G+zLP5wSW+HjtezbHyO25dOogSsUaPst2ckjSnnMpbEDQzcoV7/aalvlCpKOqf+nkEKjKkhZEDQ3V74EcolAEcz3gYAAp8rkzG9+GDPOQuwgpJde8UWqsOL8tlDRWGzpUUtB0wPFUBjp8oibM9Pjo3fxlB10Y1W8jAoyaasdJhFTQVjgS2mifLtk/tU+YmWaCe1b9TbmQDDjHfCkeFJCE1fvGvKk+krSRnDFTNJkEGjfKUYa23OPE26O70ZHljXw0D+lWXSfiKxclBkYZIHnJPA78lQEfO2P95SSpsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WnIxNW4i7FFy2C3Lfgx396jI5NpYMlWEFbXwFYw33Q=;
 b=X0kypggcVlbzS/xOS6+0Ydj7PF9kO+zO5oKOVr1uvTZ5GWaoTlRUPq6RhNLbM1UtfG1JGJsXMZ3xBzWvmY4XMeEHaS1ts0jNdZgErhqVlsyezIbmojRsKkX6+J4JbQ3tIfyRbqQbxm0lUd9Fi9Mv5j1IQyWmWeU042PEAnSCBjU=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB7407.eurprd04.prod.outlook.com (2603:10a6:800:1ab::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 10:15:29 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 10:15:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCH net-next 1/2] net: stmmac: remove redundant null check for ptp clock
Date:   Thu,  4 Feb 2021 18:15:49 +0800
Message-Id: <20210204101550.21595-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
References: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.1 via Frontend Transport; Thu, 4 Feb 2021 10:15:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4447d36c-cdc9-4d57-b2c9-08d8c8f5cbaf
X-MS-TrafficTypeDiagnostic: VE1PR04MB7407:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7407B1E28FA5B20956C622C2E6B39@VE1PR04MB7407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbmX0sZxOQMgMJfslPdvl1MXBJXnV/P+Gz1TfXqVGTEgbarekJGs0Gl+flwbu7K1bs4lhQwXnoAC0HrrF5CF7mqwVbtORP8/HpExMOHcEvpWfMjafRM03TrFAug5T7RgT0C9WHEJganXq+7p9cbaD+vBuSOTh5TSVqf/tifXsYld+akbdg8VHHNdIaFxRKc2aBgLQ7Fncdvd2E+QYqykbSmRkg1nNRGLrwW5939HH5uZLd1CF9Tk4Vd2scM07IFWxhdDOTl8DBodFwYYPOctaiJv3NL96jOWnzhyjQrUYqzii6ovbuZHbpfkm+eMyIMO4AJgODLfeKFFbS1RHMPuZ2o1xWVpKUMysMbnMEqhH/vD21QWcw+8aFp56aOHWXRkIr1zMmUCOhs7y0hurd8mSULjU5Z+urg26aAuyxnaHV32APT0wF4XXzZM9lhzaxeTHqudV7kxGlTGxMsNmzYxhcf+q4TV+T6BRbio1lNLwFkam6JPIuv6kbqNxhawCvWtzbtfRb5a8j5Uua3jYOj9Xcpn5RpD5sYQ2GrhwPKz2XOQ84ERwqXVEL/R3yqYidDngUhNIl2iCc8qECP6Lrzjdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(16526019)(186003)(2616005)(956004)(8676002)(86362001)(2906002)(6486002)(69590400011)(6666004)(83380400001)(26005)(8936002)(6506007)(36756003)(478600001)(5660300002)(316002)(66556008)(52116002)(66476007)(1076003)(66946007)(6512007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FdznQ2Zl+Xmhecps1/QHmt7nd0nVSnkoyZv2bC4h6oTOf1OGD13vpaiExs8c?=
 =?us-ascii?Q?XS1r0l0DYWpGexZttqYwE5HKLrUqczoSYr3IPA4VIgUkkI2sbbzes/Sr5N/Z?=
 =?us-ascii?Q?5Mdelwbh8j9VspcLb4+53jsYUV0Au4xMadt4ONqfsQ0m79JV3uyZdTMe8s0B?=
 =?us-ascii?Q?89C7JNgXVvTnUDFqdZiNR4NPtIkat2qT3164Ii1aC0PA5B5bJa/PJ+BmynvT?=
 =?us-ascii?Q?NNCpvr5V6YGm2aSsw+xf0USSLXpoU/TqNH1P0VlO4yzmt3nIrtp0R5Zm9SDR?=
 =?us-ascii?Q?HpvRiSHmnjvd40LHu3/cWU26tkjxQmEz+ol0iW7dJmD/EpWlXPhyLnuwL+RH?=
 =?us-ascii?Q?v4bXzjjBafA0cduOXyvbl/LfrnUl8RMYQC3AfNWabhN/znNkQuV8MFWlnx6G?=
 =?us-ascii?Q?iPRPVNigjWh8hUf8WjpmkCgiMTZ3fYKAkJVw3zFmk/11H2o7udI8lK3/K1+D?=
 =?us-ascii?Q?tvfraP8SM5/J2Hq2j6Xcc0N8Fu4OOlo5yBAz1syIeY25ZNsqHmEL2NZ9ag7h?=
 =?us-ascii?Q?v2ckvK8j7yGPZqY9MovXP+lvaNkC8CXE/4H4eso7El/OIHQ/TEcKfHZlejFu?=
 =?us-ascii?Q?cj2jjPQ5ap1wTgC2zC3z3VpurEpr1PqxpsKIyL6+T5OxtxMMmWWlQnXEerKW?=
 =?us-ascii?Q?C9XM3JKX5EwNId4OMu8nYcXWt2t4Dw51h40GyIrilzUVrq9CxOBawVi/fq27?=
 =?us-ascii?Q?3eM69DgRR0wrWq71wB9jPLi3EZ0WRjIoYm0UsK/zLjz9a6aYotNTfb7CVfQp?=
 =?us-ascii?Q?KnAe+Bndf1Svaiitvg8NBlMwBvGVQRzcIJahnJH8/RDCXTwHceua8RlwRQE7?=
 =?us-ascii?Q?OYFTQeo9cO6EmJ+SQGBeVBH0QEFnHdReab8yIFZ15iB+NSL9FXOLM62g3WJ8?=
 =?us-ascii?Q?G40FWIvD78pbNGq5MBMMTfkFzhHxiwvyCpuQDDAiMcQTXOV/QHFixPHFpsgP?=
 =?us-ascii?Q?on+eBoN3eR5QEIbPZbggTcTebTldyFKMC+546d/hmVZ/yPWeJFmLKfIEUB5F?=
 =?us-ascii?Q?4QR2Do9zBCBWbFd92dITPhBsZMv9R7w8INyvYNor0+l8i4AdaAy4wFZNOLQe?=
 =?us-ascii?Q?7cWI3+pe?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4447d36c-cdc9-4d57-b2c9-08d8c8f5cbaf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 10:15:29.0851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vyacbxp3TcQZ/kHmJrRp642mvtEZ2g6qCfOdBTnhMiXRWlDnmUEZwAycy9nOlc8kut+ks/42V5PNpM7xxD0AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before
clk_disable_unprepare()"), have not did NULL clock parameter check completely,
this patch help remove redundant null check for ptp clock.

Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..11e0b30b2e01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5291,8 +5291,7 @@ int stmmac_resume(struct device *dev)
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

