Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A39D596581
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiHPW3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237665AbiHPW3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37100796A5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQIafFKeFhOtnUF54M2C5FQXlmD1GoNxLKuB3tTH7VGziPoeTIFQhAs8MQs3Hp/TumU4inRsSa5Jc6MpH3HSPbdsKO2MRtNfARbrZge4k28f6YMBPq0909WGboN+20aB4rMmPhXIqVsy78NtNa+fqjd5nT91GbGKu0UYPmJSxwHuoNkmAWzMTphA37VjqbCgNWsZoAE0wH2tpSdjlTd15tAvbLWTwfXULGns3zuYAvEjlTWF1SyD/2zb8ENcrru4kVh4+wvivrwHqhgKkF1nLggOtewrbVtUszpRgcS4SpA/WkCUr2kqkiFUtOdTrcuD3XYX2a7acdfHpvW2h4GoFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7mtKcvUX2AZB2De/ByCccCMyDQrteS3klEW3zAm5+U=;
 b=NEOFMwgI9xB6PxPllobCI+6MiOwzZgh8TmowLTbTgC0zBN3ZGuMW96FzrXi5K++pPsonjhFMY8XTjEpyWwjqHEJjTCOu5bMKjlFgW8wh2idVSPVGXe/I/9h/JmbOAPQp0MrrwEDcjlV71WdqA/WYBY4ZOIbK0OFZzxESHoXF5vILu56DbG34jguCUdljSBt+plgQR6VszlkKhIyiTlG+p7pbWTp2M7s0tZsAEQ9VI+q58ZHUvJfUjpnX3fSm/qNvZTFMH0h2RxMjk6axn3aJJyX5YVJZOQGbNDAatjODbvxwlS3fKRXxDJomApSQqmrqxMw9s46kU+xyyoL2ZPxzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7mtKcvUX2AZB2De/ByCccCMyDQrteS3klEW3zAm5+U=;
 b=egyPUWINOLwKkKtga6X4/Pq5DurQTv+Jj+D0rRQzr85IKq3Y7mI+sKsIehn3eD0s2fv6SNeQQZVTaqAPJLFhh4PyLwTVi4Zi/z8bIBX3eukQMzRqOd3GJPA8RfmKNP2wp6jemzs91FVZ6Ht1DHNLO4UQDuvPPXNzR1yGXrvSc3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 4/7] net: ethtool: stats: replicate standardized counters for the pMAC
