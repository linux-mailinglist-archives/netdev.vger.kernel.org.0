Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0CF66E25E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbjAQPhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjAQPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C67941B5F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+FfjBFo2OCuXppiBmhEzUn2MfEFMg6W3XTiu9Y3CGuSaaS9Fx7+dz0G4DDr5X96nPZduyDKGeOqZxNMNFmqTom73xqNNEJAPGuqfFuEA57KDeCASuAhlHwP1rRwviK/Gas3tlIkL9AwrbF91txIR46Ld6SyKcIqmjVISTIZ5EvMZLtpiQrrIS+yv2SvIMpe2AZdExQdT0S9MltVCs+ySwYqwcCDFEPvIvpYnou7ngNDzOLvwsvUTuLI1cqq28OHts56gEmR7PGcbp/XQTENwjRTDfLFOoNnwzYJTXHR1dIq5aP3Sig2b66JxG/eiAghlweuGWWRGp0q/sDusbIkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P56R7WReoYDemsu9ymt00Msl0UfMxMwqcl8yjLkS/cY=;
 b=SZPqQmXrUXvBA3qjnInhCp+6wMLnOnB6RAEMMy3R0oAKxPe292RfQum9Z97Ktf+AwJENwWl/XgJNswmLNleVC9pF0Ob7jJHnzX9DawBzQCjktNU8tc2fCFvdJ96UIy2VBS2jFRT4/toY06fKP5DehtnWZDyliOKvm9K+xvQFVvCiXRyqvwq8gaMbgxg7urp5VxwdbcN6Loa17QKXElj6gDCCfUXs5WXczj1IgSkVxE4SIIdm82+CMQuCOldfcEaSRBhUEZ7sMN73A9RH32mBH67cD9uWhzybbaxVA5lmC2rQAZPNQZdQrIHBGeJtXaLpVw56s50rIT8BRvrovLG4nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P56R7WReoYDemsu9ymt00Msl0UfMxMwqcl8yjLkS/cY=;
 b=GWwF9AnYX4IjI2FR7TQlXd1WgVSESvt9vMT+HtnPDnPKjm1jRlW8mWv91Bz9BIgoEWC2NspSeTN5naWSuwBJGA1D6oEWmB29HBkZ8g90f7RGPZSxyJXO6bC4w4POodgt66m4eUUXmuIe1vniCZsQF1tHVIltUW8J7baY2jEm/K6WifE/plITjv8rC04BebQE9Z39h4euI1Bs+wOnSRhtKogkEEMsUi5p+cESBowWQaTC4uTeySLlmscCz52iP8iRbS8VOwliseu2b6RmJ8ITFxiiFmGHsiFbQQSKwjRxclfCMK+iDzcoBqJXRXnUUgSvL+FpMsRN208b+U+HPKlkdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:36:23 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:23 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations for caps and stats
