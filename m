Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8363522FE8
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiEKJvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiEKJvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:51:12 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF1B193CB
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kmsmdk34ubYwUkoeAAaPpo6fr1OnRkQ652AporZVRipW+J3NwWNGGB6YuWa2PDC7T8mmgHYhldUmG/xXoF3sar/rph3msRReHR2ItT6Os9F1Dx2unpre7ICoT0zvWMSJwOlO3EYk4ywqoNl5x2cYE/7XvMAnjpRIw6jbzn9lHvnFtzx1iklImtklXXl1gw2hYgEEDiwxb0JlvcW6est1DruoBTs7gPciIr+Hkc+6LdxK3lJ97yXUo8H3KR6IIaR5/WoeIoN9mMQsbBlRy7bKuZo4yPStyiectkh4yZ5rmJgsj4+0KDDFP8JeBveI+vN6wt0obTLkhWrnvTxOE/b1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdtJnW9SUIglGHsc8kngW7WxdRtiuVpVZg/pW3tyHro=;
 b=kQ/5qKhrBRgD5U9q39AJi+9+etEyyNhROH6gfymk/UwFls/LErH3kh3g63gOEixILPCqr5T8DRfduMmYDpHx/s8Ex4JtoZRNMKb/h5F9/ad7lqOiiCIHoGh8d/Ndpoej3gnvhdvN6DBuWNHjoeph2a6UQL/BuqJkU6Sx7wWeKIGrh5/13OU39/Uzxf7j/2PvJoWzoCh8isFOlUUXUFUw9Y0mkheFu2ozB0sSASirdv3Wp5O6GRvkGVFCJoYQy5qosYJnMdQYDhKTbxC8maDQ79sbXh/7GYfnS5WSMeEgYTtce2uTtv61rDpRFHWUzCreIBMYz8kqwEk1iha8dLhD1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdtJnW9SUIglGHsc8kngW7WxdRtiuVpVZg/pW3tyHro=;
 b=P56tAyh6KJMrXG06XXz+TRLB+86pR0qGhDYhYKzJBMRdeCC8RysyoKIhlolBDf0owRiJG7DbiiZd4N0MOaW1BVEzf0uPOAWeFMEXKzvqMhdslgt64VN3g41ZRbl7EOyRcw2U/JE+b602sVScWkdJSgVohazBoscA/srNqcUBTi0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4964.eurprd04.prod.outlook.com (2603:10a6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:50:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 6/8] net: dsa: remove port argument from ->change_tag_protocol()
