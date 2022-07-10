Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A69156D074
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiGJRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGJRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:23:30 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60092.outbound.protection.outlook.com [40.107.6.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870421400F;
        Sun, 10 Jul 2022 10:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C73ozeq4mND6gi9k5VUNQSoTvzaqa2MNybPDQB3AzI4lTclrZShR8J+lS3vFfr27oniac+E8UbskrLGYUe9oiYGQ+p3GtC19v+fjvF7L+aysHJKKgaUeCxtfQl5COcDPcpN+h2hOOKGqZUuqx5CEYpSli2ktEIGQGl9Omm6TNJblwuka/M160DmBtJ68WKWRgYFRpKmlkU0qacGkFvCWzHQBdqd94Qlo+32FbIRIJ9h0LR5GVNCgnpmetVOgtxi9SqRAAh9QweOUk3nvJzsZhtDfDetB24zIvH3dvFmyESrO6nynDCvu1JpnbMNPf3TN6dYM2DPCRp/z5kG1WnUamQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g05KxB2vkE36pNGr01S8EoyMsBHA7wbRnquGwaYNaBs=;
 b=Hxru9ThELPySv3WPxxyZQ/wrQV8uWyN56GyOWQstzzyNLQjMd6/vFaeaBImv7d3OKZ/wny3AyG3XBU7Aoz07eSvYMUCi2MYRb2l9nRW76HA+KQA3+LQo+lpYpaNW9KKprkG1dDCMb2+bhKun998ybOynYWF70oD1u7IHnL61tmwAnVIHiV5pXH3Kl/KNu7MbAQNA95lW4wx2lBjOrXB9radIQxE1FAGGDfyzcBf8Rxrz5OVwVDmL+X8ucA1kyIm1jFBWp1TH9peOfBtRvzHbTNwUZv4qnTJyFFaFO74hECHlRyIlTdmwAJkwCMZG7/txiNvfV8SKMYMtT3J+ANNnDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g05KxB2vkE36pNGr01S8EoyMsBHA7wbRnquGwaYNaBs=;
 b=Itef8IiVD0gEhOqNT7PUwMa+q1tmsrzPavC0uIJSNT5qCJYBAIn8SzfOVABc6femaxCPIoP+2AcFY4U9+wFBk2ZVCe98uuHldhnwZmG4DNRgH5bE35w+6c240/1TiQ98eac2eJmZzNylmG+oRsWNlS6fK8pyPP2Kn8cEQyC8KJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:47 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:47 +0000
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
Subject: [PATCH net-next 8/9] net: marvell: prestera: Add neighbour cache accounting
Date:   Sun, 10 Jul 2022 20:22:06 +0300
Message-Id: <20220710172208.29851-9-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d723dcb-d339-43b6-003b-08da6298cf1a
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaWJMYXLxXFTFJ5OXq00vioPpSS4HFYmOi99BZzG5xjCxLcw60LfReSnBL1n3m+8Hj+nIbot8Gm6NmgxsvciL3XpguHDJ9GCMiVJPSU87PQykHmVgwpo0CSsYeFJ/mxYzIKpNwgvmRdfSQrRlz2i7xmnp/q1q8b+uuaFEjaRUzoqKP1e5Dpt67ZZVHdNN6/6C7PGwYy97ocg6ElhTBZ3xBvc0hcv8g3Lzuy0btv3iVXfxibyfRyr7+JRnSzaP46b2y+2O8EDl28RqMnan5c3P/1ajByjfS4PxoPj6zVlGZyhrDvSlcV9B5IEBDI73YAJ1jbxexVul26hue/aLWTZbNMbcoxeGFd01oBZ6yPq7NRzmtNMux+y1wuC/YFeYSbzy5jJmliGy3PUlyDxhZACi91P6noPpHQ57bH3+nkR51KxJKLylpDznBdLecp8RILtzYdrSIyL4/dSlLgbM5A8caJhojI1sSFnZsVF2mQd3PDs+sLJH1f3QGjSUeEPAc+NOrpAk1yJ5Q/2gN6GVO68QJvIJSKI98k106A5FvDsgDlcVXgbnN3/wEnqGV0XDOA3qImh9IRTGuycDmCQpQJw53J0jt6wixIZnE7W07xhu1f9AS7KojMrthw4klZ6KFZ8ixhlGZ270mhge79GQTrzMpoj0D3zCPQEOPdzjtc6+ngYtpWdcFoV283bW4IgebAQMgyJqvYg73huph7Kl1mN5wqSKWG5nppquFprrigIf+dEC55Gq4yuGQ99t6NuWQXlEM7ICUdNtN8yc8Vr90lFCWGYz6gfDREsj/O0oEkZ6ow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(15650500001)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(30864003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zoLqD++3eX7lDkSM9m1hG0VUttGkj8RYQLbLK/VATaBN2iLHuC4DJJXJiIvG?=
 =?us-ascii?Q?NRku6p8Mkvj92MfDrDolJOSLovf5WfOQrcq7RKS6FdEfGbgLDPys7qqjjmRE?=
 =?us-ascii?Q?A5TfsMx2DUcx+e6R2f/d8v6/jQkw+S0KNvgBmfTQ3E2Wl3jml1/6CPsBr4Tg?=
 =?us-ascii?Q?vda5ttnihjajkYNpCXNb4H/cA0n27LTLPMpNiqt2+WNVAcknS3qeiMKEFOyG?=
 =?us-ascii?Q?M55mvq/MyF8EM7rZDKm7gV30Akc4NeTWzNyURAm4rgDJZPiDoSK1tjQsiGiT?=
 =?us-ascii?Q?1U7yMEV0S/jHIZMnGTYCkBgtfOyFb0FF6PPmOL9c//D9+zV4PT6N5H7j4pRy?=
 =?us-ascii?Q?Jb5Q3KZk79A+Ws7Zqowa+D1Wzc/gznSJtxwLJKyOZgpxYYS/KUgDVrlqXI8v?=
 =?us-ascii?Q?E9L6ce4yBcBxsW1eJBwkorqrzoE8+1t4bKSb1RkBJ1F2/cDMoUB41pIvVacF?=
 =?us-ascii?Q?Rar9XeeI8rdeayK0B3CmnqEJKgWIVvlesVRxiEGIgDO+IcGoHDwZIqeFGV4s?=
 =?us-ascii?Q?QjHzFcFMMkF92PnMfDGdk3hYmitoNZvSDmghPo7y1Moc9smFp/pQHVZIWrB2?=
 =?us-ascii?Q?UkF+QAYrNRKSv7f/ZTibTJXe3VRPnrf+tr+jIh0K7X3Uu0EY5gwdaILD1BCQ?=
 =?us-ascii?Q?TCV/n5NieHGotrBbxDTPj4U4wbnZo98T1yHl5TE+H5V/dbWsbnX9su1WN3rN?=
 =?us-ascii?Q?WLfCr9coK3Y6q1z75pg63vKR5p+K/aa4chgDn/94Gbfgpn+kRD018frDN7up?=
 =?us-ascii?Q?IjbFb5l4ntlE/Xmx9Yj5BbI1/XY9PNUjyPxML0NVZk1i7rnCna/sLwuaMv1z?=
 =?us-ascii?Q?xRRR07WnEUDdvFOUrJUcy4bQpb3kGuaEAD8GjU58ot41miNv+2GIum4DHSWZ?=
 =?us-ascii?Q?rH3qjTs1XDhnLqB3PYwTGMHltoGhLqpvgwCq2A2Gt3QJS0zC5ch9TDKuv/4w?=
 =?us-ascii?Q?Rji/HecU3QMSyDHoTUKcgmkDqCod8aqPU9tMcAVYvDB87k4/ykUapgqphkWn?=
 =?us-ascii?Q?dTQclU0RDSy6XZcjTf1ttHkprKkNQbVEvAwch9C+bsb5+vKznm4lbfRanjKV?=
 =?us-ascii?Q?lDYkmUOrzUK10Nh8zbhQ6EWd/+fYvpUonIy1LiL9Gk92NTmMWuBQRkhVZbx/?=
 =?us-ascii?Q?14GW2sS+5EJvNDZWcc7ipDsqAhHHwmf8aauJEqKTiiDG3uo5wB/Klaz5DAZ8?=
 =?us-ascii?Q?VXSLfTOyT1/9uLsnofPlakjHsQZ19g85PuYG/+uqYPEneUPCbdHt2X1gNzPU?=
 =?us-ascii?Q?QY5ajdp9PxlZzNe/6Zbzyg4KLquc2yAxcD4SsEBv247yRR+4oJNqMFBswIYG?=
 =?us-ascii?Q?7CRxzjYPrjTGUT9G9dJf2/QZdxiHI1y5N4LnSCGSSGzRode1nyZL2N2k0WMK?=
 =?us-ascii?Q?EywO2Do3mo9/2ze+afiDUWpINBPfT8tqWeHezrXP/wACG0R2IdMEM03EgpjB?=
 =?us-ascii?Q?UUO9z6UBlCb1PM5TZDCQOy9/7gJph0AeVOg5S/fQNWIyNnEmIsAIez7yJwjA?=
 =?us-ascii?Q?ZDmDITLNhb9F9csfXuNSZNNMp5u6GBIjBB9RDWpckOK7KhQ/nmswRB4J0m0H?=
 =?us-ascii?Q?LTQTsyMwM8pHrraLt4y6A1QA9rRtJ1QE2b2OjtARR1YU7jDux5YL4u3EBvy+?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d723dcb-d339-43b6-003b-08da6298cf1a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:47.6891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFQ9JXFN/TiBjDl/BeRcjws5acF4I1rVyc7Nq21sEyxla57Xunt/spDB1GDHZicmeuYEVocHQnvQpVe/3JcxiT7/yiggvY+sticb8MDkiKo=
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

Move forward and use new PRESTERA_FIB_TYPE_UC_NH to provide basic
nexthop routes support.
Provide deinitialization sequence for all created router objects.

Limitations:
- Only "local" and "main" tables supported
- Only generic interfaces supported for router (no bridges or vlans)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   1 +
 .../marvell/prestera/prestera_router.c        | 604 +++++++++++++++++-
 2 files changed, 602 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index b464cf46b122..32843885dc3d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -286,6 +286,7 @@ struct prestera_router {
 	struct rhashtable nh_neigh_ht;
 	struct rhashtable nexthop_group_ht;
 	struct rhashtable fib_ht;
+	struct rhashtable kern_neigh_cache_ht;
 	struct rhashtable kern_fib_cache_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 570469a99e47..6dc116c2a4b6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,11 +8,30 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/arp.h>
+#include <linux/if_vlan.h>
+#include <linux/if_macvlan.h>
 #include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+struct prestera_kern_neigh_cache_key {
+	struct prestera_ip_addr addr;
+	struct net_device *dev;
+};
+
+struct prestera_kern_neigh_cache {
+	struct prestera_kern_neigh_cache_key key;
+	struct rhash_head ht_node;
+	struct list_head kern_fib_cache_list;
+	/* Lock cache if neigh is present in kernel */
+	bool in_kernel;
+	/* Hold prepared nh_neigh info if is in_kernel */
+	struct prestera_neigh_info nh_neigh_info;
+	/* Indicate if neighbour is reachable by direct route */
+	bool reachable;
+};
 struct prestera_kern_fib_cache_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -25,9 +44,15 @@ struct prestera_kern_fib_cache {
 	struct {
 		struct prestera_fib_key fib_key;
 		enum prestera_fib_type fib_type;
+		struct prestera_nexthop_group_key nh_grp_key;
 	} lpm_info; /* hold prepared lpm info */
 	/* Indicate if route is not overlapped by another table */
 	struct rhash_head ht_node; /* node of prestera_router */
+	struct prestera_kern_neigh_cache_head {
+		struct prestera_kern_fib_cache *this;
+		struct list_head head;
+		struct prestera_kern_neigh_cache *n_cache;
+	} kern_neigh_cache_head[PRESTERA_NHGR_SIZE_MAX];
 	union {
 		struct fib_notifier_info info; /* point to any of 4/6 */
 		struct fib_entry_notifier_info fen4_info;
@@ -35,6 +60,13 @@ struct prestera_kern_fib_cache {
 	bool reachable;
 };
 
+static const struct rhashtable_params __prestera_kern_neigh_cache_ht_params = {
+	.key_offset  = offsetof(struct prestera_kern_neigh_cache, key),
+	.head_offset = offsetof(struct prestera_kern_neigh_cache, ht_node),
+	.key_len     = sizeof(struct prestera_kern_neigh_cache_key),
+	.automatic_shrinking = true,
+};
+
 static const struct rhashtable_params __prestera_kern_fib_cache_ht_params = {
 	.key_offset  = offsetof(struct prestera_kern_fib_cache, key),
 	.head_offset = offsetof(struct prestera_kern_fib_cache, ht_node),
@@ -67,6 +99,67 @@ prestera_util_fen_info2fib_cache_key(struct fib_notifier_info *info,
 	key->kern_tb_id = fen_info->tb_id;
 }
 
+static int prestera_util_nhc2nc_key(struct prestera_switch *sw,
+				    struct fib_nh_common *nhc,
+				    struct prestera_kern_neigh_cache_key *nk)
+{
+	memset(nk, 0, sizeof(*nk));
+	if (nhc->nhc_gw_family == AF_INET) {
+		nk->addr.v = PRESTERA_IPV4;
+		nk->addr.u.ipv4 = nhc->nhc_gw.ipv4;
+	} else {
+		nk->addr.v = PRESTERA_IPV6;
+		nk->addr.u.ipv6 = nhc->nhc_gw.ipv6;
+	}
+
+	nk->dev = nhc->nhc_dev;
+	return 0;
+}
+
+static void
+prestera_util_nc_key2nh_key(struct prestera_kern_neigh_cache_key *ck,
+				 struct prestera_nh_neigh_key *nk)
+{
+	memset(nk, 0, sizeof(*nk));
+	nk->addr = ck->addr;
+	nk->rif = (void *)ck->dev;
+}
+
+static bool
+prestera_util_nhc_eq_n_cache_key(struct prestera_switch *sw,
+				 struct fib_nh_common *nhc,
+				 struct prestera_kern_neigh_cache_key *nk)
+{
+	struct prestera_kern_neigh_cache_key tk;
+	int err;
+
+	err = prestera_util_nhc2nc_key(sw, nhc, &tk);
+	if (err)
+		return false;
+
+	if (memcmp(&tk, nk, sizeof(tk)))
+		return false;
+
+	return true;
+}
+
+static int
+prestera_util_neigh2nc_key(struct prestera_switch *sw, struct neighbour *n,
+			   struct prestera_kern_neigh_cache_key *key)
+{
+	memset(key, 0, sizeof(*key));
+	if (n->tbl->family == AF_INET) {
+		key->addr.v = PRESTERA_IPV4;
+		key->addr.u.ipv4 = *(__be32 *)n->primary_key;
+	} else {
+		return -ENOENT;
+	}
+
+	key->dev = n->dev;
+
+	return 0;
+}
+
 static bool __prestera_fi_is_direct(struct fib_info *fi)
 {
 	struct fib_nh *fib_nh;
@@ -301,6 +394,145 @@ prestera_kern_fib_info_type(struct fib_notifier_info *info)
 	return RTN_UNSPEC;
 }
 
+/* Decided, that uc_nh route with key==nh is obviously neighbour route */
+static bool
+prestera_fib_node_util_is_neighbour(struct prestera_fib_node *fib_node)
+{
+	if (fib_node->info.type != PRESTERA_FIB_TYPE_UC_NH)
+		return false;
+
+	if (fib_node->info.nh_grp->nh_neigh_head[1].neigh)
+		return false;
+
+	if (!fib_node->info.nh_grp->nh_neigh_head[0].neigh)
+		return false;
+
+	if (memcmp(&fib_node->info.nh_grp->nh_neigh_head[0].neigh->key.addr,
+		   &fib_node->key.addr, sizeof(struct prestera_ip_addr)))
+		return false;
+
+	return true;
+}
+
+static int prestera_dev_if_type(const struct net_device *dev)
+{
+	struct macvlan_dev *vlan;
+
+	if (is_vlan_dev(dev) && netif_is_bridge_master(vlan_dev_real_dev(dev)))
+		return PRESTERA_IF_VID_E;
+	else if (netif_is_bridge_master(dev))
+		return PRESTERA_IF_VID_E;
+	else if (netif_is_lag_master(dev))
+		return PRESTERA_IF_LAG_E;
+	else if (netif_is_macvlan(dev)) {
+		vlan = netdev_priv(dev);
+		return prestera_dev_if_type(vlan->lowerdev);
+	}
+	else
+		return PRESTERA_IF_PORT_E;
+}
+
+static int
+prestera_neigh_iface_init(struct prestera_switch *sw,
+			  struct prestera_iface *iface,
+			  struct neighbour *n)
+{
+	struct prestera_port *port;
+
+	iface->vlan_id = 0; /* TODO: vlan egress */
+	iface->type = prestera_dev_if_type(n->dev);
+	if (iface->type != PRESTERA_IF_PORT_E)
+		return -EINVAL;
+
+	if (!prestera_netdev_check(n->dev))
+		return -EINVAL;
+
+	port = netdev_priv(n->dev);
+	iface->dev_port.hw_dev_num = port->dev_id;
+	iface->dev_port.port_num = port->hw_id;
+
+	return 0;
+}
+
+static struct prestera_kern_neigh_cache *
+prestera_kern_neigh_cache_find(struct prestera_switch *sw,
+			       struct prestera_kern_neigh_cache_key *key)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+
+	n_cache =
+	 rhashtable_lookup_fast(&sw->router->kern_neigh_cache_ht, key,
+				__prestera_kern_neigh_cache_ht_params);
+	return IS_ERR(n_cache) ? NULL : n_cache;
+}
+
+static void
+__prestera_kern_neigh_cache_destroy(struct prestera_switch *sw,
+				    struct prestera_kern_neigh_cache *n_cache)
+{
+	dev_put(n_cache->key.dev);
+	rhashtable_remove_fast(&sw->router->kern_neigh_cache_ht,
+			       &n_cache->ht_node,
+			       __prestera_kern_neigh_cache_ht_params);
+	kfree(n_cache);
+}
+
+static struct prestera_kern_neigh_cache *
+__prestera_kern_neigh_cache_create(struct prestera_switch *sw,
+				   struct prestera_kern_neigh_cache_key *key)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	int err;
+
+	n_cache = kzalloc(sizeof(*n_cache), GFP_KERNEL);
+	if (!n_cache)
+		goto err_kzalloc;
+
+	memcpy(&n_cache->key, key, sizeof(*key));
+	dev_hold(n_cache->key.dev);
+
+	INIT_LIST_HEAD(&n_cache->kern_fib_cache_list);
+	err = rhashtable_insert_fast(&sw->router->kern_neigh_cache_ht,
+				     &n_cache->ht_node,
+				     __prestera_kern_neigh_cache_ht_params);
+	if (err)
+		goto err_ht_insert;
+
+	return n_cache;
+
+err_ht_insert:
+	dev_put(n_cache->key.dev);
+	kfree(n_cache);
+err_kzalloc:
+	return NULL;
+}
+
+static struct prestera_kern_neigh_cache *
+prestera_kern_neigh_cache_get(struct prestera_switch *sw,
+			      struct prestera_kern_neigh_cache_key *key)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+
+	n_cache = prestera_kern_neigh_cache_find(sw, key);
+	if (!n_cache)
+		n_cache = __prestera_kern_neigh_cache_create(sw, key);
+
+	return n_cache;
+}
+
+static struct prestera_kern_neigh_cache *
+prestera_kern_neigh_cache_put(struct prestera_switch *sw,
+			      struct prestera_kern_neigh_cache *n_cache)
+{
+	if (!n_cache->in_kernel &&
+	    list_empty(&n_cache->kern_fib_cache_list)) {
+		__prestera_kern_neigh_cache_destroy(sw, n_cache);
+		return NULL;
+	}
+
+	return n_cache;
+}
+
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_find(struct prestera_switch *sw,
 			     struct prestera_kern_fib_cache_key *key)
@@ -317,6 +549,17 @@ static void
 prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 				struct prestera_kern_fib_cache *fib_cache)
 {
+	struct prestera_kern_neigh_cache *n_cache;
+	int i;
+
+	for (i = 0; i < PRESTERA_NHGR_SIZE_MAX; i++) {
+		n_cache = fib_cache->kern_neigh_cache_head[i].n_cache;
+		if (n_cache) {
+			list_del(&fib_cache->kern_neigh_cache_head[i].head);
+			prestera_kern_neigh_cache_put(sw, n_cache);
+		}
+	}
+
 	fib_info_put(fib_cache->fen4_info.fi);
 	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
 			       &fib_cache->ht_node,
@@ -324,6 +567,41 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 	kfree(fib_cache);
 }
 
+static int
+__prestera_kern_fib_cache_create_nhs(struct prestera_switch *sw,
+				     struct prestera_kern_fib_cache *fc)
+{
+	struct prestera_kern_neigh_cache_key nc_key;
+	struct prestera_kern_neigh_cache *n_cache;
+	struct fib_nh_common *nhc;
+	int i, nhs, err;
+
+	if (!prestera_fib_info_is_nh(&fc->info))
+		return 0;
+
+	nhs = prestera_kern_fib_info_nhs(&fc->info);
+	if (nhs > PRESTERA_NHGR_SIZE_MAX)
+		return 0;
+
+	for (i = 0; i < nhs; i++) {
+		nhc = prestera_kern_fib_info_nhc(&fc->fen4_info.info, i);
+		err = prestera_util_nhc2nc_key(sw, nhc, &nc_key);
+		if (err)
+			return 0;
+
+		n_cache = prestera_kern_neigh_cache_get(sw, &nc_key);
+		if (!n_cache)
+			return 0;
+
+		fc->kern_neigh_cache_head[i].this = fc;
+		fc->kern_neigh_cache_head[i].n_cache = n_cache;
+		list_add(&fc->kern_neigh_cache_head[i].head,
+			 &n_cache->kern_fib_cache_list);
+	}
+
+	return 0;
+}
+
 /* Operations on fi (offload, etc) must be wrapped in utils.
  * This function just create storage.
  */
@@ -351,6 +629,12 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	if (err)
 		goto err_ht_insert;
 
+	/* Handle nexthops */
+	err = __prestera_kern_fib_cache_create_nhs(sw, fib_cache);
+	if (err)
+		goto out; /* Not critical */
+
+out:
 	return fib_cache;
 
 err_ht_insert:
@@ -360,6 +644,46 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	return NULL;
 }
 
