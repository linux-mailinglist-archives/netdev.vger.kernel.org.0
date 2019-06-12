Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3305042B7C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfFLP4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:56:51 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:27022
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729109AbfFLP4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvIHWrIfY5JcaqLSy2ZuSQuNn2OPJYosihG0DNSesBE=;
 b=FGYBXRAKOtCQUlciaGB4eCqvpfINcL8E1ZbEH/HsIKnR4mUS0Yq0wMzmf9Exsk0bbYu58yHyeds+rjwtyVG9z0OM0ZulFKCCEZRvZWlDKVlr9tNB5F1N0cPG3lidqEMNX/k9P9A+yFjt6W4VnMJgBEIBnhXwLSR644uDCk0TuDw=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:33 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:33 +0000
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
Subject: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHVITdoe6rurVkq00yTWSmwKXBCXQ==
Date:   Wed, 12 Jun 2019 15:56:33 +0000
Message-ID: <20190612155605.22450-1-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e918d893-b76a-464d-f3bc-08d6ef4e8a6c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB5240E971753DA4FA1EAB3799D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(66574012)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(5024004)(256004)(99286004)(7416002)(6116002)(386003)(14444005)(3846002)(6506007)(86362001)(53936002)(5660300002)(52116002)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S6JmFiudqos3a7vzBfvrXEpNrOiU1IPvgj9DUfqT9qkf2Bm6CMyX27jFDoZ3VGalURARwFH62OGChsy2+pzaws3mqFiiGVvN5ddSYZ+DLUCJ0um6jFzu+PM1XWPDfpfKbtCpfYrLgEckcklVjBI+gV0jyRUIm7KBrHi9fijDwe4xZOxRFGHhniq/vPkfhGvY2B31G9FCPK6TpBqwuxhrtSWZp9ZSEfqmKvzumCMeTMvFdCXbCGx2o6IC42wCv9NodkC/QK7R6oxhgxUlgrchjZCWgrNM9Nt002b8vnLb5xEWbV6KzIsOiGtwRkJWCHm28YCVJqgcRN9VBx498TR7F9usEW7QoB4PZaPh+Odcsf8XeJ5mOp5wj1waDJMdU9tSza7jZAYMMytORjVOsRPGAbmismBflCY/YplEOj7B4uY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <902A4B35F2920F4283B40FC8A91A403F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e918d893-b76a-464d-f3bc-08d6ef4e8a6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:33.1955
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

