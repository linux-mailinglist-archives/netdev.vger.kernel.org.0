Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E22D39445D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbhE1OpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:45:23 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235788AbhE1OpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:45:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhCk8HTDkuG7zZ44L4DMO5XHsm7AFgRoirDb/GlI+9QI6ByYhc56IpJduPDs8AW02Ju4dtjPR/kNeFbhzPlYsmrggVnWoxAjrgAvaTzGYvoiYhxLMm/Cxro9kvvAkqqJJZcth3Fq5pASNNE8x0Fm1fs4zR3ZeOnemq2Jl7Sd2KIRAXxUmcGa9q5XcfdnfRg1g4biAqvDLwIg/NvpiDr98XX+AH+j3noMH6/f1isNcOfstmnwM+FqaSsOCbrMXBFUDc3NqANDQSwFufoOGXB2Mb2tXGYDBfZI3zY7k4G+KgVnjdinyJJq2elXjhcp3mCZ/A/JasnnJApg9kqpG2UGvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaA+Iww87PhTdlRJY6iK4kwLX55b9baqg0g6cVvsxcs=;
 b=kc6BfRF7iNvVyym+Pusp1cCtl987KsV4rKgp3xQ0lrxkjZfkOVwu6IdLrajW8vrvfh2imyWv+zcTlmrgkpjWbiuQy7+uEkUXkv7iHPQ58YJuIeAODz6U66g7kAXz9uguv96s4XBRSb4SB8sVeZ6kOB2uDpfVT3SzlU6nhsFtMN+QbsN+KQWZAMOsztt8d0XWAtjLk/3S5iUo8Sznl75RjBJlYWMVMsEnA3YdDIW0Wez2UnUsh3AC3FkJ/4SxCDZZYEaXZNi67OntAre91tnQQwRZyDH/T0nO+uiEJeaxJbUyN9/2HDlF3pCaUC50iDXNq1PRv+hAvxI+DExIFrB8eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaA+Iww87PhTdlRJY6iK4kwLX55b9baqg0g6cVvsxcs=;
 b=d0AMFVun49MUwfqLQwB3YwF78pcnttRi4Breob9CQH1qzG4GBckCrTMAWb8aHTYbJokExEEj4jMDJ4cNVX1PAtup0/RsWNPjzQsozJyJbghS5nuviZNTDpW4vjllXDsCHJsRpneARsQAcFKMVRE8oW/C18JiRjzh7YVmYElJTHc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 6/8] nfp: flower-ct: add a table to map flow cookies to ct flows
