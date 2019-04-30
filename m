Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9F010048
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfD3T3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 15:29:12 -0400
Received: from mail-eopbgr730127.outbound.protection.outlook.com ([40.107.73.127]:50016
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbfD3T3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 15:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=RA+rP/mGKb968X10GMmf/gQYF7R0Tpftzl6f2gETh8mNw5izXu4Uljx2bK5JPsrYWLxdNfFuiWKsv0ZxbZ8vvQ5/DsSyZKO65Prt7r4p5O3ZAIoCBCy8ITnjBNqUPZ24NXgNGa+icgKtO6fsC+s6aAtR/qmm3M7bk9ypMNtqod0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrOpdnV7pmTKvCj1dk+AdVcU18cwSimy+eA3wTIepns=;
 b=qV4vqUMZdkTWHwu04sVkAG+xc3wvVCwh0Uor0QaYm8az6XBC6LKiZtqsWrJfcF1r4ddNlcdhLW/nAKh46BUUlJr7RnioIf3phk2dRs+CDFNvpk3EIw+SBuYltWHjFK8ciwgpMxQAACg2tAus6EZ3d3OSE9HNKtd+WXVD9mKBa8s=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrOpdnV7pmTKvCj1dk+AdVcU18cwSimy+eA3wTIepns=;
 b=NJ7wDqK1lYsYGUEYaOKSE+IQ67qk+9iltDif6u8vOikkLjgKTWdEUV29Ee7waJ3abRtWSDK1JoNnP+SUMCJhen0/MSfMBldEBt0YzSPKKpT55Xc/sPNri4zfW2v1Cep6YFEhL/Dv9CP6hGEdeEDMlxF8Na+c7Kzu0DikWrBsXXM=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1307.namprd21.prod.outlook.com (20.179.52.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.1; Tue, 30 Apr 2019 19:29:08 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::fda6:f2da:f9ce:f26d]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::fda6:f2da:f9ce:f26d%3]) with mapi id 15.20.1856.004; Tue, 30 Apr 2019
 19:29:08 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH hyperv-fixes] hv_netvsc: fix race that may miss tx queue
 wakeup
Thread-Topic: [PATCH hyperv-fixes] hv_netvsc: fix race that may miss tx queue
 wakeup
Thread-Index: AQHU/4r6KRj7uKGITUSbj+ZaAecFfQ==
Date:   Tue, 30 Apr 2019 19:29:07 +0000
Message-ID: <1556652525-83155-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0059.namprd18.prod.outlook.com
 (2603:10b6:104:2::27) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77f5db9b-792e-4b24-14e4-08d6cda21d1b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1307;
