Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B53EBE83
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbhHMXFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:05:21 -0400
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:34243
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235029AbhHMXFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:05:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbfnPnNWhRJ/r+tt+Wx9RaIfqi6SO52HrfcOg846C1Q94mJFVE3vmTi723Lp8hbsiGDZv+r4BRqS0BptfK4P5i9gK3PGo8mr82OV88O6mBnKR5BGqq/vSIwFGETxINMRU+VNdFeibVHykcVNHevpo5gUpeGuv15Do976Znx7fL5Mr44EVbdxvectq2O3/GwCkvikSAEtoZ5vsh18e+vc4yB+khZAkIu17vPd/ZhMmn8ulR5XbXWwJyLPl50Nq6Y4I/qHfD3ivmYtdKSur+6c4fxK4oOEoGd5dyPsL4Euwd0znzsB8o5ywn0od0u2an6IXbaIglxngDrbwczmbW3yOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bn0xJIuCROlzmuqSu4Sz2hqLLICzGlns7qcK51yxSyE=;
 b=lP9TdvmbWuIYQJTS7QAdcLwT8crEs/mbjCF3SWDZGcx3XEf2fljTPKFnPVmHTIfY4Kk74q9+/G4HHwQ/4cq5zuNUDYf126Q7RSzVZ/1NdS9tRcEaBM5G0DIK7gIqStWuzFvbCdzUfDsCDSOoO2FzKzrmM2Vf+q2QJVgivP4vdQaJoBY8U3wArNtk3uisJdSCdpFmPgHmx3GPTHhNbRphLCrUv/ryEz7Ql4fZjhMEg0po/ZTXNmTvhMXcSRiXzIvI5joDzkqhYSyIMOKJwu0GYqJYyFpyF9HlAAv58K/bAG+NEqnOYLIQ26OOF5rz3JATI1Q8JxWLsq5tagPE2MoQ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bn0xJIuCROlzmuqSu4Sz2hqLLICzGlns7qcK51yxSyE=;
 b=kQNUcBubTvEusyLRpk1RCj3K+9qT3KMJKxfGQfy+kUV6Py/zkodmeA/VmEuphk0ESR6eG3/t8NXyZbLq4WOM7DwQpipDQv2hziREtqMTRvkcM7meJZjMj0cOrSUiAI3dQldL70QoRfNvdI1TDgAgqMAjpL5DFCelUQvEByXOpPE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 13 Aug
 2021 23:04:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.021; Fri, 13 Aug 2021
 23:04:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: tag_8021q: fix notifiers broadcast when they shouldn't, and vice versa
