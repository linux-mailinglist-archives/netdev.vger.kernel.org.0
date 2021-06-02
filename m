Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722673988BF
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFBMCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:15 -0400
Received: from mail-dm6nam11on2124.outbound.protection.outlook.com ([40.107.223.124]:2142
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhFBMCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zbga1k90hgcLqrbJrh4K4LGfdVLA+ziZGmN9M4+aeaTCzRkNTolGQgdL2H0XAh/x8LMwbooT28Gro2Yb7k8+D+VahJwXXsDYMBCxz1L92QzGIwLbwagODSRUewjgCCP9E9pCznLmD5+Eegv0R5cOvIywxQ92Is41FEvt0L7qVv/AbUXRxKsMLRcvj9vlcWJp1CCL0uMolHPJKwrypA/9vJEnBcNDShIC1cGMJiff5MPz1QLJySTuuRI6b9cKX1YNnGnCa8aR8c/4NPVUcBgLQzPXwHqzp8ByhBYcWYAWgEfYXMQMfY5ir6KGrE5VpRyzuvVMb6iIJ2Qg1FLIxtp36w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcPkcOJ7LLyIpdJhlg7GOENpE4afUtzxsvURmMpaiDM=;
 b=SBVWf6Qeo4Wl8DDYzv7hsTyRmvSEDKbkRuZVPRDj5Byb+sZWX/0bd3N9Yx280UmtVp/1M60gDgOiEEWRab0tJNqG9/ogJ05QG5S2SoR2G8REhbQvqoANo0Co+v/jTqoiXLHlMuPurktBLaPofPjsNAE6xY8hRFh80ekLRle3IwJv5IlclHSpWU2C/8x+u3+hpDVojw2mr+/jnZCA7vRyoW4ryF9tNr0x91pyNJKM7eK3vql0rJHqknNRrhBqzCONQzlO7BbYzqYYYyFKzl884uk8MqMsmYXhIjtWpcFbyiZ3vlVr/AgQre3guJZt3JklYhe7C5p8F2FodUk33nvoYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcPkcOJ7LLyIpdJhlg7GOENpE4afUtzxsvURmMpaiDM=;
 b=F5ekgNDLvzCHnaPUagD0BlhOPAjcXglVmhy9+cKuVp+MREFJ3lWQDivtIeZxlet2Msd3UzU9Dc/t7P+/pY9vIW51AH1RHG10JZxk/F54GoMZOrfm+qHwpXyiavmAw4893BFCJRQmTgMxMJarJjS1GK7Jgrww28f9HfAv8crXqpQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4857.namprd13.prod.outlook.com (2603:10b6:510:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9; Wed, 2 Jun
 2021 12:00:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:18 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 3/8] nfp: flower-ct: add ct zone table
Date:   Wed,  2 Jun 2021 13:59:47 +0200
Message-Id: <20210602115952.17591-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7633dbb-6c1a-411d-53ab-08d925bdfd2f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4857:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48571A7304A8CD4355841F97E83D9@PH0PR13MB4857.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mvTXfY0VFy2gDnX+7jfB6GI2Q0JbRs8OfZ9cw4EujuBxnNgKFZ5rUYEZEuuVihiqlb2IVjG+QeWlV0N4MJGIvUYaqBf7caBLhVezKiWiY+r9GjnbIvASA8MPDyOSSXIq7ssiI2UoVou0LxXzeqhPCmmj9LRpejVHjz8u5Ky7cj7cSp6PVXUVJThl5IL3KfhoOVDE6isOuLSDgrSCVIJY6kTs235L6EsyMJTYKign4gJQEvMxW0NapZcxgqX3+1pNoWIUCGhjnzsdSfoXSq79YqU8hhihSNXVKvCR2MYe+MB8xDUuhBBP3T+O1+J1GQOO+MVDDKmG4yXhHN55dCQnv1wKbBlIshZK7w+zzawl5Yo1vo4mOrCpvrs3zKVaHlXgMPpicoCxYIrItg/hxbY+QxeaWAoJcuuXmbjvMd3+pxoZ+gkDwnNwU1Rm/BeD6T3+sbkgOW+TQYX1n02bGKpcGBE+MRpTQDognfW5S9/ayVSdC01CRiamcJQ8rsByQSq+uyGq21EEuawhGDdUciOAFENrZw1ZbaGoEnyQcadtcCXh62DxZpjmA+dFJaGLl0obIqkINLXU7K/HCnky8AW+hbpJ3ISq87Pvc+lynTw/0fI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(366004)(39840400004)(6666004)(54906003)(44832011)(110136005)(66476007)(16526019)(2616005)(66946007)(66556008)(1076003)(478600001)(316002)(86362001)(6512007)(4326008)(83380400001)(5660300002)(38100700002)(36756003)(6506007)(6486002)(107886003)(52116002)(8936002)(2906002)(186003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tiXFNhP3XA+2Dm2k3FdxqhvCgdITo3NkMPafo8el9zQ8M0Q05UWZfIW6PO5X?=
 =?us-ascii?Q?+UdiJBgC34IXJWnX5gQTXGI5lExTxroJ2OBMBy3ii6gixE0BXmjyhDxlu4JN?=
 =?us-ascii?Q?8jFu4xIy4z0Ng24Jl7/MAnKYTz5+r5iwUtxUJUNRanol212ytIWt4yGX0Jp2?=
 =?us-ascii?Q?ddKUhl6vFqEo129HcLt0wnegWCgxXnBprvh8kIDqUNDn0Ko4rhzo2fHYe7E5?=
 =?us-ascii?Q?4WInuCbD+Z0LenYUARkmFfeGHE5NNdTWzcdB+RjxCDSwjq3jLCEMd+LP5yR5?=
 =?us-ascii?Q?GAIRoh0bYJLDfaIb2GYQng9o+P6ZoLR5+TuLeopxY+ptNvXP9eiW9IarQpZH?=
 =?us-ascii?Q?MEl5ES2pyQO5UAj0fdrUNMOUqafgK0XN0NTYLgkqadldoy9VXDXn2Or5go0p?=
 =?us-ascii?Q?povTLt5bEsTE82Dw7qltCzA4ZLIvx7p1nrz1pDyIvzgjqp68R2SknRQhZRLx?=
 =?us-ascii?Q?aXz4M++YgiYMrMeAEtliJ9WKFv+r1MHClLt7cXyVXgi0iNLGbwnYAO3OKKfo?=
 =?us-ascii?Q?ANEK+C6SxBdo/JjnL2E+2mWkPVZX3v0MbEYFIlUTHc/Tys4BIzhjlaKvkFye?=
 =?us-ascii?Q?+z+MfqULzP9i55JSPL1c7DWfwmc0m8bvdBNAg5ObdKTZTN65Ut5X9kMMnjPo?=
 =?us-ascii?Q?y6aRNYm8stuaSH2RYyyZS4ENhbXcqj8Xm66U+B4S9s5teSk5dcre53cNWjF1?=
 =?us-ascii?Q?twV6XASo7xQ+/WiUKLZ96ko44W8Sg0reYmjjuKwzoYggpb70wfY/woixDpRE?=
 =?us-ascii?Q?iBhJoBC1HTCQxu9/ArPrvtH/uhtmZvNEZ6aG6ENL3g9Uctu/zfqClFnJJod0?=
 =?us-ascii?Q?p1mLXS+fYSEGcv++ehUOYnFUK/uQwsP3sZRRPFiUltV2N1IUDfuVqBMPs4tq?=
 =?us-ascii?Q?ikVX5PRePnaKtpyEZ9lM7rIpcN42nFbChHbXEvhx+iXCGPE5nzF6Y18gjK3N?=
 =?us-ascii?Q?Wr7ZVMGp+QNB608B8Ol3nNIP6FDJ+wQiiI2UWIXMN9FSwRdZjFoYkm+L7fYM?=
 =?us-ascii?Q?UU8EVroF9yszLvnOQbuc0M+tw5xfuz5gdcEh6JQQxK9M60s69NhFXtS/jVkS?=
 =?us-ascii?Q?u7RNKRoKsZuteHJ3jQywFR47n5TFivipnyIM/5LlEsRfPkQQw0v3lnezRj97?=
 =?us-ascii?Q?RoAsToRnyK8jaSI/+5tF+V/xT76Y7khJfhGTVaON7OhVS6mNuzBDhxjQufb5?=
 =?us-ascii?Q?pKm5L4QlLENmURgP+8tCRhhLbBiVpiVaQbYAgC376YyyVLA/991kQzj8n7hg?=
 =?us-ascii?Q?RrKx3NF54s0J7aBlI/w8JutqCq+8o+1AFhUjqFGNG1G3aiVStsdd/xuFHcGD?=
 =?us-ascii?Q?dZxViBfoJMJ3miWZNCDDrLhrzCA6bi++6aPL2QdLu2PMQBxKaB80RPCUBv2Z?=
 =?us-ascii?Q?Dce9hK3W+ME78i2c8bGXTFFYugoB?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7633dbb-6c1a-411d-53ab-08d925bdfd2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:17.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +v2UiL41NJxqHS1YPrhzkI/21L2uTpVi+uvaf+7m8qEdekSnLDs0KpfbsUJrNfa0rdNYAUGbJeeSc0h91Srjp38S6tqskrWvrnmrxHpNKkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4857
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
 .../ethernet/netronome/nfp/flower/metadata.c  | 22 ++++++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

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
index 31377923ea3d..0073851f31d7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -193,6 +193,7 @@ struct nfp_fl_internal_ports {
  * @qos_stats_lock:	Lock on qos stats updates
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
  * @merge_table:	Hash table to store merged flows
+ * @ct_zone_table:	Hash table used to store the different zones
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
index 327bb56b3ef5..4a00ce803df1 100644
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
@@ -569,6 +583,10 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	return -ENOMEM;
 }
 
+static void nfp_free_zone_table_entry(void *ptr, void *arg)
+{
+}
+
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
 {
 	struct nfp_flower_priv *priv = app->priv;
@@ -582,6 +600,8 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
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

