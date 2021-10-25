Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358F8439D8A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhJYR0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:26:46 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:53252
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233249AbhJYR0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:26:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OA4B2mAwpmcqMt3X8O3q0n7mKegpTJcbpFbuosjsadY83KaQ1TZYayO3D6ojEE37i5+qIJ3ifUhiVUzx7uBF5TXWnTlA3nwSQFpkkPGFkTKW52Z7BaPra8CO7tbYd2fVotF96SJHS8BSjUYNV559xWdiPTHy3NwdNCjEqAN3VFZihungEjhenSVvzL4cWa1aqA9P/UURSzGX6bx51h2acworiJ1SadqrOdvsQTEyVXuH7Evv6l1PR2dQjsh6WOGVBhuJ72WUd+QoLSN6u6cGA2qSl7L9AUtNIQ/j6oKAxAJ8WhQAHECWLLz4fqAYpj0GksSQIoxC3rczukpCgzRu7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvomcXVzU7vnPENE2bOknppjN6Ox4yvll18fwD2Ghh0=;
 b=e4/QpGjQYdFIU21yAoFQHsnQqDpLht4WNO9WiJv82FcHo+JV5wxEyLhjBIGNERZCzTy4q/kz1jPVkp6Yfxa4vAzG4pVjNMlyFUY4NsKPvPEMjy/NXQYZL2J+kybUBdDVoOSn/GVy1AOCJHLip9FEidA+lBkP/HfbqAXOeq+wTPkdgUEkUj6PT1iwI46LvKh56lMDuyU1bTnSJR5L8+tEbWMdjEZBjWR0TmL43HZulgJTjuqwcHDEN5Ul2ETebNzyquL8thrJG9QnQytMI2qSTphGtWR4P44/X+1sd2v3c3YGkNkog/HQfh+b7uTvyuo+Gy2xSio/bCmCIC7L6PLbqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvomcXVzU7vnPENE2bOknppjN6Ox4yvll18fwD2Ghh0=;
 b=At5AaNs65b8tUAjRLU1UjD3Xjr7wpkO1ZuUMa/+bcZXbPsqYit/cT6+5QXqyVdP30tg7R4+l8rEOIQEN+Y6hOusrjfObry+HjDlTIsC7YGfIg3W4giEVmVMLTPKT7ixQ4saOjtosjOvvIBHTG6edNAtygU4TbWHZ4VWHV1p1y/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5579.eurprd03.prod.outlook.com (2603:10a6:10:102::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 17:24:20 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 17:24:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4] net: macb: Fix several edge cases in validate
