Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6A39445A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhE1Ooy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:44:54 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235340AbhE1Ool (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:44:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZxXgJsus9DOV9+sVBtp+1EFGGZhWQor33i62zxFhmqvIaZcVsK33wAlwudGBQdVhRClWpO4t7iJDPcKym7Ci2rTngAAF5Ewra3Ih4rsi2kN2O5WTeLT84U0qyPmo/ZDl3IZ/2dV/VQmL2WJ9JbeSZa/APkJCzyiPp1Slr+cWw9/hphtazII/5pYijRSXhCy0eqGJygWCgZ7QWgg5y1UmAeBruFdqgr/PYmkLV/UW+iXB4MNjHtAgp9FvzDRw5fHLtFNeIWzXGzKbCCG0KC2HoJD0rTh89sQ4ZM31LDUH5lFIo/VL+7+X0EMvjKuOVgBVQLoph1CFLRQi1f5VXXiHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUdTq9FBXKwTS7l3d4sPKuYg+RYOV36KsxCj/4g/hWQ=;
 b=mlKgTjkfoXSI45pFWZQgLt7bH3+1mrHE/cscXlqv4E7teZSB7xm3S6Cn32rQk097wYR3pYzircCcTEG7hDjqtj2+6vUN0zBKIFyxZSujiqWjajybUNVCWZMqzTcM4MojIoircn25etf4qQVyI52QWZh8lVOeziDTOwz6WtHBNseSu8KekTJ6pMLd51+jS9GAT9Ma0eeX3TF7V211rzW6kA8AG7HDsM5U7UtUCEOlRzwoe4eqxBS8u0+jz1lALQAGGZNnc0nzFiy6SybI9aZyLQexrJDxaI1TjECgHlvg0Fi1jDy4l/kdRI9I38RF2JzaNoNrANC/P2XPcOJ8tB7AyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUdTq9FBXKwTS7l3d4sPKuYg+RYOV36KsxCj/4g/hWQ=;
 b=kzt7cK2q+MIAjIEUHt+6v48BF2Pucrb1yjfq/E8yaIRoJOdS4m8jGfYKh4vyej4+UOjw5VB5D9CPKC0UYMal5Mxze5Brw77PMWQ7wCNOusYSZFzYF02TIidMMEjq421dcOc3qfnxp/pZK3YHTKeh9sqyKFaGBzJ8DN3XKPMNux4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:05 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/8] nfp: flower-ct: add ct zone table
