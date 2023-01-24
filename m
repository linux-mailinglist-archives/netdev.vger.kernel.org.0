Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEFF679B9B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbjAXOV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbjAXOVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:21:24 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ED91703
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:21:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIMLSFTLSrc6Q4LRyIqQFFFnA4YGrP5LLa9DNSy23qxfN65qlk4eqXDbFOMEVboB/KsPYf7cYaE7w0mjVaLwhDpCwXMzdbr5t6o1Qft9gM4fKJ+dW9uDZ3vprIiQ51j+eu27U8VKc8aSJLfPBnA6zHmenVSNZN8kut/MtOMEEznN4grr/8yaVRh7SS0gCLAcKoJx88N7u4ZLKi8y9d4fLAA+OTbXgyNkQgBDCn5cpIaRL8T7gHW/CT2TgbAtoF3EGqF3B5nK91iaLGdbgbrDmyySVq5Opvz6HK/6kplwc9sUMsyOR83OKXADpyCbe6HM1pomnXTH2z3uOqhoTU0Mrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9Z+G9OcrpQ74u6BMQGPF3P/WBmGGy2OIkSNLTns0po=;
 b=cV2DJiA5dFPRquyaZxmCITdj2l3LWiBy2Ho9E2HJsKzuuXhRs8OfIXYvX++W9bmfrxXlSPFELYYRSyJSTnukTwyuF88y+Df4bn6oWLAIK8qBAdXy9S7jsCFwzekTmxmbgySovxy3FJS01ReH8jC2LZN3erUFraMMPgWaVmNKdj92m0L3tvxbD/wf7wDKphYgkt/LqxBIAH2/tBbpJEQq0w/DSjU1QYxJ4veBxIkezg3idK+oXsBk7EH0azVVi7i9oEBf0NP+pQ06dYx7FTtyjpD7R+Zg3j4epOezycQRoZXdNeejOcuwqzKXSgKMAabjf4WPlzz2JySUckDs3AQSiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9Z+G9OcrpQ74u6BMQGPF3P/WBmGGy2OIkSNLTns0po=;
 b=eq/j33c9TgZXgMlGo9IHUN+4GePCRf1X8Y5qVuMDfKVtpH5kHL6BHRtlQ5MWK1QrRaHpnb1lPFVD58nx+kiVXU9q+N/bNs63YlyJyBf3/rIlJUy14xx3/No8vtJ7bNdTUQkKxMVeqwIo1eLAGBIwODxz355Ma1L103Ule+B/k2E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7024.eurprd04.prod.outlook.com (2603:10a6:800:124::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:21:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:21:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 ethtool 2/5] netlink: add support for MAC Merge layer
