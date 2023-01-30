Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580FD6817AE
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbjA3RdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbjA3Rcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:43 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136FD30293
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWmjRUINTJ9Nmr/D3tomhM+eJeq40gIXnNLUegvNdZWzecoDRsI1n56ur+Hz/7t2hCMla/Nx1z4jlqNMMCuBgwtn++zAgDtd4jr1UghXu9+GNUSKXLghUdQ9wnH2uno8D+tTobYPx1g9Br/QMFcaknUo0r6pbyK3jyFFFfLLfJc+rCEG/haLIkBYOJro/32iIw1E7UXTDdWCKOOn0ZUIyQGRznN5zHmZb4KofKXpvO1Vx5aA2p9LzAmoFBqgyNKpnKHVfbm7+tNgxoV68OzGWOMG7L0893btPpMNQkQAtv2LfJHIoZT3DWm8eNbWxzVMj3r9wIT03ng7ZmkNbFfb/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yB9mGGvltL7mehrpOYOF3l4ByZGPBTmoYKbatYXJsxI=;
 b=VP5LI/9Vfv4is8tpsMA1OeQk/dj6rnUFdrK3v+idF8obsqqo3ZaSjG5ajoIbZ4cndA+ahZIxdD8zE6jM9h7phq2BzPL5ReHeLcPlpLQjvVwIRtPkmSkEzy6aykcYi7ck7mg74124DpYPK7UxoKACli1CjQpP+AsGm6euDBwASfVpw03N32YPW1VkMCxTP1gGhxbayqh+T5CVu9zcx9nlTRK5FOPb8VaUWU/kXyyfp39NhoMXfYX2Z56Gd/qBgWlGU/EuiArrHW679jHlFTPcrCCtqmWn4DbepGH+SaH4w7g3Pfhha6leb6ehpfMhjTqBexIVw2+IISvKaF682gqORw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yB9mGGvltL7mehrpOYOF3l4ByZGPBTmoYKbatYXJsxI=;
 b=KHtd5mVbFh64RQu+uBY2XT/Bn5rpxEDEEZfL18G3+7kv8JUGyRTmLVwFbqCoorBki1gNX5rIwuLsqJWKYhfut8YqFJssG0pmkuZVfjSTyjsYsw+isrHBLdrvc3tDH7PyKa4yrOYI0qf3AbXJ7ygt0EoENDxdYSR8nmm+U7Hiro4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:23 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:23 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 12/15] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
