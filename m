Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FC3395ADB
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhEaMsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:48:51 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:7041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231589AbhEaMsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwPAGDGhY1Xw5SN1i65jSm9ALwObJHgMuGPsVH9aSNYrGQj+jmpXM5yGykdi/xeicAU7SrVPnXxcZZr4exyJy1z7T0zrlZTdWOIl24W07fe1bAzgnrgtm6kOaAhJZdJlu2TtTMkw6c447xihu96CqpHSJO7uZbj9xi2eudm2LaZZMuqaTPhnfqi7wFxLn6ElK/8FsHMjSbX/8np9WGAEISsPr9Ufm2BAhnI0WpoBt4gAliHaO4aDRp56W/3hxwkg0qabTc8WZ20HK8wBvF/nAFpaTJDzDFLtTnzWNz9GYKnDFzQX3+A7HsAuXlP7vuvd8gOi89lJd0Mj6KEoGc+u7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9k+GZgNG6ZbpnRK9NxAX8z/uUTsAWKae9DLHUtVWfY=;
 b=igQb5QcR4xZc+YYpSx06dFsKt/+MqND4x7uVehh3FnwNXqq41r7WEzIpyivnO/bhE9fEAXRHz5GHnz60pWNQIvWhyfF87Z05gIH7ybKxmpiW75thL7QqP2BwEwaakh3le1mWwalJ5zel5BlSJZpdV4NL+/iEGdwEcLsqsytAsSSvLuSB5c4o+ue0KF0DTEnWe2hTBs50pkhPCuUMc3Zem3N5poyZpzU99Lo3O725lRfJapUXhQH+RrDXZ8cY+UiR67v99HxlPpOfJpkVeXn9ofLJtUngJMMOlA3uFXmUFoC5ctdp4RAM7Jiwh8uP6WagAQ6Ze6otMfQt8qKh6YO3SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9k+GZgNG6ZbpnRK9NxAX8z/uUTsAWKae9DLHUtVWfY=;
 b=H1EEv50ujCKiqVO0VXWoAWpA1J7kPmNx1WBIfTvLvhPeap4DiHJRc+TPzKkjh6G6oBKE0NjRK92cCV6lcda7VLTdLYYEY44gLFO3WgvW8rcO5nlvag8z8cxX+bXLMjNVwR1WZpv4j2EXS0DVnEYB3GFF/HZYDq3+CpRZu9muABo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4891.namprd13.prod.outlook.com (2603:10b6:510:96::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12; Mon, 31 May
 2021 12:46:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:35 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 5/8] nfp: flower-ct: add nfp_fl_ct_flow_entries
