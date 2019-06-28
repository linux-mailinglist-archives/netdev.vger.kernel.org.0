Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755955A6FA
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfF1WgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:15 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbfF1WgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=m2zkIsXp9Bsj0Rd9qIHEga3N478UD9Y3L1u8tuElz3OEt1zf1/H/HqeJ2/OoEet/NKjQGS+kzoUHAAOJCBTjZIu0x1LQZ9x0800ujKhMUfiOISsV5Qke4HegkzlBMqxNHNRJ0rCxGxMrD41gygePn6A5RqOy23JalGGDwn9PoqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5qP8L8w+FhXyNMnRXakoxDiTPxwCd0sOTtGTxI0KY8=;
 b=gTAxnSxIVi6OjtptNdpJn85qxZbJ7RxC+g23mLwIx1k3RgI+i1owsVJH+sEnptjZR8uS/cBxgOuQRrlDim2tklWOOGdNCXa/5x8k6YbbnHB7Gym4MT10P8h4IBSDC0hzDFaMlOs/FatPP4mS12wEWcfBUrVnxgZwLIhdnjWUD/A=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5qP8L8w+FhXyNMnRXakoxDiTPxwCd0sOTtGTxI0KY8=;
 b=TQah7vZ21YvULtV+dMLfptxWZDXkckd8FQR9RVDmmK/99adAq8Bmu9U5timM6zDcNjwijr+Olq2PU99CCJIGt2v7qTlFonSvYQTafrsgJ27RXH0WSXKEi/zppkShFUSqXOElv7l/HO/9+7QJLLUyQKfMXfPhQwXX7wIP5yL4ZCA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:02 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 08/18] net/mlx5: Limit scope of
 mlx5_get_next_phys_dev() to PCI PF devices
Thread-Topic: [PATCH mlx5-next 08/18] net/mlx5: Limit scope of
 mlx5_get_next_phys_dev() to PCI PF devices
Thread-Index: AQHVLgHdBYh9KfsvDE+WOlgZ9nCRuw==
Date:   Fri, 28 Jun 2019 22:36:02 +0000
Message-ID: <20190628223516.9368-9-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 34a33d4d-f3d4-4007-7688-08d6fc18ffb0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB23579052A4D7169D86E6614FBEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dQS/D1WTjvAgmkaCTW62CNwrK26wGKu7OowKsrtyqqiW9Z7B4vJb1+hO2weT0yxQsSrTzy3kdGXjk82LQmCwheCTQ6YfdLKGIKENxLjGfuMOcwT2cXD1q0IKZ+78zNPsQyNRJeupz16UuAWfsyPqbcn9ABJ8x9K0TIYDvEE4b50eFixoxSldFUAZuMhaHdaJLHZSgoyQY9f4t77Kcx+4zczOIrM2/QxfMD7PK64F00ksxu9Q8AEFeWASpky/6BgfVpae89sDBJvAVeblKGn57k3sI1qzTy5gfIGK3zMPUY8nFTRVka7uQrKcIxIPWDo8FeY5ZXNdIJ2HGiRjzFQ4xOPJHuFv3j+mmnxavMP8VBMA2CWA53SFboEwrGHrEsZnof2nxAoKY36Pqti673j+EheVGI+wdTGrurB8PmSGyd0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a33d4d-f3d4-4007-7688-08d6fc18ffb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:02.2996
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

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCkFzIG1seDVfZ2V0X25l
eHRfcGh5c19kZXYgaXMgdXNlZCBvbmx5IGZvciBQQ0kgUEYgZGV2aWNlcyB1c2UgY2FzZSwNCmxp
bWl0IGl0IHRvIHNlYXJjaCBvbmx5IGZvciBQQ0kgZGV2aWNlcy4NCg0KU2lnbmVkLW9mZi1ieTog
UGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVnUgUGhhbSA8
dnVodW9uZ0BtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9kZXYuYyB8IDkgKysrKysrKystDQogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2Rldi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2Rldi5jDQppbmRleCBlYmMwNDZmYTk3ZDMuLjI1YWZmY2U2Y2JlZCAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kZXYuYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Rldi5jDQpAQCAtMjkw
LDEzICsyOTAsMjAgQEAgc3RhdGljIHUzMiBtbHg1X2dlbl9wY2lfaWQoc3RydWN0IG1seDVfY29y
ZV9kZXYgKmRldikNCiAvKiBNdXN0IGJlIGNhbGxlZCB3aXRoIGludGZfbXV0ZXggaGVsZCAqLw0K
IHN0cnVjdCBtbHg1X2NvcmVfZGV2ICptbHg1X2dldF9uZXh0X3BoeXNfZGV2KHN0cnVjdCBtbHg1
X2NvcmVfZGV2ICpkZXYpDQogew0KLQl1MzIgcGNpX2lkID0gbWx4NV9nZW5fcGNpX2lkKGRldik7
DQogCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpyZXMgPSBOVUxMOw0KIAlzdHJ1Y3QgbWx4NV9jb3Jl
X2RldiAqdG1wX2RldjsNCiAJc3RydWN0IG1seDVfcHJpdiAqcHJpdjsNCisJdTMyIHBjaV9pZDsN
CiANCisJaWYgKCFtbHg1X2NvcmVfaXNfcGYoZGV2KSkNCisJCXJldHVybiBOVUxMOw0KKw0KKwlw
Y2lfaWQgPSBtbHg1X2dlbl9wY2lfaWQoZGV2KTsNCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShwcml2
LCAmbWx4NV9kZXZfbGlzdCwgZGV2X2xpc3QpIHsNCiAJCXRtcF9kZXYgPSBjb250YWluZXJfb2Yo
cHJpdiwgc3RydWN0IG1seDVfY29yZV9kZXYsIHByaXYpOw0KKwkJaWYgKCFtbHg1X2NvcmVfaXNf
cGYodG1wX2RldikpDQorCQkJY29udGludWU7DQorDQogCQlpZiAoKGRldiAhPSB0bXBfZGV2KSAm
JiAobWx4NV9nZW5fcGNpX2lkKHRtcF9kZXYpID09IHBjaV9pZCkpIHsNCiAJCQlyZXMgPSB0bXBf
ZGV2Ow0KIAkJCWJyZWFrOw0KLS0gDQoyLjIxLjANCg0K
