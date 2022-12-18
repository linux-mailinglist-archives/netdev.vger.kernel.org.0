Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6F3650511
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 23:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiLRWQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 17:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLRWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 17:16:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2094.outbound.protection.outlook.com [40.107.14.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C55838BF;
        Sun, 18 Dec 2022 14:16:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqnE+esu7p5iME13hmLiOVl0hvsjW2FkLFEkr9uo95amdBPei8uy66sS+Z9AevhmI/vw4x57sU+a1st0aB9Boxa3bmRpMGfNJlg8bSDI6rKl6p7jKfgDXuvEWapHi8xXDyeQzIPCIyiNsSMYtDREoiUjB++2zqDuANO8pjftXH9rOjW3x/k5MjZJIhLCXpfasjMe8K/Qo9PT1SwE6/LddBN2Tk/QXkv/r54dHPGqdqi2uWM5rx4M2NY1V6Pxqly+1fxUSD+NkxILyjVddDpcHVA/x9zHiIenBWh0mg8xubrgyrzL2U5dmJJD/uVKq7+3HN+gCbTrq/yNw3nmBGHmoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6H6eRylGD4+g1nABWxHsjxGtIpYm3tNamWCeiYEght4=;
 b=PShtGpdQluvuhQYzwv1+4HUv5nOmBdFa8RCJffAC/SX/A73woQY+H0baV4pL3/uXl4A/g9k/Cosl0mzTCxDxLQFR573FKsyfKG+weAwr99mlJWTqzkdZ/oOpB88Hyv2gFWHbYDH86YaHoK6yS7rtfa7z05dXaX+CpPN7Wf9jOxfSiAsluAfOLp15W2a32rxKmfuM8VIcUcgUgCLC1i6uDANA+1hWudunF5YltC415GOSEyjEsHH2cnmhca9kHlN9cPQVh+tvoWFKd7r92qLwtqDsfeK0hlZS7YV+U6DMRJkDPu5bZ6Dr8WbeYubxm6m131ff6krbxWs/0AkXD2NwEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H6eRylGD4+g1nABWxHsjxGtIpYm3tNamWCeiYEght4=;
 b=YhV5ugdSCFCXguA79qk7gTSVBR92QtAAQd97sQ9frOViPG8xLGMblOqTidyOjTP25SVNTBkfFi09Wx++b2pHrKS5b0sqbSQwk85ua4weS1znwKvSSEbS74/Lm5j2u4LSVCj5T+emZavS75ersTGGR7KM8ijceBE7L9h1GqEOqUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by GV1P190MB1874.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 22:16:32 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::16a:8656:2013:736f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::16a:8656:2013:736f%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 22:16:32 +0000
Date:   Mon, 19 Dec 2022 00:16:18 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 2/2] net: marvell: prestera: Handle ipv6
 lpm/neigh events
