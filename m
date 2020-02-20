Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C6165504
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBTC0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:26:02 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgBTC0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:26:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuKQeG8GE4/tHVpA3yWNPX/YF4m/WzSp8kIiAXyZTFFCbBjCk/yb0ktG6ua1DPfY6/wVkpqH++Rs5+OIgYk90EQoLXhtd42hpnSrUQjvr1T3jqmmYnOhnirUPclFFX4GD5dh3uh+Bf/Nqxk2UuaG6SJqQ/9uD0JhwkRy7reRMn2wfsL48cpK+flCU2Bo6IRY9mGdtK4m7HKOlPGphr+SjQe5jr4bYU/vyWLcXFdyX6IHJwFjmHDQsOaif3asY5HoIqpyRn4T/ReMyTEFto80XKtID46JThHiCi0PmN7JPdP5xicqIbmtVV+4EmvovUJwzaO823LbOAVpsrQPRcN+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqHgInEzIVKrQ50Hfb3yumWR7zyw3ZfCXykIOTjERCQ=;
 b=CPk4HYlghY00iBkikMVcNjiJt1iVBLZ7sw/7FvRUeWz1MUhj3u4seukBTo0+4xYTa8/M/hO4QZDVkJUZ/oO+it7m0lZbT0nced7kWABg3ow219V/q91Z+sl1WbrOwZIO69MRXkNe3LPnDOmBBGzUR5HX8wTagI3loXj6vr0MmV8gwsf1wRTM3tQGd4RcUEwP/mnXj3jzeTLeSvEH/icvXr/gyAr0VQFCvLO5N5PE7cw35zwUOeej/QxNtnD++unmPmta0Gw8+GCzwzoWANLFi4sgC9EBoG9ljoagcpr0Ej8h4azxtuPVyXZSYn8Ixiu42P4pS2rqM8cZD81QQYLNUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqHgInEzIVKrQ50Hfb3yumWR7zyw3ZfCXykIOTjERCQ=;
 b=b6eSfSbdVKdltUalVoYlwjcvpz4GBIfw+Pnqrh99gIsNARw44ciujn6DPSRDulbAxtRnh44zV3fqjSm0dtKXsXyELb1wc8ku8Y6y80P26N3eB/+rsqTtc+tdpnKLyGd+Chh9HCPTlyN2IdAYpjCZAI4/Ik91k+YeSWfN3X/BURs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:55 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 6/7] net/mlxfw: Add reactivate flow support to FSM
 burn flow
Thread-Topic: [PATCH net-next 6/7] net/mlxfw: Add reactivate flow support to
 FSM burn flow
Thread-Index: AQHV55UUl3+0pqx360O1hrNERl4EzQ==
Date:   Thu, 20 Feb 2020 02:25:55 +0000
Message-ID: <20200220022502.38262-7-saeedm@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
In-Reply-To: <20200220022502.38262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d70bf70e-42d5-400f-b912-08d7b5ac36c9
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB41737EA7BE5AA3F4CBBF2D08BE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NPz8zxt4FWQdF6pEAoWfsciUDxJrfgcakql4BPFc5gT0EtV9V+YmGxWKofeheMIfe/smtxMMw9hh33RhzAHHNrmMsTEJRRk6/ze0NpWKdlqWTtFoPXTQtKwtSPLbRTERsqQuCIx/72kUhOYlxrQSWIq9B0ZdISPIh8M2KXcDRsWJyVFO0hu5Ia2H/RnAkL1a7hQYzZrJgBmWCYTjIjev+ondm8vgzEapSzYYGaQbuGuBl6VVyMxAOzshpLVQiEnWyAy96egDm0vGMZSuo6iLBmwYz4VH9uGmWWMRhf+f5VvFQ4WXy6L9QQNYxRzU6ekBEmJr9MjVTY5RU+ukZX2OgAoOEqOyI+/hG+ZtiO3iumRW0Bs/0PPx27321OFcz2Cs9Gnjlu1WaCJg8t+Omc0nQksdZ4trtygfnS1t4h0eUOOHLprxaDmXyEGnmKRKpLiMqntENsdhsbCRwlxiCnjdHpYLWSDgOdxSc2xLqqET8baG8HlvI1QGTFDHNl5OVskIuTUjIYLX8FxKBio60i12GgM38fn11kUXBGOTuowu9jY=
x-ms-exchange-antispam-messagedata: ORnjuNkMNiS5fmoBQiRteZLmkz/b6T6fiNAn9aba7r7gQn7khcnuZtDgJ882ZXqb32O0KcBBlGJKPQoczE3mmmgQj6VkgBLz82bio2ukgBrxPO2bKH5CHqbJPw3JzVY5X0EfG+kV1K1sOTtWCOG/zA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d70bf70e-42d5-400f-b912-08d7b5ac36c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:55.6235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KveCa98hLN1cLTxc006JZD7E/FtdPP98EOvoHfUiPK7tVF5pImZ7vBbB1GBTm+hl/OS2RKQilgKZbQ0hP11Qog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Expose fsm_reactivate callback to the mlxfw_dev_ops struct. FSM reactivate
is needed before flashing the new image in order to flush the old flashed
but not running firmware image.

