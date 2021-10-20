Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC7443497E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhJTK6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:58:41 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:17730
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230111AbhJTK6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ36S0ptsoQp0OMVjWUz9NfJckBMvpUB5WOFuQddb8mmWlfYqnmJKAmNfxYCJ5a7v3fqB39ENkjbCZt5Dg6vna8WsmErtAVSQHk1wM95volDN73Ef7juDm5Q6i+gZcm6olQeobIk8o/yzcYXufZfCCvvksjQkSiqNysn2RUrWcjbkpnFxxC0bbhpcSlOxlOeJOL1E5EqrfoWSr0mENtzckB0xU6g6ZQhYABnzUH1PanV2BIeCQw8EyZCCbHHwSGZcv8u/usC5M3FH/pxAw2jUaJs3fvpTIBFtMyGmJLHmi9L44i4BDaiTXwVsvudjskBZhvXBDUSLDN1GAt0s33oTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWTD6PbFgspbGu1Hk4k+v7gAwsnZdsPmhvESE67NeeE=;
 b=mriYhmVNGxxzZELx4OmIuIGGP6pzJ7G5wZB/GZdjlfMEnXrKhcybDW3omhphuamD6Lg7I5QHMvssgYORJ7rSeKaEtd1v+Bf4e5oSojiZ1D/vCJBi/cfSLweHbjUkLirLG0IwMyEwAG47ohYmIfk+yoUZcW3q4NSKQkyT6L2MWIvCGvUg/AzengcHCuoceG3RPk0r0xA8+BI9X17y+WBrqtzYGB2cxhRivTQfrUAJNYqpIRABDbDYeXaRj9VloUs+QhGHU1Ij4YDh+tbkQ1Ael1hWSFbTTCq5iu2wBBKtJOyt9mQ9dG+RgQM5TqtU+br4kLDAk4GgRqMmFFg7HW8pdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWTD6PbFgspbGu1Hk4k+v7gAwsnZdsPmhvESE67NeeE=;
 b=aeKnIIliq9tKDf+/QZ2aW54emSr8o2fZP4PZztedUMWY2oHWzzAnbNuzVC3kFGh2N8PY7oDU1QRylYZqqe2z2PoR7q75et+0eVB3UHWiD/MqVCGuTSDcrw+gF48G8nF4lcpymY2SEauE0H+KYcesTE7ft6CZlNSBV1tuuzVUQLU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 10:56:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:56:24 +0000
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
Subject: [PATCH net-next 2/5] net: mscc: ocelot: convert the VLAN masks to a list
Date:   Wed, 20 Oct 2021 13:55:59 +0300
Message-Id: <20211020105602.770329-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020105602.770329-1-vladimir.oltean@nxp.com>
References: <20211020105602.770329-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0111.eurprd05.prod.outlook.com
 (2603:10a6:207:2::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0111.eurprd05.prod.outlook.com (2603:10a6:207:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbd058e7-0109-45ab-996d-08d993b8424e
X-MS-TrafficTypeDiagnostic: VE1PR04MB6702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6702691D072FD943681BD850E0BE9@VE1PR04MB6702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MiVfUL9CJ2vBmEWhDp2bXmu/d0PIhV8SkMaKsyfjR39603qLBBNeRtVup3RV0p0lE1qTZfLRI/dVYyTBfQbX1omOQaRYM5d0Mi81Qr4Dv0ZzNKTe3MRUuesFBaqjBOmwUEdVJpS1gVgBcnLzLvwMCLydkwMiCNM6Ld9qdWLOTNr1p0fIalZnsEUwBp8sgOJXZQHb8IVoofEvlVqhgE9x9IAGM6qOre5o+Fz9eKGAm+Q6k9OSBJ+eNbxS5ByDj9m0SixzsMd+CFXSVabh1AU0aTzStZr4i5lt9vxV89hioQjT9gnS0oj9An3l2hoaN6xC1Pb/9aU+qhmR+jBjuizU4Fss193UNlj+yeBzwxg3YLGIEbaoY2w9t9EdtwCEqwJilxa1kMzEkjQIkADmEU4GIfycXDV7II4ahmlbpC0IlelQdQ4AJW2txyzbpJn0x32yi4hEArcXJBdBdWUtHB5cak+uvx9cvOoBMoFbuvrGyfzdrQCmagxPatXW1GuDFhPR1xO1587gyOx2XbjauRil5SGeFh7/NocIIgIuDyLc0JM/9yS5wQFAY+Fm1glGxTQLnTsNRIZmYHZOvKE64l3+MDvUmOc/XtMm63A0mIerpxms7dU7dtTMNk/yRiijaCuv6fdZlA1kMRMD/gvxg45vzMnJQGOV8Wa5zE/uC63HBZfEqB2pQG+7QqBbTDEkSNJ6qM8LwxN1NVA1gqWkjdMmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(8676002)(1076003)(26005)(38100700002)(52116002)(83380400001)(54906003)(316002)(86362001)(4326008)(186003)(8936002)(66946007)(6666004)(6636002)(66476007)(110136005)(508600001)(44832011)(2906002)(956004)(66556008)(6506007)(2616005)(38350700002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q/oED0j66/nm3KhOUwTw445Mv+jEQyGgafiQVwXu2U9CSuZpXUFeGsDbWBhX?=
 =?us-ascii?Q?nETVBmIcpZEA6GhbX2tMswLq+YMJFGqqjlkRfvuPHL6u4fr+2Tc2M7iOflvj?=
 =?us-ascii?Q?7BLGAK4ypiufZWjZoiDSHze40QKv7vgbikGgYr5XKnfSjVbyb9UuXDeNMIxF?=
 =?us-ascii?Q?pLmGmCifNx0DkKA+jlHY3GgmerWSySABvGpYZVYqpEdF/unAPUcXlsYwWHF7?=
 =?us-ascii?Q?kT73ZWNH3qc/Q9kS3zkHLMPhHpaT6xWFcz21sNWxn7jY+rNPu5g2i+XZVfJH?=
 =?us-ascii?Q?v/W9rlznZfHUfe78y2nSQ7+HSdGurGtvNAvKpgA1aKXT+c2NeE6EP++sVs9W?=
 =?us-ascii?Q?O5iOlsQlDv7j6THW5nsSP7C3fHyrTYY27wK32HI8G9rrNlRiNfGrd9PP/k7J?=
 =?us-ascii?Q?TX/P2gCsD8tMxKa08o5vs7sq6YdezdJs0AuzoJzqYYXp8+N3p8KVEDhvctt5?=
 =?us-ascii?Q?Q7W22xx/5mCJ8w7e4Jd6DXTUgXDXmAmPxgAfw8rLroD8V9Yp82dAlGO734Iz?=
 =?us-ascii?Q?KfCGaB3V7WVUMh5WWDuNvYQQBRy0XOi0MoJkR21hqQm0QbSMU/yHp2bmTBK9?=
 =?us-ascii?Q?sLfNvzPbHXiShOh0sDnY7XELvx7dBtL9iq0V07TVK4jn/qLTV6VXa7BGhWX6?=
 =?us-ascii?Q?HbBJSTi7ysbCs71Jo4r+AD9rGFBRDUYLg4GKjAtzOUsdSwDaRMLgwRgLA3CL?=
 =?us-ascii?Q?oylLFGV1P9yTjXYnI7h7dEnyh5WGtLhfcdNTePhkWw0kNiNdw8F0v10cqtsU?=
 =?us-ascii?Q?R9GqmEpQOSf+UFLzsNmUtODHbdUUGixLBu+hF9gxe+DM/uUF1vLGribBBuO6?=
 =?us-ascii?Q?M909mZYIyGtUI290mJSvGnq78r5UZNH1EeDMsmwW3jPSO/fYdXNXROAX4qj4?=
 =?us-ascii?Q?XBR6szfN2Ua7WJCm3OQ0d3eM9bGcYgbJGqFCmhC4O4GOqrFruBcADFWG+ZTs?=
 =?us-ascii?Q?cj/QrtBIxDCr//PlFn3gJw06UhjIcRucXhsdh8Jj4g+brvmtb218ytKjPm05?=
 =?us-ascii?Q?0wmeXsp5SKdg+3DCAdOGv2LbowgeJEMu9pMjYAg/svFZadRU3miS+qiP36ZQ?=
 =?us-ascii?Q?dIoM7zOunRO49gvFDWYY+Ex+odG/Z0+HeFGCACCypKJujg0y1gwHWxzm0+P9?=
 =?us-ascii?Q?7v0AwNBD1eUId5+34VrbZSF5FfkUC9ElhZ7qUmSTHXtCu73pF/4NDIBrsxFQ?=
 =?us-ascii?Q?nvQe07xRyHEysWHwfMdIFfhkIEtjf5cRfmGXJgABkFFR00Lf+b+oRRC7NMWW?=
 =?us-ascii?Q?6As3fJdUp7081g784idYC5w9bORHOnJQ8PXoPSYU1Y38RrZAUZ4ZhbNr97qC?=
 =?us-ascii?Q?l7WJNpjYieG89n7ZWo1gTAPi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd058e7-0109-45ab-996d-08d993b8424e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:56:24.7177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GK9c/aoJpDl4xGYRUT67ym84VVRhiJwfo9fhfjv0abJeJ9nET/Vj8WPGxp0XwQ2PmbXc2VlLPJ/nxZlWCfw1QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First and foremost, the driver currently allocates a constant sized
4K * u32 (16KB memory) array for the VLAN masks. However, a typical
application might not need so many VLANs, so if we dynamically allocate
the memory as needed, we might actually save some space.

Secondly, we'll need to keep more advanced bookkeeping of the VLANs we
have, notably we'll have to check how many untagged and how many tagged
VLANs we have. This will have to stay in a structure, and allocating
another 16 KB array for that is again a bit too much.

So refactor the bridge VLANs in a linked list of structures.

The hook points inside the driver are ocelot_vlan_member_add() and
ocelot_vlan_member_del(), which previously used to operate on the
ocelot->vlan_mask[vid] array element.

ocelot_vlan_member_add() and ocelot_vlan_member_del() used to call
ocelot_vlan_member_set() to commit to the ocelot->vlan_mask.
Additionally, we had two calls to ocelot_vlan_member_set() from outside
those callers, and those were directly from ocelot_vlan_init().
Those calls do not set up bridging service VLANs, instead they:

- clear the VLAN table on reset
- set the port pvid to the value used by this driver for VLAN-unaware
  standalone port operation (VID 0)

So now, when we have a structure which represents actual bridge VLANs,
VID 0 doesn't belong in that structure, since it is not part of the
bridging layer.

So delete the middle man, ocelot_vlan_member_set(), and let
ocelot_vlan_init() call directly ocelot_vlant_set_mask() which forgoes
any data structure and writes directly to hardware, which is all that we
need.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 81 ++++++++++++++++++++++++------
 include/soc/mscc/ocelot.h          |  9 +++-
 2 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b09929970273..c8c0b0f0dd59 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -219,31 +219,79 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 		       ANA_PORT_DROP_CFG, port);
 }
 
-static int ocelot_vlan_member_set(struct ocelot *ocelot, u32 vlan_mask, u16 vid)
+static struct ocelot_bridge_vlan *ocelot_bridge_vlan_find(struct ocelot *ocelot,
+							  u16 vid)
 {
-	int err;
+	struct ocelot_bridge_vlan *vlan;
 
-	err = ocelot_vlant_set_mask(ocelot, vid, vlan_mask);
-	if (err)
-		return err;
+	list_for_each_entry(vlan, &ocelot->vlans, list)
+		if (vlan->vid == vid)
+			return vlan;
 
-	ocelot->vlan_mask[vid] = vlan_mask;
-
-	return 0;
+	return NULL;
 }
 
 static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
 {
-	return ocelot_vlan_member_set(ocelot,
-				      ocelot->vlan_mask[vid] | BIT(port),
-				      vid);
+	struct ocelot_bridge_vlan *vlan = ocelot_bridge_vlan_find(ocelot, vid);
+	unsigned long portmask;
+	int err;
+
+	if (vlan) {
+		portmask = vlan->portmask | BIT(port);
+
+		err = ocelot_vlant_set_mask(ocelot, vid, portmask);
+		if (err)
+			return err;
+
+		vlan->portmask = portmask;
+
+		return 0;
+	}
+
+	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
+	if (!vlan)
+		return -ENOMEM;
+
+	portmask = BIT(port);
+
+	err = ocelot_vlant_set_mask(ocelot, vid, portmask);
+	if (err) {
+		kfree(vlan);
+		return err;
+	}
+
+	vlan->vid = vid;
+	vlan->portmask = portmask;
+	INIT_LIST_HEAD(&vlan->list);
+	list_add_tail(&vlan->list, &ocelot->vlans);
+
+	return 0;
 }
 
 static int ocelot_vlan_member_del(struct ocelot *ocelot, int port, u16 vid)
 {
-	return ocelot_vlan_member_set(ocelot,
-				      ocelot->vlan_mask[vid] & ~BIT(port),
-				      vid);
+	struct ocelot_bridge_vlan *vlan = ocelot_bridge_vlan_find(ocelot, vid);
+	unsigned long portmask;
+	int err;
+
+	if (!vlan)
+		return 0;
+
+	portmask = vlan->portmask & ~BIT(port);
+
+	err = ocelot_vlant_set_mask(ocelot, vid, portmask);
+	if (err)
+		return err;
+
+	vlan->portmask = portmask;
+	if (vlan->portmask)
+		return 0;
+
+	list_del(&vlan->list);
+	kfree(vlan);
+
+	return 0;
 }
 
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
@@ -369,13 +417,13 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 
 	/* Configure the port VLAN memberships */
 	for (vid = 1; vid < VLAN_N_VID; vid++)
-		ocelot_vlan_member_set(ocelot, 0, vid);
+		ocelot_vlant_set_mask(ocelot, vid, 0);
 
 	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
 	 * traffic.  It is added automatically if 8021q module is loaded, but
 	 * we can't rely on it since module may be not loaded.
 	 */
-	ocelot_vlan_member_set(ocelot, all_ports, 0);
+	ocelot_vlant_set_mask(ocelot, 0, all_ports);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
@@ -2127,6 +2175,7 @@ int ocelot_init(struct ocelot *ocelot)
 
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
+	INIT_LIST_HEAD(&ocelot->vlans);
 	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0568b25c8659..9f2ea7995075 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -568,6 +568,12 @@ struct ocelot_vlan {
 	u16 vid;
 };
 
+struct ocelot_bridge_vlan {
+	u16 vid;
+	unsigned long portmask;
+	struct list_head list;
+};
+
 enum ocelot_port_tag_config {
 	/* all VLANs are egress-untagged */
 	OCELOT_PORT_TAG_DISABLED = 0,
@@ -646,8 +652,7 @@ struct ocelot {
 
 	u8				base_mac[ETH_ALEN];
 
-	/* Keep track of the vlan port masks */
-	u32				vlan_mask[VLAN_N_VID];
+	struct list_head		vlans;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
-- 
2.25.1