x-ms-traffictypediagnostic: DM6PR21MB1307:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1307FB8FA739EA2FEB36BC40AC3A0@DM6PR21MB1307.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(199004)(189003)(2616005)(25786009)(476003)(2201001)(386003)(7736002)(10090500001)(73956011)(53936002)(6506007)(6512007)(256004)(10290500003)(97736004)(6486002)(26005)(305945005)(8676002)(14444005)(486006)(102836004)(4326008)(86612001)(8936002)(2906002)(186003)(81156014)(81166006)(66476007)(68736007)(52116002)(5660300002)(22452003)(14454004)(7846003)(99286004)(66556008)(50226002)(478600001)(64756008)(6392003)(6436002)(2501003)(110136005)(3846002)(66066001)(54906003)(316002)(66946007)(6116002)(36756003)(4720700003)(71190400001)(66446008)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1307;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +440/iKDFPA2rOdrS4GWqejoM5xo8X0rd0pMkLoc8Udcu+Ab3jzZI0Nw7+w9VOKXCXH1kqgWrLdsta8S7gbmbo9ENt9kr1me9q6ug4CrNAFqHjsBwBJ30YwRcUAH7AxVpaoXxG9YA/xNV9EqHXD96k7Luavz+mIAbK3ledrMbCgxHIw+nZZO3VJdy0Ko1iDY5SVSMlBZbKAWTew558HG7QRMNnCStfjhnRwoEQVvC8JAn4Yrwu6oNwhpZo69crKsWYk0j/IOfYjm2cwOEP2II20gu6tZqCp4t5TLZ1nboWGvtqEU7Q41Ige7aWzQFQ4jNQ5KWQeUQziQT/tbLkxpXizFXr8UFbQpicxUxitoN/t0+3tCXEawZ1OZsOm4d3Pvx8PAMOgY7Ug2ow3oZh85aH0vNktKeiX1XJTBr7kPsjM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f5db9b-792e-4b24-14e4-08d6cda21d1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 19:29:08.1660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiB0aGUgcmluZyBidWZmZXIgaXMgYWxtb3N0IGZ1bGwgZHVlIHRvIFJYIGNvbXBsZXRpb24g
bWVzc2FnZXMsIGENClRYIHBhY2tldCBtYXkgcmVhY2ggdGhlICJsb3cgd2F0ZXJtYXJrIiBhbmQg
Y2F1c2UgdGhlIHF1ZXVlIHN0b3BwZWQuDQpJZiB0aGUgVFggY29tcGxldGlvbiBhcnJpdmVzIGVh
cmxpZXIgdGhhbiBxdWV1ZSBzdG9wcGluZywgdGhlIHdha2V1cA0KbWF5IGJlIG1pc3NlZC4NCg0K
VGhpcyBwYXRjaCBtb3ZlcyB0aGUgY2hlY2sgZm9yIHRoZSBsYXN0IHBlbmRpbmcgcGFja2V0IHRv
IGNvdmVyIGJvdGgNCkVBR0FJTiBhbmQgc3VjY2VzcyBjYXNlcywgc28gdGhlIHF1ZXVlIHdpbGwg
YmUgcmVsaWFibHkgd2FrZWQgdXAgd2hlbg0KbmVjZXNzYXJ5Lg0KDQpSZXBvcnRlZC1hbmQtdGVz
dGVkLWJ5OiBTdGVwaGFuIEtsZWluIDxzdGVwaGFuLmtsZWluQHdlZ2ZpbmRlci5hdD4NClNpZ25l
ZC1vZmYtYnk6IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+DQotLS0NCiBk
cml2ZXJzL25ldC9oeXBlcnYvbmV0dnNjLmMgfCAxNSArKysrKysrKystLS0tLS0NCiAxIGZpbGUg
Y2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvaHlwZXJ2L25ldHZzYy5jIGIvZHJpdmVycy9uZXQvaHlwZXJ2L25ldHZzYy5j
DQppbmRleCBmZGJlYjcwLi5lZTE5ODYwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvaHlwZXJ2
L25ldHZzYy5jDQorKysgYi9kcml2ZXJzL25ldC9oeXBlcnYvbmV0dnNjLmMNCkBAIC04NzUsMTIg
Kzg3NSw2IEBAIHN0YXRpYyBpbmxpbmUgaW50IG5ldHZzY19zZW5kX3BrdCgNCiAJfSBlbHNlIGlm
IChyZXQgPT0gLUVBR0FJTikgew0KIAkJbmV0aWZfdHhfc3RvcF9xdWV1ZSh0eHEpOw0KIAkJbmRl
dl9jdHgtPmV0aF9zdGF0cy5zdG9wX3F1ZXVlKys7DQotCQlpZiAoYXRvbWljX3JlYWQoJm52Y2hh
bi0+cXVldWVfc2VuZHMpIDwgMSAmJg0KLQkJICAgICFuZXRfZGV2aWNlLT50eF9kaXNhYmxlKSB7
DQotCQkJbmV0aWZfdHhfd2FrZV9xdWV1ZSh0eHEpOw0KLQkJCW5kZXZfY3R4LT5ldGhfc3RhdHMu
d2FrZV9xdWV1ZSsrOw0KLQkJCXJldCA9IC1FTk9TUEM7DQotCQl9DQogCX0gZWxzZSB7DQogCQlu
ZXRkZXZfZXJyKG5kZXYsDQogCQkJICAgIlVuYWJsZSB0byBzZW5kIHBhY2tldCBwYWdlcyAldSBs
ZW4gJXUsIHJldCAlZFxuIiwNCkBAIC04ODgsNiArODgyLDE1IEBAIHN0YXRpYyBpbmxpbmUgaW50
IG5ldHZzY19zZW5kX3BrdCgNCiAJCQkgICByZXQpOw0KIAl9DQogDQorCWlmIChuZXRpZl90eF9x
dWV1ZV9zdG9wcGVkKHR4cSkgJiYNCisJICAgIGF0b21pY19yZWFkKCZudmNoYW4tPnF1ZXVlX3Nl
bmRzKSA8IDEgJiYNCisJICAgICFuZXRfZGV2aWNlLT50eF9kaXNhYmxlKSB7DQorCQluZXRpZl90
eF93YWtlX3F1ZXVlKHR4cSk7DQorCQluZGV2X2N0eC0+ZXRoX3N0YXRzLndha2VfcXVldWUrKzsN
CisJCWlmIChyZXQgPT0gLUVBR0FJTikNCisJCQlyZXQgPSAtRU5PU1BDOw0KKwl9DQorDQogCXJl
dHVybiByZXQ7DQogfQ0KIA0KLS0gDQoxLjguMy4xDQoNCg==