Date:   Fri, 28 May 2021 16:42:44 +0200
Message-Id: <20210528144246.11669-7-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8164a26-b493-4191-735b-08d921e6ea4b
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50333EF29579B32146B1CE16E8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fV+ZogiQ55kkNJWBRsvgt86mNHVwbzG7YWr6FwqfYTL3oGWX2dn2P1whmpA/rr2sINfONZd2v4IEIxHbUAVaKzj6r+PrxvurZg0i+QcIXkSntinfo/3CQJbCPtO+eo1miC3xOwkqOYHyLjSEthGCqS5V6LJmdOPlSF48WZzbCygLOIhzca8jdxkrKzyztweHUgEbsUZEBUdYTkXckgwxIaXTcbt5m7MxEceg7tpKLkzZl6d+xIlY3W+0FHywhMm02ADrPkLp6zQuTF7DSas48PsP/ZV3SVo47KVmPPhP5SCaBviP2tlON7bxLwMzUR81LJP8kbTEq5U+HLA1M4+QVrMZzSAnZSTSh8OzWaDTC6D5VE1XeRVfIIFD4adrirHs3cJjfIojdovJbX9Cc3hN32I7cJu9we3FihJYFt6CTesNZEJ//L455yfYSk8w7UjaN5YEfwEBI2CrkeB7z8iwHWvZ/fYVvOPPNUgbpMwuPeogWQoxP2ghU2D6tK2pj97xAsXwE1Gk0buBZuedJCY4gKwtojuOGPYZESQjOeKitNvjVO7z++BT2spQ6h8febQz1eBapbCkupUMSlMjQD/wiXnB+cxFX6YyG2igMCwzj88=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(83380400001)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1BbmT6Qf921JmMRuebYaaz6PGRZ86w7DiK1favoANFW9RFc3SrCsVz0Ox8DW?=
 =?us-ascii?Q?cQnDGPos9KpxqaYI+hybAlFh5YHH6x5cU+CWBUTpvoGiQwfiAGoAQsolIQyM?=
 =?us-ascii?Q?hR6zRa5hZLvZK1/xF35ZOzrCbW2pSebuptjnN23DCD5mpzxbAotSu9meYkpV?=
 =?us-ascii?Q?TjNCFwa3+tih3LXvzkpIvl+26ZlpRpGTQC6zaQUKJCMgD43nCF4H/L2M0S2X?=
 =?us-ascii?Q?TEHQjl/KMH8rPZE0ettYm0NBCZ4KtQJadDtdJ3IdQpzYtqcIRxAEkg2ZpDNB?=
 =?us-ascii?Q?swJlSyaVdjAcA611ruMqIQgugbQqF2+VD/EFGir7TD1Z++X0uhBy5FBG1tqT?=
 =?us-ascii?Q?KY3nZPbJqBAa2q06ujgQmYr5LwF66md/PdLKl4Tqj61JuC00YItBtjBjkjLh?=
 =?us-ascii?Q?cpgMv6r8zIOqT0zAOkq/loSOfzu5bN3wd+TG2acV1b3NTWr4Kzn9H8GwCqif?=
 =?us-ascii?Q?Ebgl2tWB8shmNQL7M0ZRhI5J6BxIRteYUoYZxRmxAZG6IhMJ5SHGJ+7GRHjW?=
 =?us-ascii?Q?A8TaEqTOS0AqEOp6zJ5X/6pGK8g6Dwe0zYMgmAkcIKOgCcWA8VQ3NAcujlRg?=
 =?us-ascii?Q?VAUPmBHi3F8FqFmvks3Q41+zHfiu9zpORK7oJtdWV5gRtjJVyErP9nDGB9ut?=
 =?us-ascii?Q?qXiZT1K4ZXHMjKVx/kgjtvTthIBSJEDFo1n65icB0dGjeqo8uAjLAqzI0/Pi?=
 =?us-ascii?Q?7gMjAi23ea3j9nUqoRb8Cv7dOrBPdud2rHJh6kfE/iIFXWr72CIDBmKLguHe?=
 =?us-ascii?Q?UqqO0P01OHcfIW1vwQV7AMLjKJd/sltfTbfw8oYpqA6PHfVbwWYI/8Nj3lbj?=
 =?us-ascii?Q?ngl4ujBQR1Sj4uql0XkxmRv9Etv5lIcW31jihZ5tYzkzuBT4qek7AJljf/32?=
 =?us-ascii?Q?/1U3WZS6ERsu4xY2eoCLwHHEqunoir10FqQdfoSaUdTGIEThGCuuV/5mcWdd?=
 =?us-ascii?Q?f4OxtbG1ZkLbPBu4ol1lLioe2YfmlF9aM8EoSKfUtPA043FbkN42u3cA77Xk?=
 =?us-ascii?Q?xDEoL9SbL+XxmcyV9sfymzKqueN1du5EuxeNHZXGuuTGUIgnG08kgeyzkwCf?=
 =?us-ascii?Q?cGyYFjSu+fF2kIO9Ju8q73qUNa9Bg2nrfPoxIwkwEMu4RFYRV6TNLFowaKJ3?=
 =?us-ascii?Q?oJipRAf6N3RwwHAeeeSiiGFdFG8neNU0SbVbag7eC1DD5qGUiZHDDGnSYBrF?=
 =?us-ascii?Q?gTPabxfuXXh9dyriP9t93d+g25tAD3Tsd/GXv9+HuZDTQKEbZmYtz0qflZd4?=
 =?us-ascii?Q?/z05pFF/nv2Mi4sfh6ULEgAYuY3yVheoILaLRFLxi/otBTmKCIzq+z2+UiMj?=
 =?us-ascii?Q?THcP5Vm1OkbI8Ffga5o+mCgpS5HTnO58UB7nLh8GjJ4lUQ4s3OcqmdvASwtU?=
 =?us-ascii?Q?9SDp2m0Mu5jUnavDKYmRTJC/J7u3?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8164a26-b493-4191-735b-08d921e6ea4b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:10.7788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHwgBxVv/oBJ+lYYlhq+jaDgPeh373PGiHziYz0eOLeoWBfut3O3pJLOR+LwRWIV1iXCbk9T9O2livroU6LIHoXyvwTOmjPmttnqN+9YuPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add a hashtable which contains entries to map flow cookies to ct
