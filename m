Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B645A6FC
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfF1WgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:19 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbfF1WgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=X6Loj3N0zUqJMLpWw1qGpmkYoqV2xkvxIiNLuCCWqpB53cjQF1fmskrKe54M/pc3zDedPbJUNIj4Yo0LwmdEDio0b8XAOX5sAYgmL8Ms+mcqXX8mzPAsOBKxCilrl6WCCq60+EHnl2wGwRRAxPkdss5dwPlFRoMB5I6Qo8gp/Hc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuLegtSJ0oJBwmDsRFHg0bs64i1MIsCM+RSybepaoEo=;
 b=Yvjkvlj300hSHA7534J+kLh3hplFbvEboL3C53KaJb5mR/MZ3eL7OPBdgrGhahLtaF5IcBKOhB1rz8Ho65Jt49P4lK22onufmsix3lxmRkov1WTyCB3wLEsjHQAzHgz2CDOaP0uaAii/N63D3MUPVnhKSRESNBKH3yO59/4ctwA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuLegtSJ0oJBwmDsRFHg0bs64i1MIsCM+RSybepaoEo=;
 b=dQj6axoBMbKUEjo/AQ0tOvL0k7aamkcEBV4toh1TU/zjwxU82MrRIkwP35RO2LPOzwts++mJn81UPTm66GoYz8vuJFVCU8m8hSUZ7QWVt12lDhYLmxaty4dbW/iSaRXSWYp9TU66Ba6Z2xnNcKNiAE3DDEDFSBqBS4fme5Ztbsc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: [PATCH mlx5-next 09/18] net/mlx5: Don't handle VF func change if host
 PF is disabled
Thread-Topic: [PATCH mlx5-next 09/18] net/mlx5: Don't handle VF func change if
 host PF is disabled
