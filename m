Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A314294DD
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhJKQ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 12:57:46 -0400
Received: from mail-eopbgr30078.outbound.protection.outlook.com ([40.107.3.78]:64750
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232695AbhJKQ5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 12:57:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTaXPe3tmmLVsSQ4sKW9FpjiTG5zAxuVS8LncG9AYK3GFZZs1o+ylmYsAQr5H6OI1jaUpCp1HynC9vstybE+2WPIhrRTD8HVTwT72OaV8TKZez0d9y5LOj0EDTTxLKvyZo94KUjrHYmswM6ezwOPgTVvmawzeCRkTwOJJFQ2EFUsehvgaxNyNIWRI0bD32zkcHX8exGSqcZz3qwP5ZutIDNAcLwto5QEnFeKMD3CX+c2An7YkDFls6ueMxeEwTEQjEwXqdR+TMmmVr5fXMT+XdkBeK4iRVGVykJghhiqzHnWQSal7hJrpZ68XvfIm9AI0hEpH+0Ir4rRLLZ/pSV8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiGT1VF1JW6e1giRtyDdR/3QHEty+BWOSa6I9xeUYBQ=;
 b=BP8RXRapQhRpQp7BkrkuIQiY+8Pnz1vBWBg3LsL2NsrYRdd+ZZpNGQTlISouzPAgctIb84ewQqhVq6LCvm5+CoPddzHfvro6xocbMO1L6uaQEwsRWZhZX9aWA0sy/JyLHkDx7pQipHaudNN0rtWkDUHnMyOWxdLN2SrHQNrBt0OyntDXE2OPYmfcRTIF4l2oBMPF6ku6tQc04l/rQ6xinkYnQL6iz1eyXtB1ABdF86gLS4PkFAOV7AMuEYDQpO6qzYJ8z+rHum1XPPru7VYYosdtdENkCMcPQzoaCP5PVhE0wMoQikQGCRpq+t4C0YC2K12qB5PJAyWa9pl+lPNpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiGT1VF1JW6e1giRtyDdR/3QHEty+BWOSa6I9xeUYBQ=;
 b=QUdW8iU9zmuf5BN0xffCl954BtPWYYPD3rhBixJqS+gJeDdeCtTuCemRDL4zZViZkG0+XJm8tFNN0YNCupyqjfLfWh7uhIf3WhwLm6LJubbVLxEc5fHuQZFm9fIybhTLRK5z4b7x5t806CnVsYqtcD9drKhO8l6NYiXfFSJTIeA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3659.eurprd03.prod.outlook.com (2603:10a6:5:4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Mon, 11 Oct 2021 16:55:40 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 16:55:40 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 2/2] net: macb: Allow SGMII only if we are a GEM in mac_validate
Date:   Mon, 11 Oct 2021 12:55:17 -0400
Message-Id: <20211011165517.2857893-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011165517.2857893-1-sean.anderson@seco.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:208:2be::33) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BL1PR13CA0208.namprd13.prod.outlook.com (2603:10b6:208:2be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 16:55:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 451e25d0-e7ae-4bad-c5da-08d98cd7f4e0
X-MS-TrafficTypeDiagnostic: DB7PR03MB3659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB3659C5D9491A30CF25EFE2E096B59@DB7PR03MB3659.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CH3l1JzjQS6TUb5Ii1nZlfmFl0J0GvN+VKg0S33YIq8dVP5KnL0wkhzRRnG6S+oVaq2YRyfhS1YpPkj+m7fGVu100/vqT2Crajrv/22UubEJBzJr0mri78fpisbWgdZPGw6C7fU2ntg1/pEDv+IUlr/A4UJ/tw/R7sK70yVjN5rSAeZ2hy/uxTUnyg6kQHlI5VVGGVlKbNMSFap4OOwgRb7/EMjePUPFrRPhKx5fg5LhARZbJJ+tuLQ468TY5bx+650LAoJNT2QQI3lEMbfWdleAa1ABnGPAVNkO1HULIrh10AL3n5q3R14jgwJ9jvOUzNOXUdhRF3glrUTMpJdtUJNh9mWW8Bvh1peEK0ipUG5ROzpVlsRJDvkIXEeCvNHCTyoL5kYA0ouWkUGp+Ii3e4iJm+M71pgCapzsmezFLsO7/E5DZXxNywQ5h5aweU+uqus18lvfF5LDki4PNN2AKJOJjBf5MbyNeahOEjoT7UcFsFIH+VwJJxCs9omeHH4PIBF/t31r8dnOu9XD06Ak+wMEk63tWOgTyJAawVN5sYL3yqxa1XL2KTjYeKWPveG06yPtv/StNqvnlXoVtDh/TfLJ1+XcvWHVdBP2PVHl8LPF9zYSV8c+yhykSGI0JfT6r9qDI7XXzjVcnlrh+Z2h7j4zpb0gKZY2sCvvPcuN4beBoflIy5TWoTFyVUESj0Xy2/O2tTjaxxMh5d1oq8YQzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(6486002)(66476007)(66946007)(8936002)(8676002)(86362001)(508600001)(36756003)(83380400001)(52116002)(6506007)(66556008)(6666004)(54906003)(26005)(107886003)(316002)(956004)(6512007)(4326008)(2906002)(38350700002)(38100700002)(5660300002)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j+5vqorRNd0ODvdo+0SKdy+bBhDnOa+wy8YPj/3xj96q6A+fvwLMcOuuztwu?=
 =?us-ascii?Q?lRevh3BLYiwElpAqwlqut5owyTdEjGjg9Kgp+BNpuW+7UioEHF5d7I2LXiwt?=
 =?us-ascii?Q?U1e+t30Js9jAByJIan9S+1jdkErcxIDkI82/R/KCl2gYwqO142Di265DAzn2?=
 =?us-ascii?Q?328sJGKA5QDpK6W6cBSUG+DFSF1sO/Zqa21vPm290g/8mOw5J60OUQU7I9am?=
 =?us-ascii?Q?57Ev/yWPZzxJoJG17pOUpCldLQe3Z6yXBAxdCfoCo6oVghso3oA1gqHgej3b?=
 =?us-ascii?Q?pv/L2X4WqAgorOq91T+kL/lZFZcfbZ0kqzcT2w5CHFONUvDMWpjf/Bl1x9h6?=
 =?us-ascii?Q?2ZUoOkgy8vf88YGOMj4BWgo8HGScgKyOiUEce+QQBRnCShTC0yg4UNlAIz+s?=
 =?us-ascii?Q?mi6fk0rofmeNwIPAta3RtX6W+7EOMIJv9C6g6g53YVy6Zr3dSobOBdtFpaLn?=
 =?us-ascii?Q?ouD4C8kCxjEDasiw5Ln/D1bM4z6HzJbcuSpR0Ae2lHem7p2v6dluWY531EOD?=
 =?us-ascii?Q?iX6stGLO92KhBsASfDOiDBPzjGP62DilLk6iZS2QmfCIxC7gDzmzy4Rk55U0?=
 =?us-ascii?Q?PDfOVe0jI4/iptYWF+baCQvUSjgEd4UiHOEsjHoaVx/PHi0R1QDmiziZBcxV?=
 =?us-ascii?Q?ay54vhNEiPM693D7/7APPmso8KGUJ4F+t1k7YOrfwCiuBS0tOfvrGNi1AcVp?=
 =?us-ascii?Q?+MuJRoHXjJLv5MinRy8nQgMxVt9ydLgSF1yPHyySPlkYELwnw5lPaPihAZ3T?=
 =?us-ascii?Q?waAfVdHjil1KDK71XuRvz7+CudIThRhz8zdqy2vcxbftSHHIJDOHg3EWgAo5?=
 =?us-ascii?Q?qopgg34+M1anftWGQVH859+LNNjJvV5VWQI/ELDs0RAd9gaXg44HpC09J56E?=
 =?us-ascii?Q?JW3/Pz1m+iP8QHYP+E0SoEDl6+QJJKHZ8rIaGbks8mj1BCWZ6wZyGSISYb1f?=
 =?us-ascii?Q?Y4BFZkG2hHize2vNzsTAIfvOMWAaA9qQB7Vha8cxhJghCC0VeeX6jvtim/2c?=
 =?us-ascii?Q?i9yEYGVjsGfN87wpEETsi9iq6p6Q4nGx44gPVmsqxRNxcDc7FiFQdtIu4ek9?=
 =?us-ascii?Q?vSSwCi5DgyN6dGz3IG0Tbe3midvM0XsxDPkYNoe41eKxbMqZwvH9aL9FIWhj?=
 =?us-ascii?Q?FuTWFtVRPFONMKjR/z5dSZlnsuH53ykW/JRWlKd4UAlyNqsm5UzapsmMFCfy?=
 =?us-ascii?Q?QswYpyvKvwXlGYvQL9TlFX7h7sEx+pBbSwvrYBMcdggVZFd0yNS8wj7I7nrO?=
 =?us-ascii?Q?MXhzYnOOx+s5hyLAkqkrQU1s5JB+T06IWELIZyAM8/im5hRQEOzWS1L3/30P?=
 =?us-ascii?Q?owTwMpVrfLy5kNOBUhIXHXDP?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451e25d0-e7ae-4bad-c5da-08d98cd7f4e0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 16:55:40.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: elMwuC7NB9ZKzrn7xpbrWdm2OjkBuEa9yHlcxUgWBOWQl0viixToYiAGwUCpQl5l5qD99JXF6lKvh8U3QR8Srg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This aligns mac_validate with mac_config. In mac_config, SGMII is only
enabled if macb_is_gem. Validate should care if the mac is a gem as
well. This also simplifies the logic now that all gigabit modes depend
on the mac being a GEM.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- New

 drivers/net/ethernet/cadence/macb_main.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a9105ec1b885..ae8c969a609c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -534,22 +534,18 @@ static void macb_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (!macb_is_gem(bp)) {
-			if (one)
-				goto none;
-			else
-				goto mii;
-		}
-		fallthrough;
 	case PHY_INTERFACE_MODE_SGMII:
-		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseX_Full);
-			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
-				phylink_set(mask, 1000baseT_Half);
+		if (macb_is_gem(bp)) {
+			if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+				phylink_set(mask, 1000baseT_Full);
+				phylink_set(mask, 1000baseX_Full);
+				if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+					phylink_set(mask, 1000baseT_Half);
+			}
+		} else if (one) {
+			goto none;
 		}
 		fallthrough;
-	mii:
 	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_RMII:
 		phylink_set(mask, 10baseT_Half);
-- 
2.25.1