Date:   Tue, 24 Jan 2023 16:20:53 +0200
Message-Id: <20230124142056.3778131-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
References: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: e7af3c10-0a34-4018-1046-08dafe163e18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLxMpKVlnmtwKiqLsT3Q4zC9TujMRpPc3Pc5v2Q5G3NOw81zi3gwZ9u5EA5gSAOfVjXaNyUWdnDZmSI+5t7xodia//45q2SDs9q5ske1Zf7FPUWUuy0rt2LjAr0GuQGbZd+X5wdU9OwvVKuDzccG4JpSH6vO29OlmqUZB86uFVw7vadXdKaZrgpApT6h2qBBH5mWaWGM6P3b7urFgJB9OyrkMgBQYtDiVZ7pdTXKq0udQSKH/qZAoAXknK2zQBPwtydHJpiCcocrP2NlHybrcjplNR5vsUGOZJ8Nugf/gAnjo04SueWCqmnHWu1OTlzpurO5Jo+7P0Jn/ODzX+cl2jBmvkVglNCp0CZWqWvDHGie0hSJHnIBfce0aplj4bU0wNRnsStwgFKITBXhi678jlveZg0woza07HUTwYmugUfIgPYr9GVsDbfwqNrAeQl6MqPdFGCYz+us4Qo4uMmSYNbW8GdDcw3X2mz5vZU79tE/M19vc2nVnmPB7/RJnQPN7OCJvO+HwPmrNfTCszIsmjGGUGtr+EbXAjo2aABWMy+UdLwOv1LOBQRrLYlb1VEQmCntco9ASTFHbj47NjYH3KZ20TlslekJl+0+MzcMYkdAfBfRR644oUJGtcMzGMrLdxuvSFDC9aSNq428wJut13nFZMjK7KX2gk91pOZHDyNc59Bu5lwVGm/iz03Algc5lu4uJc+teEe3oIaJxeNiHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(83380400001)(38100700002)(38350700002)(2906002)(86362001)(30864003)(44832011)(8936002)(5660300002)(41300700001)(4326008)(186003)(6916009)(8676002)(6512007)(26005)(6506007)(316002)(6666004)(66556008)(2616005)(66476007)(54906003)(1076003)(66946007)(478600001)(6486002)(52116002)(45080400002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7/R26AGPRsyWyiC2bqQ1NfV1io431RvhyIjJciP8j0gS2h+918QHPHqgDhp8?=
 =?us-ascii?Q?WIuyARz6xvibgVua+BdG29rhwKsO+IR0R6oolOQ22rQnJaE6GQi/JxS9bApK?=
 =?us-ascii?Q?45wh7j5pU/bUYpL+lBeiAXnCXrkw/zLD2u68WCtuxhMgnihToWUZNyXx6QPM?=
 =?us-ascii?Q?KYXfVISyPtVAcQ1hLHaAi83umGy8hkayE7we+tcNwUCRVEtc2mqndLmYeeyY?=
 =?us-ascii?Q?JhK7p6NAhXSnWFObbl+ayjhjGKINJ9ITEYVbXVnhtFBBrWhvFbgEBX2pVWXx?=
 =?us-ascii?Q?Ok7iD18e/nfMzoysgpjoSxa3ndGBWxSV0CA1OL3JW8ltaHyVMu0Z1an5qXVO?=
 =?us-ascii?Q?zOWrI2adyKugZRIOlS1Lg0nrhBjFKT0TUsMlLfS2lrLCbVmGXGydE9Hg8lEP?=
 =?us-ascii?Q?UgWajq3b0By35PQ5w9d2M4uU1U9ciSWZIEnEDQ5cWg0Eoms8+yUjhBFfZfxi?=
 =?us-ascii?Q?kDeSTO7bO+M4GQvW1zQMlU3AplomKpPvpRTiYsozsizjyiDbv6IJ0nQSb8gI?=
 =?us-ascii?Q?4sG0lG8P0i0KMrm5Rs6SH1x9sF4e/B+ITCYCGNzhqKxYZQJoG2aHtQ3mLk/U?=
 =?us-ascii?Q?0B+hc8aMPVU7Z3mEtuuDdVaWA8T9rduClMGTRoE6cBAtYl5I/LndqeMqQ+A7?=
 =?us-ascii?Q?sjwTqdtpPP8F571PnIxFSV/J6/tnNqoSrXpR8E5DEzrZdwn1fwcdg0ggYHtK?=
 =?us-ascii?Q?5X4jVg/LHjag8KTp2LXdne43Q0bOjaosfJo4bUjp2dUgxlFq1rtp57WRyVOY?=
 =?us-ascii?Q?0iIPrixDcE8sVAGxzQImt6ZoSSRA8JUaijYCSJSMpF5wIegwqaDR/sg422c4?=
 =?us-ascii?Q?H/sbjk52YqQrgTWFRg4vTsw0KP6N6wA7ywqRWEWQquz2+89inr2jFgpMqFpD?=
 =?us-ascii?Q?DXXsEOBy7EqcPN0PzYpxKTcCnLwbEu1AG+eo6x3sxsbwD0/2Ck1ItEACjcAA?=
 =?us-ascii?Q?fFtffdHeHvce+co59NpfHm6n6/KPbghRHPG0Zyx0geR55BGy6pNj7ghDK64Q?=
 =?us-ascii?Q?aHGv/Iz31WuIVyVmCTtw0e5cwRBVz1ZmUZjrlLAD+SesgpkRhue0Rm4qFPFC?=
 =?us-ascii?Q?tltk+GkM8cqons1pHBqzxcctP0tewSu9VAsSJdUMvJmF+TwfF3/Ve8EbNVgv?=
 =?us-ascii?Q?wOIBghBUoJk44kvwZ6XMtWg3tvmU2+5IYByN4OPhG2qTKbIrgotlAQBM++/j?=
 =?us-ascii?Q?ZfjALS9ckvplrH9/ZS3YD/uwgo8IIjozKjZcaqi9QpUI9U9D3LHN/lD42nHR?=
 =?us-ascii?Q?GV++rhvVqmjFuyEoFA8qASuc6lhfzbJK6sCzlIOq1/QpOQ7dD73VGVO0wQDV?=
 =?us-ascii?Q?2+kFcQALPdGFbQtU61oxhdeNplSK+3FdQ+Buzy8RUKGPjfYcwQwXhmWgnvON?=
 =?us-ascii?Q?+PYUwyE3BY+wf6cf20mo81vPMJX8fVwVTVOCcY4USpu+A9wn9RM/dV3Ktb7N?=
 =?us-ascii?Q?Q5ah4drdeJk1Glvhdsw28CbfCbe4vneh/pLQcUxRKT8j34++sX+ZgQrQWHuE?=
 =?us-ascii?Q?peCK+gqRUAy/Cxqa1ipZXgmOaGa/xslOhu/3Kw/ctzkng/uqOJEZIwpsGOfj?=
 =?us-ascii?Q?vLpnXeMxrRPIwy+3+KtjMbjgesyyf+K6Tv8Cb26TP2aUyGhoTSd4kvjWvCp6?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7af3c10-0a34-4018-1046-08dafe163e18
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:21:11.4908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dwv1AnU1n3ze3o5dNaGBlQN+JYvnOPL1e8T+9KWrzSiGxXfr5iQ7+2SC4ARsr1i6tMHcjKv/l0I+tpIF0gGRKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ ethtool --include-statistics --show-mm eno0
MAC Merge layer state for eno0:
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
---
v1->v2:
- rebase on top of PLCA changes
- ETHTOOL_A_MM_ADD_FRAG_SIZE became ETHTOOL_A_MM_TX_MIN_FRAG_SIZE
- ETHTOOL_A_MM_RX_MIN_FRAG_SIZE was introduced
- ETHTOOL_A_MM_SUPPORTED disappeared
- fix help text for --show-mm
- use the newly introduced show_u32() instead of hand-rolling own
  implementation - show_u32_json()

 Makefile.am            |   2 +-
 ethtool.c              |  16 +++
 netlink/desc-ethtool.c |  29 +++++
 netlink/extapi.h       |   4 +
 netlink/mm.c           | 270 +++++++++++++++++++++++++++++++++++++++++
 netlink/parser.c       |   6 +-
 netlink/parser.h       |   4 +
 7 files changed, 327 insertions(+), 4 deletions(-)
 create mode 100644 netlink/mm.c

