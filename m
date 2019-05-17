Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6A721F0C
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfEQUUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:20:15 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729316AbfEQUUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hlax1JIcYGmzl4e85WKWhPLjbaq9prfUVqqTEc7qB9A=;
 b=ncxLOhg99DA3cpmSEx5xrwQt3/cdMQbeVRLS4wlwsnivSOR8du6/uMDO6MaEVvK1R2X2OWOKhlBV5c2xT7Eg4m4aV3V6lEbyYYTiCukFeq3LVn5bcG2j2nEz+tNyO7OB2qj3VXAPZwQSvzGaiMxNI3nhI8+kM5XSKFY1nA0K/AA=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:20:06 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:20:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/11] net/mlx5e: Fix possible modify header actions memory leak
Thread-Topic: [net 11/11] net/mlx5e: Fix possible modify header actions memory
 leak
Thread-Index: AQHVDO3qfmoJiGdwe0yq0qNW1g+fiA==
Date:   Fri, 17 May 2019 20:20:06 +0000
Message-ID: <20190517201910.32216-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b51beaec-f260-471b-de0b-08d6db050b5f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB6138BDA8B89CCABEF9E6EFB5BE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BnbdICGjyb0cvBDyCrKJWZ1Hdht3YWRVqQ5uUXpQ4mdPQaguSpyoWw/kHlCT0kNiktEM9ktR1doasgTly6yeqQQ4zTPqTMz7ZWanA/T92y/cJFU7BZDqOl3xjEhHvliYW8f+h4t/ac5FUTfJrPFQ/cxGgOtwxbe3C0FGwY2glr3NCXWGEoR/U0upOgcCx5ItfIlyexYgMn+h5PU+O1X6XKcuo3mK8DrK1pqZBSjhphvMqKkce+1SEOr3csdS8BDgSTStflt9MeWeexX/feLshiiFz9LiscGFnXR2nY+CskYsQt3R/GOKCeZX3IU39lr9YuKkvIEPg3yvppvT02lBv/WKfcyel7HYHLbT2mfFuiqeWtSExly20AOu+jO3TY6rbMhFNAmjHnXyXH8tnYgvT1zQLe//MyqsP58c32jxnT0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b51beaec-f260-471b-de0b-08d6db050b5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:20:06.1927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpUaGUgY2l0ZWQgY29t
bWl0IGNvdWxkIGRpc2FibGUgdGhlIG1vZGlmeSBoZWFkZXIgZmxhZywgYnV0IGRpZCBub3QgZnJl
ZQ0KdGhlIGFsbG9jYXRlZCBtZW1vcnkgZm9yIHRoZSBtb2RpZnkgaGVhZGVyIGFjdGlvbnMuIEZp
eCBpdC4NCg0KRml4ZXM6IDI3YzExYjZiODQ0Y2QgKCJuZXQvbWx4NWU6IERvIG5vdCByZXdyaXRl
IGZpZWxkcyB3aXRoIHRoZSBzYW1lIG1hdGNoIikNClNpZ25lZC1vZmYtYnk6IEVsaSBCcml0c3Rl
aW4gPGVsaWJyQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVs
bGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5v
eC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
dGMuYyB8IDUgKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fdGMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl90Yy5jDQppbmRleCA0NzIyYWM3MGYwYTkuLjMxY2QwMmYxMTQ5OSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KQEAgLTI1NjcsOCAr
MjU2NywxMCBAQCBzdGF0aWMgaW50IHBhcnNlX3RjX25pY19hY3Rpb25zKHN0cnVjdCBtbHg1ZV9w
cml2ICpwcml2LA0KIAkJLyogaW4gY2FzZSBhbGwgcGVkaXQgYWN0aW9ucyBhcmUgc2tpcHBlZCwg
cmVtb3ZlIHRoZSBNT0RfSERSDQogCQkgKiBmbGFnLg0KIAkJICovDQotCQlpZiAocGFyc2VfYXR0
ci0+bnVtX21vZF9oZHJfYWN0aW9ucyA9PSAwKQ0KKwkJaWYgKHBhcnNlX2F0dHItPm51bV9tb2Rf
aGRyX2FjdGlvbnMgPT0gMCkgew0KIAkJCWFjdGlvbiAmPSB+TUxYNV9GTE9XX0NPTlRFWFRfQUNU
SU9OX01PRF9IRFI7DQorCQkJa2ZyZWUocGFyc2VfYXR0ci0+bW9kX2hkcl9hY3Rpb25zKTsNCisJ
CX0NCiAJfQ0KIA0KIAlhdHRyLT5hY3Rpb24gPSBhY3Rpb247DQpAQCAtMzAwNSw2ICszMDA3LDcg
QEAgc3RhdGljIGludCBwYXJzZV90Y19mZGJfYWN0aW9ucyhzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJp
diwNCiAJCSAqLw0KIAkJaWYgKHBhcnNlX2F0dHItPm51bV9tb2RfaGRyX2FjdGlvbnMgPT0gMCkg
ew0KIAkJCWFjdGlvbiAmPSB+TUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX01PRF9IRFI7DQorCQkJ
a2ZyZWUocGFyc2VfYXR0ci0+bW9kX2hkcl9hY3Rpb25zKTsNCiAJCQlpZiAoISgoYWN0aW9uICYg
TUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX1ZMQU5fUE9QKSB8fA0KIAkJCSAgICAgIChhY3Rpb24g
JiBNTFg1X0ZMT1dfQ09OVEVYVF9BQ1RJT05fVkxBTl9QVVNIKSkpDQogCQkJCWF0dHItPnNwbGl0
X2NvdW50ID0gMDsNCi0tIA0KMi4yMS4wDQoNCg==
