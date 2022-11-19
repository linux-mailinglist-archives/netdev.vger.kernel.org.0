Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B6F6311E5
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiKSXOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiKSXOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:14:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12E013F57;
        Sat, 19 Nov 2022 15:14:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHhFjryaWuFbtaI633Y9FfkNQk4VHyFaZ6T1l+J2qzu4fICKAloOJes96PEA+WbXrG9Ie8h34z36Zircq/IHpj2sHzRbBLnkKA5SN4/IDiEwZVytXnb+tewWF4U+GT+NaOjrc0Sbve33NF/sHazKOA1HhVJ4FAr2rDjQnK0hJIt1+aSTxr4QgR0rb2ltcbJe7nDYREZp7zCBeGS/7fez+FphmFSX3Ed+a2QERgKOdpZ6BaS+COA7zJjDB19iO9BI2v4sI7vlyfsT5e0+gArSC6cK3FVVV8uwxNqud9eK5yTJugNVj3hvm+IAQ/DyNbSw5h6PA/tfOcXWPC26C3GIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6IUfgqfMZdZybJigsJOyOYaWpjYlH91x7LB5DcjVaU=;
 b=IrEnT/4sPDDR4lXhUbmpHfIIOVqGRK97Sr/0NETI5CpwO5OIBTvwG/k+Y6GJu8YUSbDW6jtYEzE+iLanUil046qRqw/H8MXmynD9m3mLgj3IjY1eEcnLw6OXiDHSiHwkijEDRQRJ9nbcRbtGSXAyw1dmWXEsvf2lBjx08I4Q0XkRqGTSHc1YsQ/M2mk+ukdPnYnsvUt1CyO7iCM+jZeaWgUs2g2o5nEzO7AbYg9FbTCWwaEc6CR87kVSfzI8GE5OQEYG+4ja/5QQQK/VkFgWeHcONLUXUTZaxW307bBRBfpz/WmR0epvU8CiQfa2XYt1i++zKLmTZf+7YK92npAIHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6IUfgqfMZdZybJigsJOyOYaWpjYlH91x7LB5DcjVaU=;
 b=jKN19MFde+NB5l92W94d5VOhPpHaHZgBCBG8xthEl0pHP7l7EEL2qmqwZyT4ANDB/h+6jDDwT6a+ZeT9NcMB87NTA7bhB3BE3gtjyXe2dcc6GuUmjymy7lVqE2p6tiADiC/Kud60ZTKdqt2OILFPhsoaTix6hpCZoXXd0GmZLPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4293.namprd10.prod.outlook.com
 (2603:10b6:610:7f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Sat, 19 Nov
 2022 23:14:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 23:14:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 1/3] net: mscc: ocelot: remove redundant stats_layout pointers
