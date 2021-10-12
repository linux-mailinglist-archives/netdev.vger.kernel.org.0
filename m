Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D609542AD72
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 21:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhJLTuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 15:50:11 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:55521
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233465AbhJLTuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 15:50:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXBtizYU4ftBg4u1U8xOfGtO80IxcLs2gkI54QDaNnouIqPVnOWwEclwlLJloqUs5GrTzgmQ07g5NljnuV7cGgSLfPeCoR+y+2YGwdAJnmp31ZkjnY0+fUI7FMPRjE85598KnC51LJOBn+kpH8M7/cbdHdM5KcTvcbb6AHebSxkPDzspyDMips05ZvINNOhQUkuUZKuM0HTdvaVrzkoG10u+dRt1uUd6tGvFWKRq3V4Vc0K4ZByhWsgY8qkIwNLcmj9pYUHXxo6LgURzlyRb7XHbe/IgMsF3de1zjl10F703EQfuDJiy0B5jgPzNMt7LM2a5epG/UjOMLSqaM65oxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gr8FqXiIsekp6EXmr+dTkQ+bkO+Wp5uofsKCYzoTvAY=;
 b=Cs8IkSuenFOhuuwBXV2MQJt4fONViFAeVEDwR/jdPN6VQd4KCAF4vcYvhJiKY7OciPWdLH9J0hPphV/lfeE6Fn28W/UzNj6c7VCf8jYkM/bIngz84gPQcHwJQ+FgJn1SkkGDZpGrq0VKGs/G1yyHrY9h+n5tv/9OGfi+g+tNMrq/+eIbFPn50P1a8oMTFh4ujEntFnd8rd9epqGR5VDXAIwpb+F3FXu3N7ZTT35MCxq8TuZfTcd0b8oyyp67gedwUwmHXpNaDZGcsaoNNURUomzIAYM0ajj1JCyWF2RMssyrD+967MwfK5f4gRUXro28tdBO3EKGocHtV3fx7iDTCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gr8FqXiIsekp6EXmr+dTkQ+bkO+Wp5uofsKCYzoTvAY=;
 b=fpjlY2oNbDjRYmssPYNJGKA7J2Tow/h1hmSbU25V78YSahsXe9Yruqol+Iq7qpEHW+C6vTo3Qg4Apd5hfRTJJJyCL0wJBUKtdhFs3tVfV+Ync7DfXFJg1t6Haua126d+u42DXLbBB3Vw5Tt8M40yNgfssIxp9nLEJvhoEa1281k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7513.eurprd03.prod.outlook.com (2603:10a6:10:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 19:48:07 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 19:48:07 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 2/2] net: macb: Clean up macb_validate
