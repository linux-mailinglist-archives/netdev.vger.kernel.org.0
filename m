Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45910452F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKTUfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:35:53 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfKTUfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:35:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCM0UALdhJhUJ4YA/Lr4ipAD1ncRf0ZTYGsDE7LexmMwwFRMZkknBjdZp6RlZ0lSfTkJgvV8VhVy1NiyjSTmZ6cC8kaWjVGmf9HUCq+3b6r2Uir5nBiIfV8g73cheq2/tex5NX7jgQo8AgbTHWOT3JMYisLJL+FaS9uV/Rlqw0aRBqGnjid+ZDo5ljOCSTnwGpvRXISxVdUqo0sMo2roxXvP+hFSfTiONC1caiXm2f6cq1/nh9febjdni8zCXfQGUc5O+hA2xaUxxA8vVkKSOrujY8VczXH4jowt/Gg3r892cDFXnt41qMdLVhqfHndX5DJg0gACRAkVqxgiIDVuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zogpuvj8jISd1ZepiYabQf7wKmtdmAXYZr4QKd8+9TQ=;
 b=c08T5r/NaNmM16mZ4n5yPOvft+oJuVI6Gcs83ylEafvVMPbazp88kGozeWHCxguLYHjcxXhoWY/SchDub62hW4AKx1roO8c696/I9lf1YaCCSo0aDTHkJDq6wXeC9AiSt+7MH/yT3ZeQKx8wTLG1NZwgVxtvJfQAUFHxl7qHXyocGlIoewHljKO9EVKZKnrvkvHk24WeugDbjKoZ+IC5DsNjJI2cLszTUkB8Mf6r8gp2dstrJM3eq00yXjc2AIuvpj1OrCZsij6YICVgyarss8Bs5SbKXgFuVEuNm2RJX6YIk3+rPCxvqoLmlQXd/k6vdaQSYvRBhBxNHXKEKexWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zogpuvj8jISd1ZepiYabQf7wKmtdmAXYZr4QKd8+9TQ=;
 b=tRtFJdZgqU76jopLl7CgZCM79pmxISzWwq9yAOTiaJitR8G9zrbM75kEdmAMub/H42fZ7Oj6XakJbYTgMzjSidW6pmXKaEAI8HTRKzbQv7i6P2hQP+UYBwoToEUYazQ3f//9axG4L6BvPLHTlQX4Ot5dc1Zzp4Hj/KfbCEKMEEQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/12] net/mlx5e: Fix error flow cleanup in
 mlx5e_tc_tun_create_header_ipv4/6
Thread-Topic: [net 01/12] net/mlx5e: Fix error flow cleanup in
 mlx5e_tc_tun_create_header_ipv4/6
Thread-Index: AQHVn+IUB4vxSsRAB02cohkiCffKEQ==
Date:   Wed, 20 Nov 2019 20:35:43 +0000
Message-ID: <20191120203519.24094-2-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fba3226c-e191-4d72-d664-08d76df936d3
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61108E13BC920E1BB9703306BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j08RHhFiaxiiyEP/or0XNawmSWRzePC4VjweeaC3/qKOwoR+HrL6yzD2w7w1b/Pc0ep0TshtLIhttYpWUnD7o86mUEybXe2bZMiLaqBRIup+ZSvAl9nNYXU2tIyfkpN+AEGxvDxeLKCRYhmSRogcaxxxs4an+l+B6tuzGIO6lBk6gMsHtyk82m37H7ORP9EaGF7nrOOsHPwdLIDT1ZKBNRRXHr3IwqlEPY84QzmFL0dJNZq84sSlKlZ+UOJq5/uGFmYSm0e3FUVbNlO8MZBawcZkhH/FJfUXs/n95JOm/7lo2Bc8lLWTmxU+VF+SZx4nf5Z87yl6Wkszr75cNu2EW5i6Su56JzEBpGbbiLuLzPYXll3R+IJFJua+vaY19SCwVY1P640gboQum4xfUyvmq4L5BNc9fh8Hp/4MQ3F9pgxB6k9WxFv5+bP0pubecOA5
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba3226c-e191-4d72-d664-08d76df936d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:43.4129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HfBrHIC7SZ98mcA6KUIxjW/tBaH83WhOxeDyG9pel/7CAhDefqiOJgMfGSqzGCtBMQXdTOKRbUErxeDAywVj1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Be sure to release the neighbour in case of failures after successful
route lookup.

Fixes: 101f4de9dd52 ("net/mlx5e: Move TC tunnel offloading code to separate=
 source file")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c    | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 13af72556987..745ab6cd7c30 100644
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

