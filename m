Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1302B66D931
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbjAQJDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbjAQJBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:39 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B0F301B5;
        Tue, 17 Jan 2023 01:00:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewFLE8bdyEzY4b2Re1GlwC7fituSIyRAfLGRBAhmbSPgHIjaIYJ6HlhtGnRE9zJXOseM6ggB6AKjRVSD0PEbBNbqy90mxa4t1WzV09NbXf0n9PEUIHLaq3gF7ugPNGpDCL6XXxQ66uBpDBkOlGmTZr6OniZ/Kvbgjki2HNkxZ2K9Ycxge9iTHQWgD5iaHQIjkX1MprtQteJuQOJxTeUYDxyCRqCJPTdfB0AaOuVGnKjPl9nkp/xzIf0yPcgAJQaHyRwj0ZSSLE3+4Tw46fabcnumXJTxkLA19PAddDigk0SZagmXtJ/3EJjkAk1S2x8D0C+gW8ynfFwh567oGzaPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMDtLQuOffeccLqPYxopIR24k8NAAQdgQ96Shio/Uaw=;
 b=ZwUtCCM2LBLDnpB5qS1ffqN6yRFCFFcjqyE6rPnyLWzBU9/qVZyRzZqNgT4X2v86Oj20Dwfu8GFoNo8YpE5hiSfMV+IXjb1aVeVpfwd1qOStx0w4EH4PzCMG0TJR3SNAem7x/0liQzqBr5AoHpEUUcwojwN2oJdnNk4F7q/7+6imErctNi6eqD6gCxzoP9J/nqKA3Ato2WqauTMcOda8jLF63Fbb1p59HmaABbQjJWgZLQ/PcUANNoqwuQGQeOAw2nZCkzdB/xxLRNrULufJNUZxa8fKNPO7O00lmfFEJXg2SXSL2mMU2TORt4dz5R1vRzNGysAt4PtviG7V6L5RBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMDtLQuOffeccLqPYxopIR24k8NAAQdgQ96Shio/Uaw=;
 b=R644fVtUfewph7+DNi3yxWhWiRkbP/HH/9baHJ+3MWE5DlKfvMcbBkALmrSqINcYYdGEouK90tKR49HZbN39fCAz5eUnY6wt6cMzajedJimB2BVtGTRI6+Cuzcg+barQcSx3Vv9yaAJeYz+LVr7ZFkCtYc3ZUJN21Zuh9nMmzmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9304.eurprd04.prod.outlook.com (2603:10a6:102:2b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 09:00:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 net-next 04/12] net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)
