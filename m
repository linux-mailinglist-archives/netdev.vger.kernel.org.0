Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AE921F0A
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfEQUUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:20:10 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729316AbfEQUUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0N6skdR2+tBu9R0FMCn9myDtv6DrRkE7xD76mGk+1cU=;
 b=ShW4Lp2AwFA0Fi8KmMWj/uP8BSrsmaQghnKN4heDgPX3ReNywIAswgBe/3n/p5qHnGi5RRlY8QsDd6gn3SLWIzz7vnbOPqseniGPWOPkQpgOrP0Kg+qI7visVjujnGHEiwXYJ7NYz1Y3ia6+CE8zhmK+C6pbPydUQ7JWRge8ay4=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:58 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/11] net/mlx5e: Additional check for flow destination
 comparison
Thread-Topic: [net 09/11] net/mlx5e: Additional check for flow destination
 comparison
Thread-Index: AQHVDO3mefw0DZelkEmKVKci8mXvqA==
Date:   Fri, 17 May 2019 20:19:58 +0000
Message-ID: <20190517201910.32216-10-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cb9c83a-b420-4f89-3f3f-08d6db05086c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB613894B3D164E1A9EB65EDEEBE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uinpu2xd02KTnkshTXjzWMTG16Ymi+BeS9hXXZz2yGN+qfO0UkGSY5N4td2AbUR0zHkOjC9XNpJLO4swIlXfTQJ3nKl4Zjw5bV4yGvZsTIwNpJbQsuXgw9GTtdXLyei/D14EnSeHbfvO9q8Hene2AsOA+g5UuXcyN3LOc0P5a7h552aaQ5JyYDyvTHQ713T4K+4f1yWIXMLvKXtNr8j/TJECR4v726IR0rt4/LOTln4onTi+iSQoU3HA9E3aUegs19mcNDD1aTDcul5Eky1f8JOrigSyAiYRbBwsNDi6x1/BmnbS/7Uh/QXHdMVw47aIMahsc46VHVRETC3pWfKPjiMlCnf9DrWuYt6RxciuqUi7ZfwaqeKWXwRHwlqd5okI92S/Iz9JaoKbOzb5/2QFso/DtVnIE9Ak9PJHEgvUcWU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb9c83a-b420-4f89-3f3f-08d6db05086c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:58.7891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG15dHJvIExpbmtpbiA8ZG1pdHJvbGluQG1lbGxhbm94LmNvbT4NCg0KRmxvdyBkZXN0
aW5hdGlvbiBjb21wYXJpc29uIGhhcyBhbiBpbmFjY3VyYWN5OiBjb2RlIHNlZSBubw0KZGlmZmVy
ZW5jZSBiZXR3ZWVuIHNhbWUgdmYgcG9ydHMsIHdoaWNoIGJlbG9uZyB0byBkaWZmZXJlbnQgcGZz
Lg0KDQpFeGFtcGxlOiBJZiBzdGFydCBwaW5nIGZyb20gVkYwIChQRjEpIHRvIFZGMSAoUEYxKSBh
bmQgbWlycm9yDQphbGwgdHJhZmZpYyB0byBWRjAgKFBGMiksIGljbXAgcmVwbHkgdG8gVkYwIChQ
RjEpIGFuZCBtaXJyb3JlZA0KZmxvdyB0byBWRjAgKFBGMikgd291bGQgYmUgZGV0ZXJtaW5lZCBh
cyBzYW1lIGRlc3RpbmF0aW9uLiBJdCBsZWFkDQp0byBjcmVhdGluZyBmbG93IGhhbmRsZXIgd2l0
aCBydWxlIG5vZGVzLCB3aGljaCBub3QgYWRkZWQgdG8gbm9kZQ0KdHJlZS4gV2hlbiBsYXRlciBk
cml2ZXIgdHJ5IHRvIGRlbGV0ZSB0aGlzIGZsb3cgcnVsZXMgd2UgZ290DQprZXJuZWwgY3Jhc2gu
DQoNCkFkZCBjb21wYXJpc29uIG9mIHZoY2FfaWQgZmllbGQgdG8gYXZvaWQgdGhpcy4NCg0KRml4
ZXM6IDEyMjhlOTEyYzkzNCAoIm5ldC9tbHg1OiBDb25zaWRlciBlbmNhcHN1bGF0aW9uIHByb3Bl
cnRpZXMgd2hlbiBjb21wYXJpbmcgZGVzdGluYXRpb25zIikNClNpZ25lZC1vZmYtYnk6IERteXRy
byBMaW5raW4gPGRtaXRyb2xpbkBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogUm9pIERheWFu
IDxyb2lkQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBWbGFkIEJ1c2xvdiA8dmxhZGJ1QG1l
bGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Zz
X2NvcmUuYyB8IDIgKysNCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYw0KaW5k
ZXggZmI1YjYxNzI3ZWU3Li5kN2NhN2U4MmE4MzIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5jDQorKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5jDQpAQCAtMTM4MCw2ICsxMzgwLDgg
QEAgc3RhdGljIGJvb2wgbWx4NV9mbG93X2Rlc3RzX2NtcChzdHJ1Y3QgbWx4NV9mbG93X2Rlc3Rp
bmF0aW9uICpkMSwNCiAJCWlmICgoZDEtPnR5cGUgPT0gTUxYNV9GTE9XX0RFU1RJTkFUSU9OX1RZ
UEVfVlBPUlQgJiYNCiAJCSAgICAgZDEtPnZwb3J0Lm51bSA9PSBkMi0+dnBvcnQubnVtICYmDQog
CQkgICAgIGQxLT52cG9ydC5mbGFncyA9PSBkMi0+dnBvcnQuZmxhZ3MgJiYNCisJCSAgICAgKChk
MS0+dnBvcnQuZmxhZ3MgJiBNTFg1X0ZMT1dfREVTVF9WUE9SVF9WSENBX0lEKSA/DQorCQkgICAg
ICAoZDEtPnZwb3J0LnZoY2FfaWQgPT0gZDItPnZwb3J0LnZoY2FfaWQpIDogdHJ1ZSkgJiYNCiAJ
CSAgICAgKChkMS0+dnBvcnQuZmxhZ3MgJiBNTFg1X0ZMT1dfREVTVF9WUE9SVF9SRUZPUk1BVF9J
RCkgPw0KIAkJICAgICAgKGQxLT52cG9ydC5yZWZvcm1hdF9pZCA9PSBkMi0+dnBvcnQucmVmb3Jt
YXRfaWQpIDogdHJ1ZSkpIHx8DQogCQkgICAgKGQxLT50eXBlID09IE1MWDVfRkxPV19ERVNUSU5B
VElPTl9UWVBFX0ZMT1dfVEFCTEUgJiYNCi0tIA0KMi4yMS4wDQoNCg==
