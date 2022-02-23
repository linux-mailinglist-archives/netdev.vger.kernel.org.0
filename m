Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432FE4C14F8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241344AbiBWOCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241350AbiBWOCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:02:01 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30086.outbound.protection.outlook.com [40.107.3.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEADB1091
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dj4clfcinSb1E4hRJEt7wjXzXyvsnMsRq5LuvXibohePh3WqgLT5rJm1uF1yfGvEchKL2sfF2IYKYMLmUuysFvlFiuzvgtjRtkPA1rh1skHA48qGqOa2O1saOCFAXgJdYYDTyDjvVAEwiELzTvntVx3hnP1tOR3d6n9JyWQRGsoEOowkpzHnL4jMDQT1/4VURXYEvwqpYRn9q3Q/5FXHoJWP5Afd8gVf7ZB8LYM9qMEC2D/RPUk3lAdHoGP4SclaGRpllrzEAo51tL5/T45c70t+QDcTUR8MBOCyQwVR7VdYu3MwMxg9LiOKc4x3WJbwjpUSJZdnmmyYABK2FrS+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWMDu4cusu5mJLOpbyJk6OtCUHw8jUGiZAa+Sv45MP4=;
 b=E5oOWRxHHIysmRwgb5lDfKaLCsqgPvoX6F7ER6w0emyFDV7D+Gs9muNA+IsphnVNCKj9wuKRN7bL/Oxj5noNTC2rMoOwo63zxkY99sxnQ8Clc2ifFLWefYLcd9N8bxaHHFKcjYUmkVmepMpy05opSN/WH6TvIvPSeRWWYqPmKoJtks6cBgC2jpk43/H6GcValgIjhkAZFQu6hv67Cv68f2Ywq/26i0JbKhaDzHqYug6sWs/UtczbVgE0yVMe0AoGBRqhnoJPeOKSNzJA/3yF7F5i8GVyqdJ97srmZZDYcRRafh2AKEAUFq8w4SFeNXcQWHFG2S6svE62Q0xu4VivcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWMDu4cusu5mJLOpbyJk6OtCUHw8jUGiZAa+Sv45MP4=;
 b=UJxp5KQ/cxElKmhFFck2A3wzyBgQY7wU+qLbGMshgJKklx3YAV1DExQk2ARYUI3Vi8zzKb5YxdZU9i1//A+z5ungEKjPfFsfI/HkXjH4VxsOWxevINE89rqhWZR5H/ZSRxd/1g/AnJxlNjJcKUfpu4MZ0LflxptVbSJRqCk5/xk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5164.eurprd04.prod.outlook.com (2603:10a6:10:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:21 +0000
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
Subject: [PATCH v5 net-next 11/11] net: dsa: felix: support FDB entries on offloaded LAG interfaces
Date:   Wed, 23 Feb 2022 16:00:54 +0200
Message-Id: <20220223140054.3379617-12-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: ccd68dcc-4c11-4e56-ce4b-08d9f6d4f841
X-MS-TrafficTypeDiagnostic: DB7PR04MB5164:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB516404834972C902B911066DE03C9@DB7PR04MB5164.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJXH8ohW/Yql4KKZkGoBEp3B/lDwwWnGM2sl8pTeK5kf3xEp6rDmDkcimpyZybF9pgEd384xvEW0+mq4pRrZqSrEdIF5P8ugwRJoDHgZEiHI5rLkx66949Om9IXUv4PxezsLWT1bjvmIvivUZhT3Y4nMZky4pCkQiPHxUIZupUb24XHJxnZJ06SCTR51lNmD1Q76MiUfF2Cza46Ym1IfQgsmFWA8rjddLjrzOUUF+RHspkIS6W2kKSdxxwWGwGMlcZhxjM88qlFZrUOFzqCFOe5BzmHm1c4zM/kJz7qrCT7m3qZXRaqTr5SD7L9+GmCK2kaziWb5rCT1GzkILGRdu0GYDh/O1ZkS7uTx8wO658midvL0yu8CFiwyfZppwsi4uJDmpQLzMNpAheVnT0HbFP3d077/Y/VABfn3EQIXqQh/2ymnsDdhPRxvFOK2cD/6DN+rEDH6CQ070iBmxaeBYO3lRxkh4avSy4dXqfff842A1cuDmjQkYU9cj6B4FvAM2/Wn1o0Rnc0Y4b6FH8LTGWL3gqIKshTYWul1UgoHCJObis8K8+NrfVy78XfMe0R4oWvdHnGaFaE2LKG4eC9ugdeh12qAYKD57Wn0mvmMOqqiCJkutfkmjfntktSHJL9UBSfjMYdNzJIBAl8ElZw8Xxmethn2PsNrMv8ppMAcwjm58vB2GDQSeMWAT+E/Qa3GFWr/iyo5FABHeTiVvkdD3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(38100700002)(66556008)(316002)(6916009)(66946007)(66476007)(508600001)(54906003)(6486002)(36756003)(86362001)(38350700002)(4326008)(1076003)(186003)(26005)(83380400001)(6666004)(7416002)(6512007)(6506007)(2616005)(44832011)(5660300002)(8936002)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXXHPJK+4hRY1Mc8KKrZ9KoZkP4Ub0khC/4pp0yluor0c/PjcLwHUm5vCJBz?=
 =?us-ascii?Q?2BLZC1Ffd9vhK2XxZUOBFMnPPCDsQ3i5LGrN75LVVMv+VL805YoYyFXf2bNs?=
 =?us-ascii?Q?QmM25/r4p5WMDPTQ3/KClmEXHC38FrL12YPS3cXBjlNuPezKLIpq1NqHebB6?=
 =?us-ascii?Q?7ERxSB0mhUk2h7T1COzplqkgGZIS3O/z0hO7yWPb8ejiG/nOV4KzX1pBRa0j?=
 =?us-ascii?Q?5+FkrOGrqhmy6FUHZBokfDkQKo9aKWbWnM0vRK/bOP7PQGELEloOmr8K/MjW?=
 =?us-ascii?Q?W7JOZArPi6pgIsIxA3BTXYvvoMALR2HXrx6DhwVF5TDphzCUeazTVf7zECqj?=
 =?us-ascii?Q?W9hsr3EtqocO0T24thAsFVfkuT4sHWvKsCs1JYoNx5fqrys9MbITjwIy6A++?=
 =?us-ascii?Q?8+wArKO8YL05a+QVLoEG7h0vcWbHy3NbXoS0DhOU/hw2j6WvXKNhCUl8s7Dw?=
 =?us-ascii?Q?zlGI6Cv2InkH5ezUtTuutSkyrm0AHXFY6E1pbtwHauJ724Fe/kAiNTnI5Xb4?=
 =?us-ascii?Q?1vpTbzPEiBz2dlnR/2QWBYp+ozycFqWV5WuAiR+MVKNOSW37ctJ+xR4cI+1p?=
 =?us-ascii?Q?HDZXMxWVHZm3nVCWKJQQfn8W6TrKVjhi4UxPyeU5ecqhYe5xqZtfy8wxG8H8?=
 =?us-ascii?Q?v+Sx1jFjN/6WKbdnZcpgEAmr83WAEsVvM9T2JhYFqijZYFN+t7ab1JbTOK0H?=
 =?us-ascii?Q?0bTTU7haqxGRK5ll7m0EW9ITccqQCyrI6iu/KsBtdbcrDwI508iKLgq29YVq?=
 =?us-ascii?Q?pVkNgzGP8pgYCd2p8s0C2b3rm59S+rU67AZv5CNFXLQCvYzTIfjzF3ozjMe2?=
 =?us-ascii?Q?EvEICswDDL0d7E8YZ6yR8m4CwvmDs0zzUBErhiygSy74+/L9FmN3xa2VEflI?=
 =?us-ascii?Q?mfozI5h3MKHWMYp8HNtyeo+2Mw69Pmv+kr1STAbDJBsSE2G36AEtO3YL2xgn?=
 =?us-ascii?Q?sKLc1zxjbKFXXX6EDYv3V0hj0aVxOHed54eDHsC3BdS94JKJmtCurFShPT3U?=
 =?us-ascii?Q?5vLWLj4MiZvXSPFGPSkchTv2jVaSXaC6oWDdtCKIeMDB0ttzb155AnQPTSfJ?=
 =?us-ascii?Q?3N6XnSLMtkSeJURdsah9CW94wE8dTpXrOGHoRcGmP4KEO7s2dVEZiTbw/r8O?=
 =?us-ascii?Q?c/Wgpd5ctly0xCQxVJMUZPDDj2/tQzI8N+2wiGtRgkNRin/j9bAyFwfLAx/M?=
 =?us-ascii?Q?XhselvILVFqzmkm0LzwWvOKM1vgIXboYXjtD/0dO9Zs1x5759gvLHyhQOURt?=
 =?us-ascii?Q?Je2QF1PCBLVQqhVKKnHTA5xt4I18GKUL6ey23dFjr37N6aWGmKDYHz4Van2h?=
 =?us-ascii?Q?2fcoalVp71/eMdvYg4zo3ifF0dAtmfv2WMuCd099m+MCHbDp1K1xTdoCwj73?=
 =?us-ascii?Q?1coIkEvDkKE+j2g7mn3FQl2o6bo0L3AqVMAeieta7uAi2Jq17mxy51OEWDTM?=
 =?us-ascii?Q?WBA74cZGI+vldbhvXIa06PCA9NLxP6h/fs7qc035GtnAHHow0jrK6jVEHU30?=
 =?us-ascii?Q?uT9VPn2nU1HffpbB5umLxE5XTXkwdBsqTfpUNL7Wriu7h8FLqMIgnuX94HKG?=
 =?us-ascii?Q?akpbje3dbekp6ouyqD6w/XMeLMBJFtwht4sDXg/AfIYVoCfkrQNFPfdlx3Mg?=
 =?us-ascii?Q?53u9EdS4d2XnGJFjN5trPpI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd68dcc-4c11-4e56-ce4b-08d9f6d4f841
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:20.9760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +QwBQFtceyAPXM0gHTA2fuCNTjWfged6bSAIbil1C2zsnb7M8YhSI4thP7/e91dnA0t/apA320XMc2H/5em1xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the logic in the Felix DSA driver and Ocelot switch library.
For Ocelot switches, the DEST_IDX that is the output of the MAC table
lookup is a logical port (equal to physical port, if no LAG is used, or
a dynamically allocated number otherwise). The allocation we have in
place for LAG IDs is different from DSA's, so we can't use that:
- DSA allocates a continuous range of LAG IDs starting from 1
- Ocelot appears to require that physical ports and LAG IDs are in the
  same space of [0, num_phys_ports), and additionally, ports that aren't
  in a LAG must have physical port id == logical port id

The implication is that an FDB entry towards a LAG might need to be
deleted and reinstalled when the LAG ID changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v5: none

 drivers/net/dsa/ocelot/felix.c     |  18 ++++
 drivers/net/ethernet/mscc/ocelot.c | 128 ++++++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h          |  12 +++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6d483887af04..9959407fede8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -614,6 +614,22 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
+static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
+			     const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_lag_fdb_add(ocelot, lag.dev, addr, vid);
+}
+
+static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
+			     const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_lag_fdb_del(ocelot, lag.dev, addr, vid);
+}
+
 static int felix_mdb_add(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_mdb *mdb)
 {
@@ -1579,6 +1595,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
 	.port_fdb_del			= felix_fdb_del,
+	.lag_fdb_add			= felix_lag_fdb_add,
+	.lag_fdb_del			= felix_lag_fdb_del,
 	.port_mdb_add			= felix_mdb_add,
 	.port_mdb_del			= felix_mdb_del,
 	.port_pre_bridge_flags		= felix_pre_bridge_flags,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2fb713e9baa4..0e8fa0a4fc69 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1907,6 +1907,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	u32 mask = 0;
 	int port;
 
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -1920,6 +1922,19 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	return mask;
 }
 
