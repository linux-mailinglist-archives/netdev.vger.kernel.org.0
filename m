Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374E83D1F8B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhGVHSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:22 -0400
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:59110
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231281AbhGVHSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7sZQ2Srs/tkaok6dEAoHQM30tbtOxQbvkBPaSi8S5poXDGukK17Cdg4Mi48DXPB8YLu7RJkhWzplz9NumIAA+CNqGX1AICoWAESms3bnrkx9IYAGjOOKSoHoYJLXOhsLtqRE7uozeN+srMOC+UHwY5RI2gmByRLYZJ/opXHQ/1MoI10RBAMofDC6igXzTvIuAZ8Ww6senAu4Z2oGijg/7UmidnFzhoD/GKDjIN0ZzABDr6mDPwGH46bqQ/eGBRbw3I44P52y1D41BEB8hggR9MtOFZxHAtUcxf+Di7n9h4Vy89JATybWG6diPfpMB+YbruEN6iowKqos4mn1NlBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2pDO+sBjUIJ+8w/bIXbTBeUMqrFSNajIxAAAzfBeQs=;
 b=RWrEYHZe6bi77JLnywMBqLP1N6a8PW00tdBlAVEnFBqr+NVVEK8kyAPrzA3JjPu9Rgc9nXzQoKywNwF+cDry/vFQsu0jjpMXE77x/wxuYlNZyrIsZR9bD27+y56Vh71d9Axx7ORfeVBq7N6EzzDaJGtKAqyvMrsGOBmu9r49t+oimnnNlpTLN96p7uhThWkNic8CY5ikjqsnNhAJa7FdjkXGLF3jPqEXyuewNHF4rvby7q9BKpGnEwwNqcwsXtK7KCgdH6fDrXCVTceU5MWtduTmX50XkTJEnpGW5boyJfT0Qg8xD2A0WnoKu7LTRXhCJkqVuRFrJFdL3kcaIliEig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2pDO+sBjUIJ+8w/bIXbTBeUMqrFSNajIxAAAzfBeQs=;
 b=W7H4gBQQcyHuO3g0csm8sczNBOwjypgehqza8/nBoAsOI0CMycuT3yVfPDnykQG0wH21V8IhBKOAnB0m4ykoFDdwqpbaC+PHnTdpP5c7W4UnH5UCyGwy70IMm4+Z9VWFrMvri5uxhbyc3q5hOj6sbGqTM7CkD8L+FUZg3K0CnXk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 07:58:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:43 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 9/9] nfp: flower-tc: add flow stats updates for ct
