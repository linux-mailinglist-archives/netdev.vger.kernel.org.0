Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C743A395AD8
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhEaMsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:48:35 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:7041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231611AbhEaMsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX98FVYYv4qkiCgqqNEDFy6UHl468CWDpWyM6Al6c5BnfWEndskDsv+YJ60kqehhneRQ47jsYr0SSkRJloRB90/k589Bs5Aupxg+Mjob3JwXjRf9K9WsKE5kde08v/251Hpnj1EY9/0i18c9m7h3SIynQ0mw3Bpa6t1UXksw/P2P2BVUUHqUzPwnBLhbVioXnuA6aFZRfe9/HlG6gy83w0u+/Z+zm4gjkC5p+tuPdqzARQamSvl37hb4EamE6e9E6hx5HZEIk72mCeFY0C0vCi0HEIkDK2aBvrPu7RNoXEQcH3YVXHLqtqt43bWeND1vpMb5sg0Gc61Ad1oAiNXETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXGpXXL+YDJDOJH2gnMglEcURAVS7ACDx5Pj0ZB4OVo=;
 b=fuctGXZfkU4sQ6TmVsSstOs9n9Mqk25wy2Cz46afQezRJOhY4QYepPJLO9NHtIPBlSa7v8vCj37oldYNgIZ3ZNkR29wdstNpn7D/7Kk3WMotiCvWptASZVyu23Ju7rrATXqL8wu6X7RHhpQ9XvtwU5QpbUYL8jW6cHcBvV4oDFaBzWUVToZeC7jJdHhwdFo1KMy2diMcmztyfBZSyI0++ioVqzo1Xz+kwnhaExY4IN9eT/cgZuN4EaNjm2YJwiIci9cJjiQYSKmqxGAkgNaJve1p4VdGm9YGv29QpP5yqq4EMXOmREuE9tVlFx0YWVBueSDm6EdJPep+9oFlfkGNFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXGpXXL+YDJDOJH2gnMglEcURAVS7ACDx5Pj0ZB4OVo=;
 b=XanyEarzMeHd4QG74tEia+lWutyYhTflgDRpeeO9Gre9lgN2ak14zpj8cIESrFc+IeUo9TG/brqn6oMRrXKn88qe94BbdSvHl05SR9sRm2wLFSDmuO1cfvUgGSAPlWJn97c7cMiQvemqXDs9j32pkcEwaSKsU+bSC4L0mUVa548=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4891.namprd13.prod.outlook.com (2603:10b6:510:96::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12; Mon, 31 May
 2021 12:46:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 4/8] nfp: flower-ct: add zone table entry when handling pre/post_ct flows
