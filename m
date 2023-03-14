Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476E86B8B51
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCNGhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCNGhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC72796C07
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4usMP99eRUgRejPxpdM6S7yJJPkRXcUNwGqJSmxsAMWIicj9HxTf+GuH2Ivt9xcUQLqg5l4G4PEipgTAgv5hJAlbHPqXVR5XAn1E4pdvLoLW4taXNnRMM69ZCQeCK8lSCClEFGHH0Ns+IqEZVTBwblEPotNtf0YDM+E4X/EWI0zXFW969SoV8MlHUYfCoXTGUDndwJ1ErXx6MeLfgjvEyFUfxEuM5QaLEcK7HmcS7qtxpTmItX4gwkJuo9DkY3DiftPlayJpqipnd0UixgMRe4ZD0ob5D3BbZRiypDF7owhuZoSHPGxPauZrWKctQgEDzUcag6tXK69vaC05sM2bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xrJLZ6+o6bUbcXVMXvnkLtrrFufGnBxCY1d4x1upUqw=;
 b=alnS37szYnBlIeTLR+H2+CzBQM2WmMiQXtkak1kTP8/oQMP2SroPdh3kX16UjtybHehvYBrT9az6cGrmrUvVYdRClelK8nsv0LUJd8/ad9XAknoiG2vXgoH5F2QGBDelXqtWTeQQyLGvw4ckNRDbQNNk5i7udPzGfbb58++3RCyjokbjfBIEWqFlJi/+imybXaWXkTAAUiFM+rfOTMranbVoXqTE79faJ70oJisUoLGT7WPR703kcj9Ty6ECge6jKcPZIcHAXCF6+Jo6/WCcdwxne67WAxBQgLIUh90vkLiRuDuEbfh8WKdDaLVLLa/Mlsv0/AyA5Qx+1eZKo6k5MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrJLZ6+o6bUbcXVMXvnkLtrrFufGnBxCY1d4x1upUqw=;
 b=f28Xek9kIGL8Nq/Ii9Cb43+uUjvkgfdzaCZVYVajqLvuz/2kLmWeAmwgUtHJ2tWQ8lyGjwAB3x5Yi1OwrWJ62l9w501u8Hyfu+7YRwsIxGhM9WIU013SbtH9gLvSYdDoGRHM5kDPsOfk3UzV30mPSpba1VUamVxafHzeT3W+S0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:17 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:17 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 6/6] nfp: flower: offload tc flows of multiple conntrack zones
