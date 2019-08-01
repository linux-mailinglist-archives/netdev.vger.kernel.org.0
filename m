Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 141DB7E3A4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbfHAT5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:23 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388797AbfHAT5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6ZJdVLi2rnKw5h4bxkPzp/hAILHSpV/sN+JdcOha3VpRA3xn7g4sTmpkPnvI8BF53wUFEnzUnL7oN4ZlUnTwHf8xsiONzjSXFHi6CjcJCNHP0//FJdhT71pqL4b3TE4979SFx59g0Sptq9Kgz3n57TUJeEehZKAXLQeFyJRA1/XBxka3V+bq6IYUzuIV/edujxEQt7N8BwU5RWqfvP97UptsBbIfgFcg079SRgYumsNDZUYQesH+VyfxZlFk5tfj8sks43P7DduOcbxnkjQ0f0ikEw2s2xGYqFrQb74nkEZomVlA5f1emmU4ZS99YM3aJQqYx5/LwohcP8jhNp8NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH18EoplaABX92FypNd7b9C92kwIdVMp1HCQSUnKw8s=;
 b=MFLL2v6vFyrgWjxnkrW0k767uVHOxYpzE3Xv/lR0WqrYyf7q9OADL+NTndYk40SuG9y1IVMklJEZC1Q8ihwn8tjux8NWc8Kj5J1WM2p69/kL6tKazUnrcTQB/1vfQ6+QZXNJR0AtAftHOd2xtfYjznHlZVJQCIdvGmPh2bQdEK5x8fEMOPD6IBG1R9nqhyFtXCka7+kGDFMvgCrLaPL6lqskgZ+aiv6Fq+4lDpUY6+RE3HIANj9kVgpQMB0OZiLbubbghpUcLqxqeYq/fyNBRdh124RClY2qmFyvweB+wZEPHy5u28YjlfAvvWiZIn1cH6eUbfM3GlIFDXvnHcvLsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH18EoplaABX92FypNd7b9C92kwIdVMp1HCQSUnKw8s=;
 b=lqUKqTBpNocLb6GeBkkydUlPrGXL8MaNvmBlAIj2X8jO7Re30QtH6dHnj17gDpmmIPvAiyzVdm0FeN5Pt3fxQ1pB0pLJggkcjtVJeBGlINi8pKEV5aCU6rmvUpa/qNrpXZbe4MWSa7UVv0lxr1l7MfNGg8UekwYobRns2W4LbyA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:03 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Noam Stolero <noams@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/12] net/mlx5e: Tx, Soften inline mode VLAN dependencies
Thread-Topic: [net-next 07/12] net/mlx5e: Tx, Soften inline mode VLAN
 dependencies
Thread-Index: AQHVSKNJ5wsq9SQ000uAs3ExLtdQXg==
Date:   Thu, 1 Aug 2019 19:57:03 +0000
Message-ID: <20190801195620.26180-8-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5ceb26f-89b8-4fb5-2d4d-08d716ba6c28
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759B57A63C67B5D02C2ADEDBEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QnwpCMbxVXl1TXdzRR6v84jyPs1GYLL704yyOu0uiEU3VYMpppVChetYaqP62Eh3+PtVrkCwWLog05Fl2rHoTKwQfzHAzzO/8bQtUY/jCNSORZnwu6zCqBWmmRBYPZd8YTnTO8TESE4SHDh+bWpiifCSxnZCLYwUOqqXcDyYg6oSF+nbX178s+iJvzySBHfzADm1c32V3VuNyVo3q81+QkE5ULg+7RBOxlHinZJJr4bvJTxeROmOLjja2xKvssp/yaZXQNngXeifgSe22VWGAhXGOkxmw2yN0Il5xkCHTw9XSqanB3bzpNZhWhdfD60ibLIHlG0XR3LF5N833pYc/IUdiUieRgFSEPULII9NU0ZdeWaMVtA+diSl9DLBQnVejm51K+4a60qW0kKNX9OuSC5/KZGWtm1RSNAYqgRgJl8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ceb26f-89b8-4fb5-2d4d-08d716ba6c28
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:03.1794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

If capable, use zero inline mode in TX WQE for non-VLAN packets.
For VLAN ones, keep the enforcement of at least L2 inline mode,
unless the WQE VLAN insertion offload cap is on.

Performance:
Tested single core packet rate of 64Bytes.

NIC: ConnectX-5
CPU: Intel(R) Xeon(R) Gold 6154 CPU @ 3.00GHz

pktgen:
Before: 12.46 Mpps
After:  14.65 Mpps (+17.5%)

XDP_TX:
The MPWQE flow is not affected, as it already has this optimization.
So we test with priv-flag xdp_tx_mpwqe: off.

Before:  9.90 Mpps
After:  10.20 Mpps (+3%)

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Tested-by: Noam Stolero <noams@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 22 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en_common.c   | 12 ----------
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +++-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  7 +++---
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  7 +++---
 7 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 745bcc25c6f8..30f13f81c965 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -359,6 +359,7 @@ enum {
 	MLX5E_SQ_STATE_IPSEC,
 	MLX5E_SQ_STATE_AM,
 	MLX5E_SQ_STATE_TLS,
+	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 };
=20
 struct mlx5e_sq_wqe_info {
@@ -1132,7 +1133,6 @@ void mlx5e_build_rq_params(struct mlx5_core_dev *mdev=
,
 			   struct mlx5e_params *params);
 void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 			    u16 num_channels);
