Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA24E3DC1D9
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhGaAOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:47 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:60521
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234815AbhGaAOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpCyboUuxTkyRSND/Kfy7979p5pND6OJsIhejDerupu2bIzGUHRD0FB6jhVynEwD5I1+9gh14vonQhJskLJVqao6yuLBQxofuv9bAuVReL+IRVeImZdQOTD0tuVqX5RQ+kU67Tw571STJJfmxX4bxvbX1x/kdwP2xFME+aX4+XOIlNPKkswvk6CCzjljtKwhenDimFgQJWQBBy2eGyYsMoI7SJVpDT5Q8O5oRRgpUZ9v5wq+ieU/MZD/yZ8N/fDOc5MgX4z4XPwmWm4+VR8X+wC/I4C02J4uVHALXEd4rjOB84x6XSsSRbzygMJdSa5qt62n1TvoBTFOD1uNfuNtag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWVxi/4KpAht9Blz2njUNhqv1psAcxL1KkUTdInIGB0=;
 b=OoQbPoqY0nFAQ5unHfewHQK0J3VnQ37gK3ZwXfGqi2upEkt8JOlByZjOHhM1VfEhF0o6pb3XVITdaSPBft8yXRE62hGIy4lD/zXRp3bJ8eg4ApJ4/Ygkt+SuJRJr7D+Tu4gorhD2a5eUedLYbhiyY6vbA6WSbwJfVk+AKa8dEAShW1eOsM/KeAoEXmIEXrwNC42r+/EJ+2ioxMjWF32DUrjlLh+cPvymTYGk0RXLf89yidlYnhXqNy9cb+Ur6jdUJDRRRuct/AqZJ/QqDN+x/VwQ5ebE55kMm+ZLRntvtWOBWx2E1e3b4bT3umnM7MHXz9c6lDrnzELTk3/UfLmv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWVxi/4KpAht9Blz2njUNhqv1psAcxL1KkUTdInIGB0=;
 b=KwlyESZJuYuJzjw+mTOWquxveYQJBibNRSk2SSpZhZeHPdkXaX8CG8AMDi5/mSIa+gAgNcjPWJiSbQTm0bE3We2BceYuDSptB72GRZvTHj33oUzAdCmjyDz3BPX7FK38CSjtfry3nM3yRDXPk1FJkURXH1UtFf1b9HgQIwY726c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 07/10] net: dsa: sja1105: prevent tag_8021q VLANs from being received on user ports
