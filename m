Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C7042B6F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440140AbfFLP5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:57:16 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:31558
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731995AbfFLP5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4NglS6He9DCJFoxtSYSmtU9UeXNm5HFrkUptCZltC8=;
 b=OvNlLFJudaVK9XOvpb5Uyx4xjww5bn+0AIMK64AkRqOt4jVwBphFxAa9+B4h7XjII57zl6b4DmCR1YxSq6eSEnFi8MwNYoH96aZqjV8LKwA/DaQm5HgIBb4g/++9BH+dDcbwdct87us8hO7r6Cq6e47T/ieFeFGOEsQ+Giy59Os=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:57:04 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:57:04 +0000
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
Subject: [PATCH bpf-next v4 15/17] net/mlx5e: Encapsulate open/close queues
 into a function
Thread-Topic: [PATCH bpf-next v4 15/17] net/mlx5e: Encapsulate open/close
 queues into a function
Thread-Index: AQHVITd6FDGOG/EV0U+pfep77Eo4hA==
Date:   Wed, 12 Jun 2019 15:57:04 +0000
Message-ID: <20190612155605.22450-16-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc265ba6-4824-4deb-c042-08d6ef4e9d01
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB5240CFD78F51D75D38D360CED1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(14444005)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Nw2NliJk03tW7et4tjgwB+Lnvwh5rpCRTKTlZ3rnJDIRUCCjBbWGAYya+Z3RtD6N2vWKCGmoloTWZA9xVUY5m8m77fdR7BWxq45stVFF7v0IqUwyAELJ22viBJ9tJuNuoSC1Mfx5Jsff5SV7LS984RT6d33HdKh6OX3xOd5sjxhWmT+uOC7fwJJXwenH2Hbx9PucGRc5WZNLGSUU82jZ7p23JI3VPq6a310JpaYuKGv1e8LySRenZDfYPeeqU5mFLQLz7qmK/19WO881mZsK9/cm7H72ujVG48mSltqyDyeAU9KBIER4EH+HcAIWzfzSGauvYO2+iAX5a8uh3MQKVJw0ipdyOTGNv2J3P1FH7ijDq23kUxIm+LxVu0WA/6X6sqnk6G30u8nxHufeXUWtiFTPzzZL7dKa4OPQdBvRogo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc265ba6-4824-4deb-c042-08d6ef4e9d01
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:57:04.3587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5240
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
L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCmluZGV4IDQ0NTU3ZWNkNGQzNC4uYWUxY2Y0
MjVlZTRlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
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
