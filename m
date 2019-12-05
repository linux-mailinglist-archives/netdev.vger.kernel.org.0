Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4C7114880
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbfLEVM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:27 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729859AbfLEVM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rfl5+SW0vDVxajP3VOWRzZfYRPNCBez0UEeGrFczN5XvX1Jy1CPy5qF9vO2P1aBlIRN7Qe+oQC2wctHj87HrOrxZglbRNwmj7kS7iAAjYa93FwNo9rSUNl0rI+ZbTroe82N8/aze+9UAU30T52B2vrIKgW0IKEOy+9Sjg7Z4ODYAjfMHApf7hQ5zevbmFPl+ecJKyjQ87WSIHqGXxSBytRhtp+uWKdTFMV0EAZTVWM317+HRsBqlc+5NlbzicUvuTVGGQQjG1qbhysXB5h9YbDMvQ5JEjYqsrEAkzWjljD38WEKaqOJVVwAH2mIsfM2j/SfooE2rlMX1OkiG/tcReA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guCcip1nqmvs5zsBFD9Q1oiJ/b9u5Z+v9W5K42uTHFM=;
 b=C29zrs9jnzDiO6BjyN8dFkeaOgM0IrMYJB0dicT9YoUQudJL23cAOpDAAmap5/oR1PDBkvs727T2q1oUyB7xfPICMh4g96MbCJensLXzaXWpoOJC1PoVTM1Zq1IfsORx2p4eSQT54ITw/JZsgPYnGTOEEAJJebS+7nAdJUVbhfZbc19qsBbtUfhf++HAUQ9cTi6pvLsOi2zeEFv/c2x6rJyHDyOSFvb5Wq7iKhuqNm6bPxPI55nTgKD2wXxQp1ruqsos6tIB3SyI3kwrkrWuVMFKSHXUEgV19wouq2H3UVYCB5aC0h3bFh+Johr7bqBSFMP/gTK6agYLsR3XJpILrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guCcip1nqmvs5zsBFD9Q1oiJ/b9u5Z+v9W5K42uTHFM=;
 b=BtrCLmlLjHDIU9GVjFEsJP5aeb4wX5ds2j+b6kXmC1jdvAliw9t3pQ7ivFho3t4UJRElPxomXtzby8nWZs5OOvKMqgBk9zvM0V+xY2+GlHz1lI6sfGoDGA+Cckkc0yAb4tofaUppXCd2RTVo3ptzzeFHgdiNdvWwMEzpQD28Nn4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/8] net/mlx5e: Fix free peer_flow when refcount is 0
Thread-Topic: [net 5/8] net/mlx5e: Fix free peer_flow when refcount is 0
Thread-Index: AQHVq7Cq0VzgGAktBkGyqLIR6NRH7g==
Date:   Thu, 5 Dec 2019 21:12:13 +0000
Message-ID: <20191205211052.14584-6-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 648e70c9-2c0a-41dd-08f4-08d779c7ccad
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3326275EAB02BC997E59DEB1BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(14444005)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9hjg8H3F4ufAyswy1qa0RR7bFO8jw8yOHd3Ds9yOqgKM19icDuKEmvS4spOghhsdYqzPac5v47xzXatSIZdOaZyL3OGas/KPrvuYhh+SdNsyuHaBZfKV4gRVCFhCLpXEi/cRdKN+xN4HA3MxfYauvJvTmSO6DARJwf4hBE3dv28E2DVqVhE5QwjcQaUdgq6xvu3kvYt6CzfR6IrY3GFDAZ4gY4IsdX/hod9vLaqnxcL9ZURdlRHxrF/cJ+n9qnb3aVDWS17lVrPuPLpnLj5ceEN+p9NOFICcI3DBJxc4hgHtunGOJXad4iXLzO6p8kkw1CMcJfpPSv/mhoihfyYFcTwTpPd3M7AoY33Y2vecMdiVLvavioCOtAn/ppj89xmB4nSuHPmBgBYCxfSAuFZRhTmc7dLPkihJPqucx07wg0yslpFqNBrBW5LT1hJh33aR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 648e70c9-2c0a-41dd-08f4-08d779c7ccad
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:13.9747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4AlfocpigzaIuhZvAhLJBNnEDEOg+6prKg6n+BH+BGORAy23yPV50S3Mk/ZWfYB8XejSNx9dU+75MaVr6hhEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

It could be neigh update flow took a refcount on peer flow so
sometimes we cannot release peer flow even if parent flow is
being freed now.

Fixes: 5a7e5bcb663d ("net/mlx5e: Extend tc flow struct with reference count=
er")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 704f892b321f..9b32a9c0f497 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1626,8 +1626,11 @@ static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5=
e_tc_flow *flow)
=20
 	flow_flag_clear(flow, DUP);
=20
-	mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
-	kfree(flow->peer_flow);
+	if (refcount_dec_and_test(&flow->peer_flow->refcnt)) {
+		mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
+		kfree(flow->peer_flow);
+	}
+
 	flow->peer_flow =3D NULL;
 }
=20
--=20
2.21.0

