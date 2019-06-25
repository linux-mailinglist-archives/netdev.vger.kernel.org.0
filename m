Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CDA5598E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfFYU6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:58:20 -0400
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:20873
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbfFYU6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 16:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=g3LjwOPN+QO17UIV7beJj1sCN8IeFZ9dRjAFKHOYqjUn/aD/Tdp4y1JQpJXP3bZoRZ0jYGVia/Z/KJOMju237mvfj3X7lG6F9zR2le+w07OJu0ruFWmQ2cmmSrSJMCVlzoXCkElMSqQr113zQnaH6TpSCHU38T6hJdyi5A8Tuc8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=578e5j8kfp+LzvkvjN05M50aSkO2YMDolFGh4vPA414=;
 b=kI0EjysRrHXQyp4CIn812vPsRm2WeAK4AIxy3+wq3WnQMuCITtfIdZezMaV9WQJMTYezSbGbB/T5mL5wMEVp8QhPVd5aJLdVUq1St8KcCrTegxs4V8OYsIKjdc5mwE/NfgluK7VVd1iiISfCIzDWls5XcknmysmBAmYKJwQtiRQ=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=578e5j8kfp+LzvkvjN05M50aSkO2YMDolFGh4vPA414=;
 b=j5bOcyDkRntOpvquvzRklY7aoejmaCAH4ed4q6CIUI+fMFDSFsEfr96jyb0F2YdDv5+THeTo7lwBtRepc6QUR7zt90CUdtLqahjF/W0dyIugitGrOqj22GpuaRQXNoeJ4qz5tghrOQxeDWAdtEk6SeKCI+ASFwb1ysw7zKrQ5gI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2696.eurprd05.prod.outlook.com (10.172.225.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 20:57:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 20:57:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V2 07/10] linux/dim: Add completions count to dim_sample
Thread-Topic: [for-next V2 07/10] linux/dim: Add completions count to
 dim_sample
