Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE55A1A3B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243776AbiHYUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243610AbiHYUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A8C0B43;
        Thu, 25 Aug 2022 13:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+qncO6Wh1jzyaR9hiq/1kNJ1eg8CtXTxNVvQsm5ImuC8YSNWB+GtjjlF66rIPjcShxbIcmJLJ1X4H2fwrKUmWMadBDKbLw4xA0Tk1MS/QAm4WElgKzdFoNpWqJS0JJYkP0VIYQkuxQlTkD7AyeNtIKepflFbnIsdvNIZenkGs4zb0TEy9Z/jXmlIEZt1EytADWkiq10v7v3804BrpcWgjDHLYzajCZUTg0XAnunXS4k9NL0GgbTDg/gBhsRMRVJobh+98BkJyyODP4bhdRG2jUaWBiDSxwGc5qaJxWkgk/J+hzltctN2CP99lCSYQo/MTqKHAi6qBuDndEWHYyyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NmvnCLTIeG+clB+FL1TjZLVb25lI5qp74Z8mH0T0Mo=;
 b=I/rQU/YheYnNrUUtrtlp58BC4Oacs48eN5i1dMAqtxXg3X9ZtEnc2mBEUFyN6p0CGa+sgOm9W2ESkfjv6QpaJuPYvBIymYlL3uEJgsB8YhOk1Cryjuq+rucLgCzHyCcrQHi+C+3SJSX1AmrNDPTK2c+3zHxV/lmT8KN98m6Jk3WpSi6cpl9pdCfKP3o0I334AJFcrKpmP0lKkvs3W9IhDfb4obq2XvuhONlmZrZIUfonaHFNwKN2Rxho0wDNNxlpBDxjJw9ej7ivG7uovwa+CMTQz0EQE9Lrjm86g+rVqi/r+5qmPkTfSPtVYC6D5onFZCveeZFGfrp6DFa0nXRYmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NmvnCLTIeG+clB+FL1TjZLVb25lI5qp74Z8mH0T0Mo=;
 b=G7jYp5NEpkd+T5imiBwv+SmZxdcUKb4gK+gL2PKNDcrzrnNEnx38cBNSmbjJjVo1Gi/IHyjwYzIdE8VWPDcBFSyryLLLsmuJ/eRH8fE/HCYtfJOqdsLggMKscqNI4OWpUPuAqH/Zsr3RZaLTRg6Ly2v0vpej2nr6qJbQ/gmb3wY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:32 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:32 +0000
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
Subject: [PATCH net-next v4 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Thu, 25 Aug 2022 23:24:12 +0300
Message-Id: <20220825202415.16312-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adfc8568-3d2f-4e98-e59e-08da86d7d1c0
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkOVpKpcTnd8zU9RWpZoLIbbxerMyouW4JrotieoE/j5fhrogIdFCRTgzRKOcEmILen9z9QD8v3x+2s6NK54sGF2JzxhSraf246UQNTvE1t1ZqLfpRwmx19sHMQbipLzKXlj8iMVXnlrQMVheB18DS99XvCZq2nvZAu6+anfCL0OtE9b5E6IzacnRnyRZLGFXIEKC5YsGKv0QziZ3wCMMb48XcfSjvNF68RuqHBeh57/DHT4buU8X4Uihz1c+a+phvYtW+d1qcLkC0zTzW/CfXHGhtrZ11p2KSWbGSOSiMzOGKIoCa0Ugb3WMY69yRUpLkoum3x5xpKDj7T/OFKAzzxpZ7IPvTsxhzfnYX1MTp7Y7CmcMHrlUVDtV9QSAmwMdVwb0zBXJQ+4G6NCmQk5DtVyU6SZiN/4kNNBBokY6COJBOWqcvsdZ2TtqL7eWMbCBpWfGlczQms8cpg/hLZULJPFQOD/aGcSIrw2nAdzC6Oxt8UVSq3ZZi+4diDTaCyXjvE3KJg0xr+7WX+iKfmVY22BstDyZaTbsq3rYVZcLLU2aqJqb9G/+gYABHbZTxpDmOQzpP50SplNFVVqMgcSTlnAEoU7FQonw2ULTdqbuYpI/JtsSDdH9NX8/O0bH/ofe8xnpEc/bbe5MH32q3ChUOY3B/PLblTtuJh3QTVyQDT4OeuI5hbrMv7RraGw+W/nu3czBAR5j+dd0UqBDZ1L0iFTHeiR4l6gAhh2Tonlqz4KRa0BmU/luwmcXpCfdFVx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(83380400001)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PW6hdvJ9ittofFTI/MAdhrMi/XqJsDp9ZU6bLSmGJo9JjI7le8rJV0lT8gq2?=
 =?us-ascii?Q?dBrQsN0X9hAa8V242TCSf0fwbUOwPrnIhcledt8Xrn+ZjnsrI5ewMcO7HL0X?=
 =?us-ascii?Q?lqFbj33hOMpY44IhGxpH+w+QkxT2BH0Z495vKUo/X9DOhAf5uXDeN4tn6a3g?=
 =?us-ascii?Q?TrmDPd9Uh61mNV2kQNIStbUegbiOoFG1bPt8DAXpFs+56O30iFdulejQBK8h?=
 =?us-ascii?Q?8XWVrhgIjoX8/BFnwNPi/f1ugNdq5PUqlKAcqkAAlZCxt5BwXyVPvo917Khm?=
 =?us-ascii?Q?auUjH0ulnUFTyY13u4jubvRTtNOJQrH2zH4patbG1XWTUfx1isx7BA4/kHKu?=
 =?us-ascii?Q?p+7ZljF6yW5JW6I4TSD7s/V7qDIl9ti1bqOegFOspNKhHis+N/wcNtTomT0M?=
 =?us-ascii?Q?wn1z/KTauIG5P302ZdqjpIatamzRIT1HhZDsBsh9h3lo8nYnxlcQz5VSrx5z?=
 =?us-ascii?Q?/1fh5zZ+KHO9MiWQhREsNY6xjIsnXWHIk1tC3HbP1hoyGTLSY6OSj4Oh1a/E?=
 =?us-ascii?Q?CJcZoviDBlwJCey+VUIx5g98dE+KsZWkqiPuSxVVtX+LQkF8MzKlAPAqWMN+?=
 =?us-ascii?Q?pWyXF9y2oRXTVwzx1YJWiL6pMv8X1JPmaTNxEuYmaX3+Lhtddi3BqKUltx2z?=
 =?us-ascii?Q?X8dXFkmUWBDOMjaXHNlPLcyxxLg+7yKsPQQv7JBbh9fV2LsnBIhYy/fVoP0P?=
 =?us-ascii?Q?V52SJHjcCXWVM7fBotiSnF5/6Iw6O7voQrLFm70ht8yYgX4qtHM3O29IpfOd?=
 =?us-ascii?Q?XXaUfDzPzPn+SJ0PqQoIzs9dIYUz7FI7spHJo32/psf/lSzQxsS2FSPDPmHr?=
 =?us-ascii?Q?OKualIQulxh/y/JTXVNAoaMIxmr05Xx09RDS8BimLWOyg8j7ZERKRgN7Gza0?=
 =?us-ascii?Q?fqerrd6G5xYIGOjZpzaj6trQbrE7fN76dW7k3ERLtCGWEOSbmbkV5a4p9wFQ?=
 =?us-ascii?Q?Wm6JjP2q5Kap6WhrcewxC3FzfciNgxddCnyeQ0HQgFbsoy+O3eE4mIlq58hy?=
 =?us-ascii?Q?/+AYHUsp29KcQ1X5q9OW0QEVOYlb9dHyU4sl0B2ONNJ5m94wp9zKqsIHgQJB?=
 =?us-ascii?Q?zYs6WYOGEBpC8J03lcfiW/ZlteIAs1A4yqodZt06nZfxA0AI2HRd4xqdSy4G?=
 =?us-ascii?Q?EKIBOmcjWC/eAv0qQiEaf1gtAiLyhjNO+fOCvgXQjaKzSMc+7D1z1S5NcX7s?=
 =?us-ascii?Q?zq0G+5vEDanw0ZiTbhq3nzrSTemjHEMyFROyml4RT6H/p/V964wOV/+UTLf8?=
 =?us-ascii?Q?Fg5ftBU4da6QxjO4dyjCalMSYKLn8oJBOe/nQIWNM5CrlFr0eugPbueoVVhy?=
 =?us-ascii?Q?eH3Ft2EpeU7P/SwODF8YQchydYgIAreeY78se6zBjl/fy7iEFznIHOAYAoiL?=
 =?us-ascii?Q?cAx9C+/uachsBnjP4IjOQpQuks2ERyNauWwDruLY/8lRW/DA0Nz6fd2PZ+cp?=
 =?us-ascii?Q?TNvLbNgDcCBvWZziIb+rjssrOTx9D42G+BEsIMoDU38FoAMqfMsPCkwVxsKW?=
 =?us-ascii?Q?FSfcyyH5CWJA07HuCJdDYRBUfkIpR5/w4tuKrpTWa+3H9uy09VKkXMgkwwHh?=
 =?us-ascii?Q?mx0ca/7qYW4rqF3QsPFoI/KcWBZn4xvzd6DIVoqu8D5xE753KimXH0ZnAxpi?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: adfc8568-3d2f-4e98-e59e-08da86d7d1c0
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:32.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQ3GbppjcwZdBu91txFoF0Be26j1fcU/nFkVfCjU9GZiuLJ+Ig/1WOGhivF5P6jJ7730mWv6j2Yt757rOyamC7OpF7u6/jxEshyWhYgFebU=
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
index fc118792487b..15958f83107e 100644
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