+static void
+__prestera_k_arb_fib_nh_offload_set(struct prestera_switch *sw,
+				    struct prestera_kern_fib_cache *fibc,
+				    struct prestera_kern_neigh_cache *nc,
+				    bool offloaded, bool trap)
+{
+	struct fib_nh_common *nhc;
+	int i, nhs;
+
+	nhs = prestera_kern_fib_info_nhs(&fibc->info);
+	for (i = 0; i < nhs; i++) {
+		nhc = prestera_kern_fib_info_nhc(&fibc->info, i);
+		if (!nc) {
+			prestera_util_kern_set_nh_offload(nhc, offloaded, trap);
+			continue;
+		}
+
+		if (prestera_util_nhc_eq_n_cache_key(sw, nhc, &nc->key)) {
+			prestera_util_kern_set_nh_offload(nhc, offloaded, trap);
+			break;
+		}
+	}
+}
+
+static void
+__prestera_k_arb_n_offload_set(struct prestera_switch *sw,
+			       struct prestera_kern_neigh_cache *nc,
+			       bool offloaded)
+{
+	struct neighbour *n;
+
+	n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
+			 nc->key.dev);
+	if (!n)
+		return;
+
+	prestera_util_kern_set_neigh_offload(n, offloaded);
+	neigh_release(n);
+}
+
 static void
 __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 				     struct prestera_kern_fib_cache *fc,