In case mlxfw_dev do not support the reactivation, this step will be
skipped. But if later image flash will fail, a hint will be provided by
the extack to advise the user that the failure might be related to it.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  16 +++
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 107 +++++++++++++++++-
 2 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethe=
rnet/mellanox/mlxfw/mlxfw.h
index a0a63e0c5aca..7654841a05c2 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -55,6 +55,20 @@ enum mlxfw_fsm_state_err {
 	MLXFW_FSM_STATE_ERR_MAX,
 };
=20
+enum mlxfw_fsm_reactivate_status {
+	MLXFW_FSM_REACTIVATE_STATUS_OK,
+	MLXFW_FSM_REACTIVATE_STATUS_BUSY,
+	MLXFW_FSM_REACTIVATE_STATUS_PROHIBITED_FW_VER_ERR,
+	MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_COPY_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_ERASE_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_RESTORE_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_CANDIDATE_FW_DEACTIVATION_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED,
+	MLXFW_FSM_REACTIVATE_STATUS_ERR_DEVICE_RESET_REQUIRED,
+	MLXFW_FSM_REACTIVATE_STATUS_ERR_FW_PROGRAMMING_NEEDED,
+	MLXFW_FSM_REACTIVATE_STATUS_MAX,
+};
+
 struct mlxfw_dev_ops {
 	int (*component_query)(struct mlxfw_dev *mlxfw_dev, u16 component_index,
 			       u32 *p_max_size, u8 *p_align_bits,
@@ -73,6 +87,8 @@ struct mlxfw_dev_ops {
=20
 	int (*fsm_activate)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
=20
+	int (*fsm_reactivate)(struct mlxfw_dev *mlxfw_dev, u8 *status);
+
 	int (*fsm_query_state)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 			       enum mlxfw_fsm_state *fsm_state,
 			       enum mlxfw_fsm_state_err *fsm_state_err);
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index c186924c2cfd..026cf201c26e 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -114,6 +114,84 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxf=
w_dev, u32 fwhandle,
 	return 0;
 }
=20
+static int
+mlxfw_fsm_reactivate_err(struct mlxfw_dev *mlxfw_dev,
+			 struct netlink_ext_ack *extack, u8 err)
+{
+	enum mlxfw_fsm_reactivate_status status;
+
+#define MXFW_REACT_PRFX "Reactivate FSM: "
+#define MLXFW_REACT_ERR(msg, err) \
+	MLXFW_ERR_MSG(mlxfw_dev, extack, MXFW_REACT_PRFX msg, err)
+
+	status =3D min_t(enum mlxfw_fsm_reactivate_status, err,
+		       MLXFW_FSM_REACTIVATE_STATUS_MAX);
+
+	switch (status) {
+	case MLXFW_FSM_REACTIVATE_STATUS_BUSY:
+		MLXFW_REACT_ERR("busy", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_PROHIBITED_FW_VER_ERR:
+		MLXFW_REACT_ERR("prohibited fw ver", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_COPY_FAILED:
+		MLXFW_REACT_ERR("first page copy failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_ERASE_FAILED:
+		MLXFW_REACT_ERR("first page erase failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_RESTORE_FAILED:
+		MLXFW_REACT_ERR("first page restore failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_CANDIDATE_FW_DEACTIVATION_FAILED:
+		MLXFW_REACT_ERR("candidate fw deactivation failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_ERR_DEVICE_RESET_REQUIRED:
+		MLXFW_REACT_ERR("device reset required", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_ERR_FW_PROGRAMMING_NEEDED:
+		MLXFW_REACT_ERR("fw progamming needed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED:
+		MLXFW_REACT_ERR("fw already activated", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_OK: /* fall through */
+	case MLXFW_FSM_REACTIVATE_STATUS_MAX:
+		MLXFW_REACT_ERR("unexpected error", err);
+		break;
+	};
+	return -EREMOTEIO;
+};
+
+static int mlxfw_fsm_reactivate(struct mlxfw_dev *mlxfw_dev,
+				struct netlink_ext_ack *extack,
+				bool *supported)
+{
+	u8 status;
+	int err;
+
+	if (!mlxfw_dev->ops->fsm_reactivate)
+		return 0;
+
+	err =3D mlxfw_dev->ops->fsm_reactivate(mlxfw_dev, &status);
+	if (err =3D=3D -EOPNOTSUPP) {
+		*supported =3D false;
+		return 0;
+	}
+
+	if (err) {
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not reactivate firmware flash", err);
+		return err;
+	}
+
+	if (status =3D=3D MLXFW_FSM_REACTIVATE_STATUS_OK ||
+	    status =3D=3D MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED)
+		return 0;
+
+	return mlxfw_fsm_reactivate_err(mlxfw_dev, extack, status);
+}
+
 static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_dev,
 				const char *msg, const char *comp_name,
 				u32 done_bytes, u32 total_bytes)
@@ -129,6 +207,7 @@ static void mlxfw_status_notify(struct mlxfw_dev *mlxfw=
_dev,
 static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 				 u32 fwhandle,
 				 struct mlxfw_mfa2_component *comp,
+				 bool reactivate_supp,
 				 struct netlink_ext_ack *extack)
 {
 	u16 comp_max_write_size;
@@ -166,8 +245,13 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 						   comp->index,
 						   comp->data_size);
 	if (err) {
-		MLXFW_ERR_MSG(mlxfw_dev, extack,
-			      "FSM component update failed", err);
+		if (!reactivate_supp)
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "FSM component update failed, FW reactivate is not suppoerted",
+				      err);
+		else
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "FSM component update failed", err);
 		return err;
 	}
=20
@@ -221,6 +305,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
=20
 static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandl=
e,
 				  struct mlxfw_mfa2_file *mfa2_file,
+				  bool reactivate_supp,
 				  struct netlink_ext_ack *extack)
 {
 	u32 component_count;
@@ -250,7 +335,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
=20
 		mlxfw_info(mlxfw_dev, "Flashing component type %d\n",
 			   comp->index);
-		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp, extack);
+		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp,
+					    reactivate_supp, extack);
 		mlxfw_mfa2_file_component_put(comp);
 		if (err)
 			return err;
@@ -263,6 +349,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 			 struct netlink_ext_ack *extack)
 {
 	struct mlxfw_mfa2_file *mfa2_file;
+	bool reactivate_supp =3D true;
 	u32 fwhandle;
 	int err;
=20
@@ -296,7 +383,17 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	if (err)
 		goto err_state_wait_idle_to_locked;
=20
-	err =3D mlxfw_flash_components(mlxfw_dev, fwhandle, mfa2_file, extack);
+	err =3D mlxfw_fsm_reactivate(mlxfw_dev, extack, &reactivate_supp);
+	if (err)
+		goto err_fsm_reactivate;
+
+	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
+				   MLXFW_FSM_STATE_LOCKED, extack);
+	if (err)
+		goto err_state_wait_reactivate_to_locked;
+
+	err =3D mlxfw_flash_components(mlxfw_dev, fwhandle, mfa2_file,
+				     reactivate_supp, extack);
 	if (err)
 		goto err_flash_components;
=20
@@ -326,6 +423,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 err_state_wait_activate_to_locked:
 err_fsm_activate:
 err_flash_components:
+err_state_wait_reactivate_to_locked:
+err_fsm_reactivate:
 err_state_wait_idle_to_locked:
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
 err_fsm_lock:
--=20
2.24.1

