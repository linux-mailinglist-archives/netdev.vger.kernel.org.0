Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E030B5B510D
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIKUD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIKUDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454FE27DD9;
        Sun, 11 Sep 2022 13:03:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSIIW15Be6C9yxHYs010WpYsLzk6Y50d51VpgqDodT+ayO5RHoQ4XRYgKk59WQOVg6zJJ0aESV1YoKP9YTs0RpmVkeEf5qad6E7GEqMnsH+/r6mNTRx4UzqxzhZezWKCUR32M8TUDz2qVkfTpz9w4QNQc3xDrmE/uzCg3+hMG+GCv3/zVER9UQ4iiunFXBgkmbwDpKShh9CxxCR8QIQb5ZCg+9q6mDf4osEq0ACYSb50nRuj3zI+XEnIaVEaEus17qopB89vrkxbLStvuUkXvGu6Xr7QOXiu5gd1eoZWrfdWmIuh1/9R9+hBJkd711BirdxvKq8S4EK4UYW4kyjbQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5az35p9O8xlhDt6pRnLRlMQ1zJXMFlctQDBw2XWpiw=;
 b=ewS0d4MFraBGvamYrVZFuMdiU/j82Xq/5s3ONbYQLYSTQn2KBTfiLo2G1LUqPKrmzR5zMbi/TzuszpbwpSzc076Hge4nT6qly5vThmgTSt2i4LhqKxKpJ9c49VLAWwc6MY6bzlezgsA4dpn0vgutzCm/bXU5wvu7AZn6+SF0pXl/ybBNiPgel87I4N6E9MjMlchp45htPCfHJUGGZID5DpWeMkgZY0hM9iNs+4gg5/b6RemZflPDzUd5nzzWRqDL3RoGt8MWG1KYeBP1raVzhsagmH9G0hWhMe0cQMafVDM0rRavy0cdgvxPZm/0q2vs4VD4f0Jnz33zUk3YLeD5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5az35p9O8xlhDt6pRnLRlMQ1zJXMFlctQDBw2XWpiw=;
 b=Ow8Xtn3kKw4Ky607q0Jyw0bJ2Uo9auMpz6D5HmJ9SD1wpU8r1R3cY5LRdkj7eIqdQ3sEtI5GWl5+QJHY7OSVEmxq8OpLwVPuhtoVALJfoJ8zjSC8/aS5NQFnqeIzORC9XRcg3tR5UorajTGvfupEvVdkSDBCx8iBP+sG2cLBuMY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:57 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 4/8] net: mscc: ocelot: expose vcap_props structure
