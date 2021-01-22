Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0363300ADB
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbhAVRZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:25:42 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:48516
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729190AbhAVPrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:47:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDTFYO2GpD846UnwQQf4fYAOaF9jAbMekRSNNoZjqPb13F7zGwlMM8znY9ImB1H/sgDTLe0AQSydbtuz9ZEdBC72MqPWF46ibNDQNyZqpxqBAm39J4e9eslaVWQlal3AvR/SC8saA4IWwhslpCUhwBbeldOHFn2jdbvzuHsBBrZowkD6gpXtuYoGhGst+SPKj+f87lGcp4z+9JC/WhGQM0AFnYJC5jZVFEJi0uPlViKVla4w0dmHzVSIzdXytDrJ9WhzRQ5YFIPeUGUVxz0tO8kjkxSb+Gvk2YeKyeRHmDaFfpk1KAYAOLHan9Y5F49n2dz9XWuxEeT7c+H0j+YYtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9C8G8B5Ed9uYFdvaM57toXy/mJJruRLcg/M4CTnTGg=;
 b=ls5+cbRKIcq5OmTuVof/9QZFNNdActiLaQGt04/AZMeahh8jcXlpjkp09ZW4OXirn2sLVPVX9MLCmyvVhKRXSP1q4yJCiVMTSPOa46ID9d0QFt6p8kuw1iC1ts2zYeCTW3Et3S/Nr2AVtACPbntGj9czDWHfqlfY50KCQ5lKaF1Na4+BmtuE6foZiayf1eGiNk1OV5DgcHJXFRTKbAyQkk+1ZEkbeAA8GZV9Br88ARzcY87YbgQKuXITHgljkrnTUIZd7D5Bw43GJxy/bzxjdvM28FjUfSUllinYxkkdj3e42Ut+FjUVKA4KBBf9p+wcIK9EZWJ7vjA6l9FAVRIHaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9C8G8B5Ed9uYFdvaM57toXy/mJJruRLcg/M4CTnTGg=;
 b=TXwFqa/Z2VjOuh37YaCGd/8SfOcUhbYssTiFIngIpjxYk9C/cphTpg527yznsGfRLvrPwJlL9UeIFUULYrXJ+7S22nPibJKi/n+N2PJaxnglRUuRANObQIVoeSlIBqliYdkQsZxKTNEtSfSiWnMJ6Pj7oC9Tfv3sQ/GCCdbTPcw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:41 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:41 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 08/15] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Fri, 22 Jan 2021 21:12:53 +0530
