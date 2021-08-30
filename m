Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5C3FB951
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbhH3PyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:54:08 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:46753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237628AbhH3PyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3ypLll+emoIREj74TvLlJMsrZlk17g8lrhiyIFeG+BMJo14GBSyyZJIaaCtbxO6Z/axWQlfdDHjpXcHKXuBtOgIrVbGZEGDelxmR+m4wCKcBJLaON2NXDZNleAOKi+UqXniFGohm7TUK9JkipDavK8Bl+cXQv+vTjetyNcOJCNrMSG8VQG4jfeTku+gwFI7u3SWRaCq/ijmolfjyPwDzmDP/x6/HnV6lymLCN1DjuF8G7ahYmBi69FsA3HzUnw6PxpG8W6+vkgC5JFFc4uOU6TM/hrpYdK1ttR3JXGGDYRfUWKwU2IVBkAuKPNFfWsM2B9JVtp+fbTbeeyC4BBklA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVbQD41dA1fFBadAo4Bi/q3JQRC2vllEEllKZjHijJs=;
 b=VS5o31kb8tJU9cqv42dBgaapukKwuJLLjLoN7NBhWf72Ma8cqyIcQ5SYZmCENh0R1JGtsMTRLDE63mvOrt2Zv2FdkLRP5Dwuia7MWpKPV3shv4A2v45p2bfYybAwZfPb8xc9/fZTws1NZLIYv8MvC3YJ6baWdcSLiFOugN6/9LvU09u9uJXITzTxSmzX2JK2EEqUC53NfzvrXvFlIRGGwFPPHJgBHQmTPR5lXXdc/JkKD1eUFK/YThV6+XX3+0PvQywOpbeuTYvISqnsbuumoPg3fv22SMKIOZhSM4JaTxamEtpDtzWUl8NYkG6DKGB5BJeqS6zHCEL16UmmfTVR5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVbQD41dA1fFBadAo4Bi/q3JQRC2vllEEllKZjHijJs=;
 b=J95PM3OEqLc6xsby11YB/JQkIlJeSAZmab/JwB+TEK4hyh1Q5T8ylnRdKTy8ivb5Rq6Dd8gGdM3VkBt4Yn9ngoGeP8Z9WCnuMmBVpIW6Fkdhp2rFhVjRYnYRFpii+Z8wUPDBGxMIQ9ORD0Uw4ckOdzicqhhJ/ibEk8xnDNtvAYQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Mon, 30 Aug
 2021 15:53:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:53:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC PATCH v2 net-next 2/5] net: phylink: introduce a generic method for querying PHY in-band autoneg capability
