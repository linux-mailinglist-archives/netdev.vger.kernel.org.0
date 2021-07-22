Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C253D1F85
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhGVHSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:12 -0400
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:59110
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231229AbhGVHSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShtR8/u39h4YeliTJyec3srXj6phjsldsky2JPRwNKyIdzg2Bod0hAaoAH1jtO3oRNt7YfzY6wSP9s56hJ37IxS8xJYECddA0Fz6AvJvHYb1NZPqWdukVImwGM4uhB+8XCMrMzov4mUrph01UzCz/D2gBqBbJT3GCmV/Fo3IdVse4JXFQOHSbo33cDF9ckd2m8LRQA0VvWCocYtxZ6SX6P7F4JgT67kXG9CYQS/oA71PYtyyGXdyupm516SAWyxlprP/cJAS+cvajWJXKUsAFzZkL5jtSlTWKgLUYUSD/Ikw8tsD6DFLaZkXC32HS3aQaBypqdOMUzwVO3/JnDxC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wq87lS/zyx9+ZHwGuAZ/0BsU4bkRsIRTvBZ8wyilxOY=;
 b=mX3llmuhoKap3qVzYjAeQC+tMB01P0WnOYnrNM06vS9k1ufHCu9sWgyZnTGjt0UFJkdH0aPSb8gE99PVEi0F+0Ij56djQNXlMJaOE7s/1W7NdNkGjWhjzZ9bC+V8RahIAJAt8Xtj3pQjWh9PQTE5KDufEPmKtDQQLFWc2oWovV+F5uTl/mphyqB0hHD/CwV4/32OMU2V7BwrYN6gUNaqcpXvehb3he/WH4kTGdhn9TrB+PU+CF3eV9ANh7BH9jQCaLKXZSFb6UHg+qMONA78l4/2l/m+smInqY+p/6TBWWTfwOfu1hsXjkPRtz3gW7qigiAIkqrliFK6fZUKRRB2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wq87lS/zyx9+ZHwGuAZ/0BsU4bkRsIRTvBZ8wyilxOY=;
 b=LjRQRarAHxzfVmxWMDojCYMBW/9fF7LD5oOULcuRRyntSDXVnRZJQgowPXgm1eRVcyTCZzN8EyKepuXMcuUX6ShT6GhkXuNT414Vj1VIelUtHeJXg+m5vN+XYWzumQ9nWyBAUH2IXJalkYGIUfRPulxtOKDHwpRlRCzOk9rOWQw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 07:58:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/9] nfp: flower-ct: compile match sections of flow_payload
