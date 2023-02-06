Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B255268B8E5
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjBFJpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjBFJpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:45:49 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2077.outbound.protection.outlook.com [40.107.7.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF671F747
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:45:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcig1brQ8k+JNLCEx9BABVCuUR0nE/jJVOaF056IGl4cmlXjO+Xa7hYK1EpuJwFbNJ3liQGE7tgZ/e3Kc/GOiDLK490CS383EcvJZITr4JJSsieRqikrRDJFX+6/vKFvP0oEtMNjrHFFJUeRDzKj3gcCDXUcWf8Yq4K4CMDKStTeKfLiKyTmP6aDLT7QEFNN8nyq95J3CT+q6IUgbXbAbFjR7RlZSetNkSO1AO7bDgiit1s03M/B3Lxid882qRZEKl/AJWlKN0uGzFq47RoLR9uEhWLSZGwMEtzYES0CYsRVrDzvz0V1W02ED6uTVoQeg1Fo+PIAB7TWqDyliahMmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AZCelMueYw5TRT8DS2JVlWshlM2uHc3Iv0vx4/onaY=;
 b=M6is3yD5xV3yaquCShUaG0B2rBlVO+X9CB11xUBcZb7zJ2dp0D3M1Fu8tVWfAigy/jPo7enKdPovVQzfoUBTSinfc6Dm9+vU6sydY1VyuRiZa50EekFXTGAN2f24BsKDPkIeiq/K6i38CmHWGKvyUe2SA7lDEtZBxHUkCRGfEB8SjcRrJDoMtfErzbTCmyHdF/mPfqrhaKzriECm8Li3MnrRlkSlUuuh3+EU182vMIJdrVvhfmzx7iPIraD1gpw9KRNkyF2Ubswc8ndbHn54/zSGRQrn/iNWubv4QW9ChwvJwpAvetr4mRP3lv1iL/NteKd+Y1ngi7R2aDN7OsPY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AZCelMueYw5TRT8DS2JVlWshlM2uHc3Iv0vx4/onaY=;
 b=s7xtqUsPbXdRyTaitd/4n+MKbd23P7jk9TcQrRKb5ajbOrtcK7vUX+s38dv6Od4Gc9JJDEwcgRtuR10vMLG1mYm+umqHGTAR1pVxiCV5j3KVoDuu4SAeD9Zmo+v5loYN4C5ntsxuV7aL5fzbKQqToQyM/4LY3k8trPrfSF50xpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8108.eurprd04.prod.outlook.com (2603:10a6:10:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 09:45:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 09:45:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH v2 net-next 2/2] net: enetc: add support for MAC Merge statistics counters
Date:   Mon,  6 Feb 2023 11:45:31 +0200
Message-Id: <20230206094531.444988-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206094531.444988-1-vladimir.oltean@nxp.com>
References: <20230206094531.444988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a867dc7-44db-4045-084d-08db0826e9c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixLndtlZVnepoRNbXcyWKteC4B3LBJD/IuhFWEgdiLHtChC+rLh8TMhBRWxLUNU7YhQnVhPp5fgTrZWLvHHah7rNCSQo6QgbhckRstcq0MeyshpokU0TKmEqib7GWnAxzv9sHG0VLEl0R4KdARNiPJhSpO2maBdCF/6nroNOt914YCl7ZdryvX1XgtLHQ52rl0rrTYHqpT0YAIfq90hfURgFVxq7LZMEMz6KIH9Mh6BZfB6zFZ2E49BVw3+Fx6D6sYp/z1NZOScgFGZ7emTNfJgFAqOR5YQDh60aJmJqm/urvV4/+OlDKZrdnF1fbEpc9TavryzwwnP0qf9SFZ21RV0/je5Y74FayaHoMlQI82dS235FQPpyb++zuK1OBos/hx3wGKqbhaqs9lyEhAJdbJr26vh6UgtaAPRPT6C1CMAXw+FhzwbcB5XTvr7/MkMAW+cdlXELSrvyfgeCZt6BzB9LRNiixV64gX4td2BHNuGlKut7Ut9LAwesrhxqoHLDV08u9eCHBFy8swJZor91DZ191Y1xZNvUBO7RGb64ObrfDB6zxnm6Nhc9xYeKZFk2dCEw0YMSwsrA+Gss942LSSBIjUba5KWxBHLjYrULUuWIMOjLZ+LR0bJkk+8s7qH3GAXuMWoH8s2YYHGl73dB+CAMQWJagXPlDuofDTk+RGJjyaKsI9jfx6QWCYoHkpLGUIXMLDe+bVkLCMY96xU2Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(66476007)(6666004)(1076003)(6486002)(2616005)(478600001)(6506007)(8676002)(26005)(6512007)(186003)(4326008)(66556008)(66946007)(6916009)(316002)(52116002)(38350700002)(86362001)(36756003)(54906003)(38100700002)(83380400001)(5660300002)(44832011)(8936002)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Ql38k0uBCT5SrP0DV7CX1Yp+N3i/0R4JdU7G3dQ3CA5SvfEQ/alg4vqISxr?=
 =?us-ascii?Q?Qz7+RM09Xx/oWn7S4HLB3IudbQqLsXE6sHrSp1J1p/78cYOPsaQeB7AbLrvJ?=
 =?us-ascii?Q?P9gBGI91P/DjWeB+X+NtktAXQ3myVsr/Iw4yiVQPktPkgGxqbkeLZyHXkwOE?=
 =?us-ascii?Q?UHtrz3HeGfxMW64UIXY7KgX31VM1PGLO70KLMSQhEp0bM5BWpU+knZPQkMHm?=
 =?us-ascii?Q?QPiE/lHKGKlDFmaR0v8hPsd9Y+Qx1ToR6JzXhASIHly0yqwN48vtNPDuWeW2?=
 =?us-ascii?Q?kmaD43dipoK2k6oTPwVqEFKwqhu0bIORjlPJ9PTlZdgI275lHPOiJSxsi7OB?=
 =?us-ascii?Q?yIdNryzTYtABRKURUAYFwdhWeXeJV6eAUwruQ6jQV3DwYtO0QBaymHV/zDfM?=
 =?us-ascii?Q?7IC0SAGmjEmsei02Q/GSwhKJNEkbrEHMAGLj5Gt0+BIZG+/IUVs7WXOznAOU?=
 =?us-ascii?Q?55jenKjD4p2E3BSjAZbomdr1CidDUI17DE55wkZE3IPRmYshvKV3ldYW7PB9?=
 =?us-ascii?Q?LcFju7nc0iVbOeyx7KtTpxwfQ9VreysZsj6wFujxcQ8iwdFTyJj7o0sWXTWI?=
 =?us-ascii?Q?JwveMXkgl30dad0y29/udy9cr7JsPmdyg6cDdz1CwMYQl1djJQOLmC/dKbM0?=
 =?us-ascii?Q?HKdxva6wIZciZi6IduCxrLr6xHbxCj1w4nk4IKPxaQ+z8/kGHYYNRHw90cvT?=
 =?us-ascii?Q?bKYyfp+3/g5qeOc+TJbefzvd+Dd/3y3LPlwyGLpSIc0uy+SZyKHuzmQmtvZH?=
 =?us-ascii?Q?Z5TIJ9cqnH09RoLAAsypBQsEAWkdKcoVDYI82sz1CAorNxrfpbS73/jE6pch?=
 =?us-ascii?Q?Va75Ej7+cTfStId6xBa2Ah7WYiMeJrNkw5utwrUgxJVjUqyA6G2fyliAr8+P?=
 =?us-ascii?Q?5XuhAtSj4ZgyiuYj35H9ukcfiuTxnvBq/P503w8Cy9xqOprWTGvYd2AL6HJq?=
 =?us-ascii?Q?dBfdPWPEesvRwVaaGHBmy0y/JOJicHYRO+BzaieNR9w1qUwCo25nbtEHYIH7?=
 =?us-ascii?Q?R4LmZgiz7GtUhVpYb7pHhoX7soE237OUpGyfJeepbyxmN8MZhO2WPm+SgQIJ?=
 =?us-ascii?Q?Byb/XMrc/RbLQdzkuuXJL+UcRndAauibp3nWmRY/82CNtva42v0sjfjyfycl?=
 =?us-ascii?Q?XTl5i4sNnA698wysXvA4ku1E+ei5kFSWJu4lhvuFm9h/agwgvsqifWFoilze?=
 =?us-ascii?Q?e5z0nOquTZ10T/vCI/fOgfJC3e1CgBKiEjdV+lQKNP6gZRiq5sM14jaMvBBr?=
 =?us-ascii?Q?eLasTrICf4l+r5S7/PGJEm9YVWkf+k3D1YvmrH4XvIu8H8PSF+bNzCF/7p89?=
 =?us-ascii?Q?AGejYGENp74ZvWPVpY267PEHk8klfXqgZ61zHvGRLPzjt/uoAFWIFtAFKSrF?=
 =?us-ascii?Q?Kzpjc/2csEJPNj1/z3NppSf8eU3TFHjJVyBOMZuJoXWzl/hw0+WHc9T881KI?=
 =?us-ascii?Q?IeQauZhYFFuKiWA9D9tFto8O52fgnuR4EL6WGEkD3zBhWGWHdhT44pJLCGiB?=
 =?us-ascii?Q?B9j11ZaOFdjBQBSlSgtLmluca8ZVZApnLaQ2Nt5N6HKrSsGQMW7i/WBa3ses?=
 =?us-ascii?Q?bSf3mZEfWIv3N1EhL1cWGMFLgfWu+fkyTocX4EWS/lhPSjcpgkbCLHQkS/iL?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a867dc7-44db-4045-084d-08db0826e9c0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 09:45:42.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XX/p33WB2CRGnQPmHJmfxr9KcG2SW78OTVYticl0GCo8coVTA4qXComWyVXXhcUmvab4om6KaXoWmw5/muOsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PF driver support for the following:

- Viewing the standardized MAC Merge layer counters.

- Viewing the standardized Ethernet MAC and RMON counters associated
  with the pMAC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- move MM stats counter definitions to this patch
- add missing #include <linux/ethtool_netlink.h>

 .../ethernet/freescale/enetc/enetc_ethtool.c  | 84 +++++++++++++++++--
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  6 ++
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 078259466833..bca68edfbe9c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2017-2019 NXP */
 
+#include <linux/ethtool_netlink.h>
 #include <linux/net_tstamp.h>
 #include <linux/module.h>
 #include "enetc.h"
@@ -299,14 +300,32 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = enetc_port_rd(hw, enetc_port_counters[i].reg);
 }
 
