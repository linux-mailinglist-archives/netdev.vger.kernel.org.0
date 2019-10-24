Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73494E3C1B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437002AbfJXTi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:59 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436879AbfJXTi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPBHOAIVb8Jj0CKQlTyrN6jr4i4lQlWL4LwTqrrhJUaU1HkOKqreXqFKkKczZIX/pNR5Dy158yWIwRGPl/xuCf9P2HK774g+4VXloa/oGvXGD+t7gWMEccH4gQu856hmdzteY1JzJj0lEKnsBMVAfSOOhVC0rVHGgTIRAKaMOe2b01CgF3Tg6Oij8q9raiXA6dP5cGPZZFCYNOWwCHBgdDAtcfz/1VBq8hUe/kAbd0ACkz5lt44RgqRlLXvlk9p7hWUTSGxQYcP73D2bpBECci6CVZG/pLddx0VVcR5jQsqWGm+1+BXCjkhBU7A9o5/H5OeI7xViQ/DzDguIYjargQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UetY25ojQvnVwkJf8lUqm5cQTgxoYHlFThb6axDfS5Q=;
 b=mcKN/eg9dZkhOizzFt9L9rFItSOzG3a5O1Az3NzB0UPOfIqDHvJSVaekNft+3v8YpuLXGDKRD/Bc7qEjdgHBqNaqkzRVz07FHlXYwKOlD88z1Mc8DzMmgLnky/dii6zSM4MrX0j8XfWuLEMDk8MbgaSISbv26qcWvi3nC1ic6Wfxr/0GYfykLNq+eOLur/FiJiYx7qolocVPQR7VTW0P3tB9hko+E122DbvLB4JtMu1+w9scblnG2YDm7VPceWHVk1loxlzXYTibtcChi3sl0uvVG8aK8HRKnJMIMxpo3GwE5pfocK8A1k/jguh+UYd6f2cMEIvkT9PoYR6CPC0ipA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UetY25ojQvnVwkJf8lUqm5cQTgxoYHlFThb6axDfS5Q=;
 b=Uxr4QyvsEQaEskFqyOO3ak3MYVw8VGbNtixwCj2cgMdFE6GhQMiOezHxW8C1f8Iuqbf2HtjLcvhdCmSd5zM1FsIA3Ul8EGZ2lwB4vn9xgnQQ3HMBtwuTQdPuNGaDI2zYJANro6q98urFT7sFu0pLxtveZ0u6QgJkcaS0au22+3w=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/11] net/mlx5: Fix rtable reference leak
Thread-Topic: [net 06/11] net/mlx5: Fix rtable reference leak
Thread-Index: AQHViqKqSUdhZKA0o0eKt1x1D6efkA==
Date:   Thu, 24 Oct 2019 19:38:52 +0000
Message-ID: <20191024193819.10389-7-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f7fc769-acb5-4050-7fdb-08d758b9cd00
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4623CDCD2994C22E3C7DA1EEBE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ol3Fb9pfQjE/c//aNSv0imoS8QwuD9/8NadjxQ+M3y5J6JMi6p3XG/e0SgR9s0zCoHYdMKNED/NqlPLlZTKRC3jnnWD/9TmqmdW1S8T6s5IeVQYIC3CW3bVrQKnNfnKraRrMnKNcEhiXM/nKEUlTAd304FcKYY2hzq0bn/zmeeNd5yK6FUROsdCBpqRWjB6kkklD9MZNvDSrmXxtncAOM3BCqQRzT05PUKlgSJoTDpEid9yQVcHVdJ23GORctxZ50/H/2XHrHRvVqI8VB4uQ5PdfkgxpyHVWcX7KGIIqCArp4jaekyGoYrKlME5CfRT8LZe2SVeKM0qvO9nMnPm4rCixeTob1YIA3SY4UlE5PVvH03oumAIpiZH+FYo29oVI5mtpq4sgElsZWkKvfw0Rdkt+CMOBnuO0NVT2/jmQhs/3QUmLPvLc35H3iMROxiI/
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7fc769-acb5-4050-7fdb-08d758b9cd00
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:52.9739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ox5mfJQcOAKMtV8OXG85gdSTI+cJyetSOhEvrJgpBEeUAXVbIspuT6byvr+bPeXougWs0/+QUijF7IHN+0zY3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

If the rt entry gateway family is not AF_INET for multipath device,
rtable reference is leaked.
Hence, fix it by releasing the reference.

Fixes: 5fb091e8130b ("net/mlx5e: Use hint to resolve route when in HW multi=
path mode")
Fixes: e32ee6c78efa ("net/mlx5e: Support tunnel encap over tagged Ethernet"=
)
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index f8ee18b4da6f..13af72556987 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -97,15 +97,19 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *p=
riv,
 	if (ret)
 		return ret;
=20
-	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family !=3D AF_INET)
+	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family !=3D AF_INET) {
+		ip_rt_put(rt);
 		return -ENETUNREACH;
+	}
 #else
 	return -EOPNOTSUPP;
 #endif
=20
 	ret =3D get_route_and_out_devs(priv, rt->dst.dev, route_dev, out_dev);
-	if (ret < 0)
+	if (ret < 0) {
+		ip_rt_put(rt);
 		return ret;
+	}
=20
 	if (!(*out_ttl))
 		*out_ttl =3D ip4_dst_hoplimit(&rt->dst);
@@ -149,8 +153,10 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *=
priv,
 		*out_ttl =3D ip6_dst_hoplimit(dst);
=20
 	ret =3D get_route_and_out_devs(priv, dst->dev, route_dev, out_dev);
-	if (ret < 0)
+	if (ret < 0) {
+		dst_release(dst);
 		return ret;
+	}
 #else
 	return -EOPNOTSUPP;
 #endif
--=20
2.21.0

