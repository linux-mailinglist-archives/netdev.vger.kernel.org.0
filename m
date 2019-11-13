Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E39FBBC5
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfKMWlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:39 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbfKMWli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haKjc7qOiuatdloLxdT0u9jdb9YMH/FdsueBXWia0GadEarY56eX8/RVjJN5F1emoyAAkBotCxcjT+m0HLzY0Pwv5QDFm5bvRsbj7lBNTd88hXVDqrYQ8EApgwVqRNlXYVTpW2dEdOKvLeOCP5gOMGiRuZ2QSoVLlINFSMtTVA7suH9Q+IGveylaltVBNYX4KhScV3x1jUFRlfmLUQqNHKiPoTh2xH9dJ0JuvgPkHFmwsKWSeBk5M1v9hGKFtLnGeFOKQcbZdgnlYCk4LYBJAPPlVEU6REoD6QCB54OJ+6PiM5aH+3SLiHRg19nfNA72nUYr2vzgW2HyERfij0NdNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGoDjEBeu91Ohdth6Y9X0xRPl3Rl5QFbWGZV/RsjwcM=;
 b=joZVjl1b0ULYyS+TukVOxIL0plvp9CdWafMBFZlMUOaM1OUeZawkkG2QntnKxKKLOtnt8EWdv+yhyt834jmYcOIiS4DDYAt7J6JgFigMWBhuinH0H/F3yOSH5tJM/ebRGLjUQcRtXLkLrnfV4rEPuhss9F+wIxTuiLj/Yk4iVvdfk3el3INP/3u696g0BYxa8DbS0ZF15XXHpWO7aqOcLeMH5VymNqvMvOmQ2v8hvgCINtY0WRbjCAzM3w59tLi9TvzducIwKu/b5BtHHDkqR7eVt30Y5vnWAC1z16k2T4awbZzg3JDEVEbgrNlP1keuyqTKqysi4QA9P2AyYyjr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGoDjEBeu91Ohdth6Y9X0xRPl3Rl5QFbWGZV/RsjwcM=;
 b=EJ9vazahpKVLrQ67x5liKJJ5X104Abws9pyinwI+sgFYlY3/a1d9yJFGGjpekLo7mESGHxO/Eg8LqC9paGhYOwFC8GHsYO8COiBDpRiEX9G6B/ZhxvZgV0uWqJOcqpyX6HapcdpyrhLcPjvTHAqd3UO4xbW/Lr9OiB/mWDQQ8R4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 2/7] net/mlx5: Read num_vfs before disabling SR-IOV
Thread-Topic: [net-next V2 2/7] net/mlx5: Read num_vfs before disabling SR-IOV
Thread-Index: AQHVmnOAJWcPaOG5YECsl6s1DWnOlg==
Date:   Wed, 13 Nov 2019 22:41:33 +0000
Message-ID: <20191113224059.19051-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 4a938c58-d878-45c8-b72a-08d7688aa27a
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135DCB38A78CF550D36C8C5BE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(14444005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qdd8Rdo/6uN+liN+xQo1xPoJnFyNyTRkvbqZCZhEUbI2z2onRXvnzEngIRjV02EsaRTmKUyiBAlBUAo4/i2qpqO+mu42NX5P5mG8wo/7YR8+i8R/355kbD51zx2GLvyyZotxIBlGat7Llou/8Gw5iYgeXAIWwimgThr5zKs3Clfrr6VNtVXCQaWUyOuakq9ife44Tk7dmg0IdBFZfEKMXWYZLqnjexlESj0eDNFOGIcWONzP+ITNS6pqad1Ln8KbEWY3PYazPkJgChgMT/IZ7QAegx7wuC9IhcWZulU9pSYZmo2+FZR5qSQPQuKNEH25p2SrZOtmreUUZQ6iFNPslTzBz5NYm6pAkL20hcNy/TW218yH3P1pqw5M+9w/Oju5kNnaVQLNQwiIHLkESyVQEE4rJd3qo/7dHqaB7kFFYMtWXm3CGjuzeQiaJTB0fSPk
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a938c58-d878-45c8-b72a-08d7688aa27a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:33.8680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zn3fBzdyhzgXla9uW/7L6koCC1R1mEptjf5cf6uAybJVQE9LVryv8V5DspDoFwNJPHi5pCtyMuw2kw9H/w+n1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

mlx5_device_disable_sriov() currently reads num_vfs from the PCI core.
However when mlx5_device_disable_sriov() is executed, SR-IOV is
already disabled at the PCI level.
Due to this disable_hca() cleanup is not done during SR-IOV disable
flow.

mlx5_sriov_disable()
  pci_enable_sriov()
  mlx5_device_disable_sriov() <- num_vfs is zero here.

When SR-IOV enablement fails during mlx5_sriov_enable(), HCA's are left
in enabled stage because mlx5_device_disable_sriov() relies on num_vfs
from PCI core.

mlx5_sriov_enable()
  mlx5_device_enable_sriov()
  pci_enable_sriov() <- Fails

Hence, to overcome above issues,
(a) Read num_vfs before disabling SR-IOV and use it.
(b) Use num_vfs given when enabling sriov in error unwinding path.

Fixes: d886aba677a0 ("net/mlx5: Reduce dependency on enabled_vfs counter an=
d num_vfs")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/=
ethernet/mellanox/mlx5/core/sriov.c
index f641f1336402..03f037811f1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -108,10 +108,10 @@ static int mlx5_device_enable_sriov(struct mlx5_core_=
dev *dev, int num_vfs)
 	return 0;
 }
=20
-static void mlx5_device_disable_sriov(struct mlx5_core_dev *dev, bool clea=
r_vf)
+static void
+mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool cle=
ar_vf)
 {
 	struct mlx5_core_sriov *sriov =3D &dev->priv.sriov;
-	int num_vfs =3D pci_num_vf(dev->pdev);
 	int err;
 	int vf;
=20
@@ -147,7 +147,7 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int =
num_vfs)
 	err =3D pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
-		mlx5_device_disable_sriov(dev, true);
+		mlx5_device_disable_sriov(dev, num_vfs, true);
 	}
 	return err;
 }
@@ -155,9 +155,10 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int=
 num_vfs)
 static void mlx5_sriov_disable(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  =3D pci_get_drvdata(pdev);
+	int num_vfs =3D pci_num_vf(dev->pdev);
=20
 	pci_disable_sriov(pdev);
-	mlx5_device_disable_sriov(dev, true);
+	mlx5_device_disable_sriov(dev, num_vfs, true);
 }
=20
 int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
@@ -192,7 +193,7 @@ void mlx5_sriov_detach(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return;
=20
-	mlx5_device_disable_sriov(dev, false);
+	mlx5_device_disable_sriov(dev, pci_num_vf(dev->pdev), false);
 }
=20
 static u16 mlx5_get_max_vfs(struct mlx5_core_dev *dev)
--=20
2.21.0

