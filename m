Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF824C14F1
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbiBWOBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241305AbiBWOBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:39 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E022CB0D31
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JekcSz400Xo+6DGiNseyI5/RKbE4RjfjLDw4jvx2b/KSLBPqTeZEVyXWLfbmSxB+LoaF0ZObJGgPYpiuqMeH2e9uU1wBcez5/huXckZSymXKx5mpFtCMFiJ0zRbfZhAiG5dN/2/QhXcD2vW2ijZ7XCS4z/l17VUposjQf1XJtwc5pTAvd5XifabYkzNBkE0EMpOsf85H1cVTNN4Gpcq2v8xE86Sba2tslf0+4IlXlfOdhT9QAwfAXYO4/YYJkrrDboL/i5Xt9qnKy4le5ZHGa8g8iwSedA+y4G/0972JD5ZgAYJCUXqdHIepYDmprjn7TCiXtuZJaBdOmwJylSJ3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcOU7Azb7/4LMMhQx3/IosQzNY+dF8sjTReQRHyMKXc=;
 b=Qppdk4haRtPIJXt52DKEuGVQ/boF3ehUl/aHvl4hOPsOpu4PWO71W2Q0eAbORcoa2pwwLPqIowDvEfzDsmWeOLEoAFrRB76rQR5fnjB6u7McMaGI3CdKSugIvevkav2EBo2NkD73+g81JDaEOhDseZYwmMOY5qpLrL9Ihg7w1GuYBv3tcLsjjfaWYClNHcFXdu9R/v4Ifhdwsl70OEjj3LQ9pwDYbEyFstJQgfwdZeOqH2atHCgXQReh8qGl1jBBX0xiXojdFTvGI47fzu5BX4Rbp+64r95tEUORY8prrB1H4f4eJYLtxg7NgePJL3CSyIjmR6e1WrlVBv7PKPRKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcOU7Azb7/4LMMhQx3/IosQzNY+dF8sjTReQRHyMKXc=;
 b=U4fBttD+Sf3PHiBYok+7flxUTWLS6B+7QkoZUL9OTSvRUj4VfI7RJXeUAPEsRHjSrGPorWCEj+ZExaE3T954Y+ZUSQEa7XU+yXJLmFz7Ndln/gLbaBU3Xd5dPEVuyOh6aFDk16cJFGAHl1nBWyQReo/RqrRJM5kESynTLidqEWg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 02/11] net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
