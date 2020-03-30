Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE68D197573
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgC3HRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:17:30 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:55440
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729454AbgC3HRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8aYLzm6zZ/ZwDf/xd+jLSBZ5nVmwtnk2UI6blOP+90acn68vGj2cJsGZ9m+pCPuLL++A7hD4/T8E1ADeFYOArnJjaR1svPA3IoYCVCKaj46d3NR0k86lZpYIW5z1cbgyEfjtFHWPcNViDcIvrhKaNJDvIy+51BJZlGPpiRs++Kf6jrV2kOwoWo+Gj5EDsYlVI2Daj6I3U9+iBb8Iiqi0mMxqdtin1T/z7CVuuwyTlto8DPtQIdOdNCtTreFbJ4tcgNRYIioZoH8Ol/vskzKJRKfQJNrbIFth8M6RQGMsCwvKBAKFoQBly6ZjlNQGgsSMB4kxQa4kFK3ERyVGjEeOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYzV4oP5uobe4Vp+b89KfWbQLNubth6eSCs76aau/Nc=;
 b=oU6Tr51nUcom9+zXbQDJ4WgVFoF99Rn5F4CbIBOKP8D2D6P9kA91L6leR+PUtlPuDa1nj09za+D585KcgHUp9T9TEnhi+7lAT9K5SDMxfV0EvWsCqjIXSJZlhsTdqNuka2n4Vm4+sQGmI7Tg/fAZA4O5YsVvkw48FqsJcUQLHYP6L9i7LE6Y5fWPyL2h2uW7H1MXbLdd8sESYH70iSoEE1djRdtEI4Uty3gvRNa9Oe0U+vIpGwUFbCoKZJ0dK1OonsbgDfwYWYt5lwj3I7GVeupLj0QuMU2wj/UpO9k7S06kMdiJlf6UQv4l2AZKyfNGWq/br5p7zHfE/zkNITx2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYzV4oP5uobe4Vp+b89KfWbQLNubth6eSCs76aau/Nc=;
 b=ZrxVVpNwJZQBM/hbYckhleV9xgPNgnJTA0ipuJwh1UTZCsbTOyJE+8Msuy2NLe7oAMEgz5iO7dxzJ/LoTIHR+thVygmWpD0pzx5SBjKqq7fbnBM8BBHbN8W2csGgLEB3JrgfYrNnKvwBgXrjsyUZmsb27UnPbF1SRCy/YBSFmYo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4989.eurprd05.prod.outlook.com (20.177.52.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 07:17:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:17:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 3/4] net/mlx5e: refactor indr setup block
