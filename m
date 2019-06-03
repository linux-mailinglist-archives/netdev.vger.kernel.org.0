Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73783326E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbfFCOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:32 -0400
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:22244
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729169AbfFCOma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUuC/zcBBXTnAbWFryFjjlUDKuMezvsAc5QjKmVyDGg=;
 b=Qy6gz2EKzjP5umZlkp7ubVcOrFmnWdQVIhgULzQsGJdiXUyRqte1nJTS+R/v4uBKpW0GTjKUuh8K3Q4+2ntsODoAF1SYniIw5Wrv/ZOa+6vY+p2aVtBLmQnp+E8NNcjUMOQdV53kQQ6KuozojtnKfajRbIx43iiMHqWAwOc6kRE=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:17 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:17 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 05/10] net: dsa: mv88e6xxx: implement watchdog_ops
 for mv88e6250
Thread-Topic: [PATCH net-next v3 05/10] net: dsa: mv88e6xxx: implement
 watchdog_ops for mv88e6250
Thread-Index: AQHVGhqK7HCwyko3PEaqI+5v/rMrQQ==
Date:   Mon, 3 Jun 2019 14:42:17 +0000
Message-ID: <20190603144112.27713-6-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: d6f81188-00a7-4ad8-aa3b-08d6e831ad16
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB2574EB671A4C6C41C3359CF98A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(14444005)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WVEzjHCYLEntIc0NNHDC7B+4rM0gCHD30UMstxuiD7XCVtMaxY2zNaZU0VvpywZFVg4uOy6CvWel7fkiQTob3mbCLgUiCB/o6YCwC4/Krs0y/HJcCblIaDZtPC9aYCtG0eKvSPenZqtUgFeaGRumRcIc4+PNoe3yeVOF9R0IVJ6CDhnlTyIVk1w6GRBab8OiBcmDe2mS84RQ9nb6Pz3l6U456h2k4+4rKPO/r+cXuS0yFTloE1ol4GEouoH9TpQrv7V7cOdHw6eSA+COqG7J9MjKQDlJrflGjm/K3SVeqbd4FmaQozlXIjPCBTvkyU4w5GtBcynV7XZo65UIYyk7qIiTl2DxeHorzgdjE42j7kATVVE1zfzRcmrxFqpPZiy/RZE7WgxBxIfmz5oeiFj/xsRpHIyoI5o0eZ5chr+9SHo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f81188-00a7-4ad8-aa3b-08d6e831ad16
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:17.7227
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