Date:   Tue, 17 Jan 2023 17:35:13 +0200
Message-Id: <20230117153535.1945554-4-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d0f4677-63b9-4722-fe30-08daf8a09689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMwXWEI0TP29vlzlnrPYu251fqglp1N+IeOVWKr9SY4/mlozBV5UWYYLLut4WR4ownP8P7qBJUF5j5mO8LN4f2NfiwlOo+sfAaLxDVSZ8cnQBIwjleH7NYevwvoUrWSYsC+ciYIU3MGlpmYZ5hcrfQ/1eHyYLXGOsQ46vpChD5IL/XpW3tGrwsfj2ypYSyGga43w8mHDV/BC1fjImOCfPxMvzYvJSzgzKQoT4qyP84U6PhNC0pxQ3NcQ/tnJUKwixeIfNhVlYrjDu77iVpSoiwGZzyz7aUBNz8fh9Wneu5lXn20RX/2O48zCODMXzxMe9TjkNZiBmjNgBk//fdUXW+T+ywFlevef0/lDphwftcCEmNSv3/ZDQ10/TRwT/bZVB5RRwcVNNxlDgn4tMuyvpkQu4eu+K2TK3JnWGb/pT2CMLNFPKOjxmwZr7vfhBqAe/ZJGhsdxVkaowH0iilxTy0tKZQoqnCic93Qh6G7xIL60Oocr8WTEtp4nV89pflJVXabG4z9oWDI2QjRw4HOuDz+V0GyujCvl4afKruVsfcTvnxGVPRjoxw+Gb4CEOT+5T92FaekzKFedcJvKSMAsPPVakJS2hJBYZMT8A9uPdJiqLbbCr9soXYU9nu3ErNsUU+8AWbybyeXlGYmTWGjiDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(2906002)(66946007)(26005)(4326008)(36756003)(8676002)(66476007)(66556008)(41300700001)(186003)(6512007)(1076003)(6666004)(107886003)(6506007)(2616005)(83380400001)(86362001)(316002)(38100700002)(6486002)(478600001)(8936002)(30864003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yBa5dq3OiWTRjFp4y6ncAdRUO7ihq0hOYgKw1KLyLlCz1z91GZZHThL0oTTd?=
 =?us-ascii?Q?AlAF2lgSb3HSM+f9cgYCeVDeMQVZLY4VZwMniIgKZCviaUF2FfHlWZqEPwLL?=
 =?us-ascii?Q?56NTZQNHH2xL9Sx2dRvSn7COM07bEk8AFdcaWZw0JJ0W63BbeOMQzrxS1+Cc?=
 =?us-ascii?Q?/YJkMCcJz1QF9Z9ZJMxRsbP8vhrfWGbE3qODkL3Z8v8OYUEbo4zqfn9Kj+XS?=
 =?us-ascii?Q?Ii39iQb6zDt6KkZeN26XfUTrxwisuXl7MvBdB2YaetMSAR5xKFz6FOCRX25n?=
 =?us-ascii?Q?8MCKArbzsZaKRCOV++NRAvFlD/43hsFo+/G1H5pdPRBlF99i6Z+1KI7PBeg0?=
 =?us-ascii?Q?prDWoRWn1aei3TmBduyR9vGcTzb6JZAJ+xTe2+sBQKcjFQMuosYkwchs1ytJ?=
 =?us-ascii?Q?C39mgEBsguhwwXzJ+EMwUSKPDvdELyD421grw4ZwWes1OVZ5mGal7OVFvLis?=
 =?us-ascii?Q?e8xHpVo9ggIBeKhD9t+G/8qg2NvE+aSMJT51+/p99VXUk7ww8BElZC3XEJ45?=
 =?us-ascii?Q?qw5O0mC+vm3dornZXZXGqCuGyRELzT00+q2QCJDF7IduxV1pflf94kv+weCX?=
 =?us-ascii?Q?ypGpuJI9JMsWeSqUC4nH2nhinsQbojFFWGvHmKdQgY+vGN6flrApm618T5nu?=
 =?us-ascii?Q?r++4aus91g4eL/aRpf9+UlitKRmyiW2yM8A++ZEAXNAaLYpTOKYU+8+Smfbw?=
 =?us-ascii?Q?AUGCMnRqt8MCXMATNVF2gpNHzfsp4R6t3uvSGEXH4/PSCwaf8ra99KX2Y0FZ?=
 =?us-ascii?Q?yK669PQjmFkMkTloOS4jRCpwb5h4hQghFEMbKDOlB66ZMt3yoAKAQhJriKV2?=
 =?us-ascii?Q?Cjp8xC5uFYkdG+NflYS0MVH6fRlzxQoCgaJuKUa7Ir2doHeBH5Awe3GOEcKo?=
 =?us-ascii?Q?64jQJRikLm0iohX20JT1ZGnH3hPjTv3O/egnJWcTwyUG4xu/WbIz5+MSggwE?=
 =?us-ascii?Q?kjk/1YSH0+K6rbeiG6djNxqepK+w7tjIhWGiq1ck9s+jvjZkj5lJRnW3mpU2?=
 =?us-ascii?Q?fxcq/3QoKMCtIo7OQom0BE+KdsO+9JIzH99+Mc7Eklq63ubA8ib43BdwSLRX?=
 =?us-ascii?Q?MJsfKquJNhHhcJJYPQEFDFakoIM+eq6b2VUQc6OU5fKkfIq+/Q9Swoen/xZp?=
 =?us-ascii?Q?rZbtQxnXTx3zISBYNvbJjjyNcnPmmj7GzSyJvB3Bd822LIEzXZZdq15F9/Zw?=
 =?us-ascii?Q?cNL/cU8n5N7rn7apF/zarzKeq+JWUECl3eg7q6CDDqGwCNRRwymEUSgh7CWQ?=
 =?us-ascii?Q?RsefvAVDUSNRSiiZW0LbL5TqbgPn2J3l4HAVhQCyInDk+iu2MhR1jcwT7TKr?=
 =?us-ascii?Q?V4dUInxiXQxt3Hd+VdDfDvKx264/NKrmuV3UX9tUprnK6S7RFXaKe/VhI6JV?=
 =?us-ascii?Q?yH/3wAPUaNptrZpoZ+IUpepXdbf7H9TKNXF/YpQSJtJj1MLHodrbSN1L2NF7?=
 =?us-ascii?Q?PPiAfUu0lxUoDwlYhBwCq5vjdKYhKEpeYxqN43+Uc/0vemcHxCbc+8G8cS6P?=
 =?us-ascii?Q?N+Ao37X+iWP2Qt9jr9GnFU7uOFMnQXtYdQlxCcRHcaANkfsz2qgnA6E58Wr2?=
 =?us-ascii?Q?OODYdopFNX1k3uebL6wG6rIYiZ8gr25ra/nSuXrl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0f4677-63b9-4722-fe30-08daf8a09689
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:23.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0gyaZna52JnZ99FXlBm+6yteKqrqwOOSjsTKkJ6D5ocw5q3e3swPCyeq6Tea88tpQOA7T48lQGZqYzIbDzL+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds:

