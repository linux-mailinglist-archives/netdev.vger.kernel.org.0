Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2C5294D2
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390280AbfEXJgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:36:00 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:45477
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390189AbfEXJgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uCUTqte7eY6H/b2mYleNjIarPsshMj8zO7dtXUiOyA=;
 b=BQv54xY3W0QDqFSWsflwGGa0ShJyp4fUApXaAoCkM1FebX8xZxDXkRHiT5RC89b9Cj5L3TuU2JyTq2OIwNaGRsOzuMA6EPAwJCjXU1CYn4HLlWqzQFxyOCZxpExQx+A9bF0ll4SbbvpVigA2vfg3q24rUoX0vT6iRbqKUJVJ8os=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4294.eurprd05.prod.outlook.com (52.135.160.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 24 May 2019 09:35:38 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:38 +0000
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
Subject: [PATCH bpf-next v3 14/16] net/mlx5e: Encapsulate open/close queues
 into a function
Thread-Topic: [PATCH bpf-next v3 14/16] net/mlx5e: Encapsulate open/close
 queues into a function
Thread-Index: AQHVEhQMldvtocKdEE2WwvfoDvJdGA==
Date:   Fri, 24 May 2019 09:35:38 +0000
Message-ID: <20190524093431.20887-15-maximmi@mellanox.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
In-Reply-To: <20190524093431.20887-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::18) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62aaeaa6-8a82-43bd-a29a-08d6e02b2e5a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4294;
x-ms-traffictypediagnostic: AM6PR05MB4294:
x-microsoft-antispam-prvs: <AM6PR05MB42940782512EA28EB399647AD1020@AM6PR05MB4294.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(189003)(66476007)(99286004)(478600001)(76176011)(66556008)(66946007)(14454004)(68736007)(6506007)(64756008)(386003)(66446008)(36756003)(316002)(54906003)(110136005)(73956011)(107886003)(26005)(486006)(71200400001)(71190400001)(52116002)(11346002)(446003)(186003)(305945005)(7736002)(2616005)(2906002)(476003)(6436002)(5660300002)(53936002)(50226002)(7416002)(8676002)(102836004)(1076003)(8936002)(256004)(66066001)(86362001)(25786009)(6486002)(6512007)(4326008)(81166006)(3846002)(6116002)(81156014)(14444005)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4294;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EsFTx96GwG2RYbojrKaW9mKzDcp70wvxgyTi3GahpU5Y/Zy+B0vEVcEVQHCIjFUM40Yu9w5od1S8e2eQlpuCWIAKcn2S5HYCfEGSEXJLPY+rSyN0WG8UO+pN3/pqVp2/+ZNlU9lJWJQpFz3HCzBFWZfl/Rzp+GlP5rWAlfJ9qNdchJ9y4US4LNdRQMPewEhtPAnn3r2gFiGCXzNACJ2IDTbYdRxJD4U4pjE1URjPXL77GMlfStGhZkQ5oj6QoAj0sKuGf26R2yChG+lPi7VFtUzQ0moQya7Wg/NI81SCZPnq2yxb6fYKBMVCSieS3PZCfu+1Wf3uPPd7SX93IEd6HlJdgNDx/J33mUUZ+dLM/o7ARxtWtILfB1+enNjXkFY3SF/aIkIfw4Izlk88eLT8PSkmoe3gJpepboBPG+qA0I4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62aaeaa6-8a82-43bd-a29a-08d6e02b2e5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:38.7979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4294
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
