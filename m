Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF72FFF7A
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfD3SMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:12:46 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbfD3SMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdKBqDx3ePTEwovglLdiuAa9XjGn15tpUJ1M5CkQ7rg=;
 b=L7Em9VUyoR6ItJf4J6mQXvHD43gbKmiNXtAErnOgP+uVphMsHIYqI7N3zSDHtO0MjfltgJ04F2yAFkMADRvfjEqdDuWMxRKaplUhrMzP1jEd9s77pdKstwzx/nY8CZA9V1RSPKV/3zka3dycn82HQkp42Efcbbh923qoV9yqdjw=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:12:37 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:12:37 +0000
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
Subject: [PATCH bpf-next v2 02/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v2 02/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Index: AQHU/4BKnZIGLije30iWBScoq61BJg==
Date:   Tue, 30 Apr 2019 18:12:37 +0000
Message-ID: <20190430181215.15305-3-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 76c68cec-7388-4c96-8740-08d6cd976ce0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB55537E73BC0FBDD1AC42EBA0D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(14444005)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wU167ae3QSCt6RsQc2d/ZNQkKVUzGrT5OSkKkWrAEsFMK6Hq48UBuJiGBnmHOD29BU0xeX3SbP5jcZdftitaJ+fqsspVBFPjey/f/OosI3x3BjO3l31M56/EkZso6kCO0M7DlFa1/JYQsTTryCQTawOKzShYZowkhhVVlzFUPRACc3e5JqCyRUnTdsDBJjczoV1rbm7TcSSYtm9rspga/LiO/Q2Z2aWlvMLhW066jer1o67Lylr+u9jire52Dd/gC1cGr6tD13WafjDhiuq1Erz/O9OoYiAs3Vqj67kalfZ/ZHs46IwzbmW4M6atRBL9eFVPLbIfJgdzYfMhMQHImxfJHh0WEgXU1f3Tji3jU68aBmLaQY+YGcgWkp0RPZRARFzqTVTf+wBUVfBK66sHUHUG4F5CJiVECenIP+pt/rI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c68cec-7388-4c96-8740-08d6cd976ce0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:12:37.3546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
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
bm94LmNvbT4NCi0tLQ0KIGluY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCAgICAgICB8ICA3ICsr
KysrKysNCiBuZXQveGRwL3hzay5jICAgICAgICAgICAgICAgICAgICAgfCAyMiArKysrKysrKysr
KysrKysrKysrKysrDQogdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oIHwgIDcgKysr
KysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5o
DQppbmRleCBjYWVkOGIxNjE0ZmYuLjlhZTRiNGUwOGI2OCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9pZl94ZHAuaA0KKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQpA
QCAtNDYsNiArNDYsNyBAQCBzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyB7DQogI2RlZmluZSBYRFBf
VU1FTV9GSUxMX1JJTkcJCTUNCiAjZGVmaW5lIFhEUF9VTUVNX0NPTVBMRVRJT05fUklORwk2DQog
I2RlZmluZSBYRFBfU1RBVElTVElDUwkJCTcNCisjZGVmaW5lIFhEUF9PUFRJT05TCQkJOA0KIA0K
IHN0cnVjdCB4ZHBfdW1lbV9yZWcgew0KIAlfX3U2NCBhZGRyOyAvKiBTdGFydCBvZiBwYWNrZXQg
ZGF0YSBhcmVhICovDQpAQCAtNjAsNiArNjEsMTIgQEAgc3RydWN0IHhkcF9zdGF0aXN0aWNzIHsN
CiAJX191NjQgdHhfaW52YWxpZF9kZXNjczsgLyogRHJvcHBlZCBkdWUgdG8gaW52YWxpZCBkZXNj
cmlwdG9yICovDQogfTsNCiANCitzdHJ1Y3QgeGRwX29wdGlvbnMgew0KKwlfX3UzMiBmbGFnczsN
Cit9Ow0KKw0KKyNkZWZpbmUgWERQX09QVElPTlNfRkxBR19aRVJPQ09QWSAoMSA8PCAwKQ0KKw0K
IC8qIFBnb2ZmIGZvciBtbWFwaW5nIHRoZSByaW5ncyAqLw0KICNkZWZpbmUgWERQX1BHT0ZGX1JY
X1JJTkcJCQkgIDANCiAjZGVmaW5lIFhEUF9QR09GRl9UWF9SSU5HCQkgMHg4MDAwMDAwMA0KZGlm
ZiAtLWdpdCBhL25ldC94ZHAveHNrLmMgYi9uZXQveGRwL3hzay5jDQppbmRleCBiNjhhMzgwZjUw
YjMuLjk5ODE5OTEwOWQ1YyAxMDA2NDQNCi0tLSBhL25ldC94ZHAveHNrLmMNCisrKyBiL25ldC94
ZHAveHNrLmMNCkBAIC02NTAsNiArNjUwLDI4IEBAIHN0YXRpYyBpbnQgeHNrX2dldHNvY2tvcHQo
c3RydWN0IHNvY2tldCAqc29jaywgaW50IGxldmVsLCBpbnQgb3B0bmFtZSwNCiANCiAJCXJldHVy
biAwOw0KIAl9DQorCWNhc2UgWERQX09QVElPTlM6DQorCXsNCisJCXN0cnVjdCB4ZHBfb3B0aW9u
cyBvcHRzOw0KKw0KKwkJaWYgKGxlbiA8IHNpemVvZihvcHRzKSkNCisJCQlyZXR1cm4gLUVJTlZB
TDsNCisNCisJCW9wdHMuZmxhZ3MgPSAwOw0KKw0KKwkJbXV0ZXhfbG9jaygmeHMtPm11dGV4KTsN
CisJCWlmICh4cy0+emMpDQorCQkJb3B0cy5mbGFncyB8PSBYRFBfT1BUSU9OU19GTEFHX1pFUk9D
T1BZOw0KKwkJbXV0ZXhfdW5sb2NrKCZ4cy0+bXV0ZXgpOw0KKw0KKwkJbGVuID0gc2l6ZW9mKG9w
dHMpOw0KKwkJaWYgKGNvcHlfdG9fdXNlcihvcHR2YWwsICZvcHRzLCBsZW4pKQ0KKwkJCXJldHVy
biAtRUZBVUxUOw0KKwkJaWYgKHB1dF91c2VyKGxlbiwgb3B0bGVuKSkNCisJCQlyZXR1cm4gLUVG
QVVMVDsNCisNCisJCXJldHVybiAwOw0KKwl9DQogCWRlZmF1bHQ6DQogCQlicmVhazsNCiAJfQ0K
ZGlmZiAtLWdpdCBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCBiL3Rvb2xzL2lu
Y2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaA0KaW5kZXggY2FlZDhiMTYxNGZmLi45YWU0YjRlMDhi
NjggMTAwNjQ0DQotLS0gYS90b29scy9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmgNCisrKyBi
L3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaA0KQEAgLTQ2LDYgKzQ2LDcgQEAgc3Ry
dWN0IHhkcF9tbWFwX29mZnNldHMgew0KICNkZWZpbmUgWERQX1VNRU1fRklMTF9SSU5HCQk1DQog
I2RlZmluZSBYRFBfVU1FTV9DT01QTEVUSU9OX1JJTkcJNg0KICNkZWZpbmUgWERQX1NUQVRJU1RJ
Q1MJCQk3DQorI2RlZmluZSBYRFBfT1BUSU9OUwkJCTgNCiANCiBzdHJ1Y3QgeGRwX3VtZW1fcmVn
IHsNCiAJX191NjQgYWRkcjsgLyogU3RhcnQgb2YgcGFja2V0IGRhdGEgYXJlYSAqLw0KQEAgLTYw
LDYgKzYxLDEyIEBAIHN0cnVjdCB4ZHBfc3RhdGlzdGljcyB7DQogCV9fdTY0IHR4X2ludmFsaWRf
ZGVzY3M7IC8qIERyb3BwZWQgZHVlIHRvIGludmFsaWQgZGVzY3JpcHRvciAqLw0KIH07DQogDQor
c3RydWN0IHhkcF9vcHRpb25zIHsNCisJX191MzIgZmxhZ3M7DQorfTsNCisNCisjZGVmaW5lIFhE
UF9PUFRJT05TX0ZMQUdfWkVST0NPUFkgKDEgPDwgMCkNCisNCiAvKiBQZ29mZiBmb3IgbW1hcGlu
ZyB0aGUgcmluZ3MgKi8NCiAjZGVmaW5lIFhEUF9QR09GRl9SWF9SSU5HCQkJICAwDQogI2RlZmlu
ZSBYRFBfUEdPRkZfVFhfUklORwkJIDB4ODAwMDAwMDANCi0tIA0KMi4xOS4xDQoNCg==
