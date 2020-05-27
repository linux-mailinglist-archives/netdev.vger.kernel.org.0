Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD51E34FE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgE0BuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:22 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:6191
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbgE0BuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmXX8Mvc6bP9MMIjEkwwpp7sa5f0Kt0yoYyBduN1ZHpDohNTIby3FU589N2Ald1fl89oNgCeydaBmNnUZP9it26vS6xF13EoBFbmljpeAXUU5zQabH8+UnXU2xPmkYLQj2R6E5hmQu3A0xZmvkQ8S27k6DgM+08I3FHDulNupoSv4QvDUGKZTcv4Wla5p05/bQZMwNzu/bin4ojY2g5dvLoBp30SL8DnbW6HS3gkHXNaiOJiKb7MBC+66EXONZRFSjPxEhhVD3AZAe3DZNhiTZP7bHq1W6IJQrLX9WEFVu1FVBR+Kixbz378hbHjxmMhqkxeduh7CFKpd2T49CadCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XU7XoKyq0Pjs46fgv/84EcYBVRr/v56avPc2XRjUn8=;
 b=ktmA4/cQPJBttvprib9JLFnQwjj/jdi38hFI3s+UN4sRxTnysK2lqSkfG0lFmqO7PxD0A5QHaK9z8Q9QG6ROnvS8yVFLNWnde6uvfQKKzT7JDUyHTDyK/ir6jE0xksLcJd7lOxpuh8wYjYoMEy3R2IvI9WWpZXuA++HAj/0yeYH2fOkbEDKkqioR6WlY12G2Ujk3ylv4DaJybeLfonlFZhzYm8V2n76ND8GejZyNkr3QKlBuJxaZhVUfCIfLgmflsgxQKovDw4ZO4Y0PWdhW83F+MjUXLa+wXxVrjmoauslJzNjtNCHymd5wJb1XNP6wADKS5LHe6Fh/V4mPopVtvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XU7XoKyq0Pjs46fgv/84EcYBVRr/v56avPc2XRjUn8=;
 b=O9xfUfFA0DWgBw52SGmLH5c3uoOMn5F2OnKyY6YP3eDg7D0VmHXQQ1J9Ld74T2JcQzbqG8drTwBwaC2EtLWCOcwuBTpA9uJ876qE3yMdtzGVG83f+eWF9lbRmIrcBJyQetHimEHsDHCHNB93KtCI8C1rzfgocoHJaN3TNQ+4BIk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/16] net/mlx5e: Support tc block sharing for representors
Date:   Tue, 26 May 2020 18:49:13 -0700
Message-Id: <20200527014924.278327-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e004803-7c71-43a6-5518-08d801e04738
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB66375155AA782F9DC34C612EBEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XuaMxygNaWt8m0pdUOse8a8zBg/DRbxSUCenfoM0bPtuw8IfFreRUR75GTtp/bOpKv9RUseLf7lzx0qrFdabIyE1MgLvuXXYtPDDz8rx9vyYAzdem+vAp9X/l4r5pMCUBGMp/vL4g0gzjZF5rH+J8GQ/we9cW0te1Hpt+zxa8helC2pz0W8xKkOd9KoXFTW+mjsrdCqcGcyJ+UrKb1WE7uG3IG+zStYvsvfvTeEGSMjVxK1dnCXhR3/CB9R933TIpmbJFMhVtNRoRgMTRdsirKToXQykvTnmVOge3/Yn6QYMD8EeOqN7XI+oqbIjo6D6vAgMll0BNAcPbVD2ApxWqD1upQu6P15CnqqxFcuB0YtQtOXVWnFGWjJyHot3MmdK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(6666004)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 79Mkg00hNfv9vRbkVVqtM4gTwqlvZdRu5vZrsPtBkr6jVk4KZYOozBNLE1JtaLD3lxzjKxoNFri1yAnL/ZwtIyz9GPhe1/eGGSkNNWoMf/YVg8qckP1uUDn+d2PUxN0ENJSuDMVwwar5ZOdierXcalLEpXOOZxhJwF0pxohTPS6SjzO06tQmOv9L+p/uwJlRN+YDNQdsRYTWJK3Hxdfk7FPUuwPgaWyBP3MURfQ0XOfqvqEzLK3vBQffFbf5vVsdVHV0ni3rlTicK1KCP/dM9b6n9o6YjDNJbFk0a7hId1o+t3WNJJtEenq2w67hkszV9d9cbOyfN9HxucTUhoYnNnmKbWn/52+pWtdJvAyNFSue4rQ45GHe/Z9m9ONY0aTxBOJNtsPCkGqahYE04b0LwpFj+XnUbTYRLlqWnpsh6CSC7RLbBlC33CGYE0qk5URarRqw1FEjiddah3YJ3YllKXdGteGpg11ja2gdXC0E9d4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e004803-7c71-43a6-5518-08d801e04738
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:05.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqSl4y9yNYwQHrn0f2PyNTSkJ46jso9ygTx5tlogiGMNfAQWhGo2x5hZcPurjSm3SvyFV00q25EW7wFKhE0isQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
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