Date:   Sat, 19 Nov 2022 15:14:04 -0800
Message-Id: <20221119231406.3167852-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221119231406.3167852-1-colin.foster@in-advantage.com>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH2PR10MB4293:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a178bb6-0063-4fc4-77c6-08daca83cbd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3PoPPRbEuNVPwyT8uVCJSWDisAqKaql3gU4+wYD17R/YweK15FW1cOSNZhQDDyhUy6FRElJGphEjf+DV1uZwjD/IdivqJTV52RUsvZJNdEWYCBCWrnPSi3uSYpbMfiJFUqdbpOToMvv4Kjfz/998cp9Ii5sTTiXrSHjy8jtEcbveqmbcDGTjI7ppjgLIRIBQXjtunKFr6AxV31OC2qWnc/l/u9ZlMqTJWLxSuB9dYA4KxyZUS2lnV33q6MqjaS8MoW/mAq1G/E9dETXpG4Ge7k6G0oiQmC20JIziItzunSF7jJcn1KsmFXFl7CQgBszwHJfTrIYXeElWWbMpN2MErEqe50UgICFyjYd6NunHwc2sO/l5tS+2J2wOJRbyq5R/gU+EsJw4zONgOBQ0VE5z4pT0QO7F9M9WY8FNkVaqY+5xG4WkTJtSoC1NMb0JHVRluXNNQ9YpmqdKmDGqB61c16esS8HXiiZT5ldcgKYjVoybLLkdnKBUPTSyEFGrk2Vjy4xyYwExY5cLiGrfz+Q4CLeaD5D3fwCp3+AlBn3NKmveW0w/QQfei9L3ALj/fy/AoJmJ12RC57rc0sQDkGtrm3WXE3cQnjqmojb/GOW3vivgQiptAunbdOW19j5sFPgZdqLPxmxNW7LE71/4ShbENnAJ3vViplN7Vow1gYBeEju0Pwh7iROQBFQvkUt4lMKHdlYjRFX3Qa8JoRljXPXyEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39830400003)(346002)(451199015)(2906002)(26005)(86362001)(83380400001)(6512007)(4326008)(8676002)(66476007)(66556008)(66946007)(38350700002)(38100700002)(36756003)(41300700001)(44832011)(54906003)(8936002)(5660300002)(316002)(186003)(7416002)(52116002)(478600001)(1076003)(6666004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?REIzYUqIXbPDA6tOtnEx30zrJnYooTqn/LOrUQF1vc+ZeMQIA1z3LpVMw1jt?=
 =?us-ascii?Q?KIzEy9Jt0sSrjAUVdY77xmm/sykgc4+tF8hcfOaDbz10YbjgC3AWhmdpPugt?=
 =?us-ascii?Q?PZMATGtRkplJFKJLG/dw0eOx12ysUQRFbBMUsMHe5O8CImfYvQCpaQPesU0B?=
 =?us-ascii?Q?zBXz8QUXwGIYob7FZyoyDSLLkwfoymmZT1xHl+k6Jhd16rCMKNII1ql3QPNv?=
 =?us-ascii?Q?VsG2x25PvVfRpjD1TK5nHgM8QmKhCa4XuGKtMKu9DiAAFaLLO9sPMNqT/MXT?=
 =?us-ascii?Q?E11mqFXL+DajogPTbHzUgEzGWtMBNbxHAv4CiKlAAIsBN8WhZh/26Jfsb0v0?=
 =?us-ascii?Q?hmKOP1i8ZxLd/WOzNyFddWu2IJy0E6z/BFkGeF0eifaXJRGMM3dIt/Q8Ey8y?=
 =?us-ascii?Q?rBqVEZ/qaWNRn1sWJUu4JzxerOVfBxrSNtJv7VLEIe1nb4YNCrOdLJdsHL1J?=
 =?us-ascii?Q?LgmcBea3vNJqBzfm5LaycrDpwP51cLee8ukx/RvOPPHtG51nxwrwOgtc77v7?=
 =?us-ascii?Q?2lDah6u/oFxfcnWT6yVF0Un5C13QYC30ALvlyQ4l9MC88MDl/IdZewZSMj/D?=
 =?us-ascii?Q?xug/eKdGrrWAHrDo9wLFZ+okMaH/cejSYO/1L96ZmJtruxjAbQUw9VWjQI7I?=
 =?us-ascii?Q?YQhkRkijqOQb46yDthIzLHNlfhFgZ6LUi1+krB5o/B3E2xTU09usuLdL+4Gs?=
 =?us-ascii?Q?uGf1ups1Fgc6Rs6CKiXmFTQRCwenDVw3Ky7YTbxxhmVJM3mU44WU5o7KXJpj?=
 =?us-ascii?Q?QyXqTY4dRD/qizozuO+nS4RTzsZE+qh1a8LqogDAnJP9c2ssju79afB8V0/6?=
 =?us-ascii?Q?jxmKGvYcKAjg0Wh8cNPgWsh90l5svT4xqSLLVLiD05sdn0dszuYhamMRBo2W?=
 =?us-ascii?Q?nUDrgz6cPeJrpDEvWxE1GpShUMXITfB2PzzYPaI+6QUmOfXsc8xdoxiNLcX8?=
 =?us-ascii?Q?D2EANTDIWwIBLr9qwcDsE83Snp9tDjLEc+JWsnplsN0JoJAzyNQND19BnDCy?=
 =?us-ascii?Q?eAWKSzJAdQL79wDTCmGI2NM2Z6BkolDdkLg6qM8sPBdN+c/5TWNQOznR45hY?=
 =?us-ascii?Q?EJbJOkZm09rW2vJgr8vzoH8HteCMkrjXOfUeAVn3v5s5IHkNHbam0W/JIHLq?=
 =?us-ascii?Q?rJc5syoB/zYhM+54IcC4znWAex0LmtiDU+Yjg0mG3G2NwFCfhgLPf5Wzlii+?=
 =?us-ascii?Q?tmz5PVUpGYXOpXCvcGqaFANkCmm+KMshH/QFqz6lxc+uJ5Xj1he8C0+1ONoj?=
 =?us-ascii?Q?M1gkIuG0FC5YpbfuPN+jBta4o2ErnNqg7jyKtbhJxHuhhbsE/Sw1phRubCwF?=
 =?us-ascii?Q?bgdbIKXX0S6r72XRfAlKfI4VbzvLYxj2ITw3ZE49kCo2NugDQLSrV/rwzq8Z?=
 =?us-ascii?Q?gJXyQGVv9cVg/pkFVnDVSguFMG6PhfNU1WZ3nzpnXfCmFCrku0HT4ofkdaC6?=
 =?us-ascii?Q?KCXHRryCsaWEEXzhoD9yUiQKxasfoBGbP/+atFOpHRK3prm/GfIFq2Nmh79f?=
 =?us-ascii?Q?zChr9KrJ23A6oFOt2XTUJa+9IW/H3stNS5+iAIZLV5kHfTbh5sapZIqwMolA?=
 =?us-ascii?Q?3vDoj7y+nwh9gZmR+e+jP+3+Fk8CuzHl7l11BZrMs2sWEMMiqo5aAmn4Mjz7?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a178bb6-0063-4fc4-77c6-08daca83cbd8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 23:14:23.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpmoooVaAWp4Hws9RLLepNpOgE8Rw+goKnDSWR1MttEhefR0+IIYofLfIBz6MYHQZvnb0i56P4PYV+HWaaoHhXz2bvNKDyCE6L+wXbtUpt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4293
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ever since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
definitions between all drivers") the stats_layout entry in ocelot and
felix drivers have become redundant. Remove the unnecessary code.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1->v2
    * Fix unused variable build warning in v1

---
 drivers/net/dsa/ocelot/felix.c             |  1 -
 drivers/net/dsa/ocelot/felix.h             |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  5 -----
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  5 -----
 drivers/net/ethernet/mscc/ocelot_stats.c   | 20 ++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  5 -----
 include/soc/mscc/ocelot.h                  |  1 -
 7 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 44e160f32067..3b738cb2ae6e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1363,7 +1363,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		return -ENOMEM;
 
 	ocelot->map		= felix->info->map;
-	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 42338116eed0..be22d6ccd7c8 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -28,7 +28,6 @@ struct felix_info {
 	const struct ocelot_ops		*ops;
 	const u32			*port_modes;
 	int				num_mact_rows;
-	const struct ocelot_stat_layout	*stats_layout;
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b0ae8d6156f6..01ac70fd7ddf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -565,10 +565,6 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 7, 4),
 };
 
