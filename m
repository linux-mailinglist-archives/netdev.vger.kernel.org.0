Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6374E42B5B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbfFLP4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:56:54 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:27022
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729527AbfFLP4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrShXtUsuA2kjbuotPDad+1GbtrSdlQMHHFCuNOt3i0=;
 b=jV/TEFh2BGKTK55JF31BzyunSzWXx/UBHIo6dm4Bj9uGZMpCv5dY+zjg1w+x80zpVQa6DFIAG949VRupvHeqHM7aQ4qi3cqs46P9gdcDeUIiWnByXQ2O6Dr15Cu0Wu5MFExCchzQwayu63ASKFDD0jgeSAmie+GKq0lIT2M80m4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:37 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:37 +0000
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
Subject: [PATCH bpf-next v4 02/17] xsk: Add API to check for available entries
 in FQ
Thread-Topic: [PATCH bpf-next v4 02/17] xsk: Add API to check for available
 entries in FQ
Thread-Index: AQHVITdqvtzoA2bd4024+SussqHsoQ==
Date:   Wed, 12 Jun 2019 15:56:37 +0000
Message-ID: <20190612155605.22450-3-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 3f2daf94-e941-4e7f-45a0-08d6ef4e8cdf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB5240E88AB72958C175B62C62D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c9vXxRKCglEyEK3wwvbsZYi+QVbp2O3b0h9s+GAKaRLHe3hloik3oCVcF+1rLlcf3USDqdrHBWcW7O8AWiZE+WoaYFbRyGUJJ2/1YUAS8Pqrrz7nFHv9CBTbBk60Xsak+ucmzcedWodUDEBrUNYjxLUWFv2FV7CnYnOFhsl8GdHRCAkGLTe9jV7ZkxPTbXVAHp5TRdlrpkdf4w+vUXzl43vSYu5focihjKca3ZzOSyak5rEsieZ7VmWnYxQxyL2QUF+XpspJ1jxvhuu6q/uqbICxv2HmTtsLOPeWGIpkLVcySxTCubOpptGJZOVMgDdhIon4sG19K8Tn3DztaVCEK/rivkRO9PQiWXUalht6DuOPzpVZSS9R0VVFdw5IQwTOlU9xvCWEULo7ZGAmwoa/ijA+BUmDCtXJxCcMSPmswiw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2daf94-e941-4e7f-45a0-08d6ef4e8cdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:37.2502
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

