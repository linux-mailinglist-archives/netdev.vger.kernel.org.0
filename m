Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F16687269
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjBBAhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBBAhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:18 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA51174C3F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkSt0E4LbfuZ2pgSc0/A6xW623tvk6kHJV2L3sbFs6tww1FDDt+/mTpQctlPbdEtOXiA0p0ddC3uuZgUkvFty3e/zAla/GsegApycVQPZrTpB2qthMeGY5LUJAAFGNmISK2toyj7HlcR/sHPlATZuR4xi8Odtf/fP/dyB0RtvDbvuPLPrNlBf39gHaPRGu5bQdQxe69Kk9sdd2lr3ZRdMxCwQcaTORu0ZpeOMtLCycrLfuyzKdd7Uk6hImbhoLzXGzKnuIFn075Tqat4L4DPlK0c27RqeIMALVd6W2wBEL/6XUqQ7+km45Q0f5N9wYRGFM1OzVTUpskl7imIMLdjLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Prt7wkkxqWopvzne3iRQr7SzGf2xuaY3ocfgp1tKZfk=;
 b=AUxkX6McbtCxyuujtC6I5AA940Of70sgOCjBIAK7IxyKXNgJ3oS+07r8rNL2MqbQOavn+E9fR5Gcw31Rc+ngftX+IkzFEOeCQY9F13g6cg98srMlYUDvOKQxZODFFJvFbKKiGCTnrb62qBulECMBTR+Stau97jwhvwd6EV8VUoE8SyyeGYJSDoLv5uLKQLMBHCw7bHnem5df40cFuMmRfMZexSGuo+rBXrim7QDausSLwyJhPtU01HfOBoBt8YKJFAx9S6egZ3+aza3iGz5BY0YbHvhC7fK+GZ4cX7O8y13hD8wQGslD43Ny0MTLPptcc5LdxGQeRFheXUMD41lv3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Prt7wkkxqWopvzne3iRQr7SzGf2xuaY3ocfgp1tKZfk=;
 b=Y5zSG8Lp2/LLEFlBTSyQjLreZ/n22FZKHE6kO3sSg+k6Z2e1tie5lnax7AN1EMIOFlVj4zMWNOeeBDW2atpI6iWtFDd2n8FahhCIoTeneonTi/TsS9dSsgw73lGsz7St+sXzFMTzpBu4qUG3JmmHQIRUy/NAbBLOXne8UPvqtBk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 12/17] net/sched: refactor mqprio qopt reconstruction to a library function
