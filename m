Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6D665FC9
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfGKSyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:17 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:8419
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKSyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qt5jPyi3fR9OosLe6ynQa2G7ysvmTpmyJQc6GmID4bXfdP6oHFN+Hotch4yXvM46Ka+0oQsjkzclhEXH5L2ziIVbnkxZLsYhOSljf8bkwvw9oSbDplNLVy5msIV9s8rLRFps+Db7UNPFYr0C84a0uAY59WR6LInfQvlKf++AC0KBAQ7p2O0t0cNtsrr1zatIeHWPRrOqCwPvqOmuHvtS4ZoXXILbQQLy6XtNnMpsnFuY5CKX2KAd+84NAg6H0zfUeZuVb6NXvJznkF+zSia0FOSeE/z6RtLoW8PmjEiqS5hTntqELU65PSXglvs0B2H2giD8A/SH5CjYXhLmvjapIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jzh2fEQtODuCNKQNuneTBChCJeIVuorEidSyLCbyghw=;
 b=EatQadTm7Wx0fkaJP+lrkdrFV/W7xkK+f65Oi8Plgvll88YJP7+dRGPgFarWxnmnMNJF0UjvbbHbTkRUUJFpzZuZtL/HLuqsn19GuHkV2J2lwq+MyiU7xcRNZhxM3NvlRyiHMEfVU/7qVA3EEMiT6xIaOdS2Pz7axEFsjO5H9d+1GW0vZiD38nTcUw7xnzDlwmJ05H1BMnenDSq/x1PWbyUGF9IgsBxtFKyNDkWmslC6vbm6Dnovbq5rQLbZ21zY7R72fI0M/a5aBRa7NdAovjFei0Kb1VgmiZSo4u5dYtkUZWTU2AmXEm5nOQg6g1U2zQhtPfMRE8ZHER9J86+9GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jzh2fEQtODuCNKQNuneTBChCJeIVuorEidSyLCbyghw=;
 b=eWQ3ienPAbNJSQU1F1b4OcIHPwOm/pHQ3PuOYUSX7QKOeq2n7ZidBota1ZYfaWbNVjxCWYdAqiTQhIGhLwqhaq2JUOb3AN5qBYCAbgLLYLICgCtDcjyIpueK50fogW8bAicC93uJJ+6MA97MdFy3/1lfcp7wB6RsHoLV8JqrDsA=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:13 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/6] net/mlx5e: Fix port tunnel GRE entropy control
Thread-Topic: [net 2/6] net/mlx5e: Fix port tunnel GRE entropy control
Thread-Index: AQHVOBoHRWlsBjMoyEWnW6CXsP9Tug==
Date:   Thu, 11 Jul 2019 18:54:13 +0000
Message-ID: <20190711185353.5715-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 10b114bf-c97f-4c9a-9927-08d706312a54
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB277032A59BCF15BF73680AD3BEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(446003)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(11346002)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(76176011)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Qz9nyI7FX+8uQ5Yiy7fKemUE/mVxz7zQIkMdYOjKGN86/yJkiyfrApw1AfM5Ki8KlqLLzngasnNhVE79toPeaAJyyj3YVcdzaFsPrDgn6dNm0ZWxTha8K6uY1/3hAodEemr4fsRSJpCYBIkdOysWIDrrP2ootRp0qWaddE/mbxUiJBnEZE4N0T96YxWpPcm3GA4IMcdlwiuevrH2qvy51i8rW0DWVeUlFWYrCYp8Llb+b3dX5QeIjzycCKcZQ02nDwdL32QvzUUEMdmTaRbpss3+7erV5rJw2wGhMePpoL7WzJt5AS9gSAvWnOaHLMXi8/Kn3CdIY2WiKx6I66JzudRZ2+CIbWA2CCBfGvOWkjI8mKqH03readcZ9vSECXSoeJ1NA11z5Bj0yJRR0dDS3EC9lhhh0TED6bTyU1Qy9mU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b114bf-c97f-4c9a-9927-08d706312a54
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:13.2254
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

From: Eli Britstein <elibr@mellanox.com>

GRE entropy calculation is a single bit per card, and not per port.
Force disable GRE entropy calculation upon the first GRE encap rule,
and release the force at the last GRE encap rule removal. This is done
per port.

Fixes: 97417f6182f8 ("net/mlx5e: Fix GRE key by controlling port tunnel ent=
ropy calculation")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/lib/port_tun.c         | 23 ++++---------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index be69c1d7941a..48b5c847b642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -98,27 +98,12 @@ static int mlx5_set_entropy(struct mlx5_tun_entropy *tu=
n_entropy,
 	 */
 	if (entropy_flags.gre_calc_supported &&
 	    reformat_type =3D=3D MLX5_REFORMAT_TYPE_L2_TO_NVGRE) {
-		/* Other applications may change the global FW entropy
-		 * calculations settings. Check that the current entropy value
-		 * is the negative of the updated value.
-		 */
-		if (entropy_flags.force_enabled &&
-		    enable =3D=3D entropy_flags.gre_calc_enabled) {
-			mlx5_core_warn(tun_entropy->mdev,
-				       "Unexpected GRE entropy calc setting - expected %d",
-				       !entropy_flags.gre_calc_enabled);
-			return -EOPNOTSUPP;
-		}
-		err =3D mlx5_set_port_gre_tun_entropy_calc(tun_entropy->mdev, enable,
-							 entropy_flags.force_supported);
+		if (!entropy_flags.force_supported)
+			return 0;
+		err =3D mlx5_set_port_gre_tun_entropy_calc(tun_entropy->mdev,
+							 enable, !enable);
 		if (err)
 			return err;
-		/* if we turn on the entropy we don't need to force it anymore */
-		if (entropy_flags.force_supported && enable) {
-			err =3D mlx5_set_port_gre_tun_entropy_calc(tun_entropy->mdev, 1, 0);
-			if (err)
-				return err;
-		}
 	} else if (entropy_flags.calc_supported) {
 		/* Other applications may change the global FW entropy
 		 * calculations settings. Check that the current entropy value
--=20
2.21.0

