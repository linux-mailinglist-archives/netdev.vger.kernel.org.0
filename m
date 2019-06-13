Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61C44D9F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbfFMUjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:39:51 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:2635
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729695AbfFMUju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 16:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPix+JzSy7Hf2WkcMmTQxDTI6h6hZ8c6gmxatd348fU=;
 b=LoHfw4IpbYDSlhg4yN64Aqh4uZnAPXiirXcVIkJGC6vXeiBWEF3kKstk0xcng4I6RwPHG/MxF1TMBsmsMSEW2dGy+pkC/QsCEgYAmjcLhTBX7taP9aZm86fLPoctAPpeV68ohQbCVK6IhLerM2PJj/qav0TEGRIv0X0NDDiPras=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2629.eurprd05.prod.outlook.com (10.172.225.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Thu, 13 Jun 2019 20:39:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 20:39:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 07/15] net/mlx5: Control CR-space access by different
 PFs
Thread-Topic: [net-next v2 07/15] net/mlx5: Control CR-space access by
 different PFs
Thread-Index: AQHVIigYMuRx0lUSPE2f5wuWsYPJ9Q==
Date:   Thu, 13 Jun 2019 20:39:27 +0000
Message-ID: <20190613203825.31049-8-saeedm@mellanox.com>
References: <20190613203825.31049-1-saeedm@mellanox.com>
In-Reply-To: <20190613203825.31049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14cff9fd-3720-4173-b052-08d6f03f3a86
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2629;
x-ms-traffictypediagnostic: DB6PR0501MB2629:
x-microsoft-antispam-prvs: <DB6PR0501MB26299E358E59BF41DD90E318BEEF0@DB6PR0501MB2629.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(8676002)(6916009)(81156014)(81166006)(2616005)(316002)(11346002)(25786009)(4326008)(6512007)(86362001)(476003)(486006)(8936002)(6436002)(446003)(50226002)(6486002)(66066001)(36756003)(26005)(305945005)(7736002)(186003)(73956011)(66946007)(64756008)(66446008)(66556008)(66476007)(53936002)(6116002)(256004)(14444005)(3846002)(1076003)(71190400001)(71200400001)(2906002)(478600001)(99286004)(52116002)(14454004)(102836004)(54906003)(76176011)(5660300002)(6506007)(107886003)(386003)(68736007)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2629;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YB0xiRsfhow81tvvJMMBlz/Xv1eo4KH23tht+KcTiuz/tB7+UP2W80YdPNEsaAs9ya33ZQd+s1gyCssMZySrHtsMt9/4KLzRd0EyDMnNwUX7c0Tu02ZrCpVjO+Z+G4HN7WfnpLjAs3PBybPCGbiUdNsU1bIQb+JMCKNfkyoSFoCjgCoo35Ak7Bly2WEoE76pdAEMhuHXF6FvIskwTbmAoUAd0E5cT3AAUV37Iwoaig5ak+UIw1I+emVgQC9ob7sM1YBqIEwr4iZ0UgvTmrtyCtoN1H5c9ImTiAu5SMr6GAaXr/DEXz8zkC6MRphb5Ec6PhQwSJDXUSqtK3f2S0jiYwZs1rCHuxEOC1x6US2YHagIYDLVRuCFinyjjy9TT3lFWouEo1O4uNceqL3qqdqiWpx7AuMNKkSAdzMpWUm0Nlg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14cff9fd-3720-4173-b052-08d6f03f3a86
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 20:39:27.8828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2629
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmVyYXMgRGFvdWQgPGZlcmFzZGFAbWVsbGFub3guY29tPg0KDQpTaW5jZSB0aGUgRlcg
Y2FuIGJlIHNoYXJlZCBiZXR3ZWVuIGRpZmZlcmVudCBQRnMvVkZzIGl0IGlzIGNvbW1vbg0KdGhh
dCBtb3JlIHRoYW4gb25lIGhlYWx0aCBwb2xsIHdpbGwgZGV0ZWN0ZWQgYSBmYWlsdXJlLCB0aGlz
IGNhbg0KbGVhZCB0byBtdWx0aXBsZSByZXNldHMgd2hpY2ggYXJlIHVubmVlZGVkLg0KDQpUaGUg
c29sdXRpb24gaXMgdG8gdXNlIGEgRlcgbG9ja2luZyBtZWNoYW5pc20gdXNpbmcgc2VtYXBob3Jl
IHNwYWNlDQp0byBwcm92aWRlIGEgd2F5IHRvIGFsbG93IG9ubHkgb25lIGRldmljZSB0byBjb2xs
ZWN0IHRoZSBjci1kdW1wIGFuZA0KdG8gaXNzdWUgYSBzdy1yZXNldC4NCg0KU2lnbmVkLW9mZi1i
eTogRmVyYXMgRGFvdWQgPGZlcmFzZGFAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2Fl
ZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiAuLi4vZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmMgfCA0MCArKysrKysrKysrKysrKysrLS0tDQog
Li4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvcGNpX3ZzYy5oIHwgIDggKysrKw0K
IC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWx4NV9jb3JlLmggICB8ICA0ICsrDQog
MyBmaWxlcyBjaGFuZ2VkLCA0NyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lf
dnNjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL3BjaV92
c2MuYw0KaW5kZXggYTI3YjAxMTliM2Q2Li42Yjc3NGUwYzI3NjYgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL3BjaV92c2MuYw0KKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmMNCkBA
IC0yNCwxMSArMjQsNiBAQA0KIAlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKChkZXYpLT5wZGV2LCAo
ZGV2KS0+dnNjX2FkZHIgKyAob2Zmc2V0KSwgKHZhbCkpDQogI2RlZmluZSBWU0NfTUFYX1JFVFJJ
RVMgMjA0OA0KIA0KLWVudW0gbWx4NV92c2Nfc3RhdGUgew0KLQlNTFg1X1ZTQ19VTkxPQ0ssDQot
CU1MWDVfVlNDX0xPQ0ssDQotfTsNCi0NCiBlbnVtIHsNCiAJVlNDX0NUUkxfT0ZGU0VUID0gMHg0
LA0KIAlWU0NfQ09VTlRFUl9PRkZTRVQgPSAweDgsDQpAQCAtMjg0LDMgKzI3OSwzOCBAQCBpbnQg
bWx4NV92c2NfZ3dfcmVhZF9ibG9ja19mYXN0KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHUz
MiAqZGF0YSwNCiAJfQ0KIAlyZXR1cm4gbGVuZ3RoOw0KIH0NCisNCitpbnQgbWx4NV92c2Nfc2Vt
X3NldF9zcGFjZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB1MTYgc3BhY2UsDQorCQkJICAg
ZW51bSBtbHg1X3ZzY19zdGF0ZSBzdGF0ZSkNCit7DQorCXUzMiBkYXRhLCBpZCA9IDA7DQorCWlu
dCByZXQ7DQorDQorCXJldCA9IG1seDVfdnNjX2d3X3NldF9zcGFjZShkZXYsIE1MWDVfU0VNQVBI
T1JFX1NQQUNFX0RPTUFJTiwgTlVMTCk7DQorCWlmIChyZXQpIHsNCisJCW1seDVfY29yZV93YXJu
KGRldiwgIkZhaWxlZCB0byBzZXQgZ3cgc3BhY2UgJWRcbiIsIHJldCk7DQorCQlyZXR1cm4gcmV0
Ow0KKwl9DQorDQorCWlmIChzdGF0ZSA9PSBNTFg1X1ZTQ19MT0NLKSB7DQorCQkvKiBHZXQgYSB1
bmlxdWUgSUQgYmFzZWQgb24gdGhlIGNvdW50ZXIgKi8NCisJCXJldCA9IHZzY19yZWFkKGRldiwg
VlNDX0NPVU5URVJfT0ZGU0VULCAmaWQpOw0KKwkJaWYgKHJldCkNCisJCQlyZXR1cm4gcmV0Ow0K
Kwl9DQorDQorCS8qIFRyeSB0byBtb2RpZnkgbG9jayAqLw0KKwlyZXQgPSBtbHg1X3ZzY19nd193
cml0ZShkZXYsIHNwYWNlLCBpZCk7DQorCWlmIChyZXQpDQorCQlyZXR1cm4gcmV0Ow0KKw0KKwkv
KiBWZXJpZnkgbG9jayB3YXMgbW9kaWZpZWQgKi8NCisJcmV0ID0gbWx4NV92c2NfZ3dfcmVhZChk
ZXYsIHNwYWNlLCAmZGF0YSk7DQorCWlmIChyZXQpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCisJ
aWYgKGRhdGEgIT0gaWQpDQorCQlyZXR1cm4gLUVCVVNZOw0KKw0KKwlyZXR1cm4gMDsNCit9DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9w
Y2lfdnNjLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL3Bj
aV92c2MuaA0KaW5kZXggMjhlYTZiZmE0MzlmLi42NDI3MmE2ZDc3NTQgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL3BjaV92c2MuaA0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmgN
CkBAIC00LDYgKzQsMTEgQEANCiAjaWZuZGVmIF9fTUxYNV9QQ0lfVlNDX0hfXw0KICNkZWZpbmUg
X19NTFg1X1BDSV9WU0NfSF9fDQogDQorZW51bSBtbHg1X3ZzY19zdGF0ZSB7DQorCU1MWDVfVlND
X1VOTE9DSywNCisJTUxYNV9WU0NfTE9DSywNCit9Ow0KKw0KIGVudW0gew0KIAlNTFg1X1ZTQ19T
UEFDRV9TQ0FOX0NSU1BBQ0UgPSAweDcsDQogfTsNCkBAIC0yMSw0ICsyNiw3IEBAIHN0YXRpYyBp
bmxpbmUgYm9vbCBtbHg1X3ZzY19hY2Nlc3NpYmxlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYp
DQogCXJldHVybiAhIWRldi0+dnNjX2FkZHI7DQogfQ0KIA0KK2ludCBtbHg1X3ZzY19zZW1fc2V0
X3NwYWNlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHUxNiBzcGFjZSwNCisJCQkgICBlbnVt
IG1seDVfdnNjX3N0YXRlIHN0YXRlKTsNCisNCiAjZW5kaWYgLyogX19NTFg1X1BDSV9WU0NfSF9f
ICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L21seDVfY29yZS5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21s
eDVfY29yZS5oDQppbmRleCA5N2Y4Y2Y2N2NlZDAuLjg1OTNjODE4M2Q4NyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tbHg1X2NvcmUuaA0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oDQpA
QCAtMTExLDYgKzExMSwxMCBAQCBlbnVtIHsNCiAJTUxYNV9EUklWRVJfU1lORCA9IDB4YmFkZDAw
ZGUsDQogfTsNCiANCitlbnVtIG1seDVfc2VtYXBob3JlX3NwYWNlX2FkZHJlc3Mgew0KKwlNTFg1
X1NFTUFQSE9SRV9TUEFDRV9ET01BSU4gICAgID0gMHhBLA0KK307DQorDQogaW50IG1seDVfcXVl
cnlfaGNhX2NhcHMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldik7DQogaW50IG1seDVfcXVlcnlf
Ym9hcmRfaWQoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldik7DQogaW50IG1seDVfY21kX2luaXRf
aGNhKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHVpbnQzMl90ICpzd19vd25lcl9pZCk7DQot
LSANCjIuMjEuMA0KDQo=
