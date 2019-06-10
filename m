Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E503C001
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbfFJXie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:34 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:50500
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390795AbfFJXid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ktb7SWubDbI9jo2eHmQirqzpYUpiyAe6rZWCLQV0gSc=;
 b=Caoc0Mm2JAgqXpM69Rizl4fEmaDEX3ritOAlcn9Bse63BCtloent9HZGuOSMleY6ji34jGtsr0SyCXuFyVoDYaaYYtIh24A0D++wldhOQ9zcTGbSlS+9Zk0CYyl95ATQz9GZeVL8PaUZoHg0hkg7zyZZm6dLNR+3PtwGrFd5DJI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:21 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 05/16] net/mlx5: Introduce EQ polling budget
Thread-Topic: [PATCH mlx5-next 05/16] net/mlx5: Introduce EQ polling budget
Thread-Index: AQHVH+WWJ+r8qSckw0SkZttARVn9TQ==
Date:   Mon, 10 Jun 2019 23:38:21 +0000
Message-ID: <20190610233733.12155-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 51aa1d8f-2a1d-4620-1a6e-08d6edfcb91a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB216656DEBB120C2B4F93EA3CBE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(450100002)(85306007)(53936002)(6512007)(14454004)(50226002)(2616005)(186003)(256004)(81166006)(486006)(6436002)(11346002)(8676002)(8936002)(25786009)(476003)(14444005)(52116002)(446003)(2906002)(478600001)(99286004)(81156014)(4326008)(6486002)(107886003)(71200400001)(5660300002)(66446008)(64756008)(305945005)(66946007)(386003)(6506007)(7736002)(26005)(76176011)(71190400001)(102836004)(66476007)(86362001)(73956011)(66556008)(110136005)(6636002)(36756003)(54906003)(3846002)(6116002)(316002)(1076003)(66066001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WasqmzpOuiEbd9HHkMJsi2weOjJDBWoewYdcgJoyuOEZsI8nGtmKjbwaGtpmCt7mbWPkeCJoh5Iq64VKBFFPHJMRaEhbLDLm1ylA/vLStj0B/4u/7X9ZGN+A0nAsho2FnvWf23gMbK6rid7muOP/NZAbWUeIxu7xz6M0Wb1GY3OIV3S/aSXzXiKVbLvcrWdyfciTKORTRSQcbmGJf1eQ4NJKchKK75XlZ3ehPjiYBCeoV0sjubCmm24Gs2RZJbL/g8v4VKwzIthoklft4qnLgP/45/BXuL6GKlSe6Uqiutm4+0uW7GFL4klbk9KhjofjMIkrgpxvXjnxzrVj6knxGJvFgGkkObw25JcABClNDpkDu+loxYZmYGxsKymUQE3qmuPxl/JGmH0ttbS097Sx0yCuly3KBwhk1taZ4nvJY70=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51aa1d8f-2a1d-4620-1a6e-08d6edfcb91a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:21.5893
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

RnJvbTogWXV2YWwgQXZuZXJ5IDx5dXZhbGF2QG1lbGxhbm94LmNvbT4NCg0KTXVsdGlwbGUgRVFz
IG1heSBzaGFyZSB0aGUgc2FtZSBpcnEgaW4gc3Vic2VxdWVudCBwYXRjaGVzLg0KVG8gYXZvaWQg
c3RhcnZhdGlvbiwgYSBidWRnZXQgaXMgc2V0IHBlciBFUSdzIGludGVycnVwdCBoYW5kbGVyLg0K
DQpCZWNhdXNlIG9mIHRoaXMgY2hhbmdlLCBpdCBpcyBubyBsb25nZXIgcmVxdWlyZWQgdG8gY2hl
Y2sgdGhhdA0KTUxYNV9OVU1fU1BBUkVfRVFFIGVxZXMgd2VyZSBwb2xsZWQgKHRvIGRldGVjdCB0
aGF0IGFybSBpcyByZXF1aXJlZCkuDQpJdCBpcyBndWFyYW50ZWVkIHRoYXQgTUxYNV9OVU1fU1BB
UkVfRVFFID4gYnVkZ2V0LCB0aGVyZWZvcmUgdGhlDQpoYW5kbGVyIHdpbGwgYXJtIGFuZCBleGl0
IHRoZSBoYW5kbGVyIGJlZm9yZSBhbGwgdGhlIGVudHJpZXMgaW4gdGhlDQplcSBhcmUgcG9sbGVk
Lg0KDQpJbiB0aGUgc2NlbmFyaW8gd2hlcmUgdGhlIGhhbmRsZXIgaXMgb3V0IG9mIGJ1ZGdldCBh
bmQgdGhlcmUgYXJlIG1vcmUNCkVRRXMgdG8gcG9sbCwgYXJtaW5nIHRoZSBFUSBndWFyYW50ZWVz
IHRoYXQgdGhlIEhXIHdpbGwgc2VuZCBhbm90aGVyDQppbnRlcnJ1cHQgYW5kIHRoZSBoYW5kbGVy
IHdpbGwgYmUgY2FsbGVkIGFnYWluLg0KDQpTaWduZWQtb2ZmLWJ5OiBZdXZhbCBBdm5lcnkgPHl1
dmFsYXZAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVs
bGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5v
eC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEu
YyB8IDU1ICsrKysrKysrKystLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlv
bnMoKyksIDI4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VxLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZXEuYw0KaW5kZXggNWU5MzE5ZDNkOTBjLi4yOGRlZmVhY2E4MGEgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VxLmMNCkBAIC02MSw2
ICs2MSwxNiBAQCBlbnVtIHsNCiAJTUxYNV9FUV9ET09SQkVMX09GRlNFVAk9IDB4NDAsDQogfTsN
CiANCisvKiBidWRnZXQgbXVzdCBiZSBzbWFsbGVyIHRoYW4gTUxYNV9OVU1fU1BBUkVfRVFFIHRv
IGd1YXJhbnRlZSB0aGF0IHdlIHVwZGF0ZQ0KKyAqIHRoZSBjaSBiZWZvcmUgd2UgcG9sbGVkIGFs
bCB0aGUgZW50cmllcyBpbiB0aGUgRVEuIE1MWDVfTlVNX1NQQVJFX0VRRSBpcw0KKyAqIHVzZWQg
dG8gc2V0IHRoZSBFUSBzaXplLCBidWRnZXQgbXVzdCBiZSBzbWFsbGVyIHRoYW4gdGhlIEVRIHNp
emUuDQorICovDQorZW51bSB7DQorCU1MWDVfRVFfUE9MTElOR19CVURHRVQJPSAxMjgsDQorfTsN
CisNCitzdGF0aWNfYXNzZXJ0KE1MWDVfRVFfUE9MTElOR19CVURHRVQgPD0gTUxYNV9OVU1fU1BB
UkVfRVFFKTsNCisNCiBzdHJ1Y3QgbWx4NV9pcnFfaW5mbyB7DQogCWNwdW1hc2tfdmFyX3QgbWFz
azsNCiAJY2hhciBuYW1lW01MWDVfTUFYX0lSUV9OQU1FXTsNCkBAIC0xMjksMTEgKzEzOSwxNiBA
QCBzdGF0aWMgaXJxcmV0dXJuX3QgbWx4NV9lcV9jb21wX2ludChpbnQgaXJxLCB2b2lkICplcV9w
dHIpDQogCXN0cnVjdCBtbHg1X2VxX2NvbXAgKmVxX2NvbXAgPSBlcV9wdHI7DQogCXN0cnVjdCBt
bHg1X2VxICplcSA9IGVxX3B0cjsNCiAJc3RydWN0IG1seDVfZXFlICplcWU7DQotCWludCBzZXRf
Y2kgPSAwOw0KKwlpbnQgbnVtX2VxZXMgPSAwOw0KIAl1MzIgY3FuID0gLTE7DQogDQotCXdoaWxl
ICgoZXFlID0gbmV4dF9lcWVfc3coZXEpKSkgew0KKwllcWUgPSBuZXh0X2VxZV9zdyhlcSk7DQor
CWlmICghZXFlKQ0KKwkJZ290byBvdXQ7DQorDQorCWRvIHsNCiAJCXN0cnVjdCBtbHg1X2NvcmVf
Y3EgKmNxOw0KKw0KIAkJLyogTWFrZSBzdXJlIHdlIHJlYWQgRVEgZW50cnkgY29udGVudHMgYWZ0
ZXIgd2UndmUNCiAJCSAqIGNoZWNrZWQgdGhlIG93bmVyc2hpcCBiaXQuDQogCQkgKi8NCkBAIC0x
NTEsMjAgKzE2NiwxMCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgbWx4NV9lcV9jb21wX2ludChpbnQg
aXJxLCB2b2lkICplcV9wdHIpDQogCQl9DQogDQogCQkrK2VxLT5jb25zX2luZGV4Ow0KLQkJKytz
ZXRfY2k7DQogDQotCQkvKiBUaGUgSENBIHdpbGwgdGhpbmsgdGhlIHF1ZXVlIGhhcyBvdmVyZmxv
d2VkIGlmIHdlDQotCQkgKiBkb24ndCB0ZWxsIGl0IHdlJ3ZlIGJlZW4gcHJvY2Vzc2luZyBldmVu
dHMuICBXZQ0KLQkJICogY3JlYXRlIG91ciBFUXMgd2l0aCBNTFg1X05VTV9TUEFSRV9FUUUgZXh0
cmENCi0JCSAqIGVudHJpZXMsIHNvIHdlIG11c3QgdXBkYXRlIG91ciBjb25zdW1lciBpbmRleCBh
dA0KLQkJICogbGVhc3QgdGhhdCBvZnRlbi4NCi0JCSAqLw0KLQkJaWYgKHVubGlrZWx5KHNldF9j
aSA+PSBNTFg1X05VTV9TUEFSRV9FUUUpKSB7DQotCQkJZXFfdXBkYXRlX2NpKGVxLCAwKTsNCi0J
CQlzZXRfY2kgPSAwOw0KLQkJfQ0KLQl9DQorCX0gd2hpbGUgKCgrK251bV9lcWVzIDwgTUxYNV9F
UV9QT0xMSU5HX0JVREdFVCkgJiYgKGVxZSA9IG5leHRfZXFlX3N3KGVxKSkpOw0KIA0KK291dDoN
CiAJZXFfdXBkYXRlX2NpKGVxLCAxKTsNCiANCiAJaWYgKGNxbiAhPSAtMSkNCkBAIC0xOTcsMTIg
KzIwMiwxNiBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgbWx4NV9lcV9hc3luY19pbnQoaW50IGlycSwg
dm9pZCAqZXFfcHRyKQ0KIAlzdHJ1Y3QgbWx4NV9lcV90YWJsZSAqZXF0Ow0KIAlzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2Ow0KIAlzdHJ1Y3QgbWx4NV9lcWUgKmVxZTsNCi0JaW50IHNldF9jaSA9
IDA7DQorCWludCBudW1fZXFlcyA9IDA7DQogDQogCWRldiA9IGVxLT5kZXY7DQogCWVxdCA9IGRl
di0+cHJpdi5lcV90YWJsZTsNCiANCi0Jd2hpbGUgKChlcWUgPSBuZXh0X2VxZV9zdyhlcSkpKSB7
DQorCWVxZSA9IG5leHRfZXFlX3N3KGVxKTsNCisJaWYgKCFlcWUpDQorCQlnb3RvIG91dDsNCisN
CisJZG8gew0KIAkJLyoNCiAJCSAqIE1ha2Ugc3VyZSB3ZSByZWFkIEVRIGVudHJ5IGNvbnRlbnRz
IGFmdGVyIHdlJ3ZlDQogCQkgKiBjaGVja2VkIHRoZSBvd25lcnNoaXAgYml0Lg0KQEAgLTIxNywy
MCArMjI2LDEwIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBtbHg1X2VxX2FzeW5jX2ludChpbnQgaXJx
LCB2b2lkICplcV9wdHIpDQogCQlhdG9taWNfbm90aWZpZXJfY2FsbF9jaGFpbigmZXF0LT5uaFtN
TFg1X0VWRU5UX1RZUEVfTk9USUZZX0FOWV0sIGVxZS0+dHlwZSwgZXFlKTsNCiANCiAJCSsrZXEt
PmNvbnNfaW5kZXg7DQotCQkrK3NldF9jaTsNCiANCi0JCS8qIFRoZSBIQ0Egd2lsbCB0aGluayB0
aGUgcXVldWUgaGFzIG92ZXJmbG93ZWQgaWYgd2UNCi0JCSAqIGRvbid0IHRlbGwgaXQgd2UndmUg
YmVlbiBwcm9jZXNzaW5nIGV2ZW50cy4gIFdlDQotCQkgKiBjcmVhdGUgb3VyIEVRcyB3aXRoIE1M
WDVfTlVNX1NQQVJFX0VRRSBleHRyYQ0KLQkJICogZW50cmllcywgc28gd2UgbXVzdCB1cGRhdGUg
b3VyIGNvbnN1bWVyIGluZGV4IGF0DQotCQkgKiBsZWFzdCB0aGF0IG9mdGVuLg0KLQkJICovDQot
CQlpZiAodW5saWtlbHkoc2V0X2NpID49IE1MWDVfTlVNX1NQQVJFX0VRRSkpIHsNCi0JCQllcV91
cGRhdGVfY2koZXEsIDApOw0KLQkJCXNldF9jaSA9IDA7DQotCQl9DQotCX0NCisJfSB3aGlsZSAo
KCsrbnVtX2VxZXMgPCBNTFg1X0VRX1BPTExJTkdfQlVER0VUKSAmJiAoZXFlID0gbmV4dF9lcWVf
c3coZXEpKSk7DQogDQorb3V0Og0KIAllcV91cGRhdGVfY2koZXEsIDEpOw0KIA0KIAlyZXR1cm4g
SVJRX0hBTkRMRUQ7DQotLSANCjIuMjEuMA0KDQo=