Message-ID: <Y5+RMvhZCyG0bFgh@yorlov.ow.s>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::20) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|GV1P190MB1874:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fc54888-9254-4459-afc1-08dae145848a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tq46A/Tz7LAH5TgsRHDE8QDONV10lf0o+3nWSLNfPm4/GlElXnSZar3NtHaGB3qQEibX30d/CgtoGGuFjFjMLA9KnxXCVK+puRcEqX4aP4yy1qdf3dRhJmYVUeeovJUV/6Yz68gft1wZlNiTkddoDr1TeKf3DsmQdT2wjonBbaSjMcsEhGW0aPO9dkcGLHRiBRQR4Gp4v6TD7HO+4/UMh/Tj40UQhxIYiyqaa9tc/geU67+ENX7APqHleOsjqyx9YO35frt1+rLSCtl2GvujXEyg3GEZIcQXI9UHITIzrPZ6R0jAg4KChCBXNazmkWS5LQI3xIY5Y5FAQ8D3q6LjIZQiXBTM/pwPOJ6Df6S+KMoWdibAb3fOf5f87cLKfXpOhLZmBnucl4llVKYi2P3AYwjuetjKG3K6j6v2RzEAtKS9WAbhnTKrHZSEeVryxNHl1YOaz8utojQe+0I2ebHmOfJaVKWpo1PCsZ87cHT3RhVQgxEVAuvoHdqJbol5p831PIyQDjfcalMlEwVU//OlD0wfRc9VrjUf2eU+Zn6Ex/TjjMtKpyRQhuA3uIEY6EK1Vl0USrxM2YC57Y48mbIIvxAK/meW5n+Acsj7/RWOP5jeNtyhAIeebLQ3Uo2tiADDijMuY+LrUzM9hC0sTccFzmO1r6W9FFcS8WJjygd1VAxvWgbTBefv2/40t+Jq3+n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(396003)(39830400003)(451199015)(6666004)(478600001)(6506007)(6486002)(38100700002)(6512007)(186003)(9686003)(26005)(41300700001)(44832011)(54906003)(6916009)(316002)(2906002)(66476007)(8676002)(66946007)(66556008)(4326008)(8936002)(83380400001)(5660300002)(86362001)(66574015)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OgUomVEJ7FTpmlNANhcHmNntOo2IXKlxeg8jyvv33zmeu4HGnfYYPbz79iMR?=
 =?us-ascii?Q?a4x0J+N7sduROnNy+bymSzLGHmZ8626LarCH1SVhgYqCCvfCDBv9V6eHmcLn?=
 =?us-ascii?Q?U2ITV/mkTxaqeKJx5GjeZtqRKYnRozpfaM62O6c/WTjr1zp77eJCflNYplD1?=
 =?us-ascii?Q?RDxZL8UGlOOtZiS3VCDIdfY630TCVcnbyAEIjObCYkpmiHHnzWIiZS2ccvfy?=
 =?us-ascii?Q?mpu9PVEt2ChX9hCfIcOF0Ahi7MrMn4XJxYK+plAnTMjshcb1XAjPNHduteMy?=
 =?us-ascii?Q?Wy7JdwHtHfH0+BbVRMmc4oInVIDDgRyICToKYgEJotvtjnIOb4Gkxm0EWiJU?=
 =?us-ascii?Q?KDkSz3Hn0aQnbsM+xnAeJUc1KOgGS6EwkdhndjC1tHdtLP8kUFGSbQqfXC/u?=
 =?us-ascii?Q?QJ8Iwz1EkibOrIBr375xp+bZ/9K47elru5DnWy3dlsUX0GMxP95ceaqW/J3L?=
 =?us-ascii?Q?hJlgIZOY0JTLkIxH+D3KM8P6fEVJLDtX6dQHD7mraS6VzxHVGn7xT8+Y+jnv?=
 =?us-ascii?Q?PJ14WjsVmmgvO8EUDizP8vHPTeDVZBNKQNVTgLMoaYUuJ8dQqa5P+v0ymgfh?=
 =?us-ascii?Q?Pat5nB5FFotKA41869LnyjQ1TUatuD0tXrzHMx135rZGK7ulxnO94YJSW2hB?=
 =?us-ascii?Q?/FZ6pcyOt+4J/LxD8+Gpgvf0iiOK4tncW/jWmKgffK8gplBPFfoBe4+olG4v?=
 =?us-ascii?Q?1H34UJm8QUrjRgduaeBbtPFIUqBoyD0uPUw7xduNpb0INl5Febxo26O/DbGK?=
 =?us-ascii?Q?+mzWjP7oC87lvM5badOX0brzzcKAVt6JwtXr9gjL+LxXKEQlrfN0KzIfLKPX?=
 =?us-ascii?Q?LVVu5zNFHRGM2h7eKssdwEdb8hS8IVhZx4V3TvzSEf6p/jS4WM65OzC7sfZC?=
 =?us-ascii?Q?3MxH4rJJqTr7pSN3B8JJ7T6HpmVlTuqy5tUDDE7P1FYCfOTt0OZJIRP9nHND?=
 =?us-ascii?Q?NrxWyURym2AyoxyY3FjgCyERQV1eduS8w882YsqOpM572PFvaUK78GJOBTau?=
 =?us-ascii?Q?uAkPuyexpnriCwWk3PUskIpqmVsUhT5WanhO7o/34QYcuQLKJ407iumHDB+y?=
 =?us-ascii?Q?bbcBP1+r1ZpdCLY/pyJH+ZuzC9HqrKxO4JFv7toOdc6tk7n+nCyIrZIpbKC7?=
 =?us-ascii?Q?spJ7rvOYYVJVshvX5cv0hwf9K+dC6R9WnuSpePeJBpDrcASIc/10mU6aVgdi?=
 =?us-ascii?Q?QsrjqsaVJc1iNjStTWyN0cYUEnCEF6IRq3t/vVbFDxtYtadVvptp8Tvujn4H?=
 =?us-ascii?Q?VYV8Fux/P1bOdCriUxozwdLQRCFbzY9v/alcMgdCaca+KYRfqufIczCrCg1z?=
 =?us-ascii?Q?/6qsxDSlrdGQiwULHsYfqMK0S9wfHtSK1ZNtnGrlmk0XaZ7sYvtVlkdoOjiC?=
 =?us-ascii?Q?uEAPrSuNMsdbTdXmYCapnOtP4BpnP6uBbmCX6qBv3iGC7rCcCwp1OYxXN88y?=
 =?us-ascii?Q?51j+PGk738kwgKRJ/YC/sNfbTf+jiuMhy49XdKrFezIYq0mDkAJ2mRPWYpPC?=
 =?us-ascii?Q?YrPdqRqICCp0JBoUa3c05wgjXw8JAlFJdBnwnnk5oP6fgMk6RFRBL35IG9TX?=
 =?us-ascii?Q?Ov6k8D2mh9dXeOxM9uut0NLCeOSFdaO0YW0VX26Utjvg6jqzAUW+W4HJeIQt?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc54888-9254-4459-afc1-08dae145848a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 22:16:32.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7/KOOYaDsrajcehpesMEJAPqrp8b/H9M70BZWZSyN0+bKNcMz6s+wTpZMKlmgF/dZlhRpLTPCTetyWvluwBJD+K71Tn7nhVtF9kEgacH3y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P190MB1874
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle AF_INET6 for events:
 - NETEVENT_NEIGH_UPDATE
 - FIB_EVENT_ENTRY_REPLACE
 - FIB_EVENT_ENTRY_DEL

