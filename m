Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939253C00C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390853AbfFJXiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:52 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:22416
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390524AbfFJXiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzMq2PAunOc3HDfUvrxqFvTIMEw3skbMuHAZRJFjYrc=;
 b=YqCDhcBqJbsV85WFp4xGP3rpTsUdlj6h6yb1PbrvriG0dFJ0RAMXn2q0N32Om/4PpfL7cW9sFwYRDg5s/TfaxRwvLxHQWF9gCC9LjeZsgIDKcfk8e5CDU4p1zNOwgPkGDlyb2uYu3vbkCECPMk70mrzGQ5XnyEL/1WgxbMT3alk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:33 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 11/16] net/mlx5: Separate IRQ table creation from EQ
 table creation
Thread-Topic: [PATCH mlx5-next 11/16] net/mlx5: Separate IRQ table creation
 from EQ table creation
Thread-Index: AQHVH+WdxbxpJJUTrkq2rNp1FA/9gg==
Date:   Mon, 10 Jun 2019 23:38:32 +0000
Message-ID: <20190610233733.12155-12-saeedm@mellanox.com>
References: <20190610233733.12155-1-saeedm@mellanox.com>
In-Reply-To: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2aacb814-6ffb-46c6-7b57-08d6edfcbfc3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB2166F9503F24C9284CAC4493BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(450100002)(85306007)(53936002)(6512007)(14454004)(50226002)(2616005)(186003)(256004)(81166006)(486006)(6436002)(11346002)(8676002)(8936002)(25786009)(476003)(14444005)(52116002)(446003)(2906002)(478600001)(99286004)(81156014)(4326008)(6486002)(107886003)(71200400001)(5660300002)(66446008)(64756008)(305945005)(66946007)(386003)(6506007)(7736002)(26005)(76176011)(71190400001)(102836004)(66476007)(86362001)(73956011)(66556008)(110136005)(6636002)(36756003)(54906003)(3846002)(6116002)(316002)(1076003)(66066001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O9h8v3+kj7XjJexSKoHI5Grhxva2a9jf9CA1pVjFiwEmk6PbydsEX2/nqu/4HtZY73g2Qv4HaEvkbvVM45RmRECSYM3iOTcFJkdJ7RQioH9wOXO3dn0CSuMAREER0NVWoQGeOGKz/iJw5FJo9TE/bcdfG2Xtu1qMzke1E0CjhacuPbyGe8bj/ctRYYa+G1pPR+edMimHWe30t41R+BWxzVEUKAQ68S8KSoWmpWj+/iAJNKXrRgRZFADmaN+6FD0+j3/Mnt99HwWkbN+8QVhEc3FdpX2DpE4MyPcoJA7Ai4ID3kZlHN117o2E2jNfP1ISbjpGlz3VPWeCRvZzejY99dTob1NT0WxJxtcgtDgqPY5vT94U21MqQ2mq/xg17lA1WoK8obwRMdukW/y4KTQHP9rrShvkak0lTJBU2T7hcKo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aacb814-6ffb-46c6-7b57-08d6edfcbfc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:32.8187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXV2YWwgQXZuZXJ5IDx5dXZhbGF2QG1lbGxhbm94LmNvbT4NCg0KSVJRIGFsbG9jYXRp
b24gc2hvdWxkIGJlIHBhcnQgb2YgdGhlIElSUSB0YWJsZSBsaWZlLWN5Y2xlLg0KDQpTaWduZWQt
b2ZmLWJ5OiBZdXZhbCBBdm5lcnkgPHl1dmFsYXZAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6
IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyAgfCAyMiArKystLS0tLS0tLS0tLS0tLS0tDQogLi4u
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jICAgIHwgIDkgKysrKysrKysN
CiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oICAgfCAgMiArKw0K
IDMgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jDQppbmRleCBkMzBi
ZDAxY2YwNTAuLmRhZjliYzMxNTVjYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lcS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZXEuYw0KQEAgLTEwNTYsMTggKzEwNTYsMTAgQEAgc3RydWN0IG1seDVf
ZXFfY29tcCAqbWx4NV9lcW4yY29tcF9lcShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBpbnQg
ZXFuKQ0KIHZvaWQgbWx4NV9jb3JlX2VxX2ZyZWVfaXJxcyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2KQ0KIHsNCiAJc3RydWN0IG1seDVfZXFfdGFibGUgKnRhYmxlID0gZGV2LT5wcml2LmVxX3Rh
YmxlOw0KLQlpbnQgaSwgbWF4X2VxczsNCiANCi0JY2xlYXJfY29tcF9pcnFzX2FmZmluaXR5X2hp
bnRzKGRldik7DQotCWlycV9jbGVhcl9ybWFwKGRldik7DQogCW11dGV4X2xvY2soJnRhYmxlLT5s
b2NrKTsgLyogc3luYyB3aXRoIGNyZWF0ZS9kZXN0cm95X2FzeW5jX2VxICovDQotCW1heF9lcXMg
PSB0YWJsZS0+bnVtX2NvbXBfZXFzICsgTUxYNV9FUV9WRUNfQ09NUF9CQVNFOw0KLQlmb3IgKGkg
PSBtYXhfZXFzIC0gMTsgaSA+PSAwOyBpLS0pIHsNCi0JCWZyZWVfaXJxKHBjaV9pcnFfdmVjdG9y
KGRldi0+cGRldiwgaSksDQotCQkJICZtbHg1X2lycV9nZXQoZGV2LCBpKS0+bmgpOw0KLQl9DQor
CW1seDVfaXJxX3RhYmxlX2Rlc3Ryb3koZGV2KTsNCiAJbXV0ZXhfdW5sb2NrKCZ0YWJsZS0+bG9j
ayk7DQotCXBjaV9mcmVlX2lycV92ZWN0b3JzKGRldi0+cGRldik7DQogfQ0KIA0KIHN0YXRpYyB2
b2lkIHVucmVxdWVzdF9pcnFzKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQpAQCAtMTA4MCw3
ICsxMDcyLDcgQEAgc3RhdGljIHZvaWQgdW5yZXF1ZXN0X2lycXMoc3RydWN0IG1seDVfY29yZV9k
ZXYgKmRldikNCiAJCQkgJm1seDVfaXJxX2dldChkZXYsIGkpLT5uaCk7DQogfQ0KIA0KLXN0YXRp
YyBpbnQgYWxsb2NfaXJxX3ZlY3RvcnMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCitpbnQg
bWx4NV9pcnFfdGFibGVfY3JlYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogew0KIAlz
dHJ1Y3QgbWx4NV9wcml2ICpwcml2ID0gJmRldi0+cHJpdjsNCiAJc3RydWN0IG1seDVfaXJxX3Rh
YmxlICp0YWJsZSA9IHByaXYtPmlycV90YWJsZTsNCkBAIC0xMTM0LDcgKzExMjYsNyBAQCBzdGF0
aWMgaW50IGFsbG9jX2lycV92ZWN0b3JzKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogCXJl
dHVybiBlcnI7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIGZyZWVfaXJxX3ZlY3RvcnMoc3RydWN0IG1s
eDVfY29yZV9kZXYgKmRldikNCit2b2lkIG1seDVfaXJxX3RhYmxlX2Rlc3Ryb3koc3RydWN0IG1s
eDVfY29yZV9kZXYgKmRldikNCiB7DQogCXN0cnVjdCBtbHg1X2lycV90YWJsZSAqdGFibGUgPSBk
ZXYtPnByaXYuaXJxX3RhYmxlOw0KIAlpbnQgaTsNCkBAIC0xMTU3LDEyICsxMTQ5LDYgQEAgaW50
IG1seDVfZXFfdGFibGVfY3JlYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogCXN0cnVj
dCBtbHg1X2VxX3RhYmxlICplcV90YWJsZSA9IGRldi0+cHJpdi5lcV90YWJsZTsNCiAJaW50IGVy
cjsNCiANCi0JZXJyID0gYWxsb2NfaXJxX3ZlY3RvcnMoZGV2KTsNCi0JaWYgKGVycikgew0KLQkJ
bWx4NV9jb3JlX2VycihkZXYsICJGYWlsZWQgdG8gY3JlYXRlIElSUSB2ZWN0b3JzXG4iKTsNCi0J
CXJldHVybiBlcnI7DQotCX0NCi0NCiAJZXFfdGFibGUtPm51bV9jb21wX2VxcyA9DQogCQltbHg1
X2lycV9nZXRfbnVtX2NvbXAoZXFfdGFibGUtPmlycV90YWJsZSk7DQogDQpAQCAtMTE4Miw3ICsx
MTY4LDYgQEAgaW50IG1seDVfZXFfdGFibGVfY3JlYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpk
ZXYpDQogZXJyX2NvbXBfZXFzOg0KIAlkZXN0cm95X2FzeW5jX2VxcyhkZXYpOw0KIGVycl9hc3lu
Y19lcXM6DQotCWZyZWVfaXJxX3ZlY3RvcnMoZGV2KTsNCiAJcmV0dXJuIGVycjsNCiB9DQogDQpA
QCAtMTE5MCw3ICsxMTc1LDYgQEAgdm9pZCBtbHg1X2VxX3RhYmxlX2Rlc3Ryb3koc3RydWN0IG1s
eDVfY29yZV9kZXYgKmRldikNCiB7DQogCWRlc3Ryb3lfY29tcF9lcXMoZGV2KTsNCiAJZGVzdHJv
eV9hc3luY19lcXMoZGV2KTsNCi0JZnJlZV9pcnFfdmVjdG9ycyhkZXYpOw0KIH0NCiANCiBpbnQg
bWx4NV9lcV9ub3RpZmllcl9yZWdpc3RlcihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBzdHJ1
Y3QgbWx4NV9uYiAqbmIpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9tYWluLmMNCmluZGV4IGJlNzlkY2VlYTNjMy4uYmZjOGM2ZmFlZGMyIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KQEAgLTEwNDcs
NiArMTA0NywxMiBAQCBzdGF0aWMgaW50IG1seDVfbG9hZChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2KQ0KIAltbHg1X2V2ZW50c19zdGFydChkZXYpOw0KIAltbHg1X3BhZ2VhbGxvY19zdGFydChk
ZXYpOw0KIA0KKwllcnIgPSBtbHg1X2lycV90YWJsZV9jcmVhdGUoZGV2KTsNCisJaWYgKGVycikg
ew0KKwkJbWx4NV9jb3JlX2VycihkZXYsICJGYWlsZWQgdG8gYWxsb2MgSVJRc1xuIik7DQorCQln
b3RvIGVycl9pcnFfdGFibGU7DQorCX0NCisNCiAJZXJyID0gbWx4NV9lcV90YWJsZV9jcmVhdGUo
ZGV2KTsNCiAJaWYgKGVycikgew0KIAkJbWx4NV9jb3JlX2VycihkZXYsICJGYWlsZWQgdG8gY3Jl
YXRlIEVRc1xuIik7DQpAQCAtMTExOCw2ICsxMTI0LDggQEAgc3RhdGljIGludCBtbHg1X2xvYWQo
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCiBlcnJfZndfdHJhY2VyOg0KIAltbHg1X2VxX3Rh
YmxlX2Rlc3Ryb3koZGV2KTsNCiBlcnJfZXFfdGFibGU6DQorCW1seDVfaXJxX3RhYmxlX2Rlc3Ry
b3koZGV2KTsNCitlcnJfaXJxX3RhYmxlOg0KIAltbHg1X3BhZ2VhbGxvY19zdG9wKGRldik7DQog
CW1seDVfZXZlbnRzX3N0b3AoZGV2KTsNCiAJbWx4NV9wdXRfdWFyc19wYWdlKGRldiwgZGV2LT5w
cml2LnVhcik7DQpAQCAtMTEzNCw2ICsxMTQyLDcgQEAgc3RhdGljIHZvaWQgbWx4NV91bmxvYWQo
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCiAJbWx4NV9mcGdhX2RldmljZV9zdG9wKGRldik7
DQogCW1seDVfZndfdHJhY2VyX2NsZWFudXAoZGV2LT50cmFjZXIpOw0KIAltbHg1X2VxX3RhYmxl
X2Rlc3Ryb3koZGV2KTsNCisJbWx4NV9pcnFfdGFibGVfZGVzdHJveShkZXYpOw0KIAltbHg1X3Bh
Z2VhbGxvY19zdG9wKGRldik7DQogCW1seDVfZXZlbnRzX3N0b3AoZGV2KTsNCiAJbWx4NV9wdXRf
dWFyc19wYWdlKGRldiwgZGV2LT5wcml2LnVhcik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oDQppbmRleCA5MDc1MTVmM2JmYmIu
LjE0ZjFmNjNkYjNlMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9tbHg1X2NvcmUuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL21seDVfY29yZS5oDQpAQCAtMTU1LDYgKzE1NSw4IEBAIHZvaWQgbWx4NV9s
YWdfcmVtb3ZlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KIA0KIGludCBtbHg1X2lycV90
YWJsZV9pbml0KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KIHZvaWQgbWx4NV9pcnFfdGFi
bGVfY2xlYW51cChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KTsNCitpbnQgbWx4NV9pcnFfdGFi
bGVfY3JlYXRlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KK3ZvaWQgbWx4NV9pcnFfdGFi
bGVfZGVzdHJveShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KTsNCiANCiBpbnQgbWx4NV9ldmVu
dHNfaW5pdChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KTsNCiB2b2lkIG1seDVfZXZlbnRzX2Ns
ZWFudXAoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldik7DQotLSANCjIuMjEuMA0KDQo=
