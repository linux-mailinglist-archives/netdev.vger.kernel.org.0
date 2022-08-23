Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0357059CD09
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbiHWAL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbiHWALk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8C257233;
        Mon, 22 Aug 2022 17:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYs2T+sY66/HX+hfsLVgLPDKVckZlZYY+SYquI1BL4DRBB+clvoy4eosdQGTjcm5hqHBoILz3MkQE3AEetuNOHbH4b7am8uBykxGaqoi7XMG/xiwPJ/jy5kh53HCQDIF7c2KIbNVC/WOge6IjSEOg+rhZ84VyF8CRcygE+hzy+ujXGYAJ0BAvLA43bGW9g+ZDgkxT60BUpsiexh/mfLurnJvxx7NtaNo6tj9hhQc1TczztFTmco6zo0B32395dv+BHO7LcHT6w4SAmIjGEPK+dIEgs0WtgCpQ7iizZEVyLjZ18HM8kYWnYsC/cQb4ScazhML0DYB4Aro1Q/K7oX07w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nIDX2w+y/vfl8GH7nfLeYcbiiDBwbMmcQs2JJI7yOU=;
 b=T2Cqe2Scl5v61sQaBdOiwc6VcSLtPiL3VJXPoAzMpV+mfv8ARjHlWNHvTHMRwDBz4lCFZM9R4bU/tcTRwCFxNf42wepZE11Qdryij5W85LbgjXynJ+MRdqPlKtbIso71zAhizZOGFlFqqk01E+4g4011GqumaRl4vUj7ihtMlDqK1uaBgmc6YhLATxvnS0+ca/wNoV9Er5FnBjRe7z1AlusiAqW79O3Ya3URtXjvAfVYi6j4eWNKDetkx3+vRy3s3cW5PHulpHSHP883vudQomfsxAhJS7f0xYMQcQ7GaF/i7tpOprWxRS1ljUu42XMV+ckLN/ovNL6CNCwOzHhyQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nIDX2w+y/vfl8GH7nfLeYcbiiDBwbMmcQs2JJI7yOU=;
 b=JkAQ68KGjKm4fWa4L3Qs5OEcqgeptVbXijgnlcXzBYxMyIcJ+c9stHgBoTvKft4xl7F0XoV+tTtLNzt2p+Q58Svm0Q2PqB1kYbfU1MhsZIAr1yCDGOtRgRUJbqSHiJp0aHxz2ulac8Y0SBvfz6ovpxY029mGET8ljmZU1vC7H+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:33 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:33 +0000
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
Subject: [PATCH net-next v3 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Tue, 23 Aug 2022 03:10:44 +0300
Message-Id: <20220823001047.24784-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ce9b9fa-7e01-431a-cc3a-08da849c092e
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMI/A+wqJe1SXV0z5fFO2HzVWY9eedFQqhpJ9/6aVdHBlR638Jqfy9icEYaA4V+sfP7Fcm+ZlyBOBza1RM9PtkeSMj8mO0ffD8tczibmU1TKWflOq1iUHE5sW+BVvzAKXxa5j9u09KVBUMZkag8X5oQde7WtvM2sQTlosyzkBsaqOQkaLZDmu4x3XLfdbeMToMnQJ6B5r4WP3XgPe4FLcxx4kuvkv5Q/+Q4zZhQeLFojtOFKTgpPeTu99cPj1CZpa8sN+K024hmAQRAkMyXAxevMEw9Z6diM0ahuIGldvJyxPDkKLV3PitllcgEVEOvBeYXutaDc3acSNL0BxjLFVUxwwRjcl/YBK6cc1fqu65V8d+aREkVwgawHapEpnoD6h78KrvxhAYqq3SjEknxcsfzYkWxUV16hS6j8ZZlDNMOwjBHMRn3Gpe5AUTUdSYv3Bs8n/DtIYno5ErMfPYytsDH5VtWgpbLpLl8AHgscYEgp2F4Sa9JTeaa1JdOhWqMajlGqv0awmkkUQym2GeUMymxckFGeWGWmWRIoJr5Omh6p+8SesyvjpJIItaZ1rDvOkW6njk2Y3RcSNFJi7SBfDB/jjFLblu0C8aEBWhh9S+PZ3G0EW2j4Bqhm7eDWFAduj4LnIwK637PL28rr5nR6LOczNGHPo4tSZgxzLBLRgm5/ljv54N5gLt79I4VWaAJkgCgoJR6uHUutuI2uMjcAHaTYId7bHd4mnaqTUf7LSr522VrLkXF508BZpBVs1OOO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(83380400001)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dkj7ePLEUW6N2B8qammZtVxNMSocBCbciQYhR6xsLHZigzTKJSwU26UoJyhU?=
 =?us-ascii?Q?S/DBYECp1jEVMe8YgFZCXRBv7ntIHleZIQj9KLjCEePkWfd78TxLYS7YZ7Sx?=
 =?us-ascii?Q?cOjlCZEkj/rUmEx67kWVw08NDZWyc7yBvcaJJyKOI5CSopIEAgcIcRvWnEy+?=
 =?us-ascii?Q?R/iWmIR0IdXDn0jfjwH0Inf+xaGX1gzGBSa5kzqwU6KaEfUjiOgGl5R1XQst?=
 =?us-ascii?Q?xdLQOF/n8d1wVYJU69z908D1YpNTB14smwiUJmPzAEgbTkbwjDyGnIgWwNw3?=
 =?us-ascii?Q?hMKUZZ2D6UyGMUPeZMLqXZPLAhvx9laXBTIBeWvWfbCRD4suSwQLWUc8sLM+?=
 =?us-ascii?Q?4PDEuLyocOd6A12SH9ZTU4V9/UexFdF/khoOShg3wvT6eRVrsuvOiIblOalN?=
 =?us-ascii?Q?VFHrHen5oI8xMva/SdQUWALWUECFbECHBzpKQGSGGRc9AZQQqFZuz9v+38P2?=
 =?us-ascii?Q?42Y4OTI/pn+4ksX/oOj/9Cmy8GN9PDFLEvr155YwFC7EpeY3ibAKva6VuXCH?=
 =?us-ascii?Q?UHcQn4p9jDdv8sMJBFj1sBA4o7bOgfLL6YdGZHd8rrLZ/dxL+1ufGOcJo/QS?=
 =?us-ascii?Q?YXyJ6TCgAm3VhzuiwqIppBUbR8RS3GTRoD2Qpx15xN4yod2cin/qxKGau+oT?=
 =?us-ascii?Q?U023ZHyVryzUoSOFTvnjdkmaRypcDmAngsbsRXeh9bw+PI/y7vA1FxiSOhAb?=
 =?us-ascii?Q?alWVq8srdV+Fpsur7UvGUffel2sQWnVXQ2PQaNk3A5MVh1khsXqOAFggb6ao?=
 =?us-ascii?Q?HqajyZPv+SJ+keUK4pE8sTf/iJD1ExPvl4ml8FlCQ/vb/ZBbkibQlDS58t3D?=
 =?us-ascii?Q?ZH2rgivRagzASZ0of2FlyxS27ttVl5W7rhmB8Q6uOvwbFQWi4kEPFadxLdLk?=
 =?us-ascii?Q?T4WIbrJVFE3D+Vc+ro60UxO6QjWXF7mdKnjOYDfAhX6xReHeex9P8xQQj4kz?=
 =?us-ascii?Q?B+TaKvjbcGudTSPH5M1IAWRUilZaPgRskBk3FjKshqKR0o6JDCgfZfq3nwaQ?=
 =?us-ascii?Q?tr6NtHOcideXloPQEO4Mwm8AJlUajES2bkdTMjarrUQDBFKtxpkb8gZpey9h?=
 =?us-ascii?Q?ZimffjcwvvIvHXtY558QWdm+eGvG1gdV7mKlqcwz9XDb03B2ie9afqNgXXiA?=
 =?us-ascii?Q?Z3kdJRfFNi7L9yDFPE6KCWgGCM9Op3ZWjELfWbr+w6VxQJi+Z4MfbT9dyFxX?=
 =?us-ascii?Q?ypfWs+4qqu3lxgzD5zGwTc2B18ssFZufNvX7HEPDRkPNSL9jPLJtzaafSxKZ?=
 =?us-ascii?Q?q3ZuiqBKpeR6RMvqrpQVVXpFblFsvRgjf56x9qYXEMg0jMKxIAmregZ6yjjM?=
 =?us-ascii?Q?f5jVcJLiW+IYtGjH8aESnpeHRnt5qh0QgVGuZBQyFKltn9joPm5fysJA9LYd?=
 =?us-ascii?Q?Gmq/44gLeh9rXVg1AOq3B/401KMft6St/e79OYa5PKME14vOwFTk0oQ+XET5?=
 =?us-ascii?Q?YNv6mOgmyHn65S5v/PaS/wqQ7FdKdwTaAQcHgM6pEVnoy35EjTNf65kzd4oM?=
 =?us-ascii?Q?oeV8JFwEYqSx7i5/dyTevilIzpu/oyip9rEYL77G1ZrTpVP112DTR2FY0J44?=
 =?us-ascii?Q?IFt6+sEF1qdnkxBbVgi0qcF3cTDzPGLY+znFWDkUtAJgz/Og3j20iqdZSpx6?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce9b9fa-7e01-431a-cc3a-08da849c092e
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:33.1422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBPK+P8162ccr6DstVQenV9j9TziryyrMIQiFrZkYLY2IJpiMwrWWz89VDN/GVdSiQywyE0b7ExDJ5THtrDDO9W/A2oBjgONEAt/60u1gLE=
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

This will be used to implement nexthops related logic in next patches.
Also try to keep ipv4/6 abstraction to be able to reuse helpers for ipv6
in the future.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 101 ++++++++++++------
 1 file changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index db327ab4a072..89c72b9ede55 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -7,6 +7,7 @@
 #include <net/inet_dscp.h>
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
+#include <net/nexthop.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -26,9 +27,10 @@ struct prestera_kern_fib_cache {
 	} lpm_info; /* hold prepared lpm info */
 	/* Indicate if route is not overlapped by another table */
 	struct rhash_head ht_node; /* node of prestera_router */
