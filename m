Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5413D2722
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhGVPPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:15:48 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:4577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232727AbhGVPPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:15:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTpA1dYa5XKMNiQ19tu/0RASj6nHTCsG/pnd0IO7axlFgQWopWZUgxGMK0scVy+eLw9WosQOipkp4pXv9UTWIAGQJnhw/nBYmXGfmzbw8A0EqfA9cR3IwIj9iZgEqWM5DCV0ShZoOIewIs5LEfnQg7il/6ygi7bIrPCQtUxYcOSRV/Zw+bqVRrqtrccuDucw7aovydl5QQIcMa2vany/CHoUjyQ2YYyNaVmd9ynnVYRA5ork/XnoF2Ho1P/uXEzKf761vqKqH4vOIuE2ucRsLRGcyPjDQ28IYhneNZEGnauPreOsPa1vB6D/Zy7YTOQ88AtaofHQ/Onl6uVBbAA3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnNsmqSGXme7gRFsGv5yZ5vZbFhW8Cd6oNNqhjaTRH8=;
 b=JYCv8tXVRV7rLuHYS3AF4LugUo9GmjA9yB9UrqwA9AYqdKpi8DKpRkYOTQtrpSSipGbRTZJDJ7ECUEgkAWL9K7PDJ4z3sZSxlHLpYCIq9BiUFTBLB/nSnRMsiicOeyZWsaeAAPo+YhpB3y67I3a+f9RpCgkCUtLt08rsAFZOBj5bSAR08Zura87pGfT0o9bpyZZIZSZOtYaWXBvhUamA16FWeUPdk40f7xfJuJ5ZaVNkj56xulazZWEpeoYDi871FXBHike7xQO7JSCPJ0XCZoY1WUUGoANA2VIc+MraKyITcdLWufkPavrVJiVKKNHyTbfWFZW55MXAdKEkOreJiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnNsmqSGXme7gRFsGv5yZ5vZbFhW8Cd6oNNqhjaTRH8=;
 b=IfXGzRY6NUEuy60RqzwyKJSVDYQIel+21sC+5d7q/FdYR1O6EW+MF4Uz1dItBtZaXH67yzco1fi+offgq8wfWeHrQDWO8Aga95SuhXQkn0veRPxP2Rsnc4bIfb9zeNB/toOIv+qc754hm6I5ZH6IjN9Eie+8EcGn83RvD/X61/Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3966.eurprd04.prod.outlook.com (2603:10a6:803:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 15:56:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 15:56:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 5/5] net: dsa: tag_dsa: offload the bridge forwarding process
