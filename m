Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE005F1B73
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJAJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiJAJgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:36:52 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60119.outbound.protection.outlook.com [40.107.6.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5D226CA;
        Sat,  1 Oct 2022 02:35:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbxNAh8P8B+qVz5drXpHJZTwes90PtmJ0J6I3AjqR2QDRiG0aktNRnrQEAuxLVUztiCSe1qOtOwRqYETUfFnMukVa9n9rW3ZfGCTK8t/j997HOM5DwieJhyVb8eHAI65OLc5A2slykf1RHeP7xPOKqb6T94YBI+nXgLOzeNvUPZXB5gWVPZV649fETd4i+mdeMZatDvk+pKyIJKCzYy4oQZBSy9LgYtoxQXEL+ouYQvuEYdKIwpoUnp+VMvHnNdu/zMIN097p55zdpZ5+Sl79lK24j/Ao5lxo1P/vZn0KaAaLUwBujc4XE8LFJ82RTp068wnczJg3gCRn80XczEe3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4zzh/ydezsEhRykrJiL+IUukJJvaitVoZaMF31X34U=;
 b=ZfuK+hnhJV1VKNFJaBnRfv0TcbF73upv9hcoQhRcJwj1T122SS0j63pffkbo+lMGQzOYPo3yxuUrsLkomCi6fYfERdo2G87WwXQbIeX2IMtn+HWENpvXXMtxmdXHF23HyiN0ocpOOFoCFXMEgmNrxg7Tw/EZcqIJQvjfJm+RQpxO74URk7KWv0D6hDywWMjpiWfb9FjYw82FENH3c1eXTr9iiQ7DXeCxgAEaKSqeofnyPLYynm5WpdbLdSnrxv9mHGNa85yk5TygLtZ/q732iFDyFJ2fFY7VA3pjEO57ATWqVcyWD2G+DsZxpM1E0UwvgGFnrm50GBYUzF2jzf3Tbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4zzh/ydezsEhRykrJiL+IUukJJvaitVoZaMF31X34U=;
 b=n40I3YZIOCq8N8qO1pwkb7nB7IMemNu2dso+6b6jdBP6kLjxV0mkrtV67ukhRTNHt0tG5qoHeOxY4SkX9JtbWkLx7UpYfHOrSNff+0upx9I74HKWZSE/Af4ggoMR5hmHgfe6jT7aCcI7lBz5h+uwvMFJMZuB3DFW9nTcRzmmlc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:38 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:38 +0000
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
Subject: [PATCH net-next v7 9/9] net: marvell: prestera: Propagate nh state from hw to kernel
Date:   Sat,  1 Oct 2022 12:34:17 +0300
Message-Id: <20221001093417.22388-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: d76f338e-65c5-47b8-0b54-08daa390289f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLhP+KzKpGMoxOsWXwuDvG+mB1tP+epUj6e5O3wAnl0S6XSBa2iKSIPMBn4+CNEJxKAcTLke67LaMWfI2sPROdCZNPHgJPFDxNlc9oLYl8pqL9NnAUpekO0mI4On9JjAKSCJgEnlPmJYUWHFmewz6eL9WGLwRoWa27owBd3s5iN3xXBP+1YLG/nIANCWHtuoH6mERiEJKEd0Zrsfy7wrMzn7OTILmV6FWtu+b2iRxh17J7eGfBgGxDq+IdMfr8YpmcwUcqxX56bFqMtVSf+pH6w2iwfl5GxitshT/c+OHy6S0S2pkuHWEQD5+whRZfsEErozAg3NKtdgn9yxhdQhKcmBpQQGjDPhnfULLx/qgsjR38PKkO0eLe0P1uGVD0eJsXuq5pRB350dcbg1MJzdIwiD4DL8u76zXZGh9qoPhlJW9ix3Huev3U3T9DyFiOLS8VrY9DJLhTkwgQQMQr+0rMTxuOPnR4bHM243hyJmHjdQiLrhiXTtE/xFrditnHA/BKGssP2zjn8OvzXP2gJyTZ2gNaPJdhDSsO9BcCt1Hrgv9PMEQ71Lek1Oa62u6sB5VInLFOP9HkDTgsYbz///XNdxTJ9VaAQfD1fZWXWaFA4WAj7jVDFl+JKO6HRm7M5FkCiZ0XR6ai3GpBK882ix7Rz6Y69yIi3M6ifTIAQ3I4wD4tGg+jEXlsIPJiNP75l75ys1N/sSz41//NEA3Dp1BG7mbDMBVK4INhWHX4hRRIF2m0wd/4fOrbLLCtLP+Se4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(83380400001)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ahq4pvGa7itC9tN8pSdVQXYUqJeohpGcHN6/SoNkx5E0OsnA1EwlTTcFIYQ?=
 =?us-ascii?Q?4rpNIRUUK/lJonHc3TpViB64iKcRGUu1oXRU0RzOOElj/uR2Pc0zifd8k9UE?=
 =?us-ascii?Q?PBgEMTjgGIZW17B/ciQzFxuiNNjcNETEoVtNYcNHp18NWbfmEhGFUeDw4we6?=
 =?us-ascii?Q?BsjU2kwiOsLB3kjVVawHx2hTPz0vGvWfwhOve2l9hm+aRDvAImzqCE4CoFWQ?=
 =?us-ascii?Q?kuPN6CKyKZxbovvDcHJPWjmtJLNaEjWNda7qLTD8fdYORupaVlApauVg1LJ0?=
 =?us-ascii?Q?xLKXCJZ+P9gnBZkBeS7ctDDHYqF7MWSCt/VcduPZGYRf2KhSmpCdDz1PugK3?=
 =?us-ascii?Q?J2MwAO2vSeMiDmKin8oBQxRzcW/x0ZOpllplYTA+yvNV1kxYUP8+TmxnLRM1?=
 =?us-ascii?Q?5B6ao9SV5wtJggwu4vd08PHNhAxUOF4Db8LSJVJaz79hca80AQIYj8oXBwJz?=
 =?us-ascii?Q?P85r8zZFL+yoEynE9m2rVan7AIg3VQXoT+vWPlkUEKX+L2UnpZS46VaWscU6?=
 =?us-ascii?Q?aTreN4CXZGK9faalXfDrlRkp4l/q+oXtn6WgTWXR/CpPypck5uBWHWFeSpcB?=
 =?us-ascii?Q?qsAG0YwY67ISPR+Q0BRbVtTpX9+SaKdee8Z8rmHrORDeNsyOt8mAfkxgEoW1?=
 =?us-ascii?Q?yJRCv+a/+82sFfU6CtzfauUDta9HmlCBNxnUMFFW36P0xoxrCxelSQ/6Rn0b?=
 =?us-ascii?Q?rqandUE5+gjJEOiu8ykHbeavuGFH9H9dHNWgKdPM7aTR1xvn3h8OwFWoOoRu?=
 =?us-ascii?Q?yARWn2cGylJb84OGSQWtLNHiG7iN29/xgZh8YXukC0ECkNxw6k7xg/2u0u/M?=
 =?us-ascii?Q?BfxJkTHVLkkdlCX1/Y+l4/e45/I2DSLu2eputGIilompWZYV+bZHpdMyO1xO?=
 =?us-ascii?Q?Im6Vh9aIriwzKya1363CvhYN+9NacK56h/I+DKPfcyOZ63eN4ad6xHP0H0hs?=
 =?us-ascii?Q?AplXnCGb9Scb0mlBoyvjKjBtzTN1cGX3K+/YtZzEAF/Ej2kubKGsPlgWIVOV?=
 =?us-ascii?Q?M8KJ8Hi2RK4cT6POJbjpZ9PaPhBiEb75H/eqDujq9AVm+a+3+0TU1xNoim8+?=
 =?us-ascii?Q?yZrarPSYD74fJkoen/nyXU3UQ0QOAgwx2JmWWnx6Pj6lI1q0pf1KCBGPgHJT?=
 =?us-ascii?Q?On24szONgVK5Ehc0P5b5x8bXV/fmROPJ4vO4n9zC7jYceQOyMBF9xuT5VlSR?=
 =?us-ascii?Q?pLY3LuKQPMvJ6RYDIyv6qV4F3KpL0FeuEH7vhOVllONz3ZprVdVAEA6ctYzt?=
 =?us-ascii?Q?a+MKMdAbWbTsuKwOeZhbm73oz5EitU7MA4Z1FznPtrkaH+2SPyrZ9kOm7Bnb?=
 =?us-ascii?Q?d3/BlbAD4k3jNUcM+bAFNkL1oOzCtQ4H9W8vDzOXFjt8xQg0DoeecIKhih8U?=
 =?us-ascii?Q?kHG7kOYU0ZHMdQQ36eXTtsBi0NBNRLrtLh+zt5QChnaJ70M7dhw2+Q0bmDOi?=
 =?us-ascii?Q?tyO33LluVduKppt05QI489QfJRABAjv7KWv7f8SrZt0Z92usr9P2Z5NvAN9F?=
 =?us-ascii?Q?dymeksFvNQEqrLxmqz+iORhsfNp8C5JFnTPlBxuxyRASyz3Y7/Ho67PtQYle?=
 =?us-ascii?Q?yMv22stzvclgXXz4mJZERnFBlWCmH7LgDxQD/TpxeOBINu041h+eglx/Spqb?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d76f338e-65c5-47b8-0b54-08daa390289f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:37.9726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ec7MlSBjFNSOhIC1UsKM7bzlKoUJFozr/gViK4x1HA9jVgi0/fkkpCX9nedsA8K78r04IrSucXp7LOaeO2v2nw0Baqldo0JC5hMlqWznt/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
This is useful, when you have add route, which will be used after some
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
index 540a36069b79..35554ee805cd 100644
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
index af7d24390d2e..4046be0e86ff 100644
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
 	/* Lock cache if neigh is present in kernel */
 	bool in_kernel;
 };
+
 struct prestera_kern_fib_cache_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -1021,6 +1025,78 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
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
@@ -1441,6 +1517,34 @@ static int prestera_router_netevent_event(struct notifier_block *nb,
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
@@ -1474,6 +1578,10 @@ int prestera_router_init(struct prestera_switch *sw)
 		goto err_nh_state_cache_alloc;
 	}
 
+	err = prestera_neigh_work_init(sw);
+	if (err)
+		goto err_neigh_work_init;
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -1504,6 +1612,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	prestera_neigh_work_fini(sw);
+err_neigh_work_init:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_neigh_cache_ht);
@@ -1522,6 +1632,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_neigh_work_fini(sw);
 	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
-- 
2.17.1