Date:   Thu, 22 Jul 2021 09:58:04 +0200
Message-Id: <20210722075808.10095-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 802afa02-45b8-476d-044f-08d94ce68266
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB47785EAE17D9978C35FFFFFDE8E49@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /b5wXBISlAIofImH2wY/JypYCYAsZoNEq/CBUQ2PrM6dCQm7gOWAxHj9EuLARZQPnNPMlna507W1grZdsxYPRSTVdaRfUb8fYYPOmEU/qQeCyJPB8X2P1+3WVdFvFx5dsFzpi/HIbNLQWJyo9DIDfQKrWSOa1frAztt3Df6meeARVUDX2VsU3ty6j1DSQO4rXFTM5YTREhs5K864zJbq02zMDdqEvhx1dTeQ7e3QFAnhY/am1gmXqJXnIqE3o/idPL5V72vYWCUCN6zjQNFk4gajcwIoZLisRSeMcRa1lKSBXo7nZ+j7FEqAuy5cyq3mrKLSPXq6VHkygcbgRGJD8m1cvHXWug9nklQFK55957M1uu0+KrL66fC37HxegLLYbnXxXxXvgvJvv5pEWs3u3fHKPUYHdSgFoOxZd9JC5c5NCMBoyQFLjhG6eYBp6tvkt+PSqCShHVjQ7JVOgbJYITjjrJAAbKA1nyUehyZU88WauO0vRhz0zhFLihOG9ZxEeeor3HMVtFQFlG18smLGkumTT2tsBdwXiZwtNc4TFWtYXQw05B57YtHTISKS28pqfTtV7WRXNM9B7AstyBFw394G8ZnAZ7sofUbFwq237Q0SQmvso8BjaOSkbRYyKvV2zxJFrJeUMEwVlDiqTkRcVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(44832011)(2616005)(36756003)(66476007)(8936002)(66556008)(8676002)(5660300002)(54906003)(6486002)(107886003)(186003)(38100700002)(6666004)(478600001)(2906002)(66946007)(6512007)(52116002)(1076003)(6506007)(110136005)(83380400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4rSE5Xz1zGbu21+6lSL48wnkg9ly+XYX8KHnL3yC+vyf1+sxh4iFIShOr7Im?=
 =?us-ascii?Q?w6n89CbUxhIoiH8ypmzTox6kR4pFOmhjjDvmUU23kNtwvl8tAluJ9MzrW5Gv?=
 =?us-ascii?Q?DHeKb/DscXIfkRU94l8De2Wk/79fPDUnz6B9oyDEac3bFKGWQrjsfbNrNvZu?=
 =?us-ascii?Q?IplLKFAfQGAYLeY9XYNvDHT1dSYITEXlcDp9LVvXsU67Q3p5t1AiAMPi5NNw?=
 =?us-ascii?Q?tViqPas7OfRpSryb9LntNX796QMgyqSqdm+ozKBzqUB8hwcsWRu05mmJN13W?=
 =?us-ascii?Q?MNWvzM27x+ehRRmlfb7IhlX5CA9/YEFnqhikLRiv/sRbbZ+dQBtzx/MNarFO?=
 =?us-ascii?Q?CrbJqrbHol3YGyUrQkt0hNE2u27XBRhESGhcdyCA1ZKSuVx5tcRvoXwSV7VS?=
 =?us-ascii?Q?kz+g3E+sVWnn1AhkbOmTtBO6UQrJBFDu/8js9DRRsfRH3L+L/MwQPyAdA45W?=
 =?us-ascii?Q?95kKPttstdsGYxOL4tMpy8FtrodkEBSuo5H5iH/3UY3ClwrA4ifqHObUh5EE?=
 =?us-ascii?Q?kFWUQLlA6/PAo9G7FRGoO5EDNxolvhLzDgbwmyjiIu8ro2BCuTfkclKUJ+VY?=
 =?us-ascii?Q?qKheX8Qpl6AAm/QOuZPbPhmcOoLdxoT1msrNM4yT9+9FmVu0i/Y50ch9JNRM?=
 =?us-ascii?Q?lYBTVNQt86CVHYbv4TkMKnhK23pgF8JBqmWbfYuB4mtqPPOguMOXQ0MQ9Kdt?=
 =?us-ascii?Q?FNYLa6KmtRJBiMV203td6Hhk/YRp3WqLKHujDkZFhHwQ39xnw5mfQ4kne5eC?=
 =?us-ascii?Q?x8HdHeKFhmO/vvmNavpOnoSvevvX5pYon/NAuiFzFMdrD2GA5Yn10zRktVpB?=
 =?us-ascii?Q?oz8Koc709rAyxMQ05yyV7TGU3rwwJIBR6AgA1xd6v9qUFDATzxy9q9j8t8nJ?=
 =?us-ascii?Q?uuWJpu+mW5JNIkpFQ95jy8yU7fvw+5p+lnyTA6TgbAQY6LU968mytMs6VP4o?=
 =?us-ascii?Q?2M/rhReAGbHrhZUiyNO1lmXb9HDwnOZKSnzoIx1uDfo5Wr+4RSli+4PlCNYy?=
 =?us-ascii?Q?46IdwAFWAYRF55mGdOxtVeay/NyFpHR8aDisTXLKR3NCV6yh4l1Jjf3tqx7c?=
 =?us-ascii?Q?WpGP4MLn/br2Li23WR5bxE2miw7z9xmzOYA+5NG/43fLFrovQpsf7kNvzEwV?=
 =?us-ascii?Q?O5soBdRV9Rot0TUOl1dEdiDqeCmrbVP5HpYgxZ6nMqShioVocwiX1iQ+GUf0?=
 =?us-ascii?Q?9n/UaC3NT8k2ORxPo2l2+SO8qWCQ6y1jToiXz+ZBxEBt8wmOK5Fs+CihGLmB?=
 =?us-ascii?Q?zd+q3iy1DPFBL3U4+HxrOHBoiT/uTkOQkwG+yr5fIQJatISYb74sxTSNI+FU?=
 =?us-ascii?Q?fIaejx3Nh82st07ZMH++hvaMDm/9lZDBLyo3AZN+9szsY/dcoqQRaQwFsC5r?=
 =?us-ascii?Q?QZbOs2sDEpjbN2GfXTEZcBoi80of?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802afa02-45b8-476d-044f-08d94ce68266
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:36.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YnqS/8bNReAqd+tYtzFO2GlnbaZs4NAlODw5fvUfBJeIHeyM+NHhN40bPAWkFQNtIxlUX6F3mzfb0LhBMVt2t7tywDg2Yrmi2IkoCBJiCqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add in the code to compile match part of the payload that will be
sent to the firmware. This works similar to match.c does it, but
since three flows needs to be merged it iterates through all three
rules in a loop and combine the match fields to get the most strict
match as result.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 224 +++++++++++++++++-
 1 file changed, 223 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index e3fbd6b74746..e057403c1a8f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -478,10 +478,19 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	struct nfp_fl_key_ls key_layer, tmp_layer;
 	struct nfp_flower_priv *priv = zt->priv;
 	u16 key_map[_FLOW_PAY_LAYERS_MAX];
+	struct nfp_fl_payload *flow_pay;
 
 	struct flow_rule *rules[_CT_TYPE_MAX];
+	u8 *key, *msk, *kdata, *mdata;
+	struct net_device *netdev;
+	bool qinq_sup;
+	u32 port_id;
+	u16 offset;
 	int i, err;
 
+	netdev = m_entry->netdev;
+	qinq_sup = !!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ);
+
 	rules[CT_TYPE_PRE_CT] = m_entry->tc_m_parent->pre_ct_parent->rule;
 	rules[CT_TYPE_NFT] = m_entry->nft_parent->rule;
 	rules[CT_TYPE_POST_CT] = m_entry->tc_m_parent->post_ct_parent->rule;
