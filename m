Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A490E038
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfD2KFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:21 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727581AbfD2KFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KWLiPzA3Ag4vqNwezW/X4orag1rIKlK1UYHht2+mU4=;
 b=HneGi59+RyO42nQLn0q+bW/UwFu6K2QpRLN3P0vwZ8Go7L0KsHpxVUzyP85djwvp6D9pJC2lwCwyQxJcjgwMIUzYUFfi/5l+UiR5RWaq4Hp8y3k5IyMP48HAzAfXaqd14zLaNYQP5yj37NW55eTEz6wLfuTNfvXp2wXCeEpGz5Y=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:43 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:43 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 04/15] net: aquantia: link interrupt handling
 function
Thread-Topic: [PATCH v4 net-next 04/15] net: aquantia: link interrupt handling
 function
Thread-Index: AQHU/nL3KSz/TekQEEqDy3zNdBYDUw==
Date:   Mon, 29 Apr 2019 10:04:43 +0000
Message-ID: <4560f070ac23ad11fa3b4d321de6df450e5d652e.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afa5507e-7833-4f4a-794b-08d6cc8a19cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB364478883D7D35852302A63198390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:88;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(4744005)(256004)(11346002)(52116002)(446003)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QVW1uHxXhe/kQY7EMPZTJEIKyDDsRCSXEiPmaRxTfnXB1YZ/t09x6lxPZNzx7JvTbAievh15zcHJ8tQC2Db0UscIwg0vQ8eyz5AGa/0lDUhKyTVfrWLAUfznINx9PazxhD6qg6OKxPhpppTm7pUzzy5MR1uCknZovfV78Rur4gcJhGSW1NHbHTKHYJxTDUJ16CEzYu4+uKSLEGUz79KKMlh6NeQaW4O/S2jeyM/HL1Tg4CQ/sxJZTPEnLhPqjDSy6o+a1aOtcXydGN6a4/fqWIO7yNCQx8NcYpHpvJjcUlvhGB/NJFJhb5Llq9RQqJf7AKEgvlf0H3M9M00I9uVldPh71ezXfvp5u99RIo2drWH492YoiGWxLw2jFiGn1wJFnJNuWtIhJpAwIlqpS0hcNGIs75pW504Bncdd+e7/BvA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa5507e-7833-4f4a-794b-08d6cc8a19cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:43.4300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVmaW5lIGxpbmsgaW50ZXJydXB0IGhhbmRsZXINCg0KU2lnbmVkLW9mZi1ieTogTmlraXRhIERh
bmlsb3YgPG5kYW5pbG92QGFxdWFudGlhLmNvbT4NClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tp
a2ggPGlnb3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMgfCAxNCArKysrKysrKysrKysrKw0KIDEgZmls
ZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jDQppbmRleCAwNTlkZjg2ZThlMzcuLjQ4NTFmYzBh
M2FlNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX25pYy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9h
cV9uaWMuYw0KQEAgLTE2MSw2ICsxNjEsMjAgQEAgc3RhdGljIGludCBhcV9uaWNfdXBkYXRlX2xp
bmtfc3RhdHVzKHN0cnVjdCBhcV9uaWNfcyAqc2VsZikNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0
YXRpYyBpcnFyZXR1cm5fdCBhcV9saW5rc3RhdGVfdGhyZWFkZWRfaXNyKGludCBpcnEsIHZvaWQg
KnByaXZhdGUpDQorew0KKwlzdHJ1Y3QgYXFfbmljX3MgKnNlbGYgPSBwcml2YXRlOw0KKw0KKwlp
ZiAoIXNlbGYpDQorCQlyZXR1cm4gSVJRX05PTkU7DQorDQorCWFxX25pY191cGRhdGVfbGlua19z
dGF0dXMoc2VsZik7DQorDQorCXNlbGYtPmFxX2h3X29wcy0+aHdfaXJxX2VuYWJsZShzZWxmLT5h
cV9odywNCisJCQkJICAgICAgIEJJVChzZWxmLT5hcV9uaWNfY2ZnLmxpbmtfaXJxX3ZlYykpOw0K
KwlyZXR1cm4gSVJRX0hBTkRMRUQ7DQorfQ0KKw0KIHN0YXRpYyB2b2lkIGFxX25pY19zZXJ2aWNl
X3RpbWVyX2NiKHN0cnVjdCB0aW1lcl9saXN0ICp0KQ0KIHsNCiAJc3RydWN0IGFxX25pY19zICpz
ZWxmID0gZnJvbV90aW1lcihzZWxmLCB0LCBzZXJ2aWNlX3RpbWVyKTsNCi0tIA0KMi4xNy4xDQoN
Cg==
