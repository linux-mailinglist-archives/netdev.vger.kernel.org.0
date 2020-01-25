Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4EB14936B
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAYFLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:10 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:6185
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgAYFLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2DNCI1vCqqVKiGy7DqBtzlEZEW3PyJhsbBNX2dGNPqjpPk9bDNRwkQLV8HMGBKdpn1FY4ccHkRvEHzlPkqqBLTqNFe5LkLVG2oqUZ42XfrlurgEEJR624k27i4RV+x97H9FkdQanPsoXsUGFH9yoFXtbTC1hbjViVrlElOlCZdA3mh9avqKwcdoF5PcJ5DfpU4BuRxgUCPdJgqdWZgwf9aMWQt6G38jphgLT+7FvJm4jhcTjTTljo6dDvTRMC0+s5xl/9hutdNrOhpQuOx3KRhNhoMNRNsn3ziLok9plmi8J+xYbyW3GDGo+Rz+VtdjD1qTISBFpI2HQycMZbI9TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCeNy6b4TcKibeMNX4Kg5vAszUhedG0Jv0DMP5Q7akQ=;
 b=kTr7DXnncMyYSw08Y5w30FLYvW8oF8mtqS5yNcG+hHp9LXl+IYr1jYLI1INaPZK0qYVVLFY7RxJUZ+/6dyxkrrFgdhw5DmURwnsv7I0LDwxA0EtJN/UMBPUDtvp0wevPb0bBIJ4DM9JLTEG1cm6jBqXXCU9k/++4fkpH9PaG2HJwkJl0LkDm/N9C+iIgET8364ses5hGJGs07v4U64HmqSy/IGTuV75a1uNsY7YwYWblh36fNtL/NHI+61sFSCC3EwyzPpeEw3v4mMX/9XqRk9RbQReBySD+IcEP5DkgxwnHbBJWZqJGEaau4IaxzmG/ai0hovh+vPV0LqSiF0eOvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCeNy6b4TcKibeMNX4Kg5vAszUhedG0Jv0DMP5Q7akQ=;
 b=LkG5acORoTw6z2o1DiTDF4fGjB1BmrJWF5nbQCb0mBx24rmnTOBY6s6011wM4DlqpM0wBUi2popvY/8Jp8OLcsLSXwW0dGBUXIj9XqkVoVebgfLPRAFngjVvsQdH1NErvZ1nnnWimt4Qj8gE/2Pul5261dFX6V3IR+Ny90PLOkQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:05 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:10:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 01/14] devlink: Force enclosing array on binary fmsg
 data
Thread-Topic: [net-next V2 01/14] devlink: Force enclosing array on binary
 fmsg data