Date:   Tue, 14 Mar 2023 08:36:10 +0200
Message-Id: <20230314063610.10544-7-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314063610.10544-1-louis.peens@corigine.com>
References: <20230314063610.10544-1-louis.peens@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA0PR13MB4110:EE_
X-MS-Office365-Filtering-Correlation-Id: 26f7fa9a-02df-41e3-4cc1-08db24568e4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7gstR1B5vZsZwrk6ZPDVRZio2pNg2OYwSFgQCpuiSQPaWIIUZnDLiW8jTkjpBfgWEBzqyOyNuyBcoiPEWqQ+Fas7BZY8XZA3E5MEynKc/Q1iGu4PcGI42EjmapnjfGGaKNf8cTjEnPth0pNdM6qY+wRO5LjuyjeVC2vyF40Y2m5UdXi4u3++xQxElrvQlUjAh9ZKCR/4/CQR7JQhv0hQFbdLI+TPJubA0oikB0zdoMXyUGvw4sO6QE1BRbzyAIqmYiRvBOGoN59cbZYKy6Adf7U9l8CEkFaDh+36NJNh8wuuW543biQSnSAQOLK6Er8fsb//q/hdYYzXqLQ6vwhkuI81VDhpFaPPR+fw1aVs3xac6TPYp6Ry3wHIs3ECJoGG70vs+BKKNuaKAW9ieiKeTSUwEMf9KAOVzF2718QBuL4X+sgwvil1+LOZFGp/oSBk2bhIKbXW44alEcxXkyNiXBbmI7oCilFQg+MxwgEM7CN7dw1Lajt7m17hJRl/XRCnffXVek2D2jOjAfEnfi/XZht1IeUK823NPvpM4hikkTUygNZrNRAKGSffP7jCq0uaMB7j2ferKlGQzilN6YV9Q+P7YVCMPkR1BjFHVly/by3EEyLJFAClD+FyG+pnQQypOv/yStt3IbsPGPR3bg0Cto8zsv9rE8dAXYussAN+S+yVCFOzqY8P1ftOY/yq7we5FpBpF99gDaDm2ZCqq+hqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(30864003)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(6666004)(4326008)(83380400001)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ydVc8v8ulwlgr9eyCSwfUbPxc0fmsnjqXhQq8T/d+F0LCm2x3bovDsbFn67?=
 =?us-ascii?Q?yBN+GmTXK3UzItdE9GG9yQtLauGcbwB9R+R0zimcMlD1QhEnpM8myZ1bintS?=
 =?us-ascii?Q?5dhjOi+Fxc9w8PGKIN+/Vqk9sNDIREjSJwr5B86AXVNazkkbzSTXgU3Rb1ZG?=
 =?us-ascii?Q?FiIyQIeot1BCHPVGmx3mTqxOsUhcpYZipFuGmKzEReG+wFyrJ+QEGJoFDTD2?=
 =?us-ascii?Q?PLtePmd3KvAhyNREwlZFgNPF9q3Vv9vg+sUahrXCotZ2/q43V9YzUTgT/WjY?=
 =?us-ascii?Q?rDhqu831fi5KNwubzgiRYEui9EaoWm4+iViX6ZmL35rAKJUs+TnUVTvT8t4+?=
 =?us-ascii?Q?OAIFyON8jIpUhi2KDm5XbtO0a6H+5aW+80e6OaaF8jd6vLQMVHpYWWGWi52J?=
 =?us-ascii?Q?p7B7wSq9cBwWPo7kFSG8n5uhJVDNCj6dBq+D9LiKNvetjpf92namim+K06ED?=
 =?us-ascii?Q?PUeVd1kNfG+2Qf3Kv3PFnjaazQpgY8NHE1D958vANFZ2dDu7d/si79hLXUWu?=
 =?us-ascii?Q?dLV+PPiYm7CPeDsiWID/lgZKpoZtdAo3T8MI8kdTsP5PIbnzSQCYRiRsD5B2?=
 =?us-ascii?Q?z8lL97a8NQfMhw/7H8pArcL8BYOvwr292YHSzPRPoA8DscprZYRp8OzpFLZq?=
 =?us-ascii?Q?Di72kb01yIgfH0oF3NDUOqI4+lHePvNITOMrT2flsrPFq8QwsQUr+jHchCy8?=
 =?us-ascii?Q?0xvWpmr8LeV0OHlxB7WraCbu2FYdb/56q7WSujKbgkQhtjZ7oly88bQurxGs?=
 =?us-ascii?Q?KvWfqheIw6XE38oj+RVSKGf0YHswefCg5jq0vhaev7+JbQ+DxyVtU5+Cw+YP?=
 =?us-ascii?Q?e8jjvOa6+mUtEN9Lc3pxjvNl/dOmBgjnTiYj/x+K6YTzHN54EP+s7M21qCae?=
 =?us-ascii?Q?PHTc5+dp5J5yLFo2kfSisTnRozTnH+3hfOSB0nuIeEJEvlaMlO3r/tTe6BM7?=
 =?us-ascii?Q?DxQfEjShMSUNx+qCIihySdA18emI23FPZ6RxMAyYk1HCLLWFUUgHAQMVvSde?=
 =?us-ascii?Q?hVeLi3UUbg9k3I7APz2y5lS646rvU3jh0uxzXmisNFFp2MC0gPfM79UzQlZe?=
 =?us-ascii?Q?HdQoiEInOHt/kYM62ua+Vv4XUZyikyWHIL1LOL+fIuPezMhbdpbbgV8kn6ff?=
 =?us-ascii?Q?lYNwGjV/qdja/L7PkPLfKPn/M80kvt6jxyVEkuw+ijVmdY12T7tiL+ck945i?=
 =?us-ascii?Q?SzEFVx47p8fO2RGFWcF97vv0BWHIGkoQFDJ7N4aeFnyYxArTuf+jeBaEoeVw?=
 =?us-ascii?Q?SaP4ZXwl1HK35wXsyg7t6ZbCRK2tkP+00bfe1OUYoRrpGCNsDAobV9011Nnr?=
 =?us-ascii?Q?yWZDvI05eVfuHHj+XnrGVHoZJNFNnMrScMGCYeB+GUDc5aY74H2qyLjyNp2q?=
 =?us-ascii?Q?rBHPA+q/4VKKuDqgKWOzycpVkPWoovQP+rcP44C78AkxY58B9//R5yik91rV?=
 =?us-ascii?Q?HaWq2aqVb37rVDzUfRyZ1vfxabaf3QI/wiDZ2Dw2Z55SunchowFPaD2EwYv2?=
 =?us-ascii?Q?INTyt+t7hzFSojybuJ/8rJ2XD5mNmN/YwMb86PKKFGeSkspl/7r5g726slp5?=
 =?us-ascii?Q?JBqBdjwzAvoMK6byFzE1Bi6RFAaAXO7wAHIdmwM+AKeVthnmxWczSutjm/vD?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f7fa9a-02df-41e3-4cc1-08db24568e4d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:17.8150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LgJuXjIeUu8Q9CyEomCuUbCK5Yh7ofyAtmMlUieUIKHm9zAwMr/J7rk4hwb6P9kbH1Kyj7aM9/OuGwY9ypEZ3INM3i72X3UxVvqca0TMWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4110
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao Jia <wentao.jia@corigine.com>

