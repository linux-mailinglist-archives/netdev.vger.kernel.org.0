Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46955A70B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfF1Wgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:45 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727064AbfF1Wgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=BwI/u+t5/VQQIycCz0Nq2+AzLDdRlcrhdQFcZkPt7x23dYkjF9cafPqd/yq2sY8ghOa7gxLToc7te9pV7x8PG5Bz9hmb8DztZ3Et8yAYYDkk897wabbHtJAkgaOL2yZxSCeCudbVN+Zq+AKaX+RTIAFyj2910r4apzm1RzcJchs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqt1HzynAq65IN3MePI+ZZwPavAZYTYrkEo4a44DEFw=;
 b=H4YQODOhCejUCfzgGldUN4UMBg0h6hOIuqLJI8UZRyNaY1BhT1PcyVDJPbTxWKXbs9/V2GcJDaulWSO9qnOeOeG1kV7zrcOr+bxftXE62A3lwQqDvHNmZEsQQEJy/GerMUDYDttMPalZjCoJQwK0DE9T6No1taXpak8uRiysY4w=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqt1HzynAq65IN3MePI+ZZwPavAZYTYrkEo4a44DEFw=;
 b=scK1gzf74jnsVjzuoKkJ69mVPqG2PbdDqpNv4FLOMCGwMF7ITi4lHJFmFxHO0VPWoUSnJCrG8c6P9mrJrPGu9+j8pq1G7cf0mG+aC+RJiczuo+mNi4VgccXBCmsc1BzvSUmQTUxgoiGreEyvRyysbO63WRG0IqKBtPvxzzd9NhQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:20 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 16/18] net/mlx5: E-Switch, Use iterator for vlan and
 min-inline setups
Thread-Topic: [PATCH mlx5-next 16/18] net/mlx5: E-Switch, Use iterator for
 vlan and min-inline setups
