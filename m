Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6876E42B5E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfFLP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:56:56 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:31558
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730158AbfFLP4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RHge13H7WRMJ1DKoVcTWrM0WkZj1ZYRJxKipC3Y+EY=;
 b=jdvC+hZ8tKCYjicvPdlSK/f5fd8IcwdblGIc8EB2QGYjX+ux560iuRpSPCHdcsqfL/hRtha1NWsIswOC87/7EFthRqtRv5Mxi8uZXfuLsN3OeVyv0AH5ZvNIMmIuDT6lJY0TIjEy0zUe/b+n6M3qr3ApLWO0ejYEPNrK5+fmau0=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:39 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:39 +0000
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
Subject: [PATCH bpf-next v4 03/17] xsk: Add getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v4 03/17] xsk: Add getsockopt XDP_OPTIONS
Thread-Index: AQHVITdrO/C5fFjaPEKQ6R0scHMsQw==
Date:   Wed, 12 Jun 2019 15:56:39 +0000
Message-ID: <20190612155605.22450-4-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6a4c1993-6401-4c75-09bd-08d6ef4e8e08
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB52406C622F9B248298966964D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(14444005)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +HisQp4PKSRI0/dHWbXAXFgigY4lZiD1/qd/h3uIBGpNI+bj9wGiQoW1hKIe1AOuFHGzLE+oNXna0c1TuuvKqKSA48OiamAm1c4KdpadDmdDlrAMiW54QZId6VmoHeNT/+C2Gdait7EWF+gfgEjrj3mYCQm/2TBYaERXGiC8yZSKq158+07/GGHlI4eXhLOzu6JE4uDgP3OeEEjfKkDv7Py3cTQVndS7Un/mnCSwWRHLaqF58XR+QzZubRk/ZGp6PHBoRzgUQq9cWEd6XpQIk20gu04ENmfGyRMYINdw0M+uNwapqhHuIR1vN0fqeV5AHXiQV5IQhCH26OVRI2WN+aEG8kVAkx7ZJwtay2AigoMO4SFrwkCM/Far7dGxNypMH3lIoGwPfOT9Lts9LKNxiSd6lWHmmkkt04FybHM3PkQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4c1993-6401-4c75-09bd-08d6ef4e8e08
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:39.4839
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

