Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F20C5B23F9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiIHQwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiIHQwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:52:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20087.outbound.protection.outlook.com [40.107.2.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD208E9004;
        Thu,  8 Sep 2022 09:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WG2h5tA/2f3ztUmhxbmwyDK+mG9/c2t7uHOJbYrfEoG7ygHYZ65sNhyh4/4bcunk4wMOknuvconnJshyGfBPeb3Tjf1CDzAnDCJZzzqk/43B2sxIyRXfV4FzC+BtJtXqbxmOMLdrVcPSqCFcmdLm5pUJzzTbOXmSQ4EXNvBjO6yjP3RqPky3OQszp//Ev2Lnd94J8yQ+zY0p7iGUFlLthM10WuOGBiOBI47AbQJWO4jQmMZHeYm2iLTA1LM9LzvHpzOsGGipeon7m+sFyC873NBr+7mwJ0fcO+jCMDxRCV/XzpLFJBKiLYZzKnmugGpYKHkAqrMXjfaSbVybiRJtfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JBZxIYHganXC9206W1lSDRFR3ltuJR9gMupEa8vO1U=;
 b=QqO/yHOCZEP/p4xYK0fGqAKFxQBOjTP9msqmJppKwvWzNkBm9PZS0FoE55oeO68LnLvWMf/Ar4g9mG/JWmlTSMGZxwL9BFV/7aKT6k7aN1Dx/0w7az0wuuCTwixb+tEJfz3OH/VbR/IHH82+hzdnouzVviyq5a8uTSZ5G72N3z9mHSAOpDWFTDM2IsmTK97/uuzKpTdgzVsRwmAj0iJizYHlV9gxsvIXkqmk0sod6s0T1tSuv29xV1x3NbLEoiBHv8hEAhjM3qLpI/L55rOPRMvkt6EREp8Rbn2pkcVS/omrWWbSnQRAxQqB1pBmBqR+9Taybr9cQi+pbPGbs9Szfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JBZxIYHganXC9206W1lSDRFR3ltuJR9gMupEa8vO1U=;
 b=GFZuy9Yb/YVekqMHYKZ6ndWiW9KW1yomZNPHq8Tk1oQOm2McupSg3SNLBnkjf3gOMDvNFqg+PZwGpjNidaC3/k3rC//xuH5mT93WcGCHc/yMRQULy9MnEL1ZtCeWDgZ/rXMp5ycBxcCx3hgPD2HKcj6mtK4s4m3vTcHiSGOtg4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5154.eurprd04.prod.outlook.com (2603:10a6:208:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 16:48:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/14] net: dsa: felix: check the 32-bit PSFP stats against overflow
Date:   Thu,  8 Sep 2022 19:48:05 +0300
Message-Id: <20220908164816.3576795-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3336d1ce-17d0-4d18-9a21-08da91b9f5cd
X-MS-TrafficTypeDiagnostic: AM0PR04MB5154:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xIunJIi7gl6/F7tVGOQdSIahRZ3EDP1I4ZnzxI2Vvn0hInfsRLoacuV1MljTJP2+lY5EClMrl7PbwpdWepTsYbioEsCvcU29QcC2OyJUUHE3PqmylrmlDxd+fetbUwYQaFcvB1So9BV1x8qd5IsMXEgSyksq0sPQSpf9AufA/kxpl7atPgZ8RxRr6L6mDDBHaIUbcbsRj0rlNfxkK6oneX8cLCdu5UoXgdc78kNW49VIa+/r227+qFxli9MUBldyn47e01USDpsPKjU+CEl11+UxEywv8d4u+ay71hTZJV0VYa8834dRVw+zZNhlX8LrXaNVS0lv4EXEQqkV8vpqeHMRQd1pKeMlJBm/S2EwHw0BAyS/dTSiSLAo6LRd0LFLdguMJ+Q8jD6T+YtRDBZWSEI+7hcHHIL7qIo3rU8Dw8/sQueR6E8mNuSVzQkF0XukItUOmWHSulMfRQ9MDit+iyBiJ0zH5dBw6iFJyaWz3JnXGqWbvJ8ytsizICbZGcuq5G9+LF3j4S1kVhuz5xdjpOYfu+QIhytrMct4oYmHWr/iYKHZV/hHCTQaNya7wvRnMe9igWQPER8+w61orwR9b2h+U1Qb6BG1JFZHoUbYTWcfaUPirDGNT1+IMt7g7g8UF4oQAoa0QNCi3Qn74UIyNqu9dZa2ppSMxdIu5fVgD4IfvqW3rZt3dfLbMzA/hC0E/rvv6OmBkqACCqF7C2vqj+Ffvxm4DDIvMohSxH9HYXINgIig6SNXfkTCyk0J4iJdMFGIHnu3bu7H02dfkSE9CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(6506007)(41300700001)(1076003)(6512007)(6666004)(478600001)(6486002)(2616005)(26005)(52116002)(38100700002)(86362001)(38350700002)(5660300002)(83380400001)(54906003)(316002)(44832011)(4326008)(8676002)(2906002)(8936002)(66476007)(66556008)(66946007)(6916009)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lo4VXO0cjvWR+9AJsF99lNNvn/pG7UZgdCfVNr1b2GoTCTvt9vzexChCNBL4?=
 =?us-ascii?Q?6YnoKlUWXx5RbsBZ/SNDm5c+GyHdgcmtpCjXE7eTAkqddyi5x3bSSs8YUpIf?=
 =?us-ascii?Q?QPeK8vUoxKWllZ3EUVCvmscJ42CH8wB6j8+YieDZt7beg0hY+2nOFIXHXvNv?=
 =?us-ascii?Q?/2os6ZK5z7bAVgNSHtEr4dkJT09cMY1kEEpXegyzzMuCJEuFbqzh+l/og2gj?=
 =?us-ascii?Q?dYPKQC8UVO1fF7z4SHp0HHRix4CxbUKe8nLKdl2SzGYwUwweqiygMrIAQfT8?=
 =?us-ascii?Q?D/Ct7XFFQ2rx1AaL+sSJI6vl9nB8xEXf3MQVAGDxv8jIHhf4dV/3ZoWzqvn5?=
 =?us-ascii?Q?cn8an3GJRoBZA+Br5gjJZks6k8aH4bUHtx8UAXyFehBf54bO2r3HKmPkQROX?=
 =?us-ascii?Q?csoplZ89pRdfTC7ZTzcdZmyA6UvJ6iLHoYV/O9mFrFg+1ZduwSZshZqSHbgR?=
 =?us-ascii?Q?NlVIp7EWjLwg81/58ZR8/SeouBTfYZ3Vb8aIFu3RNy1Qc43HajR4WP67GgAw?=
 =?us-ascii?Q?/qvMCJ0nfCeBupZEhmdp7WNlxSv9Tmo7sqREvhDyRdr4ZSIqHRCs2yB0duCw?=
 =?us-ascii?Q?4cVY532aHRi0n0hkUh9ncYh4lBKPy7enEG/UaEZIHxenXs95Izg/XInbtGRx?=
 =?us-ascii?Q?RSIopUWm6EfsOzm+H2B0pzCwkYMcBcE8RQmkSAwEwupd1gOeoAtXeJzITGCy?=
 =?us-ascii?Q?zUu/WhPVbfaG9nS7f0DIvSL0/nAo+5NWMMyfxqKR/yha3lV3uLlrT1K8YIoG?=
 =?us-ascii?Q?FbqDNYvaYUrns6BSDSE8VzVNfI5OAzN6IOgBjOZHmuhOUZ+Cmo5D7KEw7ayk?=
 =?us-ascii?Q?J+QtRaC2qF9Rt3xsF84ARq0kqsH5IN3eXdyg/0e8JkpJUPFcPAy4lscJI6t3?=
 =?us-ascii?Q?xkqmjzmP0DHxeUmKUu38tcwrWXVKVCD4h77dEXFuyuN0/GxR+oxUlSDRfPv6?=
 =?us-ascii?Q?tULKTmR9ekXkVSetLegrZQauduSfmnMGrPS/RrPKSzsY2hkFOZQwXBisNjvk?=
 =?us-ascii?Q?vrJY2ffSC3Lay1IO3Sq5nh4ToA7nypUplEGKZwO6fAnsHekmOy3lqHegCgk3?=
 =?us-ascii?Q?cjRTpG3ojWQXTCGKAThmnXebxY5V05bgZaXZ7BorpU5BsYieuJ0rxLDSc9oY?=
 =?us-ascii?Q?4slUSXgIX+a+WVHD1TGsgq1KjeBHztZsScTRMuNFzW1Hfpo2rwPup5vT/Cbu?=
 =?us-ascii?Q?SfxNaYvO9Y22500n3jNWT5mMqh9CTFFsFd+OwAlI1g6JOErHsMvww5mT9pa2?=
 =?us-ascii?Q?vfN7nw6ggwhcxtIJ6ThbyNnTkOyQEKnl+u99Ikw+MDPT0ViKaXWyMgoHmi6w?=
 =?us-ascii?Q?efNwnbfMzRUwuQjQQogKRvWTZELu7RVQVy0qjItpxZ4OTFA9Lmeuif7KcSdq?=
 =?us-ascii?Q?TP2l5n9vVXsNWJNZasgZ/WFbd2QSUzJ3cfLfj045cHo4Yf4Df+RRW9rF0wJ3?=
 =?us-ascii?Q?F3HduEpCBtWV9UImPTOe/t+ShlqeISZnRcA22NAkDnPEjL9A0Hv5Lct16/XZ?=
 =?us-ascii?Q?JAyWIC86dt2Tmroi+hEOEjmueE97XFd3Ij8gY/99KWZs8IqK6sAUsfNT/Jpl?=
 =?us-ascii?Q?Khfya/u25B4wi71ougdGl0PbQnltvF/cv0BqOGabSmhDX2iWXdCZcRpSM0eH?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3336d1ce-17d0-4d18-9a21-08da91b9f5cd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:30.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFNJczFwNvhnGA8+LzfWBCYEgxi7wlSxzkwYJS2zDGsM/e8GRNocqcCB3Lo5OoZ8EK9z2jmlNxsiaDJi7SB03Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix PSFP counters suffer from the same problem as the ocelot
ndo_get_stats64 ones - they are 32-bit, so they can easily overflow and
this can easily go undetected.

Add a custom hook in ocelot_check_stats_work() through which driver
specific actions can be taken, and update the stats for the existing
PSFP filters from that hook.

Previously, vsc9959_psfp_filter_add() and vsc9959_psfp_filter_del() were
serialized with respect to each other via rtnl_lock(). However, with the
new entry point into &psfp->sfi_list coming from the periodic worker, we
now need an explicit mutex to serialize access to these lists.

We used to keep a struct felix_stream_filter_counters on stack, through
which vsc9959_psfp_stats_get() - a FLOW_CLS_STATS callback - would
retrieve data from vsc9959_psfp_counters_get(). We need to become
smarter about that in 3 ways:

- we need to keep a persistent set of counters for each stream instead
  of keeping them on stack

- we need to promote those counters from u32 to u64, and create a
  procedure that properly keeps 64-bit counters. Since we clear the
  hardware counters anyway, and we poll every 2 seconds, a simple
  increment of a u64 counter with a u32 value will perfectly do the job.

- FLOW_CLS_STATS also expect incremental counters, so we also need to
  zeroize our u64 counters every time sch_flower calls us

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 131 +++++++++++++++++--------
 drivers/net/ethernet/mscc/ocelot.c     |   3 +
 include/soc/mscc/ocelot.h              |   3 +
 3 files changed, 94 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 18543bee793b..b56aad84b6cb 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1991,7 +1991,15 @@ struct felix_stream {
 	u32 ssid;
 };
 
+struct felix_stream_filter_counters {
+	u64 match;
+	u64 not_pass_gate;
+	u64 not_pass_sdu;
+	u64 red;
+};
+
 struct felix_stream_filter {
+	struct felix_stream_filter_counters stats;
 	struct list_head list;
 	refcount_t refcount;
 	u32 index;
@@ -2006,13 +2014,6 @@ struct felix_stream_filter {
 	u32 maxsdu;
 };
 
-struct felix_stream_filter_counters {
-	u32 match;
-	u32 not_pass_gate;
-	u32 not_pass_sdu;
-	u32 red;
-};
-
 struct felix_stream_gate {
 	u32 index;
 	u8 enable;
@@ -2516,31 +2517,6 @@ static void vsc9959_psfp_sgi_table_del(struct ocelot *ocelot,
 		}
 }
 
-static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
-				      struct felix_stream_filter_counters *counters)
-{
-	mutex_lock(&ocelot->stat_view_lock);
-
-	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
-		   SYS_STAT_CFG_STAT_VIEW_M,
-		   SYS_STAT_CFG);
-
-	counters->match = ocelot_read(ocelot, SYS_COUNT_SF_MATCHING_FRAMES);
-	counters->not_pass_gate = ocelot_read(ocelot,
-					      SYS_COUNT_SF_NOT_PASSING_FRAMES);
-	counters->not_pass_sdu = ocelot_read(ocelot,
-					     SYS_COUNT_SF_NOT_PASSING_SDU);
-	counters->red = ocelot_read(ocelot, SYS_COUNT_SF_RED_FRAMES);
-
-	/* Clear the PSFP counter. */
-	ocelot_write(ocelot,
-		     SYS_STAT_CFG_STAT_VIEW(index) |
-		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
-		     SYS_STAT_CFG);
-
-	mutex_unlock(&ocelot->stat_view_lock);
-}
-
 static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 				   struct flow_cls_offload *f)
 {
@@ -2565,6 +2541,8 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 		return ret;
 	}
 