If goto_chain action present in the post ct flow rule, merge flow rules
in this ct-zone, create a new pre_ct entry as the pre ct flow rule of
next ct-zone, but do not offload merged flow rules to firmware. Repeat
the process in the next ct-zone until no goto_chain action present in
the post ct flow rule in a certain ct-zone, merged all the flow rules.
Offload to firmware finally.

Signed-off-by: Wentao Jia <wentao.jia@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 145 +++++++++++++++---
 .../ethernet/netronome/nfp/flower/conntrack.h |  30 +++-
 .../ethernet/netronome/nfp/flower/offload.c   |   2 +-
 3 files changed, 154 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index ecffb6b0f3a1..73032173ac4e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -522,6 +522,21 @@ static int nfp_ct_check_vlan_merge(struct flow_action_entry *a_in,
 	return 0;
 }
 
+/* Extra check for multiple ct-zones merge
+ * currently surpport nft entries merge check in different zones
+ */
+static int nfp_ct_merge_extra_check(struct nfp_fl_ct_flow_entry *nft_entry,
+				    struct nfp_fl_ct_tc_merge *tc_m_entry)
+{
+	struct nfp_fl_nft_tc_merge *prev_nft_m_entry;
+	struct nfp_fl_ct_flow_entry *pre_ct_entry;
+
+	pre_ct_entry = tc_m_entry->pre_ct_parent;
+	prev_nft_m_entry = pre_ct_entry->prev_m_entries[pre_ct_entry->num_prev_m_entries - 1];
+
+	return nfp_ct_merge_check(prev_nft_m_entry->nft_parent, nft_entry);
+}
+
 static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 				  struct nfp_fl_ct_flow_entry *post_ct_entry,
 				  struct nfp_fl_ct_flow_entry *nft_entry)