Date:   Mon, 31 May 2021 14:46:03 +0200
Message-Id: <20210531124607.29602-5-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 460d0b1b-87ff-4bcc-8874-08d924321edf
X-MS-TrafficTypeDiagnostic: PH0PR13MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB489133991ADAE9487B01DE1CE83F9@PH0PR13MB4891.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x27MFk5Jjayh/LHY1oii17JQXvbNpJ+5xa4bn9Qf7dJ1V+gmQBH98i7C3HLbdvwpAABBxLYCPaAL183xJdmM7JeVbUKOI01pko+jzzjsQqdPKzd2CXsvXOvt31bgi5y4PxkMh3TUnrGw8Ku+LsCJBtoMDxLUuKF3ckS7TEiVvFVWSbS7HUEaa/MY2UQQyUJSjIFkyD3Cn7up5l4jx87eG1mOSLLsCFdixMn0fpccTBYkyyYvxifP9vs0sn3bBhUbD/SmXwkhjpIdvDrQQpdh+XPWlxALg8mNvbABPZ1Bu0P3B3GbZ2KAVip9PC9pnCA/9vS6tPqMRpWA7Vnd9gFhaQ7PAnFwhPgX6Kmm2lvPeYmwrrDzMYO2pNrkqI0iIotloHYuMlWFCSYevwBcbMxm6FTt995BYh55zK1Mj3JcTsi6wUjABmo5bidBOt4fP9WaYreWwaVirpR/gy1db0wURA2u9PQMCtfis14apfqpAB6fl0SxmWBxCAPJmcpgwA//YQ+p8aRSv0ivAJML/jBony7Q+vs/0MezgjbsVBShbXH1ouKc3A9lU2OE0x3svrj1CjGPuRmHohj2rhkuUPvQ78Swsd47bwOTxldJdLYZ4us=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39830400003)(376002)(107886003)(2906002)(66946007)(66476007)(66556008)(36756003)(38100700002)(6512007)(186003)(16526019)(4326008)(86362001)(8936002)(8676002)(6666004)(44832011)(1076003)(6506007)(54906003)(110136005)(6486002)(478600001)(2616005)(316002)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4AcPQ5NwTKWugVXNSX1WVM40sWPbiMUHR94jSUwxgiRbQnQoDfkclfhnCvzW?=
 =?us-ascii?Q?bFsvOwrGlRUJiyMWYwiztEr0a2g9aPI7n+FbdXsTAjtv/X5jJSozjO9QOm2n?=
 =?us-ascii?Q?ejNUzqYtISgDSbKq2IsQbwBT1ZvJNbtujcfOye+BgRuUBkJtzxxAZ4n4oeZp?=
 =?us-ascii?Q?CKry2hyC08FX1sUUJrGd54KEEalKLH/iOlwpyovc+QNAwLkwo09+nvtQfWd9?=
 =?us-ascii?Q?ekLT+k6ZWvDLCd5mr8XTpK9/lpyNc5a+mrpSv6ZTSJglsErB3JN2aO2b7S4G?=
 =?us-ascii?Q?EoLFYjo2wJxdsOQHranjeVmvlQVYIrkiIIlK6pJkh8kVr+2XULul2b4KF+9i?=
 =?us-ascii?Q?MJwvke6CA2hmXLEuGoEHKyOdHMnj1hAnYQDs+oxn5cCFIrr6y9/+sA5bmort?=
 =?us-ascii?Q?zXz2iYrgeGWpreatoJwl8EfFLSRjRmr9vVhu7MxRh6EJfwR7Ui05AFM5SHUI?=
 =?us-ascii?Q?ZNGLkKEddiejzE7A65XReFCEDcUFBZQlOxA5Ax/a9B9R4e2MI+kS37GGh5E/?=
 =?us-ascii?Q?bOtYvdu2qxm9NknYXXdzA0wRGJBjPwzBc9b6zjmxLkkfPM2aEp1ZmT6Dp5zc?=
 =?us-ascii?Q?r8rkoPweGBiCgLW1dA8UvnrBs0PHP6MaIy523TouZkcXp3nzHk2FKbWQwDHT?=
 =?us-ascii?Q?2hsHLZwRoPcyCZdo/k8OKGFK/50UwYDAM8SbSZUUOr9B/ngyFePG7oG3Fodo?=
 =?us-ascii?Q?qkjcWYZSJ7Tk5QoZR13nZWogFdInXGE2s7RZK1lNACCneKuGBS8sk9i/q6+R?=
 =?us-ascii?Q?JS/dtelZGqftlGQnQJdB07yyAuCS8N4OopHMXah4kv6GXH9TgiKvCfeQObFB?=
 =?us-ascii?Q?eBz1JhN+rQ6kkD11+8suwKMt+B5zRp+lnGswc4lTazGlgjSyS9o6zoCPMfQ+?=
 =?us-ascii?Q?tYOsT2z/FQLDAkcSGimfYK5eQTyw4M9QQbVzaUpzXnJmS2/jUZ6U4F0iK8os?=
 =?us-ascii?Q?M0sccjiXa9YwnuZzL574Bi1f3QdO7VHCJSNWUWS5fCFwZy8cPNNWqG9VqN7j?=
 =?us-ascii?Q?gJsFgna31fuO8KnFSWWJKAWKCAwysOETCyJX8jdAu9IjMJVap/K8ktK4dfXM?=
 =?us-ascii?Q?A7OL24/UcmSMxond2/joCIDagfHjwxpcnP2ami6Y3lPpckcvYeMFUcinGAB+?=
 =?us-ascii?Q?DH9WTHI5thNzDrcNDuZTQJGMbr9mhhq5s4PqQ/Zk/adPw4AdPGkgKI/2N+RK?=
 =?us-ascii?Q?JtLizYczw0p/DsTI12zREKHX2hZ+Ocf3KCYsQHfNOPFrAa3Qss3vGu1LUtZx?=
 =?us-ascii?Q?d0LAOAe5+2j0Uy6kQ1fTnZVB7IQYA7rJcPQjdvOHLOn1OATWv5FV7jQSeNXf?=
 =?us-ascii?Q?41vpFkjIJrX9LzpkpIOM4daSNThNcMRA1GMUKj2VgOMhgm1paWjjnBppht7P?=
 =?us-ascii?Q?SgVvWoGodNGQP/hEBfRUNrkuPKeV?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 460d0b1b-87ff-4bcc-8874-08d924321edf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:33.5801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niMqJfyAonVm+w4+zonMGc3lgsAqU3YFXE8DqyqSwxRb6uxOIdH/+I7VnZwfwmDhcLPrCOLWuQT11vwYwm4/yoFZaQGelpqwClf5048a3DQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4891
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
 .../net/ethernet/netronome/nfp/flower/main.h  |   2 +
 .../ethernet/netronome/nfp/flower/metadata.c  |   4 +
 3 files changed, 130 insertions(+)

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
index 0073851f31d7..060c6de36c02 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -194,6 +194,7 @@ struct nfp_fl_internal_ports {
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
  * @merge_table:	Hash table to store merged flows
  * @ct_zone_table:	Hash table used to store the different zones
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
index 4a00ce803df1..10d84ebf77bf 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -585,6 +585,9 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 
 static void nfp_free_zone_table_entry(void *ptr, void *arg)
 {
+	struct nfp_fl_ct_zone_entry *zt = ptr;
+
+	kfree(zt);
 }
 
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
@@ -602,6 +605,7 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 				    nfp_check_rhashtable_empty, NULL);
 	rhashtable_free_and_destroy(&priv->ct_zone_table,
 				    nfp_free_zone_table_entry, NULL);
+	kfree(priv->ct_zone_wc);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
-- 
2.20.1

