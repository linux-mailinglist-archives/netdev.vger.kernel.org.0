Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5C1336C10
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhCKGVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhCKGVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:21:22 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0621.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AB1C061574;
        Wed, 10 Mar 2021 22:21:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHH76PMkc+Qzg8xmpJNY3EwGJEKALSDvycd+YdvvJrqbSFlJMgTyzMwh+Ni5lSl6LCBDgly8H4ETT65UztfGjtNtx9B9B3AcAOJ735V5gFSqSQQCRTtGjvNsxDp6ukAiXhxjwCi66Lfb2SElwie5zkukFaLCJhSiOeQ+CjVI7LTCMpYr8DslQ2kQAjop+uIckV4ABU/zpdkE3RviKWPjjt4uuXP4lteQT9xMOeiP+2yyPuIFb3qHP7BnQmzj4b6BlNxjV866PZgSbrVOT68NzAg2jWgnDKcn3jA0Sr/HoWYSWihl6ZFCSMvXpunD+PnN8o/TRwOiD55bH7afGaVMDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUCcUeOixe4seIGhSVfibievgonYYsJIkqsL6FMhwA4=;
 b=DEGMfxbsOKr+nEOWp04WvIcPnRx8yiLHwEm5SsLz3n8n0vwbA+ohF9VPf5uUZOk4Yfy6QxheVjyWd6pMkyElxYuXQLw9GkJk7us8E2WgpE9pN6mbEcSXXE0VT4/veqbjgO0+1zzvTUaND9ykMohn0Vyqs7tyOmit4c5QAN8Iw8jsM8FIPiBJ4uu7n4oK+HOogDzc6ddObuXXRuxVYPbaEdzALWUENXilNybgkAE1Z3BdpKiqWCrLYRF02zEHVNQPFDFNjdMEPgo+4Hfj3RPLUm781/Q4pTeqaDpnM4cPbRuwJ/tmcOpWFLk7Yt4SpKtIjbRCZdeLbGmcMed1t1mv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUCcUeOixe4seIGhSVfibievgonYYsJIkqsL6FMhwA4=;
 b=IBdfwMz7mKpOK7ryGdt2jrBqUeY2bzFM4DeCO+pYylyPmlgxQSconDHPlckYCfRjkaLhNsfVrgOYYemoPJ6CtaSZ6+3gmnjTXL7ztsVxGAbaf1iKWFibyB+uxhZQItzutYJBFljHo0kjb0EcAE5CdKZbMxVAf7fJ09DdZWyw6IQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5473.eurprd04.prod.outlook.com (2603:10a6:208:112::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 06:21:19 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:19 +0000
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
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 04/16] of: mdio: Refactor of_phy_find_device()
Date:   Thu, 11 Mar 2021 11:49:59 +0530
Message-Id: <20210311062011.8054-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1706caf9-587f-4099-7561-08d8e455e1d9
X-MS-TrafficTypeDiagnostic: AM0PR04MB5473:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5473F518690BDE69742D9817D2909@AM0PR04MB5473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiB6ILo7oDMvY2v4bzrKvgJLTYZzUBgUV5vAEYk7giRgp5X40cvs6YBz0iZYt+RzeXArVsCmWoergwAp7rs5HyZNTNmSYQ7Z36dByLpG2frCtr3+Ytj7vQ3h3VJwUZFgbdeTll94ko1K01Ig5YejdusMrxlwOPSE5RNB3nVqmPRnIgyikPIJWl1FrAxmwpHr9CLuGyr6/5xTROHQDsoSdT3OSe3ZQBbaIbJjnxpi0nlB6bPcWkd1t9g0eZNr6tWoJshfrAYhylEWNZO3uXWlcCVpwl3w2Db7Rq005nSTg8lRIW3nLSsG9T45VkVRK1GnM68qCXgncIjeY7949B3MIF6riWa9ywFZKrpMkJgMd8J6tRZwDwu9NNrBHa6/sHL6Mp4Ggc2NncStlhitW0EhMXEq5NN4vFlr79W+eG6wCheddB85gq5AOW7M9MNR0oTTrO/Jvv4p/A7tqqcTcmBhWANVdQCyAV+YVpjhlKTlrPRqYVpF97T25FoYFEv5ePwWYBntICtUJeF3UCh136GBu/q2PN2pAB4/zCYHFCdvTHI9YsuZWzqvfu15m0QoU+aOCRqn/RBavybhcfZ0OmsodA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(44832011)(186003)(54906003)(66476007)(52116002)(5660300002)(110136005)(1076003)(66946007)(2906002)(316002)(16526019)(4744005)(6666004)(6486002)(921005)(4326008)(478600001)(83380400001)(6506007)(26005)(2616005)(6512007)(8936002)(7416002)(55236004)(1006002)(8676002)(86362001)(66556008)(956004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FLyl+bbrwW7vuW8JwVJ1CxGRs54jHIW0ao9ZjoDknC2Wf0thdnFJ9Lp/z2TZ?=
 =?us-ascii?Q?VztILA+9TzIsbs9iVi4QTFUuByLJ4g4ZoJ0iFZiPYNSvopyg9ess7szd16HX?=
 =?us-ascii?Q?a2/skxl8ZC3Zz7DvetaPNJWF3Q+YkQBVWQl4u/JWopb7cYeKbJa21cnNDCCZ?=
 =?us-ascii?Q?wSfZt5Dwrqa9tXFUp+SmuF8qZnGupLbAJmo2fPAMEd0Z/9VgKvxOkQ0c4Ex0?=
 =?us-ascii?Q?E5PCYSbGsIq2qZG8xQMCQyHThvqoA/FOnMORc4rZEyCI2tUTFfttBj21x6dB?=
 =?us-ascii?Q?V22cvh6bD2ZszGAa1qG1zQvh5jL7lA9j+Pge7cXlGKybuxtzLTPvx3kFiaQT?=
 =?us-ascii?Q?sPVEoncdeJH2xNFveGl9ngD5/mHtzx7AkypSztEI8esOFjGNIkhzirH3E3UW?=
 =?us-ascii?Q?9zOwZyuJRSdQsORzqyhP6POBO/15FfYBmcaqr2W7gk5n1TJdlzab4LBrg2zT?=
 =?us-ascii?Q?ftw/LbQDWx3cUhB4a5QQbf5RndsNOivZpOXzu97GwjxGyLEGtGzKeVQUMcbQ?=
 =?us-ascii?Q?0OVkz3Ie14ha5fquYE9pe+gN2dLsObWt5NjKGqWhAKKkUdc1Fp4MSmFtsitC?=
 =?us-ascii?Q?F85SOyyruosRKg3UWQDreHAlwspW9eC/D4Z73K4F8agwST9CDs2utojsTw/w?=
 =?us-ascii?Q?9/aP9PHacy4pakYtSjIaMMn+PhH5PbdG2KPFCzB4brFzoU3rnHnHeP+pxIwP?=
 =?us-ascii?Q?clqrwRJk1WLq3IVohpOn2uw9Hf04ur1yVaER5gUP+en8AW4AdxU8OyHF7Ksg?=
 =?us-ascii?Q?VTTJGm01Q5JPt8W+AUa0zSV1WFQEN0vn+c1WRcWKVTiKe60ud9rGUIUD7lcz?=
 =?us-ascii?Q?ooIwYDPgNK2/gbSgHc719BrupH31Pq78qxYEVdI31/8lmJ80Z1upKmOSntvs?=
 =?us-ascii?Q?G0HRFkEXbIjWpkWHqlz2dCzEuut20WAkEHapeX19r9NqSnTCUZwWEWEBMRx3?=
 =?us-ascii?Q?H4gmbIpRqOZ6or1P9oe8fUeQ88dDEEXlZrfhnURufgTM54CBs6qmwrtPjhvt?=
 =?us-ascii?Q?FHoM/KKiCRIj7xkoCvGWM0ioRxxG7uechzDa4qp0jPVYVn7CPL4wfIvkYX/O?=
 =?us-ascii?Q?rbS5nBipnBX3kv2XfEeuRE4b9q/whcSWkKNAPcuZcSGRaqGpB9uxSqgWqtjh?=
 =?us-ascii?Q?PVCAHzoUH1j4mDvwxpecL6YmVUrnHL9A4OJwJT46r7KEEsPsq1Vpmh77/jUE?=
 =?us-ascii?Q?/9Woeq02GD8BaEoKveAsNmpon5qCSigdXaJgSn5vN1jMAt00CBCvcb5u0owF?=
 =?us-ascii?Q?FxHNainVWpt4xtimpvp5MiFATzPkOaiI6vZUf+B6hOhBJhr0h9tq6u49CurX?=
 =?us-ascii?Q?0e2hQLxGo3tU7AUxn+GPvCXZ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1706caf9-587f-4099-7561-08d8e455e1d9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:18.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXeiM2EEw+rf9OjwOPVGOhPWV40SE1//TI/6nPZYAnK2KC5yTasoZJvH9a5xxAi4edB/UdTX88TdhX5NDSRDXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_phy_find_device() to use fwnode_phy_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index d5e0970b2561..b5e0b5b22f1a 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -360,18 +360,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct mdio_device *mdiodev;
-
-	mdiodev = of_mdio_find_device(phy_np);
-	if (!mdiodev)
-		return NULL;
-
-	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-		return to_phy_device(&mdiodev->dev);
-
-	put_device(&mdiodev->dev);
-
-	return NULL;
+	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
 }
 EXPORT_SYMBOL(of_phy_find_device);
 
-- 
2.17.1

