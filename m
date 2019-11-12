Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EF4F96CD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfKLROF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:05 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727021AbfKLROD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:14:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs9YOoFoKZNujOj2r9vpSkbVop5WlopIx+1udKtt9YTj14h19lCvoUayZWpzlLKNeXs1Wk1bnVlvhzd5defw45BRT+YNf1d2AKjiI9uha48fvewSjVezXxz0r4UHj6hRmtfibyYCoZigq6EbhzZ20XcUsZnzHimKL2ncgJc8FgGzi/IXiAnM1NgpvYsHw3cgCsm8ijROtCeS8ck1+vCe93CIHNpMbi6MeEcLtwyT8LCmbchKKsO9JPb1DnKbxez4QADLSjpWOlUsVtPgXZtG4o8DtRNMydvxcCLmKVgZbVfivZxJghpWYn+u5Qv48fe2Cuhhfkj88Faizhctzz4nDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOqdWfx6iQT0uskwkuUWp+n8PMGDk6yEZe730diCVFw=;
 b=h9YtNye3jTblbSL954LudaFTnIpUY4p+li+kCahi5nj1CwH83MvWFpXXlgkTk+k+btsFCQ3cvzeFIlPPfPRK4Nowjx+XzC/BhJxLM6ELgtBrYH/6UTb6LCWmyVrQ/DMf6HhQ611tEjyxk5pCEq+/7FYBKKadMu3hk4McAMb/VXfIYCbUdu+sn546Dvh5VVybd0mT2ydnNvqJBWb5kj5XatkShuaWe5T6CyUSp1CgteFws7CkDKHl5yTTDTbnRAkMfxed6oGiF4EFtsLO5Xu3bRRvkW5LS6DktaEIcndPP+a5wY1hiAdPrNJeJFqKdkmrF9yVg0aLBObkwnSNC5FGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOqdWfx6iQT0uskwkuUWp+n8PMGDk6yEZe730diCVFw=;
 b=B6/M3tdBZojyAQOpMT0Fa1M4/ssfCNUaweLqWjl/DcpURPsEJNlT2jtWubnnZBX6qmIBkHcqruOVf8M9RvjZOakfKnRLAgzGlEFNAClR4T5MEG3BoPSowthy+P2uYfgY3pF9R+u+Svn886vQg+1Zdg6yz/nQmrKYRHWWOhUhrKg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 4/8] net/mlx5e: Fix error flow cleanup in
 mlx5e_tc_tun_create_header_ipv4/6
Thread-Topic: [net-next 4/8] net/mlx5e: Fix error flow cleanup in
 mlx5e_tc_tun_create_header_ipv4/6
Thread-Index: AQHVmXyKUGBgdJ6/r0CcpLUTOdyobw==
Date:   Tue, 12 Nov 2019 17:13:46 +0000
Message-ID: <20191112171313.7049-5-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec535fa4-6084-4119-7a7d-08d76793ad31
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB607861FD1CC5FCD600E4246FBE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(446003)(71190400001)(11346002)(3846002)(76176011)(6506007)(386003)(52116002)(256004)(316002)(476003)(2616005)(486006)(6116002)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UgdmKpEWT8xf6FJ86qZmWmyRpMuqq/sD8sRCepmW/5qKSwEHNvdFRvDzShDsjekP3QBIOf3t7zNeIQOOt4AvZQFPMgV4hKkT1Pq5KZGMIXH2MSx+auZGiPRYuzSfqQIqInuaSoeFqJsSGa7dna9TbJ3Ulfwi4DB8oD0D9fuEs+dHeEnqF6lVXtaJlCRUm1LBINwge4A7JqnVMPAspgm94ot3Rbc5LNaOmGhLFqDC6XaneIGFIKk1cUCHfjSRf2JM49QYtKOuOO22XoKg24VIsZE5+6ckvXygA4cx6dDivsmnueUkYivpH8QBaJaCcnGvhdmSufAGZjf55TnC3WNZR4EBMJ6tSOdz6jr4q9HksHzrCNNY+Qup5c9QwiGw8Z28+zuZJ+JIomKALesfUa3CckEiA2PfoG3Y/szipX2mps50nRy4XBVNTTj6mGR6CE0E
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec535fa4-6084-4119-7a7d-08d76793ad31
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:46.1577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 035USTRourXkTtsi6j3ejP7g25LEMseqjWUoWp8bkk8e+8bAvIBqr+YSyAWKCkEo8pFXViba9vfIjSCAAe7DWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Be sure to release the neighbour in case of failures after successful
route lookup.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c    | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 4f78efeb6ee8..5316cedd78bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -239,12 +239,15 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv=
 *priv,
 	if (max_encap_size < ipv4_encap_size) {
 		mlx5_core_warn(priv->mdev, "encap size %d too big, max supported is %d\n=
",
 			       ipv4_encap_size, max_encap_size);
-		return -EOPNOTSUPP;
+		err =3D -EOPNOTSUPP;
+		goto out;
 	}
=20
 	encap_header =3D kzalloc(ipv4_encap_size, GFP_KERNEL);
-	if (!encap_header)
-		return -ENOMEM;
+	if (!encap_header) {
+		err =3D -ENOMEM;
+		goto out;
+	}
=20
 	/* used by mlx5e_detach_encap to lookup a neigh hash table
 	 * entry in the neigh hash table when a user deletes a rule
@@ -355,12 +358,15 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv=
 *priv,
 	if (max_encap_size < ipv6_encap_size) {
 		mlx5_core_warn(priv->mdev, "encap size %d too big, max supported is %d\n=
",
 			       ipv6_encap_size, max_encap_size);
-		return -EOPNOTSUPP;
+		err =3D -EOPNOTSUPP;
+		goto out;
 	}
=20
 	encap_header =3D kzalloc(ipv6_encap_size, GFP_KERNEL);
-	if (!encap_header)
-		return -ENOMEM;
+	if (!encap_header) {
+		err =3D -ENOMEM;
+		goto out;
+	}
=20
 	/* used by mlx5e_detach_encap to lookup a neigh hash table
 	 * entry in the neigh hash table when a user deletes a rule
--=20
2.21.0

