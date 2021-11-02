Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F5443683
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 20:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhKBTeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:34:12 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:49408
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229764AbhKBTeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 15:34:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mut/nUXGv+6U9t2yl4akbY1FLkSHCv/UmuMDG+EjttIuhAz+h3XZEkqb4DucllfUebDCWBBf/py737iOOS0P6dBc6LTewLqHohbIq8qjovAaepKWGJWWHmADcvBAYCgnz8IhQDBFcb5P8ENSu0ARId9D+1DciXUe91H1YXxM5H4wFmPnSnNGiJgx7WeEifevrMZWuFWjOc+a1hNX9EXqAaRd8R3vr4HO/EDl9Ap4VbOyLES7AerYm19h+t/bwvoYPq6hIwUsrYGGlfsSVAGq7dplkUSeKYvdtKBrlRKp3XBYboUr35KNoCBA2CluVhyzvySCfB0fxM8Gjc1XpFq+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2iTG1LO7croA1Fq/6ArtfPlxDdKDs+qlVAT639fmOo=;
 b=H9n9/cR0oHOYqEOA/CBaETxbGkYc58yXlhtU6tBiwjZZSjyEHQJ8VXJvHdhsKMBEJl+tyYMquSQxXOJjgKQB3G1jc9FrlraD2N6U5+TocubyB0q59cVBaWTsn6bIdM3c4aEMdWUyAvJgORQaH6GoyjVpFYBeOzolzGDuEohJ8MjpoMwFnvCH0w4Z5E2ziI87g9I040XTFcGWdclJuQqu4WUGPgaxTe+yrseRtTciqmLZrOCUDPjLEmauaqBV3foMbVVgmQNGwQuYJTfNZFwOEJS9T1RhsobS9jQ/WltxmrhFXFjPqTrYDXzHp9ZA0nQlkUsUOBMH3ARjSckJnyuQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2iTG1LO7croA1Fq/6ArtfPlxDdKDs+qlVAT639fmOo=;
 b=OhHa4mKDg2FoCRPHt/tOse0PP28s+F0JgQ6drD3PN5DkTcBZa075dVOSxAhU7F3On/hD9bw4/s8iZ9S0nrcdtP6C1RWUOpP+X0rO8Os2CDmrfz3iTS5Lr9+RGqvqMZTxZQW1G1ww6tW5Y/hco35J+TDAMr6U9C7EUhU2vl0f4GU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 19:31:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 19:31:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net] net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge
