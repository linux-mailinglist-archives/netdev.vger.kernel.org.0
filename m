Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C93B86B69
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404861AbfHHUW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:29 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404851AbfHHUW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdwcBKPdjGASGt37abmDabIbMmpUxgMF4Dc9pRz+JToVZp++VClzEI2XwvH3ifXQwcBcPBNhKNvk4cQY3nTA4DnyAZeHAhrlpKfki9NOxEmHbmGUXVXkAp/oG8hZp4HbLGwSrj3NBki8g4LwGPGS7eGU/LuWerkSGIWtKQ1WGZMJUk/3jQpqHYVVN40TnT2VXKViuczsnsxq/Qfx3Y9W3YQHuox4n1c3ru6oFrdaa4MEWfvwP6OvnrBG4TyOD5qpN+gSOFlL4BD5Y2yIinKUsrkEaGrkt5DLk81EVQZn9xx+Ja06sQHf8//tc86YSdCuHJ5xjLriilDhdSgNj1ud1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFAPr66LBgFG69Ry7ob8TlLcnFyVneZzv664EzqXnnQ=;
 b=YgJTc267Bm6p7hKUMH5vmAQTYoegNWMmluEwyhABvB0iib0riWnr5HVk2eKQO1Ae68M2xLIgqxzX8Lz00QW9ZdNu/VmatdfL9zXlA/a0PM/twou7JMKzxlNWO8HjGnLPrxwYe4RfstzN9QYtKLkhZTULH/Y2yelfq48BNwYViLrebG+z/NgtBp9t3W1JcYs4AK/yq/qku+LXYUdY8cuJoqDuNjqEIsOceM3CXGybvWj0Y6DIDuufZJUXiDmdkXB0EqTvhcAtsUEVd5weStFIibObuyBH2DN6IyBt8/bvwGkFqdPI+BdQiFrvfTdL3wbcl+2j3on0FPSx5HLV0xQdcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFAPr66LBgFG69Ry7ob8TlLcnFyVneZzv664EzqXnnQ=;
 b=f6SJsvogWZVQNlmwgQazw6tNqbBOIiGYSUEVVXBuMp5fo4O9uJ1PO+AkOXOWOU/T6v96j9icUZojv0bFWdvb2dqw0ZLCdPZDKnEAmVskVEC62Fq+oIBwB7GnCnS+OBLp2tl4ezitl05MrA+NjO9nwyAFi0BYwOstRVYep18IAOY=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:16 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/12] net/mlx5e: Fix false negative indication on tx reporter
 CQE recovery
Thread-Topic: [net 10/12] net/mlx5e: Fix false negative indication on tx
 reporter CQE recovery
Thread-Index: AQHVTib4vy/glERlD0qoeCO/B9ucAg==
Date:   Thu, 8 Aug 2019 20:22:16 +0000
Message-ID: <20190808202025.11303-11-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb3f28c6-5bc9-40fe-ea02-08d71c3e1b19
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2257CDFF026806ECACB859AFBED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Yecx2LOtlKfmJ1mepyBOJFp6BgtGYVuWnH31j8kI6yjLJXgmmBYxrxqYDNJ2GJxQuCszGNhNlCsHxXGjrt3VxcWq7p1ozSLCruddt31DyMz9CNAXeoSZXqkiFyidn+GLZIBTujiuro1TTQOkIgOpmAQ139zneShEnxCXWQKNH82jxChePs/T8rE6gBfT28NB9Tn5ugCSOgIRwrtBO3L3/Q1zsUHdMGDaX8IzSVnApD6L+9xxL9OEfN6lBQ3IAMS6oGndHVDzhn/kQYK38Mfd3Y0tLY5uGkNWNYHEnehxI9einY2O+lPdMt0lfVSswH+4B2mbAvx/ls/RdNRk3bUxpbWDa8WShsOgeJidILXqdEwZTWIIVQczYLQYh8uJWejygXw0LNMfnFAMg/AQes9xBS7IsDJL4ATPTp+P7x76a5A=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3f28c6-5bc9-40fe-ea02-08d71c3e1b19
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:16.8276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k9EsZzbJXN31F8T0d7vDufNP5tg+lPb1iwr7TgMxa6zUVRjQlIJmQ0YZb+kQDVUcOpWWM/ki8k+wGeT6TA4Ssg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Remove wrong error return value when SQ is not in error state.
CQE recovery on TX reporter queries the sq state. If the sq is not in
error state, the sq is either in ready or reset state. Ready state is
good state which doesn't require recovery and reset state is a temporal
state which ends in ready state. With this patch, CQE recovery in this
scenario is successful.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index f3d98748b211..b307234b4e05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -86,10 +86,8 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5=
e_txqsq *sq)
 		return err;
 	}
=20
-	if (state !=3D MLX5_SQC_STATE_ERR) {
-		netdev_err(dev, "SQ 0x%x not in ERROR state\n", sq->sqn);
-		return -EINVAL;
-	}
+	if (state !=3D MLX5_SQC_STATE_ERR)
+		return 0;
=20
 	mlx5e_tx_disable_queue(sq->txq);
=20
--=20
2.21.0

