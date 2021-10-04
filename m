Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A74421729
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238939AbhJDTSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:08 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238821AbhJDTRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lo/AYTi4MfeO0lwKNzh2/jppUhxMK2PibWQpYXcMZetB0IvsRvywpiaAkiXRGUbJvaKK2Kc6AL3hnw672Jw2NhwwO0CbYEdyUa0fAFw6ML+WYMsCJNJiEUDjxe+ALanrXOOENYs/6hoqVepqS4VDnwQuoqrXolUdOWCW+e0XW/CZb0LayfghOHg+7acC7V3cZJq0afCrET4iq4SsuFwQWd0yIzeUCSqaW0EECWvnmVglijFfwZWgXmuD5wG8obretafm3sD8q8am9o/DrDT5cLTPs5TIklDZK+rXXYXbwh299A0EmGAUdEbrc6/tpjTf7v2VIXZUQE9yZju4/LStuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzFxzqMFq+sNXDIXeWvtYTkChDz6300NfcmKe2BB//4=;
 b=ifygFTCY52Rv82PZnr+m5C74AeHWKGBV/wt2hr38wQ3DTKPdzvp5HlkztAVyat+cCYL6KI7do55vRBpqJAfXVV4eCmWnjOL1TlJCCh96uOcnuyGYmL1Iqt5yZ86H1sfqd8Yt7Bsa9Mlc29Vw9zQB79L1jbvGdIowsjSlei007LFyUpp0N8b/AUvYeWzTaBb/Mix5AIbvN+vJDOFR6t6bHjsCOwhrAnySHv6NV5P2G6q9KR/Onz7abmI00TexcZY5tvO+Z1mWIiBdQ4hfN6/hcTn5998Kf3PgsMy7gMxjaCZacyAdhzWNIhvUlXiotIFaN7b2XO7EDgXcwd0m1ju/3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzFxzqMFq+sNXDIXeWvtYTkChDz6300NfcmKe2BB//4=;
 b=AnKkcZLHbjbSnMJFa1dmVdFTP9J+dhxBARSGRJmd36y4MCWKxPg35brWtszZwHGjm44+DZ7PAhbn7pXsg32btvxgF0OvgfXA71xOGoWSDhicPwkWqPbK7CSvgjL4MJ6/75G/5u0TrqNGrI//wgSBNZn7qLhLacfqvEN3ltt4+0k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:57 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:57 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 07/16] net: phylink: Add helpers for c22 registers without MDIO
