Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF54A009
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfFRMAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:53 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:20207
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbfFRMAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGEuLHVj8E9pnz15duFqAWGWtQnPbP+YGMKazgoZruw=;
 b=AxvQTLfGtYAuI2yEf141l7MlIr5Iqi525DXWxOKNWBBgF1PZElXRCrH2qklwA/mY3wJFTZ1tD4Ayt5eEfcqkTAHFkW5uraTGK8mjs+W+0BdIkoHNkPTaU+NGdoZQAcWKlKmigWROi/mMz2AFmDtPMDetfio109pORKh2+VCgUJ4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5333.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 12:00:47 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:47 +0000
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
Subject: [PATCH bpf-next v5 04/16] libbpf: Support getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v5 04/16] libbpf: Support getsockopt XDP_OPTIONS
Thread-Index: AQHVJc12puAzaq00jE+pij+BRfTAhg==
Date:   Tue, 18 Jun 2019 12:00:47 +0000
Message-ID: <20190618120024.16788-5-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 61c31f84-d06d-416a-e96c-08d6f3e49929
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5333;
x-ms-traffictypediagnostic: AM6PR05MB5333:
x-microsoft-antispam-prvs: <AM6PR05MB53331D4E453144C7B0125CD5D1EA0@AM6PR05MB5333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(305945005)(66556008)(476003)(11346002)(66476007)(386003)(68736007)(478600001)(2616005)(66066001)(66946007)(73956011)(86362001)(6436002)(66446008)(25786009)(26005)(81156014)(6486002)(64756008)(446003)(6506007)(4326008)(316002)(81166006)(8676002)(102836004)(8936002)(54906003)(486006)(186003)(110136005)(6512007)(7416002)(53936002)(71200400001)(50226002)(76176011)(71190400001)(52116002)(36756003)(256004)(14454004)(107886003)(6116002)(1076003)(3846002)(5660300002)(7736002)(99286004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5333;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zxE9aUrv6FwqyA7BbiF7uMqnkRlr8sNQ5PRnbU5+qIVY+o8YfEx/xlzUvrfWeN/oaMgz3lEAXqXVZe2hNEA76aONXmQcMvhLn1X58Or12bWZdIkuMzVgH87lnrg4lDq7WFBVjj4W1BFqXTVI6I5TGxhDaWIlHPYhmFQ85h22U4D/PBMMpdJflC5g2+RNCVgaXHwIhcFt8Xz5eiHsRqzMhU0sqXCbps1n/L6GLlhkUQh3SSymZEsc5E+d0Qyl7cFqpLiRR3FSSmo8Pyjz5y2enG4F91xe4mvjko8Ne44Gvb9GTx6FJcQdWBvwQXnrNxh67kCUjk5f95q+H2ZwXVCg5frNpPBrYi4q7iUtJM1Esi21WLnCoWaTXMSXW8nWfIZUQYM2ZXXkDMMXflkSDx3PPGIS0KK3lqIa0r/zyHk2xrE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D714B9EFFE29094FA6EBF9DC0BE90D9B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c31f84-d06d-416a-e96c-08d6f3e49929
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:47.0345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UXVlcnkgWERQX09QVElPTlMgaW4gbGliYnBmIHRvIGRldGVybWluZSBpZiB0aGUgemVyby1jb3B5
IG1vZGUgaXMgYWN0aXZlDQpvciBub3QuDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFu
c2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0
YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KQWNrZWQtYnk6IEJqw7ZybiBUw7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNv
bT4NCi0tLQ0KIHRvb2xzL2xpYi9icGYveHNrLmMgfCAxMiArKysrKysrKysrKysNCiAxIGZpbGUg
Y2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94
c2suYyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCmluZGV4IDdlZjYyOTNiNGZkNy4uYmYxNWE4MGEz
N2MyIDEwMDY0NA0KLS0tIGEvdG9vbHMvbGliL2JwZi94c2suYw0KKysrIGIvdG9vbHMvbGliL2Jw
Zi94c2suYw0KQEAgLTY1LDYgKzY1LDcgQEAgc3RydWN0IHhza19zb2NrZXQgew0KIAlpbnQgeHNr
c19tYXBfZmQ7DQogCV9fdTMyIHF1ZXVlX2lkOw0KIAljaGFyIGlmbmFtZVtJRk5BTVNJWl07DQor
CWJvb2wgemM7DQogfTsNCiANCiBzdHJ1Y3QgeHNrX25sX2luZm8gew0KQEAgLTQ4MCw2ICs0ODEs
NyBAQCBpbnQgeHNrX3NvY2tldF9fY3JlYXRlKHN0cnVjdCB4c2tfc29ja2V0ICoqeHNrX3B0ciwg
Y29uc3QgY2hhciAqaWZuYW1lLA0KIAl2b2lkICpyeF9tYXAgPSBOVUxMLCAqdHhfbWFwID0gTlVM
TDsNCiAJc3RydWN0IHNvY2thZGRyX3hkcCBzeGRwID0ge307DQogCXN0cnVjdCB4ZHBfbW1hcF9v
ZmZzZXRzIG9mZjsNCisJc3RydWN0IHhkcF9vcHRpb25zIG9wdHM7DQogCXN0cnVjdCB4c2tfc29j
a2V0ICp4c2s7DQogCXNvY2tsZW5fdCBvcHRsZW47DQogCWludCBlcnI7DQpAQCAtNTk3LDYgKzU5
OSwxNiBAQCBpbnQgeHNrX3NvY2tldF9fY3JlYXRlKHN0cnVjdCB4c2tfc29ja2V0ICoqeHNrX3B0
ciwgY29uc3QgY2hhciAqaWZuYW1lLA0KIAl9DQogDQogCXhzay0+cHJvZ19mZCA9IC0xOw0KKw0K
KwlvcHRsZW4gPSBzaXplb2Yob3B0cyk7DQorCWVyciA9IGdldHNvY2tvcHQoeHNrLT5mZCwgU09M
X1hEUCwgWERQX09QVElPTlMsICZvcHRzLCAmb3B0bGVuKTsNCisJaWYgKGVycikgew0KKwkJZXJy
ID0gLWVycm5vOw0KKwkJZ290byBvdXRfbW1hcF90eDsNCisJfQ0KKw0KKwl4c2stPnpjID0gb3B0
cy5mbGFncyAmIFhEUF9PUFRJT05TX1pFUk9DT1BZOw0KKw0KIAlpZiAoISh4c2stPmNvbmZpZy5s
aWJicGZfZmxhZ3MgJiBYU0tfTElCQlBGX0ZMQUdTX19JTkhJQklUX1BST0dfTE9BRCkpIHsNCiAJ
CWVyciA9IHhza19zZXR1cF94ZHBfcHJvZyh4c2spOw0KIAkJaWYgKGVycikNCi0tIA0KMi4xOS4x
DQoNCg==
