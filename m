Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28E13CCB29
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhGRVtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:50 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:53472
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233672AbhGRVtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7JmL0qtv5NNJawwZGONteJq4yt2O+ibFDLsWjn8iCXxlPXD4m3JL93QgpvFTzQn4qzD4OCg3V073mXtYK54kBUR38YC2m77fM7pvvIw4PQj5PatUFZXQPMVAo14ST8yPEHQ7g3uZtce424rd/WWeLMwoRb+lc/PwzFm0fFwyuLLHUSAX7Xx2yJ601g6iEIw3EnWjDUKgKMWqLlA3NV914DjXGdfwZN7qYxzgBSSKRKGm5j9L53+Ii+DPxjqIagYknCl4d/dPF1JELDvRxs8HowxCJD5YutDosAgw3oJgmKSqCJRBlxs897X3RuCaXc7XEYwqG0PDK3loNNYlgTfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1X+LahK04LAJLXGx+tRE/udaDcCmdHQWHgguzH/tLY=;
 b=bgmWqgAAua6cGs2tz3ceeDDV/FkOvPZvGG8uewiww92WFOBnvDGNGMdZDynsxhTXsMNy/QT41WiY33uJ0u2YMz8XBhrR9rdM9CJ6SxXwyWmIkLWPt0Amxwm8ZA2Tu+8CTz5UW8kiNplG8U1WsRjpO3Jb82HcWqMJjHTAVo+IMiGSuAYh7FxqlQiuHT7wDo5ogDnPmx/LMYvqc4c0FriK8V7HNFmaxdlkF9uhcfMPkKAsuQzNqhg8c66AzHCCharTbrVrA7hGg6/uckE+lNkOia8v3eHgDti/PfNBeBfqdmG1hsYZljKFuNavWz52J3w/u6gsPnd5sSM8nLpll761Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1X+LahK04LAJLXGx+tRE/udaDcCmdHQWHgguzH/tLY=;
 b=W43z8yH8bCqN412NTsgt55BWbOq6r5/A8rU77jKHiB3ElqIcBCa+dd+igRgG/y+uiaRMIfJySY7mWF9opjx8CcyvdRA7KpcnQoWCWg9eNd40PEMW2wYpAME1ar30zG6ZfDgv8OohVUmRqs8bL/ZCP6MgcVZNP0tHcfpMVg2wSe8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sun, 18 Jul
 2021 21:46:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:22 +0000
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
Subject: [PATCH v4 net-next 15/15] net: dsa: tag_dsa: offload the bridge forwarding process
Date:   Mon, 19 Jul 2021 00:44:34 +0300
Message-Id: <20210718214434.3938850-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 217d1dfc-980d-4b43-f238-08d94a357bbc
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5502872583D8C9DA0ABD170BE0E09@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gv5i1seNleXuXzS6kxJNw83qL9Q9Qq/2lS/4+d4PCcSYfWlEJrY35oaVNlrBX01+wkX7EFZ4co2E6k0n5qFNRI0cldkltUbcnFOcOVDTC7JY75Czk+fNfBeu8zR+Gow+/DFaR6nAbrQ0JRSUCNjQzFoYMTm41b4td7CVAffMnfbKlv03iYKopHvM4/tYJJ7uSOxgpg2t9ZhMhsq3bd7Izju/XxMFBR4xe6Yv2QUmSis1aCik2+SMU8Jf9aD3AP3KwKTu5Td9qyfYS+kGWbsM1ArmX2le/yurLieSLfcNadC8aHbBVui2kT40PoxDpQ/Ri2OMsaYS+O6/8IrqDuYQ8IV3rGI31tljm8M5I2njbQQE09iqcCTilQy3g2ctQ8naZwvLzV2HpgovomoUKqz6jw0QEu4cctjb50JHe3g+ItADYGGcn4S0xYkVqU1q0UjD8WRHDFaKZzCPEgCoLUebnBNtBOhlXEyE9ZFoECjpm4RX0fVgzAu+U4yNzMYUOlCgE/ibq+Uh9nMcX9BvgtcZ6h54BvMtEHTmFqJbxzoPUr9+JippB0JrjHezPO/NyUfSeYekgpmZnjBn5lgwFS6tQxW6RiHFsvjXg+ygu3lAal1IKPXed44yK6+W2avpkhfW0MROFnyk3SElo7y04fuAov6oQfEZOzN3gdS3Nog92Ch85oYB25HeGBHoACEbpwmqV/vxLk7bVrqLBpGclj98Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38100700002)(44832011)(52116002)(38350700002)(6486002)(956004)(508600001)(36756003)(2616005)(6512007)(1076003)(66476007)(66556008)(316002)(66946007)(26005)(6506007)(54906003)(186003)(2906002)(86362001)(110136005)(7416002)(4326008)(83380400001)(6666004)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nsJ8q+8dU28oCVwseqxgV3hsfYH4oN9o9nMZuMebiihs/Bwm6o/pPIe549ZH?=
 =?us-ascii?Q?eq2PhcD5oYAqsIVPgWADLSPIPdAg9R3kfFxQ7a52yuWFwh+PA7EBF0yb5mYZ?=
 =?us-ascii?Q?1vfjx5/srLnO4W59keqrtXhhORN+i39Qr+9jfFU7xdED6UwXfgx/fgcK11XD?=
 =?us-ascii?Q?yRMUtizW08NOz03v08s9bGkk1y8xrx20e9KhsCvHE6od+HXt9oDvPnDfwCXx?=
 =?us-ascii?Q?19bDyxJ93LcQ+2KuVlx1+VLgSjMTh9LKitTG8+zNTMe6HhISVJibJ5qHso6v?=
 =?us-ascii?Q?NUOMp/H0QshV+VqIADqklDkGLYvVZYQLOVwHHHZU2OMGJRWga/6GbtKeLMuc?=
 =?us-ascii?Q?aqKIHbBbowzzyf1xkf8pPPC5jGVfMGrmNYphe5VESxPFPFQAoEjEE+kmZOQQ?=
 =?us-ascii?Q?9YFYvvyurSXtS8uaWLr6wv1gAQ7G86GibB6panK3j2C/2epvxbrTXU9GkWPC?=
 =?us-ascii?Q?b1UwXAOoQwt+UncchWeyi+7UMTuyifMbTVY3Z1ij8BBSHzmZDo6ZmIVTrHSj?=
 =?us-ascii?Q?AofATb7qYbN/nfMS0mJfcZvZdxGrr3Evnzz0oB6EJlfXzAGXb4K3K19tyw2t?=
 =?us-ascii?Q?pUMe85UOgRuvQNnqTm9cS7oO1oK515GqtypvuH6nddezt1TS09zuinJI68Lw?=
 =?us-ascii?Q?os2H7WB5U0iAWamXpwv1OYbeQnhWXMxZIGHcjdP5LfZc/d4V+uCgcocpMx3B?=
 =?us-ascii?Q?F8Mv9mtfxsfSnWaXszhLkEVRRp++I8X7NgtlSUzxGpItPHUm6xJSzbB0sCVy?=
 =?us-ascii?Q?XS54tXtfoHSV1YtmvAD0yr6g/ypmvsza1uoHs90KKYV/rFLLxPvPvAcYT4Z/?=
 =?us-ascii?Q?Yec2h5XCBlqNc7S22XDCoQYD3gXq4jjYDVD+Xmp4YFHR8I2saJxcnB1E0vio?=
 =?us-ascii?Q?0RSA+/cThFZqW6L5Ci67SiudeKO3LBs63YbFdy56DCx90NLfZMGcLnIg5KXW?=
 =?us-ascii?Q?JtqxPcKNrwzquAsqdWDgA28c4WnHudRFSmfo1xruvmuRJo7/gUxEZP1gpkra?=
 =?us-ascii?Q?nlAg2BsHsOQtEsxMUcqWPVhR+nenLM81b8y8G++sZ/3WYyYRG+9M5R4u3v56?=
 =?us-ascii?Q?3DkJJ1lVVJJb6QUia1oVyOHr+huZZyyJfDX1melGwatovV0Y/+Hv7DaFztpy?=
 =?us-ascii?Q?Sukm/r8QOXcoTaSHt9915II7+rqdPOh8Gznbl8lV+YF/zYDkpBB3ngo3e+9B?=
 =?us-ascii?Q?AHhtkFkBgMipRJwmhSQMVDj9+lmVFCbgiIn7/1caUWRq+an6nJDx9tR2uwWL?=
 =?us-ascii?Q?61E+mx19DMsw5lhCQFlIyF9+XJdy2h1ov+9Ka2iNIoOsV58XDzfMLzHIlqyk?=
 =?us-ascii?Q?0p2C5t9OZdpJjQpfHyLhRCZT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217d1dfc-980d-4b43-f238-08d94a357bbc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:22.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Na4cL+nsR389OkJtIuyXtK8udp0v6POH07FX4km5hsh4d86uvZnuUa+FxwG5NqLnO6nGYjPNUGLdN/2gMrlAIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
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
v3->v4:
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