Date:   Mon,  4 Oct 2021 15:15:18 -0400
Message-Id: <20211004191527.1610759-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85f90e25-7fd0-4c45-7b7d-08d9876b650e
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB7434919C303641254F44A8FD96AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6AEhaTzGJCJxM2YYSErNUTL3B764XrVGgkT0Km2Vynq6kBElp4v9ztqNCPr/GYB2c4Bw7cza49aIQhUOEp5fcICojiJWXgwSPDLBJdamD2F/dv/Y71waMwoXbfjYXpgOHdBSUynIj/V6JwczdGpWmcIlnScqMBIA97TQaxcYrVi5r09V0NsW8dUePy/biVVHX9w3boIm0v9MoS9Ha/B5On3xzqVvgeSEjzjISn0k8d4vcobeQJxPOy6MCTU9sVJ0F+y0+TVmBETlOKWwaM2hNI62fk7SBVW/5rZ+KC5rwK5j0r8hITWN3/baGC88FW5erhhFnPFGmCa3vyTQGYBN4OAGsPTmumieG2lr3PeW9c1CN5xkBlwLs1Uc/tcOZv4R7M+OUdzp13SL7DqFrP7eI+PhfpU5lmhClWg4mv2wo8/S+xNXJgsrImTCOHEL1vlnb4UqQZuGoIDxeeEzg7ZAGPh8UwFd81VHWCnJJbV6YLquoGOwGZXge7aXr//xqaKBO82A1OYnZCPVQSwpLGJTnufFEdl7K5gNFSLrfIwhR15CE4DmsOjnMVxS5UsnieK+M8ta3QhPU5PVCJt7zxQt//t+/q4jADYKzRWncmecu8KZNQn18CbucSR+AV0AsGzj8PUVt6lDXe8D9yGzxZpBUqdxBeFOgQjJRl0WiKIoAF9QQoDl+cSDtFGuFjRm2EVH29tXZN1VFq+OuSoYQOijBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(107886003)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cyT1jPdFgze51qsZG/bnWJwFT3fWxEf9zz+CdtQ6J35xAW/XHTr6cuevLJj1?=
 =?us-ascii?Q?qVATxSKtyvCqazDnrpNtk3xB0J+i/eHn77BGrasSgwiqbAN7IHz4yHGf0RAF?=
 =?us-ascii?Q?3whC/cD+zsWXut0dlpVfaBSpVwAAb25qXLUUXquw0Xq4pTx3vGOCyRpsHkkj?=
 =?us-ascii?Q?K/R2d25cqbwHzNOO2iV82MQMaIkhpnEnkgeAOp16lIzD0e/1046PC5rH4O7b?=
 =?us-ascii?Q?m1x665IvH0LJgG51lNIVjpy17aLAN6aff8n9c+gbt3DbXHCZ8LHO/D1l5lqx?=
 =?us-ascii?Q?OEBPUweClRl23wbqap2qK+eBNSl6APlKqeddTtyG0KvX9hpk3MLxJfq8CsNA?=
 =?us-ascii?Q?IUUv1q7QjLI6vHt5xvL6sb/yIDfkJ1pbbbRuZaa29uxKHqhZqwMJMS7PBAx1?=
 =?us-ascii?Q?Lgsa1kxYnOrDlTbv/OLiCwT2xW8Xn/jHxVWG+8aem9nsrbFhMCP6ddURrUx9?=
 =?us-ascii?Q?zQQmOX2fAh24LdBv9bQKunN+nSqJMcq/fSLME6NuMnuq3lmgD0TmTJUGlQTz?=
 =?us-ascii?Q?sSYf+x43WXJK1hwqggeTV9cy8l3ik4OZmO7VHdt5a+9XbC+BVD5EK9qFqp+V?=
 =?us-ascii?Q?G+nZSDP+Rr1j2czUWIfqVLs/qovvHftEc8MMklTdGvRagzhIsdA5ricWy6en?=
 =?us-ascii?Q?fGBVLgacfHqv3r9J3MHuvhOMbVQGqo9pAjEHtlb4kafwxc4m/8ZcdBtHkN5n?=
 =?us-ascii?Q?sz7sjfSYzzVK97pblUwpeYL2/7XLxPftpW+SAbQMX6oMD2H9IQeiig2W2RG0?=
 =?us-ascii?Q?xKqI69AKfNDuskUeZhMsRShQgLd0QdpN1fozj1cLbagvS0naWyt1Plyz8A7w?=
 =?us-ascii?Q?OCMpAFk2ovZSwKIOA57k0RNLti7hEeKHhAZV52Ybr817n8OwmuzMd8x3dWLM?=
 =?us-ascii?Q?l/MpHZCDq6OGP8oVWCGh/TrY07YlNMl9aiYopE93bSmU+NXwnpJks8GjLXUa?=
 =?us-ascii?Q?XwVESZSLlUawhwVgUFdmkGDI8Wz7QwnCK6AulA3GFLv1RpEFmTjRSa60vh8J?=
 =?us-ascii?Q?MSrMWC9CPG/qw56I4poAZGZYTJd+iCb/ds+4tqiLEHYXXB6Y273rT6UIiu9x?=
 =?us-ascii?Q?P3GWz5I317I1MlES6CLtnjp+nKcVjbB0imCaBNjD0lbcwX0r7cJz/wBBJoS0?=
 =?us-ascii?Q?eD9VJ3wMYFCH+bRDnNjNCMqZwCd+LcMamK9qs4C+TCF0tBh4nuGxUEqRdKqn?=
 =?us-ascii?Q?kQTeWLRfS6hOgCfE46zml0MP4YoP5AmSdXLfvKy8F8qRaqECqB4oQGiNir3p?=
 =?us-ascii?Q?4mxuovWfix9wPUW11HESuPdfCcBevqwpnflZAEe6V5Cky267OK31YkJjLHQS?=
 =?us-ascii?Q?1CQubtF6eNxGmhqUnAZ64SFC?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f90e25-7fd0-4c45-7b7d-08d9876b650e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:57.7227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NqhXiyEnI9oGMzIa07nStLIAWykVbOjTL2MbgqbEMTMMJkZM0T/vrjLSuPy7SwMHXe1p2XodbZ9paTrna4nvOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices expose memory-mapped c22-compliant PHYs. Because these