Date:   Thu, 22 Jul 2021 18:55:42 +0300
Message-Id: <20210722155542.2897921-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
References: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:56:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91b9aafd-eef8-44b6-9ced-08d94d293918
X-MS-TrafficTypeDiagnostic: VI1PR04MB3966:
X-Microsoft-Antispam-PRVS: <VI1PR04MB396666A739FEBF56004E3FCCE0E49@VI1PR04MB3966.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fU2ZNL7rC2VwmCIWldyQc8Vy8hco/4zf9Pdvhg0eNFiCxbNSpSLnj2Tc4Ron9/OSbik/6aYnAw5lAhivl1Y9Ae7nrUjWfYPgTtBNON322/uTYdtXtCSGpBWb1x2c5c1jYDt5A1g2vB4xjyYgpnwMNNJdZWUmg2TOyFPBXh9oRI3BfflfOODIJYRaYQn8yIC6lZFMFVKhDbRaHs3STtt6OxydTm8vc3awbN16Ul7AFQyz9trYvF0cRhCGOZN1cHQr5uYugsmPTBLv+xXt+QWY/6efWKUmHZ2cC5oZxYmCbX5/4B7wV7GQMkLQ6c4jt+XcOk4C9K9DE1V8yB/l4cVHvIEVL+dG1X+vq/sgZ9+HH/iwING2u4xrh5XtEJAlsopv3PjcgoRgdlgtq9UZgnMUwKoTn/0p0io8fYMRbLytMfEQZrHxOG2heNyCiuNqBONPw6qZm515V0h/TNYars2DpgzvvqCCv9HqDTGKgBbM10Bh1hrdrsgM5+DpAhI15ifNMpUlh8LtHJwA+aCQfjtY7etibKZWxgK+konWBeLzULDKVR+qItJHGsWrgKfe8k2J1SVCOtn8GotERucEE9909xBh4qSylVPUOTsKnIik9GM5VH7AOZ7CfilB78G9ek3WO2PoN+OgYy1ChPeCmzdUgRdP7wkoNlbiD+kJnHFT00quXr9sZbF2CsGYrQZ/jbc6APN0JOiDgy7atbTh3x86w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(38350700002)(2616005)(7416002)(316002)(508600001)(86362001)(44832011)(66946007)(110136005)(6506007)(8936002)(4326008)(5660300002)(6512007)(8676002)(54906003)(186003)(66556008)(36756003)(1076003)(6486002)(6666004)(66476007)(52116002)(26005)(2906002)(38100700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lEPrLuhfdMoECucb4LclJ6IKrCr2NwEHrRvpr9uSBDf8R97Q3WjO0oOz/+gA?=
 =?us-ascii?Q?/8llzWzdYRUw4r+gpCseTWgf5YJeJfEiEWsqdzguFCH8OXJpDNLB2vGOyBhL?=
 =?us-ascii?Q?vhhquRTCPvJcLpxJlIm/dN0S1zD8VjcD+10BayiBr+AXEKoMfa53WrFwzuP8?=
 =?us-ascii?Q?vqZpnkpvuuXy+K5gPKImD6ziA53hrdHst16ZYa1tGv5k6cEjT9i06YIybkRQ?=
 =?us-ascii?Q?yXhEIbIv6yLPMM5PkVx10FnIc0th0bBTLewPBnju1v4agbzp+HOuz0TVrhwQ?=
 =?us-ascii?Q?VyuWncTyloz09QiuSx4ztk7ogfqt2uVGynhfRobGO4tidyhLFW+tzx5LzoRk?=
 =?us-ascii?Q?tEwcN7oZ9+GwRpoyOwqFjUw0y9BSXkRMmhTUKx9fwoDtnQJEDrUWvPWB8f4b?=
 =?us-ascii?Q?KCdH5otblyzjYOfo5YBAJ6/IOkC4YifJfloWxvNLaRbcfTX7NFPAo2XXBpyX?=
 =?us-ascii?Q?+6UsydJex3j7orggGB50GuQD0ez2zRArYicHaRcPzbIHSPKLGaIqp2iXzm6T?=
 =?us-ascii?Q?BLnPe/QgEQipdzJ+ggIsEv5LqGcVptImtGjpWRbHtGs+zWzMUeq1AC7uhg1S?=
 =?us-ascii?Q?xzXQDP5VfTK2w5H3gXYSElRHODZjT1kKJxcddPTiIVHS17OP7ihsWSO7Nsc9?=
 =?us-ascii?Q?m7gCafkPjpxLV8Tr56tUjN1ubUZ1jCZw8fivYf12qc1LHxBQmyPQyRbZyx/s?=
 =?us-ascii?Q?QQv3b8E9NSkzIifMwx2UuJkChp3iVcp4EJ4KVgfp5YRcsAww181E9UpcQO41?=
 =?us-ascii?Q?C1Le7T7NjH5ZXpdXnGVyp7i2XXUN97e8Cmo8bgxqu/asW8Qmaoq3+TKaNRQI?=
 =?us-ascii?Q?RixaPOfs2pKST43ReyASYdegvBzn4t8zQiWILwauDvN6RgpzXR7QHvghHpGT?=
 =?us-ascii?Q?XqttXgDITWwpmVNbzDTJsZckgy9Ubj0uYSeHVVonRf5flI3JuovHOg8rTFVf?=
 =?us-ascii?Q?owuauJNoBFujBhU78a9Hr6Z6IbY1MaQJfk+0IfxYhPvQkaiDscUst2jv0fwN?=
 =?us-ascii?Q?/SF8KqEXFqccj4fB8RujJoyATJwk33exWhV/HPUtJpnI2rxWoY+4ePKdUFpP?=
 =?us-ascii?Q?qRRklsaSI/vr2LlV0RrkY9+xurjsUX424xeq/GRUdciYqYsOJ0CBopGd7GeI?=
 =?us-ascii?Q?/V/UI8C9IYS2xWcAznMbQnC/j4v79hv6TgqD5qtzIgFXDNQu7dvF6ZlB6jW+?=
 =?us-ascii?Q?gbp4igDwiIxA9Z795akGrP7cJKbU6UQvNZ4wkUgNjonb7HLeR1JFfbXQ5J6q?=
 =?us-ascii?Q?wsZJzGk+yG/bm1rrBt4Tf6TDKa40PIo8FzeKeYWMMc0z+vobJqfbcCsFZMou?=
 =?us-ascii?Q?+fSrAgvebo8fG7X7plwgoDdZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b9aafd-eef8-44b6-9ced-08d94d293918
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:56:09.8257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YApkR31mPBgtx7ALIqNAD5YOr33E0nCFdo5SozNn/zIm4+W56IVOHurlBvat/f3ZGdhILKkHGVd+e3jw8UyOoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Allow the DSA tagger to generate FORWARD frames for offloaded skbs
sent from a bridge that we offload, allowing the switch to handle any
frame replication that may be required. This also means that source
address learning takes place on packets sent from the CPU, meaning
that return traffic no longer needs to be flooded as unknown unicast.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- use the VLAN from the packet when the bridge is VLAN-aware, and the
  PVID of the bridge when VLAN-unaware, instead of the PVID of the
  egress port as the code was originally written
- retrieve the sb_dev based on the TX queue mapping of the skb instead
  of based on the DSA_SKB_CB() populated in the ndo_select_queue()
  method, because DSA does not have ownership of the skb there yet
v2->v3:
- use skb->offload_fwd_mark instead of dsa_slave_get_sb_dev() and TX
  queue mappings
- drop the "bool bridge_fwd_offload"
v3->v5:
- none

 net/dsa/tag_dsa.c | 52 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index a822355afc90..0f258218c8cf 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -126,7 +126,42 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 				   u8 extra)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 tag_dev, tag_port;