Date:   Wed, 23 Feb 2022 16:00:45 +0200
Message-Id: <20220223140054.3379617-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb683df2-ea21-448e-1c94-08d9f6d4efec
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8701C59400976D486C57D1EBE03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWsRE74MU2A4+ENvvSjAcfwODCtvk3dcabsHRqsP5iLPo8ADqRFPpSaPU/3Yhy1V5BywQ/p7ctJC9AjM8trnzVoGm9en/VL2tIhAZpzuIQtbtSwHOdHo6T7t7nR6OWMEnKDqghjOJxli/lGm/8tjM8Rxi8prgze5eovWCb2rjQtzEdGk2hl5zP2BwhdgfOe58v7bIZHVQgIu4Q0lMNPth8VlLf7LnYbdJ9QRh8E6lLO4NXpHDzj1f8q2qz3yLyDP3Tb/YaU+PxMqFOThZ7iCKNIZYhPeLhWktJ8+cisGOyKRx7cLQmvbfLkecGlFRHc4T7do+2Do5hNqw2+hvrB6OJwBzF4pbvyN6wbsmD2NtP8MDaA1saQePd4INUpjgIHsgh1w3do3bbEhMBqInotXxr1JcB79n7VyJw1MurW6kZiBQyeRCMj3GdaxYceRg+a981NgCMBfALttjCH1kh9207E88RJU0ZbTg7WbaBGehlyABTWGB66dm/6OjOwqPmKSOmoNptVZwVX7fsEEzhkhriFL1YFh+gS2RzNiJ5IiDdvCHF2UYGXcu68OXBV8tuBeTyT48mhEWQviP0XnTSUDEkeXfbS4K+683Jgrzan4InbZxXheM27M87rqwsAyKhYp9LFeAkyOZ3TS2kTs7HHan1ikXJYk/6MWoBjJh/tyk5E7jq0ZUgo03T9icDsMkYitqcpIJD5g8eAtJmifPDSrEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(8676002)(26005)(5660300002)(86362001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9+eCITUHBk52MbUEBbzrqihucli35pO8+jfwJu9o58lzdn7WzOkov1r1+EX7?=
 =?us-ascii?Q?/latZaNK2gfbvmgk4MV/Ip2v7DIN3KR3lh8OcXVKv/9WTbDXevIPUV/w/ST8?=
 =?us-ascii?Q?VFGLsruRutcakBzVTZ1qiwQZWgYMRxC/gnpEib34DLz4N4A0h2JzYnEIJ40W?=
 =?us-ascii?Q?n377NtUS564hk5sNTB3r9uZ5OvUBqj/bWgv7BCjd7nqltmMZes8P/r67dIIt?=
 =?us-ascii?Q?sxM9xKtR123WCa+NmoIfzowmzbZShXSa1RWO7q+DHfbk6MNxlHBNDvAkz/Fz?=
 =?us-ascii?Q?RQHOEhyCMECbMS1ucsQymQ0bLF4WngdSa4E12bXWEttuX2pyEOpr0IZk/7Xx?=
 =?us-ascii?Q?+uQC1AZ2t104k8cr/dMaVckd4SYHlfw2060X/50yPk6oBOQzyzmMWDUilkVY?=
 =?us-ascii?Q?uFxmHaUGGu0o4t/sZKaLbwIpDUkD1MmnYsKfyDXeZEBesMqbSrLUxRYJqKRg?=
 =?us-ascii?Q?huwyKdqC9RG4eseWO9qnf2URTsCHFBiSLcoLoALPWBRToXfSi0Z5QwPYimtu?=
 =?us-ascii?Q?+pVpRmSk/EwQ8DqyPVAy7KY4nAJJjFQn6cigGfQaS4dSEzoP/isytH9McA0g?=
 =?us-ascii?Q?EduvxUpXWUZt6tQB5lKCxgwinJWmmC7RvqgR/Kn1JWj3VvwNY8cK9/fcigX1?=
 =?us-ascii?Q?MDW8Lpg7RV3KsX0RD78xv9QQ7Ag4Ac9t56UVyL81pYvWbvnGA/DiXSK4Fjui?=
 =?us-ascii?Q?enyB+7lrHMQ5tFVqWXvdxksGB2FqLL3BLSTotYs0AUVuTuKuoCWxaWCWhQuc?=
 =?us-ascii?Q?RTb5Je0JeOj9LQbe9TTARUP5WYZUFjGvLs7aoEUIKrhiCSj06f8VQGPUqNVd?=
 =?us-ascii?Q?/01F8N7QpHs9uM97nCt4AC13rBCGbn4id24T/jXLgmYj7FDcSURVZr1DDner?=
 =?us-ascii?Q?DTJIsWEEHqBt4BZkFI2VJVQGzluUKjLXr6tIhPKHgGdmAsrZrwDcAvGfufH8?=
 =?us-ascii?Q?SqMEBgGyWy6FEo0nRWNSlnaud3VbHq5LsOU/Tft8bL+X4+hetN6y0a94rMOQ?=
 =?us-ascii?Q?VL4CgYWcrXAtZHFXpUDIIKv4PJ2tVEV57ltK01W6kHjvLfgWdYTFem5Cf+sf?=
 =?us-ascii?Q?8w5PaH43n/7pFPPoFgItT1iMkIc+lNRxE07MECIkDlaUDKseEpz17yjyVawm?=
 =?us-ascii?Q?ZpoBs3SXY44MKFl8v1ZeU3sbWNslp2zx00sxaqTkIm3zbw6uZ3ocUUXtlM3C?=
 =?us-ascii?Q?t+Ly/xxPu8mW4dwgLriT+oh1d8PC61qPiT2CwiWz1FP87J9u2sekBIYW5rVm?=
 =?us-ascii?Q?cLYVKDeDAwKHDK9s4KMjgVuR6T4QD9oUChuI6NYrDTpQXA/vpr26Je2Roiim?=
 =?us-ascii?Q?wHhHZDmkH5I1PnxdlHKqpxTJBwDSROAyUK+HUDIsbrjdNCUVJT057qHl5IMT?=
 =?us-ascii?Q?jy1mP+7I/iXuceQ0ItcbGZ4cCWof2pCs02lw/XYCD9WhFKoZpsFnLqhPMiqr?=
 =?us-ascii?Q?bnl/DtvTC86nE84BNgwx1xmcHsDpc6apBGyf+D7aEU41/tFVJjJWnXnCdLKr?=
 =?us-ascii?Q?gwGJ/+FMyzrYHKQ0Re9NrAX8jDfH4sG9Gelyj/P80RWcccUdg0C5YT3nSusr?=
 =?us-ascii?Q?O15eSsAvHh4WTiF2fLej97qosff3tgAgPoh1Z4lCmIXatew0ewEtwRnQ9Nn9?=
 =?us-ascii?Q?5P46XImDL3vgGMGRQHYQKPI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb683df2-ea21-448e-1c94-08d9f6d4efec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:07.0238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtkBP+aodfjafpVmSc+COKXmMkg/JBkrcrPbmIFAI2rTPjzdSL2PbA+tkhlHr+M15A9W/djW2wd15KkzuyzBnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in mv88e6xxx to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 drivers/net/dsa/mv88e6xxx/chip.c | 49 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f7376024fac8..4703506e8e85 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6175,7 +6175,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag,
+				      struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
@@ -6185,11 +6185,11 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	if (!mv88e6xxx_has_lag(chip))
 		return false;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -6209,20 +6209,21 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct net_device *lag)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