Date:   Sat, 31 Jul 2021 03:14:05 +0300
Message-Id: <20210731001408.1882772-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a550c63f-5141-483e-7cb4-08d953b82876
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65110DD9A98F12E38760DF79E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTthx5ObA+fSywT2QaH8Hhg0j62nHm+dfvqYjEYP/6OImtjn2sGxFq6c95Y5N7NJmO+TU5wwONOTsumSadr0Hz8W3R4i/hwbvuWnydobn+Ui4ufjgLD+hJgW6vztDfkolvJZGUajG7Em4SJgrSX+Tr/ovnu22Y5IYmYzq3M9aEUMpvF5iiD8shnoUOt1NhZNj/0E3JSGqy5Yhl4PsdUunebvQKr00b4W5ZKZoM7j7d4iEy3tQdyEfZwc81NhCqofYzVhlnylkxnnvRBzk+Ca4LSFpsJWmhhL21dSi8k+p0qheyA+LUAay1bu50gGxY/J23XJLj7Y8hMtSmpGQy5Nci0KDxeT68yHLFaaI41mawfYJHKwfjjw9D04ELH90ScbD4iN+O1U9lD3xC9BWyMn1igiWCCAKH8j6gciz4kwc3ZQ5T5399VFFB0CMoKEJRLxD+piHNPiREOotoePxmsgQbyYMLMzg2jAdRIML4EQJaPQd2Nzti/RrJpJvCe0B1ODQDHMTAwOfD8QniPCe2ray3zJTniGd7Ofdjkltq7JPeQhZUFkk6hcibQzITT0qVsHp08VTORvozu5Q5uXNRP0R9lfO5ixnmAbz2wF9yiFroQ49LoDYZ7yFw1ExXimMlWfBCwynP5ZtV2E5i6X2aCNU5MvBzDo7nClReqK3mpbt5CyfpBvooRE8brYlbSPmRn/BHiQ5XCpxt5EnQHRVPPuUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oi0APgsrzuzTqtnO+1QCZkV+RznnXcgICJBHgymlkDsAVuQ8/sHxQ3sUm2Hw?=
 =?us-ascii?Q?bqCs9e4T0dLYwM8nkIKSDIO/YdfEmSc2wkgGApc/NeKUcyYdyBMr1g3HKuEE?=
 =?us-ascii?Q?YzxvDHRUNCrhR8RuXkL4HKzn+fqfFvbF57+Jnss3iobAk+9PZZ2PNNhUYeVC?=
 =?us-ascii?Q?8UH//IG6xOIelQgPJG+FqmesrXdXXjvDcYOwX/+xdOpKPdySkRQU0FpMwY21?=
 =?us-ascii?Q?uxf1RrJu105RJJ8E3nYyiFYwuGC91Vu3rgeF1YBCkYmsPKMKsFSKfAiOvl9A?=
 =?us-ascii?Q?8EkW0A4GfKBtPg1tSwySJRB0NWJYWbUpQqGPf9MI5U2Q0DFgXz/dKGHLBDZT?=
 =?us-ascii?Q?XKi1vtsTZ8vi58CHbOgAn2ACPxFZ02DR+pWUBDR7B1tR9cQV3ZnDdSjEelj6?=
 =?us-ascii?Q?iVIyr4FrkLLAfHYD3zYQLEmX3Ac28GIwebBHNQxkyXrPfgjZvho0A7EThAww?=
 =?us-ascii?Q?1s2yZUDWUb0NZ+R8s67/COBnV4DTR4NS3dp7ccJGDg8qTU9DTVH/W+h6B2Gz?=
 =?us-ascii?Q?pUmfpYwlIG9DO7Sm0bamUyBihLyiFBMbe0ANOh8uaMYxNjYaD1CsD6u15I5U?=
 =?us-ascii?Q?4NbXCQ1wWyr2yQ5dikGlprlYlTnjxfBhlgAY8mdJAiEKZhWoBz6GhhuabMqM?=
 =?us-ascii?Q?jnKM/VHd02ghsAnyDCxhsG/rjTeZSvw48vMVKfHaEnUXYitMCcCa/DO1geQm?=
 =?us-ascii?Q?687FBiRRCLaKnW0b4dvfq/RMzqKDyJwPSY7T+iIGa7GiKUtvQiWIswL9QLtd?=
 =?us-ascii?Q?v/gBL1B781q1gHqf0c52Ws7GIJSvr4Mh9mknC/ZJCGtkiLH/apa+0zCE8EVc?=
 =?us-ascii?Q?MEJgWASVHHj1tBqNWrNS4E30wKS/j6JOuqHIS39Se944PwS0AnHjTnhGOo5R?=
 =?us-ascii?Q?z3VLmGyJOGMt1nzXRVoTVj6yzNBB5zVuIjvHskkqSwE3FVJngkJmHGA5+eH3?=
 =?us-ascii?Q?Nxer2yWxfN/vI/4z0NmCrTZpSv4FNtt5Q0uDn1c60jOJHKiXYXlbm74E+UAi?=
 =?us-ascii?Q?9M7M69zOByU2ogoU/09AMfAEjYDrIAyreOs3YHhGq8mxPBQOKE5NYz+3mGIZ?=
 =?us-ascii?Q?BMBifsYbKkNlAEjMKij9LwiLThVt3EgCzbr4Uie5p0/JmVcL2KL/oFXYM7Vm?=
 =?us-ascii?Q?x1nTa2yuMuMjDtR1GlPyWFC1JGbs/qF4hVLIOnMx1pw9UT1qpWdmVi2ytEMM?=
 =?us-ascii?Q?UzsByo2B2xBYiM7I4SEf8cKE4R3yEzvqoLOLNVCeishe8pAKdxGnA6goLvqn?=
 =?us-ascii?Q?6fODm18mLDaH8MEYaYPl2GlClVsUONRvpDuCyWZrevGHZaeH/3V1FWdMJ+9d?=
 =?us-ascii?Q?MzEp4orERtlrrOdqSfaYz69S?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a550c63f-5141-483e-7cb4-08d953b82876
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:26.9366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kkDR+5GDDauX/VZFsR2/JUrDFkN/uRAFjYDe4Nwk6LtQAqrIq5ULE3zfez6dvPzAjiSJbDXfMa9rSbET5TlSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it is possible for an attacker to craft packets with a fake
DSA tag and send them to us, and our user ports will accept them and
preserve that VLAN when transmitting towards the CPU. Then the tagger
will be misguided into thinking that the packets came on a different
port than they really came on.

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

The revelation comes from commit "net: dsa: sja1105: make sure untagged
packets are dropped on ingress ports with no pvid", where it became
obvious that untagged packets are not dropped even if the ingress port
is not in the VMEMB_PORT vector of that port's pvid. However, VLAN-tagged
packets are subject to VLAN ingress checking/dropping. This means that
instead of using the catch-all DRPSOTAG bit introduced in SJA1105P, we
can drop tagged packets on a per-VLAN basis, and this is already
compatible with SJA1105E/T.

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
index ff6f08037234..31dd4b5a2c80 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -122,12 +122,21 @@ static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
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
@@ -2249,7 +2258,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 }
 
 static int sja1105_vlan_add(struct sja1105_private *priv, int port, u16 vid,
-			    u16 flags)
+			    u16 flags, bool allowed_ingress)
 {
 	struct sja1105_vlan_lookup_entry *vlan;
 	struct sja1105_table *table;
@@ -2271,7 +2280,12 @@ static int sja1105_vlan_add(struct sja1105_private *priv, int port, u16 vid,
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
@@ -2343,7 +2357,7 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		flags = 0;
 
-	rc = sja1105_vlan_add(priv, port, vlan->vid, flags);
+	rc = sja1105_vlan_add(priv, port, vlan->vid, flags, true);
 	if (rc)
 		return rc;
 
@@ -2373,9 +2387,16 @@ static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
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

