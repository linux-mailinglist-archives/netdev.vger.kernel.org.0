Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA1B435233
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhJTSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:01:47 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:56736
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230478AbhJTSBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8MX7unK+g4nS5UCz+iDZx0VQ/0b6c/ckQ6tW36p3CP7pXMktLGVLLZm4IykFuS1Byeju2/4f7XtottURYIzvUJge48QH3Kxhc97IW3c+mXI7qqpVzNWcbXI5RzvSDvCRoiwDv24SwX+4UE9RgYkCRsUkjqQwXXDfIbbRwFNmYl2nOQ2Mv1U6xQR8izZMUHFuUcD/fjXkEzAz9/SBGkR3RLrAyOFm4JGHINmafFy7I2jyWmlFlGKxsqJbvBdqjSOHIVTwKFZHptuR8nRTRD9dRehFHzyj0EemJJ4dl1CW7mr7/fdhN0joX4wNadh++tx4aKrMEJf8/ygg1SLF9ux4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuBw6PI8qZDH+m1LT8H0/J8gU6RTefcMeMeDFzzdU2g=;
 b=VaU6yA1SVCIsPIRfFvUZQCq4QMXHFsvZndWC7AYK2Zx6LPkxuZ7OeYiiVBfBXDOYRoPm1RR6wLQ2US4PMibp8A1rL3nym2tTu0srLmkDsngyG1tqqSM9ILYXBSxAFv0vXcVM4G57YYfnb8bGvB03StT2Xut6H5lqUB3ZdRpejcdGybyu7dnTq2mK9MZtVTBXOyrXnXgVUqvoj2Z+wg5GxmXWNzaCqYhRzf3O0lHMBkdXCHDgKkraVUhmDa/ntF6EuSXzEtWfQ60hgAxzpwXDHR+ySh6YAjt1nvNkmhOUiQihbUHsBT8UXf1sD9k9r0QrPpJw1DDD6CqBhxw1sOj3qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuBw6PI8qZDH+m1LT8H0/J8gU6RTefcMeMeDFzzdU2g=;
 b=Z/cqu/9WiddIC6I8Mp2q+UapS62xi78GH+aSTFGvLQnyKgp/k/b9lY0eAxr+VzaGDB82S3ytfrnjPlQ61hGHkGNbhBTHNqpqe9SLBju856Yd+jDw/U7H5hAB54MZn9S5zcoxc3pUyQXKnu9qt6sDapTbuAkNqBEi9jEi0Z4luqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:59:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:59:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 5/5] net: mscc: ocelot: track the port pvid using a pointer