devices do not have an MDIO bus, we cannot use the existing helpers.
Refactor the existing helpers to allow supplying the values for c22
registers directly, instead of using MDIO to access them. Only get_state
and set_adversisement are converted, since they contain the most complex
logic.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/phylink.c | 154 ++++++++++++++++++++++----------------
 include/linux/phylink.h   |   5 ++
 2 files changed, 96 insertions(+), 63 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f82dc0f87f40..1b6077557e31 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2639,6 +2639,49 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
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
+	if (!state->link)
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
@@ -2667,32 +2710,48 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 		return;
 	}
 
-	state->link = !!(bmsr & BMSR_LSTATUS);
-	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
-	if (!state->link)
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
 
+/**
+ * phylink_mii_c22_pcs_encode_advertisement() - configure the clause 37 PCS
+ *	advertisement
+ * @interface: the PHY interface mode being configured
+ * @advertising: the ethtool advertisement mask
+ * @adv: the value of the %MII_ADVERTISE register
+ *
+ * Helper for MAC PCS supporting the 802.3 clause 22 register set for
+ * clause 37 negotiation and/or SGMII control.
+ *
+ * Encode the clause 37 PCS advertisement as specified by @interface and
+ * @advertising. Callers should write @adv if it has been modified.
+ *
+ * Return: The new value for @adv.
+ */
+u16 phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
+					     const unsigned long *advertising,
+					     u16 adv)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		adv = ADVERTISE_1000XFULL;
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				      advertising))
+			adv |= ADVERTISE_1000XPAUSE;
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				      advertising))
+			adv |= ADVERTISE_1000XPSE_ASYM;
+		return adv;
+	case PHY_INTERFACE_MODE_SGMII:
+		return 0x0001;
+	default:
+		/* Nothing to do for other modes */
+		return adv;
+	}
+}
+
 /**
  * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
  *	advertisement
@@ -2719,48 +2778,17 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 	int val, ret;
 	u16 adv;
 
-	switch (interface) {
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_2500BASEX:
-		adv = ADVERTISE_1000XFULL;
-		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				      advertising))
-			adv |= ADVERTISE_1000XPAUSE;
-		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				      advertising))
-			adv |= ADVERTISE_1000XPSE_ASYM;
+	val = mdiobus_read(bus, addr, MII_ADVERTISE);
+	if (val < 0)
+		return val;
 
-		val = mdiobus_read(bus, addr, MII_ADVERTISE);
-		if (val < 0)
-			return val;
-
-		if (val == adv)
-			return 0;
-
-		ret = mdiobus_write(bus, addr, MII_ADVERTISE, adv);
-		if (ret < 0)
-			return ret;
-
-		return 1;
-
-	case PHY_INTERFACE_MODE_SGMII:
-		val = mdiobus_read(bus, addr, MII_ADVERTISE);
-		if (val < 0)
-			return val;
-
-		if (val == 0x0001)
-			return 0;
-
-		ret = mdiobus_write(bus, addr, MII_ADVERTISE, 0x0001);
-		if (ret < 0)
-			return ret;
-
-		return 1;
-
-	default:
-		/* Nothing to do for other modes */
+	adv = phylink_mii_c22_pcs_encode_advertisement(interface, advertising,
+						       adv);
+	if (adv == val)
 		return 0;
-	}
+
+	ret = mdiobus_write(bus, addr, MII_ADVERTISE, adv);
+	return ret < 0 ? ret : 1;
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index bd0ce707d098..b28ed8b569ee 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -496,8 +496,13 @@ int phylink_speed_up(struct phylink *pl);
 void phylink_set_port_modes(unsigned long *bits);
 void phylink_helper_basex_speed(struct phylink_link_state *state);
 
+void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
+				      u16 bmsr, u16 lpa);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
+u16 phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
+					     const unsigned long *advertising,
+					     u16 adv);
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 					  phy_interface_t interface,
 					  const unsigned long *advertising);
-- 
2.25.1

