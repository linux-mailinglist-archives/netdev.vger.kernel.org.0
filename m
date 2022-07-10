Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E37656D07D
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGJRYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiGJRYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:24:08 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60092.outbound.protection.outlook.com [40.107.6.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793311573D;
        Sun, 10 Jul 2022 10:23:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXT6ZTA3MCZ1bMp2MuelF6kIpp5MiUwtkVsQjQBTiDsiGTjbjSnAXc1og4kq8H1LZkJNKVnUzDiYevnEeJ12CgOKT/eGmnlzFaeS9gSrb+ZG9+OmnWUhde9nL93X85SpaNPfaDooi6rJPaRHI8d4rYC8JdRdAlGLocYuUMtfR057QUc2Ka8dYr2mISy7jUh2QsY4LDJC53JBN6JlTTT0mZLeZqP5OFIEmk34fYAnuUaLZugoR0BlYkznUEWn3FIWGwSVvtesbxwwet28FteqtsfS1f+B1912thWjLOdkI5U13bUYagAJRp+WLRkjxTZGbmYUQ4mwUqGiwX2PuxUcKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZHg9TDdO2wOMYlQZ1jlMn/edIaBm42AvtIR4f5v1Uk=;
 b=N0eIdydGD2VkSe6A45RmexeAcY0PzEZI1cu4ZE7XCt7eJIOt3nwuspCwRD0esVQQdHwJDVyZosntm8Iw7+rFxx9CImOL85EQ0UKMloNjq8HdlXW1FNppjSDR3VyW56HvdzcmjWqkSMe+CfToZzvMv+wHfyYdHQuDkqz/3FNpt38qnyiCQ2EDTrHnQSoJZQh/JabCPB6hOS5xpPhBJuFwoJTFiBX4W7oc02XXlLtK14mK5LWUvro4T6POLabS7AEVW6u+iundoh/oo1zkfeK/DjQYTk8WHSgQqPCGfgcjqIIv1YjlOu1Pd/bikSRxdAFytSGW9uCJ7aFUO9T69hl2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZHg9TDdO2wOMYlQZ1jlMn/edIaBm42AvtIR4f5v1Uk=;
 b=KCcZdm9bywZ5Om1wUTCQu935Pv1p1AnRRJ3G3sXkpWFULBPPDTDa5zHsJRH7m3E+IdhHuLpKsmMFJUFUidVWDoo/JliCej1kwnGQsFfDMU2h8Kg3PNi4p0XE2dSF06gEWVykpQYsgxGHWp/qUKqC2EyKbBi5C4HU+PdcPv7amR8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:49 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:49 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 9/9] net: marvell: prestera: Propogate nh state from hw to kernel
