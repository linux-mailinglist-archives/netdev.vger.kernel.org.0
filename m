Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4628B5FCCB
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfGDSQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:22 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:28482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727016AbfGDSQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE3NH+5OKcvMlEMH9+IU7pQ5e53uETAFuSO6Z/nGBbk=;
 b=WqgqLVVV5RYRGcBoA6mRvB/r2gNmSCFoJuwBNiTE2vQBPqqqK9h7EGIFBQYulJ7n7nfeHu3xZnWTp6UIBKauBs37gTLit6Hx8wD0TjQzawfhxLCpQtmE0Y4bMoSkyfAn8Rbf++1jugz69VUL8W5d3lMZ77+vsQB3vY8ZYdL5k10=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/14] net/mlx5e: Tx, Don't implicitly assume SKB-less wqe
 has one WQEBB
Thread-Topic: [net-next 10/14] net/mlx5e: Tx, Don't implicitly assume SKB-less
 wqe has one WQEBB
Thread-Index: AQHVMpSLfGY2Yo6MaE+i4EsoqjfqiQ==
Date:   Thu, 4 Jul 2019 18:16:06 +0000
Message-ID: <20190704181235.8966-11-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6166f91c-aa0d-4e94-5a0d-08d700abae25
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584D137000F821EFD3273BFBEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(4744005)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9dVfMEecCLGiKYmxp+cF9Jat8Qm1cBVCP9xHzbGsRANqNkLG1xnpigFxCT8/2QfYZZH2N5+tgTpKiZ1kR6kHK1klmbVSdC0HZORDZKW0byjeeXm3UyC41F4PAPjfzf7JeyEd43KVFDFYoyCjYmStSu1+P+IL1a+JZGG21eRshRGVdSSwjeUowQ7EIbezc6DpHoGmgov5oE1GmHcan6aQzweWG389nKgwjNBDhtwAOWRNHn8/brf1BGJ3nwgHwiwH6/w5PdRJgc7AyIV25fBYc6osguWMGE5vjnPZLaWSxhpLHSaJBKbSVEPCCv2TehL4M7inmeiMrasO2/uBF2eFC7yg4f1Lu6rRNWRkNTW0tAlQfImPhLEzkTbsVcs+WeUza55HYKKQBTgzQIu3pc39fziga6CQt692QbM1VswBWiI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6166f91c-aa0d-4e94-5a0d-08d700abae25
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:06.2089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

When polling a CQE of an SKB-less WQE, don't assume it consumed only
one WQEBB. Use wi->num_wqebbs directly instead.
In the downstream patch, SKB-less WQEs might have more the one WQEBB,
thus this change is needed.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 983ea6206a94..9740ca51921d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -485,8 +485,8 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bud=
get)
 			wi =3D &sq->db.wqe_info[ci];
 			skb =3D wi->skb;
=20
-			if (unlikely(!skb)) { /* nop */
-				sqcc++;
+			if (unlikely(!skb)) {
+				sqcc +=3D wi->num_wqebbs;
 				continue;
 			}
=20
--=20
2.21.0

