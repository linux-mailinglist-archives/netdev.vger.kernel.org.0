Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CCF5A6F6
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfF1WgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:09 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbfF1WgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=UxSEbw0ofDOQI2XWEAmSSgBV1YOlkS4pYqVy+TU8COk2BgE8yTCw1H9zFuz4XYpDnSjQCerj0V3HybpK/d1rKw2t+VvY43CnRqkLfBfm40HLWTFbp6bckjN9W2IHtUfDKacjkuCS534ABT9979qTp3fRMrz4R5J+BJtbVFZAv8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ+uCPUzHLJNEY4ko/vvh8JMZUWh02qkbmS68vqidB4=;
 b=RnQNf5/Cn/mtPLnBDb9zrT0dOJvDbdpHFrpnmP+hN7llJahITeY45LZHm9YhEBpJZazZtg08oDKrhR3fbb6HoXGL7947tw8H5MVXhI7IeEPAnXuPiKXXqXrVnRuMpwD6wXzRhP2Wy0a/C08U+nRlRezi+32oURnkqQmx12+8S50=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ+uCPUzHLJNEY4ko/vvh8JMZUWh02qkbmS68vqidB4=;
 b=rZfG0ga6RVWsMMm1XlBFH4MvYshRHsVxhQyQp5IzYyq/xK8AaBPg2jl+qlyPEh4RZTg832UJsJFskTXleuNrQUJijzoOmBfHK994PBNmxBEXOFJyF6yFBKMBRIILb/6lItuiEt4GYgvYHkrcyGQGpiI47+XlVt7BjnbenUuBThw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 05/18] RDMA/mlx5: Cleanup rep when doing unload
