Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38EE3DC1DD
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhGaAOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:53 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:13735
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234753AbhGaAOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iawFErW1kd9vwxclWR50TyLKA5b9dhyJa+MLB5+Fb3G6Nekz3rF9T2ydtd7Yy9sriEV4L+/5OW/BHBmtxPXQYOh47/UoxtkRxn8o5AXNhn6dsusGLijSzLV5xtroYv1UXPXXyDSHyOyQPRECde3mI1XhSLA4pAJ6GCsBYFFo3/B+S8VEFcJgGNp2Lv61ToF4iJa7HCMLuS2nUO8ziU13kiHGgbtKx/5Nt6SIXri3YyhSNbyQdPNHvzlBKHR5QLb5Tn7cpNPwHxhnJQ56/WtYsx5CUuboT+caEbLQ5kMXdD6rdBBVgq4UtkTdYl6C/H6pOzcYcvveLeQFTnDr5gZ2dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agCFnOJqp8Q/p3ojNpBvwkDFp6diFTnViRZ0jE99qNg=;
 b=MF4uhsIGU3VZ4P9XNX8cQJWr8V1PHUV+ACv55dwGTOcE1+zf/xFnnA+TV/fwsSl7aFvRSiBtvo55gSb/cTOFSbMtPw3/+8KiP79JXCfg+KWu05AEqhNOJr91Tlxhnca44PtFBuxfz3ZrcOSDkWEMVHfXjkA4//2mJtCr2c5scqg7WZpyKn5UpdT9IaPbLkvvNt7uSwhr4Ry0c/Tz8jSW/IJavtuZvzB3qUKdyV9DS1WcQmk1/xNIouqf/5Q5bLvT9p/3+TAbjdjwIHopTjbx3xDmRJqzhL4Ge7k8SxXPWd4cSgdLX2zqSmi3KaBTqodwHOPTpOW+p3tWrGp5Hx2u+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agCFnOJqp8Q/p3ojNpBvwkDFp6diFTnViRZ0jE99qNg=;
 b=UvqclgnUeD6a6YUfrT+DPGopdfMc/r93KMni/ydYW7E0pPyoOuFZdykIpN/1VLnOFAE5T5f5gnfnMe/IAPE+yYPnq7VOUmdeXp+vAk36Z9uKVGesEq+V0PzAlEP8ACzrOH/VvHRPjdujMxi3fHy07fI6tDOjOAxsX4ogo2uoowg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 10/10] net: dsa: sja1105: drop untagged packets on the CPU and DSA ports