Date:   Wed, 11 May 2022 12:50:18 +0300
Message-Id: <20220511095020.562461-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ddd7a6a-522b-4619-bbc2-08da3333b7d0
X-MS-TrafficTypeDiagnostic: AM0PR04MB4964:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4964FF2D66F452AA3E217BC9E0C89@AM0PR04MB4964.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49JYiVXtqpBoJwZBueWgxT/5s6XGAFlsXUhN1+qbdoyl4CB3vUMCBEbVrpwBQMWQ8tIlmg3qELXItUcVLkgXjS7vk/zdjMuMk/Jrh61/HEoizyTMoOOrR5vSKov2qE/kA8jNquRx9Sc+Zjq4YZq6TYw85DNuB4MzqPCh+SVbr+yYMSpbTosHzqzqBhlcGaAd44pbDbuAbfTFBM4ykqLI0qMDTWP7chwE+Gi470XiYI+/l+5EwoCR59HNsgaNZVz+wLlAL2QnPDzPW7j66KPbIMHTWStdkOEarSll0mztjsC5/EYuT97B6fUh+rG/Y7QHMX3NXBDl/CjxCuiSC09c04SjB3U9ppeOXlLACXUM3vH35Wpeo68s/cJCgkO/JMjncwu5J6j3ZV7ueE91i94gzw2YChZJ77hc3HERROqOCJkKD/OW/O5vY5nPhsOTn5VOixxiFZq9C0NVb/FtMdaXmsqHIVjoE/3DhjVT+2Rh561TscjqRBwyo5QfOtVREEAwUje5ORQFMC8MDj89zZGU08sIKM8F+Kfr/khMgqzhtrSVj0gfEE4BpO+J1xSydwzqf51gyBzPW5lfPe4hT//cBWyTgkJWgVmakENt+ehiVaBA2r/nhCyhKTGIQDM9H1iHgYlRq7zS8ExcBHoklH0BWEZh3pQk6x3cHoGWyzO5gdIjWOQpNwGqckWY2GzARhyq3Ovp85qvwABdadlvtxMU0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(38350700002)(66946007)(6916009)(508600001)(66476007)(8676002)(66556008)(186003)(1076003)(316002)(83380400001)(36756003)(2906002)(44832011)(86362001)(6512007)(5660300002)(2616005)(7416002)(8936002)(6486002)(6666004)(4326008)(6506007)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G31v1D8s60rah7VY+T7HfSqR2eucnhd0c5EEf42UVnolq/BJ6J3qFoaKAMD2?=
 =?us-ascii?Q?zSBQeim1+F2Jps1ttNmC/fE2Ts+Dw4KJFRbx7UpKTwNG45UflX7OaitvzHTz?=
 =?us-ascii?Q?tUqQd6s6WY5VkNEqnU+pt1XjjmNXePLqKDIf2wVd96L3fEA7216tF8rXsm8Y?=
 =?us-ascii?Q?RZGFCov2TsZDF19zWNFj5bIxvLRicXQuqD8GyzJi3NZlUfE1ZHvYfAzRq31U?=
 =?us-ascii?Q?LNx9xTmQKKRV/Cx/kufo8xf4VURecBb79KMUoeIRNKC9i2qNLOW4lkrgPFQq?=
 =?us-ascii?Q?WRKY7A6V+iBbY1SSQgxVCxCUWteAAA8kJNe14Np7a/uxUC8RNvZ9FPIdp7Av?=
 =?us-ascii?Q?mIWhNUW87IC1QEFBB1E6ACyiQQ8Nwl+4d8qIpkPDLNPZt64S/9TJp6npx1O4?=
 =?us-ascii?Q?3As1tWt/wad2L+ZtS55gzbzLAe5R0XYY9xeennM5Mzk0mSYFBHl7jT9EVCWb?=
 =?us-ascii?Q?i7OSX60rp8x94JWmFt7hWNXzgbZ1j11+5vE+Bg+s7KRJAkqyKI+3PjDKdbuc?=
 =?us-ascii?Q?UG2ZnYi8M+FgW5zRGqWnkteTmMTMEsKO+MkuN1GPHih53q4YUoGAReMvBT9y?=
 =?us-ascii?Q?/eTBIY/xSMJ3xRkE3UoN9JNas4CMBFZeQ+nvivdSsfXzuEyxt+HNrdO6KSW6?=
 =?us-ascii?Q?sa/4AWnUjNOpVqXBYx8HIY9cLJvK7x1UUEhhWcd3UEsROSTzXoMO3enXnJd1?=
 =?us-ascii?Q?DBeLZlCT1Xaa/L8GxDTQReumYphQOX49xCmMCfRe3WR4gV52UkRuTEJbyRdH?=
 =?us-ascii?Q?CfCosZR9ZHJTpbKD67imfgWW5t5NYCLTZNUUG8qLJ1xnEfw6Jpp6Ps3Su8Yx?=
 =?us-ascii?Q?H3xXnSAFxPqt3Bze3k+1g7Gz1dzy7phVjv02CwMYcsj1isaZkrOtYJmRi6SY?=
 =?us-ascii?Q?JFeaUCYw0GW+bd844WzaydRnBNzHo8SHi0Ln+2ySo7sj4mcCOmICGGpX/EI7?=
 =?us-ascii?Q?q98+juaSrto8/xgV0lsoTUxXL0Q2xMyXY1EneZe5aOL2t+NxDUBWruMcd5La?=
 =?us-ascii?Q?oVpfJxpGYuW0FyZyVLI3Z+Be0khc+9wcXDIxpevIB6yksae96V0wMQqKBVnh?=
 =?us-ascii?Q?uBNWM1yKiqRwp98HP2Peff5tZJl/zKG+27tSb51Qik4ChIojr+yLhhhSq0gu?=
 =?us-ascii?Q?uMbS73umYW/Alqdldxb8QkpVPIdSyl+5HPBlZMZrarf8cw6dPCWuDJQY9V85?=
 =?us-ascii?Q?9iTc3Ff71KaWxehrSRIA/sdSLQ6bIoipYEqznBUIBWs1nmU6Byj7EqrXAazJ?=
 =?us-ascii?Q?3TJDrV/cv9oRvl8pukJtN9YyN4q0YxomTmjW4+TJqYMNr/qOta/KknF7N169?=
 =?us-ascii?Q?UQDe489PVare1+sZB9f+5k7A1jMmNA9mvknGIs5NHQlcMg5cto7sNSUtaJnS?=
 =?us-ascii?Q?qhpRsJSGLo/EZy0djlPCcM2oq8JWbCiUBBCByq+lahfxyRqLieArnU4fJuo4?=
 =?us-ascii?Q?5+qvB7HPg9k9odHTKXwIbdoD8PkhY35MM/CQHCmlJF/+sPqw4KOGUXiDXytA?=
 =?us-ascii?Q?FBGf2PaXlQOY3v2AtXqDPY56NJyLr17s/zAgfHt+zqEeahRQrcy9MjTvckSW?=
 =?us-ascii?Q?fNPjVsCHN5Ej/8x9R65n0cSMm4KiNubTMbeSa8KRte7DX358nnu5UKC5Fau5?=
 =?us-ascii?Q?zxVEaMKSPnW5VvK26NzrlJd6KYREE64ZrrR+lLYYFsU++tVfHPt0maeJWc0J?=
 =?us-ascii?Q?2g7dXQWLmsoyYFIn9I8nrRJI7IyMyQlWxLgcTE6QaMpJ1WuylfaUjv6qsqBh?=
 =?us-ascii?Q?W+uMLikRtrdP47oy5QubagbA+HRTv1Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddd7a6a-522b-4619-bbc2-08da3333b7d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:44.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzOOLx2nnXWbJVgrA1gUZXspt4VgllZRibOf/jkWppUs3FMbNASQWwIt5s+LAHPrxRrZ/LQNbSMb0nds0Vz2TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA has not supported (and probably will not support in the future
either) independent tagging protocols per CPU port.

