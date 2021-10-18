Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04243295D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhJRV5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:57:20 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:24544
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233407AbhJRV5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:57:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lD3cToVfzFIdtbySU2PRHVlXMa/jpzrMNbcPVjRC3jr4jMr+Km9HQ0bBwzHo7T8RszCI2YDMvDble7zSxNb2uEEeFBwvsjA4Se2d8TFxsigYfD8KQSKCsdEXIPpHyTp/a6RAupMPGLWvWFxkZOYuiR8fTGtPnE9GMYMfBN74eCl86hjFk+JZz2qDRQBizZ3Bm8j/WWXYXv8RRLLJWvwz+zj/UL63e4qmznqUk9xv8ST2THHcyRzE1VaL0s9yoJVQTuY2xgXicar1kB0HIP+R03rzQGJ9NXmk3f2KmQjX90Pn646XDmEIy8/UTLW2WFV22v4voFm2/9sG8MrPZbAnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bU4K09rciqwffmaoxf4ZNC7E8WLgrHeGnP/qgo8aG9k=;
 b=N64amIQB0RHkWz7A6a8f7Bnr8M5MRn2JA5UoRj74j2qc3XklHbrju6rylpHofviPtzMXj2/Utr2Ww23dVah8dH4j9j2ewGrS15C4lkkI+yBAy88op5o0IaBh2he6OL8cITdw3SBzG6VjqNsSLTACdlv6NnQ8NQFlSZpd8AFLOThF+m6ArFkVnWl+LapU4LaNsNX5W3F0DJ3ot6pM7wdJiNu6QE1c3eIkgMcROyTqh+YaspY9ZRsPMSLTqmQKPsAl+HvBp2dTrQD4eFJy+GcpzDiOaJ8KgJoa1XLAOu6ha7TMOf5uVBRsNYVln3V5e9XuV6MFZnLmIrR9S4Dw7MlOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bU4K09rciqwffmaoxf4ZNC7E8WLgrHeGnP/qgo8aG9k=;
 b=t954SxU2+ikaiiMc9wDU4Y42Vyy4RWSjTJkaSoBY860f592LY8DuUbPSUs53hLa9hdgkBBUd0D5TfDJXfLw9lj7a7FF28oEYkUuxop8ZYisbCmbADj4mx8DSPgdpzaVgwW50nwb/t1alXUlqF4NKJC3TXZJRwwuc+wS78M7JVWI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (20.176.234.91) by
 DBBPR03MB5366.eurprd03.prod.outlook.com (10.255.79.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Mon, 18 Oct 2021 21:55:04 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 21:55:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 2/3] net: phylink: Convert some users of mdiobus_* to mdiodev_*
