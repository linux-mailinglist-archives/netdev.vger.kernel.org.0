Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC53A4FAC
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfIBHXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:14 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:38403
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729529AbfIBHXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSMsKMteFUrRDedQIAfqurqiI17AQHX/nvEy3rNSIcziysmqgVcHl4kcgSRXmPSE3fF9tlp8hYB5GUduPYHjpj6WZ0zSfj95bK2BARZiPuujJYLc31Q8QiyHUha1TqBeVUF/8QU+sJJe83JccbTu9uSMYJFiK/kVrGNfFSBjQ+oV1ZReHWCvn06j+0yiu5PQkjFqgn4kuUzEnoVH7EL/9ahsQl50KCx48FnlPHmei73p0SYhNpdSU7pmNxM1UMBZWpJHeK3vf13Q4B9pSXxZYd0clpKT5Mc5ZeL9HXuXDgGyOK+UK4EEcUDKAyECCDLhXcRW27G7VKO1jbzJ6Yo+lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1diACnJ75vpYCqczzL2eY9/qv4A1I8fJ+mW0trqJncc=;
 b=jRyZM35KbAWs+lC43k4FstHBDBH+KYw8bECr8keU5zuOibkE8EI1OmQNbUZP/fVMiNM/oYRXW4/tCfMygJVhin9oWhorVoW1UwM6gFBnm23FRx7N49Tg7cABi1qriXjKHrdJSoh1axbUQvQxSOuVzSsVXGMp3mIX1BzUqeA9swpVoNievIIjTRW846Zv45TRVTJOB4DYOWN4zt974ALIhB2dIcxhMnQcWcR5xcwGglKmctTMNcigYOoM+EmoUaK0C4qRzo6D4xtLBq/L/nHSczPvV5qj/J3Oed6V+sPktMIy1M3Bgeidfahl+ayoc1DK9hqv2TwnNpJCH1v3zBvEhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1diACnJ75vpYCqczzL2eY9/qv4A1I8fJ+mW0trqJncc=;
 b=J1N+B90bt5Aj+dh1QW+poom9gL7TydHoreHhwuKWJMn80FHQqh/mLoo0Ru/aGTGRGyIZz3M/KRklHf3ML+WgSZBAnZ17UHFHFelu55YTBrdQUoejxU70wd8aEsCRV7n23WrQiCTaoJ01Vj8yCIpoK/7xVesQUOLjAek0wiA/VF4=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2625.eurprd05.prod.outlook.com (10.172.217.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Mon, 2 Sep 2019 07:22:52 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:22:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/18] net/mlx5: Add flow steering actions to fs_cmd shim
 layer
Thread-Topic: [net-next 01/18] net/mlx5: Add flow steering actions to fs_cmd
 shim layer
Thread-Index: AQHVYV87T8tleZGT5UquhfNqVzZ07w==
Date:   Mon, 2 Sep 2019 07:22:52 +0000
Message-ID: <20190902072213.7683-2-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77b64274-1688-4253-5e08-08d72f765dcb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2625;
x-ms-traffictypediagnostic: AM4PR0501MB2625:|AM4PR0501MB2625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26252DA4E3E7CD3171D26B95BEBE0@AM4PR0501MB2625.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(199004)(189003)(8676002)(107886003)(14454004)(7736002)(6512007)(1076003)(53946003)(11346002)(64756008)(66556008)(66476007)(66946007)(66446008)(50226002)(26005)(2616005)(36756003)(99286004)(102836004)(478600001)(71200400001)(446003)(6486002)(71190400001)(53936002)(52116002)(305945005)(66066001)(76176011)(3846002)(256004)(186003)(316002)(486006)(4326008)(5024004)(14444005)(54906003)(6916009)(81166006)(6116002)(81156014)(30864003)(86362001)(2906002)(5660300002)(8936002)(25786009)(6506007)(386003)(476003)(6436002)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2625;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5lQkb3uiLmRPxEYltBbC5PkeSLz+jA6iPo0nIYzwxNxhvGugpUYIv8yayMQy3SXOOpxsSGcwB1xATOmpT93dafP+KAu4YsgZT0hT6su/9W6i78z9hG3wQucmNF26CoLvQWNe1DB7ce95PIHLdgEyEuO/sNGSa8iC1Vf+Br4XbJ0od9lf9uZFPuE80obEFJHTuB+xJ1uCQMSnhwmCKkHwU+8a2gFxv1Ha3YUxc/Q/oML5X0Jjsbk9ZK2jU6xUfooahf3x7LN0MOkpzqdlC8b6U+rcs+l7BCnwbWMe79U2Yua49TpFHZFemsYpeLi3bH8+u0ooeKtYwDoGJJTxVLXoP4j28ex+t+8L/4U599j1PcBzU0SGpBfnUYTXC6Oe3Csl3p4C2H9xEMnOwoHdY81ELjeZvn7pGsQ4YsNoOd9E/Og=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b64274-1688-4253-5e08-08d72f765dcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:22:52.7077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J1ChQWBo1L18FDNBqVCwVtGm4gkffnf72qJaNXIxhsBoyYI5TSRKrksk2pLMrv3GiLIlBNGlQAA1aKiI3Y/gEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2625
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add flow steering actions: modify header and packet reformat
to the fs_cmd shim layer. This allows each namespace to define
possibly different functionality for alloc/dealloc action commands.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c             |  18 +--
 drivers/infiniband/hw/mlx5/main.c             |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   5 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  27 ++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  46 ++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  26 +++--
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  92 ++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |  18 +++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 105 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  11 ++
 include/linux/mlx5/fs.h                       |  33 +++---
 13 files changed, 286 insertions(+), 110 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5=
