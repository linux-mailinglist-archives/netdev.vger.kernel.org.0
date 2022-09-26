Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965595E9750
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiIZAbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiIZAbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:31:06 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFF129C83;
        Sun, 25 Sep 2022 17:30:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLOC467/BsuCBTUPuKTbmhlkGKuwZ73vA6h+AWpvKEYHkv2SKA05i58iEWOhDbkf4I4IYquQkvgkJ6ULhdCjpxpQzC2Hq/YWYzmGEm9M/PWSoEzxmsKwLqdHt18P92DKIKyCBa6VXQwOPCNQO+87znAJFikZ28JnPo3EXFXyW7UlEXZ4BylrbQkhuKRQWHPQJZ1/bxUvSihr5q5iUrlwrENWtNpfVmcUa/oz9Hu8i0ybaIQoMFNiCkOC5NDVbtLTRE2lFXhxIKAJMAjRi29qdHslyzHP17k6ac363sL9pIJJ+K6xIEUpqIcWUkPnw+U064/Ld7rJ93AmFF97rd7JbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usWnpg7aQcqYbfBiFKlyj2p+/ST4zMg0LoHWJvSqLAM=;
 b=J6+VJxRDjo2YoIea5Jh7ZFBR8LguBltWpcnTw6XkKFibXCW9okE3ZD0vY1B6LF+2OcoA1f+44Z9A+LO4V6YVy6/vjjs3ZcaIRUY9VF+MfWrpVWeTFwxaWfBvzoqgJFFn5yFrUQOPidT+LgWMAQloHKi5EyY9/uwvF34NujVMGsJVMnmSl4Oekl0nwwusf2FxB85aCOh5q60Bt/cnNz+NId7h44/9sjYzQnE8HMYQCGVvPzbLEgwd6EZFAu2RHLSvJd8bNGFdZJbImld+OpCq1Y2sK4hse9SWQzCEUkhZCT5tNWalmssjvmLXERu9W3UxGiJiXDAnnp7dObKzMsh8gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usWnpg7aQcqYbfBiFKlyj2p+/ST4zMg0LoHWJvSqLAM=;
 b=RiqOS4WjHMm3msi/P+IFxCUtAPk7AOBtVQyRhZwthlmP9IM30Ti1gvsCoL/xJecK8dKVqIdnw1FnoyKpIhsIZvkUWMI/plxENY+ChygrQag4h+6NVTubfH587TPkK1/OsMkTYHMMRpF1IJOUkzT88ZFn/dos42f/HOPjxViKoQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:24 +0000
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
Subject: [PATCH v3 net-next 08/14] net: dsa: felix: update init_regmap to be string-based
Date:   Sun, 25 Sep 2022 17:29:22 -0700
Message-Id: <20220926002928.2744638-9-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 00d3ef06-4943-4ea3-9211-08da9f564ce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mu/wkS7jpemavl9iKEQQlL3v1kqfH3GQNXjh2m1myw2hhzVwlQ5wtUe7OkZHG4mK2oirqa6fVEFBlJdhW5oKgooG1/IdWhZK87Oz7mkIayCk9MAYIg88B/BIj89kwOpSYrg50uWMIFE9CDA1ujUuU6UOPb08MfsGbnVXI0Ar/HLgh+r+VzCiSThpkxHaVH8xfq//I24JDEsnUJkP1jv1LKfOQKTWHllPuO1HwMnEGfna9MuPugP2B/Swqc9tR+U0fvjodqOsGBS9fSfcMXHmc27EaW0lskwjlpL60HdMEXrIjJjWyjjxcfxIqmXD5FDQ41n6orQJBp0PlYq/+NEs1ZTYARDldqgu9F+KKTKJlXQi3Euif3e5xpmOGtuZRTmvEWhtInSZ5K/4eCcwylpMoj/p63V2j5s0hwWk7IE+zLH0OzTz//5MdkOOlBTSE62E9WyGXi3623qdpDCWIi7jIera8zMkS3znBD5YNZzWp0kN1RnjrWDdTvF/4O+tuRxhh/kqeaNLVQ+wEzD1ayLErFB5wkVnAPzslH5tmsv91w6ZJCEji/5NFPzI1T2cGy3/cgIn3vAsFsyJqnvDsJHcPAT4n1e7aLf07i38eeK0L47Hr36PSMOarnl9oIVMkcY8wFP+F/wPpu9PMln3MPaBt/3gMWtV/mPqfq2gpmoe1ja7YaVAtwz3852Y0jxgVTmziN9Z82Iuu571Q09VcaBPixd9NRjEY/lHvboQa7Yah+CoERIz0rhN4Go1ms1HBXJD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dS889AFpacFby+Z9PuYLbUmakjLIJ85r91WXKhM1h7/iL3kbMYimJtProCg9?=
 =?us-ascii?Q?VDPc06VmAI3IswCTjyOXgLfprypEXk2uw0Y6XYuBMZpwUEzUZNDVHr+EyrP9?=
 =?us-ascii?Q?MEq+2/BKNpqSY24pYcMgs74oc+tg/mhDR9E1/py97ceIbKB3W2E0Vovh8ivI?=
 =?us-ascii?Q?HjkmLxn9zQCJU7vhHfAE5QPojgGWww7Inl1ixzhVEdppxHoAY/TRgfeOr3Lz?=
 =?us-ascii?Q?PBNxzXxqnBEm1HO4c0iO2bX7fLmTAxmmRs2FrDRzvltpkTVrppuPAjh6onV5?=
 =?us-ascii?Q?GJ57acwCicKCcEn7xorqAm4dx/gdKlfDAJxkGMF5p24QYq43WxadJETS3SQY?=
 =?us-ascii?Q?dp19pa+vDlktvvxm7edpjXUju2Sov5f/Id3gsRQll1dihaFfBdnvKhs4H2Ch?=
 =?us-ascii?Q?T7n8cvCP/c2S/yQ3kxnxNlypNNx8ur/YKHkjBz7SjOwellE/CeVtvF00ODMp?=
 =?us-ascii?Q?wRQHpEua/IA1V2m4Qfj07XkGL0Mh7bMoyBzMv4mkYcgDpG/HIDLxm++fTTD6?=
 =?us-ascii?Q?4xFYc3htLI/LFL7B7VUWAj/qGwRZuQVtX9iywcD4PAZm2oxDtUtZhstwz3JE?=
 =?us-ascii?Q?My0ZWVqyrdTAaoR95C8RiErM5n7yDpGU6D51rquzenbPiqNU83mXsZGXykw/?=
 =?us-ascii?Q?37llLrfIAS/lHQ3EsgYxP34lh6SAvpdqXWfL9zgXeZI+BXjWBg1OpnHNCAEj?=
 =?us-ascii?Q?ETSwEX51pDMjbDtlj2gvIjM8l267PXvmmV7VEMtiDcCcUgCIVpFS5Pf2lf64?=
 =?us-ascii?Q?jzurQMf+t9dUVcvyHu0N2U80Zey3ArN00GlA1kP8MLMot3gS+hDa8M/kL7k9?=
 =?us-ascii?Q?XRfA1xZx2zfbUpf/jTLcPbHhshYz29VYsgA+8yLl5sOte4hT53/d0+TUhsWr?=
 =?us-ascii?Q?tPEMHYVlK/7EjvtpH2alz5S3ZV51EtdYsos8+2MowlL51naXkdB8q+bVjV9x?=
 =?us-ascii?Q?j7MUCP+/8Ih+L9AfnSvva0Y5RTJzmewu0EyftfOQdZNCNdZMUvexhQsSNKo7?=
 =?us-ascii?Q?L+vtoDmxYGAplaZqx0nR9TB6qYiq6sgBGvQw80oCBoi6ZGCRXFxo3WdKdxpi?=
 =?us-ascii?Q?2gAmxrDYLhzS5aT7FIo+BJMFs3D9YLCxnz1luTmy7Cu0pNio98KaCKdNSr7v?=
 =?us-ascii?Q?+Gey89xqNdfGR5I/S01ja1VCTx6i3gMFFhcZogbvSyx+LMOXV0B1+EXUsp1+?=
 =?us-ascii?Q?sYav5BsRKwjp6PjbFY0oNQJnet20qM/bmvGBzlwv41yodBi/SNFcXroiHFPX?=
 =?us-ascii?Q?DmzN4vcNkVTt3/7U2FpUb5hRKlzU78YpaqQsWjbDPkI4eoZ+65T6C2aJxZga?=
 =?us-ascii?Q?AwuaFHXY6+IXM6TNb+Jn5RKhoxEOd6z6ltoEav1l53qE9HrZWCTVglw5R+aS?=
 =?us-ascii?Q?Yk/Op4PKFPmEdQEaknq9wlmWW6ddAR8oK7GQpWHZyJtw0XRr+HxtJiuc2S9j?=
 =?us-ascii?Q?zRYYJ+cH67n53wmSugo67WPN/tTBJ2b8EeXZSW1Rcx6wu7KGfzI+fjRLV9LJ?=
 =?us-ascii?Q?HOuSLG0b+YtMycHDX2sj///SOl7VmBfpvVSD/O1y3gw5KDzfwWgdukmTYv+/?=
 =?us-ascii?Q?EpissR/H4WZkiuhVXCmZXIhBia33v4IG3f39DLMx2YN9zBn239msZ6ljKIcW?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d3ef06-4943-4ea3-9211-08da9f564ce0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:23.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KAroa9xXKvXT9b76DUP3CAu/Hu3EFSgYwUDr6FLKnMMxYMzWzL864psiXxtkQBjgoZycJmH3FnwTDOm3rJT/bvC69dXD1Wvko118GZvjEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During development, it was believed that a wrapper for ocelot_regmap_init()