+	mutex_lock(&psfp->lock);
+
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_GATE:
@@ -2606,6 +2584,7 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 			sfi.maxsdu = a->police.mtu;
 			break;
 		default:
+			mutex_unlock(&psfp->lock);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -2675,6 +2654,8 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 		goto err;
 	}
 
+	mutex_unlock(&psfp->lock);
+
 	return 0;
 
 err:
@@ -2684,6 +2665,8 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 	if (sfi.fm_valid)
 		ocelot_vcap_policer_del(ocelot, sfi.fmid);
 
+	mutex_unlock(&psfp->lock);
+
 	return ret;
 }
 
@@ -2691,18 +2674,22 @@ static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 				   struct flow_cls_offload *f)
 {
 	struct felix_stream *stream, tmp, *stream_entry;
+	struct ocelot_psfp_list *psfp = &ocelot->psfp;
 	static struct felix_stream_filter *sfi;
-	struct ocelot_psfp_list *psfp;
 
-	psfp = &ocelot->psfp;
+	mutex_lock(&psfp->lock);
 
 	stream = vsc9959_stream_table_get(&psfp->stream_list, f->cookie);
-	if (!stream)
+	if (!stream) {
+		mutex_unlock(&psfp->lock);
 		return -ENOMEM;
+	}
 
 	sfi = vsc9959_psfp_sfi_table_get(&psfp->sfi_list, stream->sfid);
-	if (!sfi)
+	if (!sfi) {
+		mutex_unlock(&psfp->lock);
 		return -ENOMEM;
+	}
 
 	if (sfi->sg_valid)
 		vsc9959_psfp_sgi_table_del(ocelot, sfi->sgid);
@@ -2728,27 +2715,83 @@ static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 					  stream_entry->ports);
 	}
 
