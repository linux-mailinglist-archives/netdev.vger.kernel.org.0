Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA595ECCAC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiI0TP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiI0TPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:15:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C42B67165
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+uKg8Rlb6YGsstfzJIZCMVPfsCvvlv6xCyaZ6CnLq16aKSJKw/RrJVgVrjI8XpVM3i+WygQ5SxNJKLBtVKftqwPufpW7V7VBzlNA3xE0npY0y/tfy3O9Ej9mVfik8LTB/MQgUHigahk5OrGAnOMdAA78PiBW9EsV/HNx9+rmH/L4WDb8/zRbdBZWh7mc7YTn6YKY6tPIfZRa4Nvfkdp5ciA4I7gG0DeefIBiwyqFv6rwBlVu0pKXo8v6DL7TgHVVJ1Orwi7MA3gcRdqAzrl/VjZQZyLEIJw7qWvtqWIyMWpWb0eRBGukNkUektvcqNIzu0AC8skTciHmjhz6at0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDnbWP/+vtuLUc0YPgcF2sM3AaLL2/JzkDGCCdWmY8M=;
 b=OpnYINSTJiKRQK1+z3Nq+cc4eNKoJH+qv+d9xrGYQ8J2/cFLZOAt5D5TpRQHXwwS4wNmLj1fBdRE0aE5uvhgebF+dVcUoDFnMgc9ar1tvCd/uhf/kNcEKm8byIsCHDoZYNYwpQCrfWGgY5/V4QGsVRGkb3jZLtGTD3K4bHap2ngEKMzATEHg+vXpj2FcuEg2gU9CW0Of35+cODNsEpMRpaIfEi8q+fiOovvvKqHZTJmb0cIrmV5L4FQDyMgoXvFvykbBuApc0T6v00ff1/ZHoHsyecvZZwixJLkGrpLPRPLOBCrflpEQypi3bfxOBPUEZ9MGfpqfX3KmYS/537s00Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDnbWP/+vtuLUc0YPgcF2sM3AaLL2/JzkDGCCdWmY8M=;
 b=FPAPM7OTi+mQ+nY+i/5ljMO2LJ+GwUkA0qnNMASyJj6FgxqwvDJTgA3kGNUjbJfQDbzWUnIqEgOgHJhAvVhby+zP3z8decpyk6lzlHluirNwy3dMf2WJiepgaigMIZQlKh8HSewrkQWO6Qp4JcDNltXW1aIwFUnADhYLEwG+4IU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net-next 3/5] net: dsa: felix: remove felix_info :: init_regmap
