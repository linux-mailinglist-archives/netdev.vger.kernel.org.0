Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73015156D7
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbiD2VeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbiD2VeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:34:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2123.outbound.protection.outlook.com [40.107.237.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0663EF10;
        Fri, 29 Apr 2022 14:30:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxWbmcWkFDvNAh/BNzQq9aOK2unNky1gUuwT26iQUwCq/IWkAFpL83GdzfB/lxROZnuGNv2gL8IpyMQBYPpB0oZKTnPDu1TBVxePVX8nN8TxGpp1dF80naaa+PUde4fD4RyLc6ozU/17RRZJ0u4OWOS2pvb6Duir+SuN8zWlorgDRShgitCEOWTnvXAQTzH+r+H9cOB+BWRjjktXvNLluMVm8WFH2k4p2V9P9rDK9GW+yPdM3EJoIc5DjWmAvRXqCpC730mUeQHQj5qOJo9CkdQJVKworyMoDHsxA4aESPMUAMAz04ehOjiZqcjX15J8YH8aVw7qQQ0GpqHihw4Wlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XquYO7z9tUXCpmQv6JraXuf+y1vEJEElockqXKgFvYg=;
 b=jBLf6qGYurZZa5sdJVg7xIrUrp6SQwWvY8vINETtB/nCXlV9MgHWHc7til51jb7ra+Z0vcUyQc0HrmXXDg2Br9VDbyzOujqvEamjSixi7Qs7DQDfyuKMlWYNvaEUSNM26H5ccMSbtvspMfaVskHSUC3jcUWvwE6zOnpxHV+dHaxlk4EebLmSxF7aF0HjXE45BK2BetWjzDgIms/tpLlDJcBLN1ZYhkanyTGlueFbz98n+pCcKuUWxciQuWEc2ggY+Aq1Yc7fip0kRsCFb7F8MsTSkp+kG2dc1oUoD052kwbv7Lx0tr43mzgbOUfUyjMVfuzM/cc2pEFJjB6NV8yR+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XquYO7z9tUXCpmQv6JraXuf+y1vEJEElockqXKgFvYg=;
 b=DdEo8qz9+KgExPXfPEkuOTHHRP7fHxKv/Tm0/MfVYFWa8MbguryXUYlyto2iS+98Pwc7dTvhoTosaSApt8PQcZvr8x8hsq7Rr3/pjMzWjwC1lu479PAn+vl1kjhZg970xBWFC5fXxVUT/oOHFHzc+Sn4QGHa6gVBG0RPc6BvChg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1957.namprd10.prod.outlook.com
 (2603:10b6:903:127::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 21:30:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 21:30:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     aolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need for num_stats initializer
Date:   Fri, 29 Apr 2022 14:30:36 -0700
Message-Id: <20220429213036.3482333-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429213036.3482333-1-colin.foster@in-advantage.com>
References: <20220429213036.3482333-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23c4042e-4b37-446c-ab1a-08da2a2787c5
X-MS-TrafficTypeDiagnostic: CY4PR10MB1957:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB195733256A73CF87759C5D77A4FC9@CY4PR10MB1957.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zb8HNw1Jgo3JItj2Mu/A6ZdeCkWkaoipw3mgNmizgZXd9EUVEkqAtee3PVV/gBAraUQ9v+CXDt8HSknAdYWK0RZvu2y1PQV6y9yRx9s+sPUaE/ISwP2sASVWwJbklTycIEn+FPXZ4yVyPVpvCOvpbc5cIZyvd1pj0tMob8xbA89bMorLqLoSPDic2EF9HHj6oxzpfJZoBqhHUH3dOXzA0NmmC0t1tzNslCRv0aiDwSQaHpNGFiC/hHiPBoBgdT+wBti79DemwYb0YlkeW8Xfsq9Buo8xxFyUzO8X1Rb5oeOoJev2C55AgADnyz16km0e8smyOLR7gl9zFiFBHnboEWkb72Zk1AzNeZLH8nQt8hfHN3y/sf96cB+nzCGayVdo9Z9vkwAdB++oN938AuMzRZtpjm4a6RErXKslOemxqnL7thauvqPqQhlWjcsDTyTlWmbjPAumJTFuzexRh0sdjzuW2DuHA/pCNs1ZOX5eNzrH+5r/Yj7iaMJph/yXZiHD1Z0kMqwb5MrWmHtuBQdMedvnVEvDCohg+PJL8EsBXqYE3FjpIIH8EESIwRwp5loFq3V1dJmXmf3Hwq8Zbf6Z8QW1sFJ2mQfXrYoL+SXlcMTeGPaVphARQvwzxe8ZrdgorqMMlBr9/GkDYXketpxIqrELECX3yhXthSGuGDN40elYxWirjCKrZjF8hbRdItgBOb467yQjBIQBIvFIRhFTvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(39830400003)(396003)(136003)(346002)(86362001)(6486002)(54906003)(2616005)(1076003)(186003)(508600001)(8936002)(36756003)(44832011)(2906002)(7416002)(83380400001)(66946007)(8676002)(5660300002)(4326008)(66556008)(66476007)(26005)(6512007)(6506007)(6666004)(316002)(52116002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UQEXs6iPArRiv/nxmjQ+YV/0htrewGW9ZJj8RTajnawS4sPtYFCBlAAXUZVq?=
 =?us-ascii?Q?LYvQe50nxpEXtlv7fAKRwys6IznsPvgJIs5wkLW7GiDAYgtzlV3jzu/dCYiK?=
 =?us-ascii?Q?dXINhGN/3N4NOnZH0XIzOU+i89i4fLFczjFd/6c4+EbJ+AcNUwRti6w9ZbnN?=
 =?us-ascii?Q?Cuniq8aFM1jV/71S7sW7FmMgvzRW+wd7aOLSBdM2Zcr1vv4XfIEaoktTF0lH?=
 =?us-ascii?Q?krIh73NZmH7ofVPJfvzoar+ryaqts6n/KuQqnaUd/hzdfqf6VczO0kUREKno?=
 =?us-ascii?Q?29WrobbYn5R4gQnjuydPifXd195ew2UfDfp3e7Zi7/vK8smwd0Q/fxZfv470?=
 =?us-ascii?Q?oDP2uvgTAVVmq7UdaoIwxOuGDV6d/4l/Bzuo/0SlbczEmldkkYwSVkMpwb41?=
 =?us-ascii?Q?3GsgcRIbbiPrD57IUxNX/36UbUUYYIFrH64rjW+ZPLEWbCvvYvmk0rcLbreG?=
 =?us-ascii?Q?/2gURFLH2W7BmM5FIwEXz6V0H7fU5HrvZ4e+JP5zkKIGI6AGX684PE13s580?=
 =?us-ascii?Q?vcWM1oUXPXqamiDnsBzm5adYxOJss6UoklFF2OLML3E5bfih0+bWBfVrhb8T?=
 =?us-ascii?Q?wRA5BaCAeKeo9J3tmECZGYLHu+JsUvqW6WyeokRsgrEv64F6goqX4Zslu3Dn?=
 =?us-ascii?Q?wiaoYUhYL0CY0LLV1MLHGVbKKzJbn9yC62jSHqK3Bpf2yUVeP5SSN3BRaCnV?=
 =?us-ascii?Q?JmOfL/eCHXcAwDU6z6XNkVLOn7I2xC0tl7l9bEK5pCwzX45kaKSyjOS6EswU?=
 =?us-ascii?Q?mrzPdvIYjVtDIQoQu2D3G1kbDXcx8eMS4YxcqpwmywTepwXJs7fgKyFfGhyz?=
 =?us-ascii?Q?1gKcKarY0QFRDbVt1bZVqL8DpxVRml+SmwAICG426T7obgBIiFUmz/tvPaZI?=
 =?us-ascii?Q?hQUg+MZY27zFOL04G+4jDY++GRVK/iCtSINCvxglyIu/v9WxE2mYX5F974LL?=
 =?us-ascii?Q?vkVLfbZrUWAVIymcUdd/ZxCrGf3SyotRgZZ+dYHXxvFJWZiLSPuln2hf7UxC?=
 =?us-ascii?Q?UDZtkm0nG63v8L3J0uZgv1o0/s2dI2Z/Stg8wbpdreG9JFTvge1I6ZHG8ucp?=
 =?us-ascii?Q?ukiTUuD0fmXcKXF5Hbv623gNjdSs1WLNUaNtKtPicDAe0F7Mi87FeSldcU8I?=
 =?us-ascii?Q?hEAEO5HOOVT/jNBuoEhM8vGFRtx9PqER5lbj7+NUnpxlW3kizlRJEXZsqAaF?=
 =?us-ascii?Q?58ONHoAeJEySG9e1f9ceR6KaqSjJxNLgfadOkgo0OPI6w044QmhwSh/KXMtQ?=
 =?us-ascii?Q?FfmQ9Kv9CeKo4YOLeWPzh2qdBOP8B7mJ4kZOPQzhXQs/KRtd1PbM1c6tlBSt?=
 =?us-ascii?Q?bfjgABdu1q/lLJoygFOQS9m3lQmMU9+LgRi9FrFaZ5kVlP/m7i6bEiRvnjBz?=
 =?us-ascii?Q?6NBe/2S8IaVXK5/rPFvxFnz4UYv9T0YUySDf1aVFjDq7ybGQnw0VtVwgGfaN?=
 =?us-ascii?Q?CEAclibNzQDUMOIMABBzPH2KZpUj2dOd1+brGJoTCig2rC7xR0JC1BOIGDXP?=
 =?us-ascii?Q?e9MvJOj4tbUCmUYXKPXQ8IvTgQGWKIgncUsbJcgdFPKopxkRuri9dTBfM/fZ?=
 =?us-ascii?Q?KZMgXJG8NcqI1vSjkL175nL79RnPaVARGCpumlbh20vbehZJeNwyau4knh3C?=
 =?us-ascii?Q?smMYAWJcZXmFKTrv4pYosb2hZ9sWhExuBFKP9qRgr+NTFQlKtm6BWXv/y6Y0?=
 =?us-ascii?Q?LoZv2h0koHeYZfpyom/C8mH7N9U8q/NrT2LSKZxepiZuHmRogK6tAzN6yM2i?=
 =?us-ascii?Q?D91OL2sa28wLM8EQrho77HRRoWnVsU8VpJSLvFs2lgGs/f3rvZAh?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c4042e-4b37-446c-ab1a-08da2a2787c5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 21:30:50.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzNi1b68uIf8YBhTzHQGocW12//mDGXhMsGjAjzqjHlHUhqMBFjPhR8ZFx6GRVKzQnIe5HLH/60DD9NXp9U6auzO7q4yHrfVsswD9UvXlEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1957
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a desire to share the oclot_stats_layout struct outside of the
current vsc7514 driver. In order to do so, the length of the array needs to
be known at compile time, and defined in the struct ocelot and struct
felix_info.

Since the array is defined in a .c file and would be declared in the header
file via:
extern struct ocelot_stat_layout[];
the size of the array will not be known at compile time to outside modules.

To fix this, remove the need for defining the number of stats at compile
time and allow this number to be determined at initialization.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c             |  1 -
 drivers/net/dsa/ocelot/felix.h             |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot.c         |  5 +++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 +-
 include/soc/mscc/ocelot.h                  | 10 ++++++++++
 7 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9e28219b223d..33cb124ca912 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1197,7 +1197,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 	ocelot->map		= felix->info->map;
 	ocelot->stats_layout	= felix->info->stats_layout;
-	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index f083b06fdfe9..39faf1027965 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -24,7 +24,6 @@ struct felix_info {
 	const u32			*port_modes;
 	int				num_mact_rows;
 	const struct ocelot_stat_layout	*stats_layout;
-	unsigned int			num_stats;
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 52a8566071ed..081871824eaf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -638,6 +638,7 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x10F,	.name = "drop_green_prio_5", },
 	{ .offset = 0x110,	.name = "drop_green_prio_6", },
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
+	OCELOT_STAT_END
 };
 
 static const struct vcap_field vsc9959_vcap_es0_keys[] = {
@@ -2216,7 +2217,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.map			= vsc9959_regmap,
 	.ops			= &vsc9959_ops,
 	.stats_layout		= vsc9959_stats_layout,
-	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
 	.vcap_pol_base		= VSC9959_VCAP_POLICER_BASE,
 	.vcap_pol_max		= VSC9959_VCAP_POLICER_MAX,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 68ef8f111bbe..48fd43a93364 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -636,6 +636,7 @@ static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
 	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
 	{ .offset = 0x90,	.name = "drop_green_prio_6", },
 	{ .offset = 0x91,	.name = "drop_green_prio_7", },
+	OCELOT_STAT_END
 };
 
 static const struct vcap_field vsc9953_vcap_es0_keys[] = {
@@ -1086,7 +1087,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.map			= vsc9953_regmap,
 	.ops			= &vsc9953_ops,
 	.stats_layout		= vsc9953_stats_layout,
-	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
 	.vcap			= vsc9953_vcap_props,
 	.vcap_pol_base		= VSC9953_VCAP_POLICER_BASE,
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ca71b62a44dc..0825a92599a5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -3228,6 +3228,7 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 
 int ocelot_init(struct ocelot *ocelot)
 {
+	const struct ocelot_stat_layout *stat;
 	char queue_name[32];
 	int i, ret;
 	u32 port;
@@ -3240,6 +3241,10 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
+	ocelot->num_stats = 0;
+	for_each_stat(ocelot, stat)
+		ocelot->num_stats++;
+
 	ocelot->stats = devm_kcalloc(ocelot->dev,
 				     ocelot->num_phys_ports * ocelot->num_stats,
 				     sizeof(u64), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4f4a495a60ad..961f803aca19 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -190,6 +190,7 @@ static const struct ocelot_stat_layout ocelot_stats_layout[] = {
 	{ .name = "drop_green_prio_5", .offset = 0x8F, },
 	{ .name = "drop_green_prio_6", .offset = 0x90, },
 	{ .name = "drop_green_prio_7", .offset = 0x91, },
+	OCELOT_STAT_END
 };
 
 static void ocelot_pll5_init(struct ocelot *ocelot)
@@ -227,7 +228,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 
 	ocelot->map = ocelot_regmap;
 	ocelot->stats_layout = ocelot_stats_layout;
-	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9b4e6c78d0f4..5c4f57cfa785 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -105,6 +105,13 @@
 #define REG_RESERVED_ADDR		0xffffffff
 #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
 
+#define OCELOT_STAT_FLAG_END		BIT(0)
+
+#define for_each_stat(ocelot, stat)				\
+	for ((stat) = ocelot->stats_layout;			\
+	     !((stat)->flags & OCELOT_STAT_FLAG_END);		\
+	     (stat)++)
+
 enum ocelot_target {
 	ANA = 1,
 	QS,
@@ -535,9 +542,12 @@ enum ocelot_ptp_pins {
 
 struct ocelot_stat_layout {
 	u32 offset;
+	u32 flags;
 	char name[ETH_GSTRING_LEN];
 };
 
+#define OCELOT_STAT_END { .flags = OCELOT_STAT_FLAG_END }
+
 struct ocelot_stats_region {
 	struct list_head node;
 	u32 offset;
-- 
2.25.1

