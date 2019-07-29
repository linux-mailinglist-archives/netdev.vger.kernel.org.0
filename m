Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22DC79D13
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfG2XwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:52:10 -0400
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:13028
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728060AbfG2XwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:52:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvmuCQcrM77cGnYWY5GbKTGVqh3icnmn9P1jDdpXPmS9uMkWCRlNXHf4niSG2G0rujIOUfrMozfiU5gSD1uVaYI5BCWr8lVOt0J7WczsWgxe9JGF0fjgLYakzUaf48RAPdxmWnvcqU+yHpnA+ZfxnOS0JM6ZcGWNQhV23fqF4AKy45w4UcR6weRL+Eh4nj7JhzzlZzE6jjrNoF8whXzGHOB7VyzEewpwcYOpG22GX7plQbhkyp6/2L+kr6Zq3xB+dPtK/t1/iHXQsdXhNI+bTGJnjatZUdJwNUM9n6eXpDjJFMQ8IuSXuQqWa/klpWn0+CbJ7EMrou5AaZlaEw4LNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7zXPC9P5BhPaqCzT6LVQOdBT5EI1jS25FjrpAVOyK0=;
 b=IK2icmpZ6GWWtb7aSItoNgRVs8N4/BOSly5Wdg9dPfxt0275x0hUMiJbxEgmdeZAV8eFpVQ4FXStjv8NQHuekm++yE1xZQV30jvFgzT4DzzMLsaOJCDvTDVLprLN8O2PliV99dK0ZPqPQnBFbZaWhNj++YuI9DrvlM8kpubPAaJcoL92X1B0dEVktTZhwDcgRaUh6XITRTF6yuyi4CQA7PdniNPYJu8mRGA+1v2N52FZCxv82s/lNn12DM2KLIoxDlhijA0Snms3f1zgxzVrWmBnPbbyoqz0mTTLaa+k8k4vthNgbpEYB7T5PFYeZLUNM8fGx8b5/6Hne4lvDZKdIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7zXPC9P5BhPaqCzT6LVQOdBT5EI1jS25FjrpAVOyK0=;
 b=W6t2tYp0TG6kkEUwuYpZxkXDfQnspfefMYx6ZSDA7/fQ3IIqjXcsSjvM9o4UomIVn4/6M02xivkqpQRRSE9ymc00eIdahdwnEUL8HMUD8IhDnpGCEA1ekjEJNv87fecethkx2G8I++ELY3hVeGe9cDZ5WgJt+Kj3IuqlTiRgwNU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:36 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/13] net/mlx5e: Protect tc flow table with mutex
Thread-Topic: [net-next 13/13] net/mlx5e: Protect tc flow table with mutex
Thread-Index: AQHVRmhrueHTO0kXlk+1kUbE5eGdrg==
Date:   Mon, 29 Jul 2019 23:50:36 +0000
Message-ID: <20190729234934.23595-14-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7283d2c-a4fa-4bfb-2c1e-08d7147f8d81
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB2343129028919FB82E37C55DBEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:404;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rKdyWLe+KXUslM5grLJc2F6DbmzKWC1hSoWFTxd5Vt8BW8/c3UjLCK8kaSl4UXKqYDOchihKw3Nwlti6p5EMHZ79Pq5E+KGoYf9KKDNbgoQSrAXaBFFod+IpollqzRLi2sLLEI2a0CwDHimhk8vqUCbc5I+nrsG8Im3DD9XmH0EBB7oschHyd/8nqVvFsccvoEHQ2DSB1l2TjOxcvntF4aKGykpdUNdIUXUvIRIj9v17yFBlkj6sCc9Bo5JJvOe534xhQMnkFV6WvCHnu1Lq/9lMwk1yXis/q2aw9IdvHHpajhrqPezPfD3tOi7jkw0G5NuYLyazYLCEZSlSKIwbF+xt6O+d5NmpZAreeQA0PClXPXhqBg5AfnYN+cOQltvdS+BrwPrazo9gdB2HFeOOb6fTbHFu9flxJJI2k6l+aiM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7283d2c-a4fa-4bfb-2c1e-08d7147f8d81
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:36.5828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

TC flow table is created when first flow is added, and destroyed when last
flow is removed. This assumes that all accesses to the table are externally
synchronized with rtnl lock. To remove dependency on rtnl lock, add new
mutex mlx5e_tc_table->t_lock and use it to protect the flow table.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index eb70ada89b09..4518ce19112e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -10,6 +10,8 @@ enum {
 };
=20
 struct mlx5e_tc_table {
+	/* protects flow table */
+	struct mutex			t_lock;
 	struct mlx5_flow_table		*t;
=20
 	struct rhashtable               ht;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 595a4c5667ea..f3ed028d5017 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -854,6 +854,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 			return err;
 	}
=20
+	mutex_lock(&priv->fs.tc.t_lock);
 	if (IS_ERR_OR_NULL(priv->fs.tc.t)) {
 		int tc_grp_size, tc_tbl_size;
 		u32 max_flow_counter;
@@ -873,6 +874,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 							    MLX5E_TC_TABLE_NUM_GROUPS,
 							    MLX5E_TC_FT_LEVEL, 0);
 		if (IS_ERR(priv->fs.tc.t)) {
+			mutex_unlock(&priv->fs.tc.t_lock);
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed to create tc offload table\n");
 			netdev_err(priv->netdev,
@@ -886,6 +888,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
=20
 	flow->rule[0] =3D mlx5_add_flow_rules(priv->fs.tc.t, &parse_attr->spec,
 					    &flow_act, dest, dest_ix);
+	mutex_unlock(&priv->fs.tc.t_lock);
=20
 	if (IS_ERR(flow->rule[0]))
 		return PTR_ERR(flow->rule[0]);
@@ -904,10 +907,12 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *=
priv,
 		mlx5_del_flow_rules(flow->rule[0]);
 	mlx5_fc_destroy(priv->mdev, counter);
=20
+	mutex_lock(&priv->fs.tc.t_lock);
 	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) && priv->fs.tc=
.t) {
 		mlx5_destroy_flow_table(priv->fs.tc.t);
 		priv->fs.tc.t =3D NULL;
 	}
+	mutex_unlock(&priv->fs.tc.t_lock);
=20
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
@@ -3684,6 +3689,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	struct mlx5e_tc_table *tc =3D &priv->fs.tc;
 	int err;
=20
+	mutex_init(&tc->t_lock);
 	hash_init(tc->mod_hdr_tbl);
 	hash_init(tc->hairpin_tbl);
=20
@@ -3722,6 +3728,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 		mlx5_destroy_flow_table(tc->t);
 		tc->t =3D NULL;
 	}
+	mutex_destroy(&tc->t_lock);
 }
=20
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
--=20
2.21.0