Different switch drivers have different requirements, some may need to
replicate some settings for each CPU port, some may need to apply some
settings on a single CPU port, while some may have to configure some
global settings and then some per-CPU-port settings.

In any case, the current model where DSA calls ->change_tag_protocol for
each CPU port turns out to be impractical for drivers where there are
global things to be done. For example, felix calls dsa_tag_8021q_register(),
which makes no sense per CPU port, so it suppresses the second call.

Let drivers deal with replication towards all CPU ports, and remove the
CPU port argument from the function prototype.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
v1->v2: none

 drivers/net/dsa/mv88e6xxx/chip.c    | 22 +++++++++++++---
 drivers/net/dsa/ocelot/felix.c      | 39 ++++++++---------------------
 drivers/net/dsa/realtek/rtl8365mb.c |  2 +-
 include/net/dsa.h                   |  6 ++++-
 net/dsa/dsa2.c                      | 18 ++++++-------
 net/dsa/switch.c                    | 10 +++-----
 6 files changed, 46 insertions(+), 51 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 53fd12e7a21c..5d2c57a7c708 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6329,11 +6329,12 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 	return chip->tag_protocol;
 }
 
-static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
+static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds,
 					 enum dsa_tag_protocol proto)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	enum dsa_tag_protocol old_protocol;
+	struct dsa_port *cpu_dp;
 	int err;
 
 	switch (proto) {
@@ -6358,11 +6359,24 @@ static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
 	chip->tag_protocol = proto;
 
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_setup_port_mode(chip, port);
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = mv88e6xxx_setup_port_mode(chip, cpu_dp->index);
+		if (err) {
+			mv88e6xxx_reg_unlock(chip);
+			goto unwind;
+		}
+	}
 	mv88e6xxx_reg_unlock(chip);
 
-	if (err)
-		chip->tag_protocol = old_protocol;
+	return 0;
+
+unwind:
+	chip->tag_protocol = old_protocol;
+
+	mv88e6xxx_reg_lock(chip);
+	dsa_switch_for_each_cpu_port_continue_reverse(cpu_dp, ds)
+		mv88e6xxx_setup_port_mode(chip, cpu_dp->index);
+	mv88e6xxx_reg_unlock(chip);
 
 	return err;
 }
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6b67ab4e05ab..0edec7c2b847 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -575,14 +575,13 @@ static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
  * tag_8021q setup can fail, the NPI setup can't. So either the change is made,
  * or the restoration is guaranteed to work.
  */
