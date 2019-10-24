Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340F0E3C1A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436933AbfJXTi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:56 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392853AbfJXTiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA2S1ZYrJ/AVw9+PJTjvEe76CDAhT/zwcozu/SJPYZnBvkObzOkHqzNbk0di31y5bBBo81yIwyaZYdxb7ogHPTWDqrnIo2ShqmhL3om1Az5q2wBx7fauxY1SG2vMT3O7C9SgqKWaIK+d//bPwTrAfCgv6VkZZNseudmdHVsoZINeDgG3HubBa0a4P7ZgEBTrJe20GEBAvOAEQxPwBx7RG2udC0h2d8s1b0YJJGd9Il2rA9x46F2S9NJdGQf1KwOv/502TIJXbao+J+dlXxBzk7Z2n7i8fFMqxw5sTzlpDJ8m8bNRotZPxnGUaLXdWX/m+1kq/rA/LoBsOC0r2kaF/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYoFGSsYE5C0b/WoAnsM98+oQSlplxVfdfEFM+yad4I=;
 b=bn2PkBAl+082vLwiXT+FfGqkRpWopnnRS4yN3VgUU3OvGynPc0X0ExYSO3RT/V6SiMJMSYJELIr8EQ3MzqpdDZe2yHAiY7j7aVUN/Iq6WdotGEXCZ6+nAmN5NFEieBwDHj+RIXgdsv8eIkwZojfu15WkZCXtUdV+6KaIhVog44BDcBYZJ4le1WURAX8gJZoXlBqSs/SQlLHAG8/LBy6WrskORT+ajjtIUYrzOtAXEs7eKkuQXLsXq4hsCD4MoFmVbws8Yb0cFs+j+B3H5MuF/TqRk5Vo4P++VtybdVYKLpdCCtiqx01CUqkoHIovbDJrgUp0wGPpqyIsT8Es+GbCZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYoFGSsYE5C0b/WoAnsM98+oQSlplxVfdfEFM+yad4I=;
 b=E8CGLAZHeKZ6g5xr+qjTyZQgWmGqfPLL5lie5ATw/V0Vxi3sdEraNhaBd514Rx4Pkh487put8LAyKlXzHGgHZh/Yj61myUEEpG2NNZ81NsUrMzPwCrZJRucDlNq3npc720LRTFqUSt09zdQeHPuX78XBFrqWiAzwI9TJJ/a1d1M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/11] net/mlx5e: Only skip encap flows update when encap init
 failed
Thread-Topic: [net 05/11] net/mlx5e: Only skip encap flows update when encap
 init failed
Thread-Index: AQHViqKpmr0CejDGAEm+5nvD9ZjAzw==
Date:   Thu, 24 Oct 2019 19:38:51 +0000
Message-ID: <20191024193819.10389-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0623acde-8ae9-4e37-46d0-08d758b9cbd7
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4623F03C241D23DC0606F2DFBE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(15650500001)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EoSkOU5U+SvuEaCYhom8f8DH2K21is7cTpLNEhonDAuC+Dpek9ZPfxuFJ0vMNTJjEQTpdygUAStKwxLA8SQWOMEBqHM9/UByV4cx9ipGTO8taECUjpu1JgS+Xav4Bv4mDXIi8QG0gC63cPgOMtwCEswMwWPfzDIZ+5q+o2KCP7iEZsqt0ICeqLKiXNZpl9cFMdEdzGa050kXg7KgeBuaM6ZThcQIII/+SmMpS5Bkj8c9cdCjTgtyUE0IpTqyqUc2In6uGIPM+pHZPQFdl9t/9NsgaciKs4Iet8r4EZr+R2chYWksED3PmUyGOsu+hJJvQgy7qdjjw41d9vtfRPFfoiNxVYp4MUt3K412w5uEOZI7FT9w3t76PrW8iBM7pRikZU41wSnuG7hOP3DVkgbvq/2CL4iIdo2IxjavB/YYgclZWwsUMQJn3mDcLw3Wufay
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0623acde-8ae9-4e37-46d0-08d758b9cbd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:51.2009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PCYX0el2Cym5aZpMfdg9zXwIjWnC6OkQl45g24DdG/CEKyELsEXqXCc/v+RZ9GfHt0XjZDUK+FEBYasAREeg3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

When encap entry initialization completes successfully e->compl_result is
set to positive value and not zero, like mlx5e_rep_update_flows() assumes
at the moment. Fix the conditional to only skip encap flows update when
e->compl_result < 0.

Fixes: 2a1f1768fa17 ("net/mlx5e: Refactor neigh update for concurrent execu=
tion")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 95892a3b63a1..cd9bb7c7b341 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -611,8 +611,8 @@ static void mlx5e_rep_update_flows(struct mlx5e_priv *p=
riv,
=20
 	mutex_lock(&esw->offloads.encap_tbl_lock);
 	encap_connected =3D !!(e->flags & MLX5_ENCAP_ENTRY_VALID);
-	if (e->compl_result || (encap_connected =3D=3D neigh_connected &&
-				ether_addr_equal(e->h_dest, ha)))
+	if (e->compl_result < 0 || (encap_connected =3D=3D neigh_connected &&
+				    ether_addr_equal(e->h_dest, ha)))
 		goto unlock;
=20
 	mlx5e_take_all_encap_flows(e, &flow_list);
--=20
2.21.0

