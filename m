Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3ED679B9C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbjAXOV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjAXOVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:21:25 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277C093EC
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:21:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4pQ9Gnz3FjRTaDYWuUrDSZYXSBghE0w5359lBrxW8EIn3nCfGUajTk1jW46LFuInTdA6mqHC/cGvdnhWG3cJ5xnFVTYd44oz9QMMBFe0M3h9MIKdj7JZ6vje1n5md6/d1OZ9c5P3G+SMz0aELvp5aFPZF/ztlkJKMTHmhJJMHaqiytjfSeLaULM3VWL6QCS8lmouDIN3C6wtpn1lx5s7y2ImrArNT1TPhDqLeTsUmDppkqv3T8z0cfEozzxfwzsoJ/03tgb6ZqCI7JECIvCuowEe4bE0No4sL65wuZM2lboQCiwZnwDIiHp91mjjgsRrZxQLGVWpSmxsub4eUhi3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f90zMcHvBXobDVkrSefWsKcwDIkzmkygCfX7kJ9jaCE=;
 b=eQlMUQX6JhRh5Z9iM+KRXAia2GUfdrnyMfVc42Ij89XU6puj8l8YXvYehRvpT9wgl62ZE9vcdiQvUKcISflHf6TDTgdGHewd6nB0LMwMU7Q8ceGC/UQuefSaIROZY/JDWBHGrqiVAPKr0L5SWPdZ72rSYMhQpIc++eGmgWIS/nTUjVImHiFTDo/XMqC/qCb/GwgVIU2HdSZCcX7kGLZ6Y3ZgSulLtPcA6jBnYeRXg9wr/vL/RAExE9kUAY5FahUPHsUpuckhZt42QA780WcNP+VDWH1bnHltHiiYOPsiPpqIoSJ2X5GQR2n7+U/QgxG6hReLP41mH6vcwAQp4O4uaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f90zMcHvBXobDVkrSefWsKcwDIkzmkygCfX7kJ9jaCE=;
 b=mcMj9RLvNc0gi/hjNsVtCr5dZepLPGVc2Ct1Kcw3MTFi441Y/eO4EWKY2LbZEDVJlF7VR3LYzACr3GkGu/klJ8X1Qw2Y8vKmTc26BF9tIULpAlFtPKQVmyLqkCnQLLLs5YCjR/tSxu8SPZEV2RKDwD33LGoX1RqxjDzFmdRrrt0=
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
Subject: [PATCH v2 ethtool 3/5] netlink: pass the source of statistics for pause stats
Date:   Tue, 24 Jan 2023 16:20:54 +0200
Message-Id: <20230124142056.3778131-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0c4fb258-e4b2-4785-5425-08dafe163ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htqZG4EkW7IO/BbMPz8I+lvWJNs/jgFymsHra8IzNv/ukvQg92zEmAkv13Ri27H1VU3IfeBwHca7PRTHnFfl9pLnCK+UH9VHO8LzA7hVnYFTCaEvxS51vIen8jTRbNVXCCmz8TYpoyqS6wnhbILkSP1S+OoUtHJul0Q2jOWsk7NdNxbvtZh/pAXcYzesJb+qlDxXqG89R6P9NBRHaS1gSPqB/EFPxInbnTSik9B1v9QNpUa8lnOtg01Ev8ybUUXZ9w1XPcCRnaRb9a1AH3lFF5Hiz8eopFZbtOSJ+6myAf1Py8N3eUKjMKGmUuwdFbid7FhovnTJcygYVj2Zzlm9dIGVZlqkk89M2+Qc9iq7MFMZnP7cqKIiZx7K8jFWwW7Necm7NrdCAlmKto3w5zI3NQt0+ZS40SZzRS048e+sUVD7dqgFta2YUvULF/+1uWSfFpQnyDX6GAnEDMB4R0EM3bPUeEaZla13bHAu7Yohdo1Eozz+AgkHpLWr0bDuqPZoVmuRE2F76FK6H49YoOjEkCGT0NAqgiKgcONLkAD1kA8hMq/ZLYNm9a1cOxaEqYH14daL5NXmoAdBKBEac2y3/PvaiIKeMgpRImuiCfyniiei5qBElnVbAnMFahWYswqfich/L+VxcAWcS2UWdjTkdUm4Y0Rd4gvg+Hbhq+5bEu36LcEFymIlAF+iBqg/GSBFBDw5YDYd8azVfqqgoVGEDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(83380400001)(38100700002)(38350700002)(2906002)(86362001)(44832011)(8936002)(5660300002)(41300700001)(4326008)(186003)(6916009)(8676002)(6512007)(26005)(6506007)(316002)(6666004)(66556008)(2616005)(66476007)(54906003)(1076003)(66946007)(478600001)(6486002)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RDpTw5rlwSSLOb7mMNNZtStnzbLTBiwKj2C0Qv2heFWDfzya3VQAp7pWfwT8?=
 =?us-ascii?Q?BcnAwiFRWqrbkYKhZIldfZR1n0qVQ/gaC/Da8rWbH1dJHRgIbFQWUCm96mpB?=
 =?us-ascii?Q?rq7L5CCps/qH9uMMqZ93/sKC0vt8Z0x37n4htc//eKGLI7z0Qbs7nsZ48THO?=
 =?us-ascii?Q?wDdSVwzbtqwcBtH5qbRvQ1NYD8NOjDrYCTqjRA+BZ4LVp2cKXHqiMwXkIXDB?=
 =?us-ascii?Q?s7BVq/Xrh9iUBWT6WSabzSSsKfQVR/R/9qEYoTSJl9uGzfvSwkFdJfGbRLQN?=
 =?us-ascii?Q?dqHpf0k2LJAq30vo1Z+P18uGPHWNsoPbCzWRYk4h/qHkeZmoAhPLHXCEUrGZ?=
 =?us-ascii?Q?amQt11AEK6sldx9L+7WKOLWPzx5ppUsu23o7dZSu4AyVlrLPa6svz9Na/UII?=
 =?us-ascii?Q?kS5Bx4IEfnvJXuekUGDy5rqYXpa7LrG8il2+MBqulUikkFIHQGUjG2C5CcWR?=
 =?us-ascii?Q?xpD+FS2qvFKs4mJJjK+AMlrBmwpiKAYQ3LQSG2rG0qxmlV9uhFEKhoh6Osjs?=
 =?us-ascii?Q?/u4bI2s37K7mh0ruANHOFhthuyvjDMx2/BzLn6qbrZv5PyBL1Jz4qoaievVP?=
 =?us-ascii?Q?d1XPDLWVvC/6/DRnJgaaUJZjfdQdhga6PQSFoN2/5JdGBXnz+b4jxFiirAMg?=
 =?us-ascii?Q?r7D9xBqPcgBLXi/k3qD4qCDu4yeMXBe1j1Z3eEsjsRc550ZF1FP6HFwlkkf6?=
 =?us-ascii?Q?5OqdJ2UFbR5OhSlMyRectmGwe8m+/PbmDZdu+wWKpp8oaVOF7O18Kv5VDha/?=
 =?us-ascii?Q?IG3lIRXgIo1NWPdl1Lo5P8Vt45b7Gbi14A7ueRF+LToWtCXgx5pYxFJow+al?=
 =?us-ascii?Q?+nwHf8fu/SJ2Nd2S//i15841GWtP177N5iB/K24walq84oHzKLiQY6vWUPwf?=
 =?us-ascii?Q?iPmmz55YyJecOBt5lh/3ezMQ8kOel3eGgCdRtU0ac2qPNjFftgF0gc5tyhta?=
 =?us-ascii?Q?pSts58NztwFl7+q7+p9Hy6ErpY2ZhnoeocyBkFlde82VUhJKLp9d2+QwjsVM?=
 =?us-ascii?Q?auShTR+fmQs7loi6zjm8Jq050BjyzDkbZwjw/lwaTP1A0Zdw5k7cG+y7Aaa+?=
 =?us-ascii?Q?gX/WHAHHlBeHetIw7TnAgmalg0VTwN6wcM7ZHf854ZNi8P2q5TQjBHfKBcIq?=
 =?us-ascii?Q?+DRTxI1/E4/dAV9pJP+K/+nuI8baAcG0LfniLDzwEY1lJy0X3SwNnC7d392t?=
 =?us-ascii?Q?3D+hFQ28wx9CRK5hA84pyU6dHWXaQF8qdFkoPxmNflVWGN6vGcZ+RpWEhNDp?=
 =?us-ascii?Q?zEw7OF5wLUcmNOGdc6Uv3UlZdI/cbOV1WFpLVYAhf0OZHxuF1qfTV+pMv2ue?=
 =?us-ascii?Q?3gn5xBUhpWU+UNCpKVbpCCP72pl9ExWz/736WRBhR4x3vM3+YH6knqWJHT6P?=
 =?us-ascii?Q?mutjzIgZXEm03f5SXMkBXvuXhNw5NlxJP0d+yiWD9bK2SlXFml6P7QzQgi5S?=
 =?us-ascii?Q?p3LhrkitmNL2N1OzDc1oPDEDaF6lWrhSVeysMTHsF6FGk+c/7JdYEwvxWugh?=
 =?us-ascii?Q?EcpgovOLeVXRg9TDXICgEo4kMT8+25cW5WRwy1ed1h+sRHvobT9ZuM1U8dJi?=
 =?us-ascii?Q?PcicPfgKBLuki33wvFcTGXfybp45l+q4nwd8dP2pXFcfQViamqbm0CECUEtD?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4fb258-e4b2-4785-5425-08dafe163ec1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:21:12.5220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mULh92yvBBbFCsLcoY8PZkfSzt40BGrgZXmHbByd6fyFi68hHakcjW7dbBt6VvVVijviUkd8/K6NW+mSIjiv5g==
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