@@ -796,27 +811,34 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 {
 	enum nfp_flower_tun_type tun_type = NFP_FL_TUNNEL_NONE;
 	struct nfp_fl_ct_zone_entry *zt = m_entry->zt;
+	struct flow_rule *rules[NFP_MAX_ENTRY_RULES];
+	struct nfp_fl_ct_flow_entry *pre_ct_entry;
 	struct nfp_fl_key_ls key_layer, tmp_layer;
 	struct nfp_flower_priv *priv = zt->priv;
 	u16 key_map[_FLOW_PAY_LAYERS_MAX];
 	struct nfp_fl_payload *flow_pay;
-
-	struct flow_rule *rules[_CT_TYPE_MAX];
-	int num_rules = _CT_TYPE_MAX;
 	u8 *key, *msk, *kdata, *mdata;
 	struct nfp_port *port = NULL;
+	int num_rules, err, i, j = 0;
 	struct net_device *netdev;
 	bool qinq_sup;
 	u32 port_id;
 	u16 offset;
-	int i, err;
 
 	netdev = m_entry->netdev;
 	qinq_sup = !!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ);
 
-	rules[CT_TYPE_PRE_CT] = m_entry->tc_m_parent->pre_ct_parent->rule;
-	rules[CT_TYPE_NFT] = m_entry->nft_parent->rule;
-	rules[CT_TYPE_POST_CT] = m_entry->tc_m_parent->post_ct_parent->rule;
+	pre_ct_entry = m_entry->tc_m_parent->pre_ct_parent;
+	num_rules = pre_ct_entry->num_prev_m_entries * 2 + _CT_TYPE_MAX;
+
+	for (i = 0; i < pre_ct_entry->num_prev_m_entries; i++) {
+		rules[j++] = pre_ct_entry->prev_m_entries[i]->tc_m_parent->pre_ct_parent->rule;
+		rules[j++] = pre_ct_entry->prev_m_entries[i]->nft_parent->rule;
+	}
+
+	rules[j++] = m_entry->tc_m_parent->pre_ct_parent->rule;
+	rules[j++] = m_entry->nft_parent->rule;
+	rules[j++] = m_entry->tc_m_parent->post_ct_parent->rule;
 
 	memset(&key_layer, 0, sizeof(struct nfp_fl_key_ls));
 	memset(&key_map, 0, sizeof(key_map));
@@ -1181,6 +1203,12 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 	if (err)
 		return err;
 
+	if (pre_ct_entry->num_prev_m_entries > 0) {
+		err = nfp_ct_merge_extra_check(nft_entry, tc_m_entry);
+		if (err)
+			return err;
+	}
+
 	/* Combine tc_merge and nft cookies for this cookie. */
 	new_cookie[0] = tc_m_entry->cookie[0];
 	new_cookie[1] = tc_m_entry->cookie[1];
@@ -1211,11 +1239,6 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 	list_add(&nft_m_entry->tc_merge_list, &tc_m_entry->children);
 	list_add(&nft_m_entry->nft_flow_list, &nft_entry->children);
 
-	/* Generate offload structure and send to nfp */
-	err = nfp_fl_ct_add_offload(nft_m_entry);
-	if (err)
-		goto err_nft_ct_offload;
-
 	err = rhashtable_insert_fast(&zt->nft_merge_tb, &nft_m_entry->hash_node,
 				     nfp_nft_ct_merge_params);
 	if (err)
@@ -1223,12 +1246,20 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 
 	zt->nft_merge_count++;
 
+	if (post_ct_entry->goto_chain_index > 0)
+		return nfp_fl_create_new_pre_ct(nft_m_entry);
+
+	/* Generate offload structure and send to nfp */
+	err = nfp_fl_ct_add_offload(nft_m_entry);
+	if (err)
+		goto err_nft_ct_offload;
+
 	return err;
 
-err_nft_ct_merge_insert:
+err_nft_ct_offload:
 	nfp_fl_ct_del_offload(zt->priv->app, nft_m_entry->tc_flower_cookie,
 			      nft_m_entry->netdev);
-err_nft_ct_offload:
+err_nft_ct_merge_insert:
 	list_del(&nft_m_entry->tc_merge_list);
 	list_del(&nft_m_entry->nft_flow_list);
 	kfree(nft_m_entry);
@@ -1474,7 +1505,7 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 
 	entry->zt = zt;
 	entry->netdev = netdev;
