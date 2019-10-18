Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED54DCF64
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443342AbfJRTik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:40 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443332AbfJRTig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPy/Fh9qdGx7ZnSAssPMZ7lJ9vG7zjXNz47yHxL1GRqkzA4hJAKhz7QJYPn0OZLgrYdtA1y7yLh7YSAOpCiQLuKBoXXPOdEyutUTvteylLH4b8QYUzaf31GshKVohRWIu0XjA6OX81tChczQLmPDzoGq1+03UO3vA+Yh3WrN+xRAa7rtjf9gG7/xM0xWhSJLvkKfjLzWQfglD2D58PJVVfHUb3XvZBJId/1dlIV4EaK67zJuqKGdXIpczCqA5Jah2IjeR1K0pRoFJZbRsnWE4CMKJYkZyphAVNLfwN5AcgWHihs94Rm/A5Q+Xoduc8P2kaXZXsjLR9tyVJfMDd+VvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pd/OKpYMO8fhqdfQGfSv5UoeobWsrI61iJ75yTgJKl4=;
 b=OqasxtLYH2om+lfDL1ExyQQv9GEUSf5zkUB6jz00+9cz1mYCP0lcideBX8iVvkmQm7MIibqRwMohrQLUNBMCtiMvMlNMI/MC2aJXCDbhgBuEEm6cevDCUlQ5zlu8ChtqOm3n622l/s3DKFlICOITFdacUFucNYrT9aLaszmqe6g/ld2chNMXK2t7kOEN4X14zonAnj46tzuziLm0bs3P7lzQcvenzOiCuBmHeYbcl0D0tAf9sgoF+KTnIjwxix78CEp0221C3SzmEZCgarVHDwm7mza9vkQvl/Q+5I9j0udQZskwGaIHLQIzyNiUb9nSSM2K8R+DJJ+ONvMeT3eFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pd/OKpYMO8fhqdfQGfSv5UoeobWsrI61iJ75yTgJKl4=;
 b=KZjCmHrFVYFtgsoENV1mKthE+NkrCHBD6TVLipdJYZak/FCT5UamHycttVLdhtJOagETVoESDvcQdtdIpAGxq8KAI+f+zWXa/pPF4h82FiYutuvHHo3RGUeLItMYApiegj3/5gDkSOJtkEZIhHf1Ez9wYmQkRjKGpDHeVf2Wgis=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/15] net/mlx5e: kTLS, Save a copy of the crypto info
Thread-Topic: [net 11/15] net/mlx5e: kTLS, Save a copy of the crypto info
Thread-Index: AQHVheuawLjJi7C3EEu3RHx16T16bQ==
Date:   Fri, 18 Oct 2019 19:38:22 +0000
Message-ID: <20191018193737.13959-12-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a8ef8e6-d363-4f50-2f7c-08d75402bc8b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392719A889691D582EE5089BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: agiw4sQueqzcVEwOgJ5mCOKrPFqkmHIkXzOymBwVkafXyCyVwIUgiv7Fv1kB2AKtAzoymm5E4jlNNPG03+pFiiQE+huOErZ1gmDsB0hT9Z3DfhJv4ePnefuKO195KM31cx4xdPgbEMwNOJpRczlxJReXAFm+dVXXSrn7v2Xj9LzJsTGnX3OpKEVv7LPKhd+G1pWy3smzm+I5Xp3Z/u8wMT9yqZVBzmTHjFtOmzQjLwK3tdW5/DrItHOBn4auZZQebN9ArPf/85b324tEYxijtfxOmWyL+e8uC3GEEp513+/UVPPShQ4SYOqdBN+39HbHYvCKo2uEjuRTKqfHhPIYOY9KFbOaNmFwhd5XlqSIUGli72rpsvIns+yRyu0hOOcwGXpvQMvVwTI0YdmJtOz2yrFlDslj5axg/Gh67jj2HnFMD1glvICYBjGUqYCOIEMB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8ef8e6-d363-4f50-2f7c-08d75402bc8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:22.8169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHJ3Os51PDIPhV5nHi/BTYVWGg92gHZQ1Z5XQveUk7nJwmasYsPdh3fmRl4WR2R/plps60UKJeJaEk+Y0PCakw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Do not assume the crypto info is accessible during the
connection lifetime. Save a copy of it in the private
TX context.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h   | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    | 8 ++------
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index d2ff74d52720..46725cd743a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -38,7 +38,7 @@ static int mlx5e_ktls_add(struct net_device *netdev, stru=
ct sock *sk,
 		return -ENOMEM;
=20
 	tx_priv->expected_seq =3D start_offload_tcp_sn;
-	tx_priv->crypto_info  =3D crypto_info;
+	tx_priv->crypto_info  =3D *(struct tls12_crypto_info_aes_gcm_128 *)crypto=
_info;
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, tx_priv);
=20
 	/* tc and underlay_qpn values are not in use for tls tis */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 929966e6fbc4..a3efa29a4629 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -44,7 +44,7 @@ enum {
=20
 struct mlx5e_ktls_offload_context_tx {
 	struct tls_offload_context_tx *tx_ctx;
-	struct tls_crypto_info *crypto_info;
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
 	u32 expected_seq;
 	u32 tisn;
 	u32 key_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 1bfeb558ff78..badc6fd26a14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -24,14 +24,12 @@ enum {
 static void
 fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *pr=
iv_tx)
 {
-	struct tls_crypto_info *crypto_info =3D priv_tx->crypto_info;
-	struct tls12_crypto_info_aes_gcm_128 *info;
+	struct tls12_crypto_info_aes_gcm_128 *info =3D &priv_tx->crypto_info;
 	char *initial_rn, *gcm_iv;
 	u16 salt_sz, rec_seq_sz;
 	char *salt, *rec_seq;
 	u8 tls_version;
=20
-	info =3D (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 	EXTRACT_INFO_FIELDS;
=20
 	gcm_iv      =3D MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
@@ -233,14 +231,12 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 		      struct mlx5e_ktls_offload_context_tx *priv_tx,
 		      u64 rcd_sn)
 {
-	struct tls_crypto_info *crypto_info =3D priv_tx->crypto_info;
-	struct tls12_crypto_info_aes_gcm_128 *info;
+	struct tls12_crypto_info_aes_gcm_128 *info =3D &priv_tx->crypto_info;
 	__be64 rn_be =3D cpu_to_be64(rcd_sn);
 	bool skip_static_post;
 	u16 rec_seq_sz;
 	char *rec_seq;
=20
-	info =3D (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 	rec_seq =3D info->rec_seq;
 	rec_seq_sz =3D sizeof(info->rec_seq);
=20
--=20
2.21.0