Date:   Mon, 18 Oct 2021 17:54:47 -0400
Message-Id: <20211018215448.1723702-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018215448.1723702-1-sean.anderson@seco.com>
References: <20211018215448.1723702-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0003.namprd19.prod.outlook.com
 (2603:10b6:208:178::16) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR19CA0003.namprd19.prod.outlook.com (2603:10b6:208:178::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 21:55:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68a5836d-f9e7-4fec-d5d0-08d99281f11b
X-MS-TrafficTypeDiagnostic: DBBPR03MB5366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB5366F3506BAA6B5D9C090FCA96BC9@DBBPR03MB5366.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sXb3aG7q48YR7HpXVhGmA5Xta4md4uUFRcdgIHn8w01KUUdqCLJJlLWoQYsdlxlGGftggZBPT4FoDk99DigoBkp/sBR51c73kOGyGJuPDi9R6hUYf42mh+XMqLGxUGlLsGrYBC9GCJVgH0vXW+IMSpi7PyPMMAeuR6C5vrAY1roCnTtbyZNgnmmPcnSzGkTZZY0nl9rPGbP3LR4j5fyhlplJHGMApeux6zzXBY/XRNIVoVkcAf0CHg0sgf97cgAaPuTuduf00BcfUrjL5S4mSt/STqgHso6YuGAs1S0uOTYIqJwhuylTBMkdwtS8/s1NTfP7Ou1TaBk3FaqIbiEa+hi+vvCf9sqYMx8LBlQj5vlslti0YyvXx+sj4TOsDTR+cwqGbbq4q8OEjMSSjWM1QfIP8J294SmxYFTOhmpmrh3AHRZISomJjG0FwKl/EEeANzLvzz7birHHgTz9ymWDr4V67TwqUrS7q8NRENGGjUioZaQAq6X+NWMcllU53Zl7386JJfj2pN9MrD6I0xsQjf/rdJxYb6Ff2ODVD05O4kFR/dxBMsqEsza3gkBHLzCPry/QzD7MWBLQgS5gOTnO+WX9wE2K/8OKwxb1EzIhwg5HaHETg+sQ3NaAcTp4sG+K8qmP3rrubeps/t/YeiAgkWat/9yT8dXa2D4iPl53BAR1mQwimCmLEQ75i1rDeb2HM/HPsre/Fpg9wnr0dqVorA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(83380400001)(52116002)(6512007)(186003)(1076003)(38350700002)(4326008)(110136005)(6506007)(8936002)(66556008)(66476007)(107886003)(956004)(6486002)(2906002)(8676002)(86362001)(66946007)(44832011)(6666004)(316002)(54906003)(36756003)(26005)(508600001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jKk1EjNpSb/eyulJF8/bR67mwXVDZP7kwgGQ41FSVM7KVHd9TNmt41OU084?=
 =?us-ascii?Q?VqpRmJoEn/TXYG6CSP7vl3AiKAaK4scQrmo9eJPns3/dbss8EhfrAaXnjRMX?=
 =?us-ascii?Q?HLXZxS7l9uOKtDmATPmDA2N0aNhRHgcj04lJo55XPK5w4yKTeQxUeXOfIKvO?=
 =?us-ascii?Q?u3d/MTlKCQYjXOaPVfkO9xI6ercNWqIUDBOocB30A26TJrsoAoqowZ6a8fGI?=
 =?us-ascii?Q?yQvr9l9tjbBQWo9iJtSbVsgEf6ShPTjHVL4vIdH0tMnks+PyyfM9HsTIGcQD?=
 =?us-ascii?Q?ZAtKoSfsUxsYuVlmN/9wlcV1IGDNhs3vGb5PDmHDN41X26uV3HeNpHZGqTTe?=
 =?us-ascii?Q?S5alHQflWSrrSmd/3NnrMbxW0gCbOOgK5M60xHosaxWty9dRRnHtrhGbYYbK?=
 =?us-ascii?Q?D95/BXKXzeM+s89QO0o+MJlz4Rgb0KFBCQ4ryxzdEMnrHshEm+U3ATA0C2o5?=
 =?us-ascii?Q?sYlL5QskyRlhAAmbc0Zitw0JeN5Bevzee17/7Wq1NvCPNoN7rW6IbxGdTfwH?=
 =?us-ascii?Q?5KLOOlH+yB7gBvjBdex1afdcayjRU9r3HXMfR0Iz8O+d5di9sTfx28/whH0f?=
 =?us-ascii?Q?SwFvx/YvKyuVcnyJOyhElIAm/FGngkQdTdD3VdHLgaZvjvOJ/C8hKO7rL/Ly?=
 =?us-ascii?Q?nO6N74ir3CpTJW2BKlS3jhVrGKbjoyKzHQtudBbAvbSmNREVf7hpPDczdj0U?=
 =?us-ascii?Q?D0a1my5jTzsr+WTEyC2gg4vIPKxub6+5HqV+t8yBjw3k/9Hd4CPRgerJPWlO?=
 =?us-ascii?Q?kV0grGallRuq/Gaz9mKJTauwFRhGpKXDhkvN598kE8+ZkqlxBONm7WSOwhIg?=
 =?us-ascii?Q?5nGQdDGdDllmm1elaas/sxEXkPB9P6BI1L5gYOJLbMBhKGmUuNlJ6WvSfWEA?=
 =?us-ascii?Q?abk29Ys67Q5u8gFWGyTLU6txYytF6G3okfkcyrg1QN96LnZ2nkWUqrLECt23?=
 =?us-ascii?Q?3dYHT0MrKALLF14DQoLzP11dQWp8D8BmBf66oWu6TqTsTtYQmx7WgQBFVLy3?=
 =?us-ascii?Q?ygtiF8LOE9xi9d6Bzf6CrINHNnLFQwMOLBpuWbb70biVkWCIHIIWrDFmsZ3h?=
 =?us-ascii?Q?oRZrwqY4qqf4AQF+HzEaLPGf7QP6WuJtBdxzgPPfvEBmGlBupqYIZMo4xj7S?=
 =?us-ascii?Q?jGEslhFPG++3XGKGscxbH5YTwXogrdDaot2GVRkfjCQJ7FrmjDvI4U9eWdYd?=
 =?us-ascii?Q?S4Vs4hUIfzjXYO2TqEp/46JvSz01eODl/UhcHKpIOPbVVNuHjaUQSXTX8WwF?=
 =?us-ascii?Q?l4uFKu4Ag/4Ke0CFvEWskuqJyuR8HBIsXEW3Gq+F3T25ncj07wCkphY3Vplp?=
 =?us-ascii?Q?gH967vqNC09uwjkzB4pNNC7l?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a5836d-f9e7-4fec-d5d0-08d99281f11b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 21:55:04.4354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNO4SUbC3Uib7uHbOjQO72sShPQG9+aWQ4CyaUkMfbur/+uXb2nvxCCWuUIGo+rzHaF0wM2sABQX5RvLJsotgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This refactors the phylink pcs helper functions to use mdiobus_* instead
of mdiodev_*.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/phylink.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 16240f2dd161..58219457db16 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2536,12 +2536,10 @@ EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	int bmsr, lpa;
 
-	bmsr = mdiobus_read(bus, addr, MII_BMSR);
-	lpa = mdiobus_read(bus, addr, MII_LPA);
+	bmsr = mdiodev_read(pcs, MII_BMSR);
+	lpa = mdiodev_read(pcs, MII_LPA);
 	if (bmsr < 0 || lpa < 0) {
 		state->link = false;
 		return;
@@ -2594,8 +2592,6 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 					  phy_interface_t interface,
 					  const unsigned long *advertising)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	u16 adv;
 
 	switch (interface) {
@@ -2609,12 +2605,10 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 				      advertising))
 			adv |= ADVERTISE_1000XPSE_ASYM;
 
-		return mdiobus_modify_changed(bus, addr, MII_ADVERTISE,
-					      0xffff, adv);
+		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, adv);
 
 	case PHY_INTERFACE_MODE_SGMII:
-		return mdiobus_modify_changed(bus, addr, MII_ADVERTISE,
-					      0xffff, 0x0001);
+		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, 0x0001);
 
 	default:
 		/* Nothing to do for other modes */
@@ -2652,8 +2646,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 
 	/* Ensure ISOLATE bit is disabled */
 	bmcr = mode == MLO_AN_INBAND ? BMCR_ANENABLE : 0;
-	ret = mdiobus_modify(pcs->bus, pcs->addr, MII_BMCR,
-			     BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
+	ret = mdiodev_modify(pcs, MII_BMCR, BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
 	if (ret < 0)
 		return ret;
 
@@ -2674,14 +2667,12 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
  */
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs)
 {
-	struct mii_bus *bus = pcs->bus;
-	int val, addr = pcs->addr;
+	int val = mdiodev_read(pcs, MII_BMCR);
 
-	val = mdiobus_read(bus, addr, MII_BMCR);
 	if (val >= 0) {
 		val |= BMCR_ANRESTART;
 
-		mdiobus_write(bus, addr, MII_BMCR, val);
+		mdiodev_write(pcs, MII_BMCR, val);
 	}
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_an_restart);
-- 
2.25.1

