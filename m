Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0904C2D33
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiBXNfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiBXNfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:09 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA39178688
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clkj65g/K6mAmWwQgTKVzTxSjTt8zsaiyRXbiNiTsExpDd6mLI7Ak6sN4ZkQoxpLktzDXFnUgZYshP95ZwyO3MEa/HA8nL0NBg6zrewnYd7E8MxTJCokIPgtWPHhYAIJD3s0k1Rfgkv6Q8xAylESX83jV6igacS9g+PmkKZPzznDCuPTHLlD3dT1H0Cbyauy9gu7MkJb5pLF1j1aLEMnEA6fHVX+gyLAA8K3Hqeegk6m7LtNa7WXuAs61IGhlVMT4vzprFVb018AgMldJ7fFrE+dMP9GCJt12FZtWvdt9kClG3AQGso15NvbV1/NfxdroakPyorV9Y4iGhwOSl70sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0l9h3jb8MeUSAe3taUu67NaYNGHY+MG+CPKKqFdhqY=;
 b=HvLbNVmzeEtbUD1H1oobgs2I4GLfUfEoRv07J4Az3V72/FAlgtsbatLifP8HFRD/SKfs3tZCH0AzjEmm1RrjYlmkZSjAgOJSw6cEftn7VAP3v7ePLc6yhtEguMsJfhIGY/CHLMGCx9Ic3/bQIGQP9cyWBYMIzK5PxFc0uizi1S7BTGwlyG/unji1fVYXadTAlZKk4H+z47YUfrHTZpMgo1vKIkpO2eOGCp8THS7JdXW3bUDtgY5JydDftYUOK0NFgorHds30oQ1BL6kRSE6cdpmiQQyGkE8o11x+GjZ+RR/GHlutkDYha62Mr1hgDWHxM3KKK3BxImXMTKMwFaaR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0l9h3jb8MeUSAe3taUu67NaYNGHY+MG+CPKKqFdhqY=;
 b=felQMC0j7Dv/hnxuo01U3fLbxfpiyqKmcAWGDMluUP//qhqSGGDMQJiw+ewOGq6OOxNsD70psBfTs3aB9bPyrcsgbunAgDnv3yOXOBMHggFfA3JdFkBSvEtUKiIsg0C1xkZEuxFX+DQwgVkVZIgGnzWhqvLSkQSVNmCzBYbnuCP98N+7OLjnFwIRAjJ2aRYsWwqVkSaERvH7INpX1IxLAs0eFoKFUNnFsUB7QOOWO4lbJDBFyLq+kSRpOvLEhPUVycdZwkO5oybhUgGMkhVnIXcIZynVN9NqFCbEgWiF6wvZClvoWhk8RqI38KgKBllreU+m6zn5mCCPH/AvmfVPsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:34:36 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/14] net: dev: Add hardware stats support