Date:   Wed, 17 Aug 2022 01:29:17 +0300
Message-Id: <20220816222920.1952936-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c309cca-4910-4d50-46f2-08da7fd6cb25
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iopOmuMz1kkzFQZt7F5cQzZIqPM0ucHKT16rNg2iYyjgFTSzvDYh/BH38ORL1Xr2+LLiGVjQn5TTxT/TqPqFwRujlGLp7eCbQrVfYj5jXabCBQS4PNWKwfMsS64kneB0lFDno3bh3M7YkhjKjtYFRsUw/4KZ2kYkG/0Kcnnw7J/7w79AGuz/lJKqRRF+ly89oeKkIUhmrwtQqxI0U0TNcOwV3SeSpiLpLtZ0Uc3fvjzMDunXF8ePyNF71ZI2jh0Zeho4HuN+lJ7s5VOhGwa7UwVMeAAVSNc1+PVVjIOMFK6gOxxh27i+CspIQ5QsTQ8QQxcrTMOVqpEjVMvd7hjMouXOPMGDQBNp/ds9Na5mbGKG4v+zwJj8KwfNn3avrjrv5E75XRishGNDIHGa60j3WYMJJtcbofVaqUGEeoBlxKxEQOiQ+Pi1cNSgHWH3mobX1QmP/8/gMX+wyvRw6+qG/cUOfKyq96Gp4RGuHGDXTCj31A9LQg9I08LCFmopfg7mE1cDb5rSCc1HTdRjr7by4g840PotyI086lUOvSI8v80+csFgWMqns7GgQxi/4ZkSkLZfFE2hlP2iHq3OIfUWjir8SX5/FLHAv/mlvOi3JUnKugIgWwbloMl8Yi96576SThxpoEB2kIdKHMRtwA+/n0ZqEZ+/fxhrQ2gzHyLSlVOApqhaRJX+aizpe2uCffIrxI0IQXweVWu4bPrCpf1SThdQNZmbN4eE0fH8rONPRRqx7Amg/5A0g2vb3Le7h+0/FHD38Oe8NFfNf30qQ2pnfH6gzM3noR7dtZ0AaoLWuEo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NloW9e60JuGrHsaQKphtk2nQ+Nr27nTMbLEm7WIogbapiU5KflJItyaaw7wN?=
 =?us-ascii?Q?fc0+EIhVvqheAYk0GupqLDbl6HjahilO1M5VitOYgs/0r/w4sCPCoua/Bsio?=
 =?us-ascii?Q?0eppyG+1we6Ya+ms9ylhYSsrMCeyQ09KrzLMamWoekCrQABEZNELfvTJp5te?=
 =?us-ascii?Q?UCxGGDlHCk/eqx8hNMVwVIoP4v6kWYnA2m7A8VOr56CJbA0UreICzU3f9gTP?=
 =?us-ascii?Q?VFtDGX7Mz/uYf0zeC/6QB+uAicAUMUfPHjrL5HfRfTCcpcjF+BJHFD2RKt2Y?=
 =?us-ascii?Q?LhGUptdxlKm0g+xHBkQCnI/rvLNPMLTiWEz/7wem/nVsa81rAjTshb2l3DT4?=
 =?us-ascii?Q?QstT7NRyR7aoXGfeGU+6A1ZK4MOzgr98z8bDSnhVfNWD2sY2ElFkADwQLG9w?=
 =?us-ascii?Q?5b8D5qu5Qmbxyi29VCPaDlNgSgy13+cGHCl591tI5t63Co8gngjit/Ky4IE0?=
 =?us-ascii?Q?JSsoSouXUsX9ylLHh4oiZlO/0QV5I5uct9txqE7vP+Gu62yM0hJA9JrJHGk2?=
 =?us-ascii?Q?1wl0X6AGpeFSASd1vdU1UbMeuVd2m8Ng0ZGb/6g6zUVgUO/M31aSpar0cC22?=
 =?us-ascii?Q?f9SkVL7s0dyNOnqvrNtyBOAp56x+ppnmJYpdBLCh9LPtG2KAfFiW7xRqYtzg?=
 =?us-ascii?Q?5+Pv2IbEFQzM1jhdLKMB4yQ0jCJUoz8pt1fY6bAkJCeAw/y7P97458JYSsrz?=
 =?us-ascii?Q?PICHkyRYN7um+gjKM3zSclPXZpWJXnZWFylpfH2phJkiMa1sUsuNFWrsgzFX?=
 =?us-ascii?Q?rni1sQIEl1Dv5+VcgvAs1vObNK99zNcfFGNS/yRxCSPXcZ9sCoRqC1KU7KrM?=
 =?us-ascii?Q?EZJw6QW3z3jPvOZ5NBVRTietIsCkjTZCBagCrn/9XMWvh/Uak6HSFbcqkLO/?=
 =?us-ascii?Q?ckrBlniJbeKvxId4rUTFLsc0tBx0XK2cGL3Z+iTfQLUT/ed1E8ZY4cmAAv+X?=
 =?us-ascii?Q?uz2pbBZ1wIr2yhnlFx0VMURKoJQJNW8aAZujGB/U12++4v89/o2N//9umTTa?=
 =?us-ascii?Q?uIOkJgzxUprMHBV9eXG/i6XlP5ZzJ8F7HNNPrzzLvRf78xD2YaOS77NZdBnI?=
 =?us-ascii?Q?QVJgWxg/oKJvbpjexmhGAsfKNvWmiza0236Ijn9e67smsl3xqZbYDsdXNO4A?=
 =?us-ascii?Q?XQz/5enmsB5GL0g/kCUfJF59E911DFHef7OPzlGg8WrD8aNsOSosA0LGPrjx?=
 =?us-ascii?Q?W8ZDNtIHnbGnY6fmezJXPks8M3eOoYJnnxHcNm3UlMFw1pFOYal5ac7wipZI?=
 =?us-ascii?Q?Qnq9lnAFmXr2AysV8KBWkPvzS5ol9sx4EMfDCsw/UTBa4U917rEzW8ez7BTl?=
 =?us-ascii?Q?vlgbPsdOTTiZITDyqUUEXU2Ige4z6r7psigC3hgvRdJM0nIr0w5vsPac+f62?=
 =?us-ascii?Q?uBnCK00c8hr0GqLZtJWhqIzQ6boM069Z7Whp4VJAicGv+xlBpIDpr8vZpxok?=
 =?us-ascii?Q?0u5YAMPxDtmpcOatuRTLNffgMpH5I+bHw3AZtjaloBkomLZH3a3dUA0jwfQG?=
 =?us-ascii?Q?vrjV36qn0LidkIjJ48eQPcsiwr6xs9iVwtQSdv+qx54aY+Ya12gveXsMQV7h?=
 =?us-ascii?Q?X5dV1bibURy8GFG+Y7eLwk3/CW2nS3fojkZnqfmLiR3kdy6crbpuNmy3UxpO?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c309cca-4910-4d50-46f2-08da7fd6cb25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:33.6011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmkYy8/juBtals8MRoRmFoabpR1n2BpU940/bwT8csgN+CtE68+/y10CzH413c5xUX6nRUAQQ1ZTfCCI3mvbNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devices supporting a MAC Merge layer will have a second Ethernet MAC per
