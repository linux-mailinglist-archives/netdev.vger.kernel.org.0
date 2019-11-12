Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFEEF96C9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKLRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:13:47 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726645AbfKLRNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:13:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rnce4HMsotIybx2dZLMu5vJqBSophG39gdU9jKKWhIdHdDJY4Yphj6qtnMjfTah40c0F3DZkmNJX6W01jf+dur4VHQFFpZx/TiWatN4tUCuUUtOO2JfmKHkULy34ROq/eVEH0UP1+HYiZoj/JyAFW0X9KjwtUYhN/VYeQF+PmQpNVNJD6WeX8bR5T0sT2qLdet1+RsuCrvZtXNT9gTRpfK1GD7/iIC5sv+PYUw5sMQkp0bfTtb1UPctN6kRMD2XmHxEFy+BHYHObmjeQSH2BXVbzQ+Nf+Ccn3p54zuna0btoG8+mrhoWFHJgtOO/I2ZPAoX3AVjGaYoE+zjN44omIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGoDjEBeu91Ohdth6Y9X0xRPl3Rl5QFbWGZV/RsjwcM=;
 b=HREeld2pKfWb8Lo4pKdSDqxCesT+o5rIMuiBU558uU8km21cnNuu94CBqrOt+Eh1u/92RQ1+bwu39Hf3prcGjgtyjCEUd56pCBgnmWCXS1w/OgGfmW5coqrQz1qyoxa4wGLi26lIeB34VH9o+ZxROfaQDau/4dBycXbGIBp8cwwtn71OlljiD6D8sUw9yPbHPUrWrQR1tiqnweNeg8hsr/cXenqdcaESU8SeJLt0HT4yud8YrlyGdNcMOE8duHma07697dVnvug2Mt7EHv4M/0+4Ihkgf71TyaKRSzRQfYGId6qDSLZWXPAlk3iymLKAIUJiaK8b5GMil3+5YX3R1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGoDjEBeu91Ohdth6Y9X0xRPl3Rl5QFbWGZV/RsjwcM=;
 b=I6gXAikLf2Ad2WIExcq2E7yOYgoktfAHWU/iYM+7qUC0tAa2kevcMqpBxmBolSuiYR2JOXsbZDtKNpCu+LhOHVa5OuphLz/0bb4yO6yjbVk5koDtbimbrK0Xz1o1kEQ+bMjBrTpRd4rWHs7RaJ4uo/K/NmjScSW61K0odbJG6YI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/8] net/mlx5: Read num_vfs before disabling SR-IOV
Thread-Topic: [net-next 2/8] net/mlx5: Read num_vfs before disabling SR-IOV
Thread-Index: AQHVmXyIEMapjlx8VkaUzdj2e7fvXw==
Date:   Tue, 12 Nov 2019 17:13:42 +0000
Message-ID: <20191112171313.7049-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6d1a455b-f26b-4dd9-1b8c-08d76793aabc
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6078DE68A49376213D94FC08BE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(446003)(71190400001)(11346002)(3846002)(76176011)(6506007)(386003)(52116002)(256004)(316002)(476003)(14444005)(2616005)(486006)(6116002)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ub9RQy3357G1G04DkP61T4oO+rzl/9c56jOvSCtQbSXA4nhVbcuPwRsgsVianoCB9ou3Cssw+hXg+CPF+cD092QHSDEhw5otA+GqErr81RxUvvSEIR8TxP9balox+HPQcp3OMcqnq7dRWGqS+Hwo71G7rxTcha5O0mhyN5GLmEZoFVFRl/CTt2+AWqjMpG3mTSG7acA8N+PhFgKNxKbkU9/QCqO7IJArUMkXYZcQ8QU4pkJLxbmGBJSmBC5WSHqkUAIwz8h9iHi2xD1gUF7vtDEPDPw4b9CFw9dpmzjog1NqoeK0sPHQEFdqTUvgIvYDsBnFRx+iI9nKympTViJJmBT9vnEO9DOX9sbZU4VJ1y5W33SIR7+dFFVuip4kp+rR1zYIAdi0eaigxLW97c6d4XOlEe6V4lmAXJCnEuN/oF4IDkH2nr5jVuePE7n39inA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1a455b-f26b-4dd9-1b8c-08d76793aabc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:42.1780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kwKtJJ56DBisxHdDYTETimN6+uxWiF+KiBPNYTuYwUe0/m1v1G9rF4Z4+g+gPRyj0GrKtkIlkQbr4lK22mx5Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
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