Thread-Index: AQHVLgHoUdcVpGDsRUmpPhMO6PPQkw==
Date:   Fri, 28 Jun 2019 22:36:20 +0000
Message-ID: <20190628223516.9368-17-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1c7db76-9e47-4991-4675-08d6fc190a6d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB23576FD2EEB8EC6E4770FAC3BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v+UfTNdMXnSZX3IDR20pCcHqsC+sKgw50y5XHaP89+mIUVJsalcH5rpUG90aqBZ71kNsmsJuq+CEBBz1uoCigzPUf2LusrZfKWuUsYzZczuO58Laco6WjP4lLiuj4ByhQhTxwnHB2pLOMoSXkEcr7WPorkcm3f/0wQbVs1F1d03c+yzRdA1FW89MPtfAFmGmhIylwKtNi3iz3NClAOWRFe2OwCyXMXbioWAhiiuHzB1gZUs0DwE0kMGBWwyPTBClGsM+KpFQvxC26ajDuEK55XCzahvRP6ANcbYeAIbyqR41R5YPMGwLwKYVhfrVPNC5aoh6cTToOL6HqVOpxYVfTgifa3QgyJ5wczw5FndTa7H+a2Qky6zXUrXzvpywVAC+biPtu3YcXQTXRlVLL4GD6bM7eqVvNoV8MRvY45Xff/c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c7db76-9e47-4991-4675-08d6fc190a6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:20.3913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNClVzZSB0aGUgZGVmaW5l
ZCBpdGVyYXRvcnMgdG8gdHJhdmVyc2FsIFZGIHJlcHMvdnBvcnQuIEFsc28sIHJlbHkgb24NCm51
bSBvZiBWRnMgcmF0aGVyIHRoYW4gdGhlIGNvdW50ZXIgb2YgZW5hYmxlZCB2cG9ydHMgYXMgUEYg
d2lsbCBhbHNvDQpiZSBlbmFibGVkIGZyb20gRUNQRiBzaWRlLCBhbmQgdGhlIGNvdW50ZXIgd2ls
bCBiZSBkaWZmZXJlbnQgZnJvbQ0KbnVtIG9mIFZGcy4NCg0KU2lnbmVkLW9mZi1ieTogQm9kb25n
IFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogUGFyYXYgUGFuZGl0IDxw
YXJhdkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG1lbGxhbm94LmNvbT4NCi0tLQ0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3
aXRjaF9vZmZsb2Fkcy5jICAgfCAxMiArKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCmluZGV4
IDFkNzkwZDQzZTcyOS4uYWVjZmI2MzZmYmM2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYw0KKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYw0KQEAg
LTM0Nyw4ICszNDcsNyBAQCBzdGF0aWMgaW50IGVzd19zZXRfZ2xvYmFsX3ZsYW5fcG9wKHN0cnVj
dCBtbHg1X2Vzd2l0Y2ggKmVzdywgdTggdmFsKQ0KIAlpbnQgdmZfdnBvcnQsIGVyciA9IDA7DQog
DQogCWVzd19kZWJ1Zyhlc3ctPmRldiwgIiVzIGFwcGx5aW5nIGdsb2JhbCAlcyBwb2xpY3lcbiIs
IF9fZnVuY19fLCB2YWwgPyAicG9wIiA6ICJub25lIik7DQotCWZvciAodmZfdnBvcnQgPSAxOyB2
Zl92cG9ydCA8IGVzdy0+ZW5hYmxlZF92cG9ydHM7IHZmX3Zwb3J0KyspIHsNCi0JCXJlcCA9ICZl
c3ctPm9mZmxvYWRzLnZwb3J0X3JlcHNbdmZfdnBvcnRdOw0KKwltbHg1X2Vzd19mb3JfZWFjaF92
Zl9yZXAoZXN3LCB2Zl92cG9ydCwgcmVwLCBlc3ctPmVzd19mdW5jcy5udW1fdmZzKSB7DQogCQlp
ZiAoYXRvbWljX3JlYWQoJnJlcC0+cmVwX2RhdGFbUkVQX0VUSF0uc3RhdGUpICE9IFJFUF9MT0FE
RUQpDQogCQkJY29udGludWU7DQogDQpAQCAtMjMwMiw3ICsyMzAxLDcgQEAgaW50IG1seDVfZGV2
bGlua19lc3dpdGNoX2lubGluZV9tb2RlX3NldChzdHJ1Y3QgZGV2bGluayAqZGV2bGluaywgdTgg
bW9kZSwNCiB7DQogCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBkZXZsaW5rX3ByaXYoZGV2
bGluayk7DQogCXN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdyA9IGRldi0+cHJpdi5lc3dpdGNoOw0K
LQlpbnQgZXJyLCB2cG9ydDsNCisJaW50IGVyciwgdnBvcnQsIG51bV92cG9ydDsNCiAJdTggbWx4
NV9tb2RlOw0KIA0KIAllcnIgPSBtbHg1X2RldmxpbmtfZXN3aXRjaF9jaGVjayhkZXZsaW5rKTsN
CkBAIC0yMzMxLDcgKzIzMzAsNyBAQCBpbnQgbWx4NV9kZXZsaW5rX2Vzd2l0Y2hfaW5saW5lX21v
ZGVfc2V0KHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rLCB1OCBtb2RlLA0KIAlpZiAoZXJyKQ0KIAkJ
Z290byBvdXQ7DQogDQotCWZvciAodnBvcnQgPSAxOyB2cG9ydCA8IGVzdy0+ZW5hYmxlZF92cG9y
dHM7IHZwb3J0KyspIHsNCisJbWx4NV9lc3dfZm9yX2VhY2hfdmZfdnBvcnRfbnVtKGVzdywgdnBv
cnQsIGVzdy0+ZXN3X2Z1bmNzLm51bV92ZnMpIHsNCiAJCWVyciA9IG1seDVfbW9kaWZ5X25pY192
cG9ydF9taW5faW5saW5lKGRldiwgdnBvcnQsIG1seDVfbW9kZSk7DQogCQlpZiAoZXJyKSB7DQog
CQkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywNCkBAIC0yMzQ0LDcgKzIzNDMsOCBAQCBpbnQg
bWx4NV9kZXZsaW5rX2Vzd2l0Y2hfaW5saW5lX21vZGVfc2V0KHN0cnVjdCBkZXZsaW5rICpkZXZs
aW5rLCB1OCBtb2RlLA0KIAlyZXR1cm4gMDsNCiANCiByZXZlcnRfaW5saW5lX21vZGU6DQotCXdo
aWxlICgtLXZwb3J0ID4gMCkNCisJbnVtX3Zwb3J0ID0gLS12cG9ydDsNCisJbWx4NV9lc3dfZm9y
X2VhY2hfdmZfdnBvcnRfbnVtX3JldmVyc2UoZXN3LCB2cG9ydCwgbnVtX3Zwb3J0KQ0KIAkJbWx4
NV9tb2RpZnlfbmljX3Zwb3J0X21pbl9pbmxpbmUoZGV2LA0KIAkJCQkJCSB2cG9ydCwNCiAJCQkJ
CQkgZXN3LT5vZmZsb2Fkcy5pbmxpbmVfbW9kZSk7DQpAQCAtMjM4OSw3ICsyMzg5LDcgQEAgaW50
IG1seDVfZXN3aXRjaF9pbmxpbmVfbW9kZV9nZXQoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LCB1
OCAqbW9kZSkNCiAJfQ0KIA0KIHF1ZXJ5X3Zwb3J0czoNCi0JZm9yICh2cG9ydCA9IDE7IHZwb3J0
IDw9IGVzdy0+ZXN3X2Z1bmNzLm51bV92ZnM7IHZwb3J0KyspIHsNCisJbWx4NV9lc3dfZm9yX2Vh
Y2hfdmZfdnBvcnRfbnVtKGVzdywgdnBvcnQsIGVzdy0+ZXN3X2Z1bmNzLm51bV92ZnMpIHsNCiAJ
CW1seDVfcXVlcnlfbmljX3Zwb3J0X21pbl9pbmxpbmUoZGV2LCB2cG9ydCwgJm1seDVfbW9kZSk7
DQogCQlpZiAodnBvcnQgPiAxICYmIHByZXZfbWx4NV9tb2RlICE9IG1seDVfbW9kZSkNCiAJCQly
ZXR1cm4gLUVJTlZBTDsNCi0tIA0KMi4yMS4wDQoNCg==
