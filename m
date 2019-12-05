Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE73511487E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfLEVMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:22 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729489AbfLEVMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVq28l1RNKvLmzXmZxg5kaqEfnyJZXzn1NdnigOA9cJvudz5LaPNYJ/cA+o3vsATLYttIDSl2NajlVYJQ4FQzRrn+y9NAl7rVohXDDfpyxQ0bRjk2Fwr4dtFNj9RN6oaGpD6BCeoK6T3UA5c7gHRpjLjn61soJq8I8y593YwZqiKOz+itgt6lrs5j4NzSKgYtp3LdfbnnHSzMCjD1j8CwTxAP+BAQfkCOw7h7YbJlWkSg5v2wPCA7FzNYyUhESiH5EpIgeOYS9BZpNjdrs4il/mpqlbSNTFkotggq9H9i8G39LpccOqfRbB/HJKkP7u6TakoySFp12nKyAWkTW/NkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10ycwM1axsbZjhgMm15THk4j9GvJMZJe/pGvuPNrAYw=;
 b=jSOZHGRZbQ9oGXneHIDhSFUY4dweX7doEiu4eKkbsLoRZaM4ac/DEWHp6HVqSPrRLWDQlkbD+eTdWvKJuXG5TaUJsfk8XHTPwCAO5Ubu9DxylSPSpYGL/HX1n1V8Af6tDZ+sTy/JK/cdh62Uu8Fi4zqILEAA1oieN5pGdfvGi373G2p2ckjS60KUjirOtHp4+XNb2yBuQwKVe+IoClAT0qrUM/Qz+V2iYr9uvYU7Hk9IqnJKQvYvp61YL+bfcN08zFAmh5uAQ1CRQkCTVzg5xny2HOo1aROeJU46CTLnQcB4h/rGccUYTA++OPhux9PTxbtU12TOhZMrAmN6gLc9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10ycwM1axsbZjhgMm15THk4j9GvJMZJe/pGvuPNrAYw=;
 b=j0k/FRq85k4ptulB+reMgUomNZS676DZVbQBpmzvRo2Xf6WEf0UwWSzwGkOMHDsHOcuf0PehvGTVDPdFa8RCYQdjJ80lHcALwZqHk0pA/k1xfIrj+6hZnmcl8uydMyIzmegxsp+uw1cnsMqvFIB8In0Q4/WuoDw2X6G70q9DcyE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/8] net/mlx5e: Fix SFF 8472 eeprom length
Thread-Topic: [net 3/8] net/mlx5e: Fix SFF 8472 eeprom length
Thread-Index: AQHVq7Co+HBl2pzvOkyG28GY/xZeTg==
Date:   Thu, 5 Dec 2019 21:12:09 +0000
Message-ID: <20191205211052.14584-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1a04af9a-7f16-4831-e421-08d779c7ca3f
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3326299741F15964E5864C08BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(14444005)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PwiznigQ0eEEyAhRGtbPKg+2TbPntD1h4fUUauczq7yA60QmM/pQ7/pdMMEDehtEDq6koYkmTkuK4sEHADh1IFVjxHbCT0lObT+HJ3cm2SNlPW1SiuOgBtnb8uon0HOSH9cI+1s2GryVuf1Zc57G0s7oRxcqlytnjl+oVnrKGqKUrbesT1nQhjzzy43jbyJDK2KMzWnoc0QlZY1i3ImbnFImoLTU12fi6o+VzVWGwvxuGW6riYm35zm0oyG2Jy79lQrKYn11ethvyzaPOAlsl4+ld1JYmfVfO+ZulEyeQDugmYWW2juNMmyUVApj5WTxcQldkvYOSikwuKphtGFDGxWDdMwPRuzLb1ulLBbtZyPz5Cs4omgMGEXxModSxdC3S5wiHKAH8BAnDFVVLfEFxMUH+O82S3eYT2FQh4CTjtnUFML/lmWeBkoVWjTXZhvZ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a04af9a-7f16-4831-e421-08d779c7ca3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:09.9269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vdch5GN0csU9t3bthfrZEtVuQL6Z5KwYpRau5cVHAjkcOianUTbCnL/z9WGnRTUkiETIJkcWEAizuigMAQ/rhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

SFF 8472 eeprom length is 512 bytes. Fix module info return value to
support 512 bytes read.

Fixes: ace329f4ab3b ("net/mlx5e: ethtool, Remove unsupported SFP EEPROM hig=
h pages query")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 95601269fa2e..d5d80be1a6c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1643,7 +1643,7 @@ static int mlx5e_get_module_info(struct net_device *n=
etdev,
 		break;
 	case MLX5_MODULE_ID_SFP:
 		modinfo->type       =3D ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len =3D MLX5_EEPROM_PAGE_LENGTH;
+		modinfo->eeprom_len =3D ETH_MODULE_SFF_8472_LEN;
 		break;
 	default:
 		netdev_err(priv->netdev, "%s: cable type not recognized:0x%x\n",
--=20
2.21.0