Date:   Mon, 30 Mar 2020 00:16:54 -0700
Message-Id: <20200330071655.169823-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330071655.169823-1-saeedm@mellanox.com>
References: <20200330071655.169823-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 07:17:23 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17f31cfc-6ad3-4a00-a6f8-08d7d47a65d1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4989:|VI1PR05MB4989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB498946C14A913E0AA228972FBECB0@VI1PR05MB4989.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(5660300002)(6512007)(8676002)(107886003)(478600001)(81156014)(66476007)(86362001)(66556008)(4326008)(6486002)(66946007)(6506007)(16526019)(6666004)(54906003)(52116002)(1076003)(8936002)(81166006)(186003)(26005)(2906002)(316002)(956004)(2616005)(36756003)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqW7OIfDvii00pFEZqaBdfv74R2KOABZUiPASCmyPJ2QKzu7+uougXceecp0WvLxHo5aEfF8XOrXFiO42xvu+VTJgCY8pj2mpAZG2v5knlpqcY3vwpmYxCnnO9eqR5ZKoupZNvjWD5gpjYNmdUXXT/7vYV9RQPEfRmFLEbdMzf1YGO3n1ohaTTx0114RbXl+WbaJTlBMXvQ+tgHtJtXAAIR9OV4IAWKOaOZWTAN9AoB4XCkFKIqRS67zkt3aSfqgzhwOitxkYHqqu8oIBKoV2ogwI5mlHeWgp+ZAeJrfhyWWEJgs6PtE5Jx0YaPRNzp2s9frrJvMlNLZPr4Cr2/WcCrYSKhj6blodQBxf9FtGV6batS629gIEv7YRfkmnJTg+Bdn1QstShuplKfTYogoXn+WhIc0sj7qHN3b+qwpKoww8p5UgE/5wHMT7KROkqRWuzG0cw1LqeGO/mSJB0RpQMt0LI1n5MaIt9hb9chpA4EB4Rv12TRIYneTJELlxUal
X-MS-Exchange-AntiSpam-MessageData: J6Cr+Tg+j6RIuXsgjiaIb4iKHUC8fF9/NU9NYlPXAGoITquVloa6Z5mqE1f8bFbxnaYawqM9SOeoCx8jHkCEcFINjj7ifAPLJwFebONHd6nxp3Ybz3q6lCSaAVoOtMvcCSIVqPxJDwgcHZU8jpplxQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f31cfc-6ad3-4a00-a6f8-08d7d47a65d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 07:17:25.7160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+hRxMBDIXT9k20IY4+q4n1QvRRg3LPIO8YUVuKwXCKPxLXcRlUrfVnxH3Md40uvuQSvaBvmOAbYoRkEuLZLxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor indr setup block for support ft indr setup in the
next patch. The function mlx5e_rep_indr_offload exposes
'flags' in order set additional flag for FT in next patch.
Rename mlx5e_rep_indr_setup_tc_block to mlx5e_rep_indr_setup_block
and add flow_setup_cb_t callback parameters in order set the
specific callback for FT in next patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 42 +++++++++----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 559453b4c6b6..4c947b14b56d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -694,9 +694,9 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
 static int
 mlx5e_rep_indr_offload(struct net_device *netdev,
 		       struct flow_cls_offload *flower,
-		       struct mlx5e_rep_indr_block_priv *indr_priv)
+		       struct mlx5e_rep_indr_block_priv *indr_priv,
+		       unsigned long flags)
 {
-	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
 	int err = 0;
 
@@ -717,20 +717,22 @@ mlx5e_rep_indr_offload(struct net_device *netdev,
 	return err;
 }
 
-static int mlx5e_rep_indr_setup_block_cb(enum tc_setup_type type,
-					 void *type_data, void *indr_priv)
+static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
 {
+	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
 
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv);
+		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv,
+					      flags);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
+static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
 
@@ -741,9 +743,10 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int
-mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
-			      struct mlx5e_rep_priv *rpriv,
-			      struct flow_block_offload *f)
+mlx5e_rep_indr_setup_block(struct net_device *netdev,
+			   struct mlx5e_rep_priv *rpriv,
+			   struct flow_block_offload *f,
+			   flow_setup_cb_t *setup_cb)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	struct flow_block_cb *block_cb;
@@ -769,9 +772,8 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = flow_block_cb_alloc(mlx5e_rep_indr_setup_block_cb,
-					       indr_priv, indr_priv,
-					       mlx5e_rep_indr_tc_block_unbind);
+		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
+					       mlx5e_rep_indr_block_unbind);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
@@ -786,9 +788,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(f->block,
-						mlx5e_rep_indr_setup_block_cb,
-						indr_priv);
+		block_cb = flow_block_cb_lookup(f->block, setup_cb, indr_priv);
 		if (!block_cb)
 			return -ENOENT;
 
@@ -802,13 +802,13 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 }
 
 static
-int mlx5e_rep_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
-			       enum tc_setup_type type, void *type_data)
+int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
+			    enum tc_setup_type type, void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_indr_setup_tc_block(netdev, cb_priv,
-						      type_data);
+		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+						  mlx5e_rep_indr_setup_tc_cb);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -820,7 +820,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
 	int err;
 
 	err = __flow_indr_block_cb_register(netdev, rpriv,
-					    mlx5e_rep_indr_setup_tc_cb,
+					    mlx5e_rep_indr_setup_cb,
 					    rpriv);
 	if (err) {
 		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
@@ -834,7 +834,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
 static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
 					    struct net_device *netdev)
 {
-	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_tc_cb,
+	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
 					rpriv);
 }
 
-- 
2.25.1

