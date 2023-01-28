Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3927B67F381
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbjA1BIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbjA1BIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:07 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B2F77DD9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k18J9GZBUWgIp81Dd2ilfgTGxRRrYWc34np1N+7Hm9rWm+EIpWlBpB7CEmz6KX9RsH/N7ljj1onW8CPU6vQHD73RMnESHyZ6iBFsLHBV49ljDVk9fxbOH8k+Es5lYh7wW9izo57A+9WEoeO/0rfhgkKoxK0b0uJQEDZka4ONa/wM/7Vam+EYeZg4MkSNo6AZR4yAQHxOcn0gv3936nQlPcPtA/uUTkN/TrQ+4UeMoM3N+si93QXtjSQ7iitt5qiygOx4mXULT2WPDIWX+SIOfKOGYcOSrOos0yjybZzKYEc94hlEU1Jv4fUVpYFnrOUOf10twkfOcDoEvqZ+LOeGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aeWJHvCcRBik0wfCiKH8kGwX1IMOz0+IuhYKMGDK/f8=;
 b=hvCOwOjHNwcbfnRAQUe59mBz7jo4lsYSof88LlbLrI1XGahDMECmpLGHbab204zb9Macp0gD6WwSRuj8+fxky0TPHM6YGgC4NlcuGynLwhENOGCWBWScJibCDUzderLHmIQdAMMlew73mqQScfjQx9dsdBelB9YsnZboT1JliFPjN8gCxD84QtxefQ34NYO+gbELBBmZYPtx6k5yHIbbzbqHNPJ9jxV1i98GWb62NfjrMOJQUiABPDQm/8v9KkPi9Xk2w/0HzgdUI85XLTr47O7TRhvxpuPs52T/w1KUtsxqA5WSa9Uj3XNv3tfISWoIsNnUHZNKdI3ffaSAaTshOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeWJHvCcRBik0wfCiKH8kGwX1IMOz0+IuhYKMGDK/f8=;
 b=XUf1RRjBFG4id8PaqtWkkiqgr3y7WP/Iyxff/1CwrcavtshVmh6Qk2UFUEmYzFO39elnSZIyMVdrhdkTlRtQfIf99It+F1uFnGlFMXsMPqW8MTADYHQRMTiKatqUoQMS6y7dmxi59lvKHKEpwOgVrooIMW+ZsSCCZ+RiruHYAPg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 14/15] net/sched: taprio: split segmentation logic from qdisc_enqueue()