Date:   Wed, 20 Oct 2021 20:58:52 +0300
Message-Id: <20211020175852.1127042-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
References: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0019.eurprd08.prod.outlook.com (2603:10a6:208:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:59:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5c2be41-f327-41f0-1326-08d993f356bf
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB46854B7FC4664A99AE2D9410E0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwDuEJvxzG1XrdgE143ca7mvAkD5wtEH80ehN43PIW5Hb3obOzYy1pYqBPa4w1oYnHVH4Lw7nUGwh607mNBtzLcXlYx+Lb6WzDnFdcxKUFOL0xfqmot5IxDLLjTRF0wSZkLbSMXOTOYs5HO+tK5NJsSSi9UELZ7hfsEmD8Tfzm7jC9LLmLwPL9AxwEw693o7jtO9MrUy/1GRtCScRdOYPJKJFFlTJ9625u9CWPa8bMlOQZXok49EZn4Lz+mKUF6xBzzH732Xy12Zn+4VGkYfrCeR9PacPuyfyg5+9gav97peuoE6NeZ3EySsMc4JcUAxLclJy77sgf+2HeT47M3RmTR/h8V+hQhbSUnqqwylLSGzQl4nkpdH2OR53S+O+DwAswG+HUYnK2+pv/czu+yTM/zlFlO0lyzXJTZ1CyDhPuoy5vZjSsNqFtVYR0LpdcamYjrxWhwQbC4Djx9SfBnjc9MSbw5boMZ7USDPC5ludF0VyzIih7boJieuMTmVcCppJsEhEMIWc18hhNn7715GBhggaQ7zl88yx/oUbLGZibPCO2O9ZSiEvtOHG/IFlR2s9rTy1JvZLPpP8itZeqsCAncM39NnpM62YOPW5fZetdFB7xGBKwYh2QF+OpnrFivHPPWZYunI1kzDGJlPj/L07VkIFpXga1PZ5h11GM785yERqkXj8yz8laScRxbDFp2tZavQ46Yx2Kb1vkoHJXf0Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(110136005)(316002)(5660300002)(186003)(6506007)(52116002)(38350700002)(66476007)(66556008)(6666004)(38100700002)(54906003)(1076003)(26005)(6486002)(86362001)(6512007)(956004)(66946007)(83380400001)(8676002)(36756003)(6636002)(2906002)(8936002)(2616005)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GZhFWYz/EVtgBdxztjgCMBLzEd41FGD9oqdQftbzCJJNbrEKuiELalRNG8XL?=
 =?us-ascii?Q?X/RhgVUsEevX1Du8oNKacabpH9xQEDbjzNyd+cBFmYKy8U6l5DrRK6JWcpSf?=
 =?us-ascii?Q?KgY1TVn8xnC2O4dR/X3EMPxTfLCWd9DmqyvpyHWR3TQHRLHae26mKxdFKZsc?=
 =?us-ascii?Q?jZhST/8kXmlcsUsPynz/f467WRszi0NPXVb0/5Mo2S8AnLGfNFpj+qz04FRj?=
 =?us-ascii?Q?bo5dxCes3ST9571MsF+coZl81qUBfW7l7qckyTF08w/EXKWaMOg1baMqbaSw?=
 =?us-ascii?Q?Zv92qf28qcgD+ISvAkvDnzm42XeqxL324vH0ni+psptHpV6gNPUCRzGy8S2r?=
 =?us-ascii?Q?PA5svxPRL82kelPyfAzDk7DKKLhxShZE/99me9oLhp2IrTs4G6oobCir62ru?=
 =?us-ascii?Q?IqNpwVaH3DHtzS286JgWJe6tRq9i6j2APFKQaYx8USKIXkxeds9V6n8T9BJM?=
 =?us-ascii?Q?SZNXChQR7E6LY1mUMAMxFpxJsJykJOnETlVxgmpC03Ja7k1ayM/8smG1wgPA?=
 =?us-ascii?Q?kThF83Zl0brkW2NhGJNxXaz6TeAcn9O8/xhdbOsQkp7HqgXCRPbfEs76lBoT?=
 =?us-ascii?Q?jlQr2ZknuYeaDgRfN0t+gGYFVe2qlq3nGkxfwcfGh2w4Czquhro2aRBtoRww?=
 =?us-ascii?Q?6mlEDb1qC5Rj5qEMeGtfyrOEsfsoSN5INMF9zRTKmZGjSqLwi1duhlILIJXT?=
 =?us-ascii?Q?PjpRNy+jANe19HfzbCXCHXH4+Xs3z+4WeemoGDqyDN6/VY0j+A1acMbBZuMb?=
 =?us-ascii?Q?AZ8IznFPrtGOQiYvWQT+PZusd9ThOigTQJy1wz7q/IrHtnUCbqWhPAm9Qiq/?=
 =?us-ascii?Q?+9UDGYm8K9VUCfgrzWIHBnEJFK+yRT01cRHs3l9FJXiOTGyzsy/aE28dchrt?=
 =?us-ascii?Q?d8VXzBf5DIHuIwbbEYx/ZeA7GbYRixnbjm+Kio+4ZDVNjioGwPQ5Yvn2Rhrt?=
 =?us-ascii?Q?6LbgV7wzG1nbKcKwE57gzWnqLr6erDErDSa3cenkJI+ipnmk5lr7Y4tY8YuA?=
 =?us-ascii?Q?8FEmtZbh5H7BHInDyI+UN97VY1hXsXqiDy3/8Kvw/bp1f66GwIaFvp3Ce5fv?=
 =?us-ascii?Q?YRyQrdDWmC3jUDeeN/vBTSG47nC8BP83jMmPpM7N2crWHsFJU/jys9HOtR2t?=
 =?us-ascii?Q?iSfIRNxS1KD3kLlmGuEXyCrFAq5XAz9XHObOhf7GPSYcmIb6ia+QOaEN5A2f?=
 =?us-ascii?Q?QzuR5kRXWn12ouURQ46nQ61swuAggmSQziEwiZe7wPIppZxDwCNs35biZFC4?=
 =?us-ascii?Q?zYtOuDavHS8glAmrazbYvnUa4dUg20CT6ta0IY7BJP5lsUGgzVHLvtZPNder?=
 =?us-ascii?Q?RyigOppODL8f3JR3Yte0tcxobJH5WlyAuwm60vNuZ/lfMuFi/XIq3FCN/NNI?=
 =?us-ascii?Q?ZHVOSH/ljuIRirPOSZ27HaHf++8MbEHTE/IDg0sBbkEkqmVy5X97AUvDubV/?=
 =?us-ascii?Q?cZSUAqixeDrclA7CQISi9UrkQiJ6GWytSVdwcm+ESx5hBdhzHczn7idg804Q?=
 =?us-ascii?Q?TMsZAaodcg+hsF4vhEInV5gRy7hYjjdD7AIoWmm5kBO1ac17CyoHMvdWOYas?=
 =?us-ascii?Q?cy+QThWKb7ugcR5DWjjJgmihSFJlh9rwgk9WpqVjfw45s3OSBLSVqbODiieM?=
 =?us-ascii?Q?/uaTtLcyVBTPui8YU4Fj+4U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c2be41-f327-41f0-1326-08d993f356bf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:59:19.4662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnM9cGFsKxUqtVJpUPGAjrg9QdlUEBRbpqf5g5NYdJrzkyndapNnI2dgi4/q/ZM4QYKskLmOT4/e+o5seJH5gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a list of struct ocelot_bridge_vlan entries, we can
rewrite the pvid logic to simply point to one of those structures,
instead of having a separate structure with a "bool valid".
The NULL pointer will represent the lack of a bridge pvid (not to be
confused with the lack of a hardware pvid on the port, that is present
at all times).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 31 ++++++++++++------------------
 include/soc/mscc/ocelot.h          |  7 +------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 30aa99a95005..4e5ae687d2e2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -260,18 +260,19 @@ static void ocelot_port_manage_port_tag(struct ocelot *ocelot, int port)
 
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
-				 struct ocelot_vlan pvid_vlan)
+				 const struct ocelot_bridge_vlan *pvid_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u16 pvid = OCELOT_VLAN_UNAWARE_PVID;
 	u32 val = 0;
 
 	ocelot_port->pvid_vlan = pvid_vlan;
 
