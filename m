Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DE9279B69
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgIZRbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:51 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:61761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbgIZRbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9TuVO+5bdRr34PkCOGv5BP5SAeJlASQHcIYh/21grjmt7nleAnHIqJGWCLmypcO/BiQo8wP65a0lZaUK7pAZCS2bISvarkk92UOxi7I2PFtz1eq7pkM7LBp8S5+y4vsIFxT0jQxGgtHzoZih/JPKmR319XickGbT+cd/PYs1NE43aH/8SPomswRtGcFbkbKi02FAfoUdlBwhBniSlpAdIfJQV3vadr2jKIwwyYWpUJDPK6r+MIjGPQ4A4RYUULKof3PuhqCQdX8Z9yGsXP501t+CmsRL8WT8cqqsqCBjQ3pg7Z09smgrs41A+Ztw7lpXaNg4D0wwFPM5Far7CSUDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p85U8NFjot5CTcglPQG6P8UQPpIUsIhxxAZXjwfOfN8=;
 b=AfyavqSRrMfT9NvPfg34XPvLifgyVVcVFhqQ0nq8LESJUKpAByCogt0CqITQ+FrdFbND1HC60ccotuXvD6JIsmiDSu+pNJhdFDTCfrknJQGEl3RCDwxWBONK7fY1VdLfYbBvQmODDxOTDkYhylTtNhPTGxaMt/BVC9DAPNwuytQksZSKjjD9X1qSyaVNsMya6IfDCt0FJx/msr0jC9c2Laet9acESweJA/5omWapqowWxwNBcSHCbA5ohhJqNGsrjk00KM6C3KggBM38koG6Cfhb92QZ9PexsWjVgAwBwkVzMDPLh7RR2HcB4YZprJ27rjKDYeSWc1UEnaari1tfgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p85U8NFjot5CTcglPQG6P8UQPpIUsIhxxAZXjwfOfN8=;
 b=JCoknyc9J3/LwNEeqxuB6EYkEMV6BQ9eEvwEenbFG+VdUeiP7ymynMA9OGKzLMdhmpUFLnLhLP4FmEm30/bcLWDxHGqwund5U9s2vj3TgL52Q0+IRsegeZbkNMxMwgwdocDRLuJZrOGjab4/UJ5ewlEzZ0UlqkJfN2BrbSU1UMc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:33 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 13/16] net: dsa: tag_ocelot: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:05 +0300
Message-Id: <20200926173108.1230014-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:32 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2952d994-84e3-466a-9f9a-08d862420318
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4813EDAB27D2E46B77488DD7E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jyeWMCUoKAMb49wD2aSAJvGBgJIB3btwc8DmPoYQh61olgkYd3Eg2Kov6R+4UiA5arcqe7s3Jabuojs4BEWQf/9LrlQ+s61PcaQkAceN74OmtwatKinP5WAoFWXmhve4OEUqLOngVYA8invILPa4Z0y/8VocgbehPaqjq/FOV3h3+UzZJR3nnfuvmD+Sn2mVCSn5vcabZMofnXVpeoMS/+8XEFaNMjQKPrQsPPjOBp2kUkCk3rlC4peh24Ih1CzWnbrstvcZ8flDQfkY2+h1ek++p9QaWKGUHIiYhnOTCDrv7DTYMLHYtyhIaZND0x+olZNTWAJwddNL03oRoobvpvji0Q6FRKTek6nimgX8XzOtvBKl70EoKcNNvgdPRG6f9lW4t/GY4KplPrWUe8zS/GBYbc2vvGvT1JTwJdA+WHKhOu2+xzC5YNo1E7c3vmtjiPpcIoeFLpuRRcUUJexW/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(4744005)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KmGt1o2HTWAYFoV8jJ240IJcueZJvauJX+HybMgEAqTQiLCsJe5FFG5UsjECU9ai8JNpoT8g/U+Z8J4GFhpoVG0s8w3y60IP6XINGNl5BXyvkBCfODSsQb2JOtv+qMFLIirfAAvdrlnVkAgPD9WF+EkbJQruP+Ueyz4OKi0TUGzQHaXuj75nz8INz1lf9pFYdV/qHRgzIJbDyjQzwJWkuZVx8Rhav6h7A/BCod39O6qACREAOgq9yfmJ1wV/5eMS29jbsEKgCkC0XD3TTxYnIAGOFCaJ7vAvaiOyiwKYyB1a+mC77ks27Un407p43rVOLp6HK0BRaAyv2zKysXWwIK8HN4tVWg8rckXSNPY7VwLe4nZZq+AO+vFSKBe6A4aSkeG+sloeNRqIbFR50GDiE1j6H+r0bu3xjMFdQSWG5iwruf2iS05UhFfokxnBx+brkK+MZ5k/Rc7BOr8YEMbMdF01DZky8XR03RXF+EuaK01I33TqsoYBGipLd3+B7PeakZ3+b0tZ9AnRGOPaeJbU3UPmywtm//j83HIJs14ksuIpjSQkeb2GCWMdqmRj4VxUuy6Vt4JfydfCRsFSB6kd291u5c55rYv5zuVNcjKMAkc0YLb5DpcEH1ClqudxP/w/GID0uQoKlP+2PCc91ee6pQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2952d994-84e3-466a-9f9a-08d862420318
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:33.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjVzdqp4NYwBp0itnrY8CQCGuA9JUeAGmn3NmysnA0gyi2sKCgg/tavyJ+UKUTT+MymJfOf+/329H7kpPUyKKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches put their DSA tag before the Ethernet header, so they
shift the other headers and need to call the generic flow dissector
procedure. Do this now, once we've made the injection and the extraction
header use the same length prefixes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index fb6d006eb986..5ee81b535357 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -237,6 +237,7 @@ static const struct dsa_device_ops ocelot_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= OCELOT_TOTAL_TAG_LEN,
+	.flow_dissect		= dsa_tag_generic_flow_dissect,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

