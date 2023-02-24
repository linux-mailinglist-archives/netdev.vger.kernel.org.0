Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D96A1EFB
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjBXPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBXPw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:52:59 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF5B11141
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:52:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhHRwvChAdpqW2Wdu6MANL967Q+fmo6e5isZCuOCZtk74jUzs7VEjXN3wYhE7TNU9bWe1+dgHW0wNgCKlcpfkVbsmsbqhv6fl9ZeK8utQgH+aX1tcaxRE3tfGmsc4ojqCMor8yFWcpeRQuZWvrjWTFSKWAgorJ+Ga0gdhV8ExIV5UaUgo8At/B0vNI6WBVjb9e4YXqEzfoQxhH7KsfEtAoTxI5EPF/8tVoHDP+q7LiD3aXWf754+Bb29ALbjMuCPLN6+f67ivcWmNOqFUIttTbID+hFo2iFAtSCMVHhIP8E1LAhi7qY2wteP/loalPS/KggIT3opvxgRa6Bby23kDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6PFJLcjlmrpghec6Cd30eDP2cbP94Ro2lSZQOCns5U=;
 b=hF02E63cUacWa8GPjuDt4jXs89X5yA8xooh4e7Uxp8Yb0WJJYTdlOuPXjI5/gifjxE5j17AnOMYYu05t6mc4Kl5to1kcanx7i0MDwnmAUKfQr57ipdPZ4SJSsscklxmkwNVhA14PXqQiNOWP6jVj5oSepPOf//UzhqELhyuDmw/JUi8Xz36agCcqQg5Ba5NDMq0Evl5Pc2zBakJxdwWnBA3sOSWTqsFcYAYT+ea7oV4j6Sf/LzmyJMU0c9HFJFEWcKDcVMuxfMN2rWW4D6XDv76E/daiOZqMMVdSFwElpeAqsDtIHWAGxnIF8KY6P/hsMLjGRvjmZCRv+T2s+so02g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6PFJLcjlmrpghec6Cd30eDP2cbP94Ro2lSZQOCns5U=;
 b=qFy/+ded8Wmyz7IkLwfQoyNJsuVkz8xaXmO8MvO1Ucqxa0CFMJSYjorZN6c5FQOOrsv0BEEUSLcHNIbOllfO3Nm+UStZI+1ASoa6EqyvkbH5u12gA8kVtiFT26gJqqXuWkZZCa7Dd5Cql81ZshVn03OgV/29UGMDEZ8kDT/eF1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 15:52:53 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:52:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name error
