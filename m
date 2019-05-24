Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64929413
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390106AbfEXJAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:00:39 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:58510
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389837AbfEXJAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:00:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIIwCA8BdsWtnTPZmiKd1HDBmFk+WkATNZooV1VjWwY=;
 b=SS9OCC1+i5Wjq2+NKWqpK2PalZoK/4MawpcQovw5JvcN6yAiRKlETShC+5vZEKZAbNHq/YHUI3hGQNaE816m2nAJEbP2iGIn7qrWuuHvte+8WVzRdHd5O+QGJ5+qySDc9oSp+Rt3k4ZnujZ7vyYzRi4K4+4pm9eBMAp7So0Okqk=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM (10.166.146.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 24 May 2019 09:00:28 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5%3]) with mapi id 15.20.1922.016; Fri, 24 May 2019
 09:00:28 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/5] net: dsa: implement vtu_getnext and vtu_loadpurge for
 mv88e6250
Thread-Topic: [PATCH v2 3/5] net: dsa: implement vtu_getnext and vtu_loadpurge
 for mv88e6250
Thread-Index: AQHVEg8hoj45jgceM0qMOdngN0r/eA==
Date:   Fri, 24 May 2019 09:00:27 +0000
Message-ID: <20190524085921.11108-4-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0802CA0015.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::25) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dea48259-5b8d-4e55-979b-08d6e026441e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB1535;
x-ms-traffictypediagnostic: VI1PR10MB1535:
x-microsoft-antispam-prvs: <VI1PR10MB153522FA334E9DCB49CB8F998A020@VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(42882007)(66946007)(73956011)(81166006)(102836004)(66066001)(6116002)(76176011)(1076003)(25786009)(52116002)(478600001)(386003)(6512007)(6506007)(186003)(3846002)(74482002)(72206003)(4326008)(66556008)(64756008)(66446008)(66476007)(316002)(26005)(36756003)(68736007)(50226002)(305945005)(5660300002)(7736002)(6436002)(44832011)(256004)(486006)(53936002)(8676002)(81156014)(8976002)(110136005)(476003)(6486002)(8936002)(446003)(2906002)(11346002)(54906003)(2616005)(99286004)(71190400001)(71200400001)(14454004)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1535;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C4slFItwTMx3BvOFooH9ovOL3o246xCfmrboBPL3vm1pZJ+moOoOLi/q68xT+GoCWcWphLpFHGpyVUME5N+UmzD/SUMpxn7eQgHQvMZHhAOAv9+kkmtmc84+tP5LLWKI7Mz61ybgQwea1L1ZNUKIcT3KRcNtyCW/x2S3fMgLYJJbC0slavu21mU+aKeOenlhPzUR55O2mVrBxucNY4ED1lqN586/COPAZ1Nx9wpyxeM6tNJGREk3R45eZErKOPkPwYevakRFHuculxSalxleiQdZpDbs0kraq1jsrsWt0AZkooib2ZatIOvNYKAReZ3ULas2Ceo5ZFIEBpoBB1gxtnTeQY4PIaO/freIl/9oxWtnjY8tZZw06FjdqVcjSm3vMSEYU4VdGSL4qx4kIS5g2VuT/qSm6bZvjYYdJRIjjFQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: dea48259-5b8d-4e55-979b-08d6e026441e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:00:27.9516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1535
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
ZyBvbmUpLg0KDQpSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KU2ln
bmVkLW9mZi1ieTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+
DQotLS0NCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuaCAgICAgfCAgNCArKw0K
IGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYyB8IDU4ICsrKysrKysrKysr
KysrKysrKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDYyIGluc2VydGlvbnMoKykNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oIGIvZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgNCmluZGV4IGJlZjAxMzMxMjY2Zi4uYjIwNWIwYmJh
MTU4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgNCisr
KyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oDQpAQCAtMzA1LDYgKzMwNSwx
MCBAQCBpbnQgbXY4OGU2MTg1X2cxX3Z0dV9nZXRuZXh0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAq
Y2hpcCwNCiAJCQkgICAgIHN0cnVjdCBtdjg4ZTZ4eHhfdnR1X2VudHJ5ICplbnRyeSk7DQogaW50
IG12ODhlNjE4NV9nMV92dHVfbG9hZHB1cmdlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwN
CiAJCQkgICAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCitpbnQgbXY4
OGU2MjUwX2cxX3Z0dV9nZXRuZXh0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkg
ICAgIHN0cnVjdCBtdjg4ZTZ4eHhfdnR1X2VudHJ5ICplbnRyeSk7DQoraW50IG12ODhlNjI1MF9n
MV92dHVfbG9hZHB1cmdlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkgICAgICAg
c3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCiBpbnQgbXY4OGU2MzUyX2cxX3Z0
dV9nZXRuZXh0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJCQkgICAgIHN0cnVjdCBt
djg4ZTZ4eHhfdnR1X2VudHJ5ICplbnRyeSk7DQogaW50IG12ODhlNjM1Ml9nMV92dHVfbG9hZHB1
cmdlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L2dsb2JhbDFfdnR1LmMNCmluZGV4IDA1ODMyNjkyNGYzZS4uYThlZjI2OGMzMmNiIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX3Z0dS5jDQorKysgYi9kcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMNCkBAIC0zMDcsNiArMzA3LDM1IEBA
IHN0YXRpYyBpbnQgbXY4OGU2eHh4X2cxX3Z0dV9nZXRuZXh0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hp
cCAqY2hpcCwNCiAJcmV0dXJuIG12ODhlNnh4eF9nMV92dHVfdmlkX3JlYWQoY2hpcCwgZW50cnkp
Ow0KIH0NCiANCitpbnQgbXY4OGU2MjUwX2cxX3Z0dV9nZXRuZXh0KHN0cnVjdCBtdjg4ZTZ4eHhf
Y2hpcCAqY2hpcCwNCisJCQkgICAgIHN0cnVjdCBtdjg4ZTZ4eHhfdnR1X2VudHJ5ICplbnRyeSkN
Cit7DQorCXUxNiB2YWw7DQorCWludCBlcnI7DQorDQorCWVyciA9IG12ODhlNnh4eF9nMV92dHVf
Z2V0bmV4dChjaGlwLCBlbnRyeSk7DQorCWlmIChlcnIpDQorCQlyZXR1cm4gZXJyOw0KKw0KKwlp
ZiAoZW50cnktPnZhbGlkKSB7DQorCQllcnIgPSBtdjg4ZTYxODVfZzFfdnR1X2RhdGFfcmVhZChj
aGlwLCBlbnRyeSk7DQorCQlpZiAoZXJyKQ0KKwkJCXJldHVybiBlcnI7DQorDQorCQkvKiBWVFUg
REJOdW1bMzowXSBhcmUgbG9jYXRlZCBpbiBWVFUgT3BlcmF0aW9uIDM6MA0KKwkJICogVlRVIERC
TnVtWzU6NF0gYXJlIGxvY2F0ZWQgaW4gVlRVIE9wZXJhdGlvbiA5OjgNCisJCSAqLw0KKwkJZXJy
ID0gbXY4OGU2eHh4X2cxX3JlYWQoY2hpcCwgTVY4OEU2WFhYX0cxX1ZUVV9PUCwgJnZhbCk7DQor
CQlpZiAoZXJyKQ0KKwkJCXJldHVybiBlcnI7DQorDQorCQllbnRyeS0+ZmlkID0gdmFsICYgMHgw
MDBmOw0KKwkJZW50cnktPmZpZCB8PSAodmFsICYgMHgwMzAwKSA+PiA0Ow0KKwl9DQorDQorCXJl
dHVybiAwOw0KK30NCisNCiBpbnQgbXY4OGU2MTg1X2cxX3Z0dV9nZXRuZXh0KHN0cnVjdCBtdjg4
ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJCQkgICAgIHN0cnVjdCBtdjg4ZTZ4eHhfdnR1X2VudHJ5ICpl
bnRyeSkNCiB7DQpAQCAtMzk2LDYgKzQyNSwzNSBAQCBpbnQgbXY4OGU2MzkwX2cxX3Z0dV9nZXRu
ZXh0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK2lu
dCBtdjg4ZTYyNTBfZzFfdnR1X2xvYWRwdXJnZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAs
DQorCQkJICAgICAgIHN0cnVjdCBtdjg4ZTZ4eHhfdnR1X2VudHJ5ICplbnRyeSkNCit7DQorCXUx
NiBvcCA9IE1WODhFNlhYWF9HMV9WVFVfT1BfVlRVX0xPQURfUFVSR0U7DQorCWludCBlcnI7DQor
DQorCWVyciA9IG12ODhlNnh4eF9nMV92dHVfb3Bfd2FpdChjaGlwKTsNCisJaWYgKGVycikNCisJ
CXJldHVybiBlcnI7DQorDQorCWVyciA9IG12ODhlNnh4eF9nMV92dHVfdmlkX3dyaXRlKGNoaXAs
IGVudHJ5KTsNCisJaWYgKGVycikNCisJCXJldHVybiBlcnI7DQorDQorCWlmIChlbnRyeS0+dmFs
aWQpIHsNCisJCWVyciA9IG12ODhlNjE4NV9nMV92dHVfZGF0YV93cml0ZShjaGlwLCBlbnRyeSk7
DQorCQlpZiAoZXJyKQ0KKwkJCXJldHVybiBlcnI7DQorDQorCQkvKiBWVFUgREJOdW1bMzowXSBh
cmUgbG9jYXRlZCBpbiBWVFUgT3BlcmF0aW9uIDM6MA0KKwkJICogVlRVIERCTnVtWzU6NF0gYXJl
IGxvY2F0ZWQgaW4gVlRVIE9wZXJhdGlvbiA5OjgNCisJCSAqLw0KKwkJb3AgfD0gZW50cnktPmZp
ZCAmIDB4MDAwZjsNCisJCW9wIHw9IChlbnRyeS0+ZmlkICYgMHgwMDMwKSA8PCA4Ow0KKwl9DQor
DQorCXJldHVybiBtdjg4ZTZ4eHhfZzFfdnR1X29wKGNoaXAsIG9wKTsNCit9DQorDQogaW50IG12
ODhlNjE4NV9nMV92dHVfbG9hZHB1cmdlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJ
CQkgICAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KQ0KIHsNCi0tIA0KMi4y
MC4xDQoNCg==
