Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6028639445C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhE1OpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:45:08 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235340AbhE1Ooz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n237CC3jM5rlnTgVydDEfMbjKAuGXJAcAtuxJSDqmKxn/cuTnvUoUPTXL0MTdMW6RuTIdmd+5vw6Rrs0Tlp1l0DYiv7ynifgZC6ZxwoWlw1vmI9C0SWYAqUVrvQg+dqKWH6Kg7s61eLp4srN/prRgU4F1r70lyQrMVWAC/4oMmUQahONEWQJVGdCkSH+Y7dIR6V8/9TiOfD1yxN8YdLlKGrx9asFGT7gl55Rt26qwzvPCDDbcuWnyjW/EFhu0miDBi2JjMfxTvJSgyW3PUizA6hqNhAhg55r0sCukkJI8RwtHz/DVso3orPUkyB2ZOnPJsv5RIXDuui9Glpo6+SV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUuknGWQJCVQ0e2NA7ihTzscE5vzco4QsSVsbJYTu1U=;
 b=S7rbezNHM+AxBUHb/ajiZ/qN35LPqS44ksqOheQfqzsSXLS9uLS7oKbFi2frU1SN8L5UfUNC3BJCCUgYGcAFCwVe+yslgWyInLdZfy2wd4VKh9LqfSUNQLhTlSsTLZBheN7YYqksKrL2Xr4b7qy/HiZXirsHmU8Z8s+R7A5GqOEhC5KZXAPfUsbncmBNQ86fSUmooXNyLDznwtPknNPhX1HMlTBCV1edoJ7OJiiSl0FWp4SXfR0540FmP01iFyeB/HbnFF6lcdXiGTYG9iY1xk1HcV0rZngGUWZkuHt2XzGJZjqBXNU44qdyDh8jmEqicvWVC3UTSi/Zn1/JjJxEdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUuknGWQJCVQ0e2NA7ihTzscE5vzco4QsSVsbJYTu1U=;
 b=tKNSpIO4ZnlL8rGhpmoZuGvyQq+nOvOWEyI/hD38gxa6q17Lp27ajAavshDo1kxO5cMiKJHnzjQaeGzM940aw06vTnKIxmpcmyGD39uZyABwLzlpXD/TozZrmimiv1OEyk4FC9e9vz2zbx1lxBq/1drahaqVqHXzx6CNEwotKp8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:09 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/8] nfp: flower-ct: add nfp_fl_ct_flow_entries
