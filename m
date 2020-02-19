Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0088D163AC9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgBSDGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:41 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:65095
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728266AbgBSDGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXxecPTAtatgDgBDUzS8qUl8imn4/Q5OweG+d/sRmv7W4pkJrxFw+bS57T9YqqQ3iVx48rJ/bK8tlHxNkIPJq5jtdYUshPiT6Frp523O1eShf9kNAAlwkQjvHQVUuqbdzqRwd7nSzH06xNPfs1AV11xFqb54xYrTaIBHixr9XTtTjTjVI8DmnCGHn9Ddm6r0jNWJCgJkFMUwli3HmEBHYkYf8Ygrnh4k50SFzKPsPBVwpRRd2HaEQ7ENexFLuRxAnhD9m0SCpQy2OgR0tkAFfaD5dffYxnQgWIH2jZMy2YUPVpsxK0amEDTWiP1h8wrgXy/nWgyl8obaB1XmsIbZTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vT6tGO7Fm1WNB2N7cyzEYfJ66iDK0/bWzAV4XoiH8LA=;
 b=AfSoIVs2TwWZF4NxWeOdWygtf4mjPX9Fg/wO5A2e4tmpbvpZIIrYXb786PqfwyQOyH93fZQ4reQ5vw8D8VaIabCq38F0fiRyymknlcmQdbgygFIjXfskxGzpg/CRkCACD7NwESIbvB17xFy4I3CO/YBhPCVKfKi/AHImjWQ5AV7NUwtko3kYylT/X53saKdzw/bqeL9mzpFLjfp8+UsgURtjxWQXEZU72eNc2Wgn6whVZ0ppf36rXw0UuqItOcBAIkEyz01Ww/l+dHEkSz08aWbC7jiJUpt5/mpbttNi0gqkJFFzIeYkO6QkuqJ/summ14HgJfNRFdpkM+/zIxIcrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vT6tGO7Fm1WNB2N7cyzEYfJ66iDK0/bWzAV4XoiH8LA=;
 b=jIsQDlFO/kp0h1J0wWVnf6RlYkt64Ek0zJFBVvaJdn70Uvv7alS3hduE93OX/F0itDQLP3Mwq34Qt7dmKMg0B1HBcIkMmsMTM7vBxfasPWSKOFyINlIxAtu/O0ssB6M/Q26/4ElKNCYwI7f35GZFygzdrqSS40tBlZGtugcKPmg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:37 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/7] net/mlx5: Fix lowest FDB pool size
Thread-Topic: [net 6/7] net/mlx5: Fix lowest FDB pool size
Thread-Index: AQHV5tGZsGf5GKJ5REKfFJM9wAE0/w==
Date:   Wed, 19 Feb 2020 03:06:37 +0000
Message-ID: <20200219030548.13215-7-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 856062af-07f4-419b-46fe-08d7b4e8bb93
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5853A4ABB3298277E0C32BC1BE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ON8PvRbkc5iibnwt80H7UOV0BpRUagdV6rf8W16B3iNDBsCbSo5uhYH9YrhXt+/X3PC2UR74fdbfF/5fFjPCpUg4y6ogLPcAFw2DJvH3ItZ0+cfv8rT+iDqTxfoFu//4yM6lYTOZArQb4FbgK9aaB4tHFQVqrv6nC3Yksa7gHA2/MaYezD874qPqeQXan/DbKymsjcvKeImK9/K2btoUroQy+qalCfFN0UKeSxj9ipZhtYbCkzMSFUuYbYImtbaCyq+LUmneW9kS0stx7zXXW4Nq1/s7SNFfTmoh4qRcgjI8UnFfUw79UhMB4Ug1UW3in4b63CELKcW5Tvc7cNxK8Vi6XKpb7hDqv/z2LN6NR6P5QLL3+WG+DsWvXtNqScbrtRH+aTdjXgZYN4aeVtlYYDGkPbtze9nfaF+8EZKUMOIewobUoWNopJYqQnx/ryPnTzBCrYctNXb2sS2DCpgdmyvj0xhxKO+NOHrrWG4DIwDqmeBUjcbpibXERjhGZ0EOgPdCAOeE6+y3vPwbrQIYCR4KAkxY/1IfAGXfeznNgpY=
x-ms-exchange-antispam-messagedata: Ev2sOd38wDWjHJANJacsslP01rspMzRHeeJdW+3iYIVr/Vfu5BC0BZbQueAG85nnrkJu0QXJRDT94iH5dzmt3NaU1066qUVoXC0Ap7uTk7FCLbU+PA88R4KBKOoT78pHfmFhtQYdq3KosfO93E7iPg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856062af-07f4-419b-46fe-08d7b4e8bb93
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:37.2476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oE8fu6P8G7Mgjzb4wTeqEMldlnpWI7euRnV4gAi3n2rX7j0uvUdhew9u1lAr6OdljpBdj4St1hSzJzGLwTqJqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

The pool sizes represent the pool sizes in the fw. when we request
a pool size from fw, it will return the next possible group.
We track how many pools the fw has left and start requesting groups
from the big to the small.
When we start request 4k group, which doesn't exists in fw, fw
wants to allocate the next possible size, 64k, but will fail since
its exhausted. The correct smallest pool size in fw is 128 and not 4k.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index c5a446e295aa..4276194b633f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -35,7 +35,7 @@
 static const unsigned int ESW_POOLS[] =3D { 4 * 1024 * 1024,
 					  1 * 1024 * 1024,
 					  64 * 1024,
-					  4 * 1024, };
+					  128 };
=20
 struct mlx5_esw_chains_priv {
 	struct rhashtable chains_ht;
--=20
2.24.1

