Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668D610D38
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEATcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:32:24 -0400
Received: from mail-eopbgr30097.outbound.protection.outlook.com ([40.107.3.97]:30801
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfEATcW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 15:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8Ozsr0svN/G73Pw1tcMb9atfEqk3hrAD0fdD6JtnFE=;
 b=tbVqzgU+V+KBxdm1ULo+kzBE+8IKq9sZHSNqc3WPQJiv5bsvEsvzJ3rq2fZ4XhqId2W0KFfKij53Q7U/mDBHwoWli407jvsEEGNzX82DAFU4r0hiU96bgliJyNQzu2dQpvN8j64VkvXDSNLLlWExlD0D+Ptw0acHkQuZDC1bYII=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM (20.177.62.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Wed, 1 May 2019 19:32:13 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 19:32:13 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [RFC PATCH 4/5] net: dsa: implement vtu_getnext and vtu_loadpurge for
 mv88e6250
Thread-Topic: [RFC PATCH 4/5] net: dsa: implement vtu_getnext and
 vtu_loadpurge for mv88e6250
Thread-Index: AQHVAFSTxJvpVJ1k/0ChQ6SyRHzKCw==
Date:   Wed, 1 May 2019 19:32:13 +0000
Message-ID: <20190501193126.19196-5-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0005.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::15) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [5.186.118.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cd7fc2a-e68b-4e3f-8680-08d6ce6bb629
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2382;
x-ms-traffictypediagnostic: VI1PR10MB2382:
x-microsoft-antispam-prvs: <VI1PR10MB2382DE11BC76DB00457FDEC48A3B0@VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(396003)(136003)(346002)(376002)(189003)(199004)(81166006)(6512007)(14454004)(186003)(50226002)(8676002)(107886003)(66066001)(3846002)(71190400001)(4326008)(6116002)(8976002)(478600001)(54906003)(81156014)(1076003)(8936002)(25786009)(71446004)(72206003)(316002)(73956011)(71200400001)(305945005)(74482002)(68736007)(66476007)(76176011)(44832011)(486006)(64756008)(53936002)(66446008)(66556008)(256004)(99286004)(110136005)(6436002)(446003)(386003)(476003)(11346002)(6486002)(7736002)(26005)(6506007)(42882007)(2906002)(66946007)(2616005)(36756003)(52116002)(102836004)(5660300002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2382;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YxJ1UIUyPMBfUALNJAIv7TPugDh7dGvoOdJm6WS+d6nAADnNogdhSQsoUcB6+v9UWIOQc6naVe+1tKrTlvLW8RJMHllYNVtl5pH4d+19qotHH4SOmIq3O5qJaaGuao7KSq95ydEOzoJ0EkFFap+tpk4mY0293b/XdLU7wxANzJ839KemR5O6eMZfOJW3NtM4OXenX9j09aS6KCVq68pT1rpGPJorM1gduUO6OL0bUSX8oU9INwu+cSC3s9eUeVhbmy7uaXZWa9V0TguxSQhmq4mqen14C0AuDsXb3Z1yhtMitwwFsQA0vVmT00j2GnbDDw6KmYF7lHxg3y9hpiiFH6o5NMsG8mcDtw+Lqexb4tjXUm66JIwWHyfo41Sz8ss2KEiqXiWx39kKWj+fJnYQiKSD4RFKa17PMSKaWH6gl+8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd7fc2a-e68b-4e3f-8680-08d6ce6bb629
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 19:32:13.5343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlc2UgYXJlIGFsbW9zdCBpZGVudGljYWwgdG8gdGhlIDYxODUgdmFyaWFudHMsIGJ1dCBoYXZl
IGZld2VyIGJpdHMNCmZvciB0aGUgRklELg0KDQpCaXQgMTAgb2YgdGhlIFZUVV9PUCByZWdpc3Rl
ciAob2Zmc2V0IDB4MDUpIGlzIHRoZSBWaWRQb2xpY3kgYml0LA0Kd2hpY2ggb25lIHNob3VsZCBw
cm9iYWJseSBwcmVzZXJ2ZSBpbiBtdjg4ZTZ4eHhfZzFfdnR1X29wKCksIGluc3RlYWQNCm9mIGFs
d2F5cyB3cml0aW5nIGEgMC4gSG93ZXZlciwgb24gdGhlIDYzNTIgZmFtaWx5LCB0aGF0IGJpdCBp
cw0KbG9jYXRlZCBhdCBiaXQgMTIgaW4gdGhlIFZUVSBGSUQgcmVnaXN0ZXIgKG9mZnNldCAweDAy
KSwgYW5kIGlzIGFsd2F5cw0KdW5jb25kaXRpb25hbGx5IGNsZWFyZWQgYnkgdGhlIG12ODhlNnh4
eF9nMV92dHVfZmlkX3dyaXRlKCkNCmZ1bmN0aW9uLg0KDQpTaW5jZSBub3RoaW5nIGluIHRoZSBl
eGlzdGluZyBkcml2ZXIgc2VlbXMgdG8ga25vdyBvciBjYXJlIGFib3V0IHRoYXQNCmJpdCwgaXQg
c2VlbXMgcmVhc29uYWJsZSB0byBub3QgYWRkIHRoZSBib2lsZXJwbGF0ZSB0byBwcmVzZXJ2ZSBp
dCBmb3INCnRoZSA2MjUwICh3aGljaCB3b3VsZCByZXF1aXJlIGFkZGluZyBhIGNoaXAtc3BlY2lm
aWMgdnR1X29wIGZ1bmN0aW9uLA0Kb3IgYWRkaW5nIGNoaXAtcXVpcmtzIHRvIHRoZSBleGlzdGlu
ZyBvbmUpLg0KDQpTaWduZWQtb2ZmLWJ5OiBSYXNtdXMgVmlsbGVtb2VzIDxyYXNtdXMudmlsbGVt
b2VzQHByZXZhcy5kaz4NCi0tLQ0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5o
ICAgICB8ICA0ICsrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX3Z0dS5jIHwg
NTggKysrKysrKysrKysrKysrKysrKysrKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgNjIgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwx
LmggYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuaA0KaW5kZXggYmVmMDEzMzEy
NjZmLi5iMjA1YjBiYmExNTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L2dsb2JhbDEuaA0KKysrIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgNCkBA
IC0zMDUsNiArMzA1LDEwIEBAIGludCBtdjg4ZTYxODVfZzFfdnR1X2dldG5leHQoc3RydWN0IG12
ODhlNnh4eF9jaGlwICpjaGlwLA0KIAkJCSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkg
KmVudHJ5KTsNCiBpbnQgbXY4OGU2MTg1X2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4
eF9jaGlwICpjaGlwLA0KIAkJCSAgICAgICBzdHJ1Y3QgbXY4OGU2eHh4X3Z0dV9lbnRyeSAqZW50
cnkpOw0KK2ludCBtdjg4ZTYyNTBfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlw
ICpjaGlwLA0KKwkJCSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCitp
bnQgbXY4OGU2MjUwX2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlw
LA0KKwkJCSAgICAgICBzdHJ1Y3QgbXY4OGU2eHh4X3Z0dV9lbnRyeSAqZW50cnkpOw0KIGludCBt
djg4ZTYzNTJfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAkJ
CSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCiBpbnQgbXY4OGU2MzUy
X2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYyBiL2RyaXZlcnMvbmV0
L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYw0KaW5kZXggMDU4MzI2OTI0ZjNlLi5hOGVmMjY4
YzMyY2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYw0KQEAgLTMw
Nyw2ICszMDcsMzUgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfZzFfdnR1X2dldG5leHQoc3RydWN0
IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAlyZXR1cm4gbXY4OGU2eHh4X2cxX3Z0dV92aWRfcmVh
ZChjaGlwLCBlbnRyeSk7DQogfQ0KIA0KK2ludCBtdjg4ZTYyNTBfZzFfdnR1X2dldG5leHQoc3Ry
dWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KKwkJCSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVf
ZW50cnkgKmVudHJ5KQ0KK3sNCisJdTE2IHZhbDsNCisJaW50IGVycjsNCisNCisJZXJyID0gbXY4
OGU2eHh4X2cxX3Z0dV9nZXRuZXh0KGNoaXAsIGVudHJ5KTsNCisJaWYgKGVycikNCisJCXJldHVy
biBlcnI7DQorDQorCWlmIChlbnRyeS0+dmFsaWQpIHsNCisJCWVyciA9IG12ODhlNjE4NV9nMV92
dHVfZGF0YV9yZWFkKGNoaXAsIGVudHJ5KTsNCisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsN
CisNCisJCS8qIFZUVSBEQk51bVszOjBdIGFyZSBsb2NhdGVkIGluIFZUVSBPcGVyYXRpb24gMzow
DQorCQkgKiBWVFUgREJOdW1bNTo0XSBhcmUgbG9jYXRlZCBpbiBWVFUgT3BlcmF0aW9uIDk6OA0K
KwkJICovDQorCQllcnIgPSBtdjg4ZTZ4eHhfZzFfcmVhZChjaGlwLCBNVjg4RTZYWFhfRzFfVlRV
X09QLCAmdmFsKTsNCisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCisNCisJCWVudHJ5LT5m
aWQgPSB2YWwgJiAweDAwMGY7DQorCQllbnRyeS0+ZmlkIHw9ICh2YWwgJiAweDAzMDApID4+IDQ7
DQorCX0NCisNCisJcmV0dXJuIDA7DQorfQ0KKw0KIGludCBtdjg4ZTYxODVfZzFfdnR1X2dldG5l
eHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAkJCSAgICAgc3RydWN0IG12ODhlNnh4
eF92dHVfZW50cnkgKmVudHJ5KQ0KIHsNCkBAIC0zOTYsNiArNDI1LDM1IEBAIGludCBtdjg4ZTYz
OTBfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAlyZXR1cm4g
MDsNCiB9DQogDQoraW50IG12ODhlNjI1MF9nMV92dHVfbG9hZHB1cmdlKHN0cnVjdCBtdjg4ZTZ4
eHhfY2hpcCAqY2hpcCwNCisJCQkgICAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVu
dHJ5KQ0KK3sNCisJdTE2IG9wID0gTVY4OEU2WFhYX0cxX1ZUVV9PUF9WVFVfTE9BRF9QVVJHRTsN
CisJaW50IGVycjsNCisNCisJZXJyID0gbXY4OGU2eHh4X2cxX3Z0dV9vcF93YWl0KGNoaXApOw0K
KwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJZXJyID0gbXY4OGU2eHh4X2cxX3Z0dV92
aWRfd3JpdGUoY2hpcCwgZW50cnkpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJ
aWYgKGVudHJ5LT52YWxpZCkgew0KKwkJZXJyID0gbXY4OGU2MTg1X2cxX3Z0dV9kYXRhX3dyaXRl
KGNoaXAsIGVudHJ5KTsNCisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCisNCisJCS8qIFZU
VSBEQk51bVszOjBdIGFyZSBsb2NhdGVkIGluIFZUVSBPcGVyYXRpb24gMzowDQorCQkgKiBWVFUg
REJOdW1bNTo0XSBhcmUgbG9jYXRlZCBpbiBWVFUgT3BlcmF0aW9uIDk6OA0KKwkJICovDQorCQlv
cCB8PSBlbnRyeS0+ZmlkICYgMHgwMDBmOw0KKwkJb3AgfD0gKGVudHJ5LT5maWQgJiAweDAwMzAp
IDw8IDg7DQorCX0NCisNCisJcmV0dXJuIG12ODhlNnh4eF9nMV92dHVfb3AoY2hpcCwgb3ApOw0K
K30NCisNCiBpbnQgbXY4OGU2MTg1X2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9j
aGlwICpjaGlwLA0KIAkJCSAgICAgICBzdHJ1Y3QgbXY4OGU2eHh4X3Z0dV9lbnRyeSAqZW50cnkp
DQogew0KLS0gDQoyLjIwLjENCg0K