Date:   Mon, 31 May 2021 14:46:04 +0200
Message-Id: <20210531124607.29602-6-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f237c61-13b1-470d-4328-08d92432201e
X-MS-TrafficTypeDiagnostic: PH0PR13MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48913D4DBAC1644276D51191E83F9@PH0PR13MB4891.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mSFmT8FGMxnwbtIiXU5p9bU3gKG0SS/OlsboBiL5+wO5JqEVvSZzlS4qofItl2BR7RCmNW0KZtexYNSXeGudWs9n+Qf2r6Xm4/1i42BbSe36/wHFIyXauFykstH/DCg/r1I8YLWddb9Qf7521/3a+PmNgXCqiiUB1oBOR2Tg7cUGJcJkkukIRsyLWTH7FbBWTzpohWOqC39wyywcLD4w5Qw20Wdffuk9zxU6aU70w4MNTpxCubR0rMwy0RDfUb6QtYiBKrW2gkRXl3R0M/S15xrlES4PFjkEiAyWoNAKcFQo+I0mv9N1MXYsR9s4yPufNmmlFSHj9xpaGefAIKci66YOm4gv3J4F+yE2eHTJHpa7VAxFSNEODlKQlbcHUzlT4qu4HtAoMF9xoBlV8UdyfSXoOzZvowsbtO9Iq+BgK9Nyng8dpj8dNv/sMwzu41AVCBumdZOAiMtG1WNkz2zDZCNXqMnCjPZ9I/ir1cAa3No57xQqjD+sKa6zpdg8ORnStaw4IgeDmI1dIXYV0Sp9W9zqtVqxFk8ii4S8iDrkNEhvBtHqlb6C7j+lvZ1nymg2ihAmEVqtlcnZbNINdrFda4GqtyU8vCzky+HJB5VS70o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39830400003)(376002)(107886003)(2906002)(66946007)(66476007)(66556008)(36756003)(38100700002)(6512007)(186003)(16526019)(4326008)(86362001)(8936002)(8676002)(83380400001)(6666004)(44832011)(30864003)(1076003)(6506007)(54906003)(110136005)(6486002)(478600001)(2616005)(316002)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ju2irf8AFRb2uhK0mk3jKxCZSVp3BZryypo+c9tNvmnw0FF9Zn1CsTQi1FoJ?=
 =?us-ascii?Q?peEKuDoQ8yGc6B7V+8zdua2LR33kxwi/ERFY8Lidva2XNw/tQxQpDIvwxl7I?=
 =?us-ascii?Q?DRHvoAoewBgEz3NHQjzy+6G0OppVWOvbWwYx3LYWo6du8jp9cYGSP5g3QYDU?=
 =?us-ascii?Q?ZEs8HxmiavcrAfceEN4pDESHJb3fuHIgVp5QtcqC5IQ8rtYKxicJNhe3Rxok?=
 =?us-ascii?Q?bimwPfskmak919POY7V+vbmeahi7TirToYPVtpT27UP5veTmRnLR5qZeMKgR?=
 =?us-ascii?Q?K7zY8jQWEWM++IHEjQffy4TJaXHQqcbNzK39f+McJqvt7tCeheyfnR8DjTe8?=
 =?us-ascii?Q?J/yP3R+lAn296fnPZ1ncctEjEMcO8/J+q79omTK1anm5gr3O+lA5jKT41HaL?=
 =?us-ascii?Q?C4ecI0mR3VMTZFulHxiuamHpbe9QiFnc8gJD/oTAwJvx72Uuidw7S8R7tb9j?=
 =?us-ascii?Q?ELaoc9RRUrFaNUBqw5JVgoni/s+S9igmhqPECPhuZBoPeN04kTdBvqtVrzHH?=
 =?us-ascii?Q?mUQ+4+7vGcmS9f8xAMXUJ6JZqNiF7KkLfenavOABbgY1j5OI7A/DpAv4Phmd?=
 =?us-ascii?Q?0tOTYXVCwv0NiqblpVdhvLosH809d7g6sClP74iwGJxl/h71MRS4xciXsxja?=
 =?us-ascii?Q?UqwXoo2gCjBhIS+FoD4DPkLP+fIMk1YWg2yimNBaCvD1OxtP5k35taPWALM4?=
 =?us-ascii?Q?h1XRm/9IpUo/35Oarngr1zhV+K84FJ83ET9dG64Z7lkd9xCjuOq9ssD0S+Xa?=
 =?us-ascii?Q?cXQNU6+rUcM8Q0DibJJ0QVwzEwjYf8O4ZcHENwZbIoCsKdZs8i3WADkcCOdP?=
 =?us-ascii?Q?slxOcgWeoYCVwIVQUNyzetD2xGe0nodxaF74QPpJFxloTBQqdbcfdDgDFr0e?=
 =?us-ascii?Q?SIE0g+mShHpXcHFckvJfVAHF1t7JMX/B6yEW61Kt9gIMANZj+YztdPpe7dv3?=
 =?us-ascii?Q?ZiMJ5JqOKpU8YkK8ghX/LkGrzG2pEMklIWDTLhMz18nlYNqa+I00A7GWTRX6?=
 =?us-ascii?Q?e5MHrWAB6yR9O79SAGAqQnIEmh1S7hzo65sDMAsfoTZ+KWvWRsBI/xq3IErS?=
 =?us-ascii?Q?m8a5W4plII2kU6LiZGTVF0R5aPE6h27JY44etgxDB7WK/35Z+MyKQnxHugFE?=
 =?us-ascii?Q?yF72KUfWF28hipf4a11ghLq99HEBOm+LQs/5cokEt9LHrBm+k/I9VaX6Ycov?=
 =?us-ascii?Q?UbjsAs7Zc9/L7fhCz+w9b01FZNzrOjKHa/aKUXx9McEsCupGsqGg/dxjhaIt?=
 =?us-ascii?Q?HXdybn0OrWHOYnLvU6yckGvDt+v/X+cDa01g8BU8bkLYzHvhUCPYr/Bxnkuh?=
 =?us-ascii?Q?q/fUDmUozUtEexhn8eOVDQ2Cs0uuUGfA0N/NE2PWhlGqLjOmvxhwtsXkHYwd?=
 =?us-ascii?Q?/U34HZQHJO3iH7jmUJuQPojgfC9j?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f237c61-13b1-470d-4328-08d92432201e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:35.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytyTlT0ePy5dgUIYS4c6WdjZL5s198OAGIwTxWKVaCLJaGNAu2UAUhfOCa3ld+52tKktKT2dkE4Ft/T5+RQSGFQ2eFtgxM+zhAEMOSonEyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

