Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3771B2A3D3
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfEYJ6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:58:03 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:59488
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbfEYJ6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 05:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgAdZhRomP+72ub6Ih4PqEbbbuPFFQEVNZh89FrfXQE=;
 b=hBd0Ieykmde3GpNKSihKCS9fdHh0m96sI+3vG8LfnMYpDV33j/7ZBvO2TdC2G/KsR/nD7HTnubjeo5KOITxC/E/4oERZSwPH8Iort6zRAM2TI/wbnlXF1azp3lywAnBbWIVpAW/clPSOIPbbHwfdByrupB/NsPis6mNwD1i6/vg=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3017.namprd11.prod.outlook.com (20.177.218.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Sat, 25 May 2019 09:57:59 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 09:57:59 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 1/4] net: aquantia: tx clean budget logic error
Thread-Topic: [PATCH net 1/4] net: aquantia: tx clean budget logic error
Thread-Index: AQHVEuBVT4SUIS3FcU+FHgKEouHK5A==
Date:   Sat, 25 May 2019 09:57:59 +0000
Message-ID: <f659b94aff7f57a4592d89d797060d24f22a1bb9.1558777421.git.igor.russkikh@aquantia.com>
References: <cover.1558777421.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1558777421.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:bc::19)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0152936a-4060-410c-0e1c-08d6e0f77773
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR11MB3017;
x-ms-traffictypediagnostic: DM6PR11MB3017:
x-microsoft-antispam-prvs: <DM6PR11MB301705FD869A9B11C965667398030@DM6PR11MB3017.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39850400004)(199004)(189003)(66946007)(71190400001)(486006)(53936002)(66476007)(2616005)(44832011)(71200400001)(66556008)(107886003)(66446008)(73956011)(64756008)(7736002)(6916009)(14454004)(11346002)(478600001)(316002)(25786009)(446003)(6436002)(72206003)(6512007)(6486002)(386003)(118296001)(36756003)(3846002)(4326008)(305945005)(52116002)(6506007)(186003)(76176011)(26005)(2906002)(99286004)(476003)(102836004)(256004)(86362001)(5660300002)(54906003)(66066001)(68736007)(81156014)(8676002)(81166006)(50226002)(8936002)(6116002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3017;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ld/Xj1zdl8kSOpG9zK77DqtIh+enZIMl0Kh7lhcL6/raB6QpS/X4rHl1/4f1rZhJCx5jX9lXfFaMqbOTKQqmYHoEbYsg3LuQu9D22MJz6lcyS1WSghzLOhRQabsInEceTr4IzpaMTv57NujIdGjDoFPGuEDIM8V+8l2/YrnPlvTpfSz1qUInA2EzMHdMEvVExw7mmG83Z4td2K7ne4/2qRaVzu1Gn4j4sBjhpOf0ioInRP4AuDdofGgssuosd/AxwK8myy4xUh5J3tj0fQVDD2YxH+2wVFkAwf71jiuCmGeVfsXcs2MErAj/+AtQZ80UrpNXfSM85z4H2M32jZ9QsQcc+x+NNqTDiRxcNJ7zBFVyCpJqgjQYSFIxbrVgeh48+2RRo/uUaLVJlIYasVgRCEytqSKc5Gt8MC6+BEkSMDI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0152936a-4060-410c-0e1c-08d6e0f77773
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 09:57:59.1932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gY2FzZSBubyBvdGhlciB0cmFmZmljIGhhcHBlbmluZyBvbiB0aGUgcmluZywgZnVsbCB0eCBj
bGVhbnVwDQptYXkgbm90IGJlIGNvbXBsZXRlZC4gVGhhdCBtYXkgY2F1c2Ugc29ja2V0IGJ1ZmZl
ciB0byBvdmVyZmxvdw0KYW5kIHR4IHRyYWZmaWMgdG8gc3R1Y2sgdW50aWwgbmV4dCBhY3Rpdml0
eSBvbiB0aGUgcmluZyBoYXBwZW5zLg0KDQpUaGlzIGlzIGR1ZSB0byBsb2dpYyBlcnJvciBpbiBi
dWRnZXQgdmFyaWFibGUgZGVjcmVtZW50b3IuDQpWYXJpYWJsZSBpcyBjb21wYXJlZCB3aXRoIHpl
cm8sIGFuZCB0aGVuIHBvc3QgZGVjcmVtZW50ZWQsDQpjYXVzaW5nIGl0IHRvIGJlY29tZSBNQVhf
SU5ULiBTb2x1dGlvbiBpcyByZW1vdmUgZGVjcmVtZW50b3INCmZyb20gdGhlIGBmb3JgIHN0YXRl
bWVudCBhbmQgcmV3cml0ZSBpdCBpbiBhIGNsZWFyIHdheS4NCg0KRml4ZXM6IGI2NDdkMzk4MDk0
OGUgKCJuZXQ6IGFxdWFudGlhOiBBZGQgdHggY2xlYW4gYnVkZ2V0IGFuZCB2YWxpZCBidWRnZXQg
aGFuZGxpbmcgbG9naWMiKQ0KU2lnbmVkLW9mZi1ieTogSWdvciBSdXNza2lraCA8aWdvci5ydXNz
a2lraEBhcXVhbnRpYS5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9yaW5nLmMgfCA3ICsrKystLS0NCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcmluZy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvYXFfcmluZy5jDQppbmRleCAzNTBlMzg1NTI4ZmQuLjYzZWQwMDQxNTkw
NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2Fx
X3JpbmcuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
cmluZy5jDQpAQCAtMjIzLDEwICsyMjMsMTAgQEAgdm9pZCBhcV9yaW5nX3F1ZXVlX3N0b3Aoc3Ry
dWN0IGFxX3JpbmdfcyAqcmluZykNCiBib29sIGFxX3JpbmdfdHhfY2xlYW4oc3RydWN0IGFxX3Jp
bmdfcyAqc2VsZikNCiB7DQogCXN0cnVjdCBkZXZpY2UgKmRldiA9IGFxX25pY19nZXRfZGV2KHNl
bGYtPmFxX25pYyk7DQotCXVuc2lnbmVkIGludCBidWRnZXQgPSBBUV9DRkdfVFhfQ0xFQU5fQlVE
R0VUOw0KKwl1bnNpZ25lZCBpbnQgYnVkZ2V0Ow0KIA0KLQlmb3IgKDsgc2VsZi0+c3dfaGVhZCAh
PSBzZWxmLT5od19oZWFkICYmIGJ1ZGdldC0tOw0KLQkJc2VsZi0+c3dfaGVhZCA9IGFxX3Jpbmdf
bmV4dF9keChzZWxmLCBzZWxmLT5zd19oZWFkKSkgew0KKwlmb3IgKGJ1ZGdldCA9IEFRX0NGR19U
WF9DTEVBTl9CVURHRVQ7DQorCSAgICAgYnVkZ2V0ICYmIHNlbGYtPnN3X2hlYWQgIT0gc2VsZi0+
aHdfaGVhZDsgYnVkZ2V0LS0pIHsNCiAJCXN0cnVjdCBhcV9yaW5nX2J1ZmZfcyAqYnVmZiA9ICZz
ZWxmLT5idWZmX3Jpbmdbc2VsZi0+c3dfaGVhZF07DQogDQogCQlpZiAobGlrZWx5KGJ1ZmYtPmlz
X21hcHBlZCkpIHsNCkBAIC0yNTEsNiArMjUxLDcgQEAgYm9vbCBhcV9yaW5nX3R4X2NsZWFuKHN0
cnVjdCBhcV9yaW5nX3MgKnNlbGYpDQogDQogCQlidWZmLT5wYSA9IDBVOw0KIAkJYnVmZi0+ZW9w
X2luZGV4ID0gMHhmZmZmVTsNCisJCXNlbGYtPnN3X2hlYWQgPSBhcV9yaW5nX25leHRfZHgoc2Vs
Ziwgc2VsZi0+c3dfaGVhZCk7DQogCX0NCiANCiAJcmV0dXJuICEhYnVkZ2V0Ow0KLS0gDQoyLjE3
LjENCg0K