Date:   Thu, 22 Jul 2021 09:58:08 +0200
Message-Id: <20210722075808.10095-10-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871e48cb-d3f1-4d3e-3418-08d94ce686b4
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB47789F136F21BD4AA57D81EDE8E49@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cq34Wihk7nh5PFcxxONzb6aOpn/NmFVVHTfxXPkH7RLqJwlwPgUfmbf7/FRNjvOkrhA/sEVgSoPXeQyRrq6uPf6MhPxb7Jl+8RLTWZuMTgg4joJsRkhfyHumhMO5yYF3B81PtOi1XGcrq9qdy/v9iZvNFVqczvyW2c57H9PXN7v5U9RCHYaSzt0B38je5xaUg/49LU5tG7ifZschjQ2ygN8ApXwdtfIQxyqInqt7yBR1LkMbbtiz3yd2mqsVY29LH19jlAKv+1RPblWHHg8wrXIIQFk1SRiI4WWBVk602d+UmFB5Ra2YMe7YGZyDd181csdr53MdFtwfExfs0UTRhvrtH6uHWUu4AC91JnMiiVJBLDGLPBATeMVtV9Fmma3As+n0v8JvLkulE9y7Cfy3SOrSJTV6l/iYIwZfzpmSa8EsFsaFbKociF5XECIrEAycemnwP9jys9pcpIJLjegdFcYO+DqQgS+3Ef36UiicZ+hEdMYX9h1ZFLBtcKfwhwgy21fasKoaHR/GvwJvv7iakBTSwiriertXWn0j1NpCShMG6Xt6NdykNUm7L/ZNA3Lhh2RQECHaJ9PxTeRx8u+6lecL+wNYaqOyGdRcHgUUF1cCh4VF3i3A5oinmBiTZjGXkZPYZMhfbnz1RxQqyn15Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(39840400004)(366004)(44832011)(2616005)(36756003)(66476007)(8936002)(66556008)(8676002)(5660300002)(54906003)(6486002)(107886003)(186003)(38100700002)(6666004)(478600001)(2906002)(66946007)(6512007)(15650500001)(52116002)(1076003)(6506007)(110136005)(83380400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i0PjhMCq//w9zXXVLNeblgXpAOabi90Uwjq0tMoEtuQdFxkgueOBmIZkTsIl?=
 =?us-ascii?Q?4OnECvdzj+Wp+TNJqFtk1IsdGDCx9VZ9/0nzYQEDtHQUsfLPJpWr2VG2lval?=
 =?us-ascii?Q?+GXGTFWWDuV1lhDCWxW6T0DgcUmN8g3fOvfY6T79lpTdyAzHkLIeYN51uaPp?=
 =?us-ascii?Q?e6DgonF5iC09q8RteIFPhH7DEWc5Pr9djqYBATzcmLepsfs9/WGadkGWIcSQ?=
 =?us-ascii?Q?pAS6PoYdLuMM6IClDt6QdEF+prZWSReCaBbnVxn2F0boUM78a3CZQWktrTIl?=
 =?us-ascii?Q?217WNYvbWwgZBHMT6/QHbjA/l5YgtPoZR2P8qXiFYL+dJ5kd8B25cpKQt8de?=
 =?us-ascii?Q?PSuQSrNBFHdI+J6ocm4L3ckWXVeXIEuEsBTLtDyDAF+rkuaLs5tIwjwJ2Zo+?=
 =?us-ascii?Q?JSc1A6AM3/kbtXhW/20UA5/JcVDbO1puq4sV0iJb50p1GWb5RSef8lLN7QeY?=
 =?us-ascii?Q?DMT0DRP80AiizYuuU4KOWBaOJyXrgmLg9DDcb0gZRkXl9JUpcEq0G09U3MX2?=
 =?us-ascii?Q?aSOGpZrem6SG4EW0Ij4s9AbZClmLlpVba5ghA9rLbkmWkMjcRFh4S+azPieS?=
 =?us-ascii?Q?ZmpQY/R34g7u19f/ck/YC2uctpUq2OZsgk4nSh4GesuSHQ5wFeMyOsnu2URb?=
 =?us-ascii?Q?P4dh1yp+KjSisugRKMFTdync6bebSdlCH8LCV4ymA84h1SlHq19HV/Ug7xBn?=
 =?us-ascii?Q?Lq/cwSXekMi1REE1A1ssRZkWmuj97xKJxqos+XUKl0yDquvHhKPLj439CBEB?=
 =?us-ascii?Q?4Q9sKJ059sTB6KCUBrKCNpNtxg5OUGItk2jiYDw5+J99fhuYv6NP1LAJ+1X3?=
 =?us-ascii?Q?v+hk690dK8aVNuL3JgmrcghlktfZdoxaDsmLwNh4ayOV6V68jmIdckkzQt17?=
 =?us-ascii?Q?7NjdDEBpghHO5ih1yHn5yo9TGcUU1Njd5u/dgYU7diPwcRS+/k69FhCf6Erp?=
 =?us-ascii?Q?sDLqcst5JEuTDAR+9i6UYQFBpOyB/w86DKNixu33TsLcAE04wBDwNq62+5AN?=
 =?us-ascii?Q?Jc/ofeZKHX7CwO2SK3ftdm0phtkfMULgTXJInylO3cnliDZeCUOM5bmVTWTT?=
 =?us-ascii?Q?CVo3DiOegGExTQpakPoXFT2+fGANzKcx82Q863A7HY1ufisWk1F4qTeIhy5z?=
 =?us-ascii?Q?v4wOCTy6cKRvV8I7AWVhOc7gw6TJY8KpziakBdwqnYQUGljmAyra7J1+oTFg?=
 =?us-ascii?Q?ud+8TZaS/ZOHMJMz5NiguQIhSseFPMcoQT0dDtz9TeJnDIwapA0kTKMbWEvx?=
 =?us-ascii?Q?1WQeAWdAZcXgdwHug/bexI6J+qfFBhLC7aSDd2vWBAeHlw8aQ8vDLLrEGzh4?=
 =?us-ascii?Q?q1nvPjvSdCy7Ik061oNXmN74GSs8+IoPJRvoAOS3sSC1o8ThWGwK3Vw0qVUh?=
 =?us-ascii?Q?uB5f6ZTm+8+E7aKbx+LJNN9KWnS7?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871e48cb-d3f1-4d3e-3418-08d94ce686b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:43.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACcE3OUKqVbeNTQ9OoeP7v2Iugg0zLm4GYT7ZtDemL2opzw23WvY73zfxhq9RJ7tUvg5+Csrf+HcmGaKyn1Zq6wZzC+x76NlhtTsDY88pGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add in the logic to update flow stats. The flow stats from the nfp
is saved in the flow_pay struct, which is associated with the final
merged flow. This saves deltas however, so once read it needs to
be cleared. However the flow stats requests from the kernel is
from the other side of the chain, and a single tc flow from
the kernel can be merged into multiple other tc flows to form
multiple offloaded flows. This means that all linked flows
needs to be updated for each stats request.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 139 +++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |   8 +
 .../net/ethernet/netronome/nfp/flower/main.h  |   3 +
 .../ethernet/netronome/nfp/flower/offload.c   |   9 +-
 4 files changed, 157 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index df782a175a67..2abf02eed7fb 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1521,6 +1521,139 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	return 0;
 }
 