- 2 new netlink messages:
  * ULP_DDP_GET: returns a bitset of supported and active capabilities
  * ULP_DDP_SET: tries to activate requested bitset and returns results

- 2 new netdev ethtool_ops operations:
  * ethtool_ops->get_ulp_ddp_stats(): retrieve device statistics
  * ethtool_ops->set_ulp_ddp_capabilities(): try to apply
    capability changes

ULP DDP capabilities handling is similar to netdev features
handling.

If a ULP_DDP_GET message has requested statistics via the
ETHTOOL_FLAG_STATS header flag, then per-device statistics are
returned to userspace.

Similar to netdev features, ULP_DDP_GET capabilities and statistics
can be returned in a verbose (default) or compact form (if
ETHTOOL_FLAG_COMPACT_BITSET is set in header flags).

Verbose statistics are nested as follows:

    STATS (nest)
        COUNT (u32)
        MAP (nest)
            ITEM (nest)
                NAME (strz)
                VAL  (u64)
            ...

Compact statistics are nested as follows:

    STATS (nest)
        COUNT (u32)
        COMPACT_VALUES (array of u64)

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/ethtool.h              |   6 +
 include/uapi/linux/ethtool_netlink.h |  49 ++++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/netlink.c                |  17 ++
 net/ethtool/netlink.h                |   4 +
 net/ethtool/ulp_ddp.c                | 399 +++++++++++++++++++++++++++
 6 files changed, 476 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/ulp_ddp.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 1783a4402686..016a3a1cc3ff 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -692,6 +692,10 @@ enum {
  *	plugged-in.
  * @set_module_power_mode: Set the power mode policy for the plug-in module
  *	used by the network device.
+ * @get_ulp_ddp_stats: Query ULP DDP statistics. Return the number of
+ *	counters or -1 or error.
+ * @set_ulp_ddp_capabilities: Set device ULP DDP capabilities.
+ *	Returns a negative error code or zero.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -830,6 +834,8 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	int	(*get_ulp_ddp_stats)(struct net_device *dev, struct ethtool_ulp_ddp_stats *stats);
+	int	(*set_ulp_ddp_capabilities)(struct net_device *dev, unsigned long *bits);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 83557cae0b87..3218bc1f081e 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -55,6 +55,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_CFG,
 	ETHTOOL_MSG_PLCA_SET_CFG,
 	ETHTOOL_MSG_PLCA_GET_STATUS,
+	ETHTOOL_MSG_ULP_DDP_GET,
+	ETHTOOL_MSG_ULP_DDP_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -105,6 +107,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
 	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
 	ETHTOOL_MSG_PLCA_NTF,
+	ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	ETHTOOL_MSG_ULP_DDP_SET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -922,6 +926,51 @@ enum {
 	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
 };
 
+/* ULP DDP */
+
+enum {
+	ETHTOOL_A_ULP_DDP_UNSPEC,
+	ETHTOOL_A_ULP_DDP_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_ULP_DDP_HW,				/* bitset */
+	ETHTOOL_A_ULP_DDP_ACTIVE,			/* bitset */
+	ETHTOOL_A_ULP_DDP_WANTED,			/* bitset */
+	ETHTOOL_A_ULP_DDP_STATS,			/* nest - _A_ULP_DDP_STATS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_CNT,
+	ETHTOOL_A_ULP_DDP_MAX = __ETHTOOL_A_ULP_DDP_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_COUNT,			/* u32 */
+	ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES,		/* array, u64 */
+	ETHTOOL_A_ULP_DDP_STATS_MAP,			/* nest - _A_ULP_DDP_STATS_MAP_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAX = __ETHTOOL_A_ULP_DDP_STATS_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_MAP_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM,		/* next - _A_ULP_DDP_STATS_MAP_ITEM_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_MAP_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_MAX = __ETHTOOL_A_ULP_DDP_STATS_MAP_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME,		/* string */
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_VAL,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_MAX = __ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 563864c1bf5a..68a1114ec838 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
-		   pse-pd.o plca.o
+		   pse-pd.o plca.o ulp_ddp.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9f924875bba9..5cfdc989540c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -290,6 +290,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_CFG]	= &ethnl_plca_cfg_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
+	[ETHTOOL_MSG_ULP_DDP_GET]	= &ethnl_ulp_ddp_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1076,6 +1077,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_plca_get_status_policy,
 		.maxattr = ARRAY_SIZE(ethnl_plca_get_status_policy) - 1,
 	},
