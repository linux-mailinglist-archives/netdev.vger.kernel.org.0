Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260B5437AA1
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhJVQMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:12:34 -0400
Received: from mail-eopbgr50076.outbound.protection.outlook.com ([40.107.5.76]:59296
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231453AbhJVQMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:12:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUgQEz9eFvyp6xriaTYsvLXwoZ71iKihPVcCSHwHSKP5cKMBIYGysL3IZP4WllHAhMP5txljn6OXC1feHlLaJmmGsx74yoq08FLLcaLp3yDR3PEK2jHxTqg9Hb/SCwnhwo09nnI2lZS7g/RncH7JHVkTaIiwbnEN35+ljSyfs2Z2QUU9oMUiZPfmq0OfOK7ojYQ/mm4Yg7Q/4YUBXgGe8p8SRsLzWAJMT9IoP5RxPEvzfDKGzthIBYIJrKc7rb8TXqXtFJEZhjbJr/x6MA/+7ih64GDF9Ty2Yb1nK4z99LKQd6/0fhFDbRx3I6Bnwm4zp7NcrdTcdALIiji0qp1ECA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIqydE633AGsrLo9b7rUT4Y2VA/HESs5fH83OGAxlV0=;
 b=V9WSjC/uMVt6gbhvK1DpxFWzbLK10bw2eLCVj97rfGTaajeG9mtAxc9KBbahvhsYwsZMElFaxAeA10AY/d9IJC9/TkfpwEv6hhVaFFNz7md+emoT0jlZ3EA9YZlXh2uNu4gWcQRqXTUSD72V+kUN4ycK0IoRl5TpAt4W2c/AqYheCF3FxPCnx2kflkKlPIWJuIvyCdt1dns+4rxz/Y1Y6x3EmZ3doeNyJTNt891qDDyQYZdeWOkUvLNulUCSfSwwmdxTal3IsiJlL1+poWMu7/tYbRh2f++8EI6s8NwAyweyNGJJMrGbu6dOdJ9C9QqsaQTmCrVu50RJCcIrBTxXPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIqydE633AGsrLo9b7rUT4Y2VA/HESs5fH83OGAxlV0=;
 b=Bo9pZtdQGarhj+XxdB3HW2UPKwlh/uXbjd774rnbomGQOEDzUEfVTrshBVp9Uqhi5wGP5bDNp1bTRmtv8qBAJcnoVdx6H7vYw8pzblQCyvKZVv9u3wUkXSdG8V2nST/oId37WKphvwgXeb8o27/q4/M6TLiyXFFJYW3i6+dpiSE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3802.eurprd03.prod.outlook.com (2603:10a6:5:3b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 22 Oct
 2021 16:10:12 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 16:10:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v2] net: phylink: Add helpers for c22 registers without MDIO
Date:   Fri, 22 Oct 2021 12:09:59 -0400
Message-Id: <20211022160959.3350916-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0048.namprd19.prod.outlook.com
 (2603:10b6:208:19b::25) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR19CA0048.namprd19.prod.outlook.com (2603:10b6:208:19b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 16:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3344ad7-6ffa-4cd4-265a-08d995766d78
X-MS-TrafficTypeDiagnostic: DB7PR03MB3802:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB38028CAE46EDFC5CFFB9D64496809@DB7PR03MB3802.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zoOSXpOrrCzcgkED2P+m1k4NXWmOjoRw+9oaShqFgXuiviG3gR46QJG/bS1gMrzeorcByakE3Q6XJohMptHH49LEQonzo+AJ6q6AtC+sgN5CQ6uAll/IvkHJXp3trAmg6TZ7ulj2DcPG+iULsOj4UcD6qRVg1WTQvXanyPtfy+HNwmo4GExGhw+7GqqTpP9ZsZby4dmf7TPhvZ3pWcOdJ9cxBQsfN58oDSWI9E+BsCvxeZJpV5VbFZ8fdQ+bc0sL00QiLkI3uogzsHfPTPf2lYmm6Yj02Cskj2p2GvcSGIbN1H7D3YAcGn5XrLTdHbky8wxxQNUFys8ckdi4rOeFqnQ0ZkuGLdAhE6EHpcRwBUl6evWwoAwyMuEBAO0xyaiNqDI4tVVm780BPIE8mYeG967oqiLlZXHP6BaY4l95ecB7Tct3In7ateZhWVrWBUz5DN0YO9nQwtRDRgErQUt1ZszZ89CWhZCndCGTu4c3uNq4yA9C/OiepJM7N8X51o2Rzj55C5LbpxQmZjEj11balc7+Mi2QYL5pvcuV/TIj0vM0eFJI4VTgaoi3n/ORmbTYuIzLkzqijQccU7VbgMN01cl/FjEFue5DMRaDMIhkIoy/5K7WedoY7fe2DU4qrcuWPg//Sgy4DFjl0tPb17/SHPHLAby2Xx4ddOlKlI5YjhNEij4aL6kfqbjI0mOQFdD0hWCXKQ28T22c7TN/BnyU0uSpqmHhChdOx+sUsZRHwyaR4yhf0pxQg4areOYstrPCD8+yQmyui7wWhoVUqIrJ8oXpXzWB+8Xv3b7pr1OHWtg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(316002)(38100700002)(5660300002)(966005)(6506007)(44832011)(54906003)(6666004)(6916009)(2906002)(8676002)(1076003)(26005)(508600001)(6512007)(66556008)(66476007)(6486002)(66946007)(36756003)(4326008)(8936002)(52116002)(2616005)(86362001)(956004)(107886003)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86HN91+Ku2G0cPoRLjX9fo608nVfZsYSWF1qd6nWflItSUae7/ZmTDJyanSM?=
 =?us-ascii?Q?XiqW7pCdFSVdm7FSOLzuaY/pbgYfC72e99JtPp9A2T7i7p00zyoI+4ri4gNH?=
 =?us-ascii?Q?wXUZEG9dKF8zfTLi+ghTUuF+0JlCXNfVGzyKYJ1DcFO1mNDFU27oqzhk9eB3?=
 =?us-ascii?Q?YYxzjabQRMVgH4OdeWPnI5069tLSeZ9fYmJqyTU6WbU5Qmv+yVz7HASd3RVx?=
 =?us-ascii?Q?CQvAgLlTpjT93q6FYgUq1lwiBdrsdWj+1I+rtVBisS5PM639EL6qwMEks1QR?=
 =?us-ascii?Q?wuLO9gSWurm84cTP+u0lRhHny0NloDxfe7hayJANzqx4jSFyJ3bio8Oo8MR7?=
 =?us-ascii?Q?mII7RKflyNrb8wWPtwVnSrrB3HlaQz2OFlzjOR3p/njKpVtcDOsHtIRibke5?=
 =?us-ascii?Q?7bYFiI5ZU3Jdg74gsOCfDHqnnv8s/eemTO4Ruc7BOjYjkFjmQml7C/uLwWji?=
 =?us-ascii?Q?NPyROHq7k7GhllOHes/a4DUEiVqqDOQjI9nkYz6i31DtM5+6T/XnBSEVwQjy?=
 =?us-ascii?Q?tLBFlsR8pny0bImD1cJaqWXyiPSDZNSOAUNAHr37mxa0idqoYtaInig3ynSg?=
 =?us-ascii?Q?la7+qCRsML88Za60N6+5Qp8Q9IVS/WPgWClfwbnmpAG5nHAIrKRHnPJU++fu?=
 =?us-ascii?Q?+fS1rDp5UiJ0oe0p6svSM3jL8zcKqVvrXnJv/PDLfsMWrdFHE4wIp7g3toL8?=
 =?us-ascii?Q?qblWbeSEQ7H0q7ocVTVG2HEDb+kmykUBi3M4PQaGzxFDEXIKh3jeV9tfhoLi?=
 =?us-ascii?Q?h0DFqJUEU30dMR5B73Bumc+4emXVQUCJ9EzG61HsNoYagK5osbjTyUOoXgEC?=
 =?us-ascii?Q?e7aofQU+DPNSGehKDugmBFgPHpHWzsJWZTIu5HiGsbjmy3yPApM19/rKAKWS?=
 =?us-ascii?Q?v9q8oL3gZZ/GrbFHGcbJFtC9K688dwWtnTQlEKM/CY8ftMpNesRO2HvPrcmT?=
 =?us-ascii?Q?afJGkfxLe30pZKk8W9gBzHti3X9BXDYZK3NxwNa68BYTdX97c9a02bfIwplG?=
 =?us-ascii?Q?252oiS0v+wbOdWLTnca30F/E+VUlsKrr5HhmAUNNjH4RfsduUOZNpI2wKXVW?=
 =?us-ascii?Q?CAlGB8NYJoWEC3Shw73dpEqUSP/l6Mo9jlMpPRH82DH5dXKBFZ87ua636sRa?=
 =?us-ascii?Q?Fay6DuuXzqcP2WDFzPwNFdFQJzHFHNsQ8bFtN+GiRI9Hl7x63AeMNH+f29ai?=
 =?us-ascii?Q?IIRQiQe13JNRjhrcnt3VYR+I0wgiN6p3Ck8Sqvs7xpBM7GF0aSoFqcuCDKJJ?=
 =?us-ascii?Q?IQBGWIGMhMdTjrS337z+kMnKEZQQeTpv4TSOIa1yEROF1M/pWyhU2Buppq3o?=
 =?us-ascii?Q?VGuArCAx+mUu9HN4Z+pRg0Hm?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3344ad7-6ffa-4cd4-265a-08d995766d78
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 16:10:12.6775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices expose memory-mapped c22-compliant PHYs. Because these
devices do not have an MDIO bus, we cannot use the existing helpers.
Refactor the existing helpers to allow supplying the values for c22
registers directly, instead of using MDIO to access them. Only get_state
and set_advertisement are converted, since they contain the most complex
logic. Because set_advertisement is never actually used outside
phylink_mii_c22_pcs_config, move the MDIO-writing part into that
function. Because some modes do not need the advertisement register set
at all, we use -EINVAL for this purpose.

Additionally, a new function phylink_pcs_enable_an is provided to
determine whether to enable autonegotiation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>

---
This series was originally submitted as [1]. Although does not include
its intended user (macb), I have submitted it separately at the behest
of Russel. This series depends on [2].

[1] https://lore.kernel.org/netdev/YVtypfZJfivfDnu7@lunn.ch/T/#m50877e4daf344ac0b5efced38c79246ad2b9cb6e
[2] https://lore.kernel.org/netdev/20211022155914.3347672-1-sean.anderson@seco.com/

Changes in v2:
- Add phylink_pcs_enable_an
- Also remove set_advertisement
- Use mdiobus_modify_changed

 drivers/net/phy/phylink.c | 120 +++++++++++++++++++++-----------------
 include/linux/phylink.h   |   7 ++-
 2 files changed, 72 insertions(+), 55 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 14c7d73790b4..df86f4070d5f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2525,6 +2525,52 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
 }
 EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
 
+/**
+ * phylink_mii_c22_pcs_decode_state() - Decode MAC PCS state from MII registers
+ * @state: a pointer to a &struct phylink_link_state.
+ * @bmsr: The value of the %MII_BMSR register
+ * @lpa: The value of the %MII_LPA register
+ *
+ * Helper for MAC PCS supporting the 802.3 clause 22 register set for
+ * clause 37 negotiation and/or SGMII control.
+ *
+ * Parse the Clause 37 or Cisco SGMII link partner negotiation word into
+ * the phylink @state structure. This is suitable to be used for implementing
+ * the mac_pcs_get_state() member of the struct phylink_mac_ops structure if
+ * accessing @bmsr and @lpa cannot be done with MDIO directly.
+ */
+void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
+				      u16 bmsr, u16 lpa)
+{
+	state->link = !!(bmsr & BMSR_LSTATUS);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
+	/* If there is no link or autonegotiation is disabled, the LP advertisement
+	 * data is not meaningful, so don't go any further.
+	 */
+	if (!state->link || !state->an_enabled)
+		return;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_decode_c37_word(state, lpa, SPEED_1000);
+		break;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		phylink_decode_c37_word(state, lpa, SPEED_2500);
+		break;
+
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		phylink_decode_sgmii_word(state, lpa);
+		break;
+
+	default:
+		state->link = false;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_decode_state);
+
 /**
  * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
  * @pcs: a pointer to a &struct mdio_device.
@@ -2551,55 +2597,26 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 		return;
 	}
 
-	state->link = !!(bmsr & BMSR_LSTATUS);
-	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
-	/* If there is no link or autonegotiation is disabled, the LP advertisement
-	 * data is not meaningful, so don't go any further.
-	 */
-	if (!state->link || !state->an_enabled)
-		return;
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_1000BASEX:
-		phylink_decode_c37_word(state, lpa, SPEED_1000);
-		break;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		phylink_decode_c37_word(state, lpa, SPEED_2500);
-		break;
-
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		phylink_decode_sgmii_word(state, lpa);
-		break;
-
-	default:
-		state->link = false;
-		break;
-	}
+	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
 
 /**
- * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
+ * phylink_mii_c22_pcs_encode_advertisement() - configure the clause 37 PCS
  *	advertisement
- * @pcs: a pointer to a &struct mdio_device.
  * @interface: the PHY interface mode being configured
  * @advertising: the ethtool advertisement mask
  *
  * Helper for MAC PCS supporting the 802.3 clause 22 register set for
  * clause 37 negotiation and/or SGMII control.
  *
- * Configure the clause 37 PCS advertisement as specified by @state. This
- * does not trigger a renegotiation; phylink will do that via the
- * mac_an_restart() method of the struct phylink_mac_ops structure.
+ * Encode the clause 37 PCS advertisement as specified by @interface and
+ * @advertising.
  *
- * Returns negative error code on failure to configure the advertisement,
- * zero if no change has been made, or one if the advertisement has changed.
+ * Return: The new value for @adv, or ``-EINVAL`` if it should not be changed.
  */
