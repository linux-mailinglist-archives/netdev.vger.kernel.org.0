Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373F44BEC8D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiBUVYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiBUVYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:32 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37A6FD35
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE0sD4mGus2RNnuYtKDxwyAy1+FtqbodEEZesZUdA70szWZsu+8ItwN2jQfH9whOtFxAnOxN+yC+4ampQZ2iKk8vUkg3qZQGcI9DQR6k7gwma0kb4Wg3a8erTCwDmS4so5O7m8W+qilA3YCG6tXcvyk5G97PrTfItsc6aE9+rFW/XryLEfX92Tc2BdD63MlUo0nc1bcrrrudeL5CKg4h0BO06B70AzSO/loobBPVqiGjuqkd7FFrpCKuON7tt/SOdtYN4gWczv4bof8164o/q3wTQnYy2GJc7JEJUzXd4VKZ4WaxEtDEgvpnMFyYMnXt8P7f1mAlynDnz35ovswyQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PR1X/C+RAD8PaWhIvaf09Sd+uqmaQZBNkYiXZdOVr9c=;
 b=FsZo3G1DsPBGDG/bctwbxLEBWzhyJVP9MUsaWBXXQIpebzDGLEN24pLsKoSbxwPsyC+mlQKkFzL9K6N7ar5DN6cixFqZmDyY7qWwOdmLnDpk90vC5yFyKz/TQENhjKZVd8V/6zwHz10fFELwoYVVsedjsqscsn/GTI87rsNPhXI3iFBlXobDC0Hh2t90vuXOV+9dsJAgN9xUOITquA7F13kTzZ/A/pnTmev1RiNwqELThVcEYLxBi76qmri5CUll54PecDG0yTOuUconkBVGhNtHARaUClC/AYQAIDMUIHooAlwr+YIFFIZDedWCDd2JFM2gtoZqSjvSHV7HxkemMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PR1X/C+RAD8PaWhIvaf09Sd+uqmaQZBNkYiXZdOVr9c=;
 b=ewlufKJehliN/HkKfGn1+FJRT4VGsnz23mR9C1IBEDKD21k4eEuI2O9uhS0RUAl+hUEh4idYupAVWC9eM5wuGCzChsyYMM3+6llvfdr+4n3seBYov/e+Rx0mXkPavdYSVuou12aA/EBeooR62jILMRgjbypp2Ze7JBynK3KxePw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:04 +0000
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
Subject: [PATCH v4 net-next 02/11] net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
Date:   Mon, 21 Feb 2022 23:23:28 +0200
Message-Id: <20220221212337.2034956-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e24edff5-424c-4e2d-7e25-08d9f5807c2f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5645D1FC809B021AE67717E3E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qI60hzZSzWrKC9XOP1Mh74M9s+k7V2gYUIj6YVawj5UudsPFXjCYIhhpdeXD++hu9iHhZBcltIBQIGqjLO97QljXcHPdDi7IXPphKgKHslwHRnTpN+tdf7tQWaQxOpUk+sNnva+WfvFLaGjoVwtxygCxQ3ZeH4wWUwKrgbbxp2uSjEw3Qo6br3vuBjejWShGNI2Fr11gdLOhrX8dTR9eO1zcge1oTdA/CKGmk4WQ18IpTymgK3V9WF6L6nctQAv2gmSMf+6l8PJfBJqEyJutiOgubuogBzv2TsA64Ikm5pGQUfALN2e4RgzmoxPNcaefNSUd41hbusdp5AEhjnzP6ZfYax9dBDMCumzlldbIEbOhNfqezlv7UjsduqgJmAnnb14XfflSItZnAesbsR/xwkZd3tFTGMBPbZwUTclYEzQJyV92cjsTn9PMnI5zaohIK45WrlvgfrtkDXtz87a/sWxu1lkKatBIKubxjRrXYUxW6K6xB3NwPSwSRUf39Q3j/x5GBedeLj1o6Lw3P7BIckFzeMDHjQu13sHLjuF/4HaHtMEFnnH70VEnqvnDvaw0VSOoNv8YoU2VfgxyJXj9HOG0Tu/O0VJQOhqQoQJ9Ax41zR8sQYj+RF5Qy1b4JRRq+FeGfYApGEnpp3xePG+SP+pGVIsVk3A1jqm6tV2QiyCWTdPA5xjefjfbFVu8+RJbewgYqQmf2XyjVGwXkr17wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rxu1mSsPq5NTEESJjE9UDHiB8YPwzZdT/mKobsn2auyCU3NxwTbEwX3wIIGw?=
 =?us-ascii?Q?aUvRD8yvhPvnfGF9Ktx7Yejae797kc6fKkiJXv053qF+61GH2QZ4ag/3JTWN?=
 =?us-ascii?Q?5L22aZpVaIkIWvva0l2pficdxY3k2/VpSbaN2477EH/QwOQecIy9XkxHxul+?=
 =?us-ascii?Q?xDcsFZRlLJvqFqoDgWOO/kKyQOWeERFcEiVZdbJ/j4hg4lbrYBWPaJOBkM2A?=
 =?us-ascii?Q?zSrLO9CZ/sJAzh3FnUZMP1ik3IdqfqAAg3t2ZACEb1xFz6heGEtwy5WfsN/N?=
 =?us-ascii?Q?ccYufFzViHqsu9H+lIfFFsgX75icTg6Q1WDaClOoxPb919T8La+xGWYm4lDb?=
 =?us-ascii?Q?S8vF6JzB41qpamt3UnLU2Jo5yFiKPdWOK5iIWWOS/Eg84yMR/gdFeYKE5vgE?=
 =?us-ascii?Q?azVuvawsCV36d9QLjWtUCn1zE3P2GTbGqksgwEzeIr1d48yEaftxDkOkhST2?=
 =?us-ascii?Q?B1m7b3tOrzI3oYqsyKO4lHi92RFB8P4r7Dc1240K6odWp9vR+u0ZfCkrPzT3?=
 =?us-ascii?Q?/uAyBc8GqqscTE8lA3Pedna/QMbyOUVFoz1nn2fxZVsoKAKGFcL0krcCvwG2?=
 =?us-ascii?Q?n9KAJrujAoGSpGU6Mbw5QFADN613fQwO9disBRV+tL+1exe4Gls3rPAqbKCt?=
 =?us-ascii?Q?BQu3/DznAwdGFwI2SHq4/armWTNBYQXQJY10K2p0ee3N0JkvvYxO45/p9+yH?=
 =?us-ascii?Q?n+ypUn1OZEfTVwBhmAAyKenmCrcGB1vZGs18hBn0J4ILtkYKMWAhHeblnE6Y?=
 =?us-ascii?Q?WKWZMzjGsGcpPk5i6OveWOLJNn+e/hbM5g9+RMEjd1OyMdn6Gjbqud64H/SL?=
 =?us-ascii?Q?zMU68nsADlkGj1/QWQ1xWMdhcGHylnpzvTZ7cc/6BTw4mS3KyYVeyH2KurBy?=
 =?us-ascii?Q?tHqxkWR0BlpeBwzYPI8UsHgbHOhIyij8wQ4sG5EmA5jEaRbek6rosXl7NlA6?=
 =?us-ascii?Q?NW0YgCPtceA+D7ZvCgjotkQVfjSlqBWxT27zB3xWzY40knGPRrOIshBN/KM2?=
 =?us-ascii?Q?k8M8Xe2TiGIfHPo3HUXzqwSK7RXBIOF/i/Sm7krCrs+u0xJMGA84wJqbZgsx?=
 =?us-ascii?Q?PhwzqXNuFFU6ehWR/jWXByR85O710uOuU3F/xUn9/687yAquzu1Dk/mAm/jr?=
 =?us-ascii?Q?F5c8cukrBiK8VPfi9WTAju4rQsdVlsojk/kqnnkRlABVv0Xgua4AwJPnrbnt?=
 =?us-ascii?Q?+IwlvPar9EwgZJYeqf/v7t0dRpWeJ7rHoUTpkjfov3kGOB1jbpfcEXIslWlz?=
 =?us-ascii?Q?6pMs2mWNt6fLYyN0MPp5hP1yNxnDRpy8SfqiY/cYcQDJq8bvadygc59PkklX?=
 =?us-ascii?Q?cYcO4h1kCUHgp3mYgQ9TnHeN80ISSKsQiIQFj/Zyf5ctWHbOLjylUFqsSIrk?=
 =?us-ascii?Q?J8SNdDSE0q+jC652d+NVmpkhrDYzPwPeRrR9Xw6oEIj0s6VR3g/j91gQxzuk?=
 =?us-ascii?Q?nHrAt1MbWDqz8jyJFTJ9XHeIwDP64b05pAVUFjRwdLlkDuVsyFII1yyhA21l?=
 =?us-ascii?Q?CHm2SlWglHdFM1zI96yAJojwIkanXlK5tZypEDrz2SwCXyp63hpltYzLncxU?=
 =?us-ascii?Q?3dtqj1/9q6QvjxfJDvM3+ByVg/8nbo6I+lri/Of93/o+/HCvWFrgC9mpJidW?=
 =?us-ascii?Q?9RG2ItKKQJnJdWFtR7LW2rQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e24edff5-424c-4e2d-7e25-08d9f5807c2f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:03.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EnOn7ZWUXIHNwEAE+MfIGL4H9TjaZuWn3P911xWNnEE/SX2M30dLQNZEwDtRYtJG2Ozarsm1VToRbGPm4IVmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
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
---
v1->v4: none

 drivers/net/dsa/mv88e6xxx/chip.c | 49 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7d5e72cdc125..24da1aa56546 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6168,7 +6168,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag,
+				      struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
@@ -6178,11 +6178,11 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
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
 
@@ -6202,20 +6202,21 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
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
@@ -6259,8 +6260,8 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct net_device *lag_dev;
 	unsigned int id, num_tx;
-	struct net_device *lag;
 	struct dsa_port *dp;
 	int i, err, nth;
 	u16 mask[8];
@@ -6284,12 +6285,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6298,7 +6299,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6320,14 +6321,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6344,16 +6345,16 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
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
 
@@ -6361,7 +6362,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6376,13 +6377,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
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
@@ -6401,18 +6402,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
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
 
@@ -6424,13 +6425,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
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

