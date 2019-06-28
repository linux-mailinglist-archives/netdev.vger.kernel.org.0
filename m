Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D085A6F4
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfF1WgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:06 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726892AbfF1WgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=dgHB9RUPNk049CP3nkRNMj+86LHG3PhhOtzq4IFIIlKR0TGC0kXnQT5zPhpomZIl+5FDZtAlkEpAKjUbkj7dDfFMJ/qR1U6ZRBx7RMHPz6AakgXSD2cv4IeL4M3h2X04gv9DzmMaI+4QyzqvQFB7waBZxq9n9ofxoO8R0xXOz8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdrQPhFZXKD+xrpyzr+8yC9U78CcaKRAP3tL3DSgbRY=;
 b=cqJaiqtD5qcCvuVfY+4AEczQyY1XaBZZ9QelVcfAT4g/N+c+pAAYo32+e2UvkH1RmGKfJ6gsfoE/5WF6qVmC+rX8qPoJgZFwUJyWVT17H/MibspBkx0xkAJRJYy2dAyf7hPpGRmj+8Jk/iQKmEkd1QV/KyPbkR5f2kYQyLzATEI=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdrQPhFZXKD+xrpyzr+8yC9U78CcaKRAP3tL3DSgbRY=;
 b=bGtflZpLhxGNRZ7QbZ9Ud/PD91MyMMKgWNcioCDLJMlZaxZJZ6sO4zp29hc45si5+SRzxNqke2Zq/U8zFi1JCctuv/CrWuTfA5EOINA05/QBRB9DncLIOTvJ5NcQlEvapr3CiVeJVSGpl2Et03ygRx3ovkFXCF/kolOlGiuRqcU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:54 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 04/18] {IB, net}/mlx5: E-Switch, Use index of rep
 for vport to IB port mapping