Also try to make wrappers for ipv4/6 specific functions.
This allow us to pass fib_notifier_info for most cases.
E.g  prestera_util_fen_info_copy, prestera_util_fen_info_release.
Main idea is to increase number of agnostic about ip version functions.

Limitations:
- Only "local" and "main" tables supported
- Only generic interfaces supported for router (no bridges or vlans)

Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Co-developed-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 138 +++++++++++++-----
 1 file changed, 101 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index a9a1028cb17b..5ee0a9511878 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -12,6 +12,7 @@
 #include <linux/if_vlan.h>
 #include <linux/if_macvlan.h>
 #include <net/netevent.h>
+#include <net/ip6_route.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -60,6 +61,7 @@ struct prestera_kern_fib_cache {
 	union {
 		struct fib_notifier_info info; /* point to any of 4/6 */
 		struct fib_entry_notifier_info fen4_info;
+		struct fib6_entry_notifier_info fen6_info;
 	};
 	bool reachable;
 };
@@ -89,18 +91,67 @@ static u32 prestera_fix_tb_id(u32 tb_id)
 	return tb_id;
 }
 
+static void
+prestera_util_fen_info_copy(struct fib_notifier_info *sinfo,
+			    struct fib_notifier_info *tinfo)
+{
+	struct fib6_entry_notifier_info *sinfo6 =
+		container_of(sinfo, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *sinfo4 =
+		container_of(sinfo, struct fib_entry_notifier_info, info);
+	struct fib6_entry_notifier_info *tinfo6 =
+		container_of(tinfo, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *tinfo4 =
+		container_of(tinfo, struct fib_entry_notifier_info, info);
+
+	if (sinfo->family == AF_INET) {
+		fib_info_hold(sinfo4->fi);
+		*tinfo4 = *sinfo4;
+	} else if (sinfo->family == AF_INET6) {
+		fib6_info_hold(sinfo6->rt);
+		*tinfo6 = *sinfo6;
+	} else {
+		WARN(1, "Invalid address family %s %d", __func__, sinfo->family);
+	}
+}
+
+static void prestera_util_fen_info_release(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *info6 =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *info4 =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		fib_info_put(info4->fi);
+	else if (info->family == AF_INET6)
+		fib6_info_release(info6->rt);
+	else
+		WARN(1, "Invalid address family %s %d",
+		     __func__, info->family);
+}
+
 static void
 prestera_util_fen_info2fib_cache_key(struct fib_notifier_info *info,
 				     struct prestera_kern_fib_cache_key *key)
 {
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
 	struct fib_entry_notifier_info *fen_info =
 		container_of(info, struct fib_entry_notifier_info, info);
 
 	memset(key, 0, sizeof(*key));
-	key->addr.v = PRESTERA_IPV4;
-	key->addr.u.ipv4 = cpu_to_be32(fen_info->dst);
-	key->prefix_len = fen_info->dst_len;
-	key->kern_tb_id = fen_info->tb_id;
+	if (info->family == AF_INET) {
+		key->addr.v = PRESTERA_IPV4;
+		key->addr.u.ipv4 = cpu_to_be32(fen_info->dst);
+		key->prefix_len = fen_info->dst_len;
+		key->kern_tb_id = fen_info->tb_id;
+	} else if (info->family == AF_INET6) {
+		key->addr.v = PRESTERA_IPV6;
+		key->addr.u.ipv6 = fen6_info->rt->fib6_dst.addr;
+		key->prefix_len = fen6_info->rt->fib6_dst.plen;
+		key->kern_tb_id = fen6_info->rt->fib6_table->tb6_id;
+	}
 }
 
 static int prestera_util_nhc2nc_key(struct prestera_switch *sw,
@@ -155,6 +206,9 @@ prestera_util_neigh2nc_key(struct prestera_switch *sw, struct neighbour *n,
 	if (n->tbl->family == AF_INET) {
 		key->addr.v = PRESTERA_IPV4;
 		key->addr.u.ipv4 = *(__be32 *)n->primary_key;
+	} else if (n->tbl->family == AF_INET6) {
+		key->addr.v = PRESTERA_IPV6;
+		key->addr.u.ipv6 = *(struct in6_addr *)n->primary_key;
 	} else {
 		return -ENOENT;
 	}
@@ -683,8 +737,15 @@ __prestera_k_arb_n_offload_set(struct prestera_switch *sw,
 {
 	struct neighbour *n;
 
-	n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
-			 nc->key.dev);
+	if (nc->key.addr.v == PRESTERA_IPV4)
+		n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
+				 nc->key.dev);
+	else if (nc->key.addr.v == PRESTERA_IPV6)
+		n = neigh_lookup(&nd_tbl, &nc->key.addr.u.ipv6,
+				 nc->key.dev);
+	else
+		n = NULL;
+
 	if (!n)
 		return;
 
@@ -715,7 +776,8 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 		fib_alias_hw_flags_set(&init_net, &fri);
 		return;
 	case PRESTERA_IPV6:
-		/* TODO */
+		fib6_info_hw_flags_set(&init_net, fc->fen6_info.rt,
+				       offload, trap, fail);
 		return;
 	}
 }
@@ -1384,44 +1446,43 @@ static int __prestera_inetaddr_valid_cb(struct notifier_block *nb,
 struct prestera_fib_event_work {
 	struct work_struct work;
 	struct prestera_switch *sw;
-	struct fib_entry_notifier_info fen_info;
+	union {
+		struct fib_notifier_info info; /* point to any of 4/6 */
+		struct fib6_entry_notifier_info fen6_info;
+		struct fib_entry_notifier_info fen4_info;
+	};
 	unsigned long event;
 };
 
 static void __prestera_router_fib_event_work(struct work_struct *work)
 {
 	struct prestera_fib_event_work *fib_work =
-			container_of(work, struct prestera_fib_event_work, work);
-	struct prestera_switch *sw = fib_work->sw;
+		container_of(work, struct prestera_fib_event_work,
+			     work);
 	int err;
 
 	rtnl_lock();
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = prestera_k_arb_fib_evt(sw, true,
-					     &fib_work->fen_info.info);
+		err = prestera_k_arb_fib_evt(fib_work->sw, true,
+					     &fib_work->info);
 		if (err)
-			goto err_out;
+			dev_err(fib_work->sw->dev->dev,
+				"Error when processing lpm entry");
 
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		err = prestera_k_arb_fib_evt(sw, false,
-					     &fib_work->fen_info.info);
+		err = prestera_k_arb_fib_evt(fib_work->sw, false,
+					     &fib_work->info);
 		if (err)
-			goto err_out;
+			dev_err(fib_work->sw->dev->dev,
+				"Cant delete lpm entry");
 
 		break;
 	}
 
-	goto out;
-
-err_out:
-	dev_err(sw->dev->dev, "Error when processing %pI4h/%d",
-		&fib_work->fen_info.dst,
-		fib_work->fen_info.dst_len);
-out:
-	fib_info_put(fib_work->fen_info.fi);
+	prestera_util_fen_info_release(&fib_work->info);
 	rtnl_unlock();
 	kfree(fib_work);
 }
@@ -1430,30 +1491,33 @@ static void __prestera_router_fib_event_work(struct work_struct *work)
 static int __prestera_router_fib_event(struct notifier_block *nb,
 				       unsigned long event, void *ptr)
 {
+	struct fib6_entry_notifier_info *info6 =
+		container_of(ptr, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *info4 =
+		container_of(ptr, struct fib_entry_notifier_info, info);
+	struct prestera_router *router =
+		container_of(nb, struct prestera_router, fib_nb);
 	struct prestera_fib_event_work *fib_work;
-	struct fib_entry_notifier_info *fen_info;
 	struct fib_notifier_info *info = ptr;
-	struct prestera_router *router;
-
-	if (info->family != AF_INET)
-		return NOTIFY_DONE;
-
-	router = container_of(nb, struct prestera_router, fib_nb);
 
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
-		fen_info = container_of(info, struct fib_entry_notifier_info,
-					info);
-		if (!fen_info->fi)
+		if (info->family == AF_INET6) {
+			if (!info6->rt)
+				return NOTIFY_DONE;
+		} else if (info->family == AF_INET) {
+			if (!info4->fi)
+				return NOTIFY_DONE;
+		} else {
 			return NOTIFY_DONE;
+		}
 
 		fib_work = kzalloc(sizeof(*fib_work), GFP_ATOMIC);
 		if (WARN_ON(!fib_work))
 			return NOTIFY_BAD;
 
-		fib_info_hold(fen_info->fi);
-		fib_work->fen_info = *fen_info;
+		prestera_util_fen_info_copy(info, &fib_work->info);
 		fib_work->event = event;
 		fib_work->sw = router->sw;
 		INIT_WORK(&fib_work->work, __prestera_router_fib_event_work);
@@ -1500,7 +1564,7 @@ static int prestera_router_netevent_event(struct notifier_block *nb,
 
 	switch (event) {
 	case NETEVENT_NEIGH_UPDATE:
-		if (n->tbl->family != AF_INET)
+		if (n->tbl->family != AF_INET && n->tbl->family != AF_INET6)
 			return NOTIFY_DONE;
 
 		net_work = kzalloc(sizeof(*net_work), GFP_ATOMIC);
-- 
2.17.1
