Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3831A3F1F48
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhHSRlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:41:14 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:62067
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229520AbhHSRlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTDBhCeNT6mZVkxyNiqhrk0SvC7G47OrgmN+Nqb6y3FhKMUDQkABRg6XPEtHhLKkU1b/q7z1BYsp9YWPATmcnCB9oDXI9WGVDchO9oVPcUis8zfkS/o4ZmB0nfBkR/S6gcIQA/tljGSGAg6MSKbgj45Q9ioWV5hdYXNtZx4zDROP2Z7Kpzr9EOri2IOb92LUyKftIh6Lr6gy2fBrnPxe27bXWxu6QyrN0yrVg2TO5NpaE7Fs2kFQXNblpml+gkuYa3t+jMGvwGu9OYmB7Xa4lnNYqKKSFq3ENYeIcbM3MgolkNzhP39j65nyOYMkxT2n/ljdNLBNs2pBPYc9qEpFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WQCwH5GbFPvs5E2VGIWrR+dDYLsA6Qori/cPxi4Lqo=;
 b=h77ISEC5pH5vEBzyxld4B40MvV7ypj3v8Wq34MKIr4qXWsM0RD4faqLIPXVEX0IABYxSbGyAEMBhD3wrEWbkC7gP4bmLKqzflFjzuFzONQ34hAvgKXuxFLmvn7KiQZA+OGt404YvzBLaXZ+EhsKLnD1T3Rckbxxx4xuN42guVosCWARNReTzTpEz0MOsmt+IsMq86loFhL5rk8Cx9C5RvucQ7SrKDipkJRiY9QnIZbnFanj9FoR0PlKB6vVnPUn6yleIITIzblAcALS5xbh4NAuuDwuhE4Zi8U9/R9vYJZFCSkn3evtKMOPrLXJHw++/+OKZnIppKm4djVmdDcxbSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WQCwH5GbFPvs5E2VGIWrR+dDYLsA6Qori/cPxi4Lqo=;
 b=Smv6VfeJS2DOowKTrwyyxuOVIj1F2y0g6Uhfauj34OIlJoPWvnulbKio7I3/a3qrDaHWZgckEmRqS0WPU1C73UoXCwKyHoaEdSIac11S1Z4bVB9fQ8hQnZ8iMpq096lSR/6bjr6HKsVldXuvmrSGGWl5Fn1KPIMK9lL7J/OPZ68=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 17:40:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 17:40:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 1/3] net: mscc: ocelot: transmit the "native VLAN" error via extack