-	struct fib_info *fi;
-	dscp_t kern_dscp;
-	u8 kern_type;
+	union {
+		struct fib_notifier_info info; /* point to any of 4/6 */
+		struct fib_entry_notifier_info fen4_info;
+	};
 	bool reachable;
 };
 
@@ -51,15 +53,41 @@ static u32 prestera_fix_tb_id(u32 tb_id)
 }
 
 static void
-prestera_util_fen_info2fib_cache_key(struct fib_entry_notifier_info *fen_info,
+prestera_util_fen_info2fib_cache_key(struct fib_notifier_info *info,
 				     struct prestera_kern_fib_cache_key *key)
 {
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
 	memset(key, 0, sizeof(*key));
+	key->addr.v = PRESTERA_IPV4;
 	key->addr.u.ipv4 = cpu_to_be32(fen_info->dst);
 	key->prefix_len = fen_info->dst_len;
 	key->kern_tb_id = fen_info->tb_id;
 }
 
+static unsigned char
+prestera_kern_fib_info_type(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return fen4_info->fi->fib_type;
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		/* TODO: ECMP in ipv6 is several routes.
+		 * Every route has single nh.
+		 */
+		return fen6_info->rt->fib6_type;
+	}
+
+	return RTN_UNSPEC;
+}
+
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_find(struct prestera_switch *sw,
 			     struct prestera_kern_fib_cache_key *key)
