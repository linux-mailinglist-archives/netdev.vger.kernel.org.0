Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6704742A37C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhJLLnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:17 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:6350
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236289AbhJLLnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5IRNukyEJskQLbWx7UsTmm5Y+SUM9z4yg6+N0LMrmbx3TMzxStHE0ONx5t9J7MSbLx1TF6/LX8k/FDkMvBkeHgOLSMbUCfkiJk4Nd4cq8A6rMuEY2z8BbgG6w6V1ELV5Mg+swbv/aMv9rc2k0LXIqp/d6jLnzW91Dn0oPueW8w649JLYdiXbG+6Y5gq2O1D06Z5k/2fue52+237ALEIOmgbvwY10kTt4XItRD0jO/VrGPRlHzoYJzqn90otj6vVEGKvIjrSe4aZxdz+r45yKwztcG/wbRVNJfz95DDTbAh7eVAqutT/VrOUX/1sTSN00fGKfHA1WOIJgRsw/alz7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yW1bfuUatZLNdn3xqiZ+L2/sgRaxmRQim9ptxJfD4Ms=;
 b=GFkdgJZ8ap2GHh9I0WvRzVx3U9Nf3Li6ki0sIb3Y6zWTOXHnGxYtKjzczthBGEm0ht2yyoRQRvX949SSbTc2dMx8mhtApOdki9eV2xZX+GdK+hS9vF4DxYn2SIjHfSJjlc3IRv5/rNEWo3+YDWIvHLC7rvtNPFcP15kI2OdfjBUZ6zU4bHs8dYn0+099SbNwEmXeIJIYXC/q6gAWQxhSKUHWVhjB0YsEqIxFb7lfyiHB8iRWW6KiDzoqsWo5e3jIeEYNyY2jrPCZR2eHcfHA/4scLHwAwa+HaJJyMZW5tyLXfjj3Hjtm7yGS7/UKjetlT5WVGiNugYXpMiLbNM3VLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yW1bfuUatZLNdn3xqiZ+L2/sgRaxmRQim9ptxJfD4Ms=;
 b=ey3WGnx5bdN89RZEF1LrocQLL85ahO0z+yALKsLm3HuwnYBCnK7Vgfd/soBz0pHQscaHEE/SQ7FnHhNlwbvr4DuQyGLZGTQSufZFBkRPJlztS5Cdk3gDQQDbGWSB1LIGdztrj/+cb9jTADNS+PcRu6yPCiA2acQmVry7Anv9570=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:41:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:41:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 09/10] net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs into BLOCKING ports
