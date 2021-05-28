Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B866239445B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhE1Oo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:44:57 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235925AbhE1Ooq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g07y3fMUYxxxrTJTlMUYOs/5rMlkSiX9Aa0wEBlwD+EHqX3T4uNEddSG3tK4G1thW9DdTdnOSpMZ1TZi2dv60GPFnP0ksvDYdcK2EcOTAR6PULyym4wARn6rO8CrEVsDPc0SJ4AiF3IZJEuRazqRjGk66M9t5sGKxsG9XM8oguj0F+2MqbDYUDI/wIYcvwohIPAnrYDBcmmg/hsMqbk53rlkq8+epfcVFIBR7VsopY0PK1ljYp0O0sQSTzbAwFHZud83FgGBqvl3gtzTWQoinqn99yf2zSHnL7IlUyCMwNbIMpRgZl1yBAMZVEarHVIwRbvyhCKrkQWtWnyIXDllyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8Rt2q+Urw05+JDe8Ym76MFlczzYMVQ/EMXSWXt+gIw=;
 b=OFY2ojRXR2pjcsyM7vsWaUXTWOVyZDTLWtQqZ2oCukV/1m1y4a6IQhhwI3H0gecRJj+FfysWu9SGRtPw+WkDCN1AM7lxfHWvFvNxM1s/3xwbsJSg+I5TXryXJ3fs11Pe1kKc85ae+tU5rLu9onApgykbTL4pus2COGIQTrsSHXvQy05GjwyIUN/8zmVZllYJkGrrDUz8T0P6GzvFCfKEj/zbUpgWh+PYVcM9rpVVaUA29+Fek0oEDhlLDn408A6Xgd9CbgbrEhmNMTgA64GdvZtYQdxu7DwnCjXcsIOr+QV+FVN+tEfADa2I7tyFZkqRUSLNwIJFS0wlNgknLCFLwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8Rt2q+Urw05+JDe8Ym76MFlczzYMVQ/EMXSWXt+gIw=;
 b=jvBTGnra9TNz9OjS5vhdfHmKd7xdg+9gxYp6o65RCT9SkJjTUG0ueFZaD0bWRwPvtmJtFrDCB2lUJRcjhnjEOMz1yycg22L2vm0PMHqJvgEQH/ZTVnLH1+i+kuOp+7cbPsVyBzCcRb9i5bv0klH7goIqkdGBhZmW4VLREpXMlpo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/8] nfp: flower-ct: add zone table entry when handling pre/post_ct flows
