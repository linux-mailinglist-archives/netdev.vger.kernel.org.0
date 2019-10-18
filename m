Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44741DCF5A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443261AbfJRTiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:18 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:32581
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443146AbfJRTiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBolBZqywKkrWUWT69jwj4TwMvN/r0jpA0HPjV+SRjZZ/kHtrcwqGOlKgOWDuPcnT3p64bM7mx7bFAZ7WtzEvZ/xkLvnwC8Hc7WGujKLqWL+jkVyzd/LcEgkD1vcIwTkAnHdXfJg6CqpSs/012fUzf3nQZWpSMzC51Ut7QHXY4sAn+mrP9o7MKaQqrJ1LH35mjZlVd0ENph3+Yjkn+qdoVh4YGUU1EwK9pqcXV1qG+xR+EhGz3LL4oeKPOzex24PHlF/JwH+DtWfGBpG0iponIrJLgV+sIs8VswOEBaYl5rBi2RYoJwxWiVtapp52VhUDqLn9n63e3Yrwzgi+yQ/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/yh5hxSDTnv7MKByOpYpgYqGHCq9cLm364PGhb5ILY=;
 b=ChHD+Z1B2zs61wFj4Il0pLfWF3N6LrU/MSiQGRxgGlNKuqKtCUBsaZpQdA7PGm8uzim/oedngL0dDb2hkQtyJPNKRUBiOyk2JsfCP1wYT59qyfJLjQO41sTm1EUfKlJgTPutKy4BWRf1zlZGATWM66770uBcu4rjLKdFKr1Ta9T86P9BKQHsUAQHjX/E0xZAXjACG/aqn0pS/fYy6TEOLIgczgJOP8EgMJOnwU13YyIKRAoPnrgeG3kkwyhUaW6D/v7OfE661Ht3V5yiq/IWFsV/15gZq9reffchONcNYl2m2B43onilDhbGmK/rzoYGpZy507I29z2/ImJjbCkgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/yh5hxSDTnv7MKByOpYpgYqGHCq9cLm364PGhb5ILY=;
 b=lEQmln7EQYOKpsfuy/gfgirEzetUQ8WE0TYa8UF4zlqGR1NqH+TQau5//EN1sHmS0D71KVuL5jrmx0rqNesDdw2a2zcyjoWjqofbiEgXobESLvPCFjKLCXgbe/xXoHqlRAp4MlQVoJkyUdtlByXzzVVhC0KKAnr+ItZuuBgIx8M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/15] net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in
 cleanup flow
Thread-Topic: [net 01/15] net/mlx5e: Tx, Fix assumption of single WQEBB of NOP
 in cleanup flow
Thread-Index: AQHVheuNxl0CGKj8502vcW4EWge1Fg==
Date:   Fri, 18 Oct 2019 19:38:02 +0000
Message-ID: <20191018193737.13959-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c5d5e588-131b-4964-7fda-08d75402b000
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392A59C5713F3EC2B79917CBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cY7p7KoVZ19xBVLe33mIHfKwJxt4jaoiq8pVeF/oZ3FbSHGOGYGany+YvWenBwoERjt8oaDDT2YMo11q2+vExMZit6dvu0BGQ6JLQ6bqTRktZU8oyAEw13hdloGs2QLjftAm51H1Tg9VYscGAmoONtgDNKxzjSsoWhFvlHP/k5MxXA09CYMSs/V+gCU2ZzdL4O94UdRiPo1myovzYFhQHLcQUkdWiOrTvfqTZRB6sa2Wpxgm4E8CaJXt1s1Eu58+p0bSGqeStu5gKEmrG0A3UBz7/sH/wlSuXnpywGhJeBnNI/6cdl50Amfq1NAjqJEuNdwGjMqw8H4UMLXtG+l/smNGSxo4TD7ToNDRnf/2kg2Fdz4vp9OtEs0k5ppO7vR2dEaR8nUC1kulJmrJdfBXENOMrNV+t1LG1jT2Jn3o/sME+d5u1c4qDgHQZBJkJV2T
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d5e588-131b-4964-7fda-08d75402b000
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:02.1431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qwgfUcGaoquvU/lRdrrTNkTJ5f3qYTLecY7KGfbLyMYf43ed5loIUwg/eAvsgiL1dYsTokkNcoyArKAW0inw5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Cited patch removed the assumption only in datapath.
Here we remove it also form control/cleanup flow.

Fixes: 9ab0233728ca ("net/mlx5e: Tx, Don't implicitly assume SKB-less wqe h=
as one WQEBB")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 7569287f8f3c..b476b007f093 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1349,9 +1349,13 @@ static void mlx5e_deactivate_txqsq(struct mlx5e_txqs=
q *sq)
 	/* last doorbell out, godspeed .. */
 	if (mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, 1)) {
 		u16 pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+		struct mlx5e_tx_wqe_info *wi;
 		struct mlx5e_tx_wqe *nop;
=20
-		sq->db.wqe_info[pi].skb =3D NULL;
+		wi =3D &sq->db.wqe_info[pi];
+
+		memset(wi, 0, sizeof(*wi));
+		wi->num_wqebbs =3D 1;
 		nop =3D mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nop->ctrl);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index d3a67a9b4eba..9094e9519db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -550,8 +550,8 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		wi =3D &sq->db.wqe_info[ci];
 		skb =3D wi->skb;
=20
-		if (!skb) { /* nop */
-			sq->cc++;
+		if (!skb) {
+			sq->cc +=3D wi->num_wqebbs;
 			continue;
 		}
=20
--=20
2.21.0

