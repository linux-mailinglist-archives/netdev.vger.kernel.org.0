Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A516B56D078
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiGJRXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiGJRW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:22:58 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60092.outbound.protection.outlook.com [40.107.6.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79E513F65;
        Sun, 10 Jul 2022 10:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzkVCNQIsRNAGbp9i9/hQBswRIKiuRHqkN26yKQV6puMnuRRCZ6HCpcnCF6XOufhCuA5jyZnnlSuq5X1XkMxWvpx+OeDZcWLAv2ChO3aq2SNPhuYlFkksW354GV8n6EFjXDgM8uGe+ZSg1JedugZ39HlrnD9iHmgYF6Hq/iydRT8H0vPh3/RZ+y6G+Ozhb0JiGfEyJLbBlXif32YtZ94hK7iXYYvP53WK4iptOljfYwca44PDadbQWDpQKRxgYLY6zbJJl70shG58Z/pHVKf8kDU8Mn5q8awBsCuBcridpYhDc8rG9tTJjwPT/YVUX6MT0BZpBLxYjEkneUcJ5XWMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGr7SDGKr/P0WlJSCEj8tQmOuc3rKS2v+pl6WNttY1I=;
 b=BZ08gkkutU07ZCgy2l4qW8Lg5/54smMTXhC2Z/vUQN6nTrl5gTNaLG5gdiMLhCtEo+COfTJhrYh11xwEX3L89omu9IOJ/WFAzfEAdugG35IS5TGEh/rRxdnLzePDKB7RXm8U4h/yry9PvbG0XJUB6lTeX+OV8kLb7ZtjMzJpVtO3ojh0vLHlh+Hyf4ER2VolrF/studuanqLqz1EFMe+CCFLcQrP0wjyopkEaqpL+QL6/QB5gO7ujv4mAhJPpmsrUnInxvSrzZsRelnh0tpt9Qh5e3ykAjS2/vXbBN7yb6ffVThEJvIaiVEpNkIosrVUTrdLRDvxm3lBjXhtg7ga7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGr7SDGKr/P0WlJSCEj8tQmOuc3rKS2v+pl6WNttY1I=;
 b=xXwBaP4OUiEVSWKsugXfkPnFbMk3or3K+s7iY/Fvpp4yS50R38rT4wjcEjt7kFVhxf3b3mp6ny0SZWw1J0nJH+iTPsvKbZmLkQ/Upg6crf4TUyXvYhRHv8Y383xheF/LJa+OKKuNpN2A7jNRDRVJH0H26YsAZmQrcfZwbdorMmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:43 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:43 +0000
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
Subject: [PATCH net-next 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Sun, 10 Jul 2022 20:22:04 +0300
Message-Id: <20220710172208.29851-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cddda54-16fc-4886-cb8f-08da6298cc9a
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJB3HP07LzWJnlVPsvx6QbZ30j7CUQCAT24yDsXgvxeEPX1TjLeBGzpg9QRC0sqLaid7ItrMn213fqFexTLD5GQPyuyvfy0V8BBKlOsuWUjjwHM617w35MSgdsVgKo9kQ+3EKdBickKOuWeBatC5KfffWTroWFVlZ1f4OxHQ7Fl32/YxM+lRFuobwRx4ARUX2Bhvqw+s0kAFQZtuzzvm8UJyazB3qZcHtXdS59GRLtEqTJuEbcRBUd/MiLAVPMczQs9jrq4pKbxHB/vju2WiEfnxC8xtYmXrMq0wAa4sqmBXO0wJXFJTXbiTsq+mV2aUW4dC72fI53lRtiaIiXGfKeBvKN9pSCzyeOHnEx7YZ0TaDQaj1OCGG54yeKU7KyniJju+hwdVh56aHzs3KtPrESFVUz4EgZG4uuuBO3144jDdhxklqxbD42IGhEKa6bddWuVVK5JIWRaRvaZKLAP8KXeKkna5bZfwkQnwVL10aeUZ9K01ILjsWue3qTaiiX5YGRp9B8zmD7WsgoaeRSfymyB5W5jPP0TXW57uPZWTVfT5+k6nsCR55uUsHRyJLypSFI2s5vLr1NjxPANqq+v7ZkQam8jrJoVlE32nLjztypDCOHBLrHdxInOx0gL0pNNgnSl62foSxqpe7QpgiTuxoqLpp9gYWD4zSFle3X1PiRtm4XIx/bUGsYxW0vi3LnLv0IEsyx2Vob82rjCpwu4CaHXbSKjvJQGdBNm8sVlueJRkgmKf92yCoBXmrKBar9vAxxSO9gWE54QnNFVuA4yGzz9mKoRkVob6NVQRwrWksIecqdGqWgHIFKeGmIZIzwW0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(30864003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YPsTFQo7t04sprGBghDqUsYvED2kAG8Ir9pilFc1Ou+IXWTvBh0fzfx8TndA?=
 =?us-ascii?Q?zAfx0NDUIzPBtHpjJgaX4Sj9l+UeG4ETkBB1kPC5jqT6/659F3A5A7/FkfQS?=
 =?us-ascii?Q?84dQx7mHJqE5us3JJL4xMeJ+UglL5nBUl/qc9FjnV1UhpZ2qhZJU0WSDIU0R?=
 =?us-ascii?Q?83lAtGlAswcYNshxoK6vi/MlMC6022jzvaB3D+Fx68FG1q9WqH2EUzNWIb/j?=
 =?us-ascii?Q?zbV3lBtzyIUo3xDdgRSvMQgYt6tG+Nvq+GPlA2Vx26GN/RfHyI/ao2RoS/Nb?=
 =?us-ascii?Q?LUiP8sPTrrGlRCBJ0DD8MhUbR9N4Q52Cjz39yM5hgWXD9ivyR0urQDAw+la1?=
 =?us-ascii?Q?D6TTmZOBDa/q5q5TfHvO/sNdcjFYynD2wpPRCL8t5rrE7Dx+EKY3vykUNmJC?=
 =?us-ascii?Q?7kUFJArZxQgNja2yfbaK7V8/q5UpTjuCuwL94EX1kjI1FJGoOtXqu08fhXxj?=
 =?us-ascii?Q?uhcXAWLZFVd9V0IXcG4oLhWJbiDqZdZmZiux5i0t4SmxWNoQ2MD2xsg+CIH/?=
 =?us-ascii?Q?DbGxWBpdOBGmZwvr8aI2X5x804mpIJoE2hHpPJ5iV1Bwfclik72FcC1pOE0P?=
 =?us-ascii?Q?uE8HF3mu8FhGSV/Z40jx+B7m2UdCTiGZZuAfU8iiNBclnKuU7a7HAwjDRDHt?=
 =?us-ascii?Q?lg9TrZGY0NiUA4nNUAwvpbe7vO09aLsAmrN1MRk+Ggk+mIyBmZYFSRvVOlwL?=
 =?us-ascii?Q?xLujVbsjRkY771cg2qUJB5g8OC3c3eZxGeM1YHXiGHfjoBPQ3CmmrHA0ed2m?=
 =?us-ascii?Q?9xsSF2xQj/wkaImnTMGfMnElefBAwLZQ1ZJTGtZ6jfrYFXh5tuU9rQlDCJne?=
 =?us-ascii?Q?ZR75A6lhhLbhjmG81phrEAV6muQdPC7rwdA7m5y5XBkyI55n4uhJw/NsnMuR?=
 =?us-ascii?Q?o4Nz/FQ3j/EiLtVc0GOVQ+0L7HeHI2Dhl/Q+WdhEmAVABs6c7VXdzbw6ETGO?=
 =?us-ascii?Q?4Jot2O+jHvNb5/IPDVHzKS/rNUsKgSrPqxIJO7gLJKY1WAMEM3KpAsoOrzGH?=
 =?us-ascii?Q?oVCKr3TE+KCZfJnUYI/Lzre5sdApOQYsKItf0WlFhajxv7u5w0iMDhM7glhs?=
 =?us-ascii?Q?Bwa5hcbjKhsqIK5aIIQuMJ5GRV8MABDm/fUmv6u6PqR62DvRgq+wlodA0Yge?=
 =?us-ascii?Q?dC2kLWe+Am6xpHWce3f2Xjj/8GJz9UwsprmkKS1qoZbEnCkRoUvzOMnvWVCX?=
 =?us-ascii?Q?vPjipArTqWAN6f3G8O7eQMnEB56V5lzpHkYnwbIVZANHkAlC2W7lYyk3hFD5?=
 =?us-ascii?Q?utLF0ijMxD9xaR2PaBy/9BF7XsvY5063VlxmLsvQMRVp+iREmMZh71m6ajlr?=
 =?us-ascii?Q?oZbXLRi7QkecfDhw+5pdAmkuT285cvPB9WGpOEXPSqETvUBpVId30nEmKnOK?=
 =?us-ascii?Q?yopxc6q8NWhdRixm70thx1xTEzvFXFMn8qUDsEQXIZvjqlY5gQWkeROnb2HL?=
 =?us-ascii?Q?NhYD7MCca5nzmG74hPsS3CqGqFkyKKBbJBdPmfsY1S4DQ7gJDdJ/Q+lfmbHi?=
 =?us-ascii?Q?VImoxEl3X8c56EA6XH0KpxV9e3xf5UrtfNN6Ln/s3Fu0VmTfZv1ZgTisP6rr?=
 =?us-ascii?Q?b77OjCvHCQfSsAHk3AM8WUKBsAthk2D5P2BhS7lC87eck9Ix3kiMZ9Fy9Fcy?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cddda54-16fc-4886-cb8f-08da6298cc9a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:43.5000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/j+pUKW6o++ADpAwBNNSpkYniuMd82jAYpN27Dsr5p+uXX3NXgE8IY4b62X9E+vs22NY6tnOTmzEqcnpxHvlk/27SkBjQdBA/iJ3ZhEkTw=
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

This will be used to implement nexthops related logic in next patches.
Also try to keep ipv4/6 abstraction to be able to reuse helpers for ipv6
in the future.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 311 ++++++++++++++++--
 1 file changed, 277 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index db327ab4a072..0150aa33c958 100644
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
 
@@ -51,15 +53,253 @@ static u32 prestera_fix_tb_id(u32 tb_id)
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
 
+static bool __prestera_fi_is_direct(struct fib_info *fi)
+{
+	struct fib_nh *fib_nh;
+
+	if (fib_info_num_path(fi) == 1) {
+		fib_nh = fib_info_nh(fi, 0);
+		if (fib_nh->fib_nh_scope == RT_SCOPE_HOST)
+			return true;
+	}
+
+	return false;
+}
+
+static bool prestera_fi_is_direct(struct fib_info *fi)
+{
+	if (fi->fib_type != RTN_UNICAST)
+		return false;
+
+	return __prestera_fi_is_direct(fi);
+}
+
+static bool prestera_fi_is_nh(struct fib_info *fi)
+{
+	if (fi->fib_type != RTN_UNICAST)
+		return false;
+
+	return !__prestera_fi_is_direct(fi);
+}
+
+static bool __prestera_fi6_is_direct(struct fib6_info *fi)
+{
+	if (!fi->fib6_nh->nh_common.nhc_gw_family)
+		return true;
+
+	return false;
+}
+
+static bool prestera_fi6_is_direct(struct fib6_info *fi)
+{
+	if (fi->fib6_type != RTN_UNICAST)
+		return false;
+
+	return __prestera_fi6_is_direct(fi);
+}
+
+static bool prestera_fi6_is_nh(struct fib6_info *fi)
+{
+	if (fi->fib6_type != RTN_UNICAST)
+		return false;
+
+	return !__prestera_fi6_is_direct(fi);
+}
+
+static bool prestera_fib_info_is_direct(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		return prestera_fi_is_direct(fen_info->fi);
+	else
+		return prestera_fi6_is_direct(fen6_info->rt);
+}
+
+static bool prestera_fib_info_is_nh(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		return prestera_fi_is_nh(fen_info->fi);
+	else
+		return prestera_fi6_is_nh(fen6_info->rt);
+}
+
+/* must be called with rcu_read_lock() */
+static int prestera_util_kern_get_route(struct fib_result *res, u32 tb_id,
+					__be32 *addr)
+{
+	struct fib_table *tb;
+	struct flowi4 fl4;
+	int ret;
+
+	/* TODO: walkthrough appropriate tables in kernel
+	 * to know if the same prefix exists in several tables
+	 */
+	tb = fib_new_table(&init_net, tb_id);
+	if (!tb)
+		return -ENOENT;
+
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.daddr = *addr;
+	ret = fib_table_lookup(tb, &fl4, res, FIB_LOOKUP_NOREF);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static bool
+__prestera_util_kern_n_is_reachable_v4(u32 tb_id, __be32 *addr,
+				       struct net_device *dev)
+{
+	struct fib_nh *fib_nh;
+	struct fib_result res;
+	bool reachable;
+
+	reachable = false;
+
+	if (!prestera_util_kern_get_route(&res, tb_id, addr))
+		if (prestera_fi_is_direct(res.fi)) {
+			fib_nh = fib_info_nh(res.fi, 0);
+			if (dev == fib_nh->fib_nh_dev)
+				reachable = true;
+		}
+
+	return reachable;
+}
+
+/* Check if neigh route is reachable */
+static bool
+prestera_util_kern_n_is_reachable(u32 tb_id,
+				  struct prestera_ip_addr *addr,
+				  struct net_device *dev)
+{
+	if (addr->v == PRESTERA_IPV4)
+		return __prestera_util_kern_n_is_reachable_v4(tb_id,
+							      &addr->u.ipv4,
+							      dev);
+	else
+		return false;
+}
+
+static void prestera_util_kern_set_neigh_offload(struct neighbour *n,
+						 bool offloaded)
+{
+	if (offloaded)
+		n->flags |= NTF_OFFLOADED;
+	else
+		n->flags &= ~NTF_OFFLOADED;
+}
+
+static void
+prestera_util_kern_set_nh_offload(struct fib_nh_common *nhc, bool offloaded, bool trap)
+{
+		if (offloaded)
+			nhc->nhc_flags |= RTNH_F_OFFLOAD;
+		else
+			nhc->nhc_flags &= ~RTNH_F_OFFLOAD;
+
+		if (trap)
+			nhc->nhc_flags |= RTNH_F_TRAP;
+		else
+			nhc->nhc_flags &= ~RTNH_F_TRAP;
+}
+
+static struct fib_nh_common *
+prestera_kern_fib_info_nhc(struct fib_notifier_info *info, int n)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+	struct fib6_info *iter;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return &fib_info_nh(fen4_info->fi, n)->nh_common;
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		if (!n)
+			return &fen6_info->rt->fib6_nh->nh_common;
+
+		list_for_each_entry(iter, &fen6_info->rt->fib6_siblings,
+				    fib6_siblings) {
+			if (!--n)
+				return &iter->fib6_nh->nh_common;
+		}
+	}
+
+	/* if family is incorrect - than upper functions has BUG */
+	/* if doesn't find requested index - there is alsi bug, because
+	 * valid index must be produced by nhs, which checks list length
+	 */
+	WARN(1, "Invalid parameters passed to %s n=%d i=%p",
+	     __func__, n, info);
+	return NULL;
+}
+
+static int prestera_kern_fib_info_nhs(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return fib_info_num_path(fen4_info->fi);
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		return fen6_info->rt->fib6_nh ?
+			(fen6_info->rt->fib6_nsiblings + 1) : 0;
+	}
+
+	return 0;
+}
+
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
@@ -76,7 +316,7 @@ static void
 prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 				struct prestera_kern_fib_cache *fib_cache)
 {
-	fib_info_put(fib_cache->fi);
+	fib_info_put(fib_cache->fen4_info.fi);
 	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
 			       &fib_cache->ht_node,
 			       __prestera_kern_fib_cache_ht_params);
@@ -89,8 +329,10 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
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
 
@@ -99,10 +341,8 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
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
@@ -113,7 +353,7 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	return fib_cache;
 
 err_ht_insert:
-	fib_info_put(fi);
+	fib_info_put(fen_info->fi);
 	kfree(fib_cache);
 err_kzalloc:
 	return NULL;
@@ -126,21 +366,25 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
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
@@ -149,7 +393,7 @@ __prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
 {
 	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
 
-	switch (fc->fi->fib_type) {
+	switch (prestera_kern_fib_info_type(&fc->info)) {
 	case RTN_UNICAST:
 		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
 		break;
@@ -274,14 +518,14 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
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
@@ -304,10 +548,7 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
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
@@ -512,13 +753,15 @@ static void __prestera_router_fib_event_work(struct work_struct *work)
 
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