Date:   Thu,  2 Feb 2023 02:36:16 +0200
Message-Id: <20230202003621.2679603-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ad3baf5-2329-4e6e-add8-08db04b5983a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Llzlf+EHA7kuEUMKTgULU393dYGLxAJLzSKn0umPtW6phyGhzWd9qmtOXi5AzSpz179tw+/LfIfCmpWBRQfvDTqjj680MbUlLBc1NacyiSVBOT+RQASGTNQVNC6veScT2EwYPtlv+mQiqcFrcTPSIFEjq+Gvr+/XDTFIFbZWHfhMEFePJoDDlq6Hi6Gu6jC1Xzth1/5ljjkpOWzWdmqcH7WePHc/IZ6wfQEdqYCwiMzNLWDUbyl2GylxcrqmES6H8XWCpDdsZJUJgMk/GZyiCqLLVLns7eZDJ4XxeSv9KRzHpMOXNGOK2/6miFYuKr0BJAwYFlvX6s19tg8h+UXqMowEwPTMQB4J/w20WUa9TRIfCetTzcTd6qWatIuRDKEfspcgaZ3uk2TSvGPIC3a0dUYznSBOzIBT6fCEixRcFcb5mXBGEvTIGR1EC2B2LZfeOzT2dP7rwHxJ6teQYaw0MGgodzvzgST4M8jTUwKwof7S6lYBliHx/d++UVlKIk8S4OHom8fI8RrtJKqQqhMVGsNTg0hVNhO41onxYsqz6bI8XMvDsAOaJVUBgd809dKEII2LgEk17Hs96s7vKyQwagSsEcAVwN8Zc7N2KHt9T5dWYUJlEoVKzuvJBZhF7jBANKleBjU8eUTNAriHWlfbmQYsAIGqSYplsq10nZdgo9w/MIRFtBmMBVuBDNfKZlB+X361+cHWJ4dalqgKj+WK6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o1SOlkSAu9ff77N3nBFCFrCNpi8r5wm9y7NZ1VcC8Ak+Wd/YIXVFKUjesgnw?=
 =?us-ascii?Q?VZgKbEdw0drkeHl8/nVr9ybE5Xh1fwOVd2fs4GSq/q1wIJPzhKfFP8ldpHFW?=
 =?us-ascii?Q?GfIWeMe37YUp7DWXd4jMGpUONGxrvV35M3tYr0pBNs9ftqGpXpOnXIUPHfcN?=
 =?us-ascii?Q?dyErSBjgsWdfY9WJfjxQW1sAswio/6x+dvus2x69EGxNtwCIxiLR9rqhlVw6?=
 =?us-ascii?Q?NZeHbYt1P45MJ6z5waV/yNeSfLExtIs77aBCMRxP59zj7fkAgsl+BvOKZLdA?=
 =?us-ascii?Q?SL0Uyby7YmBL4quKQ40Mt1jVrzNRaEQiTwKiMoyPuuIkA6p3A4A3auxip9Vm?=
 =?us-ascii?Q?1DqKG4hQ1fwVW0i6J/mwDFjr+0xcIgV4reT3Fz90yT4Hjeu1b6p6E6Dt9sHi?=
 =?us-ascii?Q?zg6Y8XxFDG1Jc7iD3SoBllhTNIRYNYcluCIw2RwObRLIV+71OTxbm+RRd+rh?=
 =?us-ascii?Q?u4EmJAroaAQOH2Tqc5hWE2gfaoNwUdzb53L6su/2AboQmJwD4D4D1nERypBj?=
 =?us-ascii?Q?DUSsA07R8UqYob8nv3aTTFBj0Hwh99PKFwjzD82lWu1j6mfcm1mBF6Bnyhi+?=
 =?us-ascii?Q?WRVaqH0G8iV6XV0HAsUqyr1IOCO6plMOgj9YFnux6cty3xhX8Kub1Yq0Zrk4?=
 =?us-ascii?Q?tMqIWOVTG2+HJl7AL20alZPPKKbVQbaEYjq3Dwv8L0FZnqYKX9gxvrLS2f+y?=
 =?us-ascii?Q?70xMZfTn0OIBES94dmuwciFUWywSEov0xCOni+8SGQx1FAvdox6/f6MMfeEw?=
 =?us-ascii?Q?YTFvKmSEEZ4wOZI9pBHafpwfux42NzifEyf4KnIEZJbX9Ail2s98FxUi4xHu?=
 =?us-ascii?Q?iuUelEst6KmmIP9pvEtjbnWfaMw13Hmr5iiYwBlZejRJNn83Pp2u1MsvT7K+?=
 =?us-ascii?Q?6SwVc/OrV/eRtaRWO+lnNXJpiEp7NRklTO/cXS3P8H55u4U+AL5Gictnhra1?=
 =?us-ascii?Q?/69MiiZvakqjtw80JoBs/MY2tpsPxTdas08pD1DyU7WsrCOOV/1dyops2pmu?=
 =?us-ascii?Q?YpvcHRENAtZAtZZ8JecsiCmq2vfbFNgIAM76q+hXxy5w6BWFeKr7PogGY4nZ?=
 =?us-ascii?Q?ZK8SS91arqrFgMuUE7nAw1Tt/7/qCCia5D+qEO+KlWyr+RYHd07ZbENwl90I?=
 =?us-ascii?Q?44Via/Cfos/ECANVtIi2+IRX41T+zOhpnWQ3kyxTA9iVvr36aK1+kvS+dAeu?=
 =?us-ascii?Q?Td2zptOfEhQ3kC2dw0OoF+rR4Jq0NrLeD/Wi0BDDZDjuSnHBh3ZbTImeon80?=
 =?us-ascii?Q?j+jcrXBzXRH+/eE+ccEPyJ8idgzEQ3yfwjuo1+JHcLDCQsJcFYHkx763d3Uz?=
 =?us-ascii?Q?7iovtGImaIdzeCwCK1qFtSYJKAX5MrgHGgZLo2TE96ziM7NRmcpHMPtMB93i?=
 =?us-ascii?Q?BJL0BlP48B5MKIC+yTe71Exsjr7fRawC2UOwe3YMgK23h8x6NE/8jdSEk80D?=
 =?us-ascii?Q?rHnlYzHekFRizEIJIPuME47frzn9og2hEct/Ynh8FZTmpbQsX/TV7WaRfe8f?=
 =?us-ascii?Q?et9O6Mt+o/Aj2cC2mXsvSg4pFNdLwuyJXj+yXm3r+ZHgl/PCx/7w+qj4ksEx?=
 =?us-ascii?Q?WGjlaWoINfSUht+5WcawYPELa8p9EcLe/dbsbndgc2lVKci2xBXR/Awk+7AR?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad3baf5-2329-4e6e-add8-08db04b5983a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:59.5599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFVr7rg/8Ytl9eHFUFM1fAZ9IDebJbKW8RJwaPLyE6k24QuF1R8krITvHPMBBN8ptlC7IKLxkkTI3zLBA5Q+eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio qdisc will need to reconstruct a struct tc_mqprio_qopt from