port which handles preemptable traffic. This has all the same counters
as the regular (express) MAC, so export 4 new groups of statistics for
it, which have all the same structure as the ones for the eMAC, except
for different names.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/ethtool.h              |  9 ++++
 include/uapi/linux/ethtool_netlink.h |  4 ++
 net/ethtool/stats.c                  | 70 ++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index fa504dd22bf6..ce3b118bcf19 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -802,6 +802,15 @@ struct ethtool_ops {
 	void	(*get_rmon_stats)(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats,
 				  const struct ethtool_rmon_hist_range **ranges);
+	void	(*get_eth_pmac_phy_stats)(struct net_device *dev,
+					  struct ethtool_eth_phy_stats *phy_stats);
+	void	(*get_eth_pmac_mac_stats)(struct net_device *dev,
+					  struct ethtool_eth_mac_stats *mac_stats);
+	void	(*get_eth_pmac_ctrl_stats)(struct net_device *dev,
+					   struct ethtool_eth_ctrl_stats *ctrl_stats);
+	void	(*get_pmac_rmon_stats)(struct net_device *dev,
+				       struct ethtool_rmon_stats *rmon_stats,
+				       const struct ethtool_rmon_hist_range **ranges);
 	int	(*get_module_power_mode)(struct net_device *dev,
 					 struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 658810274c49..a2743ffb6c63 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -742,6 +742,10 @@ enum {
 	ETHTOOL_STATS_ETH_MAC,
 	ETHTOOL_STATS_ETH_CTRL,
 	ETHTOOL_STATS_RMON,
+	ETHTOOL_STATS_ETH_PMAC_PHY,
+	ETHTOOL_STATS_ETH_PMAC_MAC,
+	ETHTOOL_STATS_ETH_PMAC_CTRL,
+	ETHTOOL_STATS_PMAC_RMON,
 
 	/* add new constants above here */
 	__ETHTOOL_STATS_CNT
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index 8d4d3c70c0a4..50e858b540c2 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -24,8 +24,13 @@ struct stats_reply_data {
 		struct ethtool_eth_mac_stats	mac_stats;
 		struct ethtool_eth_ctrl_stats	ctrl_stats;
 		struct ethtool_rmon_stats	rmon_stats;
+		struct ethtool_eth_phy_stats	pmac_phy_stats;
+		struct ethtool_eth_mac_stats	pmac_mac_stats;
+		struct ethtool_eth_ctrl_stats	pmac_ctrl_stats;
+		struct ethtool_rmon_stats	pmac_rmon_stats;
 	);
 	const struct ethtool_rmon_hist_range	*rmon_ranges;
+	const struct ethtool_rmon_hist_range	*pmac_rmon_ranges;
 };
 
 #define STATS_REPDATA(__reply_base) \
@@ -36,6 +41,10 @@ const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_STATS_ETH_MAC]			= "eth-mac",
 	[ETHTOOL_STATS_ETH_CTRL]		= "eth-ctrl",
 	[ETHTOOL_STATS_RMON]			= "rmon",
+	[ETHTOOL_STATS_ETH_PMAC_PHY]		= "eth-pmac-phy",
+	[ETHTOOL_STATS_ETH_PMAC_MAC]		= "eth-pmac-mac",
+	[ETHTOOL_STATS_ETH_PMAC_CTRL]		= "eth-pmac-ctrl",
+	[ETHTOOL_STATS_PMAC_RMON]		= "pmac-rmon",
 };
 
 const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN] = {
@@ -143,6 +152,20 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 		ops->get_rmon_stats(dev, &data->rmon_stats,
 				    &data->rmon_ranges);
 
+	if (test_bit(ETHTOOL_STATS_ETH_PMAC_PHY, req_info->stat_mask) &&
+	    ops->get_eth_pmac_phy_stats)
+		ops->get_eth_pmac_phy_stats(dev, &data->pmac_phy_stats);
+	if (test_bit(ETHTOOL_STATS_ETH_PMAC_MAC, req_info->stat_mask) &&
+	    ops->get_eth_pmac_mac_stats)
+		ops->get_eth_pmac_mac_stats(dev, &data->pmac_mac_stats);
+	if (test_bit(ETHTOOL_STATS_ETH_PMAC_CTRL, req_info->stat_mask) &&
+	    ops->get_eth_pmac_ctrl_stats)
+		ops->get_eth_pmac_ctrl_stats(dev, &data->pmac_ctrl_stats);
+	if (test_bit(ETHTOOL_STATS_PMAC_RMON, req_info->stat_mask) &&
+	    ops->get_pmac_rmon_stats)
+		ops->get_pmac_rmon_stats(dev, &data->pmac_rmon_stats,
+					 &data->pmac_rmon_ranges);
+
 	ethnl_ops_complete(dev);
 	return 0;
 }