VGhpcyBzZXJpZXMgY29udGFpbnMgaW1wcm92ZW1lbnRzIHRvIHRoZSBBRl9YRFAga2VybmVsIGlu
ZnJhc3RydWN0dXJlDQphbmQgQUZfWERQIHN1cHBvcnQgaW4gbWx4NWUuIFRoZSBpbmZyYXN0cnVj
dHVyZSBpbXByb3ZlbWVudHMgYXJlDQpyZXF1aXJlZCBmb3IgbWx4NWUsIGJ1dCBhbHNvIHNvbWUg
b2YgdGhlbSBiZW5lZml0IHRvIGFsbCBkcml2ZXJzLCBhbmQNCnNvbWUgY2FuIGJlIHVzZWZ1bCBm
b3Igb3RoZXIgZHJpdmVycyB0aGF0IHdhbnQgdG8gaW1wbGVtZW50IEFGX1hEUC4NCg0KVGhlIHBl
cmZvcm1hbmNlIHRlc3Rpbmcgd2FzIHBlcmZvcm1lZCBvbiBhIG1hY2hpbmUgd2l0aCB0aGUgZm9s
bG93aW5nDQpjb25maWd1cmF0aW9uOg0KDQotIDI0IGNvcmVzIG9mIEludGVsIFhlb24gRTUtMjYy
MCB2MyBAIDIuNDAgR0h6DQotIE1lbGxhbm94IENvbm5lY3RYLTUgRXggd2l0aCAxMDAgR2JpdC9z
IGxpbmsNCg0KVGhlIHJlc3VsdHMgd2l0aCByZXRwb2xpbmUgZGlzYWJsZWQsIHNpbmdsZSBzdHJl
YW06DQoNCnR4b25seTogMzMuMyBNcHBzICgyMS41IE1wcHMgd2l0aCBxdWV1ZSBhbmQgYXBwIHBp
bm5lZCB0byB0aGUgc2FtZSBDUFUpDQpyeGRyb3A6IDEyLjIgTXBwcw0KbDJmd2Q6IDkuNCBNcHBz
DQoNClRoZSByZXN1bHRzIHdpdGggcmV0cG9saW5lIGVuYWJsZWQsIHNpbmdsZSBzdHJlYW06DQoN
CnR4b25seTogMjEuMyBNcHBzICgxNC4xIE1wcHMgd2l0aCBxdWV1ZSBhbmQgYXBwIHBpbm5lZCB0
byB0aGUgc2FtZSBDUFUpDQpyeGRyb3A6IDkuOSBNcHBzDQpsMmZ3ZDogNi44IE1wcHMNCg0KdjIg
Y2hhbmdlczoNCg0KQWRkZWQgcGF0Y2hlcyBmb3IgbWx4NWUgYW5kIGFkZHJlc3NlZCB0aGUgY29t
bWVudHMgZm9yIHYxLiBSZWJhc2VkIGZvcg0KYnBmLW5leHQuDQoNCnYzIGNoYW5nZXM6DQoNClJl
YmFzZWQgZm9yIHRoZSBuZXdlciBicGYtbmV4dCwgcmVzb2x2ZWQgY29uZmxpY3RzIGluIGxpYmJw
Zi4gQWRkcmVzc2VkDQpCasO2cm4ncyBjb21tZW50cyBmb3IgY29kaW5nIHN0eWxlLiBGaXhlZCBh
IGJ1ZyBpbiBlcnJvciBoYW5kbGluZyBmbG93IGluDQptbHg1ZV9vcGVuX3hzay4NCg0KdjQgY2hh
bmdlczoNCg0KVUFQSSBpcyBub3QgY2hhbmdlZCwgWFNLIFJYIHF1ZXVlcyBhcmUgZXhwb3NlZCB0
byB0aGUga2VybmVsLiBUaGUgbG93ZXINCmhhbGYgb2YgdGhlIGF2YWlsYWJsZSBhbW91bnQgb2Yg
UlggcXVldWVzIGFyZSByZWd1bGFyIHF1ZXVlcywgYW5kIHRoZQ0KdXBwZXIgaGFsZiBhcmUgWFNL
IFJYIHF1ZXVlcy4gVGhlIHBhdGNoICJ4c2s6IEV4dGVuZCBjaGFubmVscyB0byBzdXBwb3J0DQpj
b21iaW5lZCBYU0svbm9uLVhTSyB0cmFmZmljIiB3YXMgZHJvcHBlZC4gVGhlIGZpbmFsIHBhdGNo
IHdhcyByZXdvcmtlZA0KYWNjb3JkaW5nbHkuDQoNCkFkZGVkICJuZXQvbWx4NWU6IEF0dGFjaC9k
ZXRhY2ggWERQIHByb2dyYW0gc2FmZWx5IiwgYXMgdGhlIGNoYW5nZXMNCmludHJvZHVjZWQgaW4g
dGhlIFhTSyBwYXRjaCBiYXNlIG9uIHRoZSBzdHVmZiBmcm9tIHRoaXMgb25lLg0KDQpBZGRlZCAi
bGliYnBmOiBTdXBwb3J0IGRyaXZlcnMgd2l0aCBub24tY29tYmluZWQgY2hhbm5lbHMiLCB3aGlj
aCBhbGlnbnMNCnRoZSBjb25kaXRpb24gaW4gbGliYnBmIHdpdGggdGhlIGNvbmRpdGlvbiBpbiB0
aGUga2VybmVsLg0KDQpSZWJhc2VkIG92ZXIgdGhlIG5ld2VyIGJwZi1uZXh0Lg0KDQpNYXhpbSBN
aWtpdHlhbnNraXkgKDE3KToNCiAgbmV0L21seDVlOiBBdHRhY2gvZGV0YWNoIFhEUCBwcm9ncmFt
IHNhZmVseQ0KICB4c2s6IEFkZCBBUEkgdG8gY2hlY2sgZm9yIGF2YWlsYWJsZSBlbnRyaWVzIGlu
IEZRDQogIHhzazogQWRkIGdldHNvY2tvcHQgWERQX09QVElPTlMNCiAgbGliYnBmOiBTdXBwb3J0
IGdldHNvY2tvcHQgWERQX09QVElPTlMNCiAgeHNrOiBDaGFuZ2UgdGhlIGRlZmF1bHQgZnJhbWUg
c2l6ZSB0byA0MDk2IGFuZCBhbGxvdyBjb250cm9sbGluZyBpdA0KICB4c2s6IFJldHVybiB0aGUg
d2hvbGUgeGRwX2Rlc2MgZnJvbSB4c2tfdW1lbV9jb25zdW1lX3R4DQogIGxpYmJwZjogU3VwcG9y
dCBkcml2ZXJzIHdpdGggbm9uLWNvbWJpbmVkIGNoYW5uZWxzDQogIG5ldC9tbHg1ZTogUmVwbGFj
ZSBkZXByZWNhdGVkIFBDSV9ETUFfVE9ERVZJQ0UNCiAgbmV0L21seDVlOiBDYWxjdWxhdGUgbGlu
ZWFyIFJYIGZyYWcgc2l6ZSBjb25zaWRlcmluZyBYU0sNCiAgbmV0L21seDVlOiBBbGxvdyBJQ08g
U1EgdG8gYmUgdXNlZCBieSBtdWx0aXBsZSBSUXMNCiAgbmV0L21seDVlOiBSZWZhY3RvciBzdHJ1
Y3QgbWx4NWVfeGRwX2luZm8NCiAgbmV0L21seDVlOiBTaGFyZSB0aGUgWERQIFNRIGZvciBYRFBf
VFggYmV0d2VlbiBSUXMNCiAgbmV0L21seDVlOiBYRFBfVFggZnJvbSBVTUVNIHN1cHBvcnQNCiAg
bmV0L21seDVlOiBDb25zaWRlciBYU0sgaW4gWERQIE1UVSBsaW1pdCBjYWxjdWxhdGlvbg0KICBu
ZXQvbWx4NWU6IEVuY2Fwc3VsYXRlIG9wZW4vY2xvc2UgcXVldWVzIGludG8gYSBmdW5jdGlvbg0K
ICBuZXQvbWx4NWU6IE1vdmUgcXVldWUgcGFyYW0gc3RydWN0cyB0byBlbi9wYXJhbXMuaA0KICBu
ZXQvbWx4NWU6IEFkZCBYU0sgemVyby1jb3B5IHN1cHBvcnQNCg0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2k0MGUvaTQwZV94c2suYyAgICB8ICAxMiArLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3hzay5jICB8ICAxNSArLQ0KIC4uLi9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlICB8ICAgMiArLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oICB8IDE1NSArKystDQogLi4uL2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbi9wYXJhbXMuYyAgIHwgMTA4ICsrLQ0KIC4uLi9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW4vcGFyYW1zLmggICB8IDExOCArKy0NCiAuLi4vbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYyAgfCAyMzEgKysrKy0tDQogLi4uL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmggIHwgIDM2ICstDQogLi4uL21lbGxh
bm94L21seDUvY29yZS9lbi94c2svTWFrZWZpbGUgICAgICAgIHwgICAxICsNCiAuLi4vZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5jICAgfCAxOTIgKysrKysNCiAuLi4vZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oICAgfCAgMjcgKw0KIC4uLi9tZWxs
YW5veC9tbHg1L2NvcmUvZW4veHNrL3NldHVwLmMgICAgICAgICB8IDIyMyArKysrKysNCiAuLi4v
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9zZXR1cC5oICAgICAgICAgfCAgMjUgKw0KIC4uLi9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3R4LmMgICB8IDExMSArKysNCiAuLi4v
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay90eC5oICAgfCAgMTUgKw0KIC4uLi9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3VtZW0uYyB8IDI2NyArKysrKysrDQog
Li4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdW1lbS5oIHwgIDMxICsNCiAu
Li4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2V0aHRvb2wuYyAgfCAgMjkgKy0NCiAu
Li4vbWVsbGFub3gvbWx4NS9jb3JlL2VuX2ZzX2V0aHRvb2wuYyAgICAgICAgfCAgMTggKy0NCiAu
Li4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCA3MjYgKysrKysr
KysrKysrLS0tLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVw
LmMgIHwgIDEyICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcngu
YyAgIHwgMTA0ICsrLQ0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMu
YyAgICB8IDExNSArKy0NCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRz
LmggICAgfCAgMzAgKw0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3R4
cnguYyB8ICA0MiArLQ0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaXBvaWIvaXBv
aWIuYyB8ICAxNCArLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS93
cS5oICB8ICAgNSAtDQogaW5jbHVkZS9uZXQveGRwX3NvY2suaCAgICAgICAgICAgICAgICAgICAg
ICAgIHwgIDI3ICstDQogaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oICAgICAgICAgICAgICAg
ICAgIHwgICA4ICsNCiBuZXQveGRwL3hzay5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgMzYgKy0NCiBuZXQveGRwL3hza19xdWV1ZS5oICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgMTQgKw0KIHNhbXBsZXMvYnBmL3hkcHNvY2tfdXNlci5jICAgICAgICAgICAgICAgICAg
ICB8ICA0NCArLQ0KIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCAgICAgICAgICAg
ICB8ICAgOCArDQogdG9vbHMvbGliL2JwZi94c2suYyAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgIDE4ICstDQogdG9vbHMvbGliL2JwZi94c2suaCAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgICAyICstDQogMzUgZmlsZXMgY2hhbmdlZCwgMjMzNyBpbnNlcnRpb25zKCspLCA0ODQgZGVs
ZXRpb25zKC0pDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbi94c2svTWFrZWZpbGUNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5jDQogY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2sv
cnguaA0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW4veHNrL3NldHVwLmMNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9zZXR1cC5oDQogY3JlYXRlIG1vZGUg
MTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdHgu
Yw0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4veHNrL3R4LmgNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay91bWVtLmMNCiBjcmVhdGUgbW9kZSAxMDA2NDQg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay91bWVtLmgNCg0K
LS0gDQoyLjE5LjENCg0K
