Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289D5D2BF2
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfJJOB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:01:26 -0400
Received: from mail-eopbgr780080.outbound.protection.outlook.com ([40.107.78.80]:63120
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfJJOBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:01:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQlRsYVWMysUeFwql4oXdCmWtQC20a7iPrvayhIY/iQUIGsKM3+QsKw0Uwc4MT+t5Rwb+2LopDkXrhvDwh/J3YYMSX8i04tJEavjcaWIfrIo5CntbmP0OcFgU5oISgzeUgYPCaNO1V97dt5PqcIYlfp9K4aPb4BfBQE+XUrtiwwTQzApGkzJofP51FnqPs6ShD0mz6zalBfKRapvBcq0PHSdIaSUKy5H8gwux6tZ6KPQWpo5MDTm5qvd/jFClFALGj4+aOdKU121jQ4UJXQgRIF6IFrpCOaHu641hnAbjfCvH1B1+gi8cmYT6rJkJZqA2C0bXMUdtz5aguORKLN8yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfuhjdJqZWRE8OjBwq1BN+Wgob+XsF4p4uhfhC8qRvU=;
 b=BJdVBklJ7nnTYLzcKtreYMnvclSbxooKegEXGYD/uIFk+c12+suTy4Y6qKxwCmg8A57TR/K4Gt64NO2QOR1iF70bLnaKMEKTm5eHjJUD1cCYxmLwRpweqRtSlDAcvwXLDE9DSK7qVUwJleOjbeA0ZnJD5wraLZtJBfJ2xX2xQ+hzEag1yCh7CDlkP8vqYc/GAL51kZobK9qLt3DRrleNoFwNxrN4fN/JH4ZHQncIaPaAOZEFk2W2X7jnggWCFs3pFVfdh7TjUyGm/U4POHhw4G+70YMb5AA4PTeUxIiMvpebqVlpQjhwLI2X2+nRLIg7yIqATIE6MbJ2gcccOut5pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfuhjdJqZWRE8OjBwq1BN+Wgob+XsF4p4uhfhC8qRvU=;
 b=EkEBtt20s8HKImM/tI6eUpFWhwqOZS2zJhnKGHSpHwyF2gQuzRtZnnl7gTMUOXYlMxV4CfjZhD//HlejjVO9rWayIJfmu7l62kAJCIjYj1UVpOwVatfiZpjL38o+IBypzPqPCWgacFCNqaIBdUUAnZwkXUYXraiwPn2IBm6BaGY=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3779.namprd11.prod.outlook.com (20.178.220.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 14:01:22 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 14:01:22 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 1/4] net: aquantia: temperature retrieval fix
Thread-Topic: [PATCH net 1/4] net: aquantia: temperature retrieval fix
Thread-Index: AQHVf3MyinrvQ3/1i0m6scHoj7ZlYg==
Date:   Thu, 10 Oct 2019 14:01:22 +0000
Message-ID: <8167dd20577261b78fbbd8bcad6c9605f510508b.1570708006.git.igor.russkikh@aquantia.com>
References: <cover.1570708006.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570708006.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49b2781b-2ff6-4a0e-5e4e-08d74d8a54cd
x-ms-traffictypediagnostic: BN8PR11MB3779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37792F73A0DFB8BFAF62498E98940@BN8PR11MB3779.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39850400004)(396003)(346002)(376002)(189003)(199004)(66556008)(26005)(446003)(14444005)(64756008)(476003)(6916009)(8676002)(14454004)(81156014)(81166006)(1730700003)(4326008)(508600001)(36756003)(11346002)(2906002)(66946007)(186003)(5024004)(66446008)(3846002)(66476007)(256004)(107886003)(2616005)(5660300002)(486006)(6116002)(6486002)(25786009)(305945005)(7736002)(316002)(6436002)(66066001)(52116002)(66574012)(386003)(118296001)(99286004)(54906003)(5640700003)(6512007)(44832011)(50226002)(102836004)(71200400001)(71190400001)(2351001)(76176011)(6506007)(8936002)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3779;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xSfccl5VwcwIEITZHeyqFzV66H6S+ChiObcB/9514OCGb+LDUZ/S0QReXqGgPtXwDfZjg044oKBHf0p1jV4N98HQAUMy4LBHwzeMSoYTr7nP81nX9X6GC/HUSpqTr+CUGLVZJ4UNxg3n4tTJ+qw99lbrwyW0JqHPYJGDz0luJomeT8ANe1yqfc/pmDWJ/vQ0lGrFZld3pYG5AbnVuLrm6aD1Ma3NWrploR0RUSj+HjVLvQ9vKgvYn1U+i219//Ne8/+kOcRzlXUqn4whC72MTemyAP4v6uAr2rYPXlOAqxDtCH5Ltt+23FQt2Hx94Ou3i/SQ5SBHpoSMkpuwGSdfgGNKAQAtq/fQ+4WOwor25EEN/jSEbzEvlHFxkmNLSQBreU1k59XqclvII02m0jsGfL8hxyI0W2DsbkZKsI9CYOU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBEFC3FAFFD52D4398ED1079FE4D3963@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b2781b-2ff6-4a0e-5e4e-08d74d8a54cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 14:01:22.2243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aExhRrlCxgnEEJNN5IUUe9VVeBUaY+Q2P55SKWbMb1289JlrWWQA1FEFi+JAS81hvfHLOXVTsaGgJmUUT5ISpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q2hpcCB0ZW1wZXJhdHVyZSBpcyBhIHR3byBieXRlIHdvcmQsIGNvbG9jYXRlZCBpbnRlcm5hbGx5
IHdpdGggY2FibGUNCmxlbmd0aCBkYXRhLiBXZSBkbyBhbGwgcmVhZG91dHMgZnJvbSBIVyBtZW1v
cnkgYnkgZHdvcmRzLCB0aHVzDQp3ZSBzaG91bGQgY2xlYXIgZXh0cmEgaGlnaCBieXRlcywgb3Ro
ZXJ3aXNlIHRlbXBlcmF0dXJlIG91dHB1dA0KZ2V0cyB3ZWlyZCBhcyBzb29uIGFzIHdlIGF0dGFj
aCBhIGNhYmxlIHRvIHRoZSBOSUMuDQoNCkZpeGVzOiA4Zjg5NDAxMTg2NTQgKCJuZXQ6IGFxdWFu
dGlhOiBhZGQgaW5mcmFzdHJ1Y3R1cmUgdG8gcmVhZG91dCBjaGlwIHRlbXBlcmF0dXJlIikNClRl
c3RlZC1ieTogSG9sZ2VyIEhvZmZzdMOkdHRlIDxob2xnZXJAYXBwbGllZC1hc3luY2hyb255LmNv
bT4NClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2ggPGlnb3IucnVzc2tpa2hAYXF1YW50aWEu
Y29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdf
YXRsX3V0aWxzX2Z3MnguYyAgIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlsc19mdzJ4LmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzX2Z3MnguYw0KaW5k
ZXggZGE3MjY0ODllM2M4Li4wOGIwMjZiNDE1NzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzX2Z3MnguYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91
dGlsc19mdzJ4LmMNCkBAIC0zMzcsNyArMzM3LDcgQEAgc3RhdGljIGludCBhcV9mdzJ4X2dldF9w
aHlfdGVtcChzdHJ1Y3QgYXFfaHdfcyAqc2VsZiwgaW50ICp0ZW1wKQ0KIAkvKiBDb252ZXJ0IFBI
WSB0ZW1wZXJhdHVyZSBmcm9tIDEvMjU2IGRlZ3JlZSBDZWxzaXVzDQogCSAqIHRvIDEvMTAwMCBk
ZWdyZWUgQ2Vsc2l1cy4NCiAJICovDQotCSp0ZW1wID0gdGVtcF9yZXMgICogMTAwMCAvIDI1NjsN
CisJKnRlbXAgPSAodGVtcF9yZXMgJiAweEZGRkYpICAqIDEwMDAgLyAyNTY7DQogDQogCXJldHVy
biAwOw0KIH0NCi0tIA0KMi4xNy4xDQoNCg==