Date:   Sat, 14 Aug 2021 02:04:22 +0300
Message-Id: <20210813230422.111175-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0224.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0224.eurprd02.prod.outlook.com (2603:10a6:20b:28f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 23:04:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bed2898-33f4-4caa-45ee-08d95eaec11e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504EDAB9CAACACF3038C51EE0FA9@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOsq7exLdYklxkVf7k7BeABC2t6uKrL12KFA1M3ZV6OZ8qCtcsy6o8LjpRc64dcrVv2X6GBuYnTLdoe1XylwZP8YNAe1rwAVyVAO0OPAlO297Nk8KXW6uXWXDHiBJEW5e9161N2dF9KJJ+z7i20E5BcQaJskfqaa0cV5zVXq01ZAIRNztW8xWsVx3XEGaUaL8jqh2DBquiqdC3HdtHfbEyGR39MmoaHObyCLMLg1Hul3Hxbc0lolZwFcge68d+gokIC1WI6ImC823rSXDXYJ85evM8KTOzDrodIYriS3dKOLdo59XHew2/BwZH0SJhx8AfP2nfW8uMmoR9hixWgQdbPvDhrncmyEDN+mcHs1hjiFAjNdoBff5Qv1X/UAO05qdlmEu0nzajX2IeBvQVz8mEmc8/loD44/NcMC6DfntCO8p+siJkti6BJ329pOmFVMdeGAKSyFVtuZxPZZZimC3aMy9Dwkj1BC9LbXZXSyceGFEsESZd58WQN/gHdp5CXFOPYo67TnLllkw0u/CXN4439zfNWqsFPtV4awgR3/2/4viJxc4F90pSeJ+HEj0UoeiKYKoCxJf2AQPvPEZEPezeu04UEa1V9F0iFJOS7YCAlpTLRGX216pkKhDZLNAF2K4HIgtQaWytBSTTHDUIJU4KZ7gzU8V8aQ14gFLx96tJXTFyu04WSqeVABk59Rczu/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39850400004)(366004)(8676002)(83380400001)(6666004)(1076003)(478600001)(6506007)(36756003)(5660300002)(8936002)(186003)(4326008)(52116002)(38100700002)(44832011)(38350700002)(110136005)(86362001)(66946007)(956004)(66476007)(2906002)(66556008)(316002)(6486002)(2616005)(6512007)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6375MmoFSqVSE879L4YsMYTaYwKEUFfd5k6GsIt8jw7VXV1WDxvo61dYsRq?=
 =?us-ascii?Q?S1PkVdbiH8iRzPjhD4qu3M1UHh+uYxF6nnbfcPtfDxQvY3eDEwMe/TfQCC4H?=
 =?us-ascii?Q?NgMvW3RqvPdykGUTrR7x/jO7nI11xFJRbW1KU+4V++C8WvH9BQDBFOd2BSHD?=
 =?us-ascii?Q?vDAihc4JgsrQihCL41Wlu9LeBWQXDk3eBp616F5wpFji3W7XipCczvE/xYZC?=
 =?us-ascii?Q?7G1IWr9Hq2BElUv7A85EIeTQo5IF7pLKjybbbhbpv+jXWZPF5zTkqr3H2ann?=
 =?us-ascii?Q?pgMakdoRlAOXgZYajFIHD+vECFi8KoyfKhptF9/6xdCV7dXNKCrT8q/KP5yx?=
 =?us-ascii?Q?NKsvTiFUspWPqIde8wX9ZWYBTJqxDOsieSF+VqYxZSxDm+391R5E8gm35Kpi?=
 =?us-ascii?Q?MDUUL1/2i7gSmvOmEVkgOwYdZ4z5EhS3n0ZrCjXkxeR8L4wVKlch5tVLpgyn?=
 =?us-ascii?Q?WTyInnhNKycCSGZksBJm47duwu6F85QExLK0ydcDeFHfrUWCoF2QixxrO5bF?=
 =?us-ascii?Q?m/qIdKCd75AHFz2mkBEOM7jKcXGpYfJqNX75ZcHCqSIZ2FKVMVsmvZQ1gzpj?=
 =?us-ascii?Q?pqQL8OeYA93rAwuhwckiRVdQ4/da8uCjpXoQPOXM0vzVrjsWOxY5VedZOYa4?=
 =?us-ascii?Q?r/z99GaeHu2L7aBR5fyyCPnKvB8sUW0f9F6ftMoryyCdiHaoe2w3mX7Lbl1t?=
 =?us-ascii?Q?caR6NvPgfD8/jiMftpd8u7fNUWBxjq/emPG/ge7j68DywCvjzG26hbsGLLHn?=
 =?us-ascii?Q?uUSh/4+8dMp0DcEEMDoUJlKlYkdvTRGSHk1UJXv6UC3EkfDOi81+mXkQJnpw?=
 =?us-ascii?Q?Np61+Ua937EHVykWM1inSOt8V80xOH4vo/crTlTuhY7mzfQAF5Xuka5STcVL?=
 =?us-ascii?Q?cPOdc6iOpCXjmvkx2tz7HLaxYB8ZbBd4NfFxC+r/OmoUhZETYXpNDLiLp4rm?=
 =?us-ascii?Q?tS+R48lcqBsjtfHh7ssu0JL520Tu8ZgsMmatF9SoqnYFYjNq9oWtVAPf9CjJ?=
 =?us-ascii?Q?LNzVeB60W5NJQD5TOrZvyu/iAfHglXb1H30bbWt9MwfYaVEpnuloBPmdTlBw?=
 =?us-ascii?Q?0Hf/wCq3rkJuSboBaCE+kkqZn71Ep750708mcitJKKFr/pKuLekozxM8HunH?=
 =?us-ascii?Q?ta1GmWVfQ+XCgIH/pFRmsznjrMhHqkkU1co9qkpdz7kQTAs/FMp3Y8/wiDO0?=
 =?us-ascii?Q?PuPUiey9hu3eGF05RF9LxxyRomxSRnhhG9+d8i4I3qpRXCAxvqJvSNwPh03G?=
 =?us-ascii?Q?mxnGm1hkhCf1J52aI2Gmmjb2Fh6pDmxWtAAdOwn+3T6YqKTf5MVMO155QU7c?=
 =?us-ascii?Q?jiXeU9NFk+84FpQM7o43BTue?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bed2898-33f4-4caa-45ee-08d95eaec11e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 23:04:50.8721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EtohcVT9u14+Wgr9n6AclmKWFkVUr2dQ6n/ELGQDEEFqwpzV1sv0l0+zwPI7/hJVbC6AZzCxopxPMqJ0F4SM/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the development of the blamed patch, the "bool broadcast"
argument of dsa_port_tag_8021q_vlan_{add,del} was originally called
"bool local", and the meaning was the exact opposite.

Due to a rookie mistake where the patch was modified at the last minute
without retesting, the instances of dsa_port_tag_8021q_vlan_{add,del}
are called with the wrong values. During setup and teardown, cross-chip
notifiers should not be broadcast to all DSA trees, while during
bridging, they should.

Fixes: 724395f4dc95 ("net: dsa: tag_8021q: don't broadcast during setup/teardown")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index e6d5f3b4fd89..f8f7b7c34e7d 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -362,12 +362,12 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 			continue;
 
 		/* Install the RX VID of the targeted port in our VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid, false);
+		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid, true);
 		if (err)
 			return err;
 
 		/* Install our RX VID into the targeted port's VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid, false);
+		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid, true);
 		if (err)
 			return err;
 	}
@@ -451,7 +451,7 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	 * L2 forwarding rules still take precedence when there are no VLAN
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
-	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid, true);
+	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid, false);
 	if (err) {
 		dev_err(ds->dev,
 			"Failed to apply RX VID %d to port %d: %pe\n",
@@ -463,7 +463,7 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	vlan_vid_add(master, ctx->proto, rx_vid);
 
 	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid, true);
+	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid, false);
 	if (err) {
 		dev_err(ds->dev,
 			"Failed to apply TX VID %d on port %d: %pe\n",
-- 
2.25.1

