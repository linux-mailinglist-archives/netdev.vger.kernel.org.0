Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73795BBF9F
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiIRTs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiIRTsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:48:09 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2130.outbound.protection.outlook.com [40.107.21.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410CE18352;
        Sun, 18 Sep 2022 12:47:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZG3VHiTC/lyB5LQ+w96hBxzxN0j88eQ7mLF/v1x6y/rkkaxEzqx7+CPTf5gtVYYj0Vatj2SWMARhaxa1vo1NHpEomdLOcqSyLkK0as0HsTWKCw9nvy8ooGW+U5qMdsnaoY6WKjyBe4VoqWOpe1VHSOuROQchzxs1XOygMSrZNbAlvdHUJ9A45mPmfThP7PdHuRnjfW0h+UMLybN1qpW2FnrZH9yqK/BpbusKlW5y1KBg28ocxAQk8+v5zpghc6BoRi3wG9I6lRv/cCwBWnvaJl2D8bjFjYGP3dBDkQkSqJeIGmFc/XOxs4iHlbZAy+1TTJC567I7C2roohTyzMgGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bu91UWEoOWEY7ZljUddNpMmbtG6YQai0PFAnZtOL0HE=;
 b=hTCnO2sT2X23zoR4Qm6HOjFHLbEI8mtWs7d9tIZJhOxmt3L49SHj76hY3hBCb7pnO8f78YNLHO6bOvSAuBwMOZvC93AVZGcwXdJvQyexC//p+nowXaXrQ5tcrl0WPwD7QHD4BgnUtG4J1pfk3/W6a/rNMD2w52h82FFLnZSA4JKZ+3Rl3EeNitZ4Lp05cYK8ZBiSbvLXxLfiCQQvZrB0iZd0WChBPmdxkrfBFNW+//4/NomwCJ10TTXpxNSucpbbkDzaGdng7qeMBpP3WTL0rjtaEr4DKy5f2+gcoTgcJ2KbN0OoLV33X7wLVZUMA12umVJq8mfMFv9t1JneiBIdgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu91UWEoOWEY7ZljUddNpMmbtG6YQai0PFAnZtOL0HE=;
 b=Gz7lXCmvouEVqQ6jss9U535Y6IvsSe+Cb5lhCUAGIglWALPLvr/sn+rwZqDRR1+8CCCKQ++7FvgFxlUfq2WcWYElYlAPr+sTTAo5tgqMjrQKfEu+lwB4LWwBX01OHdsHZxBxiFx3gfmlvtvuoZXRBhr/PN4yMlnP1erWuWX5IZ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by DB9P190MB1817.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:33d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Sun, 18 Sep
 2022 19:47:24 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:23 +0000
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
Subject: [PATCH net-next v6 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Sun, 18 Sep 2022 22:46:57 +0300
Message-Id: <20220918194700.19905-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|DB9P190MB1817:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f866826-1980-45ec-a234-08da99ae9b66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7IOI41bjpYHxVSl2XR3AwzMN0zz0lUf9KAf3xx4AzEx3F4hSvrdOn72S8ybOYOupcA0tT/EsbL38j+kPg/oZSgVyhUCnPCjL9bRpgxKC4O1lSGUz8jYE5xw6GNZKaPrlZCLBzAt5tOYEokOnfI/CbcWo6AlqPgQ9ckp2AEwRnz9Ars/MGBSTzX3Ss7vBTYSyxV2AJCiTVRT4lhgEmYWh44aJy69duFnGyio4WfjZeNGgiPvzjaMWKLRSBW0aDi/NyZg7L7Y0pfKDJjtw49oy2uviV341ETZi+gRVs13n6CdViw0txjRDGBWoQNCJ4nK9Y8RgHxk5RbTDiq5WSEF72hJug9OWBiMvD8/Obkvan7FfDKN/M+f/pUxSKYpdTW7i0v0xm2ERdjrpnC5bqg9g35pr4xpMcZZGfULxIR9EYBz+gzZv1mAosxxmpJY2TqYodP3Niw1EIJrFFvFRgBPtImKDhuCPGtommyd1anI5+dvFn5q8csXkdyqjMLhFvjDdWuw+0aRMlSNXZHOa5ayVNQHBJ5INHCoI06lOhwYxHlA7JHUxV9IH88xzdbf3Kepn4oMRHzmdGLzuG6Zj+SejYFAwPjqhy8s6r2TheIWDYCD9Zw7N0539se6m5vx85ghbnAog2/oCcUs+MzjMnyG2orrYPpeTYiQI1XVQcQXgz/SVtO4LOlNWckuSbLxxZ7sqMZfB8L3njXsVXnF9hdqDYlwmND+bKhiDXteCxgXBaXJAYxaU5GUV1Lx4dhP9k96
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(136003)(39830400003)(451199015)(36756003)(6506007)(26005)(52116002)(478600001)(41300700001)(54906003)(6916009)(316002)(6486002)(107886003)(38350700002)(38100700002)(6512007)(186003)(1076003)(66574015)(6666004)(86362001)(83380400001)(2616005)(8676002)(66476007)(66556008)(66946007)(5660300002)(2906002)(7416002)(8936002)(4326008)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RAAd8TN9aUU56pRpWPRTfljeIzO3CtNtXYF+gBuOYocph9NQpbmisqMInSF+?=
 =?us-ascii?Q?1U4wVPZuNbcRLGTBYMcPBPrDrb4ltRnKYXfeKqM0joN3o78NH/GxbNOB3aBg?=
 =?us-ascii?Q?jaBfsBPoQlp+ZSTKFx0SdiBui0BRL8/PsjzvjmYoRdF0Ae8yOrwlQ41oZLkC?=
 =?us-ascii?Q?ph76YMqT18+OFEp1zIvQ7WxS32vK6CzmAWjRwryVwQdKJFkKE1QuAgSsgQRj?=
 =?us-ascii?Q?GNd5orlzeA1NN/zL6jlge8neECxcyv2vsI8ets4lYILo3RChV/kTxkFIK3Nw?=
 =?us-ascii?Q?vJTNCkgtm3O2iWoSuABOqmiRDN12J/rkuisn6IZX3uRDiavYNyvpLU5xRBLK?=
 =?us-ascii?Q?cfc9mXuDzgJDkcRxWsHqOvAjXwQ7hnZEet946zdiyUK+Fo4wdY3eJCHZzCkp?=
 =?us-ascii?Q?/K4Frw2v6zu8Y7NdXUyVTmB+aTvJIv/3d7AvIByOliYdktvbNt4W8xkxkLIj?=
 =?us-ascii?Q?LZdW6wcPSkh5emJqaHNASeYyPBYBttZMZAr3XpWGXedXZcDsvDvgKA/Vmp6v?=
 =?us-ascii?Q?56S05v0lSVBMKncb1uKfbCUZsWROFyucmV4vYkvpTK89wTQzxi2LMOfMCLui?=
 =?us-ascii?Q?qtMmVPqgFA6tighBfBVDfzkL9KTuNAUFCmFR2o/ksl/1KhwQKXziXwHjzofJ?=
 =?us-ascii?Q?akjyYK9aPZ0SgfBDJAnC8+z7c58MmNJyjZK6UDiG9nEjJb/qWG2xptkU9+qO?=
 =?us-ascii?Q?8UhV5T/AGKANvmif3MCwlplwXJcJtJ6LUG1ORlUHrnkB+bXWkaclrntD7JJV?=
 =?us-ascii?Q?1cBDsA5lBQJgvzKoa0Oivsz3yvGXI1vZCY75fsKYSnbVDVVP+RGsM2Dcr5Tk?=
 =?us-ascii?Q?+Wkk9kT9oBjQPG2+zMs3HJw0RwaRQ1eAX89zpQQbnif6ZohGcv6suEpye8Vr?=
 =?us-ascii?Q?Ff9E2+cgqPM5JsxEjEZTTJjwf5RnByrPrED9fxp5i/ABqe/YXNv3WOdO50IV?=
 =?us-ascii?Q?RNO0pBDGNlhgwwAHQeNGlp5yiyo7tVXev7eMnaXg94wandSFUldfqrjI5RCs?=
 =?us-ascii?Q?oioqyfHjV4cdJJyfFwLFKOkOEtFFJWlRKKhKHRoM4lGS/wBahl/D8Y7RmObz?=
 =?us-ascii?Q?mComjc+gtLmzmDnHkkOK6nZezAcBL5Ru+uW9sG8+G75ZOkU14dUUvRzru1bR?=
 =?us-ascii?Q?Gv4x74pBQvSOG46hlL7gZCNLitPQ9giBjdzg4pQHbVCyQooLjeYXeZgT5Sks?=
 =?us-ascii?Q?ygre8F/pfXaD6TaMWoOxsiGFeUwv2Eh0r4MwAO5hQPpIoHgDDUSicQ9cpldd?=
 =?us-ascii?Q?3WHwloxRNM/atDLmF8iRw4et+E7BnOQ9wx2ts8MJZ24HYmMujTUD1i2Vl7pw?=
 =?us-ascii?Q?ABFapCT1AZBD5E1y00ZbICmDpKylP0xnlut+Q6kGvtZiKhmT4ckShApSmwYy?=
 =?us-ascii?Q?I4DTflQVsIFkNLvnsDfA+R6aO01Dk2oWDCCcZjmfSOxDzlFncJL+e8CgpzcF?=
 =?us-ascii?Q?8ITXCwyrMpUfiqpxOxzxs3ofAx58MHyhcISN799Unh8KFFD/fngb6/nYYOOw?=
 =?us-ascii?Q?1cSeWzjKOZiVI+aoVLJtkn8SKmlWnVpAlZ021mPiz6H61J6qzRKSDLLEgwcG?=
 =?us-ascii?Q?FxQS360/kVtJHFNAV0Mb2Tx61bYkgfg3NazGV6nrK0yjnXU+C9XnDSrGuFrF?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f866826-1980-45ec-a234-08da99ae9b66
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:23.8307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71HY5P3h9N3aOWwzaV2V0HQA3jx/Hk7EyaWy2TzmWyq5FfiOHFYEuES4Vz2mjfTWM8aaQIV1my3EV/ilLDx9jJGmYpUKowLtbHnrvbeeoec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../marvell/prestera/prestera_router.c        | 99 ++++++++++++-------
 1 file changed, 65 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index c8ef32f9171b..15958f83107e 100644
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
@@ -276,14 +308,14 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
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
@@ -306,10 +338,7 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
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
@@ -514,13 +543,15 @@ static void __prestera_router_fib_event_work(struct work_struct *work)
 
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

