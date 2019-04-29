Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EE8E031
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfD2KFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:22 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727946AbfD2KFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3NKGY4FEjx3WtyEP1H5VUzlwIhP4VK1yQFJAbMPZYk=;
 b=ZVPJAKFiPx7Rlo5b29FPLvHUx+RIl4YrmkLFyjdgtKzn86/CxMPYhbimveuhkZgan88ewArliWY1IsU8qMAj52CTRHL6W5cwHgAXBsy1izNhIbCV8Ku4kERKVwjjcixdahTA9WudziACFH5uD92OJjQFzQaQ1iLGLHQM5tRdDo0=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:46 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:46 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 05/15] net: aquantia: create global service
 workqueue
Thread-Topic: [PATCH v4 net-next 05/15] net: aquantia: create global service
 workqueue
Thread-Index: AQHU/nL5t5S1BY/vxEerm/sWy/jsKA==
Date:   Mon, 29 Apr 2019 10:04:45 +0000
Message-ID: <6a4c5eff8a7bbe0fb8cf57321b2e9972753b41f8.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b02fe98-d31d-4430-847d-08d6cc8a1b4a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB364426AA0E5E4D8CC185E27C98390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(256004)(11346002)(52116002)(446003)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H9hgYlOdJhabfAdILu1M77Q6chPpx2gZsKRrwZL03QFRlZwqVPCIeCdTf2YXvYtla6y1o9hLwRFTCA9Ejcvym1ErOLPKgstMoN+WcbawhLuP1CDV35BtYhlPkr1OpFNW2Vb/LbyGQNU9aJsrLKiaZMFijOjnn8qSl67bfiIwrz9qBcFxuDCHw9Sb4+3Sf5Gynfx3MR9aQpg7bJUnNv7ZtbrUdGLlBEPsXvpeQNfZUF4NiYjp0YzotKlnhfmEjc5Sgvlhn2EmRk75+QzzWnKvgImZ9+0GZ3gnS526E/VseVjPlVMVzEovga/R2F5yuSpwFEIeSmLJvHkWGKYlOES+rIq+LRBI2/W6gQetzHehOvrxgLiO1tFnVLX7+fwfH8hZelbNOyUu/moHlG4MFAOBvIdvDOJw8uG/x6Uq3psRZBs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b02fe98-d31d-4430-847d-08d6cc8a1b4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:45.9288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmlraXRhIERhbmlsb3YgPG5kYW5pbG92QGFxdWFudGlhLmNvbT4NCg0KV2UgbmVlZCB0
aGlzIHRvIHNjaGVkdWxlIGxpbmsgaW50ZXJydXB0IGhhbmRsaW5nIGFuZA0KdmFyaW91cyBzZXJ2
aWNlIHRhc2tzLg0KDQpTaWduZWQtb2ZmLWJ5OiBOaWtpdGEgRGFuaWxvdiA8bmRhbmlsb3ZAYXF1
YW50aWEuY29tPg0KU2lnbmVkLW9mZi1ieTogSWdvciBSdXNza2lraCA8aWdvci5ydXNza2lraEBh
cXVhbnRpYS5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2Fx
X21haW4uYyAgfCA0MSArKysrKysrKysrKysrKysrKysrDQogLi4uL25ldC9ldGhlcm5ldC9hcXVh
bnRpYS9hdGxhbnRpYy9hcV9tYWluLmggIHwgIDIgKw0KIC4uLi9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9wY2lfZnVuYy5jICB8IDExICsrKystDQogLi4uL2V0aGVybmV0L2FxdWFudGlh
L2F0bGFudGljL2FxX3BjaV9mdW5jLmggIHwgIDMgKysNCiA0IGZpbGVzIGNoYW5nZWQsIDU2IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYw0KaW5kZXggMmExMWMxZWVmZDhmLi43ZjQ1ZTk5
MDg1ODIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRp
Yy9hcV9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX21haW4uYw0KQEAgLTIzLDggKzIzLDE3IEBAIE1PRFVMRV9WRVJTSU9OKEFRX0NGR19EUlZf
VkVSU0lPTik7DQogTU9EVUxFX0FVVEhPUihBUV9DRkdfRFJWX0FVVEhPUik7DQogTU9EVUxFX0RF
U0NSSVBUSU9OKEFRX0NGR19EUlZfREVTQyk7DQogDQorY29uc3QgY2hhciBhcV9uZGV2X2RyaXZl
cl9uYW1lW10gPSBBUV9DRkdfRFJWX05BTUU7DQorDQogc3RhdGljIGNvbnN0IHN0cnVjdCBuZXRf
ZGV2aWNlX29wcyBhcV9uZGV2X29wczsNCiANCitzdGF0aWMgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1
Y3QgKmFxX25kZXZfd3E7DQorDQordm9pZCBhcV9uZGV2X3NjaGVkdWxlX3dvcmsoc3RydWN0IHdv
cmtfc3RydWN0ICp3b3JrKQ0KK3sNCisJcXVldWVfd29yayhhcV9uZGV2X3dxLCB3b3JrKTsNCit9
DQorDQogc3RydWN0IG5ldF9kZXZpY2UgKmFxX25kZXZfYWxsb2Modm9pZCkNCiB7DQogCXN0cnVj
dCBuZXRfZGV2aWNlICpuZGV2ID0gTlVMTDsNCkBAIC0yMDksMyArMjE4LDM1IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbmV0X2RldmljZV9vcHMgYXFfbmRldl9vcHMgPSB7DQogCS5uZG9fdmxhbl9y
eF9hZGRfdmlkID0gYXFfbmRvX3ZsYW5fcnhfYWRkX3ZpZCwNCiAJLm5kb192bGFuX3J4X2tpbGxf
dmlkID0gYXFfbmRvX3ZsYW5fcnhfa2lsbF92aWQsDQogfTsNCisNCitzdGF0aWMgaW50IF9faW5p
dCBhcV9uZGV2X2luaXRfbW9kdWxlKHZvaWQpDQorew0KKwlpbnQgcmV0Ow0KKw0KKwlhcV9uZGV2
X3dxID0gY3JlYXRlX3NpbmdsZXRocmVhZF93b3JrcXVldWUoYXFfbmRldl9kcml2ZXJfbmFtZSk7
DQorCWlmICghYXFfbmRldl93cSkgew0KKwkJcHJfZXJyKCJGYWlsZWQgdG8gY3JlYXRlIHdvcmtx
dWV1ZVxuIik7DQorCQlyZXR1cm4gLUVOT01FTTsNCisJfQ0KKw0KKwlyZXQgPSBhcV9wY2lfZnVu
Y19yZWdpc3Rlcl9kcml2ZXIoKTsNCisJaWYgKHJldCkgew0KKwkJZGVzdHJveV93b3JrcXVldWUo
YXFfbmRldl93cSk7DQorCQlyZXR1cm4gcmV0Ow0KKwl9DQorDQorCXJldHVybiAwOw0KK30NCisN
CitzdGF0aWMgdm9pZCBfX2V4aXQgYXFfbmRldl9leGl0X21vZHVsZSh2b2lkKQ0KK3sNCisJYXFf
cGNpX2Z1bmNfdW5yZWdpc3Rlcl9kcml2ZXIoKTsNCisNCisJaWYgKGFxX25kZXZfd3EpIHsNCisJ
CWRlc3Ryb3lfd29ya3F1ZXVlKGFxX25kZXZfd3EpOw0KKwkJYXFfbmRldl93cSA9IE5VTEw7DQor
CX0NCit9DQorDQorbW9kdWxlX2luaXQoYXFfbmRldl9pbml0X21vZHVsZSk7DQorbW9kdWxlX2V4
aXQoYXFfbmRldl9leGl0X21vZHVsZSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbWFpbi5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvYXFfbWFpbi5oDQppbmRleCBjZTkyMTUyZWI0M2UuLjU0NDhiODJmYjdl
YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2Fx
X21haW4uaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
bWFpbi5oDQpAQCAtMTMsNyArMTMsOSBAQA0KICNkZWZpbmUgQVFfTUFJTl9IDQogDQogI2luY2x1
ZGUgImFxX2NvbW1vbi5oIg0KKyNpbmNsdWRlICJhcV9uaWMuaCINCiANCit2b2lkIGFxX25kZXZf
c2NoZWR1bGVfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOw0KIHN0cnVjdCBuZXRfZGV2
aWNlICphcV9uZGV2X2FsbG9jKHZvaWQpOw0KIA0KICNlbmRpZiAvKiBBUV9NQUlOX0ggKi8NCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lf
ZnVuYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1
bmMuYw0KaW5kZXggNTMzYTc4ZGVlZmVlLi5lZWM0OWU2ZTk1YWIgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5jDQorKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5jDQpAQCAt
MzY4LDQgKzM2OCwxMyBAQCBzdGF0aWMgc3RydWN0IHBjaV9kcml2ZXIgYXFfcGNpX29wcyA9IHsN
CiAJLnNodXRkb3duID0gYXFfcGNpX3NodXRkb3duLA0KIH07DQogDQotbW9kdWxlX3BjaV9kcml2
ZXIoYXFfcGNpX29wcyk7DQoraW50IGFxX3BjaV9mdW5jX3JlZ2lzdGVyX2RyaXZlcih2b2lkKQ0K
K3sNCisJcmV0dXJuIHBjaV9yZWdpc3Rlcl9kcml2ZXIoJmFxX3BjaV9vcHMpOw0KK30NCisNCit2
b2lkIGFxX3BjaV9mdW5jX3VucmVnaXN0ZXJfZHJpdmVyKHZvaWQpDQorew0KKwlwY2lfdW5yZWdp
c3Rlcl9kcml2ZXIoJmFxX3BjaV9vcHMpOw0KK30NCisNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5oIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1bmMuaA0KaW5kZXggYWVlZTY3YmY2
OWZhLi43OTljNWUwZDY1M2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVh
bnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9h
cXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5oDQpAQCAtMjksNCArMjksNyBAQCBpbnQgYXFf
cGNpX2Z1bmNfYWxsb2NfaXJxKHN0cnVjdCBhcV9uaWNfcyAqc2VsZiwgdW5zaWduZWQgaW50IGks
DQogdm9pZCBhcV9wY2lfZnVuY19mcmVlX2lycXMoc3RydWN0IGFxX25pY19zICpzZWxmKTsNCiB1
bnNpZ25lZCBpbnQgYXFfcGNpX2Z1bmNfZ2V0X2lycV90eXBlKHN0cnVjdCBhcV9uaWNfcyAqc2Vs
Zik7DQogDQoraW50IGFxX3BjaV9mdW5jX3JlZ2lzdGVyX2RyaXZlcih2b2lkKTsNCit2b2lkIGFx
X3BjaV9mdW5jX3VucmVnaXN0ZXJfZHJpdmVyKHZvaWQpOw0KKw0KICNlbmRpZiAvKiBBUV9QQ0lf
RlVOQ19IICovDQotLSANCjIuMTcuMQ0KDQo=
