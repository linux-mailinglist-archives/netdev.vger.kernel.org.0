Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C43988BE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFBMCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:10 -0400
Received: from mail-dm6nam11on2100.outbound.protection.outlook.com ([40.107.223.100]:56833
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229668AbhFBMCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZkhakJEez6hUz3PlZdKPuXWsMBLdPhAUNAqrkB9tqy2YlTlnG4fYxHyIus1RVDWS5AEBlF9tv6G5R7NXzHZ04iBv5aVfMpElvG1Y1OkX0Yc0q/ZrSxOHdYKf7CbI//Jw2Ne9CxMevC2vzY8FrucW6418hi+auIsR97Fu6cXB1K28r44WiUXrZzV5YxVVjFxfNkKoVRz9VN1q8Q7w8xGlWbs+N5WPH75/UbQRJVR56w+k88lB+HiswCZXT/STcxE6dQUWLFUlPz4IMrLzw+0ywNR3aFCrtFFGbuXLT2D5eUEiTeINNTLMAuPB+B90lPmTmOrryTkj14o7rlbKR6E+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRlQXbWcTqGO9B01tc48EHVXxWMGKTiI54HptriGqCQ=;
 b=Xj0R/KP9cTl2/nFVhy0JEKt9G3Zl6okefiHkrel+fcljYzSlrSkm5EvlnktvWJ7ZbOLox0W9m1TZLJnLZxKjW0W+067lalrPO1aa8VET4+Y/WC4KzFuZqZuPLAU4Sf9CGAkOEKflh6YA9KC/KM4DkYGUggHRKI61rCWT3wwcSaovidQ6UlrIs0fl2tqeRRM6TAUk3+DaWDa1WLD8UslCvQN40V00v6H3BoEkVVhvYrEYzm7N1mhvskRHWRf035yg31PNqO10He8t7BAESqvrGC0itysdnjIAnltHsexvzR0tChaKLF4yF82DLqgLc8SPpFz2LLk4ZAVEdgzO1WagmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRlQXbWcTqGO9B01tc48EHVXxWMGKTiI54HptriGqCQ=;
 b=RXGfhAR+ySq7YOcW6hTf1Wmfogp4CbVR4mwOwW4ZkWOaYAx3/P6u/rhL0oM91mLvfym87Oh0EUI99SWNNue9mGfCH+eLGeXDtHycQu/Av2jEvpeFoI6725IH+vtRZUBRattSy/XxsE4N0HeduSoO1hhGdu/hIkTUcgq3Vb3b2oU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:19 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 4/8] nfp: flower-ct: add zone table entry when handling pre/post_ct flows