TWFrZSBpdCBwb3NzaWJsZSBmb3IgdGhlIGFwcGxpY2F0aW9uIHRvIGRldGVybWluZSB3aGV0aGVy
IHRoZSBBRl9YRFANCnNvY2tldCBpcyBydW5uaW5nIGluIHplcm8tY29weSBtb2RlLiBUbyBhY2hp
ZXZlIHRoaXMsIGFkZCBhIG5ldw0KZ2V0c29ja29wdCBvcHRpb24gWERQX09QVElPTlMgdGhhdCBy
ZXR1cm5zIGZsYWdzLiBUaGUgb25seSBmbGFnDQpzdXBwb3J0ZWQgZm9yIG5vdyBpcyB0aGUgemVy
by1jb3B5IG1vZGUgaW5kaWNhdG9yLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNr
aXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFy
aXF0QG1lbGxhbm94LmNvbT4NCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxh
bm94LmNvbT4NCi0tLQ0KIGluY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCAgICAgICB8ICA4ICsr
KysrKysrDQogbmV0L3hkcC94c2suYyAgICAgICAgICAgICAgICAgICAgIHwgMjAgKysrKysrKysr
KysrKysrKysrKysNCiB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggfCAgOCArKysr
KysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5o
DQppbmRleCBjYWVkOGIxNjE0ZmYuLmZhYWE1Y2EyYTExNyAxMDA2NDQNCi0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9pZl94ZHAuaA0KKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQpA
QCAtNDYsNiArNDYsNyBAQCBzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyB7DQogI2RlZmluZSBYRFBf
VU1FTV9GSUxMX1JJTkcJCTUNCiAjZGVmaW5lIFhEUF9VTUVNX0NPTVBMRVRJT05fUklORwk2DQog
I2RlZmluZSBYRFBfU1RBVElTVElDUwkJCTcNCisjZGVmaW5lIFhEUF9PUFRJT05TCQkJOA0KIA0K
IHN0cnVjdCB4ZHBfdW1lbV9yZWcgew0KIAlfX3U2NCBhZGRyOyAvKiBTdGFydCBvZiBwYWNrZXQg
ZGF0YSBhcmVhICovDQpAQCAtNjAsNiArNjEsMTMgQEAgc3RydWN0IHhkcF9zdGF0aXN0aWNzIHsN
CiAJX191NjQgdHhfaW52YWxpZF9kZXNjczsgLyogRHJvcHBlZCBkdWUgdG8gaW52YWxpZCBkZXNj
cmlwdG9yICovDQogfTsNCiANCitzdHJ1Y3QgeGRwX29wdGlvbnMgew0KKwlfX3UzMiBmbGFnczsN
Cit9Ow0KKw0KKy8qIEZsYWdzIGZvciB0aGUgZmxhZ3MgZmllbGQgb2Ygc3RydWN0IHhkcF9vcHRp
b25zICovDQorI2RlZmluZSBYRFBfT1BUSU9OU19aRVJPQ09QWSAoMSA8PCAwKQ0KKw0KIC8qIFBn
b2ZmIGZvciBtbWFwaW5nIHRoZSByaW5ncyAqLw0KICNkZWZpbmUgWERQX1BHT0ZGX1JYX1JJTkcJ
CQkgIDANCiAjZGVmaW5lIFhEUF9QR09GRl9UWF9SSU5HCQkgMHg4MDAwMDAwMA0KZGlmZiAtLWdp
dCBhL25ldC94ZHAveHNrLmMgYi9uZXQveGRwL3hzay5jDQppbmRleCBiNjhhMzgwZjUwYjMuLjM1
Y2E1MzFhYzc0ZSAxMDA2NDQNCi0tLSBhL25ldC94ZHAveHNrLmMNCisrKyBiL25ldC94ZHAveHNr
LmMNCkBAIC02NTAsNiArNjUwLDI2IEBAIHN0YXRpYyBpbnQgeHNrX2dldHNvY2tvcHQoc3RydWN0
IHNvY2tldCAqc29jaywgaW50IGxldmVsLCBpbnQgb3B0bmFtZSwNCiANCiAJCXJldHVybiAwOw0K
IAl9DQorCWNhc2UgWERQX09QVElPTlM6DQorCXsNCisJCXN0cnVjdCB4ZHBfb3B0aW9ucyBvcHRz
ID0ge307DQorDQorCQlpZiAobGVuIDwgc2l6ZW9mKG9wdHMpKQ0KKwkJCXJldHVybiAtRUlOVkFM
Ow0KKw0KKwkJbXV0ZXhfbG9jaygmeHMtPm11dGV4KTsNCisJCWlmICh4cy0+emMpDQorCQkJb3B0
cy5mbGFncyB8PSBYRFBfT1BUSU9OU19aRVJPQ09QWTsNCisJCW11dGV4X3VubG9jaygmeHMtPm11
dGV4KTsNCisNCisJCWxlbiA9IHNpemVvZihvcHRzKTsNCisJCWlmIChjb3B5X3RvX3VzZXIob3B0
dmFsLCAmb3B0cywgbGVuKSkNCisJCQlyZXR1cm4gLUVGQVVMVDsNCisJCWlmIChwdXRfdXNlcihs
ZW4sIG9wdGxlbikpDQorCQkJcmV0dXJuIC1FRkFVTFQ7DQorDQorCQlyZXR1cm4gMDsNCisJfQ0K
IAlkZWZhdWx0Og0KIAkJYnJlYWs7DQogCX0NCmRpZmYgLS1naXQgYS90b29scy9pbmNsdWRlL3Vh
cGkvbGludXgvaWZfeGRwLmggYi90b29scy9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmgNCmlu
ZGV4IGNhZWQ4YjE2MTRmZi4uZmFhYTVjYTJhMTE3IDEwMDY0NA0KLS0tIGEvdG9vbHMvaW5jbHVk
ZS91YXBpL2xpbnV4L2lmX3hkcC5oDQorKysgYi90b29scy9pbmNsdWRlL3VhcGkvbGludXgvaWZf
eGRwLmgNCkBAIC00Niw2ICs0Niw3IEBAIHN0cnVjdCB4ZHBfbW1hcF9vZmZzZXRzIHsNCiAjZGVm
aW5lIFhEUF9VTUVNX0ZJTExfUklORwkJNQ0KICNkZWZpbmUgWERQX1VNRU1fQ09NUExFVElPTl9S
SU5HCTYNCiAjZGVmaW5lIFhEUF9TVEFUSVNUSUNTCQkJNw0KKyNkZWZpbmUgWERQX09QVElPTlMJ
CQk4DQogDQogc3RydWN0IHhkcF91bWVtX3JlZyB7DQogCV9fdTY0IGFkZHI7IC8qIFN0YXJ0IG9m
IHBhY2tldCBkYXRhIGFyZWEgKi8NCkBAIC02MCw2ICs2MSwxMyBAQCBzdHJ1Y3QgeGRwX3N0YXRp
c3RpY3Mgew0KIAlfX3U2NCB0eF9pbnZhbGlkX2Rlc2NzOyAvKiBEcm9wcGVkIGR1ZSB0byBpbnZh
bGlkIGRlc2NyaXB0b3IgKi8NCiB9Ow0KIA0KK3N0cnVjdCB4ZHBfb3B0aW9ucyB7DQorCV9fdTMy
IGZsYWdzOw0KK307DQorDQorLyogRmxhZ3MgZm9yIHRoZSBmbGFncyBmaWVsZCBvZiBzdHJ1Y3Qg
eGRwX29wdGlvbnMgKi8NCisjZGVmaW5lIFhEUF9PUFRJT05TX1pFUk9DT1BZICgxIDw8IDApDQor
DQogLyogUGdvZmYgZm9yIG1tYXBpbmcgdGhlIHJpbmdzICovDQogI2RlZmluZSBYRFBfUEdPRkZf
UlhfUklORwkJCSAgMA0KICNkZWZpbmUgWERQX1BHT0ZGX1RYX1JJTkcJCSAweDgwMDAwMDAwDQot
LSANCjIuMTkuMQ0KDQo=