Date:   Tue, 12 Oct 2021 14:40:43 +0300
Message-Id: <20211012114044.2526146-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:41:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1688596-fe96-4368-c1e9-08d98d752be8
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941E78740EF06FD201B2B2DE0B69@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgIC1i+TnBilDOeZSIsxrO/xnleclxBNAdNvNIUYud4barH/5F6KuTTpjmBXAcgQB45c503KT31I5KK17wVFhYWENtxEMBybraaBvraBxY1BjX4Svszdrho3JLJ2jldhd65yrS2fwQ3GPQv9luglKF4GYgNvwCYr/GBqxgbFCVeaqwTomfstJ6LVsevt+MiT6QbFQCXzzGc3fyH/HtVdNNBdhCL5ELBtks+w35GL/RmOROlabFimdr/7923tzHGwVnfQ7uvTIc6rUgdn4VYGcemvP3TLtzeEx2h1iP3YhVP+PkIVa9WGP0bQ/G/Hf331+MJ9APE4N8it0eOQ1RS4T0ArTSZArMvphM8uGxuP9sSWa2sqpn2HL/bwun4QhQOrv/2xZ1jFJlhx0IysTb583kte8oNYMe2NfcnitB4IuzQBNLaDneUTziUTy2J4CLbJdXo/l4VJMzPrdij/hmFTPB9wlaLcqnle4ymvetmd9YCemWx+cmnPeQzZBvVOgaWzfs+aw4XDPmuo5iAwdK59Fokl/UQGNC9aJwxEvbjv8Od6s/5jhtSw4OuzDB0GQ09b8inUQuXTrgzvdEkhoqyOC/xKbx6VYio6YyAhj8sYFiDkYVh2ChnEoo0I5//xl80VghjR8foCdGrn93/5+ObrCDpsmXUOG9UP5LN/DeL1wS+Ufj1FvWQfZSNMmKpQuyjSioW8TAAAHzU4AiBhTolOvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(44832011)(508600001)(110136005)(6636002)(2906002)(66556008)(66476007)(54906003)(52116002)(6512007)(4326008)(316002)(2616005)(956004)(26005)(186003)(38350700002)(6506007)(7416002)(66946007)(8936002)(6666004)(83380400001)(6486002)(86362001)(36756003)(1076003)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jKVSUxyIZndH7ndaanc+WE5CuXQ0pZmwtWPrzgL5atLP5QM1EM1P4PNdUQ2Y?=
 =?us-ascii?Q?bM7O5YhgQ3QxgK5GBw+qQrmV6mVaZTH/Iw0cgljt+GPG9h29eosnCY7FYeHe?=
 =?us-ascii?Q?CzQ3uBtGpw9fL6PFpqG+QUsSiE8JSAshMjXMft5t7cjb1aaCFTmu/6YBu4bo?=
 =?us-ascii?Q?Ar+fGZ6DvTOHnvQ1dtfE+Sza/qHmhE8hVPYiW6Ivh2neBDzOOyq53NmBY1d3?=
 =?us-ascii?Q?cnvXmUOHEarHXq8Fyrn20WFmiH3bNGMLk4YC11mIk+U1QR0p2g0lK20fNAcc?=
 =?us-ascii?Q?LEua3S/yZ17wFhF4s51F9ux5IyIgYK43pL/Xo5ht9S9Go5KKaErUsRDUovW8?=
 =?us-ascii?Q?qSDgy5cW/RgmMrS9PN1PabAJtp029FhJ01ndIZVmi4s+d3Fl4luS16qnWps+?=
 =?us-ascii?Q?aN8pTpDKSAfUOxeuf8ZuLknBKr2/Ne58mkE1SV6+7ph/AReORLiltbX4CiGg?=
 =?us-ascii?Q?JpGCVcW3wK2UxJ6daHh11JJ55gTamk8cpEQ0Vfa+p92cu7UheNWHbtT3fCLS?=
 =?us-ascii?Q?rDYAQE+wlf26guNJhdDY5l63Ln4ZyYm0pdE1czG3wqrwRJEPAaheFtmVFhfM?=
 =?us-ascii?Q?6UlJfgEhwwcENsTL/Bwt3kzqcn7pyiTkOots0/dxI82I/Gq2UavI2VGOYZzU?=
 =?us-ascii?Q?/9FaaJr9L5C57YqGOfDjwDjGoacCKU+cyxUKQyAPQeu7wYYTUKVZ2H1/P9Er?=
 =?us-ascii?Q?N0y3g2Ce0yj0ChW0HMOATtDHVuATp0NFudAhyjWS70MjjoNXHU0E3zuqXPUt?=
 =?us-ascii?Q?EHI/VoMfXDwPpb5QEPqUDH/i6Xyjm+hv/LAEEb7sxz/HuS5MRgHxrcRjfJtV?=
 =?us-ascii?Q?Lu0e8+wyluGlX6nUF2ZzlDxyqCR7Vqyqso21cPb8xK9zZ6kNhHNpqdy9M7M6?=
 =?us-ascii?Q?bZL27vg0MqQlmPcwTjhPX7rYpD1iFqweQQHFJ4kB6AvNg81MFsjmHYWkUxmo?=
 =?us-ascii?Q?h8xB7jBW0pY4zoKGS4yT37L06QcHjpgaq8jGn2fRrKaSNh0PTXGCrV1fKFTB?=
 =?us-ascii?Q?GVU09HsFSWG9AwaJs8FPL4rERkbLA8jMZKphm0Od1L+gMKzpoo6pZy+9pGGe?=
 =?us-ascii?Q?k4o8zN6VKx9G8LvhZ34CGwkcUj6wkeYLjf3g5rd6C7C7aEwxfAwq8IuapRo4?=
 =?us-ascii?Q?p0aR3swRw1f1/Vbd4yZcwWOZ5OHZw7qEgmwrhhlsfe+1mqj1GD81wiLJspzt?=
 =?us-ascii?Q?17EyRr8KBmrGtW+w7z1sF/LPbtGE59BfRnJuZO/mGxW4uNR3hSw02soi0R05?=
 =?us-ascii?Q?HsD4Bn4SwKPg6dhFS09ORRi3KaUubjg7V2V1NqwMtnYwvUnOvc4EoGzuz8ON?=
 =?us-ascii?Q?cvrfqShJ+OL40aPXSYz/gOZv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1688596-fe96-4368-c1e9-08d98d752be8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:41:03.8589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+SBGt7xTQDQOoPIhBM6xZF56EdMX+pEsXTaocgxOfsrGAQV2IwhYcEvSRc/70C+4WN4pce67pnEBIz3A31Xdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up a bridge with stp_state 1, topology changes are not
detected and loops are not blocked. This is because the standard way of
transmitting a packet, based on VLAN IDs redirected by VCAP IS2 to the
right egress port, does not override the port STP state (in the case of
Ocelot switches, that's really the PGID_SRC masks).

To force a packet to be injected into a port that's BLOCKING, we must
send it as a control packet, which means in the case of this tagger to
send it using the manual register injection method. We already do this
for PTP frames, extend the logic to apply to any link-local MAC DA.

Fixes: 7c83a7c539ab ("net: dsa: add a second tagger for Ocelot switches based on tag_8021q")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/dsa/tag_ocelot_8021q.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index d05c352f96e5..3412051981d7 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -42,8 +42,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct ethhdr *hdr = eth_hdr(skb);
 
-	if (ocelot_ptp_rew_op(skb))
+	if (ocelot_ptp_rew_op(skb) || is_link_local_ether_addr(hdr->h_dest))
 		return ocelot_defer_xmit(dp, skb);
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
-- 
2.25.1

