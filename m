Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1080486B61
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404811AbfHHUWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:14 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404324AbfHHUWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJg1JlndliObamMDgcaNj5d+YUSkLzlLNvqirIOVx196tGg5pwNl0+gR/E3VSw/hTRJ1TGmDT1Ivx1NSS7YNtNtEkDnp4dS5a2uiMJ51eEW6Tm+u4/G3vMb9WWOcgPgH+e+1yD9s8ZZhQ2jvN6xSrqOJs8O/WvyjuCMQmdc3gcFaTjcHXg1w05pzqdI8+DFc2sVnj/xT1TMsLY9LefRfUoeGnePNxy0b/9ruPo+v0YeKpHzNcY0+sFzA+Rtyj88urrZjQ6mK9vh7jG/tQqyH5GodKkXva2w6ush+AqGUUB+/neCP64z44DTEXY7e/1NyQdGCIgps+VjEDrzVTnXg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGWSu/j85T81SNIwxbR377B/Tp44a7Qi5Ngk2cEgUw4=;
 b=g0kUUM/qWzU3MUt0Wa/sRB+gcchkJRwfTyehzHTxLRq3dOoUj2ectI91h9Vsh+QMCcZbmPE5wDp1nsUCwMznary+t456Gn7U4ZrbZ77hvxCQ/fhClRxrYhBDkbRgb/Bivstc0keKpQedhm/2dhOfRnJLHbH+LrDUh7R4qEwLrf1fnUqo0J/YHLvO/J1GD+BVo7oydetODpHuomsZ/7LqcANcpg2n1FXS1jUXqKd6BiXONeNE7xmJn1bQdoox64I0AdKj7OADBb1mxxB3UliXLY0+msWZAsEfzk8mTOaB/ZQWbcp8zttPnSvyNgkMkljELFnkHB0ENXnwa3YwT+/Fpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGWSu/j85T81SNIwxbR377B/Tp44a7Qi5Ngk2cEgUw4=;
 b=VfbPHvPjEqdAXGfDCvrsDrmSPX5SzKJxaCaI3m1MbTcgFOr+1gkL6bG6T1g2YwB2JTPahJeSJXsn4AWZpBIAc8+EYf0gBw2WZpdDRv2jfRYAyQYzeKyzukQKBfKaIlijSCSd+YGAA2zwhgCtT5GbFCnOQKiwBWQT1IRfGCL9rEU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:06 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mohamad Heib <mohamadh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/12] net/mlx5e: ethtool, Avoid setting speed to 56GBASE when
 autoneg off
Thread-Topic: [net 04/12] net/mlx5e: ethtool, Avoid setting speed to 56GBASE
 when autoneg off
Thread-Index: AQHVTiby846VTy9YYUGeYFnmMAzFdw==
Date:   Thu, 8 Aug 2019 20:22:06 +0000
Message-ID: <20190808202025.11303-5-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 271af8f6-1119-409c-0704-08d71c3e14bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22573121E2862754BCBCD2F2BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:107;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(14444005)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H7xVxqDnFFrpTB2hhKC5E9Ct6pGUQtHDkpOU972vzanmfMpUFh7BVIU5SwbQg5eP55ueAUoyZzA2RXdvJTc1iJ2dkWi79U78nsaU3bREbLVjodehH/dgo5kDpPQCZhoOWQObrybzFPMFXxdzFhF9hV63kmEXpX5z46kB4VICy3CZwvDfWBG/VyS5k5TWYZCXDFJqaTtrALHlghWIi2cJWfkCcKWLpydvQq1zBnvHLJ7OE+dOLzNHRyvCoFV44TLO1kuwFH2qWejeVMXTUb1hRyz46QFeGkcFlbLjScADiXGksR2TkYZtuibKDwFqMFrBD5gA2QAOLCaqfLmijZxC4u8hUE/UM9uorxSYiui3vZvR2ng6YZLzocwBDbZ4FoXqJoQ1L1wWrj/b3oTmz/VIegBz1vL8tWPabCZk2WSNNys=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271af8f6-1119-409c-0704-08d71c3e14bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:06.3703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6z2ivQSquC5U+X68rjJWFALJ7eN12wnMKzXQpZz66ajP26trMfTqVv/60/wrIMbtXRcOALzGliUomV8n0/uwWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohamad Heib <mohamadh@mellanox.com>

Setting speed to 56GBASE is allowed only with auto-negotiation enabled.

This patch prevent setting speed to 56GBASE when auto-negotiation disabled.

Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support ConnectX-4 Ethe=
rnet functionality")
Signed-off-by: Mohamad Heib <mohamadh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ee9fa0c2c8b9..e89dba790a2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1081,6 +1081,14 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_pr=
iv *priv,
 	link_modes =3D autoneg =3D=3D AUTONEG_ENABLE ? ethtool2ptys_adver_func(ad=
ver) :
 		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
=20
+	if ((link_modes & MLX5E_PROT_MASK(MLX5E_56GBASE_R4)) &&
+	    autoneg !=3D AUTONEG_ENABLE) {
+		netdev_err(priv->netdev, "%s: 56G link speed requires autoneg enabled\n"=
,
+			   __func__);
+		err =3D -EINVAL;
+		goto out;
+	}
+
 	link_modes =3D link_modes & eproto.cap;
 	if (!link_modes) {
 		netdev_err(priv->netdev, "%s: Not supported link mode(s) requested",
--=20
2.21.0

