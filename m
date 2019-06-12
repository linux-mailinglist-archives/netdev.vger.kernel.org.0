Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE2542B71
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440150AbfFLP5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:57:17 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:27022
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732181AbfFLP5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQ4aKuZkr8TTvkp1m0KcPB/knITj1+XDAK9tGasaJ3I=;
 b=ibgc+FTalxqmmVeRsexRFVHUjOIacKNO2mcS1CYLVDYzvOVhzQX1wJlOzXz4sLHX1/2QOiN3Va0KLpemPucN1kGq5dhYOCd0aNVS7Ouhmnw37/z4eKu4YC4wJG2Cs3fsi1O6XKyo5EWCRh/C1fdV3d8/ERcmnqEf6Ouh5dQltwA=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:57:02 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:57:02 +0000
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
Subject: [PATCH bpf-next v4 14/17] net/mlx5e: Consider XSK in XDP MTU limit
 calculation
Thread-Topic: [PATCH bpf-next v4 14/17] net/mlx5e: Consider XSK in XDP MTU
 limit calculation
Thread-Index: AQHVITd5M2jzV8l46kq9/5VJ5dacrg==
Date:   Wed, 12 Jun 2019 15:57:02 +0000
Message-ID: <20190612155605.22450-15-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1836f5c9-f8b3-47d3-75af-08d6ef4e9bd7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB52404E66D49976EF3C365980D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9Hl6ryu4nzQnLgNyT0RJ/xFzXc9L+ChCeREXGnRILYh0UTyfYBcskXqyUIpI058RNnrD7UD6se3W+sEGdLwQaJpI9Ab/4SsHQPLN0TfQhe1tjAAj542b8Gpeo5jpmFpJK+gS3d9ugPiP91cS2XHCnqdEARryBInmmAi+enC5t/KLvcmteJ0TE8EsK5TVLaTZXFgkOryJ800Oco4v91irHlZiOovoySEc/qsGSgiff3TQxF95aTC0cGV/S4AHAmqgRVDnBwPMuqpEt8nk7fMsdFSZXzQ5GwB+MyhVYuHwRni7QLlPcBW5Syrd/BleNUT2vRCoGefoKLlbRX4sumyJUnBbYEjRpyvM1tOVOgaswwrdg8uHrbiCfNgcCSC/AP3doy1N5ZEyeAyYaUvI1JyKPcDPL4IEtDf0BlTvAIQLue0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1836f5c9-f8b3-47d3-75af-08d6ef4e9bd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:57:02.4078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5240
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
ZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQppbmRleCA3OWY2ODRjYjhmNTEuLjQ0NTU3ZWNk
NGQzNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9tYWluLmMNCkBAIC0zNzI0LDcgKzM3MjQsNyBAQCBpbnQgbWx4NWVfY2hhbmdlX210dShz
dHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQgbmV3X210dSwNCiAJaWYgKHBhcmFtcy0+eGRw
X3Byb2cgJiYNCiAJICAgICFtbHg1ZV9yeF9pc19saW5lYXJfc2tiKCZuZXdfY2hhbm5lbHMucGFy
YW1zKSkgew0KIAkJbmV0ZGV2X2VycihuZXRkZXYsICJNVFUoJWQpID4gJWQgaXMgbm90IGFsbG93
ZWQgd2hpbGUgWERQIGVuYWJsZWRcbiIsDQotCQkJICAgbmV3X210dSwgbWx4NWVfeGRwX21heF9t
dHUocGFyYW1zKSk7DQorCQkJICAgbmV3X210dSwgbWx4NWVfeGRwX21heF9tdHUocGFyYW1zLCBO
VUxMKSk7DQogCQllcnIgPSAtRUlOVkFMOw0KIAkJZ290byBvdXQ7DQogCX0NCkBAIC00MTY5LDcg
KzQxNjksNyBAQCBzdGF0aWMgaW50IG1seDVlX3hkcF9hbGxvd2VkKHN0cnVjdCBtbHg1ZV9wcml2
ICpwcml2LCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQogCWlmICghbWx4NWVfcnhfaXNfbGluZWFy
X3NrYigmbmV3X2NoYW5uZWxzLnBhcmFtcykpIHsNCiAJCW5ldGRldl93YXJuKG5ldGRldiwgIlhE
UCBpcyBub3QgYWxsb3dlZCB3aXRoIE1UVSglZCkgPiAlZFxuIiwNCiAJCQkgICAgbmV3X2NoYW5u
ZWxzLnBhcmFtcy5zd19tdHUsDQotCQkJICAgIG1seDVlX3hkcF9tYXhfbXR1KCZuZXdfY2hhbm5l
bHMucGFyYW1zKSk7DQorCQkJICAgIG1seDVlX3hkcF9tYXhfbXR1KCZuZXdfY2hhbm5lbHMucGFy
YW1zLCBOVUxMKSk7DQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KIA0KLS0gDQoyLjE5LjENCg0K
