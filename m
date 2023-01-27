Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5929D67EE3A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjA0Tgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjA0TgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8929F7909B;
        Fri, 27 Jan 2023 11:36:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3hnszXQPeBvqbHjAwNyZRcl/lJvO0C2DYr07KJduaT0/vBEWBhd3cLASFEEDROW17tAcW55BgoopAsqGRBuTp/P56wUKlD8RAglaRV5ciAXiHPEFmBpl/Nmn1sWYk6tSFekDHYE1oHNYGpyJhwbZcj+XL4g3IcJOB8Jd5drWSfBPnzuwszxsGRiQiz1raSBrrSD5+hU94gRu2FnZZfIdkLF9+IpfBEfxCTzq1zSiXKjQ38iQy7s3+vmOs8oQKHrQtDj5Kl9/PWEXp4+BEd1omNRf1Byi+htYejDVLVuJMyt7Yq1eO7YQmGHsyVcQXoumjkjij2ozStvW3H5H6PKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgF4meZtVzUEh61zhvnHHXuN62U5ooTTV9C+9aRwJO8=;
 b=dRCRP1KRyOabrErjK2wBhgXiyW4IE6S4C67PCYtP0maFjT/TNfTTGalS8DWaIY+XkPuUX1iuNZBGpmV7/9NCe3AJzynWdp6qXmwMWrHzSoGmOannAU4+VWNSgQezQXBYIb4e+CYTa9fWp63B3BjYl+dMp8tnWLkLXeaSfWifeYuYTqL60wRHujeIHmAVDIsUI34IMno3oyntyyQekeb4o7WMbjQO4wlh18FVxhusRI1KCzSZH0bUDaOuF0QSni69Nhzhfx2rMunaNgQw2m/aFvDxQ+y4vbcP+OAC0MkYqWMw4Y2Fzy5cXD9wbk2YEpzXInzji7HTC2E6CEmU8kHtkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgF4meZtVzUEh61zhvnHHXuN62U5ooTTV9C+9aRwJO8=;
 b=QO2Y2Tp9NITJqHQuTbXqd6sZfbVREv3RpPw1tk19YvMwPXjm/tD3ODthgNO0a0Uk0K2S6ygn6xebyb6b0Vp07h2SunHaxMC8CHC4p1Gfzqr6tk/Aev8QtnF6qh2haR9pcM/NMbhhA6diM200iP2+9QeTt31EhooC6s7E9L1vrDE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:16 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:16 +0000
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
Subject: [PATCH v5 net-next 03/13] net: mscc: ocelot: expose vcap_props structure
Date:   Fri, 27 Jan 2023 11:35:49 -0800
Message-Id: <20230127193559.1001051-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 306231f9-6025-4043-f620-08db009dc179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOOLbCSa2ColzbKqe+mkH6rnTwQAQF6Pq2n4/KBAmuPp8BlLCOui+qg36S3kWokw4j0qKMqZi7P3znj9vbaokY1AswnnJK90TN3QNM1v0EuWWoXrICPeEiGv4iq7OMJvnChHK0v2Pn9hqXEgox/bX0kltLWbN57V5nWilF7QESmnQHFSUwzkF9B/9fPmG6U2eXH0G5mTzhALQQbDN3kek8PT4J1BptYRTu79cclDqp5Kng8ukE+CBL5mkeimWwtH9TgWVptRPcB2yLfkz2++EJtGZHTFX3eIUaIvjBwZsg4W5ktLBLCvVOGpEB0JdQK/Lsz4OVEbSwaZiYzrSzEfj7AcAGM4+dLawjorC4PbFYqO1SKufwRxGV8w/gUV/Oza6BKiBTwZGKv5MfMneFVsfinDHLPZ2yRXmV6oP/BZMlTNAAm5AjcKW/1Asacyvjo/eYNMoQdECcOURDw/D4+xFpuXHnNTO26S5g6+miT6mERksIBfM2nyFX4VgO8XXj+ZSTxg7KVVQUrlBD+dvInpBN9bXoZU141uOc8O/w3AKI+86jrxzOUpHfFomiQ16zpIkV1rk+xnfyNOR58XGvWr7Ulhh9E7V3WwI5HPIWbfahNlZy9Agun/lijWUh4akbZ/Pujyt6Fdg2NOK6yuVTT3TjSvmlo2Z6x3VKwC1f37uuEWrmRDpNYFYbm7dcBNDjG8QoAfHEzjjRsphfXonDp/gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fwB1R71LoT0r49dy1V1O7zl+qpP/nzNDfGm38rwhfNrljZQ44PvO/fGKw4rD?=
 =?us-ascii?Q?eC+GM7AlPNOazXlDQ87CcFL5ndcgW+IaJM5WGiGe+pFd5oiC+pe0ACdWutq7?=
 =?us-ascii?Q?UswZf/F3yp+IeOcBUkgL5RC3n93XkHdT6o5jEFtv4Z1g5mO8aoJ7ZGWC4Wix?=
 =?us-ascii?Q?oDdIVxI7CSJTuYr4rAmjRE5VICdPeYEomuMkWLF0wh/tb/E1YTGLAHhbn9vP?=
 =?us-ascii?Q?zxPbLi2w8q5dvnPx5RQIbgFrN1kTVUXXN0a58sSDQHT8g9FPCZFPWHMBNs2N?=
 =?us-ascii?Q?7l5KKOXDLsxaLXqUXdtkGoJZZp5yC9CLaxQBHUBpvzluHIowVlDqjm1kE4EI?=
 =?us-ascii?Q?scVeHUvyv/Xq5sMXe4Tc/L+mMXaH9QudX0CuAzd3CKnB5GcMczjhG4fA0MsI?=
 =?us-ascii?Q?Gq08UELtXTLZiGoU81EaTaybKrzo2vMjBDrZh5IueV3scFN4XeOhzRvtW9Cg?=
 =?us-ascii?Q?YW58RLjplHvUTlZK6gebAr4LVlBCVrOWOjocDTzx7ClBo3JUhuL9+wKEqMoi?=
 =?us-ascii?Q?MOZYN8rx9tqXUDHIbipWrnK3T3CNn9c1mnrlQIEd8mjkh8nJshCoMXv5XEjO?=
 =?us-ascii?Q?8spQp6w9+9v14ORt3kXH91FaXyaWhZETF+5NAzj9uLwRlyUcGpN/5KjIkoZZ?=
 =?us-ascii?Q?DTPNbecgnroGsaCJS8vio0AEEg66J22+XtNArftLhg2MowE5w/uvMUPoz1hM?=
 =?us-ascii?Q?Z94c6c/KRGk0TKpVhkM+fKa2+svUQzHwFf5avEvgb1o6tH9j11Hx4jaQv2WG?=
 =?us-ascii?Q?KnoeefObQnqe/YhaCorY6qWl/Vv1aY4GkrrmpPt2NKW/9lfHfBRAelzzWQ72?=
 =?us-ascii?Q?++sUqD7j+9u40OARLCESfrMU6ZcKrfwIv97QwfVJchLYA6XBLjHXFzEyGD5d?=
 =?us-ascii?Q?SnS91Eu03sGoagcTzRIalKBaulAZW05Ol4zYOrJNQiPgUNlCs89va5bBsu88?=
 =?us-ascii?Q?2OQjkgKCAqjl16qcRoJZa15U79ytMcWG1gZ6/T4kHuwoJEXsDCYHpsRruy9W?=
 =?us-ascii?Q?UqCFUwntmqCoIAOwN1sLeAvOK2Iu82+ZcyhXlflLvjBTSAcSwsrSfy9TFttS?=
 =?us-ascii?Q?bHfQFa7+iu1rKpUvPb4H60KJ9t0Ay6COgjSTtE5chDanujdSTmp40U+KKhKM?=
 =?us-ascii?Q?ChgaB59QQrON1rfAf1iVDwufqksek8KKsQHseGQWMfp3mE5oCqF+9k8M4mTM?=
 =?us-ascii?Q?gkg1oOnEAi7lSWbm5H5euMRqK+bW6iCEquEZ6spTshFxwziRFaoykcuOCZx1?=
 =?us-ascii?Q?3EV/leoeh90ES5sUDr5XUOB107T7rVxj8WKvDsTc+4QC+bPgCc39ZUjenvHS?=
 =?us-ascii?Q?t59YPb40rPRyhQIfIGjjLn1hXnRFFjaKU2/eeb7WEYoCJTS0nFHl8M/mwrFt?=
 =?us-ascii?Q?MaRQh5dElzAIQT1VburtmfbBqs0K5aVXeoLUEqIkRXCRIvLxSWq+fa8KKu/D?=
 =?us-ascii?Q?6IzQxdBpYmXl8/0m7DgA5DLW0ih0BtUDbCV8MldI0NGGXmpfOJiyybqdyKcF?=
 =?us-ascii?Q?XLGoE6fFxsHd3AzXe9EFR+ZSkMRP2B6G/Vtz000Bnaq0spW/oDdZuL4mEO+B?=
 =?us-ascii?Q?YEdZwBc75fgHIScYpmGB+2/x4uV/AtWQagRSfXpjbjK8FC/3Ho7TIlhiLrPF?=
 =?us-ascii?Q?bnKGJEThddhLIXGXH9R/zl8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306231f9-6025-4043-f620-08db009dc179
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:16.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BeBpkN/n8NoRIrrlB7OMV5XRi5dDGAryCztMdpzOpQf63jcS4yigPiKxZh+Q2zHPeBTGA1ZbHB4s/tEnzy4F1IILJiVjhkmiVLEFXilK1Bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
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

v1 - v5 from previous RFC:
    * No changes

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 43 ---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 44 ++++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  2 +
 3 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 8a90b5e8c8fa..381d099f41b1 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -180,49 +180,6 @@ static const struct ocelot_ops ocelot_ops = {
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
index 123175618251..c3ad01722829 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -639,3 +639,47 @@ const struct vcap_field vsc7514_vcap_is2_actions[] = {
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
index 9b40e7d00ec5..8cfbc7ec07f8 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -10,6 +10,8 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 
+extern struct vcap_props vsc7514_vcap_props[];
+
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
 extern const u32 vsc7514_ana_regmap[];
-- 
2.25.1

