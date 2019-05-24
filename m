Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73ABA294BB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbfEXJfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:35:22 -0400
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:22992
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389869AbfEXJfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PnC9GDTOhmlJoIEmMOH0APFrJ7Nt7cTtmgtlyGULTc=;
 b=r5rPRymozd9at19biJrR1wR8tABWaZD0E5ofA+1cuj60ngaOvDy5khvmG/wJnsQ0uY2kllUK4bS4tyTozwDRur1MEnUkuwS3H3Va+ZQdjjxLaPgFr+4DrQ9iT/rzLxhzvoRWHGUr/CsZev0Z9BBxmBvxox2D+fxEc+Wt8I52RUA=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4294.eurprd05.prod.outlook.com (52.135.160.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 24 May 2019 09:35:17 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:17 +0000
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
Subject: [PATCH bpf-next v3 03/16] libbpf: Support getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v3 03/16] libbpf: Support getsockopt XDP_OPTIONS
Thread-Index: AQHVEhP/PHEMzx35Z0aT2HfuxeUMXw==
Date:   Fri, 24 May 2019 09:35:17 +0000
Message-ID: <20190524093431.20887-4-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 08a3b340-0f44-481f-d409-08d6e02b2158
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4294;
x-ms-traffictypediagnostic: AM6PR05MB4294:
x-microsoft-antispam-prvs: <AM6PR05MB4294332CBFD37FE094616E16D1020@AM6PR05MB4294.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(189003)(66476007)(99286004)(478600001)(76176011)(66556008)(66946007)(14454004)(68736007)(6506007)(64756008)(386003)(66446008)(36756003)(316002)(54906003)(110136005)(73956011)(107886003)(26005)(486006)(71200400001)(71190400001)(52116002)(11346002)(446003)(186003)(305945005)(7736002)(2616005)(2906002)(476003)(6436002)(5660300002)(53936002)(50226002)(7416002)(8676002)(102836004)(1076003)(8936002)(256004)(66066001)(86362001)(25786009)(6486002)(6512007)(4326008)(81166006)(3846002)(6116002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4294;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3VO+mkc2Ys46NSxCsEXTwI1HyXX+tm39qvY/fP1dhd4vidjErcrBWotFkxXKhuLaxaIaYBhBP1EKxyO+nQdIQ0BRfYIJEFRWiRNbvXId9uaZGC0jxXR02oi/tYZ2f9Hu23XsOV5e0vLNSjFNxFdX1m9uqEbRrre7pxxdv+EZvyHnq2DpA/9mDsWR8Lcqq7v5aIZvXzOvg85rbjC+q9zaO5bO1SJCMpEaWwMvDBhaYXPme/ZBSIST4J0SFNXNpS0YuYUbTcApxVxuiMqEZjQ0imnu2VBpXyPbFE6hJsgGfpaGsfmyvU0+UzsF/GOmnHGF/wCM7hW77OZRTTHK1qB6bPzSzp16wF9mZmnQONM/ts9VoesPGFYqZ6j/Fa1agLHYS8F3DkKGhkGh/nOx9ypIF9NFYxkTmokQJrQJW3HLOOg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a3b340-0f44-481f-d409-08d6e02b2158
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:17.0377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4294
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UXVlcnkgWERQX09QVElPTlMgaW4gbGliYnBmIHRvIGRldGVybWluZSBpZiB0aGUgemVyby1jb3B5
IG1vZGUgaXMgYWN0aXZlDQpvciBub3QuDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFu
c2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNh
ZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiB0b29scy9saWIvYnBmL3hzay5jIHwgMTEgKysrKysr
KysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEv
dG9vbHMvbGliL2JwZi94c2suYyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCmluZGV4IDM4NjY3YjYy
ZjFmZS4uYmVkZDc0N2RiODFhIDEwMDY0NA0KLS0tIGEvdG9vbHMvbGliL2JwZi94c2suYw0KKysr
IGIvdG9vbHMvbGliL2JwZi94c2suYw0KQEAgLTY3LDYgKzY3LDcgQEAgc3RydWN0IHhza19zb2Nr
ZXQgew0KIAlpbnQgeHNrc19tYXBfZmQ7DQogCV9fdTMyIHF1ZXVlX2lkOw0KIAljaGFyIGlmbmFt
ZVtJRk5BTVNJWl07DQorCWJvb2wgemM7DQogfTsNCiANCiBzdHJ1Y3QgeHNrX25sX2luZm8gew0K
QEAgLTUyNyw2ICs1MjgsNyBAQCBpbnQgeHNrX3NvY2tldF9fY3JlYXRlKHN0cnVjdCB4c2tfc29j
a2V0ICoqeHNrX3B0ciwgY29uc3QgY2hhciAqaWZuYW1lLA0KIAl2b2lkICpyeF9tYXAgPSBOVUxM
LCAqdHhfbWFwID0gTlVMTDsNCiAJc3RydWN0IHNvY2thZGRyX3hkcCBzeGRwID0ge307DQogCXN0
cnVjdCB4ZHBfbW1hcF9vZmZzZXRzIG9mZjsNCisJc3RydWN0IHhkcF9vcHRpb25zIG9wdHM7DQog
CXN0cnVjdCB4c2tfc29ja2V0ICp4c2s7DQogCXNvY2tsZW5fdCBvcHRsZW47DQogCWludCBlcnI7
DQpAQCAtNjQ2LDYgKzY0OCwxNSBAQCBpbnQgeHNrX3NvY2tldF9fY3JlYXRlKHN0cnVjdCB4c2tf
c29ja2V0ICoqeHNrX3B0ciwgY29uc3QgY2hhciAqaWZuYW1lLA0KIAl4c2stPnFpZGNvbmZfbWFw
X2ZkID0gLTE7DQogCXhzay0+eHNrc19tYXBfZmQgPSAtMTsNCiANCisJb3B0bGVuID0gc2l6ZW9m
KG9wdHMpOw0KKwllcnIgPSBnZXRzb2Nrb3B0KHhzay0+ZmQsIFNPTF9YRFAsIFhEUF9PUFRJT05T
LCAmb3B0cywgJm9wdGxlbik7DQorCWlmIChlcnIpIHsNCisJCWVyciA9IC1lcnJubzsNCisJCWdv
dG8gb3V0X21tYXBfdHg7DQorCX0NCisNCisJeHNrLT56YyA9IG9wdHMuZmxhZ3MgJiBYRFBfT1BU
SU9OU19aRVJPQ09QWTsNCisNCiAJaWYgKCEoeHNrLT5jb25maWcubGliYnBmX2ZsYWdzICYgWFNL
X0xJQkJQRl9GTEFHU19fSU5ISUJJVF9QUk9HX0xPQUQpKSB7DQogCQllcnIgPSB4c2tfc2V0dXBf
eGRwX3Byb2coeHNrKTsNCiAJCWlmIChlcnIpDQotLSANCjIuMTkuMQ0KDQo=
