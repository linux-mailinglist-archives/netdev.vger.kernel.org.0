Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603B310104
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfD3UkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:40:01 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:9176
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726723AbfD3UkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcmFB6yWH9ce1SGKtVOrHAmJ6O7uYmbzsB06kSIr028=;
 b=EnM6xaefHaH+Mb+eekMIjHRinmHFl4LUeYf0PSVIHT4OBCkyg6Vwyg98vHlKtAaAdtdLi4S2p/KlJwhGyZxGSrvlBFLUldp9pRPIKRp2MV6jKIPG58XZYK1VVwil0LmfHoJkymZRg8bXLKKzTQKCjOC1Brz123PMHFqCDCGkv4A=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:39:52 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:39:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5e: Replace TC VLAN pop with VLAN 0 rewrite
 in prio tag mode
Thread-Topic: [net-next 04/15] net/mlx5e: Replace TC VLAN pop with VLAN 0
 rewrite in prio tag mode
Thread-Index: AQHU/5TcSFiBkIs4cU62hHJhBPSTaw==
Date:   Tue, 30 Apr 2019 20:39:52 +0000
Message-ID: <20190430203926.19284-5-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f84bafdb-e727-464d-0bab-08d6cdabfee9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB6542353FC036512694568855BE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4aNJfqLBlmfiV1hSur3s80PK+clFoTBjYeNSZQzci0CnN3HJEl2YyOqFKmFlEA5dAZ7QXBpNHRdKUuDDkFM561jWmjz48FqTqJYidg4W4K1a3zbyZ7tsSa5Wjnt88b2ZYjEMyf+/TLOqWim7A+OjOTElMqTRrr3AJSeuGZip2DLOHtvCHSJCc6B02uGNpoBWk81MzALb/3xQETFolOEzU15gKBgpo5Yms4mBPgV3wxbq3b1WeEzGwW39yl/0dPG1iWV/0DVFxhwIt1FBpMjtsM5JoBxh5DTg2Ez4MnCHyJEx/PZ8YctXN5L3oPSeUcbpkengCDK+KrjuHTSqC5SGMkVwV2EV/ErwRa9W5RDdVxQ1aglxl6Uu9Ab1BLZ94HvtoX/Y7Yj/wWlBHSDHTeN0aPS9lh3Z5rT8C7ylbc1f7u0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84bafdb-e727-464d-0bab-08d6cdabfee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:39:52.4735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
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
