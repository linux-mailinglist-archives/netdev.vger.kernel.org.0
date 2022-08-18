Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5EB5984E4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245398AbiHRNzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245425AbiHRNya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:30 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2082.outbound.protection.outlook.com [40.107.105.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF3D12D2E
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj9PSPtcDSAifDI3YHSWYReuyLmZfWa2PljpLnZlAKKTm5ldC8dA/ooUVZLPGgsYiuTi0I3on8JWR/gBNdSVqDMembQAtic/8g/F9y4WzuNSVg78++4g89AGKeDzOENVRaVMaViCLo1wsxDgT75A1H4Hu4QUQQ+SbARRmiYNrmSCHEn6yVzd4c4o9ZFPqY2ACHcS9YgbrYCX2Qaa84WWsl+x1x9uD14t/zGVXfKmtAr5e2xGUb4Kc7ErvqYMdSYxGnoKWJQquEJV5lNoUJBb9UZcZPa17XuP0xwF4KgfKbxvY3PuwuS1rrXNwuayoWj6PoiUB8o+ZEDnbtFC7fP6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJ+l9hwpGqc2a8rg9TpqkySNL0Uy6ZgyAv/WazrB0wo=;
 b=HKgbdSk0dBgMW3KsyRRQjE1BR00Y2MA1kECCL8nAoKXvhqjulun/81Q2whG5jeTE1+YqIyMncZJhlvOUR8RWRdHSVENH/AT/w3e7CC/BdBE7hVqPqyEJ06SvT6/953u8SfhZcphHEFQGGffnAr5SX1YcByLDOfTe6XomwqqWi1b/0UnDVrv6Bo3MDpMwDz4nE6Az/I9yEXD9IRr4QtbuHDEV6FVOfiTem8ood5JA4sU1ght6APqAqqiRGCYNoEGEPiyKGhx1Ft1U+1czF99qoyJq4tRdwSDVCuKOYklAMiHXYE3WqJ4xvjcepuDoesuIYXG6+ca8j+/Mp2E+QyJNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJ+l9hwpGqc2a8rg9TpqkySNL0Uy6ZgyAv/WazrB0wo=;
 b=H4W/uPUCp3yk7tBQ+oZLgC3gMpi201CXwvn9e65Z+isbnxhaEpkofSuydelmMZYbxadfmOE0ifmuipUZZoPc/N4QNg0rbdk6OGVKiWfJ0mCNbiDdANNG51f0kgjWOecPaY0kswiFn0S1i+6blpb4CvB1qRZ5ekJMoMBNYxhTdFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 7/9] net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
