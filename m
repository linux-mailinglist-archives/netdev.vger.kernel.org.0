Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAF53F9143
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 02:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243813AbhH0AQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:16:23 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:60513
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229710AbhH0AQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRh9IzRLAdKa87n6v1f3i9lhQ8vcSKYkTxrVgw0is8CAF8Al+VMA1wCFeaDukz/nUSlv6SjJZ9kbdhrnGWyGz9OYdmgnQumMxLixHvcbrC3ebi3sTAthV6KkGTYn9FVMpFu5JJ2hpjOQZSGW8aitfgv88zD0WLs1CriaXeNIR5qphUgiWxNgWjISBjAHB7dp7FWhSFt93MR1wFrWM9y0pXpbMr8/Joo9wShbk305GlRSMGJECKQZpXoIzkBQx7KVAsrz4GPKmEpmAEZiEkUU/LqtNaT4qV5ejVNne8Wg/WgRYdFGFPmwBkETWZqTMNDME4gXrHnQcRiv9TDGgvyMlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUYgWRTl/23zOFVYTOc4eRp7buSj3v5oR4YthGMk7wE=;
 b=DuTP3s+IpRsPXiFRO0o57f/iDc4BeKIyHFmAX1yhn+gatEzxnyUa0oc+9ydcwdkjNWmUl+28QYU5J/ew5udWQLlBoDn739nDjDtjzEt8AomJhZ0y6wKV/3cwyGAofx0PNgSaD8HO6o6GE1yOjuMA4COSFQHdDwyyVbFDORhGu5ZcOJMIWnAekPLA+kUNHMSspJYs5lvP/VXPdss9H1A8y1PlI78HnZ74ZFNK8Ayljr9AkUTUwrr2b/i3SOTBU7YBgfsvvgwnt2iJSBMV34AkHXnIomlXVkQS3ULJChx4evhjMUlPJ7WoIWMfi2Itvii8fJCONt9+OPFo7ccN4ObklQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUYgWRTl/23zOFVYTOc4eRp7buSj3v5oR4YthGMk7wE=;
 b=jVEAgdDWmaq/KIoZaqlwbKBiln6ZZlHLulSMCfh50d9znzwl7gFTOU5LXz2zWlhh2eJQe+5lV8GlZwuuM2o4fmVI9fP5vPEhO/Q1a6hZYjUoMScIHgwiwt0qRtafTHH52vGrmQO9q+rariv/q+R+VB5b2KYBfNBfEE4ogb2cfI0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4911.eurprd04.prod.outlook.com (2603:10a6:803:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 00:15:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 00:15:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: marvell10g: fix broken PHY interrupts for anyone after us in the driver probe list
Date:   Fri, 27 Aug 2021 03:15:13 +0300
Message-Id: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 00:15:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e856cd3e-d75d-4200-4075-08d968efc843
X-MS-TrafficTypeDiagnostic: VI1PR04MB4911:
X-Microsoft-Antispam-PRVS: <VI1PR04MB491192C4A350FB90E9743000E0C89@VI1PR04MB4911.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mShoCs3q50bN7vkyzisCF4fYabkuP7LyhF+fC392X0SmhYOwyT0zeSFmyMXUplyrsQFfNgg3AH4IhXMYLheyMpjQqMd+NM/C1NfDzyWZMBh7Fw6z1zF5uFAbiVMVQmnd16n5XDTUtqdmb80wZ0fAS0F5RRLYu0gLFXPp5a0nyqTquAInEm9Dd7jDYV8l4Qv7wWKHjCRFDriz2ghYbhuladVygi3DSKtY3fyNAGq19+E+6lrvJq654JsW4pvwAjetdud7Mv89yW3CEA4HTki5Jp51AcYTQbq6WynUlHEdzmCCO78pof9R/rqcPSm45mKsmN9Wi1QrPGjwps0m0xEJfKtdV6bAla+v7mOwgvo0gfFy9BYtLXzMJL36SwURENxeCHKBc3HSIzXkC3o5uPv4pM9ICx3fxxMhqq1Xd9Cl0lT4yyXoiNlvxB8lwHHhr5/sp0URPjVxQlKASVFaDdi9KfM5EFsOL2MWpLiDNl3jZBxHhauJrEUNH8ICjuTOMXx/uWLaLbfAX9NtDCeqAx5ixnnXt8EUNFp3nZ1nGxBfzbRGAcKvMLy9xcIAYIIryEsEhSN+PhUlbEhqanie0oTLBZTo+fNXltDufeV/QLexdxpBzhyfDkOE3U37e0DdKzedqQVi9rMjSNPkRbxTGKIbvIkeTGHfD7qq7Vvt2M2EBPnhYvlUZNT4964dIyF7L/lf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(376002)(346002)(136003)(478600001)(44832011)(956004)(2616005)(8936002)(6666004)(186003)(6506007)(1076003)(66556008)(6916009)(66476007)(38350700002)(38100700002)(26005)(52116002)(83380400001)(66946007)(316002)(8676002)(2906002)(6486002)(36756003)(54906003)(4326008)(6512007)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Do1xGcgnfo6V3/aNWKu5KuJB7Y9NtfuNYdbWinPfxiQPbDMRCfrBiCfiBuew?=
 =?us-ascii?Q?E4dPg4cuoFw5nwVPGjky0rHwtVM4rX1/rWItuAZt5C42ED7JNFXRgeAoAsa5?=
 =?us-ascii?Q?GAkA1AOB4kCHKKGYM19aaI9darN6BroaYXFdLEG6uWE8GotD6rfHkOAvJM+/?=
 =?us-ascii?Q?nASrH9FghLSZtCIvieolXq6iZsO/KUsH9TKpYUAigRU3lqDJDErIuF9dZ5zr?=
 =?us-ascii?Q?OBv2dFWiAuXsNITmZcpHwigSw0NGgVjHWdNz/na51S1u7KIY6JKfFwVHXZF3?=
 =?us-ascii?Q?ZAN3RYup07+8/3SFy/ECkK+oz7GYGkMvooF+YVf3MxUN75UEEan9KIDBeARD?=
 =?us-ascii?Q?URjiE7KPTJcMtloCu17AMtRRp5wcmJM5QUH0YtimXc9sjZcRtVLdSudBVHId?=
 =?us-ascii?Q?5JGS8qL1TgQf4brbMqfLRPRCsENrkmpSmpRjD4SO32iy49It7lhf4VU89cux?=
 =?us-ascii?Q?537UO4UugM3XUcwUixpweZqRXiRtGYdyF+RxZ8Wt1H5/QhX62wYRdUzlLI/Q?=
 =?us-ascii?Q?CliO6njK7x/1xkbIwrNMFs7B3u4j2PyjeJJmVPSSbqLgg+a0ocDmAgDsJ+i9?=
 =?us-ascii?Q?iKDXCXWtNq/bkd/2lrWWbQdc+cpCgbMbwMaD5jMlVGqOKzQmxWLDMPxT4vmj?=
 =?us-ascii?Q?HhMM+mY1TgTeeRnGMAuD4xwCNjMZ8KSMahMYLW49N/9rtfI9ODZ+zvUNNVMj?=
 =?us-ascii?Q?2GAfwM/gBrumyuKe5WAXSO7wY9vMDpK5f1X+yJuRsyrkQOLs79fPzLX542W8?=
 =?us-ascii?Q?TjRC6BlLLpW4xS5WGDGcNOEhGQnPYo+5vXS71HwuFe1ubnr2cj96C/J/XP8m?=
 =?us-ascii?Q?YWKFVOwoR1gCsjnFpyum6hSVFF0c8h58+I39UbSsTpFBAJuRAKFmFTE+4DxQ?=
 =?us-ascii?Q?T875DkFje0rX2NEGg1F04FwQdad0EtWEgYUzS/59TfUbm6fusuV/PYH0G4oQ?=
 =?us-ascii?Q?UYZ14mOy1ER4ltEpGKvzXx7lwe5XaaFiNc1H3BmPMauZnE0ze4fmALtItgPr?=
 =?us-ascii?Q?IvjcqFqk6hBGZ+9zwde409HNz5MGcdBXtn/owxkhVBibpLXKfket4g1pvuai?=
 =?us-ascii?Q?DoQaaiagSB+dnUv2/z4DN4AIyTzBg9EveTX432ts0ZRFpvliUKpKeT7KG9wQ?=
 =?us-ascii?Q?izoHETlVDm+n6wtZzS/RQ6cUz1naDECwOXzw7atZ3i2UT9jPe8EI6f11t4JR?=
 =?us-ascii?Q?gbai+1y77s6WiTh5LiFA1BUpPv3ddu9982oILBVI4yA5X6kWYJEw6VPnB99t?=
 =?us-ascii?Q?jOJJ0HzaDGoJJi+9Ui/kqTZ1IyoHQSHqPOkL9GpaqDo768KADyWcj/3jgdm7?=
 =?us-ascii?Q?cBN8g+8n4f/46d5bNeUcv5no?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e856cd3e-d75d-4200-4075-08d968efc843
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 00:15:31.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tchERadu1imuV+quQ9dulAmLQ3zAYavtHb6FXiOtmLVn7WGxgISjaXNQU8ZtKXu5CmMdp5o3DknJBLi1eOWxpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabling interrupts via device tree for the internal PHYs on the
mv88e6390 DSA switch does not work. The driver insists to use poll mode.

Stage one debugging shows that the fwnode_mdiobus_phy_device_register
function calls fwnode_irq_get properly, and phy->irq is set to a valid
interrupt line initially.

But it is then cleared.

Stage two debugging shows that it is cleared here:

phy_probe:

	/* Disable the interrupt if the PHY doesn't support it
	 * but the interrupt is still a valid one
	 */
	if (!phy_drv_supports_irq(phydrv) && phy_interrupt_is_valid(phydev))
		phydev->irq = PHY_POLL;

Okay, so does the "Marvell 88E6390 Family" PHY driver not have the
.config_intr and .handle_interrupt function pointers? Yes it does.

Stage three debugging shows that the PHY device does not attempt a probe
against the "Marvell 88E6390 Family" driver, but against the "mv88x3310"
driver.

Okay, so why does the "mv88x3310" driver match on a mv8836390 internal PHY?
The PHY IDs (MARVELL_PHY_ID_88E6390_FAMILY vs MARVELL_PHY_ID_88X3310)
are way different.

Stage four debugging has us looking through:

phy_device_register
-> device_add
   -> bus_probe_device
      -> device_initial_probe
         -> __device_attach
            -> bus_for_each_drv
               -> driver_match_device
                  -> drv->bus->match
                     -> phy_bus_match

Okay, so as we said, the MII_PHYSID1 of mv88e6390 does not match the
mv88x3310 driver's PHY mask & ID, so why would phy_bus_match return...

..Ahh, phy_bus_match calls a shortcircuit method, phydrv->match_phy_device,
and does not even bother to compare the PHY ID if that is implemented.

So of course, we go inside the marvell10g.c driver and sure enough, it
implements .match_phy_device and does not bother to check the PHY ID.

What's interesting though is that at the end of the device_add() from
phy_device_register(), the driver for the internal PHYs _is_ the proper
"Marvell 88E6390 Family". This is because "mv88x3310" ends up failing to
probe after all, and __device_attach_driver(), to quote:

	/*
	 * Ignore errors returned by ->probe so that the next driver can try
	 * its luck.
	 */

The next (and only other) driver that matches is the 6390 driver. For
this one, phy_probe doesn't fail, and everything expects to work as
normal, EXCEPT phydev->irq has already been cleared by the previous
unsuccessful probe of a driver which did not implement PHY interrupts,
and therefore cleared that IRQ.

Okay, so it is not just Marvell 6390 that has PHY interrupts broken.
Stuff like Atheros, Aquantia, Broadcom, Qualcomm work because they are
lexicographically before Marvell, and stuff like NXP, Realtek, Vitesse
are broken.

This goes to show how fragile it is to reset phydev->irq = PHY_POLL from
the actual beginning of phy_probe itself. That seems like an actual bug
of its own too, since phy_probe has side effects which are not restored
on probe failure, but the line of thought probably was, the same driver
will attempt probe again, so it doesn't matter. Well, looks like it does.

Maybe it would make more sense to move the phydev->irq clearing after
the actual device_add() in phy_device_register() completes, and the
bound driver is the actual final one.

(also, a bit frightening that drivers are permitted to bypass the MDIO
bus matching in such a trivial way and perform PHY reads and writes from
the .match_phy_device method, on devices that do not even belong to
them. In the general case it might not be guaranteed that the MDIO
accesses one driver needs to make to figure out whether to match on a
device is safe for all other PHY devices)

Fixes: a5de4be0aaaa ("net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/marvell10g.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 53a433442803..7bf35b24fd14 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -987,11 +987,17 @@ static int mv3310_get_number_of_ports(struct phy_device *phydev)
 
 static int mv3310_match_phy_device(struct phy_device *phydev)
 {
+	if ((phydev->phy_id & MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	return mv3310_get_number_of_ports(phydev) == 1;
 }
 
 static int mv3340_match_phy_device(struct phy_device *phydev)
 {
+	if ((phydev->phy_id & MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	return mv3310_get_number_of_ports(phydev) == 4;
 }
 
-- 
2.25.1

