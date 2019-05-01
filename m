Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4710ECC
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfEAVy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:54:59 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:32576
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726137AbfEAVy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcmFB6yWH9ce1SGKtVOrHAmJ6O7uYmbzsB06kSIr028=;
 b=WuioY7UTIAikOKOkV8v2HWbSDz5gX9m/55K4XspSeysL8dQSim4TJbpsaVF7jlk1K5/8au96lBNbwIVE/vHXoyA3Z7famG/T0ELxSZgA4H+v6EooOz7aeXfvtlJ3Pq9ZorW7zsn1AzOB+fNLf4GlCnij0LDas9wALwlwipOKsjk=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5868.eurprd05.prod.outlook.com (20.179.8.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 1 May 2019 21:54:53 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:54:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 04/15] net/mlx5e: Replace TC VLAN pop with VLAN 0
 rewrite in prio tag mode
Thread-Topic: [net-next V2 04/15] net/mlx5e: Replace TC VLAN pop with VLAN 0
 rewrite in prio tag mode
Thread-Index: AQHVAGiBdramHT9SOEOMG+tJ3XaLKw==
Date:   Wed, 1 May 2019 21:54:53 +0000
Message-ID: <20190501215433.24047-5-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83418069-03cb-4c5f-9737-08d6ce7fa41b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5868;
x-ms-traffictypediagnostic: DB8PR05MB5868:
x-microsoft-antispam-prvs: <DB8PR05MB58680E91438FCCBD49F68B09BE3B0@DB8PR05MB5868.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(5660300002)(256004)(86362001)(6512007)(66066001)(71190400001)(71200400001)(316002)(478600001)(446003)(11346002)(476003)(2616005)(186003)(1076003)(6486002)(26005)(486006)(6436002)(2906002)(102836004)(52116002)(6506007)(36756003)(6916009)(4326008)(76176011)(50226002)(107886003)(66446008)(68736007)(7736002)(66946007)(66476007)(66556008)(64756008)(53936002)(54906003)(305945005)(8676002)(81156014)(3846002)(81166006)(386003)(25786009)(73956011)(8936002)(99286004)(6116002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5868;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LEaTMrCtEZqH1bniOBUn+KT/NkZHB+filybnUpjaKVEUsXQo2hM1qEFXjZWOKWEWvjiDGMq7I8vm/z0nLu0xmgo8NHUjxiCTkv+QFFlEgE4fzov+3WVH3NrNPwYcMe9iRMtd9hI1CiWGsw5uFS6Zq4u7qFni0EsbA3ShyrtA4nxDGptB+7H/Kq5fKO6VvqDmm1udTX4ePz02jLfOfGId0hAatU2mC6Y48qtS5ys5HSTI3bq2s7mkB8gWR6S4eW4NzHuU1aTGQUBdWdXVkGJOXBBqlv++S0nnMjFsdX3aZrvLbI0skb7SuvHJYnaYw9iWIAzB6zg+iYkxRi1ygktp8NGNKX8hsIjDDriVMksTD+0tjJj1m9GXAOFsbV/ec7KCEuUvxzuCpstzYBeX4OCxRUzMC5eWk78hPWxDzwGmF8Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83418069-03cb-4c5f-9737-08d6ce7fa41b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:54:53.3176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5868
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpDdXJyZW50IENvbm5l
Y3RYIEhXIGlzIHVuYWJsZSB0byBwZXJmb3JtIFZMQU4gcG9wIGluIFRYIHBhdGggYW5kIFZMQU4N
CnB1c2ggb24gUlggcGF0aC4gVG8gd29ya2Fyb3VuZCB0aGF0IGxpbWl0YXRpb24gdW50YWdnZWQg
cGFja2V0cyBhcmUNCnRhZ2dlZCB3aXRoIFZMQU4gSUQgMHgwMDAgKHByaW9yaXR5IHRhZykgYW5k
IHBvcC9wdXNoIGFjdGlvbnMgYXJlDQpyZXBsYWNlZCBieSBWTEFOIHJlLXdyaXRlIGFjdGlvbnMg
KHdoaWNoIGFyZSBzdXBwb3J0ZWQgYnkgdGhlIEhXKS4NClJlcGxhY2UgVEMgVkxBTiBwb3AgYWN0
aW9uIHdpdGggYSBWTEFOIHByaW9yaXR5IHRhZyBoZWFkZXIgcmV3cml0ZS4NCg0KU2lnbmVkLW9m
Zi1ieTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IE96
IFNobG9tbyA8b3pzaEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVl
ZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX3RjLmMgICB8IDM2ICsrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hh
bmdlZCwgMzYgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KaW5kZXggNzI4OTFjYzdmMzJhLi5jNzlkYjU1ZjhhNzYg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
dGMuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3Rj
LmMNCkBAIC0yNDM2LDYgKzI0MzYsMzAgQEAgc3RhdGljIGludCBhZGRfdmxhbl9yZXdyaXRlX2Fj
dGlvbihzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwgaW50IG5hbWVzcGFjZSwNCiAJcmV0dXJuIGVy
cjsNCiB9DQogDQorc3RhdGljIGludA0KK2FkZF92bGFuX3ByaW9fdGFnX3Jld3JpdGVfYWN0aW9u
KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KKwkJCQkgc3RydWN0IG1seDVlX3RjX2Zsb3dfcGFy
c2VfYXR0ciAqcGFyc2VfYXR0ciwNCisJCQkJIHN0cnVjdCBwZWRpdF9oZWFkZXJzX2FjdGlvbiAq
aGRycywNCisJCQkJIHUzMiAqYWN0aW9uLCBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2sp
DQorew0KKwljb25zdCBzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgcHJpb190YWdfYWN0ID0gew0K
KwkJLnZsYW4udmlkID0gMCwNCisJCS52bGFuLnByaW8gPQ0KKwkJCU1MWDVfR0VUKGZ0ZV9tYXRj
aF9zZXRfbHlyXzJfNCwNCisJCQkJIGdldF9tYXRjaF9oZWFkZXJzX3ZhbHVlKCphY3Rpb24sDQor
CQkJCQkJCSAmcGFyc2VfYXR0ci0+c3BlYyksDQorCQkJCSBmaXJzdF9wcmlvKSAmDQorCQkJTUxY
NV9HRVQoZnRlX21hdGNoX3NldF9seXJfMl80LA0KKwkJCQkgZ2V0X21hdGNoX2hlYWRlcnNfY3Jp
dGVyaWEoKmFjdGlvbiwNCisJCQkJCQkJICAgICZwYXJzZV9hdHRyLT5zcGVjKSwNCisJCQkJIGZp
cnN0X3ByaW8pLA0KKwl9Ow0KKw0KKwlyZXR1cm4gYWRkX3ZsYW5fcmV3cml0ZV9hY3Rpb24ocHJp
diwgTUxYNV9GTE9XX05BTUVTUEFDRV9GREIsDQorCQkJCSAgICAgICAmcHJpb190YWdfYWN0LCBw
YXJzZV9hdHRyLCBoZHJzLCBhY3Rpb24sDQorCQkJCSAgICAgICBleHRhY2spOw0KK30NCisNCiBz
dGF0aWMgaW50IHBhcnNlX3RjX25pY19hY3Rpb25zKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0K
IAkJCQlzdHJ1Y3QgZmxvd19hY3Rpb24gKmZsb3dfYWN0aW9uLA0KIAkJCQlzdHJ1Y3QgbWx4NWVf
dGNfZmxvd19wYXJzZV9hdHRyICpwYXJzZV9hdHRyLA0KQEAgLTI5NDcsNiArMjk3MSwxOCBAQCBz
dGF0aWMgaW50IHBhcnNlX3RjX2ZkYl9hY3Rpb25zKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0K
IAkJfQ0KIAl9DQogDQorCWlmIChNTFg1X0NBUF9HRU4oZXN3LT5kZXYsIHByaW9fdGFnX3JlcXVp
cmVkKSAmJg0KKwkgICAgYWN0aW9uICYgTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX1ZMQU5fUE9Q
KSB7DQorCQkvKiBGb3IgcHJpbyB0YWcgbW9kZSwgcmVwbGFjZSB2bGFuIHBvcCB3aXRoIHJld3Jp
dGUgdmxhbiBwcmlvDQorCQkgKiB0YWcgcmV3cml0ZS4NCisJCSAqLw0KKwkJYWN0aW9uICY9IH5N
TFg1X0ZMT1dfQ09OVEVYVF9BQ1RJT05fVkxBTl9QT1A7DQorCQllcnIgPSBhZGRfdmxhbl9wcmlv
X3RhZ19yZXdyaXRlX2FjdGlvbihwcml2LCBwYXJzZV9hdHRyLCBoZHJzLA0KKwkJCQkJCSAgICAg
ICAmYWN0aW9uLCBleHRhY2spOw0KKwkJaWYgKGVycikNCisJCQlyZXR1cm4gZXJyOw0KKwl9DQor
DQogCWlmIChoZHJzW1RDQV9QRURJVF9LRVlfRVhfQ01EX1NFVF0ucGVkaXRzIHx8DQogCSAgICBo
ZHJzW1RDQV9QRURJVF9LRVlfRVhfQ01EX0FERF0ucGVkaXRzKSB7DQogCQllcnIgPSBhbGxvY190
Y19wZWRpdF9hY3Rpb24ocHJpdiwgTUxYNV9GTE9XX05BTUVTUEFDRV9GREIsDQotLSANCjIuMjAu
MQ0KDQo=