Date:   Thu, 18 Aug 2022 16:52:54 +0300
Message-Id: <20220818135256.2763602-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a57f091-bc06-45e6-2ac5-08da81210205
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qigMPjZob0b0Z9lkM08DyaxlOWOlKNk2047KY3eToUyTdkPEX5WilzqHYZcHm34z8gXJ3kTMMxl/k0c0CnTbbWyTlR4sYBON0ESn3FtFglEpQTOyu6wCklogCIEvrXKH23lJx0CGOpH+zJgL+MIx0IDZ4I4OimQrptTP0R9f9CnVKZZzbQ1v9xv6Mqvn7joE5bF8zosJyBjOjL6pfNoMBwFSyvhqXlezXvG9pe+HK9qDr/f5Z5s3sy+0qhkQJLI/4DuXBRgu8BbbofsfXVQaLIOKyCc+NopGL2LGWi/Wp5mK8lneWEaHa9OlcuGZvhC/oT4ViSdaoV6v6HEjhDtG2YGGacxsnko/Ot0CqqdDDoTnVT0PDkhRxpAk2q+0YEIq1HfdewGYgtpjDTrNz+i0si9j1KReZiD/CE6a4lyjO65yF/tgAyLDIWxXETvDw+S6F1Cx/T6Uf985vxUUFwjoE3x8bSNZk39N3CCOLf8rESdqNSdU0AC3YG9LIa0PSOJxfWIl9gWikbo9HYzJHGH5G2hTNKMlnWs3Cnx2ErKYNK1mZH+Rbvnqo5L0kx2s7ncfs7N5wQABAKHB64WHtLUnPvBvdcOIW5Hm6nyia42r62hOsQztT8w706qoxSt532lONGK7ByVMRDZcXad/tHmlM2xAprlX/IB0VbAgeCYPmSM8aN0sQyrLMlza3kflVFas9VSvyNwMBLZfJod127odG9e0os4vr8qKygkACzUIg4C7QMcHHM9uKottN3YGBBUByaUJ+Sb2y6Hw/In7HvApQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHQKGI34plyu30rCRyTxgy+irXxpJOYZ4MNbkuqQKkmURmRfs+PMbGTVXOMA?=
 =?us-ascii?Q?CcawZqEZligd53Rm/WLBMKw9zTuiGhXumRSeyBEJQ3pfh9Gl3PnnmeySfF29?=
 =?us-ascii?Q?QKz3h8aB8UdNfE+Yhjc8pVR1dghKoNflPIqn0K+pOFzpi2VX2oKnO86pRlpi?=
 =?us-ascii?Q?xcD9NcvsqFxBZ0m+rNkwUYVGu8HVomEq0OM9lVSa9KFmwYsuJqMfRVGOjQYL?=
 =?us-ascii?Q?casviI5m0X7u3ZYXWSn6oM9miWLhGazErcyoY10FQV3de6RCpOoW1x3QhxCA?=
 =?us-ascii?Q?mYEkJRIppsaTtCw7NCqmW+jNB0roAwtc2bIEheOLd7JCs/gir8etEKKV5UH/?=
 =?us-ascii?Q?3JHJXjs/72RK7HlFQDj7mQAplzt3NCpvPECeE3Vx4rHELe6PM8FsUqXhpWq2?=
 =?us-ascii?Q?kNUCwfIh0lMXcCusf5iZqCKZUcKLXNvXS+Xkkb89tCC759il51JE00tNYXCq?=
 =?us-ascii?Q?SJgrJIBdNWL1I2OY56l+NM1souWQQThrF9rIfls/xf/Xh/aVJ8qpVr/AkqIm?=
 =?us-ascii?Q?g+ayTPEiGDX+2i/Wk1WDkeDwZIFIoOui54jIahB4eNoyopW51znaecBPon5M?=
 =?us-ascii?Q?kmL5Sl1jTkcDNXvLxl8Aj798O1kZUtlJpe6VVjpsOKrXMWUUWaVLU2S0SsSw?=
 =?us-ascii?Q?iPmH0HDTSvzkBeoLbu5wpYL+MVPr1AvQR4Ok2hjAJ4dEZyI2y5mk9W9/gYK/?=
 =?us-ascii?Q?89fE1F4q0yvWOwGPJ2MmhgD4HJZW93MYM8f3DOAwFGvFRQduL7Ytr1tuht+C?=
 =?us-ascii?Q?7u2PaEkjkDHdJcLDwT3m4HN+1U5azvBMIOHZYvJZXeaOf6nFqLeL20Fxi/Er?=
 =?us-ascii?Q?2cQqiv4R0ZsIE5xhvINvVaIteohdkunryuiwEI11/sI1ncZXNuf/trA84K3S?=
 =?us-ascii?Q?PfUQ8StayFkmrfZ1FoATx0vHJfXRc+emJQbzRw+ZayquAEUegwybKaNcQOlv?=
 =?us-ascii?Q?mt+FUD3NOUZdh70UvATnNuISwdq6Io4fyMJ1zX8rYbq04gn4xsNhZ4SmnJ+N?=
 =?us-ascii?Q?LuPZyViTKHbAkDIZIvnwoqjQKjo9OOW/6YnhCTBUJZ5P6aqiEC4lCc7PkXX4?=
 =?us-ascii?Q?07nwra2HSW1MxgH4D2skrCDHDa4Fzs9/5uuKDJS49vyq1wnjN35B68KBVbFf?=
 =?us-ascii?Q?EyHudnm6+H6tDx8+F09nRd+BAsxxhmeXSQxrotoExmu9ex9kA0kh0KSmOgHa?=
 =?us-ascii?Q?hSXFJVaqINIKLUNkZjYXge95+C3DVno2htMLVX2BedZwKh5qvOR+oILUFJ4Z?=
 =?us-ascii?Q?0Ml+LXuIR5m2GBv7Mc/hu5OzXAqK8X9+9QuE0Ej5rfH/XBT1vqFc1Lv7G71x?=
 =?us-ascii?Q?X7jY9o1/h8vrvsbo/7FCe2MIpwR11AHUUmrHtiYErThfXdPQnfwEryYyrREL?=
 =?us-ascii?Q?oKbPIAJLZBjxKyJ6fJBhGrHJZ5SsWxQfq8Ybi17b/jUxb9pVzANZ6fTHyxWP?=
 =?us-ascii?Q?k1BaaYwrhOqjkU00ysI2flGfp1545JZE8WYK7X/83i5R5/vQrUIA7qV1u/95?=
 =?us-ascii?Q?Dj0AWi7y6ZhTjUkQ1lSh8qjkrWSoRyT8+q5TiJZKkIXUACm4kkULOJF+VrN/?=
 =?us-ascii?Q?SrJLNS2MEEOCVTtMWDpy5jQQdN6BSNYKufgJFyMOjhqJUM4pmgoZheY7jpID?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a57f091-bc06-45e6-2ac5-08da81210205
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:19.6174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvEfP1ztqAn2yIoXqB4asAXnekxseQ8hoZ37u51B/T5xcKeLQTFk2CwiNZ4IoTII5U955Uf6gv/tpM3mIqXuTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More logic will be added to dsa_tree_setup_master() and
dsa_tree_teardown_master() in upcoming changes.