This commit starts adding the structures and lists that will
be used in follow up commits to enable offloading of conntrack.
Some stub functions are also introduced as placeholders by
this commit.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 130 +++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |  51 +++++++
 .../ethernet/netronome/nfp/flower/metadata.c  |  31 ++++-
 3 files changed, 209 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 3a07196a8fe2..186f821c8e49 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -82,6 +82,10 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	zt->priv = priv;
 	zt->nft = NULL;
 
+	/* init the various hash tables and lists*/
+	INIT_LIST_HEAD(&zt->pre_ct_list);
+	INIT_LIST_HEAD(&zt->post_ct_list);
+
 	if (wildcarded) {
 		priv->ct_zone_wc = zt;
 	} else {
@@ -99,6 +103,100 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	return ERR_PTR(err);
 }
 
+static struct
+nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
+					 struct net_device *netdev,
+					 struct flow_cls_offload *flow)
+{
+	struct nfp_fl_ct_flow_entry *entry;
+	struct flow_action_entry *act;
+	int err, i;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	entry->zt = zt;
+	entry->netdev = netdev;
+	entry->cookie = flow->cookie;
+	entry->rule = flow_rule_alloc(flow->rule->action.num_entries);
+	if (!entry->rule) {
+		err = -ENOMEM;
+		goto err_pre_ct_act;
+	}
+	entry->rule->match.dissector = flow->rule->match.dissector;
+	entry->rule->match.mask = flow->rule->match.mask;
+	entry->rule->match.key = flow->rule->match.key;
+	entry->chain_index = flow->common.chain_index;
+	entry->tun_offset = NFP_FL_CT_NO_TUN;
+
+	/* Copy over action data. Unfortunately we do not get a handle to the
+	 * original tcf_action data, and the flow objects gets destroyed, so we
+	 * cannot just save a pointer to this either, so need to copy over the
+	 * data unfortunately.
+	 */
+	entry->rule->action.num_entries = flow->rule->action.num_entries;
+	flow_action_for_each(i, act, &flow->rule->action) {
+		struct flow_action_entry *new_act;
+
+		new_act = &entry->rule->action.entries[i];
+		memcpy(new_act, act, sizeof(struct flow_action_entry));
+		/* Entunnel is a special case, need to allocate and copy
+		 * tunnel info.
+		 */
+		if (act->id == FLOW_ACTION_TUNNEL_ENCAP) {
+			struct ip_tunnel_info *tun = act->tunnel;
+			size_t tun_size = sizeof(*tun) + tun->options_len;
+
+			new_act->tunnel = kmemdup(tun, tun_size, GFP_ATOMIC);
+			if (!new_act->tunnel) {
+				err = -ENOMEM;
+				goto err_pre_ct_tun_cp;
+			}
+			entry->tun_offset = i;
+		}
+	}
+
+	INIT_LIST_HEAD(&entry->children);
+
+	/* Creation of a ct_map_entry and adding it to a hashtable
+	 * will happen here in follow up patches.
+	 */
+
+	return entry;
+
+err_pre_ct_tun_cp:
+	kfree(entry->rule);
+err_pre_ct_act:
+	kfree(entry);
+	return ERR_PTR(err);
+}
+
+static void nfp_free_tc_merge_children(struct nfp_fl_ct_flow_entry *entry)
+{
+}
+
+static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
+{
+}
+
+void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry)
+{
+	list_del(&entry->list_node);
+
+	if (!list_empty(&entry->children)) {
+		if (entry->type == CT_TYPE_NFT)
+			nfp_free_nft_merge_children(entry, true);
+		else
+			nfp_free_tc_merge_children(entry);
+	}
+
+	if (entry->tun_offset != NFP_FL_CT_NO_TUN)
+		kfree(entry->rule->action.entries[entry->tun_offset].tunnel);
+	kfree(entry->rule);
+	kfree(entry);
+}
+
 static struct flow_action_entry *get_flow_act(struct flow_cls_offload *flow,
 					      enum flow_action_id act_id)
 {
@@ -117,7 +215,8 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct flow_cls_offload *flow,
 			    struct netlink_ext_ack *extack)
 {
-	struct flow_action_entry *ct_act;
+	struct flow_action_entry *ct_act, *ct_goto;
+	struct nfp_fl_ct_flow_entry *ct_entry;
 	struct nfp_fl_ct_zone_entry *zt;
 
 	ct_act = get_flow_act(flow, FLOW_ACTION_CT);
@@ -127,6 +226,13 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	ct_goto = get_flow_act(flow, FLOW_ACTION_GOTO);
+	if (!ct_goto) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: Conntrack requires ACTION_GOTO");
+		return -EOPNOTSUPP;
+	}
+
 	zt = get_nfp_zone_entry(priv, ct_act->ct.zone, false);
 	if (IS_ERR(zt)) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -137,7 +243,17 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	if (!zt->nft)
 		zt->nft = ct_act->ct.flow_table;
 