Date:   Fri, 28 May 2021 16:42:42 +0200
Message-Id: <20210528144246.11669-5-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73503760-bae5-4aae-3f54-08d921e6e839
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50339E002C90FEF1CE0E4322E8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bLVnDb961bjamhrtymL/RvJIlYQS543PmZompZVfpUZp1xd+JXe+2eGwk6ZLVbcxmw2zOUVyhKcr9ojCXUmten4NHQyqXCRP2nsEn2mimi1RBP6lg0rKUnRvpsQ/J4NSlViJE/3mlq+8ZOK73kPVl9MgPWLSZ65sM7PZxka3BLrYWrC0Fu3p4FZs2O1ThXLs9TyuOBzCVdsE/DwIRlosfOQkT6JX9zLuKFwpENpo9sVW17wP76fJRcfbWT5JqMVGWJSoCtzt0Yj3jfvjI2UU+hZnaJ5d2fFaQHt8pkL/iBOWybQypzvDoLOK5Dn68LoRHid9BdDKthzKqbf0oHnsNN0VZfGwrpYcSNVWNFdYo15f/UiRiVJxH5GZxQfFuuW1ldqtO9E0/o7KHSdPL/IFNKV191HwHFEsXQTNhVA05kJ1OpYuQNFD1Tli1YF+7+KyLFyF02paHOWs6zE37IKcXoZhnsAGLdQPVwAhDmzq1fUxCzHSUP00nQH9ahNr2VLMYoNa7ydEXlDSmbbHDN0nf14ZBbSXVOwoCMnkEVH16Vvbm8oZQMKOjng+vKDfh6mP8mt/c+ZEwjr1oxVUhVmr7JYb8WUUBBGgmAYd2jbeyuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(83380400001)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?M2sTUQZCwX9UNmJy36EyH7LcLQiAXiiM+1yE61GtqdkiCUtH5FSShEMl+HpA?=
 =?us-ascii?Q?pEm+g7iieZf4QjUnYH0gLyV+S96bLQ05+S1qz+TAnlY8QwmPB34LgjzwCp3n?=
 =?us-ascii?Q?DlQbQjXiuhfk5sbvrO0PZ7bm+DV7aoDueojg+/KSY4ni4qOgw9KCynPHkXnh?=
 =?us-ascii?Q?KN/Ro6aH6//TrYjTOuNtdr9yEgN9O2Smcz5dKy3RoXtUyDHahhukd649fPCS?=
 =?us-ascii?Q?AjD3GmpeQF6NWwRPe/BGOzqMQTCOleBlMX8sF5s9huBR9RzTkwM13d+sgNw4?=
 =?us-ascii?Q?DM28w+6Od0STTCNuCeJUC1I8EjT9nRfS9+7FDvKzKZ0jw1CPRr9BDBkwAVeE?=
 =?us-ascii?Q?/uu76Dp4zxgGXR4JzbEu+B0MJSXXsAGEFZ+fn47bOMIXYVZOtHPHxty62pp7?=
 =?us-ascii?Q?QVOV/XJ0J5NWfF0a8qchZYThX26HX8IOYPXtJgKQMMle3MhNCscHB2+7vb2n?=
 =?us-ascii?Q?E/pEJXICveXY9QxtBaOQXsJ8BS6bkftSg3ndNUu4ni4M2KvZqsSYt15pqIme?=
 =?us-ascii?Q?jQa+gg/rQrqt0JmsJzTVVhdfSzmvfXiO6jvplJouy3+PTiA4vZ1WVuh/OFCx?=
 =?us-ascii?Q?7fRxdiMcYWwv5PW7GGz4reEZMFtCS11tfXZGcZowvFBOC0ORudkbGBBDwohH?=
 =?us-ascii?Q?G6VZo0pVgwvGq+NDS5x5TBlSrVRw/nX+7DUNQFbPbw2JwmG8RqNJ2eqdTs7G?=
 =?us-ascii?Q?+54n/7EwLZ7hcKqR/HQhrGIku26M5hmQwevdZmrzknfF75NrvgMlx2eRlTXg?=
 =?us-ascii?Q?c/cW1pdetAvswAdSvAI+s7wjkB3X4qw5kmtOo+HoQ5p7Ewm/lypLMRq66tz2?=
 =?us-ascii?Q?Br/E5M6m1+xtbk2y9wlobLOHdsA80sKLTb0XXon9wGf1/OAQ7KVDEjSD0W/M?=
 =?us-ascii?Q?RyvIT+10TJ76P5utk3S2qei0lCitkXnyCbiq0R8U8IlhMQqlj/F1lYo7Ky1r?=
 =?us-ascii?Q?FBKQ3mH5omgTVMebUU3a462h5NXm6StaP7A2CXFS1qggmMTrft3Kg0pLJX62?=
 =?us-ascii?Q?326wUnQZF5n8JPyKL+Nr13nqSPGMU/Ydh2rGZhJwP9LGkNSplMzjowpFZGax?=
 =?us-ascii?Q?/F5rHNazF1Sr5HXTCYa2ip7450iidwI6jaBee4L5iQEDTFIL9YaB7hNdrTyu?=
 =?us-ascii?Q?eUtIdZ2ipWGkAjZAVl0lk2PPlr7j/kXfKDistY+VXvETxEJGk+tC0FuNxK3k?=
 =?us-ascii?Q?PjS5BkkHBovu9B1TvmNARr9TvseT8jm4AcmkBfB96gc7ALKE/FbTpoU1lHhz?=
 =?us-ascii?Q?AYJ8H9zB+yeQTkDzSXCRB5k+90iEQLSjxbYjkNwJ5uJNiIQQsZ3PtXZ2ROiV?=
 =?us-ascii?Q?CZu9jR2WB0rF6y+Gba7z8VlgQwbB7+gsXUtrd6n5EQYPPDoYXhkIo1snXaVz?=
 =?us-ascii?Q?gXVE8Kql/4stvNHytSvZK891SjSc?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73503760-bae5-4aae-3f54-08d921e6e839
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:07.2782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vtc9G9OsjyXbL8FzDMtQ+4NacjtYPnV0RASOjtJSpEJQrvfQULZ5Zr2/FvtSHttb2gKfS7VhGsx+mlcY3Bhy4uFFtoGnFs/8SP3olvaE8Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Start populating the pre/post_ct handler functions. Add a zone entry
to the zone table, based on the zone information from the flow. In
the case of a post_ct flow which has a wildcarded match on the zone
create a special entry.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 124 ++++++++++++++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |   4 +-
 .../ethernet/netronome/nfp/flower/metadata.c  |   3 +
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index aeea37a0135e..3a07196a8fe2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -3,6 +3,32 @@
 
 #include "conntrack.h"
 
+/**
+ * get_hashentry() - Wrapper around hashtable lookup.
+ * @ht:		hashtable where entry could be found
+ * @params:	hashtable params
+ * @size:	size of entry to allocate if not in table
+ *
+ * Returns an entry from a hashtable. If entry does not exist
+ * yet allocate the memory for it and return the new entry.
+ */
+static void *get_hashentry(struct rhashtable *ht, void *key,
+			   const struct rhashtable_params params, size_t size)
+{
+	void *result;
+
+	result = rhashtable_lookup_fast(ht, key, params);
+
+	if (result)
+		return result;
+
+	result = kzalloc(size, GFP_KERNEL);
+	if (!result)
+		return ERR_PTR(-ENOMEM);
+
+	return result;
+}
+
 bool is_pre_ct_flow(struct flow_cls_offload *flow)
 {
 	struct flow_action_entry *act;
@@ -29,11 +55,88 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
 	return false;
 }
 
