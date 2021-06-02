Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47EF39891D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFBMOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:14:53 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:57740
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229764AbhFBMOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:14:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOgF5io36U9SCpvx3RnJMov3Z7tah+CelUM9RU8/Lu0ghLjXSY/dNCNAHFW5Gm/aRTkbw/7S14ogAINu5uSs1R5YG4CrtEA8XzBfIlhFiEV/mLMrzuTVcAeQuMGQ9xriQZbrmv6fHCBBmdc2u04bn+Upq0bO3VMkqundy+y55JH8n5NJ4dHYNEUEzctwN1dwjf3f3dNSw5tNBl9Gn11DnGIfy7WJwt5VmZ925nssTtAuiGS+a1TypKBUtY1vVqWcY0tZNfX5zfqXONMzUJjd+QuOKDYfhFqMlfPH9O74rjRzxRDixIVio9zI6XfOC+Hlo98RhUTA5YlAQKAqnDWZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGw0fXAZ+3X6PoOdj6a8INxZnDpB/LGVm6hFlXZWnkE=;
 b=GZ/WHWYt4tvM8uT6+aeyzM4XcF8t9/s0FaFTXzqwHmk9Px622poWl5qK8mzbdbsxVkFDNz/NM0S5xWyk+wac28+rjXnqsS9DtlA2de7lL1xnIchADEQPnIF4HHcX9YQ+8kN2utZq1u9qdboCJtbSFH+5v9W5z1dPF7cZnGCks3af0ks0cNq4BPeW0/LJFkxkjMe6MS2Bt6WJkgTKnD2fcvJCexu29gj22qrQ8aAvGOTMf8KCrfkVPSNhUSJAgcy7IO2Yd1Fv5+VPK0XfR6jfx58Tv5BublwSNfBpM0OTK/w1NLJhwZgUKI3TBsBaO9A9nn0TiEeSuF2Qo2lCpcm3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGw0fXAZ+3X6PoOdj6a8INxZnDpB/LGVm6hFlXZWnkE=;
 b=heNnvOQhrmQyHuFDlbuw96y6Wh4SXKTeLgcDja+j01YeZE2NZVUoHPUasngS+uJ2+0P4U/EzRvwqTR7iFFtIbPFR1BbatEe4DYDOSSJjLAUPVAo+6m4yAI9i49JJfOjv52z6YEBWPwxzkr1bjYkuUVf3s8gB21jS/ZpdTbj1HgE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3208.eurprd04.prod.outlook.com (2603:10a6:6:3::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.24; Wed, 2 Jun 2021 12:13:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 12:13:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH net 1/3] net: stmmac: disable clocks in stmmac_remove_config_dt()
