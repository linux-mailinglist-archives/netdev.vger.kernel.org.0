Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D763A96C7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhFPKE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:04:57 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232110AbhFPKEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ef3OBl5Qr2vshSmE1CANRL94/vXttNU9YylgJtQ3GnzeaVB39PPkDsInMJ+PlEV+3KlnfMSe4Jlvfx2KO514golh6sHr8yXxMDVHDYvzqxN5oqBBz3grCI+p4ZPyXjtL4mUqy8O/q5nNTJl9gJbWMAYfKs9F3mErWN68LRFvMHjra4DeD5RN4xVr+xj/3mHlzhFCgGXnA15YBE4CdXdwpmIWCd+NqI2PcwsCk+dclt/GWMbM76hnUHomORM5+h/8QcWt+MX1BFguXP/8fye0R0Q7tlNqbPgnq07DeUjd25FO+WMtvvLAN1RDl8ofp7eQzPXeTElVG+7sG4oOVmMGHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WWEvIETZASNikfojdEylJxGQ6jzCteaeYiYnJliRqY=;
 b=CGh7/PHh7RDSkvvlgJ/Ea+P7brSOXwzWaf5DZqwSQ0XICbBJGjhTZStqnlCfURa3J1n0lIPrDNuYloTLUNJrqXSeE2U1lV9K9QpY6XkaMru9fsoFYSVij2mHyCJtQnQzjgdiMHCMX6/9g6xvFk3YTvoJ6j2pF+TKYBJaauzp9g2B0RXNZBVBYHreLK35lkcsPidclhN1lkc/bmFEtnzOTq9U1wCFTzVF9vk9Buj4lSxTH0gEmVSteKZjw1CXdvAQiLQaLJwv2rnXcSq5ovC8r5kN/EfBYh4/NnvdpSrPJBYgRTFyX3SF9qmddIyyaNDVFYfOi2uM3YHdF8UpobviPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WWEvIETZASNikfojdEylJxGQ6jzCteaeYiYnJliRqY=;
 b=L3o73i2ryH55Yh2DGC4jkGcJ8DPo4IRORMEYDL7T0N2JM5pSL04lusuDtLyeEEksFdsg7DYm5Lh1M8mu1U4rRU3P/DSL2HB1VMyJOgbHFKa5y2NSVIctaLWle484VjgMHnsusS+a6bpDMKa03GmYTV5BsStZQYCJp4+8YoFt3GI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:32 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/9] nfp: flower-ct: make a full copy of the rule when it is a NFT flow
