Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718B442BDE
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfFLQOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:14:22 -0400
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:9607
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727126AbfFLQOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0UG5MivXE2CJVVos6FzuiRWhJ8UxBcWPuhuHFcAqU8=;
 b=Y/HOK0vdY/cJyQsOtmvJLQJc2xMXRwRIforv5L7zQ+/HdE/xbeYQfE2Z4/6wUEx3aniVgxHDu135QV3WiMeIpxfxKL13l5InRlBBGKjigDB8laoMAdOEO+h7EUlbyedfkoceq1HWzJPKmcqiAWIk6lai1+mT7PlVO0gEhLQmvPQ=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6344.eurprd05.prod.outlook.com (20.179.5.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 12 Jun 2019 16:14:18 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 16:14:18 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next] net: Don't uninstall an XDP program when none is
 installed
Thread-Topic: [PATCH bpf-next] net: Don't uninstall an XDP program when none
 is installed
Thread-Index: AQHVITnjNkqLzd5XB0OcDX35ut8GrA==
Date:   Wed, 12 Jun 2019 16:14:18 +0000
Message-ID: <20190612161405.24064-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0335.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::35) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 600e4692-07a0-46fb-166d-08d6ef51057f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6344;
x-ms-traffictypediagnostic: AM6PR05MB6344:
x-microsoft-antispam-prvs: <AM6PR05MB63446B33EC6C9C778D08C523D1EC0@AM6PR05MB6344.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(39860400002)(136003)(376002)(189003)(199004)(53936002)(7416002)(54906003)(110136005)(6116002)(68736007)(50226002)(5660300002)(316002)(256004)(5024004)(71200400001)(3846002)(66066001)(71190400001)(1076003)(6512007)(2906002)(81156014)(81166006)(8936002)(8676002)(478600001)(305945005)(7736002)(66946007)(6436002)(66476007)(25786009)(86362001)(4326008)(66556008)(486006)(14454004)(6486002)(73956011)(64756008)(2616005)(476003)(52116002)(26005)(6506007)(36756003)(386003)(99286004)(66446008)(186003)(107886003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6344;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jo8RiJYnen3kj5gM2mZ0csTTGHjq9Y4lMxaqCRN55FH5zh2h/LjOJq5ZdAALHcxFGitjgjdvOau06FtHI8NYgjo1bw5D00oPrqp24Ja6Vr4iz/kZ5pTu35rmOZhDU6SXVlkTC1g1iYQQmc1yCiLpQn5OewmgudAy/60r+0QApk7FLwBzNfqWILuyjL6P10eJZZIxyX0IO4F6v+7Zcvnlkp/YuiI5DHWfPkc7arx7SEGiEubZ0lYZ1wMy02zhg2g/JxPyYntiQ6zw2MekcOAZGop9SuUQiosCV7jxtb+NA5r2qjs0yr8M5MGRJiXICWMxJbBA9l09s+LTuNbuVJuNSV6NqlwlFPRF98D271L4ZOi+vTKvWPfbi/z1sdALDL7r3abiV1PWx6yVijFKSO1qupHF2tqCDI8ITCc1dlafZKY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D11AFBE9FBF7040958FA3BCEAB2ACB7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600e4692-07a0-46fb-166d-08d6ef51057f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 16:14:18.6676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6344
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZGV2X2NoYW5nZV94ZHBfZmQgZG9lc24ndCBwZXJmb3JtIGFueSBjaGVja3MgaW4gY2FzZSBpdCB1
bmluc3RhbGxzIGFuDQpYRFAgcHJvZ3JhbS4gSXQgbWVhbnMgdGhhdCB0aGUgZHJpdmVyJ3MgbmRv
X2JwZiBjYW4gYmUgY2FsbGVkIHdpdGgNClhEUF9TRVRVUF9QUk9HIGFza2luZyB0byBzZXQgaXQg
dG8gTlVMTCBldmVuIGlmIGl0J3MgYWxyZWFkeSBOVUxMLiBUaGlzDQpjYXNlIGhhcHBlbnMgaWYg
dGhlIHVzZXIgcnVucyBgaXAgbGluayBzZXQgZXRoMCB4ZHAgb2ZmYCB3aGVuIHRoZXJlIGlzDQpu
byBYRFAgcHJvZ3JhbSBhdHRhY2hlZC4NCg0KVGhlIGRyaXZlcnMgdHlwaWNhbGx5IHBlcmZvcm0g
c29tZSBoZWF2eSBvcGVyYXRpb25zIG9uIFhEUF9TRVRVUF9QUk9HLA0Kc28gdGhleSBhbGwgaGF2
ZSB0byBoYW5kbGUgdGhpcyBjYXNlIGludGVybmFsbHkgdG8gcmV0dXJuIGVhcmx5IGlmIGl0DQpo
YXBwZW5zLiBUaGlzIHBhdGNoIHB1dHMgdGhpcyBjaGVjayBpbnRvIHRoZSBrZXJuZWwgY29kZSwg
c28gdGhhdCBhbGwNCmRyaXZlcnMgd2lsbCBiZW5lZml0IGZyb20gaXQuDQoNClNpZ25lZC1vZmYt
Ynk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQotLS0NCkJqw7Zy
biwgcGxlYXNlIHRha2UgYSBsb29rIGF0IHRoaXMsIFNhZWVkIHRvbGQgbWUgeW91IHdlcmUgZG9p
bmcNCnNvbWV0aGluZyByZWxhdGVkLCBidXQgSSBjb3VsZG4ndCBmaW5kIGl0LiBJZiB0aGlzIGZp
eCBpcyBhbHJlYWR5DQpjb3ZlcmVkIGJ5IHlvdXIgd29yaywgcGxlYXNlIHRlbGwgYWJvdXQgdGhh
dC4NCg0KIG5ldC9jb3JlL2Rldi5jIHwgMyArKysNCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspDQoNCmRpZmYgLS1naXQgYS9uZXQvY29yZS9kZXYuYyBiL25ldC9jb3JlL2Rldi5jDQpp
bmRleCA2NmY3NTA4ODI1YmQuLjY4YjNlMzMyMGNlYiAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL2Rl
di5jDQorKysgYi9uZXQvY29yZS9kZXYuYw0KQEAgLTgwODksNiArODA4OSw5IEBAIGludCBkZXZf
Y2hhbmdlX3hkcF9mZChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgbmV0bGlua19leHRf
YWNrICpleHRhY2ssDQogCQkJYnBmX3Byb2dfcHV0KHByb2cpOw0KIAkJCXJldHVybiAtRUlOVkFM
Ow0KIAkJfQ0KKwl9IGVsc2Ugew0KKwkJaWYgKCFfX2Rldl94ZHBfcXVlcnkoZGV2LCBicGZfb3As
IHF1ZXJ5KSkNCisJCQlyZXR1cm4gMDsNCiAJfQ0KIA0KIAllcnIgPSBkZXZfeGRwX2luc3RhbGwo
ZGV2LCBicGZfb3AsIGV4dGFjaywgZmxhZ3MsIHByb2cpOw0KLS0gDQoyLjE5LjENCg0K