Support adding and parsing the ETHTOOL_A_PAUSE_STATS_SRC attribute from
the request header.

$ ethtool -I --show-pause eno2 --src aggregate
Pause parameters for eno2:
Autonegotiate:  on
RX:             off
TX:             off
RX negotiated: on
TX negotiated: on
Statistics:
  tx_pause_frames: 0
  rx_pause_frames: 0
$ ethtool -I --show-pause eno0 --src pmac
$ ethtool -I --show-pause eno0 --src emac

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- ETHTOOL_STATS_SRC* macro names changed to ETHTOOL_MAC_STATS_SRC*

 netlink/pause.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/netlink/pause.c b/netlink/pause.c
index 867d0da71f72..da444bdeb13f 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -216,6 +216,24 @@ err_close_dev:
 	return err_ret;
 }
 
+static const struct lookup_entry_u32 stats_src_values[] = {
+	{ .arg = "aggregate",	.val = ETHTOOL_MAC_STATS_SRC_AGGREGATE },
+	{ .arg = "emac",	.val = ETHTOOL_MAC_STATS_SRC_EMAC },
+	{ .arg = "pmac",	.val = ETHTOOL_MAC_STATS_SRC_PMAC },
+	{}
+};
+
+static const struct param_parser gpause_params[] = {
+	{
+		.arg		= "--src",
+		.type		= ETHTOOL_A_PAUSE_STATS_SRC,
+		.handler	= nl_parse_lookup_u32,
+		.handler_data	= stats_src_values,
+		.min_argc	= 1,
+	},
+	{}
+};
+
 int nl_gpause(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
@@ -225,11 +243,6 @@ int nl_gpause(struct cmd_context *ctx)
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_GET, true))
 		return -EOPNOTSUPP;
-	if (ctx->argc > 0) {
-		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
-			*ctx->argp);
-		return 1;
-	}
 
 	flags = get_stats_flag(nlctx, ETHTOOL_MSG_PAUSE_GET,
 			       ETHTOOL_A_PAUSE_HEADER);
@@ -238,6 +251,16 @@ int nl_gpause(struct cmd_context *ctx)
 	if (ret < 0)
 		return ret;
 
+	nlctx->cmd = "-a";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+
+	ret = nl_parser(nlctx, gpause_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
 	new_json_obj(ctx->json);
 	ret = nlsock_send_get_request(nlsk, pause_reply_cb);
 	delete_json_obj();
-- 
2.34.1