-	entry->cookie = flow->cookie;
+	entry->cookie = flow->cookie > 0 ? flow->cookie : (unsigned long)entry;
 	entry->chain_index = flow->common.chain_index;
 	entry->tun_offset = NFP_FL_CT_NO_TUN;
 
@@ -1514,6 +1545,9 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 
 	INIT_LIST_HEAD(&entry->children);
 
+	if (flow->cookie == 0)
+		return entry;
+
 	/* Now add a ct map entry to flower-priv */
 	map = get_hashentry(&zt->priv->ct_map_table, &flow->cookie,
 			    nfp_ct_map_params, sizeof(*map));
@@ -1572,6 +1606,14 @@ static void cleanup_nft_merge_entry(struct nfp_fl_nft_tc_merge *m_entry)
 	list_del(&m_entry->tc_merge_list);
 	list_del(&m_entry->nft_flow_list);
 
+	if (m_entry->next_pre_ct_entry) {
+		struct nfp_fl_ct_map_entry pre_ct_map_ent;
+
+		pre_ct_map_ent.ct_entry = m_entry->next_pre_ct_entry;
+		pre_ct_map_ent.cookie = 0;
+		nfp_fl_ct_del_flow(&pre_ct_map_ent);
+	}
+
 	kfree(m_entry);
 }
 
@@ -1742,7 +1784,8 @@ nfp_ct_merge_nft_with_tc(struct nfp_fl_ct_flow_entry *nft_entry,
 int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct net_device *netdev,
 			    struct flow_cls_offload *flow,
-			    struct netlink_ext_ack *extack)
+			    struct netlink_ext_ack *extack,
+			    struct nfp_fl_nft_tc_merge *m_entry)
 {
 	struct flow_action_entry *ct_act, *ct_goto;
 	struct nfp_fl_ct_flow_entry *ct_entry;
@@ -1787,6 +1830,20 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	ct_entry->type = CT_TYPE_PRE_CT;
 	ct_entry->chain_index = flow->common.chain_index;
 	ct_entry->goto_chain_index = ct_goto->chain_index;
+
+	if (m_entry) {
+		struct nfp_fl_ct_flow_entry *pre_ct_entry;
+		int i;
+
+		pre_ct_entry = m_entry->tc_m_parent->pre_ct_parent;
+		for (i = 0; i < pre_ct_entry->num_prev_m_entries; i++)
+			ct_entry->prev_m_entries[i] = pre_ct_entry->prev_m_entries[i];
+		ct_entry->prev_m_entries[i++] = m_entry;
+		ct_entry->num_prev_m_entries = i;
+
+		m_entry->next_pre_ct_entry = ct_entry;
+	}
+
 	list_add(&ct_entry->list_node, &zt->pre_ct_list);
 	zt->pre_ct_count++;
 
@@ -1864,6 +1921,28 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	return 0;
 }
 
+int nfp_fl_create_new_pre_ct(struct nfp_fl_nft_tc_merge *m_entry)
+{
+	struct nfp_fl_ct_flow_entry *pre_ct_entry, *post_ct_entry;
+	struct flow_cls_offload new_pre_ct_flow;
+	int err;
+
+	pre_ct_entry = m_entry->tc_m_parent->pre_ct_parent;
+	if (pre_ct_entry->num_prev_m_entries >= NFP_MAX_RECIRC_CT_ZONES - 1)
+		return -1;
+
+	post_ct_entry = m_entry->tc_m_parent->post_ct_parent;
+	memset(&new_pre_ct_flow, 0, sizeof(struct flow_cls_offload));
+	new_pre_ct_flow.rule = post_ct_entry->rule;
+	new_pre_ct_flow.common.chain_index = post_ct_entry->chain_index;
+
+	err = nfp_fl_ct_handle_pre_ct(pre_ct_entry->zt->priv,
+				      pre_ct_entry->netdev,
+				      &new_pre_ct_flow, NULL,
+				      m_entry);
+	return err;
+}
+
 static void
 nfp_fl_ct_sub_stats(struct nfp_fl_nft_tc_merge *nft_merge,
 		    enum ct_entry_type type, u64 *m_pkts,
@@ -1909,6 +1988,32 @@ nfp_fl_ct_sub_stats(struct nfp_fl_nft_tc_merge *nft_merge,
 				  0, priv->stats[ctx_id].used,
 				  FLOW_ACTION_HW_STATS_DELAYED);
 	}