+/* The logical port number of a LAG is equal to the lowest numbered physical
+ * port ID present in that LAG. It may change if that port ever leaves the LAG.
+ */
+static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
+{
+	int bond_mask = ocelot_get_bond_mask(ocelot, bond);
+
+	if (!bond_mask)
+		return -ENOENT;
+
+	return __ffs(bond_mask);
+}
+
 u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
@@ -2413,7 +2428,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = ocelot_bond_get_id(ocelot, bond);
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -2428,6 +2443,46 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 	}
 }
 
+/* Documentation for PORTID_VAL says:
+ *     Logical port number for front port. If port is not a member of a LLAG,
+ *     then PORTID must be set to the physical port number.
+ *     If port is a member of a LLAG, then PORTID must be set to the common
+ *     PORTID_VAL used for all member ports of the LLAG.
+ *     The value must not exceed the number of physical ports on the device.
+ *
+ * This means we have little choice but to migrate FDB entries pointing towards
+ * a logical port when that changes.
+ */
+static void ocelot_migrate_lag_fdbs(struct ocelot *ocelot,
+				    struct net_device *bond,
+				    int lag)
+{
+	struct ocelot_lag_fdb *fdb;
+	int err;
+
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
+	list_for_each_entry(fdb, &ocelot->lag_fdbs, list) {
+		if (fdb->bond != bond)
+			continue;
+
+		err = ocelot_mact_forget(ocelot, fdb->addr, fdb->vid);
+		if (err) {
+			dev_err(ocelot->dev,
+				"failed to delete LAG %s FDB %pM vid %d: %pe\n",
+				bond->name, fdb->addr, fdb->vid, ERR_PTR(err));
+		}
+
+		err = ocelot_mact_learn(ocelot, lag, fdb->addr, fdb->vid,
+					ENTRYTYPE_LOCKED);
+		if (err) {
+			dev_err(ocelot->dev,
+				"failed to migrate LAG %s FDB %pM vid %d: %pe\n",
+				bond->name, fdb->addr, fdb->vid, ERR_PTR(err));
+		}
+	}
+}
+
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
@@ -2452,14 +2507,23 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
+	int old_lag_id, new_lag_id;
+
 	mutex_lock(&ocelot->fwd_domain_lock);
 
