Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2CF692958
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjBJVdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjBJVdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:33:38 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FC68219C
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:33:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/GX03T1gggbvwc0MDD4WcGV8v9lWgfNG8rpAe93LRi4S8BS7LEDe8NoR2L4RIzVlCa0q0rNEWssMGJP4RivmcJ9O8b79M2XgNHCnQem0ocd/YWKc9BnKWDx3w4wdGSdohe7APZQhgkJ0iASxdYkdNl3l1mPtq/C8+4dFs5PjXxvRgqfqWHqumNlJmXc3IRJ5EoqzHvGRTp2g3u/iZncJ+rxbKVrtK18ZJUyHBlGW0QMgHFQIinPQsiEYiwG2xBTw11wqWwaymxf/WjlbksFX+C9kJs3K6yLlxYbcJhVKxb6eQAkOgs9iuuEAhl9TedIt2q6xjh0w3txb+PrMz1EcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msQoS2/p+GWKUNEhvQRySfFs0i1XSZN0Yv5VsAp+RWs=;
 b=eBtd8t8cTA55K69ITTsdXLNJEkuFm0Akd9ePIeFPE1ILYzuIZA8NXAWX0NIg1qhsBrxyF83ZOt6JBqMRuIPkCQjnO5VIF1GCvNfcf+EkRoXVn9NlcNmSm7r3aodH1D0bHW3OYum1jgukLGsyiCn5H2tSdpNwKzD/xycT2Y1RrWDIwv8JZGO73nU3Ubot3rZscPzxGO25cPIBaaIx9igP3sB3QXq0b6o+0hQ2R/krpwBLs/W+Z5l7COgn8cTSGS4IlryPM6fqV2Q7oiFMKHvM794+fDtEmGGWx5pGI74Ii5aDDw207nptZshDRVhyQDJF7ftRJokujNZIlHxx8kMTJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msQoS2/p+GWKUNEhvQRySfFs0i1XSZN0Yv5VsAp+RWs=;
 b=JrOHKQ1Zz1BBOJ34UEm47HEvKmAfT3XGxvwu5kPoBAuxfbBivLgWIpj2K31pfp+2sZ8TYtt+JHQeUZWpUyVoDlgKYPqmDSp6iJ0PVH8nA+IZIJZ22nvIugahcTy/OgrEv78OCfCbEKjUf8mxQXZ6inj6ueYXPkquoG9SZxLM29A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6881.eurprd04.prod.outlook.com (2603:10a6:208:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 21:33:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 21:33:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Subject: [PATCH v3 ethtool 1/4] netlink: add support for MAC Merge layer
Date:   Fri, 10 Feb 2023 23:33:08 +0200
Message-Id: <20230210213311.218456-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210213311.218456-1-vladimir.oltean@nxp.com>
References: <20230210213311.218456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:208:122::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef3c484-8df2-4fc3-8c2a-08db0bae718e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jcx0EHCNUxysm6Ri8Xg6rw+lTy3beLUldaTvJWKa3b6IKziw4+Px/wJYzn8HlThg7NjcTjH3zNaYvy33vhqDBq08PUA0TR1QtnsfqgYkTm2zxTRGtiC5i1zOrNkVRtZAx9ILxDT5USJRqVmHBf6ZiFBIwGeAnji9EzhVvyD+SpDaXekOheVNxKJyP/+YwtByYlzGeeOPp7ojozmAN/y5+4nTt8UeKXmmm7g+/uOQjweGk7OsupxntxWOEBXETq8k9g1BcNfJs2nktHdcaeB152OnMovETI6AFKkd6qiL3JNSLb57uQETKCriuo45ObIQDQRDLlpWvXoNOD8ZV3I17eXzwj/8bXXM86n+pJoNNxFkjQ/zq//BrCTPqBOMcCQ6bV/NX3Vl9wK7gZMO854xJZ9YfEgnNyCg9BDcltAY91gq6x4847idj3fh6rTckgcG/p4LVCU9Dh6ppE8nCd4ZtmLwH/KIPFWY7wQC9YcPF+YaH1ksrjvHkSo+iHDiIgWBzXdacop6gWlCxCLefpipwIlpC59NwARY7WX3bLtTwu5VI61LVVLoll7rS/3GxJ3DlsC0/41IBIaoWjpm/LJe40lALh/x5CQDT0NTe9cSLAWpBiBam1PtwtZnNU+SkbeSMbSQpReokR81cNDD92f114rJ9TkNKzSuIxbQb6Ivb5Cs2mSH5PsqJhUxMO+pb6IBEfqNDOr8BN3K6V8Y8/mprA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(186003)(66476007)(6512007)(6666004)(26005)(52116002)(2616005)(478600001)(6486002)(6506007)(83380400001)(66556008)(66946007)(1076003)(54906003)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(5660300002)(30864003)(44832011)(2906002)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dhdmqcc5gBNLmhlaq4TfdZncxmoZu6BbDKxs211HSWX1aaHg39nMmjmZgfaZ?=
 =?us-ascii?Q?UcKIAjeX5cBWx0+aEHR2cdNEs6p5Hwp9I7eKG56QLllhZ2DhWz3QQsK8qzcn?=
 =?us-ascii?Q?nyRkQopB7XSkKwyVTGbw/TJ2sgjQdRSZ3TpgUIWsDgx+vdbEGAh0W2hUIZxx?=
 =?us-ascii?Q?cTfELQrdYvlVgVImJH5zYAwWlnz5fGbVJqOpc3HMs7lCBLhl3r+Z3y3rOAdx?=
 =?us-ascii?Q?EL/NuPHOz86UZ9A8UvrbVrqcRNPjyPyPiCCt5VjHWYxsGeTqr6/jIlJxNLdK?=
 =?us-ascii?Q?bu8ASMS0Y1uO2zPg8nQOr/Ag7kEpFOF/994DR3lLEHB/Wbh91MeHaAD7+nxS?=
 =?us-ascii?Q?9yWO6gytidbIzuv810fC3rsdFUqdEfi5GnR4j/SLg5SOJ0mnpdtjuIvyTAkf?=
 =?us-ascii?Q?miLJxvR9BkT8hjn6tYb3KBnwUOfuhlbOTnKriNmImL1xx5zW7de7WV3Kpv2c?=
 =?us-ascii?Q?UlcOUg9X+HnORWM6oMFyFhP9d3xvmaJYxV99gDfRYr1tt9FG6Yvrn1yPNIUE?=
 =?us-ascii?Q?oVZ8PnoGhNIE5JwsnmPMxv7nYF7luTotZU+iJrEZXBUlTIhh9l0yjIcWfTSL?=
 =?us-ascii?Q?CCy+NM7UyEJiRmUCU/QEnBwv2dnHTvbwRSYDtEhUoDxwwKgrwvb1c5IYZUb4?=
 =?us-ascii?Q?0dMJlpIeCfN2FlkL6nnHiKLrYEDE6RPhluYCBwvVj24IYdaPAgIICkqM28FA?=
 =?us-ascii?Q?fe15yauQx3FpJWnnkELrAgqnmMZkLttSlZR4OYxNzj8c96NPLqwlZy04QCYV?=
 =?us-ascii?Q?A96oANQgNtJEu2LRQRQIj79VA3gsB+RC1c/OZx/AMB4DFjyL/QX2ONnGctXn?=
 =?us-ascii?Q?hDCSDxF/R3i02eVk92hKYO3s33cYV4rW4C0tdsPqXZso7aH15WGal+bfn/Zx?=
 =?us-ascii?Q?9HZ0vHkmzRS29MmvtbsxcCWPAZlfhwXayqvuWGnB7VM3B1VtH84By0CATP3s?=
 =?us-ascii?Q?y8XAPv4mTXkfu7Vp34vBulCLwFk1jtPHvQezabo75BLhjEHhN/5qKFBGSGeZ?=
 =?us-ascii?Q?qtMDnBOHaVB84oPpxNi4jKThtUaAqvgWdD0TBJ/U/MdMY1EyzK7a4f/9+mjp?=
 =?us-ascii?Q?oBCx+ff0myZShZny5NSlGj3w+biqWYaDC+N6U54AFGJmz4sFZJ73Kwu4+e+C?=
 =?us-ascii?Q?1CGG9J5EEaquLGUXXUZjP7jZCqrGX7v7FNZFUMWe65qyPTP+lkKtFZoRGGAW?=
 =?us-ascii?Q?5SIHUmDBeDsPeiHnzj0iVmNcUwpZ0iDNP5LBYTe9wRo/lh8l/yct4TFxXEa/?=
 =?us-ascii?Q?MyR7umf+j1DU2ldEqwpBHAwY/u593sBV7bjt3qhZQ+sxx5NjfhTl/fx3j5fx?=
 =?us-ascii?Q?dQZAPMPVEkklqhE5+2zWoi1pxvQe2yOtc7dt1a7UaCu/40j83+Joc2UwyW9B?=
 =?us-ascii?Q?CU8yRj/fmpxaom7hpRyyoGxz2eYKbL+aX+anJmds38CQOFXup01l4JYXOMPY?=
 =?us-ascii?Q?kZC3OiZ0HXf3aEOBf+ZieOX/gfV4fHXKjBjTaTDlEJev0rRtmSdCNC5qHvVa?=
 =?us-ascii?Q?48hmC6U4Mz9VQP6WMNePce5r/F9lv2sB8En4t9CXr3IgwswINLe10QfbhdQR?=
 =?us-ascii?Q?TCXo8J1QNg47V49Jsx2C/KssL8Nd8RXZTjkIHXZHqtMRqk62umz0sK1M5YlH?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef3c484-8df2-4fc3-8c2a-08db0bae718e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 21:33:26.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Z1CcnZE8bDEHkpGX1tovZ9IKe3ZvargkEnb9AlAFoQcVOztEBW2L9kcif8FBJneXE31WpDYJB+QwSPQuCRkqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ ethtool --include-statistics --show-mm eno0
MAC merge layer state for eno0:
pMAC enabled: on
TX enabled: on
TX active: on
TX minimum fragment size: 60
RX minimum fragment size: 60
Verify enabled: off
Verify time: 127 ms
Max verify time: 127 ms
Verification status: SUCCEEDED
Statistics:
  MACMergeFrameAssErrorCount: 0
  MACMergeFrameSmdErrorCount: 0
  MACMergeFrameAssOkCount: 0
  MACMergeFragCountRx: 0
  MACMergeFragCountTx: 0
  MACMergeHoldCount: 0

$ ethtool --include-statistics --json --show-mm eno0
[ {
        "ifname": "eno0",
        "pmac-enabled": true,
        "tx-enabled": true,
        "tx-active": true,
        "tx-min-frag-size": 60,
        "rx-min-frag-size": 60,
        "verify-enabled": true,
        "verify-time": 127,
        "max-verify-time": 127,
        "verify-status": "SUCCEEDED",
        "statistics": {
            "MACMergeFrameAssErrorCount": 0,
            "MACMergeFrameSmdErrorCount": 0,
            "MACMergeFrameAssOkCount": 0,
            "MACMergeFragCountRx": 0,
            "MACMergeFragCountTx": 0,
            "MACMergeHoldCount": 0
        }
    } ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
v2->v3:
- the pretty nlattr descriptions have already been generated by Michal
- fix stray %u in show_u32()
- remove unintended changes to netlink/parser.c and netlink/parser.h

v1->v2:
- rebase on top of PLCA changes
- ETHTOOL_A_MM_ADD_FRAG_SIZE became ETHTOOL_A_MM_TX_MIN_FRAG_SIZE
- ETHTOOL_A_MM_RX_MIN_FRAG_SIZE was introduced
- ETHTOOL_A_MM_SUPPORTED disappeared
- fix help text for --show-mm
- use the newly introduced show_u32() instead of hand-rolling own
  implementation - show_u32_json()

 Makefile.am      |   2 +-
 ethtool.c        |  16 +++
 netlink/extapi.h |   4 +
 netlink/mm.c     | 270 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 291 insertions(+), 1 deletion(-)
 create mode 100644 netlink/mm.c

diff --git a/Makefile.am b/Makefile.am
index cbc1f4f5fdf2..c83cb18173db 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -38,7 +38,7 @@ ethtool_SOURCES += \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
-		  netlink/stats.c \
+		  netlink/stats.c netlink/mm.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/module-eeprom.c netlink/module.c netlink/rss.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
diff --git a/ethtool.c b/ethtool.c
index 16c88bf7f527..74dfc9dfb66b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6101,6 +6101,22 @@ static const struct option args[] = {
 		.nlfunc	= nl_plca_get_status,
 		.help	= "Get PLCA status information",
 	},
+	{
+		.opts	= "--show-mm",
+		.json	= true,
+		.nlfunc	= nl_get_mm,
+		.help	= "Show MAC merge layer state",
+	},
+	{
+		.opts	= "--set-mm",
+		.nlfunc	= nl_set_mm,
+		.help	= "Set MAC merge layer parameters",
+			  "		[ verify-enabled on|off ]\n"
+			  "		[ verify-time N ]\n"
+			  "		[ tx-enabled on|off ]\n"
+			  "		[ pmac-enabled on|off ]\n"
+			  "		[ tx-min-frag-size 60-252 ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/extapi.h b/netlink/extapi.h
index ce5748ec0532..bbe063342f60 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -51,6 +51,8 @@ int nl_grss(struct cmd_context *ctx);
 int nl_plca_get_cfg(struct cmd_context *ctx);
 int nl_plca_set_cfg(struct cmd_context *ctx);
 int nl_plca_get_status(struct cmd_context *ctx);
+int nl_get_mm(struct cmd_context *ctx);
+int nl_set_mm(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -122,6 +124,8 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_plca_get_cfg		NULL
 #define nl_plca_set_cfg		NULL
 #define nl_plca_get_status	NULL
+#define nl_get_mm		NULL
+#define nl_set_mm		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/mm.c b/netlink/mm.c
new file mode 100644
index 000000000000..d026bc33239e
--- /dev/null
+++ b/netlink/mm.c
@@ -0,0 +1,270 @@
+/*
+ * mm.c - netlink implementation of MAC merge layer settings
+ *
+ * Implementation of "ethtool --show-mm <dev>" and "ethtool --set-mm <dev> ..."
+ */
+
+#include <errno.h>
+#include <inttypes.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "bitset.h"
+#include "parser.h"
+
+/* MM_GET */
+
+static const char *
+mm_verify_state_to_string(enum ethtool_mm_verify_status state)
+{
+	switch (state) {
+	case ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+		return "INITIAL";
+	case ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+		return "VERIFYING";
+	case ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+		return "SUCCEEDED";
+	case ETHTOOL_MM_VERIFY_STATUS_FAILED:
+		return "FAILED";
+	case ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+		return "DISABLED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static int show_mm_stats(const struct nlattr *nest)
+{
+	const struct nlattr *tb[ETHTOOL_A_MM_STAT_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	static const struct {
+		unsigned int attr;
+		char *name;
+	} stats[] = {
+		{ ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS, "MACMergeFrameAssErrorCount" },
+		{ ETHTOOL_A_MM_STAT_SMD_ERRORS, "MACMergeFrameSmdErrorCount" },
+		{ ETHTOOL_A_MM_STAT_REASSEMBLY_OK, "MACMergeFrameAssOkCount" },
+		{ ETHTOOL_A_MM_STAT_RX_FRAG_COUNT, "MACMergeFragCountRx" },
+		{ ETHTOOL_A_MM_STAT_TX_FRAG_COUNT, "MACMergeFragCountTx" },
+		{ ETHTOOL_A_MM_STAT_HOLD_COUNT, "MACMergeHoldCount" },
+	};
+	bool header = false;
+	unsigned int i;
+	size_t n;
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	open_json_object("statistics");
+	for (i = 0; i < ARRAY_SIZE(stats); i++) {
+		char fmt[64];
+
+		if (!tb[stats[i].attr])
+			continue;
+
+		if (!header && !is_json_context()) {
+			printf("Statistics:\n");
+			header = true;
+		}
+
+		if (mnl_attr_validate(tb[stats[i].attr], MNL_TYPE_U64)) {
+			fprintf(stderr, "malformed netlink message (statistic)\n");
+			goto err_close_stats;
+		}
+
+		n = snprintf(fmt, sizeof(fmt), "  %s: %%" PRIu64 "\n",
+			     stats[i].name);
+		if (n >= sizeof(fmt)) {
+			fprintf(stderr, "internal error - malformed label\n");
+			continue;
+		}
+
+		print_u64(PRINT_ANY, stats[i].name, fmt,
+			  mnl_attr_get_u64(tb[stats[i].attr]));
+	}
+	close_json_object();
+
+	return 0;
+
+err_close_stats:
+	close_json_object();
+	return -1;
+}
+
+int mm_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MM_MAX + 1] = {};
+	struct nl_context *nlctx = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_MM_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "MAC Merge layer state for %s:\n",
+		     nlctx->devname);
+
+	show_bool("pmac-enabled", "pMAC enabled: %s\n",
+		  tb[ETHTOOL_A_MM_PMAC_ENABLED]);
+	show_bool("tx-enabled", "TX enabled: %s\n",
+		  tb[ETHTOOL_A_MM_TX_ENABLED]);
+	show_bool("tx-active", "TX active: %s\n", tb[ETHTOOL_A_MM_TX_ACTIVE]);
+	show_u32("tx-min-frag-size", "TX minimum fragment size: ",
+		 tb[ETHTOOL_A_MM_TX_MIN_FRAG_SIZE]);
+	show_u32("rx-min-frag-size", "RX minimum fragment size: ",
+		 tb[ETHTOOL_A_MM_RX_MIN_FRAG_SIZE]);
+	show_bool("verify-enabled", "Verify enabled: %s\n",
+		  tb[ETHTOOL_A_MM_VERIFY_ENABLED]);
+	show_u32("verify-time", "Verify time: ",
+		 tb[ETHTOOL_A_MM_VERIFY_TIME]);
+	show_u32("max-verify-time", "Max verify time: ",
+		 tb[ETHTOOL_A_MM_MAX_VERIFY_TIME]);
+
+	if (tb[ETHTOOL_A_MM_VERIFY_STATUS]) {
+		u8 val = mnl_attr_get_u8(tb[ETHTOOL_A_MM_VERIFY_STATUS]);
+
+		print_string(PRINT_ANY, "verify-status", "Verification status: %s\n",
+			     mm_verify_state_to_string(val));
+	}
+
+	if (tb[ETHTOOL_A_MM_STATS]) {
+		ret = show_mm_stats(tb[ETHTOOL_A_MM_STATS]);
+		if (ret) {
+			fprintf(stderr, "Failed to print stats: %d\n", ret);
+			goto err;
+		}
+	}
+
+	if (!silent)
+		print_nl();
+
+	close_json_object();
+
+	return MNL_CB_OK;
+
+err:
+	close_json_object();
+	return err_ret;
+}
+
+int nl_get_mm(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	u32 flags;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MM_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	flags = get_stats_flag(nlctx, ETHTOOL_MSG_MM_GET, ETHTOOL_A_MM_HEADER);
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_MM_GET,
+				      ETHTOOL_A_MM_HEADER, flags);
+	if (ret)
+		return ret;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, mm_reply_cb);
+	delete_json_obj();
+	return ret;
+}
+
+/* MM_SET */
+
+static const struct param_parser mm_set_params[] = {
+	{
+		.arg		= "verify-enabled",
+		.type		= ETHTOOL_A_MM_VERIFY_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "verify-time",
+		.type		= ETHTOOL_A_MM_VERIFY_TIME,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-enabled",
+		.type		= ETHTOOL_A_MM_TX_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "pmac-enabled",
+		.type		= ETHTOOL_A_MM_PMAC_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-min-frag-size",
+		.type		= ETHTOOL_A_MM_TX_MIN_FRAG_SIZE,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_set_mm(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MM_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "--set-mm";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_MM_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret)
+		return ret;
+
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_MM_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, mm_set_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret)
+		return ret;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret)
+		return nlctx->exit_code;
+
+	return 0;
+}
-- 
2.34.1