+
+	/* Update previous pre_ct/post_ct/nft flow stats */
+	if (nft_merge->tc_m_parent->pre_ct_parent->num_prev_m_entries > 0) {
+		struct nfp_fl_nft_tc_merge *tmp_nft_merge;
+		int i;
+
+		for (i = 0; i < nft_merge->tc_m_parent->pre_ct_parent->num_prev_m_entries; i++) {
+			tmp_nft_merge = nft_merge->tc_m_parent->pre_ct_parent->prev_m_entries[i];
+			flow_stats_update(&tmp_nft_merge->tc_m_parent->pre_ct_parent->stats,
+					  priv->stats[ctx_id].bytes,
+					  priv->stats[ctx_id].pkts,
+					  0, priv->stats[ctx_id].used,
+					  FLOW_ACTION_HW_STATS_DELAYED);
+			flow_stats_update(&tmp_nft_merge->tc_m_parent->post_ct_parent->stats,
+					  priv->stats[ctx_id].bytes,
+					  priv->stats[ctx_id].pkts,
+					  0, priv->stats[ctx_id].used,
+					  FLOW_ACTION_HW_STATS_DELAYED);
+			flow_stats_update(&tmp_nft_merge->nft_parent->stats,
+					  priv->stats[ctx_id].bytes,
+					  priv->stats[ctx_id].pkts,
+					  0, priv->stats[ctx_id].used,
+					  FLOW_ACTION_HW_STATS_DELAYED);
+		}
+	}
+
 	/* Reset stats from the nfp */
 	priv->stats[ctx_id].pkts = 0;
 	priv->stats[ctx_id].bytes = 0;