Date:   Mon, 30 Aug 2021 18:52:47 +0300
Message-Id: <20210830155250.4029923-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 15:53:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95fa70be-2f83-4a7c-b2d4-08d96bce43d3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910F054FB2D4023C8EDF6DEE0CB9@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: duYe2fYHr99GHMEyJBkAePnpxeAFIK0gVU7zaw+ceWiBQ3iZzqknjd50UJwL8pRiWvCvtbZq5XYVK/o1YTmtlNLT/O0O4cX6yF3AVAPPWWUxB6iS+wZwil8Vi3Ajz0NXszPP4jKTeWtTwKE+rBOVtbB8gKuDUBb0kLm7ZuIo1ybK+AWftw6fvl0w+ppOUQG14r+jUFfGwwfB8XRKQaGA01EOo6aT5yQnxK3u0Q4VJKKBu91yPlevG2en3Ch6Mqs7VaW0KSWwg1oOjMi2GW0p3fQ7AV0yzamrfqBYFTtgRO/Q20YesLltrrOpoTNBik9lMjcBvJ+ronUO1ljwsD3yrOI9gHqOHlVC6mGYaGZlJrvQY8RxCLQYg9Yh0lrN4hq2u2Ch+4GhZSl3fFsm+iv7My/ocNKWiBEgurMdn9wKLBWVe1jLfR43S194OFuu46+vnF4gWHMDxBVV2/AGhpwfExwzj44qI8ewobuWYMdBwsCD+jJBWjXs1Fm7XcowDvPhPkaFb3OVXxtArTzCUskaIt/FBniiov1S5XekZG48iJZL3k9RGZK1e92iZZC7GwcrEsSJbpdiH+6QaSFA26S/zIMkXYHL/ZLgY1A33I0EnGWzqKSR7Ob2oB38upIpkzgs9WmHZ0Htjx+HhCaRLZJHthtyrcEpFVvJnfugw6XMYZ4IlH+WzDzHjyMGlZOyJXkMAS7PJQV1EPQzt/WQ//jhMuJaVtyEC1l+riwOnsJHHVc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(5660300002)(186003)(6512007)(86362001)(36756003)(7416002)(2616005)(956004)(1076003)(6916009)(66946007)(8936002)(6506007)(2906002)(6486002)(8676002)(66476007)(66556008)(6666004)(38100700002)(54906003)(38350700002)(4326008)(83380400001)(26005)(44832011)(316002)(52116002)(478600001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+VPRiHyAxJaGb3Qowdpc8K3r64830peDEkhfEx9AjYA/hBzl29S3ATKyZr5c?=
 =?us-ascii?Q?ExbT4O2rE7dB48ltbYsiSH4+dum3NqyEC1on7RKfF49qGeJ005KG3O55uGPi?=
 =?us-ascii?Q?WMiiIAfueTa/2jLCBHJH+LAf1D8m34vu7FQX9zIbL3dBv+NofZIwMEr2tEJp?=
 =?us-ascii?Q?4mtxSncZJib9HZVoEoxoLoGPHt49fi+CVV676em8vw+1pQr18QcqiS25lNyG?=
 =?us-ascii?Q?WrfUrr2mdbe1zoq2Qircb5I1UH6cf0bGMmixJPFnlCmyHS3ettHT9J7uY700?=
 =?us-ascii?Q?2ia5942JHwJAi3toKRYjhGoPtAp+DVFrYqmr4wAEygUG/33RSNZQ53DInPct?=
 =?us-ascii?Q?P0YMVYgAIKQsrlwUyjtfvZPzRRWS/RfT7MNnzGELxRVlKn0rGzzAHMbX3gLI?=
 =?us-ascii?Q?kx/nRthYepv3J9JXH93BY+AQJOb3jZBn4WsVuYaoxl/XSLzELH6Q492yevyn?=
 =?us-ascii?Q?cTz5zMH1v9XtF13FbtaOU74qXHPJASBfpdWzNj6wwIZmlP4BlL4Bh2RzhXIV?=
 =?us-ascii?Q?wrKz2sh/rX6dH7ntdMVEVfOz855hnpo84kr+RgWGOKtxVQCHYBwak8nM5bBz?=
 =?us-ascii?Q?rbeOGlbmq6zxZBkwnfa+Bnwx3H7Mvf5ZBq5RGjfl2kAD97zx7mhwR8dOuq9e?=
 =?us-ascii?Q?pQpHUnIdiUiHaxbElYVPv/pjFchq7ulpYniFUU/rO1oEH9EmBJebRkRKI99+?=
 =?us-ascii?Q?rIOXkUP/YcGqzBYRfJExaIgwrHY8di9D/3JMbT9MK2Ebp0cMbYJ2EAuV50x5?=
 =?us-ascii?Q?EAbBgpd2IBKR+4xc6tdDgvE7nG0Q1kE43yOfL6eKnjZB64ODhw8w7U0jdPON?=
 =?us-ascii?Q?z2E3Ej5vJl6XLRHR6+IdskGt07rElIuB9hQ8gySUsc6fIsa5Hg+5zYR9oeU4?=
 =?us-ascii?Q?UgseMwt9jqspKaiwxlv8p+qUnO7OFX8skiHjwbsDTOMsEWMW0r+g55HowWk7?=
 =?us-ascii?Q?a5Fisn4GlspYlXSOcVhboxKqP9AQ3cbQ2HGOCwCFpzgz0wuTWV487dDq1U8h?=
 =?us-ascii?Q?rRuXXfD28Udn8WNd3SJ4/fYimZthl9kCVXBhfROXZvzT0Kx18zfYK2f8nyTc?=
 =?us-ascii?Q?9LSnChqnHrn8OrqE5YUYCGVC+GPEks+B77F3XxaeZfXE/pXLVd2YKRLHwHyE?=
 =?us-ascii?Q?p+RL2v2bjcOS4YS3pix3AFIIGdzsD/G0yyNiDLTiuUTnNWlCZJCU0ysnBZyB?=
 =?us-ascii?Q?zbTDGU+Zfa8h/8drM3AqSLgqIuitkceGCg3kP3BEwilfoLi6XZp0KFqMXi6W?=
 =?us-ascii?Q?EDFOmAfDu086cU+m7ciiisSa3H0tffhP3xh1ZWG4RL0ZEN0FyDKSfjRKjenX?=
 =?us-ascii?Q?1SRBCBvajSZ4f2w07dEOPFFx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fa70be-2f83-4a7c-b2d4-08d96bce43d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 15:53:09.6227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8eHNXNpI63pvbsyJ4CB5mPGeS1PPVP72IEi+gyBJm/tKgJJtQ6HiMG41blQHORYv+3YrYgXTLpwBxrZgWcMsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink parses the firmware node for 'managed = "in-band-status"' and
