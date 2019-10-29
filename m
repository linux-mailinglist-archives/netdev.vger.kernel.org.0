Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92BE93DF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfJ2XqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:18 -0400
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:4154
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbfJ2XqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZIpeAb1z5tivUeADSB83K32Cud93qisLTrhGikHlq4IvUiIguOVoKuPJ1iEWb/VDNHxu6dvrB8H70HWKvjXgmPUvraDh1fJoS68KyaLZ0ZRg/R3Peig1wp6MUSWm0iyyaoUCxZFlKjGrYjaOMytqPD2e1RG3IpIhxPXRh/KGFfFsvJE5N7nwWNo3LNhhYjETnCd20g2Flz+oUBtUWqV/ORsVtn6ie9tbv/yRvHodfPRP5oQCjlZwQEDFisWi+B4tRd/pWhNgIO7B9IBcHQGcv0ONPXbhNglHyKATNCmva0QwMk1kx5gQqJkAp9RUUzRLFoKNqidbRzoIfxO5tH35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DCuZCZhn5qBrFVldQ8rRBI72pnYlaPytvPzfkV0pUE=;
 b=D3Bd8tPFHdyJHqyRoL1CwLFdINNdrlIceny0bsKLtp8/idDJPx3VU5AEB6tvNePNHw4Xh1pKbpPbeSHwMA2F83QsmUVrBu4X/MVKXRN9puu7XZe4LZLsPl+ETz+F+BToJ5cyfaLAwMmravDm4k79DT4MdLexm5C2AgMUlnMiWb8EL7YcCr6DC7Yl3eqb+9kz3h1tc0UPvF+GVnzvupDCLFObwJJP40psXGtvg4CPO1/8PbFCQ2xHx+5/1jxIqmHrfJMwmrRu8oZz3OkBYWsGnmYIVs7nsoMZS6h6ej+QVch5/tTBW9gLrOfS/5Eov4ScQDVkpHCVzD3c6dy4p81/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DCuZCZhn5qBrFVldQ8rRBI72pnYlaPytvPzfkV0pUE=;
 b=QTdWSs1yXYUAW9IgTjIz2xf0/FYZfjIbxwpvMnUOPW2xIKVYVPrBYQwOpWfhWQ1Sn8aIl1M4Og+srt9YhOFryv1f7gUrhYcLGp6Ll3NT4JsdRqXiSvu20T5rYTyko8gVZwGgUIRwUQLpGTF8eeKFrM/OeuKVfHXIswWFZZeOsY8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:46:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 10/11] net/mlx5e: Fix ethtool self test: link speed
Thread-Topic: [net V2 10/11] net/mlx5e: Fix ethtool self test: link speed
Thread-Index: AQHVjrMLSsWbecpCn0WFF4k4rzCSVQ==
Date:   Tue, 29 Oct 2019 23:46:12 +0000
Message-ID: <20191029234526.3145-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e56aabea-2290-4aef-054d-08d75cca2e2b
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157637E7A5ED874648CCD4FBE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CGefHIi63/mYBw7NFFgsTOFcvueWybR7ntafCoZOufWekzbdD6GmC2xhM5MJakHinNx1YioY4soAgH7b+mzsrv1I5PzXW3hEzX8yuNj+l4qf36BnDQHsd6bAkhqiBt7V+f9MPMcNdeu5In7R5N511pD7AasVbLDGvStAF/6YFyvr0diTxO7mxbf18CMViGHXEUlJB1y7Wjp3LLSCKMF2pvtoFJUiSMjUfn6krS1/O2crG9C4DF5lYbQMdM9wEnlJ2nNwbti5oQ48ETitvlyx3yJPAz5sNkKFrBBo37rbaDtZunqIyend8HED8VJE2P3u+xevALeMKlAl4srvbFUnbAGL8p1B8tu9sbQK5U6jc1Nd0AwqH+mvmjGv3QoXO5MtOFQclV/z6BRyyWy8TzxsbCxWGNBBJ2Izc7qz/ns2Icqz+8i2JFE8Jkq2S76r85pz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56aabea-2290-4aef-054d-08d75cca2e2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:46:12.6213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTXSedXn8vdFKcsyehnzie4Rc6x5qgP+jQ8DsHiz/hFayRwlCWBxmAaVER0UrOyha2g+jcTiXOIqDWaAo+N/fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool self test contains a test for link speed. This test reads the
PTYS register and determines whether the current speed is valid or not.
Change current implementation to use the function mlx5e_port_linkspeed()
that does the same check and fails when speed is invalid. This code
redundancy lead to a bug when mlx5e_port_linkspeed() was updated with
expended speeds and the self test was not.

Fixes: 2c81bfd5ae56 ("net/mlx5e: Move port speed code from en_ethtool.c to =
en/port.c")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 840ec945ccba..bbff8d8ded76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -35,6 +35,7 @@
 #include <linux/udp.h>
 #include <net/udp.h>
 #include "en.h"
+#include "en/port.h"
=20
 enum {
 	MLX5E_ST_LINK_STATE,
@@ -80,22 +81,12 @@ static int mlx5e_test_link_state(struct mlx5e_priv *pri=
v)
=20
 static int mlx5e_test_link_speed(struct mlx5e_priv *priv)
 {
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	u32 eth_proto_oper;
-	int i;
+	u32 speed;
=20
 	if (!netif_carrier_ok(priv->netdev))
 		return 1;
=20
-	if (mlx5_query_port_ptys(priv->mdev, out, sizeof(out), MLX5_PTYS_EN, 1))
-		return 1;
-
-	eth_proto_oper =3D MLX5_GET(ptys_reg, out, eth_proto_oper);
-	for (i =3D 0; i < MLX5E_LINK_MODES_NUMBER; i++) {
-		if (eth_proto_oper & MLX5E_PROT_MASK(i))
-			return 0;
-	}
-	return 1;
+	return mlx5e_port_linkspeed(priv->mdev, &speed);
 }
=20
 struct mlx5ehdr {
--=20
2.21.0

