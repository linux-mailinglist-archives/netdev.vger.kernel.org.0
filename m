Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7AC39808
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbfFGVsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:48:04 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731464AbfFGVsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDlwl+p+p6XjVTBu6g1Ji2pkYGeGqnaj50gujKEgqho=;
 b=KLqjBLf/BVxSZ1RRVJu6tW51qNXqIQgIub2Ux4/zUpq8tb+qpiWEZQJaK541kHmacrhYwNUliqNOLqRnlGmOYVW5GfkcY3Mvial6cUC0tppelLcyX0p8FIls3rYWhY4k0e+VhHtHqJ38OZaBKOdQUbQXGwdb66s3HKxAcXvIUG0=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:42 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shay Agroskin <shayag@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/7] net/mlx5e: Replace reciprocal_scale in TX select queue
 function
Thread-Topic: [net 4/7] net/mlx5e: Replace reciprocal_scale in TX select queue
 function
Thread-Index: AQHVHXqi/6KKMZ28QE6yHsup4ZDjrA==
Date:   Fri, 7 Jun 2019 21:47:42 +0000
Message-ID: <20190607214716.16316-5-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c6ad1b8-9ce8-4f9e-ef76-08d6eb91c4de
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB6139C17FC6867F9194394230BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(14444005)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AZ9dk44iUOfZlT9rRdYVLoA3jnZTbGxKtIqq4wPwMjwjCnlkkzGnatMBzNmKL/cwBRgbn5ZqBxAA64wbctVF2WEwFwtmhJDfI+sP+cUtSwfCxsF2bcDYArq8yh4EjOMH04vvki6/LMlOQJL3045hK4fASOhC3ALDj8U72o/2AeLQS0HWYcIsHkyaCiyDdNmeF4+8clVHBI+3dXTloBV88vTdlXAkmZIkaroh8zEcyxP3SCZpLRySpqIDCST+czwTXI/s2umSgmTUGtAZySPduSigIlkRVczRps/gonKkDs+sQMk57e5e8BzyUNUn6bgHVPpuFTXkak+0vjApradUOk2XFyC7cYKvc8Epu3KAGBWZ54mpsAgcXGORp0P3ahedwGEfY4XX01JbR7O37AttAVRWspyQeSkWkMi5LqqUFpc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c6ad1b8-9ce8-4f9e-ef76-08d6eb91c4de
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:42.8761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2hheSBBZ3Jvc2tpbiA8c2hheWFnQG1lbGxhbm94LmNvbT4NCg0KVGhlIFRYIHF1ZXVl
IGluZGV4IHJldHVybmVkIGJ5IHRoZSBmYWxsYmFjayBmdW5jdGlvbiByYW5nZXMNCmJldHdlZW4g
WzAsTlVNIENIQU5ORUxTIC0gMV0gaWYgUW9TIGlzbid0IHNldCBhbmQNClswLCAoTlVNIENIQU5O
RUxTKSooTlVNIFRDcykgLTFdIG90aGVyd2lzZS4NCg0KT3VyIEhXIHVzZXMgZGlmZmVyZW50IFRD
IG1hcHBpbmcgdGhhbiB0aGUgZmFsbGJhY2sgZnVuY3Rpb24NCih3aGljaCBpcyBkZW5vdGVkIGFz
ICd1cCcsIHVzZXIgcHJpb3JpdHkpIHNvIHdlIG9ubHkgbmVlZCB0byBleHRyYWN0DQphIGNoYW5u
ZWwgbnVtYmVyIG91dCBvZiB0aGUgcmV0dXJuZWQgdmFsdWUuDQoNClNpbmNlIChOVU0gQ0hBTk5F
TFMpKihOVU0gVENzKSBpcyBhIHJlbGF0aXZlbHkgc21hbGwgbnVtYmVyLCB1c2luZw0KcmVjaXBy
b2NhbCBzY2FsZSBhbG1vc3QgYWx3YXlzIHJldHVybnMgemVyby4NCldlIGluc3RlYWQgYWNjZXNz
IHRoZSAndHhxMnNxJyB0YWJsZSB0byBleHRyYWN0IHRoZSBzcSAoYW5kIHdpdGggaXQgdGhlDQpj
aGFubmVsIG51bWJlcikgYXNzb2NpYXRlZCB3aXRoIHRoZSB0eCBxdWV1ZSwgdGh1cyBnZXR0aW5n
DQphIG1vcmUgZXZlbmx5IGRpc3RyaWJ1dGVkIGNoYW5uZWwgbnVtYmVyLg0KDQpQZXJmOg0KDQpS
eC9UeCBzaWRlIHdpdGggSW50ZWwoUikgWGVvbihSKSBTaWx2ZXIgNDEwOCBDUFUgQCAxLjgwR0h6
IGFuZCBDb25uZWN0WC01Lg0KVXNlZCAnaXBlcmYnIFVEUCB0cmFmZmljLCAxMCB0aHJlYWRzLCBh
bmQgcHJpb3JpdHkgNS4NCg0KQmVmb3JlOgkwLjU2Nk1wcHMNCkFmdGVyOgkgMi4zN01wcHMNCg0K
QXMgZXhwZWN0ZWQsIHJlbGVhc2luZyB0aGUgZXhpc3RpbmcgYm90dGxlbmVjayBvZiBzdGVlcmlu
ZyBhbGwgdHJhZmZpYw0KdG8gVFggcXVldWUgemVybyBzaWduaWZpY2FudGx5IGltcHJvdmVzIHRy
YW5zbWlzc2lvbiByYXRlcy4NCg0KRml4ZXM6IDdjY2RkMDg0MWIzMCAoIm5ldC9tbHg1ZTogRml4
IHNlbGVjdCBxdWV1ZSBjYWxsYmFjayIpDQpTaWduZWQtb2ZmLWJ5OiBTaGF5IEFncm9za2luIDxz
aGF5YWdAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1l
bGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
LmggICAgICB8ICAxICsNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fbWFpbi5jIHwgIDEgKw0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90eC5jICAgfCAxMiArKysrKystLS0tLS0NCiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuLmgNCmluZGV4IGFiMDI3ZjU3NzI1Yy4uY2M2Nzk3ZTI0NTcxIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmgNCisr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oDQpAQCAtMzg1
LDYgKzM4NSw3IEBAIHN0cnVjdCBtbHg1ZV90eHFzcSB7DQogCS8qIGNvbnRyb2wgcGF0aCAqLw0K
IAlzdHJ1Y3QgbWx4NV93cV9jdHJsICAgICAgICB3cV9jdHJsOw0KIAlzdHJ1Y3QgbWx4NWVfY2hh
bm5lbCAgICAgICpjaGFubmVsOw0KKwlpbnQgICAgICAgICAgICAgICAgICAgICAgICBjaF9peDsN
CiAJaW50ICAgICAgICAgICAgICAgICAgICAgICAgdHhxX2l4Ow0KIAl1MzIgICAgICAgICAgICAg
ICAgICAgICAgICByYXRlX2xpbWl0Ow0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QgICAgICAgICByZWNv
dmVyX3dvcms7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9tYWluLmMNCmluZGV4IGNkNDkwYWUzMzBkOC4uNTY0NjkyMjI3YzE2IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KQEAg
LTEwODIsNiArMTA4Miw3IEBAIHN0YXRpYyBpbnQgbWx4NWVfYWxsb2NfdHhxc3Eoc3RydWN0IG1s
eDVlX2NoYW5uZWwgKmMsDQogCXNxLT5jbG9jayAgICAgPSAmbWRldi0+Y2xvY2s7DQogCXNxLT5t
a2V5X2JlICAgPSBjLT5ta2V5X2JlOw0KIAlzcS0+Y2hhbm5lbCAgID0gYzsNCisJc3EtPmNoX2l4
ICAgICA9IGMtPml4Ow0KIAlzcS0+dHhxX2l4ICAgID0gdHhxX2l4Ow0KIAlzcS0+dWFyX21hcCAg
ID0gbWRldi0+bWx4NWVfcmVzLmJmcmVnLm1hcDsNCiAJc3EtPm1pbl9pbmxpbmVfbW9kZSA9IHBh
cmFtcy0+dHhfbWluX2lubGluZV9tb2RlOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3R4LmMNCmluZGV4IDE5NWE3ZDkwM2NlYy4uNzAxZTVkYzc1YmIw
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X3R4LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90
eC5jDQpAQCAtMTEzLDEzICsxMTMsMTMgQEAgc3RhdGljIGlubGluZSBpbnQgbWx4NWVfZ2V0X2Rz
Y3BfdXAoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIHN0cnVjdCBza19idWZmICpza2INCiB1MTYg
bWx4NWVfc2VsZWN0X3F1ZXVlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBza19idWZm
ICpza2IsDQogCQkgICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKnNiX2RldikNCiB7DQotCWludCBj
aGFubmVsX2l4ID0gbmV0ZGV2X3BpY2tfdHgoZGV2LCBza2IsIE5VTEwpOw0KKwlpbnQgdHhxX2l4
ID0gbmV0ZGV2X3BpY2tfdHgoZGV2LCBza2IsIE5VTEwpOw0KIAlzdHJ1Y3QgbWx4NWVfcHJpdiAq
cHJpdiA9IG5ldGRldl9wcml2KGRldik7DQogCXUxNiBudW1fY2hhbm5lbHM7DQogCWludCB1cCA9
IDA7DQogDQogCWlmICghbmV0ZGV2X2dldF9udW1fdGMoZGV2KSkNCi0JCXJldHVybiBjaGFubmVs
X2l4Ow0KKwkJcmV0dXJuIHR4cV9peDsNCiANCiAjaWZkZWYgQ09ORklHX01MWDVfQ09SRV9FTl9E
Q0INCiAJaWYgKHByaXYtPmRjYnhfZHAudHJ1c3Rfc3RhdGUgPT0gTUxYNV9RUFRTX1RSVVNUX0RT
Q1ApDQpAQCAtMTI5LDE0ICsxMjksMTQgQEAgdTE2IG1seDVlX3NlbGVjdF9xdWV1ZShzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAkJaWYgKHNrYl92bGFuX3Rh
Z19wcmVzZW50KHNrYikpDQogCQkJdXAgPSBza2Jfdmxhbl90YWdfZ2V0X3ByaW8oc2tiKTsNCiAN
Ci0JLyogY2hhbm5lbF9peCBjYW4gYmUgbGFyZ2VyIHRoYW4gbnVtX2NoYW5uZWxzIHNpbmNlDQor
CS8qIHR4cV9peCBjYW4gYmUgbGFyZ2VyIHRoYW4gbnVtX2NoYW5uZWxzIHNpbmNlDQogCSAqIGRl
di0+bnVtX3JlYWxfdHhfcXVldWVzID0gbnVtX2NoYW5uZWxzICogbnVtX3RjDQogCSAqLw0KIAlu
dW1fY2hhbm5lbHMgPSBwcml2LT5jaGFubmVscy5wYXJhbXMubnVtX2NoYW5uZWxzOw0KLQlpZiAo
Y2hhbm5lbF9peCA+PSBudW1fY2hhbm5lbHMpDQotCQljaGFubmVsX2l4ID0gcmVjaXByb2NhbF9z
Y2FsZShjaGFubmVsX2l4LCBudW1fY2hhbm5lbHMpOw0KKwlpZiAodHhxX2l4ID49IG51bV9jaGFu
bmVscykNCisJCXR4cV9peCA9IHByaXYtPnR4cTJzcVt0eHFfaXhdLT5jaF9peDsNCiANCi0JcmV0
dXJuIHByaXYtPmNoYW5uZWxfdGMydHhxW2NoYW5uZWxfaXhdW3VwXTsNCisJcmV0dXJuIHByaXYt
PmNoYW5uZWxfdGMydHhxW3R4cV9peF1bdXBdOw0KIH0NCiANCiBzdGF0aWMgaW5saW5lIGludCBt
bHg1ZV9za2JfbDJfaGVhZGVyX29mZnNldChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KLS0gDQoyLjIx
LjANCg0K
