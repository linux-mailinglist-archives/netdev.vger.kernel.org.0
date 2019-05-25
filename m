Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13EE2A3D4
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfEYJ6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:58:04 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:59488
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbfEYJ6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 05:58:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX6PqiN3ewi4dlYGiBzMJJ3mW61LKe1iDwG1dvEr4Rk=;
 b=GUlQ4lo8hJXDdfYDgO22J/WaDG5It89+n5Grb3QlI2yXKPWEci65IGah496Jukg9tS6BwuCXD8oxFAP+IqrNkeuxQTq3BNkZD6fBwisEYsXToWwP62535WY0eBkfmBfxM5l591py1FTA/h/eqOUN6WELfa6xjs/3/aVV2Iz+0q4=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3017.namprd11.prod.outlook.com (20.177.218.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Sat, 25 May 2019 09:58:01 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 09:58:01 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 2/4] net: aquantia: check rx csum for all packets in LRO
 session
Thread-Topic: [PATCH net 2/4] net: aquantia: check rx csum for all packets in
 LRO session
Thread-Index: AQHVEuBWxF0fc2KLVECZyn4MN4KuZA==
Date:   Sat, 25 May 2019 09:58:01 +0000
Message-ID: <460cfe142738b34712a555e98eebe4c6d6df8b0f.1558777421.git.igor.russkikh@aquantia.com>
References: <cover.1558777421.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1558777421.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:bc::19)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2aa2253b-4bab-4d2d-ca2f-08d6e0f778d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR11MB3017;
x-ms-traffictypediagnostic: DM6PR11MB3017:
x-microsoft-antispam-prvs: <DM6PR11MB3017053C540551449425724F98030@DM6PR11MB3017.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:506;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(346002)(376002)(396003)(366004)(39850400004)(43544003)(199004)(189003)(66946007)(71190400001)(486006)(53936002)(66476007)(2616005)(44832011)(71200400001)(66556008)(107886003)(66446008)(73956011)(64756008)(7736002)(6916009)(14454004)(11346002)(478600001)(316002)(25786009)(446003)(6436002)(72206003)(6512007)(6486002)(386003)(118296001)(36756003)(3846002)(4326008)(305945005)(52116002)(6506007)(186003)(76176011)(26005)(2906002)(99286004)(14444005)(476003)(102836004)(256004)(86362001)(5660300002)(54906003)(66066001)(68736007)(81156014)(8676002)(81166006)(50226002)(8936002)(6116002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3017;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Gt2fwvyhpEJXGgTAPj3S48RwqDqLyk43YJ1PtbDpP+iZvfvxaxWsZHvKVJViOSj4799nheAcVz1y5uboy7wnlZz+mSRcVax9d+yk7coqXks8Fc4RWQ04wgNnDEMasfNprWwerfbXADh1BZfsi9PzqaHNlWDtQeTabnDUxRUgbDKIt6M5GyuyXwO3nVt7t6z72pFu2BY5VqY2rAIEmDzS4j2bn6zVzNS7CB/o3x4CQIu16DyZqecBJN/ATXxfWrdTncaA6q6/OzIrWQgRaFefJ3BL5X3m0X823wnzsdld+DOVIwNS290tjd/jvbcC2wBghZrOqz1JH3IG/qV7IP8fuaCRCZh69r/Uk9b/LeiiQL7e6Jkq+4FXY6o+1h6aqHfYpuKY6jMNjFLdjftJ60u7LjZZcvYJw0xoUkbdLst2Uu0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa2253b-4bab-4d2d-ca2f-08d6e0f778d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 09:58:01.2381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG1pdHJ5IEJvZ2Rhbm92IDxkbWl0cnkuYm9nZGFub3ZAYXF1YW50aWEuY29tPg0KDQpB
dGxhbnRpYyBoYXJkd2FyZSBkb2VzIG5vdCBhZ2dyZWdhdGUgbm9yIGJyZWFrcyBMUk8gc2Vzc2lv
bnMNCndpdGggYmFkIGNzdW0gcGFja2V0cy4gVGhpcyBtZWFucyBkcml2ZXIgc2hvdWxkIHRha2Ug
Y2FyZSBvZiB0aGF0Lg0KDQpJZiBpbiBMUk8gc2Vzc2lvbiB0aGVyZSBpcyBhIG5vbi1maXJzdCBk
ZXNjcmlwdG9yIHdpdGggaW52YWxpZA0KY2hlY2tzdW0gKEwyL0wzL0w0KSwgdGhlIGRyaXZlciBt
dXN0IGFjY291bnQgdGhpcyBpbmZvcm1hdGlvbg0KaW4gY3N1bSBhcHBsaWNhdGlvbiBsb2dpYy4N
Cg0KRml4ZXM6IDAxODQyM2U5MGJlZTggKCJuZXQ6IGV0aGVybmV0OiBhcXVhbnRpYTogQWRkIHJp
bmcgc3VwcG9ydCBjb2RlIikNClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2ggPGlnb3IucnVz
c2tpa2hAYXF1YW50aWEuY29tPg0KU2lnbmVkLW9mZi1ieTogRG1pdHJ5IEJvZ2Rhbm92IDxkbWl0
cnkuYm9nZGFub3ZAYXF1YW50aWEuY29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRp
YS9hdGxhbnRpYy9hcV9yaW5nLmMgIHwgNDQgKysrKysrKysrKysrKy0tLS0tLQ0KIDEgZmlsZSBj
aGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3JpbmcuYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3JpbmcuYw0KaW5kZXggNjNlZDAw
NDE1OTA0Li45NDFiMGJlYjg3ZWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9h
cXVhbnRpYS9hdGxhbnRpYy9hcV9yaW5nLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2FxX3JpbmcuYw0KQEAgLTI5OSwzNSArMjk5LDQ3IEBAIGludCBhcV9y
aW5nX3J4X2NsZWFuKHN0cnVjdCBhcV9yaW5nX3MgKnNlbGYsDQogCQl1bnNpZ25lZCBpbnQgaSA9
IDBVOw0KIAkJdTE2IGhkcl9sZW47DQogDQotCQlpZiAoYnVmZi0+aXNfZXJyb3IpDQotCQkJY29u
dGludWU7DQotDQogCQlpZiAoYnVmZi0+aXNfY2xlYW5lZCkNCiAJCQljb250aW51ZTsNCiANCiAJ
CWlmICghYnVmZi0+aXNfZW9wKSB7DQotCQkJZm9yIChuZXh0XyA9IGJ1ZmYtPm5leHQsDQotCQkJ
ICAgICBidWZmXyA9ICZzZWxmLT5idWZmX3JpbmdbbmV4dF9dOyB0cnVlOw0KLQkJCSAgICAgbmV4
dF8gPSBidWZmXy0+bmV4dCwNCi0JCQkgICAgIGJ1ZmZfID0gJnNlbGYtPmJ1ZmZfcmluZ1tuZXh0
X10pIHsNCisJCQlidWZmXyA9IGJ1ZmY7DQorCQkJZG8gew0KKwkJCQluZXh0XyA9IGJ1ZmZfLT5u
ZXh0LA0KKwkJCQlidWZmXyA9ICZzZWxmLT5idWZmX3JpbmdbbmV4dF9dOw0KIAkJCQlpc19yc2Nf
Y29tcGxldGVkID0NCiAJCQkJCWFxX3JpbmdfZHhfaW5fcmFuZ2Uoc2VsZi0+c3dfaGVhZCwNCiAJ
CQkJCQkJICAgIG5leHRfLA0KIAkJCQkJCQkgICAgc2VsZi0+aHdfaGVhZCk7DQogDQotCQkJCWlm
ICh1bmxpa2VseSghaXNfcnNjX2NvbXBsZXRlZCkpIHsNCi0JCQkJCWlzX3JzY19jb21wbGV0ZWQg
PSBmYWxzZTsNCisJCQkJaWYgKHVubGlrZWx5KCFpc19yc2NfY29tcGxldGVkKSkNCiAJCQkJCWJy
ZWFrOw0KLQkJCQl9DQogDQotCQkJCWlmIChidWZmXy0+aXNfZW9wKQ0KLQkJCQkJYnJlYWs7DQot
CQkJfQ0KKwkJCQlidWZmLT5pc19lcnJvciB8PSBidWZmXy0+aXNfZXJyb3I7DQorDQorCQkJfSB3
aGlsZSAoIWJ1ZmZfLT5pc19lb3ApOw0KIA0KIAkJCWlmICghaXNfcnNjX2NvbXBsZXRlZCkgew0K
IAkJCQllcnIgPSAwOw0KIAkJCQlnb3RvIGVycl9leGl0Ow0KIAkJCX0NCisJCQlpZiAoYnVmZi0+
aXNfZXJyb3IpIHsNCisJCQkJYnVmZl8gPSBidWZmOw0KKwkJCQlkbyB7DQorCQkJCQluZXh0XyA9
IGJ1ZmZfLT5uZXh0LA0KKwkJCQkJYnVmZl8gPSAmc2VsZi0+YnVmZl9yaW5nW25leHRfXTsNCisN
CisJCQkJCWJ1ZmZfLT5pc19jbGVhbmVkID0gdHJ1ZTsNCisJCQkJfSB3aGlsZSAoIWJ1ZmZfLT5p
c19lb3ApOw0KKw0KKwkJCQkrK3NlbGYtPnN0YXRzLnJ4LmVycm9yczsNCisJCQkJY29udGludWU7
DQorCQkJfQ0KKwkJfQ0KKw0KKwkJaWYgKGJ1ZmYtPmlzX2Vycm9yKSB7DQorCQkJKytzZWxmLT5z
dGF0cy5yeC5lcnJvcnM7DQorCQkJY29udGludWU7DQogCQl9DQogDQogCQlkbWFfc3luY19zaW5n
bGVfcmFuZ2VfZm9yX2NwdShhcV9uaWNfZ2V0X2RldihzZWxmLT5hcV9uaWMpLA0KQEAgLTM5MCw2
ICs0MDIsMTIgQEAgaW50IGFxX3JpbmdfcnhfY2xlYW4oc3RydWN0IGFxX3JpbmdfcyAqc2VsZiwN
CiAJCQkJCQkJQVFfQ0ZHX1JYX0ZSQU1FX01BWCk7DQogCQkJCQlwYWdlX3JlZl9pbmMoYnVmZl8t
PnJ4ZGF0YS5wYWdlKTsNCiAJCQkJCWJ1ZmZfLT5pc19jbGVhbmVkID0gMTsNCisNCisJCQkJCWJ1
ZmYtPmlzX2lwX2NzbyAmPSBidWZmXy0+aXNfaXBfY3NvOw0KKwkJCQkJYnVmZi0+aXNfdWRwX2Nz
byAmPSBidWZmXy0+aXNfdWRwX2NzbzsNCisJCQkJCWJ1ZmYtPmlzX3RjcF9jc28gJj0gYnVmZl8t
PmlzX3RjcF9jc287DQorCQkJCQlidWZmLT5pc19jc29fZXJyIHw9IGJ1ZmZfLT5pc19jc29fZXJy
Ow0KKw0KIAkJCQl9IHdoaWxlICghYnVmZl8tPmlzX2VvcCk7DQogCQkJfQ0KIAkJfQ0KLS0gDQoy
LjE3LjENCg0K