populates the initial pl->cfg_link_an_mode to MLO_AN_PHY or MLO_AN_INBAND
accordingly, but sometimes things do not really work out at runtime, and
the pl->cur_link_an_mode may change.

The most notable case is when an SFP module with a PHY that has broken
in-band autoneg is attached. Phylink currently open-codes a check for
the BCM84881 PHY ID and updates pl->cur_link_an_mode from MLO_AN_INBAND
to MLO_AN_PHY.

There is an additional degree of freedom I would like to add. This has
to do with the on-board PHY case (not on SFP). Sometimes, a PHY can only
operate with in-band autoneg enabled, but the MAC driver does not
declare 'managed = "in-band-status"' in the firmware node (say it was
recently converted from phylib to phylink). If the MAC driver is strict
in its phylink ops implementation, it will disable in-band autoneg and
thus the connection to the PHY will be broken.

The firmware can (and should) be updated, but if the PHY driver is
patched to report that it only supports in-band autoneg, then the
pl->cur_link_an_mode can be fixed up to request in-band autoneg from the
MAC driver, even if the firmware node does not. While I do not expect
production systems to rely on this feature, it seems sensible to have it
as long as it is not difficult to implement (the PHY driver should be
updated with a small .validate_inband_aneg method), and it can even ease
the transition from phylib to phylink.

There is also the reverse case: the firmware node reports MLO_AN_INBAND
but the on-board PHY doesn't support that. That sounds like a serious
bug, so while we still do attempt to fix it up (it seems within our
reach to handle it, and worth it), we print to the kernel log on a more
severe tone and not just at the debug level.

So if the 3 code paths:
- phylink_sfp_config
- phylink_connect_phy
- phylink_fwnode_phy_connect

do more or less the same thing (adapt pl->cur_link_an_mode based on the
capability reported by the PHY), the intention is different. With SFP
modules this behavior is absolutely to be expected, and pl->cfg_link_an_mode
only denotes the initial operating mode. On the other hand, when the PHY
is on-board, the initial link AN mode should ideally also be the final
one. So the implementations for the three are different.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phy.c     | 13 ++++++++
 drivers/net/phy/phylink.c | 63 +++++++++++++++++++++++++++++++++++++--
 include/linux/phy.h       | 16 ++++++++++
 3 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f124a8a58bd4..975ae3595f8f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -750,6 +750,19 @@ static int phy_check_link_status(struct phy_device *phydev)
 	return 0;
 }
 
