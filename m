Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046163F6645
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbhHXRWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:22:09 -0400
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:42631
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241055AbhHXRT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYTNIb1xIoM3cpOn7oNrR2ibZEmt1OwizkICGoiOdQXpCHd0PajBRUDu0s7FEvMnexIXrqJjT5psbBGUwcyERcPwUKmOTUHvmdhxVH78fAQ6A+BK+WHn7UQsqmDvCdabk0ghaDCK1vZAgO7eJ+1qFdkrUETj1XISmyTsgddXaZcYWunE4xYgQQNyn+U1AHCzRPiObsVVwvVDs0a4c/3MicSel2hBQR3Wu5/Qm+nTtOqCxHrVB3IG8q+8yzvT1fcNnGCqhxCUuRaLOSu8jE9VcYw3exBBxfdu6HvaI7AMIlg9/3Hww8ftogRgit5ruXMO0e+WpvuCDXgzF9MkT7jemg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBxLhlnO/nlo6Myn/aWsgbaa9dTILTNwegB3+oODD9U=;
 b=Xubg/hQUkC69QvYOzIqcw8fYgV7F8k+mxI+qRLyvpga1kLV1l6EIIASL5plQvza1MqfzNAqqE2TNc0LCEZ5in9YGCRDnBzluw+U9MKBiYwJRN8Uy1El0uNUu604tPZ45jQFkKNLOediwdQ4dQMfW9auZy0DPmrPCKpyO2AcUsIoyO/O5Nu9XUs5bX1+L+Cm+uoyQKzVn6XJ2/WY1f6xRf0X2e6DSI/RWA9Pn0aeBmuVsc0o/+kBVtkq8GmrWNFeYdbHJrdCCWFwQm7Kidl3qWxVcN5dqqCl7Py4VqiiKGj8o5F9Bq9wasjysMgayYaZWbSWFKlDi5i5ux/5RFD/mgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBxLhlnO/nlo6Myn/aWsgbaa9dTILTNwegB3+oODD9U=;
 b=DPfjB7nG5S4aixxSz8nAHfi/1x9i+yg93R29A1fp+FSYG2nviLGMRsstUgQWw9SX+0MKr6Lc7d/ymqyWADHF4Ytk29va60UBTOiHiBBFe8pOoWcUN6lGWPRh2gkf2TDlRlsEd3YyWSlx6Um7aNK8gckjzGHiBCEHR+TEWyLp56c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 17:18:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 17:18:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: drop untagged packets on the CPU and DSA ports
