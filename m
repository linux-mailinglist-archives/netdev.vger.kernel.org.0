Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71926DCF68
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505990AbfJRTjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:39:13 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:26853
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443347AbfJRTjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:39:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqZJLJ0q+0JzFkSLr/n2CK54Srz+ZhuzdkI6qu55KFdlH2TjHbNRf6qBfvfbTeunX5D1kX6xhJwJ4vl4SZUINjlzyT+JAl/piaEonoI5H8z3wxwJqZiyDvKrBBLEHwPOX39NSxeQNUycyl3U14z6HY3ehkOwO9jbxS9XrObovs+ew7LtK9LKsNqklP+SPz2pM+bopLzLIZJego96ii+YWQ1/FZShZHFmCVLzQfzyY4DAOo25VaG1+EczPGvWRC2o6iiKVaTtEra2rXIUZlCrhcJUqYl139n1Xpi8FVjc8TLYsejyBkUyMoJ46d+v4W+UXQ2lgb3kitI6lYGZhTdQlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFKGHzBuuocW1Bw9q5aIP9q/J4dmvXdPnTqJOm2KW/Y=;
 b=fDj1mAT0VRWtPQdPqQNPJF07toILE3LjupEKN8jSKqSfdaB1Za/nhnZdQygbAXmQ0ool+49Y8EQ+lXPQIgmHHt3AVH6aedznxNmwh5i7EnDzJsJBN9JbafnCrrM9ac3cbbh+dUaKh84aopDpMYrGh8D8vNYcwYo+s684fHXjb12/VHDadIviNcouobSLktlXSbC8VgSAOrQsdyT7yT9/LcSsYLHGikNkw+ta0H0CNZxKWpKDSpbjDvOUEFrRRQm1LyUco5oepQqGXji8o8qeFEedOSAvJqRMRusHkZnRgPFXDQITjUPQLjwJQi4tOzeoNFcEsIJ50tLVm83ZamQANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFKGHzBuuocW1Bw9q5aIP9q/J4dmvXdPnTqJOm2KW/Y=;
 b=U3WD8pOPRCM/ZJ7ggh+oykRwpNuWG/jsEUOav1quY8WFFmVFmcPk6Ys0AiFWtzEWjBDBaEj3+kcI2GtCwcldLrzknIX7kAPvl8H2mWpMCXeOhW2XTT6yW2Ar75CaTsiVKhYdApr8mPBDUze5Gcj5a6WD0XGknUFye6whG1uWPsE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 13/15] net/mlx5e: TX, Fix consumer index of error cqe dump
Thread-Topic: [net 13/15] net/mlx5e: TX, Fix consumer index of error cqe dump
Thread-Index: AQHVheuccc7dY+6CJki5o/RuYy1Kew==
Date:   Fri, 18 Oct 2019 19:38:26 +0000
Message-ID: <20191018193737.13959-14-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 33ecc328-c79c-4ef5-987c-08d75402be89
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392FA7E56CA47E59AF0EE5DBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AprKQSgCaK5Jhaa5SkoySkBUslGUjS3+1GIORNDTAxd4vROUMvlioNHss+zme8WW90EYUvkG0wqWjQYn+sP5FDWPzct2qFqX3BcMZdZgwRteDrnVmCtjYlaaUazTQbXmW583o10tH8dvk0o+S9qNr6FSbdYrBH/H9eH5YsNLzOJfPRPbLiMa7xA1+/fji8qq1oy9D98m73lyJeCEwHU9b8Qux2reJJcsyq4bga0kzJOA8Kp3FVLujftjxQU+7YsEQqNLuWq2l/6Z9nTL4uZ5yc8Qwp5FLjf5MKJU3ngFU4K4EJHwayqXlhD61i7HpQdRGC+ZJ3EoaB+XMiNdqKlQYGIpvf3toy6n3nbZmg0d+ihpD9eWsRYLVLoTj6cA0ejaGmSR03yFtarY9gv9Wa1C0696Jg7DDgpqmF244EkW1oZ72+aaVS7G7rkpqyRnbDhi
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ecc328-c79c-4ef5-987c-08d75402be89
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:26.3368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tfqUsJhEuTmMel/vk+7kHwLnOLaNcWit019Tr+gApn2WtNoTH/2p0ly5M5fC3gGZhcBZChS5PFhzHeiCUiQMbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The completion queue consumer index increments upon a call to
mlx5_cqwq_pop().
When dumping an error CQE, the index is already incremented.
Decrease one for the print command.

Fixes: 16cc14d81733 ("net/mlx5e: Dump xmit error completions")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 8dd8f0be101b..67dc4f0921b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -403,7 +403,10 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net=
_device *dev)
 static void mlx5e_dump_error_cqe(struct mlx5e_txqsq *sq,
 				 struct mlx5_err_cqe *err_cqe)
 {
-	u32 ci =3D mlx5_cqwq_get_ci(&sq->cq.wq);
+	struct mlx5_cqwq *wq =3D &sq->cq.wq;
+	u32 ci;
+
+	ci =3D mlx5_cqwq_ctr2ix(wq, wq->cc - 1);
=20
 	netdev_err(sq->channel->netdev,
 		   "Error cqe on cqn 0x%x, ci 0x%x, sqn 0x%x, opcode 0x%x, syndrome 0x%x=
, vendor syndrome 0x%x\n",
--=20
2.21.0