Date:   Sun, 10 Jul 2022 20:22:07 +0300
Message-Id: <20220710172208.29851-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e20f3dce-2558-4bb4-e699-08da6298d04f
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSmfd2KGkj5+HzfRPUrC0DEBA4CCmAm2Jl2hvXBRbbkXfkIrd/9FRHGv8DSVQxqldoGmIuELVO/esLMilSMXgs81pKpgGJzrcf3tu79DqvPReLqvOkBKGjyIAIg9j+n+jg1NMB918HCmLVKoxZuYYRRXzKlsHIBbiQGJGlQKHKVw6MEgb1Wo7Hxb0Z+lOZGVenlBAWvi5Mx8d/ia3u6zIosNXhJ5CKuOyxwvwTbNsvg0mxsCm69vRTdyyXyPj1MKEEfaSvmPed0+2A1JV1iqUG0uV6kUxUU+oVNvyrE2Kl0e0zHtTueUE81a7FA6GX5ShVpJj75RQqMdqzvS8PBkA5DvM2Yli85+kFLF3EBOdJWh+8IzRhV6804LOU9+L94Xv9v/deckTiv1bot3PTvYQHIFW+lkqndTzDQR8m3qVqy6jhlWzQEOGi8lBvysDaoytTn7Y1L4OlUFrK0qiNfWatl9dojhqbH6Bh/1yr6ADeZMlYfO2K4Tqzex0y3ZuB00hUuPjNbnshMHerQvejBPe4TyOvZqWRNdlB+F9g7VXp68F4lR9VMThiTmKOz56iR/5ZuNpof01hSDg9SmzYXKlr9DDYKSqT+ovl/YYidxSb8frxM5V0gQcN/JOyCPOdKblWOSBKIem/vR+Ar8t5PT/dq37doXS8odwhbBQFpoBC/3dq4gIifyyEUIEsm5tEA9ouLTjoiTGQYSg1IIzrIkNgX52W7FKtYNyl60Ktpg56I1M0DSlmHO/mtXWAL51oWAUZvxyPqty83u3SJzHuqNtgbmkPzkCQt1vXe2rutFOdlJ1yM7D8I/VDl+vlQlySNy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TnKC+E5Gz26VXF0n0BMMAPplyvDl2EpW2kR1DlCKU4HXCRDxbJ8XomVTmwAF?=
 =?us-ascii?Q?TsPcs8hiK+qDOSJICrJdcTCzFrrV4geqv8JXixHIye9QRzfx7uaOoltyVJtB?=
 =?us-ascii?Q?NE4zePe/e3Wm3EuimgACpg2eBEsB4o7GU93XugKjfVwI0CQ+aut8RvWbio0k?=
 =?us-ascii?Q?PeXx42G+zKPyCXRQa9+0cwXxySIGTXJzYYNj5VLjv9UW5mIGVqf1WL9bVfNp?=
 =?us-ascii?Q?DVJpWyoG16JxGQqpFKW18y9WjSSx/YMCV0S2Uc8JzVsBetfmC5jSmm/jteut?=
 =?us-ascii?Q?p2BKqaRHY8ehcwP3xrAlPiBWFT36cYjIXhc6z5AY4zc56/7EX3J/eKFxwNNq?=
 =?us-ascii?Q?VkFwBoO2sTI0HwNZotgAdEJrU5WYWZRHgjry1R1+/BNmcpXgrIPTfCaTLAUH?=
 =?us-ascii?Q?hJT9BvDq8RisjrmRVmIaXIgVjoGJ9Ih+YWu7Y3SDe6UPONmZPp7aV+ikOpC5?=
 =?us-ascii?Q?uBP/FI7/vj6OhMvwqHshIQ1RhuYVmQBVDEPxq+2zd7hb5Zt7y8wBtK1E30Ug?=
 =?us-ascii?Q?BlGyyq4XxvfCNvvfULsHA4c9M8DLFuWGeRdxtuOlUpMNoIhmssXdtAhSfBaA?=
 =?us-ascii?Q?OSrlkgaSKD6PRPT7pRkmjIBwc2aV16Ll5FrAcY6ft7AD9Dyo8/w4SFHjHJFj?=
 =?us-ascii?Q?txEKSW0mj2sYppUsWDaqSJ8MJpYqaXvrru4TduYueA/xBpmfjChHwNGKOJ5d?=
 =?us-ascii?Q?65zy1GAYo82fyIsEPo4MGi+ImP6fKqBsrmoz6mDBY3gyWpHwKZL/T/5o8R63?=
 =?us-ascii?Q?O8mr5S9H4Gi6dqOy7jGl0MfIbxBtq1JXYhfGaMRxVvfWul62QzSaPyyYuFuc?=
 =?us-ascii?Q?1yOaAEKxsrTr98G0aGu14/mECCTdnWrh5SaSgyxM3VdP3ix8FY8ViybNEehD?=
 =?us-ascii?Q?RhC5OtOULebscq3gGzMHtGBZfT6cXwAACBiPFGHN7cmF1VN8IZr9flojDhPY?=
 =?us-ascii?Q?CpmaXwro130g/nXFbXqNY1Jt6xTad7HLwsZoQz5riOS7RDP2zBoXsyWxwREQ?=
 =?us-ascii?Q?nePYTs9XfXtZbYYYaxa82l1/BTMTkhtMXiiu++BTAKhZj4YNF3y/jPcaMY97?=
 =?us-ascii?Q?vpU/6/CIXDvrD6/iyjVXSlO7d+nv6Pxilyu+odYI/VSmcllgP1telPSCwZoW?=
 =?us-ascii?Q?yP6v+qscsIcGBKQVA5NMa2AaVnkZlRoa5dcQ6x75h/uYq978WyyUFW8u7nDw?=
 =?us-ascii?Q?fzsxg5+BhLvbaHA2cuUi0/yIW1C3Mht1BVZWsgpscXPgo4ftpUNjg4l5mzDD?=
 =?us-ascii?Q?OnLqwNNFtBi5NrTtHtKrq/Jv5Zx/hft3TgeHlX+Ew192CqG3D9O3JQEpkPOb?=
 =?us-ascii?Q?EM2qpEarZnFsIphk2+veNHC4sunpVKtjzsFavCQsyPBBMQEPTyomMJ2SOYsL?=
 =?us-ascii?Q?a69shoAH6Bqrx9QroN1+WAO8nFe4RdJhkScDxTitVir1PZoNyC80n5urN5Jh?=
 =?us-ascii?Q?8zkAf7GHIIDKky/474RuQoYDhg2HKG9gokCZK9Juw2xA9Sa/5tR3rQi3aNri?=
 =?us-ascii?Q?9KgfTjY1xLvUNWSZz2Fy6DNmdALt7iEK6RqBBh08fEJ1jEgIBAGl2Q1lcMqb?=
 =?us-ascii?Q?lSqQ1qEX4FKjJ+IqTtSARDLY4Nnd91TyEIqRmQzlbHFz4ODc1D+RlVt6uT6A?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e20f3dce-2558-4bb4-e699-08da6298d04f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:49.6887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmdKzSiChIZVK+kfljg9LCceXjO07crbIzvgJs7mDYwlv524EJ8ZLgr+oE7dJWzE07W66oFzBdhhe71s1bbWdfWWMF2VZjonA4YleE8PkFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 32843885dc3d..682cbc3652a3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -294,6 +294,9 @@ struct prestera_router {
 	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
+	struct {
+		struct delayed_work dw;
+	} neighs_update;
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 6dc116c2a4b6..e342c738355d 100644
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
@@ -1017,6 +1021,78 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
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
@@ -1463,6 +1539,34 @@ static int prestera_router_netevent_event(struct notifier_block *nb,
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
@@ -1496,6 +1600,10 @@ int prestera_router_init(struct prestera_switch *sw)
 		goto err_nh_state_cache_alloc;
 	}
 
+	err = prestera_neigh_work_init(sw);
+	if (err)
+		goto err_neigh_work_init;
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -1526,6 +1634,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	prestera_neigh_work_fini(sw);
+err_neigh_work_init:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_neigh_cache_ht);
@@ -1544,6 +1654,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_neigh_work_fini(sw);
 	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
-- 
2.17.1

