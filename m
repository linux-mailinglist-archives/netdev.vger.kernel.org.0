Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E055F1B6C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJAJfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiJAJfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:35:24 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60127.outbound.protection.outlook.com [40.107.6.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1761C42C;
        Sat,  1 Oct 2022 02:34:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dggv8KjYmSPqRrRYqVw1xQRbQk7QRFymLo21P5qN/jPdubh8RphElEL0nI/FK/1u2REQ+mvDWu/4Tz2W9gN1pgFwBkRQjc2XpN8iuZ5qhDaZ1jipbPSCCrVSB9dIkvbLu3WKziZjl28n+iGIFIDMVGHmvv4phzcx5Dd55TaCpTTKfVFjThUjpvcq8TkqpUksCEgLYvpUXgK1lbgQ4fszR+D8O+nOZYmXor/TBw1kc0xGo6gbXvVNK1WGpuLgdTvdUWJAUbbZaJdbwCUbzICYTuu+DVrlSl4kMbzQdXotpzWl8dPVUlXZCr8bWLLsTeSjOFb6i7wssnoTcJNwDjDtSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmvIq7MdXDMigNAEY/ETlxAIB8JkFOYx0HuO4ZP5hoM=;
 b=GS1zqXVsY2XrX5gIWVAEk3xnOWYco6HIoBKOtPsDZvXJFsT6CVQzxt2lQSjlEEjA0GvGP6KtdUCri4n4mjwyw/QRoxh8CilredxOIRCV4apfnCIkBpnT28FJWttihz0FHG+xLEkT9AiSoUyFXDdJAGZC0AatinRweg8a+xhdFOggZK1qUckOKU58ZUrfAFowTNZeSg/Q+jPSagY+1OPr/vEmNcR4NiHlGiukwKfiTFIUAF1FZ6ShtLXpGje2qFfO+qRuYI5XVM8JJLkkkAW2IvScW76Os1HFimEo9R1FFfMlavl54wTupUPZ0aylEh5opK2HJLxT8Q17UbY6uT4P2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmvIq7MdXDMigNAEY/ETlxAIB8JkFOYx0HuO4ZP5hoM=;
 b=m+DFALT38XbcLRS+mxRSjFbGYdG5DZoiHeugeEEzPvx18A2cNX8rw9NMrTHzm12HhUub0a1cqHn9edexWOzno0FIrYaaObNn0zKaddzUxiMZSFKEDkKABbh2P+LdUBd+H0X7TikjpaqNLGY60wtLN0SioaEX7P6H2Xn+Mtu42y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:34 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:34 +0000
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
Subject: [PATCH net-next v7 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Sat,  1 Oct 2022 12:34:14 +0300
Message-Id: <20221001093417.22388-7-yevhen.orlov@plvision.eu>
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
X-MS-Office365-Filtering-Correlation-Id: c088b6bf-ba3f-4f5e-8021-08daa3902693
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rvTg8ZmUpPiXXD6+Gz/GkrLL8up/RUoZkJlCjfq8F3/D7OlQBeCp8zti6zVz1MFAOeu1LdrXjqQFddOHe4DfYS5lNmkzfBgGEjFGJBwaNyuE9R06GwYk5mES1t8Cm0kl78eUsODTl7FecNbhTsQ9N3E9xKwmVY84wZSMayKA/HSXSpVc47IQWf3LMuM6jsdkir4ltAJRp2Wbw9FAThIcSy+a6B0ia6i1BT6+kQQwDJ2cvUS1lAxBCJ/PNPWXub4k9mvz4GXm2bpHI79H2cllaDhK4gHU/r6e3/fQA7VFx3BtHnS9T3LkaXB5r/gzinRELU5N3Ks2ocxJTfFNJaOG7UMR189a5efU0quRwf0DsUW6ybvTRXm0ecQN9Ly2vHk3YP88MuJe0lNckH3wTE93jaQkZTjiJGBRtUmmrKwaNR3yrkgXJlZrwmM2JpZwstXJNTugrU9aPC6suGDoWwXtLjZPVIUfpjVZMHuu7PUgJSV1JhFtsmZ9sukIp54MUoC7qWOLT/+4UohYWA077p/BW4nRUzGzJQ39/oSaw178pVCgrkVb4Vy/tLDWdHwlUwsC4FP5aR5tB9Ni71N+TRE8vLM4fc627bX6adjduL8yzkUW089+Zvr3KWbpRzztwHVE6WKN3n+wkCVXugHua2hJjPLUE2phjjnkUxgeweeYDNUtGeNphs5KG7SK7twSv+BCveAMZc9ZhD/d6piXxDKCHTl+dlRE7XLT75y2jy71qjumtzugYFf2E4aMBXkPSEW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(83380400001)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vI7kQ22WKR9BFB1+8M64DDxWUrEb/EDYw2cBiOZI0dsuXFO7JTBiswaQJUGX?=
 =?us-ascii?Q?j2ERifa9pL5E5S4QRSGwz6agJ9hiV0CxqTwEhxZS6GjOrAqSrLXaSBpE6tEm?=
 =?us-ascii?Q?CaFDEmYQCSYm0in7frE3YtgbhkeVw+ifeOVCbgX8sk6y3lwTNd3izFYid1c5?=
 =?us-ascii?Q?LwmJ9XyrOm3Oj2RcYsPpBsep16OS53XPfnPHk106XnBPsjnH2UuhAjrEEgm+?=
 =?us-ascii?Q?7MVVpgtpr4wRpcjyUgCYjl+b6DMD7HPPxcMUFvRqRTXEiCnxACMbsjFv7JG4?=
 =?us-ascii?Q?+DSsOATziE6Eg909seydUb/rTV1/6Zj6JWAKL3i+IsosVCILJmldI6zbGega?=
 =?us-ascii?Q?aGLaomPKDef4xecGJVwFUEzS7ndvued1TU9kD0v2uT3qjiCmeaJBNGhwcavi?=
 =?us-ascii?Q?O0+zd9RhZD6mOfnNXDbA7KR9wcfCh6vFohPIOGiXoZfPm6WeUwGU/Rt3GwVB?=
 =?us-ascii?Q?P9H9oucrrAcgBC9wMoWXuioUX4fmCAn3Zc0BMeXKtT8yaIOurOdmlrZtnJQ2?=
 =?us-ascii?Q?qZlVv6kRk8bcdUQQh4ZKJnUGIT1sXGBkUcgeZetH/HKHZ3n8aBkLvF+/IwCo?=
 =?us-ascii?Q?DkKAZEVHg7Y4vxurR69CFOfFht+CmETC3oqMs7SPHo397ZADuL2hiHbgatiQ?=
 =?us-ascii?Q?6xOuhUeA7EY1EGIQrZ2O5Z7FT7mG+OmFF3+V04KHn3V6DwuicjFoCHVbDDEJ?=
 =?us-ascii?Q?wFHOw/kf20k0QjyZ77cw1Ur8X6KqN8ieCjC2j3Pfm8SZYcP42LdDF1pb4f5P?=
 =?us-ascii?Q?iV5405okIOeX5Cg3ULfF1NbWCeArX6i6HvnFggx6t47LT61l0AVHAWVs82nI?=
 =?us-ascii?Q?VRQQvMR2KkFzHj/TFl5tRslfGnWTrlE/gz87QT+rQwzQy97cl2mFWTmoCCyX?=
 =?us-ascii?Q?reY9otl5XlIrEsrfivBbF+zUr5of/IV4v9BUr4Fi/nrSJ1k07FB4JgdgYE0z?=
 =?us-ascii?Q?smwcnliSTlpx33aIhURU2tmY1eFz7iE7RZmwHFR339GPaZzsUlcFOdYRDCg9?=
 =?us-ascii?Q?m6UhlZhBJOxJ6mEmyX+WB/5ygJnbcax3pbROJ+TG9knVl9WxMRDCv5hXOPFB?=
 =?us-ascii?Q?Lgd/FSXyqmLJA/48F302ahGklXf4BfSgwIkY9zabVIUtHlKnjRZXUhom1QeB?=
 =?us-ascii?Q?Vo4qEI0KtDyG0aJ//leMcm7MsJMVJG19N/i3v9SttnOnMMqRy644fznDx8SY?=
 =?us-ascii?Q?SFQjHzelE+2SRxS/H5NfEezNzE4aoO6s0wncVDdV/qFdWt859UGaTzfC8UIg?=
 =?us-ascii?Q?nGkcq3TqylObVrZzUwzBBRw1rNoFsb8oizebVmP8l3TPMLW/NLhKXjdgTlrg?=
 =?us-ascii?Q?NxGiBGsIy9pvJI3eP+aNi2YYB30PK4wx30ybVvcOoLerFlC1apApv4/4k2N7?=
 =?us-ascii?Q?GhfKgDq5FnzDrSpJcP5H4H5uigBvkkiwfsyQRRLvj3f32MFNV5hDPJ3gq4lV?=
 =?us-ascii?Q?lv/PvSWNuVDPzmpK8CaRgSjRDZnF+THLZ56qZfSATU6C8KtjwpotoJCIK/Zj?=
 =?us-ascii?Q?lrwKAQD83Zj2QxYF6UKNlP2WBJq4Tv4bdOLsjGZhCKq6xcuuYpP3DGTt5eHg?=
 =?us-ascii?Q?uDW0mcaYVJY3QKm6QE8iAdWDxLD90rG7VO0x5TBDQ4xcJUadMCrUC1Bq2zqm?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c088b6bf-ba3f-4f5e-8021-08daa3902693
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:34.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRLN/hFSRdJeXTw+KF1c2taKQ4uB8Ja+KkTyu1Rse9pd5ZIKpwv1udwoo+iLWX/Eq2ZW6lcajhhe8IuspWi9QHPv1f6J4DmfNUg56a5blpc=
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
index 9625c5870847..607efd481782 100644
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
 __prestera_kern_fib_cache_destruct(struct prestera_switch *sw,
 				   struct prestera_kern_fib_cache *fib_cache)
 {
-	fib_info_put(fib_cache->fi);
+	fib_info_put(fib_cache->fen4_info.fi);
 }
 
 static void
@@ -96,8 +124,10 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
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
 
@@ -106,10 +136,8 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
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
@@ -120,7 +148,7 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	return fib_cache;
 
 err_ht_insert:
-	fib_info_put(fi);
+	fib_info_put(fen_info->fi);
 	kfree(fib_cache);
 err_kzalloc:
 	return NULL;
@@ -133,21 +161,25 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
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
@@ -156,7 +188,7 @@ __prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
 {
 	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
 
-	switch (fc->fi->fib_type) {
+	switch (prestera_kern_fib_info_type(&fc->info)) {
 	case RTN_UNICAST:
 		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
 		break;
@@ -283,14 +315,14 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
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
@@ -313,10 +345,7 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
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
@@ -508,13 +537,15 @@ static void __prestera_router_fib_event_work(struct work_struct *work)
 
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

