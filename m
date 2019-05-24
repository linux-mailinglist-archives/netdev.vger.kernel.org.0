Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A599294CC
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390250AbfEXJfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:35:47 -0400
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:42462
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390210AbfEXJfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHn4IHnzQVw+1TIJ+OWuC1QMYRH/rzjaam/ljUspNAQ=;
 b=aUPLb/+iLcXiDiJc/a2ZMvEphSLyiCfTITaqrBdyvFJ06+Ip3johipV1j8VLy8SgOOwbW2tTfTzaMZURM+lvW9mwAZ6/Zfno0+JM1olijIJPHN+JSih3YD3SWpfRdifZTdOEt0uqrpKTmMsMoTOZgtsqguAVkoQM76IzcdCJvIQ=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.196.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Fri, 24 May 2019 09:35:37 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:37 +0000
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
Subject: [PATCH bpf-next v3 13/16] net/mlx5e: Consider XSK in XDP MTU limit
 calculation
Thread-Topic: [PATCH bpf-next v3 13/16] net/mlx5e: Consider XSK in XDP MTU
 limit calculation
Thread-Index: AQHVEhQKZk5WoQ57QEu8BpGRaJQlew==
Date:   Fri, 24 May 2019 09:35:36 +0000
Message-ID: <20190524093431.20887-14-maximmi@mellanox.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
In-Reply-To: <20190524093431.20887-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::18) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d13a8c02-ddd2-4e61-1712-08d6e02b2d3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5142;
x-ms-traffictypediagnostic: AM6PR05MB5142:
x-microsoft-antispam-prvs: <AM6PR05MB514264E6BFF9551A41DCFC4FD1020@AM6PR05MB5142.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(76176011)(99286004)(52116002)(14454004)(256004)(66446008)(64756008)(66556008)(66476007)(7736002)(305945005)(73956011)(110136005)(54906003)(66946007)(7416002)(386003)(6506007)(68736007)(86362001)(2906002)(66066001)(316002)(26005)(3846002)(6116002)(186003)(102836004)(107886003)(6436002)(478600001)(81156014)(36756003)(50226002)(8936002)(6486002)(1076003)(5660300002)(6512007)(71200400001)(71190400001)(25786009)(8676002)(81166006)(53936002)(476003)(446003)(486006)(11346002)(4326008)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5142;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZG6WscBxP/CC6db1w9vl8jbEP/40mhA63Q32bTxwCFqV1pNryBMXXXbaqna5M1tzPCZyppJceI47KwwgNALqXQpf2ykx9nx0p8fWIOwzn9xgyOq0eBkPiNYIP//iOcF7OZ014yn5FHrva3gXfgBW33k0nKTiCo5KrzakuJtRV8kGehnH91aQqqQ9AuNkDllWD97W+WJSf5baOACEME+kpZWpUmx7ZGbCLsUVWeG50ii7WWxSRKO0NEDVUxMXtOqJPIbtyhmVlBuwgQEy6VQyEuzVZoWVmw2dcHg0FRDPiMJvCZxA8n0p9d1uG8RyrlMOvHG9+j6r9Rpw6/yy9p0YNJeaqKVHLbp6ZZo3i2Flg/inzJCv9cIB4VDA1/z118qc5m12LRxEO5fXb8XrejpHXaiBwymcyzPTMWPYEfIF7Vo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13a8c02-ddd2-4e61-1712-08d6e02b2d3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:36.9690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5142
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