+	mutex_unlock(&psfp->lock);
+
 	return 0;
 }
 
+static void vsc9959_update_sfid_stats(struct ocelot *ocelot,
+				      struct felix_stream_filter *sfi)
+{
+	struct felix_stream_filter_counters *s = &sfi->stats;
+	u32 match, not_pass_gate, not_pass_sdu, red;
+	u32 sfid = sfi->index;
+
+	lockdep_assert_held(&ocelot->stat_view_lock);
+
+	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(sfid),
+		   SYS_STAT_CFG_STAT_VIEW_M,
+		   SYS_STAT_CFG);
+
+	match = ocelot_read(ocelot, SYS_COUNT_SF_MATCHING_FRAMES);
+	not_pass_gate = ocelot_read(ocelot, SYS_COUNT_SF_NOT_PASSING_FRAMES);
+	not_pass_sdu = ocelot_read(ocelot, SYS_COUNT_SF_NOT_PASSING_SDU);
+	red = ocelot_read(ocelot, SYS_COUNT_SF_RED_FRAMES);
+
+	/* Clear the PSFP counter. */
+	ocelot_write(ocelot,
+		     SYS_STAT_CFG_STAT_VIEW(sfid) |
+		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
+		     SYS_STAT_CFG);
+
+	s->match += match;
+	s->not_pass_gate += not_pass_gate;
+	s->not_pass_sdu += not_pass_sdu;
+	s->red += red;
+}
+
+/* Caller must hold &ocelot->stat_view_lock */
+static void vsc9959_update_stats(struct ocelot *ocelot)
+{
+	struct ocelot_psfp_list *psfp = &ocelot->psfp;
+	struct felix_stream_filter *sfi;
+
+	mutex_lock(&psfp->lock);
+
+	list_for_each_entry(sfi, &psfp->sfi_list, list)
+		vsc9959_update_sfid_stats(ocelot, sfi);
+
+	mutex_unlock(&psfp->lock);
+}
+
 static int vsc9959_psfp_stats_get(struct ocelot *ocelot,
 				  struct flow_cls_offload *f,
 				  struct flow_stats *stats)
 {
-	struct felix_stream_filter_counters counters;
-	struct ocelot_psfp_list *psfp;
+	struct ocelot_psfp_list *psfp = &ocelot->psfp;
+	struct felix_stream_filter_counters *s;
+	static struct felix_stream_filter *sfi;
 	struct felix_stream *stream;
 
-	psfp = &ocelot->psfp;
 	stream = vsc9959_stream_table_get(&psfp->stream_list, f->cookie);
 	if (!stream)
 		return -ENOMEM;
 
-	vsc9959_psfp_counters_get(ocelot, stream->sfid, &counters);
+	sfi = vsc9959_psfp_sfi_table_get(&psfp->sfi_list, stream->sfid);
+	if (!sfi)
+		return -EINVAL;
+
+	mutex_lock(&ocelot->stat_view_lock);
+
+	vsc9959_update_sfid_stats(ocelot, sfi);
+
+	s = &sfi->stats;
+	stats->pkts = s->match;
+	stats->drops = s->not_pass_gate + s->not_pass_sdu + s->red;
 
-	stats->pkts = counters.match;
-	stats->drops = counters.not_pass_gate + counters.not_pass_sdu +
-		       counters.red;
+	memset(s, 0, sizeof(*s));
+
+	mutex_unlock(&ocelot->stat_view_lock);
 
 	return 0;
 }