-	if (!ocelot_port->vlan_aware)
-		pvid_vlan.vid = OCELOT_VLAN_UNAWARE_PVID;
+	if (ocelot_port->vlan_aware && pvid_vlan)
+		pvid = pvid_vlan->vid;
 
 	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
 		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
 		       ANA_PORT_VLAN_CFG, port);
 
@@ -280,7 +281,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 	 * classified to VLAN 0, but that is always in our RX filter, so it
 	 * would get accepted were it not for this setting.
 	 */
-	if (!pvid_vlan.valid && ocelot_port->vlan_aware)
+	if (!pvid_vlan && ocelot_port->vlan_aware)
 		val = ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
 		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
 
@@ -445,13 +446,9 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		return err;
 
 	/* Default ingress vlan classification */
-	if (pvid) {
-		struct ocelot_vlan pvid_vlan;
-
-		pvid_vlan.vid = vid;
-		pvid_vlan.valid = true;
-		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
-	}
+	if (pvid)
+		ocelot_port_set_pvid(ocelot, port,
+				     ocelot_bridge_vlan_find(ocelot, vid));
 
 	/* Untagged egress vlan clasification */
 	ocelot_port_manage_port_tag(ocelot, port);
@@ -470,11 +467,8 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 		return err;
 
 	/* Ingress */
-	if (ocelot_port->pvid_vlan.vid == vid) {
-		struct ocelot_vlan pvid_vlan = {0};
-
-		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
-	}
+	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
+		ocelot_port_set_pvid(ocelot, port, NULL);
 
 	/* Egress */
 	ocelot_port_manage_port_tag(ocelot, port);
@@ -1803,11 +1797,10 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_vlan pvid = {0};
 
 	ocelot_port->bridge = NULL;
 
-	ocelot_port_set_pvid(ocelot, port, pvid);
+	ocelot_port_set_pvid(ocelot, port, NULL);
 	ocelot_port_manage_port_tag(ocelot, port);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b8b1ac943b44..9b872da0c246 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -563,11 +563,6 @@ struct ocelot_vcap_block {
 	int pol_lpr;
 };
 
-struct ocelot_vlan {
-	bool valid;
-	u16 vid;
-};
-
 struct ocelot_bridge_vlan {
 	u16 vid;
 	unsigned long portmask;
@@ -608,7 +603,7 @@ struct ocelot_port {
 
 	bool				vlan_aware;
 	/* VLAN that untagged frames are classified to, on ingress */
-	struct ocelot_vlan		pvid_vlan;
+	const struct ocelot_bridge_vlan	*pvid_vlan;
 
 	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
-- 
2.25.1