Date:   Sat, 31 Jul 2021 03:14:08 +0300
Message-Id: <20210731001408.1882772-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4355335-a416-4af5-4498-08d953b82a20
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65114935CCDACBCDD3E07F49E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qzw64S5gvL5/8EJazH5aRLg6TdSIrqcbecqM0sdMAl2lxmew5YqhFNlHNdRKeZP8CljT48P2vLXH0eYfP38eTzvxtIc3Rpc5UklW2i7XecJZ7L4XkXBAR2Y6ieyLWZ56TMYtts+HAFsNFVr12Lmtq0e+cQ8fGBNk+EoBygFrVqHYHCTvsry9nCHJn6xWya0UV7gq3h1MFZjFWDXwpc32OmSkR1bQIlUMHdDhn/lA73a8HylPA+8qIVikoR34viQl9IoLxhM7YU5YrXNLfk7DceJujQZe+sW6F2OACdi6HmwbBjUBiZedWC4qbMhuKfF04CM83Doqbo+cJdiCizgx+ICcdXP8RBcCVhIcBZowZjLj9x9t0836kZZlrXXSpBRK9Oe7H61ulQDt+JEvUJA4e9MPJXGHEpEMAsqxONWITs0gmaS/O/E/2I4BfHByL7PRIHpDu0fBbSXEtcFzR1zvuVUXQXxk05eZn+g3CzwUyqnCdTNQibS4xNtqPsPNJ51dIh2g8NBhbtID5C1RQKj7lQFJviu9aJPjU+TnoE87hI3kP5SyU0Ocdod10v9xnoySaT1tFlLkvKf+iGaqq6lkfTI6JbK7I3BGvV17Df5ZAQqh/Lb9Zhy7aWqeADFQDRIf+mH0q6uxcmoH2afjCpMthqqrN6ASXGNdMIf/c2s8bixPBM3gVDvOtYIJlTksLNEkGlPXMr8jl4D+JWM6+fJ2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62iqnkww0cPtAeKTz/EKM94PAYPF8SmuQLwx5/FvWlA+kA++0q3q7TBQJ2j+?=
 =?us-ascii?Q?+0L0bPsWB67ICPQCsTuA5RztoiaMZN1A8md01iAMCiCeYa36rkobF3qaPszX?=
 =?us-ascii?Q?jnjwkmdcUN8H7LWUe+HnN7HVTGkp4YFUCcEEdygzNGZ0FGcXgg52fD0lIL8C?=
 =?us-ascii?Q?ZU0zSwPaYE5CjutdiUAJcGeCoD6qYbwOmGJElqRZdIYUx8+aKj5k4uxckBp7?=
 =?us-ascii?Q?aiJpLCJiAYZO3SFBwIS3+zA1QCCHji4K8aPTNDbMG84uYnSIDOaSkqh8ons6?=
 =?us-ascii?Q?DMtPeZJRs60qQPwOaVw6tcbNKd5vCL8wONAC00E3bjPuArYMLzRXHWpaNq1b?=
 =?us-ascii?Q?CY2l2QcrG3Zaoskncx/JLoJ7Y0RqblysJCoy4azDSswsR7FiT8Oi46NsbJEf?=
 =?us-ascii?Q?lfhyR8i3Ez78tm+bvVmBHrzy28hywkqZzrXLlgKGGg7TSYxa+WIm29TIVt9s?=
 =?us-ascii?Q?cK+WIhiBQKXJqHSXdSmDwHsr2yQGAdeHdgRVT/IZrEBtftVTRWT3EDh+0XGM?=
 =?us-ascii?Q?TpgiZaub0Vcdxb4QzUynR4ER7OJ8QS6VnOLim4M0lzBIX6FHt2f5be8dCq8z?=
 =?us-ascii?Q?CyvqvDhSDrwL162q3unD7UFVzn3eveuZ4XYMDplN4fUXxKs5g7RDKjFWfsjn?=
 =?us-ascii?Q?nVc+yry9NFQEa0Ii5FAFLrE5leoEyeP32vRdKicbVbs6tfu9elHMLQnherEj?=
 =?us-ascii?Q?YMNU+ozRZCg4vsM2eAKER9L8pwUGJIVpWglyjwYNnc7pXq8QvEo89sL+x2Tc?=
 =?us-ascii?Q?nfPkf2RU5G/lko2EbonUf0NB8/wIMpQJ1H02WoCU0Ki+nDN0TdLV6BwKcqc9?=
 =?us-ascii?Q?njg34RSRqefNAUTeitBuwfZ9lhYDPJxN0uIvO10Bv8Myv1aYHJafDe0I4CFi?=
 =?us-ascii?Q?1eiRVCPVoQT0CBNXbToXIAEYBWhLEpT5NtSJS6xbAAqU8KRB0hdWrWlHgnPr?=
 =?us-ascii?Q?JmYvjOQ+poRbOdA4cGYW24XjwUhQEHriUa1Ct3lrFBB1JJGZjWx58nxAVgyN?=
 =?us-ascii?Q?GXxJNKzecoink9XjK0yOL2oH0yaN0vlvnBbH+LHqY4mzJ8aeUB8lDGhbPP2Y?=
 =?us-ascii?Q?K0fght83dlMurcgJx5J/KUN2DhzQSCh5xS1NcmlfOnAaytQ+roGQdQJulIjR?=
 =?us-ascii?Q?QuQ09CuJNjrucwY9AeMw05iHtC2Yk8g+EHuNy+/VY7KZsdGZvMh3PTuq31ME?=
 =?us-ascii?Q?D5Gu4V+A7kbzRrHzACUN6UNsw6SlYhgOpdCUMIMpp9+rYsF7Um9vqCR0968b?=
 =?us-ascii?Q?7oICfxKP/JKzUr604NDy68l/P3xGPYisS1YjLq6tE3OvCFmjxbzCPnBOs4ax?=
 =?us-ascii?Q?1YEApshG+N8zlQgKD7pV58s8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4355335-a416-4af5-4498-08d953b82a20
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:29.6960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZ6FjtrB+nK5AX9oWtIlYyGBkvXG1NumkeIyDFFDEVKOC5Y3V59y2DuERebkWhMH3emWzyjEmpixz0bUgAzt6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 driver is a bit special in its use of VLAN headers as DSA
tags. This is because in VLAN-aware mode, the VLAN headers use an actual
TPID of 0x8100, which is understood even by the DSA master as an actual
VLAN header.

