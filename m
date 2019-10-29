Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F305E93E3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfJ2XqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:09 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:62542
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726099AbfJ2XqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjDEEeUL4VAGxcIThURJK4LV29jpNylJnPMKXBTCQlR0mgAzFFvMEN6gkZ4SoMFbogisW/E3suqFjojeapmpaQwoZzrTJlW6XhJ9nb2SpJgUaslBUMRhnCyk5/UYlsuXWE9dmCauljAG5GqQvUX5+Kcj7gIY4klB2RDKl0sc8kMl16LMEwyBGDl5UXZmXjokZjTRiGpVp+Rn4I2/8q7Hc0J8rt23s8AnICV7LTPYcUdrSoRsdVgzS4i3l9UY3z8MIguy8qLDsSgP3GJeHTx7oWl+jyfEU8DDOTVOtflRyIblGOAzL7CQSO9E8M/Cr8jPbFAiPM03InxZwVxFglrDxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UetY25ojQvnVwkJf8lUqm5cQTgxoYHlFThb6axDfS5Q=;
 b=Gmi7zQWKyY5Koj8XX1taIVk7N28IP/mnDEiCFvY9/sjT9yuQwRuPgb64AuNrsNW+O0VbC0Q/A+mKZ4kDaFhHsPBS06P7e1SjUxKM7sPWExCwL1SlYn2Fs/RWrnlyz86h/xqt36CC3hCmTk1zPQ1/2fA5TDqmVnQhnsCMd7XlgR0w23aljXRS8DizHpAyEdJtuzmScS3p1YYobaoPHyejMMT1QCM9cc68Gr6YePektfd/i8pe3Uai6a06UrSwjcPuiFH7FkoyBYKAESzDFcUJr9Gsi+VbvGs/4g2PZw0JEC34QBYz+O0nbXErvnxlN5TcPaUW50HmJAu8fCot3mk70w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UetY25ojQvnVwkJf8lUqm5cQTgxoYHlFThb6axDfS5Q=;
 b=P5DYcUA3mFgNDei4nthy6Uuo6IeubRZF+rkHeHxpIxfW0O6N8EBRDOlPvsaNMt1AOTs3shsyaascM7mvfAx8iIj+0Aw3h7LI9f4G4psMoxXDxfpAZePw4NV+cDz2k6uH96q/4JO9QubF5/CKSGpInzOMpAG4J0NJwXuN7QgG7q8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4320.eurprd05.prod.outlook.com (52.134.31.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Tue, 29 Oct 2019 23:46:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 06/11] net/mlx5: Fix rtable reference leak
Thread-Topic: [net V2 06/11] net/mlx5: Fix rtable reference leak
Thread-Index: AQHVjrMGOcb74aAGEEqjp7FNICPqkQ==
Date:   Tue, 29 Oct 2019 23:46:03 +0000
Message-ID: <20191029234526.3145-7-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8d9da6a0-9298-4b5e-b504-08d75cca28f0
x-ms-traffictypediagnostic: VI1PR05MB4320:|VI1PR05MB4320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43202696139FB9F9EB3D4FA3BE610@VI1PR05MB4320.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(199004)(189003)(86362001)(8936002)(7736002)(305945005)(6436002)(99286004)(81166006)(50226002)(52116002)(26005)(66066001)(8676002)(4326008)(81156014)(66476007)(66556008)(102836004)(54906003)(186003)(6506007)(478600001)(386003)(76176011)(6512007)(25786009)(66446008)(64756008)(66946007)(6116002)(3846002)(486006)(476003)(36756003)(446003)(6916009)(2616005)(11346002)(316002)(14454004)(107886003)(256004)(71200400001)(71190400001)(6486002)(2906002)(1076003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4320;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rfArYfZvFoAUWUiGvTewEnsFphDI6yAqwi98bdb9nxezHqGWxrUtuB+ORQLTXyq/x/9Qp9hgluEfHbMA3lwL5gazM+qH+bFqPOZNMcY8pDYrEsaxpp4Cde7+nO6NZgKpDy1nqQbzXHjR5Doc95rtZuF2ppUoZHvVTnmyhNpeh1ny+7R7Gf3Rd0sGoFMe1z9uwsSh3h2IEP4MCQvbTvVVglyMJj4YR6aA0B3PfK2NA+4giyaxZlf9PPSKjfFHhSlHXwTqxqyBXOS0BrUGIhg1Sa78fFIUXcWtl+jhgZBJTg9drMuS2Cu/wXBPpnjeFEbxw+7nsUf6ERy3a6qvHEQQcdyoyb48Q4YUbIwcVrnFxYacF57cjfo/h3AV9p3LhWm2dvC68FsfVTPdzvx0ouE2+ukCWzZOjskY1iKtHdDZ41d+oevVqzr8pR8gWAmFajnk
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9da6a0-9298-4b5e-b504-08d75cca28f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:46:03.8455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9y2boVlUI9lGM0Znspy+owPK4Gitg9W5GWHEiUUQUbZyrBC5BTxVGrLO/WraZ6FI1UiimVEQnGj2Hkc6tT/9hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4320
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

