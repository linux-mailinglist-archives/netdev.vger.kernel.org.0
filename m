Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98F59CCF6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbiHWAMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbiHWAMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:12:07 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500CF5723D;
        Mon, 22 Aug 2022 17:11:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvlQA+hovkS8GjLzvOTK4pcx/FVnCGirTxZywxcDdjLDvLo1JWPRQoj1nZwAg3tN/TJSD9qwwxONZsMjJFIe0qF9frHbaBYWws83W+5jRxH4koF4jRoUskRlNug2G8bzcYoKnGMD+N4/N/OJAtU30CzxIEXwnBy5+9DelsjQoBKonnTwfbGw6/GK8029jjogEroTJIbDS9+pPpIGSXuC8whNIiZ2Wo8N55TajfEAD/oxiDAKiDja+QhVJEdPfloW1ejyW/DiQTIJE4XxxVo/s779vXcfY+l5PEaVQGpfuxWIPajX6NTeInGafIfx0SDaSTHQH0wASrip74W/DTQm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0OUvl/mjrfCy9Nigb3+qFAtg/CCUkZhV8T2NRUl+G4=;
 b=C1jO3d3IfSIuq6OT50fsdMNjoEnyCos01piV55Ace5GfbuF+F8tqWO3O47GmLPg8/1GSuSohMbnBpn/TbBbTcqsXL1wvthWEUTdIT+d+kdxlaOlRiPgqf/H/07MQavh9JcioyWUKaPWrLJDK3jYG8fKtBCgwXgoiBzrM4G4lIMrC3At6Jf4XfmlVGILE3t9Vgz0dAIZIHYhVqiADnYP/pWxN+uLBpUjakPkiuQ362IbNiCbPKw+G/oBKBbxPbnc8FpBV5DgMIYtUlSlu+MQ0kVKNRjGSvDMBZ8isyOyxl7DsngCQvrojO7VlMIf+9NEGr9zLY2mZ/+DYSR07PhGOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0OUvl/mjrfCy9Nigb3+qFAtg/CCUkZhV8T2NRUl+G4=;
 b=XhoSo73te4oLpcwzBfpoUby2+oCVGEd/clIL4cG8LZQ+bc4N+mdiMREDQl7wq+yEiD7QkCZaMBuPsieK6R52mWFvV7IcLyFtoOmXoJq+TpnDyVlBttYgQyR9l81GniJYzg0Df/vmGp73Pp7aevHmnjIAblphNQytDB82ZxF9ik8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:36 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:36 +0000
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
Subject: [PATCH net-next v3 9/9] net: marvell: prestera: Propogate nh state from hw to kernel
Date:   Tue, 23 Aug 2022 03:10:47 +0300
Message-Id: <20220823001047.24784-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e6c6882-5421-4bd0-1184-08da849c0b15
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnYlGty2kxTD38iCKOIheol3ZsEy9fyynFuSTi1+NH1N/YC9wZs2Guyow0lRkuC0MHnlKnHd+lLLo/aWnVXV0UOnobYJU3q1GeSeyItXNQGO75LtDvVCvvKtbd1Wg70yrgaM5lp9WjdavWRRd0x2G4CMQ+hdL26Q7h7AzS9FCkTQDxlZ2loPxVtSTL///kTIZytIqJt0S+955hXn2QpViBM+n6XUcPWH26+Nb+MEQ2oZUffUQsFy5VBG7njUae+5Te1YGoNigfh25Vqy03EjCJYqaA8cYMh2xtBtVMC8kSLfigtg0Qy5f92Ils/+QMJo86kMrrFyzeWoSeoNtXs/YBq/CkcbQfLnsbcXdIwV4dqHIvjlJkF5pmORZSInhjmrs8viflWvwcG/YK/6dyYDlqdeyyVqtGMCZacpvcFlCQHpTVV/8PbV8c22uSme8EB++DoDo8F7krMfq6YR+0sc2VaJHCBOTLU9nzRa6CCor44TgUihrJdr5e1MHuh8Y4Bey2V2BuQ+JLwgt50BdN3MW0fHPVTs272eTnDP4x+zEA1PtYjTbS/8xCk0/MyZv2w+j1D0df/wTosRpt7D1FvDxpoljweBxbzvd+4dh9S7trUacZKHmnt80N3f3hfH+Dw0lh1SgRNsctpW4CU8YNLTYB5EYdQ2RiKRlJw0XFHJfcMawWrQnhv4fCDcHy54nKldyrO6ZIHf/OhKALaNmkCz1KgtufGvZnmJTUytIQT4oc508YIk/W8d8pM21EBt7uLU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(83380400001)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sgiHQhZYyeDfPGTR2mDl6Y+ipOPHf9v9vzxwJ9RY7o7XS2Nd7XMRzf54zq35?=
 =?us-ascii?Q?vOqh/WTva534gm6pgfJYwXdj3UxLYBa03Q1uLTJ1DFud6LRtvj4I6Z7n5SwG?=
 =?us-ascii?Q?qBRe5KvVtXE8GIhDAoV1t4Avsg7nEbxyHBllIqKpslXcVO4Cmti5kF3br0aO?=
 =?us-ascii?Q?9KetZtid46/NXaNTbm/4PHdvSuUNDvlXlxJAt7rbGDFb3K5k24wN0E2xorQB?=
 =?us-ascii?Q?947BcSgc2ZQZqjAIKl4fEtjpLL4qnu20bomogqzTfeCROdkdACCfuTklmrrz?=
 =?us-ascii?Q?PvbUe4dK7GwySwjz+iLOVREapeaF5Hc34f7kUcDXR5Xbf6c5VHlYO8lm2HWN?=
 =?us-ascii?Q?CSep/yhAX3SQYA8/+66HR86XVrHy/b4Vtf8afmthTTWBSg94bUbRKaXujBxE?=
 =?us-ascii?Q?ECgezdNlETbiWf3hF/pBfoEEQmBn3kjIUbI+jJhOUP08swryCEv0vDWXBWaK?=
 =?us-ascii?Q?85esTQjwUtbeNkIa36eHU47mcZNnCt+ecVGdBPbUkvSlfRXXSooKpstlLB8t?=
 =?us-ascii?Q?t5BmyRwAkjv0M7u18tkP1ZxRHpB3DAygTtGuDnrtfe8+76d++aAVrS5erm2u?=
 =?us-ascii?Q?Xb1lC+6WfEoApzKpDiZHQOiy+7luVd+pG4tKXLUYte4RO3NgQRqoeOGV7WKB?=
 =?us-ascii?Q?iqhryUwEkkXFrCpSAWjuVR2QtZIqrcyRzYdYRvFPiAJLwrLbMuGmUgHK8f4R?=
 =?us-ascii?Q?F5f0wNcb5xj41SVHsLwNcThg6lbaUcIXSINJRZlPrfbetfuo+3MMffS+vpsi?=
 =?us-ascii?Q?3RmR7h0DrkUgbhlPpiq3ZyTA6iwqPIPlnGAKoeBX29tfa4O3sgHKJXSMIyZU?=
 =?us-ascii?Q?PZRycTpKW5Apk7n2dJDfX0Wgc7XutlnEUQzVOJe8hQf8EA8WcKPizfbNp0ux?=
 =?us-ascii?Q?GE0EVYzryYOQd5EBAnPecCqFNnV4pK/bbXRwm5psRyzdc0o6XNA78LBl9oHW?=
 =?us-ascii?Q?x7v+4Cnw8z6E2/Vl8cEuto8/RV9BgxWHPA5gAv/JcuYn8XzymWenFk36pbU8?=
 =?us-ascii?Q?aPn5YoRqLqGIlD/NRXM6W+T3RP70FuQVfHXZphXy+Fk4zf3IJ+CnSof2dwLm?=
 =?us-ascii?Q?BL3EOtmisE9gozBVZxFkn0A6j1ay2nOlm4I6/ACQQIEJqRnKUrQz5GBHxFhm?=
 =?us-ascii?Q?FnK+nx38E6fMMny7m7dduSmNDeAtE+iYxZBKGWkkd9XlzZ9QLCvyu3cNLzYu?=
 =?us-ascii?Q?SncbhruUhI3rBl5d3x/8Iofp2ctBdmAMK6dbIPG235EAn6f1QaWhL/xDQ2bc?=
 =?us-ascii?Q?ZSSiANoUBCEttEUqK3EgHXuvD8g9uRPTnMSkO2MDEr2bVC2taAgkK1iDscDS?=
 =?us-ascii?Q?BqN9OFcoV1MrdNh59IQlqcZh/2BDKYUMrUMXEKrWG5ID8z64Xi2A1DKHF/Lx?=
 =?us-ascii?Q?UpyqyP36MVJZnHvo2x+8rASSAdN5v4JrdKw60Ot7Fm42+HPA0c54claeIoZk?=
 =?us-ascii?Q?tKTBTNHJYO64T287NFiX4WzKeQw3/WHdO0sxI09Ymg8MR7echBGn5U+R21nL?=
 =?us-ascii?Q?ZygZj3VulrBlqocglXh7jjwyIxZmCZvtwm3ITouIn/RdvdBZCU8p6EqkJ8rJ?=
 =?us-ascii?Q?/a/OpLFRJMj4ab12OPGvdgf3X7//iAJRpA7SUmcfLd15CI3Lpfs4I2VxU4Vj?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6c6882-5421-4bd0-1184-08da849c0b15
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:36.3447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggVBnfcbk+7OxHZL6dTIFg//NsAZqJXcid2I1l7srclggZZ2qbFhPDBfiSq5YDq8BxZIe9POsboK1MT8lHAUkWEIanBRwvw8i3inLXjFknk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
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
index 8cd934f7c458..1b37ba20801e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -314,6 +314,9 @@ struct prestera_router {
 	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
+	struct {
+		struct delayed_work dw;
+	} neighs_update;
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 444032057c93..0972ba459bb3 100644
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