@@ -2113,10 +2218,12 @@ int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 	switch (ct_entry->type) {
 	case CT_TYPE_PRE_CT:
 		zt->pre_ct_count--;
-		rhashtable_remove_fast(m_table, &ct_map_ent->hash_node,
-				       nfp_ct_map_params);
+		if (ct_map_ent->cookie > 0)
+			rhashtable_remove_fast(m_table, &ct_map_ent->hash_node,
+					       nfp_ct_map_params);
 		nfp_fl_ct_clean_flow_entry(ct_entry);
-		kfree(ct_map_ent);
+		if (ct_map_ent->cookie > 0)
+			kfree(ct_map_ent);
 
 		if (!zt->pre_ct_count) {
 			zt->nft = NULL;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 9440ab776ece..c4ec78358033 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -86,6 +86,9 @@ enum ct_entry_type {
 	_CT_TYPE_MAX,
 };
 
+#define NFP_MAX_RECIRC_CT_ZONES 4
+#define NFP_MAX_ENTRY_RULES  (NFP_MAX_RECIRC_CT_ZONES * 2 + 1)
+
 enum nfp_nfp_layer_name {
 	FLOW_PAY_META_TCI =    0,
 	FLOW_PAY_INPORT,
@@ -114,27 +117,31 @@ enum nfp_nfp_layer_name {
  * @chain_index:	Chain index of the original flow
  * @goto_chain_index:	goto chain index of the flow
  * @netdev:	netdev structure.
- * @type:	Type of pre-entry from enum ct_entry_type
  * @zt:		Reference to the zone table this belongs to
  * @children:	List of tc_merge flows this flow forms part of
  * @rule:	Reference to the original TC flow rule
  * @stats:	Used to cache stats for updating
+ * @prev_m_entries:	Array of all previous nft_tc_merge entries
+ * @num_prev_m_entries:	The number of all previous nft_tc_merge entries
  * @tun_offset: Used to indicate tunnel action offset in action list
  * @flags:	Used to indicate flow flag like NAT which used by merge.
+ * @type:	Type of ct-entry from enum ct_entry_type
  */
 struct nfp_fl_ct_flow_entry {
 	unsigned long cookie;
 	struct list_head list_node;
 	u32 chain_index;
 	u32 goto_chain_index;
-	enum ct_entry_type type;
 	struct net_device *netdev;
 	struct nfp_fl_ct_zone_entry *zt;
 	struct list_head children;
 	struct flow_rule *rule;
 	struct flow_stats stats;
+	struct nfp_fl_nft_tc_merge *prev_m_entries[NFP_MAX_RECIRC_CT_ZONES - 1];
+	u8 num_prev_m_entries;
 	u8 tun_offset;		// Set to NFP_FL_CT_NO_TUN if no tun
 	u8 flags;
+	u8 type;
 };
 
 /**
@@ -171,6 +178,7 @@ struct nfp_fl_ct_tc_merge {
  * @nft_parent:	The nft_entry parent
  * @tc_flower_cookie:	The cookie of the flow offloaded to the nfp
  * @flow_pay:	Reference to the offloaded flow struct
+ * @next_pre_ct_entry:	Reference to the next ct zone pre ct entry
  */
 struct nfp_fl_nft_tc_merge {
 	struct net_device *netdev;
@@ -183,6 +191,7 @@ struct nfp_fl_nft_tc_merge {
 	struct nfp_fl_ct_flow_entry *nft_parent;
 	unsigned long tc_flower_cookie;
 	struct nfp_fl_payload *flow_pay;
+	struct nfp_fl_ct_flow_entry *next_pre_ct_entry;
 };
 
 /**
@@ -206,6 +215,7 @@ bool is_post_ct_flow(struct flow_cls_offload *flow);
  * @netdev:	netdev structure.
  * @flow:	TC flower classifier offload structure.
  * @extack:	Extack pointer for errors
+ * @m_entry:previous nfp_fl_nft_tc_merge entry
  *
  * Adds a new entry to the relevant zone table and tries to
  * merge with other +trk+est entries and offload if possible.
@@ -215,7 +225,8 @@ bool is_post_ct_flow(struct flow_cls_offload *flow);
 int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct net_device *netdev,
 			    struct flow_cls_offload *flow,
-			    struct netlink_ext_ack *extack);
+			    struct netlink_ext_ack *extack,
+			    struct nfp_fl_nft_tc_merge *m_entry);
 /**
  * nfp_fl_ct_handle_post_ct() - Handles +trk+est conntrack rules
  * @priv:	Pointer to app priv
@@ -233,6 +244,19 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 			     struct flow_cls_offload *flow,
 			     struct netlink_ext_ack *extack);
 
+/**
+ * nfp_fl_create_new_pre_ct() - create next ct_zone -trk conntrack rules
+ * @m_entry:previous nfp_fl_nft_tc_merge entry
+ *
+ * Create a new pre_ct entry from previous nfp_fl_nft_tc_merge entry
+ * to the next relevant zone table. Try to merge with other +trk+est
+ * entries and offload if possible. The created new pre_ct entry is
+ * linked to the previous nfp_fl_nft_tc_merge entry.
+ *
+ * Return: negative value on error, 0 if configured successfully.
+ */
+int nfp_fl_create_new_pre_ct(struct nfp_fl_nft_tc_merge *m_entry);
+
 /**
  * nfp_fl_ct_clean_flow_entry() - Free a nfp_fl_ct_flow_entry
  * @entry:	Flow entry to cleanup
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 8593cafa6368..18328eb7f5c3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1344,7 +1344,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		port = nfp_port_from_netdev(netdev);
 
 	if (is_pre_ct_flow(flow))
-		return nfp_fl_ct_handle_pre_ct(priv, netdev, flow, extack);
+		return nfp_fl_ct_handle_pre_ct(priv, netdev, flow, extack, NULL);
 
 	if (is_post_ct_flow(flow))
 		return nfp_fl_ct_handle_post_ct(priv, netdev, flow, extack);
-- 
2.34.1