-static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static const struct vcap_field vsc9959_vcap_es0_keys[] = {
 	[VCAP_ES0_EGR_PORT]			= {  0,  3},
 	[VCAP_ES0_IGR_PORT]			= {  3,  3},
@@ -2546,7 +2542,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.regfields		= vsc9959_regfields,
 	.map			= vsc9959_regmap,
 	.ops			= &vsc9959_ops,
-	.stats_layout		= vsc9959_stats_layout,
 	.vcap			= vsc9959_vcap_props,
 	.vcap_pol_base		= VSC9959_VCAP_POLICER_BASE,
 	.vcap_pol_max		= VSC9959_VCAP_POLICER_MAX,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 6500c1697dd6..88ed3a2e487a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -543,10 +543,6 @@ static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
 	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 11, 4),
 };
 
-static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static const struct vcap_field vsc9953_vcap_es0_keys[] = {
 	[VCAP_ES0_EGR_PORT]			= {  0,  4},
 	[VCAP_ES0_IGR_PORT]			= {  4,  4},
@@ -970,7 +966,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.regfields		= vsc9953_regfields,
 	.map			= vsc9953_regmap,
 	.ops			= &vsc9953_ops,
-	.stats_layout		= vsc9953_stats_layout,
 	.vcap			= vsc9953_vcap_props,
 	.vcap_pol_base		= VSC9953_VCAP_POLICER_BASE,
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index dbd20b125cea..5dc132f61d6a 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -9,6 +9,10 @@
 #include <linux/workqueue.h>
 #include "ocelot.h"
 
+static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
+	OCELOT_COMMON_STATS,
+};
+
 /* Read the counters from hardware and keep them in region->buf.
  * Caller must hold &ocelot->stat_view_lock.
  */
