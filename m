Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D664A019
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfFRMBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:01:11 -0400
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:12489
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729079AbfFRMBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQ4aKuZkr8TTvkp1m0KcPB/knITj1+XDAK9tGasaJ3I=;
 b=m/RNBb6Z9VLMPGfg6TU9DDQN9G0Ba6BBmx+GKN9YuzBvxsNgZHFTRO6oIEYg3orPV4usMlN8V8RiNMcgjuctVzRX42CCWnnEWBfJ3p6MyiZ3vdi2AucjGOMxCrKnFwYoWn78CHcoCutZhGsH8vfUz21q28beeQRKmMLQw8hsZVg=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4917.eurprd05.prod.outlook.com (20.177.36.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 12:01:06 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:01:06 +0000
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
Subject: [PATCH bpf-next v5 13/16] net/mlx5e: Consider XSK in XDP MTU limit
 calculation
Thread-Topic: [PATCH bpf-next v5 13/16] net/mlx5e: Consider XSK in XDP MTU
 limit calculation
Thread-Index: AQHVJc2Ce5NGdIAdAEG9jKz2HFSYig==
Date:   Tue, 18 Jun 2019 12:01:06 +0000
Message-ID: <20190618120024.16788-14-maximmi@mellanox.com>
References: <20190618120024.16788-1-maximmi@mellanox.com>
In-Reply-To: <20190618120024.16788-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0064.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::28) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cb7c152-d6ab-4903-5528-08d6f3e4a4a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4917;
x-ms-traffictypediagnostic: AM6PR05MB4917:
x-microsoft-antispam-prvs: <AM6PR05MB49170B5C09F1FC4FF49768B5D1EA0@AM6PR05MB4917.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(346002)(376002)(189003)(199004)(6486002)(6436002)(256004)(6512007)(8936002)(66556008)(66476007)(66446008)(86362001)(64756008)(7416002)(81166006)(50226002)(478600001)(476003)(81156014)(52116002)(66946007)(14454004)(8676002)(54906003)(73956011)(110136005)(486006)(11346002)(99286004)(7736002)(305945005)(36756003)(316002)(446003)(386003)(5660300002)(71200400001)(4326008)(68736007)(107886003)(76176011)(6506007)(1076003)(3846002)(186003)(2906002)(6116002)(102836004)(2616005)(66066001)(25786009)(71190400001)(26005)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4917;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dErpUVzAdtt3V3LZd9LnYezTZx8ToVmInEl7TsXBGuvJM9YzLqON9RLuGY9nLbBxnZL8EbjAA6wQfbnJm92hI5XC17eIqDARjIpjKHufoTQtYwCHD2wl7x8LomdESZP0ZbRnBrTajmXLEdvJuwIjzSbgdNS/21A7klPpxeabUeRGwFS9s424CMRVCf8wJd3JPzESdbY6+NYC+H8fGxw6mx/+NWSa/dgKo/Dkg5cSHyYSM6IocHxVuSK8cI6ntRWi9ClB102ARaOuMr/pDY+/z5NJWakhSTDybyiprmEVMYLHZWB0jEu/rzXyDrycnivTs6J765GeinngcS2y95LwGHM/wEcAPFrYhLHk9i1Cb8fBPswx3/WFvFVt7EYT7kpQU0bFltrYAl5rKudrnoYYpabzQYY0318Q459jNnVR8WA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb7c152-d6ab-4903-5528-08d6f3e4a4a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:01:06.3855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4917
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