Date:   Sat, 28 Jan 2023 03:07:18 +0200
Message-Id: <20230128010719.2182346-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 2223bfe4-32e6-40d2-cf1b-08db00cc175f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0cqxmhbmVsB/L3PswBDN1P3iIO/14Jnz3lCTwyV7v61WmwHNHUPz5GzZ31EaVJfZ4CZi5wNgjRecRqDE+guQ6ppMjS1tKnIjsSuURKkU11Ae2WU49vsOFmuOT3pjH1qQ67XPuN3eOrs/Jtf1rZtXNHN3J/zI1SbhVPkyp0r1IOU6iQIc2O73DTZtcq1mEJYgMDVX1GJtEizG4H5BAabO7m2w6IExT+viaWdeMVUng/cECdNRUyQohlNZ7jb/rMTIzweBRqL36nO3y+cH4KpuyYiYw28VofUYb5ENpXwg7amQ7yZNHi3FuEIguzWknNzGNYZw7YULtbXg6H5gmUuNEbMu50p/1bG369J4dAKKVn3uaMbhuAnTRjDieGK8Tvthy6xeZwQyMfqmu4evXlE/hZIMXmiEJfo0V+rqwVEZMfOhSDwXpe7wK/1UNkkNCYldA58HVg71n8dKp9NmdD/SC+CAPZaD9CFXjTRLx0f47WGEslU7/l0IlOCql2si5+U76lbbOB5PEYPtHJIBn8H/LIq6/z8/pLZLSec8LHVZj/4DKBTmfKirWeEMnZyeaANhpSYEiifDX4M3IudVYErgYvv/65izb0VZOMh4Aa/KLtzTc0YBRswtmU8bn3TC98yF9Te6JTeKZFOBpST1GL3uP0f1LuXE8Bacbt9XJzJw9rnmjpd5aSCcPwPHSrk0MeKgBXRypNz3IYKVpxBXohovQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7zuPyd3Doly7fVgumjXHGYEt7yOth5ZeqsP5tSfcIFmOMc0YK/8f+Mpdk5Ci?=
 =?us-ascii?Q?LslkMK0JHLenyYAAgh4q/vkLpnU/oFWRXY+vSnUFQQWV6dkZDSNIy8sCXYHu?=
 =?us-ascii?Q?Ees7GibIROsNk0D6sd8SJvP2pRB9+9TfC8bFJdL6rAaZLJ4VA7mTNYn1OXMb?=
 =?us-ascii?Q?0qk5cU/fin7tYfzf8/xLqwayy3oJxcxUt2qYviqTH0x34eZ/L9yDhFe0Jkic?=
 =?us-ascii?Q?DZyT/KXD2jKYT2JIZm87SRVEkySD8K2HC9swKkHTEaWB8bMbydhvZ8sVFE5A?=
 =?us-ascii?Q?2VHD3XLdUY095F4OxEwXhkZjKASqa2P/duRL+soEHyOfh9oOl4QTsuQESCcA?=
 =?us-ascii?Q?0fqIjamMr3tVM55XprFhrPVCJZ0OzmHzIrPzOx64iaAhW+zKspk2OEb6nYjY?=
 =?us-ascii?Q?ZQ6LWMa0dUQfqCTJwfvavwb3vg8eV46iaS+9pQTV//FTNbXwLxErU5H53uwl?=
 =?us-ascii?Q?53qekI+x2kDavvcYGv/zXs1N9NkU80JIw9hZa4Qc8ofALSknaTFDYCKVGeR7?=
 =?us-ascii?Q?AAyv0lAUaODVU6QKCWJt7yIpwgD/erKB/kqC2o18DPF3qth1y0F6JWSaNCe7?=
 =?us-ascii?Q?rWajyfysLIaYsq3jplaH3xyd2PrsTlPI3yc9GGSS6h7n5OT1z5C2oIYJqynO?=
 =?us-ascii?Q?0kCMmOrpLXLUEL057Lm9RwwcU3WvmYIiqjKWCWsff1FxR/ympnD0BfyWrWWo?=
 =?us-ascii?Q?3aUtbDFpYJmXVsMmhdabve1G9iIB+oa3dWpE58UHeNuUbUSz1loOdjhEq23u?=
 =?us-ascii?Q?vE5xHY9FeATD8Bqk5f0SwP7cCRPDUeLHnjpxl9atEooZyfXtMlOqmDPkxPjM?=
 =?us-ascii?Q?nxOQ5ocOLMdTuvUx2gan6+yJIfOncca6UwQ4t7CnbF8OzVqQdgFUFX2HKztd?=
 =?us-ascii?Q?hekD+WJ+SzlHSr2DmQApKwEcR+1OvEbIafLmNxyc1B2uK+NupFiH30aforIY?=
 =?us-ascii?Q?o/vHQLjeuS4fGRbXbzfHjPpgZz3vvQd/arawJB4qbQEgFhZnd6z5luArysz/?=
 =?us-ascii?Q?eIJNSusiGOGYY8UyI5g2s8+H5pswOtWnDZxmk8lXterdA/qLjLWN0AyC8805?=
 =?us-ascii?Q?8ZUh9XrrEbyhu2nxNzAMUkc20nB0TSN+bs6nsde8WTbCvhvySVp7MRUMdhjl?=
 =?us-ascii?Q?zgz9dfUkuWkCxgsWlFHaB4B4cto9u9FQLDMYe5GF3BBwcE1p92oTbdWqyd/c?=
 =?us-ascii?Q?hbFi0z9yEuR0DXReG0XV1jUUnMY7/AnRR/7ENPd/rxD6Q0Xhq+4y0zlwdWYY?=
 =?us-ascii?Q?kyaoeutqMb1NMC1D7vZMYGh+AUky6WLjUl8rDYzIVSX57rrNWv6WAjCI+Ztw?=
 =?us-ascii?Q?ut39pG5MI1umpS7WW1Chb+uGryayO81Xdo/EBdp0MS0ioN/RwiwMJgrrpjTa?=
 =?us-ascii?Q?7O/nz3DAWKeSpzbNCkVhVhR46NwvYNiE4MFjuxWWGkF4UTJwbj6MugAv4f08?=
 =?us-ascii?Q?dO2g4CD/c+ls/Zidqz0ywCyMZh3xNBMS0HWlHsudpV3rI851xR+RJnsTxjN2?=
 =?us-ascii?Q?Es3SZUtVJ8DX/eR/utnSrUFZyzAE6FJEWO2JbIhIcQaWmrvQkXBBmcOQwCBI?=
 =?us-ascii?Q?2vADxexNG31pJmMWZBKY4aCUzSkx/L4WLix3R544uhJMeV4S8YTYor6p137C?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2223bfe4-32e6-40d2-cf1b-08db00cc175f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:57.0415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTslfsXoOpiL9PZh+YRkJ8eZSA7xlfwoa3wguUZ8IzbyamKKhO+0ycTB0YdVaYjHAhtuqeZ7960Mk7gTGNYiOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The majority of the taprio_enqueue()'s function is spent doing TCP
