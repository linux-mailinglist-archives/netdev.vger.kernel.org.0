Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DCA395AD9
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhEaMsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:48:41 -0400
Received: from mail-bn7nam10on2126.outbound.protection.outlook.com ([40.107.92.126]:16736
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231416AbhEaMsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+LbptpY7hluQHFTiYPdPfxtAxSeqa6K8QQk7fy/JYAKazXxi8gChXALvgobg25XP7HyfQp6tkaQtOAq6MD9jxedhasFW6tXR9BzdFkU7ACQfu0wHRf0SHRR6DKLMV+Pyt4AK5Q0v6hwZSRXU+po8WsXt6TFPNP47vt75V9Iu4oYh67JefHrWJab2eTRdjNVQfqUTvcmEnACrJ19R5K6vaWcHhR9DccT88Xbvy1fKUrcac4mjT9y94GpFjiidc0S+xhdB3shUrVhS44ZtlbQBVkQnIFT6D0AYAzQyHKdwR3dwOgac1lIf2qUEuP8mU6rmyzCQN5eVBymCeG8Ah8YUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcPkcOJ7LLyIpdJhlg7GOENpE4afUtzxsvURmMpaiDM=;
 b=eLNNvvlblseNqQrpsOODEaC2I5/pOvyvLgYlI3/JIMIFt/IPAqsXbtbHtw2Lraa795JGYN7jHKx19QrkQWOgkjHFe/j/RnuHYPZeCR7fDjvU7ftS21l6M16dur5S4geyTNLdFZluPHxBddVKtzLFhKQ2c+e4/CpVbJvr8ngTY73o7U1X5iAy0U3GdHL9N1soBdzGsNZsDZ2tjHBafJLh6mGErJ4ZDyW2lwLL4KBkQqq6ERzd5RLb/JbfCvZ0+JcN02pzVV4OICRmL8mvuiwfIVtnlSaL6yk65dONT8Ocr/lX0DI04rnbBOut2Y0dNd8GQIZr/QC98FS7Q2xslE0rMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcPkcOJ7LLyIpdJhlg7GOENpE4afUtzxsvURmMpaiDM=;
 b=a1en3yqnm3Gd8wVr6W1ujMOtIs6YdmbWMnEICHnKh0IZrIaLPMr+eMxbLUMW5yWAfkx5WvvHXFM7ym+qpp1NCuscnH6q8nbk9HRDvhNJt59AFfV9CBKMm2UlGRk813RBazW3mtWAaHeS7uGDNUuqq5WPNB8j63sCcLkUXvmMXNk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.17; Mon, 31 May
 2021 12:46:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 3/8] nfp: flower-ct: add ct zone table
