Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD70395ADD
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhEaMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:49:01 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:7041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231553AbhEaMsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNIZ7cpIfeUJbUug+9HlGdtDyhaIA7naDsbxBKXlWfk7wRmoiOMWLb4rS58zJP2Pyki9jOJIdEf10UhfV0u8CFqAfbgcnnee71ALWcjqVEJLQNlGN42NVWqOubdD5DbHfiQkLlYWgPQ3ySerOJ0W+6F+McPpCsAqha+tpGHRsChisAeB5FYqNhKtztJot7asmIQI5JuI/Ng+j5aTRtxUojpsnrQBO/ZxJzFoGJR07gSC3+kzNALoGsLDeJnqEWSBW6gdWZ9grzM3I6C1j/85dN6hkcu6VnTuBU+GZrrR6WFLodt4tvo70/+rbA3fftuVotz0KBKDr78ZuR4pqLOSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3KCxgKFRoH2eyZiK4IZLpnHxAxPfmhQVdPviTG3mrQ=;
 b=U6Tfk8Ql8Sfmdh6lZ9BbPCI76hEYUlalqQydriRDwTBlAqFWzfZPBTxkDefBifzJA7LO8Rp1Sb3gZXkG228DmRBsPPGR01LqUfSdfQXfu2QNI1ZAMgttmyxtWJrv4OviTw/FIR62LXcYQ16Cv8E1qg0MkMv3VtmOW8QX8HTYPFa4WPJRlIdp8nP/VNK6cG5+02NwTHPPpJQmK4UlkfmSeWi8VoFy5SqYLW9U/8p8FGwKsQg+da5EUIQ+D8nR+sNeHjHLLODAKHxCCm5F1eWI4uKgCHRI3aFL73tJ7Z5ZhnPw7ZKknIh07GKGRcU1diKGsWXvDpK6uegJ0NoFz9OFwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3KCxgKFRoH2eyZiK4IZLpnHxAxPfmhQVdPviTG3mrQ=;
 b=ewPOX8yU8YSb2LfjKsSuHuu1mcCtSh8idlOjajzvS/yNtx1sD8fmcXZRADgZ445oLR2kKVvNguFtIYCK/qUZfFCTgF4yM3sIwwXkWh2B8Xoxm3ONSXTt08VWK76RduDUze1LW5hH+F3m+L7ghmVDBJeHXJTGvrDQqCedREWehrg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4891.namprd13.prod.outlook.com (2603:10b6:510:96::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12; Mon, 31 May
 2021 12:46:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 6/8] nfp: flower-ct: add a table to map flow cookies to ct flows