+	/* Add entry to pre_ct_list */
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow);
+	if (IS_ERR(ct_entry))
+		return PTR_ERR(ct_entry);
+	ct_entry->type = CT_TYPE_PRE_CT;
+	ct_entry->chain_index = ct_goto->chain_index;
+	list_add(&ct_entry->list_node, &zt->pre_ct_list);
+	zt->pre_ct_count++;
+
 	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack action not supported");
+	nfp_fl_ct_clean_flow_entry(ct_entry);
 	return -EOPNOTSUPP;
 }
 
@@ -147,6 +263,7 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 			     struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct nfp_fl_ct_flow_entry *ct_entry;
 	struct nfp_fl_ct_zone_entry *zt;
 	bool wildcarded = false;
 	struct flow_match_ct ct;
@@ -167,6 +284,17 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 		return PTR_ERR(zt);
 	}
 
+	/* Add entry to post_ct_list */
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow);
+	if (IS_ERR(ct_entry))
+		return PTR_ERR(ct_entry);
+
+	ct_entry->type = CT_TYPE_POST_CT;
+	ct_entry->chain_index = flow->common.chain_index;
+	list_add(&ct_entry->list_node, &zt->post_ct_list);
+	zt->post_ct_count++;
+
 	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack match not supported");
+	nfp_fl_ct_clean_flow_entry(ct_entry);
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 5f1f54ccc5a1..46437de4d75f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -6,6 +6,8 @@
 
 #include "main.h"
 
