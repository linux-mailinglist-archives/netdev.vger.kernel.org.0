Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064A4315E4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfEaUKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:10:11 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:7493
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbfEaUKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvOy65loZ5u2uw4hDMBq78oWYhfZ0NoZUK1xLTyyED8=;
 b=Ge2Osjl0oUM+Cs4Ff0FzFg/ATN+csEUBvHriysdODMFbPHNQCqesdla3nYUgu548RJX/RkqFmeRAVQx4q8gkd+vzUPheIi2V7hFk5lHwu8e0JR5GgiFtB9VjaZrj8DgCxD6708Bnos1tlO4ZRUZEvqdmSuxjrS8KUbvSGzMeG8c=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB5600.eurprd05.prod.outlook.com (20.177.203.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 20:09:39 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 20:09:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 9/9] net/mlx5e: TX, Improve performance under GSO workload
Thread-Topic: [net-next 9/9] net/mlx5e: TX, Improve performance under GSO
 workload
Thread-Index: AQHVF+zHOGptURoIBUqC+ZVxrtBs2w==
Date:   Fri, 31 May 2019 20:09:39 +0000
Message-ID: <20190531200838.25184-10-saeedm@mellanox.com>
References: <20190531200838.25184-1-saeedm@mellanox.com>
In-Reply-To: <20190531200838.25184-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b40aba6e-9482-4175-66e8-08d6e603e93d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5600;
x-ms-traffictypediagnostic: VI1PR05MB5600:
x-microsoft-antispam-prvs: <VI1PR05MB56003F322FBC501FD50F2035BE190@VI1PR05MB5600.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:211;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(396003)(346002)(189003)(199004)(99286004)(52116002)(2616005)(6116002)(6512007)(107886003)(486006)(54906003)(386003)(476003)(76176011)(186003)(26005)(3846002)(11346002)(305945005)(81166006)(66066001)(256004)(6506007)(4326008)(25786009)(6486002)(102836004)(6436002)(66946007)(8936002)(64756008)(7736002)(8676002)(53936002)(66476007)(73956011)(446003)(66556008)(81156014)(66446008)(6916009)(1076003)(68736007)(2906002)(86362001)(71190400001)(14454004)(5660300002)(316002)(508600001)(36756003)(50226002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5600;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oHhTuqLJdSBiMr90iDzaDqXYBisOE4I7fK7JGz6fbtVkiKlcGFsFvOEzS3mCbb+TVQvzjyTa8o1B+wtVnqog7uwzRt8MbCQnTPw6E/8ygr5irBJ0YFimTOvES+RstgGAbfdi0ZuqMtkNFHZ8+bH25ugwsk7nh8W8xM3d+iwVndgA65NW4Ifpua2BiVwp5PtG7qc8Xx+HTcFs5dwQYFu3Iv6q+QQaYCqGvWGjkpT/zltuJZ9WTeiKCkVT3qhcG2wbtF6keO8mCnvNy8xUi4O9Oe9xJFO+FDL8ckDXe95bY1z80wde7Y8aAWu0W5Gfg/TgU5wU9Gtj9T78niogRqPR2IqPoTmhfiYZc8CIJvXuRCB+/E4lZPlvc8voSXtFdbv4twhfgzSeRSO+E3ZYcPLcFb9FCd44Khfu5lFxk1pjtWo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b40aba6e-9482-4175-66e8-08d6e603e93d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 20:09:39.7626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5600
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJleiBBbGZhc2kgPGVyZXphQG1lbGxhbm94LmNvbT4NCg0KX19uZXRkZXZfdHhfc2Vu
dF9xdWV1ZSgpIHdhcyBpbnRyb2R1Y2VkIGJ5Og0KY29tbWl0IDNlNTkwMjBhYmYwZiAoIm5ldDog
YnFsOiBhZGQgX19uZXRkZXZfdHhfc2VudF9xdWV1ZSgpIikNCg0KQlFMIGNvdW50ZXJzIHNob3Vs
ZCBiZSB1cGRhdGVkIHdpdGhvdXQgZmxpcHBpbmcvY2FyaW5nIGFib3V0DQpCUUwgc3RhdHVzLCBp
ZiB0aGUgY3VycmVudCBza2IgaGFzIHhtaXRfbW9yZSBzZXQuDQoNClVzaW5nIF9fbmV0ZGV2X3R4
X3NlbnRfcXVldWUoKSBhdm9pZHMgbWVzc2luZyB3aXRoIEJRTCBzdG9wDQpmbGFnLCBpbmNyZWFz
ZXMgcGVyZm9ybWFuY2Ugb24gR1NPIHdvcmtsb2FkIGJ5IGtlZXBpbmcNCmRvb3JiZWxscyB0byB0
aGUgbWluaW11bSByZXF1aXJlZCBhbmQgYWxzbyBzcGFyaW5nIGF0b21pYw0Kb3BlcmF0aW9ucy4N
Cg0KU2lnbmVkLW9mZi1ieTogRXJleiBBbGZhc2kgPGVyZXphQG1lbGxhbm94LmNvbT4NClJldmll
d2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5
OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jIHwgNyArKysrLS0tDQogMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3R4LmMNCmluZGV4IDE5NWE3ZDkw
M2NlYy4uNmZkNmQ1MzU2MjQ2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3R4LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl90eC5jDQpAQCAtMzAxLDYgKzMwMSw3IEBAIG1seDVlX3R4d3FlX2Nv
bXBsZXRlKHN0cnVjdCBtbHg1ZV90eHFzcSAqc3EsIHN0cnVjdCBza19idWZmICpza2IsDQogCQkg
ICAgIGJvb2wgeG1pdF9tb3JlKQ0KIHsNCiAJc3RydWN0IG1seDVfd3FfY3ljICp3cSA9ICZzcS0+
d3E7DQorCWJvb2wgc2VuZF9kb29yYmVsbDsNCiANCiAJd2ktPm51bV9ieXRlcyA9IG51bV9ieXRl
czsNCiAJd2ktPm51bV9kbWEgPSBudW1fZG1hOw0KQEAgLTMxMCw4ICszMTEsNiBAQCBtbHg1ZV90
eHdxZV9jb21wbGV0ZShzdHJ1Y3QgbWx4NWVfdHhxc3EgKnNxLCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LA0KIAljc2VnLT5vcG1vZF9pZHhfb3Bjb2RlID0gY3B1X3RvX2JlMzIoKHNxLT5wYyA8PCA4KSB8
IG9wY29kZSk7DQogCWNzZWctPnFwbl9kcyAgICAgICAgICAgPSBjcHVfdG9fYmUzMigoc3EtPnNx
biA8PCA4KSB8IGRzX2NudCk7DQogDQotCW5ldGRldl90eF9zZW50X3F1ZXVlKHNxLT50eHEsIG51
bV9ieXRlcyk7DQotDQogCWlmICh1bmxpa2VseShza2Jfc2hpbmZvKHNrYiktPnR4X2ZsYWdzICYg
U0tCVFhfSFdfVFNUQU1QKSkNCiAJCXNrYl9zaGluZm8oc2tiKS0+dHhfZmxhZ3MgfD0gU0tCVFhf
SU5fUFJPR1JFU1M7DQogDQpAQCAtMzIxLDcgKzMyMCw5IEBAIG1seDVlX3R4d3FlX2NvbXBsZXRl
KHN0cnVjdCBtbHg1ZV90eHFzcSAqc3EsIHN0cnVjdCBza19idWZmICpza2IsDQogCQlzcS0+c3Rh
dHMtPnN0b3BwZWQrKzsNCiAJfQ0KIA0KLQlpZiAoIXhtaXRfbW9yZSB8fCBuZXRpZl94bWl0X3N0
b3BwZWQoc3EtPnR4cSkpDQorCXNlbmRfZG9vcmJlbGwgPSBfX25ldGRldl90eF9zZW50X3F1ZXVl
KHNxLT50eHEsIG51bV9ieXRlcywNCisJCQkJCSAgICAgICB4bWl0X21vcmUpOw0KKwlpZiAoc2Vu
ZF9kb29yYmVsbCkNCiAJCW1seDVlX25vdGlmeV9odyh3cSwgc3EtPnBjLCBzcS0+dWFyX21hcCwg
Y3NlZyk7DQogfQ0KIA0KLS0gDQoyLjIxLjANCg0K
