Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2713C008
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbfFJXir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:47 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:22416
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390524AbfFJXiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6BGDuE3gp1NMtEuDaRXieL4loJT0eX3ND/Pb4Ioi7M=;
 b=aNZEcy+5cpH8iPjt8K6fV/l/xdA80ufqnHOVH3gSuO/hJfFjd9GkInS4J6nvAZMu0Y65E+rL+tyC/94dQWINq5JIm4//BI00nb7KOpyW30H7H7SRKdOCdNmMtzGGxlb9JGSgUK6clM2+XLp5iJhtegJF+knfz4Yp0m+tCdiAWyc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 09/16] net/mlx5: Move IRQ rmap creation to IRQ
 allocation phase
Thread-Topic: [PATCH mlx5-next 09/16] net/mlx5: Move IRQ rmap creation to IRQ
 allocation phase
Thread-Index: AQHVH+WbOT2GJNW4EEOGWRXxQUbxcQ==
Date:   Mon, 10 Jun 2019 23:38:28 +0000
Message-ID: <20190610233733.12155-10-saeedm@mellanox.com>
References: <20190610233733.12155-1-saeedm@mellanox.com>
In-Reply-To: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad13eeff-1381-4dce-b163-08d6edfcbd75
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB21660B9C1ECE2CBC9C8B3FF9BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(450100002)(85306007)(53936002)(6512007)(14454004)(50226002)(2616005)(186003)(256004)(81166006)(486006)(6436002)(11346002)(8676002)(8936002)(25786009)(476003)(14444005)(52116002)(446003)(2906002)(478600001)(99286004)(81156014)(4326008)(6486002)(107886003)(71200400001)(5660300002)(66446008)(64756008)(305945005)(66946007)(386003)(6506007)(7736002)(26005)(76176011)(71190400001)(102836004)(66476007)(86362001)(73956011)(66556008)(110136005)(6636002)(36756003)(54906003)(3846002)(6116002)(316002)(1076003)(66066001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UOKIlLbGp3XIhCbPIzhdVPxgtmhnAemAqKY4ICbG59PAZ8+7pitDbwOuL0sUyJaV4H7fmOyiPAKSfwxEBA/k/KoBkNRVOnPgYbj27bn1r7Iq2FIOiT7cGsQBQfqxmSAESMlH8T+HL2Su0J5uRuz+78e2gBisBhieAmBsMbA3Co3/Sgr4ZQPO6KRXWxkAtVOJoeRE8qXB6eOuMlxJKzkR52kImzxA3CEokfv78Jh00zOEgtHAiIhbCLjf6jjKBhILs6YIYReFNA3LnS+Ykuyfg/H5zJnQsLsDUYVdqn3kjxB99H4iKDdtH0s4Qg7T+FkBduHrJJpo9jngNSjtJjB04i9S4AO3j1X+EFjJX9XhPih8/03vo23baKaimIUAuQmtnhjt3oqBr7ZDy6kcsxnVZavDdrfe2GVSzQMI7DHNjD0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad13eeff-1381-4dce-b163-08d6edfcbd75
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:28.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXV2YWwgQXZuZXJ5IDx5dXZhbGF2QG1lbGxhbm94LmNvbT4NCg0KUm1hcCBjcmVhdGlv
bi9kZWxldGlvbiBpcyBwYXJ0IG9mIHRoZSBJUlEgbGlmZS1jeWNsZS4NCg0KU2lnbmVkLW9mZi1i
eTogWXV2YWwgQXZuZXJ5IDx5dXZhbGF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJh
diBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFt
ZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VxLmMgfCA4MiArKysrKysrKysrKysrKy0tLS0tLQ0KIDEgZmlsZSBj
aGFuZ2VkLCA1NyBpbnNlcnRpb25zKCspLCAyNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VxLmMNCmluZGV4IGNkZmEzNWVjMDJmYS4u
MWVhOTgzYzFlYzA1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VxLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lcS5jDQpAQCAtMjE2LDYgKzIxNiw0OSBAQCBzdGF0aWMgaW50IHJlcXVlc3RfaXJxcyhz
dHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBpbnQgbnZlYykNCiAJcmV0dXJuICBlcnI7DQogfQ0K
IA0KK3N0YXRpYyB2b2lkIGlycV9jbGVhcl9ybWFwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYp
DQorew0KKyNpZmRlZiBDT05GSUdfUkZTX0FDQ0VMDQorCXN0cnVjdCBtbHg1X2lycV90YWJsZSAq
aXJxX3RhYmxlID0gZGV2LT5wcml2LmlycV90YWJsZTsNCisNCisJZnJlZV9pcnFfY3B1X3JtYXAo
aXJxX3RhYmxlLT5ybWFwKTsNCisjZW5kaWYNCit9DQorDQorc3RhdGljIGludCBpcnFfc2V0X3Jt
YXAoc3RydWN0IG1seDVfY29yZV9kZXYgKm1kZXYpDQorew0KKwlpbnQgZXJyID0gMDsNCisjaWZk
ZWYgQ09ORklHX1JGU19BQ0NFTA0KKwlzdHJ1Y3QgbWx4NV9pcnFfdGFibGUgKmlycV90YWJsZSA9
IG1kZXYtPnByaXYuaXJxX3RhYmxlOw0KKwlpbnQgbnVtX2FmZmluaXR5X3ZlYzsNCisJaW50IHZl
Y2lkeDsNCisNCisJbnVtX2FmZmluaXR5X3ZlYyA9IG1seDVfaXJxX2dldF9udW1fY29tcChpcnFf
dGFibGUpOw0KKwlpcnFfdGFibGUtPnJtYXAgPSBhbGxvY19pcnFfY3B1X3JtYXAobnVtX2FmZmlu
aXR5X3ZlYyk7DQorCWlmICghaXJxX3RhYmxlLT5ybWFwKSB7DQorCQllcnIgPSAtRU5PTUVNOw0K
KwkJbWx4NV9jb3JlX2VycihtZGV2LCAiZmFpbGVkIHRvIGFsbG9jYXRlIGNwdV9ybWFwLiBlcnIg
JWQiLCBlcnIpOw0KKwkJZ290byBlcnJfb3V0Ow0KKwl9DQorDQorCXZlY2lkeCA9IE1MWDVfRVFf
VkVDX0NPTVBfQkFTRTsNCisJZm9yICg7IHZlY2lkeCA8IGlycV90YWJsZS0+bnZlYzsgdmVjaWR4
KyspIHsNCisJCWVyciA9IGlycV9jcHVfcm1hcF9hZGQoaXJxX3RhYmxlLT5ybWFwLA0KKwkJCQkg
ICAgICAgcGNpX2lycV92ZWN0b3IobWRldi0+cGRldiwgdmVjaWR4KSk7DQorCQlpZiAoZXJyKSB7
DQorCQkJbWx4NV9jb3JlX2VycihtZGV2LCAiaXJxX2NwdV9ybWFwX2FkZCBmYWlsZWQuIGVyciAl
ZCIsIGVycik7DQorCQkJZ290byBlcnJfaXJxX2NwdV9ybWFwX2FkZDsNCisJCX0NCisJfQ0KKwly
ZXR1cm4gMDsNCisNCitlcnJfaXJxX2NwdV9ybWFwX2FkZDoNCisJaXJxX2NsZWFyX3JtYXAobWRl
dik7DQorZXJyX291dDoNCisjZW5kaWYNCisJcmV0dXJuIGVycjsNCit9DQorDQogc3RhdGljIGlu
dCBtbHg1X2NtZF9kZXN0cm95X2VxKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHU4IGVxbikN
CiB7DQogCXUzMiBvdXRbTUxYNV9TVF9TWl9EVyhkZXN0cm95X2VxX291dCldID0gezB9Ow0KQEAg
LTg5MywxMiArOTM2LDYgQEAgc3RhdGljIHZvaWQgZGVzdHJveV9jb21wX2VxcyhzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2KQ0KIA0KIAljbGVhcl9jb21wX2lycXNfYWZmaW5pdHlfaGludHMoZGV2
KTsNCiANCi0jaWZkZWYgQ09ORklHX1JGU19BQ0NFTA0KLQlpZiAodGFibGUtPmlycV90YWJsZS0+
cm1hcCkgew0KLQkJZnJlZV9pcnFfY3B1X3JtYXAodGFibGUtPmlycV90YWJsZS0+cm1hcCk7DQot
CQl0YWJsZS0+aXJxX3RhYmxlLT5ybWFwID0gTlVMTDsNCi0JfQ0KLSNlbmRpZg0KIAlsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUoZXEsIG4sICZ0YWJsZS0+Y29tcF9lcXNfbGlzdCwgbGlzdCkgew0K
IAkJbGlzdF9kZWwoJmVxLT5saXN0KTsNCiAJCWlmIChkZXN0cm95X3VubWFwX2VxKGRldiwgJmVx
LT5jb3JlKSkNCkBAIC05MjEsMTEgKzk1OCw2IEBAIHN0YXRpYyBpbnQgY3JlYXRlX2NvbXBfZXFz
KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogCUlOSVRfTElTVF9IRUFEKCZ0YWJsZS0+Y29t
cF9lcXNfbGlzdCk7DQogCW5jb21wX2VxcyA9IHRhYmxlLT5udW1fY29tcF9lcXM7DQogCW5lbnQg
PSBNTFg1X0NPTVBfRVFfU0laRTsNCi0jaWZkZWYgQ09ORklHX1JGU19BQ0NFTA0KLQl0YWJsZS0+
aXJxX3RhYmxlLT5ybWFwID0gYWxsb2NfaXJxX2NwdV9ybWFwKG5jb21wX2Vxcyk7DQotCWlmICgh
dGFibGUtPmlycV90YWJsZS0+cm1hcCkNCi0JCXJldHVybiAtRU5PTUVNOw0KLSNlbmRpZg0KIAlm
b3IgKGkgPSAwOyBpIDwgbmNvbXBfZXFzOyBpKyspIHsNCiAJCWludCB2ZWNpZHggPSBpICsgTUxY
NV9FUV9WRUNfQ09NUF9CQVNFOw0KIAkJc3RydWN0IG1seDVfZXFfcGFyYW0gcGFyYW0gPSB7fTsN
CkBAIC05NDIsMTAgKzk3NCw2IEBAIHN0YXRpYyBpbnQgY3JlYXRlX2NvbXBfZXFzKHN0cnVjdCBt
bHg1X2NvcmVfZGV2ICpkZXYpDQogCQl0YXNrbGV0X2luaXQoJmVxLT50YXNrbGV0X2N0eC50YXNr
LCBtbHg1X2NxX3Rhc2tsZXRfY2IsDQogCQkJICAgICAodW5zaWduZWQgbG9uZykmZXEtPnRhc2ts
ZXRfY3R4KTsNCiANCi0jaWZkZWYgQ09ORklHX1JGU19BQ0NFTA0KLQkJaXJxX2NwdV9ybWFwX2Fk
ZCh0YWJsZS0+aXJxX3RhYmxlLT5ybWFwLA0KLQkJCQkgcGNpX2lycV92ZWN0b3IoZGV2LT5wZGV2
LCB2ZWNpZHgpKTsNCi0jZW5kaWYNCiAJCWVxLT5pcnFfbmIubm90aWZpZXJfY2FsbCA9IG1seDVf
ZXFfY29tcF9pbnQ7DQogCQlwYXJhbSA9IChzdHJ1Y3QgbWx4NV9lcV9wYXJhbSkgew0KIAkJCS5p
bmRleCA9IHZlY2lkeCwNCkBAIC0xMDM5LDE0ICsxMDY3LDcgQEAgdm9pZCBtbHg1X2NvcmVfZXFf
ZnJlZV9pcnFzKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogCWludCBpLCBtYXhfZXFzOw0K
IA0KIAljbGVhcl9jb21wX2lycXNfYWZmaW5pdHlfaGludHMoZGV2KTsNCi0NCi0jaWZkZWYgQ09O
RklHX1JGU19BQ0NFTA0KLQlpZiAodGFibGUtPmlycV90YWJsZS0+cm1hcCkgew0KLQkJZnJlZV9p
cnFfY3B1X3JtYXAodGFibGUtPmlycV90YWJsZS0+cm1hcCk7DQotCQl0YWJsZS0+aXJxX3RhYmxl
LT5ybWFwID0gTlVMTDsNCi0JfQ0KLSNlbmRpZg0KLQ0KKwlpcnFfY2xlYXJfcm1hcChkZXYpOw0K
IAltdXRleF9sb2NrKCZ0YWJsZS0+bG9jayk7IC8qIHN5bmMgd2l0aCBjcmVhdGUvZGVzdHJveV9h
c3luY19lcSAqLw0KIAltYXhfZXFzID0gdGFibGUtPm51bV9jb21wX2VxcyArIE1MWDVfRVFfVkVD
X0NPTVBfQkFTRTsNCiAJZm9yIChpID0gbWF4X2VxcyAtIDE7IGkgPj0gMDsgaS0tKSB7DQpAQCAt
MTA4NiwxMyArMTEwNywxOSBAQCBzdGF0aWMgaW50IGFsbG9jX2lycV92ZWN0b3JzKHN0cnVjdCBt
bHg1X2NvcmVfZGV2ICpkZXYpDQogDQogCXRhYmxlLT5udmVjID0gbnZlYzsNCiANCisJZXJyID0g
aXJxX3NldF9ybWFwKGRldik7DQorCWlmIChlcnIpDQorCQlnb3RvIGVycl9zZXRfcm1hcDsNCisN
CiAJZXJyID0gcmVxdWVzdF9pcnFzKGRldiwgbnZlYyk7DQogCWlmIChlcnIpDQotCQlnb3RvIGVy
cl9mcmVlX2lycXM7DQorCQlnb3RvIGVycl9yZXF1ZXN0X2lycXM7DQogDQogCXJldHVybiAwOw0K
IA0KLWVycl9mcmVlX2lycXM6DQorZXJyX3JlcXVlc3RfaXJxczoNCisJaXJxX2NsZWFyX3JtYXAo
ZGV2KTsNCitlcnJfc2V0X3JtYXA6DQogCXBjaV9mcmVlX2lycV92ZWN0b3JzKGRldi0+cGRldik7
DQogZXJyX2ZyZWVfaXJxX2luZm86DQogCWtmcmVlKHRhYmxlLT5pcnFfaW5mbyk7DQpAQCAtMTEw
NCw2ICsxMTMxLDExIEBAIHN0YXRpYyB2b2lkIGZyZWVfaXJxX3ZlY3RvcnMoc3RydWN0IG1seDVf
Y29yZV9kZXYgKmRldikNCiAJc3RydWN0IG1seDVfaXJxX3RhYmxlICp0YWJsZSA9IGRldi0+cHJp
di5pcnFfdGFibGU7DQogCWludCBpOw0KIA0KKwkvKiBmcmVlX2lycSByZXF1aXJlcyB0aGF0IGFm
ZmluaXR5IGFuZCBybWFwIHdpbGwgYmUgY2xlYXJlZA0KKwkgKiBiZWZvcmUgY2FsbGluZyBpdC4g
VGhpcyBpcyB3aHkgdGhlcmUgaXMgYXN5bW1ldHJ5IHdpdGggc2V0X3JtYXANCisJICogd2hpY2gg
c2hvdWxkIGJlIGNhbGxlZCBhZnRlciBhbGxvY19pcnEgYnV0IGJlZm9yZSByZXF1ZXN0X2lycS4N
CisJICovDQorCWlycV9jbGVhcl9ybWFwKGRldik7DQogCWZvciAoaSA9IDA7IGkgPCB0YWJsZS0+
bnZlYzsgaSsrKQ0KIAkJZnJlZV9pcnEocGNpX2lycV92ZWN0b3IoZGV2LT5wZGV2LCBpKSwNCiAJ
CQkgJm1seDVfaXJxX2dldChkZXYsIGkpLT5uaCk7DQotLSANCjIuMjEuMA0KDQo=