-int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					  phy_interface_t interface,
-					  const unsigned long *advertising)
+int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
+					     const unsigned long *advertising)
 {
 	u16 adv;
 
@@ -2613,18 +2630,15 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 				      advertising))
 			adv |= ADVERTISE_1000XPSE_ASYM;
-
-		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, adv);
-
+		return adv;
 	case PHY_INTERFACE_MODE_SGMII:
-		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, 0x0001);
-
+		return 0x0001;
 	default:
 		/* Nothing to do for other modes */
-		return 0;
+		return -EINVAL;
 	}
 }
-EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_encode_advertisement);
 
 /**
  * phylink_mii_c22_pcs_config() - configure clause 22 PCS
@@ -2642,16 +2656,18 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising)
 {
-	bool changed;
-	u16 bmcr;
+	bool changed = 0;
+	u16 adv, bmcr;
 	int ret;
 
-	ret = phylink_mii_c22_pcs_set_advertisement(pcs, interface,
-						    advertising);
-	if (ret < 0)
-		return ret;
-
-	changed = ret > 0;
+	adv = phylink_mii_c22_pcs_encode_advertisement(interface, advertising);
+	if (adv != -EINVAL) {
+		ret = mdiobus_modify_changed(pcs->bus, pcs->addr,
+					     MII_ADVERTISE, 0xffff, adv);
+		if (ret < 0)
+			return ret;
+		changed = ret;
+	}
 
 	/* Ensure ISOLATE bit is disabled */
 	if (mode == MLO_AN_INBAND &&
@@ -2664,7 +2680,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	if (ret < 0)
 		return ret;
 
-	return changed ? 1 : 0;
+	return changed;
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index f7b5ed06a815..77df5d6f80d1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -487,11 +487,12 @@ void phylink_set_port_modes(unsigned long *bits);
 void phylink_set_10g_modes(unsigned long *mask);
 void phylink_helper_basex_speed(struct phylink_link_state *state);
 
+void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
+				      u16 bmsr, u16 lpa);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
-int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					  phy_interface_t interface,
-					  const unsigned long *advertising);
+int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
+					     const unsigned long *advertising);
 int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 			       phy_interface_t interface,
 			       const unsigned long *advertising);
-- 
2.25.1