Thread-Index: AQHV0z3XZ26Q/VdgIk63MTdja7K5aA==
Date:   Sat, 25 Jan 2020 05:11:04 +0000
Message-ID: <20200125051039.59165-2-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
In-Reply-To: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 759c4b77-24d8-41eb-383c-08d7a154f86d
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB039440A41FE398F28B7F7E30BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BCxJC35wdi2JQVYpx4s3BdiKdB3vug4fXABQb9T4TafYFxKmEb+24NT4R/ysuGIEIHB/aACozHdwvEia+5iNwM1hF+iAyEwNjAAPz2mIrc7vDBVBrudi8F0eS9MqqmobTwh9GuriNAc0RQVv+G55a8Txth9/fhFjjhXWaAEqfGDvjFhWBBbVC3YxNk3NQUuh3u4AaLMgbm8qrObxBMt7+nrUhF2eZtBDQoRWWBrqqGnXMNO6w6lvt0kq2gvr67O+WMeUXD7yaVMYgDXcMYAIzlogTncZjc+jiJeuN2w01Si/odNkCSyfMBDcZtr32me86L10QyWEVeY76TDF0aqNkWuS+1pVpoaTs0N/AFKQNiNi8YCuxJzBEHT7b4TV1jVlasYFbmE/1ZBsgDjFL0oKviE9T0dx7BnExyMqm06zxCfCrTZF1BOc1j5d7rDjIL0xQCv/Y5qJF4JLXExCXJhY455RwTHEt/u5FjVAnh9VISh6/o2hoE6uPLUoSh3CPPe0ZffkSAtrhvfWsnk1P7AnDe497ZEBkMCQkxdv+PEzy0k=
x-ms-exchange-antispam-messagedata: Q4Qn4qsdR7Lz73mhlPohVM2UROv7B0hpYe1HRbab/F1v+4oiFLct7f9V83jSOjd7npK67nLhHDY4+EHKBwgdIRQjuXrLT+l/BHEf8/X1Qq3dBuOzw1p8pAJR0nO4ohgFZLONWAw9T8Z2HBWQ9QHFAA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759c4b77-24d8-41eb-383c-08d7a154f86d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:04.8446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mUiRBMMfC4OhRZ79E9lC/fmg41rz2cGAq4KwK2nM9RETHvWkyqQ5l7tjZVcjL51zXv/DqKQ6AaqPGcuXE1GF3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add a new API for start/end binary array brackets [] to force array
around binary data as required from JSON. With this restriction, re-open
API to set binary fmsg data.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/devlink.h |  5 +++
 net/core/devlink.c    | 94 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5e46c24bb6e6..182a5e69355b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -979,12 +979,17 @@ int devlink_fmsg_pair_nest_end(struct devlink_fmsg *f=
msg);
 int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
 				     const char *name);
 int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg);
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name);
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg);
=20
 int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value);
 int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value);
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value);
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value);
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value);
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len);
=20
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name=
,
 			       bool value);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 64367eeb21e6..4791dd8f9917 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4231,6 +4231,12 @@ struct devlink_fmsg_item {
=20
 struct devlink_fmsg {
 	struct list_head item_list;
+	bool putting_binary; /* This flag forces enclosing of binary data
+			      * in an array brackets. It forces using
+			      * of designated API:
+			      * devlink_fmsg_binary_pair_nest_start()
+			      * devlink_fmsg_binary_pair_nest_end()
+			      */
 };
=20
 static struct devlink_fmsg *devlink_fmsg_alloc(void)
@@ -4274,17 +4280,26 @@ static int devlink_fmsg_nest_common(struct devlink_=
fmsg *fmsg,
=20
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
=20
 static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
 }
=20
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
@@ -4295,6 +4310,9 @@ static int devlink_fmsg_put_name(struct devlink_fmsg =
*fmsg, const char *name)
 {
 	struct devlink_fmsg_item *item;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
 		return -EMSGSIZE;
=20
@@ -4315,6 +4333,9 @@ int devlink_fmsg_pair_nest_start(struct devlink_fmsg =
*fmsg, const char *name)
 {
 	int err;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err =3D devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START)=
;
 	if (err)
 		return err;
@@ -4329,6 +4350,9 @@ EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
=20
 int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
@@ -4338,6 +4362,9 @@ int devlink_fmsg_arr_pair_nest_start(struct devlink_f=
msg *fmsg,
 {
 	int err;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err =3D devlink_fmsg_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
@@ -4354,6 +4381,9 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fms=
g *fmsg)
 {
 	int err;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err =3D devlink_fmsg_nest_end(fmsg);
 	if (err)
 		return err;
@@ -4366,6 +4396,30 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fm=
sg *fmsg)
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
=20
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name)
+{
+	int err;
+
+	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	fmsg->putting_binary =3D true;
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
+
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	fmsg->putting_binary =3D false;
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
+
 static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
 				  const void *value, u16 value_len,
 				  u8 value_nla_type)
@@ -4390,40 +4444,59 @@ static int devlink_fmsg_put_value(struct devlink_fm=
sg *fmsg,
=20
 int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_bool_put);
=20
 int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u8_put);
=20
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
=20
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u64_put);
=20
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
 				      NLA_NUL_STRING);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
=20
-static int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *=
value,
-				   u16 value_len)
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len)
 {
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
 }
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
=20
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name=
,
 			       bool value)
@@ -4534,10 +4607,11 @@ int devlink_fmsg_binary_pair_put(struct devlink_fms=
g *fmsg, const char *name,
 				 const void *value, u32 value_len)
 {
 	u32 data_size;
+	int end_err;
 	u32 offset;
 	int err;
=20
-	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	err =3D devlink_fmsg_binary_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
=20
@@ -4547,14 +4621,18 @@ int devlink_fmsg_binary_pair_put(struct devlink_fms=
g *fmsg, const char *name,
 			data_size =3D DEVLINK_FMSG_MAX_SIZE;
 		err =3D devlink_fmsg_binary_put(fmsg, value + offset, data_size);
 		if (err)
-			return err;
+			break;
+		/* Exit from loop with a break (instead of
+		 * return) to make sure putting_binary is turned off in
+		 * devlink_fmsg_binary_pair_nest_end
+		 */
 	}
=20
-	err =3D devlink_fmsg_arr_pair_nest_end(fmsg);
-	if (err)
-		return err;
+	end_err =3D devlink_fmsg_binary_pair_nest_end(fmsg);
+	if (end_err)
+		err =3D end_err;
=20
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
=20
--=20
2.24.1