Furthermore, control packets such as PTP and STP are transmitted with no
VLAN header as a DSA tag, because, depending on switch generation, there
are ways to steer these control packets towards a precise egress port
other than VLAN tags. Transmitting control packets as untagged means
leaving a door open for traffic in general to be transmitted as untagged
from the DSA master, and for it to traverse the switch and exit a random
switch port according to the FDB lookup.

This behavior is a bit out of line with other DSA drivers which have
native support for DSA tagging. There, it is to be expected that the
switch only accepts DSA-tagged packets on its CPU port, dropping
everything that does not match this pattern.

We perhaps rely a bit too much on the switches' hardware dropping on the
CPU port, and place no other restrictions in the kernel data path to
avoid that. For example, sja1105 is also a bit special in that STP/PTP
packets are transmitted using "management routes"
(sja1105_port_deferred_xmit): when sending a link-local packet from the
CPU, we must first write a SPI message to the switch to tell it to
expect a packet towards multicast MAC DA 01-80-c2-00-00-0e, and to route
it towards port 3 when it gets it. This entry expires as soon as it
matches a packet received by the switch, and it needs to be reinstalled
for the next packet etc. All in all quite a ghetto mechanism, but it is
all that the sja1105 switches offer for injecting a control packet.
The driver takes a mutex for serializing control packets and making the
pairs of SPI writes of a management route and its associated skb atomic,
but to be honest, a mutex is only relevant as long as all parties agree
to take it. With the DSA design, it is possible to open an AF_PACKET
socket on the DSA master net device, and blast packets towards
01-80-c2-00-00-0e, and whatever locking the DSA switch driver might use,
it all goes kaput because management routes installed by the driver will
match skbs sent by the DSA master, and not skbs generated by the driver
itself. So they will end up being routed on the wrong port.

So through the lens of that, maybe it would make sense to avoid that
from happening by doing something in the network stack, like: introduce
a new bit in struct sk_buff, like xmit_from_dsa. Then, somewhere around
dev_hard_start_xmit(), introduce the following check:

	if (netdev_uses_dsa(dev) && !skb->xmit_from_dsa)
		kfree_skb(skb);

Ok, maybe that is a bit drastic, but that would at least prevent a bunch
of problems. For example, right now, even though the majority of DSA
switches drop packets without DSA tags sent by the DSA master (and
therefore the majority of garbage that user space daemons like avahi and
udhcpcd and friends create), it is still conceivable that an aggressive
user space program can open an AF_PACKET socket and inject a spoofed DSA
tag directly on the DSA master. We have no protection against that; the
packet will be understood by the switch and be routed wherever user
space says. Furthermore: there are some DSA switches where we even have
register access over Ethernet, using DSA tags. So even user space
drivers are possible in this way. This is a huge hole.

However, the biggest thing that bothers me is that udhcpcd attempts to
ask for an IP address on all interfaces by default, and with sja1105, it
will attempt to get a valid IP address on both the DSA master as well as
on sja1105 switch ports themselves. So with IP addresses in the same
subnet on multiple interfaces, the routing table will be messed up and
the system will be unusable for traffic until it is configured manually
to not ask for an IP address on the DSA master itself.

It turns out that it is possible to avoid that in the sja1105 driver, at
least very superficially, by requesting the switch to drop VLAN-untagged
packets on the CPU port. With the exception of control packets, all
traffic originated from tag_sja1105.c is already VLAN-tagged, so only
STP and PTP packets need to be converted. For that, we need to uphold
the equivalence between an untagged and a pvid-tagged packet, and to
remember that the CPU port of sja1105 uses a pvid of 4095.