would be sufficient for the felix driver to work in non-mmio scenarios.
This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
add interface for custom regmaps")

As the external ocelot DSA driver grew closer to an acceptable state, it
was realized that most of the parameters that were passed in from struct
resource *res were useless and ignored. This is due to the fact that the
external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).

Instead of simply ignoring those parameters, refactor the API to only
require the name as an argument. MMIO scenarios this will reconstruct the
struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
scenarios need only call dev_get_regmap(dev, name).

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
    * Assign match = NULL for the default case
    * Don't export felix_init_regmap symbol - the felix.o object is
      compiled directly into "mscc_felix-objs" and "mscc_seville-objs"

v2
    * New patch

---
 drivers/net/dsa/ocelot/felix.c           | 58 ++++++++++++++++++------
 drivers/net/dsa/ocelot/felix.h           |  4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c |  2 +-
 4 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a8196cdedcc5..b01482b24e7a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1318,11 +1318,48 @@ static int felix_parse_dt(struct felix *felix, phy_interface_t *port_phy_modes)
 	return err;
 }
 
+struct regmap *felix_init_regmap(struct ocelot *ocelot, const char *name)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	const struct resource *match = NULL;
+	struct resource res;
+	int i;
+
+	for (i = 0; i < TARGET_MAX; i++) {
+		if (!felix->info->target_io_res[i].name)
+			continue;
+
+		if (!strcmp(name, felix->info->target_io_res[i].name)) {
+			match = &felix->info->target_io_res[i];
+			break;
+		}
+	}
+
+	if (!match) {
+		for (i = 0; i < ocelot->num_phys_ports; i++) {
+			if (!strcmp(name, felix->info->port_io_res[i].name)) {
+				match = &felix->info->port_io_res[i];
+				break;
+			}
+		}
+	}
+
+	if (!match)
+		return ERR_PTR(-EINVAL);
+
+	memcpy(&res, match, sizeof(res));
+	res.flags = IORESOURCE_MEM;
+	res.start += felix->switch_base;
+	res.end += felix->switch_base;
+
+	return ocelot_regmap_init(ocelot, &res);
+}
+
 static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
