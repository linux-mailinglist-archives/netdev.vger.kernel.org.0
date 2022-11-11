Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E39626330
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbiKKUtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiKKUtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:49:43 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2103.outbound.protection.outlook.com [40.107.244.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF2C85444;
        Fri, 11 Nov 2022 12:49:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc5OsPcEKMSiOY2JixugKVW/SjkkPVsQOA5j7aTBMarmLe1DiN+PLKJbnUXI1Q7P8JLQeJzARyQIQqnryV+AAPyDeVzKNizA7wYpcsz+sa6bkW3Z1Arwtlrb6nrFUx0KU5WonzsYZwXQOA1i+3vICO+L90AAuuXu92KtfwAgI90caHDV4/q4OMsYKQeBdWabE6HGhr40TXIVhXUY4uogS4I5VSM68AVqHRh2cc1rZOXdw1SphScLKjtZuirlgiCitA9Fz5a/DbQebdIEOy7smBp18FcdPH4o0deWtwdzu3Uk2RNPO8dkizDykBinXLc8wricErO0Nofw1wfO1wnHZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGeWV2FgjlEZe5bA1UDohs0NcU+Se/nP2jyZlcAjr0w=;
 b=nSHR9g2Ce/spuAFq/+IYBJMJ+CVXvCB1bieeu1MSGmfO2yei9MF6AR9DNC1jgJ7Ev9AOBzX5sDTrUzrLIRfrv6ud5d2rvcAWjRI4enOX4D+ozqtb3GnhMIw9NLjsrdjaWHrri8c0tn+8pWF3yUWyGzin4PZ1iElA7D4St3C8OKpWzzA2tYqX1I8hCYmV49dtXHfHT0FimTIED0oIJaQfjvZ9dfxZxdxGi3AWtAaT3nhTo3A6JE+iZKaQcr+HTbIOWfVbHrEmJY554HatvutpQ34SnRdHZP+ddNyECzR2yYE1wQ7LILBL+7aLfcrnnfqLbuQnvn2T5BisI73scK+TBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGeWV2FgjlEZe5bA1UDohs0NcU+Se/nP2jyZlcAjr0w=;
 b=CSkaycXSCD69ZW6tAi55VXl/24byUwuhIH9UybcboKZLcLCNfZhdMtf2xgoKsjF3eyESqK2GZS8eWfZwniXZrZPDohD+cCZ/OcT+cvsa6f9zBGFvjiy6LFTHTbPlA0t1Xk7NEHSnj//rN7pHZkBmUTGZ5m/7CxSWnjU4idZCeSs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4588.namprd10.prod.outlook.com
 (2603:10b6:806:f8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 20:49:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 20:49:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant stats_layout pointers
Date:   Fri, 11 Nov 2022 12:49:23 -0800
Message-Id: <20221111204924.1442282-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221111204924.1442282-1-colin.foster@in-advantage.com>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: 70886846-1c2c-4cb1-7742-08dac4264034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkALBATQXS6H2q83KBfeSiF+MrL3Ugyq/LNzhvwQwejU7gdH2E0JnjCzc2jMsZ2Z/ByjsK0MgnnT2WxHhQlf3oD8HiIJiJWMKUUiS56AyY4Lt6ZIMMvwOmtsoN6pzxroM1NNIVVnwsXUYRiZYZoPU4y6OKOvR0v0xwPSIhAyv0TSiUnw0PQyFuOtgkZfNTRuKcIBX/PhZZzhdcSAUE4s+VievcCXUDqs4+coDeEyhWiwPA6PqUKvZw88Qzb2n7+pGmrRFCrmVu92Rw2JB3leI/BxJhqfNzYpTD1TazMZIZJVI6d31/3ULUONhzHXHafl2u8ZKa7R7/kCrUch/r40bMwfvZRvHIr6N1P2ts9yMaV4zM4B/nDPXT45xNmiYHLZiIGBoKIqTcCBjYvu4xZ7SFO9urJJ+8VnOfZMmFTQoaut1bTQHA2ivHysZZhwGqwV8BL3htAG6cHqVsUItv1XpXQqlSyzlZRv0aEhe2yzgwMaWSIid1zQ7eEvXkV27YbC1XDkDxGUZrhzQeJnv0Kritul9Fn2Gyaytg87+5hJRMQpSjOL0IpED8Z+0hnoRfPFzjZfc2z8NyFUMNKujnuH9owoIlGucm61bjltIkLNw1LfSI9kLmsuNcpzbU8XVF8axxN+f3SgQFGMz2czbhsSghF9rVPtlCfwDR7UKLiHZUgbNOFdGg94f0upucuI5rXhJSBJCUgozwsJfnwC8LrVZTceDC8bcld7X1/suadE8zJLC0JIblTHGZJFIiYR9oBp40WGATFnF9PJ2xVc8w3PAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199015)(54906003)(6666004)(86362001)(6512007)(26005)(36756003)(2616005)(4326008)(66476007)(1076003)(5660300002)(66946007)(186003)(66556008)(41300700001)(7416002)(8676002)(2906002)(83380400001)(316002)(44832011)(8936002)(6506007)(52116002)(38350700002)(38100700002)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OwomPjvbzoaFWkPkOmr88NJTx+dBJ2LYpRsy9H2wgisN0Xtx3gWbNyFbvVmH?=
 =?us-ascii?Q?TudTVqnYFuYTtTNcONVyMQKP4Qs37l5Ge41FWs74VLCpSvQ1LD/W3ZjskW6b?=
 =?us-ascii?Q?H7N2W6Zamxg7v4/QRxeFYTfeqvFDkZ8Xx51Qs8lcsunh6nBKTqf+fzfTTAq8?=
 =?us-ascii?Q?W9wCttRVEGSKhIwQNDjmVwdxfwjFJLV+h/eNwO3MljT1HSVcE/eENohyCakc?=
 =?us-ascii?Q?S7f7JKPa9FtnEgAZ1XB+Wd7HOEVsjQYSzkUs5I9usjU3aaNYYg/rFaBWU0xT?=
 =?us-ascii?Q?AjHCjweG+q58n0G2o2QIJSymqRrshKBJ1UoyAL29ZdC6k9M1TCkQIfH0UHxI?=
 =?us-ascii?Q?lJe9fS1tTqxY7LJF/WORrggie3fR8375ZwLr6u9sz0w+zn2kYkcuJlzWJCIP?=
 =?us-ascii?Q?Ttiw7xhyzarx7zI4qm+uw+DSAKVLydx36QTsQrqn3CfWoP/V+KjX9RBdWWlq?=
 =?us-ascii?Q?ziRsbRDSX4EJjIP1wIl/AMcVvKuDcNhZsl+Xspt+iOMxvvnr2i9TTtL06scu?=
 =?us-ascii?Q?Wae2TUO/z8IzMkh86UIMe9CtpiQdXv0v7rSOOx5WiUL5mtEWOnP2RmRyY9lN?=
 =?us-ascii?Q?aBEvan1Ryg+U53VpSfEp0PjaVl0F3vS1CoXRyR5HVjbEe+t2mhum7tJn0XL0?=
 =?us-ascii?Q?aiauf8OMtgfPm8Y39KaS4SFtzDQhco6bb9Nkqn5mWv6kwm0noxgom533B7UK?=
 =?us-ascii?Q?aaoYqPffpJ1xKH3INcCOJrNvyqeOXHr8IO0eNQ8ALYZT/NJlUcWayqsqtQow?=
 =?us-ascii?Q?nncG8R/n0ng4MC+NlgAl495gWDyyQp+Db9X0Yv65lbci3FDkQ1t702RZIARE?=
 =?us-ascii?Q?auta/xuP7oNCj9BnkZKaybdeGnq6/4MANp/kzapsLcJzDr3QP3980ezE86PH?=
 =?us-ascii?Q?3GRwyPbq4XleeMaXqN6foSCpdz4VHy69sS5bIQAAhZeJFc2QxUiXkJw6KpXl?=
 =?us-ascii?Q?UxAj4On1vPO1Ey0858xL0q535A89nFt7FkmWm6bUZfu19XUfsLwys+J5kjKz?=
 =?us-ascii?Q?AFxVmR7uWKH+swU5CIvYepe22yiqQQ/p3FrpSZIytjDqS5jUv9h5l59Sckxs?=
 =?us-ascii?Q?MYd4FZq1TkRku3bM/ze5Ews2BofPF4RzbOzTqGBzYMWs6G0ZzCzUvr3VlVWS?=
 =?us-ascii?Q?nXtUeIk7q9fj4B8tHMdWt68UFvSoOhTB0lI1KtP+Wi9duNHBskKuHkA0JNku?=
 =?us-ascii?Q?S+C8SXX9Q5KAqW/UUaG5gvb0nRLhi6CkAbzgZRyeWp8LxFWVXBIFQUv5E356?=
 =?us-ascii?Q?iq4c2Fnp1N0ZBpldn+PriZmEJm/jCdNM3oF6ukEDjuAiOjFq5Z/L5G9f6cNA?=
 =?us-ascii?Q?j2S85LDTkALpMg3WH9rpx37UFx1i4cQ/LJOYAemCMzQJyP/hd1HoSw1QCPPa?=
 =?us-ascii?Q?ciX9ZqbgzuiODwWKVURT4UCCfsiBppN2HqijQZ/MIyKZ46RaWaBjaAc/v5rm?=
 =?us-ascii?Q?2BAXtW3Slaf3tgw2w8NBx9ZVQBjwTrohtx3/T/n7MGrQWP6spQSusyCmyS+U?=
 =?us-ascii?Q?TpNIWvi+sx9D/n00iZAYrUbcQprUUp8aiItdOF47x0PzOopSqrTpJVH4Vl2l?=
 =?us-ascii?Q?E/Q3d040Gy9oxdjfl0gEJQGAryVjIWuA9R4fe3oYpXggD3NuKpI/NCrKSC46?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70886846-1c2c-4cb1-7742-08dac4264034
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 20:49:39.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1MF4j2+wof8EEU56piy+WD0XxSfBJiDUVxX3lDkZjFbVEUMPIGa5GiMfpKb/e3jgdq0Hajbc58jKtsk+pXpEMbohGyYbz4kwFoMz53JmfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4588
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
 drivers/net/dsa/ocelot/felix.c             |  1 -
 drivers/net/dsa/ocelot/felix.h             |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  5 -----
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  5 -----
 drivers/net/ethernet/mscc/ocelot_stats.c   | 20 ++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  1 -
 include/soc/mscc/ocelot.h                  |  1 -
 7 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index dd3a18cc89dd..e2ad9be11287 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1370,7 +1370,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		return -ENOMEM;
 
 	ocelot->map		= felix->info->map;
-	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index c9c29999c336..31fdbe75654d 100644
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
index 26a35ae322d1..e742cf48bc54 100644
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
@@ -2575,7 +2571,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.regfields		= vsc9959_regfields,
 	.map			= vsc9959_regmap,
 	.ops			= &vsc9959_ops,
-	.stats_layout		= vsc9959_stats_layout,
 	.vcap			= vsc9959_vcap_props,
 	.vcap_pol_base		= VSC9959_VCAP_POLICER_BASE,
 	.vcap_pol_max		= VSC9959_VCAP_POLICER_MAX,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 7af33b2c685d..a383fae4e218 100644
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
@@ -996,7 +992,6 @@ static const struct felix_info seville_info_vsc9953 = {
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
index 93431d2ff4f1..125262e16351 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -138,7 +138,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
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