@@ -176,6 +199,28 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 			nla_total_size(4)) *	/* _A_STATS_GRP_HIST_BKT_HI */
 			ETHTOOL_RMON_HIST_MAX * 2;
 	}
+	if (test_bit(ETHTOOL_STATS_ETH_PMAC_PHY, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_eth_mac_stats) / sizeof(u64);
+		n_grps++;
+	}
+	if (test_bit(ETHTOOL_STATS_ETH_PMAC_MAC, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_eth_mac_stats) / sizeof(u64);
+		n_grps++;
+	}
+	if (test_bit(ETHTOOL_STATS_ETH_PMAC_CTRL, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_eth_ctrl_stats) / sizeof(u64);
+		n_grps++;
+	}
+	if (test_bit(ETHTOOL_STATS_PMAC_RMON, req_info->stat_mask)) {
+		n_stats += sizeof(struct ethtool_rmon_stats) / sizeof(u64);
+		n_grps++;
+		/* Above includes the space for _A_STATS_GRP_HIST_VALs */
+
+		len += (nla_total_size(0) +	/* _A_STATS_GRP_HIST */
+			nla_total_size(4) +	/* _A_STATS_GRP_HIST_BKT_LOW */
+			nla_total_size(4)) *	/* _A_STATS_GRP_HIST_BKT_HI */
+			ETHTOOL_RMON_HIST_MAX * 2;
+	}
 
 	len += n_grps * (nla_total_size(0) + /* _A_STATS_GRP */
 			 nla_total_size(4) + /* _A_STATS_GRP_ID */
@@ -419,6 +464,31 @@ static int stats_fill_reply(struct sk_buff *skb,
 				      ETH_SS_STATS_RMON, stats_put_rmon_stats);
 	}
 
+	if (!ret && test_bit(ETHTOOL_STATS_ETH_PMAC_PHY, req_info->stat_mask))
+		ret = stats_put_stats(skb, &data->pmac_phy_stats,
+				      ETHTOOL_STATS_ETH_PMAC_PHY,
+				      ETH_SS_STATS_ETH_PHY,
+				      stats_put_phy_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_ETH_PMAC_MAC, req_info->stat_mask))
+		ret = stats_put_stats(skb, &data->pmac_mac_stats,
+				      ETHTOOL_STATS_ETH_PMAC_MAC,
+				      ETH_SS_STATS_ETH_MAC,
+				      stats_put_mac_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_ETH_PMAC_CTRL, req_info->stat_mask))
+		ret = stats_put_stats(skb, &data->pmac_ctrl_stats,
+				      ETHTOOL_STATS_ETH_PMAC_CTRL,
+				      ETH_SS_STATS_ETH_CTRL,
+				      stats_put_ctrl_stats);
+	if (!ret && test_bit(ETHTOOL_STATS_PMAC_RMON, req_info->stat_mask)) {
+		struct rmon_stats_put_ctx ctx = {
+			.rmon_stats = &data->pmac_rmon_stats,
+			.rmon_ranges = data->pmac_rmon_ranges,
+		};
+
+		ret = stats_put_stats(skb, &ctx, ETHTOOL_STATS_PMAC_RMON,
+				      ETH_SS_STATS_RMON, stats_put_rmon_stats);
+	}
+
 	return ret;
 }
 
-- 
2.34.1