flow entries. Currently the entries are added and not used, but
follow-up patches will use this for stats updates and flow deletes.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 35 +++++++++++---
 .../ethernet/netronome/nfp/flower/conntrack.h | 13 ++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 +
 .../ethernet/netronome/nfp/flower/metadata.c  | 46 ++++++++++++++++++-
 4 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 186f821c8e49..0ac6e92853fa 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -106,9 +106,11 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 static struct
 nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 					 struct net_device *netdev,
-					 struct flow_cls_offload *flow)
+					 struct flow_cls_offload *flow,
+					 struct netlink_ext_ack *extack)
 {
 	struct nfp_fl_ct_flow_entry *entry;
+	struct nfp_fl_ct_map_entry *map;
 	struct flow_action_entry *act;
 	int err, i;
 
@@ -159,12 +161,33 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 
 	INIT_LIST_HEAD(&entry->children);
 
-	/* Creation of a ct_map_entry and adding it to a hashtable
-	 * will happen here in follow up patches.
-	 */
+	/* Now add a ct map entry to flower-priv */
+	map = get_hashentry(&zt->priv->ct_map_table, &flow->cookie,
+			    nfp_ct_map_params, sizeof(*map));
+	if (IS_ERR(map)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload error: ct map entry creation failed");
+		err = -ENOMEM;
+		goto err_ct_flow_insert;
+	}
+	map->cookie = flow->cookie;
+	map->ct_entry = entry;
+	err = rhashtable_insert_fast(&zt->priv->ct_map_table,
+				     &map->hash_node,
+				     nfp_ct_map_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload error: ct map entry table add failed");
+		goto err_map_insert;
+	}
 
 	return entry;
 
+err_map_insert:
+	kfree(map);
+err_ct_flow_insert:
+	if (entry->tun_offset != NFP_FL_CT_NO_TUN)
+		kfree(entry->rule->action.entries[entry->tun_offset].tunnel);
 err_pre_ct_tun_cp:
 	kfree(entry->rule);
 err_pre_ct_act:
@@ -244,7 +267,7 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 		zt->nft = ct_act->ct.flow_table;
 
 	/* Add entry to pre_ct_list */
-	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow);
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 	ct_entry->type = CT_TYPE_PRE_CT;
@@ -285,7 +308,7 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	}
 
 	/* Add entry to post_ct_list */
-	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow);
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 6a876ae89d9a..faf42a967ab9 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -9,6 +9,7 @@
 #define NFP_FL_CT_NO_TUN	0xff
 
 extern const struct rhashtable_params nfp_zone_table_params;
