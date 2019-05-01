Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CCA10D34
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfEATcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:32:17 -0400
Received: from mail-eopbgr30097.outbound.protection.outlook.com ([40.107.3.97]:30801
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfEATcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 15:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vPeVmMtyTHgwP5h7upLZPHu6LlY0VeVXcswS51oeXM=;
 b=pdN1xu8zp9Aqlat1CoIR+IR0Mhurrd7dhmEOlUlulO70wcegIfsc9oR6iJgeBEiQ+l8PhAHKrQU1JgxZ3xXHsYjklTfvntJEW6qT/adUC5cYV9IPDYrCX8DfRgGJtByBZaM2hiwvbknBGK73XA3kPRZ0NvP59+EdJ15UYjkAWd0=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM (20.177.62.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Wed, 1 May 2019 19:32:10 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 19:32:10 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [RFC PATCH 1/5] net: dsa: mv88e6xxx: introduce support for two chips
 using direct smi addressing
Thread-Topic: [RFC PATCH 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
Thread-Index: AQHVAFSRDSaXDG0750O+aewkwJZ2+w==
Date:   Wed, 1 May 2019 19:32:10 +0000
Message-ID: <20190501193126.19196-2-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: d89a25cc-ec7d-4cce-3888-08d6ce6bb417
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2382;
x-ms-traffictypediagnostic: VI1PR10MB2382:
x-microsoft-antispam-prvs: <VI1PR10MB23820C8CBAE33977E3DA180B8A3B0@VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(396003)(136003)(346002)(376002)(189003)(199004)(81166006)(6512007)(14454004)(186003)(50226002)(8676002)(107886003)(66066001)(3846002)(71190400001)(4326008)(6116002)(8976002)(478600001)(54906003)(81156014)(1076003)(8936002)(25786009)(71446004)(72206003)(316002)(73956011)(71200400001)(305945005)(74482002)(68736007)(66476007)(76176011)(44832011)(486006)(64756008)(53936002)(66446008)(66556008)(14444005)(256004)(99286004)(110136005)(6436002)(446003)(386003)(476003)(11346002)(6486002)(7736002)(26005)(6506007)(42882007)(2906002)(66946007)(2616005)(36756003)(52116002)(102836004)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2382;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iOpFkXJnRPCw7klGyfrSra/4qrzLApogUlXSb+QLL48xhlxQYVMOeWITSywxhWEYT8S3+F4YeEASayOj1pZtZi/s2m8VIu16ysIigInmDBcRm8JuyuzMxVgU+714vItZ3KzK6hlGiK5BMie2/uu38tX+Chk+6vJLS/QSMvbRhWvM8E+DSJDIrvFgIZmQiiTrUXYha5ZzLThPj8yl5L7+9qSDvtjEH5lxZ8cJUYJaVC+Myu/EIbQ5ZqcsDtUEIpUPZVWRDW4/HCXiyQNokZyJS+L+ivNEea8ZLaDGmPEptW7LuoR0hycDITIfrE7Vokf+UoPoEQ1ZLbKmxo3yDcZ/Rd0lAIlOgEs+KSzk4QpR2/ZUz+FY57B47QxNr4uvzklvsLy9KZeyGR/oLy0lL9Mln31G/xI2ZKdBE83ZTXCysVo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d89a25cc-ec7d-4cce-3888-08d6ce6bb417
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 19:32:10.1589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDg4ZTYyNTAgKGFzIHdlbGwgYXMgNjIyMCwgNjA3MSwgNjA3MCwgNjAyMCkgZG8gbm90IHN1
cHBvcnQNCm11bHRpLWNoaXAgKGluZGlyZWN0KSBhZGRyZXNzaW5nLiBIb3dldmVyLCBvbmUgY2Fu
IHN0aWxsIGhhdmUgdHdvIG9mDQp0aGVtIG9uIHRoZSBzYW1lIG1kaW8gYnVzLCBzaW5jZSB0aGUg
ZGV2aWNlIG9ubHkgdXNlcyAxNiBvZiB0aGUgMzINCnBvc3NpYmxlIGFkZHJlc3NlcywgZWl0aGVy
IGFkZHJlc3NlcyAweDAwLTB4MEYgb3IgMHgxMC0weDFGIGRlcGVuZGluZw0Kb24gdGhlIEFERFI0
IHBpbiBhdCByZXNldCBbc2luY2UgQUREUjQgaXMgaW50ZXJuYWxseSBwdWxsZWQgaGlnaCwgdGhl
DQpsYXR0ZXIgaXMgdGhlIGRlZmF1bHRdLg0KDQpJbiBvcmRlciB0byBwcmVwYXJlIGZvciBzdXBw
b3J0aW5nIHRoZSA4OGU2MjUwIGFuZCBmcmllbmRzLCBpbnRyb2R1Y2UNCm12ODhlNnh4eF9pbmZv
OjpkdWFsX2NoaXAgdG8gYWxsb3cgaGF2aW5nIGEgbm9uLXplcm8gc3dfYWRkciB3aGlsZQ0Kc3Rp
bGwgdXNpbmcgZGlyZWN0IGFkZHJlc3NpbmcuDQoNClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxs
ZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNh
L212ODhlNnh4eC9jaGlwLmMgfCAxMCArKysrKysrLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhl
Nnh4eC9jaGlwLmggfCAgNSArKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvY2hpcC5jIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCmluZGV4IGMwNzhj
NzkxZjQ4MS4uZjY2ZGFhNzc3NzRiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhl
Nnh4eC9jaGlwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jDQpAQCAt
NjIsNiArNjIsMTAgQEAgc3RhdGljIHZvaWQgYXNzZXJ0X3JlZ19sb2NrKHN0cnVjdCBtdjg4ZTZ4
eHhfY2hpcCAqY2hpcCkNCiAgKiBXaGVuIEFERFIgaXMgbm9uLXplcm8sIHRoZSBjaGlwIHVzZXMg
TXVsdGktY2hpcCBBZGRyZXNzaW5nIE1vZGUsIGFsbG93aW5nDQogICogbXVsdGlwbGUgZGV2aWNl
cyB0byBzaGFyZSB0aGUgU01JIGludGVyZmFjZS4gSW4gdGhpcyBtb2RlIGl0IHJlc3BvbmRzIHRv
IG9ubHkNCiAgKiAyIHJlZ2lzdGVycywgdXNlZCB0byBpbmRpcmVjdGx5IGFjY2VzcyB0aGUgaW50
ZXJuYWwgU01JIGRldmljZXMuDQorICoNCisgKiBTb21lIGNoaXBzIHVzZSBhIGRpZmZlcmVudCBz
Y2hlbWU6IE9ubHkgdGhlIEFERFI0IHBpbiBpcyB1c2VkIGZvcg0KKyAqIGNvbmZpZ3VyYXRpb24s
IGFuZCB0aGUgZGV2aWNlIHJlc3BvbmRzIHRvIDE2IG9mIHRoZSAzMiBTTUkNCisgKiBhZGRyZXNz
ZXMsIGFsbG93aW5nIHR3byB0byBjb2V4aXN0IG9uIHRoZSBzYW1lIFNNSSBpbnRlcmZhY2UuDQog
ICovDQogDQogc3RhdGljIGludCBtdjg4ZTZ4eHhfc21pX3JlYWQoc3RydWN0IG12ODhlNnh4eF9j
aGlwICpjaGlwLA0KQEAgLTg3LDcgKzkxLDcgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfc21pX3Np
bmdsZV9jaGlwX3JlYWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIHsNCiAJaW50IHJl
dDsNCiANCi0JcmV0ID0gbWRpb2J1c19yZWFkX25lc3RlZChjaGlwLT5idXMsIGFkZHIsIHJlZyk7
DQorCXJldCA9IG1kaW9idXNfcmVhZF9uZXN0ZWQoY2hpcC0+YnVzLCBhZGRyICsgY2hpcC0+c3df
YWRkciwgcmVnKTsNCiAJaWYgKHJldCA8IDApDQogCQlyZXR1cm4gcmV0Ow0KIA0KQEAgLTEwMSw3
ICsxMDUsNyBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9zbWlfc2luZ2xlX2NoaXBfd3JpdGUoc3Ry
dWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIHsNCiAJaW50IHJldDsNCiANCi0JcmV0ID0gbWRp
b2J1c193cml0ZV9uZXN0ZWQoY2hpcC0+YnVzLCBhZGRyLCByZWcsIHZhbCk7DQorCXJldCA9IG1k
aW9idXNfd3JpdGVfbmVzdGVkKGNoaXAtPmJ1cywgYWRkciArIGNoaXAtPnN3X2FkZHIsIHJlZywg
dmFsKTsNCiAJaWYgKHJldCA8IDApDQogCQlyZXR1cm4gcmV0Ow0KIA0KQEAgLTQ1NDgsNyArNDU1
Miw3IEBAIHN0YXRpYyBzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKm12ODhlNnh4eF9hbGxvY19jaGlw
KHN0cnVjdCBkZXZpY2UgKmRldikNCiBzdGF0aWMgaW50IG12ODhlNnh4eF9zbWlfaW5pdChzdHJ1
Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCQkJICAgICAgc3RydWN0IG1paV9idXMgKmJ1cywg
aW50IHN3X2FkZHIpDQogew0KLQlpZiAoc3dfYWRkciA9PSAwKQ0KKwlpZiAoc3dfYWRkciA9PSAw
IHx8IGNoaXAtPmluZm8tPmR1YWxfY2hpcCkNCiAJCWNoaXAtPnNtaV9vcHMgPSAmbXY4OGU2eHh4
X3NtaV9zaW5nbGVfY2hpcF9vcHM7DQogCWVsc2UgaWYgKGNoaXAtPmluZm8tPm11bHRpX2NoaXAp
DQogCQljaGlwLT5zbWlfb3BzID0gJm12ODhlNnh4eF9zbWlfbXVsdGlfY2hpcF9vcHM7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmggYi9kcml2ZXJzL25ldC9k
c2EvbXY4OGU2eHh4L2NoaXAuaA0KaW5kZXggNTQ2NjUxZDhjM2UxLi41NzU5ZmZmYmQzOWMgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuaA0KKysrIGIvZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmgNCkBAIC0xMjMsNiArMTIzLDExIEBAIHN0cnVjdCBt
djg4ZTZ4eHhfaW5mbyB7DQogCSAqIHdoZW4gaXQgaXMgbm9uLXplcm8sIGFuZCB1c2UgaW5kaXJl
Y3QgYWNjZXNzIHRvIGludGVybmFsIHJlZ2lzdGVycy4NCiAJICovDQogCWJvb2wgbXVsdGlfY2hp
cDsNCisJLyogRHVhbC1jaGlwIEFkZHJlc3NpbmcgTW9kZQ0KKwkgKiBTb21lIGNoaXBzIHJlc3Bv
bmQgdG8gb25seSBoYWxmIG9mIHRoZSAzMiBTTUkgYWRkcmVzc2VzLA0KKwkgKiBhbGxvd2luZyB0
d28gdG8gY29leGlzdCBvbiB0aGUgc2FtZSBTTUkgaW50ZXJmYWNlLg0KKwkgKi8NCisJYm9vbCBk
dWFsX2NoaXA7DQogCWVudW0gZHNhX3RhZ19wcm90b2NvbCB0YWdfcHJvdG9jb2w7DQogDQogCS8q
IE1hc2sgZm9yIEZyb21Qb3J0IGFuZCBUb1BvcnQgdmFsdWUgb2YgUG9ydFZlYyB1c2VkIGluIEFU
VSBNb3ZlDQotLSANCjIuMjAuMQ0KDQo=