Date:   Fri, 24 Feb 2023 17:52:35 +0200
Message-Id: <20230224155235.512695-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224155235.512695-1-vladimir.oltean@nxp.com>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: ed45bcad-0112-49f5-02b0-08db167f3072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWXuJuzayO9EKM1/EQjJeWyF9kAFUfQ+gJAWFW0tuNZq/QJec5NgQE3VbVElzJ/o3r9Idoidpp3XHbRMPIxaqUJ+k8xZWvDQTkqwUcyqbV+2aJrVgYg5Ozh9rj7zIYkClkQav/hVfxnZFxBMko3X/3kTJ4vU1LkAnj5nLjf1F1yed0v7AGsxVKfbFGbNTNQrbMDuTnv/qEghimRajZdSXs/DHkf3OkG4mWT87A0LOywFVZaIqnG8vXygWj/w2Mv0vTuVQ7tw9NPhryk+cetx0sHQzm1wZBKxQsUapyibzaW6DoThVNduljBEXX+ZQamoHTuUVmhZykiSQGrckHt7U77wGaO/1ezDNAD8JqFhVC/QmKO3eHarER5APATe2r7cQqdg4yPHocGfCSYVJ1mifGcQc1jBRgearv42ULbzUMJabR6z5WkQC39D+JSX9TQ7FxTEKahV78/bhuuaEgDEkXtoWyf2+WGu/ckQhUXKWAo6AvEBtWDWEUmuQ73SHxvYCO5ltOP5Ff8bzceTof3Xng3PSwc4XIBQiDd7KlySeZK1aVX4kGnUvS0isqIFZz/79FvHjHBtAUPKYuFXnrgPsgDwbxkeMwuYD938uWgCio+AHZ7iRzBrXqH+hns5FEHkG9dUk2BOWa+i+7XWLj5SE6DY0yhVZzUvzNwuFcWw7zzZPfihK7KZFa79PwW3yPlwDXm6G4tOvLgzg0861yyiyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199018)(8936002)(66946007)(6916009)(8676002)(4326008)(316002)(66476007)(54906003)(6486002)(7416002)(2906002)(478600001)(52116002)(41300700001)(66556008)(1076003)(36756003)(26005)(186003)(6666004)(6506007)(6512007)(2616005)(38100700002)(83380400001)(5660300002)(38350700002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PpCCxJ2nJij1ql0PofMFxxgtHlb1kLB+XKrQ63z4FrolaBzuFo+Qd4FpytDJ?=
 =?us-ascii?Q?k70EEwra97cwMpTFY0pG0US7tKl3N787nXTbgQtjXDUGt0gH6vhYzRJfTuFL?=
 =?us-ascii?Q?dWhMIk+SEZ0CBGrXHZX6bExiWRLfbFznJKqxcpgRNOoCq3kFe9cfUBl4YxE8?=
 =?us-ascii?Q?jlHefcnuEUyToqTOjl9zXNFmw2UaW47Q2jN+SVAuiUqfv6uLWT3EhyeR88ZC?=
 =?us-ascii?Q?bgVlB/hzDh2IBbaNblWsv1rd3X1elS3dWZ1JQigt1fdl9zuxLj2ytg/9U+pZ?=
 =?us-ascii?Q?iEk75o91GMVeGUGCTJP5BOq+iU79kkJ6qWWJEUooNjdeEN536vWS1vGtyBX6?=
 =?us-ascii?Q?8Ig8RT8/dqEwT/ptRr4xkk/wJoaZrnD6MCoZbyQs3mvQvcDLPof9XWcMrEgD?=
 =?us-ascii?Q?bwTyMK0prDhkT4cTjJ9r72u93vV5aT+QiXrAMURqfxc/O3JwAhw0U+qC5tbg?=
 =?us-ascii?Q?Y/texGOX6SaxBQhZjKRrXuoz1VRWBU8M5/aeOjp7BPzTtPj3+NU049IlCegj?=
 =?us-ascii?Q?VfHHWpCjADFBHUCXQfspZj0noTYWEs/VXy4K8walJbfEjV1RVWUnjbTM9Iq+?=
 =?us-ascii?Q?ja38W3C1/MHu+H+8KbNoNVJmSD6C9bzDFxW/eoxBENhgHqMOrIcbMWIclCA4?=
 =?us-ascii?Q?mNGNKSe7o1HElAAl1XtIegliIel0X2oYKcRUZJM8pInHYyDaV3PSH0Ua6aHy?=
 =?us-ascii?Q?/Vr2CrwWHW11Jlt4513KozTU/9c2ndO/8fzI57cIez0ptr1Zaq+SKik6tZel?=
 =?us-ascii?Q?4Y5IXEx7IKcB/L9yHUWbps7xB2FssKp3bNMUdGHSYc9sVMwXXBLT/ZZoY/R5?=
 =?us-ascii?Q?yjv3G1XxPTpKqRmfM8+20AwN59WTzIqGcd6d8PgtjnVQCICH2uZAvtsP6Joe?=
 =?us-ascii?Q?Dh7RLlUScva9eLq9J9v+loSoJnpOEhqHXKkfNzfvlBEn+w6JmZVc30jcJJVr?=
 =?us-ascii?Q?w6ojDEPcPCaSGWJBeTz5Kr66YtRWj7ZQBZ9sklthDp7D4WGb7CZjC8Yh/Z1L?=
 =?us-ascii?Q?tfgc3kljCF4Vm6Phobd2+C4CIgYUKMIHw2SCchBO8VtSCWOciKK1ozTanQ9c?=
 =?us-ascii?Q?7TA7UG4zmkLbbJ17vl6sz6tVo99xPAmb3svonRwW+87UdOBqSxZcp3T7rxNU?=
 =?us-ascii?Q?TTG7+Yl/VwxlW+4LYVKqdmv46GK6BA0lgxcCVfNZHAKSqNMBN5aZXvA+3zHn?=
 =?us-ascii?Q?w9HhfH5IOfj2Vn6NZ8c7Bqw4bSMBHvRpK6WZO/noPnH+tp5DLcEW4wDb5izp?=
 =?us-ascii?Q?kVwuaseddcmc83VqUBiLqw5qo1I6MuFZhBi30F768abs2r2+fmB0m2s9WmE9?=
 =?us-ascii?Q?yqVhjv2Owa10Wc5MGhhNljheNzSyECeRlqECGDR6LJHca123FiHKiAIIAQ6u?=
 =?us-ascii?Q?XYD29FXY/YNae+5ItVJRkdlrSlvRqwdy/iVOCg6gC1cX2/GMyGlhiIMliXuy?=
 =?us-ascii?Q?fG0QsHPlfXeugdcPSWg67sivfFs4IgKJEmQexKI39DgcgmcIFcRFh2Yilaxk?=
 =?us-ascii?Q?P6YRex/Ah5BXZ0Ab6Ui85ei9Mf1k2CYO1ebVLOglktsoLgvoLQ2dEw7qIw0K?=
 =?us-ascii?Q?a+ty8xbWHrR7sGYjU5XCDWei+ZhkSM1G+MoCgVt0Z8AZb+ECQv69nA/Qi1US?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed45bcad-0112-49f5-02b0-08db167f3072
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:52:53.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4y8+E2uc+sjiRRSJJeDHROjaAH651FF6+keUHK18BxDiH81IFvXc6nCIMJSaXzzvHZAfH31Qj15Ms/VvrVGdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
be printed:

[    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...

Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
duplication, and update the mfd_cell entry for its resources.

Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/mfd/ocelot-core.c           | 2 +-
 drivers/net/dsa/ocelot/ocelot_ext.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index b0ff05c1759f..e1772ff00cad 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -177,7 +177,7 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
 	}, {
-		.name = "ocelot-switch",
+		.name = "ocelot-ext-switch",
 		.of_compatible = "mscc,vsc7512-switch",
 		.num_resources = ARRAY_SIZE(vsc7512_switch_resources),
 		.resources = vsc7512_switch_resources,
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
index 14efa6387bd7..52b41db63a28 100644
--- a/drivers/net/dsa/ocelot/ocelot_ext.c
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -149,7 +149,7 @@ MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
 
 static struct platform_driver ocelot_ext_switch_driver = {
 	.driver = {
-		.name = "ocelot-switch",
+		.name = "ocelot-ext-switch",
 		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
 	},
 	.probe = ocelot_ext_probe,
-- 
2.34.1