Date:   Thu, 19 Aug 2021 20:40:06 +0300
Message-Id: <20210819174008.2268874-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
References: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0191.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0191.eurprd02.prod.outlook.com (2603:10a6:20b:28e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 17:40:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 041e1e6a-6cf0-4fd9-edd8-08d9633871d3
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686C384B7CA018B06FFF989E0C09@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26D1ibyKN6p95vqkHt6x/zNmqo3i0B937kdVPmOuhPmrgwzoP32flGatuBjauidtP4vl54XeOB9TC7dq4eFRKHSsTR3N5MjBXjkhlA6XlxVgeh9JF41MNLdb+amCYwJmocWSmRsuL8kDzDXdGlarE9XiF8kAwBR87kpL5Q8GZdkYE/zENRKdUAkozAzWjIm90SBHctchFtbUsI/xp8mU3FL4aJ2Or+f+0/Vf6n0r31EqCTHlFDH3r/HHJyWK4g+IfhdoyH0W7VYylJUksnzziBWSZzUrtWhvyNDhOuGAaWZ4V6hOUVuQviHHeJO0EEScvI/3C8LTLxiRVGyFMR9E1Zjbco34lxHWokvoEe0ndtNlI4gQEVuA8BOccoF1z31OE3mkWJ/NTSBqPLguVPG0Ewz8LyZbOIl4rxG5j/MclNoCZqGYWqU8z3jf4CR4KaF2Q47KPphV82bzT0rqapV5UExAi8PpdeY1xhB7bHpxEzNlWmZUrDuSJwjW5Qi9XLvS0ygfMg6VOK0TvEmhu9RUmqSC6bDJse2opq4lK6um8kE/vJgHimbiqo/4cjGtAS6Q/KOPWQx0rTCVnUMBhXbBUTqUiDQrH4yZ6NnYvc3tSI5Ml0FJwyThLAMm3yAus8Q8qdAYcYgrqd56MQZL6Zwjzf7ZH8xie8ru4vxkm7/wTIUUf4shEu6akcEe95gYC1/xCzcJT/tpNBi9JCbJ+3eqYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(6486002)(316002)(6666004)(44832011)(83380400001)(110136005)(54906003)(1076003)(8936002)(36756003)(186003)(26005)(38350700002)(8676002)(5660300002)(6506007)(6512007)(86362001)(38100700002)(4326008)(956004)(2616005)(478600001)(66476007)(66556008)(66946007)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5ce7OdFFnXrlqUbo+iHFh9Q6GM27RcO25cYpEFkc0tau8B7kRU6OUxiR88T?=
 =?us-ascii?Q?Hkssa7OSveeqDNahLNxNrDPo+nuC+ITMs0HjZEKxhLDTtRHXUCoFDPksww/X?=
 =?us-ascii?Q?hR6Rf4Jfrx8xipKaD59rfSdEsi/Me1qBAwmitq5Wrz1iDm8Z2JkTWc+aJRal?=
 =?us-ascii?Q?vXT8amNgvLlFKcQ6bbC33yyDymjMUh3NgLGNGNIYszQRg7ZkmQkeODyaTaxR?=
 =?us-ascii?Q?GyOOT26ewjDasbGOOJIjRKuRCeYTS63M+1p6y6eVc+GNN1RBsIRhTotYoO9k?=
 =?us-ascii?Q?W8EYcGHSiiEgN9/luXxl8E1cuueuP7xYDLTarnLKEEYkUHWsb2hHoLRLNzjo?=
 =?us-ascii?Q?pvJmbgQIi8KK9lpzT/hJ4V5Zz3CdgHwBhKNAYMPe0hAcn40xyEpU4WyRiKbQ?=
 =?us-ascii?Q?+x/FgFLH+6KAkHrAWNH6Fw0s9ousfQ+ceUUVE0YYAf89M5ma0RhrnrAmbpUz?=
 =?us-ascii?Q?82NPRCJCs6/B+j9FhtWYffUxsp/9nOwJio64l4FOVkMhIXnNPGaTX+VqJD+O?=
 =?us-ascii?Q?uNHYzWlRt6+J4fOr9hcAzYXybtbkt+1v9ZQ06aUgLsnoIiIdMxxIl+X1shUK?=
 =?us-ascii?Q?ZFzhRKnvJP7XBvub0uquT9VzSqdxK078Cs8RogOFRAbnrd7W59b9TNuSDSX3?=
 =?us-ascii?Q?7sh80pUu6elnOdyZggY2y0cdY0CyE/Psuo889Yuj1L+Xlb1S2D8FLThDDZMR?=
 =?us-ascii?Q?kw7/brCfjZpWilvXqbJUDYGk6h8VALjt9yKePXyuAt4PfddC6PimQfh/9D9N?=
 =?us-ascii?Q?IE7FzmU4xUD2pDH/YULQ0gIo2SJ1cm2p9nKLW1wkCaaZ+ldkzvBhzuaWqHHs?=
 =?us-ascii?Q?JB+KpcqzdlXlUKKERCsTaW1yuNm92wOJpFUITgYqN0fzAlfm1xtPWWBtv2yW?=
 =?us-ascii?Q?KXW6mHR2xoaILDaTbhV2SAJJnXQ88kZb4cNgilq37FN1iE/8TY/qv8FzqJTg?=
 =?us-ascii?Q?TOsNuzycotoP7soIn6wYLRRcZ7mOJ168cp/mWyzJnVKWJ+3spkYefYNhjeDW?=
 =?us-ascii?Q?hjSAMof2JKw8y0DQH0BufZFPszLW6E5U6FXg5oPBUyczxPGuwHUO8GHmG0qT?=
 =?us-ascii?Q?p84ZsUCKlLKiHLrv9qAWESLuALBgrbJaqrY6n7rj5zZAkLdEz0rOFHfUMAeQ?=
 =?us-ascii?Q?TitnUTivwCN+8a/aXEppNNRz9L/v/o3Vc0pC2PlFbsBQp1J9YygPpoSqPQIk?=
 =?us-ascii?Q?nqHllLTYm9s9XTnyvqFt3KDHiJN6cgFHakCBxSYh9y2DHwdK85dXiWrtkCSD?=
 =?us-ascii?Q?aJnHPaGx9uAbz1VusACdEZdhmginIWnyGFSBj6/Wzf77eSwwymKy/f/EtWF1?=
 =?us-ascii?Q?nTuitAtMIFm8R+ZtVG66KS4j?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041e1e6a-6cf0-4fd9-edd8-08d9633871d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 17:40:33.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eezxJwBbm3SpV2oWyeUYQHaDEk+l7qBXDNlGyDm8aOYRqcUQ0edxBno+TeVOhzOjUF4zyzyAHR/btySmY5bI6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to reject some more configurations in future patches, convert
the existing one to netlink extack.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  8 ++++---
 drivers/net/ethernet/mscc/ocelot.c     |  7 +++---
 drivers/net/ethernet/mscc/ocelot_net.c | 30 ++++++++++++++------------
 include/soc/mscc/ocelot.h              |  2 +-
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e764d8646d0b..0b3f7345d13d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -740,7 +740,8 @@ static int felix_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
-			      const struct switchdev_obj_port_vlan *vlan)
+			      const struct switchdev_obj_port_vlan *vlan,
+			      struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
@@ -758,7 +759,8 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 
 	return ocelot_vlan_prepare(ocelot, port, vlan->vid,
 				   flags & BRIDGE_VLAN_INFO_PVID,
-				   flags & BRIDGE_VLAN_INFO_UNTAGGED);
+				   flags & BRIDGE_VLAN_INFO_UNTAGGED,
+				   extack);
 }
 
 static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