Date:   Tue, 12 Oct 2021 15:46:44 -0400
Message-Id: <20211012194644.3182475-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012194644.3182475-1-sean.anderson@seco.com>
References: <20211012194644.3182475-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0021.namprd19.prod.outlook.com
 (2603:10b6:208:178::34) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR19CA0021.namprd19.prod.outlook.com (2603:10b6:208:178::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Tue, 12 Oct 2021 19:48:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2eb63efa-4a4c-45fd-ba21-08d98db93673
X-MS-TrafficTypeDiagnostic: DB9PR03MB7513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB7513198BB9DB97B82786628596B69@DB9PR03MB7513.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnWAHgttnRrF8nKeobjOKzyBy/CTbGkmOvRht94vrzFkmFIMosZQzz98HibxzWxrPaVg6o/w9W3y5zWOwn3S3mg88VFZ8l1TLr9M/rlgG0RtUYUdP+NASuEmORBgWDu5r5YOTJfZ/5zdrAc/WXa0DgbopPSePWTBq4DeXgOSuF9vHGdZ3cwO5fo1e0w2T0l2pBA257nWbAxiEYq3iu5N+v2I5JqgYtzv7wv6K/dL8ioHuBQAa+QF+k0vnbfsE9bfGBLjuokTvWMlZtZ3orwNf8xRhJZX/aE43RKEwHzbXL9cYsUkjZNXjt6jjGMBA+KEPqgrv3yvkKtCEVl24ranXnWUPfVebhKxFoyARNriHkx0pbC5DyEO3w0AJb+QHM9KCBVYN3pXEj/7I7IRWDNKlQ/NSKvq5hzIeK1dCE25xdFWuwwZ/7smBoldlDbWBFPYnU6bDUmO9QHXmPFbQgpUvQVBMryXaumJQ+7ziyJ0RwDzk/wf8tiiJyNd2rmio4tlqaoa/nweJKiKtFSBTV7slypQOw6BBk2OuwXrLNFn5zw5b+0gAbtcN0UTX2XxD6X75Sfr7gPT0LLyHTTtwMU4Ek8Z2lZFwTSdx/ac6YDJcmgTO6nPKtz5AFOaKKzfgRfbWIBPsTYg4Z1y3KSP/wzbY00CjpVVZDzf8zqJbbUsYyochP0nXNoCLRPP4CHG5iqdTwWia9/wXta0hJqv0bRpL9PnQgiDJK1/rXLrE5Vf8qjUnjKZS74pPweU/dHHkjQ7BmUT2FpW/oAgM7TN15cToJFNROWyr0FzSRRDxFqvulU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(2906002)(2616005)(5660300002)(107886003)(83380400001)(38100700002)(38350700002)(86362001)(956004)(508600001)(4326008)(6486002)(966005)(66946007)(6506007)(6512007)(110136005)(36756003)(26005)(8936002)(8676002)(186003)(52116002)(316002)(6666004)(1076003)(66556008)(66476007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIULWOgwMgFYESl2+uMqUZ/P8UdT+g53WQCydhDxGVKEmt7LbSFOJK3tOi5I?=
 =?us-ascii?Q?OxEJNKylYPzyR7NRGBKj6YWPbjvDXJ/mWPDgA5LGxS3Jwj5p832f9asx306X?=
 =?us-ascii?Q?5JXGzNoMfeMA4Vn/OlJfWMStf00XVtNeK/uQthJ0UtAS/IFo0VblVpu6WyYT?=
 =?us-ascii?Q?Bjzc8g5Ux+fDWw5/x6SYxqzx3aimIfPEyBln4Z5TmnGmf/VlimrHJYrgBlnG?=
 =?us-ascii?Q?mcpJy/PzQrsaXMqXWqU4eGyAcj0e0q41Y8GpWEOiwXEVH+3vukhkaKWj0WXE?=
 =?us-ascii?Q?J3HylsD6lgEwnvBsgzPA7vreZW+SnqoEpDN9YUUgaD9fASUQPh/iw9UqLqET?=
 =?us-ascii?Q?+yRdjLWafuqDpkiFaKTxBYFvoIOGwiY0Tg+Vm3aQgGgGRAuPbWYbcCampqcX?=
 =?us-ascii?Q?DE8ji1dDHd1m60QbUcbtmYkeKXBEgOX8zaD5TgSFyths1ebzXc/wJkZRExzd?=
 =?us-ascii?Q?XgQ9tLS8mLoR4r5SH1nqTxdLrjKb8qnPorJZbAi6HsBy0MAZ45dbE6zmwLPW?=
 =?us-ascii?Q?mvO8ZbFJf0DADVsc/l2sVT2RG6965puQuGSiPpdy1HUlFoCFbldmLY8Ov3fB?=
 =?us-ascii?Q?0jnkJ+sA/izHUWfwJLpc7ZOUm3V6PGOa/fGi3A7No5Alki/gGMKPg1et18jg?=
 =?us-ascii?Q?UwquA/uSqVyLEiO8QIrKFzlwTQqJmqRHmMn7O7bLf+1oSlyDaAXZU8xUJqfO?=
 =?us-ascii?Q?YEzb482VuvqZymI6XU+xQAfhubSDY7jzE19mygYGorf9M2OblDHYonAVft/A?=
 =?us-ascii?Q?2K4qpckVvFFl4QlILITMrITXDi8tgD7QnRdWN4kzIrVLwwmV8qeWg4n/psMb?=
 =?us-ascii?Q?wS41cR4YLonDLkAaOwfZ/bKuwYyUJG6tsFi2UIvRdHiCttIlT3JYtcecZpZr?=
 =?us-ascii?Q?i+yaSQ1yjg3mFxmBLReED4NGIIHfgWFxCPny8vE94Q622wnSA+HXMcoMoclL?=
 =?us-ascii?Q?CUUpoNmF99fdToairpP+LL0ucjAiB9WAdxJsmD8tyg8FKSbJJvuSlxAEl2C2?=
 =?us-ascii?Q?+IEieRVeAO5x/yyie1C/IDnVoKVRvMbwTpzTMgFALmkDhXserZlzN3CLJvYY?=
 =?us-ascii?Q?9RtQdhWZUrMjqWzPfuuWbTPsCIpEhDXXrEEljGIIXxKc0JFg+rDCYXalGAXl?=
 =?us-ascii?Q?45GilwS1+jtcrZpMQVCZVgCdRDyXMlR/W6bgeS2qaYzzZe+yUo6XXthkZgf6?=
 =?us-ascii?Q?K15qMWPyYLYIdIKltP8GkqjBlEDmRu/ktuukDZemPjYqZkoRkYn19LCp5SZk?=
 =?us-ascii?Q?vsRUZDKZOEdTfJwYg0ujULIBvRkH64LLk3JwT1vTs1Za306Wl7EwlKrh82J7?=
 =?us-ascii?Q?BUmEtfCWu5NXqt1Ic+fjFmLI?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb63efa-4a4c-45fd-ba21-08d98db93673
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 19:48:07.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHCOzYpZOxL5MJK0SHUx/EQw5lvw7rdltB2fEn5WQrC563wl6DD9MqrL1RERpb4Sps47A5AjqsrdRBs8/JlLhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7513
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the number of interfaces grows, the number of if statements grows
ever more unweildy. Clean everything up a bit by using a switch
statement. This reduces the number of if statements, and the number of
times the same condition is checked. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This patch was originally submitted as [1].

There is another approach which could be used here. We could do
something like

macb_set_mode(bp, mask, iface)
{
        switch (iface) {
        case 10GBASER:
                if (...)
                        phylink_set_10g_modes(mask);
                else
                        return -EINVAL;
                break;
        case GMII:
        /* etc etc */
        }
        return 0;
}

macb_validate(...)
{
        if (state->interface == PHY_INTERFACE_MODE_NA) {
                macb_set_mode(bp, mask, PHY_INTERFACE_MODE_10GBASER);
                macb_set_mode(bp, mask, PHY_INTERFACE_MODE_GMII);
                macb_set_mode(bp, mask, PHY_INTERFACE_MODE_MII);
        } else if (macb_set_mode(bp, mask, state->interface)) {
                bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
                return;
        }

        /* etc etc */
}

which has the advantage of much cleaner logic in the switch statement.

[1] https://lore.kernel.org/netdev/20211004191527.1610759-9-sean.anderson@seco.com/

Changes in v3:
- Remove labels/gotos in favor of explicit zeroing. Hopefully this
  better illustrates the "linear" flow of the logic.
- Add comment with overview of the flow of the logic.

Changes in v2:
- Fix polarity of `one` being inverted
- Only set gigabit modes for NA if macb_is_gem()

 drivers/net/ethernet/cadence/macb_main.c | 105 ++++++++++++-----------
 1 file changed, 55 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index cb0f86544955..9b2173c37edb 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -510,33 +510,65 @@ static void macb_validate(struct phylink_config *config,
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
-	     state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
-
-	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
-	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
-	      bp->caps & MACB_CAPS_PCS)) {
+	/* There are three major types of interfaces we support:
+	 * - (R)MII supporting 10/100 Mbit/s
+	 * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
+	 * - 10GBASER supporting 10 Gbit/s only
+	 * Because GMII and MII both support 10/100, GMII falls through to MII.
+	 *
+	 * If we can't support an interface mode, we just clear the supported
+	 * mask and return. The major complication is that if we get
+	 * PHY_INTERFACE_MODE_NA, we must return all modes we support.  Because
+	 * of this, NA starts at the top of the switch and falls all the way to
+	 * the bottom, and doesn't return early if we don't support a
+	 * particular mode.
+	 */
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (bp->caps & MACB_CAPS_HIGH_SPEED &&
+		    bp->caps & MACB_CAPS_PCS &&
+		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set_10g_modes(mask);
+			phylink_set(mask, 10000baseKR_Full);
+		} else if (one) {
+			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			return;
+		}
+		if (one)
+			break;
+		fallthrough;
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_SGMII:
+		if (macb_is_gem(bp)) {
+			if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+				phylink_set(mask, 1000baseT_Full);
+				phylink_set(mask, 1000baseX_Full);
+				if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+					phylink_set(mask, 1000baseT_Half);
+			}
+		} else if (one) {
+			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			return;
+		}
+		fallthrough;
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		break;
+	default:
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
 	}
@@ -544,33 +576,6 @@ static void macb_validate(struct phylink_config *config,
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

