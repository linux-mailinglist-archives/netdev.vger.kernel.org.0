Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5005865FCC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfGKSyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:23 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:22784
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728927AbfGKSyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9UO1Gfi5XfRZaDrsx9vcty7AKqXdsW/oDmYaMxfEeYERwc4pJXp1X5vdel0nCoxdNBjN9fphyQiWN6qGrSve44fGczEQDEcakLHBODmclrzRE67ySp3PDq5moNaqaJucOau02SxQ9nC6sHEl2vyJ/LlAPuI95liu9ScBjURYMvaoAAvbdttLgA53go0x7mUjKdwe36+Z+TntJMCyeqRHwy5NuQOOK3/rhh04o+zH7OXcJQVgoYf6xqYUOQnXSZn4ApXiRzrtbGEX19p/6t73tuEQYMXvlT7xhTrALt5/R0jN+4rtB37OKEp3/108MVHrY8dkLsL+HIgtVXdeJk5Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kTbPgtSgZTG4vtcHIyGLR7wSD2Gk3YCqzXeecvv/bg=;
 b=R1Iig/bOUiviRWQxULMItXjmueL4VuxV9LlCfaICiZ+hlBpBFAXQpKjKOBGCS9OKNf4b2KyYYhZzl3uY3l+8II2RjsPBLPefa48W4kEj9pO+yE5HcoF756Qyjz0OpVVBEsZC9m/VBJ7kQAQNJrRmspjXbz9fvp76QwgICx6Cm35g9l3rg9AOPOWcPHiDD6XXF1dU6G2Vu6P1qhkkK6AryN6B3Kucr/8Mwyj+0lBIqTbapmDhfLaKmjAWHdvQwSn7gpVndK0qPs8ogmK0rJsvZnGXuNKvDedEu6ckgcXZwqkRvdd54bO0fyIh1OGoBEBxDvPKQHcPtazijLg45OcMNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kTbPgtSgZTG4vtcHIyGLR7wSD2Gk3YCqzXeecvv/bg=;
 b=gPCoNrpOpl9sq9tWDDei/1aYuEE1NQf8k2XTSjUZKTjeTLP3HhkA8vvyqwqkDk0bz7d2Kp40T5xUZ+ivMGWzAc3duvW1JKWbERWJG10AApxHIVLF28GCUQLS08fzHEsN2R4NzsHkAXD+IgU3UNjjokaK6ueIwAtRg9IROStSIl0=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:19 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/6] net/mlx5e: Fix error flow in tx reporter diagnose
Thread-Topic: [net 5/6] net/mlx5e: Fix error flow in tx reporter diagnose
Thread-Index: AQHVOBoLfgxrMshtIEON+fwueTo3Qg==
Date:   Thu, 11 Jul 2019 18:54:18 +0000
Message-ID: <20190711185353.5715-6-saeedm@mellanox.com>
References: <20190711185353.5715-1-saeedm@mellanox.com>
In-Reply-To: <20190711185353.5715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2745bcb3-b800-4cd6-84af-08d706312dae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB27702BB96A91CA4E0F2F78E6BEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(446003)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(11346002)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(76176011)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bqXjgjMR3hUXeyzU4ObX+SfcTd1maPeQ4S1txAqseXRsLPI3c50m8y+PF3ByD7NZ2n9aKqg8/5CU1toiG+Yj9dKuTtXAxDkPk+LL0ZDq2fbaijxrIU1muLIrzBD2EeZKwH9QG3FGzKq1VWBzzjNm5RJSkINktj+tHwqlaFraHQJaRiU9+jKDVmbHSEwi1cSnIMhYT78o5Irf3geXQphMiRkFLrBYC/oY6PQ7rn2+vU1fMHgQNmxWEddBJh1sfxueTiteqf7osHASlcqUsFBlyyHEB3Is2R7DEIe7gs5IeZ7G1fPtZ1awLexMu6BQnb9nxqhuZn5gYir+HqsCsXsppE8nBMB5MGEBGdNd0lmomdPpDOu9jVKuGT2dG9WzWNSq1gtZcRKezlDZ6ryDIvImNA+XMVqjtFtbYFLGiqNKB+8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2745bcb3-b800-4cd6-84af-08d706312dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:18.9578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Fix tx reporter's diagnose callback. Propagate error when failing to
gather diagnostics information or failing to print diagnostic data per
queue.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index a778c15e5324..f3d98748b211 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -262,13 +262,13 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_=
health_reporter *reporter,
=20
 		err =3D mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
 		if (err)
-			break;
+			goto unlock;
=20
 		err =3D mlx5e_tx_reporter_build_diagnose_output(fmsg, sq->sqn,
 							      state,
 							      netif_xmit_stopped(sq->txq));
 		if (err)
-			break;
+			goto unlock;
 	}
 	err =3D devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
--=20
2.21.0

