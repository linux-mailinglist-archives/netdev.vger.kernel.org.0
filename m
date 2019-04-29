Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AF2E9D9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfD2SOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:14:25 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:53125
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728928AbfD2SOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifr7E60v34KuQgW/ajhJjR97FCgZb6ysoYEVKz4hUwA=;
 b=VKY3fF7Y3SCZErld7WNKBSLB5go2kDuj7/zUxzFFMfa3Sp9huuWvgEQR3u0Hsir8f4hwa6KkxUfuHz2jBzgjpmE99UGcW/mk90SnCpXRVoUWSj0aFTUqYjXkGKV6NBKrajdlhDx9f7f072pS3Cso37u5Ff902o1jwDLyPqbLBf0=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6026.eurprd05.prod.outlook.com (20.179.10.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.16; Mon, 29 Apr 2019 18:14:14 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:14:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 08/11] net/mlx5: Add new miss flow table action
Thread-Topic: [PATCH V2 mlx5-next 08/11] net/mlx5: Add new miss flow table
 action
Thread-Index: AQHU/rdaWuNAVKpRDEGXa3haM04kfQ==
Date:   Mon, 29 Apr 2019 18:14:14 +0000
Message-ID: <20190429181326.6262-9-saeedm@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:a03:40::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d09e5def-6565-4a38-545e-08d6ccce7c8e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6026;
x-ms-traffictypediagnostic: DB8PR05MB6026:
x-microsoft-antispam-prvs: <DB8PR05MB60261114652F1AEC96DB0AE1BE390@DB8PR05MB6026.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(189003)(199004)(25786009)(3846002)(66476007)(64756008)(66446008)(66556008)(107886003)(305945005)(76176011)(256004)(14444005)(52116002)(450100002)(4326008)(66066001)(386003)(6506007)(6116002)(14454004)(478600001)(73956011)(6512007)(66946007)(53936002)(8936002)(36756003)(11346002)(2616005)(2906002)(71190400001)(71200400001)(5660300002)(110136005)(186003)(316002)(26005)(486006)(6636002)(54906003)(446003)(6436002)(68736007)(99286004)(7736002)(50226002)(85306007)(102836004)(81166006)(81156014)(8676002)(86362001)(6486002)(97736004)(1076003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6026;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7QrGbJo1StZkQTa+fAUmJEnOnzO0a4U2b1Uu0z5dlUpk1SDOna1l3OCxLZef+O1tb6M+g2O2GhcUrX0cFKEtO5hbTXX9i4uOiR1UuG8Eokx0Df2K5qtYz1iUQuExZarnSgphWvGk83eMMgzc4fQlkOarQvxcIKdn1Ux9ltr7TYYN3K+xk9tZNsEbxd/sf0ntz0O7KBq55qjLAqthN8oIUTg8LVHwMheNbgT+zChnJdc2js/GwDc7gO1ol1xxobfM1QqoArcfi282tcxUXcZJvM8bE+M5yS1thXRusbDCN+F9RSS1dWKqpopT38Fik83uIXHD8P09UUemd9sveWc4b8iH6K6G4vwxIqXHB2UNvsnU2tjhA+YkF/7B2uGRgRs5SicENJ+uSLMLg7BND5cn3mKxPsfxtGRe2q15YJvNDJc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d09e5def-6565-4a38-545e-08d6ccce7c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:14:14.7437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWFvciBHb3R0bGllYiA8bWFvcmdAbWVsbGFub3guY29tPg0KDQpGbG93IHRhYmxlIHN1
cHBvcnRzIHRocmVlIHR5cGVzIG9mIG1pc3MgYWN0aW9uOg0KMS4gRGVmYXVsdCBtaXNzIGFjdGlv
biAtIGdvIHRvIGRlZmF1bHQgbWlzcyB0YWJsZSBhY2NvcmRpbmcgdG8gdGFibGUuDQoyLiBHbyB0
byBzcGVjaWZpYyB0YWJsZS4NCjMuIFN3aXRjaCBkb21haW4gLSBnbyB0byB0aGUgcm9vdCB0YWJs
ZSBvZiBhbiBhbHRlcm5hdGl2ZSBzdGVlcmluZw0KICAgdGFibGUgZG9tYWluLg0KDQpOZXcgdGFi
bGUgbWlzcyBhY3Rpb24gd2FzIGFkZGVkIC0gc3dpdGNoX2RvbWFpbi4NClRoZSBuZXh0IGRvbWFp
biBmb3IgUkRNQV9SWCBuYW1lc3BhY2UgaXMgdGhlIE5JQyBSWCBkb21haW4uDQoNClNpZ25lZC1v
ZmYtYnk6IE1hb3IgR290dGxpZWIgPG1hb3JnQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBN
YXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhh
bWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9mc19jbWQuYyAgfCAxMyArKysrKysrKysrLS0tDQogZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYyB8ICA2ICsrKysrLQ0KIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmggfCAgMSArDQog
aW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggICAgICAgICAgICAgICAgICAgICB8IDEwICsr
KysrKysrKy0NCiA0IGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZnNfY21kLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNf
Y21kLmMNCmluZGV4IDYyOWM1YWIxYzBkMS4uMDEzYjFjYTRhNzkxIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY21kLmMNCkBAIC0xNzIsOSAr
MTcyLDE0IEBAIHN0YXRpYyBpbnQgbWx4NV9jbWRfY3JlYXRlX2Zsb3dfdGFibGUoc3RydWN0IG1s
eDVfZmxvd19yb290X25hbWVzcGFjZSAqbnMsDQogCWNhc2UgRlNfRlRfT1BfTU9EX05PUk1BTDoN
CiAJCWlmIChuZXh0X2Z0KSB7DQogCQkJTUxYNV9TRVQoY3JlYXRlX2Zsb3dfdGFibGVfaW4sIGlu
LA0KLQkJCQkgZmxvd190YWJsZV9jb250ZXh0LnRhYmxlX21pc3NfYWN0aW9uLCAxKTsNCisJCQkJ
IGZsb3dfdGFibGVfY29udGV4dC50YWJsZV9taXNzX2FjdGlvbiwNCisJCQkJIE1MWDVfRkxPV19U
QUJMRV9NSVNTX0FDVElPTl9GV0QpOw0KIAkJCU1MWDVfU0VUKGNyZWF0ZV9mbG93X3RhYmxlX2lu
LCBpbiwNCiAJCQkJIGZsb3dfdGFibGVfY29udGV4dC50YWJsZV9taXNzX2lkLCBuZXh0X2Z0LT5p
ZCk7DQorCQl9IGVsc2Ugew0KKwkJCU1MWDVfU0VUKGNyZWF0ZV9mbG93X3RhYmxlX2luLCBpbiwN
CisJCQkJIGZsb3dfdGFibGVfY29udGV4dC50YWJsZV9taXNzX2FjdGlvbiwNCisJCQkJIG5zLT5k
ZWZfbWlzc19hY3Rpb24pOw0KIAkJfQ0KIAkJYnJlYWs7DQogDQpAQCAtMjQ2LDEzICsyNTEsMTUg
QEAgc3RhdGljIGludCBtbHg1X2NtZF9tb2RpZnlfZmxvd190YWJsZShzdHJ1Y3QgbWx4NV9mbG93
X3Jvb3RfbmFtZXNwYWNlICpucywNCiAJCQkgTUxYNV9NT0RJRllfRkxPV19UQUJMRV9NSVNTX1RB
QkxFX0lEKTsNCiAJCWlmIChuZXh0X2Z0KSB7DQogCQkJTUxYNV9TRVQobW9kaWZ5X2Zsb3dfdGFi
bGVfaW4sIGluLA0KLQkJCQkgZmxvd190YWJsZV9jb250ZXh0LnRhYmxlX21pc3NfYWN0aW9uLCAx
KTsNCisJCQkJIGZsb3dfdGFibGVfY29udGV4dC50YWJsZV9taXNzX2FjdGlvbiwNCisJCQkJIE1M
WDVfRkxPV19UQUJMRV9NSVNTX0FDVElPTl9GV0QpOw0KIAkJCU1MWDVfU0VUKG1vZGlmeV9mbG93
X3RhYmxlX2luLCBpbiwNCiAJCQkJIGZsb3dfdGFibGVfY29udGV4dC50YWJsZV9taXNzX2lkLA0K
IAkJCQkgbmV4dF9mdC0+aWQpOw0KIAkJfSBlbHNlIHsNCiAJCQlNTFg1X1NFVChtb2RpZnlfZmxv
d190YWJsZV9pbiwgaW4sDQotCQkJCSBmbG93X3RhYmxlX2NvbnRleHQudGFibGVfbWlzc19hY3Rp
b24sIDApOw0KKwkJCQkgZmxvd190YWJsZV9jb250ZXh0LnRhYmxlX21pc3NfYWN0aW9uLA0KKwkJ
CQkgbnMtPmRlZl9taXNzX2FjdGlvbik7DQogCQl9DQogCX0NCiANCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYw0KaW5kZXggM2MyMzAyYTJi
OWQ0Li5mYjViNjE3MjdlZTcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZnNfY29yZS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZnNfY29yZS5jDQpAQCAtMjUwNCw2ICsyNTA0LDkgQEAgc3RhdGljIGlu
dCBpbml0X3JkbWFfcnhfcm9vdF9ucyhzdHJ1Y3QgbWx4NV9mbG93X3N0ZWVyaW5nICpzdGVlcmlu
ZykNCiAJaWYgKCFzdGVlcmluZy0+cmRtYV9yeF9yb290X25zKQ0KIAkJcmV0dXJuIC1FTk9NRU07
DQogDQorCXN0ZWVyaW5nLT5yZG1hX3J4X3Jvb3RfbnMtPmRlZl9taXNzX2FjdGlvbiA9DQorCQlN
TFg1X0ZMT1dfVEFCTEVfTUlTU19BQ1RJT05fU1dJVENIX0RPTUFJTjsNCisNCiAJLyogQ3JlYXRl
IHNpbmdsZSBwcmlvICovDQogCXByaW8gPSBmc19jcmVhdGVfcHJpbygmc3RlZXJpbmctPnJkbWFf
cnhfcm9vdF9ucy0+bnMsIDAsIDEpOw0KIAlpZiAoSVNfRVJSKHByaW8pKSB7DQpAQCAtMjc0OCw3
ICsyNzUxLDggQEAgaW50IG1seDVfaW5pdF9mcyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0K
IAkJCWdvdG8gZXJyOw0KIAl9DQogDQotCWlmIChNTFg1X0NBUF9GTE9XVEFCTEVfUkRNQV9SWChk
ZXYsIGZ0X3N1cHBvcnQpKSB7DQorCWlmIChNTFg1X0NBUF9GTE9XVEFCTEVfUkRNQV9SWChkZXYs
IGZ0X3N1cHBvcnQpICYmDQorCSAgICBNTFg1X0NBUF9GTE9XVEFCTEVfUkRNQV9SWChkZXYsIHRh
YmxlX21pc3NfYWN0aW9uX2RvbWFpbikpIHsNCiAJCWVyciA9IGluaXRfcmRtYV9yeF9yb290X25z
KHN0ZWVyaW5nKTsNCiAJCWlmIChlcnIpDQogCQkJZ290byBlcnI7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuaCBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmgNCmluZGV4IGU0M2M2ZjZk
NDZhNy4uMGM2YzVmZWY0NTQ4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuaA0KQEAgLTIxOCw2ICsyMTgsNyBAQCBzdHJ1Y3QgbWx4
NV9mbG93X3Jvb3RfbmFtZXNwYWNlIHsNCiAJc3RydWN0IG11dGV4CQkJY2hhaW5fbG9jazsNCiAJ
c3RydWN0IGxpc3RfaGVhZAkJdW5kZXJsYXlfcXBuczsNCiAJY29uc3Qgc3RydWN0IG1seDVfZmxv
d19jbWRzCSpjbWRzOw0KKwllbnVtIG1seDVfZmxvd190YWJsZV9taXNzX2FjdGlvbiBkZWZfbWlz
c19hY3Rpb247DQogfTsNCiANCiBpbnQgbWx4NV9pbml0X2ZjX3N0YXRzKHN0cnVjdCBtbHg1X2Nv
cmVfZGV2ICpkZXYpOw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5o
IGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCmluZGV4IDg5ZTcxOTRiM2Q5Ny4uN2Q5
MjY0YjI4MmQxIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCisr
KyBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oDQpAQCAtMzcwLDcgKzM3MCw5IEBAIHN0
cnVjdCBtbHg1X2lmY19mbG93X3RhYmxlX3Byb3BfbGF5b3V0X2JpdHMgew0KIAl1OAkgICByZWZv
cm1hdF9sM190dW5uZWxfdG9fbDJbMHgxXTsNCiAJdTgJICAgcmVmb3JtYXRfbDJfdG9fbDNfdHVu
bmVsWzB4MV07DQogCXU4CSAgIHJlZm9ybWF0X2FuZF9tb2RpZnlfYWN0aW9uWzB4MV07DQotCXU4
ICAgICAgICAgcmVzZXJ2ZWRfYXRfMTVbMHhiXTsNCisJdTggICAgICAgICByZXNlcnZlZF9hdF8x
NVsweDJdOw0KKwl1OAkgICB0YWJsZV9taXNzX2FjdGlvbl9kb21haW5bMHgxXTsNCisJdTggICAg
ICAgICByZXNlcnZlZF9hdF8xOFsweDhdOw0KIAl1OCAgICAgICAgIHJlc2VydmVkX2F0XzIwWzB4
Ml07DQogCXU4ICAgICAgICAgbG9nX21heF9mdF9zaXplWzB4Nl07DQogCXU4ICAgICAgICAgbG9n
X21heF9tb2RpZnlfaGVhZGVyX2NvbnRleHRbMHg4XTsNCkBAIC0xMjg0LDYgKzEyODYsMTIgQEAg
ZW51bSBtbHg1X2Zsb3dfZGVzdGluYXRpb25fdHlwZSB7DQogCU1MWDVfRkxPV19ERVNUSU5BVElP
Tl9UWVBFX0ZMT1dfVEFCTEVfTlVNID0gMHgxMDEsDQogfTsNCiANCitlbnVtIG1seDVfZmxvd190
YWJsZV9taXNzX2FjdGlvbiB7DQorCU1MWDVfRkxPV19UQUJMRV9NSVNTX0FDVElPTl9ERUYsDQor
CU1MWDVfRkxPV19UQUJMRV9NSVNTX0FDVElPTl9GV0QsDQorCU1MWDVfRkxPV19UQUJMRV9NSVNT
X0FDVElPTl9TV0lUQ0hfRE9NQUlOLA0KK307DQorDQogc3RydWN0IG1seDVfaWZjX2Rlc3RfZm9y
bWF0X3N0cnVjdF9iaXRzIHsNCiAJdTggICAgICAgICBkZXN0aW5hdGlvbl90eXBlWzB4OF07DQog
CXU4ICAgICAgICAgZGVzdGluYXRpb25faWRbMHgxOF07DQotLSANCjIuMjAuMQ0KDQo=
