Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B86692959
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjBJVdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbjBJVdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:33:47 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41A82190
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:33:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXnilRju3MA2O9tDCha6bHKwfS4QWv9y/IQTRGihofdG7F67FNIb+Y5f1zhwFaPrDgljdXqiCu+NzZb5/bK6H6h2Gn2iEShiJqukHxPnu0m+abnIXgfQqNzoBTqHuz8+PvK0+bBYigoosq+QpKSt2jdT/9d64XTlQEFjrFRyV27JrqFfJuFkGmHQ80rcub4qZ2BGmdxuKx/jZn65iJB5/1F1SXzHH8lyDkkgkjxCT4eJxnFDN8IshytTSscbeYqwMZZtTtKNznaOX+B3igCzMGUlRRwyRY6zGX5KbArnAw/pv4lmug3KHqRa+CJNWEqFdmuR9bIF00VoEDuVFSR5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbaH6B51lWC9Tx6ZCPobtyGnH0go56lWe8/01LLIV48=;
 b=G3ygYwOLJ4+3KapfYuSM+CdoKTMnDYeKXRoDcw9WVbSh3B6s+QdRwxSutaMaXB3swpG3FrnHcvqN16LumNY93/+wRrTpDoZXrJM+/mCN39TLYUauW88PMOuWbGdir6I7njH2ay/Sj3VJn3Dr7eM5LB/J2tZebzkgyzWUDyne6/g5fF9akQY9H2ahMtev+fTmWL+3EI+OjqtSeI3omUqqF84wQwg68eHSlShOk/BwReXorTLYNbhZizAGXLT60QwlqjVvXfrTpX9EF5Ku8oUhrkCbD9f+byGOGTlM8vvEgKdGnBmdUBrurqZwiCA+34kCA8yyKD+Yl37HNngyWsT44g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbaH6B51lWC9Tx6ZCPobtyGnH0go56lWe8/01LLIV48=;
 b=VCcJ0Yu49nxwUBpvKPuFOvackJnGQHNEpFeRKZEYt6lmm3W1/wLO0nQi6Lc5mYBGeYlf5eU5EI4XQOynN3vnYczpIE8ZAhUH+QmFYox5ItPU2TedYO8KDNzJyrP06RvbHFm+WG1WS7S4XKNqwNYbwR8C7iVId+4du62NlAdcHV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6881.eurprd04.prod.outlook.com (2603:10a6:208:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 21:33:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 21:33:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Subject: [PATCH v3 ethtool 2/4] netlink: pass the source of statistics for pause stats
Date:   Fri, 10 Feb 2023 23:33:09 +0200
Message-Id: <20230210213311.218456-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d9879323-2db9-4a70-48c6-08db0bae720f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpT3HINqGF3ylseWijMKB2CmsuDV5X+bF4rOgfpU6dpbVMRsLQUgqbJozK01ez7WA+h0SuPUjEdXb/Q6A3nGTTjTMeFMqwE13XuUl9nNLImO7XDG4s6vkYsaeuLP7rgMYZ4t2EjuUBvI/0IarfbCPVM4XJVzoXlKsyJWfMY0kThkuXGFsbNZ6rmaFombgL7g1H7n62rj3c3n0BnNRES66Dp5VjRkL55NgakzVrH6gKlhxRytIHsYbLhxvnv9aGKNxg+G5OJpIc2kI446gYmkABkrCX0XFM0O9mXdOsb/NzOxsxdvX+hfZ4h3zGmwKumyizgU02BiAOJePjfx7UvEqyL+Zc3b/0R/b7mU+6xS06qVJa/TiRJEQ6O9//YnHgtfkYVIltfprB1o+IQkACsD1m0JYWRjuhxvU2lQy30pvfzLh4i4y4t3pah+6tb7UnXVqBIWfm6T98p+sWX2SbYWldsW1Vo6xz0bDtK17eABjreN8oPn5Wv6O6krMVAykWihr6iOiuEGspuL7VpUof+Z//xE7r0Bu9oWk2h7IKK0aqfpVM+qELmGwE2GVBjiux4XvymcZn+eQIVTrdbswKBHvTvwpYByEbh2T2XLdk3VdYIcMnly8SYyAIfvl033iu1QEmFV8+i8TW5vCnOBo5k+3W7qaW8TSx+Kp00lx6KrWqxcCtvWRHIAXyfb2Z2Bo3Yw2BXjZssJL1OEKxZhRGLqFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(186003)(66476007)(6512007)(6666004)(26005)(52116002)(2616005)(478600001)(6486002)(6506007)(83380400001)(66556008)(66946007)(1076003)(54906003)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(5660300002)(44832011)(2906002)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QCTAS04S8M3lMGMkL5s2J7DxbIuZV8XodoCyz934D5K9ujObyZa6kTuxi+20?=
 =?us-ascii?Q?k4m5pRuInP0Xu3hbckQlnRS3EQFmqfK81RJrzNtK4sZAjmevVPA6Mp98e9dq?=
 =?us-ascii?Q?Mdx4fAKPctaTZSlG8PRkAd75kzlxF5asKo7tzQ1uayxU/HzQpIk4ygbhLHU5?=
 =?us-ascii?Q?R18ooi4OltXKKMdyz6H1uL/n/NMRuTmJo6IzkbthCdfp7SkaToeacvwNTupE?=
 =?us-ascii?Q?IA7fpqMaRrt5bL7lEq59nEIgG7lDXH8IUALT38Ig+fLHl5qpmBiQxWGHKFYF?=
 =?us-ascii?Q?W9D7ukuUWFLd7x04LPUkBp5aDBUMAgg8Ey5NCvD1lYYXHsYbVK9TWMkbOi4G?=
 =?us-ascii?Q?HEfqv4Tr2R+BR1Ejnu5VTni/POZoTo3qx3CC+ivujfw5MhplEtt8FGLj+ETJ?=
 =?us-ascii?Q?YzVpkLNoCivgQdRC/d4c8N1wvxVC5xbgEtWnuZgO7Wv8F/G+uCDzB1X0Dxc7?=
 =?us-ascii?Q?PPtUQe+mCYsog7I3BJOBg4tHJfWzjZD9GRRqMurxATFZbrWwHDKpNJF9OiKm?=
 =?us-ascii?Q?SRn86Ebkc0d5V0NdGYKyA6q1pQSzpdp1QRKm2jurXzFzvz0/dwXF8/2C2nTY?=
 =?us-ascii?Q?uJrSZF2piDtedAsdxJc6D86iGA6yXup+s5i4PEtsIU0aXmW9619EI2nmPvPA?=
 =?us-ascii?Q?c6oF3Z9EZlRfPuv++dmT6tOQhCgG0K/8WngsZfAbJzj+EUFPrd3KIRi3AiCg?=
 =?us-ascii?Q?wz6bQVnQohpN+q+KME4rv++MwocedsDu6WfEmJr248DfgjVuhAiPBFoRphPd?=
 =?us-ascii?Q?nhZVNWZmRIe6Va1QLgYFgBUBMHF3SXTiaBWE4yzHTmV66/ZEhrS3K1Y0IDnw?=
 =?us-ascii?Q?VWRUes708B3f1AfIhKJBEnjdCcW0rHMkOcHM/fL7jtvvRylNfzZWxIoLWHOt?=
 =?us-ascii?Q?nDkTtQI/ls9HQ2/zpjgLeae/TIZlR1c/0sOKOgbkz2f4cVyODNXhI+cG1oCW?=
 =?us-ascii?Q?67rBmGWqaCMVnqRckZXrD5dJUs2jYnHOAVnlTqe0MJqDgTCS+LSDGEMMGJVU?=
 =?us-ascii?Q?pO4lxFdbKe3y9iRbMIRh76TvpJGQkL6UtTAtqRtRsRn0t7lMW0hkeYAkADxR?=
 =?us-ascii?Q?l1sohGW7XPay2SRPONNyEiv32sAuJjiVAHz5LcThkD8vlEPKU5z3ZxEJXa+v?=
 =?us-ascii?Q?CQbFM52PIFWw73ndgGxkg+xvDuQfNuvb2ZgZhqMcRLvBj/4/LMdEzklwrF4S?=
 =?us-ascii?Q?WocODfQcI8gmroig5P6SGTNwK0l2f7OCH/uRuVZ17TzqExTWulNSPG+MViiL?=
 =?us-ascii?Q?oSYBPrhEnNvzSIkx+CA31cdvgFgL4grt70OM7CEZ2jCj4YFR5yZ7m78Q4vMv?=
 =?us-ascii?Q?4fsnZcLf6r6DdCeOHj7Q9mXYY6gsAqOpUEjRMC72/4VI9XBcxH5SFGW4/JTe?=
 =?us-ascii?Q?8JQI3bOA3O2eem2YOZ6lSZe3XwL6Z3HRhb1wGFCLpNrFyaIMfFZjP1YxxPoQ?=
 =?us-ascii?Q?nyjR2CyO68fJ9V6rwHVMf4AYn7fAhwtwVMv0MhTCYhZQAR9V+TrdIvkYxAC9?=
 =?us-ascii?Q?IMMh/Pjp4dLoaKmle4I9tL9rUK4lmXs25unE8Eif8wftP2hYNqTp3rgISSs5?=
 =?us-ascii?Q?NzFSJyqQDTcyKRRP9M4Coh+qs7x7gQsvF7p6qJMFPtJXPrRmEpEYzWC3QzJY?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9879323-2db9-4a70-48c6-08db0bae720f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 21:33:27.0595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eK7gkoQxJtA68YUjZqyMae4ClN7Jky60Bcir7aQW/dLRthet7uHLyrq/OccGC73KmcoHzAJYNeG2gkdWRNvOOg==
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
Reviewed-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
v2->v3: none
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

