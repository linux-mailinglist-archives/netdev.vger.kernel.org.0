Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7C7665F40
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbjAKPhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbjAKPhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:37:01 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26607193F1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:37:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxixX0gORvq/wSQenz/IKuXB5oZukahYcIKalGyx6rYq6MgO6GPUjSgMFdY4Dd9ZcB/sQBbeyUT8CsqgUID8IzcXetY8g+7EKiTzIBGlWOpstzRL82jz0jlQc44tnXld5uM2WPXYMvxaMkYTcPQa0sW9Lv2AyXm3fl+vwaH/9h4GgwaKBMFOFIIJgueW5RautkQFQMKYnNGIoej3eyg2RUmlZ/3wiuNldP4Wi42oVmWGOZzjp7G1JMfDbyYl7dVgmKA2vj2e5wCnCaiamIM10Zuw2tc/AGWj8WwffRC51vhxpCgbuYFECXlu2WcS0oxgsCmLYEERxJr3+DYFXm2vsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cg0uVqCpb36tO07GP8oAuwT/JfFoWSoHvPz1N/ONoM=;
 b=NlGKpUJ2mnjg5yzsAPMvY0bjX9bU9goh6nogJGM2p32LgGZsGRjdtObhAvAiNqIChp21Er0WT69XGSYFyxW4NjplmQBPLCSIYS75+ZI7PZ2SyhR14+7grstTD863VR+pMwkoiLQ0kmYH954JV5KeLyA28f/vpV9tklKbeKadWOfIVUy5YtFrebFJ71FyWPbTmmP2RnkTIUlO+OquT6d998nMd1AOHK2239tVKK6nrTFuTW5lSUrNXeRpnJMhNQ0ee0JJQwppUu5AJ5J7JXsbFeVa4zWZy+buYDqs/249LlPPxORSpppI7EFWtLV/cgvqu7L7CQ9Vhr3RkYxzAAkPqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cg0uVqCpb36tO07GP8oAuwT/JfFoWSoHvPz1N/ONoM=;
 b=LU+SBDZpglJAcD1hrkRz+PAT1jGlFzWwsyDuFAsyBPxP8UtCsd0AuxXMulskWquSvkiERrD6+RA4CajUssKpAEwJt9ZBn4OUOZESVx1//PKG/KrBL04OKjL9HO8kvJ7Jxd6QDbpVVqn+tq/TC0gAHwGq5WXQ+XFIXSU0923lr6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7219.eurprd04.prod.outlook.com (2603:10a6:20b:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:36:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 15:36:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH ethtool 4/5] netlink: pass the source of statistics for port stats
