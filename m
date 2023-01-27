Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C5E67EE4C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjA0Thl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjA0ThY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:37:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A6820C3;
        Fri, 27 Jan 2023 11:36:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMr8CQmTzqiLdaa9KyLbkydc3PNgNbCLYv8Hs1k0fv2LsH9D2baHEpbCtCzSiBEfWK8/8T31SQPk1XdaYgdr9FUH1uud/u+Dp1oz6581GBPLUoQ3XRjYtD3hxmdV/M9O0bpgew2M64gHz0ApiX4dhIm7iWEgClv0rhJUIK+HS2qRpBLjfMg13x8g0M58gU3Ynfhb51eI9HdnZJXIu1TqUfQNkK69W7eyZk9M/FRaVOy+pKom8ndcZHYjP5EKJStmcx+X1BJ8dBroubopavjCcmKlVpO2I/EyC8vfDuCaSzgySUJmPLcpfi3LhsBs+ERprcL58Iv4J01IrEJQ48JWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlpRQM+SXc9wFoCwHURm3MbTg5IhdmuFZMzYZjzHPbU=;
 b=FEgqZVewE1XQYsoQSY4oqskpIQLqNOlRhYI31QK/WhyE+Hw08IW4VmMFx2pUvvpineZIhFKI8Cp3zcV7HXKKNxK3xdTiZDBkr4b/l+gsTuyS+QXK3VcM6+XUufnHJ0EClcod5GvAs/1ycw/EPIIVkz1DPzyCT6WrUy+IgPl3I7OdynzyVhTeCzs4VUIm3GW0Ojc5toRDmBwXHhGFPBeQwJcmOUbdUA+sVkvf8ra5dGnh2v9ilZS567jRpmIjK84d3tHseBBjt8uB6kZRzuoJ8dPDmU2BXgLgDCyV5ovf6azk538gOfot2bwZc0Uj2v+saV4lMPYDASG1fYGfkzcqGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlpRQM+SXc9wFoCwHURm3MbTg5IhdmuFZMzYZjzHPbU=;
 b=d+v2elBiT8jznjfWc24ws76Zt2X5jfBVQI/3FH35b3t5J2lJ0mwqSOuHSdtyvBlsnld5BEKEztz76l5pPTin79ik55X5sod8PWg15f67zoey0sDyvK3JEDOwboFOXE/EQm1l2mllckKGdO0g58hHDG2kT3laxh5EVt6RsvjqlLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:25 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:25 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 08/13] net: dsa: felix: add functionality when not all ports are supported
