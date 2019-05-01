Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9296E10ECB
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfEAVyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:54:55 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:10321
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726137AbfEAVyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qMPo+bS+AbaWnM7Zd+kCPuFvwO0XCkXRIOl+xJpTDk=;
 b=bEijZVwK1RyrN9F8dSKHkWnJEnfxkJGpii+ssa6kYojJfWsmbgvXoaxBCgg6yAC/Qy1TCjEEjFc1pDHwVJ+IxZ/oDVm94Zg8wLLNExCP8unCWM6t2GbteGnoYG0OhpzaTdZYHRn2cGE828DG9q1WLtei/FWbyWFwD8Xck80b5pM=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Wed, 1 May 2019 21:54:48 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:54:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 01/15] net/mlx5e: Take common TIR context settings into
 a function
Thread-Topic: [net-next V2 01/15] net/mlx5e: Take common TIR context settings
 into a function
Thread-Index: AQHVAGh+cJLFxUuZUEatp5nLjuQXEQ==
Date:   Wed, 1 May 2019 21:54:48 +0000
Message-ID: <20190501215433.24047-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 98c1141e-7425-4bd0-7068-08d6ce7fa132
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6044;
x-ms-traffictypediagnostic: DB8PR05MB6044:
x-microsoft-antispam-prvs: <DB8PR05MB60449B31919E127FCF7F8EBDBE3B0@DB8PR05MB6044.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:129;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(376002)(346002)(366004)(189003)(199004)(386003)(66946007)(66066001)(76176011)(50226002)(8936002)(25786009)(26005)(186003)(107886003)(3846002)(6116002)(6506007)(73956011)(102836004)(1076003)(6486002)(53936002)(6512007)(2906002)(66556008)(64756008)(66476007)(66446008)(68736007)(6916009)(71190400001)(71200400001)(7736002)(8676002)(476003)(14454004)(2616005)(52116002)(486006)(4326008)(11346002)(54906003)(6436002)(305945005)(316002)(86362001)(478600001)(99286004)(5660300002)(81156014)(81166006)(256004)(446003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6044;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QmzOCTNHgMHzhIeS57Kmi2SGxR3ql41vewMba2DiU1/4xcvSoGFRNFGS8FdNdaXDLxL/HcBYuO/9DTuEePpjpxtD+SYouSWA/7780oVxFRs4nHYj9YHm82jiB2wtu+SFq6FNq5ixuZVpt+zeGSLfhHEZ+Czm3duNUhTvCjQTFWKDHGlE0EZcYKbq+dB7XNGV+unFJ2tDcbbDUrRw1f2DMFCVx8uA5ZTWZw2dXG0u0qjpjyg2y1Zeo4yCzbEIs6kZ9k5i4A4Q3KCpNtGXmohLShp1lRwfLCAUzjvBlkGmAPseD6HMEkWbLxTydD6wZsWQ5DLFWepRI4FsZ74K5tqdE/MOa6oVO6e5HnEOlk4t95Ohe3VKG166AIyl6EzJsAudg+gCnx/k1cSV7nP+EvdNs0bFx8gNEjXlMVD5U1CSLfY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c1141e-7425-4bd0-7068-08d6ce7fa132
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:54:48.4442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KDQpNYW55IFRJUiBjb250
ZXh0IHNldHRpbmdzIGFyZSBjb21tb24gdG8gZGlmZmVyZW50IFRJUiB0eXBlcywNCnRha2UgdGhl
bSBpbnRvIGEgY29tbW9uIGZ1bmN0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBUYXJpcSBUb3VrYW4g
PHRhcmlxdEBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogQXlhIExldmluIDxheWFsQG1lbGxh
bm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3gu
Y29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5j
IHwgNDkgKysrKysrKystLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAyOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQppbmRleCAyMzZjY2U1OTE4MWQuLmQ3MTNhYjJlN2Ey
ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9tYWluLmMNCkBAIC0yNjc0LDIyICsyNjc0LDYgQEAgc3RhdGljIGludCBtbHg1ZV9tb2RpZnlf
dGlyc19scm8oc3RydWN0IG1seDVlX3ByaXYgKnByaXYpDQogCXJldHVybiBlcnI7DQogfQ0KIA0K
LXN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2lubmVyX2luZGlyX3Rpcl9jdHgoc3RydWN0IG1seDVl
X3ByaXYgKnByaXYsDQotCQkJCQkgICAgZW51bSBtbHg1ZV90cmFmZmljX3R5cGVzIHR0LA0KLQkJ
CQkJICAgIHUzMiAqdGlyYykNCi17DQotCU1MWDVfU0VUKHRpcmMsIHRpcmMsIHRyYW5zcG9ydF9k
b21haW4sIHByaXYtPm1kZXYtPm1seDVlX3Jlcy50ZC50ZG4pOw0KLQ0KLQltbHg1ZV9idWlsZF90
aXJfY3R4X2xybygmcHJpdi0+Y2hhbm5lbHMucGFyYW1zLCB0aXJjKTsNCi0NCi0JTUxYNV9TRVQo
dGlyYywgdGlyYywgZGlzcF90eXBlLCBNTFg1X1RJUkNfRElTUF9UWVBFX0lORElSRUNUKTsNCi0J
TUxYNV9TRVQodGlyYywgdGlyYywgaW5kaXJlY3RfdGFibGUsIHByaXYtPmluZGlyX3JxdC5ycXRu
KTsNCi0JTUxYNV9TRVQodGlyYywgdGlyYywgdHVubmVsZWRfb2ZmbG9hZF9lbiwgMHgxKTsNCi0N
Ci0JbWx4NWVfYnVpbGRfaW5kaXJfdGlyX2N0eF9oYXNoKCZwcml2LT5yc3NfcGFyYW1zLA0KLQkJ
CQkgICAgICAgJnRpcmNfZGVmYXVsdF9jb25maWdbdHRdLCB0aXJjLCB0cnVlKTsNCi19DQotDQog
c3RhdGljIGludCBtbHg1ZV9zZXRfbXR1KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICptZGV2LA0KIAkJ
CSBzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsIHUxNiBtdHUpDQogew0KQEAgLTMxMTAsMzIg
KzMwOTQsNDEgQEAgc3RhdGljIHZvaWQgbWx4NWVfY2xlYW51cF9uaWNfdHgoc3RydWN0IG1seDVl
X3ByaXYgKnByaXYpDQogCQltbHg1ZV9kZXN0cm95X3Rpcyhwcml2LT5tZGV2LCBwcml2LT50aXNu
W3RjXSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2luZGlyX3Rpcl9jdHgoc3Ry
dWN0IG1seDVlX3ByaXYgKnByaXYsDQotCQkJCSAgICAgIGVudW0gbWx4NWVfdHJhZmZpY190eXBl
cyB0dCwNCi0JCQkJICAgICAgdTMyICp0aXJjKQ0KK3N0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2lu
ZGlyX3Rpcl9jdHhfY29tbW9uKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KKwkJCQkJICAgICB1
MzIgcnF0biwgdTMyICp0aXJjKQ0KIHsNCiAJTUxYNV9TRVQodGlyYywgdGlyYywgdHJhbnNwb3J0
X2RvbWFpbiwgcHJpdi0+bWRldi0+bWx4NWVfcmVzLnRkLnRkbik7DQorCU1MWDVfU0VUKHRpcmMs
IHRpcmMsIGRpc3BfdHlwZSwgTUxYNV9USVJDX0RJU1BfVFlQRV9JTkRJUkVDVCk7DQorCU1MWDVf
U0VUKHRpcmMsIHRpcmMsIGluZGlyZWN0X3RhYmxlLCBycXRuKTsNCiANCiAJbWx4NWVfYnVpbGRf
dGlyX2N0eF9scm8oJnByaXYtPmNoYW5uZWxzLnBhcmFtcywgdGlyYyk7DQorfQ0KIA0KLQlNTFg1
X1NFVCh0aXJjLCB0aXJjLCBkaXNwX3R5cGUsIE1MWDVfVElSQ19ESVNQX1RZUEVfSU5ESVJFQ1Qp
Ow0KLQlNTFg1X1NFVCh0aXJjLCB0aXJjLCBpbmRpcmVjdF90YWJsZSwgcHJpdi0+aW5kaXJfcnF0
LnJxdG4pOw0KLQ0KK3N0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2luZGlyX3Rpcl9jdHgoc3RydWN0
IG1seDVlX3ByaXYgKnByaXYsDQorCQkJCSAgICAgIGVudW0gbWx4NWVfdHJhZmZpY190eXBlcyB0
dCwNCisJCQkJICAgICAgdTMyICp0aXJjKQ0KK3sNCisJbWx4NWVfYnVpbGRfaW5kaXJfdGlyX2N0
eF9jb21tb24ocHJpdiwgcHJpdi0+aW5kaXJfcnF0LnJxdG4sIHRpcmMpOw0KIAltbHg1ZV9idWls
ZF9pbmRpcl90aXJfY3R4X2hhc2goJnByaXYtPnJzc19wYXJhbXMsDQogCQkJCSAgICAgICAmdGly
Y19kZWZhdWx0X2NvbmZpZ1t0dF0sIHRpcmMsIGZhbHNlKTsNCiB9DQogDQogc3RhdGljIHZvaWQg
bWx4NWVfYnVpbGRfZGlyZWN0X3Rpcl9jdHgoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIHUzMiBy
cXRuLCB1MzIgKnRpcmMpDQogew0KLQlNTFg1X1NFVCh0aXJjLCB0aXJjLCB0cmFuc3BvcnRfZG9t
YWluLCBwcml2LT5tZGV2LT5tbHg1ZV9yZXMudGQudGRuKTsNCi0NCi0JbWx4NWVfYnVpbGRfdGly
X2N0eF9scm8oJnByaXYtPmNoYW5uZWxzLnBhcmFtcywgdGlyYyk7DQotDQotCU1MWDVfU0VUKHRp
cmMsIHRpcmMsIGRpc3BfdHlwZSwgTUxYNV9USVJDX0RJU1BfVFlQRV9JTkRJUkVDVCk7DQotCU1M
WDVfU0VUKHRpcmMsIHRpcmMsIGluZGlyZWN0X3RhYmxlLCBycXRuKTsNCisJbWx4NWVfYnVpbGRf
aW5kaXJfdGlyX2N0eF9jb21tb24ocHJpdiwgcnF0biwgdGlyYyk7DQogCU1MWDVfU0VUKHRpcmMs
IHRpcmMsIHJ4X2hhc2hfZm4sIE1MWDVfUlhfSEFTSF9GTl9JTlZFUlRFRF9YT1I4KTsNCiB9DQog
DQorc3RhdGljIHZvaWQgbWx4NWVfYnVpbGRfaW5uZXJfaW5kaXJfdGlyX2N0eChzdHJ1Y3QgbWx4
NWVfcHJpdiAqcHJpdiwNCisJCQkJCSAgICBlbnVtIG1seDVlX3RyYWZmaWNfdHlwZXMgdHQsDQor
CQkJCQkgICAgdTMyICp0aXJjKQ0KK3sNCisJbWx4NWVfYnVpbGRfaW5kaXJfdGlyX2N0eF9jb21t
b24ocHJpdiwgcHJpdi0+aW5kaXJfcnF0LnJxdG4sIHRpcmMpOw0KKwltbHg1ZV9idWlsZF9pbmRp
cl90aXJfY3R4X2hhc2goJnByaXYtPnJzc19wYXJhbXMsDQorCQkJCSAgICAgICAmdGlyY19kZWZh
dWx0X2NvbmZpZ1t0dF0sIHRpcmMsIHRydWUpOw0KKwlNTFg1X1NFVCh0aXJjLCB0aXJjLCB0dW5u
ZWxlZF9vZmZsb2FkX2VuLCAweDEpOw0KK30NCisNCiBpbnQgbWx4NWVfY3JlYXRlX2luZGlyZWN0
X3RpcnMoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIGJvb2wgaW5uZXJfdHRjKQ0KIHsNCiAJc3Ry
dWN0IG1seDVlX3RpciAqdGlyOw0KLS0gDQoyLjIwLjENCg0K