+	old_lag_id = ocelot_bond_get_id(ocelot, bond);
+
 	ocelot->ports[port]->bond = NULL;
 
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot, false);
 	ocelot_set_aggr_pgids(ocelot);
 
+	new_lag_id = ocelot_bond_get_id(ocelot, bond);
+
+	if (new_lag_id >= 0 && old_lag_id != new_lag_id)
+		ocelot_migrate_lag_fdbs(ocelot, bond, new_lag_id);
+
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
@@ -2468,13 +2532,74 @@ void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot_port->lag_tx_active = lag_tx_active;
 
 	/* Rebalance the LAGs */
 	ocelot_set_aggr_pgids(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_change);
 
+int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_lag_fdb *fdb;
+	int lag, err;
+
+	fdb = kzalloc(sizeof(*fdb), GFP_KERNEL);
+	if (!fdb)
+		return -ENOMEM;
+
+	ether_addr_copy(fdb->addr, addr);
+	fdb->vid = vid;
+	fdb->bond = bond;
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+	lag = ocelot_bond_get_id(ocelot, bond);
+
+	err = ocelot_mact_learn(ocelot, lag, addr, vid, ENTRYTYPE_LOCKED);
+	if (err) {
+		mutex_unlock(&ocelot->fwd_domain_lock);
+		kfree(fdb);
+		return err;
+	}
+
+	list_add_tail(&fdb->list, &ocelot->lag_fdbs);
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_lag_fdb_add);
+
+int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_lag_fdb *fdb, *tmp;
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	list_for_each_entry_safe(fdb, tmp, &ocelot->lag_fdbs, list) {
+		if (!ether_addr_equal(fdb->addr, addr) || fdb->vid != vid ||
+		    fdb->bond != bond)
+			continue;
+
+		ocelot_mact_forget(ocelot, addr, vid);
+		list_del(&fdb->list);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+		kfree(fdb);
+
+		return 0;
+	}
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(ocelot_lag_fdb_del);
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
@@ -2769,6 +2894,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
 	INIT_LIST_HEAD(&ocelot->vlans);
+	INIT_LIST_HEAD(&ocelot->lag_fdbs);
 	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 78f56502bc09..dd4fc34d2992 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -635,6 +635,13 @@ enum macaccess_entry_type {
 #define OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION	BIT(0)
 #define OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP		BIT(1)
 
+struct ocelot_lag_fdb {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	struct net_device *bond;
+	struct list_head list;
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -690,6 +697,7 @@ struct ocelot {
 
 	struct list_head		vlans;
 	struct list_head		traps;
+	struct list_head		lag_fdbs;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
@@ -866,6 +874,10 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
+int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid);
+int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
+		       const unsigned char *addr, u16 vid);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-- 
2.25.1

