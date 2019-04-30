Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575AAFF92
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfD3SNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:13:20 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbfD3SNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uCUTqte7eY6H/b2mYleNjIarPsshMj8zO7dtXUiOyA=;
 b=OdV5sTDltxVquYTYW95Z/4v0wHJz6Eo0jKAE3Nq49q1JXndL1MKXroeESUuNeOqKgP7vmltnuPRbYts6mVlprGKUOHOfkHDCZYwE8grPM92iiUXQB78NJfteRQfF3xABVvlWIMQ5H42ZYVODLgDZyaZuoZGlaASoy45uPxDhAys=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:13:05 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:13:05 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v2 14/16] net/mlx5e: Encapsulate open/close queues
 into a function
Thread-Topic: [PATCH bpf-next v2 14/16] net/mlx5e: Encapsulate open/close
 queues into a function
Thread-Index: AQHU/4BbHoMRWMMgjEmLtodpff9ILQ==
Date:   Tue, 30 Apr 2019 18:13:05 +0000
Message-ID: <20190430181215.15305-15-maximmi@mellanox.com>
References: <20190430181215.15305-1-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::22) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31c4b2b4-8b57-4291-34f7-08d6cd977d83
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB55533049AC9879A372A4F428D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(14444005)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zslSFlraHeJODhpyqTHidWjiKYiPAyknqN4XsCMTcFDm6lenQWtkvpqKg36R2UwT03q/6fWNVaa0tYhd4jjBXK3qCGlEGd52i4lV8RGbnB3SoL3JQ2/zj8+fV8lyf4RWaFNpfVSeOD1lKa7VizGoBLsHdIwlxR0DRhp7au4DXJQctI1+sqUd323Mm9n4U2KRbGUuoKNyC0pr0FZhFRY0QnBpCQJNlD+5zuC79s8QBMQG6Uu26XWN5WcZI/jetBQmwVTG9PQBIGW9YdIk/K/AnuIxYJYpAiuvtLW6wHlkRE5tjzBg9sjmGK9pWyLXe4O6lNdGAb/Z9Ntw7cIJ3htl941pMHFe20wD0BqYqMEjXty5IfuJgQ2Qci024bpwDRZSzyPqG2MK8vU3wo4IACy9tTHkaQcL4qlXd3UTyGA0kUs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c4b2b4-8b57-4291-34f7-08d6cd977d83
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:13:05.2102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3JlYXRlIG5ldyBmdW5jdGlvbnMgbWx4NWVfe29wZW4sY2xvc2V9X3F1ZXVlcyB0byBlbmNhcHN1
bGF0ZSBvcGVuaW5nDQphbmQgY2xvc2luZyBSUXMgYW5kIFNRcywgYW5kIGNhbGwgdGhlIG5ldyBm
dW5jdGlvbnMgZnJvbQ0KbWx4NWVfe29wZW4sY2xvc2V9X2NoYW5uZWwuIEl0IHNpbXBsaWZpZXMg
dGhlIGV4aXN0aW5nIGZ1bmN0aW9ucyBhIGJpdA0KYW5kIHByZXBhcmVzIHRoZW0gZm9yIHRoZSB1
cGNvbWluZyBBRl9YRFAgY2hhbmdlcy4NCg0KU2lnbmVkLW9mZi1ieTogTWF4aW0gTWlraXR5YW5z
a2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRh
cmlxdEBtZWxsYW5veC5jb20+DQpBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxs
YW5veC5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9t
YWluLmMgfCAxMjUgKysrKysrKysrKy0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDczIGluc2Vy
dGlvbnMoKyksIDUyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCmluZGV4IDA4YzJmZDBiZTdhYy4uOWY3NGI5
ZjcyMTM1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX21haW4uYw0KQEAgLTE3NjksNDkgKzE3NjksMTYgQEAgc3RhdGljIHZvaWQgbWx4NWVf
ZnJlZV94cHNfY3B1bWFzayhzdHJ1Y3QgbWx4NWVfY2hhbm5lbCAqYykNCiAJZnJlZV9jcHVtYXNr
X3ZhcihjLT54cHNfY3B1bWFzayk7DQogfQ0KIA0KLXN0YXRpYyBpbnQgbWx4NWVfb3Blbl9jaGFu
bmVsKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LCBpbnQgaXgsDQotCQkJICAgICAgc3RydWN0IG1s
eDVlX3BhcmFtcyAqcGFyYW1zLA0KLQkJCSAgICAgIHN0cnVjdCBtbHg1ZV9jaGFubmVsX3BhcmFt
ICpjcGFyYW0sDQotCQkJICAgICAgc3RydWN0IG1seDVlX2NoYW5uZWwgKipjcCkNCitzdGF0aWMg
aW50IG1seDVlX29wZW5fcXVldWVzKHN0cnVjdCBtbHg1ZV9jaGFubmVsICpjLA0KKwkJCSAgICAg
c3RydWN0IG1seDVlX3BhcmFtcyAqcGFyYW1zLA0KKwkJCSAgICAgc3RydWN0IG1seDVlX2NoYW5u
ZWxfcGFyYW0gKmNwYXJhbSkNCiB7DQotCWludCBjcHUgPSBjcHVtYXNrX2ZpcnN0KG1seDVfY29t
cF9pcnFfZ2V0X2FmZmluaXR5X21hc2socHJpdi0+bWRldiwgaXgpKTsNCiAJc3RydWN0IG5ldF9k
aW1fY3FfbW9kZXIgaWNvY3FfbW9kZXIgPSB7MCwgMH07DQotCXN0cnVjdCBuZXRfZGV2aWNlICpu
ZXRkZXYgPSBwcml2LT5uZXRkZXY7DQotCXN0cnVjdCBtbHg1ZV9jaGFubmVsICpjOw0KLQl1bnNp
Z25lZCBpbnQgaXJxOw0KIAlpbnQgZXJyOw0KLQlpbnQgZXFuOw0KLQ0KLQllcnIgPSBtbHg1X3Zl
Y3RvcjJlcW4ocHJpdi0+bWRldiwgaXgsICZlcW4sICZpcnEpOw0KLQlpZiAoZXJyKQ0KLQkJcmV0
dXJuIGVycjsNCi0NCi0JYyA9IGt2emFsbG9jX25vZGUoc2l6ZW9mKCpjKSwgR0ZQX0tFUk5FTCwg
Y3B1X3RvX25vZGUoY3B1KSk7DQotCWlmICghYykNCi0JCXJldHVybiAtRU5PTUVNOw0KLQ0KLQlj
LT5wcml2ICAgICA9IHByaXY7DQotCWMtPm1kZXYgICAgID0gcHJpdi0+bWRldjsNCi0JYy0+dHN0
YW1wICAgPSAmcHJpdi0+dHN0YW1wOw0KLQljLT5peCAgICAgICA9IGl4Ow0KLQljLT5jcHUgICAg
ICA9IGNwdTsNCi0JYy0+cGRldiAgICAgPSBwcml2LT5tZGV2LT5kZXZpY2U7DQotCWMtPm5ldGRl
diAgID0gcHJpdi0+bmV0ZGV2Ow0KLQljLT5ta2V5X2JlICA9IGNwdV90b19iZTMyKHByaXYtPm1k
ZXYtPm1seDVlX3Jlcy5ta2V5LmtleSk7DQotCWMtPm51bV90YyAgID0gcGFyYW1zLT5udW1fdGM7
DQotCWMtPnhkcCAgICAgID0gISFwYXJhbXMtPnhkcF9wcm9nOw0KLQljLT5zdGF0cyAgICA9ICZw
cml2LT5jaGFubmVsX3N0YXRzW2l4XS5jaDsNCi0JYy0+aXJxX2Rlc2MgPSBpcnFfdG9fZGVzYyhp
cnEpOw0KLQ0KLQllcnIgPSBtbHg1ZV9hbGxvY194cHNfY3B1bWFzayhjLCBwYXJhbXMpOw0KLQlp
ZiAoZXJyKQ0KLQkJZ290byBlcnJfZnJlZV9jaGFubmVsOw0KLQ0KLQluZXRpZl9uYXBpX2FkZChu
ZXRkZXYsICZjLT5uYXBpLCBtbHg1ZV9uYXBpX3BvbGwsIDY0KTsNCiANCiAJZXJyID0gbWx4NWVf
b3Blbl9jcShjLCBpY29jcV9tb2RlciwgJmNwYXJhbS0+aWNvc3FfY3EsICZjLT5pY29zcS5jcSk7
DQogCWlmIChlcnIpDQotCQlnb3RvIGVycl9uYXBpX2RlbDsNCisJCXJldHVybiBlcnI7DQogDQog
CWVyciA9IG1seDVlX29wZW5fdHhfY3FzKGMsIHBhcmFtcywgY3BhcmFtKTsNCiAJaWYgKGVycikN
CkBAIC0xODU2LDggKzE4MjMsNiBAQCBzdGF0aWMgaW50IG1seDVlX29wZW5fY2hhbm5lbChzdHJ1
Y3QgbWx4NWVfcHJpdiAqcHJpdiwgaW50IGl4LA0KIAlpZiAoZXJyKQ0KIAkJZ290byBlcnJfY2xv
c2VfcnE7DQogDQotCSpjcCA9IGM7DQotDQogCXJldHVybiAwOw0KIA0KIGVycl9jbG9zZV9ycToN
CkBAIC0xODc1LDYgKzE4NDAsNyBAQCBzdGF0aWMgaW50IG1seDVlX29wZW5fY2hhbm5lbChzdHJ1
Y3QgbWx4NWVfcHJpdiAqcHJpdiwgaW50IGl4LA0KIA0KIGVycl9kaXNhYmxlX25hcGk6DQogCW5h
cGlfZGlzYWJsZSgmYy0+bmFwaSk7DQorDQogCWlmIChjLT54ZHApDQogCQltbHg1ZV9jbG9zZV9j
cSgmYy0+cnFfeGRwc3EuY3EpOw0KIA0KQEAgLTE4OTAsNiArMTg1Niw3MyBAQCBzdGF0aWMgaW50
IG1seDVlX29wZW5fY2hhbm5lbChzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwgaW50IGl4LA0KIGVy
cl9jbG9zZV9pY29zcV9jcToNCiAJbWx4NWVfY2xvc2VfY3EoJmMtPmljb3NxLmNxKTsNCiANCisJ
cmV0dXJuIGVycjsNCit9DQorDQorc3RhdGljIHZvaWQgbWx4NWVfY2xvc2VfcXVldWVzKHN0cnVj
dCBtbHg1ZV9jaGFubmVsICpjKQ0KK3sNCisJbWx4NWVfY2xvc2VfeGRwc3EoJmMtPnhkcHNxKTsN
CisJbWx4NWVfY2xvc2VfcnEoJmMtPnJxKTsNCisJaWYgKGMtPnhkcCkNCisJCW1seDVlX2Nsb3Nl
X3hkcHNxKCZjLT5ycV94ZHBzcSk7DQorCW1seDVlX2Nsb3NlX3NxcyhjKTsNCisJbWx4NWVfY2xv
c2VfaWNvc3EoJmMtPmljb3NxKTsNCisJbmFwaV9kaXNhYmxlKCZjLT5uYXBpKTsNCisJaWYgKGMt
PnhkcCkNCisJCW1seDVlX2Nsb3NlX2NxKCZjLT5ycV94ZHBzcS5jcSk7DQorCW1seDVlX2Nsb3Nl
X2NxKCZjLT5ycS5jcSk7DQorCW1seDVlX2Nsb3NlX2NxKCZjLT54ZHBzcS5jcSk7DQorCW1seDVl
X2Nsb3NlX3R4X2NxcyhjKTsNCisJbWx4NWVfY2xvc2VfY3EoJmMtPmljb3NxLmNxKTsNCit9DQor
DQorc3RhdGljIGludCBtbHg1ZV9vcGVuX2NoYW5uZWwoc3RydWN0IG1seDVlX3ByaXYgKnByaXYs
IGludCBpeCwNCisJCQkgICAgICBzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsDQorCQkJICAg
ICAgc3RydWN0IG1seDVlX2NoYW5uZWxfcGFyYW0gKmNwYXJhbSwNCisJCQkgICAgICBzdHJ1Y3Qg
bWx4NWVfY2hhbm5lbCAqKmNwKQ0KK3sNCisJaW50IGNwdSA9IGNwdW1hc2tfZmlyc3QobWx4NV9j
b21wX2lycV9nZXRfYWZmaW5pdHlfbWFzayhwcml2LT5tZGV2LCBpeCkpOw0KKwlzdHJ1Y3QgbmV0
X2RldmljZSAqbmV0ZGV2ID0gcHJpdi0+bmV0ZGV2Ow0KKwlzdHJ1Y3QgbWx4NWVfY2hhbm5lbCAq
YzsNCisJdW5zaWduZWQgaW50IGlycTsNCisJaW50IGVycjsNCisJaW50IGVxbjsNCisNCisJZXJy
ID0gbWx4NV92ZWN0b3IyZXFuKHByaXYtPm1kZXYsIGl4LCAmZXFuLCAmaXJxKTsNCisJaWYgKGVy
cikNCisJCXJldHVybiBlcnI7DQorDQorCWMgPSBrdnphbGxvY19ub2RlKHNpemVvZigqYyksIEdG
UF9LRVJORUwsIGNwdV90b19ub2RlKGNwdSkpOw0KKwlpZiAoIWMpDQorCQlyZXR1cm4gLUVOT01F
TTsNCisNCisJYy0+cHJpdiAgICAgPSBwcml2Ow0KKwljLT5tZGV2ICAgICA9IHByaXYtPm1kZXY7
DQorCWMtPnRzdGFtcCAgID0gJnByaXYtPnRzdGFtcDsNCisJYy0+aXggICAgICAgPSBpeDsNCisJ
Yy0+Y3B1ICAgICAgPSBjcHU7DQorCWMtPnBkZXYgICAgID0gcHJpdi0+bWRldi0+ZGV2aWNlOw0K
KwljLT5uZXRkZXYgICA9IHByaXYtPm5ldGRldjsNCisJYy0+bWtleV9iZSAgPSBjcHVfdG9fYmUz
Mihwcml2LT5tZGV2LT5tbHg1ZV9yZXMubWtleS5rZXkpOw0KKwljLT5udW1fdGMgICA9IHBhcmFt
cy0+bnVtX3RjOw0KKwljLT54ZHAgICAgICA9ICEhcGFyYW1zLT54ZHBfcHJvZzsNCisJYy0+c3Rh
dHMgICAgPSAmcHJpdi0+Y2hhbm5lbF9zdGF0c1tpeF0uY2g7DQorCWMtPmlycV9kZXNjID0gaXJx
X3RvX2Rlc2MoaXJxKTsNCisNCisJZXJyID0gbWx4NWVfYWxsb2NfeHBzX2NwdW1hc2soYywgcGFy
YW1zKTsNCisJaWYgKGVycikNCisJCWdvdG8gZXJyX2ZyZWVfY2hhbm5lbDsNCisNCisJbmV0aWZf
bmFwaV9hZGQobmV0ZGV2LCAmYy0+bmFwaSwgbWx4NWVfbmFwaV9wb2xsLCA2NCk7DQorDQorCWVy
ciA9IG1seDVlX29wZW5fcXVldWVzKGMsIHBhcmFtcywgY3BhcmFtKTsNCisJaWYgKHVubGlrZWx5
KGVycikpDQorCQlnb3RvIGVycl9uYXBpX2RlbDsNCisNCisJKmNwID0gYzsNCisNCisJcmV0dXJu
IDA7DQorDQogZXJyX25hcGlfZGVsOg0KIAluZXRpZl9uYXBpX2RlbCgmYy0+bmFwaSk7DQogCW1s
eDVlX2ZyZWVfeHBzX2NwdW1hc2soYyk7DQpAQCAtMTkyMSwxOSArMTk1NCw3IEBAIHN0YXRpYyB2
b2lkIG1seDVlX2RlYWN0aXZhdGVfY2hhbm5lbChzdHJ1Y3QgbWx4NWVfY2hhbm5lbCAqYykNCiAN
CiBzdGF0aWMgdm9pZCBtbHg1ZV9jbG9zZV9jaGFubmVsKHN0cnVjdCBtbHg1ZV9jaGFubmVsICpj
KQ0KIHsNCi0JbWx4NWVfY2xvc2VfeGRwc3EoJmMtPnhkcHNxKTsNCi0JbWx4NWVfY2xvc2VfcnEo
JmMtPnJxKTsNCi0JaWYgKGMtPnhkcCkNCi0JCW1seDVlX2Nsb3NlX3hkcHNxKCZjLT5ycV94ZHBz
cSk7DQotCW1seDVlX2Nsb3NlX3NxcyhjKTsNCi0JbWx4NWVfY2xvc2VfaWNvc3EoJmMtPmljb3Nx
KTsNCi0JbmFwaV9kaXNhYmxlKCZjLT5uYXBpKTsNCi0JaWYgKGMtPnhkcCkNCi0JCW1seDVlX2Ns
b3NlX2NxKCZjLT5ycV94ZHBzcS5jcSk7DQotCW1seDVlX2Nsb3NlX2NxKCZjLT5ycS5jcSk7DQot
CW1seDVlX2Nsb3NlX2NxKCZjLT54ZHBzcS5jcSk7DQotCW1seDVlX2Nsb3NlX3R4X2NxcyhjKTsN
Ci0JbWx4NWVfY2xvc2VfY3EoJmMtPmljb3NxLmNxKTsNCisJbWx4NWVfY2xvc2VfcXVldWVzKGMp
Ow0KIAluZXRpZl9uYXBpX2RlbCgmYy0+bmFwaSk7DQogCW1seDVlX2ZyZWVfeHBzX2NwdW1hc2so
Yyk7DQogDQotLSANCjIuMTkuMQ0KDQo=
