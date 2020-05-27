Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831A21E49CE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390950AbgE0QWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:45 -0400
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:63619
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390930AbgE0QWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+RNNUIVftlq7CCcBL30CjSag816eJJSbpaRFJOaO1RY+0Ta7ApwDCx//GklzqXKYPDWPZ3LsBmmgP7o2uo0YFyTWwtntalCYD8Uafj46Jo/SOyN9od74rhS6/cQosbZPBIZcxqD7EZWqauiiDkngvkubBEyLMVCytK4JdWrz4tsSVi//gKYBXQRiYDtb/20cX/S9uYkFwzGNlEDlw44Ek1ogndTdD8E1BpXbw7qiYAV+9ULQ4jOVVSR0bJSUZz38D0gv9etu011W5OELHx7WRXHld5TBzN0XRC9mYZc4bE18jHY2bBS0YA1zT9LcdFoPdwCIMSDYmuuUvWUE9aWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XU7XoKyq0Pjs46fgv/84EcYBVRr/v56avPc2XRjUn8=;
 b=RKpran1i4xQFwnaS6onjwH08yHNHSaTr+Ssi6hhlVmku7CMO0QM243LQj9SbRqi4fu6auCoIB9yUERpouj6FTcSn06eJfnP6JodDhcp6cZElchW3VFBo0eetpCf5usXNTi4Th5n50oi7axEX6ji7I5LIIJya/1XMvGBJUFN2UgDQxrfq7sQ4wgR57rbCi5tvZV7CafRJSFs+YUD+ehIvRv4dNOI4LBmlnkJTO3E26+Z2la9e/rgIwegRLwvzAA2sGEkFZR51CX/4VLws7KMyM2VGmG/+/nAAtntWMfkxpFsZ/nNEVWcoJz9psQGbFFxca3QYN9iVLeLBQoTSEAxXCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XU7XoKyq0Pjs46fgv/84EcYBVRr/v56avPc2XRjUn8=;
 b=ALJXgl6Ui+HQgCKqmEl4U7JlAISD2b3RAereIAILHuEMIcnHfbRcDJak5mAuw2tRRuZGtA3V/tqXY7ng4203J34dCWJVDfev1XMkwSA3Qc/viDsJgDi9GTPKKhjOcPdz4C1Rcr1V9E+Sq4cJVAnc8GstbJLr5TYR9h5WEljNG1g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5054.eurprd05.prod.outlook.com (2603:10a6:803:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 27 May
 2020 16:22:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 05/15] net/mlx5e: Support tc block sharing for representors
