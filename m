Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D411487D
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfLEVMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:20 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729489AbfLEVMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eV2XFL8jz0JeZPfEVasJTPrr8O1hQFS3Becy9cFT8I/a+v20xa2OBGWvBoCV+juKY5Fc/KsE8J5T8gmq7X/pyNpiLkyGrtDPFYODyah3AdPmxV4FwUSQlR6tjlvVl1TygYkB9KlDl5r18GNTJgKx71kJQ5m2AZADpCDM8sfF2jpkk3a8Td+DsolaJS6/lWmkqFBGhscpXvcubxfugAVTJEg+hsfNYbRaBRl/sYh27+AwRNrkKU0Fq2NkbiaIvIRYcfCsI58RPMHozmaRpogrZ8+VgfcSQD3vSsPX5+402jFhoVJNe35KMRj3UpLuZGKcJlak8FrTTLYubt8ZRRxdkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNNbcUQJiOMiYvWsqCnk7xN2i8yPOrWjy7qFY0ASGK4=;
 b=JdwpGzDRiclv7zMYd6956oJ881RpBHJsQI0luhAt8OcLar422+UowPe110ghjOviml9aj04g2USExy28BbeqTNZTdmoC4NHI/9ZK9i/xv9U3CmY6i7OGqkfDZA4FJrgiY/kr/eXbArfrUqOTeA8Uannj/JrDxX4ZZh6y0JPMJEe0u/LPvMqdM4nlnCECriHsGgc28XW3gmdt6a91rTChDpowiF7Opnt3b6kzghllbhLtj7r0XgR7R3vMc2GVBDxPN76toAtbcaWLevR0dzd9ZMn6xE4PikxzfkRs69o9oYPL1CvRFxVISvY/aVA46uNoq95Jws1qFUTvMPlZgZzQaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNNbcUQJiOMiYvWsqCnk7xN2i8yPOrWjy7qFY0ASGK4=;
 b=G313Q3KQWLfunASNOL8khbde5K5AIqjtZZX9ck337nBdEvuO5cA7MWnkMjJPfoHcIBiusBbdHlUE93Yin+TjveWRm9Vs/rWyrkknJ0kU9TlBd82HJsiVxVSeN/ozZq2APGyg+X6bs2vbgUsca9BKdrEeFwQgBBMtuNPdQKf4Vrc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/8] net/mlx5e: Query global pause state before setting
 prio2buffer
Thread-Topic: [net 2/8] net/mlx5e: Query global pause state before setting
 prio2buffer
Thread-Index: AQHVq7CmhOjaRyPcrUSwhV8ArqiZFA==
Date:   Thu, 5 Dec 2019 21:12:07 +0000
Message-ID: <20191205211052.14584-3-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ef701d2-e076-42d4-f6a6-08d779c7c928
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB33267D6A6E6B737B9D6DC29BBE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(14444005)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MUaLK/Tl5oGPqtFoFEC863IsR8EDRpT4qi1TBzCJ881bkkteRL03DBkFts1mCkiqOC+spF+EOfqJOdRqJZ/I5+PU04Kd35nffsMQBvKqdkiPbR1yJwhMFPwFAa6kM4qZiOJCtItuTFBlVyhEvNbNe6vtKOdvfLX0nyF7hfkl0bAFsY1PmtCHgIsLDPZO4hMilxdKb7W2Tu5Kqqy/0XwJ6Rmf0vMrZKP7ks4g1u/wn3N14VpP3OZRqZvRinnaXVX06ufRVzOgWG04wc+aPL1W/MMryfvP69e0gB2x/IcaIHCDQcx50V++XfnDwp6aTdKWrFdFJpMdNWz/BOfPxHW/1YTSMugF7HydsJWRRtXRYHsKHMFnwIRr2wQPvRPmiU+/X2V3XtTjGpB6S6bLZ1sN/RtvzCSqqP24vqgzYLQIKBJwRrSQbwC8UnVVD5HwWUPg
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ef701d2-e076-42d4-f6a6-08d779c7c928
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:07.8511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5tXhl9A34bGtxhCz1w/yKqx5K1RdYLJDNVKk93y0/owo/d3sradRu5+zw8p48jgpjpXakK7f1wZygHShIGgeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

When the user changes prio2buffer mapping while global pause is
enabled, mlx5 driver incorrectly sets all active buffers
(buffer that has at least one priority mapped) to lossy.

Solution:
If global pause is enabled, set all the active buffers to lossless
in prio2buffer command.
Also, add error message when buffer size is not enough to meet
xoff threshold.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/port_buffer.c       | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 7b672ada63a3..ae99fac08b53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -155,8 +155,11 @@ static int update_xoff_threshold(struct mlx5e_port_buf=
fer *port_buffer,
 		}
=20
 		if (port_buffer->buffer[i].size <
-		    (xoff + max_mtu + (1 << MLX5E_BUFFER_CELL_SHIFT)))
+		    (xoff + max_mtu + (1 << MLX5E_BUFFER_CELL_SHIFT))) {
+			pr_err("buffer_size[%d]=3D%d is not enough for lossless buffer\n",
+			       i, port_buffer->buffer[i].size);
 			return -ENOMEM;
+		}
=20
 		port_buffer->buffer[i].xoff =3D port_buffer->buffer[i].size - xoff;
 		port_buffer->buffer[i].xon  =3D
@@ -232,6 +235,26 @@ static int update_buffer_lossy(unsigned int max_mtu,
 	return 0;
 }
=20
+static int fill_pfc_en(struct mlx5_core_dev *mdev, u8 *pfc_en)
+{
+	u32 g_rx_pause, g_tx_pause;
+	int err;
+
+	err =3D mlx5_query_port_pause(mdev, &g_rx_pause, &g_tx_pause);
+	if (err)
+		return err;
+
+	/* If global pause enabled, set all active buffers to lossless.
+	 * Otherwise, check PFC setting.
+	 */
+	if (g_rx_pause || g_tx_pause)
+		*pfc_en =3D 0xff;
+	else
+		err =3D mlx5_query_port_pfc(mdev, pfc_en, NULL);
+
+	return err;
+}
+
 #define MINIMUM_MAX_MTU 9216
 int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 				    u32 change, unsigned int mtu,
@@ -277,7 +300,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *=
priv,
=20
 	if (change & MLX5E_PORT_BUFFER_PRIO2BUFFER) {
 		update_prio2buffer =3D true;
-		err =3D mlx5_query_port_pfc(priv->mdev, &curr_pfc_en, NULL);
+		err =3D fill_pfc_en(priv->mdev, &curr_pfc_en);
 		if (err)
 			return err;
=20
--=20
2.21.0