@@ -503,7 +512,220 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	}
 	key_layer.key_size = nfp_fl_calc_key_layers_sz(key_layer, key_map);
 
-	return 0;
+	flow_pay = nfp_flower_allocate_new(&key_layer);
+	if (!flow_pay)
+		return -ENOMEM;
+
+	memset(flow_pay->unmasked_data, 0, key_layer.key_size);
+	memset(flow_pay->mask_data, 0, key_layer.key_size);
+
+	kdata = flow_pay->unmasked_data;
+	mdata = flow_pay->mask_data;
+
+	offset = key_map[FLOW_PAY_META_TCI];
+	key = kdata + offset;
+	msk = mdata + offset;
+	nfp_flower_compile_meta((struct nfp_flower_meta_tci *)key,
+				(struct nfp_flower_meta_tci *)msk,
+				key_layer.key_layer);
+
+	if (NFP_FLOWER_LAYER_EXT_META & key_layer.key_layer) {
+		offset =  key_map[FLOW_PAY_EXT_META];
+		key = kdata + offset;
+		msk = mdata + offset;
+		nfp_flower_compile_ext_meta((struct nfp_flower_ext_meta *)key,
+					    key_layer.key_layer_two);
+		nfp_flower_compile_ext_meta((struct nfp_flower_ext_meta *)msk,
+					    key_layer.key_layer_two);
+	}
+
+	/* Using in_port from the -trk rule. The tc merge checks should already
+	 * be checking that the ingress netdevs are the same
+	 */
+	port_id = nfp_flower_get_port_id_from_netdev(priv->app, netdev);
+	offset = key_map[FLOW_PAY_INPORT];
+	key = kdata + offset;
+	msk = mdata + offset;
+	err = nfp_flower_compile_port((struct nfp_flower_in_port *)key,
+				      port_id, false, tun_type, NULL);
+	if (err)
+		goto ct_offload_err;
+	err = nfp_flower_compile_port((struct nfp_flower_in_port *)msk,
+				      port_id, true, tun_type, NULL);
+	if (err)
+		goto ct_offload_err;
+
+	/* This following part works on the assumption that previous checks has
+	 * already filtered out flows that has different values for the different
+	 * layers. Here we iterate through all three rules and merge their respective
+	 * masked value(cared bits), basic method is:
+	 * final_key = (r1_key & r1_mask) | (r2_key & r2_mask) | (r3_key & r3_mask)
+	 * final_mask = r1_mask | r2_mask | r3_mask
+	 * If none of the rules contains a match that is also fine, that simply means
+	 * that the layer is not present.
+	 */
+	if (!qinq_sup) {
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			offset = key_map[FLOW_PAY_META_TCI];
+			key = kdata + offset;
+			msk = mdata + offset;
+			nfp_flower_compile_tci((struct nfp_flower_meta_tci *)key,
+					       (struct nfp_flower_meta_tci *)msk,
+					       rules[i]);
+		}
+	}
+
+	if (NFP_FLOWER_LAYER_MAC & key_layer.key_layer) {
+		offset = key_map[FLOW_PAY_MAC_MPLS];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_mac((struct nfp_flower_mac_mpls *)key,
+					       (struct nfp_flower_mac_mpls *)msk,
+					       rules[i]);
+			err = nfp_flower_compile_mpls((struct nfp_flower_mac_mpls *)key,
+						      (struct nfp_flower_mac_mpls *)msk,
+						      rules[i], NULL);
+			if (err)
+				goto ct_offload_err;
+		}
+	}
+
+	if (NFP_FLOWER_LAYER_IPV4 & key_layer.key_layer) {
+		offset = key_map[FLOW_PAY_IPV4];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_ipv4((struct nfp_flower_ipv4 *)key,
+						(struct nfp_flower_ipv4 *)msk,
+						rules[i]);
+		}
+	}
+
+	if (NFP_FLOWER_LAYER_IPV6 & key_layer.key_layer) {
+		offset = key_map[FLOW_PAY_IPV6];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_ipv6((struct nfp_flower_ipv6 *)key,
+						(struct nfp_flower_ipv6 *)msk,
+						rules[i]);
+		}
+	}
+
+	if (NFP_FLOWER_LAYER_TP & key_layer.key_layer) {
+		offset = key_map[FLOW_PAY_L4];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_tport((struct nfp_flower_tp_ports *)key,
+						 (struct nfp_flower_tp_ports *)msk,
+						 rules[i]);
+		}
+	}
+
+	if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
+		offset = key_map[FLOW_PAY_GRE];
+		key = kdata + offset;
+		msk = mdata + offset;
+		if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
+			struct nfp_flower_ipv6_gre_tun *gre_match;
+			struct nfp_ipv6_addr_entry *entry;
+			struct in6_addr *dst;
+
+			for (i = 0; i < _CT_TYPE_MAX; i++) {
+				nfp_flower_compile_ipv6_gre_tun((void *)key,
+								(void *)msk, rules[i]);
+			}
+			gre_match = (struct nfp_flower_ipv6_gre_tun *)key;
+			dst = &gre_match->ipv6.dst;
+
+			entry = nfp_tunnel_add_ipv6_off(priv->app, dst);
+			if (!entry)
+				goto ct_offload_err;
+
+			flow_pay->nfp_tun_ipv6 = entry;
+		} else {
+			__be32 dst;
+
+			for (i = 0; i < _CT_TYPE_MAX; i++) {
+				nfp_flower_compile_ipv4_gre_tun((void *)key,
+								(void *)msk, rules[i]);
+			}
+			dst = ((struct nfp_flower_ipv4_gre_tun *)key)->ipv4.dst;
+
+			/* Store the tunnel destination in the rule data.
+			 * This must be present and be an exact match.
+			 */
+			flow_pay->nfp_tun_ipv4_addr = dst;
+			nfp_tunnel_add_ipv4_off(priv->app, dst);
+		}
+	}
+
+	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
+		offset = key_map[FLOW_PAY_QINQ];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
+						(struct nfp_flower_vlan *)msk,
+						rules[i]);
+		}
+	}
+
+	if (key_layer.key_layer & NFP_FLOWER_LAYER_VXLAN ||
+	    key_layer.key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
+		offset = key_map[FLOW_PAY_UDP_TUN];
+		key = kdata + offset;
+		msk = mdata + offset;
+		if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
+			struct nfp_flower_ipv6_udp_tun *udp_match;
+			struct nfp_ipv6_addr_entry *entry;
+			struct in6_addr *dst;
+
+			for (i = 0; i < _CT_TYPE_MAX; i++) {
+				nfp_flower_compile_ipv6_udp_tun((void *)key,
+								(void *)msk, rules[i]);
+			}
+			udp_match = (struct nfp_flower_ipv6_udp_tun *)key;
+			dst = &udp_match->ipv6.dst;
+
+			entry = nfp_tunnel_add_ipv6_off(priv->app, dst);
+			if (!entry)
+				goto ct_offload_err;
+
+			flow_pay->nfp_tun_ipv6 = entry;
+		} else {
+			__be32 dst;
+
+			for (i = 0; i < _CT_TYPE_MAX; i++) {
+				nfp_flower_compile_ipv4_udp_tun((void *)key,
+								(void *)msk, rules[i]);
+			}
+			dst = ((struct nfp_flower_ipv4_udp_tun *)key)->ipv4.dst;
+
+			/* Store the tunnel destination in the rule data.
+			 * This must be present and be an exact match.
+			 */
+			flow_pay->nfp_tun_ipv4_addr = dst;
+			nfp_tunnel_add_ipv4_off(priv->app, dst);
+		}
+
+		if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_GENEVE_OP) {
+			offset = key_map[FLOW_PAY_GENEVE_OPT];
+			key = kdata + offset;
+			msk = mdata + offset;
+			for (i = 0; i < _CT_TYPE_MAX; i++)
+				nfp_flower_compile_geneve_opt(key, msk, rules[i]);
+		}
+	}
+
+ct_offload_err:
+	kfree(flow_pay->action_data);
+	kfree(flow_pay->mask_data);
+	kfree(flow_pay->unmasked_data);
+	kfree(flow_pay);
+	return err;
 }
 
 static int nfp_fl_ct_del_offload(struct nfp_app *app, unsigned long cookie,
-- 
2.20.1