+extern const struct rhashtable_params nfp_ct_map_params;
 
 /**
  * struct nfp_fl_ct_zone_entry - Zone entry containing conntrack flow information
@@ -68,6 +69,18 @@ struct nfp_fl_ct_flow_entry {
 	u8 tun_offset;		// Set to NFP_FL_CT_NO_TUN if no tun
 };
 
+/**
+ * struct nfp_fl_ct_map_entry - Map between flow cookie and specific ct_flow
+ * @cookie:	Flow cookie, same as original TC flow, used as key
+ * @hash_node:	Used by the hashtable
+ * @ct_entry:	Pointer to corresponding ct_entry
+ */
+struct nfp_fl_ct_map_entry {
+	unsigned long cookie;
+	struct rhash_head hash_node;
+	struct nfp_fl_ct_flow_entry *ct_entry;
+};
+
 bool is_pre_ct_flow(struct flow_cls_offload *flow);
 bool is_post_ct_flow(struct flow_cls_offload *flow);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 060c6de36c02..0fbd682ccf72 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -195,6 +195,7 @@ struct nfp_fl_internal_ports {
  * @merge_table:	Hash table to store merged flows
  * @ct_zone_table:	Hash table used to store the different zones
  * @ct_zone_wc:		Special zone entry for wildcarded zone matches
+ * @ct_map_table:	Hash table used to referennce ct flows
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -231,6 +232,7 @@ struct nfp_flower_priv {
 	struct rhashtable merge_table;
 	struct rhashtable ct_zone_table;
 	struct nfp_fl_ct_zone_entry *ct_zone_wc;
+	struct rhashtable ct_map_table;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 062e963a8838..7654cf6a3222 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -504,6 +504,13 @@ const struct rhashtable_params nfp_zone_table_params = {
 	.automatic_shrinking	= false,
 };
 
+const struct rhashtable_params nfp_ct_map_params = {
+	.head_offset		= offsetof(struct nfp_fl_ct_map_entry, hash_node),
+	.key_len		= sizeof(unsigned long),
+	.key_offset		= offsetof(struct nfp_fl_ct_map_entry, cookie),
+	.automatic_shrinking	= true,
+};
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_num_mems)
 {
@@ -528,6 +535,10 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	if (err)
 		goto err_free_merge_table;
 
+	err = rhashtable_init(&priv->ct_map_table, &nfp_ct_map_params);
+	if (err)
+		goto err_free_ct_zone_table;
+
 	get_random_bytes(&priv->mask_id_seed, sizeof(priv->mask_id_seed));
 
 	/* Init ring buffer and unallocated mask_ids. */
@@ -535,7 +546,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		kmalloc_array(NFP_FLOWER_MASK_ENTRY_RS,
 			      NFP_FLOWER_MASK_ELEMENT_RS, GFP_KERNEL);
 	if (!priv->mask_ids.mask_id_free_list.buf)
-		goto err_free_ct_zone_table;
+		goto err_free_ct_map_table;
 
 	priv->mask_ids.init_unallocated = NFP_FLOWER_MASK_ENTRY_RS - 1;
 
@@ -572,6 +583,8 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	kfree(priv->mask_ids.last_used);
 err_free_mask_id:
 	kfree(priv->mask_ids.mask_id_free_list.buf);
+err_free_ct_map_table:
+	rhashtable_destroy(&priv->ct_map_table);
 err_free_ct_zone_table:
 	rhashtable_destroy(&priv->ct_zone_table);
 err_free_merge_table:
@@ -589,22 +602,40 @@ static void nfp_zone_table_entry_destroy(struct nfp_fl_ct_zone_entry *zt)
 		return;
 
 	if (!list_empty(&zt->pre_ct_list)) {
+		struct rhashtable *m_table = &zt->priv->ct_map_table;
 		struct nfp_fl_ct_flow_entry *entry, *tmp;
+		struct nfp_fl_ct_map_entry *map;
 
 		WARN_ONCE(1, "pre_ct_list not empty as expected, cleaning up\n");
 		list_for_each_entry_safe(entry, tmp, &zt->pre_ct_list,
 					 list_node) {
+			map = rhashtable_lookup_fast(m_table,
+						     &entry->cookie,
+						     nfp_ct_map_params);
+			WARN_ON_ONCE(rhashtable_remove_fast(m_table,
+							    &map->hash_node,
+							    nfp_ct_map_params));
 			nfp_fl_ct_clean_flow_entry(entry);
+			kfree(map);
 		}
 	}
 
 	if (!list_empty(&zt->post_ct_list)) {
+		struct rhashtable *m_table = &zt->priv->ct_map_table;
 		struct nfp_fl_ct_flow_entry *entry, *tmp;
+		struct nfp_fl_ct_map_entry *map;
 
 		WARN_ONCE(1, "post_ct_list not empty as expected, cleaning up\n");
 		list_for_each_entry_safe(entry, tmp, &zt->post_ct_list,
 					 list_node) {
+			map = rhashtable_lookup_fast(m_table,
+						     &entry->cookie,
+						     nfp_ct_map_params);
+			WARN_ON_ONCE(rhashtable_remove_fast(m_table,
+							    &map->hash_node,
+							    nfp_ct_map_params));
 			nfp_fl_ct_clean_flow_entry(entry);
+			kfree(map);
 		}
 	}
 	kfree(zt);
@@ -617,6 +648,16 @@ static void nfp_free_zone_table_entry(void *ptr, void *arg)
 	nfp_zone_table_entry_destroy(zt);
 }
 
+static void nfp_free_map_table_entry(void *ptr, void *arg)
+{
+	struct nfp_fl_ct_map_entry *map = ptr;
+
+	if (!map)
+		return;
+
+	kfree(map);
+}
+
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
 {
 	struct nfp_flower_priv *priv = app->priv;
@@ -633,6 +674,9 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 	rhashtable_free_and_destroy(&priv->ct_zone_table,
 				    nfp_free_zone_table_entry, NULL);
 	nfp_zone_table_entry_destroy(priv->ct_zone_wc);
+
+	rhashtable_free_and_destroy(&priv->ct_map_table,
+				    nfp_free_map_table_entry, NULL);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
-- 
2.20.1