+	enum dsa_cmd cmd;
 	u8 *dsa_header;
+	u16 pvid = 0;
+	int err;
+
+	if (skb->offload_fwd_mark) {
+		struct dsa_switch_tree *dst = dp->ds->dst;
+		struct net_device *br = dp->bridge_dev;
+
+		cmd = DSA_CMD_FORWARD;
+
+		/* When offloading forwarding for a bridge, inject FORWARD
+		 * packets on behalf of a virtual switch device with an index
+		 * past the physical switches.
+		 */
+		tag_dev = dst->last_switch + 1 + dp->bridge_num;
+		tag_port = 0;
+
+		/* If we are offloading forwarding for a VLAN-unaware bridge,
+		 * inject packets to hardware using the bridge's pvid, since
+		 * that's where the packets ingressed from.
+		 */
+		if (!br_vlan_enabled(br)) {
+			/* Safe because __dev_queue_xmit() runs under
+			 * rcu_read_lock_bh()
+			 */
+			err = br_vlan_get_pvid_rcu(br, &pvid);
+			if (err)
+				return NULL;
+		}
+	} else {
+		cmd = DSA_CMD_FROM_CPU;
+		tag_dev = dp->ds->index;
+		tag_port = dp->index;
+	}
 
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		if (extra) {
@@ -134,10 +169,10 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
 		}
 
-		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
+		/* Construct tagged DSA tag from 802.1Q tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
-		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;
-		dsa_header[1] = dp->index << 3;
+		dsa_header[0] = (cmd << 6) | 0x20 | tag_dev;
+		dsa_header[1] = tag_port << 3;
 
 		/* Move CFI field from byte 2 to byte 1. */
 		if (dsa_header[2] & 0x10) {
@@ -148,12 +183,13 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		skb_push(skb, DSA_HLEN + extra);
 		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
 
-		/* Construct untagged FROM_CPU DSA tag. */
+		/* Construct untagged DSA tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
-		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
-		dsa_header[1] = dp->index << 3;
-		dsa_header[2] = 0x00;
-		dsa_header[3] = 0x00;
+
+		dsa_header[0] = (cmd << 6) | tag_dev;
+		dsa_header[1] = tag_port << 3;
+		dsa_header[2] = pvid >> 8;
+		dsa_header[3] = pvid & 0xff;
 	}
 
 	return skb;
-- 
2.25.1