-	struct resource res;
+	const char *name;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -1358,15 +1395,12 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
 
-		if (!felix->info->target_io_res[i].name)
-			continue;
+		name = felix->info->target_io_res[i].name;
 
-		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
-		res.flags = IORESOURCE_MEM;
-		res.start += felix->switch_base;
-		res.end += felix->switch_base;
+		if (!name)
+			continue;
 
-		target = felix->info->init_regmap(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, name);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1398,12 +1432,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return -ENOMEM;
 		}
 
-		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
-		res.flags = IORESOURCE_MEM;
-		res.start += felix->switch_base;
-		res.end += felix->switch_base;
-
-		target = felix->info->init_regmap(ocelot, &res);
+		name = felix->info->port_io_res[port].name;
+		target = felix->info->init_regmap(ocelot, name);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index f94a445c2542..e623806eb8ee 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -57,8 +57,7 @@ struct felix_info {
 	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
-	struct regmap *(*init_regmap)(struct ocelot *ocelot,
-				      struct resource *res);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot, const char *name);
 };
 
 /* Methods for initializing the hardware resources specific to a tagging
@@ -97,5 +96,6 @@ struct felix {
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
 int felix_netdev_to_port(struct net_device *dev);
+struct regmap *felix_init_regmap(struct ocelot *ocelot, const char *name);
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2fd2bb499e9c..e20d5d5d2de9 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2615,7 +2615,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
-	.init_regmap		= ocelot_regmap_init,
+	.init_regmap		= felix_init_regmap,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e589d07f84db..7c698e19d818 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1079,7 +1079,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.port_modes		= vsc9953_port_modes,
-	.init_regmap		= ocelot_regmap_init,
+	.init_regmap		= felix_init_regmap,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1

