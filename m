Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5749B57D6A8
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbiGUWNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiGUWMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56C2951E9;
        Thu, 21 Jul 2022 15:12:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBuuYhrzQgeRnoIevWckQIWL48P0hFuz/4DFR5jY3eMr8FgUq7A3QM2zk2duRRjCrAwC3KtLuL1SLayo7L+eXxTEUGIiSM0DKXZdS1aBUAhyCDj2wGrgVHdfEmbi6sIujYAOF0gyh6WnBJMYHOzocFQy6qmryD/RbEr9bHO9uD3wlHo4KyYIeBiS/V50x2G0fFozsMh3snURrnw0/FHKd5gue1zao6iQdaDFHhJCzpqSGxPycdr59suIKM9aCgDVOcJ/JOGnVwd6/NLHKk35BeCiiMAuM9XnN8vAKmR0pu/95po+1H+QcYwznCjkpzP4B4ujgdJNy2XsAZLXmKEw8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mVs0dfCYClcABnNs7EdJzFP2L81V2Eviq5nqIX5M1LQ=;
 b=QucSbIFeJkD+ITFIWgJngdHSx2rg4Q+0HnAtEcisxUYRyA8t9/dc3cUkwLV0tcI5J+fiURbUbL4jKXf+hqIrGaIilw6CskI8og4uc76vnUw7VgzO4psdabJ2j449mg85W8pMekolKk5caPRBi2BA3Sdt2sTBNHKmo9Pftptbg5kDYJnrBiH1TAKYJSyQOTQtd02uUWe+/s4sWVi2lLsrmYvCF/4awRb+q7RvHGD15gUjy91niLUoJtH4/oqYrd/ftaaxcv1LSf71593YFWvOUPuj4SaEVd6+NFNSKOlsXdW4MJLrRjgSrg4klMt7UVKfsdWDyrtZ6PCKkuEWv+MYUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVs0dfCYClcABnNs7EdJzFP2L81V2Eviq5nqIX5M1LQ=;
 b=gZ8zLHJ5ZtRirSw5XAQYbSf1bMkHTiqI3501jL682wes4joOg2qYeroB2hH0TchfE7o0jc1a7FwuYfIWXP38CwmH/nVi36nvnrlL/rdznMILZWGKHHDfjIf+LuL3OfCECqr4uiqB8H11mwrhlBUF10LwjX7fK7Km/4mkv+cQMkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:14 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:14 +0000
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
Subject: [PATCH net-next v2 8/9] net: marvell: prestera: Add neighbour cache accounting
Date:   Fri, 22 Jul 2022 01:11:47 +0300
Message-Id: <20220721221148.18787-9-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2563d25e-e284-4a00-5b0f-08da6b66113f
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vhGoPp0vw7sYmhqv9sQbJ0vJ/LtgxvjwPBffv9RR//TF3ubp2FmiljFW4oAXKJcPStrcfW2ik/X1Y6P8ys4Qa8Mk9TCrFWDRQOt24MvVHzlPYe+ymA5o5wXxRrtbj+rKu4nRYBjh9vLguuR/pyA6yrwIqqkrwpEGfcekJc8SRb439z1cmVsueRVAV9nrdpBSiUqvJM/89xEu94tGMQwYsSuGaV/tU1hxmwNs+RJvyhyT+TPfnYzd4UhxbDe5Dqne/Mj1qEoWX4RMNwmT6kpRBgnS4XxYG38AXoaGaUKHjxVL1Givz+iD0b7HUnWQ4KVTZ4ym/vwtB9JuC96n40bzrOCSDF5jWD0FMSMzgQtjmLpr0tFLWBfWFis+rPvG7rzIFPGMldDCCZw0+r603U4s4UDu9CPXF9jlTC5F1LOA2OIoXkaJM70bOQTT7+bjG9pan36mdgQzZp7McgCPjYS1XcCHbnZo3ICptrGsh9iSOglGm2eckkVtvnGM//PIMoRCZoSGLxO93NTUwkmVJDByV4bAvFKh4vvBgnteP+IBaobVwfX5EfeExhqJciqrTRg0G9+HkwgMNfF+RQQ0hXRHnq/nalCkBm1bRCsNJX+UHeP6YvCC/2zTQVggD5A3v5Jza8a5COar4jflolASIutASGTh21AATUGJ8RZZqTDQpakAKZ/DB4jZOvBdl4DqEjiPuWIwhCTt6wzuvzS4YCUXoMQb1aoZe4HsWhsZ5U3e24i/2e1eG46kmeJo0XTaXVRxlraiOt1Txuipk+Pa6DOvWRZwF+aRcxIzEnRH9ZTgP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(15650500001)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(30864003)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OQnRtu1IRHoavAA5ab6Tu2prYB7mM6gd9xl7JClFzU62KABXU3MT64ffOgca?=
 =?us-ascii?Q?M1QMVZOeU+kkAInxYP+MRWXjugALjgpgV87QGD1XqRyejXkTFfcOAMe+CAtf?=
 =?us-ascii?Q?pwkZ0gH+sbG52IbAbcELPHg5ZFcMbZ0SeuWahLpLIRoWypGRQC4ibBokPOz5?=
 =?us-ascii?Q?n6ahg+MGxwUGQT02fCKgOcCpVccrAhqBSswBoIBTtqBAkxVbs+pOWMTQR+An?=
 =?us-ascii?Q?8QrEzN5rp4eXeE+MCVcqPOAhIGS5xp76pDg9t7u+de+c05wSL4AxWQ8dVskS?=
 =?us-ascii?Q?v5xu4C5uUZnOobJaFMzJ21jUukP1MuiZl7VzULpwwC49nVnjh4Yf4W6S6D9S?=
 =?us-ascii?Q?ZbyM8GyDZX2yrn4GJpZyCqoXSgwHsNFU1Zk0MZLxtY/Y9gppFgn8ifX0lb5q?=
 =?us-ascii?Q?bd5UrNTogQ0bIf22kU11Of+cMAPTMKyZcK92lGig+fuvJTkmyx3Z475RKr7w?=
 =?us-ascii?Q?3aF3nw0qKJDrJhJbePtyKWLnS3Gt/I3AP9j1TqGu4wIiGmWchcqmvJ6/m6GV?=
 =?us-ascii?Q?RttPWiNVQx6wK0GSyxuarvsx9yfDCmKzJS+epV8+J52n7QqKV7Jpfk+mJHQ+?=
 =?us-ascii?Q?XmNC4XDq9ndqakKoz+X12q43JLxYZv+jUCryatBvPnXSwR8vPwrj01tNX3Qt?=
 =?us-ascii?Q?LZ2mrghlc8MlCWJNo2pL5e7zoF9iaxnQU7C/5uvljqS5dP+5myCYngRC+htZ?=
 =?us-ascii?Q?kRcsze49v83kWmEhGJoLo7nSDw0ACXZPmD0wkG1XnDIFHyQBq0B9cZhU95ON?=
 =?us-ascii?Q?EyfX5E2ONPQ9VIac4xUifAjw59M1ZLLEj7Cvkiwx/w17vkpWEdGtWP6HTFiC?=
 =?us-ascii?Q?1rNkc2oMNL33Nrni4EXK5G/N1Zrl5szM4i2PVgiGdoa6EWxqFif/DZGrhBfl?=
 =?us-ascii?Q?s8ezfcZBpuHvSBs1QjMWMGOBMUry8VJQjHohQp6sniLKvShjPmDc+aCZIOrf?=
 =?us-ascii?Q?DfpHDni/6q6YVCFfP2m7vnPnubovlRUQCKQXlzOmf3WMIdiF4rmYtq86LfCs?=
 =?us-ascii?Q?ujm0u+vnF/7T0R4DoxVtlDh6UQ5nsJAfJ0vFe7ePhbcEKv/Fxj0YybbKz94U?=
 =?us-ascii?Q?bkZ1+OwqHUpX2DF/5un2WVC2PxX4N1KyCqedVmN8pjjrJZw/iHNAr47e/SkJ?=
 =?us-ascii?Q?7ynLvQY5p2cv6NvWCbTn26RmyJZ9cR52GbcqVs+2ngYN/qzgEWIUWJ369cmR?=
 =?us-ascii?Q?1T62B4Uo3Iq+fWgz/f1UDulKzsrDugVFhk+aue/eaSfrw0fDjR9EN4lvQX1H?=
 =?us-ascii?Q?6RqVgR5hyulccTr3ZG+IiBeKpWMjMiXCb64MUNIhZF6+2UKeIl69G+Jjy+01?=
 =?us-ascii?Q?PkmbDfTMyapI9Fdw33gP47PwB0Nija80jCEhXXe/tUu4Dm2qvz6GdxRboZir?=
 =?us-ascii?Q?uu8KpdTYqd7a5curck7nL1pdyIxJA2m+gXHFjkmr153Js4BD76IAYjnCaGoZ?=
 =?us-ascii?Q?7BwCNgc2mRXSr5bNQjSx57nXiTn0TeHCDqElh2RsbptpYFK6Z8XQh26XhR0G?=
 =?us-ascii?Q?5XZ068sUAup/e48YgwbeO4OzHnJ+0Odcs3Z398Tcrn3yEj2bUXJTiUuTbcY/?=
 =?us-ascii?Q?3QI4vZ2AVdDCqlmN42qJell25myUCVo8I/mzEExqKBKlvkRsB7pUd/9B7wFq?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2563d25e-e284-4a00-5b0f-08da6b66113f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:14.8265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwwxITpGf59pMCYiCiByt2bc+vhJsTVm26QuS+wZTl1FkAU2Nve5gcUnnNP5zcRudxEDv+Pe23G7cHbcvqklULNrB08QldG1P+Zhc2l7+HU=
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
index 33a0add529ba..8cd934f7c458 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -306,6 +306,7 @@ struct prestera_router {
 	struct rhashtable nh_neigh_ht;
 	struct rhashtable nexthop_group_ht;
 	struct rhashtable fib_ht;
+	struct rhashtable kern_neigh_cache_ht;
 	struct rhashtable kern_fib_cache_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index e35ab79ba477..292201290f04 100644
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