Date:   Tue, 17 Jan 2023 10:59:39 +0200
Message-Id: <20230117085947.2176464-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9304:EE_
X-MS-Office365-Filtering-Correlation-Id: 171dc6c6-1093-463a-1999-08daf86939cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yx3wecUg1P4fdXOUMPp0WLKPZ8meatW452Y1kcB4ueREBnLzd/TCY5w+8+uSVvj8dfQWbcfqnG43XhF+3fkYLljCUGpZrTDPeIja1g8Cu/8OQUpAk29Kbw98gj47cg+8XKoqZgj8BVZZ78KcuoRNs83UWedgVFs4+m6e9WrhepBTVyHv780ML6Vv6LRh7rb1woxc6wyPJw8eTVhTGo8lO2Ak9jRkGV4hP+iZGEbADTmeoCAEo1NC1EUn5BSI+d+xilMfh5CgKX0Un2mBegwkR1HVimtKC7x5KA+KuB35tjLKTf9NgUC/+W3avQnVKC9EbNQbiyB0nn0CW+kZKzwhkVX+Ra/ZlTaTFkInjrt7OHUriBg3c0lREUcz25LrmQxTNsbIl326lHJRxNLhW0cNErXYD2PxzyHNcK5eA95fHGbPLo6OcSgOxZBsuSOaKXPDOHTxYOQon0JCZLQyuJv+fCJLwTKxRcskgAnw9fTMEwD+tqoF497lyQdElZmW4zqRraZnsXfv9b5iWY8oVOSqLdXl+Pb2gvqiNx0hQHXnUBGwNn7HK2PWhyInWuGiHXdcrTOjdIFRUp6dII4xzjChbMM53y1G6jlyS0buwsdGXRbaIopYxXT4CJSkH8BXd0GtjmQLVykcTnnxiNrhcHsPKx7t7c0QvEjlsxx++qfP8dg8zb1UJUHcpAPNj0IR3OYNk/vvtIBh9BxCWO5atjH7ci+TuHmN9o3uPejS5fYPOgXzi2a7xx3g8JXqcuvUWsjc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(6486002)(6512007)(478600001)(186003)(26005)(6666004)(52116002)(6506007)(66556008)(2616005)(66946007)(66476007)(316002)(54906003)(8676002)(6916009)(4326008)(36756003)(83380400001)(41300700001)(8936002)(44832011)(1076003)(2906002)(30864003)(7416002)(38350700002)(38100700002)(5660300002)(86362001)(309714004)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EHGN278sfhuRj3i3Rj0hdpcvLQsaYAPSPuZZ7xfBdWX0RcnN7khEJtXXueeo?=
 =?us-ascii?Q?2bECtVHtzZ1oY//F+nbjwEUf+zPGRjjs8HPYiJwpRheUp+oRjLfKHJQWSrlw?=
 =?us-ascii?Q?6jePGBjjq0jDqjMGuuVq3QLJ3OfGwTUF/P9gXSlKECEhe/VytU4zpyjc/rFS?=
 =?us-ascii?Q?fyVxg3AZicq04HAwREOPSbXVuKCugAouJU3xxmN4I3TyYYk5Xlaufa0TmKZG?=
 =?us-ascii?Q?apkkBCRz7wVOu9PPagcn0YPDN32DXp24rvqLHsaaiqIExvtT62a5HD7zl8pF?=
 =?us-ascii?Q?ewOwwGqmIuroQ6Cpm3nN9jECJTCi8nJbreT9fO7S7vlfOcEZCH/iRFnaQDAe?=
 =?us-ascii?Q?+k/2ZGMqn5QEP+qIruSTl8DIQ/boOv9/5C6Lm3ccVmtBLsiY5AYB5rJL0Ih9?=
 =?us-ascii?Q?sZreKIym1gK2Rydu+hdzTAIXL//34OrS6VWMR9/oyoCJsnZ/UgAhK+1M0lsw?=
 =?us-ascii?Q?JJRDTmf6ujQifSWxKhGGt6szeZdj3amdtI0plEIOO07zSo06/ZQpx86YtW+9?=
 =?us-ascii?Q?ujFNjCDlpvrFarfQ9GLpztZhpvgredN4GUpGs5d9QnYWzWMrdvuVMr1WiEVC?=
 =?us-ascii?Q?F2Yw8sbrsddcZ3ZqT/mK4WoPH/LOwIPzkttIMihp+e0nA7sAjL4YolH4oxRY?=
 =?us-ascii?Q?+KT1Ax2eWYs7+RZwumRwoxRwEZ6CJvZHobAsXBwSBgvgsNZ4fQnVRNPeSf9l?=
 =?us-ascii?Q?IhiFhHpxAamdIlhaZgEyWxlAUPJwS1CtS4Q0NMqAB7bOpO6Dbnbg+Rt+coqE?=
 =?us-ascii?Q?snG5M0nORRf/oqdVSkusbh4cdOTkGb2kAPo5pMYp0JIvoYhxMAvY4oefE1fA?=
 =?us-ascii?Q?VoHEfHbcknOQBPi/AKQdTXtxl8JbMxoEYrqpjjkz0RHwkszAW75VKfmGM5aO?=
 =?us-ascii?Q?UHZkdj/AoE8H4u/iY2hOW6X+Ho5OJF26fV0GjUr4WQxOT31PG6M7qi/ZQ46T?=
 =?us-ascii?Q?QmzSoWxql1ZVfkO1IOokx3hUIU9futd7K6mmYXMPOtXxT4MtS35vNcCWe0RR?=
 =?us-ascii?Q?PYybsJJQqDyahq7haRgteygbj5UmDWkDsAbwcZ9vKlltqOIr/1srL+FMGPgE?=
 =?us-ascii?Q?OeqcxPLXfEeJw+LCCaVjuVICkJJJQcg8+wV8tqsAs0E/gH330EWzcUx9obaS?=
 =?us-ascii?Q?lxuKj2O4GOQmdvoMfoSfsRImawxbqR7HOXs7vmPuHU7SF6XnYyQwGY4hznjz?=
 =?us-ascii?Q?7LZDXHK8xY7FiKIJu3k2aPgHvp0nIXRTDoPCayzO6puB/eyi461qVP0qiyV/?=
 =?us-ascii?Q?0G5Sx/s2Vy/jbTeaLaS4wNAH0qsog3L1Y8sZh0HKS00Ff58UofYjQsOWSU+o?=
 =?us-ascii?Q?B9hr2XpjM7SyB4RGxhETKm+rB/tUDhU8qxiwvYs/cY/5kMprImfyPTKtB0pB?=
 =?us-ascii?Q?dXjrCH73o4P5omdo4HBQ1LoHAqK82Q+X/F7cpAq7yFREubJ33Ax3Lf+NbJ3t?=
 =?us-ascii?Q?3pOw/SH1plb9LkChkbwgKSPLvZ0uhnhllWslVanlEyZAaR2rDtc/g8zCgjwM?=
 =?us-ascii?Q?2364FFBx8d3m+isfnNpiMvk2Vmpj7lPrLZzAMhNxze4/brgUrpiZ5MNC8SvG?=
 =?us-ascii?Q?KjCDEA30qYE78JFVXEwseA7TWHoDnWwXcRckf/K3FEL6gS3UVzcZIzW/9ho3?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171dc6c6-1093-463a-1999-08daf86939cc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:05.4090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Te/9koRfNgjPi8nJBrAGX/hN0Xr7yFYzMuXFwK6epMItlgBRvfW2+agMF1jTNsterbDvce4go4LH0kp0FPpx3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.3-2018 clause 99 defines a MAC Merge sublayer which contains an