Date:   Sun, 11 Sep 2022 13:02:40 -0700
Message-Id: <20220911200244.549029-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2806812-e9dc-4b76-d0b0-08da94309e77
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+gBskCqe7dR7DdAl16CLufoSmz6FQHnS0PzpYDEnlFek0w+cFYnnjqBh8L1F5LFOfl0uUFW74Tmuiao+FTw+sE24uiEj2n1tvxe1bM3OTBXUbCDBzzd8PyW3X0etHzgStcdpXsZEsrHeYp99Gp/hUmjZpQ8Fg4anhHSn8ausWIxEqlm5qnxXkowczUFx+YA4Xs3F30xuBW/bcnnANdH3YSZD7YfC6szS+gqvrhnCK0O5Kn672M4tiz/p4P1SqNbJAFue14nTpAXMBsCz0fKDqW12NKjQTFzilAMtzjbqluVKy67FIzF9/W3ddx7ibh9C1iyfnWpvqpFr1hxYzAhOA8e+S7ubDApHYoXueJnK3Kn14o6WL7C/Y3X4Dt7CYKSe8QArwGIoUkm8WyzIni8etXfISy97+hts8qvIrIy/+kk2tXf8zwU4SS1huQtJPLwJjPmfOIIwj2bocGPYL2GM6TSYhYClvuc1foYcODsH3A+6VrYdntejrQJOdIG4DJI+v7cvo2X58KSKtYXDvYjiecSsKSTBwB0dM0FCPCbhZrXOWgqir08HRUnDbtFlouZVFPd4ynisOtWHZOwpZZTLEI5HSYgsNEhDSZQv0ZtITySsv8xC8xQWfCuGra1XvoS1L4FsibWtP3exfYvOhFRes2IDfqYdyQuVamOR5Jk2p/SS0QzlrrLDDBAOQ8OqUaOcZT6atSwDCg8HF4VUUcJHNJ01MnEza9t3YCThISPHOA5+s1Y/MDeXNop05nGdaWr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6CDSSHnMbf1ujOuK15oZYIwt7A5XafJp53Wbeoke1eAMRS+44qVUAneLOF6?=
 =?us-ascii?Q?3c7lDUSkmqyLGoQYjvs0aPlK6IV+HPBAayMBRGBMc9VTshyBnrtdOlPdqgMg?=
 =?us-ascii?Q?g8P9oza7jZx4l4z5FEKGfry65uDtDDDkvxiAWkA2xjsGv6uhvk8AMUFmQJ7h?=
 =?us-ascii?Q?932K1LGHHgwYlXWHYeUqgvBwmgsBUyWoTGVg+yo5yswkAYD1V7RoRotfL7SD?=
 =?us-ascii?Q?uKzsxwyWPStqnOpFls3ALe738lTPGhKImNQrjqBi0I1rjVkKHtZh+o0GM13c?=
 =?us-ascii?Q?bMPepKFVPY63YTu0/0bK9A9rTTUA0EPr6Ct2THYZ/Z52RBamieI0AQcXzy38?=
 =?us-ascii?Q?0xe0NTnlbQx6g/FyavNpVhNPIEdJk9afDSQvz4dBsv3P0HCN21A39qSxdCwo?=
 =?us-ascii?Q?XmP2sCMSS/xz62MWadpvcMc3L6GfjMlf+SNe5s0fycpyN27N5qweTCp6WVVf?=
 =?us-ascii?Q?J3N1kUJ1NF+SBPG8XSC2UYT6+MfwwVawFNc7bUvHAfd2OOvkN19l01infYtI?=
 =?us-ascii?Q?0WeSLnRPUHk6JGLf6fDtDT2kE7EOM+9BYqMgbgW4clcmwo/n9D1FTRuYN3Qu?=
 =?us-ascii?Q?2Pho6yCk3k810mqcI/yG7+hd4EH6+42qV0yFYaFL70wrnXVLKzJffKqWukCU?=
 =?us-ascii?Q?CrSyEN0MjPPEg49TGt2KZHuyXnnEvCkvHMh4h3/5iYjBgPY/6uOQTCyHeppT?=
 =?us-ascii?Q?yB2HH5L3rtQQOdB4xaVJRq0wQeJUsp/xPoUytDSS1TPQdEwOkYpNJWqeaiO+?=
 =?us-ascii?Q?TtB4h5Z1fNKA3WufXx9V3UT21fWF16Go1BXVoDStz+UtGvbYHatziS3IKx/0?=
 =?us-ascii?Q?VV7ja1EZX2m5omGkSd+elOcUlecnr3MtqSKfXwj8k+yQzguVqo5u4RWZwWOb?=
 =?us-ascii?Q?SR1M0udSpbWI0GY/TC87CtMgdgHAxBtiWN/UfFUFWL4AInlggHufI+yRGs7I?=
 =?us-ascii?Q?VvwUs2cvXqsH5HJGPWF7YQAc+J2HDCkWX5R3e+eOJYs9ts+5nVDLWQ9Pa91d?=
 =?us-ascii?Q?gZdhfRuf9n2PYGzSVw3D8Ay9ueZJlhWD1GLIOIbfqhAz0TB8qWbH5gsVsCXe?=
 =?us-ascii?Q?jcxP/MbF7AXpyNC1WbBk7PT5u/bZx7M7J2mOxUU89nyEwqljABsSu2x2WTus?=
 =?us-ascii?Q?as86x34NcXngZpI808NjfYUCMChmMCptB+GP3tSaH7fulLABABBZP0wF5QRE?=
 =?us-ascii?Q?0WCpxCLpbQ9jJznw2X6Kup0Hf4uskPOtqP46ELE28wnR0UMqQz5FQZAEzqCA?=
 =?us-ascii?Q?TI66UAKd6V5gy5CdRSY+Eev1q6jzNpjYe1OKRJg7WL+obMY8Ox4ebuc6kxho?=
 =?us-ascii?Q?EEP4Lfm/h0TsEyNoHLbfbRBCLKodfoP7XKpk2xBc7ERjLGAf+jc5fXAnKNJ9?=
 =?us-ascii?Q?a6pkxLajhWPJr/HdFQecAL2jUwee0nyjCCADvLOdoLOY+RRbkS/opk7LsoZ0?=
 =?us-ascii?Q?bRal7sb8Ge8GFZISqp47HlMATxHsWuNbVfl+gZjnt3u2Coyyen2QbCbZalMj?=
 =?us-ascii?Q?83CUPUsAiEWEH9sJJdYB9sku++CIWaSW0fmNtiZAP31txsoHvg9u5SgedCl8?=
 =?us-ascii?Q?qojQpkhrZaHNqLYWBab17EUE6GGyMsOHajeK0fBJKNk4N+1soedk1SXFCtVm?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2806812-e9dc-4b76-d0b0-08da94309e77
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:56.5746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oCn5O154zSmhmo0AlBbO9CEsUBnR1O57W8I36u5A0e5fwipZAn5O2gKtyFSRJzUsd3F9/4kqj2ry0vVe4OpD63b8ZZ1ei70WqObvrHTjSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v1 from previous RFC:
    * No changes

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 43 ---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 44 ++++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  1 +
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 7673ed76358b..6191bca7a9c4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -161,49 +161,6 @@ static const struct ocelot_ops ocelot_ops = {
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

