Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F155F21F06
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfEQUT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:19:58 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727808AbfEQUT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sz0MqNKIJ6OnLV7K7oHhxrB+VLAKH3Bgg6rpH1mlg98=;
 b=VrhcJliYCvsTIn3D0YhRm3SCx6c6Z9FqofahoMSO5l6GWzA4o8R6jB8QWl9tlG7qNcJ4tkWeXAfC0yzLnQ0i8ozq501hbtKmq5AVUUEsdAzMkj+17MWfVqnljT3dDKWfEdYqgM6H7pFFxcOq9MUMo3jy6av0gof2701T6M6A+c8=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:44 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/11] net/mlx5e: Fix wrong xmit_more application
Thread-Topic: [net 05/11] net/mlx5e: Fix wrong xmit_more application
Thread-Index: AQHVDO3dnxhQn6DGU06lT4IAQKwFWw==
Date:   Fri, 17 May 2019 20:19:44 +0000
Message-ID: <20190517201910.32216-6-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c86c815-c8a3-4b02-0c4a-08d6db04ff95
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB61388820075024C97D7E5484BE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F8mqJ2te62x96AwaLRLwL5U51geM8+rEojz48hEZt5Avsrvoz7mbz1U4uuTqtOIrON06YV4kJe1ryKFgy3r7qDjlGHcktIq0dvQ8yJt3kgkWkGZT+3gJ2yeV8UMUCtWLyQ69uBaOJcFNW0q3AIYS4gT8WVALN/SWq+nWjPNN0z/JgX70oo1NOsBMLxcWaTQgsRVQMT7XkhyIpwU3OvSnDpsQ4pXj1cpmAiAAV6VlC3PGWLVfGlzv47HuUl1NU1Utr1u2bjiScSKNvSXGuSpCsdvCSajGxZO+n2HgVd/Fl4Kfokd0La650i04MAYKh7M2NyxXcr8lP8ikgofUSI1qcUF/AQ8ID+pgaXjVDkJCmZVYTj0si+Q68d4zna/o1MlzTDGSaRGo8jIr0FuZczB9vyCj9aE90Lw8Tay1+x2Cj3E=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c86c815-c8a3-4b02-0c4a-08d6db04ff95
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:44.2498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KDQpDaXRlZCBwYXRjaCBy
ZWZhY3RvcmVkIHRoZSB4bWl0X21vcmUgaW5kaWNhdGlvbiB3aGlsZSBub3QgcHJlc2VydmluZw0K
aXRzIGZ1bmN0aW9uYWxpdHkuIEZpeCBpdC4NCg0KRml4ZXM6IDNjMzFmZjIyYjI1ZiAoImRyaXZl
cnM6IG1lbGxhbm94OiB1c2UgbmV0ZGV2X3htaXRfbW9yZSgpIGhlbHBlciIpDQpTaWduZWQtb2Zm
LWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBT
YWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jICAgICAgIHwgOSArKysrKy0tLS0NCiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaXBvaWIvaXBvaWIuYyB8IDIg
Ky0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaXBvaWIvaXBvaWIu
aCB8IDMgKystDQogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fdHguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90
eC5jDQppbmRleCA3YjYxMTI2ZmNlYzkuLjE5NWE3ZDkwM2NlYyAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdHguYw0KQEAgLTM2MSw3ICszNjEs
NyBAQCBuZXRkZXZfdHhfdCBtbHg1ZV9zcV94bWl0KHN0cnVjdCBtbHg1ZV90eHFzcSAqc3EsIHN0
cnVjdCBza19idWZmICpza2IsDQogCX0NCiANCiAJc3RhdHMtPmJ5dGVzICAgICArPSBudW1fYnl0
ZXM7DQotCXN0YXRzLT54bWl0X21vcmUgKz0gbmV0ZGV2X3htaXRfbW9yZSgpOw0KKwlzdGF0cy0+
eG1pdF9tb3JlICs9IHhtaXRfbW9yZTsNCiANCiAJaGVhZGxlbiA9IHNrYi0+bGVuIC0gaWhzIC0g
c2tiLT5kYXRhX2xlbjsNCiAJZHNfY250ICs9ICEhaGVhZGxlbjsNCkBAIC02MjQsNyArNjI0LDgg
QEAgbWx4NWlfdHh3cWVfYnVpbGRfZGF0YWdyYW0oc3RydWN0IG1seDVfYXYgKmF2LCB1MzIgZHFw
biwgdTMyIGRxa2V5LA0KIH0NCiANCiBuZXRkZXZfdHhfdCBtbHg1aV9zcV94bWl0KHN0cnVjdCBt
bHg1ZV90eHFzcSAqc3EsIHN0cnVjdCBza19idWZmICpza2IsDQotCQkJICBzdHJ1Y3QgbWx4NV9h
diAqYXYsIHUzMiBkcXBuLCB1MzIgZHFrZXkpDQorCQkJICBzdHJ1Y3QgbWx4NV9hdiAqYXYsIHUz
MiBkcXBuLCB1MzIgZHFrZXksDQorCQkJICBib29sIHhtaXRfbW9yZSkNCiB7DQogCXN0cnVjdCBt
bHg1X3dxX2N5YyAqd3EgPSAmc3EtPndxOw0KIAlzdHJ1Y3QgbWx4NWlfdHhfd3FlICp3cWU7DQpA
QCAtNjYwLDcgKzY2MSw3IEBAIG5ldGRldl90eF90IG1seDVpX3NxX3htaXQoc3RydWN0IG1seDVl
X3R4cXNxICpzcSwgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJfQ0KIA0KIAlzdGF0cy0+Ynl0ZXMg
ICAgICs9IG51bV9ieXRlczsNCi0Jc3RhdHMtPnhtaXRfbW9yZSArPSBuZXRkZXZfeG1pdF9tb3Jl
KCk7DQorCXN0YXRzLT54bWl0X21vcmUgKz0geG1pdF9tb3JlOw0KIA0KIAloZWFkbGVuID0gc2ti
LT5sZW4gLSBpaHMgLSBza2ItPmRhdGFfbGVuOw0KIAlkc19jbnQgKz0gISFoZWFkbGVuOw0KQEAg
LTcwNSw3ICs3MDYsNyBAQCBuZXRkZXZfdHhfdCBtbHg1aV9zcV94bWl0KHN0cnVjdCBtbHg1ZV90
eHFzcSAqc3EsIHN0cnVjdCBza19idWZmICpza2IsDQogCQlnb3RvIGVycl9kcm9wOw0KIA0KIAlt
bHg1ZV90eHdxZV9jb21wbGV0ZShzcSwgc2tiLCBvcGNvZGUsIGRzX2NudCwgbnVtX3dxZWJicywg
bnVtX2J5dGVzLA0KLQkJCSAgICAgbnVtX2RtYSwgd2ksIGNzZWcsIGZhbHNlKTsNCisJCQkgICAg
IG51bV9kbWEsIHdpLCBjc2VnLCB4bWl0X21vcmUpOw0KIA0KIAlyZXR1cm4gTkVUREVWX1RYX09L
Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9pcG9pYi9pcG9pYi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2lwb2liL2lwb2liLmMNCmluZGV4IGFkYTFiN2MwZTBiOC4uOWNhNDkyYjQzMGQ4IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2lwb2liL2lwb2li
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9pcG9pYi9p
cG9pYi5jDQpAQCAtNjE5LDcgKzYxOSw3IEBAIHN0YXRpYyBpbnQgbWx4NWlfeG1pdChzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAlzdHJ1Y3QgbWx4NV9pYl9h
aCAqbWFoICAgPSB0b19tYWgoYWRkcmVzcyk7DQogCXN0cnVjdCBtbHg1aV9wcml2ICppcHJpdiA9
IGVwcml2LT5wcHJpdjsNCiANCi0JcmV0dXJuIG1seDVpX3NxX3htaXQoc3EsIHNrYiwgJm1haC0+
YXYsIGRxcG4sIGlwcml2LT5xa2V5KTsNCisJcmV0dXJuIG1seDVpX3NxX3htaXQoc3EsIHNrYiwg
Jm1haC0+YXYsIGRxcG4sIGlwcml2LT5xa2V5LCBuZXRkZXZfeG1pdF9tb3JlKCkpOw0KIH0NCiAN
CiBzdGF0aWMgdm9pZCBtbHg1aV9zZXRfcGtleV9pbmRleChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0
ZGV2LCBpbnQgaWQpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2lwb2liL2lwb2liLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvaXBvaWIvaXBvaWIuaA0KaW5kZXggOTE2NWNhNTY3MDQ3Li5lMTliYTNmY2QxYjcg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaXBv
aWIvaXBvaWIuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2lwb2liL2lwb2liLmgNCkBAIC0xMTksNyArMTE5LDggQEAgc3RhdGljIGlubGluZSB2b2lkIG1s
eDVpX3NxX2ZldGNoX3dxZShzdHJ1Y3QgbWx4NWVfdHhxc3EgKnNxLA0KIH0NCiANCiBuZXRkZXZf
dHhfdCBtbHg1aV9zcV94bWl0KHN0cnVjdCBtbHg1ZV90eHFzcSAqc3EsIHN0cnVjdCBza19idWZm
ICpza2IsDQotCQkJICBzdHJ1Y3QgbWx4NV9hdiAqYXYsIHUzMiBkcXBuLCB1MzIgZHFrZXkpOw0K
KwkJCSAgc3RydWN0IG1seDVfYXYgKmF2LCB1MzIgZHFwbiwgdTMyIGRxa2V5LA0KKwkJCSAgYm9v
bCB4bWl0X21vcmUpOw0KIHZvaWQgbWx4NWlfaGFuZGxlX3J4X2NxZShzdHJ1Y3QgbWx4NWVfcnEg
KnJxLCBzdHJ1Y3QgbWx4NV9jcWU2NCAqY3FlKTsNCiB2b2lkIG1seDVpX2dldF9zdGF0cyhzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgcnRubF9saW5rX3N0YXRzNjQgKnN0YXRzKTsNCiAN
Ci0tIA0KMi4yMS4wDQoNCg==
