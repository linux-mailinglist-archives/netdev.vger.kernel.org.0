Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FBE5A1A47
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbiHYUZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243768AbiHYUYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:48 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46A1C0B43;
        Thu, 25 Aug 2022 13:24:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdVgQ2tAeKc8eEkvv1w11GVIHvzBmhfkneBMcgA3+VV3rjeomyVDLEQ1J4/ZSo84ppUo7RRzlLoDOa/o2v6/KQsYu4VFVtFPf/MsGIB5cQWwCuRLNRWekoy47LzAuLMwXMbHMkGjfLdAozR+oW5nJsgInJ6HCQy5eG/dZ4257P4dZ/3/KK7i6QPIO9nYMQ0o1BVl9oJ+GAcCv4pXAm4gagdsWnDurF7FdyKhaI26N6/NxqXLn0+iaId7AZ1E4lT0Q1meSxIT6/P8m0zKJfZGE9vSU/N9M0kYaY5+zj55NNaBZknOhsioFT4nhNvv4oEW9z+8AUkr3HRxyGfYxhMIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L7l4dSuE0AgqHWGMmEjsYGF1Ex+gHDqLDluKzjLLeo=;
 b=inlIoDo4NmoBSznjjy8FncK0jgUt85yPUjoJSf8VB6eg+Vva+2GGyLQuPBdvfpM+VmcnwoXGKf7NgLAqn9ZIxYFrpfv+wyIFz7d41tyE2Uu1zuaSr6uQbZeg8/KEn001vNERtB4QR8TH6FffxUCRm33B/OLAkE4Hr+y77Ilm0VCJwn3UTwVewy7feLjY8VlC599mc3h03qgm+6K2e7UjeGnoKB2DwKRPJDoClTJvTGw1uGvrZMCXnYIe2mpNIiMb1LKrAXdomF/t5TKIhyq+ix8U8Mplcw0TxxNwW+9DBca/jGV3t8nRj+M3blEBppazXCaecMuuEroklUB5uKl1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L7l4dSuE0AgqHWGMmEjsYGF1Ex+gHDqLDluKzjLLeo=;
 b=XExelOxyFp2RHf2g1uHILrZGngDoTM/jtAtfZF3lGBGobyY1/k0RtKapO10gdgu9etL/lrvIw9AfvIjYehXMfcW5ZDw1CyadMkvFXo68Xza+gl4wWtxS95qRPfgCx9AEq71EWc3Kzka49BF1IAeNVStjJHCGSOPxkul0VRX5wbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:34 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:34 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v4 9/9] net: marvell: prestera: Propogate nh state from hw to kernel
