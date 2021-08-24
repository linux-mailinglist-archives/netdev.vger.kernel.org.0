Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9BD3F6632
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhHXRV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:21:28 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:63518
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240545AbhHXRT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUAj00IUpMw3a9x8HhWatXJ1uZwej8BcP5IpKQE+kpLKvjFu2r71pK2AT6r1wrgOqAOTBFQaRTxoXKkS6ZWnziWZzq9ACUMa0Cqp6DozUlTiScVU7WPe/oolCgfpUF47Ag3wG6l5B5/3aB0WazmkWRoY9KWFe9nChhDI18rwfBkBcYqIWoMuHD4nxH7tg6XjMZGQ/IqYO5bALce1tx7hJuNRZl3EZVlPdPSh2Txca18w7Y0Pt1neFIDgspwZ0UwXx41u1VA6ZY60lR93ENtnjqHJWm1DGyF/qafhL8lG/eZliubdLYwUrdmz/zMYKHyLL779q4piCmgJrh6skrrjWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVdVifAX8/YsxoyMLDBUD5Vd5xPvl4miaMK4/EuZ08E=;
 b=Rb8aOKhfkFLx32K/pNOrPrTXpR8CkbHbdSIl1+/u3mSPedVluVuACGHnv7WhmBMTagBxBkABYk3+D5lL4tDGV+uewxvIuTVW/EBhjGUG4S2c3d3Hp/vXowIUj8UkOGaN1SdyLNU2CuJFY+IzY+zC4tqqHzy/1LmYTd1WT6QAa9wlLlab+PE1DDCIZUiTWht6mXKreK9rI50XybNnNaKjImIAu01aPvqTTPqQQKdRSKoC1XXAOXzxI9641uoxMn50gSW2sFR9v79Qz9Bae6Kkg6Z6cCO5gdc9agm1kQ3NoLTnj6cVQQKVAqQ6TYA0ObR+n4i2kpHw4Lf3BAZ82rpwww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVdVifAX8/YsxoyMLDBUD5Vd5xPvl4miaMK4/EuZ08E=;
 b=m7iGsYYoJ+jyVObcF0asJ6u/5f40pq/aipRHojQNUEOnO293CoOg+gzq6wA7Cekz5FvOvzv6apfoXgeQw1RE4tK8CC6nMXqEIj6xK6goxGeqDMqK7gVMnIAsq1IXc6bxrOjDi5taJnZzz8s1zimNTRzQuNUZkwQv1YUNlBq4zbY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 17:18:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 17:18:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: sja1105: prevent tag_8021q VLANs from being received on user ports