Date:   Tue, 24 Aug 2021 20:15:01 +0300
Message-Id: <20210824171502.4122088-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM9P195CA0024.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 17:18:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 160f6d0a-fdc2-426e-32ac-08d9672324ee
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222DB4EE3043CC8E9A39A54E0C59@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WaSuMPP/kSbEhZMP4JawEpB7o5Yu9be5rDRq6+yYkM22fcP9NXzwqCaUtmqH0r9y/0KiD0H2ZnIdB310tcDc4iyW5sUPhaJvrFTvWn/EbxUjdBIhSnRZeFshVT3PZelzXgKJ4oNnTmICbBC6r8ORfM2DrD8xASFwe5APf7Z6xiOYGYR+c88EVaV+stUgC1pl5Jy5tipPQb3pNw7pPHDQAqYajWHSDmL5RSEJNW4LQa9h0gMc5pT0Wv7hw9zm3LAkEEmPBNL7aai9q2vAm23hmTcZHuTr1BlSIHLwiqUNSBc3OhjnjDVYm5jKyciZZL6yEoJn6feGBRoUePHJ3akQi0ggswE/CmFN2lLXiW0VgHhOha8zjILGOwW6AmsNiLvqe6ygcAy6RpRiVERbhbflR8H86JWCoEiVJVmx+lU4aBLE9VV++cn7Hfc+qUk5grbK5e4WTvGdyxRs/+X4728wRDun+MmrN2SXmsZcVSmf6GMkwHs46kbEL4Cyx4grh7X0mBztqbMamUZ/jYlTBWo+Eb22ES7EGygffggIwD1NSyYQK+KLi8bF0ELY0SAoc5vxtl4CLFJDBbXYgCH+2fli/OI7j3q49ofmanCd8MiMiqXJp3vPQWHqTHwOxHlS8Q5Zj8hBumQcke40AgUGAsUvh6GtkIWyaKv4jg4FyGXq2E0Vrlclk/mp/rM6waO0OMQPZmYnv1zhwdGNEoHp8KKJFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(6486002)(66476007)(36756003)(6506007)(478600001)(66556008)(6666004)(2906002)(52116002)(86362001)(66946007)(44832011)(6512007)(26005)(83380400001)(2616005)(956004)(186003)(38350700002)(38100700002)(6916009)(4326008)(316002)(54906003)(1076003)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8cqxvYzNm7+prwCqSXEfKYm9S5rxYCOcfVpxPb7lFRJA2JgTtDF2H23dL3Zf?=
 =?us-ascii?Q?etkBRwzDKg75I2gP6+ROl8nLqgUlrRp5BoY0rMn60wJwaJI7YTSzy9MZw1WX?=
 =?us-ascii?Q?n5PRyVml4LXh1Lo4nr8wle9ES/5S0m8gppbOg2Gv0G6IcqTHfQrA3+/Tl6dJ?=
 =?us-ascii?Q?C+gEcqVPbHYdc6RlxjsPSKHoTwxPDBce/PLjjIMzraBm+mEeXrApXfeqMhDG?=
 =?us-ascii?Q?inq5WUlkeN4vEiZEr/IIBVTRIHiBYrNVC9TWKXo/hIfYHJ0nkPup942Bdg/A?=
 =?us-ascii?Q?0BVSWR+ROnnMhf6mDLp+5fObzgY2l79hNHsQLrOGRYGk8cvwa12c4WLqqWpy?=
 =?us-ascii?Q?1x/c28+b05o4tZZORqHxYSvIQbnmdhedisfac3UMvnGdPgrLqXU/eJ+2qDZR?=
 =?us-ascii?Q?F0N73JLejwf6QsU9S6gOtyDGT6bOnFvaFJQIVjs2Pe9bqy+DOcReLE97GXJJ?=
 =?us-ascii?Q?+T/uCvPtQWJZlUPizV6gNobZ2JPvZYXTBjzmqaRyVIed5BY7uZy01ICE3Fo1?=
 =?us-ascii?Q?uxX+xLjQI0scmXBRHncdEUZujUPRMY8SyTZsD0Wgny0XuD6xteXnOzyqxoCM?=
 =?us-ascii?Q?kFbaCX5Fhd/9FaUSzeOhKmAfXaluZrEiPboDODDTGkYUhDf/xetzeOgZN31h?=
 =?us-ascii?Q?sMjdQMj1h7rayrinW+S3HaNTbyXCnb5Hy7Rx9sEcFNV/H3+kkpGZ+02aQ6xK?=
 =?us-ascii?Q?X9FTI/rrz7Erp8VwXt+zFa2plqPyT+ILTf89djm4xOMT2BUxxeG7e2AbtvuI?=
 =?us-ascii?Q?ikUvF7RsqOPgQpYvho5n6PD3qWrvipOqsgeL+/c4frLR8NL+pvycWAPXKoyw?=
 =?us-ascii?Q?N1D7zkVz6h+d8NEFU73bZvG8N7F7PObjt2nKVZba9omc4rn4GDU386WM5cCz?=
 =?us-ascii?Q?mfqCrgGWKYETVK9hbfZvekkw+3hQL9FeatokQ3eqFjQ66DztJBz/eTt6La1y?=
 =?us-ascii?Q?cQy65eaKouhtUkoE7wNNy5hq58DKkbTT9oWnWGxpo4WQ9aZn7+VLtFaoc56g?=
 =?us-ascii?Q?GVY8o+kacPfb9jmQ5aMZN9K55iHUIyy6xdv4hL+6Afdi2DHUEOdTpoefSixW?=
 =?us-ascii?Q?8Jd+igJ7oio6WJbyCjS4I6DvgECn1BcdpbBtziFIw43G4rjWhuhcBkSJj9ff?=
 =?us-ascii?Q?q9GOxfcCyRwPFgS4xk6yzAmkd1kGoen0T80jT7al2AsUzdgdHoMiKuuoLQAe?=
 =?us-ascii?Q?UO8EOYIUgHla18WM+S7XG+MSGSUKvO4Eeogxg8UxyoCMq5qEk+CYHqmsd+FF?=
 =?us-ascii?Q?/TzHyKM575qUTY5o9B5Z7dqja47rhB3lQnVpii2WqAD8yKR1EthqDfl5NSj+?=
 =?us-ascii?Q?3biK2FO0oXfWKu3mBjWOLWhG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160f6d0a-fdc2-426e-32ac-08d9672324ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 17:18:09.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJ1Kr2/u6847BkQSOz1NPkBF+kQbUZYJsultroIloTyunUjdn/pMFK4sewXnJOY45zi5lyfK0Jas1rYqAwnQBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
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
index 6be9fed50ed5..976f06462223 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -26,7 +26,6 @@
 #include "sja1105_tas.h"
 
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
-#define SJA1105_DEFAULT_VLAN		(VLAN_N_VID - 1)
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
 			     unsigned int startup_delay)
