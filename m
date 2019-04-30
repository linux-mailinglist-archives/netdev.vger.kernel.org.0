Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2701FF90
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfD3SNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:13:18 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727061AbfD3SNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHn4IHnzQVw+1TIJ+OWuC1QMYRH/rzjaam/ljUspNAQ=;
 b=D7Z+sV3XqIsIg+u3l9mPwav8+7zPHUKB0vQPWWLwUHQ7e7ixUVIHC1wicVTJaK4ox1AjkBGmqRfsltomF1sxIYR/CtaX9lGHG5UT796/vmbarKrNiZwGjww1GWSZmHHrGOM7fGt2+lWjcj9DmFVi5lH07A3diq0FfDe83OoomI0=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:13:02 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:13:02 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v2 13/16] net/mlx5e: Consider XSK in XDP MTU limit
 calculation
Thread-Topic: [PATCH bpf-next v2 13/16] net/mlx5e: Consider XSK in XDP MTU
 limit calculation
Thread-Index: AQHU/4BZ56SIlWeyR0SinzgnZ2U4Vw==
Date:   Tue, 30 Apr 2019 18:13:02 +0000
Message-ID: <20190430181215.15305-14-maximmi@mellanox.com>
References: <20190430181215.15305-1-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::22) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12da4f95-1d85-4cdd-2e4d-08d6cd977c17
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB555334C67043FC763BCBD50CD13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D2YTlFLKNA4KyijCcvEtQx7hY+wbd0r3awNxzQdO5jq2Bi9zAnfBatSM0a/QpIuHiNXj4BqFIWj/XracXm/xsokc1Iw2AxCe1bIIsTkGdeRJ7SqCv9MfeAuNlT5OYPTTgGRS8XBATgxRN3WurHZdze/IrNLqGUTzxEOz7codUv4y4MvkaCJZQxyi3LuseqqKB9D6UBfKDCX66bPoYr8hrVnZTidVcxkQ9jKtNhefvw35MU9wrOMi90S2sSnBNdwXnq/SlMTlDRJhbQXFgazmEzxCcWFNHEjVPztggZz47DZpCxUiwj4QtXN5CVc9HwsBuo2Tfww/SEwvbwRPl4WAMWcJ2ZasrZctKlvyPl4EAdRuELEo+wjrto+E7pZXKox9SYn27owo7IsTIb5DxZs7psWKTLFNvMjzexjgipE9Ht8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12da4f95-1d85-4cdd-2e4d-08d6cd977c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:13:02.8726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VXNlIHRoZSBleGlzdGluZyBtbHg1ZV9nZXRfbGluZWFyX3JxX2hlYWRyb29tIGZ1bmN0aW9uIHRv
IGNhbGN1bGF0ZSB0aGUNCmhlYWRyb29tIGZvciBtbHg1ZV94ZHBfbWF4X210dS4gVGhpcyBmdW5j
dGlvbiB0YWtlcyB0aGUgWFNLIGhlYWRyb29tDQppbnRvIGNvbnNpZGVyYXRpb24sIHdoaWNoIHdp
bGwgYmUgdXNlZCBpbiB0aGUgZm9sbG93aW5nIHBhdGNoZXMuDQoNClNpZ25lZC1vZmYtYnk6IE1h
eGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVGFy
aXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVk
IDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuL3BhcmFtcy5jIHwgNCArKy0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3BhcmFtcy5oIHwgMiArKw0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYyAgICB8IDUgKysrLS0NCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmggICAgfCAzICsrLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgICB8IDQgKystLQ0K
IDUgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9wYXJh
bXMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9wYXJhbXMu
Yw0KaW5kZXggNTBhNDU4ZGMzODM2Li4wZGU5MDhiMTJmY2MgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcGFyYW1zLmMNCisrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9wYXJhbXMuYw0KQEAgLTksOCAr
OSw4IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBtbHg1ZV9yeF9pc194ZHAoc3RydWN0IG1seDVlX3Bh
cmFtcyAqcGFyYW1zLA0KIAlyZXR1cm4gcGFyYW1zLT54ZHBfcHJvZyB8fCB4c2s7DQogfQ0KIA0K
LXN0YXRpYyBpbmxpbmUgdTE2IG1seDVlX2dldF9saW5lYXJfcnFfaGVhZHJvb20oc3RydWN0IG1s
eDVlX3BhcmFtcyAqcGFyYW1zLA0KLQkJCQkJICAgICAgIHN0cnVjdCBtbHg1ZV94c2tfcGFyYW0g
KnhzaykNCit1MTYgbWx4NWVfZ2V0X2xpbmVhcl9ycV9oZWFkcm9vbShzdHJ1Y3QgbWx4NWVfcGFy
YW1zICpwYXJhbXMsDQorCQkJCSBzdHJ1Y3QgbWx4NWVfeHNrX3BhcmFtICp4c2spDQogew0KIAl1
MTYgaGVhZHJvb20gPSBORVRfSVBfQUxJR047DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3BhcmFtcy5oIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3BhcmFtcy5oDQppbmRleCBlZDQyMGYzZWZlNTIu
LjdmMjliODJkZDhjMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbi9wYXJhbXMuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuL3BhcmFtcy5oDQpAQCAtMTEsNiArMTEsOCBAQCBzdHJ1Y3QgbWx4NWVf
eHNrX3BhcmFtIHsNCiAJdTE2IGNodW5rX3NpemU7DQogfTsNCiANCit1MTYgbWx4NWVfZ2V0X2xp
bmVhcl9ycV9oZWFkcm9vbShzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsDQorCQkJCSBzdHJ1
Y3QgbWx4NWVfeHNrX3BhcmFtICp4c2spOw0KIHUzMiBtbHg1ZV9yeF9nZXRfbGluZWFyX2ZyYWdf
c3ooc3RydWN0IG1seDVlX3BhcmFtcyAqcGFyYW1zLA0KIAkJCQlzdHJ1Y3QgbWx4NWVfeHNrX3Bh
cmFtICp4c2spOw0KIHU4IG1seDVlX21wd3FlX2xvZ19wa3RzX3Blcl93cWUoc3RydWN0IG1seDVl
X3BhcmFtcyAqcGFyYW1zKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW4veGRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW4veGRwLmMNCmluZGV4IDEzNjRiZGZmNzAyYy4uZWU5OWVmZGU5MTQzIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5j
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMN
CkBAIC0zMiwxMCArMzIsMTEgQEANCiANCiAjaW5jbHVkZSA8bGludXgvYnBmX3RyYWNlLmg+DQog
I2luY2x1ZGUgImVuL3hkcC5oIg0KKyNpbmNsdWRlICJlbi9wYXJhbXMuaCINCiANCi1pbnQgbWx4
NWVfeGRwX21heF9tdHUoc3RydWN0IG1seDVlX3BhcmFtcyAqcGFyYW1zKQ0KK2ludCBtbHg1ZV94
ZHBfbWF4X210dShzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsIHN0cnVjdCBtbHg1ZV94c2tf
cGFyYW0gKnhzaykNCiB7DQotCWludCBociA9IE5FVF9JUF9BTElHTiArIFhEUF9QQUNLRVRfSEVB
RFJPT007DQorCWludCBociA9IG1seDVlX2dldF9saW5lYXJfcnFfaGVhZHJvb20ocGFyYW1zLCB4
c2spOw0KIA0KIAkvKiBMZXQgUyA6PSBTS0JfREFUQV9BTElHTihzaXplb2Yoc3RydWN0IHNrYl9z
aGFyZWRfaW5mbykpLg0KIAkgKiBUaGUgY29uZGl0aW9uIGNoZWNrZWQgaW4gbWx4NWVfcnhfaXNf
bGluZWFyX3NrYiBpczoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW4veGRwLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4veGRwLmgNCmluZGV4IDg2ZGI1YWQ0OWE0Mi4uOTIwMGNiOWY0OTliIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5oDQor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmgNCkBA
IC0zOSw3ICszOSw4IEBADQogCShzaXplb2Yoc3RydWN0IG1seDVlX3R4X3dxZSkgLyBNTFg1X1NF
TkRfV1FFX0RTKQ0KICNkZWZpbmUgTUxYNUVfWERQX1RYX0RTX0NPVU5UIChNTFg1RV9YRFBfVFhf
RU1QVFlfRFNfQ09VTlQgKyAxIC8qIFNHIERTICovKQ0KIA0KLWludCBtbHg1ZV94ZHBfbWF4X210
dShzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMpOw0KK3N0cnVjdCBtbHg1ZV94c2tfcGFyYW07
DQoraW50IG1seDVlX3hkcF9tYXhfbXR1KHN0cnVjdCBtbHg1ZV9wYXJhbXMgKnBhcmFtcywgc3Ry
dWN0IG1seDVlX3hza19wYXJhbSAqeHNrKTsNCiBib29sIG1seDVlX3hkcF9oYW5kbGUoc3RydWN0
IG1seDVlX3JxICpycSwgc3RydWN0IG1seDVlX2RtYV9pbmZvICpkaSwNCiAJCSAgICAgIHZvaWQg
KnZhLCB1MTYgKnJ4X2hlYWRyb29tLCB1MzIgKmxlbik7DQogYm9vbCBtbHg1ZV9wb2xsX3hkcHNx
X2NxKHN0cnVjdCBtbHg1ZV9jcSAqY3EpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQppbmRleCAzNWI0MmM4NzVjZjMuLjA4YzJmZDBi
ZTdhYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9tYWluLmMNCkBAIC0zNzE4LDcgKzM3MTgsNyBAQCBpbnQgbWx4NWVfY2hhbmdlX210dShz
dHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQgbmV3X210dSwNCiAJaWYgKHBhcmFtcy0+eGRw
X3Byb2cgJiYNCiAJICAgICFtbHg1ZV9yeF9pc19saW5lYXJfc2tiKCZuZXdfY2hhbm5lbHMucGFy
YW1zKSkgew0KIAkJbmV0ZGV2X2VycihuZXRkZXYsICJNVFUoJWQpID4gJWQgaXMgbm90IGFsbG93
ZWQgd2hpbGUgWERQIGVuYWJsZWRcbiIsDQotCQkJICAgbmV3X210dSwgbWx4NWVfeGRwX21heF9t
dHUocGFyYW1zKSk7DQorCQkJICAgbmV3X210dSwgbWx4NWVfeGRwX21heF9tdHUocGFyYW1zLCBO
VUxMKSk7DQogCQllcnIgPSAtRUlOVkFMOw0KIAkJZ290byBvdXQ7DQogCX0NCkBAIC00MTYwLDcg
KzQxNjAsNyBAQCBzdGF0aWMgaW50IG1seDVlX3hkcF9hbGxvd2VkKHN0cnVjdCBtbHg1ZV9wcml2
ICpwcml2LCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQogCWlmICghbWx4NWVfcnhfaXNfbGluZWFy
X3NrYigmbmV3X2NoYW5uZWxzLnBhcmFtcykpIHsNCiAJCW5ldGRldl93YXJuKG5ldGRldiwgIlhE
UCBpcyBub3QgYWxsb3dlZCB3aXRoIE1UVSglZCkgPiAlZFxuIiwNCiAJCQkgICAgbmV3X2NoYW5u
ZWxzLnBhcmFtcy5zd19tdHUsDQotCQkJICAgIG1seDVlX3hkcF9tYXhfbXR1KCZuZXdfY2hhbm5l
bHMucGFyYW1zKSk7DQorCQkJICAgIG1seDVlX3hkcF9tYXhfbXR1KCZuZXdfY2hhbm5lbHMucGFy
YW1zLCBOVUxMKSk7DQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KIA0KLS0gDQoyLjE5LjENCg0K
