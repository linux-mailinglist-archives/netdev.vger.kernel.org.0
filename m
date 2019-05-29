Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825092D398
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE2CIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:07 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbfE2CIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W8Afy0e4qppMNVw/E0YTP8ezek5e+0gYdlaWHnSk0c=;
 b=EKgylQFWBH77qh5JOnOouxNgbpMQZTjV6bYZodwu+WF79PxiU+CS/P5f3SMwCTRsjQV+BiSb60SB+BGiNcP+uZd8W8VBlDwCfq2EP/GGQKfBaTkX+mIVQfyRmeVaOUrBAOyxszuVxND5rbgjLDtlsVSVQX60JlfceyQOUmsG8DE=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:08:02 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:08:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/6] net/mlx5: Avoid double free in fs init error unwinding path
Thread-Topic: [net 3/6] net/mlx5: Avoid double free in fs init error unwinding
 path
Thread-Index: AQHVFcNYfbGXMIQ8gUSD6sJinbf02Q==
Date:   Wed, 29 May 2019 02:08:02 +0000
Message-ID: <20190529020737.4172-4-saeedm@mellanox.com>
References: <20190529020737.4172-1-saeedm@mellanox.com>
In-Reply-To: <20190529020737.4172-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64e5c9db-7509-43a8-9277-08d6e3da7ae5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB5947A5FE7E0E6DA8378070E1BE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(186003)(4326008)(476003)(68736007)(486006)(6512007)(446003)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(107886003)(76176011)(66066001)(64756008)(6916009)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WrY01xB3cfjE6YO8d4O9CeW33gQg0xDoZKem4D/Sf14oRzHR1AIlkP3yvgKouYZHcTN7nv1nnNlb/uStEB92mp6FTGcUEnre0V5y8Oykc1z70uivDTF/NP3tZ7xNqVNPPw9C19QOwNsPzZKOP3P1ZDqmO2fAj5AtyFVDqzgNzJ9j1Tl4BSVqdVaL77dxX6srMyH/nAnv4FQRrW/7zXnECXAqhvlotk+zDuFz8rl91cldoktBsDO1xbEIJos73Ak1u8hEY/NlDtNvGy+taRXI09WzxFB5EMUzyEgxBuZ+hIL80x7/sY0zJAQ9o5Zv1fY7vDFJCOwr7rr+lLLRMy335d8gGkBIQEN+d0HOhG/5avIZjEXgOMI0fVjrtvDqXASOGWv1NyIT6YS+bdwLvHWf+04TEzGgJqtmviUuNTjz9tw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e5c9db-7509-43a8-9277-08d6e3da7ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:08:02.7053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCkluIGJlbG93IGNvZGUg
ZmxvdywgZm9yIGluZ3Jlc3MgYWNsIHRhYmxlIHJvb3QgbnMgbWVtb3J5IGxlYWRzDQp0byBkb3Vi
bGUgZnJlZS4NCg0KbWx4NV9pbml0X2ZzDQogIGluaXRfaW5ncmVzc19hY2xzX3Jvb3RfbnMoKQ0K
ICAgIGluaXRfaW5ncmVzc19hY2xfcm9vdF9ucw0KICAgICAgIGtmcmVlKHN0ZWVyaW5nLT5lc3df
aW5ncmVzc19yb290X25zKTsNCiAgICAgICAvKiBzdGVlcmluZy0+ZXN3X2luZ3Jlc3Nfcm9vdF9u
cyBpcyBub3QgbWFya2VkIE5VTEwgKi8NCiAgbWx4NV9jbGVhbnVwX2ZzDQogICAgY2xlYW51cF9p
bmdyZXNzX2FjbHNfcm9vdF9ucw0KICAgICAgIHN0ZWVyaW5nLT5lc3dfaW5ncmVzc19yb290X25z
IG5vbiBOVUxMIGNoZWNrIHBhc3Nlcy4NCiAgICAgICBrZnJlZShzdGVlcmluZy0+ZXN3X2luZ3Jl
c3Nfcm9vdF9ucyk7DQogICAgICAgLyogZG91YmxlIGZyZWUgKi8NCg0KU2ltaWxhciBpc3N1ZSBl
eGlzdCBmb3Igb3RoZXIgdGFibGVzLg0KDQpIZW5jZSB6ZXJvIG91dCB0aGUgcG9pbnRlcnMgdG8g
bm90IHByb2Nlc3MgdGhlIHRhYmxlIGFnYWluLg0KDQpGaXhlczogOWI5M2FiOTgxZTNiZiAoIm5l
dC9tbHg1OiBTZXBhcmF0ZSBpbmdyZXNzL2VncmVzcyBuYW1lc3BhY2VzIGZvciBlYWNoIHZwb3J0
IikNCkZpeGVzOiA0MGMzZWViYjQ5ZTUxICgibmV0L21seDU6IEFkZCBzdXBwb3J0IGluIFJETUEg
Ulggc3RlZXJpbmciKQ0KU2lnbmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5v
eC5jb20+DQpSZXZpZXdlZC1ieTogTWFyayBCbG9jaCA8bWFya2JAbWVsbGFub3guY29tPg0KU2ln
bmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5jIHwgNCArKysr
DQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmMNCmluZGV4IDRmYTg3Y2E2M2Jj
YS4uMzQyNzZhMmI2ZGEyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2ZzX2NvcmUuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2ZzX2NvcmUuYw0KQEAgLTI0MjcsNiArMjQyNyw3IEBAIHN0YXRpYyB2b2lk
IGNsZWFudXBfZWdyZXNzX2FjbHNfcm9vdF9ucyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0K
IAkJY2xlYW51cF9yb290X25zKHN0ZWVyaW5nLT5lc3dfZWdyZXNzX3Jvb3RfbnNbaV0pOw0KIA0K
IAlrZnJlZShzdGVlcmluZy0+ZXN3X2VncmVzc19yb290X25zKTsNCisJc3RlZXJpbmctPmVzd19l
Z3Jlc3Nfcm9vdF9ucyA9IE5VTEw7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGNsZWFudXBfaW5ncmVz
c19hY2xzX3Jvb3RfbnMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCkBAIC0yNDQxLDYgKzI0
NDIsNyBAQCBzdGF0aWMgdm9pZCBjbGVhbnVwX2luZ3Jlc3NfYWNsc19yb290X25zKHN0cnVjdCBt
bHg1X2NvcmVfZGV2ICpkZXYpDQogCQljbGVhbnVwX3Jvb3RfbnMoc3RlZXJpbmctPmVzd19pbmdy
ZXNzX3Jvb3RfbnNbaV0pOw0KIA0KIAlrZnJlZShzdGVlcmluZy0+ZXN3X2luZ3Jlc3Nfcm9vdF9u
cyk7DQorCXN0ZWVyaW5nLT5lc3dfaW5ncmVzc19yb290X25zID0gTlVMTDsNCiB9DQogDQogdm9p
ZCBtbHg1X2NsZWFudXBfZnMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCkBAIC0yNjI1LDYg
KzI2MjcsNyBAQCBzdGF0aWMgaW50IGluaXRfZWdyZXNzX2FjbHNfcm9vdF9ucyhzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2KQ0KIAlmb3IgKGktLTsgaSA+PSAwOyBpLS0pDQogCQljbGVhbnVwX3Jv
b3RfbnMoc3RlZXJpbmctPmVzd19lZ3Jlc3Nfcm9vdF9uc1tpXSk7DQogCWtmcmVlKHN0ZWVyaW5n
LT5lc3dfZWdyZXNzX3Jvb3RfbnMpOw0KKwlzdGVlcmluZy0+ZXN3X2VncmVzc19yb290X25zID0g
TlVMTDsNCiAJcmV0dXJuIGVycjsNCiB9DQogDQpAQCAtMjY1Miw2ICsyNjU1LDcgQEAgc3RhdGlj
IGludCBpbml0X2luZ3Jlc3NfYWNsc19yb290X25zKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYp
DQogCWZvciAoaS0tOyBpID49IDA7IGktLSkNCiAJCWNsZWFudXBfcm9vdF9ucyhzdGVlcmluZy0+
ZXN3X2luZ3Jlc3Nfcm9vdF9uc1tpXSk7DQogCWtmcmVlKHN0ZWVyaW5nLT5lc3dfaW5ncmVzc19y
b290X25zKTsNCisJc3RlZXJpbmctPmVzd19pbmdyZXNzX3Jvb3RfbnMgPSBOVUxMOw0KIAlyZXR1
cm4gZXJyOw0KIH0NCiANCi0tIA0KMi4yMS4wDQoNCg==