@@ -388,15 +712,187 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 	}
 }
 
+static void
+__prestera_k_arb_n_lpm_set(struct prestera_switch *sw,
+			   struct prestera_kern_neigh_cache *n_cache,
+			   bool enabled)
+{
+	struct prestera_nexthop_group_key nh_grp_key;
+	struct prestera_kern_fib_cache_key fc_key;
+	struct prestera_kern_fib_cache *fib_cache;
+	struct prestera_fib_node *fib_node;
+	struct prestera_fib_key fib_key;
+
+	/* Exception for fc with prefix 32: LPM entry is already used by fib */
+	memset(&fc_key, 0, sizeof(fc_key));
+	fc_key.addr = n_cache->key.addr;
+	fc_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
+	/* But better to use tb_id of route, which pointed to this neighbour. */
+	/* We take it from rif, because rif inconsistent.
+	 * Must be separated in_rif and out_rif.
+	 * Also note: for each fib pointed to this neigh should be separated
+	 *            neigh lpm entry (for each ingress vr)
+	 */
+	fc_key.kern_tb_id = l3mdev_fib_table(n_cache->key.dev);
+	fib_cache = prestera_kern_fib_cache_find(sw, &fc_key);
+	if (!fib_cache || !fib_cache->reachable) {
+		memset(&fib_key, 0, sizeof(fib_key));
+		fib_key.addr = n_cache->key.addr;
+		fib_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
+		fib_key.tb_id = prestera_fix_tb_id(fc_key.kern_tb_id);
+		fib_node = prestera_fib_node_find(sw, &fib_key);
+		if (!enabled && fib_node) {
+			if (prestera_fib_node_util_is_neighbour(fib_node))
+				prestera_fib_node_destroy(sw, fib_node);
+			return;
+		}
+	}
+
+	if (enabled && !fib_node) {
+		memset(&nh_grp_key, 0, sizeof(nh_grp_key));
+		prestera_util_nc_key2nh_key(&n_cache->key,
+					    &nh_grp_key.neigh[0]);
+		fib_node = prestera_fib_node_create(sw, &fib_key,
+						    PRESTERA_FIB_TYPE_UC_NH,
+						    &nh_grp_key);
+		if (!fib_node)
+			pr_err("%s failed ip=%pI4n", "prestera_fib_node_create",
+			       &fib_key.addr.u.ipv4);
+		return;
+	}
+}
+
+static void
+__prestera_k_arb_nc_kern_fib_fetch(struct prestera_switch *sw,
+				   struct prestera_kern_neigh_cache *nc)
+{
+	if (prestera_util_kern_n_is_reachable(l3mdev_fib_table(nc->key.dev),
+					      &nc->key.addr, nc->key.dev))
+		nc->reachable = true;
+	else
+		nc->reachable = false;
+}
+
+/* Kernel neighbour -> neigh_cache info */
+static void
+__prestera_k_arb_nc_kern_n_fetch(struct prestera_switch *sw,
+				 struct prestera_kern_neigh_cache *nc)
+{
+	struct neighbour *n;
+	int err;
+
+	memset(&nc->nh_neigh_info, 0, sizeof(nc->nh_neigh_info));
+	n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4, nc->key.dev);
+	if (!n)
+		goto out;
+
+	read_lock_bh(&n->lock);
+	if (n->nud_state & NUD_VALID && !n->dead) {
+		err = prestera_neigh_iface_init(sw, &nc->nh_neigh_info.iface,
+						n);
+		if (err)
+			goto n_read_out;
+
+		memcpy(&nc->nh_neigh_info.ha[0], &n->ha[0], ETH_ALEN);
+		nc->nh_neigh_info.connected = true;
+	}
+n_read_out:
+	read_unlock_bh(&n->lock);
+out:
+	nc->in_kernel = nc->nh_neigh_info.connected;
+	if (n)
+		neigh_release(n);
+}
+
+/* neigh_cache info -> lpm update */
+static void
+__prestera_k_arb_nc_apply(struct prestera_switch *sw,
+			  struct prestera_kern_neigh_cache *nc)
+{
+	struct prestera_kern_neigh_cache_head *nhead;
+	struct prestera_nh_neigh_key nh_key;
+	struct prestera_nh_neigh *nh_neigh;
+	int err;
+
+	__prestera_k_arb_n_lpm_set(sw, nc, nc->reachable && nc->in_kernel);
+	__prestera_k_arb_n_offload_set(sw, nc, nc->reachable && nc->in_kernel);
+
+	prestera_util_nc_key2nh_key(&nc->key, &nh_key);
+	nh_neigh = prestera_nh_neigh_find(sw, &nh_key);
+	if (!nh_neigh)
+		goto out;
+
+	/* Do hw update only if something changed to prevent nh flap */
+	if (memcmp(&nc->nh_neigh_info, &nh_neigh->info,
+		   sizeof(nh_neigh->info))) {
+		memcpy(&nh_neigh->info, &nc->nh_neigh_info,
+		       sizeof(nh_neigh->info));
+		err = prestera_nh_neigh_set(sw, nh_neigh);
+		if (err) {
+			pr_err("%s failed with err=%d ip=%pI4n mac=%pM",
+			       "prestera_nh_neigh_set", err,
+			       &nh_neigh->key.addr.u.ipv4,
+			       &nh_neigh->info.ha[0]);
+			goto out;
+		}
+	}
+
+out:
+	list_for_each_entry(nhead, &nc->kern_fib_cache_list, head) {
+		__prestera_k_arb_fib_nh_offload_set(sw, nhead->this, nc,
+						    nc->in_kernel,
+						    !nc->in_kernel);
+	}
+}
+
 static int
 __prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
 				     struct prestera_kern_fib_cache *fc)
 {
+	struct fib_nh_common *nhc;
+	int nh_cnt;
+
 	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
 
 	switch (prestera_kern_fib_info_type(&fc->info)) {
 	case RTN_UNICAST:
-		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
+		if (prestera_fib_info_is_direct(&fc->info) &&
+		    fc->key.prefix_len ==
+			PRESTERA_IP_ADDR_PLEN(fc->key.addr.v)) {
+			/* This is special case.
+			 * When prefix is 32. Than we will have conflict in lpm
+			 * for direct route - once TRAP added, there is no
+			 * place for neighbour entry. So represent direct route
+			 * with prefix 32, as NH. So neighbour will be resolved
+			 * as nexthop of this route.
+			 */
+			nhc = prestera_kern_fib_info_nhc(&fc->info, 0);
+			fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_UC_NH;
+			fc->lpm_info.nh_grp_key.neigh[0].addr =
+				fc->key.addr;
+			fc->lpm_info.nh_grp_key.neigh[0].rif =
+				nhc->nhc_dev;
+
+			break;
+		}
+
+		/* We can also get nh_grp_key from fi. This will be correct to
+		 * because cache not always represent, what actually written to
+		 * lpm. But we use nh cache, as well for now (for this case).
+		 */
+		for (nh_cnt = 0; nh_cnt < PRESTERA_NHGR_SIZE_MAX; nh_cnt++) {
+			if (!fc->kern_neigh_cache_head[nh_cnt].n_cache)
+				break;
+
+			fc->lpm_info.nh_grp_key.neigh[nh_cnt].addr =
+				fc->kern_neigh_cache_head[nh_cnt].n_cache->key.addr;
+			fc->lpm_info.nh_grp_key.neigh[nh_cnt].rif =
+				fc->kern_neigh_cache_head[nh_cnt].n_cache->key.dev;
+		}
+
+		fc->lpm_info.fib_type = nh_cnt ?
+					PRESTERA_FIB_TYPE_UC_NH :
+					PRESTERA_FIB_TYPE_TRAP;
 		break;
 	/* Unsupported. Leave it for kernel: */
 	case RTN_BROADCAST:
@@ -436,7 +932,8 @@ static int __prestera_k_arb_f_lpm_set(struct prestera_switch *sw,
 		return 0;
 
 	fib_node = prestera_fib_node_create(sw, &fc->lpm_info.fib_key,
-					    fc->lpm_info.fib_type, NULL);
+					    fc->lpm_info.fib_type,
+					    &fc->lpm_info.nh_grp_key);
 
 	if (!fib_node) {
 		dev_err(sw->dev->dev, "fib_node=NULL %pI4n/%d kern_tb_id = %d",
@@ -465,6 +962,10 @@ static int __prestera_k_arb_fc_apply(struct prestera_switch *sw,
 	}
 
 	switch (fc->lpm_info.fib_type) {
+	case PRESTERA_FIB_TYPE_UC_NH:
+		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
+						     fc->reachable, false);
+		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
 						     false, fc->reachable);
@@ -516,6 +1017,57 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 	return rfc;
 }
 
+/* Propagate kernel event to hw */
+static void prestera_k_arb_n_evt(struct prestera_switch *sw,
+				 struct neighbour *n)
+{
+	struct prestera_kern_neigh_cache_key n_key;
+	struct prestera_kern_neigh_cache *n_cache;
+	int err;
+
+	err = prestera_util_neigh2nc_key(sw, n, &n_key);
+	if (err)
+		return;
+
+	n_cache = prestera_kern_neigh_cache_find(sw, &n_key);
+	if (!n_cache) {
+		n_cache = prestera_kern_neigh_cache_get(sw, &n_key);
+		if (!n_cache)
+			return;
+		__prestera_k_arb_nc_kern_fib_fetch(sw, n_cache);
+	}
+
+	__prestera_k_arb_nc_kern_n_fetch(sw, n_cache);
+	__prestera_k_arb_nc_apply(sw, n_cache);
+
+	prestera_kern_neigh_cache_put(sw, n_cache);
+}
+
+static void __prestera_k_arb_fib_evt2nc(struct prestera_switch *sw)
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
+		__prestera_k_arb_nc_kern_fib_fetch(sw, n_cache);
+		__prestera_k_arb_nc_apply(sw, n_cache);
+		rhashtable_walk_start(&iter);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
 static int
 prestera_k_arb_fib_evt(struct prestera_switch *sw,
 		       bool replace, /* replace or del */
@@ -573,9 +1125,45 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 			dev_err(sw->dev->dev, "Applying fib_cache failed");
 	}
 
+	/* Update all neighs to resolve overlapped and apply related */
+	__prestera_k_arb_fib_evt2nc(sw);
+
 	return 0;
 }
 
+static void __prestera_k_arb_abort_neigh(struct prestera_switch *sw)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->kern_neigh_cache_ht, &iter);
+		rhashtable_walk_start(&iter);
+
+		n_cache = rhashtable_walk_next(&iter);
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!n_cache) {
+			break;
+		} else if (IS_ERR(n_cache)) {
+			continue;
+		} else if (n_cache) {
+			if (!list_empty(&n_cache->kern_fib_cache_list)) {
+				WARN_ON(1); /* BUG */
+				continue;
+			}
+			__prestera_k_arb_n_offload_set(sw, n_cache, false);
+			n_cache->in_kernel = false;
+			/* No need to destroy lpm.
+			 * It will be aborted by destroy_ht
+			 */
+			__prestera_kern_neigh_cache_destroy(sw, n_cache);
+		}
+	}
+}
+
 static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
 {
 	struct prestera_kern_fib_cache *fib_cache;
@@ -598,6 +1186,8 @@ static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
 			__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
 							     false, false,
 							     false);
