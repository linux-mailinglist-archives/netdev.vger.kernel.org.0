Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177C0437A7E
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhJVQB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:01:57 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:18401
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230187AbhJVQBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:01:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCyFDo/moCfRYltnWai7Ey/voVeGD1VGAqVjrMxgOU+zUCLXVBFvAjvjmI36Zjlz1qQPFwF/wI5QhKgEsA5RxspktJixOGwneL2ygshdYHm5+JkFGhCDKQswKzEG/NhlYKY3O24Kqxop0mF+NUtSzfXQiuSoQpy/HKMafaZNOWCQxzQPlHRMGXaINAsHD/frukVbsZexoFnOBUfI+hlOQ1P4w7EDNVQz54Y2BZp/nRgLx0uqw6FiwLwIxINLTjM7MeBV36o3zmgaB0BZ1FJoZpuxVd8tbWHxN+/S4+5Gj1eAZYemqdEIPceYj4xmb/t9OOS6clSU8406zd736mKeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnDNcXDMTtLTNzsBJmcTZwUL6OmqiGDibpedwtA0ETo=;
 b=EQ0U/6G2zuyolZCNDmQTKxCjj64/j4y16htZDRMPqWh2wqWu9N9r97mpqnoOC+Mo65Oj1h1M3dsvZn+hhZ3AGgCK63nHh/jywPv8rV0IavcO4Y3UXOWyrVDo2clwli5nbNmezqftRMm8xAwCB11NnJ/v2ZmmxnQ/PkojPPFgkzZ7CAi0j6qKSIferN651eJgrKL2O02ihUDQvhZkHayah0/qPfWvRd1KD5VtDsxyU3+QSjx/1WHwHrdUod8J8Nv9oJeEudAULKKW8cjHNn0CTfhY9OsgTDCrnVF+8fpObhKX52In3rFQn/NxjXYYdaJtjDxiNm3DNCyiqQgh3nyG/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnDNcXDMTtLTNzsBJmcTZwUL6OmqiGDibpedwtA0ETo=;
 b=S+BEwF7MaQsFnoqkCHpJnDSDQURwY56E1oeVBL37doRmstDUZc6FPCjjdCQ6OEgjU6WsFmubwiA+H0cKMx3rnplb0pDBDqLw7nHrOwuHstbMGUsFW5aRu4rMF4TwIeQdPR0/QvwSQVLpknSDw6ti0KHvUTVaNojU2S3HMsjN7P8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4522.eurprd03.prod.outlook.com (2603:10a6:10:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 22 Oct
 2021 15:59:35 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 15:59:35 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v2 2/3] net: phylink: Convert some users of mdiobus_* to mdiodev_*
