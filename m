Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C1486B5E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404785AbfHHUWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:11 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404763AbfHHUWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzG1oqMSrSdFhkg6g7/5q+FmNpVa6GLhHNjf13nMnAff7wWvDgLxLFFjgr70YmW7yJAOEsLYbiT1hwWw625zWk23WB//AddmEPiU3DEw4CnP7bVdxiPlEElnYnHDFpqqn/Rs1lb+VpQRDNVRgmeAQ5B/c+XyxWrCebmQVaoip4QMnniIIPd95UdxkN35C5SuTkmw3aujPoleU8NAz4nJF3nKEEcQOYqC67fHE5baeUfKQCVeNHIOqgeu+xld9RQjoDYG5PcFh+QJKy9kVgRQap8BodXUFUkR5D/F3hgKYrRwvVBuJyjd4shwa3vHkyRjUJoCSBH1erxKR4HcK6QPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTNrS9qmYcRsgB2I59Ny/ww9yDEewY48Wqjrv1soFk4=;
 b=W2Q1lo9rdijfZVUiQijdtLjfox0Mnwqmhg8uGLWyJHz35sCT4Lqbnao6iAT3glp8NhurpgYKyCTVQ0PXbt4mlT9A+rHViRHG17CGY/9uyRrd3hCw+JlvPmHzzInYcqnv4oTKy27eyHBIgDn3ThbXozI931lj9vPkcfFiSxMpvnQ7Xuk7UqjEpQsZqxv4gDHi7npP6v8VDvdqo2HQ09hYwIgD/+WHUNp+K588xdujRtzNh/ymtFxdSqYcZIX9hNSaAB+2311vyqoxpTmcCkvOT8yk+2IYiNJDXLJwNG5sHcrKRBlZxmpqZBcj2y+iafxgwx2TfZMEvpwMJn7BzA6pzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTNrS9qmYcRsgB2I59Ny/ww9yDEewY48Wqjrv1soFk4=;
 b=mdCbIZN2HZo0QDejPDfoZkMgU6MY84Mpmqqp/IKBmaSbSn54vepJNAaobwnS4HzRtW197jMENxBwdRuVhdZWxMGcC7M75K7CdkiWL/BhvMxOjPXC7XnqZ8Cf/LVcZrRb7TpJSJVMPRPnrK4g+TPEqb3NCH/FGdHVMSpkYSrGf8c=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:04 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/12] net/mlx5e: Only support tx/rx pause setting for port
 owner
Thread-Topic: [net 03/12] net/mlx5e: Only support tx/rx pause setting for port
 owner
Thread-Index: AQHVTibxvSC3c1g16kyVFq/vO2WzEA==
Date:   Thu, 8 Aug 2019 20:22:04 +0000
Message-ID: <20190808202025.11303-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2970fe3e-cced-4baf-1ece-08d71c3e13a7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2257E6704E2D7CD505F32F77BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(4744005)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VpefF0pceTKZZt4HzH79uVRYd2AVI6yiGjsOdw6iMCDlZCjlEk7BH5fSYaMYT7ipUqSKUmX9kvaHLc/fsTf9vJSBG0NK2JkJPdxzbytsMqQy5FWyPm9le+uP9GmUViKWwkyT8jo05Yunk6CzC/kaYh1w2hThDkpLsg+J41aAqR3P6iLym0Nnc6nMu6ICYKPOxmyMH57hq4GDWeqqQtyT+Wub5VHbJUf7MlOFE0aXo06LaqNObBT4pm4aQO6trl+cg+hbNs7RqTrcBsGrma3pfCwGmHUIa09HgW3LVlf3nOXsoCasTT0NdW7RO4u1mVkBqpn/OiKYi6wpWZp8wXXCO21THnFSujCL3+nBxLoLdt/NiwPDTE+Wq3d1WectLpNPeS3l0f9HJorY5g8rgU2Nut36Hy5EshcYkX+M/yRw4v4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2970fe3e-cced-4baf-1ece-08d71c3e13a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:04.3462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wsTcSnovG6oFijIC+moEv3bj5SWV3b7LnedWxKm88vmN/EOVP2m4Hmtp/CBTzjHpbE9EFuNXHwO38WnfNpmh/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Only support changing tx/rx pause frame setting if the net device
is the vport group manager.

Fixes: 3c2d18ef22df ("net/mlx5e: Support ethtool get/set_pauseparam")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 03bed714bac3..ee9fa0c2c8b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1338,6 +1338,9 @@ int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *p=
riv,
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	int err;
=20
+	if (!MLX5_CAP_GEN(mdev, vport_group_manager))
+		return -EOPNOTSUPP;
+
 	if (pauseparam->autoneg)
 		return -EINVAL;
=20
--=20
2.21.0

