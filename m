Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5A3F5BFB
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfKHXpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:45:33 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:11398
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfKHXpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:45:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQL8zNvKdyZMzhLASsHlaxZvOPz/rNkmdBluHdJeDqAIqMWQuR6ApsEUq5bil7dmYnvhj0x3AaYTH4YI4eDa3NUFGYj0QdkW2B/ItWB3pC+vMoXyicW0vB7oQNkTAU4Z48nzeyYtaIEmaxMyvDMtGl33ZoOcbJlWMBuvh8E+OgYtzetlB3C0FvzwLS1YgNGmy7y6pX4KiqXTScoIePY2v+wvsrC5j24/hoZAD4qf87pVfuSoMbfzgjvFqqZtFD9PZzLKD1z4n1f8HpyAqjb1Zo2/X2QNnjBolnL+k4em1sMK/a3H5MJvceTFuxBQ8hpkPownZ9ppSM9ik+XHCSUxwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgvge60wryAlQXdTOZ8xVsNoCv/JdYIlp+n674WUmSw=;
 b=lkgwrcebr9Joo389uEOZDOFF0QNgd+e++fJNFI5i5lWBalRnmbWZzV5i0iuEE/Mx62Gtd/WrAg1tFvtWv0JylaxUI2l7jiuDUSo+q5vauo8fz8Hmb0mrVg+xI6+1gYbjNO2shgdRSH2BAX0z0ExzKiTsgHzeCZAUhFjA4zpxhK2nVHO+jmqpMgo/pfm1DnueQ84Dyx2Ej4sX4IiIUxmbBPA94BwmxIOns63mEELQwU9rjXbkHYl1rPrzllm+oi2X30o9L00Mk0O4V1vv+ywkN0NnGtKX/qHL5xE29a4dNP2Thee8ul6AFI/AQthweH1gDOM4107twZHOgGX9CKhJAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgvge60wryAlQXdTOZ8xVsNoCv/JdYIlp+n674WUmSw=;
 b=j06R+tslqGS9NmomoyhtOHrc0Z1qHPfYg1cTTdwzecYH30DQklj+TCYyjVwlBdigVVar9x2ukt0CtfHTq61eQLYw8p8AV+ZPBU5JF5BnfcA/hLH/OOEvwxgF+UuS3/56CZq1o55k3OXsvX0LZTPhhxrNfmgQlE6yHwPqJqMcBDM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.14.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:45:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:45:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Handle "enable_roce" devlink param
Thread-Topic: [PATCH mlx5-next 3/5] net/mlx5: Handle "enable_roce" devlink
 param