@@ -136,6 +135,9 @@ static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
 			drop_untagged = true;
 	}
 
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+		drop_untagged = true;
+
 	return sja1105_drop_untagged(ds, port, drop_untagged);
 }
 
@@ -217,6 +219,12 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		 */
 		if (dsa_port_is_dsa(dp))
 			dp->learning = true;
+
+		/* Disallow untagged packets from being received on the
+		 * CPU and DSA ports.
+		 */
+		if (dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))
+			mac[dp->index].drpuntag = true;
 	}
 
 	return 0;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 6b0dc9ff92d1..8c5601f1c979 100644
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
index 5b80a9049e2c..a49308fbd19f 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -168,6 +168,36 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp), tx_vid);
 }
 
+/* Transform untagged control packets into pvid-tagged control packets so that
+ * all packets sent by this tagger are VLAN-tagged and we can configure the
+ * switch to drop untagged packets coming from the DSA master.
+ */
+static struct sk_buff *sja1105_pvid_tag_control_pkt(struct dsa_port *dp,
+						    struct sk_buff *skb, u8 pcp)
+{
+	__be16 xmit_tpid = htons(sja1105_xmit_tpid(dp));
+	struct vlan_ethhdr *hdr;
+
+	/* If VLAN tag is in hwaccel area, move it to the payload
+	 * to deal with both cases uniformly and to ensure that
+	 * the VLANs are added in the right order.
+	 */
+	if (unlikely(skb_vlan_tag_present(skb))) {
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
@@ -183,8 +213,13 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	 * but instead SPI-installed management routes. Part 2 of this
 	 * is the .port_deferred_xmit driver callback.
 	 */
-	if (unlikely(sja1105_is_link_local(skb)))
+	if (unlikely(sja1105_is_link_local(skb))) {
+		skb = sja1105_pvid_tag_control_pkt(dp, skb, pcp);
+		if (!skb)
+			return NULL;
+
 		return sja1105_defer_xmit(dp, skb);
+	}
 
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp),
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
@@ -213,6 +248,10 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 		return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp),
 				     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 
+	skb = sja1105_pvid_tag_control_pkt(dp, skb, pcp);
+	if (!skb)
+		return NULL;
+
 	skb_push(skb, SJA1110_HEADER_LEN);
 
 	dsa_alloc_etype_header(skb, SJA1110_HEADER_LEN);
-- 
2.25.1

