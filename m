Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65475A700
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfF1WgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:24 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbfF1WgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=LamMfPB22cehe3WJMBO3U7tNIs21OJuIK3LzbzyuQp07YQhqf8KvJ65N7Dz0UVGm2qL7OqbI3fvySNq+2Leuxkzi8NGRUizK7VDwH7fX+Ne38p38eW3IVi55nQ4qUBOB9PQQbroccb7qv/Gpvy5H1GbIpksT2dluyGVtFuIUxko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4K/tP+b6qVXoZGbmUPUmCZolttiFsCU/dncLkXy8Cc=;
 b=mE36YCRem3Z4CV00icNto0BW8A1KlHWUhYEoKXyeGkNqwdXMoHz9XXIBlOIiENW6Mo+Sv7yITALWs67/OqqL999787DWfWGTQ4EDiUkb/3ugjdEGoxppSGNkcP32iEzmmMB9Mbo5dw71gNOOrLsKjVW/ZIT5LEHzFGEIxbCVhxA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4K/tP+b6qVXoZGbmUPUmCZolttiFsCU/dncLkXy8Cc=;
 b=E1kfa52nPFf6aCQR6FO5UFeCrcezNQvwamtBQ1VAcBb6QoV3OL3e2EyTLbaM7HNL2j1WnJ58w6qDjeNmlii77sQNvdkaZHIbViZEWr6LiPc/qXvCTKr794wVPKVqPH/MmlvJQwE7Y+FPVB8awZ2GlyrmgSfwG2LYXmlKbdFUsuI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:11 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>
Subject: [PATCH mlx5-next 11/18] net/mlx5: E-Switch, Use correct flags when
 configuring vlan
Thread-Topic: [PATCH mlx5-next 11/18] net/mlx5: E-Switch, Use correct flags
 when configuring vlan
Thread-Index: AQHVLgHjjELg/LtMwUmpzyt2KoFuqg==
Date:   Fri, 28 Jun 2019 22:36:11 +0000
Message-ID: <20190628223516.9368-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f37ac385-e87a-48e2-6135-08d6fc190374
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB23573BC004308F21148B6155BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:173;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8Mgsh8fmbU5JMhwZLPsGLW92QroO6bsU3plj+8TuX8pQiqRv8f0vkkQoGKjuSuxphGx9iXBEy/9Fii12OLYGMJre1M6DPKLCtkRjViOlQjH/qvK4T/VYDyvm4xi76KYNDk3MbqXUI6BdV2DzNwvTmmZ0i/HD5K8eyCttO2SlLddqmFTA28qskykC8mzkPs74Aj8DAC9+z42MY5A7tJVLIltXGzEFrxChknMr4QwEceUMOVsBfGa3fdn/VkORb5CfFEtlaYioUj2QPNDAv1u5iSU75eiI5GF/dlsizWI249Aq/OeVOPDMhb6/cw/eyeBHTeqTagmmTJaF/T/m0/AvYW68eKAVJc+c/X6Aag8L4BejMSyw6p05ZgiP7MU5/37+m6N9oWNYgeayjTTJZEMULAM+P86Om2cJ5FmTkqzp/IE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37ac385-e87a-48e2-6135-08d6fc190374
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:11.6642
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

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCkJlZm9yZSB0aGUgb2Zm
ZW5kaW5nIGNvbW1pdCwgdmxhbiB3aWxsIGJlIGNvbmZpZ3VyZWQgaWYgZWl0aGVyIHZsYW4NCm9y
IHFvcyBpcyBzZXQuIEFmdGVyIHRoZSBjaGFuZ2Ugd2l0aCBuZXcgc2V0IGZsYWdzLCBmdW5jdGlv
biBjYWxsZXJzDQpzaG91bGQgcHJvdmlkZSBmbGFncyBhY2NvcmRpbmdseS4NCg0KRml4ZXM6IGUz
M2RmZTMxNmNmMyAoIm5ldC9tbHg1OiBFLVN3aXRjaCwgQWxsb3cgZmluZSB0dW5pbmcgb2YgZXN3
aXRjaCB2cG9ydCBwdXNoL3BvcCB2bGFuIikNClNpZ25lZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxi
b2RvbmdAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVk
bUBtZWxsYW5veC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZXN3aXRjaC5jIHwgNSArKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZXN3aXRjaC5jDQppbmRleCA2NzU5ODI3MmQ0YTkuLjBjNzUyMTlkOTFiNSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoLmMNCkBAIC0xNTUzLDYgKzE1NTMsNyBAQCBzdGF0aWMgdm9pZCBlc3dfYXBwbHlfdnBvcnRf
Y29uZihzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQogCQkJCSBzdHJ1Y3QgbWx4NV92cG9ydCAq
dnBvcnQpDQogew0KIAlpbnQgdnBvcnRfbnVtID0gdnBvcnQtPnZwb3J0Ow0KKwlpbnQgZmxhZ3M7
DQogDQogCWlmIChlc3ctPm1hbmFnZXJfdnBvcnQgPT0gdnBvcnRfbnVtKQ0KIAkJcmV0dXJuOw0K
QEAgLTE1NzAsOCArMTU3MSwxMCBAQCBzdGF0aWMgdm9pZCBlc3dfYXBwbHlfdnBvcnRfY29uZihz
dHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQogCQkJCQkJdnBvcnQtPmluZm8ubm9kZV9ndWlkKTsN
CiAJfQ0KIA0KKwlmbGFncyA9ICh2cG9ydC0+aW5mby52bGFuIHx8IHZwb3J0LT5pbmZvLnFvcykg
Pw0KKwkJU0VUX1ZMQU5fU1RSSVAgfCBTRVRfVkxBTl9JTlNFUlQgOiAwOw0KIAltb2RpZnlfZXN3
X3Zwb3J0X2N2bGFuKGVzdy0+ZGV2LCB2cG9ydF9udW0sIHZwb3J0LT5pbmZvLnZsYW4sIHZwb3J0
LT5pbmZvLnFvcywNCi0JCQkgICAgICAgKHZwb3J0LT5pbmZvLnZsYW4gfHwgdnBvcnQtPmluZm8u
cW9zKSk7DQorCQkJICAgICAgIGZsYWdzKTsNCiANCiAJLyogT25seSBsZWdhY3kgbW9kZSBuZWVk
cyBBQ0xzICovDQogCWlmIChlc3ctPm1vZGUgPT0gU1JJT1ZfTEVHQUNZKSB7DQotLSANCjIuMjEu
MA0KDQo=