/flow.c
index b8841355fcd5..324acc7b5b9e 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -322,11 +322,11 @@ void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_f=
low_action *maction)
 	switch (maction->flow_action_raw.sub_type) {
 	case MLX5_IB_FLOW_ACTION_MODIFY_HEADER:
 		mlx5_modify_header_dealloc(maction->flow_action_raw.dev->mdev,
-					   maction->flow_action_raw.action_id);
+					   maction->flow_action_raw.modify_hdr);
 		break;
 	case MLX5_IB_FLOW_ACTION_PACKET_REFORMAT:
 		mlx5_packet_reformat_dealloc(maction->flow_action_raw.dev->mdev,
-			maction->flow_action_raw.action_id);
+					     maction->flow_action_raw.pkt_reformat);
 		break;
 	case MLX5_IB_FLOW_ACTION_DECAP:
 		break;
@@ -352,10 +352,10 @@ mlx5_ib_create_modify_header(struct mlx5_ib_dev *dev,
 	if (!maction)
 		return ERR_PTR(-ENOMEM);
=20
-	ret =3D mlx5_modify_header_alloc(dev->mdev, namespace, num_actions, in,
-				       &maction->flow_action_raw.action_id);
+	maction->flow_action_raw.modify_hdr =3D
+		mlx5_modify_header_alloc(dev->mdev, namespace, num_actions, in);
=20
-	if (ret) {
+	if (IS_ERR(maction->flow_action_raw.modify_hdr)) {
 		kfree(maction);
 		return ERR_PTR(ret);
 	}
@@ -479,10 +479,10 @@ static int mlx5_ib_flow_action_create_packet_reformat=
_ctx(
 	if (ret)
 		return ret;
=20
-	ret =3D mlx5_packet_reformat_alloc(dev->mdev, prm_prt, len,
-					 in, namespace,
-					 &maction->flow_action_raw.action_id);
-	if (ret)
+	maction->flow_action_raw.pkt_reformat =3D
+		mlx5_packet_reformat_alloc(dev->mdev, prm_prt, len,
+					   in, namespace);
+	if (IS_ERR(maction->flow_action_raw.pkt_reformat))
 		return ret;
=20
 	maction->flow_action_raw.sub_type =3D
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 016373d1d27e..4e9f1507ffd9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2658,7 +2658,8 @@ int parse_flow_flow_action(struct mlx5_ib_flow_action=
 *maction,
 			if (action->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 				return -EINVAL;
 			action->action |=3D MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			action->modify_id =3D maction->flow_action_raw.action_id;
+			action->modify_hdr =3D
+				maction->flow_action_raw.modify_hdr;
 			return 0;
 		}
 		if (maction->flow_action_raw.sub_type =3D=3D
@@ -2675,8 +2676,8 @@ int parse_flow_flow_action(struct mlx5_ib_flow_action=
 *maction,
 				return -EINVAL;
 			action->action |=3D
 				MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-			action->reformat_id =3D
-				maction->flow_action_raw.action_id;
+			action->pkt_reformat =3D
+				maction->flow_action_raw.pkt_reformat;
 			return 0;
 		}
 		/* fall through */
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/m=
lx5/mlx5_ib.h
index a20d2ee08a3b..125a507c10ed 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -868,7 +868,10 @@ struct mlx5_ib_flow_action {
 		struct {
 			struct mlx5_ib_dev *dev;
 			u32 sub_type;
-			u32 action_id;
+			union {
+				struct mlx5_modify_hdr *modify_hdr;
+				struct mlx5_pkt_reformat *pkt_reformat;
+			};
 		} flow_action_raw;
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 4c4620db3d31..f8ee18b4da6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -291,14 +291,14 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv=
 *priv,
 		 */
 		goto out;
 	}
-
-	err =3D mlx5_packet_reformat_alloc(priv->mdev,
-					 e->reformat_type,
-					 ipv4_encap_size, encap_header,
-					 MLX5_FLOW_NAMESPACE_FDB,
-					 &e->encap_id);
-	if (err)
+	e->pkt_reformat =3D mlx5_packet_reformat_alloc(priv->mdev,
+						     e->reformat_type,
+						     ipv4_encap_size, encap_header,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(e->pkt_reformat)) {
+		err =3D PTR_ERR(e->pkt_reformat);
 		goto destroy_neigh_entry;
+	}
=20
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
@@ -407,13 +407,14 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv=
 *priv,
 		goto out;
 	}
=20
-	err =3D mlx5_packet_reformat_alloc(priv->mdev,
-					 e->reformat_type,
-					 ipv6_encap_size, encap_header,
-					 MLX5_FLOW_NAMESPACE_FDB,
-					 &e->encap_id);
-	if (err)
+	e->pkt_reformat =3D mlx5_packet_reformat_alloc(priv->mdev,
+						     e->reformat_type,
+						     ipv6_encap_size, encap_header,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(e->pkt_reformat)) {
+		err =3D PTR_ERR(e->pkt_reformat);
 		goto destroy_neigh_entry;
+	}
=20
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index a0ae5069d8c3..8e512216deb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -161,7 +161,7 @@ struct mlx5e_encap_entry {
 	 */
 	struct hlist_node encap_hlist;
 	struct list_head flows;
-	u32 encap_id;
+	struct mlx5_pkt_reformat *pkt_reformat;
 	const struct ip_tunnel_info *tun_info;
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 67f66412a33c..30d26eba75a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -61,7 +61,7 @@
 struct mlx5_nic_flow_attr {
 	u32 action;
 	u32 flow_tag;
-	u32 mod_hdr_id;
+	struct mlx5_modify_hdr *modify_hdr;
 	u32 hairpin_tirn;
 	u8 match_level;
 	struct mlx5_flow_table	*hairpin_ft;
@@ -201,7 +201,7 @@ struct mlx5e_mod_hdr_entry {
=20
 	struct mod_hdr_key key;
=20
-	u32 mod_hdr_id;
+	struct mlx5_modify_hdr *modify_hdr;
=20
 	refcount_t refcnt;
 	struct completion res_ready;
@@ -334,7 +334,7 @@ static void mlx5e_mod_hdr_put(struct mlx5e_priv *priv,
=20
 	WARN_ON(!list_empty(&mh->flows));
 	if (mh->compl_result > 0)
-		mlx5_modify_header_dealloc(priv->mdev, mh->mod_hdr_id);
+		mlx5_modify_header_dealloc(priv->mdev, mh->modify_hdr);
=20
 	kfree(mh);
 }
@@ -395,11 +395,11 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
 	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
 	mutex_unlock(&tbl->lock);
=20
-	err =3D mlx5_modify_header_alloc(priv->mdev, namespace,
-				       mh->key.num_actions,
-				       mh->key.actions,
-				       &mh->mod_hdr_id);
-	if (err) {
+	mh->modify_hdr =3D mlx5_modify_header_alloc(priv->mdev, namespace,
+						  mh->key.num_actions,
+						  mh->key.actions);
+	if (IS_ERR(mh->modify_hdr)) {
+		err =3D PTR_ERR(mh->modify_hdr);
 		mh->compl_result =3D err;
 		goto alloc_header_err;
 	}
@@ -412,9 +412,9 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
 	list_add(&flow->mod_hdr, &mh->flows);
 	spin_unlock(&mh->flows_lock);
 	if (mlx5e_is_eswitch_flow(flow))
-		flow->esw_attr->mod_hdr_id =3D mh->mod_hdr_id;
+		flow->esw_attr->modify_hdr =3D mh->modify_hdr;
 	else
-		flow->nic_attr->mod_hdr_id =3D mh->mod_hdr_id;
+		flow->nic_attr->modify_hdr =3D mh->modify_hdr;
=20
 	return 0;
=20
@@ -906,7 +906,6 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	struct mlx5_flow_destination dest[2] =3D {};
 	struct mlx5_flow_act flow_act =3D {
 		.action =3D attr->action,
-		.reformat_id =3D 0,
 		.flags    =3D FLOW_ACT_NO_APPEND,
 	};
 	struct mlx5_fc *counter =3D NULL;
@@ -947,7 +946,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
=20
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err =3D mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-		flow_act.modify_id =3D attr->mod_hdr_id;
+		flow_act.modify_hdr =3D attr->modify_hdr;
 		kfree(parse_attr->mod_hdr_actions);
 		if (err)
 			return err;
@@ -1304,14 +1303,13 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *pr=
iv,
 	struct mlx5e_tc_flow *flow;
 	int err;
=20
-	err =3D mlx5_packet_reformat_alloc(priv->mdev,
-					 e->reformat_type,
-					 e->encap_size, e->encap_header,
-					 MLX5_FLOW_NAMESPACE_FDB,
-					 &e->encap_id);
-	if (err) {
-		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation heade=
r, %d\n",
-			       err);
+	e->pkt_reformat =3D mlx5_packet_reformat_alloc(priv->mdev,
+						     e->reformat_type,
+						     e->encap_size, e->encap_header,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(e->pkt_reformat)) {
+		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation heade=
r, %lu\n",
+			       PTR_ERR(e->pkt_reformat));
 		return;
 	}
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
@@ -1326,7 +1324,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv=
,
 		esw_attr =3D flow->esw_attr;
 		spec =3D &esw_attr->parse_attr->spec;
=20
-		esw_attr->dests[flow->tmp_efi_index].encap_id =3D e->encap_id;
+		esw_attr->dests[flow->tmp_efi_index].pkt_reformat =3D e->pkt_reformat;
 		esw_attr->dests[flow->tmp_efi_index].flags |=3D MLX5_ESW_DEST_ENCAP_VALI=
D;
 		/* Flow can be associated with multiple encap entries.
 		 * Before offloading the flow verify that all of them have
@@ -1395,7 +1393,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv=
,
=20
 	/* we know that the encap is valid */
 	e->flags &=3D ~MLX5_ENCAP_ENTRY_VALID;
-	mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
+	mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
 }
=20
 static struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow)
@@ -1561,7 +1559,7 @@ static void mlx5e_encap_dealloc(struct mlx5e_priv *pr=
iv, struct mlx5e_encap_entr
 		mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
=20
 		if (e->flags & MLX5_ENCAP_ENTRY_VALID)
-			mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
+			mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
 	}
=20
 	kfree(e->encap_header);
@@ -3048,7 +3046,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv=
,
 	flow->encaps[out_index].index =3D out_index;
 	*encap_dev =3D e->out_dev;
 	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
-		attr->dests[out_index].encap_id =3D e->encap_id;
+		attr->dests[out_index].pkt_reformat =3D e->pkt_reformat;
 		attr->dests[out_index].flags |=3D MLX5_ESW_DEST_ENCAP_VALID;
 		*encap_valid =3D true;
 	} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index aba9e7a6ad3c..4f70202db6af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -69,7 +69,7 @@ struct vport_ingress {
 	struct mlx5_flow_group *allow_spoofchk_only_grp;
 	struct mlx5_flow_group *allow_untagged_only_grp;
 	struct mlx5_flow_group *drop_grp;
-	int modify_metadata_id;
+	struct mlx5_modify_hdr   *modify_metadata;
 	struct mlx5_flow_handle  *modify_metadata_rule;
 	struct mlx5_flow_handle  *allow_rule;
 	struct mlx5_flow_handle  *drop_rule;
@@ -385,11 +385,11 @@ struct mlx5_esw_flow_attr {
 	struct {
 		u32 flags;
 		struct mlx5_eswitch_rep *rep;
+		struct mlx5_pkt_reformat *pkt_reformat;
 		struct mlx5_core_dev *mdev;
-		u32 encap_id;
 		struct mlx5_termtbl_handle *termtbl;
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
-	u32	mod_hdr_id;
+	struct  mlx5_modify_hdr *modify_hdr;
 	u8	inner_match_level;
 	u8	outer_match_level;
 	struct mlx5_fc *counter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7d3582ee66b7..bee67ff58137 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -190,10 +190,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *=
esw,
 						MLX5_FLOW_DEST_VPORT_VHCA_ID;
 				if (attr->dests[j].flags & MLX5_ESW_DEST_ENCAP) {
 					flow_act.action |=3D MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-					flow_act.reformat_id =3D attr->dests[j].encap_id;
+					flow_act.pkt_reformat =3D attr->dests[j].pkt_reformat;
 					dest[i].vport.flags |=3D MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
-					dest[i].vport.reformat_id =3D
-						attr->dests[j].encap_id;
+					dest[i].vport.pkt_reformat =3D
+						attr->dests[j].pkt_reformat;
 				}
 				i++;
 			}
@@ -213,7 +213,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *es=
w,
 		spec->match_criteria_enable |=3D MLX5_MATCH_INNER_HEADERS;
=20
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		flow_act.modify_id =3D attr->mod_hdr_id;
+		flow_act.modify_hdr =3D attr->modify_hdr;
=20
 	fdb =3D esw_get_prio_table(esw, attr->chain, attr->prio, !!split);
 	if (IS_ERR(fdb)) {
@@ -276,7 +276,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 			dest[i].vport.flags |=3D MLX5_FLOW_DEST_VPORT_VHCA_ID;
 		if (attr->dests[i].flags & MLX5_ESW_DEST_ENCAP) {
 			dest[i].vport.flags |=3D MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
-			dest[i].vport.reformat_id =3D attr->dests[i].encap_id;
+			dest[i].vport.pkt_reformat =3D attr->dests[i].pkt_reformat;
 		}
 	}
 	dest[i].type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
@@ -1734,7 +1734,7 @@ static int esw_vport_ingress_prio_tag_config(struct m=
lx5_eswitch *esw,
=20
 	if (vport->ingress.modify_metadata_rule) {
 		flow_act.action |=3D MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-		flow_act.modify_id =3D vport->ingress.modify_metadata_id;
+		flow_act.modify_hdr =3D vport->ingress.modify_metadata;
 	}
=20
 	vport->ingress.allow_rule =3D
@@ -1770,9 +1770,11 @@ static int esw_vport_add_ingress_acl_modify_metadata=
(struct mlx5_eswitch *esw,
 	MLX5_SET(set_action_in, action, data,
 		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport));
=20
-	err =3D mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRES=
S,
-				       1, action, &vport->ingress.modify_metadata_id);
-	if (err) {
+	vport->ingress.modify_metadata =3D
+		mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
+					 1, action);
+	if (IS_ERR(vport->ingress.modify_metadata)) {
+		err =3D PTR_ERR(vport->ingress.modify_metadata);
 		esw_warn(esw->dev,
 			 "failed to alloc modify header for vport %d ingress acl (%d)\n",
 			 vport->vport, err);
@@ -1780,7 +1782,7 @@ static int esw_vport_add_ingress_acl_modify_metadata(=
struct mlx5_eswitch *esw,
 	}
=20
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_MOD_HDR | MLX5_FLOW_CONTEXT_=
ACTION_ALLOW;
-	flow_act.modify_id =3D vport->ingress.modify_metadata_id;
+	flow_act.modify_hdr =3D vport->ingress.modify_metadata;
 	vport->ingress.modify_metadata_rule =3D mlx5_add_flow_rules(vport->ingres=
s.acl,
 								  &spec, &flow_act, NULL, 0);
 	if (IS_ERR(vport->ingress.modify_metadata_rule)) {
@@ -1794,7 +1796,7 @@ static int esw_vport_add_ingress_acl_modify_metadata(=
struct mlx5_eswitch *esw,
=20
 out:
 	if (err)
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.modify_metadata_id);
+		mlx5_modify_header_dealloc(esw->dev, vport->ingress.modify_metadata);
 	return err;
 }
=20
@@ -1803,7 +1805,7 @@ void esw_vport_del_ingress_acl_modify_metadata(struct=
 mlx5_eswitch *esw,
 {
 	if (vport->ingress.modify_metadata_rule) {
 		mlx5_del_flow_rules(vport->ingress.modify_metadata_rule);
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.modify_metadata_id);
+		mlx5_modify_header_dealloc(esw->dev, vport->ingress.modify_metadata);
=20
 		vport->ingress.modify_metadata_rule =3D NULL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index 1e3381604b3d..488f50dfb404 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -107,6 +107,34 @@ static int mlx5_cmd_stub_delete_fte(struct mlx5_flow_r=
oot_namespace *ns,
 	return 0;
 }
=20
+static int mlx5_cmd_stub_packet_reformat_alloc(struct mlx5_flow_root_names=
pace *ns,
+					       int reformat_type,
+					       size_t size,
+					       void *reformat_data,
+					       enum mlx5_flow_namespace_type namespace,
+					       struct mlx5_pkt_reformat *pkt_reformat)
+{
+	return 0;
+}
+
+static void mlx5_cmd_stub_packet_reformat_dealloc(struct mlx5_flow_root_na=
mespace *ns,
+						  struct mlx5_pkt_reformat *pkt_reformat)
+{
+}
+
+static int mlx5_cmd_stub_modify_header_alloc(struct mlx5_flow_root_namespa=
ce *ns,
+					     u8 namespace, u8 num_actions,
+					     void *modify_actions,
+					     struct mlx5_modify_hdr *modify_hdr)
+{
+	return 0;
+}
+
+static void mlx5_cmd_stub_modify_header_dealloc(struct mlx5_flow_root_name=
space *ns,
+						struct mlx5_modify_hdr *modify_hdr)
+{
+}
+
 static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 				   struct mlx5_flow_table *ft, u32 underlay_qpn,
 				   bool disconnect)
@@ -412,11 +440,13 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev=
,
 	} else {
 		MLX5_SET(flow_context, in_flow_context, action,
 			 fte->action.action);
-		MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
-			 fte->action.reformat_id);
+		if (fte->action.pkt_reformat)
+			MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
+				 fte->action.pkt_reformat->id);
 	}
-	MLX5_SET(flow_context, in_flow_context, modify_header_id,
-		 fte->action.modify_id);
+	if (fte->action.modify_hdr)
+		MLX5_SET(flow_context, in_flow_context, modify_header_id,
+			 fte->action.modify_hdr->id);
=20
 	vlan =3D MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan);
=20
@@ -468,7 +498,7 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 						    MLX5_FLOW_DEST_VPORT_REFORMAT_ID));
 					MLX5_SET(extended_dest_format, in_dests,
 						 packet_reformat_id,
-						 dst->dest_attr.vport.reformat_id);
+						 dst->dest_attr.vport.pkt_reformat->id);
 				}
 				break;
 			default:
@@ -643,14 +673,15 @@ int mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev,=
 u32 base_id, int bulk_len,
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
=20
-int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
-			       int reformat_type,
-			       size_t size,
-			       void *reformat_data,
-			       enum mlx5_flow_namespace_type namespace,
-			       u32 *packet_reformat_id)
+static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace =
*ns,
+					  int reformat_type,
+					  size_t size,
+					  void *reformat_data,
+					  enum mlx5_flow_namespace_type namespace,
+					  struct mlx5_pkt_reformat *pkt_reformat)
 {
 	u32 out[MLX5_ST_SZ_DW(alloc_packet_reformat_context_out)];
+	struct mlx5_core_dev *dev =3D ns->dev;
 	void *packet_reformat_context_in;
 	int max_encap_size;
 	void *reformat;
@@ -693,35 +724,36 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *=
dev,
 	memset(out, 0, sizeof(out));
 	err =3D mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
=20
-	*packet_reformat_id =3D MLX5_GET(alloc_packet_reformat_context_out,
-				       out, packet_reformat_id);
+	pkt_reformat->id =3D MLX5_GET(alloc_packet_reformat_context_out,
+				    out, packet_reformat_id);
 	kfree(in);
 	return err;
 }
-EXPORT_SYMBOL(mlx5_packet_reformat_alloc);
=20
-void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
-				  u32 packet_reformat_id)
+static void mlx5_cmd_packet_reformat_dealloc(struct mlx5_flow_root_namespa=
ce *ns,
+					     struct mlx5_pkt_reformat *pkt_reformat)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_in)];
 	u32 out[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_out)];