+static void
+nfp_fl_ct_sub_stats(struct nfp_fl_nft_tc_merge *nft_merge,
+		    enum ct_entry_type type, u64 *m_pkts,
+		    u64 *m_bytes, u64 *m_used)
+{
+	struct nfp_flower_priv *priv = nft_merge->zt->priv;
+	struct nfp_fl_payload *nfp_flow;
+	u32 ctx_id;
+
+	nfp_flow = nft_merge->flow_pay;
+	if (!nfp_flow)
+		return;
+
+	ctx_id = be32_to_cpu(nfp_flow->meta.host_ctx_id);
+	*m_pkts += priv->stats[ctx_id].pkts;
+	*m_bytes += priv->stats[ctx_id].bytes;
+	*m_used = max_t(u64, *m_used, priv->stats[ctx_id].used);
+
+	/* If request is for a sub_flow which is part of a tunnel merged
+	 * flow then update stats from tunnel merged flows first.
+	 */
+	if (!list_empty(&nfp_flow->linked_flows))
+		nfp_flower_update_merge_stats(priv->app, nfp_flow);
+
+	if (type != CT_TYPE_NFT) {
+		/* Update nft cached stats */
+		flow_stats_update(&nft_merge->nft_parent->stats,
+				  priv->stats[ctx_id].bytes,
+				  priv->stats[ctx_id].pkts,
+				  0, priv->stats[ctx_id].used,
+				  FLOW_ACTION_HW_STATS_DELAYED);
+	} else {
+		/* Update pre_ct cached stats */
+		flow_stats_update(&nft_merge->tc_m_parent->pre_ct_parent->stats,
+				  priv->stats[ctx_id].bytes,
+				  priv->stats[ctx_id].pkts,
+				  0, priv->stats[ctx_id].used,
+				  FLOW_ACTION_HW_STATS_DELAYED);
+		/* Update post_ct cached stats */
+		flow_stats_update(&nft_merge->tc_m_parent->post_ct_parent->stats,
+				  priv->stats[ctx_id].bytes,
+				  priv->stats[ctx_id].pkts,
+				  0, priv->stats[ctx_id].used,
+				  FLOW_ACTION_HW_STATS_DELAYED);
+	}
+	/* Reset stats from the nfp */
+	priv->stats[ctx_id].pkts = 0;
+	priv->stats[ctx_id].bytes = 0;
+}
+
+int nfp_fl_ct_stats(struct flow_cls_offload *flow,
+		    struct nfp_fl_ct_map_entry *ct_map_ent)
+{
+	struct nfp_fl_ct_flow_entry *ct_entry = ct_map_ent->ct_entry;
+	struct nfp_fl_nft_tc_merge *nft_merge, *nft_m_tmp;
+	struct nfp_fl_ct_tc_merge *tc_merge, *tc_m_tmp;
+
+	u64 pkts = 0, bytes = 0, used = 0;
+	u64 m_pkts, m_bytes, m_used;
+
+	spin_lock_bh(&ct_entry->zt->priv->stats_lock);
+
+	if (ct_entry->type == CT_TYPE_PRE_CT) {
+		/* Iterate tc_merge entries associated with this flow */
+		list_for_each_entry_safe(tc_merge, tc_m_tmp, &ct_entry->children,
+					 pre_ct_list) {
+			m_pkts = 0;
+			m_bytes = 0;
+			m_used = 0;
+			/* Iterate nft_merge entries associated with this tc_merge flow */
+			list_for_each_entry_safe(nft_merge, nft_m_tmp, &tc_merge->children,
+						 tc_merge_list) {
+				nfp_fl_ct_sub_stats(nft_merge, CT_TYPE_PRE_CT,
+						    &m_pkts, &m_bytes, &m_used);
+			}
+			pkts += m_pkts;
+			bytes += m_bytes;
+			used = max_t(u64, used, m_used);
+			/* Update post_ct partner */
+			flow_stats_update(&tc_merge->post_ct_parent->stats,
+					  m_bytes, m_pkts, 0, m_used,
+					  FLOW_ACTION_HW_STATS_DELAYED);
+		}
+	} else if (ct_entry->type == CT_TYPE_POST_CT) {
+		/* Iterate tc_merge entries associated with this flow */
+		list_for_each_entry_safe(tc_merge, tc_m_tmp, &ct_entry->children,
+					 post_ct_list) {
+			m_pkts = 0;
+			m_bytes = 0;
+			m_used = 0;
+			/* Iterate nft_merge entries associated with this tc_merge flow */
+			list_for_each_entry_safe(nft_merge, nft_m_tmp, &tc_merge->children,
+						 tc_merge_list) {
+				nfp_fl_ct_sub_stats(nft_merge, CT_TYPE_POST_CT,
+						    &m_pkts, &m_bytes, &m_used);
+			}
+			pkts += m_pkts;
+			bytes += m_bytes;
+			used = max_t(u64, used, m_used);
+			/* Update pre_ct partner */
+			flow_stats_update(&tc_merge->pre_ct_parent->stats,
+					  m_bytes, m_pkts, 0, m_used,
+					  FLOW_ACTION_HW_STATS_DELAYED);
+		}
+	} else  {
+		/* Iterate nft_merge entries associated with this nft flow */
+		list_for_each_entry_safe(nft_merge, nft_m_tmp, &ct_entry->children,
+					 nft_flow_list) {
+			nfp_fl_ct_sub_stats(nft_merge, CT_TYPE_NFT,
+					    &pkts, &bytes, &used);
+		}
+	}
+
+	/* Add stats from this request to stats potentially cached by
+	 * previous requests.
+	 */
+	flow_stats_update(&ct_entry->stats, bytes, pkts, 0, used,
+			  FLOW_ACTION_HW_STATS_DELAYED);
+	/* Finally update the flow stats from the original stats request */
+	flow_stats_update(&flow->stats, ct_entry->stats.bytes,
+			  ct_entry->stats.pkts, 0,
+			  ct_entry->stats.lastused,
+			  FLOW_ACTION_HW_STATS_DELAYED);
+	/* Stats has been synced to original flow, can now clear
+	 * the cache.
+	 */
+	ct_entry->stats.pkts = 0;
+	ct_entry->stats.bytes = 0;
+	spin_unlock_bh(&ct_entry->zt->priv->stats_lock);
+
+	return 0;
+}
+
 static int
 nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
 {
@@ -1553,7 +1686,11 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 						    nfp_ct_map_params);
 		return nfp_fl_ct_del_flow(ct_map_ent);
 	case FLOW_CLS_STATS:
