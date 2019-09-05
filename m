Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA28EAAE07
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfIEVu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:50:59 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:28743
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730537AbfIEVu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:50:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giarzjgRzVL80RW/3R1bKbtsklv5lJHA+HZTO2LO5NxKCKxxMvbAzFFPWAeMuHDHTvqFSRaa2XFnSklgNxQSj40uC2O0+lzhALM07HXqc1ZEHQu/Cq8IWXsmgyQJt17Xe5w4dVGiBv+lwfM4kbjr6s7Gvj/uybiokEhs1sEE0e7cWGyBqG4H2iyy9Vqki5pFD4CyYBa8Oc1+awqb/W8/crCd7J9GafkHEmk/l45iCaJoyCb5mpp5dZbI4j0/BOxVRDhkkRABqKX/h5PcHOnwhyLzSlzz3uSkJAMPqGh2tgW4nYVCntea6VNg2l5cdYAtNwa/SbvdmmUuzLhNndu3yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yss0tg/pyRpPrPRXZ3NtQtiSz3MYdDDD2xzy0D6HaCE=;
 b=EW/NGc+pJqVgLGt5xy872v8CwZmA4qU6jj1c+GAF/OMqVBZ5LkoKUG+J7gsC7H3ltgSG7qf7GotmAHPZyd1rZW7xKmamOBMELIwkDbNUr6xCMF+90HnSe+LGQBBLulB6e5st1QjBBqWcJZ/iM9UkHv2uFJc+E18m7kfTWrf3K+6XxJkdK5LXuix/My3YedM2CN/Dr+lGoMNjrvuh+Fe4MeJH+luyT8ZlCr0H501/PkfsniEsbQDlbjnTdIVxlvx4akAsfwSfXh+4cKNZKeUKSY8KcotzKqlobqt58SoM/CeFqkots7BYxqu7VPd1Sp1JqhndwTlXcnEY1L+hTKdFrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yss0tg/pyRpPrPRXZ3NtQtiSz3MYdDDD2xzy0D6HaCE=;
 b=Td4GUUyV2xjGVezvC+mOnN9gsHZuuPMB3iNNAeFPWh6lxQ/WIADqhKxO79RrLPVA/AKeWWn2wh2+I3YksnXaOPhBDNvNCgYpZGZxP4ni0u+OID7wwyE7GNQH9l9Sh1/J9kRv4EQqj9WwgxdI3liyzMa4vDyL/gMktM5GlsaO8FI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2191.eurprd05.prod.outlook.com (10.169.134.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Thu, 5 Sep 2019 21:50:54 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:50:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/14] net/mlx5e: Fix static checker warning of potential
 pointer math issue
Thread-Topic: [net-next 01/14] net/mlx5e: Fix static checker warning of
 potential pointer math issue
Thread-Index: AQHVZDP9kFWnnQVo2Ua0Z8ntYMe8Kw==
Date:   Thu, 5 Sep 2019 21:50:54 +0000
Message-ID: <20190905215034.22713-2-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8efd711-758c-44db-7d4d-08d7324b2050
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2191;
x-ms-traffictypediagnostic: VI1PR0501MB2191:|VI1PR0501MB2191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2191096CFE838F4EA5943616BEBB0@VI1PR0501MB2191.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(54906003)(316002)(2906002)(256004)(8936002)(8676002)(6486002)(305945005)(99286004)(7736002)(5660300002)(81156014)(81166006)(50226002)(1076003)(478600001)(6512007)(11346002)(26005)(25786009)(36756003)(86362001)(4326008)(14454004)(6436002)(53936002)(102836004)(486006)(6506007)(386003)(66066001)(2616005)(476003)(446003)(186003)(107886003)(71190400001)(6916009)(71200400001)(52116002)(6116002)(66446008)(64756008)(66556008)(66476007)(66946007)(3846002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2191;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CHQpF8dc399MfwCyfJJV0vRXkhiaOhJPEVziBD2Slb9gPtclqlGOGdxD9f0Ft1k52ugiRG1mjS6RHms5/S/ymUGO5lNvVo/WD6aDIIKyW6RHbWm21mU6RtLntvq3hDcXR1E2yKAPMxWsnrY6XfPJpFT1GRrtZ5rdsvo7aPjL6z7mX7gOx2mxzr3uxGlG3jARlMgElZIRmFrMVSdVrc+8bu7wON+tR6UlE3b1pBjXtCqbi3BjAE4ZE0mh+n36IOTR8pUIJhDrdd+alltLugyXZpPWxDTpPvEOEb53Ja02sLt4q7HOzyvHyFEBPyAAs3DicNuHIEfqe6fZRud+1EzaFbDM0WeMIKv8nQ4y/dSXLIPFR2KdrCpDnGsUvzGkmSOU0CUgojNJMPQv8s9HPQRFt3byvjnCz18EdXDCkk+GuZo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8efd711-758c-44db-7d4d-08d7324b2050
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:50:54.4205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VKPFUazTXPPo2NBYtl0m+DASLm/2XYsTEiovih0EIvIoE4fCs8XA6pq8nv33uPl2uCDFt3hYlMmFlPk3s7ljlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Cited patch have an issue in WARN_ON_ONCE check, with wrong address ranges
are compared. Fix that by changing pointer types from u64* to void*. This
will also make code simpler to read.

In addition mlx5e_hv_vhca_fill_ring_stats can get void pointer, so remove
the unnecessary casting when calling it.

Found by static checker:
drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c:41 mlx5e_hv_vhca=
_fill_stats()
warn: potential pointer math issue ('buf' is a u64 pointer)

Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c   | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index c37b4acd9bd5..b3a249b2a482 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -30,22 +30,21 @@ mlx5e_hv_vhca_fill_ring_stats(struct mlx5e_priv *priv, =
int ch,
 	}
 }
=20
-static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, u64 *data,
+static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, void *data,
 				     int buf_len)
 {
 	int ch, i =3D 0;
=20
 	for (ch =3D 0; ch < priv->max_nch; ch++) {
-		u64 *buf =3D data + i;
+		void *buf =3D data + i;
=20
 		if (WARN_ON_ONCE(buf +
 				 sizeof(struct mlx5e_hv_vhca_per_ring_stats) >
 				 data + buf_len))
 			return;
=20
-		mlx5e_hv_vhca_fill_ring_stats(priv, ch,
-					      (struct mlx5e_hv_vhca_per_ring_stats *)buf);
-		i +=3D sizeof(struct mlx5e_hv_vhca_per_ring_stats) / sizeof(u64);
+		mlx5e_hv_vhca_fill_ring_stats(priv, ch, buf);
+		i +=3D sizeof(struct mlx5e_hv_vhca_per_ring_stats);
 	}
 }
=20
--=20
2.21.0