@@ -93,10 +97,10 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 		return;
 
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (ocelot->stats_layout[i].name[0] == '\0')
+		if (ocelot_stats_layout[i].name[0] == '\0')
 			continue;
 
-		memcpy(data + i * ETH_GSTRING_LEN, ocelot->stats_layout[i].name,
+		memcpy(data + i * ETH_GSTRING_LEN, ocelot_stats_layout[i].name,
 		       ETH_GSTRING_LEN);
 	}
 }
@@ -137,7 +141,7 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 		return -EOPNOTSUPP;
 
 	for (i = 0; i < OCELOT_NUM_STATS; i++)
-		if (ocelot->stats_layout[i].name[0] != '\0')
+		if (ocelot_stats_layout[i].name[0] != '\0')
 			num_stats++;
 
 	return num_stats;
@@ -154,7 +158,7 @@ static void ocelot_port_ethtool_stats_cb(struct ocelot *ocelot, int port,
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
 		int index = port * OCELOT_NUM_STATS + i;
 
-		if (ocelot->stats_layout[i].name[0] == '\0')
+		if (ocelot_stats_layout[i].name[0] == '\0')
 			continue;
 
 		*data++ = ocelot->stats[index];
@@ -389,10 +393,10 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->stats_regions);
 
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (!ocelot->stats_layout[i].reg)
+		if (!ocelot_stats_layout[i].reg)
 			continue;
 
-		if (region && ocelot->stats_layout[i].reg == last + 4) {
+		if (region && ocelot_stats_layout[i].reg == last + 4) {
 			region->count++;
 		} else {
 			region = devm_kzalloc(ocelot->dev, sizeof(*region),
@@ -400,12 +404,12 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 			if (!region)
 				return -ENOMEM;
 
-			region->base = ocelot->stats_layout[i].reg;
+			region->base = ocelot_stats_layout[i].reg;
 			region->count = 1;
 			list_add_tail(&region->node, &ocelot->stats_regions);
 		}
 
-		last = ocelot->stats_layout[i].reg;
+		last = ocelot_stats_layout[i].reg;
 	}
 
 	list_for_each_entry(region, &ocelot->stats_regions, node) {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 93431d2ff4f1..b097fd4a4061 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -100,10 +100,6 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -138,7 +134,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	int ret;
 
 	ocelot->map = ocelot_regmap;
-	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 967ba30ea636..995b5950afe6 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -967,7 +967,6 @@ struct ocelot {
 	struct regmap			*targets[TARGET_MAX];
 	struct regmap_field		*regfields[REGFIELD_MAX];
 	const u32 *const		*map;
-	const struct ocelot_stat_layout	*stats_layout;
 	struct list_head		stats_regions;
 
 	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
-- 
2.25.1