Date:   Fri, 27 Jan 2023 11:35:54 -0800
Message-Id: <20230127193559.1001051-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: febab0e5-7542-45e4-a178-08db009dc6cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1lwAPRD6M4B+wyvYGUImBtcdVsxzTjkZCTh6LALcHCxZ3OrXE3AWoM2164Ca2sbxfK/HzK8gAR+OEQvBhSTyCEQv+l3QnYDpQHSwC+/RzEYcQde4clH9u4HZZT8KhZq6CMSgIO+ypA/Ge1VRQh85OGTJNnaQMRhdfuVBBTQ46Y26DI747Xv3NndWB5B+ET31AgbGNL/e3MrCYl42NO2UemLwydIBCSxuIsOMvuxEHvxLOl2b0AOF9UdZTv4W6s2QD+HShR9TgFBeu2ZKH8lPRnsUymd04K2mZgIvwcVO/DSUxmV7+JPNIZjGlM1q/Wndp2CN6gNfdXEnq1A5v2ejpKfCYn8aFCJeUC1dvpXKo9Iw3Kd2x8HLe+s4Cr/uSFNcb9NLegvKTqmXy8Ju/czqyZ+HxtLOLPjAfidN9pJ90vvcy/fMu5H7aPWyftFLuKEGV/7BdLi5BCTCqgmxA7v5I/9r4SCA0+mUlML5aDq1e1Rcy7A792JQEDBDQb0pqYPVT+iRsQTm2rw5jgEr/wi+phNvTe5S+uYLHWFzfBVw2Wb+XkZWFKrUMPg/JyddS9oPkp3zdQqnL0fbacXuJQjWCu5W8Q9VZG+ppcZHGY3mpb5TOp7TMhCW9T1MjR8koD8pf5NSSJyjifLwgwuwz20sX0UpjV0orbzo03xEnDge1DVEQc/rG+NNaAahm8cUrPVzKgptgnSlNtP4LrUTl2RcnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2p22+13hOr36gq2WCUY/4OGgn6fLG8+vPQwXO6KUiFSjxy0In8cU93pMozHB?=
 =?us-ascii?Q?vJBN1xtMD0kih+vXlHX657Vzw2VgAuCx9WzXEnp6TZ0/5HUGOBw/HNV0asq/?=
 =?us-ascii?Q?uEX8JeMaXEJZ68QqGFu36h2DwueabHbUYjI9Qy1ZXeOxLhW9A0SEuv1W5Rwf?=
 =?us-ascii?Q?wcD2z9HQhUtLG1ZvOzmdmKeYKLQvNN11aRekzYzsvoVNarZ8YdWu7hPy34vv?=
 =?us-ascii?Q?gk3pbBXChrZxxlUDBDRLeqdgUAp5AY1J4vwk0khGiU4RzLqaYyFkeBKLRv1y?=
 =?us-ascii?Q?QVWKxsSf0qW/gh8jJI8cNTJWRX8izykjFoYTrw/EOdgKcPoSp0y1A92maNFC?=
 =?us-ascii?Q?vzbvnfQf/kTrqhRXaNcBTANq4hTBJowCE0tMExs6IK6in6D9oe6RZVUMjD14?=
 =?us-ascii?Q?jhTy9wSEcsM6qzcETmPkTHnwwMIKIrz/ztf1h6XVq5QSk9riBTjcJTtoF657?=
 =?us-ascii?Q?pm0Gp81uVJW1RebAIDi2Dtz12EoEG7UggnBJ9QLhmBZpV0REWqj8dp+pPGnA?=
 =?us-ascii?Q?EzcT/4yJPseHWJhXQRuCuuaCuK7EcIO8ctu5K6QSIFwIpIfWgzyk5y/AGPo0?=
 =?us-ascii?Q?iXvaqR4Uh41CduSQZ6Q4E0p+7jK0EPLUs3CJ6iz8k+c3QTk+jprwYYn5TKyq?=
 =?us-ascii?Q?B/qKvUpzow3T5MYmiOjY0u+JadytGGuGh55jkCEuovyZ9JqHYYCaD4huDzFw?=
 =?us-ascii?Q?1P3FL/uMe/ePqrXf1B5C0Vfn56Hc6jk5C6nOIQLXakD2hTllGEmc8cTHB+bZ?=
 =?us-ascii?Q?VLYQxc/rGukSUPsQN8qkNrl2o6csLrWIdvazNhjX3IAnN2KaqftQiv0Kt22m?=
 =?us-ascii?Q?A+/E6b229l+o/ywuvdAfAJSPFssO2N89Jn1K2gCtqJJIGHXrdNhz7itgQF8h?=
 =?us-ascii?Q?URt2lu0LBDKV/IYYX1eIIcMwKROikehi+YjNiGBMXnYkYBw/3Jv1kThpePV0?=
 =?us-ascii?Q?znroLs6ycrF+oQxLLIgmVQZvFRRNzCymCY1BvyxJuMFoSW6VZB2yf28vPZFQ?=
 =?us-ascii?Q?4Rw0T1wwQQZqnImdfZHGEBgEwNsKXgyP1az0KMm2tuiBSeUJDSRm5g0JocAF?=
 =?us-ascii?Q?/LWRmKdCIP3eILZ3pr25B7KFPOZk8cRiEB/YhsGcpr7dkaoiOAKsClsJOWU1?=
 =?us-ascii?Q?vmgk9VZrXCwuN0B/nnadEgUJoOO1fWDR3pCJvRZgFgnLwu4Edkhgwg1LxsbP?=
 =?us-ascii?Q?WQo2ITGzxkJK8+QnhlqOUpjJDUtmly2CsaZ9dl2RAiKx/IAyiHfl5AichAuu?=
 =?us-ascii?Q?8WZ2POAuVB1iFtanPtciV/OfOwIAraq6wWy2s9YZ7pVio3RaTMO//CD48tUN?=
 =?us-ascii?Q?yIoxB2wE+0S/OVqVXObDAwzx80mjHHY1sl3lBJUzWj8si8xWDI+T1G5HQzco?=
 =?us-ascii?Q?yhuYs3jwHodO0Egs1Reh8xrViSXOtgqYvGlJu5PF0WkKQXcPf1s4toTPDL5S?=
 =?us-ascii?Q?tE438G8XhhrCL1SbjS79QNWEhmQnvPHrNXuecHkyOxclS5ftqHt5+q4RiVje?=
 =?us-ascii?Q?CXP7tWa0UwlLA+9kKIkPlY5/ZLZJ5UyWudghql0mcPwZ5bOdOl6WqA9J43F9?=
 =?us-ascii?Q?BpJ5KJHZQKCK5AJE/hvG/49yvpRbbAxIJFVcjFUKGhcQYGbyPMewsh8DtV0E?=
 =?us-ascii?Q?FPGud3NLJWtOahjpdIwfTFo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: febab0e5-7542-45e4-a178-08db009dc6cd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:25.0474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lR2ve3vr+tiCpephI7z80is+NijwhaxEcB3TUELbAuH0x7MJAG9LjLwD9+CSPTXtx7Gwl360eLubOnqMUNmWx2C3ox89AptNUCRoKv5r/bs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Felix driver would probe the ports and verify functionality, it
would fail if it hit single port mode that wasn't supported by the driver.

The initial case for the VSC7512 driver will have physical ports that
exist, but aren't supported by the driver implementation. Add the
OCELOT_PORT_MODE_NONE macro to handle this scenario, and allow the Felix
driver to continue with all the ports that are currently functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5
    * No changes

v4
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 11 ++++++++---
 drivers/net/dsa/ocelot/felix.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d3ff6e8a82e9..d4cc9e60f369 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1273,10 +1273,15 @@ static int felix_parse_ports_node(struct felix *felix,
 
 		err = felix_validate_phy_mode(felix, port, phy_mode);
 		if (err < 0) {
-			dev_err(dev, "Unsupported PHY mode %s on port %d\n",
-				phy_modes(phy_mode), port);
+			dev_info(dev, "Unsupported PHY mode %s on port %d\n",
+				 phy_modes(phy_mode), port);
 			of_node_put(child);
-			return err;
+
+			/* Leave port_phy_modes[port] = 0, which is also
+			 * PHY_INTERFACE_MODE_NA. This will perform a
+			 * best-effort to bring up as many ports as possible.
+			 */
+			continue;
 		}
 
 		port_phy_modes[port] = phy_mode;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9e1ae1dde0d9..d5d0b30c0b75 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -7,6 +7,7 @@
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
 #define FELIX_MAC_QUIRKS		OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION
 
+#define OCELOT_PORT_MODE_NONE		0
 #define OCELOT_PORT_MODE_INTERNAL	BIT(0)
 #define OCELOT_PORT_MODE_SGMII		BIT(1)
 #define OCELOT_PORT_MODE_QSGMII		BIT(2)
-- 
2.25.1

