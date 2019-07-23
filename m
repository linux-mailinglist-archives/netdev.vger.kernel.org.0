Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B466717AB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbfGWMCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 08:02:32 -0400
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:27267
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728418AbfGWMCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 08:02:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xfvq0mCOEUqwqftOZgRF1s0431/5JlYpIcUVcDAexj9S5MrxKdOQYW0sN8KdMQbLKbdatnE/hUf4W71/IvgSZjT5ER6zbm9tjElL+gm88S7xmqSBHPLoQpggE1DMlFmTrMaq42Ps+i7BKcV0ADM+a4baDV3T4G7BmIEe/MrwUjh80B9bd//E75RyeNdTF7qi+RVsnPhMeQdSyM+SKDnPpVmgXI/xMLEoktYqreLZwditmZjifEBVXDpZdX0H3NGqlSpGw/cqe2yB8ItkU2OOkd/udz0s1fe2SAEoV2mT5Yn4aNPBaE6LWXlh9LaZEpVhdZB1gw2QFYiIdQjbini23A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98TbHuTdr663klLOJL9dnsNLjswGlS+TifwZrDUAc78=;
 b=RPvDXBBsMRg8Sgh9CAbCSBiShKWo9aG7Ht59Od/5EHvukZcgn2CsMYJ1OM0KZM0/JRFiPzmgrxj7/85ak6dznemB2sAlOdzRSMaZfhDi2Xfg3nyonCzSQUn0mNs7l0uLleGiRI8l1a/7t8wkvhAK7+UNce9rvwRDevKGCJcNDckZilhBC46Qc/1zaeuVhi6k0yyliiuL/ctoa1QvP3QpxQrQpFtBetUk/Czxd1TASuhA5nTGQgWHpcj8J8gUUdUAuf8GyvUYZFb/ZbRtaQbEALwTbEzJsFP33xP1FhZe1di4aUZOAF1VuidyQmUisCCCtYsjwmEHRiFuGpNhQBDzpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98TbHuTdr663klLOJL9dnsNLjswGlS+TifwZrDUAc78=;
 b=NVJ7kVztBYs4dKMxzLkicZlEZsFAGzhhjBlilT4i16ppMbLOfUAyuTBGLNzXcpxY9xU8hWwwehSwXPlJFYHN6D9VHot2p+akpXUTQQiJxVKmVJH0fbpnNS8erQITlFmpSU9FZn4DCDCJ41PHSI7HQAZvePpGeAyj8xc48NJWiM4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5093.eurprd05.prod.outlook.com (20.177.36.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Tue, 23 Jul 2019 12:02:27 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 12:02:26 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next v2] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Thread-Topic: [PATCH net-next v2] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Thread-Index: AQHVQU5+6tqHEGq4/EK+pU6XK/84gA==
Date:   Tue, 23 Jul 2019 12:02:26 +0000
Message-ID: <20190723120208.27423-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0382.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::34) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7eed7b82-6e82-4358-c82c-08d70f65a0b9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5093;
x-ms-traffictypediagnostic: AM6PR05MB5093:
x-microsoft-antispam-prvs: <AM6PR05MB5093F0B7A679822D40D41E0ED1C70@AM6PR05MB5093.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(189003)(199004)(53936002)(99286004)(110136005)(4326008)(305945005)(7736002)(316002)(66946007)(107886003)(66476007)(6436002)(66556008)(54906003)(66446008)(64756008)(6486002)(8676002)(5660300002)(6512007)(7416002)(486006)(256004)(81166006)(81156014)(1076003)(6506007)(86362001)(52116002)(386003)(71200400001)(68736007)(36756003)(8936002)(102836004)(50226002)(66066001)(26005)(186003)(14454004)(2616005)(14444005)(478600001)(25786009)(2906002)(476003)(3846002)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5093;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MnQ1Tg4vKQTlluFf5szmhlDyt+Jo4SWiid0EaAAixk+ypxLiqptfxWDg7np8mcBINZxmxgBoixyySkq0qZ1z5zDPzXUu32rJXmxiLAPvFg+mn2FWQOBHgqPA2dfYBt3O4CA2j9lotlFgDwd/d6zZRDzJYOV7DvKlCxBtLHS1FQAopY6PBppvhMb0byuSFWGza0NFZMIIG8pGWcSrvxP1ViCQ64435cwiDouaiCNljQdygxMGXF5uULWod8Sdm0cjvGUB6Jb4KyaR+aLsLiq4/xKauVh5MWEovC/V0m7jIUNRxmsanSBXLyijMCs18VlRHpw7PtiDicfR1yAVi477sgtDINjsreccG/EjoqyeE9TKjh25APKhEp9Y5kXu7pUzI7I9Wa/ri2n6S+tpmYpNVm3Z9l9NPBbazNH8z5Us1g8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eed7b82-6e82-4358-c82c-08d70f65a0b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 12:02:26.0717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The structure is too large to put on the stack, resulting in a
warning on 32-bit ARM:

drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:59:5: error: stack f=
rame size of 1344 bytes in function
      'mlx5e_open_xsk' [-Werror,-Wframe-larger-than=3D]

Use kvzalloc() instead.

Fixes: a038e9794541 ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
v2 changes: use kvzalloc/kvfree and fix a memory leak.

 .../mellanox/mlx5/core/en/xsk/setup.c         | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index aaffa6f68dc0..f701e4f3c076 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -60,24 +60,28 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5=
e_params *params,
 		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
 		   struct mlx5e_channel *c)
 {
-	struct mlx5e_channel_param cparam =3D {};
+	struct mlx5e_channel_param *cparam;
 	struct dim_cq_moder icocq_moder =3D {};
 	int err;
=20
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
 		return -EINVAL;
=20
-	mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
+	cparam =3D kvzalloc(sizeof(*cparam), GFP_KERNEL);
+	if (!cparam)
+		return -ENOMEM;
=20
-	err =3D mlx5e_open_cq(c, params->rx_cq_moderation, &cparam.rx_cq, &c->xsk=
rq.cq);
+	mlx5e_build_xsk_cparam(priv, params, xsk, cparam);
+
+	err =3D mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rx_cq, &c->xs=
krq.cq);
 	if (unlikely(err))
-		return err;
+		goto err_free_cparam;
=20
-	err =3D mlx5e_open_rq(c, params, &cparam.rq, xsk, umem, &c->xskrq);
+	err =3D mlx5e_open_rq(c, params, &cparam->rq, xsk, umem, &c->xskrq);
 	if (unlikely(err))
 		goto err_close_rx_cq;
=20
-	err =3D mlx5e_open_cq(c, params->tx_cq_moderation, &cparam.tx_cq, &c->xsk=
sq.cq);
+	err =3D mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->tx_cq, &c->xs=
ksq.cq);
 	if (unlikely(err))
 		goto err_close_rq;
=20
@@ -87,21 +91,23 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5=
e_params *params,
 	 * is disabled and then reenabled, but the SQ continues receiving CQEs
 	 * from the old UMEM.
 	 */
-	err =3D mlx5e_open_xdpsq(c, params, &cparam.xdp_sq, umem, &c->xsksq, true=
);
+	err =3D mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, umem, &c->xsksq, tru=
e);
 	if (unlikely(err))
 		goto err_close_tx_cq;
=20
-	err =3D mlx5e_open_cq(c, icocq_moder, &cparam.icosq_cq, &c->xskicosq.cq);
+	err =3D mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->xskicosq.cq)=
;
 	if (unlikely(err))
 		goto err_close_sq;
=20
 	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
 	 * triggered and NAPI to be called on the correct CPU.
 	 */
-	err =3D mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
+	err =3D mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
 	if (unlikely(err))
 		goto err_close_icocq;
=20
+	kvfree(cparam);
+
 	spin_lock_init(&c->xskicosq_lock);
=20
 	set_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
@@ -123,6 +129,9 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5=
e_params *params,
 err_close_rx_cq:
 	mlx5e_close_cq(&c->xskrq.cq);
=20
+err_free_cparam:
+	kvfree(cparam);
+
 	return err;
 }
=20
--=20
2.19.1