+	struct mlx5_core_dev *dev =3D ns->dev;
=20
 	memset(in, 0, sizeof(in));
 	MLX5_SET(dealloc_packet_reformat_context_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT);
 	MLX5_SET(dealloc_packet_reformat_context_in, in, packet_reformat_id,
-		 packet_reformat_id);
+		 pkt_reformat->id);
=20
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
-EXPORT_SYMBOL(mlx5_packet_reformat_dealloc);
=20
-int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
-			     u8 namespace, u8 num_actions,
-			     void *modify_actions, u32 *modify_header_id)
+static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *n=
s,
+					u8 namespace, u8 num_actions,
+					void *modify_actions,
+					struct mlx5_modify_hdr *modify_hdr)
 {
 	u32 out[MLX5_ST_SZ_DW(alloc_modify_header_context_out)];
 	int max_actions, actions_size, inlen, err;
+	struct mlx5_core_dev *dev =3D ns->dev;
 	void *actions_in;
 	u8 table_type;
 	u32 *in;
@@ -772,26 +804,26 @@ int mlx5_modify_header_alloc(struct mlx5_core_dev *de=
v,
 	memset(out, 0, sizeof(out));
 	err =3D mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
=20
-	*modify_header_id =3D MLX5_GET(alloc_modify_header_context_out, out, modi=
fy_header_id);
+	modify_hdr->id =3D MLX5_GET(alloc_modify_header_context_out, out, modify_=
header_id);
 	kfree(in);
 	return err;
 }
-EXPORT_SYMBOL(mlx5_modify_header_alloc);
=20
-void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev, u32 modify_head=
er_id)
+static void mlx5_cmd_modify_header_dealloc(struct mlx5_flow_root_namespace=
 *ns,
+					   struct mlx5_modify_hdr *modify_hdr)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_modify_header_context_in)];
 	u32 out[MLX5_ST_SZ_DW(dealloc_modify_header_context_out)];
