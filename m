Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98C9FF7C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfD3SMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:12:51 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbfD3SMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJ4JSVaexTjDmLhack66eK1rVsHA3YtVDLI2YxIs1IA=;
 b=Hb/Fd0sRDaWE8E1rnQ+j5AaLXCu166EPRt1dOPCyYaN/sx1Lmtq22C6huMmFWdGsc1ATbj0Cfzpn9ntan6FHk6OWaOiz+zcaEv7WaItBObhzFd9ke5mNtws8Ba1mdIo9EZX0eduq6dUUcbBAzbzVO0aUaHBxo4R5v/9kb10KFmI=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:12:39 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:12:39 +0000
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
Subject: [PATCH bpf-next v2 03/16] libbpf: Support getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v2 03/16] libbpf: Support getsockopt XDP_OPTIONS
Thread-Index: AQHU/4BMZ5CcDa4PE06kgMsjgdDWzw==
Date:   Tue, 30 Apr 2019 18:12:39 +0000
Message-ID: <20190430181215.15305-4-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c8b72f02-560f-40a1-4b3c-08d6cd976e46
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB5553843263D1870913679E7DD13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VyJEEQrplZYWXKNCfZnaa66ABHepcoD/VQBodes0wvu9qj7fpJIeoPbIlltVRMrKONW9i8yj13ya9AbwSFrct4+a1Z+YceNQg8W1FIhOCtiH7rUGUp6a5DwKUVHeFnIq1G+tY54I3bRiOQ1YZlm+wiiKApGXu6i2xGYD70du1N1yPBiuM2tEEiXaOY5H/Oe2vRuJxPRhgE8fbZ3Dz11TymtNNUTF1LSrmjGZwQCxVoS//QyjqyFym4ZLMhmg79XmiStoNCkm1PLJEDjoia5wPXaDFab/3usfGFiALDtDPEWASiKahBoTvQED1YI9iWXQjgkoWamJ2dWA4alu6hZQQFnqBmAA9l0dVefAVzGkX9bY6ku/1RpfVlDe8baZudvjwPD4xM/9valU+2yGHKReDU15xGcYZmpZEXBgwsYIhns=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b72f02-560f-40a1-4b3c-08d6cd976e46
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:12:39.6692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UXVlcnkgWERQX09QVElPTlMgaW4gbGliYnBmIHRvIGRldGVybWluZSBpZiB0aGUgemVyby1jb3B5
IG1vZGUgaXMgYWN0aXZlDQpvciBub3QuDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFu
c2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0
YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KLS0tDQogdG9vbHMvbGliL2JwZi94c2suYyB8IDExICsrKysrKysrKysrDQog
MSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL3Rvb2xzL2xp
Yi9icGYveHNrLmMgYi90b29scy9saWIvYnBmL3hzay5jDQppbmRleCA1NTdlZjhkMTI1MGQuLmE5
NWIwNmQxZjgxZCAxMDA2NDQNCi0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCisrKyBiL3Rvb2xz
L2xpYi9icGYveHNrLmMNCkBAIC02Nyw2ICs2Nyw3IEBAIHN0cnVjdCB4c2tfc29ja2V0IHsNCiAJ
aW50IHhza3NfbWFwX2ZkOw0KIAlfX3UzMiBxdWV1ZV9pZDsNCiAJY2hhciBpZm5hbWVbSUZOQU1T
SVpdOw0KKwlib29sIHpjOw0KIH07DQogDQogc3RydWN0IHhza19ubF9pbmZvIHsNCkBAIC01MjYs
NiArNTI3LDcgQEAgaW50IHhza19zb2NrZXRfX2NyZWF0ZShzdHJ1Y3QgeHNrX3NvY2tldCAqKnhz
a19wdHIsIGNvbnN0IGNoYXIgKmlmbmFtZSwNCiB7DQogCXN0cnVjdCBzb2NrYWRkcl94ZHAgc3hk
cCA9IHt9Ow0KIAlzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyBvZmY7DQorCXN0cnVjdCB4ZHBfb3B0
aW9ucyBvcHRzOw0KIAlzdHJ1Y3QgeHNrX3NvY2tldCAqeHNrOw0KIAlzb2NrbGVuX3Qgb3B0bGVu
Ow0KIAl2b2lkICptYXA7DQpAQCAtNjQzLDYgKzY0NSwxNSBAQCBpbnQgeHNrX3NvY2tldF9fY3Jl
YXRlKHN0cnVjdCB4c2tfc29ja2V0ICoqeHNrX3B0ciwgY29uc3QgY2hhciAqaWZuYW1lLA0KIAkJ
Z290byBvdXRfbW1hcF90eDsNCiAJfQ0KIA0KKwlvcHRsZW4gPSBzaXplb2Yob3B0cyk7DQorCWVy
ciA9IGdldHNvY2tvcHQoeHNrLT5mZCwgU09MX1hEUCwgWERQX09QVElPTlMsICZvcHRzLCAmb3B0
bGVuKTsNCisJaWYgKGVycikgew0KKwkJZXJyID0gLWVycm5vOw0KKwkJZ290byBvdXRfbW1hcF90
eDsNCisJfQ0KKw0KKwl4c2stPnpjID0gb3B0cy5mbGFncyAmIFhEUF9PUFRJT05TX0ZMQUdfWkVS
T0NPUFk7DQorDQogCWlmICghKHhzay0+Y29uZmlnLmxpYmJwZl9mbGFncyAmIFhTS19MSUJCUEZf
RkxBR1NfX0lOSElCSVRfUFJPR19MT0FEKSkgew0KIAkJZXJyID0geHNrX3NldHVwX3hkcF9wcm9n
KHhzayk7DQogCQlpZiAoZXJyKQ0KLS0gDQoyLjE5LjENCg0K
