Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C680D68D9FC
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjBGN6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBGN6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:58:04 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2081.outbound.protection.outlook.com [40.107.7.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92F0CA27;
        Tue,  7 Feb 2023 05:57:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGjGcAkTY8vDIWgQr9AVlpv1j/vRHM2vtJInp5aSrKBuZ3guxl6ioGNBQW/zhuteKuzz+MWEAbsjcZj76z6qNbP3E6M/844l3dIpBiJd2DOnFFEWqGAfYhkB85bokl6OFyYblC9HVLe562UiQOUiqcd9N6svhEgLvtAC8qqHacXu1uY9Yvr/Rh8XxzduZI4oLP3/JXtQHzcvpce63xb8ZmDPAcn3nndLxhrpg0Rw6KbHuovAX44OtV+8EucbH74rOrCZgGEI5Dtd+sMhN4divu/LfFXqws053+AGD0+LrcHbn0Ygy9v8AVu7Z/zcT5tSRc79AMWyyB4K0HN9MRXihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeDbZNGeWgvML5Hp8qKyu92dq/8PagPxjbc5NDdh5jw=;
 b=jq9+EqSiv/mIt/LG6xIjp6uviFbU74oaPWqRc8fe7PFMcm19xPR3gv//nFBsOKCsiH+paZX3R8YDWssWW9zHuZbLO3G5mpZIHd3OnSdFFNI/VkG4lsp4Jt4smMryDCSGul2Gll27Yo6iXRi2P6PyLekJ1Jl9cdQ+ykAldMCTGpcmoLEmE5g17RepFO3PuI2DgNRrJTkTFUzE9Jy7IxL1ol8PMd4oIe3BhmB3wFq/rNJI9Yd13UffbRG8fQnx+63KPLwjo7bQ7k9VIZhDTSQa6XVk1YiRdoAtM+aFevFl21RJppegnhd4Ia4HT/GitnEg5JzpC6kiOEmw9X+td+V3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeDbZNGeWgvML5Hp8qKyu92dq/8PagPxjbc5NDdh5jw=;
 b=KvA+bv4OOmmIcTjiFR+S8BJxM2IjU3nqQ8lG1ODT7OvsLJvYHMF8lQ/zXKIYRKeERXcXco0uJU471NwldyvuLtSZtBUkoABCqe41nL/2M61l0BYXv+xqmDCLj+vvTbNych058w7o0T3oW95xl5LqVOdpcdiUHyqkMECD+IGfMAM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 14/15] net/sched: taprio: split segmentation logic from qdisc_enqueue()