+	struct mlx5_core_dev *dev =3D ns->dev;
=20
 	memset(in, 0, sizeof(in));
 	MLX5_SET(dealloc_modify_header_context_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT);
 	MLX5_SET(dealloc_modify_header_context_in, in, modify_header_id,
-		 modify_header_id);
+		 modify_hdr->id);
=20
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
-EXPORT_SYMBOL(mlx5_modify_header_dealloc);
=20
 static const struct mlx5_flow_cmds mlx5_flow_cmds =3D {
 	.create_flow_table =3D mlx5_cmd_create_flow_table,
@@ -803,6 +835,10 @@ static const struct mlx5_flow_cmds mlx5_flow_cmds =3D =
{
 	.update_fte =3D mlx5_cmd_update_fte,
 	.delete_fte =3D mlx5_cmd_delete_fte,
 	.update_root_ft =3D mlx5_cmd_update_root_ft,
+	.packet_reformat_alloc =3D mlx5_cmd_packet_reformat_alloc,
+	.packet_reformat_dealloc =3D mlx5_cmd_packet_reformat_dealloc,
+	.modify_header_alloc =3D mlx5_cmd_modify_header_alloc,
+	.modify_header_dealloc =3D mlx5_cmd_modify_header_dealloc
 };
=20
 static const struct mlx5_flow_cmds mlx5_flow_cmd_stubs =3D {
@@ -815,6 +851,10 @@ static const struct mlx5_flow_cmds mlx5_flow_cmd_stubs=
 =3D {
 	.update_fte =3D mlx5_cmd_stub_update_fte,
 	.delete_fte =3D mlx5_cmd_stub_delete_fte,
 	.update_root_ft =3D mlx5_cmd_stub_update_root_ft,
+	.packet_reformat_alloc =3D mlx5_cmd_stub_packet_reformat_alloc,
+	.packet_reformat_dealloc =3D mlx5_cmd_stub_packet_reformat_dealloc,
+	.modify_header_alloc =3D mlx5_cmd_stub_modify_header_alloc,
+	.modify_header_dealloc =3D mlx5_cmd_stub_modify_header_dealloc
 };
=20
 static const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.h
index bc4606306009..3268654d6748 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -75,6 +75,24 @@ struct mlx5_flow_cmds {
 			      struct mlx5_flow_table *ft,
 			      u32 underlay_qpn,
 			      bool disconnect);
+
+	int (*packet_reformat_alloc)(struct mlx5_flow_root_namespace *ns,
+				     int reformat_type,
+				     size_t size,
+				     void *reformat_data,
+				     enum mlx5_flow_namespace_type namespace,
+				     struct mlx5_pkt_reformat *pkt_reformat);
+
+	void (*packet_reformat_dealloc)(struct mlx5_flow_root_namespace *ns,
+					struct mlx5_pkt_reformat *pkt_reformat);
+
+	int (*modify_header_alloc)(struct mlx5_flow_root_namespace *ns,
+				   u8 namespace, u8 num_actions,
+				   void *modify_actions,
+				   struct mlx5_modify_hdr *modify_hdr);
+
+	void (*modify_header_dealloc)(struct mlx5_flow_root_namespace *ns,
+				      struct mlx5_modify_hdr *modify_hdr);
 };
=20
 int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 7bdec442f0ac..1d2333fd3080 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1415,7 +1415,8 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_dest=
ination *d1,
 		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_VHCA_ID) ?
 		      (d1->vport.vhca_id =3D=3D d2->vport.vhca_id) : true) &&
 		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID) ?