+	{
+		.cmd    = ETHTOOL_MSG_ULP_DDP_GET,
+		.doit   = ethnl_default_doit,
+		.start  = ethnl_default_start,
+		.dumpit = ethnl_default_dumpit,
+		.done   = ethnl_default_done,
+		.policy = ethnl_ulp_ddp_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_ULP_DDP_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_ulp_ddp,
+		.policy = ethnl_ulp_ddp_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f271266f6e28..6e7378c9f27f 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -349,6 +349,7 @@ extern const struct ethnl_request_ops ethnl_pse_request_ops;
 extern const struct ethnl_request_ops ethnl_rss_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_cfg_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_status_request_ops;
+extern const struct ethnl_request_ops ethnl_ulp_ddp_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -393,6 +394,8 @@ extern const struct nla_policy ethnl_rss_get_policy[ETHTOOL_A_RSS_CONTEXT + 1];
 extern const struct nla_policy ethnl_plca_get_cfg_policy[ETHTOOL_A_PLCA_HEADER + 1];
 extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1];
 extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
+extern const struct nla_policy ethnl_ulp_ddp_get_policy[ETHTOOL_A_ULP_DDP_HEADER + 1];
+extern const struct nla_policy ethnl_ulp_ddp_set_policy[ETHTOOL_A_ULP_DDP_WANTED + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -414,6 +417,7 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/ulp_ddp.c b/net/ethtool/ulp_ddp.c
new file mode 100644
index 000000000000..a6ef79ddcb39
--- /dev/null
+++ b/net/ethtool/ulp_ddp.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * ulp_ddp.c
+ *     Author: Aurelien Aptel <aaptel@nvidia.com>
+ *     Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
+ */
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+#include <net/ulp_ddp_caps.h>
+
+static struct ulp_ddp_netdev_caps *netdev_ulp_ddp_caps(struct net_device *dev)
+{
+#ifdef CONFIG_ULP_DDP
+	return &dev->ulp_ddp_caps;
+#else
+	return NULL;
+#endif
+}
+
+/* ULP_DDP_GET */
+
+struct ulp_ddp_req_info {
+	struct ethnl_req_info	base;
+};
+
+struct ulp_ddp_reply_data {
+	struct ethnl_reply_data	base;
+	DECLARE_BITMAP(hw, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(active, ULP_DDP_C_COUNT);
+	struct ethtool_ulp_ddp_stats stats;
+};
+
+#define ULP_DDP_REPDATA(__reply_base) \
+	container_of(__reply_base, struct ulp_ddp_reply_data, base)
+
+const struct nla_policy ethnl_ulp_ddp_get_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+/* When requested (ETHTOOL_FLAG_STATS) ULP DDP stats are appended to
+ * the response.
+ *
+ * Similar to bitsets, stats can be in a compact or verbose form.
+ *
+ * The verbose form is as follow:
+ *
+ * STATS (nest)
+ *     COUNT (u32)
+ *     MAP (nest)
+ *         ITEM (nest)
+ *             NAME (strz)
+ *             VAL  (u64)
+ *         ...
+ *
+ * The compact form is as follow:
+ *
+ * STATS (nest)
+ *     COUNT (u32)
+ *     COMPACT_VALUES (array of u64)
+ *
+ */
+static int ulp_ddp_stats64_size(const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base,
+				ethnl_string_array_t names,
+				unsigned int count,
+				bool compact)
+{
+	unsigned int len = 0;
+	unsigned int i;
+
+	/* count */
+	len += nla_total_size(sizeof(u32));
+
+	if (compact) {
+		/* values */
+		len += nla_total_size(count * sizeof(u64));
+	} else {
+		unsigned int maplen = 0;
+
+		for (i = 0; i < count; i++) {
+			unsigned int itemlen = 0;
+
+			/* name */
+			itemlen += ethnl_strz_size(names[i]);
+			/* value */
+			itemlen += nla_total_size(sizeof(u64));
+
+			/* item nest */
+			maplen += nla_total_size(itemlen);
+		}
+
+		/* map nest */
+		len += nla_total_size(maplen);
+	}
+	/* outermost nest */
+	return nla_total_size(len);
+}
+
+static int ulp_ddp_put_stats64(struct sk_buff *skb, int attrtype, const u64 *val,
+			       unsigned int count, ethnl_string_array_t names, bool compact)
+{
+	struct nlattr *nest;
+	struct nlattr *attr;
+
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_ULP_DDP_STATS_COUNT, count))
+		goto nla_put_failure;
+	if (compact) {
+		unsigned int nbytes = count * sizeof(*val);
+		u64 *dst;
+
+		attr = nla_reserve(skb, ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES, nbytes);
+		if (!attr)
+			goto nla_put_failure;
+		dst = nla_data(attr);
+		memcpy(dst, val, nbytes);
+	} else {
+		struct nlattr *map;
+		unsigned int i;
+
+		map = nla_nest_start(skb, ETHTOOL_A_ULP_DDP_STATS_MAP);
+		if (!map)
+			goto nla_put_failure;
+		for (i = 0; i < count; i++) {
+			attr = nla_nest_start(skb, ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM);
+			if (!attr)
+				goto nla_put_failure;
+			if (ethnl_put_strz(skb, ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME, names[i]))
+				goto nla_put_failure;
+			if (nla_put_u64_64bit(skb, ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_VAL,
+					      val[i], -1))
+				goto nla_put_failure;
+			nla_nest_end(skb, attr);
+		}
+		nla_nest_end(skb, map);
+	}
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int ulp_ddp_prepare_data(const struct ethnl_req_info *req_base,
+				struct ethnl_reply_data *reply_base,
+				struct genl_info *info)
+{
+	struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	const struct ethtool_ops *ops = reply_base->dev->ethtool_ops;
+	struct net_device *dev = reply_base->dev;
+	struct ulp_ddp_netdev_caps *caps;
+
+	caps = netdev_ulp_ddp_caps(dev);
+	if (!caps)
+		return -EOPNOTSUPP;
+
+	bitmap_copy(data->hw, caps->hw, ULP_DDP_C_COUNT);
+	bitmap_copy(data->active, caps->active, ULP_DDP_C_COUNT);
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		if (!ops->get_ulp_ddp_stats)
+			return -EOPNOTSUPP;
+		ops->get_ulp_ddp_stats(dev, &data->stats);
+	}
+	return 0;
+}
+
+static int ulp_ddp_reply_size(const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	unsigned int len = 0;
+	int ret;
+
+	ret = ethnl_bitset_size(data->hw, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset_size(data->active, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		ret = ulp_ddp_stats64_size(req_base, reply_base,
+					   ulp_ddp_stats_names, __ETH_ULP_DDP_STATS_CNT,
+					   compact);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+	return len;
+}
+
+static int ulp_ddp_fill_reply(struct sk_buff *skb,
+			      const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	int ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_HW, data->hw,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_ACTIVE, data->active,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		ret = ulp_ddp_put_stats64(skb, ETHTOOL_A_ULP_DDP_STATS,
+					  (u64 *)&data->stats,
+					  __ETH_ULP_DDP_STATS_CNT,
+					  ulp_ddp_stats_names,
+					  compact);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
+const struct ethnl_request_ops ethnl_ulp_ddp_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_ULP_DDP_GET,
+	.reply_cmd		= ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_ULP_DDP_HEADER,
+	.req_info_size		= sizeof(struct ulp_ddp_req_info),
+	.reply_data_size	= sizeof(struct ulp_ddp_reply_data),
+
+	.prepare_data		= ulp_ddp_prepare_data,
+	.reply_size		= ulp_ddp_reply_size,
+	.fill_reply		= ulp_ddp_fill_reply,
+};
+
+/* ULP_DDP_SET */
+
+const struct nla_policy ethnl_ulp_ddp_set_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_ULP_DDP_WANTED]	= { .type = NLA_NESTED },
+};
+
+static int ulp_ddp_send_reply(struct net_device *dev, struct genl_info *info,
+			      const unsigned long *wanted,
+			      const unsigned long *wanted_mask,
+			      const unsigned long *active,
+			      const unsigned long *active_mask, bool compact)
+{
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len = 0;
+	int ret;
+
+	reply_len = ethnl_reply_header_size();
+	ret = ethnl_bitset_size(wanted, wanted_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+	ret = ethnl_bitset_size(active, active_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+
+	ret = -ENOMEM;
+	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_ULP_DDP_SET_REPLY,
+				ETHTOOL_A_ULP_DDP_HEADER, info,
+				&reply_payload);
+	if (!rskb)
+		goto err;
+
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_WANTED, wanted,
+			       wanted_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_ACTIVE, active,
+			       active_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+
+	genlmsg_end(rskb, reply_payload);
+	ret = genlmsg_reply(rskb, info);
+	return ret;
+
+nla_put_failure:
+	nlmsg_free(rskb);
+	WARN_ONCE(1, "calculated message payload length (%d) not sufficient\n",
+		  reply_len);
+err:
+	GENL_SET_ERR_MSG(info, "failed to send reply message");
+	return ret;
+}
+
+int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info)
+{
+	DECLARE_BITMAP(old_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(new_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_wanted, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_mask, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(all_bits, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(tmp, ULP_DDP_C_COUNT);
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct ulp_ddp_netdev_caps *caps;
+	struct net_device *dev;
+	int ret;
+
+	if (!tb[ETHTOOL_A_ULP_DDP_WANTED])
+		return -EINVAL;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_ULP_DDP_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+	rtnl_lock();
+	caps = netdev_ulp_ddp_caps(dev);
+	if (!caps) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
+	ret = ethnl_parse_bitset(req_wanted, req_mask, ULP_DDP_C_COUNT,
+				 tb[ETHTOOL_A_ULP_DDP_WANTED],
+				 ulp_ddp_caps_names, info->extack);
+	if (ret < 0)
+		goto out_rtnl;
+
+	/* if (req_mask & ~all_bits) */
+	bitmap_fill(all_bits, ULP_DDP_C_COUNT);
+	bitmap_andnot(tmp, req_mask, all_bits, ULP_DDP_C_COUNT);
+	if (!bitmap_empty(tmp, ULP_DDP_C_COUNT)) {
+		ret = -EINVAL;
+		goto out_rtnl;
+	}
+
+	/* new_active = (old_active & ~req_mask) | (wanted & req_mask)
+	 * new_active &= caps_hw
+	 */
+	bitmap_copy(old_active, caps->active, ULP_DDP_C_COUNT);
+	bitmap_and(req_wanted, req_wanted, req_mask, ULP_DDP_C_COUNT);
+	bitmap_andnot(new_active, old_active, req_mask, ULP_DDP_C_COUNT);
+	bitmap_or(new_active, new_active, req_wanted, ULP_DDP_C_COUNT);
+	bitmap_and(new_active, new_active, caps->hw, ULP_DDP_C_COUNT);
+	if (!bitmap_equal(old_active, new_active, ULP_DDP_C_COUNT)) {
+		ret = dev->ethtool_ops->set_ulp_ddp_capabilities(dev, new_active);
+		if (ret)
+			netdev_err(dev, "set_ulp_ddp_capabilities() returned error %d\n", ret);
+		bitmap_copy(new_active, caps->active, ULP_DDP_C_COUNT);
+	}
+
+	ret = 0;
+	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
+		DECLARE_BITMAP(wanted_diff_mask, ULP_DDP_C_COUNT);
+		DECLARE_BITMAP(active_diff_mask, ULP_DDP_C_COUNT);
+		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+
+		/* wanted_diff_mask = req_wanted ^ new_active
+		 * active_diff_mask = old_active ^ new_active -> mask of bits that have changed
+		 * wanted_diff_mask &= req_mask    -> mask of bits that have diff value than wanted
+		 * req_wanted &= wanted_diff_mask  -> bits that have diff value than wanted
+		 * new_active &= active_diff_mask  -> bits that have changed
+		 */
+		bitmap_xor(wanted_diff_mask, req_wanted, new_active, ULP_DDP_C_COUNT);
+		bitmap_xor(active_diff_mask, old_active, new_active, ULP_DDP_C_COUNT);
+		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask, ULP_DDP_C_COUNT);
+		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,  ULP_DDP_C_COUNT);
+		bitmap_and(new_active, new_active, active_diff_mask,  ULP_DDP_C_COUNT);
+		ret = ulp_ddp_send_reply(dev, info,
+					 req_wanted, wanted_diff_mask,
+					 new_active, active_diff_mask,
+					 compact);
+	}
+
+out_rtnl:
+	rtnl_unlock();
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
-- 
2.31.1

