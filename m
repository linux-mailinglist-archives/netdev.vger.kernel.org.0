Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED4E4294DC
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhJKQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 12:57:45 -0400
Received: from mail-eopbgr30078.outbound.protection.outlook.com ([40.107.3.78]:64750
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhJKQ5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 12:57:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgANnmR+58WyMd/J3TcKBUGS3NiW+m4uMxHYzysKrZrFhyF8f0+6DHdmCiTvdtYAQmu6OpVTZYWzNySFLqYodZ9+Mahcwgt9Adev2Xs54eHBp3l7VrH0Oj/RDkPujUZEmgk4D7p1xxdoMDLvBXRH4flohyK6yKO7MsMtIQbTpricZ7E9NQVsaY32yvVsweFUxV4gkWH3H2U0i2RJ1Cc/JMSK3kSw+6IOsnX1ZsB+TCn/C4sADjtJP6bMzi82iov8mzwNka5XjKRWEC5YZQHWaYcB/xE0dr34J8Xrhp4fHaM/570D6o0+twaW4Is8QqfBKyvB2uVHZjDVcDQLjB8few==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOQ5vXceNCeHyFH5GGePd7N9/h1brCSYXOWnKYluzCI=;
 b=DBdBFDjkNEgEP8W3uOE+BnVqfOPOA72Ldx/AdUCX3dJ7cxUUGkqgpdnjLm4plk9OvHjHkBw7PAb+d6B5DsvPmXwNk7E8eE1ikUMYgTqW32ujOyEmaa5oGfivwK9GumUojvAwBC0fg/NtiNCzKdxbMUyTyT//7bLfGp2r7a3P2zG7y/681xBiJr+on9vsnruqbfCTOnx/zf1xjNe4uaaAnSbVGSX55qPC/Lyc4fojXMsFvP9qdYH3HEPJE1pZiLiD++pejfPR9J5GZRGXugQ4eCZc0eziyDlSiMRocn2Sc3vUzUWCeUUj5v6BlQ8ZNI0aA8tP7ip+4uMOaPPxJtpD/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOQ5vXceNCeHyFH5GGePd7N9/h1brCSYXOWnKYluzCI=;
 b=TINWYjgqzwHS8WDIY72bqxOqhQ/TSy+n915LsKuUqWp80ntz5MLWcMueVSdwrtEmXZNC/CqZZKmIV0g0F51kK/K7u5xqxhkjngmGpUVtXeyqLwZHaKxHua2icoBThTQx0Ai3aoy4RYcIvUgWFgHIiFMIX8nDSA1W26ur242c3E8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3659.eurprd03.prod.outlook.com (2603:10a6:5:4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Mon, 11 Oct 2021 16:55:39 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 16:55:39 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 1/2] net: macb: Clean up macb_validate
Date:   Mon, 11 Oct 2021 12:55:16 -0400
Message-Id: <20211011165517.2857893-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:208:2be::33) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BL1PR13CA0208.namprd13.prod.outlook.com (2603:10b6:208:2be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 16:55:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02058769-78f0-4b5b-d411-08d98cd7f411
X-MS-TrafficTypeDiagnostic: DB7PR03MB3659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB3659E20AAAA5FC1F83B7881496B59@DB7PR03MB3659.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXIKpvcD4FGPhfkd4g71qq72QTFOXsTXf4IPvN09OsY4kljW1b2Zec5fe5k0QycSxoH0uZoFuwjSePeRmLP+i7nBFX2H7HfGd4vKgxbqqUZBvaqbEQj2GUJfLFqZNzyrzGv2ryhlJiwiIKvgzzw/rzmi7ROuRX6QJkeoqn3q1Dpjgs7zhxo/IVQkrJxVh71GvROpP+BZqzNrJcsZ1qzvK2ptr00qOm/6FwP/voYDoVsk1YxKWmRPO2mgWKtYQgaGyT7zfj/wW1sAUCrxdQ5r+HEtd1YyaQskVLzF+qNY0E9CNF3ivrAQOfLkyqcaoQDOD2Q9+7t9uXL3VTty92dH2cpcSMUdfxlDx3ll+3o4pH5hGnFCiaJQ1VWCASOQQVbUDnGff/8JRSjEA0yJtzkbG7jYvPPsmVXS2/E4F3VrVR0obrTJ412jq91/Zs8dhEEcrN2pU2R/pFJztQy734F2Ho6D+OWuogpIQZHxaSyEioyTo3lnn1dPLnQpTQJ8tazVSdeAik2M2sQGTtRcv2l+4hhrl8N87iX2X+MCrFaYzfJlMeDJPN+liAlrKWnmE9jFFmoNKo9hwz2EZKXqLxXi0FnTRjK/9kdpIMXYLW0g/iGm9KnEX8RL6qwsGhyop3SgZOq+/LYmcPkoAN86S3/d1PQmDhUcBXM8lAeyT2EnWEpA13eCtzJSvko68dMuoyvhns9j3heWNTJBuALJr5ey/qa/U8MyXOwzDIjuOxJTtbwmSut5Cf/ZX6Pnz3YQ6vDgdsSdqvo+cO/92iXyZgAVVHN/BbaHqmKEDXL8RO9CkYU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(6486002)(66476007)(66946007)(966005)(8936002)(8676002)(86362001)(508600001)(36756003)(83380400001)(52116002)(6506007)(66556008)(6666004)(54906003)(26005)(107886003)(316002)(956004)(6512007)(4326008)(2906002)(38350700002)(38100700002)(5660300002)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gxMRhWP1DNDU2WSSnuBCen/0BBMVZwPEXDK67aPseGxzN8iBgLpaWYUJb8dY?=
 =?us-ascii?Q?WtJLzQ6KiITLMe1RId1/gjlUeswTLkASlduh+YgiszZ/UYodoz5R3OW/721P?=
 =?us-ascii?Q?IqztG7VkYh6NG30HASCQbJH1Y30EE8FrPcV+K262NzClYu7kvvr+QuT0FvjH?=
 =?us-ascii?Q?5Pskg2kRN8oseuU+wj8vLdt0JR5gYpRd3/ux89sRFhaQjgo7oYL+HlW+WRq9?=
 =?us-ascii?Q?ZCZp7NVBHWCASRnxl3XLzwsZIrknOBLDTB/Php9LNL+rADWVbvV6SBW5PUuj?=
 =?us-ascii?Q?Ox8oFYG03j6+dihIhfrCrnmGGsvpgz000r6BzgnPx/14qf1QQzZHUCl+83f6?=
 =?us-ascii?Q?Jo4Qzu4V8s+NzbGEBsuzHGg2lD2O+fU6z3iVhbkjEg7KgPTUlMDAie/a+HS7?=
 =?us-ascii?Q?s1Ys0DMNi4NO6bwu3NrXNEP9x2QjrXbXQQJTjlrNyMNqYsSu0n2nzR7ddDqg?=
 =?us-ascii?Q?R/3YTx9lTyz72aTpQl8dnOiQ0j+Pt4iSQqS2xyIYnYBhEJgrgne71vuobIDU?=
 =?us-ascii?Q?QOyKRHKbpq5jh/5vISnEz0LUG3ulotMOtFR496AGr7nP2xwNAH4rwKTfvqfM?=
 =?us-ascii?Q?jQMSkJ84XpP36LGP5fJwAUAYzpX7CCCe0wokeCvKL4wl40j72cXXGD+SBfTI?=
 =?us-ascii?Q?1NQpXv5F1BbWQ3HFjor1PyhKTZ9A9hqj/SDuHzFuynpXF420w+Z8yKSsYUIr?=
 =?us-ascii?Q?eCQlL7Bquha/BH1UocB/yV8vV5rtcpia9sFebboqU4i6a1+J48cc8pHvulhC?=
 =?us-ascii?Q?y+YWdeLu3CNq+TQWb5EyGe3Vy9opmuBOpuqZkj+vrSkJHeG9kWyrqY06CgzW?=
 =?us-ascii?Q?xM1IfXytkaSGzrtT5AQ0FisEN1pbQ9UYexN74mXZtdPmadFYmnpJOFQqLGY8?=
 =?us-ascii?Q?SW7n36ZlhYOYFWLiOJ+E67seYqodOj9IxS/010kpYzBvfwBZdnQ2kAMbAGrf?=
 =?us-ascii?Q?I+HDk6DywTSB9KCFHvfWrBnJf2X1JInuGE0Qz5k2sD1X9uvcOXsYjLe1Ha4F?=
 =?us-ascii?Q?gpe3llVZVOdKYkpZs7ScfpJ2IYIFMLe4mih19zWSjOPQUj/PKZpZ48roj49t?=
 =?us-ascii?Q?WQdRWUXhm1Ng1c1hcWUoKZgslpX1NrUTNh9dOBKHHv9RR6NXm95cVzPHdlt4?=
 =?us-ascii?Q?7C0gs/VE4f38DRgZDG5474NWSstuk0FbJjPO6wURrIcJ04yKkblNHKadJwuV?=
 =?us-ascii?Q?TPvntEMc2McoLV0iU6XsP/5fwIeF1wvvx6ViWX84Jd9+v16myBfoBbpaPRpG?=
 =?us-ascii?Q?OiwhmM9FzccXHuOC0fP+K57xJSSuHimdQk/KVsF9NIdpp1xAgUbGQErkMc0y?=
 =?us-ascii?Q?jAKpblY0fXkW14mJ9q7bb43N?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02058769-78f0-4b5b-d411-08d98cd7f411
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 16:55:39.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yyD48NFIxBqrTBo1Tjrm5+r0pcNQbpnfHr/1yLjRG4nKFvQWNcY/RvlR8rQSqfNmo9mKFSlSZLE2kiSPUOprQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the number of interfaces grows, the number of if statements grows
ever more unweildy. Clean everything up a bit by using a switch
statement. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This patch was originally submitted as [1].

[1] https://lore.kernel.org/netdev/20211004191527.1610759-9-sean.anderson@seco.com/

Changes in v2:
- Fix polarity of `one` being inverted
- Only set gigabit modes for NA if macb_is_gem()

 drivers/net/ethernet/cadence/macb_main.c | 94 ++++++++++++------------
 1 file changed, 45 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 683f14665c2c..a9105ec1b885 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -510,32 +510,55 @@ static void macb_validate(struct phylink_config *config,
 			  unsigned long *supported,
 			  struct phylink_link_state *state)
 {
+	bool one = state->interface != PHY_INTERFACE_MODE_NA;
 	struct net_device *ndev = to_net_dev(config->dev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct macb *bp = netdev_priv(ndev);
 
-	/* We only support MII, RMII, GMII, RGMII & SGMII. */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_RMII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
-
-	if (!macb_is_gem(bp) &&
-	    (state->interface == PHY_INTERFACE_MODE_GMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
-
-	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
-	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
-	      bp->caps & MACB_CAPS_PCS)) {
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (bp->caps & MACB_CAPS_HIGH_SPEED &&
+		    bp->caps & MACB_CAPS_PCS &&
+		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set_10g_modes(mask);
+			phylink_set(mask, 10000baseKR_Full);
+		} else if (one) {
+			goto none;
+		}
+		if (one)
+			break;
+		fallthrough;
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (!macb_is_gem(bp)) {
+			if (one)
+				goto none;
+			else
+				goto mii;
+		}
+		fallthrough;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+				phylink_set(mask, 1000baseT_Half);
+		}
+		fallthrough;
+	mii:
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		break;
+	none:
+	default:
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
 	}
@@ -543,33 +566,6 @@ static void macb_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
-
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
-		phylink_set_10g_modes(mask);
-		phylink_set(mask, 10000baseKR_Full);
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			goto out;
-	}
-
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_GMII ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-
-		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
-			phylink_set(mask, 1000baseT_Half);
-	}
-out:
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-- 
2.25.1