Date:   Thu, 24 Feb 2022 15:33:27 +0200
Message-Id: <20220224133335.599529-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0059.eurprd02.prod.outlook.com
 (2603:10a6:802:14::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0b42c24-c95d-4a07-7df0-08d9f79a664a
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6008D0FB3773DB31AEB01E39B23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLq2WBWMw5NKSbMc9hH5E5bhvTfSTZgmV+ZK+atXyXpZrvhAKMaDE0Iq+bM5pViv6lJljII0OX9EP+531QX6wsXgR/D0af/9CSr39EySGNAYUou38C/oswMLL4mnU12FdenqVvrXKsw9zhrPJjYmiEoYowLTlR1fDzdv6ts6ph9hUyS1T9UkTWzXBU/bGrEvUvnppSuT7Ow7CmXYDwz9oaIzHZRAfq8BTXGdAj75ttXGpm8o6DjbLPBAwCGoCvAwhZjnmcDxtn2QXeSJH/eLPWM0sSv6Lda2XGOIS+nXKXDek0cvtWoCrbzIKjETceB2M+9Jkx/kMIubb2wECGCD6CaB/+iAOn2q76nUSVhx6OvkaB2J/EWBlJaxzvJLlqLkfUgoVOxmiUbNeNW21wD9USQjJiymB+Pgo/j4tf8fh8o0J1betb/VCcAjdkesrg2OYwV37mbUUAOXQHfddmgygRjsNMMQ3YAmZdtLWa9WuUzB7MoYf8d0jXhh4tk1j2t/oqpBbC0O4K3yWjMX1G7K1h0z5xjjyxpYXreWHkQtShk1hhvF8wqZhlzx1sTUedeEbi8yVYj9LGhSfUnIcefuW+OGCWMkQ+sZp22TwomT2wHmSHR8WVj+Mq6Bpm6RAk13QFSQ6jYDP0cnbyS4TUxPNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(30864003)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/YIM0kzR+6nNa6tPUUTIfCBsxVbd169BCqRqgxad7u8UiU+0TzO8kkflezf?=
 =?us-ascii?Q?vobtMY93BzUMEz49sQ33ktH2mSTf+aPT+QiFwDXrOhWgPseCykkW3YPYE569?=
 =?us-ascii?Q?Q0DMXHV0D66js7Np9f0wZnf6x73PIsj54aSeyx6k9xolBNPCAYLE7Q7HqlbV?=
 =?us-ascii?Q?bKiMlyTlA7o3xFxuyyQ5a7XrgzQX7f3pWyRKK6KpvbSKWyDe9OY+z4C2aA2a?=
 =?us-ascii?Q?SsaO2rpxRPWZsJrJAXaYWAiTeUAONFruMTU/XXHYqTXIteBs4cMmnRqt7v9c?=
 =?us-ascii?Q?szRzh8KDGsA4KqVSUx0F7p6SnpT++/QmoygOwpM4T5AYUAiSejczl3Po1c9R?=
 =?us-ascii?Q?nUu8ut/ZD3//feHHawUuLz+QA8H5cOMT7XDTmwaXWEOl0jC6NpW8fmC6UBlu?=
 =?us-ascii?Q?OLRYv3OYfVpHuoawRXtJ9jDTCBhdJFt4CJD1huf+1nr/PhFAUoxVz4cYMoXC?=
 =?us-ascii?Q?lEpaKYzNOk4ECIQ+LaHrto1zFDz0Wu+TnZjYJYc0GF0Q6KnMAAXVMNRvH3mx?=
 =?us-ascii?Q?+7GOq+IvYOgRnJaiV18gJsnW5400gD/Wk0xM7+EpvYfFRDGuvaOVaf1S8D5M?=
 =?us-ascii?Q?tMtM4sZ+G6pXwFmWXMsxW1jQfXdE5Pk/JbRYO7DxqosmMudIsxhAtWhr8cdP?=
 =?us-ascii?Q?mkBzk+kH2VK5B8W3L58ZuE4nQfykHULmDizJcWOuq03Lpt4Azr29bZCAu5NF?=
 =?us-ascii?Q?hrMlaM9Nquc0lzl0Sr/wyif/RDaV7K8WMKXBEde5hUylFuLPQjyK+O0hgH4F?=
 =?us-ascii?Q?xz4okKd5sUK37FMrqwQL1cfQZEvXFPhlv7mJ44X/81dh8WDlRBimD+mGCM8K?=
 =?us-ascii?Q?bPF64lnxKukVT6bGSZAXnQ2CuKJsMql/HPeGy/wXdBOQMLPQ8jHuhyEsa8aA?=
 =?us-ascii?Q?myWN5egM8vituiCk67QPtQtkAkQ+iED5ZOFzvDhg6U6HjaXemEJ/ZlwSLl1d?=
 =?us-ascii?Q?+ASom94V9hJuBsBD+ErE0w1nLLuoFCshjwD21h3DMpuDhkLQ08ycrZyZ4IrP?=
 =?us-ascii?Q?EByrOP1RODbMaEMnFSj+sAmkQN51BN4Hg+P2sRY5/TtkqgSQYTw8JzUXIh3X?=
 =?us-ascii?Q?d9vO1JTsao9JW39c6OB7inzW6if8Seh4eDEyux0JOH7q6AQ+v1PmaigQTVo6?=
 =?us-ascii?Q?8ZaBjgnlLh9TCnj0bdJtatQ5KuXN3XTr4G4Yqlk657dqFfz4sJ/hnYIgyVLH?=
 =?us-ascii?Q?qTJGHXjquynGMAvjOVJXfC0tR9qKg//2frnLdkGQvyagOdjKIoUP4a7ah4zu?=
 =?us-ascii?Q?O9iMbBWoAdxqYG+mQHuOYKeGEcESp6nNb6F3Z/KAXbmp40KIPfxZmtfamF5X?=
 =?us-ascii?Q?6Vvik6oohKh5InzOasrG5A/RN/sJ1KLdx1DzKkPwV/6GZnaqq6C7I+qF15g2?=
 =?us-ascii?Q?31n/uAb69N2h1RkW0vWHEiEEJcWx8Co5AWA3FBA86AvB8cE+b4veTfP8yZko?=
 =?us-ascii?Q?8CNueclo39J+wpthxLJIpVgnu/ShrdRLLzqTWqch2/aLc5oA/hIfHm5orB5i?=
 =?us-ascii?Q?Yq9xKML+TP1Y5wrBCETSUHPLi4InxmvXxdc1+GQPYOvZZSiAXjNHy+3ORq84?=
 =?us-ascii?Q?5i9uFT43K+9Ov2l+Sa2bwEHBhm7QbR6/Z54mu/kFk/UY9d4w4gevRVb3QCCM?=
 =?us-ascii?Q?jGnVe7q27gh1BaA7ep0mjqU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b42c24-c95d-4a07-7df0-08d9f79a664a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:36.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UruDlwaIbzfEMJRUmmoki8ck0lp/iFloJUelxjdsO1UO+8rwHH276vWNmr81nWO9PhpU2Jat6KSiY4dq3hS3gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Offloading switch device drivers may be able to collect statistics of the
traffic taking place in the HW datapath that pertains to a certain soft
netdevice, such as VLAN. Add the necessary infrastructure to allow exposing
these statistics to the offloaded netdevice in question. The API was shaped
by the following considerations:

- Collection of HW statistics is not free: there may be a finite number of
  counters, and the act of counting may have a performance impact. It is
  therefore necessary to allow toggling whether HW counting should be done
  for any particular SW netdevice.

- As the drivers are loaded and removed, a particular device may get
  offloaded and unoffloaded again. At the same time, the statistics values
  need to stay monotonous (modulo the eventual 64-bit wraparound),
  increasing only to reflect traffic measured in the device.

  To that end, the netdevice keeps around a lazily-allocated copy of struct
  rtnl_link_stats64. Device drivers then contribute to the values kept
  therein at various points. Even as the driver goes away, the struct stays
  around to maintain the statistics values.

- Different HW devices may be able to count different things. The
  motivation behind this patch in particular is exposure of HW counters on
  Nvidia Spectrum switches, where the only practical approach to counting
  traffic on offloaded soft netdevices currently is to use router interface
  counters, and count L3 traffic. Correspondingly that is the statistics
  suite added in this patch.

  Other devices may be able to measure different kinds of traffic, and for
  that reason, the APIs are built to allow uniform access to different
  statistics suites.

- Because soft netdevices and offloading drivers are only loosely bound, a
  netdevice uses a notifier chain to communicate with the drivers. Several
  new notifiers, NETDEV_OFFLOAD_XSTATS_*, have been added to carry messages
  to the offloading drivers.

- Devices can have various conditions for when a particular counter is
  available. As the device is configured and reconfigured, the device
  offload may become or cease being suitable for counter binding. A
  netdevice can use a notifier type NETDEV_OFFLOAD_XSTATS_REPORT_USED to
  ping offloading drivers and determine whether anyone currently implements
  a given statistics suite. This information can then be propagated to user
  space.

  When the driver decides to unoffload a netdevice, it can use a
  newly-added function, netdev_offload_xstats_report_delta(), to record
  outstanding collected statistics, before destroying the HW counter.

This patch adds a helper, call_netdevice_notifiers_info_robust(), for
dispatching a notifier with the possibility of unwind when one of the
consumers bails. Given the wish to eventually get rid of the global
notifier block altogether, this helper only invokes the per-netns notifier
block.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/netdevice.h |  42 ++++++
 net/core/dev.c            | 282 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 323 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c79ee2296296..aeafdccaba44 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1950,6 +1950,7 @@ enum netdev_ml_priv_type {
  *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
  *	@dev_registered_tracker:	tracker for reference held while
  *					registered
+ *	@offload_xstats_l3:	L3 HW stats for this netdevice.
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2287,6 +2288,7 @@ struct net_device {
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
 	netdevice_tracker	dev_registered_tracker;
+	struct rtnl_link_stats64 *offload_xstats_l3;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -2727,6 +2729,10 @@ enum netdev_cmd {
 	NETDEV_CVLAN_FILTER_DROP_INFO,
 	NETDEV_SVLAN_FILTER_PUSH_INFO,
 	NETDEV_SVLAN_FILTER_DROP_INFO,
+	NETDEV_OFFLOAD_XSTATS_ENABLE,
+	NETDEV_OFFLOAD_XSTATS_DISABLE,
+	NETDEV_OFFLOAD_XSTATS_REPORT_USED,
+	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
@@ -2777,6 +2783,42 @@ struct netdev_notifier_pre_changeaddr_info {
 	const unsigned char *dev_addr;
 };
 
+enum netdev_offload_xstats_type {
+	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
+};
+
+struct netdev_notifier_offload_xstats_info {
+	struct netdev_notifier_info info; /* must be first */
+	enum netdev_offload_xstats_type type;
+
+	union {
+		/* NETDEV_OFFLOAD_XSTATS_REPORT_DELTA */
+		struct netdev_notifier_offload_xstats_rd *report_delta;
+		/* NETDEV_OFFLOAD_XSTATS_REPORT_USED */
+		struct netdev_notifier_offload_xstats_ru *report_used;
+	};
+};
+
+int netdev_offload_xstats_enable(struct net_device *dev,
+				 enum netdev_offload_xstats_type type,
+				 struct netlink_ext_ack *extack);
+int netdev_offload_xstats_disable(struct net_device *dev,
+				  enum netdev_offload_xstats_type type);
+bool netdev_offload_xstats_enabled(const struct net_device *dev,
+				   enum netdev_offload_xstats_type type);
+int netdev_offload_xstats_get(struct net_device *dev,
+			      enum netdev_offload_xstats_type type,
+			      struct rtnl_link_stats64 *stats, bool *used,
+			      struct netlink_ext_ack *extack);
+void
+netdev_offload_xstats_report_delta(struct netdev_notifier_offload_xstats_rd *rd,
+				   const struct rtnl_link_stats64 *stats);
+void
+netdev_offload_xstats_report_used(struct netdev_notifier_offload_xstats_ru *ru);
+void netdev_offload_xstats_push_delta(struct net_device *dev,
+				      enum netdev_offload_xstats_type type,
+				      const struct rtnl_link_stats64 *stats);
+
 static inline void netdev_notifier_info_init(struct netdev_notifier_info *info,
 					     struct net_device *dev)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..605ef2c04015 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1622,7 +1622,8 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
 	N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
-	N(PRE_CHANGEADDR)
+	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
+	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
@@ -1939,6 +1940,32 @@ static int call_netdevice_notifiers_info(unsigned long val,
 	return raw_notifier_call_chain(&netdev_chain, val, info);
 }
 
+/**
+ *	call_netdevice_notifiers_info_robust - call per-netns notifier blocks
+ *	                                       for and rollback on error
+ *	@val_up: value passed unmodified to notifier function
+ *	@val_down: value passed unmodified to the notifier function when
+ *	           recovering from an error on @val_up
+ *	@info: notifier information data
+ *
+ *	Call all per-netns network notifier blocks, but not notifier blocks on
+ *	the global notifier chain. Parameters and return value are as for
+ *	raw_notifier_call_chain_robust().
+ */
+
+static int
+call_netdevice_notifiers_info_robust(unsigned long val_up,
+				     unsigned long val_down,
+				     struct netdev_notifier_info *info)
+{
+	struct net *net = dev_net(info->dev);
+
+	ASSERT_RTNL();
+
+	return raw_notifier_call_chain_robust(&net->netdev_chain,
+					      val_up, val_down, info);
+}
+
 static int call_netdevice_notifiers_extack(unsigned long val,
 					   struct net_device *dev,
 					   struct netlink_ext_ack *extack)
@@ -7728,6 +7755,257 @@ void netdev_bonding_info_change(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_bonding_info_change);
 
+static int netdev_offload_xstats_enable_l3(struct net_device *dev,
+					   struct netlink_ext_ack *extack)
+{
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.info.extack = extack,
+		.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+	};
+	int err;
+	int rc;
+
+	dev->offload_xstats_l3 = kzalloc(sizeof(*dev->offload_xstats_l3),
+					 GFP_KERNEL);
+	if (!dev->offload_xstats_l3)
+		return -ENOMEM;
+
+	rc = call_netdevice_notifiers_info_robust(NETDEV_OFFLOAD_XSTATS_ENABLE,
+						  NETDEV_OFFLOAD_XSTATS_DISABLE,
+						  &info.info);
+	err = notifier_to_errno(rc);
+	if (err)
+		goto free_stats;
+
+	return 0;
+
+free_stats:
+	kfree(dev->offload_xstats_l3);
+	dev->offload_xstats_l3 = NULL;
+	return err;
+}
+
+int netdev_offload_xstats_enable(struct net_device *dev,
+				 enum netdev_offload_xstats_type type,
+				 struct netlink_ext_ack *extack)
+{
+	ASSERT_RTNL();
+
+	if (netdev_offload_xstats_enabled(dev, type))
+		return -EALREADY;
+
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		return netdev_offload_xstats_enable_l3(dev, extack);
+	}
+
+	WARN_ON(1);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(netdev_offload_xstats_enable);
+
+static void netdev_offload_xstats_disable_l3(struct net_device *dev)
+{
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+	};
+
+	call_netdevice_notifiers_info(NETDEV_OFFLOAD_XSTATS_DISABLE,
+				      &info.info);
+	kfree(dev->offload_xstats_l3);
+	dev->offload_xstats_l3 = NULL;
+}
+
+int netdev_offload_xstats_disable(struct net_device *dev,
+				  enum netdev_offload_xstats_type type)
+{
+	ASSERT_RTNL();
+
+	if (!netdev_offload_xstats_enabled(dev, type))
+		return -EALREADY;
+
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		netdev_offload_xstats_disable_l3(dev);
+		return 0;
+	}
+
+	WARN_ON(1);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(netdev_offload_xstats_disable);
+
+static void netdev_offload_xstats_disable_all(struct net_device *dev)
+{
+	netdev_offload_xstats_disable(dev, NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+}
+
+static struct rtnl_link_stats64 *
+netdev_offload_xstats_get_ptr(const struct net_device *dev,
+			      enum netdev_offload_xstats_type type)
+{
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		return dev->offload_xstats_l3;
+	}
+
+	WARN_ON(1);
+	return NULL;
+}
+
+bool netdev_offload_xstats_enabled(const struct net_device *dev,
+				   enum netdev_offload_xstats_type type)
+{
+	ASSERT_RTNL();
+
+	return netdev_offload_xstats_get_ptr(dev, type);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_enabled);
+
+struct netdev_notifier_offload_xstats_ru {
+	bool used;
+};
+
+struct netdev_notifier_offload_xstats_rd {
+	struct rtnl_link_stats64 stats;
+	bool used;
+};
+
+static void netdev_link_stats64_add(struct rtnl_link_stats64 *dest,
+				    const struct rtnl_link_stats64 *src)
+{
+	dest->rx_packets	  += src->rx_packets;
+	dest->tx_packets	  += src->tx_packets;
+	dest->rx_bytes		  += src->rx_bytes;
+	dest->tx_bytes		  += src->tx_bytes;
+	dest->rx_errors		  += src->rx_errors;
+	dest->tx_errors		  += src->tx_errors;
+	dest->rx_dropped	  += src->rx_dropped;
+	dest->tx_dropped	  += src->tx_dropped;
+	dest->multicast		  += src->multicast;
+	dest->collisions	  += src->collisions;
+	dest->rx_length_errors	  += src->rx_length_errors;
+	dest->rx_over_errors	  += src->rx_over_errors;
+	dest->rx_crc_errors	  += src->rx_crc_errors;
+	dest->rx_frame_errors	  += src->rx_frame_errors;
+	dest->rx_fifo_errors	  += src->rx_fifo_errors;
+	dest->rx_missed_errors	  += src->rx_missed_errors;
+	dest->tx_aborted_errors	  += src->tx_aborted_errors;
+	dest->tx_carrier_errors	  += src->tx_carrier_errors;
+	dest->tx_fifo_errors	  += src->tx_fifo_errors;
+	dest->tx_heartbeat_errors += src->tx_heartbeat_errors;
+	dest->tx_window_errors	  += src->tx_window_errors;
+	dest->rx_compressed	  += src->rx_compressed;
+	dest->tx_compressed	  += src->tx_compressed;
+	dest->rx_nohandler	  += src->rx_nohandler;
+}
+
+static int netdev_offload_xstats_get_used(struct net_device *dev,
+					  enum netdev_offload_xstats_type type,
+					  bool *p_used,
+					  struct netlink_ext_ack *extack)
+{
+	struct netdev_notifier_offload_xstats_ru report_used = {};
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.info.extack = extack,
+		.type = type,
+		.report_used = &report_used,
+	};
+	int rc;
+
+	WARN_ON(!netdev_offload_xstats_enabled(dev, type));
+	rc = call_netdevice_notifiers_info(NETDEV_OFFLOAD_XSTATS_REPORT_USED,
+					   &info.info);
+	*p_used = report_used.used;
+	return notifier_to_errno(rc);
+}
+
+static int netdev_offload_xstats_get_stats(struct net_device *dev,
+					   enum netdev_offload_xstats_type type,
+					   struct rtnl_link_stats64 *p_stats,
+					   bool *p_used,
+					   struct netlink_ext_ack *extack)
+{
+	struct netdev_notifier_offload_xstats_rd report_delta = {};
+	struct netdev_notifier_offload_xstats_info info = {
+		.info.dev = dev,
+		.info.extack = extack,
+		.type = type,
+		.report_delta = &report_delta,
+	};
+	struct rtnl_link_stats64 *stats;
+	int rc;
+
+	stats = netdev_offload_xstats_get_ptr(dev, type);
+	if (WARN_ON(!stats))
+		return -EINVAL;
+
+	rc = call_netdevice_notifiers_info(NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
+					   &info.info);
+
+	/* Cache whatever we got, even if there was an error, otherwise the
+	 * successful stats retrievals would get lost.
+	 */
+	netdev_link_stats64_add(stats, &report_delta.stats);
+
+	if (p_stats)
+		*p_stats = *stats;
+	*p_used = report_delta.used;
+
+	return notifier_to_errno(rc);
+}
+
+int netdev_offload_xstats_get(struct net_device *dev,
+			      enum netdev_offload_xstats_type type,
+			      struct rtnl_link_stats64 *p_stats, bool *p_used,
+			      struct netlink_ext_ack *extack)
+{
+	ASSERT_RTNL();
+
+	if (p_stats)
+		return netdev_offload_xstats_get_stats(dev, type, p_stats,
+						       p_used, extack);
+	else
+		return netdev_offload_xstats_get_used(dev, type, p_used,
+						      extack);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_get);
+
+void
+netdev_offload_xstats_report_delta(struct netdev_notifier_offload_xstats_rd *report_delta,
+				   const struct rtnl_link_stats64 *stats)
+{
+	report_delta->used = true;
+	netdev_link_stats64_add(&report_delta->stats, stats);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_report_delta);
+
+void
+netdev_offload_xstats_report_used(struct netdev_notifier_offload_xstats_ru *report_used)
+{
+	report_used->used = true;
+}
+EXPORT_SYMBOL(netdev_offload_xstats_report_used);
+
+void netdev_offload_xstats_push_delta(struct net_device *dev,
+				      enum netdev_offload_xstats_type type,
+				      const struct rtnl_link_stats64 *p_stats)
+{
+	struct rtnl_link_stats64 *stats;
+
+	ASSERT_RTNL();
+
+	stats = netdev_offload_xstats_get_ptr(dev, type);
+	if (WARN_ON(!stats))
+		return;
+
+	netdev_link_stats64_add(stats, p_stats);
+}
+EXPORT_SYMBOL(netdev_offload_xstats_push_delta);
+
 /**
  * netdev_get_xmit_slave - Get the xmit slave of master device
  * @dev: device
@@ -10417,6 +10695,8 @@ void unregister_netdevice_many(struct list_head *head)
 
 		dev_xdp_uninstall(dev);
 
+		netdev_offload_xstats_disable_all(dev);
+
 		/* Notify protocols, that we are about to destroy
 		 * this device. They should clean all the things.
 		 */
-- 
2.33.1

