Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B005BDCF5B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443292AbfJRTiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:20 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:32581
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443157AbfJRTiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrIX3AMhLHgXW7IiiCfgvHPRXqtbLKkWq6a+cHYrdk/oww+qwWvq/HfIe3+GaxX/n0lfkv48pNdwVn/Ip8E7/aLawBnI3RlDFV8NVSB5LWdvkhukqzFNlxICee3kXxc3uGtB/AqNU42Ht8GNASInouA+piMdhR2k+luXQKUjbHfeHl8cLuQ5/GdaTM47K0m+na7XkspGa76HQT0SdpKm4MHuMJu7hN4LeNuDh8ORvNUdYK9EF5h7eCkKAvR4lAlPHFrj0KohjPZ6IZDUImVTuYbd8FChnKpA/ic/5ogxVSQd1wPuW4QuvZBfVXW6du1FoAwfq06FTZ4466Hq4x7XWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmIqBw6yWKPd6jkZUf+Xxc/XnG4dKj7hxQPFftJn48A=;
 b=JxxbZWLHuOX30egt44sG6OkY8D5MaPDmJiZ71U9Ne9zRA591Ayi3ngNEvLwSyRxbrl9QKMRbCh7BBp+PYMjhNFRHiOEAYbVOZZOlsIzcP+MmqksQYrcPch4Z4ov/dRvJlhT3mtHGOZS/pO29qZv6q4Wmy2pyjSac0zi+FM6RapmlBgIKqCZnU0PMOA9c3scxnGh8xWBJHfzBcGn9A/eWSzFewaly68VN7izrcM9NulK3f3k68uyOu7eLnQPBkw5+6KIgfo43dVu5a+uDGbs9r2bVp4I+z66wYDLR3XIF2+3nxAyRTerDOcrGKRfqmgGnZCjEGnR2V56yclGjZvhk2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmIqBw6yWKPd6jkZUf+Xxc/XnG4dKj7hxQPFftJn48A=;
 b=NnqTjw5UXfYFj5La2jViqoswY33tmDNCkgirDu4AmxDuzfuLk1bd6W+0ghPWcpIUDXHoef7mLcjB9ksdi+NJ6nyi59mcTPNPBM1U/9N4sL4A156Q7DW8krVsjNkqyCDTMFqJDpjRth1iHWiCCdjZZcXX8/VY6Rrig+MAU52uvpM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/15] net/mlx5e: Tx, Zero-memset WQE info struct upon update
Thread-Topic: [net 02/15] net/mlx5e: Tx, Zero-memset WQE info struct upon
 update
Thread-Index: AQHVheuPWAf7m2PZME6AycbcFFdY8Q==
Date:   Fri, 18 Oct 2019 19:38:04 +0000
Message-ID: <20191018193737.13959-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 9b4f7718-01d7-4527-542f-08d75402b15e
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392588B88D16453E1CB89AEBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(15650500001)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: utLnqd1b8qs6IhMwTuxLOqzNCKfyeNeQKQBN+HJrD5YzXJbIqxLOB/lfqmXiOctLet6jHFuxbM5gT/sA8VLoGc97TnSCnPSa1b5xsv5R9OHRWkrgD/zrvf3DVLr6Mc544W0Aac8qjI3xZpMfiYF5LKWHhQNvfr9AoXfbOaFeUr9JKcOwLc6HLJGy/C+vfGAIyUutvdIa4vd0rcUBGOoFvBUvkijyT+xQhmiBysVqzZiIj9wJmfhbTJGuPbY8yUF7lmA/6pDbD7Hy0J3ujOuMXM3ajSlGnEgSbHME6XUQFYFgrndhctp5RUvAhCFuTAxoN10Yeda/mmRLau/+A3QrG3cR4Ai9PogeMmF+8ldtMymRaRZqkCPn06lMc849aNNZeaz9P1iDGtJPuRmx1THy7mBjadpcXMdop5gy/Aw5PWxoRMFnnkDCEFU7lk7qpPQG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4f7718-01d7-4527-542f-08d75402b15e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:04.4268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: URAZ/KcxS5B+Zixn3B0oPcyeqUMV1NYgMh1Vxonh2zrQCcell30gZK1zBfGhbiHFCNBgaQ5Sh4qI9CJHgIOBZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Not all fields of WQE info are being written in the function,
having some leftovers from previous rounds.
Zero-memset it upon update.

Particularly, not nullifying the wi->resync_dump_frag field
will cause double free of the kTLS DUMPed frags.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 87be96747902..182d5c5664eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -92,7 +92,7 @@ mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq, struct ml=
x5_wq_cyc *wq,
=20
 	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
 	for (; wi < edge_wi; wi++) {
-		wi->skb        =3D NULL;
+		memset(wi, 0, sizeof(*wi));
 		wi->num_wqebbs =3D 1;
 		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	}
--=20
2.21.0