Now that we drop untagged traffic on the CPU port, non-aggressive user
space applications like udhcpcd stop bothering us, and sja1105 effectively
becomes just as vulnerable to the aggressive kind of user space programs
as other DSA switches are (ok, users can also create 8021q uppers on top
of the DSA master in the case of sja1105, but in future patches we can
easily deny that, but it still doesn't change the fact that VLAN-tagged
packets can still be injected over raw sockets).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 10 ++++++-
 include/linux/dsa/sja1105.h            |  2 ++
 net/dsa/tag_sja1105.c                  | 41 +++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6e0b67228d68..47f480cf9e77 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -26,7 +26,6 @@
 #include "sja1105_tas.h"
 
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
-#define SJA1105_DEFAULT_VLAN		(VLAN_N_VID - 1)
 
 static const struct dsa_switch_ops sja1105_switch_ops;
 
@@ -138,6 +137,9 @@ static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
 			drop_untagged = true;
 	}
 
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+		drop_untagged = true;
+
 	return sja1105_drop_untagged(ds, port, drop_untagged);
 }
 
@@ -216,6 +218,12 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		 */
 		if (dsa_is_dsa_port(ds, i))
 			priv->learn_ena |= BIT(i);
+
+		/* Disallow untagged packets from being received on the
+		 * CPU and DSA ports.
+		 */
+		if (dsa_is_cpu_port(ds, i) || dsa_is_dsa_port(ds, i))
+			mac[i].drpuntag = true;
 	}
 
 	return 0;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 0eadc7ac44ec..edf2509936ed 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -16,6 +16,8 @@
 #define ETH_P_SJA1105_META			0x0008
 #define ETH_P_SJA1110				0xdadc
 
+#define SJA1105_DEFAULT_VLAN			(VLAN_N_VID - 1)
+
 /* IEEE 802.3 Annex 57A: Slow Protocols PDUs (01:80:C2:xx:xx:xx) */
 #define SJA1105_LINKLOCAL_FILTER_A		0x0180C2000000ull
 #define SJA1105_LINKLOCAL_FILTER_A_MASK		0xFFFFFF000000ull
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 664cb802b71a..c23f520db540 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -158,6 +158,36 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv), tx_vid);
 }
 
+/* Transform untagged control packets into pvid-tagged control packets so that
+ * all packets sent by this tagger are VLAN-tagged and we can configure the
+ * switch to drop untagged packets coming from the DSA master.
+ */
+static struct sk_buff *sja1105_pvid_tag_control_pkt(struct dsa_port *dp,
+						    struct sk_buff *skb, u8 pcp)
+{
+	__be16 xmit_tpid = htons(sja1105_xmit_tpid(dp->priv));
+	struct vlan_ethhdr *hdr;
+
+	/* If VLAN tag is in hwaccel area, move it to the payload
+	 * to deal with both cases uniformly and to ensure that
+	 * the VLANs are added in the right order.
+	 */
+	if (skb_vlan_tag_present(skb)) {
+		skb = __vlan_hwaccel_push_inside(skb);
+		if (!skb)
+			return NULL;
+	}
+
+	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+
+	/* If skb is already VLAN-tagged, leave that VLAN ID in place */
+	if (hdr->h_vlan_proto == xmit_tpid)
+		return skb;
+
+	return vlan_insert_tag(skb, xmit_tpid, (pcp << VLAN_PRIO_SHIFT) |
+			       SJA1105_DEFAULT_VLAN);
+}
+
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
@@ -173,8 +203,13 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	 * but instead SPI-installed management routes. Part 2 of this
 	 * is the .port_deferred_xmit driver callback.
 	 */
-	if (unlikely(sja1105_is_link_local(skb)))
+	if (unlikely(sja1105_is_link_local(skb))) {
+		skb = sja1105_pvid_tag_control_pkt(dp, skb, pcp);
+		if (!skb)
+			return NULL;
+
 		return sja1105_defer_xmit(dp->priv, skb);
+	}
 
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
@@ -204,6 +239,10 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 		return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
 				     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 
+	skb = sja1105_pvid_tag_control_pkt(dp, skb, pcp);
+	if (!skb)
+		return NULL;
+
 	skb_push(skb, SJA1110_HEADER_LEN);
 
 	/* Move Ethernet header to the left, making space for DSA tag */
-- 
2.25.1