diff --git a/Makefile.am b/Makefile.am
index 4d3442441265..ee734fa1e97c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,7 +37,7 @@ ethtool_SOURCES += \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
-		  netlink/stats.c \
+		  netlink/stats.c netlink/mm.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/module-eeprom.c netlink/module.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
diff --git a/ethtool.c b/ethtool.c
index 76a81cf55c3c..9846419f0ebf 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6117,6 +6117,22 @@ static const struct option args[] = {
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
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index b3ac64d1e593..5ca81e22703a 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -442,6 +442,31 @@ static const struct pretty_nla_desc __pse_desc[] = {
 	NLATTR_DESC_U32_ENUM(ETHTOOL_A_PODL_PSE_PW_D_STATUS, pse_pw_d_status),
 };
 
+static const struct pretty_nla_desc __mm_stats_desc[] = {
+	NLATTR_DESC_BINARY(ETHTOOL_A_MM_STAT_PAD),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_SMD_ERRORS),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_REASSEMBLY_OK),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_RX_FRAG_COUNT),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_TX_FRAG_COUNT),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_HOLD_COUNT),
+};
+
+static const struct pretty_nla_desc __mm_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MM_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MM_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_VERIFY_STATUS),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_VERIFY_ENABLED),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_VERIFY_TIME),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_MAX_VERIFY_TIME),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_TX_ENABLED),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_TX_ACTIVE),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_PMAC_ENABLED),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_TX_MIN_FRAG_SIZE),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_RX_MIN_FRAG_SIZE),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MM_STATS, mm_stats),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -481,6 +506,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_GET, pse),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_SET, pse),
+	NLMSG_DESC(ETHTOOL_MSG_MM_GET, mm),
+	NLMSG_DESC(ETHTOOL_MSG_MM_SET, mm),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -524,6 +551,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_GET_REPLY, pse),
+	NLMSG_DESC(ETHTOOL_MSG_MM_GET_REPLY, mm),
+	NLMSG_DESC(ETHTOOL_MSG_MM_NTF, mm),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 0add156e644a..af0b92cc8117 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -50,6 +50,8 @@ int nl_getmodule(struct cmd_context *ctx);
 int nl_plca_get_cfg(struct cmd_context *ctx);
 int nl_plca_set_cfg(struct cmd_context *ctx);
 int nl_plca_get_status(struct cmd_context *ctx);