Date:   Thu, 25 Aug 2022 23:24:15 +0300
Message-Id: <20220825202415.16312-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6092e339-976b-4274-d01d-08da86d7d30f
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d19c7ddBgiBpb6erJnpguOPcqapK50X1PUAmk8vVUO1u7AQ4DRI7Z1vi8j+mXGzDlDBWSYT9tSsciuWvOoRUV1BhD23yztO/+NXEj68CTprWuwR60y+kL6Z8BNYW5BcV2oDIks5+NNOwD20Z1DEVtOOK1IiMGjsvz60jbcOF1AcksQhOEQehzA/uPGhSVNkSZBrNPxFRkOND7IajOVCWPitG2Z9kQXes3Opi9SWevG+al3yjrOxGoC6wPfhNBD7H7dpvCrRRbf956tRfHQ2xApi0J4nviU60ZVfZG5e8Zz+7Wyxd8GopijAR2nGxv7ERxBtQajrtYdQ5vM5uCiWEgUO4guCqlileFggbrcL23R0Q2PSG3fFKIMHJBgOomThThCGasnK1UEnNNFfJk8YZ4ziWSkrdkYld0SeFB9GsOfzTB7PDNs+QlKeHszHF+3lC2IWKVIScy7ANeebaMIyagfkO+ZvDmZuDHpDCUarPSAIPdeoziHFnoTZ+ZJUkHdRhXI8R/6glVdMKTL+4QrPw+e3IJrfWsNd445sU4Fk4Rt2uT2LMUKQH6B11ogz2iQkBmDSXuBD1K10+tTspVtoK6SywaMKNOU3TNYoNEpWqa4p0oGRcndKtOsKi9Mj+jKh7nc5A4SO6/cg6nyZqgDIyv4bGa7fFIo7PKTASbbPuP5eQ/7fP/sQm7Msit2jxtzw1pUl0SUKVfpflCyhIA4GEXm8E1jWAZeUmT4aAACzqqGFhhUh/q2eRFfrWU7IFMY0w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(83380400001)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hhf2upCzjxENiaxSSPvFxHHIGCXkO7G4b+fmGVoeKF28vhWHsQo1Ya6EFN6T?=
 =?us-ascii?Q?OQskVkJulnnMPctmiEeWLlciXZ1F0q4T42WpDG3fGycwNJtEkjMECRY8FjGk?=
 =?us-ascii?Q?A1pU+GCjNTRzIvzf/LFdEwRIJ5d9RNZhZR+pIkDgnmvL1b3oBbFHgiEiqxzM?=
 =?us-ascii?Q?nPRAxiY3U9Ok9+kpOUSXlVjhJSrS9iCCC1XEtiCzE1rVqzzB8yd9fzSLREU+?=
 =?us-ascii?Q?EZqe5IGiNMbvhaqNRtxNTT5HPiukii3gWp/whz2h1blLhuKadcqxSD8wQtdn?=
 =?us-ascii?Q?mkjqY3TcVT+btCR2JYhDf9B8HGTwJTVDPPsaBYhy8P9xJeqG90hMs3HFgg2z?=
 =?us-ascii?Q?uSMTb5A5BXU0a6ReqLQ439z1leKiiYuZbIgoI+1359jvh3yfmMoQjgENT8zR?=
 =?us-ascii?Q?lRgmQPapHQFyk5CIJF6dw1L7EYonK9sZdD9pYXPkVffmu1Z0VyAOlGGlsqAG?=
 =?us-ascii?Q?IVnRIncz80dwzmNnj3L+UR7cecieemgrGpmxJUrcYijAQinZ0A5ztkGSGUtj?=
 =?us-ascii?Q?Zfe/F/u1dYK9K5PUmCy8DuekA8ryv42TsjbWbLj5E1MWQvkaHp64ooQfaQVV?=
 =?us-ascii?Q?T84Qq3Pqbe4+cTHxCTHk6WX+0Pz5HepxeWvRlEDxpUCCF8cGK2WS7SVDqjFn?=
 =?us-ascii?Q?FQE6n6k75gJBtCbY/WjwMISA5Cd51Z7oJE82npdViFJ6fE6r20R8LVTMOyrt?=
 =?us-ascii?Q?hCH+XeNc+HJclB9D+Cs1K4SCO/t6QWxwJLoUAk1ilcwb8vtgOprihZJOx7SW?=
 =?us-ascii?Q?9ihYs3G7XiOr9iRolgVsQQP5pG3NGYu8DSCe/v67HoIbzQOjmvpiOkYtWvj/?=
 =?us-ascii?Q?Kc9Q/bvNwdMRZ4yhAX3Ughjl1WVtr8NsA7P5J4C4+ktBzfB5vWPAtHKlo18Z?=
 =?us-ascii?Q?DTozta0c93NUtXvenbHMnbR1IAGm6iCYVND/ECEWmr5XLi0m4WhJFyWyw1md?=
 =?us-ascii?Q?upn1WBFyrvEq0UZNuLKdIwnlhoOZJz2D941t7bjL+H/+ff2W79j/FNPrkPuy?=
 =?us-ascii?Q?jGt7bKL2J0RhTwn3I/tMbTt9QSpXWWBSqtbx2SyQl4zEBMA+1eEJQT5PsfJP?=
 =?us-ascii?Q?tMklG75VsNEE1B6ujKWiUCBAAsboJOCkpnW7DhVqQiIX4RUWf4A2lYAPyhnI?=
 =?us-ascii?Q?Z5ZBaPSfU0gfIwFomSWWMsSfihh4Q2rRuBaws4I4Knrv4l2EknTfdb1sr4/t?=
 =?us-ascii?Q?UQ7xqdMKRch23lkoIUYlFWksz5T/DbjagyJh0nMZxCgYuF0XaQp6wpeNRlwK?=
 =?us-ascii?Q?dEpMnDoK7k7/FXcSqwxZWLyS94jr8GzRCs7h8a1XTMMpX+bdvU00Stga4Zut?=
 =?us-ascii?Q?tlmpdBK2wHCb9c057cHGr22y4Q1r6fjgGlKJTbAJZOGfDWC8fhz77UyeisaP?=
 =?us-ascii?Q?s3yPHev6moHZ+5GFnF8XPmzUDCd269rtgXvX/XgvSZaNkBF0Ml3pyRB4q/t1?=
 =?us-ascii?Q?2+q22TWMWVhfp/dlbPIGwRTA1XYoVqlZBLt1gXSRdI9JRN37MsNygd1KQUzB?=
 =?us-ascii?Q?aweOilDOBsEzIZ8HaRw0v3dTRhOXXf+nepmqhQRMMn5miaeFw66Nbwo6M8rL?=
 =?us-ascii?Q?TdTAsJ0SL5a+eMJ4uoSiqENwKETLgBv1FXsnKauNRtG/d07DRy1dZ5jiRAZV?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6092e339-976b-4274-d01d-08da86d7d30f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:34.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22VlAaX1u+hyFGNxwCJ4yfOIj8BJj2VnFssjthiypErXW0GbAx+xbw8o5koQ8fRAZHYpEWQZV/18u6xyAUw3PkkfGT9k15XZ6nBnYjhKyF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We poll nexthops in HW and call for each active nexthop appropriate
neighbour.

Also we provide implicity neighbour resolving.
For example, user have added nexthop route:
  # ip route add 5.5.5.5 via 1.1.1.2