+				  struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
 	u16 map = 0;
 	int id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
 	 * port if the LAG port is on a remote chip.
 	 */
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
 
 	return mv88e6xxx_g2_trunk_mapping_write(chip, id, map);
@@ -6266,8 +6267,8 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct net_device *lag_dev;
 	unsigned int id, num_tx;
-	struct net_device *lag;
 	struct dsa_port *dp;
 	int i, err, nth;
 	u16 mask[8];
@@ -6291,12 +6292,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	 * are in the Tx set.
 	 */
 	dsa_lags_foreach_id(id, ds->dst) {
-		lag = dsa_lag_dev(ds->dst, id);
-		if (!lag)
+		lag_dev = dsa_lag_dev(ds->dst, id);
+		if (!lag_dev)
 			continue;
 
 		num_tx = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (dp->lag_tx_enabled)
 				num_tx++;
 		}
@@ -6305,7 +6306,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6327,14 +6328,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 }
 
 static int mv88e6xxx_lag_sync_masks_map(struct dsa_switch *ds,
-					struct net_device *lag)
+					struct net_device *lag_dev)
 {
 	int err;
 
 	err = mv88e6xxx_lag_sync_masks(ds);
 
 	if (!err)
-		err = mv88e6xxx_lag_sync_map(ds, lag);
+		err = mv88e6xxx_lag_sync_map(ds, lag_dev);
 
 	return err;
 }
@@ -6351,16 +6352,16 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
-				   struct net_device *lag,
+				   struct net_device *lag_dev,
 				   struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err, id;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -6368,7 +6369,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6383,13 +6384,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
-				    struct net_device *lag)
+				    struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_trunk;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	err_trunk = mv88e6xxx_port_set_trunk(chip, port, false, 0);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_trunk;
@@ -6408,18 +6409,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
-					int port, struct net_device *lag,
+					int port, struct net_device *lag_dev,
 					struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto unlock;
 
@@ -6431,13 +6432,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
-					 int port, struct net_device *lag)
+					 int port, struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_pvt;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	err_pvt = mv88e6xxx_pvt_map(chip, sw_index, port);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_pvt;
-- 
2.25.1