Thread-Index: AQHVlo6XtUUORSfsyUeJu3QyViFU6A==
Date:   Fri, 8 Nov 2019 23:45:24 +0000
Message-ID: <20191108234451.31660-4-saeedm@mellanox.com>
References: <20191108234451.31660-1-saeedm@mellanox.com>
In-Reply-To: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81a32595-1267-4497-5973-08d764a5b982
x-ms-traffictypediagnostic: VI1PR05MB4334:|VI1PR05MB4334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43340AA0BF2149EA3445F67ABE7B0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(2616005)(102836004)(36756003)(450100002)(52116002)(486006)(71200400001)(1076003)(71190400001)(6636002)(107886003)(14454004)(4326008)(478600001)(110136005)(256004)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(6506007)(6116002)(8936002)(50226002)(3846002)(186003)(6436002)(6486002)(81156014)(446003)(8676002)(26005)(14444005)(2906002)(76176011)(305945005)(99286004)(6512007)(386003)(7736002)(66066001)(54906003)(11346002)(81166006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51JrzGce9d4HVYA5hcKARemN4AfuTITgwzYykRqOQRPz32hByrREC3MRblyJbehLPIVhbWmSrC3MiDct1cJGWVVFXw9gftdXD3Vh1J8VUfJWKuKVHaY444Ctyjgnh/lQNo5b0GteHvC1EhufuUhweKEaBzsbuXzaiLOP7W68Ih1yMgpwLIahXRpq1YjCeTwrZMQt57nFQvZawMnPHURaIiSAPLBLFpWPTR7Uaqglq8ECnBSosFF6+ekpw9bCScg5dP+R1Aeonahp1f/aNkY7Zxr3WB953zfSm1jfaw6ppPJh9ZM52KX4RpWbh+WDlk58FvX6sWBkKzw61F8hkGjKTFXmDUBjqGtlf19DwK+GLC8AIYgufTVR45cyCCfceux1oVf/5UDaTKpyDD02IPTNa1y/15sLOt7uQU6agKDMSU2Frr8zyjZILMFIEx6QcNbt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a32595-1267-4497-5973-08d764a5b982
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:45:24.4021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZpYYmVl3hAbTrmWuqSZoZedKU3JiyyK5+nnh+L043OIAuRJHvqxGiDcII06+63emq9/T1UvP/Oajk/XS190KxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Register "enable_roce" param, default value is RoCE enabled.
Current configuration is stored on mlx5_core_dev and exposed to user
through the cmode runtime devlink param.
Changing configuration requires changing the cmode driverinit devlink
param and calling devlink reload.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          | 21 ++++++++++++++++++
 .../networking/devlink-params-mlx5.txt        |  5 +++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 22 +++++++++++++++++++
 include/linux/mlx5/driver.h                   | 11 ++++++++++
 4 files changed, 59 insertions(+)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index d071c6b49e1f..7599dceba9f1 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -154,6 +154,27 @@ User command examples:
       values:
          cmode runtime value smfs
=20
+enable_roce: RoCE enablement state
+----------------------------------
+RoCE enablement state controls driver support for RoCE traffic.
+When RoCE is disabled, there is no gid table, only raw ethernet QPs are su=
pported and traffic on the well known UDP RoCE port is handled as raw ether=
net traffic.
+
+To change RoCE enablement state a user must change the driverinit cmode va=
lue and run devlink reload.
+
+User command examples:
+
+- Disable RoCE::
+
+    $ devlink dev param set pci/0000:06:00.0 name enable_roce value false =
cmode driverinit
+    $ devlink dev reload pci/0000:06:00.0
+
+- Read RoCE enablement state::
+
+    $ devlink dev param show pci/0000:06:00.0 name enable_roce
+      pci/0000:06:00.0:
+      name enable_roce type generic
+      values:
+         cmode driverinit value true
=20
 Devlink health reporters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/networking/devlink-params-mlx5.txt b/Documentati=
on/networking/devlink-params-mlx5.txt
index 8c0b82d655dc..5071467118bd 100644
--- a/Documentation/networking/devlink-params-mlx5.txt
+++ b/Documentation/networking/devlink-params-mlx5.txt
@@ -10,3 +10,8 @@ flow_steering_mode	[DEVICE, DRIVER-SPECIFIC]
 			without firmware intervention.
 			Type: String
 			Configuration mode: runtime
+
+enable_roce		[DEVICE, GENERIC]
+			Enable handling of RoCE traffic in the device.
+			Defaultly enabled.
+			Configuration mode: driverinit
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 381925c90d94..b2c26388edb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -177,12 +177,29 @@ enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
 };
=20
+static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 =
id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	bool new_state =3D val.vbool;
+
+	if (new_state && !MLX5_CAP_GEN(dev, roce)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct devlink_param mlx5_devlink_params[] =3D {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     mlx5_devlink_fs_mode_get, mlx5_devlink_fs_mode_set,
 			     mlx5_devlink_fs_mode_validate),
+	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_enable_roce_validate),
 };
=20
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -197,6 +214,11 @@ static void mlx5_devlink_set_params_init_values(struct=
 devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
 					   value);
+
+	value.vbool =3D MLX5_CAP_GEN(dev, roce);
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+					   value);
 }
=20
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7b4801e96feb..1884513aac90 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1191,4 +1191,15 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP =3D (u64)1 << 32,
 };
=20
+static inline bool mlx5_is_roce_enabled(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink =3D priv_to_devlink(dev);
+	union devlink_param_value val;
+
+	devlink_param_driverinit_value_get(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+					   &val);
+	return val.vbool;
+}
+
 #endif /* MLX5_DRIVER_H */
--=20
2.21.0