Date:   Mon, 31 May 2021 14:46:02 +0200
Message-Id: <20210531124607.29602-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531124607.29602-1-simon.horman@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2a4d611-ba9e-4407-4f35-08d924321d9d
X-MS-TrafficTypeDiagnostic: PH0PR13MB4876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4876927934C84AFF40F05E02E83F9@PH0PR13MB4876.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZD0NQDrIYb4N6ibx9Tt/x8zhiPWNNr1mayhYpuw2eap/dz3hJxWCYK64sWxm5+uzwH7ej6V9GdTQJHANjEgzb9s1UJemLGqRiFbDEiawhXMU7buASnMDryN1xZqNwkxuhf2IHqFNdSH3+ws41cAc30qmqRl+wh632M8mdp8X0+j3/fQfbkrATK5w1N/Rn2Vqq9p93m/7EU3LkrDlPX3mTD/3IrvSS0kITUTb+chv52OK+5agBHZyZim+6WnNToISSQyOr9sWXydHvsUU1jk48iNf2iD+56ATMglYQl7M9iTnlln6c4bDphNfH6hZKWQwC9OvCQD3wgvBrQFWgpV9v4wIc9h3KkB7vaC2G5Cf43JOxWXa7FTJ2bSOnlrkR2YHoZWUFZzxeOFhTgo5CeRzA1JfATpxSjyfM2rMeGORIYma9w8b5KXZ+FlBQwJJrHJTBm8FkIimIlSdLZipPn83+7m/uqfcTuT9WchAqhHWqEp23i5wj53bW89RSLyV1wpOf3s3iFH6V/cx0v8a5BsppsAWmWzQ9bHTUBDu4aMe90E58H46N4CAgS+hwJVIm/y+xPn6civ/yIyRzIn/75J11WcXO+3YOzCZFMG6UMtLHDY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(366004)(2616005)(6512007)(5660300002)(6486002)(1076003)(186003)(86362001)(36756003)(8936002)(4326008)(478600001)(6666004)(16526019)(8676002)(2906002)(66476007)(66556008)(44832011)(107886003)(54906003)(83380400001)(316002)(110136005)(52116002)(38100700002)(66946007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5fuPbLJGGPDIc/Tu7t5P3Pn3nTmg7E62cwJmajnUe4L/nvqrevJVY5pGEIs0?=
 =?us-ascii?Q?9xON9RAF5QH9hsy3BHyNmAtmrT/Ab++fLHGxAhAURN7a7fk6gA29sbAxwhS9?=
 =?us-ascii?Q?aGkks1KIBwbKX5rfJW/G09BEQxXxS5wxj2eJ9Y21xkLdQ8r4LgMFqPUu7Rjl?=
 =?us-ascii?Q?H0eJKBuGDrbKca278LE9PS+gtc55o8LCnuJcmfO3DdhGX9L1uI+pUt5tDCSc?=
 =?us-ascii?Q?kg+1rqlk06N3pICLzthlTlxoKi9jvxIJmqKeuMjHl0oRyVg7JYYsDDSv+DTz?=
 =?us-ascii?Q?0D4oJTZZDDiJdoKDlvjP49XVdOyUdWpj6USiq2lYERohZqKjyajKwH5ylRdz?=
 =?us-ascii?Q?ndbimvPAe762agh/jI/HzcDCbZ+U9crVnb7nz0UDzy8PGx140IGXMs3wrgZ4?=
 =?us-ascii?Q?vF2p39ciaFxRBwj64uqKTmuaRTnZaeHLTeFZNiSH5y0/ghb1n1BdY7qbYWpo?=
 =?us-ascii?Q?rfMlq6QfPEkUVwuf8Vhsu1bFzb8YRNJBCmw5hkzOEEs6nIWfzaji32CGzGEN?=
 =?us-ascii?Q?wbb/7+082CA64BxxoIP/ksepIaPf8p9Ytbdwd+Oi0Ak27BRli2uvWv2hj0ti?=
 =?us-ascii?Q?CrxZvUNGiOWkxxDW+/wb245I6LatrK9A+YPOyAj7YFqAEJ5065W0mrC/0/Lx?=
 =?us-ascii?Q?COmYnBtkF5ePCp/FQ4PFhs7XACSPqKgnCwQgyzGy/BmqNZREH5EPLNBwZoZe?=
 =?us-ascii?Q?0Bxpmpup2/iUaHz7FmpyxjyvAvYP9NYZGR3eVZImLFq2nOOdHxNR9JekBUlC?=
 =?us-ascii?Q?vWYvdMPSJyjaWvbG0Uyi/EuPbgvp01i+Y86TxebmbdYVeB5PUcXrxU4VA411?=
 =?us-ascii?Q?zgnKkHJiwU0YUUFNVEvPS/7FfXwV14pCXS6gC2AH5paky2v3ttg+bDqBwoSt?=
 =?us-ascii?Q?1J1iAUH5UIcQTmt5s6/d+6ks2+B+L9LNQDsl3m+64ewGGcsRePNZ3/OL9Up+?=
 =?us-ascii?Q?50MIdWAqD/lbMU1ICTv/1Ht6+nq8WWjzuYEbpnOrEh/S2J/OkiPxELKMdn88?=
 =?us-ascii?Q?XIehuvfIuvymCdYwR2I86cd5RBY9NdpgKpm4zen1ezZSc3XzyQPEY2EfFu86?=
 =?us-ascii?Q?9nvZicAWNojKl6Epue9KmejaGq4JSDwp+ho7GFtWDwqTSXtVyT+Mj45ivb1E?=
 =?us-ascii?Q?w149NdtMEbcjmA+N9hz0nU6LFL+5HNxhvZeTZYSR9uH7ZS/Tfim7kpa3Ql8n?=
 =?us-ascii?Q?310saiIVlG6QiNiGTnaAT7scVjsS89N59pgE0FIGOwbMC7ikMQ+dIUWQPAud?=
 =?us-ascii?Q?qxhjlyjw+eri+RWOnFYb9poiIisgVuLA+Wihc3+JbqlYhO0vlY7LHdD4x77G?=
 =?us-ascii?Q?+liyv03S8td3T0yYFudcD/8Yxe7toiimEYGvVoAuzhbcljQHhgABVe0NkpZ2?=
 =?us-ascii?Q?EMkrLSYf7BCt6wDrQYLSj7BVUFn/?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a4d611-ba9e-4407-4f35-08d924321d9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:31.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhtYj2O7voV5W3qAqV1WAzlWDDDshj0x41L33gfwLPkE5Wwyw0f/Y9dbgQuK8fzqnuQVw4aOabmRCEucFZUALUefgrhSkbPSRCk/xlP/dqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
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