@@ -2760,6 +2803,7 @@ static void vsc9959_psfp_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&psfp->stream_list);
 	INIT_LIST_HEAD(&psfp->sfi_list);
 	INIT_LIST_HEAD(&psfp->sgi_list);
+	mutex_init(&psfp->lock);
 }
 
 /* When using cut-through forwarding and the egress port runs at a higher data
@@ -2850,6 +2894,7 @@ static const struct ocelot_ops vsc9959_ops = {
 	.psfp_stats_get		= vsc9959_psfp_stats_get,
 	.cut_through_fwd	= vsc9959_cut_through_fwd,
 	.tas_clock_adjust	= vsc9959_tas_clock_adjust,
+	.update_stats		= vsc9959_update_stats,
 };
 
 static const struct felix_info felix_info_vsc9959 = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a677a18239c5..8e063322625a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1934,6 +1934,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 		spin_unlock(&ocelot->stats_lock);
 	}
 
+	if (!err && ocelot->ops->update_stats)
+		ocelot->ops->update_stats(ocelot);
+
 	mutex_unlock(&ocelot->stat_view_lock);
 
 	if (err)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e85fb3b15524..bc6ca1be08f3 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -729,6 +729,7 @@ struct ocelot_ops {
 			      struct flow_stats *stats);
 	void (*cut_through_fwd)(struct ocelot *ocelot);
 	void (*tas_clock_adjust)(struct ocelot *ocelot);
+	void (*update_stats)(struct ocelot *ocelot);
 };
 
 struct ocelot_vcap_policer {
@@ -766,6 +767,8 @@ struct ocelot_psfp_list {
 	struct list_head stream_list;
 	struct list_head sfi_list;
 	struct list_head sgi_list;
+	/* Serialize access to the lists */
+	struct mutex lock;
 };
 
 enum ocelot_sb {
-- 
2.34.1

