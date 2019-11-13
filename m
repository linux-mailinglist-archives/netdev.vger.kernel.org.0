Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148FFFBBC7
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKMWln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:43 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbfKMWln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A30GILafFcbSwIBeAB+9EpinfLNyGOeH+C46VoI9CCRB6zhkck7r+3U4rMBEjUvCF0Km/qfVa6MjWq1q/Yo84FoebI62mnW1r5xrlt1DQW2/65LafJSSiL0uYlfKpZUKAtO3pUfADaZnDB/Ro1xDAWg6a2J5RxZMeUwNGS1gw3NWdoeARGLfv9CBX0PbrXMtRX2S20TPOCKc++qU5YvZXDWSFFHvXnmqpBFdK8uUYtvVd/4mcC4MlKP2+7Rl3rS5gxznm6nN/T2OrRPKw5PW0bOtTLt25NBQgXqVleLxtA9rgwQM4gwr+ELJ7dljzq+oNli79DCXlvWmeI8M7g/a9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOqdWfx6iQT0uskwkuUWp+n8PMGDk6yEZe730diCVFw=;
 b=W6ZLIz87Y08mvDlXnxh8wce/Cr8J4TJvJEq5Fib+3RivNqva4kzCD1wu9nVht9q6ya2ZfbcrOt4sQOi5Xrt1ACFfGEtYEYpFOG9EmymlCYhNojCSA1ad4cQeJEm3IIKhhZP7BUAZd8X2FYCioyMQCBeopox/S5uc5pmOFKHzOxb0EmUKYtDnD5sBuMBu8hFKxS8KTLYk1mMFmv7QzN0/ZrMQ8TW4VwLATb5tgMeaX3WyibqylO+t0fJdj1GtleS+rdgpUCEAoX6r/9/DL25MmVMpkGBaCxfQlrEvvVqTEjrcHJdzdVWe06HkDI1lsH67IokIXjCWSzUOx2weApVetQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOqdWfx6iQT0uskwkuUWp+n8PMGDk6yEZe730diCVFw=;
 b=opptzbAHSAMfAftdDSiLvzwbB0ExfZX9v3+XSB14MKb/TZ62jENBwkgbYfZiHBA2bllOXDfnMq1MhACa0hw3RjfR0x2AThOC0+6llrIPwUeRX223IFHl4LsynV/v0Vc+PUD3WsfNs81DuVN92LIxWsXvIO+cz36GT+aX7bm7L4k=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 4/7] net/mlx5e: Fix error flow cleanup in
 mlx5e_tc_tun_create_header_ipv4/6
Thread-Topic: [net-next V2 4/7] net/mlx5e: Fix error flow cleanup in
 mlx5e_tc_tun_create_header_ipv4/6
Thread-Index: AQHVmnOChhhKk0KjVECWHMwjrErmoA==
Date:   Wed, 13 Nov 2019 22:41:38 +0000
Message-ID: <20191113224059.19051-5-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 33f90724-463e-412a-0c83-08d7688aa528
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135494696CC5B3ACD26B126BE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmEdYmHKPBEarJ9joYTcW+BljMTfIFRYUKSeeI1bOPJQBBakt0AsopZYZ+zCLxUoeveboM9ClE8MM8GPNtK6K75looPXmsvJ7CuIVRlzVCJppqzl2tj5MqQWWk8FlULqGWEJAWURaOJxcomyvGq6V3hcAAfm+nmEBiYc1g1gPIPQSRrYTCMgnMSKHfiT27y6ptetOCe+G4iWQUa97/OEU5RCD+957EL/5sVD3UBhvBg5VW+TyJLzRR7JZlsnQd3omHwHyavcK7KCJsr38uB5BrX70TXkUDB+afqj42TrLr+darSZMUjYvdv1+tPW69cLu7NMc57vwhGGAAfwwsiutp9nGUgufyY+C2kC4TtfjymmVq1K8zMTxIiN4/pWVtqw3teKVYx+o530BRAoW0US0LJs+BBLVMXpDI3/jAPTWo+xezf10H2G7V0J2nGPyJLR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f90724-463e-412a-0c83-08d7688aa528
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:38.3384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0I1B09XzlSUjrHdbljcRhbdVGCpOIUhr09q6QKoo+zIH67jw/hnPwI1B67RInypQSc2pkW1BHS3nv65k+WBkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
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

