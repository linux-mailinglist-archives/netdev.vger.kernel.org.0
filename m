Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002375694E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfFZMf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:35:57 -0400
Received: from mail-eopbgr720068.outbound.protection.outlook.com ([40.107.72.68]:11727
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727598AbfFZMfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXMxDLLfUaL/z2efHMhmhKYK8skQzUuToBYNbZOWXDo=;
 b=cRcVCognfitV8H92h6F95WxEpEZ+3euj0jwvy7UOxoOlLTTqPZJLJHFyl02DgnTdz4BXS7aa0gGqj5YaSd7CQdpB+PwESATgOsgFM/kiw7hoDZnii3Va3+IJB+7mbjnQQqpbw+M6oM+W2M0N9pZIqxGEbdE0S/qrMrrbSXf0G2k=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1535.namprd11.prod.outlook.com (10.172.54.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 12:35:49 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 12:35:49 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v3 8/8] net: aquantia: implement vlan offload
 configuration
Thread-Topic: [PATCH net-next v3 8/8] net: aquantia: implement vlan offload
 configuration
Thread-Index: AQHVLBuvxV66sA5HxE+jCqE29x594g==
Date:   Wed, 26 Jun 2019 12:35:49 +0000
Message-ID: <310dd524af035a8b3359aee19affc29420b67feb.1561552290.git.igor.russkikh@aquantia.com>
References: <cover.1561552290.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561552290.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:7:16::14) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0851780-0a37-4ab0-840d-08d6fa32d132
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1535;
x-ms-traffictypediagnostic: MWHPR11MB1535:
x-microsoft-antispam-prvs: <MWHPR11MB1535D23647AF78782C82AC1B98E20@MWHPR11MB1535.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:78;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(39850400004)(366004)(199004)(189003)(86362001)(25786009)(6486002)(102836004)(6436002)(72206003)(6116002)(66066001)(3846002)(386003)(5660300002)(36756003)(53936002)(478600001)(2906002)(305945005)(7736002)(6512007)(66446008)(73956011)(66556008)(66476007)(64756008)(66946007)(26005)(118296001)(186003)(14444005)(71190400001)(256004)(71200400001)(99286004)(446003)(4326008)(11346002)(54906003)(2616005)(50226002)(476003)(14454004)(316002)(486006)(6506007)(6916009)(68736007)(8936002)(81166006)(81156014)(52116002)(107886003)(44832011)(8676002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1535;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9vmYJxRLWbne3NoMox0J9tMRe3hjyii3KbfUmMgb5ldsXmRWv/hWOAw9qQCB4TBG4irx6N+15ZJRpOJNj5DYjcQxKQoxUkoMfS+JXz1i3WlzXzYuB45acgEEX0IguI7ph++lKhQSKqzqvh8puUCLvHrT0kmQs4rOhr0jZipiJXghUnXrLDGx5nYQbqFWBtY5u9k7oAQHbOClthQpV/P8fqSgpshLIe5OjH5rdOijyIbm2AdnlMnNa1HmRFZZwjDIj8gGS39QL/mUoh6Hhn4Yc7VVyd6Vhn7nLLPTTa0F/WcSnAp+IKEXQ1n16vNkYOF96WvnMCT2LZzwPk9UQJ7/peuMdODm9zT6Q3cnWv3rbve6IxCF5OizNT9yOmaKeWEKrSU/ZwmPIt0g7Kjgp0XttH3PYXfjLbuJQUy7VxvpT2Y=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0851780-0a37-4ab0-840d-08d6fa32d132
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:35:49.0436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1535
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