Date:   Wed, 16 Jun 2021 12:02:02 +0200
Message-Id: <20210616100207.14415-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210616100207.14415-1-simon.horman@corigine.com>
References: <20210616100207.14415-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66772efb-3540-4d91-8f99-08d930addb69
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49710055E4835FFD74AC8F53E80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9GVUtnKgx3f/zG8OjXweJERD336xBYR2s5h7XJwalTznVwyI49COReUzzGqryM9ByypOaYrqEXTvVOISYaPwZmy9T+CYSwGzt5+J5Mdxi5CS+/o2D9LS+DP0foxybQfKHzKKEJIIudQvHmeqcTZHmQH6mfolwbmJ/7umY0rym3UNzOHLMYdMIcBRZgYstNIRO2acXhrgdcbRR46zE9hDQJHI9L9tO0vP9/yGJMtNmeKABU5giAm2tLaeU4Fcf3B0S2AIFmswPHLwceRT1106cigyKboGaKbwJqGYTBXi2XOl26UtrqFEU1n3kGOAnotWkgoFgumatzviREmef5smbeKwPkT8nLC6+pMAZJTuq+U0ehF+30TRJ2fJ85ruodcFqbG4Rucp4AZ02pPPhg91p9kWq2Hq2E+vm3WVhU8RMCB5aTb3/EO6DjKXWqKsArMvyWoYKjwFWkxUAVtJhu8dgFnBD1SGOSIyLvwDC8GU9JmQX73O6O+yeps6b00waVcnJ0ovhPfAvdpIMgrPP1OYBD6Ld5RRSqmORrXsnjOf8Sv4pJrHB9O0fkXDFulT/Y90wIjOdb7q1UGtE2ONbX6lgFaI/AI7ji/tpfFG9RMzebltVA5JyBrBnaMOmaJx7wZ1//ITxT8s1WFKJsTceiRYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KuEHRHMn3ujUbSHybDgvCZkb5zC2nYczGlQgepf2U7ljFnN77EUMbwnPcfcx?=
 =?us-ascii?Q?zlxuVX++bqlzUw+9sGb5YEU7uRjWiNwPrudhhvbW31FseQTk778VGsrEGAIN?=
 =?us-ascii?Q?49TFaQvRr7+Vft4EqC4tlv6tp1ig6oUHulouAVuYkLieOc4cWTFHC9VsANxC?=
 =?us-ascii?Q?4q3yS58+i1rT1pIsFDfNJS+VXedZHws8gpY82K9qsIhXc4yOSE00+xZT1b6T?=
 =?us-ascii?Q?L9YucQyuI4+sWfNdV+F5r5MlCuftyCl34bLM0ojn8eIu8P7Ro/hUmKK/O+4b?=
 =?us-ascii?Q?ZHv7d6kKzJbackrXC2i7YyRqM84p1KtZZ1FdtDDClGj8GBqRQWArynZHlm3F?=
 =?us-ascii?Q?tF+vEbHd1m9fe0WH7FI1J+QNTfrrOyGrBa+LAfwER4fCZxEloP1X5v0Gm3hK?=
 =?us-ascii?Q?kgmWNhbFg1fvMtvt0Xr1RyMF9oYmzj13PypSJV2tmjLrirvUKkXOLOxAfy8w?=
 =?us-ascii?Q?h6JYGvkaQesUK3NSrjLaWeDc9zqrl5jaJyUycTV0s5iLDlKsGTTAbwoQCuQo?=
 =?us-ascii?Q?L9ndxbO5mDoozMlBX6DnMRscG3bRbsQnFSHE5RvAYzZlH/13d8B2EvehrFTD?=
 =?us-ascii?Q?+w9JSDWqag6K856rCISV2BU2U5wmxSKBsI9H0Gd0dCl0uWDq5VNvfL8zmjCq?=
 =?us-ascii?Q?AtAjR9Dq65cixDjg10sgQb9yinF/IQkc0BJb5dbAngoPcjXCgVH1EHFQjRkb?=
 =?us-ascii?Q?qB/jU2+CoaOQDwmvObsrJZUslxYIFDoZEgoPnwKGQNiF3lwwOJytNVGJRStm?=
 =?us-ascii?Q?mtlL9ZU/pbci/rixtl5CZSebhYX+limpef/YBEdIHdKFTc92WgqOb/E93hJ6?=
 =?us-ascii?Q?7Z8qyyiZ2cbVYssWiB62IH6j8mmZj5XSD8dPgqH+h050wHwtdfynAEFhcCUv?=
 =?us-ascii?Q?OK/67dvPlS+OxBw+ZvVYh4A1jb3jWpEHNfmWSr3rOKKjp1CqNB/PbBnjDpi/?=
 =?us-ascii?Q?8Yhv57aGgwXD9Bxw9DVf3Co/Lr/7RWDFewgauE4US4RieJuCA3nGVHanyMvs?=
 =?us-ascii?Q?/VJgUFx3TgcGb3ZeD95LLT025FjL/KVel36oB1Zj2TU6NZmokCbQarnnJHgr?=
 =?us-ascii?Q?5WLjWjDMbdgaR8UKkBWj97whATjmcZW/Jew5zoJSQTlGwYVuVP8LmWoMop+w?=
 =?us-ascii?Q?iQl3hHe3SXcbNF4R3wgEUAa/Hk1GMG8pWq9HfgMhUfrlr7Bg73Mcj6ys8hVS?=
 =?us-ascii?Q?jTXOkLUFEcB+JaqW2OCFKnaILuX2m4GvWpeqcBeKQJx6TLB1D1h9Avo27bKK?=
 =?us-ascii?Q?2jSPdUxFN7IHnqOzZZ8CwcmwACdrFO8taM15GjhBom/U/72HCe/C3qCQhOD9?=
 =?us-ascii?Q?5Uqfd7vNvUrz6gQiSh9BK3D8Pkii3M+jWbDeRO6H33y0+86+SEYOqgQRi4sc?=
 =?us-ascii?Q?7G40od+MVEHEHYjJAeBSwjFhIXxh?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66772efb-3540-4d91-8f99-08d930addb69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:31.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8l0AxWNOBpZfAQzF71S8Ch4WHNGnphQcm5um0fvrrIOAG81bDMAZ/8w3cc+L730dWhyZbKI1G6PWn4spJtgBB076f2TUgikaKCgmYYcM8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The nft flow will be destroyed after offload cb returns. This means