Date:   Fri, 22 Oct 2021 11:59:13 -0400
Message-Id: <20211022155914.3347672-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022155914.3347672-1-sean.anderson@seco.com>
References: <20211022155914.3347672-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 15:59:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3deef0dc-d822-4d2c-fbe5-08d99574f1bb
X-MS-TrafficTypeDiagnostic: DB7PR03MB4522:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB452258AD39FA7C04F2C39AEF96809@DB7PR03MB4522.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jy7OKSvW8w6iCwF8VofEfuT0Ybql8g49/FG8WwWXMPkNKL9EaSJQJmJcbVIq456dhRI0nxrijlL1HK4L3DNyUzIAc3iE9WzeauCBKF9EdY7ZEjc3hMmEJ7pCDi1IyHTGdTLwuTOXPtGcqiiUXq35ZjsdexShMicymJP6KCNOE9FNvQP7jSZA82mgS2pyQsB6N9+owtToETVRA8rrqN5yq1G5a/gCZNEHAyPXWqGjCpUj+3rXW9/yztowozVTcqaTFO0vMUcHv0VH2nN5hbJ6JT5xAIVx2BA1hhymkiiiX6n0QELsqoZmVpngeokChITDjETw4WJMPlcRI3w0csDwUejYT7itMJY+9O5s2WCk+wyIwH5gZlIJnweSyzUnAAsl5+EgmRcyWtvUZn+gfsrOsouXGLPUiKRA+z9eu+nPLa+n++QlpVBx2hgQzcU3Gf8bq0I4bCHInp7x+iFDwHOj3JGOfEQqqZM7YK6kb8Pr6Mk0wc7mKbpkHWGJBvQjmUtAOk6yIs3MzPSRDqwnBfwNrTHSFwh9Kjo2/roInBO8Sdx+m0nkh8zKjS2RxGawmGOd4y5Hc1TyqT108IcI+FfOXHWmyfy+dK0TLdsWwJlqcazAoR+tEFYTu0nD53COR/gBWccsaIy0FR3Z0phk4D8xfhsVkFaE1ENGOBh1iVoQT73NJOso72sSMmscI5y0zA5PlnYkGuy/oQ70HJ1Lvca6Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(8936002)(110136005)(2906002)(26005)(83380400001)(66946007)(6486002)(6506007)(54906003)(5660300002)(52116002)(86362001)(186003)(508600001)(4326008)(66476007)(36756003)(8676002)(66556008)(6666004)(44832011)(2616005)(956004)(38100700002)(38350700002)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Euno1TD7p9MV9AoXD7EQplunSxWuCCGGgKaVkwwFqsGWIN8wFFVtZyeUCG/E?=
 =?us-ascii?Q?lxnwgvkMB0lwVWtwYDxyEvKy8rj6FImzC+t2O+jWHaQ5SYU34KqrztrrRFu1?=
 =?us-ascii?Q?XEDDtiue/uRwTsoNX4LwHFXkXwn3XXaYGlA4OvaUGNan1uAE5IJFdJYpkjXo?=
 =?us-ascii?Q?eOsmbPsduk/TJ+3kHQ+EPkuOYb0cjsNxkSMqa0N9Z0f5XqYrNkZFUBHwU0Iv?=
 =?us-ascii?Q?VUD8SmsK8x34jeVTeJ2g7Ny4RbpUwmxTG6wRUHrzrrlLOqFgJHgfsLPKBOpA?=
 =?us-ascii?Q?KnjAZnfEh+0PxoxsRcWHVYjR7kus5KAI0086hsVALwQxyWcvHxEzZJlQQsIA?=
 =?us-ascii?Q?8hI9FHO54SRA+ggcu4xixiou74qxU5vxPX1hAW7SLxgtVZOCEZKq7r8cY5C/?=
 =?us-ascii?Q?FtGcDR9KGQ3pUjBLQB0h8JOY7h5PWtHfnxrQL5C+l9V1uM7Os3VXzs0YLSG3?=
 =?us-ascii?Q?I31lVXVGzO5MwNrm0DyfqiRhcUrQI/+X961LaSxWhP1e99eqZFED500g/BEy?=
 =?us-ascii?Q?5Ro8DoHKAeqMKSvG2K/YEFDXleSYvLQg1mI+/wvaA0Hu+X14iK4izD2etlvX?=
 =?us-ascii?Q?Y00tsHL3l8XU53k7eqF6yTLD/cby1jbfh8kFzta5UWpG9s/k4bIXc+eMlqYx?=
 =?us-ascii?Q?LJxDtAYLMmURQS8p4706JNDO5vtCEbHFJDL3b0+OWzF7KHE4F0s0BSwyXwdU?=
 =?us-ascii?Q?N46fpgbSUL6ylc34hEQiDDr7MqdmqFdgEBLFjwT8lsTowbUvrK3HbnKFFIq8?=
 =?us-ascii?Q?0fcjQlb1H4mpv2fQxPlvvE9+uiQE5eYRwYWfp77uqak464NuKptwhoEr44nN?=
 =?us-ascii?Q?xt6xULuwoWlKb/JIBalmNEP6eOqnECuhGORtkB1K7MMuz/LS826F480Tb0Zh?=
 =?us-ascii?Q?ZqcznjVweUW9hKgaAC3XqEPkeQkEvPUNVQWTkbUxiEbgDET6vlKcwR/N53HF?=
 =?us-ascii?Q?//GF/fuHBg37FezlB8Hcomf2EXIPHKdGUbS6Ufr1808BpUJNuse48WUCTiqk?=
 =?us-ascii?Q?PKDTzax1Ko9d3JEbpr7oVLRvdnaPXteZMKILWihhDLZ84PnvNojcTYJD46mW?=
 =?us-ascii?Q?NiHPsLdfhjzUdHNDNqjytrdI279GsVjMe9RCHu8A/ChYJ5G82sK4RMw28PuS?=
 =?us-ascii?Q?DYqct4kp4pNWZz6/fd3Vh3mEKyq+HfBuTicTpQA7IMbWbCr8TvQj/qvCOZUT?=
 =?us-ascii?Q?24aC0uHau1W76LPmB6jggWEa9pgw4lRopZ+slilCqOKZt1Bb/1fg3PymfGYd?=
 =?us-ascii?Q?YltxeBj+5fltC2h+3MltDysQjHfsGO91CiVOoPSEsm1BOg+4pLWTPDZiLwhX?=
 =?us-ascii?Q?7XdBu3gDr3YHGh+hcEVhV0f1?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3deef0dc-d822-4d2c-fbe5-08d99574f1bb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 15:59:35.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This refactors the phylink pcs helper functions to use mdiobus_* instead
of mdiodev_*.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Rebased onto net-next/master

 drivers/net/phy/phylink.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7e93d81fa5ad..14c7d73790b4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2542,12 +2542,10 @@ EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
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
@@ -2603,8 +2601,6 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 					  phy_interface_t interface,
 					  const unsigned long *advertising)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	u16 adv;
 
 	switch (interface) {
@@ -2618,12 +2614,10 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
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
@@ -2666,8 +2660,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	else
 		bmcr = 0;
 
-	ret = mdiobus_modify(pcs->bus, pcs->addr, MII_BMCR,
-			     BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
+	ret = mdiodev_modify(pcs, MII_BMCR, BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
 	if (ret < 0)
 		return ret;
 
@@ -2688,14 +2681,12 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
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