QWRkIGEgZnVuY3Rpb24gdGhhdCBjaGVja3Mgd2hldGhlciB0aGUgRmlsbCBSaW5nIGhhcyB0aGUg
c3BlY2lmaWVkDQphbW91bnQgb2YgZGVzY3JpcHRvcnMgYXZhaWxhYmxlLiBJdCB3aWxsIGJlIHVz
ZWZ1bCBmb3IgbWx4NWUgdGhhdCB3YW50cw0KdG8gY2hlY2sgaW4gYWR2YW5jZSwgd2hldGhlciBp
dCBjYW4gYWxsb2NhdGUgYSBidWxrIG9mIFJYIGRlc2NyaXB0b3JzLA0KdG8gZ2V0IHRoZSBiZXN0
IHBlcmZvcm1hbmNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGlt
bWlAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxh
bm94LmNvbT4NCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4N
Ci0tLQ0KIGluY2x1ZGUvbmV0L3hkcF9zb2NrLmggfCAyMSArKysrKysrKysrKysrKysrKysrKysN
CiBuZXQveGRwL3hzay5jICAgICAgICAgIHwgIDYgKysrKysrDQogbmV0L3hkcC94c2tfcXVldWUu
aCAgICB8IDE0ICsrKysrKysrKysrKysrDQogMyBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC94ZHBfc29jay5oIGIvaW5jbHVkZS9uZXQv
eGRwX3NvY2suaA0KaW5kZXggYWUwZjM2OGE2MmJiLi5iNmY1ZWJhZTQzYTEgMTAwNjQ0DQotLS0g
YS9pbmNsdWRlL25ldC94ZHBfc29jay5oDQorKysgYi9pbmNsdWRlL25ldC94ZHBfc29jay5oDQpA
QCAtNzcsNiArNzcsNyBAQCBpbnQgeHNrX3JjdihzdHJ1Y3QgeGRwX3NvY2sgKnhzLCBzdHJ1Y3Qg
eGRwX2J1ZmYgKnhkcCk7DQogdm9pZCB4c2tfZmx1c2goc3RydWN0IHhkcF9zb2NrICp4cyk7DQog
Ym9vbCB4c2tfaXNfc2V0dXBfZm9yX2JwZl9tYXAoc3RydWN0IHhkcF9zb2NrICp4cyk7DQogLyog
VXNlZCBmcm9tIG5ldGRldiBkcml2ZXIgKi8NCitib29sIHhza191bWVtX2hhc19hZGRycyhzdHJ1
Y3QgeGRwX3VtZW0gKnVtZW0sIHUzMiBjbnQpOw0KIHU2NCAqeHNrX3VtZW1fcGVla19hZGRyKHN0
cnVjdCB4ZHBfdW1lbSAqdW1lbSwgdTY0ICphZGRyKTsNCiB2b2lkIHhza191bWVtX2Rpc2NhcmRf
YWRkcihzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0pOw0KIHZvaWQgeHNrX3VtZW1fY29tcGxldGVfdHgo
c3RydWN0IHhkcF91bWVtICp1bWVtLCB1MzIgbmJfZW50cmllcyk7DQpAQCAtOTksNiArMTAwLDE2
IEBAIHN0YXRpYyBpbmxpbmUgZG1hX2FkZHJfdCB4ZHBfdW1lbV9nZXRfZG1hKHN0cnVjdCB4ZHBf
dW1lbSAqdW1lbSwgdTY0IGFkZHIpDQogfQ0KIA0KIC8qIFJldXNlLXF1ZXVlIGF3YXJlIHZlcnNp
b24gb2YgRklMTCBxdWV1ZSBoZWxwZXJzICovDQorc3RhdGljIGlubGluZSBib29sIHhza191bWVt
X2hhc19hZGRyc19ycShzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHUzMiBjbnQpDQorew0KKwlzdHJ1
Y3QgeGRwX3VtZW1fZnFfcmV1c2UgKnJxID0gdW1lbS0+ZnFfcmV1c2U7DQorDQorCWlmIChycS0+
bGVuZ3RoID49IGNudCkNCisJCXJldHVybiB0cnVlOw0KKw0KKwlyZXR1cm4geHNrX3VtZW1faGFz
X2FkZHJzKHVtZW0sIGNudCAtIHJxLT5sZW5ndGgpOw0KK30NCisNCiBzdGF0aWMgaW5saW5lIHU2
NCAqeHNrX3VtZW1fcGVla19hZGRyX3JxKHN0cnVjdCB4ZHBfdW1lbSAqdW1lbSwgdTY0ICphZGRy
KQ0KIHsNCiAJc3RydWN0IHhkcF91bWVtX2ZxX3JldXNlICpycSA9IHVtZW0tPmZxX3JldXNlOw0K
QEAgLTE0Niw2ICsxNTcsMTEgQEAgc3RhdGljIGlubGluZSBib29sIHhza19pc19zZXR1cF9mb3Jf
YnBmX21hcChzdHJ1Y3QgeGRwX3NvY2sgKnhzKQ0KIAlyZXR1cm4gZmFsc2U7DQogfQ0KIA0KK3N0
YXRpYyBpbmxpbmUgYm9vbCB4c2tfdW1lbV9oYXNfYWRkcnMoc3RydWN0IHhkcF91bWVtICp1bWVt
LCB1MzIgY250KQ0KK3sNCisJcmV0dXJuIGZhbHNlOw0KK30NCisNCiBzdGF0aWMgaW5saW5lIHU2
NCAqeHNrX3VtZW1fcGVla19hZGRyKHN0cnVjdCB4ZHBfdW1lbSAqdW1lbSwgdTY0ICphZGRyKQ0K
IHsNCiAJcmV0dXJuIE5VTEw7DQpAQCAtMjAwLDYgKzIxNiwxMSBAQCBzdGF0aWMgaW5saW5lIGRt
YV9hZGRyX3QgeGRwX3VtZW1fZ2V0X2RtYShzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHU2NCBhZGRy
KQ0KIAlyZXR1cm4gMDsNCiB9DQogDQorc3RhdGljIGlubGluZSBib29sIHhza191bWVtX2hhc19h
ZGRyc19ycShzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHUzMiBjbnQpDQorew0KKwlyZXR1cm4gZmFs
c2U7DQorfQ0KKw0KIHN0YXRpYyBpbmxpbmUgdTY0ICp4c2tfdW1lbV9wZWVrX2FkZHJfcnEoc3Ry
dWN0IHhkcF91bWVtICp1bWVtLCB1NjQgKmFkZHIpDQogew0KIAlyZXR1cm4gTlVMTDsNCmRpZmYg
LS1naXQgYS9uZXQveGRwL3hzay5jIGIvbmV0L3hkcC94c2suYw0KaW5kZXggYTE0ZTg4NjRlNGZh
Li5iNjhhMzgwZjUwYjMgMTAwNjQ0DQotLS0gYS9uZXQveGRwL3hzay5jDQorKysgYi9uZXQveGRw
L3hzay5jDQpAQCAtMzcsNiArMzcsMTIgQEAgYm9vbCB4c2tfaXNfc2V0dXBfZm9yX2JwZl9tYXAo
c3RydWN0IHhkcF9zb2NrICp4cykNCiAJCVJFQURfT05DRSh4cy0+dW1lbS0+ZnEpOw0KIH0NCiAN
Citib29sIHhza191bWVtX2hhc19hZGRycyhzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHUzMiBjbnQp
DQorew0KKwlyZXR1cm4geHNrcV9oYXNfYWRkcnModW1lbS0+ZnEsIGNudCk7DQorfQ0KK0VYUE9S
VF9TWU1CT0woeHNrX3VtZW1faGFzX2FkZHJzKTsNCisNCiB1NjQgKnhza191bWVtX3BlZWtfYWRk
cihzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHU2NCAqYWRkcikNCiB7DQogCXJldHVybiB4c2txX3Bl
ZWtfYWRkcih1bWVtLT5mcSwgYWRkcik7DQpkaWZmIC0tZ2l0IGEvbmV0L3hkcC94c2tfcXVldWUu
aCBiL25ldC94ZHAveHNrX3F1ZXVlLmgNCmluZGV4IDg4YjlhZTI0NjU4ZC4uMTJiNDk3ODRhNmQ1
IDEwMDY0NA0KLS0tIGEvbmV0L3hkcC94c2tfcXVldWUuaA0KKysrIGIvbmV0L3hkcC94c2tfcXVl
dWUuaA0KQEAgLTExNyw2ICsxMTcsMjAgQEAgc3RhdGljIGlubGluZSB1MzIgeHNrcV9uYl9mcmVl
KHN0cnVjdCB4c2tfcXVldWUgKnEsIHUzMiBwcm9kdWNlciwgdTMyIGRjbnQpDQogCXJldHVybiBx
LT5uZW50cmllcyAtIChwcm9kdWNlciAtIHEtPmNvbnNfdGFpbCk7DQogfQ0KIA0KK3N0YXRpYyBp
bmxpbmUgYm9vbCB4c2txX2hhc19hZGRycyhzdHJ1Y3QgeHNrX3F1ZXVlICpxLCB1MzIgY250KQ0K
K3sNCisJdTMyIGVudHJpZXMgPSBxLT5wcm9kX3RhaWwgLSBxLT5jb25zX3RhaWw7DQorDQorCWlm
IChlbnRyaWVzID49IGNudCkNCisJCXJldHVybiB0cnVlOw0KKw0KKwkvKiBSZWZyZXNoIHRoZSBs
b2NhbCBwb2ludGVyLiAqLw0KKwlxLT5wcm9kX3RhaWwgPSBSRUFEX09OQ0UocS0+cmluZy0+cHJv
ZHVjZXIpOw0KKwllbnRyaWVzID0gcS0+cHJvZF90YWlsIC0gcS0+Y29uc190YWlsOw0KKw0KKwly
ZXR1cm4gZW50cmllcyA+PSBjbnQ7DQorfQ0KKw0KIC8qIFVNRU0gcXVldWUgKi8NCiANCiBzdGF0
aWMgaW5saW5lIGJvb2wgeHNrcV9pc192YWxpZF9hZGRyKHN0cnVjdCB4c2tfcXVldWUgKnEsIHU2
NCBhZGRyKQ0KLS0gDQoyLjE5LjENCg0K