we need save a full copy of it since it can be referenced through
other paths other than just the offload cb, for example when a new
pre_ct or post_ct entry is added, and it needs to be merged with
an existing nft entry.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 58 +++++++++++++++----
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 1b527f0660a7..2c636f8490e1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -194,8 +194,9 @@ static struct
 nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 					 struct net_device *netdev,
 					 struct flow_cls_offload *flow,
-					 struct netlink_ext_ack *extack)
+					 bool is_nft, struct netlink_ext_ack *extack)
 {
+	struct nf_flow_match *nft_match = NULL;
 	struct nfp_fl_ct_flow_entry *entry;
 	struct nfp_fl_ct_map_entry *map;
 	struct flow_action_entry *act;
@@ -205,17 +206,39 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 	if (!entry)
 		return ERR_PTR(-ENOMEM);
 
-	entry->zt = zt;
-	entry->netdev = netdev;
-	entry->cookie = flow->cookie;
 	entry->rule = flow_rule_alloc(flow->rule->action.num_entries);
 	if (!entry->rule) {
 		err = -ENOMEM;
-		goto err_pre_ct_act;
+		goto err_pre_ct_rule;
 	}
-	entry->rule->match.dissector = flow->rule->match.dissector;
-	entry->rule->match.mask = flow->rule->match.mask;
-	entry->rule->match.key = flow->rule->match.key;
+
+	/* nft flows gets destroyed after callback return, so need
+	 * to do a full copy instead of just a reference.
+	 */
+	if (is_nft) {
+		nft_match = kzalloc(sizeof(*nft_match), GFP_KERNEL);
+		if (!nft_match) {
+			err = -ENOMEM;
+			goto err_pre_ct_act;
+		}
+		memcpy(&nft_match->dissector, flow->rule->match.dissector,
+		       sizeof(nft_match->dissector));
+		memcpy(&nft_match->mask, flow->rule->match.mask,
+		       sizeof(nft_match->mask));
+		memcpy(&nft_match->key, flow->rule->match.key,
+		       sizeof(nft_match->key));
+		entry->rule->match.dissector = &nft_match->dissector;
+		entry->rule->match.mask = &nft_match->mask;
+		entry->rule->match.key = &nft_match->key;
+	} else {
+		entry->rule->match.dissector = flow->rule->match.dissector;
+		entry->rule->match.mask = flow->rule->match.mask;
+		entry->rule->match.key = flow->rule->match.key;
+	}
+
+	entry->zt = zt;
+	entry->netdev = netdev;
+	entry->cookie = flow->cookie;
 	entry->chain_index = flow->common.chain_index;
 	entry->tun_offset = NFP_FL_CT_NO_TUN;
 
@@ -276,8 +299,10 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 	if (entry->tun_offset != NFP_FL_CT_NO_TUN)
 		kfree(entry->rule->action.entries[entry->tun_offset].tunnel);
 err_pre_ct_tun_cp:
-	kfree(entry->rule);
+	kfree(nft_match);
 err_pre_ct_act:
+	kfree(entry->rule);
+err_pre_ct_rule:
 	kfree(entry);
 	return ERR_PTR(err);
 }
@@ -339,6 +364,15 @@ void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry)
 
 	if (entry->tun_offset != NFP_FL_CT_NO_TUN)
 		kfree(entry->rule->action.entries[entry->tun_offset].tunnel);
+
+	if (entry->type == CT_TYPE_NFT) {
+		struct nf_flow_match *nft_match;
+
+		nft_match = container_of(entry->rule->match.dissector,
+					 struct nf_flow_match, dissector);
+		kfree(nft_match);
+	}
+
 	kfree(entry->rule);
 	kfree(entry);
 }
@@ -419,7 +453,7 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	}
 
 	/* Add entry to pre_ct_list */
-	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, false, extack);
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 	ct_entry->type = CT_TYPE_PRE_CT;
@@ -464,7 +498,7 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	}
 
 	/* Add entry to post_ct_list */
-	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, false, extack);
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 
@@ -516,7 +550,7 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 		ct_map_ent = rhashtable_lookup_fast(&zt->priv->ct_map_table, &flow->cookie,
 						    nfp_ct_map_params);
 		if (!ct_map_ent) {
-			ct_entry = nfp_fl_ct_add_flow(zt, NULL, flow, extack);
+			ct_entry = nfp_fl_ct_add_flow(zt, NULL, flow, true, extack);
 			ct_entry->type = CT_TYPE_NFT;
 			list_add(&ct_entry->list_node, &zt->nft_flows_list);
 			zt->nft_flows_count++;
-- 
2.20.1