-u8 mlx5e_params_calculate_tx_min_inline(struct mlx5_core_dev *mdev);
 void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 7da22b413a48..87be96747902 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -117,9 +117,27 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void _=
_iomem *uar_map,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
=20
-static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5e_tx_wqe *wqe)
+static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg =
*cseg)
 {
-	return !!wqe->ctrl.tisn;
+	return cseg && !!cseg->tisn;
+}
+
+static inline u8
+mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg =
*cseg,
+			 struct sk_buff *skb)
+{
+	u8 mode;
+
+	if (mlx5e_transport_inline_tx_wqe(cseg))
+		return MLX5_INLINE_MODE_TCP_UDP;
+
+	mode =3D sq->min_inline_mode;
+
+	if (skb_vlan_tag_present(skb) &&
+	    test_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state))
+		mode =3D max_t(u8, MLX5_INLINE_MODE_L2, mode);
+
+	return mode;
 }
=20
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_common.c
index 1539cf3de5dc..f7890e0ce96c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -180,15 +180,3 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool e=
nable_uc_lb)
=20
 	return err;
 }
-
-u8 mlx5e_params_calculate_tx_min_inline(struct mlx5_core_dev *mdev)
-{
-	u8 min_inline_mode;
-
-	mlx5_query_min_inline(mdev, &min_inline_mode);
-	if (min_inline_mode =3D=3D MLX5_INLINE_MODE_NONE &&
-	    !MLX5_CAP_ETH(mdev, wqe_vlan_insert))
-		min_inline_mode =3D MLX5_INLINE_MODE_L2;
-
-	return min_inline_mode;
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 8dd31b5c740c..01f2918063af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1101,7 +1101,7 @@ void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv)
 static void mlx5e_trust_update_tx_min_inline_mode(struct mlx5e_priv *priv,
 						  struct mlx5e_params *params)
 {
-	params->tx_min_inline_mode =3D mlx5e_params_calculate_tx_min_inline(priv-=
>mdev);
+	mlx5_query_min_inline(priv->mdev, &params->tx_min_inline_mode);
 	if (priv->dcbx_dp.trust_state =3D=3D MLX5_QPTS_TRUST_DSCP &&
 	    params->tx_min_inline_mode =3D=3D MLX5_INLINE_MODE_L2)
 		params->tx_min_inline_mode =3D MLX5_INLINE_MODE_IP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b2618dd6dd10..e75cb18c2256 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1131,6 +1131,8 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->stats     =3D &c->priv->channel_stats[c->ix].sq[tc];
 	sq->stop_room =3D MLX5E_SQ_STOP_ROOM;
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
+	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
+		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
 	if (mlx5_accel_is_tls_device(c->priv->mdev)) {
@@ -4777,7 +4779,7 @@ void mlx5e_build_nic_params(struct mlx5_core_dev *mde=
v,
 	mlx5e_set_tx_cq_mode_params(params, MLX5_CQ_PERIOD_MODE_START_FROM_EQE);
=20
 	/* TX inline */
-	params->tx_min_inline_mode =3D mlx5e_params_calculate_tx_min_inline(mdev)=
;
+	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
=20
 	/* RSS */
 	mlx5e_build_rss_params(rss_params, params->num_channels);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index acf25cc38fa1..d3a67a9b4eba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -292,8 +292,7 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struc=
t sk_buff *skb,
 		num_bytes =3D skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
 		stats->packets +=3D skb_shinfo(skb)->gso_segs;
 	} else {
-		u8 mode =3D mlx5e_transport_inline_tx_wqe(wqe) ?
-			MLX5_INLINE_MODE_TCP_UDP : sq->min_inline_mode;
+		u8 mode =3D mlx5e_tx_wqe_inline_mode(sq, &wqe->ctrl, skb);
=20
 		opcode    =3D MLX5_OPCODE_SEND;
 		mss       =3D 0;
@@ -608,9 +607,11 @@ netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, stru=
ct sk_buff *skb,
 		num_bytes =3D skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
 		stats->packets +=3D skb_shinfo(skb)->gso_segs;
 	} else {
+		u8 mode =3D mlx5e_tx_wqe_inline_mode(sq, NULL, skb);
+
 		opcode    =3D MLX5_OPCODE_SEND;
 		mss       =3D 0;
-		ihs       =3D mlx5e_calc_min_inline(sq->min_inline_mode, skb);
+		ihs       =3D mlx5e_calc_min_inline(mode, skb);
 		num_bytes =3D max_t(unsigned int, skb->len, ETH_ZLEN);
 		stats->packets++;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/=
ethernet/mellanox/mlx5/core/vport.c
index c912d82ca64b..30f7848a6f88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -122,12 +122,13 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev=
,
 			   u8 *min_inline_mode)
 {
 	switch (MLX5_CAP_ETH(mdev, wqe_inline_mode)) {
+	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
+		if (!mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode))
+			break;
+		/* fall through */
 	case MLX5_CAP_INLINE_MODE_L2:
 		*min_inline_mode =3D MLX5_INLINE_MODE_L2;
 		break;
-	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
-		mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode);
-		break;
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		*min_inline_mode =3D MLX5_INLINE_MODE_NONE;
 		break;
--=20
2.21.0