+			__prestera_k_arb_fib_nh_offload_set(sw, fib_cache, NULL,
+							    false, false);
 			/* No need to destroy lpm.
 			 * It will be aborted by destroy_ht
 			 */
@@ -617,6 +1207,7 @@ static void prestera_k_arb_abort(struct prestera_switch *sw)
 	 * hw object (e.g. in case of overlapped routes).
 	 */
 	__prestera_k_arb_abort_fib(sw);
+	__prestera_k_arb_abort_neigh(sw);
 }
 
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
@@ -837,7 +1428,7 @@ static void prestera_router_neigh_event_work(struct work_struct *work)
 	/* neigh - its not hw related object. It stored only in kernel. So... */
 	rtnl_lock();
 
-	/* TODO: handler */
+	prestera_k_arb_n_evt(sw, n);
 
 	neigh_release(n);
 	rtnl_unlock();
@@ -893,6 +1484,11 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_kern_fib_cache_ht_init;
 
+	err = rhashtable_init(&router->kern_neigh_cache_ht,
+			      &__prestera_kern_neigh_cache_ht_params);
+	if (err)
+		goto err_kern_neigh_cache_ht_init;
+
 	nhgrp_cache_bytes = sw->size_tbl_router_nexthop / 8 + 1;
 	router->nhgrp_hw_state_cache = kzalloc(nhgrp_cache_bytes, GFP_KERNEL);
 	if (!router->nhgrp_hw_state_cache) {
@@ -932,6 +1528,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_validator_notifier:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
+	rhashtable_destroy(&router->kern_neigh_cache_ht);
+err_kern_neigh_cache_ht_init:
 	rhashtable_destroy(&router->kern_fib_cache_ht);
 err_kern_fib_cache_ht_init:
 	prestera_router_hw_fini(sw);
-- 
2.17.1

