Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE0E93DC
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfJ2XqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:13 -0400
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:58478
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726740AbfJ2XqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GS0juneBIqRJTbCP3vrHbo4sl3aAdgt+fzPkJLxuwX0p3K8Z1jAYluu/xATNuzndEkY9yQGNfJ8sP+eyLfS/zpZB8jpxO6VRgdqXr4Sg3HseSRrYTRHiMpGxfaje0xY3HqRNXM5RgMLGv6/WYZunS4HueITk8mUtruKjXQDqWjNL4o9X4LK+OycuO2n9pBofk9j+hjiNTnTBEz9KJrtpIONvo4yS2ZvK6pvv3OdQtT+VelIZRrDH1AOfdRC/lrlv+CdIllxJYgYLqFhnyn4fyusZnss3C91Cc57FkVBnzLkdnuXdRtKcPyEMNYVqCLwz55fnlYDn+W+cl5HTR/k9zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYoFGSsYE5C0b/WoAnsM98+oQSlplxVfdfEFM+yad4I=;
 b=IFs+vCixEcpfUeOXoAh9jxmRZKpEuQInifBEZigCcyemU5CjS/WjGk/pLX3NX3tkxL/wmNrGZXYwzJuN8/O3qZbYXb/EIR53bAM1hG6wwVFVDRVmBSXTXZqUeMD02doQxsgnAzM7W7h1hSF6KLyNepla91i+n088Gl294+CF8odyzDG10sUo7+JD7yj8Ykoklj4ALo/MgxVl3QAD8curAXGCSUEQCKUQ2DiypZxKR6Hqddc2IWqX9cizcH4I0YULWndAPCQguOxvTH2zsS+gIpYFQVIqPeFIc+7FFnXV2wQEs3zVa3tEBPZZZ7yQiP3p6SCEfjF9Qn5Mm8UW582Rpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYoFGSsYE5C0b/WoAnsM98+oQSlplxVfdfEFM+yad4I=;
 b=DfQjGIe07APoCg0QjbaNmwPzF3oyrvHmDHeE1dz0ciR2OQrkeT1K03imztg93Jb9YBOS/V2iHlsxJB0VLqnhy607p1KB76OP/Tnb+dugYACGne9zz3EL80kAd7eT7DlG9CmMiJ0JcKhjeaQmPCtiNmzImMwHTG3fR8hkCKMmDA4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:46:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 05/11] net/mlx5e: Only skip encap flows update when encap
 init failed
Thread-Topic: [net V2 05/11] net/mlx5e: Only skip encap flows update when
 encap init failed
Thread-Index: AQHVjrMFi1sMJwqkJ06AzaUj8a8uMg==
Date:   Tue, 29 Oct 2019 23:46:01 +0000
Message-ID: <20191029234526.3145-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: a9c1a8a7-15f5-4591-033e-08d75cca27d2
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61574B71C10395A15F383FB2BE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(15650500001)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(14444005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eWWvF/7XIC/BFK3tNtP9FkmzPt1uDpEUSfKK8OoJ69vOVXYHhRfyNuoT7mYGaJs49ggJeCzfxOBvV9SF6gcpzvv6neQiEmJi8IHd3TR6UssoTANcX5KHnNZIwBsgap95yy1dohN9c4dLPyoHClmtfoc23Wsypj2cYPCSfn5HZUcb0vycHZr8GR/aZqzbnYFAG2OKJZUMaKzDb676JNhj5b5x9waXArz+n5StYRUDsIx0LZCfaI6jpYeuJa/HxdAKZKbvqmUF1DUsEh2iFnIkA4fhZxViE08ay0UIs/OkwRs5qM5JsB48kfZGFrztUQPq8X8N0Uj+J0kP6s6kYmtGpjSYN7zSrxqx66BeUyR6F+uoTpI7uSspbDDYe4dY2AwUrUJsesqw0V4AIyjfJn6RMhZOTI6oOf5a4G1oyqoZf1dMCF0JyECEbOaTnpfHm8PE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c1a8a7-15f5-4591-033e-08d75cca27d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:46:01.9647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNG61lOjY+FEJWQFPflIBAlXwgo89qvq/BaFLdevMxEBZVsSAkG0FmncZKpp2ldOzIdHn4e4atOxaMr4anWmjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
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