Reduce the indentation by one level in these functions by introducing
and using a dedicated iterator for CPU ports of a tree.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 include/net/dsa.h |  4 ++++
 net/dsa/dsa2.c    | 46 +++++++++++++++++++++-------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b902b31bebce..f2ce12860546 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -559,6 +559,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_user((_dp)))
 
+#define dsa_tree_for_each_cpu_port(_dp, _dst) \
+	list_for_each_entry((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_cpu((_dp)))
+
 #define dsa_switch_for_each_port(_dp, _ds) \
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
 		if ((_dp)->ds == (_ds))
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b2fe62bfe8dd..6c46c3b414e2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1046,26 +1046,24 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 	int err = 0;
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp)) {
-			struct net_device *master = dp->master;
-			bool admin_up = (master->flags & IFF_UP) &&
-					!qdisc_tx_is_noop(master);
+	dsa_tree_for_each_cpu_port(cpu_dp, dst) {
+		struct net_device *master = cpu_dp->master;
+		bool admin_up = (master->flags & IFF_UP) &&
+				!qdisc_tx_is_noop(master);
 
-			err = dsa_master_setup(master, dp);
-			if (err)
-				break;
+		err = dsa_master_setup(master, cpu_dp);
+		if (err)
+			break;
 
-			/* Replay master state event */
-			dsa_tree_master_admin_state_change(dst, master, admin_up);
-			dsa_tree_master_oper_state_change(dst, master,
-							  netif_oper_up(master));
-		}
+		/* Replay master state event */
+		dsa_tree_master_admin_state_change(dst, master, admin_up);
+		dsa_tree_master_oper_state_change(dst, master,
+						  netif_oper_up(master));
 	}
 
 	rtnl_unlock();
@@ -1075,22 +1073,20 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp)) {
-			struct net_device *master = dp->master;
+	dsa_tree_for_each_cpu_port(cpu_dp, dst) {
+		struct net_device *master = cpu_dp->master;
 
-			/* Synthesizing an "admin down" state is sufficient for
-			 * the switches to get a notification if the master is
-			 * currently up and running.
-			 */
-			dsa_tree_master_admin_state_change(dst, master, false);
+		/* Synthesizing an "admin down" state is sufficient for
+		 * the switches to get a notification if the master is
+		 * currently up and running.
+		 */
+		dsa_tree_master_admin_state_change(dst, master, false);
 
-			dsa_master_teardown(master);
-		}
+		dsa_master_teardown(master);
 	}
 
 	rtnl_unlock();
-- 
2.34.1

