Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABFB5B29AF
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIHWyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiIHWxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:51 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2121.outbound.protection.outlook.com [40.107.20.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5425F12BFA0;
        Thu,  8 Sep 2022 15:53:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nc4GXJsJp9I3qeJpT9he17c0bUMdZ2mg9G9NTGHbu0UvphEwh4+YKWcgeUV2iu0Csr+Rlpmfv4KKXnWzBugy/RHLLYveQymzgqzPdUxw1vZ+soUYmpxxbnqiOrxrSuwkYT/wZlhZEhkrK+AXLeE9nGyoZfZYacUScBOgeI3OyeZDfBjoL8FAuiP2mkoyQSQ6T7YQqDhY5jHeELlBMGP37KjHheDF0m1GV2ollpnddj/daz8oMdCk7ilUM3D+A9jAIGV+nRLJJFPhFm2BPSzlQ6a9T9rI0V5ureP7Uj7u+6KYS6GtS3jWnSglGuSR6OuznUiO2cVBWTOwPPi5NukrNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bu91UWEoOWEY7ZljUddNpMmbtG6YQai0PFAnZtOL0HE=;
 b=Mwpa+DQ2o6UMh01eGOF1zDNC2IbxUF7Y1qlto0bhu132E2NzSOHxNL56GuhefGcn6QCPM3NzRk/yI7QxhOSdAoNU3SyEaVoUdqN4LKloD8GNj6G1rxlfXRUA9n0jrDAZotIkONJrIlGqg2Fz2N/QKU9VweVsxSGmThw5cHMuyRlnouGOW/Jpq0QeGMgF1+FJkIoTml3KBhKvg71nosU9Naegqex/UWub338kBFw7fPaOxJ29f1KFvCA1RM2nH7L3f3QeQdgZWrzxCl7BeO//7Pk5qyvLVhcjvKCKrDuO0pnIRHwYKMb3C+HeVUTlyrXQgUryXCTMMbvyc6jM4lztKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu91UWEoOWEY7ZljUddNpMmbtG6YQai0PFAnZtOL0HE=;
 b=WTDqDfvaUxDfETbx5fat+NlvEUZANMrzkDcmqPb+m8KkJsaEoWEl5j7sJlzqRzqD39ZQOtxnV8fwzCrizaPS/zuPHYrqAH3IUC8BV2nxKgvLWby+oWHwQSw4g0s6rwMuhhyBhfzgovxnMAWTzLbewXPzKxIDtkVPNuBjwA/fuKI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:37 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:37 +0000
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
Subject: [PATCH net-next v5 6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
Date:   Fri,  9 Sep 2022 01:52:08 +0300
Message-Id: <20220908225211.31482-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c72b070-63fa-4e80-783d-08da91ecf772
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFt31/SemN5wR31RV8MQYiFNtJUDYA3X4eLkRzSzUa1rwZuxyOgNoxpYzd38KUgy3m69ni7T540gzjg03GH6qH7Vd0aoyIbpv5jbeEYTZoJFl7BZBSYkQHSO3bsQbi4mpU9i+pYQU1f+OXIT7rMwDPsSKgB5faft2k6FK7Lunb3KYc8U9WO3vT3gWY1OBhie873+5nNLOWSX5z3t9ZENBwFRZFiXIqjTQkfEYz2hBLQVLGEJ0mRL1irroMelDN5NK19Y7FeTYYlTsYTy56ruhouHTlkdYAhQk7widrFGZHJTYu6eyI8L+Y1J+uSPAmX385RhoM/SSodRGyLCgyf5A9K+/hDjDQzeGRbWrXh+4BXHfW1mVszrLZPXvVPL+a7bWpqDS3lSz9bhDB3Rabf5QVRrupebm5ioIsfLOYkyAAEpZvtyXaQ0IWEW2bX40+ns/TLtiXKkcYL2PiLFXwklpqawS6zjbL1iRZzs9OFOpv0mqELNAeH/CfVxxnIO1A40wgk2sUZBDmzw6e6BqiEogNpzeUjezMYEfnq/KtwRDDlndlFVEfGHnUgQwm0vjrgOOpxxn9MvP+G/Wk6tioORspkHkxMlZrd3u5NEwdd/V61xx7n2o0Nanz+1Z2UyqOZMQjq6du3MxStyZwCAYo1SQqTHFt9NYhx5Tvz6F3PasSXc9ug0TXLDvAKfgr1An2Q4BbvBwazUPvypiqWCRKV+mmjtZ5o6m1pABnJKmknjRWSpywyKbQgLEEZhSTIHezqo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(83380400001)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IHYRlSi9ecadiQ26NCyG7nxrzY++gCNsMsGa5tSt3YOuktkblqb823L2HQBE?=
 =?us-ascii?Q?ZygzYlEaBNXrkqmXU1D/CFEInQemsdEyg8A0NUdwnPL/3U51tAwNhn2OEkk+?=
 =?us-ascii?Q?Kv0OHm2IAWsm/n50JwtWtBu3hauZFpnEY/tCExol9k0Xu/sZtbxdch7IJcl6?=
 =?us-ascii?Q?bk7dAUfbgMl3rgVS0QW3x2quU/YJtZezCnzUq2tbZiOSWEtJkmSvtAvjtPct?=
 =?us-ascii?Q?aE52bpA1GNyWrf2d7QPGXKvc8QscYkIkDvWYOIueOYcjrOZLiz32CtEKuWPZ?=
 =?us-ascii?Q?BmydzYcQk+IbDJVrZEJMN+UYiPfjxfN4p6ECqW0P5Zon/ZZ4sOvY6LkpsHPE?=
 =?us-ascii?Q?vAG7Rj/iXsLmqWzL1xhMOCGe8TA3x38Ogbo3zFpKyR343RVMMZK98jRj51xp?=
 =?us-ascii?Q?bwipmO2B1GRnFP6jT/ys2pv6vVTaTZTga12Owx3zfwx5gsYQfAZ4SYRAOgWX?=
 =?us-ascii?Q?EFMYrLLkzBetljTqG9IrfHbCSai5Q/lirk+F+9lKC/aWO0BKWvzR4Jo4IN0F?=
 =?us-ascii?Q?zxmePRL/0U0rNmbvN7qCQceUZQ94hlV+26ujt7UcuiEu66Nt1aE4YXualMlF?=
 =?us-ascii?Q?+YCDABqjNKLtmpOk7Dn+oYrHzMnTbnLX3Q4V1sO/sdWQNo2E+XfTM7bCUOvV?=
 =?us-ascii?Q?ebqMB3okA4KUo3Ge668kvZaCIDEUT58K3rRezXJwF4oexGu5Z2pINjtJYLZz?=
 =?us-ascii?Q?FhZubHnzifTqMHO3PUSI6TYetohpqpoipWbZ6P6qfd4fNpEB25nRO9pIOQ4a?=
 =?us-ascii?Q?vsiZLkiJ/e/J4Llhc1NfGnbsbva76Wfrm0bmQ++zXMJYPeZTqhedtpQnQ6px?=
 =?us-ascii?Q?bV1yI0FKJp9hZ3xFcOBjdMnwlIE3uQyIbYk2LBhIOo8YyqaH+c4En68Xm66N?=
 =?us-ascii?Q?KZ9pSdmarf53b5HA+T7jU8fvivfzGCvmusaBDplXvsy+cYhSOJrB3c7/4t9b?=
 =?us-ascii?Q?qL/jFyfxFiBP7xDLWzZlY3YRsOlmN4hDCtUIuPrJjJ1H8oOJj+wwiF+hXc2G?=
 =?us-ascii?Q?/OkP8YLWERET03ZjOceDMQxP3+JXfsCvpQFCxKF1IbdmxLcU6hWy+NMa4cqr?=
 =?us-ascii?Q?GHdpwHdWlDn+oS2l/9QF8SY2idWRrnkdDH+1WJJ85NB2a8A5UxAR2IXHZLmJ?=
 =?us-ascii?Q?RLzE3TmoEKu4xuaHAHbMjG6Z42VW4loNT5drzNUA06GC+nVpocALMLLDIzhY?=
 =?us-ascii?Q?GIodfcvPmsHyIzkJcLOhLm26L+pSp8fvlqGv8sR4GlgGBieYYfw9HogWwKW/?=
 =?us-ascii?Q?7BzxLQnWfEkv8GFTMzqCv+S6X4jxUo3RYMMsicirflIen3Gfb9LGf4UXqRls?=
 =?us-ascii?Q?77n49VZbNpVwT5W46TGtZdMf9vHzO6kNMarcua8CNzXCiFsqIutPng+bTlYj?=
 =?us-ascii?Q?SuJu47w3qxGv94uDwVsTt6GQot0+FUZycdK4fn/S/A8Rn+F3DltEahdiSYUw?=
 =?us-ascii?Q?NhnwunGLwAPrhAEI7uhlovYZKTQAzCpE3WTBadxvtWiQz/kyh0bfv9fA7bLg?=
 =?us-ascii?Q?PR/rJ7p1KqaIdw93PZjoR3vCyvXqDwfKGycHhKD8cnLH6EtKKwZhRUqReMs6?=
 =?us-ascii?Q?SSg+1PVKPNTi+0vwDU2mVD7eFeLPRcGMUDS7X5bhq1SqfOKRTuFHkyWdUDTJ?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c72b070-63fa-4e80-783d-08da91ecf772
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:37.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8/FBw7DS8h7xt2fWuBpMPk/2mTdSm7RTPM7RwVRJVzSzeMyErns7Wi0xJNagwEMwagmy2m1nDFKgZkp5vsxqvp9XrGfcu8wOzHM2yGod7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
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