Date:   Mon, 25 Oct 2021 13:24:05 -0400
Message-Id: <20211025172405.211164-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0129.namprd02.prod.outlook.com
 (2603:10b6:208:35::34) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BL0PR02CA0129.namprd02.prod.outlook.com (2603:10b6:208:35::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Mon, 25 Oct 2021 17:24:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e175bcf-b0a0-4cc7-7d1c-08d997dc47cc
X-MS-TrafficTypeDiagnostic: DB8PR03MB5579:
X-Microsoft-Antispam-PRVS: <DB8PR03MB5579DDA33F904C22BDFB5B7396839@DB8PR03MB5579.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Pq1eEQrWZfq89yO2lnJIRPJDI+6e5JPut7LyT/4lO3rzweY6I35/CFZcR1Hl4tVRRj0AF7pXmRQNxk/zTl+EcojBbrI/b46sJTUruNT1WrqCwJdBwtL2yjSK6YD6I6YGvZfnY4G1wILzyXDoCK5Ftp3uyC4Z8cbvFC8Ceo37kcpdwRkJra6LBfwfqYuZnQ1JLXScfs63Yjq25kTqssym/9TLTdgBR4fxQr5Dy4izXHkkXwsgTd0ntWXuvxvQiyNhTSoKBD5EoFb4VfCYd/G+g+Yy7AXFG33b9tx6GOVoTToKJhvLefsUT/OsnRi9mbllgdFQ6AgUjeiZ3YxFGRoBR6mlWHS9hUY4blqvvTEkpMoGdUOaXKgrFBytSXKdtl9dI9xMAWssLEil6xS1UXevH0o6z88PBieMH2vtmkeJhjWniQoi0IUhmAHBsvhLdrIlXBLh6MlY3qyTjrMHuowxsxOdnUj1L65j2Lp2K3IMO+y5eDZJE0rt9Y4q639r8cOcikaeS39OczQKBrUNUBIjQRA5BZZHQCimLHwHILP7duZrN9STxeOQGujK7dzO1UB+Kqk91k0UGCUeOy8wnzpwNmNvTbvIcU7yPiBW0h/3rHand1Uq5VLqRO0pHOX5BcevFOjZFDZWkLqSY25EbRCCU8Q1iAfrHIKCAUKFDp03GoiPCd/UU286OPum+ASdCeP6gQIGkuujm0tYtaFW+o0XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(8676002)(5660300002)(1076003)(186003)(110136005)(54906003)(956004)(66946007)(44832011)(316002)(86362001)(36756003)(508600001)(83380400001)(2616005)(26005)(6666004)(6506007)(15650500001)(6512007)(6486002)(4326008)(66556008)(38350700002)(2906002)(38100700002)(66476007)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W8E6b8YCMUOip/PigBFZSTFq5gXFW8wNnGgpPKmwsWFQHYQ1LD2RnplgocrT?=
 =?us-ascii?Q?nbc/2xez+Q09Uhkir8y9Kt/Gwesl7DbCjrPfXQP2HKa1seA2/3NmaXEl1np+?=
 =?us-ascii?Q?APlsMNBAT1JNeE4p2UhixKVQuKXmtFNLpqg4fVbJqSisj+LApG2cffyyelNL?=
 =?us-ascii?Q?qw9wcpH1a1oCDZ8k+veKI2GIYll0ScHuRA5fz5oId/GvnycPjaQ8OXaSAfgh?=
 =?us-ascii?Q?79YzVrf+Fi2ovcRz/tPTfwZhd+Llgm0xuXCXwnTOefT2FYWzSMIGvvVPyArZ?=
 =?us-ascii?Q?WHNbQ56bdeOaiF0yS+T4/w8joosiZWBeZa+loJn0SbQB20hQcj7aMyB/nn34?=
 =?us-ascii?Q?Iysu5k4q4WtVGvOFRO6JsAnZKsRq7dieIl1m349IkBVssQDrFfm5RsGK8zs5?=
 =?us-ascii?Q?l7lzT2ksm2R/p8R0TgHcB842G3GZEK7NndK4fKDYRodjPukLRknlCFMBOlCb?=
 =?us-ascii?Q?wxvbuD+09Ksc0XcZBFVvo2nHt19lLefoeD9KYdFBX+zhp6gXZByVjPnX3rOk?=
 =?us-ascii?Q?AfvpZlWBLl1oszsgT34fEh71OqCrdfdGByjw4LvAUWBm4BTXXz/W8q7RbTO8?=
 =?us-ascii?Q?AkeeyvE8wS5JUFpWuGL2+3eKeEsyizXS4NHXbb9hPnLxNIxaMsidSKEV+XsN?=
 =?us-ascii?Q?kWIv2LDLjmLTTWEOgBAuZ7pnH2E1yADVUD6ioDWYkkLOpXD9Dsm6TgG4BBYx?=
 =?us-ascii?Q?4QJqwNbdMkgLBJv39ig94WDyjvLk5ymBja0TB8UV2WcsBcX2x2xNfAVws5qR?=
 =?us-ascii?Q?8VVvXLxH+A1zudqHpoc8cVspJFEosquMSaZDoC52YqJjj+qt9NB9eotQcgIo?=
 =?us-ascii?Q?Wtg9av76DE32sQW+eyiWGkhiP8CP5otk8dp8wOalFstMxztWbnTvaCutvNjK?=
 =?us-ascii?Q?zdrXRjKOaQnM9F5+YYpu09QWFgFf7j2aMoM1aLBdjrNd1kU8bFZAG7t61sJw?=
 =?us-ascii?Q?weQOeOUpeprVwiKCUMGy3nSC+IOvDcGOTXz7Oz2uRf4kuguNiLD6euGpxpcH?=
 =?us-ascii?Q?9kvIAbEukVTJ+t5Lcfz6mqqThes32DQLMVK2h0MDsfqOnHoiOGCEAK4QIa4t?=
 =?us-ascii?Q?PCk7m1aN3mnPBMpgssA+IW0NuHmvNFkBCdTsIQg6drOutBOzmoDNELVQmowA?=
 =?us-ascii?Q?79/OYERIgMtepzW2qZ7CuiikqDzf9NB+d+ASu5nvO2/KJpoNyOorN1KutOrn?=
 =?us-ascii?Q?AC+5HG1nhKNQRI1/Ee/dfUVJcUipuobVKOm0/wTzpQ8pi8OgmW9iiFIaC1xk?=
 =?us-ascii?Q?ERm5ES/rxN+IojlOMdHcCSk/rkKWLa1ZDm/C4Pyo5/XbtzK9XkbQpNQIj1Id?=
 =?us-ascii?Q?4ZXQC9KNqDS1rDT2rvE0PnD7FBqF9PqTs7cGQbrXpVpbap75davSIl9Zc4ya?=
 =?us-ascii?Q?GVOojfwfUPVQZzCViN2Pm+rXHj6F2BBXrZulzd9P12XVatRM67q36UEmAaCd?=
 =?us-ascii?Q?arMZtuOe3FGxB1IXmO0EcIARNh5SOUp6Oiz8XmKLF+ecczmMQ26akVz0Mj6W?=
 =?us-ascii?Q?jABmCirDXb+/aMc6h3EXDOPrecQ1iL+KhurCeeBsn9G7LOy+TIQ3t5zvN42P?=
 =?us-ascii?Q?Z2x06WUf4v3OTLCr65mLmKaw831q+SKytrYwS1Vs+I0S22j3sQ3y9RjMY+VV?=
 =?us-ascii?Q?PeKV9PT8VAMK+jJEOwGC7o4=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e175bcf-b0a0-4cc7-7d1c-08d997dc47cc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 17:24:20.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gB2b7FCYMYVMDGVaDXjDgWqKNky9RloeEwyPu+XkAbqNmZiUA6oHKTO0ODlFp+/H6NdKEoO1SqE/g/GBNZxFiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5579
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were several cases where validate() would return bogus supported
modes with unusual combinations of interfaces and capabilities. For
example, if state->interface was 10GBASER and the macb had HIGH_SPEED
and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
another case, SGMII could be enabled even if the mac was not a GEM
(despite this being checked for later on in mac_config()). These
inconsistencies make it difficult to refactor this function cleanly.

This attempts to address these by reusing the same conditions used to
decide whether to return early when setting mode bits. The logic is
pretty messy, but this preserves the existing logic where possible.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v4:
- Drop cleanup patch

Changes in v3:
- Order bugfix patch first

Changes in v2:
- New

 drivers/net/ethernet/cadence/macb_main.c | 59 +++++++++++++++++-------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 309371abfe23..40bd5a069368 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -510,11 +510,16 @@ static void macb_validate(struct phylink_config *config,
 			  unsigned long *supported,
 			  struct phylink_link_state *state)
 {
+	bool have_1g = true, have_10g = true;
 	struct net_device *ndev = to_net_dev(config->dev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct macb *bp = netdev_priv(ndev);
 
-	/* We only support MII, RMII, GMII, RGMII & SGMII. */
+	/* There are three major types of interfaces we support:
+	 * - (R)MII supporting 10/100 Mbit/s
+	 * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
+	 * - 10GBASER supporting 10 Gbit/s only
+	 */
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    state->interface != PHY_INTERFACE_MODE_MII &&
 	    state->interface != PHY_INTERFACE_MODE_RMII &&
@@ -526,27 +531,48 @@ static void macb_validate(struct phylink_config *config,
 		return;
 	}
 
-	if (!macb_is_gem(bp) &&
-	    (state->interface == PHY_INTERFACE_MODE_GMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		linkmode_zero(supported);
-		return;
+	/* For 1G and up we must have both have a GEM and GIGABIT_MODE */
+	if (!macb_is_gem(bp) ||
+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
+		if (state->interface == PHY_INTERFACE_MODE_GMII ||
+		    phy_interface_mode_is_rgmii(state->interface) ||
+		    state->interface == PHY_INTERFACE_MODE_SGMII ||
+		    state->interface == PHY_INTERFACE_MODE_10GBASER) {
+			linkmode_zero(supported);
+			return;
+		} else if (state->interface == PHY_INTERFACE_MODE_NA) {
+			have_1g = false;
+			have_10g = false;
+		}
 	}
 
-	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
-	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
-	      bp->caps & MACB_CAPS_PCS)) {
-		linkmode_zero(supported);
-		return;
+	/* We need a PCS for SGMII and 10GBASER */
+	if (!(bp->caps & MACB_CAPS_PCS)) {
+		if (state->interface == PHY_INTERFACE_MODE_SGMII ||
+		    state->interface == PHY_INTERFACE_MODE_10GBASER) {
+			linkmode_zero(supported);
+			return;
+		} else if (state->interface == PHY_INTERFACE_MODE_NA) {
+			have_10g = false;
+		}
+	}
+
+	/* And for 10G that PCS must be high-speed */
+	if (!(bp->caps & MACB_CAPS_HIGH_SPEED)) {
+		if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
+			linkmode_zero(supported);
+			return;
+		} else if (state->interface == PHY_INTERFACE_MODE_NA) {
+			have_10g = false;
+		}
 	}
 
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
 
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
+	if ((state->interface == PHY_INTERFACE_MODE_NA ||
+	     state->interface == PHY_INTERFACE_MODE_10GBASER) && have_10g) {
 		phylink_set_10g_modes(mask);
 		phylink_set(mask, 10000baseKR_Full);
 		if (state->interface != PHY_INTERFACE_MODE_NA)
@@ -558,11 +584,10 @@ static void macb_validate(struct phylink_config *config,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
+	if ((state->interface == PHY_INTERFACE_MODE_NA ||
 	     state->interface == PHY_INTERFACE_MODE_GMII ||
 	     state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
+	     phy_interface_mode_is_rgmii(state->interface)) && have_1g) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 
-- 
2.25.1