+int nl_get_mm(struct cmd_context *ctx);
+int nl_set_mm(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -120,6 +122,8 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_get_plca_cfg		NULL
 #define nl_set_plca_cfg		NULL
 #define nl_get_plca_status	NULL
+#define nl_get_mm		NULL
+#define nl_set_mm		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/mm.c b/netlink/mm.c
new file mode 100644
index 000000000000..42f309476ed7
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
+	show_u32("tx-min-frag-size", "TX minimum fragment size: %u\n",
+		 tb[ETHTOOL_A_MM_TX_MIN_FRAG_SIZE]);
+	show_u32("rx-min-frag-size", "RX minimum fragment size: %u\n",
+		 tb[ETHTOOL_A_MM_RX_MIN_FRAG_SIZE]);
+	show_bool("verify-enabled", "Verify enabled: %s\n",
+		  tb[ETHTOOL_A_MM_VERIFY_ENABLED]);
+	show_u32("verify-time", "Verify time: %u ms\n",
+		 tb[ETHTOOL_A_MM_VERIFY_TIME]);
+	show_u32("max-verify-time", "Max verify time: %u ms\n",
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
diff --git a/netlink/parser.c b/netlink/parser.c
index f982f229a040..d6090915ec48 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -37,7 +37,7 @@ static void parser_err_min_argc(struct nl_context *nlctx, unsigned int min_argc)
 			nlctx->cmd, nlctx->param, min_argc);
 }
 
-static void parser_err_invalid_value(struct nl_context *nlctx, const char *val)
+void parser_err_invalid_value(struct nl_context *nlctx, const char *val)
 {
 	fprintf(stderr, "ethtool (%s): invalid value '%s' for parameter '%s'\n",
 		nlctx->cmd, val, nlctx->param);
@@ -136,8 +136,8 @@ static int lookup_u32(const char *arg, uint32_t *result,
 	return -EINVAL;
 }
 
-static int lookup_u8(const char *arg, uint8_t *result,
-		     const struct lookup_entry_u8 *tbl)
+int lookup_u8(const char *arg, uint8_t *result,
+	      const struct lookup_entry_u8 *tbl)
 {
 	if (!arg)
 		return -EINVAL;
diff --git a/netlink/parser.h b/netlink/parser.h
index 8a4e8afa410b..a3c73138b9f2 100644
--- a/netlink/parser.h
+++ b/netlink/parser.h
@@ -99,6 +99,10 @@ struct char_bitset_parser_data {
 
 int parse_u32(const char *arg, uint32_t *result);
 
+int lookup_u8(const char *arg, uint8_t *result,
+	      const struct lookup_entry_u8 *tbl);
+void parser_err_invalid_value(struct nl_context *nlctx, const char *val);
+
 /* parser handlers to use as param_parser::handler */
 
 /* NLA_FLAG represented by on | off */
-- 
2.34.1