+#define NFP_FL_CT_NO_TUN	0xff
+
 extern const struct rhashtable_params nfp_zone_table_params;
 
 /**
@@ -14,6 +16,12 @@ extern const struct rhashtable_params nfp_zone_table_params;
  * @hash_node:	Used by the hashtable
  * @priv:	Pointer to nfp_flower_priv data
  * @nft:	Pointer to nf_flowtable for this zone
+ *
+ * @pre_ct_list:	The pre_ct_list of nfp_fl_ct_flow_entry entries
+ * @pre_ct_count:	Keep count of the number of pre_ct entries
+ *
+ * @post_ct_list:	The post_ct_list of nfp_fl_ct_flow_entry entries
+ * @post_ct_count:	Keep count of the number of post_ct entries
  */
 struct nfp_fl_ct_zone_entry {
 	u16 zone;
@@ -21,6 +29,44 @@ struct nfp_fl_ct_zone_entry {
 
 	struct nfp_flower_priv *priv;
 	struct nf_flowtable *nft;
+
+	struct list_head pre_ct_list;
+	unsigned int pre_ct_count;
+
+	struct list_head post_ct_list;
+	unsigned int post_ct_count;
+};
+
+enum ct_entry_type {
+	CT_TYPE_PRE_CT,
+	CT_TYPE_NFT,
+	CT_TYPE_POST_CT,
+};
+
+/**
+ * struct nfp_fl_ct_flow_entry - Flow entry containing conntrack flow information
+ * @cookie:	Flow cookie, same as original TC flow, used as key
+ * @list_node:	Used by the list
+ * @chain_index:	Chain index of the original flow
+ * @netdev:	netdev structure.
+ * @type:	Type of pre-entry from enum ct_entry_type
+ * @zt:		Reference to the zone table this belongs to
+ * @children:	List of tc_merge flows this flow forms part of
+ * @rule:	Reference to the original TC flow rule
+ * @stats:	Used to cache stats for updating
+ * @tun_offset: Used to indicate tunnel action offset in action list
+ */
+struct nfp_fl_ct_flow_entry {
+	unsigned long cookie;
+	struct list_head list_node;
+	u32 chain_index;
+	enum ct_entry_type type;
+	struct net_device *netdev;
+	struct nfp_fl_ct_zone_entry *zt;
+	struct list_head children;
+	struct flow_rule *rule;
+	struct flow_stats stats;
+	u8 tun_offset;		// Set to NFP_FL_CT_NO_TUN if no tun
 };
 
 bool is_pre_ct_flow(struct flow_cls_offload *flow);
@@ -59,4 +105,9 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 			     struct flow_cls_offload *flow,
 			     struct netlink_ext_ack *extack);
 
+/**
+ * nfp_fl_ct_clean_flow_entry() - Free a nfp_fl_ct_flow_entry
+ * @entry:	Flow entry to cleanup
+ */
+void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 10d84ebf77bf..062e963a8838 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -583,11 +583,38 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	return -ENOMEM;
 }
 
+static void nfp_zone_table_entry_destroy(struct nfp_fl_ct_zone_entry *zt)
+{
+	if (!zt)
+		return;
+
+	if (!list_empty(&zt->pre_ct_list)) {
+		struct nfp_fl_ct_flow_entry *entry, *tmp;
+
+		WARN_ONCE(1, "pre_ct_list not empty as expected, cleaning up\n");
+		list_for_each_entry_safe(entry, tmp, &zt->pre_ct_list,
+					 list_node) {
+			nfp_fl_ct_clean_flow_entry(entry);
+		}
+	}
+
+	if (!list_empty(&zt->post_ct_list)) {
+		struct nfp_fl_ct_flow_entry *entry, *tmp;
+
+		WARN_ONCE(1, "post_ct_list not empty as expected, cleaning up\n");
+		list_for_each_entry_safe(entry, tmp, &zt->post_ct_list,
+					 list_node) {
+			nfp_fl_ct_clean_flow_entry(entry);
+		}
+	}
+	kfree(zt);
+}
+
 static void nfp_free_zone_table_entry(void *ptr, void *arg)
 {
 	struct nfp_fl_ct_zone_entry *zt = ptr;
 
-	kfree(zt);
+	nfp_zone_table_entry_destroy(zt);
 }
 
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
@@ -605,7 +632,7 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 				    nfp_check_rhashtable_empty, NULL);
 	rhashtable_free_and_destroy(&priv->ct_zone_table,
 				    nfp_free_zone_table_entry, NULL);
-	kfree(priv->ct_zone_wc);
+	nfp_zone_table_entry_destroy(priv->ct_zone_wc);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
-- 
2.20.1