Date:   Tue,  2 Nov 2021 21:31:22 +0200
Message-Id: <20211102193122.686272-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0115.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by VI1PR08CA0115.eurprd08.prod.outlook.com (2603:10a6:800:d4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 19:31:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62480676-7ce0-4d3d-e5e2-08d99e3760f0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342CE19FADCD667A32A0A7BE08B9@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Djq0SGwmf6uKdSCinEpooQtyI/A8+V+9a3aaPyr47FytMMUuTBSOhXgP9RgnzCf6B0X93/8DCmm7k+XlfZa1KIptcrWHUgFhluUfyRBungwuOpFCS+LEuhOsN1CHplf2lANK+65lyCCqyfEqsAFwLmQlMYhgiC6Vy6OaJUzY0SiKSiazTV+uQ4XyERcEzkP9TtfS879DtAk+vDY6jUMgjCpnukx3KjC3/jnIhBAbkMV9PCId2lFSFGP7qE97SA2FJP7CyZsRDfVViqwO64peAcda16nV1Evah9WMbGPrXK7oblSxUVidb0XqFHCzw/eZ+WKuIRI1YyFOfUd4B0REaG92Ywyk/IvQ6/uqCMDz/wQZ7k04oE9uZ1hPhA8t2SMVVwJJsBD7KIMARSIErIYwW+JXn8qUXkMTj3w6CznaHDJEqe8rOuLXfYSyMugtWUS9oKf6qXE8ofybtFTKpV9QURAOPBRZl5n+/l8POsT89V2krChCYdAwk7W2Le2xotfMGyJM3VRL7O1OJKp2LRZoWTvd1MUhH9wknzn1IiKHS7sPFu0N7WOq5A4OEKDi0w9anNA/UiqZrZwhN+g7fII9oQUulJQ3+taxywPVjraKdt3TpQFoTjFUw5AcmC/Fg0xQuze6Bq6EYxRxttW0vuKl02lWaOMuemERqZGtUo2eQAOL3JTMdyQUjVTAlwDEfvOU5wG0H2jmX20Xv///UX+11crwo/fzti9Up8+nVJkjY47gopONHiIIuuWiD/1WmXGJrD8BMo+cJVIMb8K3LZgcpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(316002)(26005)(956004)(186003)(6506007)(6916009)(36756003)(8676002)(86362001)(4326008)(966005)(38350700002)(6486002)(38100700002)(83380400001)(66946007)(44832011)(8936002)(54906003)(508600001)(66476007)(66556008)(2906002)(6512007)(1076003)(52116002)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CsdnvTurW5HQs/FI9aFxtiBpfP3oGbXPoeUrPkk9pTuZj9G7L+k/Rzmk5vqy?=
 =?us-ascii?Q?HvDdf3lY7thihiJwsPVnRT4Bee0tAAJlykhwbqZiJSrUeOSDY1IUhgUXEcEg?=
 =?us-ascii?Q?kAm/9kWOmz1n3k+zVLCF+XXXISYpialx5pSCDZ/RZV4SybX/sCla1drExchN?=
 =?us-ascii?Q?7bISeJ9qVmXnVB5khhrl9Ephd7Wl+jWSSfYxAW0/Rmr+xwIQ/ccpcOix6ofn?=
 =?us-ascii?Q?fuTAdaNJP6FNfoikRyo1ojWu9to6gp1nx5N+n4iYbNspfgbcNjK8n2xILTii?=
 =?us-ascii?Q?7Qm4/JYCqBaeoDygUrTa5I3yL+Gop8KmsnQQlxWKDDrtXmz1ArtnEFRupVOC?=
 =?us-ascii?Q?eRaYFmJKOUv2Sqzw2rRTr6FPtVSMRxqf+XoH4tqCY0/bht9Lq4e2YhBeZGD1?=
 =?us-ascii?Q?ZFszv7Ke/zzLdorJ+V+AH2P1NXzlTN3ysJQWMfvyRBwbbeVIjWfpVUYSlQuD?=
 =?us-ascii?Q?MoSrHwcf4RXUYezZvWZV6QOp6KYUnj/JETqF1/vbbbP4Gtp1u0X5v4qVqV6n?=
 =?us-ascii?Q?KXeR5Jhp2DnxvmBgjG2UNWRF//RtHLY73CZ+hByFRqIrNkTyahwrUJ9Moq+h?=
 =?us-ascii?Q?NArgDN2GToIW4CQZR5akPxYwaczjmogRjDGfKHvLGW8Penfx4L99dglexSvh?=
 =?us-ascii?Q?yWRPXcGgY1EI0jqE7ML0Ci9OcOHJcMiKRJBh2V3mwAyzIWDd8DWakO8PMce8?=
 =?us-ascii?Q?mM9iXxvQoFcUoI+J1xgNFkIoJiUTbpk6qdzuFFoSdzomJWAm7UQBWcqszm6M?=
 =?us-ascii?Q?tN2ASvgCGNfDjA1gVZ4I4jy8RWY7rpfJrmfshahCJZLUGLEXHQK6QhA1mYfd?=
 =?us-ascii?Q?o17xPMHx5hLPLHEURNqKqPD/Fj7N5iFeH8zWkSzgLA0LKKIsI/q+yCAlUhq3?=
 =?us-ascii?Q?ZDV4b2tOjPU4SyJ+crJ0vrqTjZbKfvPULikadzXzQ/AT9pSsHJQba/SqKtIZ?=
 =?us-ascii?Q?E0XMANPzHddi56sptMzwk6Xs35uDr7q1BU4S3HjdSknBfdqPYpHUoCaRR3eE?=
 =?us-ascii?Q?nMgbcNX+nVDu8WXuK7+7RfZVX8WIs6UjeMolx7ZNXxSfOi1F4rEhgsTXiy/B?=
 =?us-ascii?Q?DD+177zBMvPXgqRXJ5svjs8N8kxlTzm4U5raQz9Ezz+XoGsLSfYX1tcwRvEn?=
 =?us-ascii?Q?dvuT/k3OEZ5Y0Hphp+Op3FOkzIlnrlkZFzSix1ZW78UbMvOJtAWNV2/q1SNG?=
 =?us-ascii?Q?mmBZVDHP0cZFGMelw0+ukkWJIrRwc7U4UqnCrvu8Kz6oNq5ypMSR3ulBYC01?=
 =?us-ascii?Q?XLfWcOUppxjGkeX8peM4dHkqDJpjDozswLsXEIPU1mzL+kgofFWfGvYFkbOa?=
 =?us-ascii?Q?/wSmoaDtH72WJbLM7p7EtkGAbQdvI5sEUkcEqq99pAZ1JveeZtl3eCaC107M?=
 =?us-ascii?Q?Eh1nLWxKeXtFguQBXh+Sq2PLDGZ+nG+RpeaGDdlq0FMtqDhSOU0VvVc/8RP4?=
 =?us-ascii?Q?ZA9+WVOYQtgg4X2rLWNsqjJHnA41LiCsaEYSGD4RyoUFRit92EZaZx2tscEH?=
 =?us-ascii?Q?29T6GwShQE/M7Sa7VgkLuwpoKBZEmVMKn6/8VI4hy9hZGvFTwkk/P0gWWHpZ?=
 =?us-ascii?Q?FQpGekNWYbccAa4egHcVImI4i2XmwUBB4tJU6MfeMtk8BjKxwOAqEZSoqBuD?=
 =?us-ascii?Q?yva0s6/YJ+0SoB/Mjzac4xY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62480676-7ce0-4d3d-e5e2-08d99e3760f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 19:31:33.8464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhIv+06UEdYqr76Kn9cYqa4aVgUczWiZVxCtvwB56YRCRw9cbsJLPu4EUjTTD9t/QJmkGrIG/JSoYVjKloQGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally it is expected that the dsa_device_ops :: rcv() method finishes
parsing the DSA tag and consumes it, then never looks at it again.

But commit c0bcf537667c ("net: dsa: ocelot: add hardware timestamping
support for Felix") added support for RX timestamping in a very
unconventional way. On this switch, a partial timestamp is available in
the DSA header, but the driver got away with not parsing that timestamp
right away, but instead delayed that parsing for a little longer:

dsa_switch_rcv():
	nskb = cpu_dp->rcv(skb, dev); <------------- not here
	-> ocelot_rcv()
	...

	skb = nskb;
	skb_push(skb, ETH_HLEN);
	skb->pkt_type = PACKET_HOST;
	skb->protocol = eth_type_trans(skb, skb->dev);

	...

	if (dsa_skb_defer_rx_timestamp(p, skb)) <--- but here
	-> felix_rxtstamp()
		return 0;

When in felix_rxtstamp(), this driver accounted for the fact that
eth_type_trans() happened in the meanwhile, so it got a hold of the
extraction header again by subtracting (ETH_HLEN + OCELOT_TAG_LEN) bytes
from the current skb->data.

This worked for quite some time but was quite fragile from the very
beginning. Not to mention that having DSA tag parsing split in two
different files, under different folders (net/dsa/tag_ocelot.c vs
drivers/net/dsa/ocelot/felix.c) made it quite non-obvious for patches to
come that they might break this.

Finally, the blamed commit does the following: at the end of
ocelot_rcv(), it checks whether the skb payload contains a VLAN header.
If it does, and this port is under a VLAN-aware bridge, that VLAN ID
might not be correct in the sense that the packet might have suffered
VLAN rewriting due to TCAM rules (VCAP IS1). So we consume the VLAN ID
from the skb payload using __skb_vlan_pop(), and take the classified
VLAN ID from the DSA tag, and construct a hwaccel VLAN tag with the
classified VLAN, and the skb payload is VLAN-untagged.

The big problem is that __skb_vlan_pop() does:

	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
	__skb_pull(skb, VLAN_HLEN);

aka it moves the Ethernet header 4 bytes to the right, and pulls 4 bytes
from the skb headroom (effectively also moving skb->data, by definition).
So for felix_rxtstamp()'s fragile logic, all bets are off now.
Instead of having the "extraction" pointer point to the DSA header,
it actually points to 4 bytes _inside_ the extraction header.
Corollary, the last 4 bytes of the "extraction" header are in fact 4
stale bytes of the destination MAC address from the Ethernet header,
from prior to the __skb_vlan_pop() movement.

So of course, RX timestamps are completely bogus when the system is
configured in this way.

The fix is actually very simple: just don't structure the code like that.
For better or worse, the DSA PTP timestamping API does not offer a
straightforward way for drivers to present their RX timestamps, but
other drivers (sja1105) have established a simple mechanism to carry
their RX timestamp from dsa_device_ops :: rcv() all the way to
dsa_switch_ops :: port_rxtstamp() and even later. That mechanism is to
simply save the partial timestamp to the skb->cb, and complete it later.

Question: why don't we simply populate the skb's struct
skb_shared_hwtstamps from ocelot_rcv(), and bother with this
complication of propagating the timestamp to felix_rxtstamp()?

Answer: dsa_switch_ops :: port_rxtstamp() answers the question whether
PTP packets need sleepable context to retrieve the full RX timestamp.
Currently felix_rxtstamp() answers "no, thanks" to that question, and
calls ocelot_ptp_gettime64() from softirq atomic context. This is
understandable, since Felix VSC9959 is a PCIe memory-mapped switch, so
hardware access does not require sleeping. But the felix driver is
preparing for the introduction of other switches where hardware access
is over a slow bus like SPI or MDIO:
https://lore.kernel.org/lkml/20210814025003.2449143-1-colin.foster@in-advantage.com/

So I would like to keep this code structure, so the rework needed when
that driver will need PTP support will be minimal (answer "yes, I need
deferred context for this skb's RX timestamp", then the partial
timestamp will still be found in the skb->cb.

Fixes: ea440cd2d9b2 ("net: dsa: tag_ocelot: use VLAN information from tagging header when available")
Reported-by: Po Liu <po.liu@nxp.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 9 +++------
 include/linux/dsa/ocelot.h     | 1 +
 net/dsa/tag_ocelot.c           | 3 +++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 83808e7dbdda..327cc4654806 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1370,12 +1370,12 @@ static bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
 static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type)
 {
-	u8 *extraction = skb->data - ETH_HLEN - OCELOT_TAG_LEN;
+	u32 tstamp_lo = OCELOT_SKB_CB(skb)->tstamp_lo;
 	struct skb_shared_hwtstamps *shhwtstamps;
 	struct ocelot *ocelot = ds->priv;
-	u32 tstamp_lo, tstamp_hi;
 	struct timespec64 ts;
-	u64 tstamp, val;
+	u32 tstamp_hi;
+	u64 tstamp;
 
 	/* If the "no XTR IRQ" workaround is in use, tell DSA to defer this skb
 	 * for RX timestamping. Then free it, and poll for its copy through
@@ -1390,9 +1390,6 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 	tstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 
-	ocelot_xfh_get_rew_val(extraction, &val);
-	tstamp_lo = (u32)val;
-
 	tstamp_hi = tstamp >> 32;
 	if ((tstamp & 0xffffffff) < tstamp_lo)
 		tstamp_hi--;
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index d42010cf5468..7ee708ad7df2 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -12,6 +12,7 @@
 struct ocelot_skb_cb {
 	struct sk_buff *clone;
 	unsigned int ptp_class; /* valid only for clones */
+	u32 tstamp_lo;
 	u8 ptp_cmd;
 	u8 ts_id;
 };
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index cd60b94fc175..de1c849a0a70 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -101,6 +101,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	struct dsa_port *dp;
 	u8 *extraction;
 	u16 vlan_tpid;
+	u64 rew_val;
 
 	/* Revert skb->data by the amount consumed by the DSA master,
 	 * so it points to the beginning of the frame.
@@ -130,6 +131,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	ocelot_xfh_get_qos_class(extraction, &qos_class);
 	ocelot_xfh_get_tag_type(extraction, &tag_type);
 	ocelot_xfh_get_vlan_tci(extraction, &vlan_tci);
+	ocelot_xfh_get_rew_val(extraction, &rew_val);
 
 	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
 	if (!skb->dev)
@@ -143,6 +145,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 
 	dsa_default_offload_fwd_mark(skb);
 	skb->priority = qos_class;
+	OCELOT_SKB_CB(skb)->tstamp_lo = rew_val;
 
 	/* Ocelot switches copy frames unmodified to the CPU. However, it is
 	 * possible for the user to request a VLAN modification through
-- 
2.25.1