@@ -777,7 +779,7 @@ static int felix_vlan_add(struct dsa_switch *ds, int port,
 	u16 flags = vlan->flags;
 	int err;
 
-	err = felix_vlan_prepare(ds, port, vlan);
+	err = felix_vlan_prepare(ds, port, vlan, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8ec194178aa2..ccb8a9863890 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -259,16 +259,15 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-			bool untagged)
+			bool untagged, struct netlink_ext_ack *extack)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	/* Deny changing the native VLAN, but always permit deleting it */
 	if (untagged && ocelot_port->native_vlan.vid != vid &&
 	    ocelot_port->native_vlan.valid) {
-		dev_err(ocelot->dev,
-			"Port already has a native VLAN: %d\n",
-			ocelot_port->native_vlan.vid);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port already has a native VLAN");
 		return -EBUSY;
 	}
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 04ca55ff0fd0..133634852ecf 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -385,17 +385,6 @@ static int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return 0;
 }
 
-static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
-				   bool untagged)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
-
-	return ocelot_vlan_prepare(ocelot, port, vid, pvid, untagged);
-}
-
 static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			       bool untagged)
 {
@@ -943,14 +932,26 @@ static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 	return err;
 }
 
+static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
+				   bool untagged, struct netlink_ext_ack *extack)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_vlan_prepare(ocelot, port, vid, pvid, untagged, extack);
+}
+
 static int ocelot_port_obj_add_vlan(struct net_device *dev,
-				    const struct switchdev_obj_port_vlan *vlan)
+				    const struct switchdev_obj_port_vlan *vlan,
+				    struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	int ret;
 
-	ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged);
+	ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged, extack);
 	if (ret)
 		return ret;
 
@@ -1038,7 +1039,8 @@ static int ocelot_port_obj_add(struct net_device *dev, const void *ctx,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		ret = ocelot_port_obj_add_vlan(dev,
-					       SWITCHDEV_OBJ_PORT_VLAN(obj));
+					       SWITCHDEV_OBJ_PORT_VLAN(obj),
+					       extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fb5681f7e61b..ac072303dadf 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -825,7 +825,7 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-			bool untagged);
+			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
-- 
2.25.1

