Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1DE3988C0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFBMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:24 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:6496
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229665AbhFBMCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLhtSQY/ERmc2UAQbtxMNLjnUsMBEZdYMufwFyIbVtxntm+6aRhx11IvwG5gjY1RKer9sr4aEkij8PQhy+U46pcBh9Jatj0glXCwX3jLsrz6e/yNRm5lclUPYFQ5jYrEW1ZOklIklNP2a9bL82JDXR9wWiOlb5mQkY+r9FCNHXP3CiV2Ktr3BfaYUenatX5EpB5lt4q5MvWpXwcEO0tB/BrQ0oE++AfltcEnc4+2OMK76i8GhypvbIKvZ8u+E5t0e/FuIZj7kBuIWMm30m2J9JmlxJMOOesGo1itpqnxNts5zwwv20BSWJZ9gdsXcHhxdQi3AFx6pKDswh3k8gJr1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/ioLKxTs35z36oPNZG8q6glJc5x4RZXKLV/YIBZv+A=;
 b=IXT/QtaZ08vtCQbpIwipQpUYzXlpt0aR9xeu0PwKy2KGQ7VpH4HseiMNQuneJAGbGmAfM5UPZ+8VIZya84JWF8lQDFA4o9LoGw7W7pDndQSJaZsvGF4cRw7Y+arOYYfulYnmrIvoe1qYmqgArHgBDi1RZIXkRdO2J3za0AdtOLToTbrUlkB7pkW6W9+BJCb/m8fXxWbchIAB9DSs8kdycl7W7MfUGL1IUMAdmZH4G3Knok7xOka+Wdj7bp6J6ZA9QpKq1I2CwA3V3dc+0yNM28/ldMYzerKsNEe0k8JV9iRinstgI2h3O/XMdPDq8WZ3KEFy8l2U70VIvN0g3VYsLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/ioLKxTs35z36oPNZG8q6glJc5x4RZXKLV/YIBZv+A=;
 b=mJ5rnZvc3f3u/0HWmneTNGgNgqnqg8rxwWEwQfWP/i9LzDiumnTQwuv/DI3RNGMhMZypG6myNQ+I8kx3jTuc4NIVlvw7LJ5vVwSbqOsBQpv6oCTzLe/1vuXNrVw8PNoK1FG04fJdTrhs0DdGuvi10yl3QBIU/jr4NrOJGzvWbuY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 5/8] nfp: flower-ct: add nfp_fl_ct_flow_entries