But neighbour 1.1.1.2 doesn't exist. In this case we will try to call
neigh_event_send, even if there is no traffic.
This is usefull, when you have add route, which will be used after some
time but with a lot of traffic (burst). So, we has prepared, offloaded
route in advance.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   3 +
 .../marvell/prestera/prestera_router.c        | 111 ++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 4d24e0e216dc..055761463088 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -324,6 +324,9 @@ struct prestera_router {
 	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
+	struct {
+		struct delayed_work dw;
+	} neighs_update;
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 5d6dd8a9f176..9b612b725a16 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -16,6 +16,9 @@
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+#define PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH
+#define PRESTERA_NH_PROBE_INTERVAL 5000 /* ms */
+
 struct prestera_kern_neigh_cache_key {
 	struct prestera_ip_addr addr;
 	struct net_device *dev;
@@ -32,6 +35,7 @@ struct prestera_kern_neigh_cache {
 	/* Indicate if neighbour is reachable by direct route */
 	bool reachable;
 };
+
 struct prestera_kern_fib_cache_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -1016,6 +1020,78 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 	return rfc;
 }
 
+static void __prestera_k_arb_hw_state_upd(struct prestera_switch *sw,
+					  struct prestera_kern_neigh_cache *nc)
+{
+	struct prestera_nh_neigh_key nh_key;
+	struct prestera_nh_neigh *nh_neigh;
+	struct neighbour *n;
+	bool hw_active;
+
+	prestera_util_nc_key2nh_key(&nc->key, &nh_key);
+	nh_neigh = prestera_nh_neigh_find(sw, &nh_key);
+	if (!nh_neigh) {
+		pr_err("Cannot find nh_neigh for cached %pI4n",
+		       &nc->key.addr.u.ipv4);
+		return;
+	}
+
+	hw_active = prestera_nh_neigh_util_hw_state(sw, nh_neigh);
+
+#ifdef PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH
+	if (!hw_active && nc->in_kernel)
+		goto out;
+#else /* PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH */
+	if (!hw_active)
+		goto out;
+#endif /* PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH */
+
+	if (nc->key.addr.v == PRESTERA_IPV4) {
+		n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
+				 nc->key.dev);
+		if (!n)
+			n = neigh_create(&arp_tbl, &nc->key.addr.u.ipv4,
+					 nc->key.dev);
+	} else {
+		n = NULL;
+	}
+
+	if (!IS_ERR(n) && n) {
+		neigh_event_send(n, NULL);
+		neigh_release(n);
+	} else {
+		pr_err("Cannot create neighbour %pI4n", &nc->key.addr.u.ipv4);
+	}
+
+out:
+	return;
+}
+
+/* Propagate hw state to kernel */
+static void prestera_k_arb_hw_evt(struct prestera_switch *sw)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(&sw->router->kern_neigh_cache_ht, &iter);
+	rhashtable_walk_start(&iter);
+	while (1) {
+		n_cache = rhashtable_walk_next(&iter);
+
+		if (!n_cache)
+			break;
+
+		if (IS_ERR(n_cache))
+			continue;
+
+		rhashtable_walk_stop(&iter);
+		__prestera_k_arb_hw_state_upd(sw, n_cache);
+		rhashtable_walk_start(&iter);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
 /* Propagate kernel event to hw */
 static void prestera_k_arb_n_evt(struct prestera_switch *sw,
 				 struct neighbour *n)
@@ -1462,6 +1538,34 @@ static int prestera_router_netevent_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void prestera_router_update_neighs_work(struct work_struct *work)
+{
+	struct prestera_router *router;
+
+	router = container_of(work, struct prestera_router,
+			      neighs_update.dw.work);
+	rtnl_lock();
+
+	prestera_k_arb_hw_evt(router->sw);
+
+	rtnl_unlock();
+	prestera_queue_delayed_work(&router->neighs_update.dw,
+				    msecs_to_jiffies(PRESTERA_NH_PROBE_INTERVAL));
+}
+
+static int prestera_neigh_work_init(struct prestera_switch *sw)
+{
+	INIT_DELAYED_WORK(&sw->router->neighs_update.dw,
+			  prestera_router_update_neighs_work);
+	prestera_queue_delayed_work(&sw->router->neighs_update.dw, 0);
+	return 0;
+}
+
+static void prestera_neigh_work_fini(struct prestera_switch *sw)
+{
+	cancel_delayed_work_sync(&sw->router->neighs_update.dw);
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -1495,6 +1599,10 @@ int prestera_router_init(struct prestera_switch *sw)
 		goto err_nh_state_cache_alloc;
 	}
 
+	err = prestera_neigh_work_init(sw);
+	if (err)
+		goto err_neigh_work_init;
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -1525,6 +1633,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	prestera_neigh_work_fini(sw);
+err_neigh_work_init:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_neigh_cache_ht);
@@ -1543,6 +1653,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_neigh_work_fini(sw);
 	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
-- 
2.17.1