-static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
+static int felix_change_tag_protocol(struct dsa_switch *ds,
 				     enum dsa_tag_protocol proto)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	enum dsa_tag_protocol old_proto = felix->tag_proto;
-	bool cpu_port_active = false;
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 	int err;
 
 	if (proto != DSA_TAG_PROTO_SEVILLE &&
@@ -590,33 +589,17 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return -EPROTONOSUPPORT;
 
-	/* We don't support multiple CPU ports, yet the DT blob may have
-	 * multiple CPU ports defined. The first CPU port is the active one,
-	 * the others are inactive. In this case, DSA will call
-	 * ->change_tag_protocol() multiple times, once per CPU port.
-	 * Since we implement the tagging protocol change towards "ocelot" or
-	 * "seville" as effectively initializing the NPI port, what we are
-	 * doing is effectively changing who the NPI port is to the last @cpu
-	 * argument passed, which is an unused DSA CPU port and not the one
-	 * that should actively pass traffic.
-	 * Suppress DSA's calls on CPU ports that are inactive.
-	 */
-	dsa_switch_for_each_user_port(dp, ds) {
-		if (dp->cpu_dp->index == cpu) {
-			cpu_port_active = true;
-			break;
-		}
-	}
-
-	if (!cpu_port_active)
-		return 0;
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		felix_del_tag_protocol(ds, cpu_dp->index, old_proto);
 
-	felix_del_tag_protocol(ds, cpu, old_proto);
+		err = felix_set_tag_protocol(ds, cpu_dp->index, proto);
+		if (err) {
+			felix_set_tag_protocol(ds, cpu_dp->index, old_proto);
+			return err;
+		}
 
-	err = felix_set_tag_protocol(ds, cpu, proto);
-	if (err) {
-		felix_set_tag_protocol(ds, cpu, old_proto);
-		return err;
+		/* Stop at first CPU port */
+		break;
 	}
 
 	felix->tag_proto = proto;
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 3d70e8a77ecf..3bb42a9f236d 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1778,7 +1778,7 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv)
 	return 0;
 }
 
-static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu_index,
+static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds,
 					 enum dsa_tag_protocol proto)
 {
 	struct realtek_priv *priv = ds->priv;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index cfb287b0d311..14f07275852b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -579,6 +579,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	dsa_switch_for_each_port((_dp), (_ds)) \
 		if (dsa_port_is_cpu((_dp)))
 
+#define dsa_switch_for_each_cpu_port_continue_reverse(_dp, _ds) \
+	dsa_switch_for_each_port_continue_reverse((_dp), (_ds)) \
+		if (dsa_port_is_cpu((_dp)))
+
 static inline u32 dsa_user_ports(struct dsa_switch *ds)
 {
 	struct dsa_port *dp;
@@ -803,7 +807,7 @@ struct dsa_switch_ops {
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mprot);
-	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
+	int	(*change_tag_protocol)(struct dsa_switch *ds,
 				       enum dsa_tag_protocol proto);
 	/*
 	 * Method for switch drivers to connect to the tagging protocol driver
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cf933225df32..d0a2452a1e24 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -809,22 +809,18 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 {
 	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
 	struct dsa_switch_tree *dst = ds->dst;
-	struct dsa_port *cpu_dp;
 	int err;
 
 	if (tag_ops->proto == dst->default_proto)
 		goto connect;
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		rtnl_lock();
-		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
-						   tag_ops->proto);
-		rtnl_unlock();
-		if (err) {
-			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
-				tag_ops->name, ERR_PTR(err));
-			return err;
-		}
+	rtnl_lock();
+	err = ds->ops->change_tag_protocol(ds, tag_ops->proto);
+	rtnl_unlock();
+	if (err) {
+		dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
+			tag_ops->name, ERR_PTR(err));
+		return err;
 	}
 
 connect:
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 704975e5c1c2..2b56218fc57c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -809,14 +809,12 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 
 	ASSERT_RTNL();
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
-						   tag_ops->proto);
-		if (err)
-			return err;
+	err = ds->ops->change_tag_protocol(ds, tag_ops->proto);
+	if (err)
+		return err;
 
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
 		dsa_port_set_tag_protocol(cpu_dp, tag_ops);
-	}
 
 	/* Now that changing the tag protocol can no longer fail, let's update
 	 * the remaining bits which are "duplicated for faster access", and the
-- 
2.25.1

