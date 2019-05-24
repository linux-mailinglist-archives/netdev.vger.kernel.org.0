Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59214294B9
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390144AbfEXJfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:35:20 -0400
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:22992
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389841AbfEXJfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbddk2TtqxJ72MRvWew16x+EpoGUY0Q5bB89+Qdd4Q8=;
 b=c/C5k4peMBpiWbRudIE7XihRs+10KWoeCXWwpGz3eMYqyEaiOkGXm1ZJjsOxOMRp5i7SzGOv4VstZCFyl6jRQ7S+YAZ1nPFmKCadUdFsIM4fMvbwsWY8goGmuoO+xX+ghe3s+1TWW1EJj+QxkZIpjpqKyjEQgOOFCDYa0b5WwO8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4294.eurprd05.prod.outlook.com (52.135.160.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 24 May 2019 09:35:15 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:15 +0000
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
Subject: [PATCH bpf-next v3 02/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v3 02/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Index: AQHVEhP9Gobwvg4Fr0mmNAWP9FKGkA==
Date:   Fri, 24 May 2019 09:35:15 +0000
Message-ID: <20190524093431.20887-3-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e2ff6048-5ad6-4ecf-cb2c-08d6e02b2034
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4294;
x-ms-traffictypediagnostic: AM6PR05MB4294:
x-microsoft-antispam-prvs: <AM6PR05MB429401C9DE0B732F478006E3D1020@AM6PR05MB4294.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(189003)(66476007)(99286004)(478600001)(76176011)(66556008)(66946007)(14454004)(68736007)(6506007)(64756008)(386003)(66446008)(36756003)(316002)(54906003)(110136005)(73956011)(107886003)(26005)(486006)(71200400001)(71190400001)(52116002)(11346002)(446003)(186003)(305945005)(7736002)(2616005)(2906002)(476003)(6436002)(5660300002)(53936002)(50226002)(7416002)(8676002)(102836004)(1076003)(8936002)(256004)(66066001)(86362001)(25786009)(6486002)(6512007)(4326008)(81166006)(3846002)(6116002)(81156014)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4294;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kLZzgsX7/uF9gvIHdiwduBMXhWAh8Gu7tE+KDfN19d8teY28yHxgx5aeem56IV0g758njR7m8FHExlKRbXUybHvZG//cn1MYzqkXSztvPhQJ2/uAaGHLTKOg29PUOH0OA4GwOTdn69t1NLkvIPLjR01RYjn/x1EvnZcb6KwiF6D/NWHsPUS3GPDHMCDQRyl1T1g4pmNBA0uv/VQbLuxrWJl8L9/duS+4GQAaEkFOzz1hGAIW4nKwezPtwL7qkptkWF/v3PMTYkCZ837haNXU1JkQ3Gqwi43YX9REpMwHz+SBzjYFBRON8cfplq/NFBMcqmH8NIXIM5rnowizdT2sxi2lfKtmzAZSlCF3LpGBgjQEHSC13DpBdY4zZ1qKAmr3IuFNUbvmiZ4rX2Ri+fcSypQyo0yod2OHVNewNSpKUqo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ff6048-5ad6-4ecf-cb2c-08d6e02b2034
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:15.1498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4294
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFrZSBpdCBwb3NzaWJsZSBmb3IgdGhlIGFwcGxpY2F0aW9uIHRvIGRldGVybWluZSB3aGV0aGVy
IHRoZSBBRl9YRFANCnNvY2tldCBpcyBydW5uaW5nIGluIHplcm8tY29weSBtb2RlLiBUbyBhY2hp
ZXZlIHRoaXMsIGFkZCBhIG5ldw0KZ2V0c29ja29wdCBvcHRpb24gWERQX09QVElPTlMgdGhhdCBy
ZXR1cm5zIGZsYWdzLiBUaGUgb25seSBmbGFnDQpzdXBwb3J0ZWQgZm9yIG5vdyBpcyB0aGUgemVy
by1jb3B5IG1vZGUgaW5kaWNhdG9yLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNr
aXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVl
ZG1AbWVsbGFub3guY29tPg0KLS0tDQogaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oICAgICAg
IHwgIDggKysrKysrKysNCiBuZXQveGRwL3hzay5jICAgICAgICAgICAgICAgICAgICAgfCAyMCAr
KysrKysrKysrKysrKysrKysrKw0KIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCB8
ICA4ICsrKysrKysrDQogMyBmaWxlcyBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggYi9pbmNsdWRlL3VhcGkvbGludXgv
aWZfeGRwLmgNCmluZGV4IGNhZWQ4YjE2MTRmZi4uZmFhYTVjYTJhMTE3IDEwMDY0NA0KLS0tIGEv
aW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvaWZf
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
UlhfUklORwkJCSAgMA0KICNkZWZpbmUgWERQX1BHT0ZGX1RYX1JJTkcJCSAweDgwMDAwMDAwDQpk
aWZmIC0tZ2l0IGEvbmV0L3hkcC94c2suYyBiL25ldC94ZHAveHNrLmMNCmluZGV4IGI2OGEzODBm
NTBiMy4uMzVjYTUzMWFjNzRlIDEwMDY0NA0KLS0tIGEvbmV0L3hkcC94c2suYw0KKysrIGIvbmV0
L3hkcC94c2suYw0KQEAgLTY1MCw2ICs2NTAsMjYgQEAgc3RhdGljIGludCB4c2tfZ2V0c29ja29w
dChzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBpbnQgbGV2ZWwsIGludCBvcHRuYW1lLA0KIA0KIAkJcmV0
dXJuIDA7DQogCX0NCisJY2FzZSBYRFBfT1BUSU9OUzoNCisJew0KKwkJc3RydWN0IHhkcF9vcHRp
b25zIG9wdHMgPSB7fTsNCisNCisJCWlmIChsZW4gPCBzaXplb2Yob3B0cykpDQorCQkJcmV0dXJu
IC1FSU5WQUw7DQorDQorCQltdXRleF9sb2NrKCZ4cy0+bXV0ZXgpOw0KKwkJaWYgKHhzLT56YykN
CisJCQlvcHRzLmZsYWdzIHw9IFhEUF9PUFRJT05TX1pFUk9DT1BZOw0KKwkJbXV0ZXhfdW5sb2Nr
KCZ4cy0+bXV0ZXgpOw0KKw0KKwkJbGVuID0gc2l6ZW9mKG9wdHMpOw0KKwkJaWYgKGNvcHlfdG9f
dXNlcihvcHR2YWwsICZvcHRzLCBsZW4pKQ0KKwkJCXJldHVybiAtRUZBVUxUOw0KKwkJaWYgKHB1
dF91c2VyKGxlbiwgb3B0bGVuKSkNCisJCQlyZXR1cm4gLUVGQVVMVDsNCisNCisJCXJldHVybiAw
Ow0KKwl9DQogCWRlZmF1bHQ6DQogCQlicmVhazsNCiAJfQ0KZGlmZiAtLWdpdCBhL3Rvb2xzL2lu
Y2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCBiL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9pZl94
ZHAuaA0KaW5kZXggY2FlZDhiMTYxNGZmLi5mYWFhNWNhMmExMTcgMTAwNjQ0DQotLS0gYS90b29s
cy9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmgNCisrKyBiL3Rvb2xzL2luY2x1ZGUvdWFwaS9s
aW51eC9pZl94ZHAuaA0KQEAgLTQ2LDYgKzQ2LDcgQEAgc3RydWN0IHhkcF9tbWFwX29mZnNldHMg
ew0KICNkZWZpbmUgWERQX1VNRU1fRklMTF9SSU5HCQk1DQogI2RlZmluZSBYRFBfVU1FTV9DT01Q
TEVUSU9OX1JJTkcJNg0KICNkZWZpbmUgWERQX1NUQVRJU1RJQ1MJCQk3DQorI2RlZmluZSBYRFBf
T1BUSU9OUwkJCTgNCiANCiBzdHJ1Y3QgeGRwX3VtZW1fcmVnIHsNCiAJX191NjQgYWRkcjsgLyog
U3RhcnQgb2YgcGFja2V0IGRhdGEgYXJlYSAqLw0KQEAgLTYwLDYgKzYxLDEzIEBAIHN0cnVjdCB4
ZHBfc3RhdGlzdGljcyB7DQogCV9fdTY0IHR4X2ludmFsaWRfZGVzY3M7IC8qIERyb3BwZWQgZHVl
IHRvIGludmFsaWQgZGVzY3JpcHRvciAqLw0KIH07DQogDQorc3RydWN0IHhkcF9vcHRpb25zIHsN
CisJX191MzIgZmxhZ3M7DQorfTsNCisNCisvKiBGbGFncyBmb3IgdGhlIGZsYWdzIGZpZWxkIG9m
IHN0cnVjdCB4ZHBfb3B0aW9ucyAqLw0KKyNkZWZpbmUgWERQX09QVElPTlNfWkVST0NPUFkgKDEg
PDwgMCkNCisNCiAvKiBQZ29mZiBmb3IgbW1hcGluZyB0aGUgcmluZ3MgKi8NCiAjZGVmaW5lIFhE
UF9QR09GRl9SWF9SSU5HCQkJICAwDQogI2RlZmluZSBYRFBfUEdPRkZfVFhfUklORwkJIDB4ODAw
MDAwMDANCi0tIA0KMi4xOS4xDQoNCg==