Date:   Tue, 24 Aug 2021 20:15:00 +0300
Message-Id: <20210824171502.4122088-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
References: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P195CA0024.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 17:18:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d606ba7-1dda-40b8-b941-08d967232475
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB422294F4407EEC5E619E588BE0C59@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TGmKzle3a0+txtu5JgtqLHxFVqoqj1fIDFzRXxTYyrcVVA13SrGP/eFekx/cAWS4+Q2BEs7jT3rmNIF8LAjWC1l+VihCFo43IlOzwqfQm9/3PxRgXSTgPCuxHdHaVUL0zhfYzjsvpqaNh4EtDmy0YpT6Mlb/72QXnDjjdLbxy6mFNcK+T+1skEBQKDqja4kdnQj8LTUG4XBRoOmWIR5fSReBXtqBwe1daZiGJlCK0Oi9ixJwNYti9i5nW9hYtrEsVEV3j1KugEhkrPW2PTJ+Q4oiRRuoDrE0+Cz8G2s6rQJfDCkkNCAmC9RQMFTjjW0omfu5xQMd5CCaItRp3x5G25VN1dUoFNW2sG7PGmn+UCfL7ZeRH1pSWnYf1MPr763OkgBAJwg+6l98D/IPaAETbrVRwOTIAeGIgoQOtKv2t9ARdiINKHjuLSqr/w1ABohhLErtFtSUlXVLkk4rNirBxicB3UrB7DsVcKfDDZz/R0kSAdq+FoO5Y8a8SZ8329gwWXFSFyu/cHcnbKf7F01yrcK/SUqE2jeWnENk6RVNTyx9ONr6OSaBsw15arAXZc+XGfZ923swEj7iTORsvudMf77cB0IEYsKdVEB9WNVie6jzbG3zDaoxriF45damaAOvvRthKnfgQ8L48wlfklwbAoqn+X4yZPBbQHUzrMm+tJeMaHcl8PB4jxXXMYv9Z6KZWXWklowU7GGTaOwR8kEPcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(6486002)(66476007)(36756003)(6506007)(478600001)(66556008)(6666004)(2906002)(52116002)(86362001)(66946007)(44832011)(6512007)(26005)(83380400001)(2616005)(956004)(186003)(38350700002)(38100700002)(6916009)(4326008)(316002)(54906003)(1076003)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ybxlKYCE3WHtwRBQz4RgjBo0phe4T5d9yfTm4VZSsokk6an6zPGr3pwEM2aj?=
 =?us-ascii?Q?wIhMVmzQ6Jo3piUWhY2I8JnXJhSAIFmk1AZvIRy98OTBum/zUEcT1djNuqzl?=
 =?us-ascii?Q?HcgMS8DByoxoYhX3ZwYMzCa4oLyjuLvMIB9pZZmIVtnGU1Hnx5lKcvQVMqOs?=
 =?us-ascii?Q?8SrFgdEd57RMWTl8Vi9Iz8ZZhF22Z1MMBKGedWq2NjuTtc8rd+goJJOoVWYR?=
 =?us-ascii?Q?Mp8vwxObWpCeCcJe8CUjLIvup4/uYGuuMlOF/whXFpMUFNGxatjc62rLiG5S?=
 =?us-ascii?Q?FgPpSJLCWEkk00/p4f6xoDHCCdw0QWBeJdxdIHqYsaPOoQJ4uvi8uQYAF0/e?=
 =?us-ascii?Q?AR4qXqiRvcUy7fUSpo1wjvF9ME5igYTX02gQJ83Fsc/qn0tVc66Ns9dCz5SM?=
 =?us-ascii?Q?6GjzGZMGkYQ6kRRMy05ysoxgWqQxfViCTsG6xCwOTzSunZikKnVYzONarqBK?=
 =?us-ascii?Q?2c96ftkhiWjJtDjmTVe2wVcF/smIfL4fezb9r4+er8oJzz6aJl/S9hdncMk3?=
 =?us-ascii?Q?mrTE31h3MvjMFVwX0Zd6PcE4HhWrzpL3lD19CSO3GqRSNA3opYkfCKU/peml?=
 =?us-ascii?Q?4shyklFWROs1rWx0RtPsJC2wIhYcQZYR6GcxKwg/BcPOXY4r8ca3Ug86ISFs?=
 =?us-ascii?Q?KpKvWloHJDdbsmJ27ZQ1SV4pfyAP0QVtZ+h2CD43EwBpQgdzeoTpzLBbBU53?=
 =?us-ascii?Q?apGpSxIHW5+sHoLkqSW3EzO+Zqgp6G3zh0k9u1wxM8dEWSONO4EQ0tvJeb9y?=
 =?us-ascii?Q?ZiTdG8sQAHXdCN4n+X2TQgfi4w7bYRYZtIgcYHtYd3tVqzwS2kE32WgmGBU8?=
 =?us-ascii?Q?OvCcyJ6qSNj90OuY+uVcKkAm/W3xD+++BwsUYWcPqt4R1/abQwbvCd/wDuoz?=
 =?us-ascii?Q?cCgRiYvr6o9lWf+5ch+A4bU5iT1P2aFlTxTQis8KqgD7EUPPwtt3yAV2q+Qc?=
 =?us-ascii?Q?Ml5Whxghxmnb9eIQsZHSXZn/N8MIT7NWB9JDICswdGjHGgOl+Nt8v7AS6Lry?=
 =?us-ascii?Q?6j0IIimIz0zsGRBcd1AHcxwclwgrgVsvTiHPEdvnCmiejRrBGzGHcyXV8iGK?=
 =?us-ascii?Q?s5w7bqNnDvIdUe0UsUeNDyZNqLZirH4256nePkCqXvQJotfQQ/ZhuAs3+Td1?=
 =?us-ascii?Q?zPrLlrkNtwKrmQ4CTQwf2n7jRGi8tMsqZBqt/E5h38c7C6OQF/VkTYdoYo8g?=
 =?us-ascii?Q?IOT+XLsCbDH0DJwOeYpL+qv9zjPwmVdXgMBpupJAFoUcIvj1f0UTYUHtb/Ii?=
 =?us-ascii?Q?rgBP6ChNQBYzC/gpCZ549C+qDEdLnfRKNoYsxHVHXpxlOkDN7x0scvEF7+0o?=
 =?us-ascii?Q?fkekJGc9RKR6D7qJrrgBHapt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d606ba7-1dda-40b8-b941-08d967232475
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 17:18:08.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkRIeuL5DRkmueeXa3s1Qe6zVVsPdpNym/i2cJ/SbKKvo4mdrOVgQQDpR9zI9ihnSEiIuhhRxDCBVgSAPDDa7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it is possible for an attacker to craft packets with a fake
DSA tag and send them to us, and our user ports will accept them and
preserve that VLAN when transmitting towards the CPU. Then the tagger
will be misled into thinking that the packets came on a different port
than they really came on.

Up until recently there wasn't a good option to prevent this from
happening. In SJA1105P and later, the MAC Configuration Table introduced
two options called:
- DRPSITAG: Drop Single Inner Tagged Frames
- DRPSOTAG: Drop Single Outer Tagged Frames