Thread-Topic: [PATCH mlx5-next 04/18] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Index: AQHVLgHYQpCW4tBUDEaAMzknhgiAbg==
Date:   Fri, 28 Jun 2019 22:35:53 +0000
Message-ID: <20190628223516.9368-5-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ac0e109-d5f7-4004-ee20-08d6fc18fab5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357449599CA0AED1AED8F97BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CXer+TSqKa3XGPAqRhNOBeLNpthuOASxTssTHwMsdn+IYdj5AAuotmJkgIYSoF/4yAGV0STZV2Aqnc7bz4XqCmo1jAx4K+P9AmfJNkHfVbx22zschiG19ntJCk7O3BUY90dhvwL0nNqH4xlEDWApM/V1Ay7MI8sA+o86QlfsTXT+aQ4cP/VGiSfHDiTmzP9diZDYjbVjhvoalFIt9ReIgMeZMsb6H6SDH3tPNtZgqR2xUQGiPlYFqOqP3P/39Rc5ReLyFS+i22kZrlEze8p4GhP1U1fjCPo/ygnpmeeGU/OJLdq3n8DqgHpWjtrwZjOnOm4lDf8gsSPl1pClfck/etVksiYBGhEGJLplYZ4zHvYII4wtxkOSVmE6qnVszswhLsbT0WP1uBPMeW0f7lEp1QAEpVmPeOUbStYgcBDPtLQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac0e109-d5f7-4004-ee20-08d6fc18fab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:53.9859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCkluIHRoZSBzaW5nbGUg
SUIgZGV2aWNlIG1vZGUsIHRoZSBtYXBwaW5nIGJldHdlZW4gdnBvcnQgbnVtYmVyIGFuZA0KcmVw
IHJlbGllcyBvbiBhIGNvdW50ZXIuIEhvd2V2ZXIgZm9yIGR5bmFtaWMgdnBvcnQgYWxsb2NhdGlv
biwgaXQgaXMNCmRlc2lyZWQgdG8ga2VlcCBjb25zaXN0ZW50IG1hcCBvZiBlc3dpdGNoIHZwb3J0
IGFuZCBJQiBwb3J0Lg0KDQpIZW5jZSwgc2ltcGxpZnkgY29kZSB0byByZW1vdmUgdGhlIGZyZWUg
cnVubmluZyBjb3VudGVyIGFuZCBpbnN0ZWFkDQp1c2UgdGhlIGF2YWlsYWJsZSB2cG9ydCBpbmRl
eCBkdXJpbmcgbG9hZC91bmxvYWQgc2VxdWVuY2UgZnJvbSB0aGUNCmVzd2l0Y2guDQoNClNpZ25l
ZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxib2RvbmdAbWVsbGFub3guY29tPg0KU3VnZ2VzdGVkLWJ5
OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJhdiBQ
YW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJr
YkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jICAg
ICAgICAgICAgICAgICAgICAgICAgfCA0ICsrLS0NCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4
NS9tbHg1X2liLmggICAgICAgICAgICAgICAgICAgICAgIHwgMSAtDQogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyB8IDEgKw0KIGluY2x1
ZGUvbGludXgvbWx4NS9lc3dpdGNoLmggICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAy
ICsrDQogNCBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYyBiL2RyaXZl
cnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jDQppbmRleCAyMmU2NTFjYjU1MzQuLjFkZTE2
YTkzZmM2NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5j
DQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0KQEAgLTE0LDcgKzE0
LDcgQEAgbWx4NV9pYl9zZXRfdnBvcnRfcmVwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHN0
cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICpyZXApDQogCWludCB2cG9ydF9pbmRleDsNCiANCiAJaWJk
ZXYgPSBtbHg1X2liX2dldF91cGxpbmtfaWJkZXYoZGV2LT5wcml2LmVzd2l0Y2gpOw0KLQl2cG9y
dF9pbmRleCA9IGliZGV2LT5mcmVlX3BvcnQrKzsNCisJdnBvcnRfaW5kZXggPSByZXAtPnZwb3J0
X2luZGV4Ow0KIA0KIAlpYmRldi0+cG9ydFt2cG9ydF9pbmRleF0ucmVwID0gcmVwOw0KIAl3cml0
ZV9sb2NrKCZpYmRldi0+cG9ydFt2cG9ydF9pbmRleF0ucm9jZS5uZXRkZXZfbG9jayk7DQpAQCAt
NTAsNyArNTAsNyBAQCBtbHg1X2liX3Zwb3J0X3JlcF9sb2FkKHN0cnVjdCBtbHg1X2NvcmVfZGV2
ICpkZXYsIHN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICpyZXApDQogCX0NCiANCiAJaWJkZXYtPmlz
X3JlcCA9IHRydWU7DQotCXZwb3J0X2luZGV4ID0gaWJkZXYtPmZyZWVfcG9ydCsrOw0KKwl2cG9y
dF9pbmRleCA9IHJlcC0+dnBvcnRfaW5kZXg7DQogCWliZGV2LT5wb3J0W3Zwb3J0X2luZGV4XS5y
ZXAgPSByZXA7DQogCWliZGV2LT5wb3J0W3Zwb3J0X2luZGV4XS5yb2NlLm5ldGRldiA9DQogCQlt
bHg1X2liX2dldF9yZXBfbmV0ZGV2KGRldi0+cHJpdi5lc3dpdGNoLCByZXAtPnZwb3J0KTsNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmggYi9kcml2ZXJz
L2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmgNCmluZGV4IDFjMjA1YzJiZDQ4Ni4uZWU3M2Rj
MTIyZDI4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9pYi5o
DQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmgNCkBAIC05NzgsNyAr
OTc4LDYgQEAgc3RydWN0IG1seDVfaWJfZGV2IHsNCiAJdTE2CQkJZGV2eF93aGl0ZWxpc3RfdWlk
Ow0KIAlzdHJ1Y3QgbWx4NV9zcnFfdGFibGUgICBzcnFfdGFibGU7DQogCXN0cnVjdCBtbHg1X2Fz
eW5jX2N0eCAgIGFzeW5jX2N0eDsNCi0JaW50CQkJZnJlZV9wb3J0Ow0KIH07DQogDQogc3RhdGlj
IGlubGluZSBzdHJ1Y3QgbWx4NV9pYl9jcSAqdG9fbWliY3Eoc3RydWN0IG1seDVfY29yZV9jcSAq
bWNxKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lc3dpdGNoX29mZmxvYWRzLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQppbmRleCBiYzYzOWE4NDY3MTQuLjI0YWYyNzQ0NDUz
YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
c3dpdGNoX29mZmxvYWRzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCkBAIC0xNDExLDYgKzE0MTEsNyBAQCBpbnQgZXN3
X29mZmxvYWRzX2luaXRfcmVwcyhzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cpDQogDQogCW1seDVf
ZXN3X2Zvcl9hbGxfcmVwcyhlc3csIHZwb3J0X2luZGV4LCByZXApIHsNCiAJCXJlcC0+dnBvcnQg
PSBtbHg1X2Vzd2l0Y2hfaW5kZXhfdG9fdnBvcnRfbnVtKGVzdywgdnBvcnRfaW5kZXgpOw0KKwkJ
cmVwLT52cG9ydF9pbmRleCA9IHZwb3J0X2luZGV4Ow0KIAkJZXRoZXJfYWRkcl9jb3B5KHJlcC0+
aHdfaWQsIGh3X2lkKTsNCiANCiAJCWZvciAocmVwX3R5cGUgPSAwOyByZXBfdHlwZSA8IE5VTV9S
RVBfVFlQRVM7IHJlcF90eXBlKyspDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2Vz
d2l0Y2guaCBiL2luY2x1ZGUvbGludXgvbWx4NS9lc3dpdGNoLmgNCmluZGV4IGFlY2UzYWUxOTAy
ZC4uMzZjYjY0MTE4OGIwIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2gu
aA0KKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2guaA0KQEAgLTQ2LDYgKzQ2LDggQEAg
c3RydWN0IG1seDVfZXN3aXRjaF9yZXAgew0KIAl1MTYJCSAgICAgICB2cG9ydDsNCiAJdTgJCSAg
ICAgICBod19pZFtFVEhfQUxFTl07DQogCXUxNgkJICAgICAgIHZsYW47DQorCS8qIE9ubHkgSUIg
cmVwIGlzIHVzaW5nIHZwb3J0X2luZGV4ICovDQorCXUxNgkJICAgICAgIHZwb3J0X2luZGV4Ow0K
IAl1MzIJCSAgICAgICB2bGFuX3JlZmNvdW50Ow0KIH07DQogDQotLSANCjIuMjEuMA0KDQo=