Date:   Fri, 28 May 2021 16:42:41 +0200
Message-Id: <20210528144246.11669-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210528144246.11669-1-simon.horman@corigine.com>
References: <20210528144246.11669-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 712bdb4e-a706-452e-3f6b-08d921e6e734
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB5033BA69FBEDD011A8A88E5DE8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiBcG8g1zAqIfzvFpBn+lDBhMDF/B/iH7bI6lgWGjC9NW1lfgpvyn6vm53avEIUzwHv/fsR0TGIor3havA+PrFr91tJQecu+PSriL5La0ULILAvYUqY7aBt7Ac2Ogv3FLRo8gI7AbeUlZqmMDaIItoEn+wuOf/iQnJipAVQwFCmBGpAqSN9TztIyYA/gqI5qSuQWyFr4HbqlkNPYIhwvuPLqmWp1imlnWje6wtVX8roIje5EZ3XszlcC4BWQF69H7RzfQESGT3FkLIrClWepha6isz6uU502SuspUHaD2puPbjZe3YwDPFsyA7vkaQFIENtPt1OqD+/RQefThSqYUcGTaHscRvjPqY4ak5K281ue15B2u2tjROLc6y3yKclSCzW8ieW4nslQejDaMb3HWbZtth5/iQCSmlJ8wCxROE+H6cXyQX2UhKcdLz0mzzHOwteJGTmlmqV1nliY3UdITNz/d9Kdu42WUF9XQCtdoCh2OX4JtAlD9B9dZcmknejG1kDOKTdXszVPP6uURY+hocmP5deqZ9ppzi0NM9ykVAW3vTSGJaUblUsQS2S8Og9m8xbc/GZyeXhImr9s6XwJ7FbURYtCzL1ACBkHVdem40c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(83380400001)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H6edoq04xtPkMbiZPHABINvsapX43q411/xE7SRZjBdFBqk3k0hp2hmBkp+I?=
 =?us-ascii?Q?3SZjIzic3SQotSEGb29OSWeu1o5/zrrttw+wmfnMBK/DBO7AmtOB2m5xIMAY?=
 =?us-ascii?Q?O56h4/AVlO/Wq1DVmIb5D87kpxQurdS+t79BcWb/o8oAdS5qF+6+jBuPsnka?=
 =?us-ascii?Q?GUlFxPaZaBdz87UKRS3hHjKZzkCe2l4UeLD6aB0xcLezJV3hDaOYniKWqh2D?=
 =?us-ascii?Q?oE0C+EQWi+Ap5XFVEET6Nk6e4GZ47o86geCzbfBnbMB7ObOS7NYWKLs4rpCg?=
 =?us-ascii?Q?K8fMRvetTk3eapD3QLDQIECS/wHYX4Yp5UVkT4nLQ34FuyIURy3MA5d5JrAq?=
 =?us-ascii?Q?gid47EmstiLKPYDBdkoHUhmERUT92PEA+EG6QKCtt349HRyxT4l8NsGadBRy?=
 =?us-ascii?Q?tbxkVzR/uKInYmEW7atgqwYNKKyBT2KDAzTdQbtS9Z6usUoA+6neF0yzxaNu?=
 =?us-ascii?Q?5djNrEON3sbxA/gW9A5fk62CRiELB2tCQoEXmKr5h7bb8579/dssJOL9Rmnc?=
 =?us-ascii?Q?+xBfVF28n2Eq6pxyMbOELoXCVSS2rxY1vPOv0mjuttZWs3JZps2i73yjl++i?=
 =?us-ascii?Q?RGeedjJAlfhKVVkAIx2AjWytdyZAEGc1l/YBxDEgif8z92CP+01jIG84NFBG?=
 =?us-ascii?Q?/Mex2qwD85PUczdnDNHjC3PJ2v2P8Z0yrSsd0B3XwaXgeEL2HXVavV8utq4x?=
 =?us-ascii?Q?nGNrZQWyIiLQqlU0EEVzqXa28GS4EDuv//RtGCjzv/vypHPjD2frLDxLk+Vh?=
 =?us-ascii?Q?QYeOHUOecCJHOzUPho5i3Eus0JDVuWPA4xjXzGbXD9tlEiGDkD+SBaOImSTJ?=
 =?us-ascii?Q?O4kEFamuwMZWkDH/Rf5wrmSWU+3/vvHS6Nr19AgtVCHrCbZn16XjraJ9w/KG?=
 =?us-ascii?Q?ry+lfB0XOb6BsOFYJHjHzfjtfexVW7sh7crJwHbgH0kPqUE4LTdmu53+KJuA?=
 =?us-ascii?Q?CAe58tKkixmONj4VSNqjej8V05gRWDPSkeq6m6lXmzko9CQoz8IMcFszVc6t?=
 =?us-ascii?Q?5j3oMGPhWj49Nhc8GV+SvDkzvkb+rO/PolAq8XSU8Owq27e9nIizrPBmbzD7?=
 =?us-ascii?Q?VT/at8nybf/d5g1RIyvIYCrZyUxr3rLr6XzN9R7iCFIs2aBpJa/ua83t++bJ?=
 =?us-ascii?Q?FfU2ttGT7k3HS/SqeKnrEf5J5zMhHw5UV7PqP4HT+I6On1OY9p3OZqQ242tG?=
 =?us-ascii?Q?bwDizKPs4pMIDF0jw+4yBR8J3nPXspcEMzAEJD8Y/BovFrhMX8fI/h1iKKxO?=
 =?us-ascii?Q?mQ2m4k66IzHUodBDx7V71yd1qnEEO3jg1N2/bun7nhbRllTz5NWCl3pfgJW2?=
 =?us-ascii?Q?jONf/c8lSX/vYACdhj1WsIZhUCKGwjx3XCGeWgDcmFz8pZSTOYdzP+OXgGsh?=
 =?us-ascii?Q?U447A8uGOV49l+6eiSf9jyHU55G1?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 712bdb4e-a706-452e-3f6b-08d921e6e734
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:05.6115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRbZDq6ijA4d+FA4tlrkofA78BZLPlo7ypzvNSczqOjs/Nj6H9fyMvWTXMKSozfm20iP1p/2+lu1x3MS5Hwq1DArug5IfXVO0Jy3T3Eu0SM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add initial zone table to nfp_flower_priv. This table will be used
to store all the information required to offload conntrack.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.h | 17 ++++++++++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 ++
 .../ethernet/netronome/nfp/flower/metadata.c  | 23 ++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index e8d034bb9807..5f1f54ccc5a1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -6,6 +6,23 @@
 
 #include "main.h"
 