@@ -76,7 +104,7 @@ static void
 prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 				struct prestera_kern_fib_cache *fib_cache)
 {
-	fib_info_put(fib_cache->fi);
+	fib_info_put(fib_cache->fen4_info.fi);
 	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
 			       &fib_cache->ht_node,
 			       __prestera_kern_fib_cache_ht_params);
@@ -89,8 +117,10 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_create(struct prestera_switch *sw,
 			       struct prestera_kern_fib_cache_key *key,
-			       struct fib_info *fi, dscp_t dscp, u8 type)
+			       struct fib_notifier_info *info)
 {
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
 	struct prestera_kern_fib_cache *fib_cache;
 	int err;
 
@@ -99,10 +129,8 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 		goto err_kzalloc;
 
 	memcpy(&fib_cache->key, key, sizeof(*key));
-	fib_info_hold(fi);
-	fib_cache->fi = fi;
-	fib_cache->kern_dscp = dscp;
-	fib_cache->kern_type = type;
+	fib_info_hold(fen_info->fi);
+	memcpy(&fib_cache->fen4_info, fen_info, sizeof(*fen_info));
 
 	err = rhashtable_insert_fast(&sw->router->kern_fib_cache_ht,
 				     &fib_cache->ht_node,
@@ -113,7 +141,7 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	return fib_cache;
 
 err_ht_insert:
-	fib_info_put(fi);
+	fib_info_put(fen_info->fi);
 	kfree(fib_cache);
 err_kzalloc:
 	return NULL;
@@ -126,21 +154,25 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 {
 	struct fib_rt_info fri;
 
-	if (fc->key.addr.v != PRESTERA_IPV4)
+	switch (fc->key.addr.v) {
+	case PRESTERA_IPV4:
+		fri.fi = fc->fen4_info.fi;
+		fri.tb_id = fc->key.kern_tb_id;
+		fri.dst = fc->key.addr.u.ipv4;
+		fri.dst_len = fc->key.prefix_len;
+		fri.dscp = fc->fen4_info.dscp;
+		fri.type = fc->fen4_info.type;
+		/* flags begin */
+		fri.offload = offload;
+		fri.trap = trap;
+		fri.offload_failed = fail;
+		/* flags end */
+		fib_alias_hw_flags_set(&init_net, &fri);
 		return;
-
-	fri.fi = fc->fi;
-	fri.tb_id = fc->key.kern_tb_id;
-	fri.dst = fc->key.addr.u.ipv4;
-	fri.dst_len = fc->key.prefix_len;
-	fri.dscp = fc->kern_dscp;
-	fri.type = fc->kern_type;
-	/* flags begin */
-	fri.offload = offload;
-	fri.trap = trap;
-	fri.offload_failed = fail;
-	/* flags end */
-	fib_alias_hw_flags_set(&init_net, &fri);
+	case PRESTERA_IPV6:
+		/* TODO */
+		return;
+	}
 }
 
 static int
@@ -149,7 +181,7 @@ __prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
 {
 	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
 
-	switch (fc->fi->fib_type) {
+	switch (prestera_kern_fib_info_type(&fc->info)) {
 	case RTN_UNICAST:
 		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
 		break;
@@ -220,6 +252,8 @@ static int __prestera_k_arb_fc_apply(struct prestera_switch *sw,
 	}
 
 	switch (fc->lpm_info.fib_type) {
+	case PRESTERA_FIB_TYPE_UC_NH:
+		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
 						     false, fc->reachable);
@@ -274,14 +308,14 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 static int
 prestera_k_arb_fib_evt(struct prestera_switch *sw,
 		       bool replace, /* replace or del */
-		       struct fib_entry_notifier_info *fen_info)
+		       struct fib_notifier_info *info)
 {
 	struct prestera_kern_fib_cache *tfib_cache, *bfib_cache; /* top/btm */
 	struct prestera_kern_fib_cache_key fc_key;
 	struct prestera_kern_fib_cache *fib_cache;
 	int err;
 
-	prestera_util_fen_info2fib_cache_key(fen_info, &fc_key);
+	prestera_util_fen_info2fib_cache_key(info, &fc_key);
 	fib_cache = prestera_kern_fib_cache_find(sw, &fc_key);
 	if (fib_cache) {
 		fib_cache->reachable = false;
@@ -304,10 +338,7 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	}
 
 	if (replace) {
-		fib_cache = prestera_kern_fib_cache_create(sw, &fc_key,
-							   fen_info->fi,
-							   fen_info->dscp,
-							   fen_info->type);
+		fib_cache = prestera_kern_fib_cache_create(sw, &fc_key, info);
 		if (!fib_cache) {
 			dev_err(sw->dev->dev, "fib_cache == NULL");
 			return -ENOENT;
@@ -512,13 +543,15 @@ static void __prestera_router_fib_event_work(struct work_struct *work)
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = prestera_k_arb_fib_evt(sw, true, &fib_work->fen_info);
+		err = prestera_k_arb_fib_evt(sw, true,
+					     &fib_work->fen_info.info);
 		if (err)
 			goto err_out;
 
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		err = prestera_k_arb_fib_evt(sw, false, &fib_work->fen_info);
+		err = prestera_k_arb_fib_evt(sw, false,
+					     &fib_work->fen_info.info);
 		if (err)
 			goto err_out;
 
-- 
2.17.1

