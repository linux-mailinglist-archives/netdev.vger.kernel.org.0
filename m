Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D4DE3C23
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437181AbfJXTjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:39:07 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:46757
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437127AbfJXTjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:39:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Op0FOXJ+001puUBqcebCc/2BhvboaORJHV4pT9/2uJn9AsIeaR00pNRYm8fAbH+Pn51JBnlpL3GUZR8psugYKo/X5H3QHhokrpWl+8jSke0JDX6LW33F5XdbheVR66CPQLX9vO8v8uCYYcmI7/m7VXrrKO08daNqvKALmarQGOwn/EKxcJl1AD6S4gt+Q4QoXQjP0Yw4H1H4x/irrDY8VJFeNL8vuEwecOiWAAu9DpqTE8/0zIeeC27IRT0QtlQbXTRGGVe1D1J4eEgD3a2E/hJ4pfFT+ndOAF/xz0KATwaTIJdzuKtUWuQphcjJ4qcSaXn6xhwMPL9k612NlUNsJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0y3A3AuxZxk+oKvoERiekfm7iuR7NKnerAgXmIN5oM=;
 b=mnvcR6KLThrG378fLC4twtU2+UCp5faTsjgyy0aHKZm6e7Ad6fAgQbMzC4yPFdPkGeNeceHO7g5e2Vt+mGI9TI1HKJ1PxDz7iRIrtZsl2rDjgDXx9wC9arQrXpwwOBZj4I3t6jgSc+byfXf1VFXhYjXqJnSjyG/rluKBeCxbifZB5bsiZ528oSw3jAYQJxBMtKlxVTjbxc2bph03Bk0t8ctOefjgwHjnhWCZaNwR3QqBNvsd9uxxGVTKLFVeygBe+aX/vHRTFSDBb5vdaDA0LznpSsoPN6laUUjgGtGCZUK81thzAYn+9njcx2CXiA7o2p5TWrG+LE5b6lIy/Dnr6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0y3A3AuxZxk+oKvoERiekfm7iuR7NKnerAgXmIN5oM=;
 b=ZI0OWJZQJ6p7ElP7Ko/7vyt/+nc2tO1bDv8fo7VRBMhNrHQ3qCCNmECaEbOqYYLnQTVBkj55Ufy/NO5AO5J0iZKhHYKGJljIVUnD2U6kmyIu6vBN1pInMftxnPzKSRMkb02HIkGxAlpBaY7hd5vJ0nINxdmeVV4dfFDHH0/HAl8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/11] net/mlx5e: Fix handling of compressed CQEs in case of low
 NAPI budget
Thread-Topic: [net 09/11] net/mlx5e: Fix handling of compressed CQEs in case
 of low NAPI budget
Thread-Index: AQHViqKu4vpIJn565EW6hyCWDtMAxA==
Date:   Thu, 24 Oct 2019 19:38:58 +0000
Message-ID: <20191024193819.10389-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 52173abf-1a12-4cb0-2ce3-08d758b9d061
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4623A7A3B3C75F93786215EEBE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bYLB6Ebze0+YRUSUkGRdZVOon7WYHPSywOOUlG2oNIfh1lrTU8uBIIjRgwdqH4NtnGjZeOBp/Y7ecIOqRCvNeiCY4E8timY9wj0PHJ2J6QeibkCXC4koWnCB6aXn3Z4rSIS8Q/dImrbg5uoJX5UA85LcIK/crR/GyIG/pnNJWuBD0FQXu+OhQfEs9M3IiBm2UMrYJ+FVC341diVj0+mPhvbXzJyPlLVpuo04C/21C21+eXFiP0zpQywVSkbg3L7LbPQaNIveqw+mu1JX7TazSjXN6Lau7QLe9uIq9F58fJha955h3UcWLmSbNf6EOVSqM7mw4BaO4Gyi6VysDdrVOboIJ74sIDMkePU9W5vtPhwMiRMdyOF/hqhk8zKwL4dfO8MW+Au6g+ck5nvPjvrTDXEPfwn9UwYD3e9wKdeJlesb3iQZwrlHwdRuQB1ldtYh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52173abf-1a12-4cb0-2ce3-08d758b9d061
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:58.6316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxfcTqfLAAqArtYkfNEN0mbVBaFlQUjQ7s43ziQxi0UTkBVC/DY5vzIAGm0GQjFwmoycWUQysoK4cvwKoDAd/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

When CQE compression is enabled, compressed CQEs use the following
structure: a title is followed by one or many blocks, each containing 8
mini CQEs (except the last, which may contain fewer mini CQEs).

Due to NAPI budget restriction, a complete structure is not always
parsed in one NAPI run, and some blocks with mini CQEs may be deferred
to the next NAPI poll call - we have the mlx5e_decompress_cqes_cont call
in the beginning of mlx5e_poll_rx_cq. However, if the budget is
extremely low, some blocks may be left even after that, but the code
that follows the mlx5e_decompress_cqes_cont call doesn't check it and
assumes that a new CQE begins, which may not be the case. In such cases,
random memory corruptions occur.

An extremely low NAPI budget of 8 is used when busy_poll or busy_read is
active.

This commit adds a check to make sure that the previous compressed CQE
has been completely parsed after mlx5e_decompress_cqes_cont, otherwise
it prevents a new CQE from being fetched in the middle of a compressed
CQE.

This commit fixes random crashes in __build_skb, __page_pool_put_page
and other not-related-directly places, that used to happen when both CQE
compression and busy_poll/busy_read were enabled.

Fixes: 7219ab34f184 ("net/mlx5e: CQE compression")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index d6a547238de0..82cffb3a9964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1386,8 +1386,11 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget=
)
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
=20
-	if (rq->cqd.left)
+	if (rq->cqd.left) {
 		work_done +=3D mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
+		if (rq->cqd.left || work_done >=3D budget)
+			goto out;
+	}
=20
 	cqe =3D mlx5_cqwq_get_cqe(cqwq);
 	if (!cqe) {
--=20
2.21.0