Express MAC and a Preemptable MAC. Both MACs are hidden to higher and
lower layers and visible as a single MAC (packet classification to eMAC
or pMAC on TX is done based on priority; classification on RX is done
based on SFD).

For devices which support a MAC Merge sublayer, it is desirable to
retrieve individual packet counters from the eMAC and the pMAC, as well
as aggregate statistics (their sum).

Introduce a new ETHTOOL_A_STATS_SRC attribute which is part of the
policy of ETHTOOL_MSG_STATS_GET and, and an ETHTOOL_A_PAUSE_STATS_SRC
which is part of the policy of ETHTOOL_MSG_PAUSE_GET (accepted when
ETHTOOL_FLAG_STATS is set in the common ethtool header). Both of these
take values from enum ethtool_mac_stats_src, defaulting to "aggregate"
in the absence of the attribute.

Existing drivers do not need to pay attention to this enum which was
added to all driver-facing structures, just the ones which report the
MAC merge layer as supported.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- rename enum ethtool_stats_src to enum ethtool_mac_stats_src
- rename ETHTOOL_STATS_SRC_* to ETHTOOL_MAC_STATS_SRC_*
- change how __ethtool_dev_mm_supported() is implemented
v1->v2: patch is new (Jakub's suggestion)

 include/linux/ethtool.h              |  9 ++++++
 include/uapi/linux/ethtool.h         | 18 +++++++++++
 include/uapi/linux/ethtool_netlink.h |  3 ++
 net/ethtool/common.h                 |  2 ++
 net/ethtool/mm.c                     | 16 ++++++++++
 net/ethtool/netlink.h                |  4 +--
 net/ethtool/pause.c                  | 48 ++++++++++++++++++++++++++++
 net/ethtool/stats.c                  | 32 ++++++++++++++++++-
 8 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 37eba38da502..0ccba6612190 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -311,6 +311,7 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
  * via a more targeted API.
  */
 struct ethtool_eth_mac_stats {
+	enum ethtool_mac_stats_src src;
 	u64 FramesTransmittedOK;
 	u64 SingleCollisionFrames;
 	u64 MultipleCollisionFrames;
@@ -339,6 +340,7 @@ struct ethtool_eth_mac_stats {
  * via a more targeted API.
  */
 struct ethtool_eth_phy_stats {
+	enum ethtool_mac_stats_src src;
 	u64 SymbolErrorDuringCarrier;
 };
 
@@ -346,6 +348,7 @@ struct ethtool_eth_phy_stats {
  * via a more targeted API.
  */
 struct ethtool_eth_ctrl_stats {
+	enum ethtool_mac_stats_src src;
 	u64 MACControlFramesTransmitted;
 	u64 MACControlFramesReceived;
 	u64 UnsupportedOpcodesReceived;
@@ -353,6 +356,8 @@ struct ethtool_eth_ctrl_stats {
 
 /**
  * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
+ * @src: input field denoting whether stats should be queried from the eMAC or
+ *	pMAC (if the MM layer is supported). To be ignored otherwise.
  * @tx_pause_frames: transmitted pause frame count. Reported to user space
  *	as %ETHTOOL_A_PAUSE_STAT_TX_FRAMES.
  *
@@ -366,6 +371,7 @@ struct ethtool_eth_ctrl_stats {
  *	from the standard.
  */
 struct ethtool_pause_stats {
+	enum ethtool_mac_stats_src src;
 	u64 tx_pause_frames;
 	u64 rx_pause_frames;
 };
@@ -417,6 +423,8 @@ struct ethtool_rmon_hist_range {
 
 /**
  * struct ethtool_rmon_stats - selected RMON (RFC 2819) statistics
+ * @src: input field denoting whether stats should be queried from the eMAC or
+ *	pMAC (if the MM layer is supported). To be ignored otherwise.
  * @undersize_pkts: Equivalent to `etherStatsUndersizePkts` from the RFC.
  * @oversize_pkts: Equivalent to `etherStatsOversizePkts` from the RFC.
  * @fragments: Equivalent to `etherStatsFragments` from the RFC.
@@ -432,6 +440,7 @@ struct ethtool_rmon_hist_range {
  * ranges is left to the driver.
  */
 struct ethtool_rmon_stats {
+	enum ethtool_mac_stats_src src;
 	u64 undersize_pkts;
 	u64 oversize_pkts;
 	u64 fragments;
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 529a93696ab6..f7fba0dc87e5 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -711,6 +711,24 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_mac_stats_src - source of ethtool MAC statistics
+ * @ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+ *	if device supports a MAC merge layer, this retrieves the aggregate
+ *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
+ *	statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_EMAC:
+ *	if device supports a MM layer, this retrieves the eMAC statistics.
+ *	Otherwise, it retrieves the statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_PMAC:
+ *	if device supports a MM layer, this retrieves the pMAC statistics.
+ */
+enum ethtool_mac_stats_src {
+	ETHTOOL_MAC_STATS_SRC_AGGREGATE,
+	ETHTOOL_MAC_STATS_SRC_EMAC,
+	ETHTOOL_MAC_STATS_SRC_PMAC,
+};
+
 /**
  * enum ethtool_module_power_mode_policy - plug-in module power mode policy
  * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 58af390823b0..ffb073c0dbb4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -428,6 +428,7 @@ enum {
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
 	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
+	ETHTOOL_A_PAUSE_STATS_SRC,			/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
@@ -744,6 +745,8 @@ enum {
 
 	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
 
+	ETHTOOL_A_STATS_SRC,			/* u32 */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_CNT,
 	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index b1b9db810eca..28b8aaaf9bcb 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -54,4 +54,6 @@ int ethtool_get_module_info_call(struct net_device *dev,
 int ethtool_get_module_eeprom_call(struct net_device *dev,
 				   struct ethtool_eeprom *ee, u8 *data);
 
+bool __ethtool_dev_mm_supported(struct net_device *dev);
+
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index 0c8135393c14..7ebc4e82e83d 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -253,3 +253,19 @@ int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
 	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
+
+/* Returns whether a given device supports the MAC merge layer
+ * (has an eMAC and a pMAC). Must be called under rtnl_lock() and
+ * ethnl_ops_begin().
+ */
+bool __ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_mm_state state = {};
+	int ret = -EOPNOTSUPP;
+
+	if (ops && ops->get_mm)
+		ret = ops->get_mm(dev, &state);
+
+	return !!ret;
+}
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 60278485b00b..29aef39476eb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -399,7 +399,7 @@ extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEAD
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
 extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
-extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
+extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_STATS_SRC + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
 extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_TX_LPI_TIMER + 1];
@@ -410,7 +410,7 @@ extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INF
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
-extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
+extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_SRC + 1];
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index a8c113d244db..e2be9e89c9d9 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -5,8 +5,12 @@
 
 struct pause_req_info {
 	struct ethnl_req_info		base;
+	enum ethtool_mac_stats_src	src;
 };
 
+#define PAUSE_REQINFO(__req_base) \
+	container_of(__req_base, struct pause_req_info, base)
+
 struct pause_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_pauseparam	pauseparam;
@@ -19,13 +23,40 @@ struct pause_reply_data {
 const struct nla_policy ethnl_pause_get_policy[] = {
 	[ETHTOOL_A_PAUSE_HEADER]		=
 		NLA_POLICY_NESTED(ethnl_header_policy_stats),
+	[ETHTOOL_A_PAUSE_STATS_SRC]		=
+		NLA_POLICY_MAX(NLA_U32, ETHTOOL_MAC_STATS_SRC_PMAC),
 };
 
+static int pause_parse_request(struct ethnl_req_info *req_base,
+			       struct nlattr **tb,
+			       struct netlink_ext_ack *extack)
+{
+	enum ethtool_mac_stats_src src = ETHTOOL_MAC_STATS_SRC_AGGREGATE;
+	struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
+
+	if (tb[ETHTOOL_A_PAUSE_STATS_SRC]) {
+		if (!(req_base->flags & ETHTOOL_FLAG_STATS)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "ETHTOOL_FLAG_STATS must be set when requesting a source of stats");
+			return -EINVAL;
+		}
+
+		src = nla_get_u32(tb[ETHTOOL_A_PAUSE_STATS_SRC]);
+	}
+
+	req_info->src = src;
+
+	return 0;
+}
+
 static int pause_prepare_data(const struct ethnl_req_info *req_base,
 			      struct ethnl_reply_data *reply_base,
 			      struct genl_info *info)
 {
+	const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
 	struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
+	enum ethtool_mac_stats_src src = req_info->src;
+	struct netlink_ext_ack *extack = info->extack;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -34,14 +65,26 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 
 	ethtool_stats_init((u64 *)&data->pausestat,
 			   sizeof(data->pausestat) / 8);
+	data->pausestat.src = src;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
+
+	if ((src == ETHTOOL_MAC_STATS_SRC_EMAC ||
+	     src == ETHTOOL_MAC_STATS_SRC_PMAC) &&
+	    !__ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not support MAC merge layer");
+		ethnl_ops_complete(dev);
+		return -EOPNOTSUPP;
+	}
+
 	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
 	if (req_base->flags & ETHTOOL_FLAG_STATS &&
 	    dev->ethtool_ops->get_pause_stats)
 		dev->ethtool_ops->get_pause_stats(dev, &data->pausestat);
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -56,6 +99,7 @@ static int pause_reply_size(const struct ethnl_req_info *req_base,
 
 	if (req_base->flags & ETHTOOL_FLAG_STATS)
 		n += nla_total_size(0) +	/* _PAUSE_STATS */
+		     nla_total_size(sizeof(u32)) + /* _PAUSE_STATS_SRC */
 		     nla_total_size_64bit(sizeof(u64)) * ETHTOOL_PAUSE_STAT_CNT;
 	return n;
 }
@@ -77,6 +121,9 @@ static int pause_put_stats(struct sk_buff *skb,
 	const u16 pad = ETHTOOL_A_PAUSE_STAT_PAD;
 	struct nlattr *nest;
 
+	if (nla_put_u32(skb, ETHTOOL_A_PAUSE_STATS_SRC, pause_stats->src))
+		return -EMSGSIZE;
+
 	nest = nla_nest_start(skb, ETHTOOL_A_PAUSE_STATS);
 	if (!nest)
 		return -EMSGSIZE;
@@ -121,6 +168,7 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.req_info_size		= sizeof(struct pause_req_info),
 	.reply_data_size	= sizeof(struct pause_reply_data),
 
+	.parse_request		= pause_parse_request,
 	.prepare_data		= pause_prepare_data,
 	.reply_size		= pause_reply_size,
 	.fill_reply		= pause_fill_reply,
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index a20e0a24ff61..26a70320e01d 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -7,6 +7,7 @@
 struct stats_req_info {
 	struct ethnl_req_info		base;
 	DECLARE_BITMAP(stat_mask, __ETHTOOL_STATS_CNT);
+	enum ethtool_mac_stats_src	src;
 };
 
 #define STATS_REQINFO(__req_base) \
@@ -75,16 +76,19 @@ const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_A_STATS_RMON_JABBER]		= "etherStatsJabbers",
 };
 
-const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
+const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_SRC + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STATS_GROUPS]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STATS_SRC]		=
+		NLA_POLICY_MAX(NLA_U32, ETHTOOL_MAC_STATS_SRC_PMAC),
 };
 
 static int stats_parse_request(struct ethnl_req_info *req_base,
 			       struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
 {
+	enum ethtool_mac_stats_src src = ETHTOOL_MAC_STATS_SRC_AGGREGATE;
 	struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	bool mod = false;
 	int err;
@@ -100,6 +104,11 @@ static int stats_parse_request(struct ethnl_req_info *req_base,
 		return -EINVAL;
 	}
 
+	if (tb[ETHTOOL_A_STATS_SRC])
+		src = nla_get_u32(tb[ETHTOOL_A_STATS_SRC]);
+
+	req_info->src = src;
+
 	return 0;
 }
 
@@ -109,6 +118,8 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 {
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	struct stats_reply_data *data = STATS_REPDATA(reply_base);
+	enum ethtool_mac_stats_src src = req_info->src;
+	struct netlink_ext_ack *extack = info->extack;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -116,11 +127,25 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
+	if ((src == ETHTOOL_MAC_STATS_SRC_EMAC ||
+	     src == ETHTOOL_MAC_STATS_SRC_PMAC) &&
+	    !__ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not support MAC merge layer");
+		ethnl_ops_complete(dev);
+		return -EOPNOTSUPP;
+	}
+
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
 	 */
 	memset(&data->stats, 0xff, sizeof(data->stats));
 
+	data->phy_stats.src = src;
+	data->mac_stats.src = src;
+	data->ctrl_stats.src = src;
+	data->rmon_stats.src = src;
+
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
 		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
@@ -146,6 +171,8 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 	unsigned int n_grps = 0, n_stats = 0;
 	int len = 0;
 
+	len += nla_total_size(sizeof(u32)); /* _STATS_SRC */
+
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask)) {
 		n_stats += sizeof(struct ethtool_eth_phy_stats) / sizeof(u64);
 		n_grps++;
@@ -379,6 +406,9 @@ static int stats_fill_reply(struct sk_buff *skb,
 	const struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	int ret = 0;
 
+	if (nla_put_u32(skb, ETHTOOL_A_STATS_SRC, req_info->src))
+		return -EMSGSIZE;
+
 	if (!ret && test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask))
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_PHY,
 				      ETH_SS_STATS_ETH_PHY,
-- 
2.34.1

