Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B85679657
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjAXLNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjAXLNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:13:47 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2057.outbound.protection.outlook.com [40.107.7.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551C42B60F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:13:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVD/07ijAQW3FBQx8Qml9v2fg+sF+odyXzqIBvn8DMFwCcMwbaNy8qt64gcaT3q1UULcGitO5Mol2ZRwLdfbOuIbqOvfEx96f6vT/3bSnS70ddt2HFrMFPKU6WQ8v0bALOYxKM9uOCTz847JZUSO75QoJAiNaKMnW5LQ6QhXOxx4JGfALFR0EXXGNqW3TI7IDQt51M2SgqbqnCn6yHmC0XHxnFUMzXn1m7Y092qVkPexqn5qjF9FhyXQaDueZRDdxl7FPEvEsdLrIEWKaOkj/CWXm7odCwCEElZEDE1lCQIRdSNfV9nWyABR6LzVDWeK+yjJXIlW/OjGw0V8BNlyEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+sVzgk5r9iLk4C6tUUrjoQKdcHm35ATC+XQmiPD+3vM=;
 b=GstqrPIsz03RsphSnTiC3JloEiV6gW9LVdK6Rvux+gMQQsOwl+OEX7rXUWinNiYBmwbsajwXQjir98Vqi3bY609+PuHC7VRdRpzmr5jYtWpiiGDjN097ObtEi9nHHIT1vQdyclFjorsvJJorDKPm0fWOA4s0StfnUSYeGA6k/lp2JT3TOjSfqe+W9ejlgY98Z3UhbHIPsEUGaEXoeyeQg2wJj9uNxyyd1Vlzhsu/sXPzp97zPAUGjBcWKEDHyzN+JAOfj/DkmHGWXDcyiJVlycZAoic7xh5mJ4vWy97jlunyFrpK4odSW3FYEZd2hSQvuMaW/5uDymBO98Vi7u0Drw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sVzgk5r9iLk4C6tUUrjoQKdcHm35ATC+XQmiPD+3vM=;
 b=GqP5BorJNIBNOQo30MECqqjeXoUF+bJfUkGs57oVFYrL0g2Dm6mLx+v8TyPLLepNk1O2aQqtjydHFXqxj+rvUfyTqHwQiGmaCRtb43/J4v1IRRi7gc6dyfWfAzzKKZV9+H4cd5aoHWtK0keAmXtt5mpm4PLpAM3A1jYHDy/7hW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8746.eurprd04.prod.outlook.com (2603:10a6:20b:43f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:13:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:13:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next] net: ethtool: fix NULL pointer dereference in pause_prepare_data()
Date:   Tue, 24 Jan 2023 13:13:28 +0200
Message-Id: <20230124111328.3630437-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: a003a3a7-c37f-41ee-33da-08dafdfc0c83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHU97SmuxtcOlIZBfV0vZS1zPZ2oHVCvDWlNFny0xWxvXCBRIfgM1t/BKq8eXD3/MXRS9RHZRia6+/90AiBTB1At9aKAmLduul35EAenciL541cObwDjYCLaGdeRlIEnbe6u+XB5I4CXEo4WdF5sWgAQdWs/K92hHF7LVRayZlkjNFsvPDWicDiiMt83M9iv1G5WXP8UCZpZYNN0fvCG5ja54cWDv1LsOx0fG/cBR6CwVh72GyEBpHJkdoXnnhDjjCsWw95/6tcGFev2YiJS/dUKS3na0lXMDcFa+cyIlthYKesQLCILVhyvtNzAHtuc8fn4MIGGCZhBLsFKQDFivxYFV0Ze/39NLOMMxNASFAUtlS5avPP2A4PqVHU3NgBEM1xMIb+D+pVrwhVLcrUMg7zVoWyP1teyWLDqtFtsjbDJeX6N1emOgbemauicjCBeMkORpg/8jDIb3cptzWpyok89NOuvgoyczqMPsa3zqWeCIXzL4/5bCZll/x/oAXVtnLhXFrhRU27CpH7/DgcQBj1fyfsbZIU5JDzvyA5ZzJ3IZP+B5hcM4ABlWhDoIYNeUxKsUvd6blxFBemvC6u8angcGW1H4C0lTlWDwm/Ns75zxwRYBqrJRPTRS9g7RlFQF6a5mU0qUHZ06BgNXBu4ukyevuP7OzxiBMIBovEYFaZX5HphT9UM2YZArQ96BFeKPk6zNsl3YAooN5oWlMJMLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199015)(83380400001)(38350700002)(38100700002)(2906002)(86362001)(44832011)(5660300002)(8936002)(41300700001)(4326008)(186003)(6916009)(8676002)(6512007)(6506007)(26005)(316002)(6666004)(66556008)(2616005)(66476007)(54906003)(66946007)(1076003)(478600001)(6486002)(52116002)(66899015)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/q+PLA6JCg71hi147vE4eUMLQI7ca6D4A85X4PTV9J0VSckRNc4pzKG2GGMy?=
 =?us-ascii?Q?V3AG3I97pwnEbyNE20mx2lnLnsSjFQTCl4ux+7vgtLMDTPWggSYKGZyatC2t?=
 =?us-ascii?Q?Rs/lYPNMq4DoU7nfmEyD+PeQu6OlXHAX/9O+DspJn2kKsTq3NOwttW0eMq43?=
 =?us-ascii?Q?qvrKOsGSkkLPCFI8SA5dVvR4l4sA7EkTcInAUEGWMOS7VhnlgM1kYXODtXfc?=
 =?us-ascii?Q?cy8OUYanGzYl4+hLAxfFr/WnEjU4nFTbG0gsM+osB27HqmtgXHE4AbN/P1aj?=
 =?us-ascii?Q?Bb6SB5MzxHfoK2ycmcMBlA9PMt4ShAJyi7Xu3JUJkYsTyrT/CxSTlpB42GWQ?=
 =?us-ascii?Q?cX+7wIp5hGAvIsyS8tI157paDRValhQ3NODutvz/u7zH7x+qgUDb6/vZKJuE?=
 =?us-ascii?Q?wOl1I+fW0FriccCIaet2LpLDKkpUrLP5PL+zdCpUzyhf8xo4X+CWkEdi2kF7?=
 =?us-ascii?Q?qLWBGfAi962oVMD/vrePo8P5vjdyTwrZ0qmSYcPJDLH0D7q1hhXJLJUhQ1ye?=
 =?us-ascii?Q?mmKaqFVmU8nm0PEBSHnbN/M7g1KvukQchQlBXYvnYuZKungcqaCKKF2vy9+s?=
 =?us-ascii?Q?o5wt9dTkKzmiFNufc7e6G1oZuBxmFCwqk+17miLRo7Kg+ez+J63aq0tzENtq?=
 =?us-ascii?Q?ENqy5AQ2Q8aH5u6/sMv+2DUI9/LVQqB+EYTTdezwVqHp/YaDpc1pazT/T7l/?=
 =?us-ascii?Q?HmOaTbX9z9xA9yos4GZji1+P4ipDbJRryl6S3JdvMtCU+yIsFdH+fQxQ0os1?=
 =?us-ascii?Q?hctDAWtY+yi+ilfU5TrTD9G0dOEMHTQ5TWiJ4tEACjNhmTfxyMk+WwDDnhYl?=
 =?us-ascii?Q?ZUvvnXX8H1VwgeJnYLA7D+/qTH1peMJe2L+dNIMvm8e33iZCvNLE4mEpGo3C?=
 =?us-ascii?Q?IbfRdd2dpUJjTBzHc4vPh6NMBUhmXKbmeDO2D9DP6erUmcu2Iamt+4XjTcIP?=
 =?us-ascii?Q?6WVaAZ9A5w8eBhk3SRKeppCFVabLJZNDokGwaysTZJXDIR3eSZ+sCsRVA+Ik?=
 =?us-ascii?Q?Q+sNwkmICVnd+FjsTVLWVlt1UxviP9ZHtZFcNl6ZFqCO6fDZOc4IMsZ40SNc?=
 =?us-ascii?Q?BxUIP76mkKycBNH5Ha4hx3C3qzapaQD+y6I0Mz7JWf+3zl31zmqHeKfDFWX0?=
 =?us-ascii?Q?KSnl6rA8RRl5mgAi2oZnnhzPhDkW0VEg30ukrVk4c/zd1QZ0COBl+ctn1md0?=
 =?us-ascii?Q?pHEhdb7zcK76qbpNDuX3NHrYvAPHuTPKBhYuzLt3iLKtL1DU9dOX9nA6xSpe?=
 =?us-ascii?Q?pcFaRrLTHgZ3mYbNf+13wi/+lVDdqqsG6AhHGKT7Te/glRYB4ZTeZDW0IHX7?=
 =?us-ascii?Q?trQM43pZINNZzR8SmoHlDZV0uZAayhjq34aoCQm8pS8CaCH6/ppIx8qGlz1r?=
 =?us-ascii?Q?4qS1d62nMVcQGNjz8TDXq+fCfKsYo0eC6Q5ID4ek7phHA3lNzedG7+ijYayN?=
 =?us-ascii?Q?t83gMGE6AyW7AOVtHxUMoEajjzqIIFzgfnhw73yIPdhTZqb2UkZ/R4rv76Qh?=
 =?us-ascii?Q?9lPgRApb7gb4mjr8v8K0KBPdR6glIDVxsHaO/nWv0ifb0usyqDHzcvBN++lX?=
 =?us-ascii?Q?nMjoV9ESLfItiobtplLrD492Pa+HPpJChaEfpC6jAUuwVIB4PUH0DbmynaPq?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a003a3a7-c37f-41ee-33da-08dafdfc0c83
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 11:13:41.1419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVwDrQcVzfiPsIxm7MIBCnSdmwgbK7lAKmuOiTmqcPQNwpFrCFglWSAmWSCgCGTlpmTug/v3z0HGa+ACRJLD+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following call path:

ethnl_default_dumpit
-> ethnl_default_dump_one
   -> ctx->ops->prepare_data
      -> pause_prepare_data

struct genl_info *info will be passed as NULL, and pause_prepare_data()
dereferences it while getting the extended ack pointer.

To avoid that, just set the extack to NULL if "info" is NULL, since the
netlink extack handling messages know how to deal with that.

The pattern "info ? info->extack : NULL" is present in quite a few other
"prepare_data" implementations, so it's clear that it's a more general
problem to be dealt with at a higher level, but the code should have at
least adhered to the current conventions to avoid the NULL dereference.

Fixes: 04692c9020b7 ("net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/pause.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index e2be9e89c9d9..dcd34b9a849f 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -54,9 +54,9 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 			      struct genl_info *info)
 {
 	const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
 	struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
 	enum ethtool_mac_stats_src src = req_info->src;
-	struct netlink_ext_ack *extack = info->extack;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
-- 
2.34.1