Thread-Index: AQHVK5ijSF/ZYzzr40ys7bGdzT1+bw==
Date:   Tue, 25 Jun 2019 20:57:46 +0000
Message-ID: <20190625205701.17849-8-saeedm@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
In-Reply-To: <20190625205701.17849-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 776ed448-0b56-4506-6cbb-08d6f9afc626
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2696;
x-ms-traffictypediagnostic: DB6PR0501MB2696:
x-microsoft-antispam-prvs: <DB6PR0501MB26962E7254190770CD40638BBEE30@DB6PR0501MB2696.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:398;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(6512007)(66476007)(186003)(86362001)(305945005)(3846002)(26005)(6116002)(68736007)(7736002)(102836004)(50226002)(99286004)(14444005)(53936002)(6636002)(76176011)(1076003)(2906002)(5660300002)(6436002)(64756008)(14454004)(66556008)(25786009)(486006)(52116002)(73956011)(71190400001)(6486002)(6506007)(11346002)(81166006)(71200400001)(446003)(386003)(66946007)(256004)(81156014)(66446008)(478600001)(4326008)(66066001)(8676002)(107886003)(2616005)(36756003)(316002)(476003)(8936002)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2696;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rMBghmfs1Lsju1Tk0iFV9K9ftPVYOe1DSPbz/AVxG+vV+KnfNI6J7dpqHqUWFIg3GiDzY+pXv8akyBPNBxlyxtWHwPldbM5inOxnCp7dKYksgyMrQcwor5xERDRkYTEmIQYnVtDYAaKAC/wkIJPbqTpLpK82ZSJNf+dvrFtg2KCl7ZVi1eW3u563zem1GEOr7sGu7Q2flA0BUx72PXhG0hXdr83JW931/m5FQuhO5+WMKAkB5UyMhUGcXuLIFBwopmzakA8tK4efHg3LcqtcCLNWb68Deb/4RSy125FWt4viH3+8Vj1tEWvFvvxHaTwdpP0n4a+lb8hYyltLHD5YF84UB4BooqUf8CZ42HhH7jv4YWkbBqWH09UH82clR6dTMKPE4FQW3FuyrcnZMGhk9H1y0tKTgRETYBGbAoGckYE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776ed448-0b56-4506-6cbb-08d6f9afc626
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 20:57:46.3377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWFtaW4gRnJpZWRtYW4gPHlhbWluZkBtZWxsYW5veC5jb20+DQoNCkFkZGVkIGEgbWVh
c3VyZW1lbnQgb2YgY29tcGxldGlvbnMgcGVyL21zZWMgdG8gYWxsb3cgZm9yIGNvbXBsZXRpb24g
YmFzZWQNCmRpbSBhbGdvcml0aG1zLg0KDQpJbiBvcmRlciB0byB1c2UgZHluYW1pYyBpbnRlcnJ1
cHQgbW9kZXJhdGlvbiB3aXRoIFJETUEgd2UgbmVlZCB0byBoYXZlIGENCmRpZmZlcmVudCBtZWFz
dXJtZW50IHRoYW4gcGFja2V0cyBwZXIgc2Vjb25kLiBUaGlzIGNoYW5nZSBpcyBtZWFudCB0bw0K
cHJlcGFyZSBmb3IgYWRkaW5nIGEgbmV3IERJTSBtZXRob2QuDQoNCkFsbCBkcml2ZXJzIHRoYXQg
dXNlIG5ldF9kaW0gYW5kIHRodXMgZG8gbm90IG5lZWQgYSBjb21wbGV0aW9uIGNvdW50IHdpbGwN
CmhhdmUgdGhlIGNvbXBsZXRpb25zIHNldCB0byAwLg0KDQpTaWduZWQtb2ZmLWJ5OiBZYW1pbiBG
cmllZG1hbiA8eWFtaW5mQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXggR3VydG92b3kg
PG1heGdAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVk
bUBtZWxsYW5veC5jb20+DQotLS0NCiBpbmNsdWRlL2xpbnV4L2RpbS5oIHwgMjggKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLQ0KIGxpYi9kaW0vZGltLmMgICAgICAgfCAgOSArKysrKysrKysN
CiAyIGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2RpbS5oIGIvaW5jbHVkZS9saW51eC9kaW0uaA0KaW5k
ZXggZjQ4ZWRlM2UwMzIyLi5hYTliZGQ0N2E2NDggMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4
L2RpbS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2RpbS5oDQpAQCAtMzcsNiArMzcsNyBAQA0KIHN0
cnVjdCBkaW1fY3FfbW9kZXIgew0KIAl1MTYgdXNlYzsNCiAJdTE2IHBrdHM7DQorCXUxNiBjb21w
czsNCiAJdTggY3FfcGVyaW9kX21vZGU7DQogfTsNCiANCkBAIC01NCw2ICs1NSw3IEBAIHN0cnVj
dCBkaW1fc2FtcGxlIHsNCiAJdTMyIHBrdF9jdHI7DQogCXUzMiBieXRlX2N0cjsNCiAJdTE2IGV2
ZW50X2N0cjsNCisJdTMyIGNvbXBfY3RyOw0KIH07DQogDQogLyoqDQpAQCAtNjUsOSArNjcsMTEg
QEAgc3RydWN0IGRpbV9zYW1wbGUgew0KICAqIEBlcG1zOiBFdmVudHMgcGVyIG1zZWMNCiAgKi8N
CiBzdHJ1Y3QgZGltX3N0YXRzIHsNCi0JaW50IHBwbXM7DQotCWludCBicG1zOw0KLQlpbnQgZXBt
czsNCisJaW50IHBwbXM7IC8qIHBhY2tldHMgcGVyIG1zZWMgKi8NCisJaW50IGJwbXM7IC8qIGJ5
dGVzIHBlciBtc2VjICovDQorCWludCBlcG1zOyAvKiBldmVudHMgcGVyIG1zZWMgKi8NCisJaW50
IGNwbXM7IC8qIGNvbXBsZXRpb25zIHBlciBtc2VjICovDQorCWludCBjcGVfcmF0aW87IC8qIHJh
dGlvIG9mIGNvbXBsZXRpb25zIHRvIGV2ZW50cyAqLw0KIH07DQogDQogLyoqDQpAQCAtODksNiAr
OTMsNyBAQCBzdHJ1Y3QgZGltIHsNCiAJdTggc3RhdGU7DQogCXN0cnVjdCBkaW1fc3RhdHMgcHJl
dl9zdGF0czsNCiAJc3RydWN0IGRpbV9zYW1wbGUgc3RhcnRfc2FtcGxlOw0KKwlzdHJ1Y3QgZGlt
X3NhbXBsZSBtZWFzdXJpbmdfc2FtcGxlOw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsNCiAJ
dTggcHJvZmlsZV9peDsNCiAJdTggbW9kZTsNCkBAIC0yNDYsNiArMjUxLDIzIEBAIGRpbV91cGRh
dGVfc2FtcGxlKHUxNiBldmVudF9jdHIsIHU2NCBwYWNrZXRzLCB1NjQgYnl0ZXMsIHN0cnVjdCBk
aW1fc2FtcGxlICpzKQ0KIAlzLT5ldmVudF9jdHIgPSBldmVudF9jdHI7DQogfQ0KIA0KKy8qKg0K
KyAqCWRpbV91cGRhdGVfc2FtcGxlX3dpdGhfY29tcHMgLSBzZXQgYSBzYW1wbGUncyBmaWVsZHMg
d2l0aCBnaXZlbg0KKyAqCXZhbHVlcyBpbmNsdWRpbmcgdGhlIGNvbXBsZXRpb24gcGFyYW1ldGVy
DQorICoJQGV2ZW50X2N0cjogbnVtYmVyIG9mIGV2ZW50cyB0byBzZXQNCisgKglAcGFja2V0czog
bnVtYmVyIG9mIHBhY2tldHMgdG8gc2V0DQorICoJQGJ5dGVzOiBudW1iZXIgb2YgYnl0ZXMgdG8g
c2V0DQorICoJQGNvbXBzOiBudW1iZXIgb2YgY29tcGxldGlvbnMgdG8gc2V0DQorICoJQHM6IERJ
TSBzYW1wbGUNCisgKi8NCitzdGF0aWMgaW5saW5lIHZvaWQNCitkaW1fdXBkYXRlX3NhbXBsZV93
aXRoX2NvbXBzKHUxNiBldmVudF9jdHIsIHU2NCBwYWNrZXRzLCB1NjQgYnl0ZXMsIHU2NCBjb21w
cywNCisJCQkgICAgIHN0cnVjdCBkaW1fc2FtcGxlICpzKQ0KK3sNCisJZGltX3VwZGF0ZV9zYW1w
bGUoZXZlbnRfY3RyLCBwYWNrZXRzLCBieXRlcywgcyk7DQorCXMtPmNvbXBfY3RyID0gY29tcHM7
DQorfQ0KKw0KIC8qIE5ldCBESU0gKi8NCiANCiAvKg0KZGlmZiAtLWdpdCBhL2xpYi9kaW0vZGlt
LmMgYi9saWIvZGltL2RpbS5jDQppbmRleCAxN2Q1MjM2NzU5YmQuLjQzOWQ2NDFlYzc5NiAxMDA2
NDQNCi0tLSBhL2xpYi9kaW0vZGltLmMNCisrKyBiL2xpYi9kaW0vZGltLmMNCkBAIC02Miw2ICs2
Miw4IEBAIHZvaWQgZGltX2NhbGNfc3RhdHMoc3RydWN0IGRpbV9zYW1wbGUgKnN0YXJ0LCBzdHJ1
Y3QgZGltX3NhbXBsZSAqZW5kLA0KIAl1MzIgbnBrdHMgPSBCSVRfR0FQKEJJVFNfUEVSX1RZUEUo
dTMyKSwgZW5kLT5wa3RfY3RyLCBzdGFydC0+cGt0X2N0cik7DQogCXUzMiBuYnl0ZXMgPSBCSVRf
R0FQKEJJVFNfUEVSX1RZUEUodTMyKSwgZW5kLT5ieXRlX2N0ciwNCiAJCQkgICAgIHN0YXJ0LT5i
eXRlX2N0cik7DQorCXUzMiBuY29tcHMgPSBCSVRfR0FQKEJJVFNfUEVSX1RZUEUodTMyKSwgZW5k
LT5jb21wX2N0ciwNCisJCQkgICAgIHN0YXJ0LT5jb21wX2N0cik7DQogDQogCWlmICghZGVsdGFf
dXMpDQogCQlyZXR1cm47DQpAQCAtNzAsNSArNzIsMTIgQEAgdm9pZCBkaW1fY2FsY19zdGF0cyhz
dHJ1Y3QgZGltX3NhbXBsZSAqc3RhcnQsIHN0cnVjdCBkaW1fc2FtcGxlICplbmQsDQogCWN1cnJf
c3RhdHMtPmJwbXMgPSBESVZfUk9VTkRfVVAobmJ5dGVzICogVVNFQ19QRVJfTVNFQywgZGVsdGFf
dXMpOw0KIAljdXJyX3N0YXRzLT5lcG1zID0gRElWX1JPVU5EX1VQKERJTV9ORVZFTlRTICogVVNF
Q19QRVJfTVNFQywNCiAJCQkJCWRlbHRhX3VzKTsNCisJY3Vycl9zdGF0cy0+Y3BtcyA9IERJVl9S
T1VORF9VUChuY29tcHMgKiBVU0VDX1BFUl9NU0VDLCBkZWx0YV91cyk7DQorCWlmIChjdXJyX3N0
YXRzLT5lcG1zICE9IDApDQorCQljdXJyX3N0YXRzLT5jcGVfcmF0aW8gPQ0KKwkJCQkoY3Vycl9z
dGF0cy0+Y3BtcyAqIDEwMCkgLyBjdXJyX3N0YXRzLT5lcG1zOw0KKwllbHNlDQorCQljdXJyX3N0
YXRzLT5jcGVfcmF0aW8gPSAwOw0KKw0KIH0NCiBFWFBPUlRfU1lNQk9MKGRpbV9jYWxjX3N0YXRz
KTsNCi0tIA0KMi4yMS4wDQoNCg==
