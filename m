Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A96968AAB2
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 15:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjBDOyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 09:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBDOyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 09:54:09 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2040.outbound.protection.outlook.com [40.107.15.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A2CBB8E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 06:54:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erXbORAa7Ioz7KAfWt5HSwYCEJSxlccd8Y5954Z1lA7Znukf73uEPy+W30vSTvZVaFAnNoU00izIN32TnEsbJl5lpmqIl+JAlqlM3Tt3rTMB4h201l3TWYY5pKpslG8LrupRfT7WVD4QaADySa627R2VevHkaM3UMrsMpI/iQ6Wug92K13PLshLGEBe3L4Fe4QziuKuuj0RRX/hrhTfm7a8+dD0A5v/yvzNlnzuU+HJCvEGC2IaSwSXFxIv3XMArKK78OUfYZi3JbjIlCS/s/iNBYjhgPgnh43IG1VdZJxmBkpYSbbS6DQ0GBZDNrfORRUMbXX3BbOZPoVzNnPUoRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqWFDiYNmzB03kV1tCJCZuWKh9JU/q14FoGT3ua6AEI=;
 b=AsaHvW+ZQ/G5Xx195mR7Es4qaPlH+EBoNKub7YjJ90j5bUUSAXHlULSICj+Kminu8iwSBSsB0vrM1t04DiodQg2g6CG+QdCl9hpJZsw48G0RblvnHqT5/421MWlP3FIPXGkI1Hmx/fPQbmhbUgdNuyxYA1xNkgWpxQaIN2JJq1mMOM/0S/ZwbT2bbNFWZE7k25pKlw5rC284WwuvqokMNoeg3A+AMK0CdfMlwczbc0lF0K09b0tn6p8MCHxfn+eF7h/3HR8udjjShfw1OzFxMSu3SzKo2Y+zSN57zdddycYKlGaJQNpWkTCWYb9wpItAi3+u9//mw1rBdHVwFvAdtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqWFDiYNmzB03kV1tCJCZuWKh9JU/q14FoGT3ua6AEI=;
 b=G7YkJJVof0FpKZLgywmb8RaDFRmYlWApz9+RbsFROeMMhdwzdrtgtnOhvxNL3ycgeA5ThCFI/5BQMzkiGkRDj7KEYMlKFkEybLnK02ZcoxtpnLLJa+0gn+MkUI8TFRSGiArw/UOViv/lXC5u7ESBPb9InICGCDWed8JvCHtiU3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9382.eurprd04.prod.outlook.com (2603:10a6:20b:4da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 14:54:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 14:54:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 2/2] net: enetc: add support for MAC Merge statistics counters
Date:   Sat,  4 Feb 2023 16:53:50 +0200
Message-Id: <20230204145350.1186825-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204145350.1186825-1-vladimir.oltean@nxp.com>
References: <20230204145350.1186825-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS1PR04MB9382:EE_
X-MS-Office365-Filtering-Correlation-Id: 431bb08e-03ef-46ee-471a-08db06bfa7ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AnBRQA/hVbrt7+sIUpTfiFtSg94M/XChIc8QhuRBSkjw1qNi1yI1Sh4Mz5qZuCGHwdfACwwrvZgwn0EQD9H5g0pjN87bvzGzG9Y+fsTBYK2OEVO/PCwlAnmrbQeSdkrJwvenWdCpiWoBdXXrxbXJm+uQlDk3f7WDOtkVt2eFG4yDKlTOVHBBS4Z5Ta16mGJFSnF4UIwHHdtODJkKODTHcwl/b3ffN72l1tYTlAtXmtnkQe/2o0p5HXgBea36A7eBG3zWaeA8mPvCPEaYLhHP6+cTE0Ed8oPT1983hUzhlBrcq3l8qMR3ipccvvBso2/R3SvwOgy2aJ9eQtu/HC0qxggo19f6MfFkwO7REoBnet+1Dyz6GcHW7HwbGWMXcnDOkM+PWRwjTuy51bs48biewDgqCDMOQRgDMbIHOSUcqUtdfEOa41NR7nSkbt4gzul8nnIDESwHF4/z3acZMAq7Q8IfErmI/iv6J3f9BoZJ/lMhBiCL39zYROIdquSk6acL9jRJGOpu8mkx9EuYdlXS1y08ZKwckAOG3l6kTyt8amkwOwGdjzEOZRSRgZ0Lsk1pyfsc5WbfD05Du6Wg8GtVRf14uaYVkLP33hMPrA8ldkHS+UpzoUSu8Srmzu4YgSl+OVbjTVZpkNgXYfzPA14eEqMRn4PGrS5MOmR0CDJLTAAOiYOpL2vLY8ZucYeeF4qLiZxoVvPoD2BTgmuh9kAfJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199018)(66946007)(54906003)(316002)(66556008)(4326008)(8676002)(41300700001)(66476007)(6916009)(5660300002)(8936002)(38350700002)(38100700002)(86362001)(36756003)(1076003)(6506007)(186003)(26005)(6512007)(52116002)(6666004)(2906002)(44832011)(478600001)(6486002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UcjZZQEOjIl1dBi/wF/fgXJLmsQym2pIDUzzXlqpiPW2FODDLW7yniLoXk32?=
 =?us-ascii?Q?CL+UYA+rBvfxNxTpOYN0RrieStXaEifXHnlWn4DIWhbUAvD+XKib6p7DgiDV?=
 =?us-ascii?Q?aWUc5zlylWqPq0AXgS2QAqAEopr4c+xQjdKncQBL0yBQvuidGCBLCrHmrJ/7?=
 =?us-ascii?Q?zxxB5z4jl7ZTpXSj5/NI6+R7o/r7lcJ5wlhjjshzYj+an20oAyNmjw06DtqE?=
 =?us-ascii?Q?D8iJ+OKDXDmfGNcACpb9z60dX6zKERP++oXfOlGOYlWqXmtJRbM1JzBcTpmt?=
 =?us-ascii?Q?Z8mycjS5gySrhzjbxUnYnT4kp0f60v1KDC9LEU58hRMm4TMyrcIPzQJ9ZTLG?=
 =?us-ascii?Q?+X0a1rcs2EMJiaanJlCtmxWHMlCi3CwzcJnDA/yC4fE/Xhrz++/pRqcSjHkc?=
 =?us-ascii?Q?VzpXE51Rupl96WgWR+zQXeB36N3WD7WUCLJtoChWbIFZmDdAJi5/5gQNdWbu?=
 =?us-ascii?Q?APsV4IlSuTh4e/vE/BcM+A2qj6tw0Ui8MlFdY1kzgEzb4ntw04z8cc/YgOXk?=
 =?us-ascii?Q?6wsExzclfWQOEYs0cO22xW/yIMKlqOKFbrLdmFcRPoGJ5O+5mt+R9iKuqePF?=
 =?us-ascii?Q?WtLQgLhqgy5PBAWO4yNBU6lJrjV9HK8xTAJ5Bc4C9wJiNlB5wL88a4HxtW4I?=
 =?us-ascii?Q?GYxlzvJvDMxabJw1OnBgyB6j+9cIhUCOdZwEJkHuKofheEUcjd9HcpsOZRTT?=
 =?us-ascii?Q?KpCk0oLycR21el8xjPHasuwdhGN+J6vrhAp6KYMSu2MosHZ0ZatpKS7HiV/F?=
 =?us-ascii?Q?BqEnZOmf3j0M9e3/oL8RgLKrRu2upvsGjURUe5v1g8dVrmP66ydsG9mkGt8d?=
 =?us-ascii?Q?rGepsoHnLeSPwRdPXSPkfRgFMT5d6Q1hF9NUhpbpABKF0mXD9mUJVOi2E1PL?=
 =?us-ascii?Q?5lFoiqbjpo4ScqAKb8EUa7hidyN5Cns20g1ztJJ0mKSfm9XqtPucykdg1+jc?=
 =?us-ascii?Q?EqWPh26M4nu3KIu0utj85oL+ibgLKRl7sBBDbccOrsc6Q0K9m4V0V/IKVju2?=
 =?us-ascii?Q?hsiHfkl4zHn0gtkVVnIuD3+D2PnO/PAR2EdGPi/1+wQ58l2Mvb5xw/WFkZ21?=
 =?us-ascii?Q?X5zP+j7GsUJKPaZpRtLmKFIBfUJ7/ZYsU0TGfpQUw0bQ0iLxjZCSsiV2itns?=
 =?us-ascii?Q?/j6fol70Du7PYzhAvE8bDcZ2XxNApKL69FlEg5VxE8st6Sl7BOmGkDqwkkVu?=
 =?us-ascii?Q?L+DkZKM8AzukgRKCnXNnb0WrL1LnKkLpZpnuIXFhP+3fAer0Op/lFTcNkxSC?=
 =?us-ascii?Q?XlyHwiqHIxmCrjNsgeKe3n358LpWzJuinnMcFgu8+5N6RjOFaWySkwPIXFTP?=
 =?us-ascii?Q?iCgNjdm7UOor5mJU++InjATjwAxhEzCZb6RWMOswD/DiADgWSNw8i2626vYB?=
 =?us-ascii?Q?CoteHGwOXzvjYIYbyE9MlxR24tkDjLYfHsOc2z1fJ7kZl/1HsZldgxME9uWj?=
 =?us-ascii?Q?a5pK4nsV11ixtsZA2KO6i90ERdPNAT5qM0clJpSrhjP3i2klVzmRQgwzSi4b?=
 =?us-ascii?Q?QfLKg/XMiT470vSh1Y0UOiu6Xjf7CnAopRCoUNHGip7hKKQ4kCw28i0s7QJq?=
 =?us-ascii?Q?PfQtGEQJ8YAVtNq/UxEM1HpTbnG1CDqJGqZg10EwWee2L7OPV+i/XxuZkkCo?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431bb08e-03ef-46ee-471a-08db06bfa7ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 14:54:03.3852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vcgBNOSgwQtIQAo9md21NLbHgwaaXiog3Om66OrbGviNpFI34X69eQCuwkB89ZxxaHa0RfmXUVPo9ImLeWrkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9382
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
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 83 +++++++++++++++++--
 1 file changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 306d1e38cbb4..631451d8f47c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -299,14 +299,32 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
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
@@ -383,8 +401,20 @@ static void enetc_get_eth_mac_stats(struct net_device *ndev,
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
@@ -392,8 +422,20 @@ static void enetc_get_eth_ctrl_stats(struct net_device *ndev,
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
@@ -402,8 +444,20 @@ static void enetc_get_rmon_stats(struct net_device *ndev,
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
@@ -863,6 +917,24 @@ static int enetc_set_link_ksettings(struct net_device *dev,
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
@@ -1035,6 +1107,7 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_pauseparam = enetc_set_pauseparam,
 	.get_mm = enetc_get_mm,
 	.set_mm = enetc_set_mm,
+	.get_mm_stats = enetc_get_mm_stats,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
-- 
2.34.1

