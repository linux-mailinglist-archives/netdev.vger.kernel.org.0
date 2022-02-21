Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F434BEC92
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiBUVYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiBUVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92B912753
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4ujzH6kiWNNjC7P81+TMhrYxSfyAK7AhG9fILOUNMbs+5p2S94lapug4z5giy4B1sV31ivn8cvgd5B9MdD13Z3P9uBh1BnmiYK7ZAicVTfUGUaEuCFDpiDI9YldcCijNXrLkDI0uVngh8GOigOERaYHIkJBaf5GzRW2z8q92FJbYwYXzRtuU5Eqddl99FJsdVGGSH07vDW6WRAIarij/ziP9chpwsr9/vo91oNcjvwpcuyA3vSVRFGTFSQkmwc7ETiCUMFAKb2Y99Ur/WffBzT3Z7uL1rako1JnFv2uWIpf/RVLVyJqibf8ubRF1m8E7sZQzpdmzv35eFU9xBLkMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ke3kJFr46+s46yckZq4D7gBwjgjC9DwKL6i1ZN82waQ=;
 b=S633zdSR5XY9q/w/sYRc5I/c77QRnYs9C1ftO+sY7eZA9Gpi8wHWzqVlEYOeb7QrRJ9hxhLBr4UTxximwvynjZzIvFQDbbklHN0dxsG+mOiZoqoMkaIp07kexT05CAiPkSclBgEeBtFrofgXcNQhfZU+cJuszeRK+aPd7eM2dQkP4rEQ/4xAxaOiPe8XklffkyPY7jsZoMQL4X+OQvrewPF7HzDj9tAFyT7Z7zFFpwaW1z93KmnOO0HaFh2Ey+zfhyP4A9d3g7KDe8+sxzD5/wlqKZh2a/vP2AVFcBwMXWNGtTl9wGA5XI/seFckqt1/AkJjcL6erm6oNW/jk/K2xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ke3kJFr46+s46yckZq4D7gBwjgjC9DwKL6i1ZN82waQ=;
 b=PUDN0uUOFYm+F4gXUoKYvcHENpfIiLOTY1Yz1b0zMlcn9Awoa/x1aZSolf1fNrqOUCmDqpAd1hWgVEC88BIjqP3oh5bQmrfDx0+VYBBz7zSWb/Sh9jVNrlHd3/e9fGZFVDmKSB6DTIGBUzVTUoo5z4v+z7AoRgM3F/3eYNtGYLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 08/11] net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
