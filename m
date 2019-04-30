Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F81BFF75
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfD3SMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:12:39 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbfD3SMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPe4e4Xgs2PSNORmh0qHukO9d6zHqlSZMYn2ajoRonw=;
 b=DyYhpe7rcpWcE+K08i/MZhslyktWI9sErv4yUEwmWU/1jFdeZp4qx9jYtPxBIx1rqIGQ9O/tAEI6IHn74qAI45GEcerMdqYBJH0hxoPcjBu2D0Uf2rJEdXHnaS87ZWt8rCjd3LUyQRID3oeSbJ0RobYp3B4qgtkquvVXp/Y/gRw=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:12:32 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:12:32 +0000
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
Subject: [PATCH bpf-next v2 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v2 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHU/4BHG6K/TUzd8kqpqxh6uH48Xg==
Date:   Tue, 30 Apr 2019 18:12:32 +0000
Message-ID: <20190430181215.15305-1-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: ddba73f3-f5f5-4ad6-a70a-08d6cd976a0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB55530D2CFBC4F38DB41ECB56D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(14444005)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8mNAtKGIENgleOw6idu2SmlCrwceOrEeVRuEVYUyclK5Tnv43/wUYxAeoNmQAsP/GCdHx1WzKiOfNTpn72ezd0wL0WHliUlmr6dU7Kh9I2nj5UepKLqhl0abV3A/RPDQKUfQpkcgzbIYlB+As/Bwax01UqYEF8SN3bgF8KGDCV7we1vo+mjyw/A9Q18tcTysz7YVT+quulcaRaXIb/TVZpdQM2e0FY0VpYF0faL5l5eZsBIcgAywbAjF1kHo/0PTpHJGmbkzUHCTDcvGcH/VgAPheUBYhZI+eQR0vj1APwiwq6a5M0ToQ0CKaYK1K6vyy+hL+JLij8U8gxTNFgX9+beSiC66H8y9w088NABsV5xubF/Xr+qUUVXa0NS1UxYYPUo+1inzWYb9fLibOdl8ebSzHWkGtX+OJoTDx9VORzk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <940929ECA49D804AA877B33276EDC479@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddba73f3-f5f5-4ad6-a70a-08d6cd976a0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:12:32.5972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
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
bWVudHMgZm9yIHYxLiBSZWJhc2VkIGZvcg0KYnBmLW5leHQgKG5ldC1uZXh0IGhhcyB0byBiZSBt
ZXJnZWQgZmlyc3QsIGJlY2F1c2UgdGhpcyBzZXJpZXMgZGVwZW5kcw0Kb24gc29tZSBwYXRjaGVz
IGZyb20gdGhlcmUpLg0KDQpNYXhpbSBNaWtpdHlhbnNraXkgKDE2KToNCiAgeHNrOiBBZGQgQVBJ
IHRvIGNoZWNrIGZvciBhdmFpbGFibGUgZW50cmllcyBpbiBGUQ0KICB4c2s6IEFkZCBnZXRzb2Nr
b3B0IFhEUF9PUFRJT05TDQogIGxpYmJwZjogU3VwcG9ydCBnZXRzb2Nrb3B0IFhEUF9PUFRJT05T
DQogIHhzazogRXh0ZW5kIGNoYW5uZWxzIHRvIHN1cHBvcnQgY29tYmluZWQgWFNLL25vbi1YU0sg
dHJhZmZpYw0KICB4c2s6IENoYW5nZSB0aGUgZGVmYXVsdCBmcmFtZSBzaXplIHRvIDQwOTYgYW5k
IGFsbG93IGNvbnRyb2xsaW5nIGl0DQogIHhzazogUmV0dXJuIHRoZSB3aG9sZSB4ZHBfZGVzYyBm
cm9tIHhza191bWVtX2NvbnN1bWVfdHgNCiAgbmV0L21seDVlOiBSZXBsYWNlIGRlcHJlY2F0ZWQg
UENJX0RNQV9UT0RFVklDRQ0KICBuZXQvbWx4NWU6IENhbGN1bGF0ZSBsaW5lYXIgUlggZnJhZyBz
aXplIGNvbnNpZGVyaW5nIFhTSw0KICBuZXQvbWx4NWU6IEFsbG93IElDTyBTUSB0byBiZSB1c2Vk
IGJ5IG11bHRpcGxlIFJRcw0KICBuZXQvbWx4NWU6IFJlZmFjdG9yIHN0cnVjdCBtbHg1ZV94ZHBf
aW5mbw0KICBuZXQvbWx4NWU6IFNoYXJlIHRoZSBYRFAgU1EgZm9yIFhEUF9UWCBiZXR3ZWVuIFJR
cw0KICBuZXQvbWx4NWU6IFhEUF9UWCBmcm9tIFVNRU0gc3VwcG9ydA0KICBuZXQvbWx4NWU6IENv
bnNpZGVyIFhTSyBpbiBYRFAgTVRVIGxpbWl0IGNhbGN1bGF0aW9uDQogIG5ldC9tbHg1ZTogRW5j
YXBzdWxhdGUgb3Blbi9jbG9zZSBxdWV1ZXMgaW50byBhIGZ1bmN0aW9uDQogIG5ldC9tbHg1ZTog
TW92ZSBxdWV1ZSBwYXJhbSBzdHJ1Y3RzIHRvIGVuL3BhcmFtcy5oDQogIG5ldC9tbHg1ZTogQWRk
IFhTSyBzdXBwb3J0DQoNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNr
LmMgICAgfCAgMTIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV94
c2suYyAgfCAgMTUgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtl
ZmlsZSAgfCAgIDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4uaCAgfCAxNDcgKysrLQ0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcGFy
YW1zLmMgICB8IDEwOCArKy0NCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3Bh
cmFtcy5oICAgfCAgODcgKystDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4veGRwLmMgIHwgMjMxICsrKystLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hkcC5oICB8ICAzNiArLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL01h
a2VmaWxlICAgICAgICB8ICAgMSArDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bi94c2svcnguYyAgIHwgMTkyICsrKysrDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi94c2svcnguaCAgIHwgIDI3ICsNCiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9z
ZXR1cC5jICAgICAgICAgfCAyMjAgKysrKysrDQogLi4uL21lbGxhbm94L21seDUvY29yZS9lbi94
c2svc2V0dXAuaCAgICAgICAgIHwgIDI1ICsNCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hzay90eC5jICAgfCAxMDggKysrDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi94c2svdHguaCAgIHwgIDE1ICsNCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hzay91bWVtLmMgfCAyNTIgKysrKysrKw0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW4veHNrL3VtZW0uaCB8ICAzNCArDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9ldGh0b29sLmMgIHwgIDIxICstDQogLi4uL21lbGxhbm94L21seDUvY29yZS9l
bl9mc19ldGh0b29sLmMgICAgICAgIHwgIDQ0ICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fbWFpbi5jIHwgNjgwICsrKysrKysrKysrLS0tLS0tLQ0KIC4uLi9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jICB8ICAxMiArLQ0KIC4uLi9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMgICB8IDEwNCArKy0NCiAuLi4vZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRzLmMgICAgfCAxMTUgKystDQogLi4uL2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5oICAgIHwgIDMwICsNCiAuLi4vbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4LmMgfCAgNDIgKy0NCiAuLi4vZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2lwb2liL2lwb2liLmMgfCAgMTQgKy0NCiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvd3EuaCAgfCAgIDUgLQ0KIGluY2x1ZGUv
bmV0L3hkcF9zb2NrLmggICAgICAgICAgICAgICAgICAgICAgICB8ICAyNyArLQ0KIGluY2x1ZGUv
dWFwaS9saW51eC9pZl94ZHAuaCAgICAgICAgICAgICAgICAgICB8ICAxOCArDQogbmV0L3hkcC94
c2suYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDQzICstDQogbmV0L3hkcC94
c2tfcXVldWUuaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDE0ICsNCiBzYW1wbGVzL2Jw
Zi94ZHBzb2NrX3VzZXIuYyAgICAgICAgICAgICAgICAgICAgfCAgNTIgKy0NCiB0b29scy9pbmNs
dWRlL3VhcGkvbGludXgvaWZfeGRwLmggICAgICAgICAgICAgfCAgMTggKw0KIHRvb2xzL2xpYi9i
cGYveHNrLmMgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDEyNyArKystDQogdG9vbHMvbGli
L2JwZi94c2suaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA2ICstDQogMzUgZmlsZXMg
Y2hhbmdlZCwgMjM4NCBpbnNlcnRpb25zKCspLCA1MDAgZGVsZXRpb25zKC0pDQogY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2sv
TWFrZWZpbGUNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuL3hzay9yeC5jDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svcnguaA0KIGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3NldHVw
LmMNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuL3hzay9zZXR1cC5oDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdHguYw0KIGNyZWF0ZSBtb2RlIDEwMDY0
NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3R4LmgNCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuL3hzay91bWVtLmMNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay91bWVtLmgNCg0KLS0gDQoyLjE5LjENCg0K
