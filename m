Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A53404F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfFDHf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:35:29 -0400
Received: from mail-eopbgr00119.outbound.protection.outlook.com ([40.107.0.119]:36579
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726878AbfFDHed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUuC/zcBBXTnAbWFryFjjlUDKuMezvsAc5QjKmVyDGg=;
 b=jGZTo7Zas4tSvjh82HiSi7ILXw5/rIUGvL5wCsbL5t1kaFSQSjZ0gNcHuZuIK4OHywYsZ++jPXT9RbUXGg5AZDJVPfV/rOiP6uE6IQos80wG4FoOiApBLtkSgrKRycQjjMIZhnmDOBIDDL6PzOImRpJ3AgfRYoh5VNZcJXiOVx0=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM (10.255.19.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:28 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:28 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 05/10] net: dsa: mv88e6xxx: implement watchdog_ops
 for mv88e6250
Thread-Topic: [PATCH net-next v4 05/10] net: dsa: mv88e6xxx: implement
 watchdog_ops for mv88e6250
Thread-Index: AQHVGqfx6hGha7ZuiE2c0x9/vQouAQ==
Date:   Tue, 4 Jun 2019 07:34:28 +0000
Message-ID: <20190604073412.21743-6-rasmus.villemoes@prevas.dk>
References: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0030.eurprd03.prod.outlook.com (2603:10a6:20b::43)
 To DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6807589a-6a75-4d05-cae9-08d6e8bf1360
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3068;
x-ms-traffictypediagnostic: DB8PR10MB3068:
x-microsoft-antispam-prvs: <DB8PR10MB3068E6626ADD2C1E42DD81298A150@DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(136003)(376002)(396003)(346002)(189003)(199004)(4326008)(8976002)(8936002)(71200400001)(71190400001)(6436002)(6486002)(68736007)(446003)(486006)(2616005)(11346002)(81156014)(8676002)(66066001)(50226002)(36756003)(81166006)(42882007)(476003)(53936002)(186003)(52116002)(73956011)(76176011)(66946007)(66476007)(66556008)(64756008)(66446008)(99286004)(7736002)(44832011)(25786009)(72206003)(305945005)(478600001)(74482002)(1076003)(256004)(14444005)(6512007)(102836004)(3846002)(26005)(6116002)(386003)(6506007)(316002)(14454004)(54906003)(5660300002)(2906002)(110136005)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3068;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TlSIVZxBW6wT3uAGCATfO41/Nsl4iiVPy+bpbtUVUhFLpf7RjUGbYhOZ3WxkJYKbEkOKNnJaRLPeJ8XhG3sKJTbe71KuCCsz6r8IAQv77o5e3C5+tWIRg0KAkRK8csKjulVawS/3ypXdYdzhwfeHOUcQk3njTrJ7JneegIw6DjzEmmgQfVgz8oxNTUDkKmH5APeDywwcLqPtHJmYz3R7WQM76cLDdTbZEeZyswL5OJSwmO3dzVsVxtuiw6oGJqXkNn/hx21pzEBAaDwbI4670C7kCUSzNKLR3TJ+uxqs7hXpsjSVa+W1xSfkKdtgSPQVDcvxNR26UFODuZCj+DMYTp4y4om0MmC7cKWB7xESk/uBmy0YpTa3At2be18AgByYa4HV5cAaw4ffdZVZBC8zNiRsn83iaRXkx4BiOYJF24Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6807589a-6a75-4d05-cae9-08d6e8bf1360
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:28.3890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIE1WODhFNjM1Ml9HMl9XRE9HX0NUTF8qIGJpdHMgYWxtb3N0LCBidXQgbm90IHF1aXRlLCBk
ZXNjcmliZSB0aGUNCndhdGNoZG9nIGNvbnRyb2wgcmVnaXN0ZXIgb24gdGhlIG12ODhlNjI1MC4g
QW1vbmcgdGhvc2UgYWN0dWFsbHkNCnJlZmVyZW5jZWQgaW4gdGhlIGNvZGUsIG9ubHkgUUNfRU5B
QkxFIGRpZmZlcnMgKGJpdCA2IHJhdGhlciB0aGFuIGJpdA0KNSkuDQoNClJldmlld2VkLWJ5OiBB
bmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQpSZXZpZXdlZC1ieTogVml2aWVuIERpZGVsb3Qg
PHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbT4NClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1v
ZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212
ODhlNnh4eC9nbG9iYWwyLmMgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKysrKw0KIGRyaXZl
cnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMi5oIHwgMTQgKysrKysrKysrKysrKysNCiAyIGZp
bGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMi5jIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9i
YWwyLmMNCmluZGV4IDkxYTNjYjI0NTJhYy4uODU5ODRlYjY5ZmZkIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9t
djg4ZTZ4eHgvZ2xvYmFsMi5jDQpAQCAtODE2LDYgKzgxNiwzMiBAQCBjb25zdCBzdHJ1Y3QgbXY4
OGU2eHh4X2lycV9vcHMgbXY4OGU2MDk3X3dhdGNoZG9nX29wcyA9IHsNCiAJLmlycV9mcmVlID0g
bXY4OGU2MDk3X3dhdGNoZG9nX2ZyZWUsDQogfTsNCiANCitzdGF0aWMgdm9pZCBtdjg4ZTYyNTBf
d2F0Y2hkb2dfZnJlZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApDQorew0KKwl1MTYgcmVn
Ow0KKw0KKwltdjg4ZTZ4eHhfZzJfcmVhZChjaGlwLCBNVjg4RTYyNTBfRzJfV0RPR19DVEwsICZy
ZWcpOw0KKw0KKwlyZWcgJj0gfihNVjg4RTYyNTBfRzJfV0RPR19DVExfRUdSRVNTX0VOQUJMRSB8
DQorCQkgTVY4OEU2MjUwX0cyX1dET0dfQ1RMX1FDX0VOQUJMRSk7DQorDQorCW12ODhlNnh4eF9n
Ml93cml0ZShjaGlwLCBNVjg4RTYyNTBfRzJfV0RPR19DVEwsIHJlZyk7DQorfQ0KKw0KK3N0YXRp
YyBpbnQgbXY4OGU2MjUwX3dhdGNoZG9nX3NldHVwKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hp
cCkNCit7DQorCXJldHVybiBtdjg4ZTZ4eHhfZzJfd3JpdGUoY2hpcCwgTVY4OEU2MjUwX0cyX1dE
T0dfQ1RMLA0KKwkJCQkgIE1WODhFNjI1MF9HMl9XRE9HX0NUTF9FR1JFU1NfRU5BQkxFIHwNCisJ
CQkJICBNVjg4RTYyNTBfRzJfV0RPR19DVExfUUNfRU5BQkxFIHwNCisJCQkJICBNVjg4RTYyNTBf
RzJfV0RPR19DVExfU1dSRVNFVCk7DQorfQ0KKw0KK2NvbnN0IHN0cnVjdCBtdjg4ZTZ4eHhfaXJx
X29wcyBtdjg4ZTYyNTBfd2F0Y2hkb2dfb3BzID0gew0KKwkuaXJxX2FjdGlvbiA9IG12ODhlNjA5
N193YXRjaGRvZ19hY3Rpb24sDQorCS5pcnFfc2V0dXAgPSBtdjg4ZTYyNTBfd2F0Y2hkb2dfc2V0
dXAsDQorCS5pcnFfZnJlZSA9IG12ODhlNjI1MF93YXRjaGRvZ19mcmVlLA0KK307DQorDQogc3Rh
dGljIGludCBtdjg4ZTYzOTBfd2F0Y2hkb2dfc2V0dXAoc3RydWN0IG12ODhlNnh4eF9jaGlwICpj
aGlwKQ0KIHsNCiAJcmV0dXJuIG12ODhlNnh4eF9nMl91cGRhdGUoY2hpcCwgTVY4OEU2MzkwX0cy
X1dET0dfQ1RMLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFs
Mi5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmgNCmluZGV4IDE5NDY2MGQ4
Yzc4My4uNjIwNWM2Yjc1YmM3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4
eC9nbG9iYWwyLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMi5oDQpA
QCAtMjA1LDYgKzIwNSwxOCBAQA0KICNkZWZpbmUgTVY4OEU2WFhYX0cyX1NDUkFUQ0hfTUlTQ19Q
VFJfTUFTSwkweDdmMDANCiAjZGVmaW5lIE1WODhFNlhYWF9HMl9TQ1JBVENIX01JU0NfREFUQV9N
QVNLCTB4MDBmZg0KIA0KKy8qIE9mZnNldCAweDFCOiBXYXRjaCBEb2cgQ29udHJvbCBSZWdpc3Rl
ciAqLw0KKyNkZWZpbmUgTVY4OEU2MjUwX0cyX1dET0dfQ1RMCQkJMHgxYg0KKyNkZWZpbmUgTVY4
OEU2MjUwX0cyX1dET0dfQ1RMX1FDX0hJU1RPUlkJMHgwMTAwDQorI2RlZmluZSBNVjg4RTYyNTBf
RzJfV0RPR19DVExfUUNfRVZFTlQJCTB4MDA4MA0KKyNkZWZpbmUgTVY4OEU2MjUwX0cyX1dET0df
Q1RMX1FDX0VOQUJMRQkJMHgwMDQwDQorI2RlZmluZSBNVjg4RTYyNTBfRzJfV0RPR19DVExfRUdS
RVNTX0hJU1RPUlkJMHgwMDIwDQorI2RlZmluZSBNVjg4RTYyNTBfRzJfV0RPR19DVExfRUdSRVNT
X0VWRU5UCTB4MDAxMA0KKyNkZWZpbmUgTVY4OEU2MjUwX0cyX1dET0dfQ1RMX0VHUkVTU19FTkFC
TEUJMHgwMDA4DQorI2RlZmluZSBNVjg4RTYyNTBfRzJfV0RPR19DVExfRk9SQ0VfSVJRCQkweDAw
MDQNCisjZGVmaW5lIE1WODhFNjI1MF9HMl9XRE9HX0NUTF9ISVNUT1JZCQkweDAwMDINCisjZGVm
aW5lIE1WODhFNjI1MF9HMl9XRE9HX0NUTF9TV1JFU0VUCQkweDAwMDENCisNCiAvKiBPZmZzZXQg
MHgxQjogV2F0Y2ggRG9nIENvbnRyb2wgUmVnaXN0ZXIgKi8NCiAjZGVmaW5lIE1WODhFNjM1Ml9H
Ml9XRE9HX0NUTAkJCTB4MWINCiAjZGVmaW5lIE1WODhFNjM1Ml9HMl9XRE9HX0NUTF9FR1JFU1Nf
RVZFTlQJMHgwMDgwDQpAQCAtMzM0LDYgKzM0Niw3IEBAIGludCBtdjg4ZTZ4eHhfZzJfZGV2aWNl
X21hcHBpbmdfd3JpdGUoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgdGFyZ2V0LA0K
IAkJCQkgICAgICBpbnQgcG9ydCk7DQogDQogZXh0ZXJuIGNvbnN0IHN0cnVjdCBtdjg4ZTZ4eHhf
aXJxX29wcyBtdjg4ZTYwOTdfd2F0Y2hkb2dfb3BzOw0KK2V4dGVybiBjb25zdCBzdHJ1Y3QgbXY4
OGU2eHh4X2lycV9vcHMgbXY4OGU2MjUwX3dhdGNoZG9nX29wczsNCiBleHRlcm4gY29uc3Qgc3Ry
dWN0IG12ODhlNnh4eF9pcnFfb3BzIG12ODhlNjM5MF93YXRjaGRvZ19vcHM7DQogDQogZXh0ZXJu
IGNvbnN0IHN0cnVjdCBtdjg4ZTZ4eHhfYXZiX29wcyBtdjg4ZTYxNjVfYXZiX29wczsNCkBAIC00
ODQsNiArNDk3LDcgQEAgc3RhdGljIGlubGluZSBpbnQgbXY4OGU2eHh4X2cyX3BvdF9jbGVhcihz
dHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApDQogfQ0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
bXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MDk3X3dhdGNoZG9nX29wcyA9IHt9Ow0KK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MjUwX3dhdGNoZG9nX29wcyA9IHt9
Ow0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MzkwX3dhdGNo
ZG9nX29wcyA9IHt9Ow0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2F2Yl9vcHMg
bXY4OGU2MTY1X2F2Yl9vcHMgPSB7fTsNCi0tIA0KMi4yMC4xDQoNCg==