Message-Id: <20210122154300.7628-9-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6ae2fac-2a85-4df8-37df-08d8beeca1a8
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB344343F131149778D103FBD5D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8S4dLha1njSMGtOdeO+G1XyiIlSTG98GTzU8vMk4rRFyuZaoR9HyhSRJiHb8yHj0+W8kKUYHiRMe0AsCunvye4CKx8NohEmAcl7f14uQmOEXxe5vd6pwOX5Z2Bs44a6IuVvUzCQZV4FztOieH2uAXH+ix9L7xpgWIrresyFeLzUDyYhbiav6n37M2GA7oD23SQZsqh/1ELdW0ZX/HybS+YTRWJd9eq1lTosM6O3Ux+s491dBaFKzzMc492GnmcPSY/GNKe7ibA/IRxiuraGE0C+gVR0ScQ/I6+33c1ynYQE6g4Q/msAoNO+lQKVhN0ubBE6OzdxxwyaA3U48HqA984F0WKjqNLTDnKSUf3tgcIsqEs3eIhVimZKtZdv1YFncwWGPwFsvomP9qWuuyUlZcSSxX6vSa3oaZHvvMvdB7C1eU+ikpVktmteJ0pBjWTNKA/61qIACc0xQVOeq5nLgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Kj7G+aLVWvDcJwk9hT9kOf6OAEVJsOWBNkyR4J4HGZXCNkfvpqNS6IVom7LQ?=
 =?us-ascii?Q?G8vGBdGZuQXCaeD1LiICsnN74s4vdNGrO9HPtsDb1r6Bf5ahGZUZeflohf3W?=
 =?us-ascii?Q?UfnanECPzCr3xN/Vc+29tILUq/NlUbAFviSiUx+c73SavxN56jZN7reeQAOb?=
 =?us-ascii?Q?zwd4YUymZlReOyr1HDeL+XHbQDAJaMBy6Nk0xCCv88cwUWyt5R3S7PARXULk?=
 =?us-ascii?Q?7EnURNp5lnI6gjTwZ7mo5a4RePjTCil7hGkQgx1P3pcgO2GhiQHCUT13amNq?=
 =?us-ascii?Q?04kDr4ZBfrgE8oY3l+Mx4ceaJiF3mjcxmG/AHVJAU9RbIORLwZTOdtf8ma4j?=
 =?us-ascii?Q?ZJAFMkSK5yoh1l2rZMjRXb+tQ7MJWsG89r6R/Zcs4sDUV/KfbSySMHhwYXIo?=
 =?us-ascii?Q?7EPtZXD6QTFdvj+n1kQIr+oP6I8lg88ZK1olGUChjjnpDVSM8CjQNZGTV55m?=
 =?us-ascii?Q?WGqNbEqXoiJnlrGzAcXtIlR+E7Zld11z3hUMt1OcU1C47kjvujTkO4mOJQcm?=
 =?us-ascii?Q?YJHw2YyibPv3ZXSiBLdDffJApEr488b9H4GNA52/tt/N0NcJP5MsOG8Yf3Kt?=
 =?us-ascii?Q?P367HsNVS8256Z4pQS7HErMW6Iu8RuLZmGcgNojpQ1Ck1JIyl5FpEI6I4d2+?=
 =?us-ascii?Q?eR82Q1MnLtN0AuF8dw56qLYEX/RXo+6k7dbxelezUPVbw/L5jkDj68j/q5TR?=
 =?us-ascii?Q?tjL3xtj46+PRLBnrRpUCIVT0XX9vmKr3mJw0jixu5EvsBtWvMxz0SiEPwf08?=
 =?us-ascii?Q?TC7FoMPVT2l2qaRxkg84JCHzRaB7XsrENIS94tTyrVb7YxZVgwVTucFdTtWG?=
 =?us-ascii?Q?H5DlKSm52VTT528o/hiV8gYFey9SdjATT0846//IXiUjUV1/lAi4YC5Pzkuz?=
 =?us-ascii?Q?+31XKxyiT4wq/Prv2oti9K115bYaWQdvndoOX1DUPFL5zT0lLHD37eGee/f2?=
 =?us-ascii?Q?hfbIq0ttNBq1DnbOGSj4cTTD4WchWFyykhN4B0ORo3SQIiNyhksV29NBdVVm?=
 =?us-ascii?Q?XEI0N2892WQ8VaaA5S+futddbdX3LUTjLsIw6zmnoO6DrCGtjMajn7qa0cg8?=
 =?us-ascii?Q?5zjSy9U8?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ae2fac-2a85-4df8-37df-08d8beeca1a8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:40.9089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oTXDnCJSRNTAWRdzLdzuKuWkYmgiIFisSKNuan/T585MIlClWKJJAhSZpbHLfjPjd4GvHdiGMaTG8D89P8ZEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 40 +-------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index cd7da38ae763..1b561849269e 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -98,45 +98,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
-	struct mii_timestamper *mii_ts;
-	struct phy_device *phy;
-	bool is_c45;
-	int rc;
-	u32 phy_id;
-
-	mii_ts = of_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
-
-	is_c45 = of_device_is_compatible(child,
-					 "ethernet-phy-ieee802.3-c45");
-
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy)) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
-
-	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
-	if (rc) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		phy_device_free(phy);
-		return rc;
-	}
-
-	/* phy->mii_ts may already be defined by the PHY driver. A
-	 * mii_timestamper probed via the device tree will still have
-	 * precedence.
-	 */
-	if (mii_ts)
-		phy->mii_ts = mii_ts;
-
-	return 0;
+	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
 static int of_mdiobus_register_device(struct mii_bus *mdio,
-- 
2.17.1