Date:   Fri, 28 May 2021 16:42:43 +0200
Message-Id: <20210528144246.11669-6-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68523ae0-df3f-411f-a049-08d921e6e938
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50338134BEBBC1886C355F8AE8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9QgO7oz92xZ+8rdTVQ0Sv+JIf41y2UTCI04Pn0tTBEvO6Pw+9cLcmRx2HYJqZ2tGBCPj8ZPNktwpVYdNVZVWQAmdasgQW/DVpOOhxCld87XWBWC/UVcX0H/k5+b6ciFVMoVF+zSVEXb83xdIYP3UF6nRUwSUO2rjQdYkUXDpKAKN6eIzPlKtttsMvbw8WclbSBt/4oQi8GYIDIsxZHwd/cxidFbuoY8Y//ga3OywG0esYDvPEw/2nurM+2f65we6RgyOz/lmSKnXrkt3gWmEkqBSQ4SFIUqhfNRksBiImWTArpWNte8l0LRCUzcLBP/BM/tmZQKBW1ajEHDLbT5bnSCr7T26qw0NadEqcmDCn8OKq2iCm7gnpPLGebz416SiXtUU5PZyaZpihoIkOHrP9hO5vUZa9PbZwICSSjApWeyIHKUZLksRpBIZULdqxAUe7pSLaVLjdfZT+wCxCbpgCs6Z7AIrc6SGcGUHSf03mfUT8P1zX0iVkW7vaXAftjfccWON6sAQh/papEa7wylPXsnat0K4QjNNduMeNJI+zSrqf+++CjhBcvVIyHqq1XYuSTF4pMdWlLx9oAScYUaW5iQ8uytF2I2vsSqZJmpvuw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(30864003)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(83380400001)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aLk4usgwb3UCDqiABJ3QuLs9ZLjB2BlX19wWpeRmR5zLpuFsaFV/kvRMYi1A?=
 =?us-ascii?Q?sOCiciZz7MuvnQmYNHN4jKccb+Qnxdz1n2YaWAnua2fU2EEfcReTkETk8qZv?=
 =?us-ascii?Q?p69SDK1lLXwN9/brtFFCt7p/ms69QpbWTLW7dwDBT3lBGT1fUMqdsYroFmux?=
 =?us-ascii?Q?I8PchOQktLv8J28CpaD1ZGJDc98LegoZiXOUTF2PqlxyUxeGRnTh6FztYgkK?=
 =?us-ascii?Q?iPLXVM87TbXTRmpe514p3I0vk2XyBa01x/eVJoxxb+sf2GRXY991cGGvrsMY?=
 =?us-ascii?Q?pJQrh7JZpLAMLWEFZ37aKEHt1Jzj0I8r/smlNli7hfk3H7q+vx8S9asCYND1?=
 =?us-ascii?Q?+41LNpr6A0lrUzfX74i700pW4dY3dGOyGlyf86Zf04vkFZKje+GHTflNRqBy?=
 =?us-ascii?Q?WnSdr8SYDxmTt3yvzQ3EAOa5R++Z7AuaaQDP5bwUJQTcJ3xxOMWa6wtxc4qi?=
 =?us-ascii?Q?nqB67TNGPN8iFeypMrhzwSRsB/mkCypx8TmNMVaudV1ZOOq98JNSlTZQi6H6?=
 =?us-ascii?Q?ICXrNvQVk9+O6RWqq1FNg6HD5bGe9yID42fbds15qzQzv4rO0hMqJlEA92C7?=
 =?us-ascii?Q?xGsovUXB6x/mWEJmOzag73mSytGR7Mw/pxCE0i/a9LAN3Bb395rD97nAZB1i?=
 =?us-ascii?Q?8aDq537XFgJD01yZCgMnbRNhmjQ4x/Qqcosek8G0waTPOMO8W761xqZKBv9t?=
 =?us-ascii?Q?x9GHT8M88299NHlvVm9KUW4veWLizFL8DW4OTdBPoWZXdlN/DyLE6W7w4ogV?=
 =?us-ascii?Q?oXBhYoLz7vUAsVYbBUdEkIBd4xKG7Bsq8kMaJ9j5u/xJuv8WhvW46Jpk6f2p?=
 =?us-ascii?Q?q5eOi2GaiXCMC0ZxxfXPwPiK1E0SGRKOJFXnOVNW/IaHu00pO9INy4Df1qKP?=
 =?us-ascii?Q?izuTQ85UWf/Jo/8ouFy0jgcC5wRKptv/x7Ciozeig60f/lLi5jDAx40/zQrK?=
 =?us-ascii?Q?cYCCCHPBPgtw+XY5LSeC6W98vDG8sEdwN02U+KZ4kqvs8MWPsfBxBU6/r18R?=
 =?us-ascii?Q?3Pfr/2I19oWlHkQpbGfYSkOdpw9mKia4CPF6YgOCgE60QMA+AyDNZZJoOTsM?=
 =?us-ascii?Q?b066ngIEjUXLbKXklCJTG3By2ZgopVVyYIbPcxw3/h/rXq0LpLilK1j9kPB+?=
 =?us-ascii?Q?p8YYDRhQs05Ns/kcy9udQw2wci1DkHNaihCuZQH2c6BPGwd6S/tCHnhNsq8o?=
 =?us-ascii?Q?sOU7QIT3OsOy5aF1RxY8mWbEg+IVy9XOU+YLgURrep3H3Jc77Sm6hZ1mnKTB?=
 =?us-ascii?Q?02gIC5SA2DJxYP0Z+VBDGU3ru0eKx1YEDFpPAblFJhkHqnYUI1mH6WtErPmO?=
 =?us-ascii?Q?jYl6+Ht2n9oBt8wW7xwaSTTMHGjwew5PPP+N8q8LCNhn8ZYLtqzLwIAmQCeI?=
 =?us-ascii?Q?KLnDVL0HnmC7gpjM4VR4bQH/KKGX?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68523ae0-df3f-411f-a049-08d921e6e938
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:09.0723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yt+RKLokYtLVLZpbvoK+9TBralDcDuRKsHx4TyQMcothiFuv/Ko1ekX+q0LcFh5OM6Gv7R+/VscPMYSCBMt86mv10Jityh0P8aON46x3TbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
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
 .../ethernet/netronome/nfp/flower/conntrack.h |  50 +++++++
 .../ethernet/netronome/nfp/flower/metadata.c  |  31 ++++-
 3 files changed, 208 insertions(+), 3 deletions(-)

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
index 5f1f54ccc5a1..6a876ae89d9a 100644
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
@@ -21,6 +29,43 @@ struct nfp_fl_ct_zone_entry {
 
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
@@ -59,4 +104,9 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
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