Date:   Tue, 27 Sep 2022 22:15:18 +0300
Message-Id: <20220927191521.1578084-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec754b2-50cc-4df7-a02e-08daa0bca818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYKnNoyh4g5bRYSuQ2GQk0TNTLF0urjyfngslvyR0po31vlb5VNetV8z4i4zopTWnLRVi1g/k/9idNdM6QyqsNTfX+L0S0tSPxX1WfWel2gSV+ejnLZcIE8KCYBuBw7yXZLI19YIZ6jEYLw78mYe/QaAgvLs49BZoDnKoU3+ZzN0awfBByhmrC09tKpb5PZLjNaSjQvRJh0ma82cvuRVy2iSuE3R2pg+g5z9RLLzgebXxZtj4kcAdtJLqx202zbfBSmBa13M6TV2hFJ1NSlKHlghXKZ0aykEY/4yuOdJhh/Q6a+1ZE+ZBLOy8p5EjwezdfDZZXFIXXuEbVGhs40y/AHWstC1bsLWkUjrXhPH5NQ5wf3j9iu+C17ljc9pC4hK1VxI6HHY/9efH+wQw5UCBd7nyMCBAAwCpkp94fRfG621hmU0Yh3f8Hx9FLdPQf0o4gHctY/FkPvcdPTk9ixII9wiLDwQ4Nd8cVmhqMbel5yflz9EZ+w8CLVaGpPR7PoyojlZGmlXDtBZY9djZ5FMWztaDuH3jqOswvy/dsZONqX6Zu3BazWPpL9VSIz/S6kRTJ7YBN6V86+32Bfhg67VcUdSczJ8RzLM7FHszt+XuwPhaKxDcd+bGJJTTEX+A2KTuXiKFU0sguoCzevktpzxLWYYOiXHDW4fi6cy72C6EzpXxdAEIVLiY8xm4t6BdUXjqX1Zag/t2Qg0WIxvZi4ItyLa63fGQr0W+RsyV9/9n8hIJwEJBcOPUz9Q/DMYHuXqYU6UyyxhEkAGZ0o3VJdK9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ar4wYLFdLFbDjSSFo4/CLlSMzIqxpuL0hoDMuQLxh08cl7SRSDl5pe517DpV?=
 =?us-ascii?Q?UCz72CHRdnQOqLJqRo8t6JvSBWcqNYoqqCaiwR+XyNPiMrMM9P+1beWxaE7B?=
 =?us-ascii?Q?5qNTroWfRXOSm+BdmKnnobJB4pprio1TIkypny5gGJ1fnZkfY9IzEakgxzRO?=
 =?us-ascii?Q?oheGMQnCyNIi4jEwY2WjyIDItJl8UayjVQ17Y2f0Cnpnr3EKhTuFyR2Ap5hr?=
 =?us-ascii?Q?GeDquYCA9SHoOdNdWtrpll2cvlSYA9fHLcT3Akn3SxodZaTX8kl6x2mrfGYv?=
 =?us-ascii?Q?WefhzVbZsuphVW8Ok1VhII7D+cjGHI5dzxourqS3kSftVp1q0eY+gg/PAmeM?=
 =?us-ascii?Q?7IrvNjhVvXZ87KyRt6u/dJ6njSp9KuHX9E6qkgJGnsztlUKtvALlD4uBnrso?=
 =?us-ascii?Q?ICX9+GGXAPO4VLzWAzAKKUVwRVthKpqHmQVOzeAsEh3Vy5Vu7VpLWWm3hOgF?=
 =?us-ascii?Q?M2JOmzkk7oYDtn5vWSHEgkvz/uFQN7xFZ4FFNh9tp93z2Yyh+GvsDJNGJeij?=
 =?us-ascii?Q?OF2x4GD6LPawKIGJLFJ8+xFWa/oRtYIPtkaqPKxsJYuegq4saM+FVfRH/WLB?=
 =?us-ascii?Q?kMSvvGDy+j63RQcFGQH1woyOR7zWrcIj5aEkLm7+4D8n97XWkL6to5r6wUUw?=
 =?us-ascii?Q?02Um/FerA234NzUEIkx0mLE4KsGObUkiZi/jTuEkofgY5BonER0IjaEXQWca?=
 =?us-ascii?Q?Q09qiDNnYo9g2HZM5KcfhOetqaq6ECMp3aqhrRwNYnLmWF4zf1KTU2mh583p?=
 =?us-ascii?Q?/ToLp8yN6efnaIntHcViQpFBf6z7OqikRDHhvYXJROBGD0GxymSdwiz2jEUl?=
 =?us-ascii?Q?E3/SLugJDMyOc7TCeE9kz/Ih/Cl+35+4TsNQpxnO9cIk9hmhNMpil+kcWsMR?=
 =?us-ascii?Q?WlHGfXeuNwLmiVHLeBNZcTT5b41l/ubHMVJoE7SLC9TxgHUNBdDI9QrwIjOV?=
 =?us-ascii?Q?P+BT/GhtDBRBZ9ByiyA5pzCx8sD098Z0dFu/zQJdGV9cDyUSUDXU7k54cjRC?=
 =?us-ascii?Q?qvtaoaEzEsBArcW6tABkVaFIlKQZmE7ARI1oR0t20c4KdBTgcSYpDPypTf3H?=
 =?us-ascii?Q?qUd5VHuh6u5NDSEcZhnPMyg/C710PzNZDUCCe9jCJ3p+tXotO72H93lT4kGM?=
 =?us-ascii?Q?KLQVEgW1f76UJj7tAzi3QMstj4p6Ming8hhBcMM42D5Uqgg4FLDI0+dqLzmK?=
 =?us-ascii?Q?MfAfi5WU9FATq9zv+ds9w/6UM5PvR7wViwThox4A7WCt1TF8G2Q9+rdJX0OV?=
 =?us-ascii?Q?qNPIkJ3maAffVXgKCdMNc1csCikfXLr8dv48+97M9Ijyy7MmFX53rL3NYLe7?=
 =?us-ascii?Q?3AJXjXvD8BTXVsaM49lgvWfSwSxmi4hzcSUDf8hlai7rB+sXIkyvbMyWmyK2?=
 =?us-ascii?Q?N+nSaYKnJYFumYNiIpGnXJgQb9Mj3ygP9GtvNkTFKYtMmH6dtC2FhPdwT0pq?=
 =?us-ascii?Q?lIHVfJoCGWPpWW6vCGpRJzH+iayqac8HPaaOBRXr8n9nmCa8c83TjbhtFkIO?=
 =?us-ascii?Q?rVCFJYjDSMgAwdAHQl0AP0t+uXJiQ0exkShOSGlgtJuU1xyRr6+WyHxuedHc?=
 =?us-ascii?Q?NkzqmIr2pjw3/1AUSywfAPNikSdV0ambgc+65ehLboYoiWLn7Rj3gn0bgGw+?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec754b2-50cc-4df7-a02e-08daa0bca818
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:36.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8gvIwaFE0+TQlzWpPs5pj96dTCqqJJ/+halbmnYCer68JrxxCnsy3Im+C6lzM6qhEPKurfHlOUhugkN7vzhow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turns out that the idea of having a customizable implementation of a
regmap creation from a resource is not exactly useful. The idea was for
the new MFD-based VSC7512 driver to use something that creates a SPI
regmap from a resource. But there are problems in actually getting those
resources (it involves getting them from MFD).

To avoid all that, we'll be getting resources by name, so this custom
init_regmap() method won't be needed. Remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 -
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 -
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d2a9d292160c..b7a66c151be3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1360,7 +1360,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = felix->info->init_regmap(ocelot, &res);
+		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1397,7 +1397,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = felix->info->init_regmap(ocelot, &res);
+		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4921f5cc8170..54322d0398fd 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -55,8 +55,6 @@ struct felix_info {
 	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
-	struct regmap *(*init_regmap)(struct ocelot *ocelot,
-				      struct resource *res);
 };
 
 /* Methods for initializing the hardware resources specific to a tagging
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4ca9fbe197c7..e465e3f85467 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2617,7 +2617,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
-	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 5b29fa930627..e807db0dea98 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1078,7 +1078,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.port_modes		= vsc9953_port_modes,
-	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.34.1