+int phy_validate_inband_aneg(struct phy_device *phydev,
+			     phy_interface_t interface)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	if (!phydev->drv->validate_inband_aneg)
+		return PHY_INBAND_ANEG_UNKNOWN;
+
+	return phydev->drv->validate_inband_aneg(phydev, interface);
+}
+EXPORT_SYMBOL_GPL(phy_validate_inband_aneg);
+
 /**
  * phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 28edb3665ee9..6bded664ad86 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1042,6 +1042,39 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 	return phy_attach_direct(pl->netdev, phy, 0, interface);
 }
 
+static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
+					      struct phy_device *phy,
+					      unsigned int mode)
+{
+	int ret;
+
+	ret = phy_validate_inband_aneg(phy, pl->link_interface);
+	if (ret == PHY_INBAND_ANEG_UNKNOWN) {
+		phylink_dbg(pl,
+			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
+			    phylink_autoneg_inband(mode) ? "true" : "false");
+
+		return mode;
+	}
+
+	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
+		phylink_err(pl,
+			    "Requested in-band autoneg but driver does not support this, disabling it.\n");
+
+		return MLO_AN_PHY;
+	}
+
+	if (!phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_OFF)) {
+		phylink_dbg(pl,
+			    "PHY driver requests in-band autoneg, force-enabling it.\n");
+
+		mode = MLO_AN_INBAND;
+	}
+
+	/* Peaceful agreement, isn't it great? */
+	return mode;
+}
+
 /**
  * phylink_connect_phy() - connect a PHY to the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -1061,6 +1094,9 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
 	int ret;
 
+	pl->cur_link_an_mode = phylink_fixup_inband_aneg(pl, phy,
+							 pl->cfg_link_an_mode);
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
@@ -1136,6 +1172,9 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	if (!phy_dev)
 		return -ENODEV;
 
+	pl->cur_link_an_mode = phylink_fixup_inband_aneg(pl, phy_dev,
+							 pl->cfg_link_an_mode);
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
@@ -2096,10 +2135,28 @@ static int phylink_sfp_config(struct phylink *pl, struct phy_device *phy,
 		return -EINVAL;
 	}
 
-	if (phy && phylink_phy_no_inband(phy))
-		mode = MLO_AN_PHY;
-	else
+	/* Select whether to operate in in-band mode or not, based on the
+	 * presence and capability of the PHY in the current link mode.
+	 */
+	if (phy) {
+		ret = phy_validate_inband_aneg(phy, iface);
+		if (ret == PHY_INBAND_ANEG_UNKNOWN) {
+			if (phylink_phy_no_inband(phy))
+				mode = MLO_AN_PHY;
+			else
+				mode = MLO_AN_INBAND;
+
+			phylink_dbg(pl,
+				    "PHY driver does not report in-band autoneg capability, assuming %s\n",
+				    phylink_autoneg_inband(mode) ? "true" : "false");
+		} else if (ret & PHY_INBAND_ANEG_ON) {
+			mode = MLO_AN_INBAND;
+		} else {
+			mode = MLO_AN_PHY;
+		}
+	} else {
 		mode = MLO_AN_INBAND;
+	}
 
 	config.interface = iface;
 	linkmode_copy(support1, support);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1a47c4..4ac876f988ca 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -698,6 +698,12 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+enum phy_inband_aneg {
+	PHY_INBAND_ANEG_UNKNOWN		= BIT(0),
+	PHY_INBAND_ANEG_OFF		= BIT(1),
+	PHY_INBAND_ANEG_ON		= BIT(2),
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -767,6 +773,14 @@ struct phy_driver {
 	 */
 	int (*config_aneg)(struct phy_device *phydev);
 
+	/**
+	 * @validate_inband_aneg: Report what types of in-band auto-negotiation
+	 * are available for the given PHY interface type. Returns a bit mask
+	 * of type enum phy_inband_aneg.
+	 */
+	int (*validate_inband_aneg)(struct phy_device *phydev,
+				    phy_interface_t interface);
+
 	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
@@ -1458,6 +1472,8 @@ void phy_start(struct phy_device *phydev);
 void phy_stop(struct phy_device *phydev);
 int phy_config_aneg(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
+int phy_validate_inband_aneg(struct phy_device *phydev,
+			     phy_interface_t interface);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_speed_down(struct phy_device *phydev, bool sync);
 int phy_speed_up(struct phy_device *phydev);
-- 
2.25.1

