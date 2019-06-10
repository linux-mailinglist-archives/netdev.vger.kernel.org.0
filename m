Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942CF3C00A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbfFJXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:49 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:22416
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390832AbfFJXis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4joKeCgBS/w/71u21Vs8zAYddu081lXIQFrKW16rew=;
 b=n6Bjp7Jhjf2yO6WoNTBL2I6pnJDMgKvJLnWa+wmv2gG5hYQuW7m917i1qtHyOpud+7+RlQjjUjXhv6kCO57cYKLXxdI755HfMWjVjXVPfoVA5PiktOa+CAOVZewrI/bxWtXFGt5i6qZP6zVf80Mk06ki4VEMk2dpVDpIvaJ60LI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:31 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 10/16] net/mlx5: Move IRQ affinity set to IRQ
 allocation phase
Thread-Topic: [PATCH mlx5-next 10/16] net/mlx5: Move IRQ affinity set to IRQ
 allocation phase
Thread-Index: AQHVH+WcWhZCPK4KqE2wRVnlZx+FeA==
Date:   Mon, 10 Jun 2019 23:38:30 +0000
Message-ID: <20190610233733.12155-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5012e644-aaf8-4f52-c383-08d6edfcbe84
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB2166E9D4B460649D76A4C572BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(450100002)(85306007)(53936002)(6512007)(14454004)(50226002)(2616005)(186003)(256004)(81166006)(486006)(6436002)(11346002)(8676002)(8936002)(25786009)(476003)(14444005)(52116002)(446003)(2906002)(478600001)(99286004)(81156014)(4326008)(6486002)(107886003)(71200400001)(5660300002)(66446008)(64756008)(305945005)(66946007)(386003)(6506007)(7736002)(26005)(76176011)(71190400001)(102836004)(66476007)(86362001)(73956011)(66556008)(110136005)(6636002)(36756003)(54906003)(3846002)(6116002)(316002)(1076003)(66066001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y+3GuvxGBsbgt+I5HJW3UjXCYMiivZ2Kqi22AomTdcvoZ/8AcwCBMkuiM5nDsE+7n/5Mg3bqiafXrQiD8OwHy/g7Xs6v95cdFzS3RhKaxmxjfR9ixpWGCjG5nnbS8bhMP+qjUPQ/wncGzyhpsZPKgYK8DknNjZjcAkSbvJO8CQb8f7/72IvmxA6vle08O6LyFPPpGL3G2HnzyThEIL1J34ysXvFLsPW/qukGcNjri2llhP+Jom6Big9sjsXsVm7o4IKdoIqkm1x86qnt+JclW6R6hBFREYvC+JbCC9sqnxVNiBPL0LADhI2r95xytilK5vNIgtAA7bAQhpEmw3x5cKdpMDfbtgQn9E4hjvtH/lpfpUz2soj2aik1zGWWzqHlHjrbOXH7dUvt7H/h26RY8xIeyEpR0q++g5HyaJW4eiw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5012e644-aaf8-4f52-c383-08d6edfcbe84
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:30.8741
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

RnJvbTogWXV2YWwgQXZuZXJ5IDx5dXZhbGF2QG1lbGxhbm94LmNvbT4NCg0KQWZmaW5pdHkgc2V0
L2NsZWFyIGlzIHBhcnQgb2YgdGhlIElSUSBsaWZlLWN5Y2xlLg0KDQpTaWduZWQtb2ZmLWJ5OiBZ
dXZhbCBBdm5lcnkgPHl1dmFsYXZAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFBhcmF2IFBh
bmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZXEuYyB8IDI1ICsrKysrKysrKysrKystLS0tLS0tDQogMSBmaWxlIGNoYW5n
ZWQsIDE3IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jDQppbmRleCAxZWE5ODNjMWVjMDUuLmQzMGJk
MDFjZjA1MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lcS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZXEuYw0KQEAgLTkzNCw4ICs5MzQsNiBAQCBzdGF0aWMgdm9pZCBkZXN0cm95X2NvbXBfZXFzKHN0
cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogCXN0cnVjdCBtbHg1X2VxX3RhYmxlICp0YWJsZSA9
IGRldi0+cHJpdi5lcV90YWJsZTsNCiAJc3RydWN0IG1seDVfZXFfY29tcCAqZXEsICpuOw0KIA0K
LQljbGVhcl9jb21wX2lycXNfYWZmaW5pdHlfaGludHMoZGV2KTsNCi0NCiAJbGlzdF9mb3JfZWFj
aF9lbnRyeV9zYWZlKGVxLCBuLCAmdGFibGUtPmNvbXBfZXFzX2xpc3QsIGxpc3QpIHsNCiAJCWxp
c3RfZGVsKCZlcS0+bGlzdCk7DQogCQlpZiAoZGVzdHJveV91bm1hcF9lcShkZXYsICZlcS0+Y29y
ZSkpDQpAQCAtOTkxLDEyICs5ODksNiBAQCBzdGF0aWMgaW50IGNyZWF0ZV9jb21wX2VxcyhzdHJ1
Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAkJbGlzdF9hZGRfdGFpbCgmZXEtPmxpc3QsICZ0YWJs
ZS0+Y29tcF9lcXNfbGlzdCk7DQogCX0NCiANCi0JZXJyID0gc2V0X2NvbXBfaXJxX2FmZmluaXR5
X2hpbnRzKGRldik7DQotCWlmIChlcnIpIHsNCi0JCW1seDVfY29yZV9lcnIoZGV2LCAiRmFpbGVk
IHRvIGFsbG9jIGFmZmluaXR5IGhpbnQgY3B1bWFza1xuIik7DQotCQlnb3RvIGNsZWFuOw0KLQl9
DQotDQogCXJldHVybiAwOw0KIA0KIGNsZWFuOg0KQEAgLTEwNzgsNiArMTA3MCwxNiBAQCB2b2lk
IG1seDVfY29yZV9lcV9mcmVlX2lycXMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCiAJcGNp
X2ZyZWVfaXJxX3ZlY3RvcnMoZGV2LT5wZGV2KTsNCiB9DQogDQorc3RhdGljIHZvaWQgdW5yZXF1
ZXN0X2lycXMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCit7DQorCXN0cnVjdCBtbHg1X2ly
cV90YWJsZSAqdGFibGUgPSBkZXYtPnByaXYuaXJxX3RhYmxlOw0KKwlpbnQgaTsNCisNCisJZm9y
IChpID0gMDsgaSA8IHRhYmxlLT5udmVjOyBpKyspDQorCQlmcmVlX2lycShwY2lfaXJxX3ZlY3Rv
cihkZXYtPnBkZXYsIGkpLA0KKwkJCSAmbWx4NV9pcnFfZ2V0KGRldiwgaSktPm5oKTsNCit9DQor
DQogc3RhdGljIGludCBhbGxvY19pcnFfdmVjdG9ycyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2
KQ0KIHsNCiAJc3RydWN0IG1seDVfcHJpdiAqcHJpdiA9ICZkZXYtPnByaXY7DQpAQCAtMTExNSw4
ICsxMTE3LDE0IEBAIHN0YXRpYyBpbnQgYWxsb2NfaXJxX3ZlY3RvcnMoc3RydWN0IG1seDVfY29y
ZV9kZXYgKmRldikNCiAJaWYgKGVycikNCiAJCWdvdG8gZXJyX3JlcXVlc3RfaXJxczsNCiANCisJ
ZXJyID0gc2V0X2NvbXBfaXJxX2FmZmluaXR5X2hpbnRzKGRldik7DQorCWlmIChlcnIpDQorCQln
b3RvIGVycl9zZXRfYWZmaW5pdHk7DQorDQogCXJldHVybiAwOw0KIA0KK2Vycl9zZXRfYWZmaW5p
dHk6DQorCXVucmVxdWVzdF9pcnFzKGRldik7DQogZXJyX3JlcXVlc3RfaXJxczoNCiAJaXJxX2Ns
ZWFyX3JtYXAoZGV2KTsNCiBlcnJfc2V0X3JtYXA6DQpAQCAtMTEzNiw2ICsxMTQ0LDcgQEAgc3Rh
dGljIHZvaWQgZnJlZV9pcnFfdmVjdG9ycyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAkg
KiB3aGljaCBzaG91bGQgYmUgY2FsbGVkIGFmdGVyIGFsbG9jX2lycSBidXQgYmVmb3JlIHJlcXVl
c3RfaXJxLg0KIAkgKi8NCiAJaXJxX2NsZWFyX3JtYXAoZGV2KTsNCisJY2xlYXJfY29tcF9pcnFz
X2FmZmluaXR5X2hpbnRzKGRldik7DQogCWZvciAoaSA9IDA7IGkgPCB0YWJsZS0+bnZlYzsgaSsr
KQ0KIAkJZnJlZV9pcnEocGNpX2lycV92ZWN0b3IoZGV2LT5wZGV2LCBpKSwNCiAJCQkgJm1seDVf
aXJxX2dldChkZXYsIGkpLT5uaCk7DQotLSANCjIuMjEuMA0KDQo=