Date:   Wed,  2 Jun 2021 13:59:49 +0200
Message-Id: <20210602115952.17591-6-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 726da3b0-4411-431d-c8fa-08d925bdff51
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB498693906131D011543F915DE83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Onui2vzKpZsHvNVx8pV4OciSLfPbKJEnuQiQrAFiGQHuS6+fg/9rYU9t1yccqBe5sRwES+yCKpmJtYJ+/aK9oDpisAO2GREkICwV1YktmEZzVvjNXYxCJ/T0OjZg1RHScqCtDOQ/pRxEq5UVKXWVZE8eVVzvNgzLqe/qbvCy29SV66r5bDQevY7DpoJi8X7gd3WZWVC5GvkOU2v0zwi2ksBuk10O/iC1Xii2q7nLC1e07n4lEjGqQyvwS83og35T5WcPDp8W/Xg8ra0EbkPozw4JUf0TNdZW+/vXiMCATFQz/YMMShhUftrsKIKPdRSEtbHhoF56GzzgxdCTOBbH8RoH/w4Cp+zwRqbuHwoofpQiejEEzlYkn2L+9PaFqjc/ygF3qi9P9wWck0AcPwxPaK885UMh12ybhxz/2KzF27wDfspo+2Hg1iZkyNt7yNRbXZ9yfoKNfmowUfVBTccM3sK//ZJ5KCA49CMELSwmf4gQTzE9UUohsOV+2AfHkFnqbgUv7j1C5ZAu2eLJ031lGkQ4fRKPDiMgTbibTlsYoln5Bw+3EvTBmT59bW8afTeFMWeYL+iakwV8P4K6pPl/Fxwdw1xroYO0p0aQAEu/Pq4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(346002)(396003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(30864003)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(83380400001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xJXX6elrCBWI946b9w4PGD7GgJYT8jAJKB6OgKEzVukPUwtM9/AfAhyPb0w7?=
 =?us-ascii?Q?v0uBkrpu8AXbvNq4R2OoNo5eKMaeIoajhTWiZKNPZqrz2kk+9UVnJ58dyjap?=
 =?us-ascii?Q?COFWH7pnyQaGR0XhEzWqa8TPDn5zYsODTX+j4rMmf4fu5VF3Negf154AdWnU?=
 =?us-ascii?Q?iAY+CBYKa1I9UAyJMtYlYoiwBs0vKRRbqAomk3zflcdL1+XuKUzqm8rMyssP?=
 =?us-ascii?Q?HO+UVHdYe9vN8+Dfpa1XA4+02KEpQdodekKDSpw9Su1XlTH2Amk9C3vNIakR?=
 =?us-ascii?Q?XXnMTRPsoiEd1DrHUf37UjUFuSCOKClYMXTtGLDhrI6OVSMw4SJarFuiQubv?=
 =?us-ascii?Q?2gSC4fJWSo9FV7wzP135kBB2YgUt/4QKSwDjKxoWYLHYx/XvBFW080sq/7at?=
 =?us-ascii?Q?hXrWo8I0I6qQ+7dvQCp/ymn5ZLU0sKYHJOSHv6AfFaP2gIu3slx4Ley+4tuw?=
 =?us-ascii?Q?5HBcZPFC0I3BHuI/cOW4Zj9o2MVBNeY1CR32s2Dlth3ON90Y1t77R+Bi+GIB?=
 =?us-ascii?Q?Y/XSqATsuai8FjNPweKwmi4xkK+t49uKF1+QoUpPJuxgooW26KSQ5NJ74L9J?=
 =?us-ascii?Q?Bvf3+wqXZqzF8u+BLtGouwWhuw7YEEmZ7IJeCQBti8SSHaDI5yyjan7UpkHz?=
 =?us-ascii?Q?E/I/jCtoHo/kyAE2o/22d7FlhFF2QRvh3SY/75G9w/b6pF3U99aYjTBhFZ+I?=
 =?us-ascii?Q?Vh+BE0uRWdhFjmaCZUe7uqzvuDByjpjNsc0abEz1UDTEB4Un3mJRMo9B5usw?=
 =?us-ascii?Q?xUNBrLzJy5avUI27Iy98CVA+Prqcy1S/ClYmcFVVfFWSw1PKYGPqLvh3WyQN?=
 =?us-ascii?Q?1twLqOrBi2qKFTNBz963IEVAXMa1Y4L21SbceKWSkns7es/D0Y4w+H30U0B4?=
 =?us-ascii?Q?zfAqccmcC1ZJaJ/4DXX2jzPmOMnalm0N+ABGCZlacB7NpSgfeXOcZX5DtxQC?=
 =?us-ascii?Q?gOC4BXxMx06189Y+Df3Uom3vFeIUaNb6M+qLAP/VgSO2NUmA3zYdR7Po8coX?=
 =?us-ascii?Q?bz1oG0xGe/64ukyFs8WUFc0ljpOhmA6eiKHZ44QyqYqqNd+mAkLjoGflKIIr?=
 =?us-ascii?Q?zWeMa6EZK8xFi8zTxE8s3abF4MBg777AQOFK0R8OyD4DJrgNQVZ5FgVwdtPy?=
 =?us-ascii?Q?rdAstzqX9pDT7YqpMXwEsTHYrsILA36O1sxsReYj87STmKYG8k14OrY6XF9F?=
 =?us-ascii?Q?3zfTQkuRZyeQ7Otqv5eaIlNVa2BJ74/Y06OY+CkhmZMeuBYFi5Z+uSK11lla?=
 =?us-ascii?Q?bw3vXX4Vi45Js5MQ1v4R9iuuKw66W5vYSnvFh1QarOeflVJvuhdlfaEiqPX7?=
 =?us-ascii?Q?HpWmiXqmTlleuZmcrUBZXgExSiDnvdHG7MwZ6daJgAu354adsrvdWuY9E7v+?=
 =?us-ascii?Q?UYovtbhONrwwLiQnt6xaA0PoYPGa?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726da3b0-4411-431d-c8fa-08d925bdff51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:21.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRyEAm7uoMvXsHn8WIWLTguKJf8qLxm8B/w8G0iEcXzHudT3jowRAW9eS88wq01F7MFTNrEAUbAdlEEKzepK47sLgGO6sgNwoyqp6ck0L6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
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
index 9d63a8f89397..57a5ba5f2761 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -83,6 +83,10 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	zt->priv = priv;
 	zt->nft = NULL;
 
+	/* init the various hash tables and lists*/
+	INIT_LIST_HEAD(&zt->pre_ct_list);
+	INIT_LIST_HEAD(&zt->post_ct_list);
+
 	if (wildcarded) {
 		priv->ct_zone_wc = zt;
 	} else {
@@ -100,6 +104,100 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
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
@@ -118,7 +216,8 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct flow_cls_offload *flow,
 			    struct netlink_ext_ack *extack)
 {
-	struct flow_action_entry *ct_act;
+	struct flow_action_entry *ct_act, *ct_goto;
+	struct nfp_fl_ct_flow_entry *ct_entry;
 	struct nfp_fl_ct_zone_entry *zt;
 
 	ct_act = get_flow_act(flow, FLOW_ACTION_CT);
@@ -128,6 +227,13 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
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
@@ -138,7 +244,17 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
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
 
@@ -148,6 +264,7 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 			     struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct nfp_fl_ct_flow_entry *ct_entry;
 	struct nfp_fl_ct_zone_entry *zt;
 	bool wildcarded = false;
 	struct flow_match_ct ct;
@@ -168,6 +285,17 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
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

