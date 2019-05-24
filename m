Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6723F29417
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390142AbfEXJAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:00:42 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:58510
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389966AbfEXJAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBHFW+kdkceoxVY22iBDw+mmcjg1KcdNVxtRlIkD33M=;
 b=VjVBcsbMxS41O21lV1ShgW4TzBIcqPNaaQ2ILCD8hihlpy2UPnfakjzYmKj5Mq4iNK/GHwm+iuo5iXNhcoX3w/ITgt7VMxURqiD1UX3e9gurIX/Dmr65Y05t5grAHV93xB+MhuLSkIOmwgGu1BTBexxK2QNR3YNqxlHZgSIvfZ8=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM (10.166.146.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 24 May 2019 09:00:29 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5%3]) with mapi id 15.20.1922.016; Fri, 24 May 2019
 09:00:29 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/5] net: dsa: mv88e6xxx: implement watchdog_ops for
 mv88e6250
Thread-Topic: [PATCH v2 4/5] net: dsa: mv88e6xxx: implement watchdog_ops for
 mv88e6250
Thread-Index: AQHVEg8i6oKGKDxPDUK9e3W1TeatlA==
Date:   Fri, 24 May 2019 09:00:29 +0000
Message-ID: <20190524085921.11108-5-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: bacce580-bd82-4524-d689-08d6e02644ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB1535;
x-ms-traffictypediagnostic: VI1PR10MB1535:
x-microsoft-antispam-prvs: <VI1PR10MB15350D28FB74656DE0CE75D38A020@VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(42882007)(66946007)(73956011)(81166006)(102836004)(66066001)(6116002)(76176011)(1076003)(25786009)(52116002)(478600001)(386003)(6512007)(6506007)(186003)(3846002)(74482002)(72206003)(4326008)(66556008)(64756008)(66446008)(66476007)(316002)(26005)(36756003)(68736007)(50226002)(305945005)(5660300002)(7736002)(6436002)(44832011)(256004)(14444005)(486006)(53936002)(8676002)(81156014)(8976002)(110136005)(476003)(6486002)(8936002)(446003)(2906002)(11346002)(54906003)(2616005)(99286004)(71190400001)(71200400001)(14454004)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1535;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r+yrFl5eDmwUfxs73nRn35NfaQsXW1hifyviFyOUC0J9zFA2Ch0Qz+mp45YwK0Gyz8o7/ff326txB8E2tSPAm3He1SqMKQ/XCUo7D2QGU3AmDZDo++4Myp81szVCzqeEPj42fwmvXJhwyGaNHwuPW9NZz4hDQKTqYsMPHnoWuDVDSgIBz61jspKbyPlNZI1eTfOvg4IXiiuGkqoJPxNT1DzNTVH6sd6qvXj7Efg01nVQ4Oa7zAhQ+9EnNjJdLW0KTTmX2GmSIUBzlxyDC9kiMO1x00j03yANeG/7D54Ud2Cc+PW1mWzvpy/eZmlOyP6vGj6ciGVE/e72wsUbwG/01/nO1sgFlFJZcU0UyH0oX9Slee6zofiICQsKBKqCM4Fd1E+KklMPERGIVFlRB/9etTei6UUXxT6UKSvzAwe0vuE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: bacce580-bd82-4524-d689-08d6e02644ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:00:29.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1535
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIE1WODhFNjM1Ml9HMl9XRE9HX0NUTF8qIGJpdHMgYWxtb3N0LCBidXQgbm90IHF1aXRlLCBk
ZXNjcmliZSB0aGUNCndhdGNoZG9nIGNvbnRyb2wgcmVnaXN0ZXIgb24gdGhlIG12ODhlNjI1MC4g
QW1vbmcgdGhvc2UgYWN0dWFsbHkNCnJlZmVyZW5jZWQgaW4gdGhlIGNvZGUsIG9ubHkgUUNfRU5B
QkxFIGRpZmZlcnMgKGJpdCA2IHJhdGhlciB0aGFuIGJpdA0KNSkuDQoNClNpZ25lZC1vZmYtYnk6
IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJp
dmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmMgfCAyNiArKysrKysrKysrKysrKysrKysr
KysrKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMi5oIHwgMTQgKysrKysr
KysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMi5jIGIvZHJpdmVycy9uZXQvZHNh
L212ODhlNnh4eC9nbG9iYWwyLmMNCmluZGV4IDkxYTNjYjI0NTJhYy4uODU5ODRlYjY5ZmZkIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMi5jDQpAQCAtODE2LDYgKzgxNiwzMiBAQCBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MDk3X3dhdGNoZG9nX29wcyA9IHsN
CiAJLmlycV9mcmVlID0gbXY4OGU2MDk3X3dhdGNoZG9nX2ZyZWUsDQogfTsNCiANCitzdGF0aWMg
dm9pZCBtdjg4ZTYyNTBfd2F0Y2hkb2dfZnJlZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAp
DQorew0KKwl1MTYgcmVnOw0KKw0KKwltdjg4ZTZ4eHhfZzJfcmVhZChjaGlwLCBNVjg4RTYyNTBf
RzJfV0RPR19DVEwsICZyZWcpOw0KKw0KKwlyZWcgJj0gfihNVjg4RTYyNTBfRzJfV0RPR19DVExf
RUdSRVNTX0VOQUJMRSB8DQorCQkgTVY4OEU2MjUwX0cyX1dET0dfQ1RMX1FDX0VOQUJMRSk7DQor
DQorCW12ODhlNnh4eF9nMl93cml0ZShjaGlwLCBNVjg4RTYyNTBfRzJfV0RPR19DVEwsIHJlZyk7
DQorfQ0KKw0KK3N0YXRpYyBpbnQgbXY4OGU2MjUwX3dhdGNoZG9nX3NldHVwKHN0cnVjdCBtdjg4
ZTZ4eHhfY2hpcCAqY2hpcCkNCit7DQorCXJldHVybiBtdjg4ZTZ4eHhfZzJfd3JpdGUoY2hpcCwg
TVY4OEU2MjUwX0cyX1dET0dfQ1RMLA0KKwkJCQkgIE1WODhFNjI1MF9HMl9XRE9HX0NUTF9FR1JF
U1NfRU5BQkxFIHwNCisJCQkJICBNVjg4RTYyNTBfRzJfV0RPR19DVExfUUNfRU5BQkxFIHwNCisJ
CQkJICBNVjg4RTYyNTBfRzJfV0RPR19DVExfU1dSRVNFVCk7DQorfQ0KKw0KK2NvbnN0IHN0cnVj
dCBtdjg4ZTZ4eHhfaXJxX29wcyBtdjg4ZTYyNTBfd2F0Y2hkb2dfb3BzID0gew0KKwkuaXJxX2Fj
dGlvbiA9IG12ODhlNjA5N193YXRjaGRvZ19hY3Rpb24sDQorCS5pcnFfc2V0dXAgPSBtdjg4ZTYy
NTBfd2F0Y2hkb2dfc2V0dXAsDQorCS5pcnFfZnJlZSA9IG12ODhlNjI1MF93YXRjaGRvZ19mcmVl
LA0KK307DQorDQogc3RhdGljIGludCBtdjg4ZTYzOTBfd2F0Y2hkb2dfc2V0dXAoc3RydWN0IG12
ODhlNnh4eF9jaGlwICpjaGlwKQ0KIHsNCiAJcmV0dXJuIG12ODhlNnh4eF9nMl91cGRhdGUoY2hp
cCwgTVY4OEU2MzkwX0cyX1dET0dfQ1RMLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9t
djg4ZTZ4eHgvZ2xvYmFsMi5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmgN
CmluZGV4IDE5NDY2MGQ4Yzc4My4uNjIwNWM2Yjc1YmM3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvZ2xvYmFsMi5oDQpAQCAtMjA1LDYgKzIwNSwxOCBAQA0KICNkZWZpbmUgTVY4OEU2WFhYX0cy
X1NDUkFUQ0hfTUlTQ19QVFJfTUFTSwkweDdmMDANCiAjZGVmaW5lIE1WODhFNlhYWF9HMl9TQ1JB
VENIX01JU0NfREFUQV9NQVNLCTB4MDBmZg0KIA0KKy8qIE9mZnNldCAweDFCOiBXYXRjaCBEb2cg
Q29udHJvbCBSZWdpc3RlciAqLw0KKyNkZWZpbmUgTVY4OEU2MjUwX0cyX1dET0dfQ1RMCQkJMHgx
Yg0KKyNkZWZpbmUgTVY4OEU2MjUwX0cyX1dET0dfQ1RMX1FDX0hJU1RPUlkJMHgwMTAwDQorI2Rl
ZmluZSBNVjg4RTYyNTBfRzJfV0RPR19DVExfUUNfRVZFTlQJCTB4MDA4MA0KKyNkZWZpbmUgTVY4
OEU2MjUwX0cyX1dET0dfQ1RMX1FDX0VOQUJMRQkJMHgwMDQwDQorI2RlZmluZSBNVjg4RTYyNTBf
RzJfV0RPR19DVExfRUdSRVNTX0hJU1RPUlkJMHgwMDIwDQorI2RlZmluZSBNVjg4RTYyNTBfRzJf
V0RPR19DVExfRUdSRVNTX0VWRU5UCTB4MDAxMA0KKyNkZWZpbmUgTVY4OEU2MjUwX0cyX1dET0df
Q1RMX0VHUkVTU19FTkFCTEUJMHgwMDA4DQorI2RlZmluZSBNVjg4RTYyNTBfRzJfV0RPR19DVExf
Rk9SQ0VfSVJRCQkweDAwMDQNCisjZGVmaW5lIE1WODhFNjI1MF9HMl9XRE9HX0NUTF9ISVNUT1JZ
CQkweDAwMDINCisjZGVmaW5lIE1WODhFNjI1MF9HMl9XRE9HX0NUTF9TV1JFU0VUCQkweDAwMDEN
CisNCiAvKiBPZmZzZXQgMHgxQjogV2F0Y2ggRG9nIENvbnRyb2wgUmVnaXN0ZXIgKi8NCiAjZGVm
aW5lIE1WODhFNjM1Ml9HMl9XRE9HX0NUTAkJCTB4MWINCiAjZGVmaW5lIE1WODhFNjM1Ml9HMl9X
RE9HX0NUTF9FR1JFU1NfRVZFTlQJMHgwMDgwDQpAQCAtMzM0LDYgKzM0Niw3IEBAIGludCBtdjg4
ZTZ4eHhfZzJfZGV2aWNlX21hcHBpbmdfd3JpdGUoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlw
LCBpbnQgdGFyZ2V0LA0KIAkJCQkgICAgICBpbnQgcG9ydCk7DQogDQogZXh0ZXJuIGNvbnN0IHN0
cnVjdCBtdjg4ZTZ4eHhfaXJxX29wcyBtdjg4ZTYwOTdfd2F0Y2hkb2dfb3BzOw0KK2V4dGVybiBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MjUwX3dhdGNoZG9nX29wczsNCiBl
eHRlcm4gY29uc3Qgc3RydWN0IG12ODhlNnh4eF9pcnFfb3BzIG12ODhlNjM5MF93YXRjaGRvZ19v
cHM7DQogDQogZXh0ZXJuIGNvbnN0IHN0cnVjdCBtdjg4ZTZ4eHhfYXZiX29wcyBtdjg4ZTYxNjVf
YXZiX29wczsNCkBAIC00ODQsNiArNDk3LDcgQEAgc3RhdGljIGlubGluZSBpbnQgbXY4OGU2eHh4
X2cyX3BvdF9jbGVhcihzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApDQogfQ0KIA0KIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MDk3X3dhdGNoZG9nX29wcyA9
IHt9Ow0KK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMgbXY4OGU2MjUwX3dh
dGNoZG9nX29wcyA9IHt9Ow0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2lycV9vcHMg
bXY4OGU2MzkwX3dhdGNoZG9nX29wcyA9IHt9Ow0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4
OGU2eHh4X2F2Yl9vcHMgbXY4OGU2MTY1X2F2Yl9vcHMgPSB7fTsNCi0tIA0KMi4yMC4xDQoNCg==