Date:   Wed, 27 May 2020 09:21:29 -0700
Message-Id: <20200527162139.333643-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 295cf9ec-fcbb-440f-1e5f-08d8025a1a87
X-MS-TrafficTypeDiagnostic: VI1PR05MB5054:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB505476E351710C26FCA8E149BEB10@VI1PR05MB5054.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/2g9ksmnLI4g+n5nti72PA6VKKLyj6+fqRWtN7XsbI9Var4pVg479NYlSV8Cvubv1G9vF30RpTuDr+tSrIFyoo3MRwYfqXt7OVY4SQdHH5EuBfzWUEf16d6tVEvEFOnZt+TSMz7ZNgCF7adR5BvL/YhHrWDuErwcmaJDEHHIklfsCdDKBeqhInczx4FxruEU29SPWnnnMqMZ8gvj6O5Ijp6zOv/UIkryCre4cH9LmCNkYBwpMqsOXTOdvX738hVmXDllYsq6qT8OiZY4kOH5NS9/8Og14gUb+2sJfBhadgoAjd9g29556nj6PWqLwTg/k59AfS1N9HRtSUvMm12LpYCEnXLOI9+SisS9dnyeNF1tmZZF53yM0Gbdjt8KNBS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(6512007)(107886003)(66476007)(66946007)(66556008)(52116002)(956004)(2616005)(6506007)(5660300002)(6666004)(8676002)(26005)(1076003)(86362001)(8936002)(478600001)(2906002)(4326008)(186003)(6486002)(16526019)(316002)(54906003)(36756003)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VFndEpgSpoiRWjbo/L/PtBycWYqUdZJnGjr5Ws3JbjGIY2hZaBwDzZtkh9tfW7npELMu/fatuwl1wdTu21TE60Lc7Vbt0KYJwEA/+jfus4Lo/Ii2Fm8CqLiARSFyJRY85EL4Tm4fzwI8EsnCCZlRSI5YOScua5jPHZALChwo8lydp3nQhB0OSH6Dk2OsvYb5Y9PvsYRlzNqsIYzL0S0FdWl/0S8dOpxATpjhvoUULxJr+xPoSsjyv4bWmliCKpeiymcN6OfhgWbCQBPZ8bvupr92GW9aXypSY0qOeLLMsW0p6f6vC9Y0dXnFs8IVrdVE3vZDAJKbsJwryL1vghjQCTF23E73vr+3td8P6vQBEbafm3UGVS4VMAcdUEkAn4kJHrK36JvauH4zEwoFeYG0Ug898q4UMDcgZmEaFgEiDPskenVYV7Q6DxVI4HJOJYPnu96GC9MFh3oq6NBErR+LOE0NxttHdsooEvFAw9mksow=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295cf9ec-fcbb-440f-1e5f-08d8025a1a87
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:09.0229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GP0xo2sitmXIrf2LFSHW9z/+cByljk9OQsxTVqROsC/aeq6LcRHvgVc48g/2SfFTmTH8JU9dmMpDdWkcrDA0LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Currently offloading a rule over a tc block shared by multiple
representors fails because an e-switch global hashtable to keep
the mapping from tc cookies to mlx5e flow instances is used, and
tc block sharing offloads the same rule/cookie multiple times,
each time for different representor sharing the tc block.

Changing the implementation and behavior by acknowledging and returning
success if the same rule/cookie is offloaded again to other slave
representor sharing the tc block by setting, checking and comparing
the netdev that added the rule first.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 571da14809fe..f3e65a15c950 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -145,6 +145,7 @@ struct mlx5e_tc_flow {
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to missing route) */
+	struct net_device	*orig_dev; /* netdev adding flow first */
 	int			tmp_efi_index;
 	struct list_head	tmp_list; /* temporary flow list used by neigh update */
 	refcount_t		refcnt;
@@ -4624,11 +4625,21 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 	return err;
 }
 
+static bool is_flow_rule_duplicate_allowed(struct net_device *dev,
+					   struct mlx5e_rep_priv *rpriv)
+{
+	/* Offloaded flow rule is allowed to duplicate on non-uplink representor
+	 * sharing tc block with other slaves of a lag device.
+	 */
+	return netif_is_lag_port(dev) && rpriv->rep->vport != MLX5_VPORT_UPLINK;
+}
+
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 			   struct flow_cls_offload *f, unsigned long flags)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct rhashtable *tc_ht = get_tc_ht(priv, flags);
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5e_tc_flow *flow;
 	int err = 0;
 
@@ -4636,6 +4647,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
 	rcu_read_unlock();
 	if (flow) {
+		/* Same flow rule offloaded to non-uplink representor sharing tc block,
+		 * just return 0.
+		 */
+		if (is_flow_rule_duplicate_allowed(dev, rpriv) && flow->orig_dev != dev)
+			goto out;
+
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flow cookie already exists, ignoring");
 		netdev_warn_once(priv->netdev,
@@ -4650,6 +4667,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (err)
 		goto out;
 
+	/* Flow rule offloaded to non-uplink representor sharing tc block,
+	 * set the flow's owner dev.
+	 */
+	if (is_flow_rule_duplicate_allowed(dev, rpriv))
+		flow->orig_dev = dev;
+
 	err = rhashtable_lookup_insert_fast(tc_ht, &flow->node, tc_ht_params);
 	if (err)
 		goto err_free;
-- 
2.26.2