Date:   Mon, 31 May 2021 14:46:05 +0200
Message-Id: <20210531124607.29602-7-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e15b93d-beb5-4163-12c5-08d92432212c
X-MS-TrafficTypeDiagnostic: PH0PR13MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4891608DC3A97EF0F74A4911E83F9@PH0PR13MB4891.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGZAcWtZuOt4qWUI8Gt5CptfV8LO+fr49Wbvu9axxq03WxBHg79ah8pPRS3prpaMVlNn0T2jkiF8hLuxyQpR6DJv+DSY5jF2ijN78r6ajEvGPB6VhBI1DPBkBMLrOwssyfW4a/WPuBN2qMs3uup5PWbIRVojoMfTXjXfZJ/sQ/TDOBhz9Wu0cLueK3cMUgkgZRR30+Y0bQV+DuK1xQl5fTWKUoXN3/i7BjAI21Sx/wWs30UMDg/2GATiC+XyeVosieJ9FgolVFRIfsrdj43a8S+6nGoM9Iq345UANm5qIh/ZXVbpi8VBRv0kivcQBV21zJ+A+m9xm5Ny5X/KXa5m+NEMBwcCID5exG6MISe2ICpyg0vtYgpVBv+uvrj+U2aTtzxGyeX3lWRVUyH6qXJ74wwO60CcZRxHbiHodi3MVP1iwYmDcmj2o3T/B8WDK+kJ99NRdD+f+kO+ItmOyQ6OZHoOzGC4/0Ij6A5y/6KFJqr1paD4jhYX0h+/Hd92sJpKLVqEhTznKTf1xmPgwUWPvQvGKtvLlSdw8AxnxbBL+fBu2T0oitOZk2qHRmJiaZQeXu2/eLzIJc7i0+AgjZFqmQ7wAK6xmExyhCWdVmw0axk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39830400003)(376002)(107886003)(2906002)(66946007)(66476007)(66556008)(36756003)(38100700002)(6512007)(186003)(16526019)(4326008)(86362001)(8936002)(8676002)(83380400001)(6666004)(44832011)(1076003)(6506007)(54906003)(110136005)(6486002)(478600001)(2616005)(316002)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KLcnk3iVzIgbZFZwXkJT8Rl/R4eH5J0uChkKwHyFGnBCuJXxiUkFh3YJYWLX?=
 =?us-ascii?Q?j83IYNi95KP2BDHox8L3ydorRezl8Duqmjjneq85XmK4hxwvTwIERxZKJsU5?=
 =?us-ascii?Q?FxifRnu5J1pdFC1E58HEJ6KyCDcUPEi/xnnr8uQKd77S23sUWeRde8i/iZ0Y?=
 =?us-ascii?Q?VT+SXwORdm6NtRr1ei7bVJu+tN7TpBvmwgszGrcdd0oMY8/w6TdoeKNPRl4q?=
 =?us-ascii?Q?dL/QIrRz3BS0hcLCqx2KPw0bnEQUbfuf6zD5pSjjS/4i3+OMzh8R7GtVyX7x?=
 =?us-ascii?Q?n7TrfdxKZTy6hrK22QZJsvquS4BbUhcbFm1AoCbIvoNegM1UxcB0RwCUlMpu?=
 =?us-ascii?Q?pKlp7Y6FW/vz9s6NOCQbUwTTYAVKOe6yTgTbUYL45q3JZfzJF4RzAtW/h3yl?=
 =?us-ascii?Q?HwCz7OU0pd0s24IlwfUG0HSNamo26TSVTwpw4SDWiQeLhxVlV6iax0DjZB8C?=
 =?us-ascii?Q?XVoCTMjFzvddKuaFfL/Vi40IYKFKsznEA1GGhMqoVJcC9X3Svp6mAxKledWg?=
 =?us-ascii?Q?QZ0XQsiCsUd0rEZjJCQOrYZmkTg7ag7VzoowplRAWUe56ixkqrpIUmH8ECvj?=
 =?us-ascii?Q?dbPlmQVP2amxGQ445nxxA+0y/XxIM85eAijdzOdDL6quCO9oGJQgsXKSH0F3?=
 =?us-ascii?Q?NDhv4U85IKWsErfR7MQZFyJGWmZNc/EjDENmItIy1fTc5cHgeURRkbhrHzfW?=
 =?us-ascii?Q?YWI5ixX1NaTKTUK32UtRILyTV9KH6DrKR4bvIt52yx7ZUtuhKeaa8wQloFEl?=
 =?us-ascii?Q?GLsfXzp4pteLrcFYSAMRUHz+QO4c4p1UkkyVpfAyd91xCdwvO2dNLKnCshEH?=
 =?us-ascii?Q?Jy4Xk/073f75bAPQwHDVJgz5sBIl30T88TmzS/b3SBJj2bySDe7qIpghX6Yz?=
 =?us-ascii?Q?trLvsRiaLtQuAjvnvkG+1is2Qf4REgFWSo/5fqQ2aqlOUoOiAQ57r/XrXxOD?=
 =?us-ascii?Q?VNolRpIgkliUyX7JHw5iiNAtbrx2m8dSARyat8TrXxiwhCnYmmbkPfrbu9nm?=
 =?us-ascii?Q?xjY7QtcNgB9mKR5qu2LvabrlRYWmnbbzmx8280fshimPk4EfK2oKa/ZN9k4r?=
 =?us-ascii?Q?vB28wkTlqeS+N7sTRFQdlMB8P2lC+bWWQ0Dcx/fPo0tr/wxbXbA+9byGbjSm?=
 =?us-ascii?Q?iqROoqJFxf8NK+cM25LFhGuLUZQHjJh3KpAu/0pnKY0ysgT04SPleywXsUzU?=
 =?us-ascii?Q?iLUSwfvUO9ApEv0RfyNGGNmucQv49cjcRuoIvzO7J7dDFtH2/qrYWzBOJRrF?=
 =?us-ascii?Q?JxwQqCtXjnNKRtzzPvqroS9Gg7J0zz+SErFfVF+8uhEUyyZm/55AzFuclWPD?=
 =?us-ascii?Q?2maz2KV5gCh/o1/FzppWUiKVdKyXBFYZq8utRiqP4sVspBp1nZC6vB4khQgN?=
 =?us-ascii?Q?2+hI++2ZCvxfWwodtSf93DjBB1N+?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e15b93d-beb5-4163-12c5-08d92432212c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:37.4481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHYottiAXX3/536EvFiAnk1PXGZQZC246rrvILsMP1UzZLuGlpnmZIbUKnSNTnc+c61LCOfMwuPAXjUKPEKksNv8ib94yZccOFLHk0GxteE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4891
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
index 46437de4d75f..a7f0d7c76b72 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -9,6 +9,7 @@
 #define NFP_FL_CT_NO_TUN	0xff
 
 extern const struct rhashtable_params nfp_zone_table_params;
+extern const struct rhashtable_params nfp_ct_map_params;
 
 /**
  * struct nfp_fl_ct_zone_entry - Zone entry containing conntrack flow information
@@ -69,6 +70,18 @@ struct nfp_fl_ct_flow_entry {
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