+extern const struct rhashtable_params nfp_zone_table_params;
+
+/**
+ * struct nfp_fl_ct_zone_entry - Zone entry containing conntrack flow information
+ * @zone:	The zone number, used as lookup key in hashtable
+ * @hash_node:	Used by the hashtable
+ * @priv:	Pointer to nfp_flower_priv data
+ * @nft:	Pointer to nf_flowtable for this zone
+ */
+struct nfp_fl_ct_zone_entry {
+	u16 zone;
+	struct rhash_head hash_node;
+
+	struct nfp_flower_priv *priv;
+	struct nf_flowtable *nft;
+};
+
 bool is_pre_ct_flow(struct flow_cls_offload *flow);
 bool is_post_ct_flow(struct flow_cls_offload *flow);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 31377923ea3d..b9de3d70f958 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -193,6 +193,7 @@ struct nfp_fl_internal_ports {
  * @qos_stats_lock:	Lock on qos stats updates
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
  * @merge_table:	Hash table to store merged flows
+ * @ct_zone_table	Hash table used to store the different zones
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -227,6 +228,7 @@ struct nfp_flower_priv {
 	spinlock_t qos_stats_lock; /* Protect the qos stats */
 	int pre_tun_rule_cnt;
 	struct rhashtable merge_table;
+	struct rhashtable ct_zone_table;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 327bb56b3ef5..74c0dd508f55 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -9,6 +9,7 @@
 #include <net/pkt_cls.h>
 
 #include "cmsg.h"
+#include "conntrack.h"
 #include "main.h"
 #include "../nfp_app.h"
 
@@ -496,6 +497,13 @@ const struct rhashtable_params merge_table_params = {
 	.key_len	= sizeof(u64),
 };
 
+const struct rhashtable_params nfp_zone_table_params = {
+	.head_offset		= offsetof(struct nfp_fl_ct_zone_entry, hash_node),
+	.key_len		= sizeof(u16),
+	.key_offset		= offsetof(struct nfp_fl_ct_zone_entry, zone),
+	.automatic_shrinking	= false,
+};
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_num_mems)
 {
@@ -516,6 +524,10 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	if (err)
 		goto err_free_stats_ctx_table;
 
+	err = rhashtable_init(&priv->ct_zone_table, &nfp_zone_table_params);
+	if (err)
+		goto err_free_merge_table;
+
 	get_random_bytes(&priv->mask_id_seed, sizeof(priv->mask_id_seed));
 
 	/* Init ring buffer and unallocated mask_ids. */
@@ -523,7 +535,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		kmalloc_array(NFP_FLOWER_MASK_ENTRY_RS,
 			      NFP_FLOWER_MASK_ELEMENT_RS, GFP_KERNEL);
 	if (!priv->mask_ids.mask_id_free_list.buf)
-		goto err_free_merge_table;
+		goto err_free_ct_zone_table;
 
 	priv->mask_ids.init_unallocated = NFP_FLOWER_MASK_ENTRY_RS - 1;
 
@@ -560,6 +572,8 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	kfree(priv->mask_ids.last_used);
 err_free_mask_id:
 	kfree(priv->mask_ids.mask_id_free_list.buf);
+err_free_ct_zone_table:
+	rhashtable_destroy(&priv->ct_zone_table);
 err_free_merge_table:
 	rhashtable_destroy(&priv->merge_table);
 err_free_stats_ctx_table:
@@ -569,6 +583,11 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	return -ENOMEM;
 }
 
+static void nfp_free_zone_table_entry(void *ptr, void *arg)
+{
+	struct nfp_fl_ct_zone_entry *zt = ptr;
+}
+
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
 {
 	struct nfp_flower_priv *priv = app->priv;
@@ -582,6 +601,8 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 				    nfp_check_rhashtable_empty, NULL);
 	rhashtable_free_and_destroy(&priv->merge_table,
 				    nfp_check_rhashtable_empty, NULL);
+	rhashtable_free_and_destroy(&priv->ct_zone_table,
+				    nfp_free_zone_table_entry, NULL);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
-- 
2.20.1