Thread-Index: AQHVLgHemS55hqdZJE+JQICHcsVV5A==
Date:   Fri, 28 Jun 2019 22:36:04 +0000
Message-ID: <20190628223516.9368-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e024b62c-df92-4a11-5c1a-08d6fc1900ff
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB23571D9EF68384057A380BD6BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002)(461764006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 37pIGe4MeVDfHaDkV5uYBDAOhfwqMgMH7/0ZoOm7wvnzTvU2EjSbKfiWbHWn/hlrOH23VqyPi+N/U0ef6yuFYDeKZ+Z/vPfvZjj7kFKEshyL4+hcQfXSzsdpoccFpwR0a3I40059WaYHW9NprEaTcwqhtMw+wGhFs7M9KpX4KIqIcZCMgkYnCKZKKBUirDzOjc2F6w41VGMoAl/LM5x2CLYsUi8pK+a/9Mcbgr2SAT5cTIEe1q+ZFlQUwflg6Qkqt4ZuQ6uz9Be5s91nfLEU9XwhUTjh8Mfmw5m5jOAji+qNI7PqPxUz0Ve0l1jjOROAziN64FCHV6wvJ+/XXVaNxi//jTJtnKcprqlqRF8RKC574Nl4FLbYSl1Xe9OiUkoZCLzgPzyfqgkLbJA60i23iPUlybYSlWbaQ3E8OB0FbAg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e024b62c-df92-4a11-5c1a-08d6fc1900ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:04.4984
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

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCldoZW4gRUNQRiBlc3dp
dGNoIG1hbmFnZXIgaXMgYXQgb2ZmbG9hZHMgbW9kZSwgaXQgbW9uaXRvcnMgZnVuY3Rpb25zDQpj
aGFuZ2VkIGV2ZW50IGZyb20gaG9zdCBQRiBzaWRlIGFuZCBhY3RzIGFjY29yZGluZyB0byB0aGUg
bnVtYmVyIG9mDQpWRnMgZW5hYmxlZC9kaXNhYmxlZC4NCg0KQXMgRUNQRiBhbmQgaG9zdCBQRiB3
b3JrIGluIHR3byBpbmRlcGVuZGVudCBob3N0cywgaXQncyBwb3NzaWJsZSB0aGF0DQpob3N0IFBG
IE9TIHJlYm9vdHMgYnV0IEVDUEYgc3lzdGVtIGlzIHN0aWxsIGtlcHQgb24gYW5kIGNvbnRpbnVl
cw0KbW9uaXRvcmluZyBldmVudHMgZnJvbSBob3N0IFBGLiBXaGVuIGtlcm5lbCBmcm9tIGhvc3Qg
UEYgc2lkZSBpcw0KYm9vdGluZywgUENJIGlvdiBkcml2ZXIgZG9lcyBzcmlvdl9pbml0IGFuZCBj
b21wdXRlX21heF92Zl9idXNlcyBieQ0KaXRlcmF0aW5nIG92ZXIgYWxsIHZhbGlkIG51bSBvZiBW
RnMuIFRoaXMgdHJpZ2dlcnMgRkxSIGFuZCBnZW5lcmF0ZXMNCmZ1bmN0aW9ucyBjaGFuZ2VkIGV2
ZW50cywgZXZlbiB0aG91Z2ggaG9zdCBQRiBIQ0EgaXMgbm90IGVuYWJsZWQgYXQNCnRoaXMgdGlt
ZS4gSG93ZXZlciwgRUNQRiBpcyBub3QgYXdhcmUgb2YgdGhpcyBpbmZvcm1hdGlvbiwgYW5kIHN0
aWxsDQpoYW5kbGVzIHRoZXNlIGV2ZW50cyBhcyB1c3VhbC4gRUNQRiBzeXN0ZW0gd2lsbCBzZWUg
bWFzc2l2ZSBudW1iZXIgb2YNCnJlcHMgYXJlIGNyZWF0ZWQsIGJ1dCBkZXN0cm95ZWQgaW1tZWRp
YXRlbHkgb25jZSBjcmVhdGlvbiBmaW5pc2hlZC4NCg0KVG8gZWxpbWluYXRlIHRoaXMgbm9pc2Us
IGEgYml0IGlzIGFkZGVkIHRvIGhvc3QgcGFyYW1ldGVyIGNvbnRleHQgdG8NCmluZGljYXRlIGhv
c3QgUEYgaXMgZGlzYWJsZWQuIEVDUEYgd2lsbCBub3QgaGFuZGxlIHRoZSBWRiBjaGFuZ2VkDQpl
dmVudCBpZiB0aGlzIGJpdCBpcyBzZXQuDQoNClNpZ25lZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxi
b2RvbmdAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IERhbmllbCBKdXJnZW5zIDxkYW5pZWxq
QG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2Vzd2l0Y2hfb2ZmbG9hZHMuYyB8IDUgKysrKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9p
ZmMuaCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMyArKy0NCiAyIGZpbGVzIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5j
DQppbmRleCAyNGFmMjc0NDQ1M2IuLjEwNWMyMTA2OWMwYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRz
LmMNCkBAIC0yMDI2LDYgKzIwMjYsNyBAQCBzdGF0aWMgdm9pZCBlc3dfZnVuY3Rpb25zX2NoYW5n
ZWRfZXZlbnRfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCXUzMiBvdXRbTUxY
NV9TVF9TWl9EVyhxdWVyeV9lc3dfZnVuY3Rpb25zX291dCldID0ge307DQogCXN0cnVjdCBtbHg1
X2hvc3Rfd29yayAqaG9zdF93b3JrOw0KIAlzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3c7DQorCWJv
b2wgaG9zdF9wZl9kaXNhYmxlZDsNCiAJdTE2IG51bV92ZnMgPSAwOw0KIAlpbnQgZXJyOw0KIA0K
QEAgLTIwMzUsNyArMjAzNiw5IEBAIHN0YXRpYyB2b2lkIGVzd19mdW5jdGlvbnNfY2hhbmdlZF9l
dmVudF9oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJZXJyID0gbWx4NV9lc3df
cXVlcnlfZnVuY3Rpb25zKGVzdy0+ZGV2LCBvdXQsIHNpemVvZihvdXQpKTsNCiAJbnVtX3ZmcyA9
IE1MWDVfR0VUKHF1ZXJ5X2Vzd19mdW5jdGlvbnNfb3V0LCBvdXQsDQogCQkJICAgaG9zdF9wYXJh
bXNfY29udGV4dC5ob3N0X251bV9vZl92ZnMpOw0KLQlpZiAoZXJyIHx8IG51bV92ZnMgPT0gZXN3
LT5lc3dfZnVuY3MubnVtX3ZmcykNCisJaG9zdF9wZl9kaXNhYmxlZCA9IE1MWDVfR0VUKHF1ZXJ5
X2Vzd19mdW5jdGlvbnNfb3V0LCBvdXQsDQorCQkJCSAgICBob3N0X3BhcmFtc19jb250ZXh0Lmhv
c3RfcGZfZGlzYWJsZWQpOw0KKwlpZiAoZXJyIHx8IGhvc3RfcGZfZGlzYWJsZWQgfHwgbnVtX3Zm
cyA9PSBlc3ctPmVzd19mdW5jcy5udW1fdmZzKQ0KIAkJZ290byBvdXQ7DQogDQogCS8qIE51bWJl
ciBvZiBWRnMgY2FuIG9ubHkgY2hhbmdlIGZyb20gIjAgdG8geCIgb3IgInggdG8gMCIuICovDQpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggYi9pbmNsdWRlL2xpbnV4
L21seDUvbWx4NV9pZmMuaA0KaW5kZXggZTJhNzdiNTE1MmE4Li4wMzFkYjUzZTk0Y2UgMTAwNjQ0
DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KKysrIGIvaW5jbHVkZS9saW51
eC9tbHg1L21seDVfaWZjLmgNCkBAIC05ODIzLDcgKzk4MjMsOCBAQCBzdHJ1Y3QgbWx4NV9pZmNf
bXRyY19jdHJsX2JpdHMgew0KIA0KIHN0cnVjdCBtbHg1X2lmY19ob3N0X3BhcmFtc19jb250ZXh0
X2JpdHMgew0KIAl1OCAgICAgICAgIGhvc3RfbnVtYmVyWzB4OF07DQotCXU4ICAgICAgICAgcmVz
ZXJ2ZWRfYXRfOFsweDhdOw0KKwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzhbMHg3XTsNCisJdTgg
ICAgICAgICBob3N0X3BmX2Rpc2FibGVkWzB4MV07DQogCXU4ICAgICAgICAgaG9zdF9udW1fb2Zf
dmZzWzB4MTBdOw0KIA0KIAl1OCAgICAgICAgIGhvc3RfdG90YWxfdmZzWzB4MTBdOw0KLS0gDQoy
LjIxLjANCg0K