Date:   Wed, 11 Jan 2023 17:36:37 +0200
Message-Id: <20230111153638.1454687-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
References: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: b13630ff-41db-437a-c9e7-08daf3e9abda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6aKaJ4owzFia/nqjWkxvcREpw2x5Opi0NQkfOLGgsmUMNumoWUTFofnUbfjQaU9AB+T6+sxxSQuCcyJKGzCkKAoRs0b2R0J6FodDSGaXHwmQxZVG8X4L5aFOGrDL+FBkCubCyG2qHAR2kKtGz9fZG4uxk+b/eJujouSqSsu42N7cs+CuZnusxnNPuQGKYvFCQZOaEa75PJj4gMzUgqhl/1qSkTzeaovouhM1kWBRDV1XwkjZcqw++w9qnnrOcznMC0G4202S36XBAbXnb0lId2FPlEOskWHKo/EmNgATFHYQCCmoL7QRzD5RmImbaLjlqPifJ2c3tqdNWP85hYD8QeAYkjjnLa7loVGdyXN+pnSh34rBU5FcnUoZOUKZxl0rzv2EnM4tGpQQh3ifeSHKt/xMEIOqXQkPvSoZvMFBcKFV4rn7tl/Z13dzNxoTUKmsYpiioCMNvFhok0fz7O8qEqGIG/eTZYS7nLowaykQNP5Z7puAH+NjeXc5YVm841Cxbvj5zI5vdATwCoxl+7VeWIq1zh2O9mwm3zuhl0UkWLEDaHaFmT7Bb/z3Awt24CDushaC1ay8y933BKyDy5URUhSuxh1LV+9o0Pe0awxpv5+1dWzF0eparIaEUiQRwNYpylRMVqXYvajtSjY17EcH6dJWo4kRey7/QRMVPURuWnF6pqvIylnA0Cs3L/IusdLS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(44832011)(52116002)(4326008)(316002)(66556008)(8676002)(6916009)(66476007)(66946007)(54906003)(26005)(6512007)(1076003)(38100700002)(2616005)(86362001)(38350700002)(186003)(36756003)(6506007)(6666004)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5rCZY1qT56tvBHA0xLERw2y+y4goFavATSPpuwvWuT/4xjqdYZ5mXPoWmeCE?=
 =?us-ascii?Q?7puGz0SXHRxKJp1Jaz6wD2COU/1aKR36lVvUCLXp7QkxIYspMWrP6I6+CWLo?=
 =?us-ascii?Q?To+PViwmoeAsdegASQ0eUJUUspYyo0CwiU9v0rBl6Zh9L+/WjXFzYwL4szUc?=
 =?us-ascii?Q?YwApv6hfips7+hQp/Nho5lwRr65sO3cdzw9mi4WS2twIUBBCsQkWUGLBINou?=
 =?us-ascii?Q?LmjiI19Kqs2zsVNGOpOehYm5RkYzRY8srqLCeX3ieAZroouHtS2Vd2DxoB+9?=
 =?us-ascii?Q?V/d8LqXIS+ifgibyO1KkbsJmh6ML07oQ4iQseIiry7yYubEitwqd0dkkDRu9?=
 =?us-ascii?Q?4Qe056FOspVjtodghfEkPL1m1pb3QFggdPvTHJJo1si3jAJrCilnhWi9TQJO?=
 =?us-ascii?Q?KXuei/Xn3Izi5weFjy9lkNPyhN/tOWSK0kEHFZJ7IcFR03HKn+3LM4pILD1G?=
 =?us-ascii?Q?JUw7td+qsQ9k5qTPOjIeJYjZDUXahJgjyWw2wK2A0suXrlMwJOPgVovDniYT?=
 =?us-ascii?Q?O2mXEqlT91oEm/RbywjlRMblgWn84lUqu30SomTkLHbp8Jx6At2s6nwgPQ2o?=
 =?us-ascii?Q?Ian5FPERJksDGnPqePEqHUWy+6VmEiEH1WzodSahYNhHk55GU21IhoEbyFsv?=
 =?us-ascii?Q?oDNARzyQX/NJ1G0uhnlSDs6BoR4bfaGB//aPjertUwYJ9BYzcE/i2K/CRaNm?=
 =?us-ascii?Q?kxYHyWHc5mW5GkBuL00MfL4MmzkubvTj3EEzcCtzOjs/QZQz5pP3kU5yQB5x?=
 =?us-ascii?Q?BFLZVzCDJF9yg0ECTEguOHdvMH4SPO99EJSq+Pd6BegSHqcWdb0Fyr4tQsyL?=
 =?us-ascii?Q?++M/xBqcpQCDULF6c2k2/YE3eo69E6YE6axQbCTnkGbfUUd9Uu2a9ZCSeeaW?=
 =?us-ascii?Q?wf3z8A5TqoJ+pKhuriUvbypO3bFybL00R3rjiQWADuoa/iTwjk4EE6MX8XSl?=
 =?us-ascii?Q?qk+Vcs2egPLyhJ2qHby0rzWyioPpalf1RTQtSL3dBm9HI2CxQ5BjsXriLZ8e?=
 =?us-ascii?Q?5Zp8PJvh8IOJhd7PC8Lrl9Gw5/y7einYOX769ceJE4jbU7jfg1rP5O8Tx5yo?=
 =?us-ascii?Q?gQqJjsEjCUCa/M3yauBXiZPmowsOMToOUhRAbM9fjmeKrWQfcaL3aGTfJGyf?=
 =?us-ascii?Q?AMQx9cpYNNOKKnu6iK6G51rFb+28goviAVPZ+rBEJZlB//e/ZVhgKGIHATWa?=
 =?us-ascii?Q?8nRXHoSVOtl/SMPOJ4NLKcPdo9ZwAkt0gqBLLAR+YZ19Vrpcu1Ff8biw4SMm?=
 =?us-ascii?Q?JkscUvVQ00UYu7L8bqMcd36mPmlLaRsF1FteeS83wfC28CVJEjUojl/pliVY?=
 =?us-ascii?Q?PIf9kVDIi/sEGnJYd1IAp6Nl+5f5hGuAvCxkzx89cZ4isEl37jZmGcd54zzV?=
 =?us-ascii?Q?tKBTyrXMDbOFC41T5bI5nS+xgzO0f50qyszxG8UgMLd+8MaZk2WQwHFhhtvf?=
 =?us-ascii?Q?RyNSHxP97G8A+MJyg3HLp+A+UTmdqfZkIh0TAByUxaHLQ0zfRv0Kvi4P5jTr?=
 =?us-ascii?Q?45Me5DuOc5AjKm0uZncuUVfl7JyT+jLNH7u+TvjeLCLcQY5VGXJAvS02r0rJ?=
 =?us-ascii?Q?nviBos1x/3v0n3Wjw2eo+QuLjy1Sq+iOkFq63E178w677xs7/gRn5N1fOxh4?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b13630ff-41db-437a-c9e7-08daf3e9abda
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:36:56.4080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGybWj290qx+wFh6hwx/Jc8L6n5KZq32WySYUFd/VZYoNxTN2mUDTY6Blfw9yyMWgon4SuRGX9PLGLD13Zniiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the ETHTOOL_STATS_SRC_AGGREGATE attribute for the following
structured port groups, to allow looking at eMAC and pMAC counters
individually:

$ ethtool -S eno2 --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 netlink/stats.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/netlink/stats.c b/netlink/stats.c
index 9f609a4ec550..029aad29a135 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -268,6 +268,13 @@ err_free:
 	return ret;
 }
 
+static const struct lookup_entry_u32 stats_src_values[] = {
+	{ .arg = "aggregate",	.val = ETHTOOL_STATS_SRC_AGGREGATE },
+	{ .arg = "emac",	.val = ETHTOOL_STATS_SRC_EMAC },
+	{ .arg = "pmac",	.val = ETHTOOL_STATS_SRC_PMAC },
+	{}
+};
+
 static const struct param_parser stats_params[] = {
 	{
 		.arg		= "--groups",
@@ -283,6 +290,13 @@ static const struct param_parser stats_params[] = {
 		.handler	= stats_parse_all_groups,
 		.alt_group	= 1,
 	},
+	{
+		.arg		= "--src",
+		.type		= ETHTOOL_A_STATS_SRC,
+		.handler	= nl_parse_lookup_u32,
+		.handler_data	= stats_src_values,
+		.min_argc	= 1,
+	},
 	{}
 };
 
-- 
2.34.1