Date:   Wed,  2 Jun 2021 20:12:36 +0800
Message-Id: <20210602121238.12693-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602121238.12693-1-qiangqing.zhang@nxp.com>
References: <20210602121238.12693-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0119.apcprd02.prod.outlook.com
 (2603:1096:4:92::35) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0119.apcprd02.prod.outlook.com (2603:1096:4:92::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:13:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b04a8d58-c3f1-4615-8284-08d925bfc683
X-MS-TrafficTypeDiagnostic: DB6PR04MB3208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB320871C11EA24BD4C4A51FB4E63D9@DB6PR04MB3208.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:81;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /GbP87l+2JxMuPcXPYSs0+rsEz7lF+u7PwX41x7if5pebIxUjzNOSV4QwYyttgfN2jqBFuz1iYWwHDIFPwVzl6lyjGI+7zrU1QsHSMFzEmH9hlgk5t8XJRg0AuNCgmR+pRNmD9ns9b4jxTpIx1viIsvbZojWpFXLfzF4AvkqC7ymVzfPkzSzGW14HisigQmXOZ62USQjyQU2m+zUA0SWj/YzV5Tx7jOpcyRgtoRRzxOcRQK9/fvdWn8ERLj9zLolLVDUewU+QfsdV1M2CmrkoF2DOYz5nRMv2T7R+WRmkCoUlvVcEhFFCfx1jz3/9jMWRe5wJSLDcY6L3xka+CwSftnE6ZUcPyvghWsON/zIl36xifjh3wEc12ULj6+FpkmkvWe3ENOKSPcFZLUReG4JsLNBnx9al7XDZhWZTDyAQzJipcc0AV1id1LqJiA7gWeD4bOCJb3CKm0RXNY1ME6IDBVsFofHnUFWdVrB0ht6ybVBlNBYjtM+O/Ku8vyDoJS1f1AN2l0ZyKNqFlgJkkvb+wRpkY/9lE+Pzr4vk/4xPbj5hnWx/qM3rA0upc5ZbUgajjI0ilJvQXp1T4KspG3CGj2DQGsAxRcDjVmSdZS9wCK1/nq9gOGRRtUmSNNG1MVN4+pQfarvIQusCM4VcyKSUEruLss/5nU9ZwFP1hRHIJadW44akPtBDUfHvdQspsG8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(66556008)(5660300002)(66476007)(4326008)(2616005)(66946007)(16526019)(38350700002)(956004)(8676002)(36756003)(316002)(26005)(1076003)(83380400001)(478600001)(6512007)(6666004)(8936002)(6506007)(186003)(38100700002)(52116002)(2906002)(86362001)(7416002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?57m/FUDtYcP8Q54tAlYaZQjBi7wtGKd+yir5JMmph4zjIwy5LNCjUncw65cu?=
 =?us-ascii?Q?YCPW9DC1yjx0kRaMK7OslyBjV3d4Bo2YXdRpAjbQWW7ij3w5HmKMGpZkcmP+?=
 =?us-ascii?Q?6FCRMcdwR2OT12qfaOkj0nuPo47RhYNCMdtLEAD+lLgQYkNvFIT0lemSWkoO?=
 =?us-ascii?Q?0uMMElePk5733BZBhzH4xNoo26G6v5e1r0bvxUpQYA03wWeGGVETT1q3uGLc?=
 =?us-ascii?Q?g0yqPmzvaI+8BJFMEpQhaBmRzK3uLjez0GKGii3BOzpT0Cr2d/hhhzq2grh1?=
 =?us-ascii?Q?FO3rFZsKqW1xvex4z/hw1RO2qXY2SbmycA5Tg3IYpa10kdym4bRTJFf8gRkX?=
 =?us-ascii?Q?JBu0yu9dZJW38jLXG3aZNzemwNebJ6RzVtPxpEYu10OipsB+eEDja8eXdj3Z?=
 =?us-ascii?Q?5ps5zz4EEhiLfFgTIyyFeTKRDcY2ddlSMx0dPQznleRQapM3R3bKPM5b5thN?=
 =?us-ascii?Q?dgvfiYB7uW9Cld3JM7G8jZBjKzLllI+qMmbDjYWMtJJJd9nBFzcP0Uc+LCYW?=
 =?us-ascii?Q?uXoul30r0AXp96YfmIDQXstVpGl8Gl0thX9hlQn8UohMgMkYaX09Jp14pch6?=
 =?us-ascii?Q?WoZidRsAOg2GT97Iq3OmhwK+qsCbqS6LKuKKuw5fyAkyoKOGhBE6YfMPIxHl?=
 =?us-ascii?Q?YXddJIkD0Gl+tmy2yf8W5WCNCwrvOgTvGufzMxBQDnqCIM75aUE1mWC2sUAa?=
 =?us-ascii?Q?yq2Nx+4DVYePJ+6IysieTNLjy9qNm0rFJk1hP6aMYvSe48f8b9q1ElAoMNIx?=
 =?us-ascii?Q?D6H0FvopaxmxPs9LgO+Rk0tvzVq19b8GaQJR9+car2ZS5sAmyFDhgdPo2a6k?=
 =?us-ascii?Q?FdmFAiSRJN+EM9uKvHBHKfqtQLU4vK+65AuG8kGY5VaKTWPa7Vt+J3mOfOzP?=
 =?us-ascii?Q?DLd8lpeaGb6aQB8HsiU7QBIPwt49QOITbDEuaN5j/Vkj+/PJ/0jZDsSwQ81v?=
 =?us-ascii?Q?mwoVzCMcwY+GjVweWpzj3Y1wIWQWwu7lvZOyIFzz3V1c4e+4407GvbLQ9K4w?=
 =?us-ascii?Q?DsAQa9V8ShkRJHSrnL8aiwSjlR6y/5SVZWyh8m3Br4NeHWGmn/RB8X7YAOUl?=
 =?us-ascii?Q?s4xqj5drP3euQh9nrDstJZjyCFx2dHQz2fLr6VcbCyxJ6FRji2Q9JDbkSHb2?=
 =?us-ascii?Q?Z2s48UOX5BVQhkxwMsfKMtjdQfzdrhnmrOA/y8IVAWdMXL72yLVy+66GFNzG?=
 =?us-ascii?Q?M/TenHLxkXhbGRNobJTAmG0c4nP+QbwpmzIIz93JDJeOVuqyQkJlisGuoEBM?=
 =?us-ascii?Q?BZ9QU7M1K9CXl4Es2MjqRT43VSqm63SKRoTEgo4/bqqI4uPNIZ7RW+hH6ypI?=
 =?us-ascii?Q?/bAVycEOwN/Q2ZK21aj0s6D5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b04a8d58-c3f1-4615-8284-08d925bfc683
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:13:05.2230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3lkgV5zsb3ImiOEtE1XFNz/FZx4xlAanhBuFlfdZJh4J5r0WcAXOALrKPhz2geBNVSqY2ZECxyIqv+iMNNS9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Platform drivers may call stmmac_probe_config_dt() to parse dt, could
call stmmac_remove_config_dt() in error handing after dt parsed, so need
disable clocks in stmmac_remove_config_dt().

Go through all platforms drivers which use stmmac_probe_config_dt(),
none of them disable clocks manually, so it's safe to disable them in
stmmac_remove_config_dt().

Fixes: commit d2ed0a7755fe ("net: ethernet: stmmac: fix of-node and fixed-link-phydev leaks")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 1e17a23d9118..a696ada013eb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -622,6 +622,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
+	clk_disable_unprepare(plat->stmmac_clk);
+	clk_disable_unprepare(plat->pclk);
 	of_node_put(plat->phy_node);
 	of_node_put(plat->mdio_node);
 }
-- 
2.17.1

