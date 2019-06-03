Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF8F33270
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfFCOmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:33 -0400
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:11233
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728907AbfFCOmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nKUKY2OpAqry2zX9Ld0n5DAnVgZwbnwz9pDNoXfgSg=;
 b=s9VYzuH6sLL589MVxKZj6OTceEcat/oYJj2e9IPiC+HnHtXa2PErgbb56QJWvbrFTnhby6B59gJTzIQqFGmbl7jOfILF5PbbzTLA/likB2W/gDSfLFSsfvdnPkFe3VJY5FjQZ/Mr2QF1664SAYO2Mfo8+2LrZjCTxMms630Da2I=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:13 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:13 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 02/10] net: dsa: mv88e6xxx: introduce support for
 two chips using direct smi addressing
Thread-Topic: [PATCH net-next v3 02/10] net: dsa: mv88e6xxx: introduce support
 for two chips using direct smi addressing
Thread-Index: AQHVGhqINajDwlHVYk+q0yJ4mr+inA==
Date:   Mon, 3 Jun 2019 14:42:13 +0000
Message-ID: <20190603144112.27713-3-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:3:64::14) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90549a52-7841-4e3e-b2a6-08d6e831aac2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB25749D56EC451DFA9757F24A8A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(14444005)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oEvD/T19r/OY7+ZTH7BTdv80HVB34whJCxv3530wBYVIlY4Xr/rbt3+XzeY48zaRVNfM3FtVoGOPHfolXhS5kBD/bSpJx598GEY6R9r/jiwHyPYZhcN7urFu4yuGGKJrDCpiaV9EDZ7Dx3VQgNkK4eznPdXfgYZ7gPjPcIdZ5Em8iLBgv3105EE+rBnN4yVDZ/G981pggNHP8cbqtwluh+4F03jS4H45R8YmPTylsPqsozaQkS4lO2Vt0/xmSDomNjnWC4M2bGq9IQsOrefh5HeTPwq8W7hQ6VogNlH3C8b2gUfJLeX8nAktte9OLrGt76WITIDECMuYaz5qswV2jRGT/cCGJ3juvVTKrevhu1jrNcnH1NdlrRc8E+b+l0e+ZVpslZJYXvWL3liqyiAO71IcT6ngNkbJSyJnUTEM38I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 90549a52-7841-4e3e-b2a6-08d6e831aac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:13.8020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2574
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
bGwgdXNpbmcgZGlyZWN0IGFkZHJlc3NpbmcuDQoNClJldmlld2VkLWJ5OiBWaXZpZW4gRGlkZWxv
dCA8dml2aWVuLmRpZGVsb3RAZ21haWwuY29tPg0KUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxh
bmRyZXdAbHVubi5jaD4NClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52
aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlw
LmggfCAgNiArKysrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3NtaS5jICB8IDI1ICsr
KysrKysrKysrKysrKysrKysrKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvY2hpcC5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmgNCmluZGV4IGZhYTNm
YTg4OWYxOS4uNzQ3NzdjM2JjMzEzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhl
Nnh4eC9jaGlwLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5oDQpAQCAt
MTEyLDYgKzExMiwxMiBAQCBzdHJ1Y3QgbXY4OGU2eHh4X2luZm8gew0KIAkgKiB3aGVuIGl0IGlz
IG5vbi16ZXJvLCBhbmQgdXNlIGluZGlyZWN0IGFjY2VzcyB0byBpbnRlcm5hbCByZWdpc3RlcnMu
DQogCSAqLw0KIAlib29sIG11bHRpX2NoaXA7DQorCS8qIER1YWwtY2hpcCBBZGRyZXNzaW5nIE1v
ZGUNCisJICogU29tZSBjaGlwcyByZXNwb25kIHRvIG9ubHkgaGFsZiBvZiB0aGUgMzIgU01JIGFk
ZHJlc3NlcywNCisJICogYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24gdGhlIHNhbWUgU01JIGlu
dGVyZmFjZS4NCisJICovDQorCWJvb2wgZHVhbF9jaGlwOw0KKw0KIAllbnVtIGRzYV90YWdfcHJv
dG9jb2wgdGFnX3Byb3RvY29sOw0KIA0KIAkvKiBNYXNrIGZvciBGcm9tUG9ydCBhbmQgVG9Qb3J0
IHZhbHVlIG9mIFBvcnRWZWMgdXNlZCBpbiBBVFUgTW92ZQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvc21pLmMgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3NtaS5j
DQppbmRleCA5NmY3ZDI2ODViZGMuLjc3NWY4ZDU1YTk2MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvc21pLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgv
c21pLmMNCkBAIC0yNCw2ICsyNCwxMCBAQA0KICAqIFdoZW4gQUREUiBpcyBub24temVybywgdGhl
IGNoaXAgdXNlcyBNdWx0aS1jaGlwIEFkZHJlc3NpbmcgTW9kZSwgYWxsb3dpbmcNCiAgKiBtdWx0
aXBsZSBkZXZpY2VzIHRvIHNoYXJlIHRoZSBTTUkgaW50ZXJmYWNlLiBJbiB0aGlzIG1vZGUgaXQg
cmVzcG9uZHMgdG8gb25seQ0KICAqIDIgcmVnaXN0ZXJzLCB1c2VkIHRvIGluZGlyZWN0bHkgYWNj
ZXNzIHRoZSBpbnRlcm5hbCBTTUkgZGV2aWNlcy4NCisgKg0KKyAqIFNvbWUgY2hpcHMgdXNlIGEg
ZGlmZmVyZW50IHNjaGVtZTogT25seSB0aGUgQUREUjQgcGluIGlzIHVzZWQgZm9yDQorICogY29u
ZmlndXJhdGlvbiwgYW5kIHRoZSBkZXZpY2UgcmVzcG9uZHMgdG8gMTYgb2YgdGhlIDMyIFNNSQ0K
KyAqIGFkZHJlc3NlcywgYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24gdGhlIHNhbWUgU01JIGlu
dGVyZmFjZS4NCiAgKi8NCiANCiBzdGF0aWMgaW50IG12ODhlNnh4eF9zbWlfZGlyZWN0X3JlYWQo
c3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KQEAgLTc2LDYgKzgwLDIzIEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9kaXJlY3Rfb3BzID0g
ew0KIAkud3JpdGUgPSBtdjg4ZTZ4eHhfc21pX2RpcmVjdF93cml0ZSwNCiB9Ow0KIA0KK3N0YXRp
YyBpbnQgbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9yZWFkKHN0cnVjdCBtdjg4ZTZ4eHhfY2hp
cCAqY2hpcCwNCisJCQkJCSAgaW50IGRldiwgaW50IHJlZywgdTE2ICpkYXRhKQ0KK3sNCisJcmV0
dXJuIG12ODhlNnh4eF9zbWlfZGlyZWN0X3JlYWQoY2hpcCwgY2hpcC0+c3dfYWRkciArIGRldiwg
cmVnLCBkYXRhKTsNCit9DQorDQorc3RhdGljIGludCBtdjg4ZTZ4eHhfc21pX2R1YWxfZGlyZWN0
X3dyaXRlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkJCSAgIGludCBkZXYsIGlu
dCByZWcsIHUxNiBkYXRhKQ0KK3sNCisJcmV0dXJuIG12ODhlNnh4eF9zbWlfZGlyZWN0X3dyaXRl
KGNoaXAsIGNoaXAtPnN3X2FkZHIgKyBkZXYsIHJlZywgZGF0YSk7DQorfQ0KKw0KK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9v
cHMgPSB7DQorCS5yZWFkID0gbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9yZWFkLA0KKwkud3Jp
dGUgPSBtdjg4ZTZ4eHhfc21pX2R1YWxfZGlyZWN0X3dyaXRlLA0KK307DQorDQogLyogT2Zmc2V0
IDB4MDA6IFNNSSBDb21tYW5kIFJlZ2lzdGVyDQogICogT2Zmc2V0IDB4MDE6IFNNSSBEYXRhIFJl
Z2lzdGVyDQogICovDQpAQCAtMTQ0LDcgKzE2NSw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4
OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9pbmRpcmVjdF9vcHMgPSB7DQogaW50IG12ODhl
Nnh4eF9zbWlfaW5pdChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCQkgICAgICAgc3Ry
dWN0IG1paV9idXMgKmJ1cywgaW50IHN3X2FkZHIpDQogew0KLQlpZiAoc3dfYWRkciA9PSAwKQ0K
KwlpZiAoY2hpcC0+aW5mby0+ZHVhbF9jaGlwKQ0KKwkJY2hpcC0+c21pX29wcyA9ICZtdjg4ZTZ4
eHhfc21pX2R1YWxfZGlyZWN0X29wczsNCisJZWxzZSBpZiAoc3dfYWRkciA9PSAwKQ0KIAkJY2hp
cC0+c21pX29wcyA9ICZtdjg4ZTZ4eHhfc21pX2RpcmVjdF9vcHM7DQogCWVsc2UgaWYgKGNoaXAt
PmluZm8tPm11bHRpX2NoaXApDQogCQljaGlwLT5zbWlfb3BzID0gJm12ODhlNnh4eF9zbWlfaW5k
aXJlY3Rfb3BzOw0KLS0gDQoyLjIwLjENCg0K
