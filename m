Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88605A6F8
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfF1WgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:12 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbfF1WgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=OBfq5Hg71B3Ngw9t4qy8xQ5DnpS2JZSGOkTdGIHHmQM033pPH+OTNXu1hxVX7AwyQGseui50G14dTOlywqfTc4WQ4wrJN0XRr7BTImdh/xSn7fkRyb/6wlusNeDPbr7h9zf877z7j7JnlDf4FluTsNhhPwC4WyxA8vIHJYjtd7I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbSTFJweQn4pGeJuORCcT/sSXhaumxawXutaOsQFECE=;
 b=Oy3zujqswkTPGUF0DV+jDa9jaTxb2SnN9GN2eMt1btPz27I0d+rG6Amf6HeFSB6qKuf/0MNOc4z9tmx4v5wYlM3fuD3YHj+c+5F86zx/uc1DAD4Mbqxzh8GndL/T8kvaz8lOpxZwtH7f6Z1Qj0BIik5T8gTcP0Bza1DdSch+x5U=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbSTFJweQn4pGeJuORCcT/sSXhaumxawXutaOsQFECE=;
 b=HxaxdtNuAYd6lj0hYi9oVc3LPc1+r/N+mWj9QskzxXr5lAWPl0sMdk5kp6jzbnTQKF6k0UZB0mndJZBNHVcBab6kgsW8z3AN4pt2aXrbJ3ZNS9qAzVFTf7uJ8t5z7rFnZLICVLzCLv7cHuhf/hNu/u3BaRcmzFDjO2rLrRQ3e80=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:00 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 07/18] net/mlx5: Move pci status reg access mutex to
 mlx5_pci_init
Thread-Topic: [PATCH mlx5-next 07/18] net/mlx5: Move pci status reg access
 mutex to mlx5_pci_init
Thread-Index: AQHVLgHcIjdqWZXYWEyYVoYbblAD3w==
Date:   Fri, 28 Jun 2019 22:36:00 +0000
Message-ID: <20190628223516.9368-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c9337044-d305-4702-7a35-08d6fc18fe6d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357D1EF16C0F92704F112ABBEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j3QYPqAehWuhxFaI/xwbLdS7sMEsg549inpmyMgmjAi+v3cSN4iFCYn308RKs/XrMO0yxB8tZeWJjlmUyBkMg21WbaXBLrE+qnEK9kYZlXO7xIvTbUo2ZtG/SCnPRq7oT5pE3rhQiOkeMsQP6PKrK8IIAuSXnGi/1sdPelHxHRH5IvybR7OcoVmZIsOSYhEnYNYEtcICLj4mROzxySKaLt11KcoLECugHQPD7uIFHwcP/coY/esHYaNWr0EvPZmKPBOKchT6PAUFAhgn1vCvfd6c31/GtWThd8F1D5N0Ba6kpWpPTxTTHPzZy3iKbbiVCkv0/KSbsj0vK+0nkHTnDt6e42EUcnGEXP+1tYU9DwyC3TAfrPwxEImljlHUSZtn/fsF8/2Tdkk0XUjO9mZMMHf3jg/pqiJizQqqNNCywiw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9337044-d305-4702-7a35-08d6fc18fe6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:00.2560
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

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCm1seDVfcGNpX2luaXQo
KSBwZXJmb3JtcyBwY2kgc3BlY2lmaWMgaW5pdGlhbGl6YXRpb24gb2YgdGhlDQptbHg1X2NvcmVf
ZGV2IHN0cnVjdC4NCkhlbmNlIG1vdmUgcGNpX3N0YXR1c19tdXRleCB0byBwY2kgaW5pdGlhbGl6
YXRpb24gcm91dGluZQ0KbWx4NV9wY2lfaW5pdCgpLg0KVGhpcyBhbGxvd3MgcmV1c2luZyBtbHg1
X21kZXZfaW5pdCgpIHRvIG5vbiBQQ0kgZGV2aWNlcy4NCg0KU2lnbmVkLW9mZi1ieTogUGFyYXYg
UGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVnUgUGhhbSA8dnVodW9u
Z0BtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9tYWluLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21h
aW4uYw0KaW5kZXggZTVmOWRmN2Y3ZTM0Li4xMGY3MmI4OWFjOGUgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQpAQCAtNzMxLDYgKzczMSw3
IEBAIHN0YXRpYyBpbnQgbWx4NV9wY2lfaW5pdChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBz
dHJ1Y3QgcGNpX2RldiAqcGRldiwNCiAJc3RydWN0IG1seDVfcHJpdiAqcHJpdiA9ICZkZXYtPnBy
aXY7DQogCWludCBlcnIgPSAwOw0KIA0KKwltdXRleF9pbml0KCZkZXYtPnBjaV9zdGF0dXNfbXV0
ZXgpOw0KIAlwY2lfc2V0X2RydmRhdGEoZGV2LT5wZGV2LCBkZXYpOw0KIA0KIAlkZXYtPmJhcl9h
ZGRyID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIDApOw0KQEAgLTEyNTYsNyArMTI1Nyw2IEBA
IHN0YXRpYyBpbnQgbWx4NV9tZGV2X2luaXQoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgaW50
IHByb2ZpbGVfaWR4KQ0KIA0KIAlJTklUX0xJU1RfSEVBRCgmcHJpdi0+Y3R4X2xpc3QpOw0KIAlz
cGluX2xvY2tfaW5pdCgmcHJpdi0+Y3R4X2xvY2spOw0KLQltdXRleF9pbml0KCZkZXYtPnBjaV9z
dGF0dXNfbXV0ZXgpOw0KIAltdXRleF9pbml0KCZkZXYtPmludGZfc3RhdGVfbXV0ZXgpOw0KIA0K
IAltdXRleF9pbml0KCZwcml2LT5iZnJlZ3MucmVnX2hlYWQubG9jayk7DQotLSANCjIuMjEuMA0K
DQo=
