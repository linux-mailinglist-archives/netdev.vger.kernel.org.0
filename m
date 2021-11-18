Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C43456042
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhKRQRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:17:51 -0500
Received: from mail-vi1eur05on2075.outbound.protection.outlook.com ([40.107.21.75]:20192
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232984AbhKRQRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:17:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPGUWaJ3FPvFPSGTYwXcCpifp+PidZ2tMh87nBwpfHoxN/YEGLnP/8nBB8rpe/qmk786SYjtRhW55cCeS2h/QnOzpBy7MUbNuBweJglcfclm0vS/1P5gTURo9MrWB6Jsi/UjiayEKBI5EIG5CeMpApce1S+tK4/Wz8ba7KATYbU4ED+NECCjwwutoyFqOHqI/Pub441Eqk/n0YPhoLrS0oCK/fOLr270WikP7IIzhHd3woZSPCvm4Rw19dUNc2eIlOHG1HbBKfHpm0u4OwWUOf026pITty2OeUTnejY/VcZAQnsIJT6z4dg1Yz+SrtTahvGZxJ16FLkyl/+uB6bLDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9P2MW9B0HbMGkOayZcyzEFkCxDs+6up/RovQOgz/3uM=;
 b=j39kdwx+RammrEuTGr44h8E9tTs9nyeuupm8xLtt2pGlQ47NsFjl5Gp9FHH77ll7BHggc0aKT8IiPO7oHM74+PYzAeLbbxgrtXmgg4M2+A7vqqh+9SFHedGV0fNiDoQeboJFmp4shzmk8NgwNHLAf88YPCGrloA6fzEBo0TbIn8li/f0IXFS6bulzFbGA3NmzNkW0qEIPYGkrZQvVumReOpQ21jE9oYPjjrnXzxXRc95bOT1Dg+oeP7PYYCHoFV4jlom4+liBA3/0IZ/GihON1kj+UALHeonEUgwqIadwrUnwCFhBX2tVo6ncZBlmRTG1xywCqs7lSaf9Q5IWU/ycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9P2MW9B0HbMGkOayZcyzEFkCxDs+6up/RovQOgz/3uM=;
 b=jR8cO2y3Mu7W9OjIz2U0GRGiIfhEGHS7GcXgAHBA+TVd0kHU/HPdmbHVWBuYAIPvCCr/KY5s9Al3msyzbjzB70ThlmK5hFQlx4BwqlJUaeJF7hE8vZdRDkIhEVMc2XupwcyT/zHbZHuwhqOgP8aP7cCTdZJKIYzPnNSPOq6afLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5367.eurprd03.prod.outlook.com (2603:10a6:10:dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 16:14:46 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 16:14:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [RESEND PATCH net-next v2] net: phylink: Add helpers for c22 registers without MDIO
Date:   Thu, 18 Nov 2021 11:14:30 -0500
Message-Id: <20211118161430.2547168-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0011.namprd18.prod.outlook.com
 (2603:10b6:208:23c::16) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR18CA0011.namprd18.prod.outlook.com (2603:10b6:208:23c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Thu, 18 Nov 2021 16:14:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6f304d4-a2c1-42c4-2f4f-08d9aaae8a07
X-MS-TrafficTypeDiagnostic: DBBPR03MB5367:
X-Microsoft-Antispam-PRVS: <DBBPR03MB53673E01A491EA97EB977B2D969B9@DBBPR03MB5367.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgjXm/1GwqBICwLIS+oNjfAOtzjNINVljs+JWeKeUGnuAt7nwHpeSXXRkW8onAHDjKCtUaRGMHJT1Vvg2JTN6iN8wMUIn3cpe7OYM0By3ZtfVm2804+tqmo+SjHJZpMhTzYqOMl/5eJkpcKLGcA89oPHpKtOJhKvfQwoF956XARlFowMGwDsX7VXmXTLguK+2aNY1GRbgac8HlFaVQC0eEQDuJ2UfvsBGpThYdxy8ZGj+ncsCoEVrKj92RuwRo46Tcf5mRZq7IKTpKs0UPR+3uxgreLgElTnKrrkhgjm4vin0ZhPrAeNahYJXPGfH2jbwvOdQw48BhKD8eh8ubL8qm4z8j10c/8HzUl9tkXqLiCUYs+/zV+EAs0WI+vE9wp3ttW5E7lFyP/+UFS+Izjdc3EyHkUnNxgeOfyFGSyW0ghKyODegrEJqHg4eGzUIEtAOf+wOSnb2gmwL3kM+KOkXyuTEpuImh3jcpSn6L53BEfgAfFravKC4UsOjmVFKE1sQLyziwpQJ+Bl287KOvfrrTZQ0H5WsI1GyA38/hmfbT4Yj+2pPnOAXigwFmc/lgnJDKRTZ2+j0k+vWuS9d1ql4uagcep3f9kdmQPoknECm9l/Q4fYLaPBKdpMoG14uRKT/d4he9NAWEXqqwHQNWSyuht2l07UN264gy7ZEL0yCZtXLVPR2Ni5BE/xTFOUXbW/2YEr6h1r5uQRJso+aNGkThEctWIOwoLPET3ncZaaWlmqQriOSAlWTDKVuZB5r79MYsknhsHNGnsc6aWHznOgtwx5NPms4NnjQJiTNidRyZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(6506007)(2616005)(186003)(66556008)(52116002)(6512007)(66476007)(4326008)(6916009)(966005)(86362001)(44832011)(66946007)(26005)(38350700002)(36756003)(38100700002)(6486002)(1076003)(316002)(5660300002)(6666004)(2906002)(8676002)(83380400001)(508600001)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G/XywhvoBhTfgmSmtlgHcOJwEG77nEoLOnOhV6WYk6EFvgM/g1aMz0tJ1R05?=
 =?us-ascii?Q?IZAseFzaREUNdDODKlapK97XJqrYZgblgyzjKdNN0+aIh2lZFH+fNbqe7smW?=
 =?us-ascii?Q?jiY59YF/dy6r1N7kys57XgmA9xslp9T8dQ5gp0VLpGqZCtUPabdFbEXbFXC7?=
 =?us-ascii?Q?CzXznSXXRlCZBL0UijkmYSc87mXWo7dd0Rk5bZfnoSGlVOdDQpTKK75/q+an?=
 =?us-ascii?Q?Tul5dbIzl9YxtnX2qS2LU+5Ulp0oTIq1bDBpQdWoDGRRhNfivt1wCY4jlV01?=
 =?us-ascii?Q?ZrdRiJAc8EjKDtuvWqIXrH3kXRcgytsIDQw2rRFoMh78GiB4HckbBomoj/FQ?=
 =?us-ascii?Q?u7X+hc9/dQZxMQkZPDehNH7w22sRMSlvEBA0pPjGUU6w1fW/LH2dZ/lruZzu?=
 =?us-ascii?Q?gJEaWnZHtW0jeWsuGdZq1KryTesL4+9OKpJHELxaDhM+8OKpcN/jKkoAWhXy?=
 =?us-ascii?Q?pcXWuZjMkBOh4ctPAna3S81Ao1yp6ZOB5xzz7oCFzh0IK2ukdjdwqOv0YMag?=
 =?us-ascii?Q?I9/0CDLbPfs3ea1V86Z1GU3+I0L6C6pK4xcuPpC7ycAhmk0uHRnRj1qM8lBm?=
 =?us-ascii?Q?nNm21GP6ShuHAzmKxhP/xBf96QbnRb+JqvtJkyGx1tbwwEblKDGdhLc9mIZW?=
 =?us-ascii?Q?/ejpJAVLDjJ8uk995j0vz1eWziqiwKW4vWR37RwNy9gfrmhehgh+d93/oT4K?=
 =?us-ascii?Q?APEqGjSPt6NEkMRkph3HmdEOipQd3OFE8oGGzt16uhv+t/tWfL5QA8oBWlWu?=
 =?us-ascii?Q?90rHlSO2x03Crh153FT9lBWnbDcTnULDbfGnTP0plj8Du0Y1hIj81ypHBgwQ?=
 =?us-ascii?Q?q909ioTlMYIvM+K+RWT/ahlfhi5sEmGT5yreDkXnS6Jbf9W+xES4mv2rAHEW?=
 =?us-ascii?Q?hMSFr817ef0s61zBj3NDWJRzmrx2A+SrnJPdvmSZ7iKmcSabxoDHIZmnT4QZ?=
 =?us-ascii?Q?9kljNqM4ZZixbaEasBwUULmM3CIv89/AHXoYOYy9Hy9T927UxpZ4dnsrLaPG?=
 =?us-ascii?Q?TnUdj1XKWWzqkDOLX+tdJrBRqEila+/sJcvEFqF+YA1GdGXuQDkhiC8ItUBn?=
 =?us-ascii?Q?VHQbVYTweL5poe3yYHcfBVUkP+8r6yvFnS1JcJmLchuNe9LJjoIXZOnFOs2g?=
 =?us-ascii?Q?pER8boCmok+JsuUx7ov2EUpv2r56jQHcB3mG5wQsU6C2bT8GX/Bw8opXHN4w?=
 =?us-ascii?Q?kumYMCVm7aUT3jgfziwiXCOQCO7tELY43BVqHK8h5PYTdRpd9dWOPAHdsSWf?=
 =?us-ascii?Q?I9U72SJ5Ltd72h3gqHhP+6D3szmCrBYrQxvqx33gROrSSqNwATWkfivuWZh2?=
 =?us-ascii?Q?077p7O+iBkiJ0DCW2uj854/3V489kggf6Xv2rS0DjmOdtj6aAMzrEuoMoJSI?=
 =?us-ascii?Q?IeN7xX05/2kr0UWblllCPHwVEFoPMRg/HnB8hrIuI/vGyvFr4Ldu50Fu4/Ee?=
 =?us-ascii?Q?3HW18oW6GzfJraXbTTc6IJ0L3vzmvzhnidV/QSAxZQipGM81eOgbneZTIFEW?=
 =?us-ascii?Q?oS0mYh8dxRkUrJKYnl8U0XK2T1kB/qMm4Zgl1ye7Vg86rz5HY0LXzhbBDYNL?=
 =?us-ascii?Q?UFDsPwDTZLfELv50Yf8eekx0RdgKduuD+yznq1djyzTwlAqPX5CngQSIqjdl?=
 =?us-ascii?Q?X2FUvylKMuVA0QrkDz4b3sQ=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f304d4-a2c1-42c4-2f4f-08d9aaae8a07
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 16:14:46.8392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0e0RqUeeeSsbWyN02T5H/6/9M8Tu1FJ0RkyJev1slgH4k6fZ6t+Mj8kgeTH6uWCVIhyQn4tcfIFlp7VIAzming==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5367
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
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This series was originally submitted as [1]. Although does not include
its intended user (macb), I have submitted it separately at the behest
of Russel.

[1] https://lore.kernel.org/netdev/YVtypfZJfivfDnu7@lunn.ch/T/#m50877e4daf344ac0b5efced38c79246ad2b9cb6e

Changes in v2:
- Add phylink_pcs_enable_an
- Also remove set_advertisement
- Use mdiobus_modify_changed

 drivers/net/phy/phylink.c | 120 +++++++++++++++++++++-----------------
 include/linux/phylink.h   |   7 ++-
 2 files changed, 72 insertions(+), 55 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 33462fdc7add..36d7784e7a17 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2813,6 +2813,52 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
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
@@ -2839,55 +2885,26 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
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
 
@@ -2901,18 +2918,15 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
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
@@ -2930,16 +2944,18 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
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
@@ -2952,7 +2968,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	if (ret < 0)
 		return ret;
 
-	return changed ? 1 : 0;
+	return changed;
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 3563820a1765..01224235df0f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -527,11 +527,12 @@ void phylink_set_port_modes(unsigned long *bits);
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