-		return 0;
+		ct_map_ent = rhashtable_lookup_fast(&zt->priv->ct_map_table, &flow->cookie,
+						    nfp_ct_map_params);
+		if (ct_map_ent)
+			return nfp_fl_ct_stats(flow, ct_map_ent);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index bd07a20d054b..beb6cceff9d8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -246,4 +246,12 @@ int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent);
  */
 int nfp_fl_ct_handle_nft_flow(enum tc_setup_type type, void *type_data,
 			      void *cb_priv);
+
+/**
+ * nfp_fl_ct_stats() - Handle flower stats callbacks for ct flows
+ * @flow:	TC flower classifier offload structure.
+ * @ct_map_ent:	ct map entry for the flow that needs deleting
+ */
+int nfp_fl_ct_stats(struct flow_cls_offload *flow,
+		    struct nfp_fl_ct_map_entry *ct_map_ent);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index d77b569b097f..917c450a7aad 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -566,4 +566,7 @@ nfp_flower_del_linked_merge_flows(struct nfp_app *app,
 int
 nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 		     u8 mtype);
+void
+nfp_flower_update_merge_stats(struct nfp_app *app,
+			      struct nfp_fl_payload *sub_flow);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 2929b6b67f8b..556c3495211d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1595,7 +1595,7 @@ __nfp_flower_update_merge_stats(struct nfp_app *app,
 	}
 }
 
-static void
+void
 nfp_flower_update_merge_stats(struct nfp_app *app,
 			      struct nfp_fl_payload *sub_flow)
 {
@@ -1622,10 +1622,17 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 		     struct flow_cls_offload *flow)
 {
 	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_fl_ct_map_entry *ct_map_ent;
 	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *nfp_flow;
 	u32 ctx_id;
 
+	/* Check ct_map table first */
+	ct_map_ent = rhashtable_lookup_fast(&priv->ct_map_table, &flow->cookie,
+					    nfp_ct_map_params);
+	if (ct_map_ent)
+		return nfp_fl_ct_stats(flow, ct_map_ent);
+
 	extack = flow->common.extack;
 	nfp_flow = nfp_flower_search_fl_table(app, flow->cookie, netdev);
 	if (!nfp_flow) {
-- 
2.20.1

