Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4B5E9740
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiIZAbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiIZAaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:46 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097242315B;
        Sun, 25 Sep 2022 17:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPOayuycVuR4qJWCFLyR2DhPlNGxbNC0yAOlbJzn7EselYLmdb+a2Q7+7iPw1UTR/2QkXYdwAfP5mmexpRWFjP31GvqrMSeQT/FvVisRN3cFYs/ss1NabkOb0z+vsGUHWlqHQ9HHmtb4ivF7Gxb4+y6NXc4iFqR9hEInBdu8QsymB05htFG4WwfxoaPCWWgr61fZIy0fnLPGYgMFvSVcCJulD+8R3owOfTNFdy8PkGbKrKAD62sJ31RNY/jQDdJVTPHd3ltJsFFzHozcvXt/F5dVf1tnq7N+IQnYo5k/Nbuy+8gcZKS3gLL/hEey++wh4fVOtoRQZCLsxLyQieRLbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEnT12yDQn/2CStU+JEIT/KF/tslpV317IZjBR8XkUg=;
 b=e9kUm6aVwmkT9FwXNIqAe3W6GIts26m6mGzAOJ+GHE5cMvOxfRsBam83xuq1jDDNyefCjo3aqmjlyXA1HSeulsp7Tdj0da6ty34Mae3dWax1W73NbbRmTgMc/DC2cOooV4x0upTW/5MhCzigWUbPIlJgj34mD79v92zH7yyDRsPqTePUmGTwjfENKet+Tp4XDhrlZRe2qlca+55lRcxUBVsK8fcD3daKakf7zybEqVwJ75hX0L0uJDJ84oFK8ZAnkuQISl+tKC/he8lPeswJ0P5rz4+hTNPTjES1DgOEvFrGvUVVYW166xYuyTnpBMRJjS3JJ484449jrWbu4Z2ILQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEnT12yDQn/2CStU+JEIT/KF/tslpV317IZjBR8XkUg=;
 b=OWZnBOsdauMEXe5kNJI2is1QQ99a5bSxahhDN/KdtP78/+pRVrxgBLz4Qn1DgnTftGvmUplIozYhYWkMKjF6TjqM/0k9o0r6TjpRECH7WAjOynE4bx47aale2JNWsPF+r9t7poq1+DlofGlGo9VGJU69omNDZyRvi6pFKuPOr8w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 04/14] net: mscc: ocelot: expose vcap_props structure