netdev settings once more in a future patch, but this code was already
written twice, once in taprio and once in mqprio.

Refactor the code to a helper in the common mqprio library.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: patch is new

 net/sched/sch_mqprio.c     | 10 ++--------
 net/sched/sch_mqprio_lib.c | 14 ++++++++++++++
 net/sched/sch_mqprio_lib.h |  2 ++
 net/sched/sch_taprio.c     |  9 +--------
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index b10f0683d39b..fd25fef52ecb 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -404,7 +404,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nla = (struct nlattr *)skb_tail_pointer(skb);
 	struct tc_mqprio_qopt opt = { 0 };
 	struct Qdisc *qdisc;
-	unsigned int ntx, tc;
+	unsigned int ntx;
 
 	sch->q.qlen = 0;
 	gnet_stats_basic_sync_init(&sch->bstats);
@@ -428,15 +428,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
 
-	opt.num_tc = netdev_get_num_tc(dev);
-	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
+	mqprio_qopt_reconstruct(dev, &opt);
 	opt.hw = priv->hw_offload;
 
-	for (tc = 0; tc < netdev_get_num_tc(dev); tc++) {
-		opt.count[tc] = dev->tc_to_txq[tc].count;
-		opt.offset[tc] = dev->tc_to_txq[tc].offset;
-	}
-
 	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_mqprio_lib.c b/net/sched/sch_mqprio_lib.c
index b8cb412871b7..f57bb0869bb7 100644
--- a/net/sched/sch_mqprio_lib.c
+++ b/net/sched/sch_mqprio_lib.c
@@ -97,4 +97,18 @@ int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 }
 EXPORT_SYMBOL_GPL(mqprio_validate_qopt);
 
+void mqprio_qopt_reconstruct(struct net_device *dev, struct tc_mqprio_qopt *qopt)
+{
+	int tc, num_tc = netdev_get_num_tc(dev);
+
+	qopt->num_tc = num_tc;
+	memcpy(qopt->prio_tc_map, dev->prio_tc_map, sizeof(qopt->prio_tc_map));
+
+	for (tc = 0; tc < num_tc; tc++) {
+		qopt->count[tc] = dev->tc_to_txq[tc].count;
+		qopt->offset[tc] = dev->tc_to_txq[tc].offset;
+	}
+}
+EXPORT_SYMBOL_GPL(mqprio_qopt_reconstruct);
+
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_mqprio_lib.h b/net/sched/sch_mqprio_lib.h
index 353787a25648..63f725ab8761 100644
--- a/net/sched/sch_mqprio_lib.h
+++ b/net/sched/sch_mqprio_lib.h
@@ -12,5 +12,7 @@ int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 			 bool validate_queue_counts,
 			 bool allow_overlapping_txqs,
 			 struct netlink_ext_ack *extack);
+void mqprio_qopt_reconstruct(struct net_device *dev,
+			     struct tc_mqprio_qopt *qopt);
 
 #endif
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 888a29ee1da6..6b3cecbe9f1f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1948,18 +1948,11 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct sched_gate_list *oper, *admin;
 	struct tc_mqprio_qopt opt = { 0 };
 	struct nlattr *nest, *sched_nest;
-	unsigned int i;
 
 	oper = rtnl_dereference(q->oper_sched);
 	admin = rtnl_dereference(q->admin_sched);
 
-	opt.num_tc = netdev_get_num_tc(dev);
-	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
-
-	for (i = 0; i < netdev_get_num_tc(dev); i++) {
-		opt.count[i] = dev->tc_to_txq[i].count;
-		opt.offset[i] = dev->tc_to_txq[i].offset;
-	}
+	mqprio_qopt_reconstruct(dev, &opt);
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
-- 
2.34.1