+static void enetc_pause_stats(struct enetc_hw *hw, int mac,
+			      struct ethtool_pause_stats *pause_stats)
+{
+	pause_stats->tx_pause_frames = enetc_port_rd(hw, ENETC_PM_TXPF(mac));
+	pause_stats->rx_pause_frames = enetc_port_rd(hw, ENETC_PM_RXPF(mac));
+}
+
 static void enetc_get_pause_stats(struct net_device *ndev,
 				  struct ethtool_pause_stats *pause_stats)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
 
-	pause_stats->tx_pause_frames = enetc_port_rd(hw, ENETC_PM_TXPF(0));
-	pause_stats->rx_pause_frames = enetc_port_rd(hw, ENETC_PM_RXPF(0));
+	switch (pause_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		enetc_pause_stats(hw, 0, pause_stats);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (si->hw_features & ENETC_SI_F_QBU)
+			enetc_pause_stats(hw, 1, pause_stats);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		ethtool_aggregate_pause_stats(ndev, pause_stats);
+		break;
+	}
 }
 
 static void enetc_mac_stats(struct enetc_hw *hw, int mac,
@@ -383,8 +402,20 @@ static void enetc_get_eth_mac_stats(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
 
-	enetc_mac_stats(hw, 0, mac_stats);
+	switch (mac_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		enetc_mac_stats(hw, 0, mac_stats);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (si->hw_features & ENETC_SI_F_QBU)
+			enetc_mac_stats(hw, 1, mac_stats);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		ethtool_aggregate_mac_stats(ndev, mac_stats);
+		break;
+	}
 }
 
 static void enetc_get_eth_ctrl_stats(struct net_device *ndev,
@@ -392,8 +423,20 @@ static void enetc_get_eth_ctrl_stats(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
 
-	enetc_ctrl_stats(hw, 0, ctrl_stats);
+	switch (ctrl_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		enetc_ctrl_stats(hw, 0, ctrl_stats);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (si->hw_features & ENETC_SI_F_QBU)
+			enetc_ctrl_stats(hw, 1, ctrl_stats);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		ethtool_aggregate_ctrl_stats(ndev, ctrl_stats);
+		break;
+	}
 }
 
 static void enetc_get_rmon_stats(struct net_device *ndev,
@@ -402,8 +445,20 @@ static void enetc_get_rmon_stats(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
 
-	enetc_rmon_stats(hw, 0, rmon_stats, ranges);
+	switch (rmon_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		enetc_rmon_stats(hw, 0, rmon_stats, ranges);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (si->hw_features & ENETC_SI_F_QBU)
+			enetc_rmon_stats(hw, 1, rmon_stats, ranges);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		ethtool_aggregate_rmon_stats(ndev, rmon_stats);
+		break;
+	}
 }
 
 #define ENETC_RSSHASH_L3 (RXH_L2DA | RXH_VLAN | RXH_L3_PROTO | RXH_IP_SRC | \
@@ -863,6 +918,24 @@ static int enetc_set_link_ksettings(struct net_device *dev,
 	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
 }
 
+static void enetc_get_mm_stats(struct net_device *ndev,
+			       struct ethtool_mm_stats *s)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
+
+	if (!(si->hw_features & ENETC_SI_F_QBU))
+		return;
+
+	s->MACMergeFrameAssErrorCount = enetc_port_rd(hw, ENETC_MMFAECR);
+	s->MACMergeFrameSmdErrorCount = enetc_port_rd(hw, ENETC_MMFSECR);
+	s->MACMergeFrameAssOkCount = enetc_port_rd(hw, ENETC_MMFAOCR);
+	s->MACMergeFragCountRx = enetc_port_rd(hw, ENETC_MMFCRXR);
+	s->MACMergeFragCountTx = enetc_port_rd(hw, ENETC_MMFCTXR);
+	s->MACMergeHoldCount = enetc_port_rd(hw, ENETC_MMHCR);
+}
+
 static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -1037,6 +1110,7 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_pauseparam = enetc_set_pauseparam,
 	.get_mm = enetc_get_mm,
 	.set_mm = enetc_set_mm,
+	.get_mm_stats = enetc_get_mm_stats,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 7b93d09436c4..de2e0ee8cdcb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -240,6 +240,12 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_MMCSR_LPA		BIT(2) /* Local Preemption Active */
 #define ENETC_MMCSR_LPE		BIT(1) /* Local Preemption Enabled */
 #define ENETC_MMCSR_LPS		BIT(0) /* Local Preemption Supported */
+#define ENETC_MMFAECR		0x1f08
+#define ENETC_MMFSECR		0x1f0c
+#define ENETC_MMFAOCR		0x1f10
+#define ENETC_MMFCRXR		0x1f14
+#define ENETC_MMFCTXR		0x1f18
+#define ENETC_MMHCR		0x1f1c
 #define ENETC_PTCMSDUR(n)	(0x2020 + (n) * 4) /* n = TC index [0..7] */
 
 #define ENETC_PMAC_OFFSET	0x1000
-- 
2.34.1