+static struct
+nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
+					 u16 zone, bool wildcarded)
+{
+	struct nfp_fl_ct_zone_entry *zt;
+	int err;
+
+	if (wildcarded && priv->ct_zone_wc)
+		return priv->ct_zone_wc;
+
+	if (!wildcarded) {
+		zt = get_hashentry(&priv->ct_zone_table, &zone,
+				   nfp_zone_table_params, sizeof(*zt));
+
+		/* If priv is set this is an existing entry, just return it */
+		if (IS_ERR(zt) || zt->priv)
+			return zt;
+	} else {
+		zt = kzalloc(sizeof(*zt), GFP_KERNEL);
+		if (!zt)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	zt->zone = zone;
+	zt->priv = priv;
+	zt->nft = NULL;
+
+	if (wildcarded) {
+		priv->ct_zone_wc = zt;
+	} else {
+		err = rhashtable_insert_fast(&priv->ct_zone_table,
+					     &zt->hash_node,
+					     nfp_zone_table_params);
+		if (err)
+			goto err_zone_insert;
+	}
+
+	return zt;
+
+err_zone_insert:
+	kfree(zt);
+	return ERR_PTR(err);
+}
+
+static struct flow_action_entry *get_flow_act(struct flow_cls_offload *flow,
+					      enum flow_action_id act_id)
+{
+	struct flow_action_entry *act = NULL;
+	int i;
+
+	flow_action_for_each(i, act, &flow->rule->action) {
+		if (act->id == act_id)
+			return act;
+	}
+	return NULL;
+}
+
 int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct net_device *netdev,
 			    struct flow_cls_offload *flow,
 			    struct netlink_ext_ack *extack)
 {
+	struct flow_action_entry *ct_act;
+	struct nfp_fl_ct_zone_entry *zt;
+
+	ct_act = get_flow_act(flow, FLOW_ACTION_CT);
+	if (!ct_act) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: Conntrack action empty in conntrack offload");
+		return -EOPNOTSUPP;
+	}
+
+	zt = get_nfp_zone_entry(priv, ct_act->ct.zone, false);
+	if (IS_ERR(zt)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload error: Could not create zone table entry");
+		return PTR_ERR(zt);
+	}
+
+	if (!zt->nft)
+		zt->nft = ct_act->ct.flow_table;
+
 	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack action not supported");
 	return -EOPNOTSUPP;
 }
@@ -43,6 +146,27 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 			     struct flow_cls_offload *flow,
 			     struct netlink_ext_ack *extack)
 {
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct nfp_fl_ct_zone_entry *zt;
+	bool wildcarded = false;
+	struct flow_match_ct ct;
+
+	flow_rule_match_ct(rule, &ct);
+	if (!ct.mask->ct_zone) {
+		wildcarded = true;
+	} else if (ct.mask->ct_zone != U16_MAX) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: partially wildcarded ct_zone is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	zt = get_nfp_zone_entry(priv, ct.key->ct_zone, wildcarded);
+	if (IS_ERR(zt)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload error: Could not create zone table entry");
+		return PTR_ERR(zt);
+	}
+
 	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack match not supported");
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index b9de3d70f958..060c6de36c02 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -193,7 +193,8 @@ struct nfp_fl_internal_ports {
  * @qos_stats_lock:	Lock on qos stats updates
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
  * @merge_table:	Hash table to store merged flows
- * @ct_zone_table	Hash table used to store the different zones
+ * @ct_zone_table:	Hash table used to store the different zones
+ * @ct_zone_wc:		Special zone entry for wildcarded zone matches
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -229,6 +230,7 @@ struct nfp_flower_priv {
 	int pre_tun_rule_cnt;
 	struct rhashtable merge_table;
 	struct rhashtable ct_zone_table;
+	struct nfp_fl_ct_zone_entry *ct_zone_wc;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 74c0dd508f55..10d84ebf77bf 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -586,6 +586,8 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 static void nfp_free_zone_table_entry(void *ptr, void *arg)
 {
 	struct nfp_fl_ct_zone_entry *zt = ptr;
+
+	kfree(zt);
 }
 
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
@@ -603,6 +605,7 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 				    nfp_check_rhashtable_empty, NULL);
 	rhashtable_free_and_destroy(&priv->ct_zone_table,
 				    nfp_free_zone_table_entry, NULL);
+	kfree(priv->ct_zone_wc);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
-- 
2.20.1