Date:   Tue,  7 Feb 2023 15:54:39 +0200
Message-Id: <20230207135440.1482856-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 90aec37d-a53d-4815-6164-08db0912facf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIiH2Vq3XrhK+JB7Lfb8N4DE2RuCBgvhl7AMH3WmI6F9BtQxOlIO6vCExrDKxA2dt+mX0sOtORJr3lhNr+N1QAoBbaVg9H5vK72LTZT/DNGiTVKaVqB/EwFJ9BlwcmSC2Qig7TriHIckAWaxtq4lg/OQCchvUTYFd4FdVXRiRLTwhe7OVnuesCQ19qSF6QEmiIF0rYh2VJRugztAaUhdS+jVLhKniQqMnzrFNjla3TsNuXjgomu/UqK36qEG0A20hQegGlsG8JCxurH+sPtnuGvY3RjsJYRCj7oETIRjrzAK+Lv4z8e3cEJEYHVAvaDyTsX78T0H9DPorEmyc7gbkTNqmIf/z1Qo7YRTQYdaCAvk51Jq1NIBf4qGK1n2DuPEfC8fezG+ycCr3gKbFXTly3PXLndwXFYctroyIFhQNu7HWwKZkm+vmPZwYen/cBktWexzneF2/Q8fmimrXoVILfDFxcceufRC3FkIOlAn1Px5BvEIctj+Paq/P3dL7d2CmfLBdtRvP7jRWzuPT/cCX+jEv+aF1RbB1EQ/jmoh7weqRf43dpOchCh52w7ZGX9GKGzGB6XdHCIV/yl8/6+T3KQD91sSTF+Fh92ZEaQEnf0uqVixMvpY8aINA7JPehLFmJppA37t8xRbXoo5Ye14uqybV0qeuhgGX3sdKXON85hrWJVtsHv376v8ZF2dXN984Ra+srRhQEd4DcR8VkuH5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hsSHk5V4Hcpd35RXkW9iux5IaR3caKsEzf7+ancpMhUCQtOCv10htbQahbXz?=
 =?us-ascii?Q?PaA0P1urI1HBl8nVVCDyfuih3jH3E6qZ5TevdfLS+AJJR5XuxXjwrLOoqEZT?=
 =?us-ascii?Q?JD5Exf67KeJgV3Ztau+OTaswajR5W1Z6O29pYSpwPMhDqlbR7gMeEzg/0xAB?=
 =?us-ascii?Q?ERXxFC+RIl6YfZ2TnN8nR2QWs6qcZQ/UpSBPdYcclTSLb/gH9mX35dFQp1or?=
 =?us-ascii?Q?VP2pspeF/A+/NNJBKQw929OjzbXPK4kBFdMYL7+y2gapAARoUjd6zV+6GpV7?=
 =?us-ascii?Q?nI6vAJDfJTBxWGpiijGPY6GdnF6Pbrilf9kzxD0gdwn+oUQXHT2J+Ps9MgqR?=
 =?us-ascii?Q?1jcdxsC1L0GxbBAnFDH9+hje1ORYOBUbeoC0lWs3zNptYWKIp3RhLPS5Hv1h?=
 =?us-ascii?Q?3iUPsfChpVFEKhhbpqlmDX9ReGsmV/pNDKYgk0sREXSxCilkpIgnUk8vo+x/?=
 =?us-ascii?Q?NmMbr5vjt5R5F0WcN3x4gBgoIGJBtsIFhJ3hMhV5hfvBNX6n4EExcgxELP5U?=
 =?us-ascii?Q?/GgO/BK7XuQqs9okOhIfMy23UBAzAUH95ZjlEx/4D+UdNtAnOJ5oXIF+amNI?=
 =?us-ascii?Q?kflW+FMVkMy8R7yxMKDgIxl43eo1k9EPOuYWCWjgpvsiLrL1yAL83Za3uH0x?=
 =?us-ascii?Q?wa1HJo9Yh0GJ+cjsS2gwBSBy09CGdaAFcsUXTxj1smj31Y+h0h10ASkxJzMW?=
 =?us-ascii?Q?27/vuvBI17yZc3JlgSLIpvMwvmGFbbws3tBfXhb4SzKSH5FsRHYRr6VIt5No?=
 =?us-ascii?Q?IpvU/phu4jkJwQBSLBqWi8ycPHKNnmbsUPOSiDQ7qgRBJf5zsrmLOWqP/0zE?=
 =?us-ascii?Q?Wc5hbHPCNDzv+UsS90FfNm6DkKiZbBT7xTQuo64K08FolXcxNB9vzlc+TUvJ?=
 =?us-ascii?Q?4hDQJUWZ4BVwkW2dkplc3zId2AXXayqW9peTlPvOSZp0o7e1Zxi1kWgtHnsH?=
 =?us-ascii?Q?mmAS6/9Guw9cDumlc58nmUBHNuHmRlfaraWgIVUyPTOQOpbMGhfC4CJA2P9N?=
 =?us-ascii?Q?1cpOdjMJuXGO54g1b2lTpTAT3QXSKQddUSVoFuiQX7Y87LIXp7aUIDlIMKCJ?=
 =?us-ascii?Q?OiS9f0Ly81YaHXVq3KGKCuZcSLVSEP7LDPE1zvqgUcoLIPwXQLC8uiga0vVT?=
 =?us-ascii?Q?RNRO1lt+oae0AfJ5lf07ZVNpOH93h/eaj2EUK1hiEG0VPD/lf1XAIUPuaK1u?=
 =?us-ascii?Q?RZLRxhvXD4lb6o6vYA5oS6BeZzwIn4LDGGRf95hq2Yn6yuxJYNWGHtUGNGjb?=
 =?us-ascii?Q?CWEiDSUtup8IRa31yuKuY2ymSyo7QcoxD8hYft1jVfb+9a9ustPr67b9kKtr?=
 =?us-ascii?Q?M1Kk6dPs/KsDdQuy4VG6hRovlJWQD1LmtyvEQy1gg5iz9/V0i8R5Dw7Q8zYa?=
 =?us-ascii?Q?FLM2GhytyjdbSIXufreeqC1IXIfHiXLaCf25UFIuvpvU+HAzhJ8xM7u1vwY7?=
 =?us-ascii?Q?j+nXVfwQhH1IuTrnq91ro1KsU9unMXDqd9L+PSAKj0NpkPQ5GMp5JxrZ9Ee9?=
 =?us-ascii?Q?phBFIEa9FTcAFexhMbGpxGbotxPRkZr+1W6/VsDUIYOwoH4p9MNLD9DrgJ+7?=
 =?us-ascii?Q?UKPDLLDzffMEAiwC4xybOruEFZ4pWafpvLu+Ls6UkwEA952VRb5pAykAWioF?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90aec37d-a53d-4815-6164-08db0912facf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:32.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxU7qpqsV/8X1tMDWJN4NoTPOOCdTOYZ2UfwPdMl201UwDULUbOfbW1cc2JPU4BzKczYy9kVn7+DQhnQ2yvm9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
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
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: none

 net/sched/sch_taprio.c | 66 +++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index e7163d6fab77..839beb599f55 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -575,6 +575,40 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
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
@@ -596,36 +630,8 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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

