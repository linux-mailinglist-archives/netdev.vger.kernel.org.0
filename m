Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B766E10ED2
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfEAVzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:55:10 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:32576
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfEAVzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnQaa3et1e32nrxcdbU2JG76x23sXdujbzG8qEifLx4=;
 b=jlHz+DTT6wsKw9RL1E1Jq6sxaIc0wd1p4Gsyfgp4XePQwdThnfmJtjJ5vuxecKN3o9BFKZCZ5pctHyju2fujMmfDWKpIYoat9lzOS5+v7yT54pPY6GeyXSo/r/TsXSIS6m2teTKSwAeUm9QxaNkTnkkDmCMZvI1WqXOjYS3k4OM=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5868.eurprd05.prod.outlook.com (20.179.8.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 1 May 2019 21:54:59 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:54:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 08/15] net/mlx5e: Put the common XDP code into a
 function
Thread-Topic: [net-next V2 08/15] net/mlx5e: Put the common XDP code into a
 function
Thread-Index: AQHVAGiF2Sv9tkJ6I0CTfSubn8RuKQ==
Date:   Wed, 1 May 2019 21:54:59 +0000
Message-ID: <20190501215433.24047-9-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5214305c-f7c6-44c4-f3e4-08d6ce7fa7e7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5868;
x-ms-traffictypediagnostic: DB8PR05MB5868:
x-microsoft-antispam-prvs: <DB8PR05MB58681F5B88D3189F3D7806ECBE3B0@DB8PR05MB5868.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(5660300002)(256004)(86362001)(6512007)(14444005)(66066001)(71190400001)(71200400001)(316002)(478600001)(446003)(11346002)(476003)(2616005)(186003)(1076003)(6486002)(26005)(486006)(6436002)(2906002)(102836004)(52116002)(6506007)(36756003)(6916009)(4326008)(76176011)(50226002)(107886003)(66446008)(68736007)(7736002)(66946007)(66476007)(66556008)(64756008)(53936002)(54906003)(305945005)(8676002)(81156014)(3846002)(81166006)(386003)(25786009)(73956011)(8936002)(99286004)(6116002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5868;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9EfcKkHt5xFSisokodVGcszuKuByV7MGYqLKX8Cyt62UymFflYWqTHWxfXjtF0iR590oD/xV92HshG8nPZ0ccjaffdj+6ws2A7oP3DA6wwo8d5rWKhxjo8hIgbGYnXjVe8hYwl++oDllMjmyUK2NXjIZCvPl/I0/3MtPgx7OQAlcUMng0vZCgGS6t6lH1HTeMcLSr9iApOOZNvRitDidH5w07xo0AHHBPzROMIqKLxr1I1G5zhqgMvWalKQDqAJPo75FPoZSZP9+ld7ulBr1+KUZ2WyT5ZTY8UCxV0fttgsUni//IGf9TNY7BlrbkafYLx6VdbxLmQCRrE5uetYRxY0NBmB1kyjhGUSILrNqcMI1sj8C1lDZdYf9lSKtO3YL/NvZs+y88svYH3GrZ6OQTymJ2eGEsFB824+4K5KjBC0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5214305c-f7c6-44c4-f3e4-08d6ce7fa7e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:54:59.5980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5868
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCg0KVGhlIHNh
bWUgY29kZSB0aGF0IHJldHVybnMgWERQIGZyYW1lcyBhbmQgcmVsZWFzZXMgcGFnZXMgaXMgdXNl
ZCBib3RoIGluDQptbHg1ZV9wb2xsX3hkcHNxX2NxIGFuZCBtbHg1ZV9mcmVlX3hkcHNxX2Rlc2Nz
LiBDcmVhdGUgYSBmdW5jdGlvbiB0aGF0DQpjbGVhbnMgdXAgYW4gTVBXUUUuDQoNClNpZ25lZC1v
ZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jICB8IDYzICsrKysrKysrLS0t
LS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMzYgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veGRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4v
eGRwLmMNCmluZGV4IDM5OTk1NzEwNGY5ZC4uZWI4ZWY3OGU1NjI2IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCkBAIC0yNzUsMTIg
KzI3NSwzMyBAQCBzdGF0aWMgYm9vbCBtbHg1ZV94bWl0X3hkcF9mcmFtZShzdHJ1Y3QgbWx4NWVf
eGRwc3EgKnNxLCBzdHJ1Y3QgbWx4NWVfeGRwX2luZm8gKg0KIAlyZXR1cm4gdHJ1ZTsNCiB9DQog
DQorc3RhdGljIHZvaWQgbWx4NWVfZnJlZV94ZHBzcV9kZXNjKHN0cnVjdCBtbHg1ZV94ZHBzcSAq
c3EsDQorCQkJCSAgc3RydWN0IG1seDVlX3hkcF93cWVfaW5mbyAqd2ksDQorCQkJCSAgc3RydWN0
IG1seDVlX3JxICpycSwNCisJCQkJICBib29sIHJlY3ljbGUpDQorew0KKwlzdHJ1Y3QgbWx4NWVf
eGRwX2luZm9fZmlmbyAqeGRwaV9maWZvID0gJnNxLT5kYi54ZHBpX2ZpZm87DQorCXUxNiBpOw0K
Kw0KKwlmb3IgKGkgPSAwOyBpIDwgd2ktPm51bV9wa3RzOyBpKyspIHsNCisJCXN0cnVjdCBtbHg1
ZV94ZHBfaW5mbyB4ZHBpID0gbWx4NWVfeGRwaV9maWZvX3BvcCh4ZHBpX2ZpZm8pOw0KKw0KKwkJ
aWYgKHJxKSB7DQorCQkJLyogWERQX1RYICovDQorCQkJbWx4NWVfcGFnZV9yZWxlYXNlKHJxLCAm
eGRwaS5kaSwgcmVjeWNsZSk7DQorCQl9IGVsc2Ugew0KKwkJCS8qIFhEUF9SRURJUkVDVCAqLw0K
KwkJCWRtYV91bm1hcF9zaW5nbGUoc3EtPnBkZXYsIHhkcGkuZG1hX2FkZHIsDQorCQkJCQkgeGRw
aS54ZHBmLT5sZW4sIERNQV9UT19ERVZJQ0UpOw0KKwkJCXhkcF9yZXR1cm5fZnJhbWUoeGRwaS54
ZHBmKTsNCisJCX0NCisJfQ0KK30NCisNCiBib29sIG1seDVlX3BvbGxfeGRwc3FfY3Eoc3RydWN0
IG1seDVlX2NxICpjcSwgc3RydWN0IG1seDVlX3JxICpycSkNCiB7DQotCXN0cnVjdCBtbHg1ZV94
ZHBfaW5mb19maWZvICp4ZHBpX2ZpZm87DQogCXN0cnVjdCBtbHg1ZV94ZHBzcSAqc3E7DQogCXN0
cnVjdCBtbHg1X2NxZTY0ICpjcWU7DQotCWJvb2wgaXNfcmVkaXJlY3Q7DQogCXUxNiBzcWNjOw0K
IAlpbnQgaTsNCiANCkBAIC0yOTMsOSArMzE0LDYgQEAgYm9vbCBtbHg1ZV9wb2xsX3hkcHNxX2Nx
KHN0cnVjdCBtbHg1ZV9jcSAqY3EsIHN0cnVjdCBtbHg1ZV9ycSAqcnEpDQogCWlmICghY3FlKQ0K
IAkJcmV0dXJuIGZhbHNlOw0KIA0KLQlpc19yZWRpcmVjdCA9ICFycTsNCi0JeGRwaV9maWZvID0g
JnNxLT5kYi54ZHBpX2ZpZm87DQotDQogCS8qIHNxLT5jYyBtdXN0IGJlIHVwZGF0ZWQgb25seSBh
ZnRlciBtbHg1X2Nxd3FfdXBkYXRlX2RiX3JlY29yZCgpLA0KIAkgKiBvdGhlcndpc2UgYSBjcSBv
dmVycnVuIG1heSBvY2N1cg0KIAkgKi8NCkBAIC0zMTcsNyArMzM1LDcgQEAgYm9vbCBtbHg1ZV9w
b2xsX3hkcHNxX2NxKHN0cnVjdCBtbHg1ZV9jcSAqY3EsIHN0cnVjdCBtbHg1ZV9ycSAqcnEpDQog
DQogCQlkbyB7DQogCQkJc3RydWN0IG1seDVlX3hkcF93cWVfaW5mbyAqd2k7DQotCQkJdTE2IGNp
LCBqOw0KKwkJCXUxNiBjaTsNCiANCiAJCQlsYXN0X3dxZSA9IChzcWNjID09IHdxZV9jb3VudGVy
KTsNCiAJCQljaSA9IG1seDVfd3FfY3ljX2N0cjJpeCgmc3EtPndxLCBzcWNjKTsNCkBAIC0zMjUs
MTkgKzM0Myw3IEBAIGJvb2wgbWx4NWVfcG9sbF94ZHBzcV9jcShzdHJ1Y3QgbWx4NWVfY3EgKmNx
LCBzdHJ1Y3QgbWx4NWVfcnEgKnJxKQ0KIA0KIAkJCXNxY2MgKz0gd2ktPm51bV93cWViYnM7DQog
DQotCQkJZm9yIChqID0gMDsgaiA8IHdpLT5udW1fcGt0czsgaisrKSB7DQotCQkJCXN0cnVjdCBt
bHg1ZV94ZHBfaW5mbyB4ZHBpID0NCi0JCQkJCW1seDVlX3hkcGlfZmlmb19wb3AoeGRwaV9maWZv
KTsNCi0NCi0JCQkJaWYgKGlzX3JlZGlyZWN0KSB7DQotCQkJCQlkbWFfdW5tYXBfc2luZ2xlKHNx
LT5wZGV2LCB4ZHBpLmRtYV9hZGRyLA0KLQkJCQkJCQkgeGRwaS54ZHBmLT5sZW4sIERNQV9UT19E
RVZJQ0UpOw0KLQkJCQkJeGRwX3JldHVybl9mcmFtZSh4ZHBpLnhkcGYpOw0KLQkJCQl9IGVsc2Ug
ew0KLQkJCQkJLyogUmVjeWNsZSBSWCBwYWdlICovDQotCQkJCQltbHg1ZV9wYWdlX3JlbGVhc2Uo
cnEsICZ4ZHBpLmRpLCB0cnVlKTsNCi0JCQkJfQ0KLQkJCX0NCisJCQltbHg1ZV9mcmVlX3hkcHNx
X2Rlc2Moc3EsIHdpLCBycSwgdHJ1ZSk7DQogCQl9IHdoaWxlICghbGFzdF93cWUpOw0KIAl9IHdo
aWxlICgoKytpIDwgTUxYNUVfVFhfQ1FfUE9MTF9CVURHRVQpICYmIChjcWUgPSBtbHg1X2Nxd3Ff
Z2V0X2NxZSgmY3EtPndxKSkpOw0KIA0KQEAgLTM1NCwzMSArMzYwLDE2IEBAIGJvb2wgbWx4NWVf
cG9sbF94ZHBzcV9jcShzdHJ1Y3QgbWx4NWVfY3EgKmNxLCBzdHJ1Y3QgbWx4NWVfcnEgKnJxKQ0K
IA0KIHZvaWQgbWx4NWVfZnJlZV94ZHBzcV9kZXNjcyhzdHJ1Y3QgbWx4NWVfeGRwc3EgKnNxLCBz
dHJ1Y3QgbWx4NWVfcnEgKnJxKQ0KIHsNCi0Jc3RydWN0IG1seDVlX3hkcF9pbmZvX2ZpZm8gKnhk
cGlfZmlmbyA9ICZzcS0+ZGIueGRwaV9maWZvOw0KLQlib29sIGlzX3JlZGlyZWN0ID0gIXJxOw0K
LQ0KIAl3aGlsZSAoc3EtPmNjICE9IHNxLT5wYykgew0KIAkJc3RydWN0IG1seDVlX3hkcF93cWVf
aW5mbyAqd2k7DQotCQl1MTYgY2ksIGk7DQorCQl1MTYgY2k7DQogDQogCQljaSA9IG1seDVfd3Ff
Y3ljX2N0cjJpeCgmc3EtPndxLCBzcS0+Y2MpOw0KIAkJd2kgPSAmc3EtPmRiLndxZV9pbmZvW2Np
XTsNCiANCiAJCXNxLT5jYyArPSB3aS0+bnVtX3dxZWJiczsNCiANCi0JCWZvciAoaSA9IDA7IGkg
PCB3aS0+bnVtX3BrdHM7IGkrKykgew0KLQkJCXN0cnVjdCBtbHg1ZV94ZHBfaW5mbyB4ZHBpID0N
Ci0JCQkJbWx4NWVfeGRwaV9maWZvX3BvcCh4ZHBpX2ZpZm8pOw0KLQ0KLQkJCWlmIChpc19yZWRp
cmVjdCkgew0KLQkJCQlkbWFfdW5tYXBfc2luZ2xlKHNxLT5wZGV2LCB4ZHBpLmRtYV9hZGRyLA0K
LQkJCQkJCSB4ZHBpLnhkcGYtPmxlbiwgRE1BX1RPX0RFVklDRSk7DQotCQkJCXhkcF9yZXR1cm5f
ZnJhbWUoeGRwaS54ZHBmKTsNCi0JCQl9IGVsc2Ugew0KLQkJCQkvKiBSZWN5Y2xlIFJYIHBhZ2Ug
Ki8NCi0JCQkJbWx4NWVfcGFnZV9yZWxlYXNlKHJxLCAmeGRwaS5kaSwgZmFsc2UpOw0KLQkJCX0N
Ci0JCX0NCisJCW1seDVlX2ZyZWVfeGRwc3FfZGVzYyhzcSwgd2ksIHJxLCBmYWxzZSk7DQogCX0N
CiB9DQogDQotLSANCjIuMjAuMQ0KDQo=
