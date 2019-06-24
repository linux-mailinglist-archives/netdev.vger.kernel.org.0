Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5EB50FF8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbfFXPLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:11:05 -0400
Received: from mail-eopbgr810078.outbound.protection.outlook.com ([40.107.81.78]:6080
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730548AbfFXPLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 11:11:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXMxDLLfUaL/z2efHMhmhKYK8skQzUuToBYNbZOWXDo=;
 b=lD1bfci4z0Inv096HOfS9LjmpKIO7dyZIBv90uQdTi+7RY4vISFXSCEiU26I1LRRjidGYyHX9zea2ZnZalnn9PnquW9obQEX2rpHfDIkyHFss2YhzxqFJhLvfxcHkmTkbA2LsTtWL0w7B2MHpYPGMzrM1AC7s2xUnxiJ1jChQjE=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1614.namprd11.prod.outlook.com (10.172.56.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 15:10:59 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 15:10:59 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v2 8/8] net: aquantia: implement vlan offload
 configuration
Thread-Topic: [PATCH net-next v2 8/8] net: aquantia: implement vlan offload
 configuration
Thread-Index: AQHVKp8HZdf/Y0m1EEak+U+mfZ+VJg==
Date:   Mon, 24 Jun 2019 15:10:58 +0000
Message-ID: <d73f8bdb4acd2e87fef3510d9518ba63ebe109f8.1561388549.git.igor.russkikh@aquantia.com>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561388549.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b9f3b83-22b0-449c-a2c1-08d6f8b62998
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1614;
x-ms-traffictypediagnostic: MWHPR11MB1614:
x-microsoft-antispam-prvs: <MWHPR11MB161499C1A89C278028E29C5E98E00@MWHPR11MB1614.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:78;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39850400004)(396003)(366004)(376002)(189003)(199004)(186003)(8676002)(99286004)(26005)(72206003)(102836004)(6916009)(316002)(81156014)(478600001)(2616005)(476003)(66066001)(76176011)(81166006)(52116002)(66446008)(64756008)(73956011)(66946007)(6506007)(386003)(44832011)(50226002)(446003)(11346002)(486006)(8936002)(54906003)(6436002)(5660300002)(71200400001)(68736007)(107886003)(53936002)(6512007)(71190400001)(2906002)(66476007)(66556008)(86362001)(305945005)(36756003)(25786009)(256004)(118296001)(4326008)(14454004)(6116002)(3846002)(6486002)(7736002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1614;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2L+3NoBP9SDSM2Qct71Hli7Fe5N/D7ZKVYA9kDfeLwn9Lmd0HOpPH9Nm+wjtrMvum9xYowZDP0hIqUkySB+zohPIHL9/PUClF1xbFwSOgCAgrkZbnxdkK95FyS756CvhcKCZz6cX8YeiwyP3WO+qDSl3zX5XABTXXa8qzNPHGCCIMsH2OnBnRpAVrng27nphRk9TY4FoPZsSOK0CB7+OODkLBwN+nU+0jbc2UvB0g4eqMikK9Mdk2o65V2xDFt9hEGLAEXOreq7u1REXwwssitgyD4tyElGq3v3BNgOwbGRF1MatdzYmZXCygO5W7rzRskiaDmxrlcgIFEMM2UUp50L5JuoE6qHLTHEEX492KyLShUliLzUUo+btYHILGMwPxN8i5QDdlmQSv19/Z0Q4a3XMqsZI6ve3kzsnslSNG6o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9f3b83-22b0-449c-a2c1-08d6f8b62998
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:10:58.9262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1614
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c2V0X2ZlYXR1cmVzIHNob3VsZCB1cGRhdGUgZmxhZ3MgYW5kIHJlaW5pdCBoYXJkd2FyZSBpZg0K
dmxhbiBvZmZsb2FkIHNldHRpbmdzIHdlcmUgY2hhbmdlZC4NCg0KU2lnbmVkLW9mZi1ieTogSWdv
ciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVhbnRpYS5jb20+DQpUZXN0ZWQtYnk6IE5pa2l0
YSBEYW5pbG92IDxuZGFuaWxvdkBhcXVhbnRpYS5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0
L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYyAgfCAzNCArKysrKysrKysrKysrKystLS0tDQog
MSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmMNCmluZGV4
IDUzMTVkZjVmZjZmOC4uMTAwNzIyYWQ1YzJkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmMNCkBAIC0xMDgsMTEgKzEwOCwxNiBAQCBz
dGF0aWMgaW50IGFxX25kZXZfY2hhbmdlX210dShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50
IG5ld19tdHUpDQogc3RhdGljIGludCBhcV9uZGV2X3NldF9mZWF0dXJlcyhzdHJ1Y3QgbmV0X2Rl
dmljZSAqbmRldiwNCiAJCQkJbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQogew0KKwlib29s
IGlzX3ZsYW5fcnhfc3RyaXAgPSAhIShmZWF0dXJlcyAmIE5FVElGX0ZfSFdfVkxBTl9DVEFHX1JY
KTsNCisJYm9vbCBpc192bGFuX3R4X2luc2VydCA9ICEhKGZlYXR1cmVzICYgTkVUSUZfRl9IV19W
TEFOX0NUQUdfVFgpOw0KIAlzdHJ1Y3QgYXFfbmljX3MgKmFxX25pYyA9IG5ldGRldl9wcml2KG5k
ZXYpOw0KLQlzdHJ1Y3QgYXFfbmljX2NmZ19zICphcV9jZmcgPSBhcV9uaWNfZ2V0X2NmZyhhcV9u
aWMpOw0KKwlib29sIG5lZWRfbmRldl9yZXN0YXJ0ID0gZmFsc2U7DQorCXN0cnVjdCBhcV9uaWNf
Y2ZnX3MgKmFxX2NmZzsNCiAJYm9vbCBpc19scm8gPSBmYWxzZTsNCiAJaW50IGVyciA9IDA7DQog
DQorCWFxX2NmZyA9IGFxX25pY19nZXRfY2ZnKGFxX25pYyk7DQorDQogCWlmICghKGZlYXR1cmVz
ICYgTkVUSUZfRl9OVFVQTEUpKSB7DQogCQlpZiAoYXFfbmljLT5uZGV2LT5mZWF0dXJlcyAmIE5F
VElGX0ZfTlRVUExFKSB7DQogCQkJZXJyID0gYXFfY2xlYXJfcnhuZmNfYWxsX3J1bGVzKGFxX25p
Yyk7DQpAQCAtMTM1LDE3ICsxNDAsMzIgQEAgc3RhdGljIGludCBhcV9uZGV2X3NldF9mZWF0dXJl
cyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwNCiANCiAJCWlmIChhcV9jZmctPmlzX2xybyAhPSBp
c19scm8pIHsNCiAJCQlhcV9jZmctPmlzX2xybyA9IGlzX2xybzsNCi0NCi0JCQlpZiAobmV0aWZf
cnVubmluZyhuZGV2KSkgew0KLQkJCQlhcV9uZGV2X2Nsb3NlKG5kZXYpOw0KLQkJCQlhcV9uZGV2
X29wZW4obmRldik7DQotCQkJfQ0KKwkJCW5lZWRfbmRldl9yZXN0YXJ0ID0gdHJ1ZTsNCiAJCX0N
CiAJfQ0KLQlpZiAoKGFxX25pYy0+bmRldi0+ZmVhdHVyZXMgXiBmZWF0dXJlcykgJiBORVRJRl9G
X1JYQ1NVTSkNCisNCisJaWYgKChhcV9uaWMtPm5kZXYtPmZlYXR1cmVzIF4gZmVhdHVyZXMpICYg
TkVUSUZfRl9SWENTVU0pIHsNCiAJCWVyciA9IGFxX25pYy0+YXFfaHdfb3BzLT5od19zZXRfb2Zm
bG9hZChhcV9uaWMtPmFxX2h3LA0KIAkJCQkJCQlhcV9jZmcpOw0KIA0KKwkJaWYgKHVubGlrZWx5
KGVycikpDQorCQkJZ290byBlcnJfZXhpdDsNCisJfQ0KKw0KKwlpZiAoYXFfY2ZnLT5pc192bGFu
X3J4X3N0cmlwICE9IGlzX3ZsYW5fcnhfc3RyaXApIHsNCisJCWFxX2NmZy0+aXNfdmxhbl9yeF9z
dHJpcCA9IGlzX3ZsYW5fcnhfc3RyaXA7DQorCQluZWVkX25kZXZfcmVzdGFydCA9IHRydWU7DQor
CX0NCisJaWYgKGFxX2NmZy0+aXNfdmxhbl90eF9pbnNlcnQgIT0gaXNfdmxhbl90eF9pbnNlcnQp
IHsNCisJCWFxX2NmZy0+aXNfdmxhbl90eF9pbnNlcnQgPSBpc192bGFuX3R4X2luc2VydDsNCisJ
CW5lZWRfbmRldl9yZXN0YXJ0ID0gdHJ1ZTsNCisJfQ0KKw0KKwlpZiAobmVlZF9uZGV2X3Jlc3Rh
cnQgJiYgbmV0aWZfcnVubmluZyhuZGV2KSkgew0KKwkJYXFfbmRldl9jbG9zZShuZGV2KTsNCisJ
CWFxX25kZXZfb3BlbihuZGV2KTsNCisJfQ0KKw0KIGVycl9leGl0Og0KIAlyZXR1cm4gZXJyOw0K
IH0NCi0tIA0KMi4xNy4xDQoNCg==
