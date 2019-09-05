Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEBA7AAE10
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390999AbfIEVvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:23 -0400
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:23041
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388932AbfIEVvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIqYNH3TOmeQwwK9Zt2GAaWbBWvOpAUESgxICfJ7D+CLaXVR6HzS4XZUz/FY/r3tYowOCS6SeYfNo84CKLY26/wex31S4CmYU08Hi7hgy8KrtsOcvics8drD4VlJ+GB3v8c0VxVUH82VCi4S0msOiEk6PMl5Tbkpzd82RRVssAb94GHjlGLMaAABGJzMEO3BcT8azo5rv/scLevoSH50nmTGDnw9PrVqt0JEdL73BexXgAGoijh5+XrmhPD0hoeZIMZXHxdSFiAKZC/I7f/gS0D6T/Y0vvAxLPkw/X61v/RAzeEofiTrC+VvNReIadPVzpcQDXgknqqUzjvKhKx7qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrIDxSOclr8ie9mkH/v2MFOwlMxLPUUypns3HY6pV28=;
 b=FjGIbgkf1Q6+HBh6bSKYyzo6UHl0QUiBdFA7noke/7nQ/LzdtOeT0WaOFiGqYoz8NZpzx/svLt4ATkF37t6YcC0+WJi6TK2IeS9MHRKFyyuYRuGY8KO4Fheb79TSD56azVbHawUMd8kRkep1tREJS66ZL9n4BZocuyKdVL+yly+YrBiI5wzfJy5O+tXiDsguN74dxCeXfZIct07UbcEU6b64cfXbkUjK/K8NF5iK4fw/4Ry7toC/u1ccok7cfIIUjoBepxgRlrzot6L6XBLfoFVhRd/vQ8ATJjtOmOZsfYt9VRxXYsuzwx2RqvpDtUhPPf5e7QqYG0VCWURQZajp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrIDxSOclr8ie9mkH/v2MFOwlMxLPUUypns3HY6pV28=;
 b=APJ/vVdDwvQMzcF3YmmHC0F5PO+Wex+t6VQ+mKbqujkGYf/nv34V7I4HUdaf0KDBYyF0L1FSn7OOba0AOESs58/cd41DxHt3Y02xuOm+myidi0Ktjrk4TjIdbKN+r2UMkkAIxKiFqQL3lpmKEyImOWSKQ43jI7Y30caLL4YnBxw=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:15 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/14] net/mlx5: DR, Fix error return code in
 dr_domain_init_resources()
Thread-Topic: [net-next 11/14] net/mlx5: DR, Fix error return code in
 dr_domain_init_resources()
Thread-Index: AQHVZDQJuropgQ9o6Ey9b69H6r2atQ==
Date:   Thu, 5 Sep 2019 21:51:13 +0000
Message-ID: <20190905215034.22713-12-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7179e61d-d208-464e-8326-08d7324b2bdf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2768BED47A2C48418BC94D65BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wRgqoChIGDs3L6A9HVKBWMuRCG1OIPMVQFHAamtdafedcwLt8D0WeEGnGE3tNJOOmagr95KovP3B8QtkNMTX1b/ngmHvDV+LDvLqDxhnWe5D6x9X6TeuC2TDmskmx8ldC1hnebLyJnCADDvUH+5nomB9/7tr/g0gxPOACHHJERZK5VkY2TGMdpx9bV/CFVwV4h/iOBErbKQ5OQoXrHeOSTIUQG3XWc8mOmLo9HzF0eZ9pokG9WiJKgrOQcCOtYHfmBq1zg30jw/0wUeTv8OPOQ5g09PAeD+jTYDb0r1pKF7lC6djtkYktgj656TwxgGo3VOL+NpcpxzQioTtofet8RfTZTcYqahu+RH2NrGxBVGGqDiYqxbjDVVMp75hZKsQKGCEW8lNEiLSzjdRXl+SmmOHrs0W1sfXU4axMMTVKVI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7179e61d-d208-464e-8326-08d7324b2bdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:14.1961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8hhyHbmvoc4u81k5oBbzf8OD3lS9nbhvdieP9BZyO/NMWKkmsh4w+nOmvXbmzWjsEiv+L03BxmsTOvBQ5AVCPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 4ec9e7b02697 ("net/mlx5: DR, Expose steering domain functionality")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 3b9cf0bccf4d..461cc2c30538 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -66,6 +66,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain =
*dmn)
 	dmn->uar =3D mlx5_get_uars_page(dmn->mdev);
 	if (!dmn->uar) {
 		mlx5dr_err(dmn, "Couldn't allocate UAR\n");
+		ret =3D -ENOMEM;
 		goto clean_pd;
 	}
=20
@@ -73,6 +74,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain =
*dmn)
 	if (!dmn->ste_icm_pool) {
 		mlx5dr_err(dmn, "Couldn't get icm memory for %s\n",
 			   dev_name(dmn->mdev->device));
+		ret =3D -ENOMEM;
 		goto clean_uar;
 	}
=20
@@ -80,6 +82,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain =
*dmn)
 	if (!dmn->action_icm_pool) {
 		mlx5dr_err(dmn, "Couldn't get action icm memory for %s\n",
 			   dev_name(dmn->mdev->device));
+		ret =3D -ENOMEM;
 		goto free_ste_icm_pool;
 	}
=20
--=20
2.21.0