-		      (d1->vport.reformat_id =3D=3D d2->vport.reformat_id) : true)) ||
+		      (d1->vport.pkt_reformat->id =3D=3D
+		       d2->vport.pkt_reformat->id) : true)) ||
 		    (d1->type =3D=3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
 		     d1->ft =3D=3D d2->ft) ||
 		    (d1->type =3D=3D MLX5_FLOW_DESTINATION_TYPE_TIR &&
@@ -2888,3 +2889,105 @@ int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core=
_dev *dev, u32 underlay_qpn)
 	return err;
 }
 EXPORT_SYMBOL(mlx5_fs_remove_rx_underlay_qpn);
+
+static struct mlx5_flow_root_namespace
+*get_root_namespace(struct mlx5_core_dev *dev, enum mlx5_flow_namespace_ty=
pe ns_type)
+{
+	struct mlx5_flow_namespace *ns;
+
+	if (ns_type =3D=3D MLX5_FLOW_NAMESPACE_ESW_EGRESS ||
+	    ns_type =3D=3D MLX5_FLOW_NAMESPACE_ESW_INGRESS)
+		ns =3D mlx5_get_flow_vport_acl_namespace(dev, ns_type, 0);
+	else
+		ns =3D mlx5_get_flow_namespace(dev, ns_type);
+	if (!ns)
+		return NULL;
+
+	return find_root(&ns->node);
+}
+
+struct mlx5_modify_hdr *mlx5_modify_header_alloc(struct mlx5_core_dev *dev=
,
+						 u8 ns_type, u8 num_actions,
+						 void *modify_actions)
+{
+	struct mlx5_flow_root_namespace *root;
+	struct mlx5_modify_hdr *modify_hdr;
+	int err;
+
+	root =3D get_root_namespace(dev, ns_type);
+	if (!root)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	modify_hdr =3D kzalloc(sizeof(*modify_hdr), GFP_KERNEL);
+	if (!modify_hdr)
+		return ERR_PTR(-ENOMEM);
+
+	modify_hdr->ns_type =3D ns_type;
+	err =3D root->cmds->modify_header_alloc(root, ns_type, num_actions,
+					      modify_actions, modify_hdr);
+	if (err) {
+		kfree(modify_hdr);
+		return ERR_PTR(err);
+	}
+
+	return modify_hdr;
+}
+EXPORT_SYMBOL(mlx5_modify_header_alloc);
+
+void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
+				struct mlx5_modify_hdr *modify_hdr)
+{
+	struct mlx5_flow_root_namespace *root;
+
+	root =3D get_root_namespace(dev, modify_hdr->ns_type);
+	if (WARN_ON(!root))
+		return;
+	root->cmds->modify_header_dealloc(root, modify_hdr);
+	kfree(modify_hdr);
+}
+EXPORT_SYMBOL(mlx5_modify_header_dealloc);
+
+struct mlx5_pkt_reformat *mlx5_packet_reformat_alloc(struct mlx5_core_dev =
*dev,
+						     int reformat_type,
+						     size_t size,
+						     void *reformat_data,
+						     enum mlx5_flow_namespace_type ns_type)
+{
+	struct mlx5_pkt_reformat *pkt_reformat;
+	struct mlx5_flow_root_namespace *root;
+	int err;
+
+	root =3D get_root_namespace(dev, ns_type);
+	if (!root)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	pkt_reformat =3D kzalloc(sizeof(*pkt_reformat), GFP_KERNEL);
+	if (!pkt_reformat)
+		return ERR_PTR(-ENOMEM);
+
+	pkt_reformat->ns_type =3D ns_type;
+	pkt_reformat->reformat_type =3D reformat_type;
+	err =3D root->cmds->packet_reformat_alloc(root, reformat_type, size,
+						reformat_data, ns_type,
+						pkt_reformat);
+	if (err) {
+		kfree(pkt_reformat);
+		return ERR_PTR(err);
+	}
+
+	return pkt_reformat;
+}
+EXPORT_SYMBOL(mlx5_packet_reformat_alloc);
+
+void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
+				  struct mlx5_pkt_reformat *pkt_reformat)
+{
+	struct mlx5_flow_root_namespace *root;
+
+	root =3D get_root_namespace(dev, pkt_reformat->ns_type);
+	if (WARN_ON(!root))
+		return;
+	root->cmds->packet_reformat_dealloc(root, pkt_reformat);
+	kfree(pkt_reformat);
+}
+EXPORT_SYMBOL(mlx5_packet_reformat_dealloc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index 0d16b4b5ab83..ea0f221685ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -38,6 +38,17 @@
 #include <linux/rhashtable.h>
 #include <linux/llist.h>
=20
+struct mlx5_modify_hdr {
+	enum mlx5_flow_namespace_type ns_type;
+	u32 id;
+};
+
+struct mlx5_pkt_reformat {
+	enum mlx5_flow_namespace_type ns_type;
+	int reformat_type; /* from mlx5_ifc */
+	u32 id;
+};
+
 /* FS_TYPE_PRIO_CHAINS is a PRIO that will have namespaces only,
  * and those are in parallel to one another when going over them to connec=
t
  * a new flow table. Meaning the last flow table in a TYPE_PRIO prio in on=
e
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 97ec6be62ac4..724d276ea133 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -84,6 +84,8 @@ enum {
 	FDB_SLOW_PATH,
 };
=20
+struct mlx5_pkt_reformat;
+struct mlx5_modify_hdr;
 struct mlx5_flow_table;
 struct mlx5_flow_group;
 struct mlx5_flow_namespace;
@@ -121,7 +123,7 @@ struct mlx5_flow_destination {
 		struct {
 			u16		num;
 			u16		vhca_id;
-			u32		reformat_id;
+			struct mlx5_pkt_reformat *pkt_reformat;
 			u8		flags;
 		} vport;
 	};
@@ -195,8 +197,8 @@ enum {
=20
 struct mlx5_flow_act {
 	u32 action;
-	u32 reformat_id;
-	u32 modify_id;
+	struct mlx5_modify_hdr  *modify_hdr;
+	struct mlx5_pkt_reformat *pkt_reformat;
 	uintptr_t esp_id;
 	u32 flags;
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
@@ -205,8 +207,6 @@ struct mlx5_flow_act {
=20
 #define MLX5_DECLARE_FLOW_ACT(name) \
 	struct mlx5_flow_act name =3D { .action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_=
DEST,\
-				      .reformat_id =3D 0, \
-				      .modify_id =3D 0, \
 				      .flags =3D  0, }
=20
 /* Single destination per rule.
@@ -236,19 +236,18 @@ u32 mlx5_fc_id(struct mlx5_fc *counter);
 int mlx5_fs_add_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay_qp=
n);
 int mlx5_fs_remove_rx_underlay_qpn(struct mlx5_core_dev *dev, u32 underlay=
_qpn);
=20
-int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
-			     u8 namespace, u8 num_actions,
-			     void *modify_actions, u32 *modify_header_id);
+struct mlx5_modify_hdr *mlx5_modify_header_alloc(struct mlx5_core_dev *dev=
,
+						 u8 ns_type, u8 num_actions,
+						 void *modify_actions);
 void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
-				u32 modify_header_id);
-
-int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
-			       int reformat_type,
-			       size_t size,
-			       void *reformat_data,
-			       enum mlx5_flow_namespace_type namespace,
-			       u32 *packet_reformat_id);
+				struct mlx5_modify_hdr *modify_hdr);
+
+struct mlx5_pkt_reformat *mlx5_packet_reformat_alloc(struct mlx5_core_dev =
*dev,
+						     int reformat_type,
+						     size_t size,
+						     void *reformat_data,
+						     enum mlx5_flow_namespace_type ns_type);
 void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
-				  u32 packet_reformat_id);
+				  struct mlx5_pkt_reformat *reformat);
=20
 #endif
--=20
2.21.0