Date:   Mon, 30 Jan 2023 19:31:42 +0200
Message-Id: <20230130173145.475943-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 2783185e-d985-4ae6-2eea-08db02e7f21c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f73KAifW/ColSNbIAcrFWov0aWJwfclhKixFGhnaJ3ONpzIFOR3nYcQc3Lu1RrtEt9j64yWQHNxIWC1Tekm4mfzgKdJHZbAk5xBKlWj4o3F6KXJhAtXQg26HUNy1MQHZUnLaiYv83zjCZR1VGY7MPjA2ETS5xF6WGBi2JIEXgmGS/JYR1z+ov8ZFuLY/xhnkWmxgceRBUJJftHg31YRnV+aQyFDKo/TRJCDU3TI+XRYufc1/kDucQ0wA3u76HMEjU0TDwUc2srtgHorVKF6mLUl3NEW5/l8XdOsTGb2IjfHfJUZNdh+JKIMOUnhfzTU1C6fEwTCjau9qmarM+RgsMKujHKYrMUeFa/T6xoV2PQtsVlTHt0S/4rVV/jWtYG86py7SMwD/fVl6nvCtm/nyBEE6oa4oFZfkBvznh/CkzfqxDmFUvM2w6nf5t6zUyEpdgNoLyig84lyO2YB6ZMGD0ndxcuwkBFg6DHsYr5sYIvrMWzZhtkuds2N1mRbU75qZ+2fxm57fgc9VJEVC8evudJMu1fS6lEThtXQlkSY3aN6FMHyxJP8p0JUPbdbf142fn4ukjYrSYbdcBEsTVKNs+jenEhU0P4U1pVdEro1i5j/THX3dUuybcNjNK5iH9x6rLebLRLc22jC6DhwnHuIrYG0XhT+pnNor4Id+NmGphVx4+brSgKSFQRqTUAmDF0NB5XNjNtucBb/3iRytRjnO+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bm9e8pdbp25rGbKBrEy4o0yJILDzsevLGBaZXVZeHyStIkmNf9DASOgafNfd?=
 =?us-ascii?Q?mgLZvaozeI+2bBQelC6k3P7g1i7YKF7olJTJsahv+uyt6CUGaHar/pX1TbAQ?=
 =?us-ascii?Q?q3kXBtwIegMAc+fNrsoD14S0y9lslZbXOUQVCOCo2C9HccBn+ybowbfjrn6I?=
 =?us-ascii?Q?EpmyMNNIQg9bw17zlnI3P0/a0PVJ+3auutJRbAcX1eoCYyKE4P2AVgAJQxf3?=
 =?us-ascii?Q?gZ2CEfCgnRMUoy58deHHGa1iJ7dfQ+MdbXufZ+rro+h07DDLR3sxr/+JjWCc?=
 =?us-ascii?Q?2I2EJqR7j59MSHU661D8EKoJmw0PiK88YnvDwuBf5Yd5coON2ji2Tl1i4i89?=
 =?us-ascii?Q?06e11r3miky6CLz3jhJdLEpf6iUtRzqS4ebi6FxfP8Gow5/fupY+9SLs+4xh?=
 =?us-ascii?Q?OvfI5srPPwkk0cB+SkPeDWBVW/9Bw/QYaBPfdsi9Oh2Cp+MgarVxxP7AF0ea?=
 =?us-ascii?Q?yMuj2uKb49gdPjZrnUKxVfKoI3kzdLbPK9k+ugm6WJUsT6iTF/CBMEXsTRjX?=
 =?us-ascii?Q?i7YJ2v1OE//yOUEXhYGl367qZZ5uatmGo6pTJbWl/YCoJ4i9fPZ8h3RmWwTU?=
 =?us-ascii?Q?u1U6F6fDKMlktTiezdOs1J1LGDK+t+Ke4cisaUMQ07nvY9nKyslurIJVY08u?=
 =?us-ascii?Q?0KKRZIDgHzp7DqVxqYlt2OFXrms+yut/U7syb+zx+5VMMkFLhSJZ5+R7iVIe?=
 =?us-ascii?Q?4ZmQriU/b4wUn2X4ohqdA1+CG0tdz8hCcPmTXeNxmMrJcUAJpQkP+D51eQv0?=
 =?us-ascii?Q?SWWO5+0RQ1NFt2Re0iXxSRcysbmH27J1t0X8xYmet/jrpWj4PTxCtPKDZX29?=
 =?us-ascii?Q?XaW/rQBI3jqEwJb/Hn+z+FNKtmKwSbKuCej64PpyidvTkpoWSwj/omN4rq8Y?=
 =?us-ascii?Q?ydv3VdvN3x+7fUNcGP7TSoqitUwznduC7EojjMJV0nDGoLslL1vD+YUaQRPs?=
 =?us-ascii?Q?OtWy5skXo0d3S0FhEiJ5PEOuixbI3RdmtsCHznZQ/9Xu77prHpq08fWC1jAl?=
 =?us-ascii?Q?kcMewq6fHBlSE9II9lMYZ/mvwGOfwVwZrs4CNjWeVtdVsgYVsqeZIDO3VaDU?=
 =?us-ascii?Q?cnsamXrlodHmTH0XghsiDJVWEp170ZxtMcxT3UOI1cLbJY+9Y6sFTtSrJOmM?=
 =?us-ascii?Q?O/DDKmsydHDfLCOPFce1SL8ZvRQJXV5NVXRt0uvXE1fYaj9twGK8NblbccVb?=
 =?us-ascii?Q?bCHFpcKZlGAyFlsH/DHpExxeQvquEFPOdDSmTtRmQ+RfRjIN4XdYhVwy10U5?=
 =?us-ascii?Q?plw92+3CjNbexKcz+8ZXtOCWsy858FlqVbrEM29zE8uHUm2iCFdvAqpC1/mE?=
 =?us-ascii?Q?2Yq4j4z7Bg7B/4Y74cb1BcoWCYwvuPIy3bDBx7+wIPPPaIEamBUd2wkagWDI?=
 =?us-ascii?Q?Rbm44hELzs7fP5ISux7pqxQJb0pLezF7kMhWrh27LNT2IaFnT27VuD66eZ8k?=
 =?us-ascii?Q?70GAzKwJdePSUWYZ6ci9UMQMo/i8S8Rl7rO8mvfoaZlZt7pLijYrmbLPC46I?=
 =?us-ascii?Q?NxZAe5KMVZW/crh6/MTaqeWGTHK/bIieojwLTkKGrY/0H054QfadghNF28q3?=
 =?us-ascii?Q?UAUl2M6aVm97Umb6t23zg/LPCEkokDjKHyDPMuIICkUEI1mRCCZF+YixqrK6?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2783185e-d985-4ae6-2eea-08db02e7f21c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:23.1784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPCThPmu/kSQnvdouae8mwICffkBSsLclbQhrOUzkATc3mZdgrWCyBxINXARK4BJWn5gwk1AlhBKVClcZ03UCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio offload does not currently pass the mqprio queue configuration