segmentation, which doesn't look right to me. Compilers shouldn't have a
problem in inlining code no matter how we write it, so move the
segmentation logic to a separate function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 66 +++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7a4c0b70cdc9..cc11787dc62a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -559,6 +559,40 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
+static int taprio_enqueue_segmented(struct sk_buff *skb, struct Qdisc *sch,
+				    struct Qdisc *child,
+				    struct sk_buff **to_free)
+{
+	unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
+	netdev_features_t features = netif_skb_features(skb);
+	struct sk_buff *segs, *nskb;
+	int ret;
+
+	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	if (IS_ERR_OR_NULL(segs))
+		return qdisc_drop(skb, sch, to_free);
+
+	skb_list_walk_safe(segs, segs, nskb) {
+		skb_mark_not_on_list(segs);
+		qdisc_skb_cb(segs)->pkt_len = segs->len;
+		slen += segs->len;
+
+		ret = taprio_enqueue_one(segs, sch, child, to_free);
+		if (ret != NET_XMIT_SUCCESS) {
+			if (net_xmit_drop_count(ret))
+				qdisc_qstats_drop(sch);
+		} else {
+			numsegs++;
+		}
+	}
+
+	if (numsegs > 1)
+		qdisc_tree_reduce_backlog(sch, 1 - numsegs, len - slen);
+	consume_skb(skb);
+
+	return numsegs > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
+}
+
 /* Will not be called in the full offload case, since the TX queues are
  * attached to the Qdisc created using qdisc_create_dflt()
  */
@@ -580,36 +614,8 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 * smaller chunks. Drivers with full offload are expected to handle
 	 * this in hardware.
 	 */
-	if (skb_is_gso(skb)) {
-		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
-		netdev_features_t features = netif_skb_features(skb);
-		struct sk_buff *segs, *nskb;
-		int ret;
-
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
-		if (IS_ERR_OR_NULL(segs))
-			return qdisc_drop(skb, sch, to_free);
-
-		skb_list_walk_safe(segs, segs, nskb) {
-			skb_mark_not_on_list(segs);
-			qdisc_skb_cb(segs)->pkt_len = segs->len;
-			slen += segs->len;
-
-			ret = taprio_enqueue_one(segs, sch, child, to_free);
-			if (ret != NET_XMIT_SUCCESS) {
-				if (net_xmit_drop_count(ret))
-					qdisc_qstats_drop(sch);
-			} else {
-				numsegs++;
-			}
-		}
-
-		if (numsegs > 1)
-			qdisc_tree_reduce_backlog(sch, 1 - numsegs, len - slen);
-		consume_skb(skb);
-
-		return numsegs > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
-	}
+	if (skb_is_gso(skb))
+		return taprio_enqueue_segmented(skb, sch, child, to_free);
 
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
-- 
2.34.1

