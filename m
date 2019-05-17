Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F9221220
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 04:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfEQCj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 22:39:27 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:63618
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbfEQCj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 22:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2nD5Bty3W0oZDV/VI3phhaI9K0+GDVvg8ZnfJWHV8w=;
 b=Ek+N51cmvGDMDFHTZg+1wIfdlo+KFZ7MB+zGLXahY53HS5TEncwOa38oDwsNK9gNvNKhBXszOZKoLq+zPy6a12p/fwAuN62jrSnHYTagPRz1l3dO9pr4+fXA6Y/yXDb7k1dWyNw+s4autYun6VhGaKcUTtqwojcX1XVT8cnzSH8=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5210.eurprd04.prod.outlook.com (20.176.236.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 02:39:10 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::bd02:a611:1f0:daac]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::bd02:a611:1f0:daac%6]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 02:39:10 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVDFm06ozNDmulK0GLXWOup5sGAQ==
Date:   Fri, 17 May 2019 02:39:10 +0000
Message-ID: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0112.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::16) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 401ceef7-fc65-40b0-96df-08d6da70d704
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5210;
x-ms-traffictypediagnostic: DB7PR04MB5210:
x-microsoft-antispam-prvs: <DB7PR04MB5210DB1874FB7037D752730CE60B0@DB7PR04MB5210.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(136003)(376002)(346002)(189003)(199004)(54906003)(110136005)(66556008)(68736007)(99286004)(64756008)(66476007)(256004)(386003)(66446008)(52116002)(7736002)(66946007)(81166006)(8936002)(305945005)(6486002)(2501003)(73956011)(6512007)(8676002)(81156014)(71200400001)(71190400001)(6436002)(5024004)(14444005)(2616005)(14454004)(316002)(6116002)(476003)(486006)(50226002)(25786009)(53936002)(66066001)(26005)(102836004)(6506007)(3846002)(4326008)(478600001)(186003)(5660300002)(36756003)(2906002)(1076003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5210;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZW6JKS9El9w8U2nbTSqU6x9dVBSLZAJAKS/q+yXDfSiWEVF/tCmnoKd1S+BVL4iuiow3KabDbLDLqHhTmnLY9eAhOR+BD3RTLRuq/8wgPm5uJ3I9tT2VellRMVCzUHn0FbM1SqZy2Iu4loIjjlX2nRFlO2RWuTiQsPpWJUMTmwQV7amFFnu9luzsWqfqVE3WDdxrmYoUOp+ghLt1k/E+9sD0v9zAk8kELtRPTl3Kz77Fn6UzCsUqO2fZqmJt0/EYaP3sJjxqMQBn/dNjkijzx1RQ1ZvEyqP+B+/2j88kff4XfZjEP9UJhUjn0VR3BbzK1f849sDRtdxyMeHb9cDfyilENhv9Y4YjEpZuTDsQ8EZ0V5CUf3Px05FeJNvj5B36w4+8zy1liLfIG319qCjNQTmfzyH0HSxQslhErm7y6ew=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 401ceef7-fc65-40b0-96df-08d6da70d704
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 02:39:10.3095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5210
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgcmVwcm90ZWQgYnkgU2VhbiBOeWVramFlciBiZWxsb3c6DQpXaGVuIHN1c3BlbmRpbmcsIHdo
ZW4gdGhlcmUgaXMgc3RpbGwgY2FuIHRyYWZmaWMgb24gdGhlDQppbnRlcmZhY2VzIHRoZSBmbGV4
Y2FuIGltbWVkaWF0ZWx5IHdha2VzIHRoZSBwbGF0Zm9ybSBhZ2Fpbi4NCkFzIGl0IHNob3VsZCA6
LSkNCkJ1dCBpdCB0aHJvd3MgdGhpcyBlcnJvciBtc2c6DQpbIDMxNjkuMzc4NjYxXSBQTTogbm9p
cnEgc3VzcGVuZCBvZiBkZXZpY2VzIGZhaWxlZA0KDQpPbiB0aGUgd2F5IGRvd24gdG8gc3VzcGVu
ZCB0aGUgaW50ZXJmYWNlIHRoYXQgdGhyb3dzIHRoZSBlcnJvcg0KbWVzc2FnZSBkb2VzIGNhbGwg
ZmxleGNhbl9zdXNwZW5kIGJ1dCBmYWlscyB0byBjYWxsDQpmbGV4Y2FuX25vaXJxX3N1c3BlbmQu
DQpUaGF0IG1lYW5zIHRoZSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZSBpcyBjYWxsZWQsIGJ1dCBv
biB0aGUgd2F5DQpvdXQgb2Ygc3VzcGVuZCB0aGUgZHJpdmVyIG9ubHkgY2FsbHMgZmxleGNhbl9y
ZXN1bWUgYW5kIHNraXBzDQpmbGV4Y2FuX25vaXJxX3Jlc3VtZSwgdGh1cyBpdCBkb2Vzbid0IGNh
bGwgZmxleGNhbl9leGl0X3N0b3BfbW9kZS4NClRoaXMgbGVhdmVzIHRoZSBmbGV4Y2FuIGluIHN0
b3AgbW9kZSwgYW5kIHdpdGggdGhlIGN1cnJlbnQgZHJpdmVyDQppdCBjYW4ndCByZWNvdmVyIGZy
b20gdGhpcyBldmVuIHdpdGggYSBzb2Z0IHJlYm9vdCwgaXQgcmVxdWlyZXMgYQ0KaGFyZCByZWJv
b3QuDQoNCkZpeGVzOiBkZTM1NzhjMTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1
cCBzdXBwb3J0IikNCg0KVGhpcyBwYXRjaCBpbnRlbmRzIHRvIGZpeCB0aGUgaXNzdWUsIGFuZCBh
bHNvIGFkZCBjb21tZW50IHRvIGV4cGxhaW4gdGhlDQp3YWtldXAgZmxvdy4NCg0KU2lnbmVkLW9m
Zi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAxNyArKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFu
Z2VkLCAxNyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxl
eGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KaW5kZXggZTM1MDgzZmYzMWVlLi42
ZmJjZTQ3M2E4YzcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQorKysg
Yi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQpAQCAtMjg2LDYgKzI4Niw3IEBAIHN0cnVjdCBm
bGV4Y2FuX3ByaXYgew0KIAljb25zdCBzdHJ1Y3QgZmxleGNhbl9kZXZ0eXBlX2RhdGEgKmRldnR5
cGVfZGF0YTsNCiAJc3RydWN0IHJlZ3VsYXRvciAqcmVnX3hjZWl2ZXI7DQogCXN0cnVjdCBmbGV4
Y2FuX3N0b3BfbW9kZSBzdG07DQorCWJvb2wgaW5fc3RvcF9tb2RlOw0KIA0KIAkvKiBSZWFkIGFu
ZCBXcml0ZSBBUElzICovDQogCXUzMiAoKnJlYWQpKHZvaWQgX19pb21lbSAqYWRkcik7DQpAQCAt
MTY1Myw2ICsxNjU0LDcgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3N1c3Bl
bmQoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KIAkJaWYgKGRldmljZV9tYXlfd2FrZXVwKGRldmlj
ZSkpIHsNCiAJCQllbmFibGVfaXJxX3dha2UoZGV2LT5pcnEpOw0KIAkJCWZsZXhjYW5fZW50ZXJf
c3RvcF9tb2RlKHByaXYpOw0KKwkJCXByaXYtPmluX3N0b3BfbW9kZSA9IHRydWU7DQogCQl9IGVs
c2Ugew0KIAkJCWVyciA9IGZsZXhjYW5fY2hpcF9kaXNhYmxlKHByaXYpOw0KIAkJCWlmIChlcnIp
DQpAQCAtMTY3OSw2ICsxNjgxLDExIEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNh
bl9yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KIAkJbmV0aWZfZGV2aWNlX2F0dGFjaChk
ZXYpOw0KIAkJbmV0aWZfc3RhcnRfcXVldWUoZGV2KTsNCiAJCWlmIChkZXZpY2VfbWF5X3dha2V1
cChkZXZpY2UpKSB7DQorCQkJaWYgKHByaXYtPmluX3N0b3BfbW9kZSkgew0KKwkJCQlmbGV4Y2Fu
X2VuYWJsZV93YWtldXBfaXJxKHByaXYsIGZhbHNlKTsNCisJCQkJZmxleGNhbl9leGl0X3N0b3Bf
bW9kZShwcml2KTsNCisJCQkJcHJpdi0+aW5fc3RvcF9tb2RlID0gZmFsc2U7DQorCQkJfQ0KIAkJ
CWRpc2FibGVfaXJxX3dha2UoZGV2LT5pcnEpOw0KIAkJfSBlbHNlIHsNCiAJCQllcnIgPSBwbV9y
dW50aW1lX2ZvcmNlX3Jlc3VtZShkZXZpY2UpOw0KQEAgLTE3MTUsNiArMTcyMiwxMSBAQCBzdGF0
aWMgaW50IF9fbWF5YmVfdW51c2VkIGZsZXhjYW5fbm9pcnFfc3VzcGVuZChzdHJ1Y3QgZGV2aWNl
ICpkZXZpY2UpDQogCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2
aWNlKTsNCiAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQog
DQorCS8qIE5lZWQgZW5hYmxlIHdha2V1cCBpbnRlcnJ1cHQgaW4gbm9pcnEgc3VzcGVuZCBzdGFn
ZS4gT3RoZXJ3aXNlLA0KKwkgKiBpdCB3aWxsIHRyaWdnZXIgY29udGludW91c2x5IHdha2V1cCBp
bnRlcnJ1cHQgaWYgdGhlIHdha2V1cCBldmVudA0KKwkgKiBjb21lcyBiZWZvcmUgbm9pcnEgc3Vz
cGVuZCBzdGFnZSwgYW5kIHNpbXVsdGFuZW91c2x5IGluIGhhcyBlbnRlcg0KKwkgKiB0aGUgc3Rv
cCBtb2RlLg0KKwkgKi8NCiAJaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSAmJiBkZXZpY2VfbWF5X3dh
a2V1cChkZXZpY2UpKQ0KIAkJZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShwcml2LCB0cnVlKTsN
CiANCkBAIC0xNzI2LDkgKzE3MzgsMTQgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBmbGV4
Y2FuX25vaXJxX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQogCXN0cnVjdCBuZXRfZGV2
aWNlICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2aWNlKTsNCiAJc3RydWN0IGZsZXhjYW5fcHJp
diAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQogDQorCS8qIE5lZWQgZXhpdCBzdG9wIG1vZGUg
aW4gbm9pcnEgcmVzdW1lIHN0YWdlLiBPdGhlcndpc2UsIGl0IHdpbGwNCisJICogdHJpZ2dlciBj
b250aW51b3VzbHkgd2FrZXVwIGludGVycnVwdCBpZiB0aGUgd2FrZXVwIGV2ZW50IGNvbWVzLA0K
KwkgKiBhbmQgc2ltdWx0YW5lb3VzbHkgaXQgaGFzIHN0aWxsIGluIHN0b3AgbW9kZS4NCisJICov
DQogCWlmIChuZXRpZl9ydW5uaW5nKGRldikgJiYgZGV2aWNlX21heV93YWtldXAoZGV2aWNlKSkg
ew0KIAkJZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShwcml2LCBmYWxzZSk7DQogCQlmbGV4Y2Fu
X2V4aXRfc3RvcF9tb2RlKHByaXYpOw0KKwkJcHJpdi0+aW5fc3RvcF9tb2RlID0gZmFsc2U7DQog
CX0NCiANCiAJcmV0dXJuIDA7DQotLSANCjIuMTcuMQ0KDQo=