down to the offloading device driver. So the driver cannot act upon the
TXQ counts/offsets per TC, or upon the prio->tc map. It was probably
assumed that the driver only wants to offload num_tc (see
TC_MQPRIO_HW_OFFLOAD_TCS), which it can get from netdev_get_num_tc(),
but there's clearly more to the mqprio configuration than that.

To remedy that, we need to actually reconstruct a struct
tc_mqprio_qopt_offload to pass as part of the tc_taprio_qopt_offload.
The problem is that taprio doesn't keep a persistent reference to the
mqprio queue structure in its own struct taprio_sched, instead it just
applies the contents of that to the netdev state (prio:tc map, per-TC
TXQ counts and offsets, num_tc etc). Maybe it's easier to understand
why, when we look at the size of struct tc_mqprio_qopt_offload: 352
bytes on arm64. Keeping such a large structure would throw off the
memory accesses in struct taprio_sched no matter where we put it.
So we prefer to dynamically reconstruct the mqprio offload structure
based on netdev information, rather than saving a copy of it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: reconstruct the mqprio queue configuration structure

 include/net/pkt_sched.h |  1 +
 net/sched/sch_taprio.c  | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 02e3ccfbc7d1..ace8be520fb0 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -187,6 +187,7 @@ struct tc_taprio_sched_entry {
 };
 
 struct tc_taprio_qopt_offload {
+	struct tc_mqprio_qopt_offload mqprio;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c322a61eaeea..f40016275384 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1225,6 +1225,25 @@ static void taprio_sched_to_offload(struct net_device *dev,
 	offload->num_entries = i;
 }
 
+static void
+taprio_mqprio_qopt_reconstruct(struct net_device *dev,
+			       struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
+	int num_tc = netdev_get_num_tc(dev);
+	int tc, prio;
+
+	qopt->num_tc = num_tc;
+
+	for (prio = 0; prio <= TC_BITMASK; prio++)
+		qopt->prio_tc_map[prio] = netdev_get_prio_tc_map(dev, prio);
+
+	for (tc = 0; tc < num_tc; tc++) {
+		qopt->count[tc] = dev->tc_to_txq[tc].count;
+		qopt->offset[tc] = dev->tc_to_txq[tc].offset;
+	}
+}
+
 static int taprio_enable_offload(struct net_device *dev,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
@@ -1261,6 +1280,7 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	taprio_mqprio_qopt_reconstruct(dev, &offload->mqprio);
 	taprio_sched_to_offload(dev, sched, offload);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
-- 
2.34.1

