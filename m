Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8219DCF69
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505996AbfJRTjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:39:17 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:26853
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2505986AbfJRTjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:39:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYCF0lJmrzRzdxHETvdak2rsXJnfxtbM07gZWfkoKVb1D7Bn8/x8871Gzz8ZAySbtx9A01PoFIn3mXYrhiVOCgp2/TOK05QpJ7+MZE/c2oxPdgQ1lF8Q/dtlMzDYGagLoimaan1uRd4L40ZGIWmM3r5XrUQoFIAjOga2ZjyjPuHitVniFtuTlAkYgygCCPXdhl+OSkm71iLQV58bhBD+mkUUSn6F1i8vp5Kr3bQgn89FBpAseRA3QwnWI30HytL0a7BVGB1nXet0Ms9YWXEzyriJBFBFeOn7fPd/JhASiR+e1s6HGbYsF9euN60a7DQLMj8guPfUoC/qAybs61IJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n73UihDE0fUBwRUwafUNLnBj0qdjQOGS68dWFFgh/gM=;
 b=IPnyGzBbAHKIe0+Y+Njc1RHx4VXJYEUtbSIMHgA8v3Dt9TZKdKCWnyguHrV5O4rAe2aSQzewXQmD9JRmw8bLRbsFCUkDt5OcqKSsQ6C0Q/G7av6QNA0Gbx3zq26nhjiyQKOjpe5PCf6KQl+Zl8IOjaQCCg53KYSd6WFfe+gSArK2K7JY9rVOS7zn1OxOfRD29+eiROkzCgXnm/5LT36a/+fCSozGBv6SBMfrm0HWbNibl087/0RWADzUnIytCq3jwRA4/m+BTdWit549DkwqmH1s3s7Uqy5pn0M+wAroQYX3joLLTxRP/f99XsRKV8AR506KXLRZm8uSl1KI8ET/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n73UihDE0fUBwRUwafUNLnBj0qdjQOGS68dWFFgh/gM=;
 b=XlpVuT9l8zbvTO3s0QJMOdZY9Wg2+q7eCdKF/M19tRltF1/M6yQc5UI9fwZcWSv9+NOK6tZbPWXzrbW0sYXEsN28J/00/qZzg6ptOWHHgqbixlVcHC0hBYcSffK6UunRFdRVvoOzQ+pS9ybP0UE6XX3YATPVR1TPiLSWZhaAfG4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 14/15] net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
Thread-Topic: [net 14/15] net/mlx5: prevent memory leak in
 mlx5_fpga_conn_create_cq
Thread-Index: AQHVheudloKzecJ9o0SrUAVhxUGFfA==
Date:   Fri, 18 Oct 2019 19:38:28 +0000
Message-ID: <20191018193737.13959-15-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5a67b0fe-7ac6-40fc-9594-08d75402bf98
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB039246F7F49D974EFF80118FBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(4744005)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aHRix9+bH86qBfjSU14KgDhTgToC4N/CujJaU7a0ZKoFd3KJ+Z72T5poVNg07OYAHpJgrhJFPPhnOoQeuVFdbIBR3nw1d10gawulqXNMJc34fR3U9WILDT7W5S7eHkBhwexaIk5jxrgpwThIegAHcFTVULJMPPyV4kKmTFNdwaRbwo2hF6zyNtwPQSrXPgxXjyz19P9G3SRNtb2cKg3QnoslC+HIFc/wB8bsbXqqburGiAOXV6qaKcOFPzcCho+QXHAK/5n4KGhLM1O9XEFZhJFkP9v7V1Pz6QkBM63fEnKEreHN2Gdw+HfjcR2P6EhIT0FDzKLkuep39mDGSdNEvf78B+w7ceEKQPxZjaHb0JObwUvC7+OoKRzSwUax2sycV3rL2wl1/F9F682DADVtO5+ZM/ef/fZoVK0wrzVBMHkcQ/Fy7go+wXNnpoJUJV4s
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a67b0fe-7ac6-40fc-9594-08d75402bf98
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:28.1158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0Wt0yjdubwHji0CXYij1P2nEY1g0QgcPs3A8E+1EveMrRotQl2Iv9def2GihiqX0yUViiI51Ms/b9LK0+RBqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

In mlx5_fpga_conn_create_cq if mlx5_vector2eqn fails the allocated
memory should be released.

Fixes: 537a50574175 ("net/mlx5: FPGA, Add high-speed connection routines")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/=
net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 4c50efe4e7f1..61021133029e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -464,8 +464,10 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_c=
onn *conn, int cq_size)
 	}
=20
 	err =3D mlx5_vector2eqn(mdev, smp_processor_id(), &eqn, &irqn);
-	if (err)
+	if (err) {
+		kvfree(in);
 		goto err_cqwq;
+	}
=20
 	cqc =3D MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(cq_size));
--=20
2.21.0

