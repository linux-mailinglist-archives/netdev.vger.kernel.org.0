Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42AECA97
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfKAV7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:08 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726983AbfKAV7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXKUhFa4TafpYmwN7ZBGA84361EWMcLca29jSLf/qP1B0AFF0haG1s1I/uL8QKd1PDAMuPuidNB/Ia3fUZUtyDqgrnMr+AwEYzcwsFPWLA9gB3pIY+voqhMrKK+tpv2hYz3RLl4x7MV73q0qkWtjXM29JllmgB/QVCTuGKsYBbUi3hggIjpzH6w7TMGBvBcJiC4pOrinUAqSFOtp+XpOnecIHPeoQwbLlkaDidQSkPtvQLMlVcTOxBzKjnIuU1aZYRHgsG/C5HZTVsXWB/grYHOG3dOHm2iySxeXmlNlPL4WWTXcaGBPHY22yMMCdziy6GPMHWsvJjCm1KcyiPv6Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPuEE02MaelFlLy4WzFNugWUAEMYA32+1XOOg9n2vC8=;
 b=KWzgOSzhWB1IXhgziL4gpNSzQOYqyu7Vspyr6oDPKA++x7Da1DV4mqRkDO17RNMP7WWLOyQ+Ch6vj9AbIeFzUyPsgXD5lhjPY+N8OrIzaDslD1wBfW5TUOPZ58wMCTzIXm56pnMs3DqcCg4Xgw1FuYjKX4Adr1RsI2xG4lZn32oJ3sGrRIgosm0Cx+X2s8OAJwH9N9HYJsSWVjP9uqUy8W+yn5VddOR9HBdgTpih8UvFaLVFCCiJ2wrthRsuZxzs2K6RrKZlpuH91jsaoC9XS8IIRS+GdVXYnGosQ+FTgI2ZFs/XV/tpON/UwvecpLasJ4O670X+1oEpeMATZyfiGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPuEE02MaelFlLy4WzFNugWUAEMYA32+1XOOg9n2vC8=;
 b=ld6X/7CdyA9qpADErE/VttB9uR037lq9E6j0KaBLW7/f43ZOVYAHjrSWZ5t/68N/56xP94DrmWu3+B0thXBrIffYQwF2cEs1DKwLjPBk4e36hnHIFJC7nBTH++4Y7Y0ZaJolYOBoR+uEdomDD0UZEO4fwcMGKWg3FJ+dQbojr5M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6173.eurprd05.prod.outlook.com (20.178.123.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:59:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5: Clear VF's configuration on disabling
 SRIOV
Thread-Topic: [net-next 04/15] net/mlx5: Clear VF's configuration on disabling
 SRIOV
Thread-Index: AQHVkP+SJz+X/W03+0OxMz/xSXBv8Q==
Date:   Fri, 1 Nov 2019 21:59:02 +0000
Message-ID: <20191101215833.23975-5-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 237f5abc-6f12-4a20-d131-08d75f16b4e3
x-ms-traffictypediagnostic: VI1PR05MB6173:|VI1PR05MB6173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6173EC1D1FEB31566B42EE41BE620@VI1PR05MB6173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(476003)(5660300002)(486006)(14454004)(107886003)(76176011)(7736002)(478600001)(66066001)(52116002)(2906002)(71190400001)(8676002)(71200400001)(6486002)(102836004)(81166006)(36756003)(81156014)(50226002)(6436002)(386003)(8936002)(6506007)(25786009)(66446008)(66476007)(6512007)(6116002)(3846002)(6916009)(26005)(99286004)(11346002)(66946007)(64756008)(86362001)(305945005)(54906003)(4326008)(316002)(1076003)(14444005)(186003)(446003)(2616005)(256004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ud5dWj43zdPXMc7XXcBHtWIDSmvKLjFAStGS68PlBweQZ1wRdw06eUpiB8XCZcqkZribRHcF0yQnJB6ksiL9UcfWWrU4S4bNV1vAPjZzG6rKOFhMSPafQ7gql9EqHOQF67M1TcGUpQJ4T2E5vL+QVEua22SEqv8BrqQ2KmspcdZy9b6+5b+QOa2rE9AVeOb/X4sNaKIJiKfJ8UEzHSVpXQ7DL7c40rI2Bj+AUmUkIdxyB0wNDgaJ6jTitmzQmxIdgymi8FukvqYgCn1S1lWdi4GWw/Yx+SY6FxKHsFjiyhBNaUBNIqT9EhJV4Se7yS/LKjfsKFl9hPdGkYcsre2pCUcp49KkG5WWt2vMqRakqRjcswDzu3X8DVNe54YA6amlJzmuA093hzrs39QaUbCdLfzlNaukFY3wSeqcjpaGnD6q7rhzGBoF0Q5WaP2D7OU5
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237f5abc-6f12-4a20-d131-08d75f16b4e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:02.8031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oLjVhveGeiRGsh/h31VzGfiWnJZZKdJtHRl3QlQJ4Y8/wlWm1HHXSSX5KKXRdF4dL8LfWF6u2MvNfdvF0OzwWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When setting number of VFs to 0 (disable SRIOV), clear VF's
configuration.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c   | 13 ++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h   |  4 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c     | 10 +++++-----
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 30aae76b6a1d..89a2806eceb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1831,6 +1831,15 @@ static void mlx5_eswitch_event_handlers_unregister(s=
truct mlx5_eswitch *esw)
 	flush_workqueue(esw->work_queue);
 }
=20
+static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	int i;
+
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
+		memset(&vport->info, 0, sizeof(vport->info));
+}
+
 /* Public E-Switch API */
 #define ESW_ALLOWED(esw) ((esw) && MLX5_ESWITCH_MANAGER((esw)->dev))