Thread-Topic: [PATCH mlx5-next 05/18] RDMA/mlx5: Cleanup rep when doing unload
Thread-Index: AQHVLgHZomX2Wz/SpE6y8RkMDT1zag==
Date:   Fri, 28 Jun 2019 22:35:55 +0000
Message-ID: <20190628223516.9368-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2253c2e2-8835-42b7-360c-08d6fc18fbf0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB235731E2C4A51753EF3B448FBEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OwYZRE0LwElWhHs+1PmHNeeW0bcpqCBWw0J/VV4Cj+pmSS7XBTw9NTVbc1OyMXW5frI07QTuGxx4QDyn7cVXJ9KBZo5SxFtyw2OXtnZDjPATbGvVYPJrSCInS8qhwWzf/P4kGlCoeFeumSvJQaBHJzeXrRo9MIMPTxzLjFrutsQPQC2dSr5Ym3VRFkEFGx7JSb633UESHYgBCvb3M4ky857XK+ZxLBoncL2RImC125EKIOw3nI4pwme6UZorRWw3lxjylOD94+8dR+pL8L/pYfKXwzayINFxyS4Mmv42TW6yeX3fOoXg8DxR3M24dIgl/B0RjmUluzpRGmjTdIl9LHBcoWtJV2ARYF5mwa1OuDUJ99fIAwmKyH9Ho0y+K0xt6RTImdEOkB9FLbZG/jXU8AdKmVqENH8yL/dVJPpKLAI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2253c2e2-8835-42b7-360c-08d6fc18fbf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:55.8674
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

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCldoZW4gYW4gSUIgcmVw
IGlzIGxvYWRlZCwgbmV0ZGV2IGZvciB0aGUgc2FtZSB2cG9ydCBpcyBzYXZlZCBmb3IgbGF0ZXIN
CnJlZmVyZW5jZS4gSG93ZXZlciwgaXQncyBub3QgY2xlYW5lZCB1cCB3aGVuIGRvaW5nIHVubG9h
ZC4gRm9yIEVDUEYsDQprZXJuZWwgY3Jhc2hlcyB3aGVuIGRyaXZlciBpcyByZWZlcnJpbmcgdG8g
dGhlIGFscmVhZHkgcmVtb3ZlZCBuZXRkZXYuDQoNCkZvbGxvd2luZyBzdGVwcyBsZWFkIHRvIGEg
c2hvd24gY2FsbCB0cmFjZToNCjEuIENyZWF0ZSBuIFZGcyBmcm9tIGhvc3QgUEYNCjIuIERpc3Ry
b3kgdGhlIFZGcw0KMy4gUnVuICJyZG1hIGxpbmsiIGZyb20gQVJNDQoNCkNhbGwgdHJhY2U6DQog
IG1seDVfaWJfZ2V0X25ldGRldisweDljLzB4ZTggW21seDVfaWJdDQogIG1seDVfcXVlcnlfcG9y
dF9yb2NlKzB4MjY4LzB4NTU4IFttbHg1X2liXQ0KICBtbHg1X2liX3JlcF9xdWVyeV9wb3J0KzB4
MTQvMHgzNCBbbWx4NV9pYl0NCiAgaWJfcXVlcnlfcG9ydCsweDljLzB4ZmMgW2liX2NvcmVdDQog
IGZpbGxfcG9ydF9pbmZvKzB4NzQvMHgyOGMgW2liX2NvcmVdDQogIG5sZGV2X3BvcnRfZ2V0X2Rv
aXQrMHgxYTgvMHgxZTggW2liX2NvcmVdDQogIHJkbWFfbmxfcmN2X21zZysweDE2Yy8weDFjMCBb
aWJfY29yZV0NCiAgcmRtYV9ubF9yY3YrMHhlOC8weDE0NCBbaWJfY29yZV0NCiAgbmV0bGlua191
bmljYXN0KzB4MTg0LzB4MjE0DQogIG5ldGxpbmtfc2VuZG1zZysweDI4OC8weDM1NA0KICBzb2Nr
X3NlbmRtc2crMHgxOC8weDJjDQogIF9fc3lzX3NlbmR0bysweGJjLzB4MTM4DQogIF9fYXJtNjRf
c3lzX3NlbmR0bysweDI4LzB4MzQNCiAgZWwwX3N2Y19jb21tb24rMHhiMC8weDEwMA0KICBlbDBf
c3ZjX2hhbmRsZXIrMHg2Yy8weDg0DQogIGVsMF9zdmMrMHg4LzB4Yw0KDQpDbGVhbnVwIHRoZSBy
ZXAgYW5kIG5ldGRldiByZWZlcmVuY2Ugd2hlbiB1bmxvYWRpbmcgSUIgcmVwLg0KDQpGaXhlczog
MjY2MjhlMmQ1OGM5ICgiUkRNQS9tbHg1OiBNb3ZlIHRvIHNpbmdsZSBkZXZpY2UgbXVsdGlwb3J0
IHBvcnRzIGluIHN3aXRjaGRldiBtb2RlIikNClNpZ25lZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxi
b2RvbmdAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxh
bm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0t
DQogZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMgfCAxOCArKysrKysrKysrKy0t
LS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jIGIvZHJp
dmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCmluZGV4IDFkZTE2YTkzZmM2NC4uMzA2
NWM1ZDBlZTk2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVw
LmMNCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jDQpAQCAtMTcsNiAr
MTcsNyBAQCBtbHg1X2liX3NldF92cG9ydF9yZXAoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwg
c3RydWN0IG1seDVfZXN3aXRjaF9yZXAgKnJlcCkNCiAJdnBvcnRfaW5kZXggPSByZXAtPnZwb3J0
X2luZGV4Ow0KIA0KIAlpYmRldi0+cG9ydFt2cG9ydF9pbmRleF0ucmVwID0gcmVwOw0KKwlyZXAt
PnJlcF9kYXRhW1JFUF9JQl0ucHJpdiA9IGliZGV2Ow0KIAl3cml0ZV9sb2NrKCZpYmRldi0+cG9y
dFt2cG9ydF9pbmRleF0ucm9jZS5uZXRkZXZfbG9jayk7DQogCWliZGV2LT5wb3J0W3Zwb3J0X2lu
ZGV4XS5yb2NlLm5ldGRldiA9DQogCQltbHg1X2liX2dldF9yZXBfbmV0ZGV2KGRldi0+cHJpdi5l
c3dpdGNoLCByZXAtPnZwb3J0KTsNCkBAIC02OCwxNSArNjksMTggQEAgbWx4NV9pYl92cG9ydF9y
ZXBfbG9hZChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBzdHJ1Y3QgbWx4NV9lc3dpdGNoX3Jl
cCAqcmVwKQ0KIHN0YXRpYyB2b2lkDQogbWx4NV9pYl92cG9ydF9yZXBfdW5sb2FkKHN0cnVjdCBt
bHg1X2Vzd2l0Y2hfcmVwICpyZXApDQogew0KLQlzdHJ1Y3QgbWx4NV9pYl9kZXYgKmRldjsNCi0N
Ci0JaWYgKCFyZXAtPnJlcF9kYXRhW1JFUF9JQl0ucHJpdiB8fA0KLQkgICAgcmVwLT52cG9ydCAh
PSBNTFg1X1ZQT1JUX1VQTElOSykNCi0JCXJldHVybjsNCisJc3RydWN0IG1seDVfaWJfZGV2ICpk
ZXYgPSBtbHg1X2liX3JlcF90b19kZXYocmVwKTsNCisJc3RydWN0IG1seDVfaWJfcG9ydCAqcG9y
dDsNCiANCi0JZGV2ID0gbWx4NV9pYl9yZXBfdG9fZGV2KHJlcCk7DQotCV9fbWx4NV9pYl9yZW1v
dmUoZGV2LCBkZXYtPnByb2ZpbGUsIE1MWDVfSUJfU1RBR0VfTUFYKTsNCisJcG9ydCA9ICZkZXYt
PnBvcnRbcmVwLT52cG9ydF9pbmRleF07DQorCXdyaXRlX2xvY2soJnBvcnQtPnJvY2UubmV0ZGV2
X2xvY2spOw0KKwlwb3J0LT5yb2NlLm5ldGRldiA9IE5VTEw7DQorCXdyaXRlX3VubG9jaygmcG9y
dC0+cm9jZS5uZXRkZXZfbG9jayk7DQogCXJlcC0+cmVwX2RhdGFbUkVQX0lCXS5wcml2ID0gTlVM
TDsNCisJcG9ydC0+cmVwID0gTlVMTDsNCisNCisJaWYgKHJlcC0+dnBvcnQgPT0gTUxYNV9WUE9S
VF9VUExJTkspDQorCQlfX21seDVfaWJfcmVtb3ZlKGRldiwgZGV2LT5wcm9maWxlLCBNTFg1X0lC
X1NUQUdFX01BWCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkICptbHg1X2liX3Zwb3J0X2dldF9wcm90
b19kZXYoc3RydWN0IG1seDVfZXN3aXRjaF9yZXAgKnJlcCkNCi0tIA0KMi4yMS4wDQoNCg==