Date:   Sun, 25 Sep 2022 17:29:18 -0700
Message-Id: <20220926002928.2744638-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f884599-2477-4da1-9f3e-08da9f564add
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzFBDP0Pu2k1fR9UgYV5t4/wIbjYZZI/6sHXzaBocSa+erBILorE3HKj/8ixkfULcCvBngmybrHkLwpbMGBVvrbl3pbK+cfQ65+AmjS7opPUZ14NoU/e6NEue8dRIlbcC6wFcx4YPFSNZX3nhybTgKct+/v+zSZ08F05x+nd1n/uPZ9W692Evyfx4IVp6jUlO6E/iWcEvnYigHo0lQZFRNHy1vVefSdMWhTz2ikIwq8fSLG0ta7hrbmiUQci9opmbKyJKpeR/0WmzTaHYqEEUwZY/CebwxM9ZKpzylMcmIxJNdYG0JmIdn6Q9Zdm4q1o87y3SxX+xB0r4r4gymkqNa31jj8FsvWEhcU8g2vowfFJq3cb9Sn1YksarTIG9N0wJWpwo45Tr0EOQcF7jgoT++SqIt+m5w4GtuH4cB5c2Q2sCJB4sIpxkQAulSu6eTMRIE1feQPKdh3o/tIC4cBRMo3YaW4H0ZFErPi9GFqTo/Y8TX9788jN8JKgdZpifvNB9ijXYvgWMpEFEj4YLgepCCY4ikRC85r4flEmEMbXGTmu42vMjUBByyBwu0M8r8+4YM2eyerpAUhlL42qlS0kdVCp8nH85Rfiz5PxgVKDbsK60aLHxwvl3W6wCQ7KUY7J36Xrt0OhnU2ImyXb5kVj+k0jOsTi7XJ3fXLEQlWZdj9VtC+AA9sofhbx5jBwD+uhG30ygSuUCM2f5rVUwOUrdliqK1MMyXJ20nZN/180YbQ/kLO2JSBQf0UhcPUaFSTXGrwHiRkmMZV4TYtnjZmfOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SJadmQZwkdF+UaIFSP4HEDGKCiJXPWXEuKwtX1NthyFjxsM2ptvpwnDayZNQ?=
 =?us-ascii?Q?E15aKMom/U3s7Msnw07pSHfC6F9iHW3PK4Cj8g9GYgyLuOj9YwA2vRamFzvs?=
 =?us-ascii?Q?3YhrkjJMBi3i8nESya5xYbqjsO6wzjsFCOlMrFmMejMTBla1x8wOewRcl1Z4?=
 =?us-ascii?Q?ykqGujFK22LhXQDCF02oxWUQRUZUJC1WslyoqMtDanf8MvqIBr4UQBTAxfdk?=
 =?us-ascii?Q?aIi0/6ZsxexRsDjo76pXE7kPTdIrY4ievJwbQup1uCVHtoGgDK+6nHn43lRU?=
 =?us-ascii?Q?ll36OnA1jGncIcf4g4NNGb95+TuNHW83QRgy//jV/fQhDMR2o1yQJZawJ8He?=
 =?us-ascii?Q?vAh8af9PRCxykG8BJ8H2CiJveQzAs22GYN9b3Xw9p9XKixrZ7YdpVlYuOV5i?=
 =?us-ascii?Q?B37xkca7B9l6dcihpNotyfW6wnTXgqfhkPHOWTnB7rugtjzI8YrBYxXrrYyT?=
 =?us-ascii?Q?MvSWdOETtpcZ2vQpXvK/9cnobZ1MFWVoEaqtU6rjqbhNi1zeqqypQMeLEFeY?=
 =?us-ascii?Q?gT1y0vY1dwd9CNCJgavpvy3jEpgpvuDhHwaaN2es7ZaomrPCAxah1JofIWBi?=
 =?us-ascii?Q?Un9VcO6PiEjaOlFfB9Hd2RKcbHTD+7tO7AOyG06YGL/DkhYc3X9YGNk90XBl?=
 =?us-ascii?Q?HVmzjki98LSSmYyIMC3GutcV+JmTQNFLLiTBVigjCGfYk1/1pAxRV0aiCmxF?=
 =?us-ascii?Q?TFiltKpY9JX5BOfavWQUT1Yj5hJYudOnBm45BeYyh+mINPEwvQ4ZZ8hrVwDu?=
 =?us-ascii?Q?6+y6ALTmsPdXTQBxwC4lyd5hW8RHGo6ub+oSUoAgkZe1/cQwwu0xTcFY5WTy?=
 =?us-ascii?Q?JCdATkXxIN/mf95pUABs/CP2C4b5dmVXDxW4rhzJK34764l5gFKKEF8Q8tIi?=
 =?us-ascii?Q?VTchedwo87ug/iZKw/vaGIh7zRiOIm4nw6U5AyxCYOTw1Frt4/VhJ31fFXfl?=
 =?us-ascii?Q?OCkAZT1crQZGuise7t/g+W+ujTH47zizLrwEwBsw+K6h8eZC9hn3GsAfs548?=
 =?us-ascii?Q?6vIEAdfh0ipYQAsHg09MVxgogmQC7qYI8xMV1lx/zc7/TgyiICiLEhd3A/8H?=
 =?us-ascii?Q?yq61ouMLniTzPTK3LE1xIPS0V6twGvtnsH1Yc5eJGFJbLRd+qYVZFHN/2cvz?=
 =?us-ascii?Q?6PPksMfu8TqchneQagDPWPz7agHWQVdxtiY9kDhefgE0b6eWQ7kVyuD82zU0?=
 =?us-ascii?Q?koIKfOnHUHkkjv1wDbdP4QULSjxFg1tQdRIFYVtCIqlw8PiyE5UKD9MzjuYQ?=
 =?us-ascii?Q?9fEqrsQK9rw/zYezF/jVniXvn2E6WSbqFdfmChzxZ6G3QEB9/5E1jTzGQNLI?=
 =?us-ascii?Q?nWrWh9pKEV0YrdvBJNkY/z2G6ePWmrzbphzKMR4t81aReb32ua9+rVgSETNQ?=
 =?us-ascii?Q?0vIAOJ2CTzTeybP6pE0sElyXiDthWcrtpW0jwOpxnrTc0dQERrJheC12TLIc?=
 =?us-ascii?Q?XOj29HKRWDPXtwewErKq95iwxI8BGQuIBN/hFegwA+VFfiEA3ogPK3SsXBNO?=
 =?us-ascii?Q?+pqWKVlBnDvtVnfRBWyliv1YyQmvrgA8uItff0um1O/Aq8plD4wdHUzwOSiW?=
 =?us-ascii?Q?q+nOQ+FZ+KaVncXKErcUHqWKyPKo72Qi7MikidqIpA9vpe0MHse612rs7dnz?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f884599-2477-4da1-9f3e-08da9f564add
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:20.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxc8GQxzQozIqtBrBbs9AuFSD7xCef9l3VR/pExPryucjKTQRE9txYiGTYoI+ftIXNBBjnTEjjuqsrBTpqsahCDHi7ayWLeQU3CMNqeomnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vcap_props structure is common to other devices, specifically the
VSC7512 chip that can only be controlled externally. Export this structure
so it doesn't need to be recreated.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 - v3 from previous RFC:
    * No changes

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 43 ---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 44 ++++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  1 +
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4fb525f071ac..19e5486d1dbd 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -181,49 +181,6 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static struct vcap_props vsc7514_vcap_props[] = {
-	[VCAP_ES0] = {
-		.action_type_width = 0,
-		.action_table = {
-			[ES0_ACTION_TYPE_NORMAL] = {
-				.width = 73, /* HIT_STICKY not included */
-				.count = 1,
-			},
-		},
-		.target = S0,
-		.keys = vsc7514_vcap_es0_keys,
-		.actions = vsc7514_vcap_es0_actions,
-	},
-	[VCAP_IS1] = {
-		.action_type_width = 0,
-		.action_table = {
-			[IS1_ACTION_TYPE_NORMAL] = {
-				.width = 78, /* HIT_STICKY not included */
-				.count = 4,
-			},
-		},
-		.target = S1,
-		.keys = vsc7514_vcap_is1_keys,
-		.actions = vsc7514_vcap_is1_actions,
-	},
-	[VCAP_IS2] = {
-		.action_type_width = 1,
-		.action_table = {
-			[IS2_ACTION_TYPE_NORMAL] = {
-				.width = 49,
-				.count = 2
-			},
-			[IS2_ACTION_TYPE_SMAC_SIP] = {
-				.width = 6,
-				.count = 4
-			},
-		},
-		.target = S2,
-		.keys = vsc7514_vcap_is2_keys,
-		.actions = vsc7514_vcap_is2_actions,
-	},
-};
-
 static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ocelot ptp",
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index d665522e18c6..c943da4dd1f1 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -644,3 +644,47 @@ const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
 };
 EXPORT_SYMBOL(vsc7514_vcap_is2_actions);
+
+struct vcap_props vsc7514_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73, /* HIT_STICKY not included */
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78, /* HIT_STICKY not included */
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+EXPORT_SYMBOL(vsc7514_vcap_props);
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index d2b5b6b86aff..a939849efd91 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -12,6 +12,7 @@
 #include <soc/mscc/ocelot_vcap.h>
 
 extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+extern struct vcap_props vsc7514_vcap_props[];
 
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
-- 
2.25.1

