Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900E8148F45
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404341AbgAXUVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:17 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404330AbgAXUVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emESvtiUNZjD0BgTJc2EJ0Rl35jnQqLznP2h4rKhuUJ69ZVI8kLAeFYmtQnwlltejdZt2re6LHMVwzTafNXT63owdjPgKWSKdOlV/3PCpRTEDqk5DM3UMvK3fc0vc6cfyVYGIuNyz+c2RenX2vqbHL5AD/wXyN1GRhkSe+V5Qz1BGGNDUShDDuTYMcwY/BO9wP5qOI6h6GVfPwg2TmQndZuy5JMOjUE3vh89LvyfhtQtaBAx5V+VTrUSVqCgRk31G5L/Es7XNmrgrFW3D6qyl09VPJurfxvPJIofDGmu/64lpp9Vt8AjVbNQXTG56Oy4bwtrEtAoXIQ6hpe66T1/WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA3jxU0/gvbJpro03YrCXeipo8wrKoGe82sMmmTHwL0=;
 b=i8/c0ewZiETsTAu3+reVtev0p+FH/ZEEZUn2DAGbzxW8UVe/6FHW5S4aUd1ACMvMSpruT0MyYYZC+LkoWdCeHaxxQC2qX5FZQs3uxtSC78dmW/VjHy4T36pHlrwwaEQA3jaiuqNFItODn6mdYTana7H7lpN+MM3gizXegb2Fg/S1YFeDlS8YiTqt2LA+y3ka5lCoSraSBW96wT47TsNTSxTsWcCjRwQtd6HW3HiLnrzoKsae0q3P5zMs6LElyk/6xNrsyCg25449SBWCwQL5qyevEG2xXaGK3ROVtFLr9QXzygQ1IJ6Se86QSlzZFXrwV7zXCCSj1ztuHM0anumyUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA3jxU0/gvbJpro03YrCXeipo8wrKoGe82sMmmTHwL0=;
 b=UGC1ylqyq7VDptdZ4ptxM0iapcEIOnnYA201Zj72bvmtXAA1u1Vj0VHHgeEjvmoGdLS7mLOUJJoGiAIpyKpJdx9g2WTUjeIbdBHca+Z8EmDHEyEgbYfmOLEBOZ9NgWp+ptpBLqNZsT3qQ19oCg/mDL0zLl9uuljGH4IWEraORGU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:21:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:21:05 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:21:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 9/9] net/mlx5e: kTLS, Do not send decrypted-marked SKBs via
 non-accel path
Thread-Topic: [net 9/9] net/mlx5e: kTLS, Do not send decrypted-marked SKBs via
 non-accel path
Thread-Index: AQHV0vPObEutzfLLC0+/V/8q8b7dow==
Date:   Fri, 24 Jan 2020 20:21:05 +0000
Message-ID: <20200124202033.13421-10-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7714b7e-2d39-4b6e-33a9-08d7a10af091
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5552D1C5CFCCC63D7AC5C6FCBE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WbMlcZc/Ed9a/Y46cqqL2DBFamat6sXSJZob+qIe5vhOWSgkBcwjKuX9zj9lQJx9SAGxGE2AW/tAM9vPOd+KL7c3AswsMBuiee67xjyQ2LXlqchuGsELJiyt/jODZgXizeU+jdq+ft+OxhGbxDz7hRufGj8b7pQjLZovOk7eb855tSyoZE4LxbJd1ndXM+Ky3Pd2RVYCO5oxWvX48kzpWkDwVnc+UzoC2imcIJtacT04UxiCH/U5NPIt6Yib3RwJHvx30+btssGjgn+3W+/XZIlMT4qWoS2mgqUq72IvNOw6Zx67hT5hyrzNDqPXmxrB2m87j/4YRmqlrlsj14ujbm1++JhptYV7G1iT0/5vLa5jN53xr0/qPb1AovIZiCcc8jxGSalfbKwwc9ZizryoH7e/ZD/uRegt4fFiSHYcuCm+aNtNzUwlotqFVQ24cQvA8mywtZSpj5HNjW9rJXeyxCF1iBcc8UEHBx5nUgTCU2M6mVDAHLCugd1z8mB+LfdIo0w/XmJYw1zrG/SO5B03iI5MCl+jkuWr66E8Yc9OvF8=
x-ms-exchange-antispam-messagedata: HGFuLRsyOb3dD0IqnqerbEoS95PgvTnJHSdWbc6GDP6Uu37IoQhmNPgtLqVBm8VsN0AwpXvnJqzNGKuEWT72pZamVb3hKb2ukYGI0vKxtvXJoC+PCI8LLx8VDAvfxqMH4OEqNeMCE326c6dsErc2sg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7714b7e-2d39-4b6e-33a9-08d7a10af091
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:21:05.5886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fq0OFmyQskmfQ8NrO6q2F1lUSzj9jiXvXgcqHikQdPS1IhhVf9NEzYFwdiIzwMy/jgOGO4drJpFVuE8X8VXsww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

When TCP out-of-order is identified (unexpected tcp seq mismatch), driver
analyzes the packet and decides what handling should it get:
1. go to accelerated path (to be encrypted in HW),
2. go to regular xmit path (send w/o encryption),
3. drop.

Packets marked with skb->decrypted by the TLS stack in the TX flow skips
SW encryption, and rely on the HW offload.
Verify that such packets are never sent un-encrypted on the wire.
Add a WARN to catch such bugs, and prefer dropping the packet in these case=
s.

Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 592e921aa167..f260dd96873b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -458,12 +458,18 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_d=
evice *netdev,
 		enum mlx5e_ktls_sync_retval ret =3D
 			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
=20
-		if (likely(ret =3D=3D MLX5E_KTLS_SYNC_DONE))
+		switch (ret) {
+		case MLX5E_KTLS_SYNC_DONE:
 			*wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
-		else if (ret =3D=3D MLX5E_KTLS_SYNC_FAIL)
+			break;
+		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
+			if (likely(!skb->decrypted))
+				goto out;
+			WARN_ON_ONCE(1);
+			/* fall-through */
+		default: /* MLX5E_KTLS_SYNC_FAIL */
 			goto err_out;
-		else /* ret =3D=3D MLX5E_KTLS_SYNC_SKIP_NO_DATA */
-			goto out;
+		}
 	}
=20
 	priv_tx->expected_seq =3D seq + datalen;
--=20
2.24.1