Date:   Mon, 21 Feb 2022 23:23:34 +0200
Message-Id: <20220221212337.2034956-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b97cce8-88fb-431d-36de-08d9f58081b5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB564512BD676207F23FD293A2E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVmYiz+BwDae+pV8qawBi15+zCDnL6i9YtJZetm2Piz1QeVmq9Alom/NsB+9LHY2vyRLpCLfXtrlqqXUExvzrJd4hgkg714Brgw26Bpea9+07daz8UHSHiIaEDfZ6+9odZXE4ziEO7QEbxym6QO/kYAlR8h9m3k0n6UeaUtbzcfVH3UaQAiB6NcMtVBV4OCmg1Gzv7+WePvbx/KTsWdw3hUojHers74dMKUDoTU0PbXAzZhu96AmOC6QrIxOzPJ6pl064OYeD5z0qhYF4pnU4VkBbvY/mIvnY02gKlTT9vwb3dW/U0QEb3dNsfy/T0183/pAug5phSVVP6yDxqfdfj52GCk0QnA776EaXb5oL0noq2UFmKkacCaeMCVJtVsbnUHNnh+y9rnqyDQrULstwqS33H3z8h2o2OzouZAkk9b+4eh6F3cdUz6yGrmaj6ua854rd9W/hyRIbwVPVcedjEntAowd3heK3siW+C+hNUWmiy7ZC2gE0XkJsgxX0Sdg2whRDiEY1XklU6y74L8RuL84hryHEc4Y4sfjXd4lCJZ0HRB3iM80B1fsXBbfcViV+V/kexCjm0FLX4ElG6fWNGR3fLrJWDc7Mrh+lXgsebLi/IupY+Uve+xu/KXE6PZ7CMHuQfsK9OTRi5Qy1jmzrpS/ubFbo9nDfMvyMXhRc8ZmreiHaXUosc/qZm808m59mVVdDkFE2qyS07h3edo4oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PWADLhcjfwkGCxz0ch+7az6ve3i/rC4SdVkAO6PiDZPLoUUZokCnmW2txKCN?=
 =?us-ascii?Q?nLnw1LOpSqFbke1gWcfYrlDpmL0hgqTS5I+MxiDiXU1RrnRSq1Y8X6+kMMyy?=
 =?us-ascii?Q?kPQkwEoLf20oWEyMxTB0ZoRbN0A3l2e2NIw2Nj+j/YONRaUazaL/M0dexhrw?=
 =?us-ascii?Q?G2u8pF5ow3Sl5lfxY38sxIRiI+92T/YFfCYLTCCzPiLwgj8CybXkGbtFVJlT?=
 =?us-ascii?Q?dSFEWJFEwsoKYUZlhClI0ltrQ8fncbnCsofNUECZYzrQXzQqm3+YGqMT6J/T?=
 =?us-ascii?Q?zYxHf/EA5Ry1AGKAq5rwbsi2VmVK22wOO5Ps5cEyUbSr7hFNtqO+ko7eJ9NU?=
 =?us-ascii?Q?gNbId+kROW2hRZnbTS0kKkK8yGwIa/jI0ZGOroD14ZoUxnmzWR3dB7odiOTH?=
 =?us-ascii?Q?EcIFm7ngHYFTCg+NjbvpwJJvit+bqDmDVSCzPV98hodCQLrt19SuxDmc3zzZ?=
 =?us-ascii?Q?bTtkdPZBG5oFNOYC8bgRQKn1JVdjYUStng9cKA8M+dzAi1ko5MH2JZIVGkNB?=
 =?us-ascii?Q?T+GZqq7Qak+Q7m4mpdwyhPJeaT+huyf7yhePy0HQmBlKVqdY1YGm497Vk4me?=
 =?us-ascii?Q?q7GWI2HOyPYZEttKEpQ7fa02LFGuMtzdTVdwxfsyGgnySbgiewW2Wo4Bdzw9?=
 =?us-ascii?Q?/jR8jCs0jAyZBcVGgWHNk1K2+VFOra2nIENPvbFTeJbLYoWfF4hWYXB2OhaN?=
 =?us-ascii?Q?Efs2z1wzzahJOICq24e+d7x5iANSYazL5zMV5iPA6Q7DgVGzYe74l7tMoUHY?=
 =?us-ascii?Q?AmA6UoOKnYQNSMMaTsUbkMUV8A9q1AthKTpVGnN4B+vbhjDLJ+gkGGTr5Uoh?=
 =?us-ascii?Q?MZd11Ci0jehdVa86/WJqPBzczLRhplc6/sOb6myrRTZGVFijWPDPAbYP4V3Y?=
 =?us-ascii?Q?J+9kPv0ovwxj1a3QWRWpOvACC6d0HEfwKgkeuZnoo5+BS+o86iiJjF0rsqkr?=
 =?us-ascii?Q?mFOEUzheuuIaRWRbXlIPOrYv7V6sQxOtfoGuWsT6RE50Uk6iTr62n8WtSPFI?=
 =?us-ascii?Q?W0ZII8MrBMXKMEr83GJfT/P11vOj20Ej+T9dhR8eSMGKVeSWNth8Kv7/jUao?=
 =?us-ascii?Q?4o1UoxR+Dt7/GRdb0BKAoq0apnbmQfwhJujQG+xp0JAAmXPI+6AsPlzKC/fF?=
 =?us-ascii?Q?/VqhvRu44NIZUPqeQF3ZldZ7xHEsQ2013bYDdRP/r8VTuOlHco4Gi9ip6WD3?=
 =?us-ascii?Q?Aqv3X/zBK+fOXcHcH9QfucybTR0EywBZJ8fLFctUbxDkw92+LQ6gBwoR8052?=
 =?us-ascii?Q?hNEJhOF62HdHZ0Da8NjGlqj4oUqmxRrWLDLickGWC77IzB37iZ/S3+lJM2Xr?=
 =?us-ascii?Q?NhiQ/E0BrRB/QT4/AtTP+8wI/zlWlSDfKfvQ6g/ydrClyt8z/GpiIetfRT4I?=
 =?us-ascii?Q?5We7qY9kU2+oykYmVLv2lwXgUYZnzvLSiqBI+zMx/uT0EH8AHkWr5cvKg3OF?=
 =?us-ascii?Q?FHW79pq8aPtrVCQAHlJJa2DvFzH57j7umWn0/WBcGIdh8Fb5JYMHbXkwBmIj?=
 =?us-ascii?Q?ihktsZ8iaIHLPJ0u5kWX1lifvFG+PQvlNM3O5FLNHktPuVKMz7dYLILgR29h?=
 =?us-ascii?Q?UIUkbkHlnkj6ftcU+jA4Z7Vm4OIHw9PnVX8kLmz978e02A4nvvUKthLZzA6V?=
 =?us-ascii?Q?4VQcU4u+Nnhi06+0U1LKUPc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b97cce8-88fb-431d-36de-08d9f58081b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:13.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+RC7ViiQ837EHL/u2TleykdLwKnlk/Met4A1juytu9sB2QvM1PwBwLN/w97KQzJKTCXscpTokOOUigbFU76hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By construction, the struct net_device *dev passed to
dsa_slave_switchdev_event_work() via struct dsa_switchdev_event_work
is always a DSA slave device.

Therefore, it is redundant to pass struct dsa_switch and int port
information in the deferred work structure. This can be retrieved at all
times from the provided struct net_device via dsa_slave_to_port().

For the same reason, we can drop the dsa_is_user_port() check in
dsa_fdb_offload_notify().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v4: none

 net/dsa/dsa_priv.h |  2 --
 net/dsa/slave.c    | 16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8612ff8ea7fe..f35b7a1496e1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -119,8 +119,6 @@ struct dsa_notifier_master_state_info {
 };
 
 struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
 	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4ea6e0fd4b99..7eb972691ce9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2373,29 +2373,25 @@ static void
 dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
 
 	info.addr = switchdev_work->addr;
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
+				 switchdev_work->dev, &info.info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
+	struct net_device *dev = switchdev_work->dev;
+	struct dsa_switch *ds;
 	struct dsa_port *dp;
 	int err;
 
-	dp = dsa_to_port(ds, switchdev_work->port);
+	dp = dsa_slave_to_port(dev);
+	ds = dp->ds;
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
@@ -2497,8 +2493,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   host_addr ? " as host address" : "");
 
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
-- 
2.25.1

