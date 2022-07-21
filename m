Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17B57D6B1
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiGUWNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiGUWMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:48 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE2695B22;
        Thu, 21 Jul 2022 15:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy6Lyxh2dLdf96KE9OY2ero3LGP6I0uOugf6UTFQzN9Z8q+OXhaWd6jHJpgc2Gn2sVez2/ehMA1kpB2RTh8MUHCKWrSSfCcNo9ynim7vCAyIBrYtI152VyZQK/whyPLlxA/LMfto/uKXIva8Fh0Zpgh3vdJgEoXM/6q5RvKOAtqa6YXk7Lq4iJsRqYc2gES0TjwGYmSrtMfMtpR8FuzByXAig+bDt/S03PFbRdg2aTRJ9TkTOOsdAyO+YBn5iDG4+Wj/zjdhp1JLvETDiCi6gHw0hPMk74ZAqveNowNHmQUlGNUHO37NwfVRhW2+f9ILGS0Zb4EMPKaRWpFCbAYe8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CqakfA1V0OFC97afZl8/ycepDnrPrMTE4RU3XF4v+E=;
 b=dEUTGpaEUtOd0TATCoeCH+Pf38Irt4OJg+tRQR+VfhL6rSBP4yGUc9ScxXlNRzM4tJwGZj8q7S9mxOlFj8S8olaEdNQj7II/V+KmaQ9rYsWAqGxU1u98duPvBauAWYHNevLjOakSV7t324YCm92acKPo6Di+Py27a/dmcJJbGMaJiXie0OMGxgwR4y3/3LOfODLsN1UBbmh9OIbuN6sd/Mn+204RPAAVvfTt9gSIYiDYlwM3JkcjQiYae2k3A7XrIocjlZXk8gRDVd99aoZh1L6BuMz5bL9J4Qo9rIX+4SNFeEy5qCA6KYkgX42v9sLqa50CItUQIFcZTrvLsYqbXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CqakfA1V0OFC97afZl8/ycepDnrPrMTE4RU3XF4v+E=;
 b=uXuBbBihgB47yIfTVh8vGWbFoAap141GUCMtdfrsyaAPzHxcSxXaD2HN5kVFMta7Ce3v/SwSR3H9H46hLdugIDCB9gz9WfcQ1q8YhCXBBd/QQNkMJX2PedKQc4EXEoF/ElXdf/UvGXcezFVa47AWtNyOMbjC9v7iYGeCsRh0WkM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:16 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:16 +0000
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
Subject: [PATCH net-next v2 9/9] net: marvell: prestera: Propogate nh state from hw to kernel
Date:   Fri, 22 Jul 2022 01:11:48 +0300
Message-Id: <20220721221148.18787-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 285ba4a8-545e-4b6e-f15c-08da6b6611ef
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwqmgA63krXAl+sDZNIbkb6/DJ8WAKp21Xboc7pOsqt4rbOoQiN0WxZ32i9p1i1EfU0VDKXn2Q71g/eoMZp8s3otoRnfFboG6ugFCPT89RBpKeuCJ5KRbBJV431nIMgo0dfZISLAnQfyttU4vYrJf7b2HP3dWBV4ExtAasf7RqVVbSwlwwZ45upDzZHWude9VODksI9zR71jcz5R65lZqguY5FCRvoyAd7exsW0J4Ux4asQFgwrXhEXBy1k5PwS2RlYGppTtR0jCF9tJy8Gq2WDg86smTZ7Aq0QYHqiT0gQwX0qZR4f9g2izuE1Vax0NpFCdowf+VlSkS/sAgeWzIfNzLdg3hsJJOrPW8F3m3B2a+iQF/UV14NSHHgCk4Zsulf8bxihkKEEOZwIZfn6IfiWkhFhjJgWE7TJW8M8LlLe2xY4PrxT1IfZ25mm0mzh502H8Hj+L/nzbUa3nJ7BZ5RQl/eXxxAnAam5zczImj8plAokxXtSqoVSxzObLFQqaASorSs8SnXgQhRtaRVkNj1POSKVAVJWRQZh+SWaqbHvmhZyGLXEjTeRHF5VFxTIFIimC/cJMtFU0fG54p8A8ozJB4WUJHk0/MbPKD5F0Ccic4IZYYup53eckQ657vo/Wpp8F1wrQC/BHdMeUqKUGY1qF7W54hlRpo5onAc7UArZ3DJsCresJ2FTlO4600go9ihxg/1W2cBPZh/uie3UGsbI+IFLtywbeau2e+Ld9OLDHaujDgfyqZ4yyp8OH869gbFeOBYRm34bum+MZaTZpQjAYBJwjiXVvB1KkIClnn1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+qFD9wsexb0xyZcimaL2GWahvjZ8yCj2FEtARWdKVFIlG1aZVOsHsmDB4pXm?=
 =?us-ascii?Q?0FFIA8+AO9XE3YxjnAEVE9sLV/56zxKlvPJVNt8k56Hp0W5Fn8UGPcvALZKw?=
 =?us-ascii?Q?4mEsaiPwRJJuYv8rLuH+W877pmtkDQDeCrnBjfErcPB1id3sIbabZ9qJFBKq?=
 =?us-ascii?Q?4+NDSx1UIRHo7UN7ILdjCEUnhbixs3DxZypZkAdZMW2DRzz5xdlT90HWrl9H?=
 =?us-ascii?Q?uW9O/39azQaZYcCp/uoA45rZznREi8Dhq725U+zYQz1KMieEoxpOG/IGDXih?=
 =?us-ascii?Q?9QxwqIfWd520u/YdJXZx3tK8F4xe0d0u7mMTzRt15T09qXLjqI5fPonHBVEc?=
 =?us-ascii?Q?LcpBBN6/G62G4mXETbH6JfjVZGvaVvM7h871cpTzlN5uA5AzFaPsG6QsSt1L?=
 =?us-ascii?Q?UXLOZpRTV40vrRISUpFL/NSXBioIM4SiXPQghW+CVrmStn3nK0n5uEnGp+6b?=
 =?us-ascii?Q?pxF6z+z8xQ6YmpfMyaIH4R0sIuJltrLPOahnJVy1DjFYBgP6V4dK1a66erZW?=
 =?us-ascii?Q?WuQiYJCRdPyscG/5zAXbMnNkIhUDKrNlipXtKbITbRWuSMtXBMYjgMA/J2qw?=
 =?us-ascii?Q?PEU6oyOxZPjW/PPdTB1wAwndYRPrf+lEjl2S6a+XO9uwYBwQGQd1LyYITvXi?=
 =?us-ascii?Q?at6lbpMfhQXSt8Y45J5E7u0EQjDJSDeaiKBBl2IoEyJNrpGY63w+8ET59TP2?=
 =?us-ascii?Q?o2dSDv/aBYrZd3+QttUgq9W/9WdwJNFPqlP2vU42H/FMnA7lsc9bCMPXehTk?=
 =?us-ascii?Q?Vy2vleCflSD4XTVp7aPGBiJznlRsREKr9ZPbTBSX3z7hVld5qECdh5CrkCa1?=
 =?us-ascii?Q?mes8xDKTK/ocLfbRX6qXva+vsKoGqwAtm9j+ocuwA4W/a/T5Vn1hJKHGqoaE?=
 =?us-ascii?Q?EEdaZ1dnS9TN6NKNoGfWq8jarlvaP9vrAte60CuFaAsAkvxlWgrIgVXbT4Cs?=
 =?us-ascii?Q?NwZKcNbVfFGH8gZeeJ+RejbtJfD8Mb8dNLUVCl3RAIxzTL1PfQwEbSc7H7ol?=
 =?us-ascii?Q?WRjLTjKPEY7FuxtuiVIhE2HiHW1JmNfV8kvM+fjVp8jRO37+pPMsvbysP6Hw?=
 =?us-ascii?Q?pVIPN8ENVCovq+9DZVYO46Xfsll+uHu1S4efKgGBFwLUPSSDs9JdcmTxAhB5?=
 =?us-ascii?Q?4X2mMUTXJ06kQlJbZ0q6R0OsF/AlR8woKhGB6Y+MxuaPM5vdIvlOA6NqrPx/?=
 =?us-ascii?Q?Aa5In46VEOxqLVG5xqBOhGe8DaDJfiW91RsqcnJ1FjuRivM8+smH69clkZiS?=
 =?us-ascii?Q?Ioo0xwYegKG3zfOLuXhZh/OXQiA9bq5TsKU3hAoJ0jJCh3boJpKVMjc2NLpU?=
 =?us-ascii?Q?1k5r5OF5HF4NurSe5iix73jsubKZ5PQeujZWJ/bx8Vaa/pD/0R1+iCDYd4Xr?=
 =?us-ascii?Q?Om6B6ljRNEyvmKvOQmzGHS0JP32aiGypilhfrwvs3ZvtOnR9G9PTxhBXqYTg?=
 =?us-ascii?Q?vgVG74Xlv3gexaexnKnp5tS6bGt/VCnF4ZTRAOaUl2Lx7EaG0LCncI6fKlUO?=
 =?us-ascii?Q?1c9XX+ZEY0zjRJTdQE3FBem0AF/FIES1VbwmHVGaO1nOARCpw0Sb+ETD7Q8T?=
 =?us-ascii?Q?gDnE19woU9WMo3wPwpDDc7RaMG/UKdy98ZKfs8iZBsi4mQ0dsDLbfLNQIHvg?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 285ba4a8-545e-4b6e-f15c-08da6b6611ef
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:15.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgDXgBFPj62z92xtydPpf5TbuMfAVnd3XU+1xvPBPpnJViByQ53As61KiJzOIg1fqcmBsgwJ6fttQiCF4dFycWszrRz4s7wysAw5bpBKu3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
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
index 292201290f04..c492c1fb8f29 100644
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