Because the sja1105 driver classifies all VLANs as "outer VLANs" (S-Tags),
it would be in principle possible to enable the DRPSOTAG bit on ports
using tag_8021q, and drop on ingress all packets which have a VLAN tag.
When the switch is VLAN-unaware, this works, because it uses a custom
TPID of 0xdadb, so any "tagged" packets received on a user port are
probably a spoofing attempt. But when the switch overall is VLAN-aware,
and some ports are standalone (therefore they use tag_8021q), the TPID
is 0x8100, and the port can receive a mix of untagged and VLAN-tagged
packets. The untagged ones will be classified to the tag_8021q pvid, and
the tagged ones to the VLAN ID from the packet header. Yes, it is true
that since commit 4fbc08bd3665 ("net: dsa: sja1105: deny 8021q uppers on
ports") we no longer support this mixed mode, but that is a temporary
limitation which will eventually be lifted. It would be nice to not
introduce one more restriction via DRPSOTAG, which would make the
standalone ports of a VLAN-aware switch drop genuinely VLAN-tagged
packets.

Also, the DRPSOTAG bit is not available on the first generation of
switches (SJA1105E, SJA1105T). So since one of the key features of this
driver is compatibility across switch generations, this makes it an even
less desirable approach.

The breakthrough comes from commit bef0746cf4cc ("net: dsa: sja1105:
make sure untagged packets are dropped on ingress ports with no pvid"),
where it became obvious that untagged packets are not dropped even if
the ingress port is not in the VMEMB_PORT vector of that port's pvid.
However, VLAN-tagged packets are subject to VLAN ingress
checking/dropping. This means that instead of using the catch-all
DRPSOTAG bit introduced in SJA1105P, we can drop tagged packets on a
per-VLAN basis, and this is already compatible with SJA1105E/T.

This patch adds an "allowed_ingress" argument to sja1105_vlan_add(), and
we call it with "false" for tag_8021q VLANs on user ports. The tag_8021q
VLANs still need to be allowed, of course, on ingress to DSA ports and
CPU ports.

We also need to refine the drop_untagged check in sja1105_commit_pvid to
make it not freak out about this new configuration. Currently it will
try to keep the configuration consistent between untagged and pvid-tagged
packets, so if the pvid of a port is 1 but VLAN 1 is not in VMEMB_PORT,
packets tagged with VID 1 will behave the same as untagged packets, and
be dropped. This behavior is what we want for ports under a VLAN-aware
bridge, but for the ports with a tag_8021q pvid, we want untagged
packets to be accepted, but packets tagged with a header recognized by
the switch as a tag_8021q VLAN to be dropped. So only restrict the
drop_untagged check to apply to the bridge_pvid, not to the tag_8021q_pvid.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 37 ++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 05ba65042b5f..6be9fed50ed5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -120,12 +120,21 @@ static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
 	if (rc)
 		return rc;
 
-	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
+	/* Only force dropping of untagged packets when the port is under a
+	 * VLAN-aware bridge. When the tag_8021q pvid is used, we are
+	 * deliberately removing the RX VLAN from the port's VMEMB_PORT list,
+	 * to prevent DSA tag spoofing from the link partner. Untagged packets
+	 * are the only ones that should be received with tag_8021q, so
+	 * definitely don't drop them.
+	 */
+	if (pvid == priv->bridge_pvid[port]) {
+		vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
 
-	match = sja1105_is_vlan_configured(priv, pvid);
+		match = sja1105_is_vlan_configured(priv, pvid);
 
-	if (match < 0 || !(vlan[match].vmemb_port & BIT(port)))
-		drop_untagged = true;
+		if (match < 0 || !(vlan[match].vmemb_port & BIT(port)))
+			drop_untagged = true;
+	}
 
 	return sja1105_drop_untagged(ds, port, drop_untagged);
 }
@@ -2343,7 +2352,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 }
 
 static int sja1105_vlan_add(struct sja1105_private *priv, int port, u16 vid,
-			    u16 flags)
+			    u16 flags, bool allowed_ingress)
 {
 	struct sja1105_vlan_lookup_entry *vlan;
 	struct sja1105_table *table;
@@ -2365,7 +2374,12 @@ static int sja1105_vlan_add(struct sja1105_private *priv, int port, u16 vid,
 	vlan[match].type_entry = SJA1110_VLAN_D_TAG;
 	vlan[match].vlanid = vid;
 	vlan[match].vlan_bc |= BIT(port);
-	vlan[match].vmemb_port |= BIT(port);
+
+	if (allowed_ingress)
+		vlan[match].vmemb_port |= BIT(port);
+	else
+		vlan[match].vmemb_port &= ~BIT(port);
+
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
 		vlan[match].tag_port &= ~BIT(port);
 	else
@@ -2437,7 +2451,7 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		flags = 0;
 
-	rc = sja1105_vlan_add(priv, port, vlan->vid, flags);
+	rc = sja1105_vlan_add(priv, port, vlan->vid, flags, true);
 	if (rc)
 		return rc;
 
@@ -2467,9 +2481,16 @@ static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
 				      u16 flags)
 {
 	struct sja1105_private *priv = ds->priv;
+	bool allowed_ingress = true;
 	int rc;
 
-	rc = sja1105_vlan_add(priv, port, vid, flags);
+	/* Prevent attackers from trying to inject a DSA tag from
+	 * the outside world.
+	 */
+	if (dsa_is_user_port(ds, port))
+		allowed_ingress = false;
+
+	rc = sja1105_vlan_add(priv, port, vid, flags, allowed_ingress);
 	if (rc)
 		return rc;
 
-- 
2.25.1