=20
@@ -1923,7 +1932,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int=
 mode)
 	return err;
 }
=20
-void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
+void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 {
 	int old_mode;
=20
@@ -1952,6 +1961,8 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
+	if (clear_vf)
+		mlx5_eswitch_clear_vf_vports_info(esw);
 }
=20
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 6bd6f5895244..804a7ed2b969 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -270,7 +270,7 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw=
, u16 vport_num,
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode);
-void mlx5_eswitch_disable(struct mlx5_eswitch *esw);
+void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 			       u16 vport, u8 mac[ETH_ALEN]);
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
@@ -603,7 +603,7 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswi=
tch *esw);
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0=
; }
 static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
 static inline int  mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)=
 { return 0; }
-static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw) {}
+static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool cle=
ar_vf) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct =
mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev=
) { return false; }
 static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *de=
v)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 00d71db15f22..cbd88f42350e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1370,7 +1370,7 @@ static int esw_offloads_start(struct mlx5_eswitch *es=
w,
 		return -EINVAL;
 	}
=20
-	mlx5_eswitch_disable(esw);
+	mlx5_eswitch_disable(esw, false);
 	mlx5_eswitch_update_num_of_vfs(esw, esw->dev->priv.sriov.num_vfs);
 	err =3D mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS);
 	if (err) {
@@ -2196,7 +2196,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw=
,
 {
 	int err, err1;
=20
-	mlx5_eswitch_disable(esw);
+	mlx5_eswitch_disable(esw, false);
 	err =3D mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/=
ethernet/mellanox/mlx5/core/sriov.c
index 61fcfd8b39b4..f641f1336402 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -108,7 +108,7 @@ static int mlx5_device_enable_sriov(struct mlx5_core_de=
v *dev, int num_vfs)
 	return 0;
 }
=20
-static void mlx5_device_disable_sriov(struct mlx5_core_dev *dev)
+static void mlx5_device_disable_sriov(struct mlx5_core_dev *dev, bool clea=
r_vf)
 {
 	struct mlx5_core_sriov *sriov =3D &dev->priv.sriov;
 	int num_vfs =3D pci_num_vf(dev->pdev);
@@ -127,7 +127,7 @@ static void mlx5_device_disable_sriov(struct mlx5_core_=
dev *dev)
 	}
=20
 	if (MLX5_ESWITCH_MANAGER(dev))
-		mlx5_eswitch_disable(dev->priv.eswitch);
+		mlx5_eswitch_disable(dev->priv.eswitch, clear_vf);
=20
 	if (mlx5_wait_for_pages(dev, &dev->priv.vfs_pages))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
@@ -147,7 +147,7 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int =
num_vfs)
 	err =3D pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
-		mlx5_device_disable_sriov(dev);
+		mlx5_device_disable_sriov(dev, true);
 	}
 	return err;
 }
@@ -157,7 +157,7 @@ static void mlx5_sriov_disable(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  =3D pci_get_drvdata(pdev);
=20
 	pci_disable_sriov(pdev);
-	mlx5_device_disable_sriov(dev);
+	mlx5_device_disable_sriov(dev, true);
 }
=20
 int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
@@ -192,7 +192,7 @@ void mlx5_sriov_detach(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return;
=20
-	mlx5_device_disable_sriov(dev);
+	mlx5_device_disable_sriov(dev, false);
 }
=20
 static u16 mlx5_get_max_vfs(struct mlx5_core_dev *dev)
--=20
2.21.0