Date:   Wed,  2 Jun 2021 13:59:48 +0200
Message-Id: <20210602115952.17591-5-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d4e92b3-a9ea-4dc0-77e8-08d925bdfe47
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4986A365FD2916D6BF55CABAE83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wd1ahIBHHABG4A//jU66zs5K1cap9XRhkMz9+Uz9Vm8ooOTzDXJvNDVxHv3iN7I2fRnduJctW26nLFxnnUKS3O88+bYBN5KOR1IW5Wx2he2EFmg4VFpBmBQQ4urxT059xq6bPb2grFzH1DUSl6cgqFZHP971pZ7lYMx/aelYyf1rU9pMYsgft/6+OLFNo2tZbYqQd6CJcVLXKEXVRw3D/sSbwXk5WknLnAU/dlwPLrEHiDK0V9lS+srpr6Aw+wl67MObHg4r1LYnP8x1DUtfxCUUpYXXUxTGJ8xMl/0loY312YEmEeEMmU464ClBYxCk4bD7enlD6OmR0LHuFYjo01Zh6n46KGEIIToeJOl+UadO6j4ES+8Ij/wGWu/cqiKkYxLgrwksl2qr3GHuKKu/EmjBeInhrORcq8SUC9JKYH8/7FGNg88DMGImzEdzSS7WLU3PsjzyQJKoru/MU3yKHa7Co4jh5n1HR41p4MKqxzOJQKwlrqGa8poefnouluSETTRCBKo0IRtYn7UihUNUvHDxY2IHCWT4U830y6szinJyUjep0BzUscszfEC/v9/nxMdjpQTQsDzVWyQC0AmD1EuJu7vv3SCbPOPwkCUEkCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(346002)(396003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HkvXEollsVtFf7O7IiQzErSc5L8UvfG8W0hlKRJky8yd0dF2+v/iqqqRKxKl?=
 =?us-ascii?Q?MPeGT+ZnFwc3foVUKGfrd61cRHQUs+40dzovN7wxluxZ6vYB7alY9GCOzWEd?=
 =?us-ascii?Q?SajE6IMjUpBM/rkrp4X0FmdJjktvXyKt7Q0Qg3eEFhTW85Rhq68mF8R0ZlIH?=
 =?us-ascii?Q?QGzfgQuIN2vSM3MakSgRZF7B2Mrwsya5pgaiNErEeX/9E8e+54YlcyZRKx/P?=
 =?us-ascii?Q?kNTbWqIHXbsNUafF/KTv7r3f7Z6fymj4mzWl8mJC/eAiEtqqPOZQwg/rGknr?=
 =?us-ascii?Q?wzt0vpwxYzuPRPoImpuzq1lH4ftHCijNW4Q7Zw8lqDpMZqxBzuTyQUA6swj8?=
 =?us-ascii?Q?1hEByHvTw2e2PmRHTVsvYWUZP7immbvFTP6XStogv2IU3yBwPYdXaKpsO+1k?=
 =?us-ascii?Q?0nWFDYa9EMR5C7227pzUjG14nND1ML9Ey1rRWwShSy/1GDCgJ5llUCsdVHs4?=
 =?us-ascii?Q?DCvXFCYXQBxdCn7gFjnmojY/688iQ7sYP/WcPej8Eo9h4IiWncBKA8/FTTKY?=
 =?us-ascii?Q?Sf62UzgJQjlQ4QS7r9Dtwm5LxVTX0PX60eeiF7WUuIRg87/u8CkT4OzSEK3o?=
 =?us-ascii?Q?t9wn/d9ryjqVyKUZm3Y3Q+qDfJwnAoqtcQJGcDIRpCJcHGMYz4KRqbKJOdrX?=
 =?us-ascii?Q?z4VIwpnqMj4+STPLxoR31jnsw7LemkZdu+4i+96a2v7/Bpqz1iIcTCqpnob8?=
 =?us-ascii?Q?1BkkkNptNjj38ql7HdG3RkxcsSwwM+zolrVZJe32wuc3weVxemP3yV18fC1u?=
 =?us-ascii?Q?hRQHfSq+XwHpjyP2Kph/ScwCG9X9O+vPWko9Gp4/HEv1iwXzu4mSLava7ZcX?=
 =?us-ascii?Q?TWWgdagT41f/cQ8q4SoPBjrBiIEQOylCskLYt5GSRWt7y/6VH8e1U+5BvKCl?=
 =?us-ascii?Q?IW8whpOzeCNXQfIixc2QogH/0ZeWVXQ+ZqX6NVdrjfyTgKYCZ1c7qmpyahFp?=
 =?us-ascii?Q?E1PtJZOnS+sXtFmyXHZiHoFI8ppUSVKaBLtCcnZFj2mDWAvNfiBGSnuSJq0K?=
 =?us-ascii?Q?X0FyCTIRFRv5bdRxsf9TdGvTy9S9wAzdicVuWgnGvTcsnV0FyJ9Wd1CeH49R?=
 =?us-ascii?Q?+9B/DAeqq17JP7CPIfUmgTJ80oBRh95/aAXgxbSIC7wTey1cwXrSWXFD5a8Z?=
 =?us-ascii?Q?p2i2fPKTohsjAxdyMFC4qJKkC7NrSnJ/AQgsL/d03XZnxz/icSkfQVxXTe/x?=
 =?us-ascii?Q?CZ2Dcp3/65w12XJmBFDdiH0qKxsvHN9cVHz5jzQDg091+TrFT6dIjvIlvUtF?=
 =?us-ascii?Q?fo8i2dzHRDN0jZa/Y5rMvokbNDY2MCwMWX0CJBvNU8TS7SdUKYWF6jhttBz4?=
 =?us-ascii?Q?ib4MRk/4ayLaxvu0aHS2R/692nyPOsJj6yeeOHhpmuYuk3I5CtgIGelXfvBP?=
 =?us-ascii?Q?CqVg4d/SSpWD5FBjleo0EcuEagrj?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4e92b3-a9ea-4dc0-77e8-08d925bdfe47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:19.6033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jd3pvK/mhQOnNOK4zuzn39vyHwBV42UdrdN+pwafRGpgFPKwo9bQpBBBqSdljVWfMR+fij/V5Mfe10ObKGU0aCJkXCqXNbRWbQ/LAvT0XyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
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
 .../ethernet/netronome/nfp/flower/conntrack.c | 125 ++++++++++++++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |   2 +
 .../ethernet/netronome/nfp/flower/metadata.c  |   4 +
 3 files changed, 131 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index aeea37a0135e..9d63a8f89397 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -3,6 +3,33 @@
 
 #include "conntrack.h"
 
+/**
+ * get_hashentry() - Wrapper around hashtable lookup.
+ * @ht:		hashtable where entry could be found
+ * @key:	key to lookup
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
@@ -29,11 +56,88 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
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
@@ -43,6 +147,27 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
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

