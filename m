Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2BB19BE0
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 12:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfEJKuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 06:50:04 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:55334
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727100AbfEJKuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 06:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rmyv4pAE/O/k5FaY7V/aBByi3Xjz8jI17Mm+PMi974=;
 b=Sld5SI/39Bpj1IfOU6B1nOVvI+mr0R2hlfdjNr5ImnKMqmvi4yiPUHPqSYXPSFttGwlQFMTDeNisRrLBoSk+lxcc43HwJkYFJdeMrUEGf7pVHJ11wjoGPjXAkussy4y/6EA9+Fjd7TVOzXPuBr+nBcrXMzsXWhO7SlvyuQmZgNo=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5994.eurprd04.prod.outlook.com (20.178.107.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Fri, 10 May 2019 10:49:56 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%5]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 10:49:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan-gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 1/7] can: flexcan: allocate skb in mailbox_read
Thread-Topic: [PATCH V3 1/7] can: flexcan: allocate skb in mailbox_read
Thread-Index: AQHVBx4a60AxWdzQGUaUeNc6SkgVPg==
Date:   Fri, 10 May 2019 10:49:55 +0000
Message-ID: <20190510104639.15170-2-qiangqing.zhang@nxp.com>
References: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae7e8505-0f25-4af8-4975-08d6d5353d36
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5994;
x-ms-traffictypediagnostic: DB7PR04MB5994:
x-microsoft-antispam-prvs: <DB7PR04MB5994E540E237EBC6696C1221E60C0@DB7PR04MB5994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(54534003)(14454004)(11346002)(478600001)(66066001)(4326008)(66556008)(64756008)(66446008)(53936002)(66476007)(8936002)(81166006)(6436002)(81156014)(25786009)(8676002)(1076003)(6486002)(2501003)(6116002)(3846002)(186003)(2906002)(50226002)(305945005)(73956011)(71190400001)(6512007)(71200400001)(446003)(66946007)(5660300002)(54906003)(2616005)(476003)(36756003)(86362001)(26005)(110136005)(7736002)(76176011)(102836004)(15650500001)(386003)(68736007)(99286004)(52116002)(6506007)(486006)(256004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5994;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 99e8tfQiR9WmSmjwdt1aUYbskFUGRjdPygeVtUO9rhTp/fubliL/viWj8kVgKnmf/i18Gi6IDcD9hw1aoiWYS1RQeF0Wxa8QboI97lwsdR8gtW7u2WVcK2ji3hFEAjMux1kwvgiXL6oJcc58fMzOFmq2VSoXnf0AdKJvkK/81xVLO4wRmdmP8N71DuRsyrX90cunlxeFGJlWDBGVdGcGcjCy/T8V8ftVpPgY3A1h0OgnO4KFPpKkoWsw2IoBVcfKkxrYF4MSd4w/s5K0cL39y7qWlqp3NRUHz30N87lZTTj3eDMo5n0QUlLl/N50QwnSFo/NOCPLyzo/61x75oBqS6409Nb0ESPks9ZiIaNNS1a7QnhhfT+WHU1o1WBbNrIMetWu3w6bDsndK8WrxVlGsxQ2YVMeCxNdsTvZsGz4hbk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7e8505-0f25-4af8-4975-08d6d5353d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 10:49:56.0187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5994
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2UgbmVlZCB0byB1c2UgYWxsb2NfY2FuZmRfc2tiKCkgZm9yIENBTiBGRCBmcmFtZXMgYW5kIGFs
bG9jX2Nhbl9za2IoKQ0KZm9yIENBTiBjbGFzc2ljIGZyYW1lcy4gU28gd2UgaGF2ZSB0byBhbGxv
YyBza2IgaW4gZmxleGNhbl9tYWlsYm94X3JlYWQoKS4NCg0KU2lnbmVkLW9mZi1ieTogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCg0KQ2hhbmdlTG9nOg0KLS0tLS0tLS0t
LQ0KVjEtPlYyOg0KCSpOb25lDQpWMi0+VjM6DQoJKkNoYW5nZSB0aGUgd2F5IHRvIGFsbG9jYXRl
IHNrYg0KLS0tDQogZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyAgICAgIHwgMzggKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvbmV0L2Nhbi9yeC1vZmZsb2FkLmMg
ICB8IDI5ICsrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQogaW5jbHVkZS9saW51eC9jYW4vcngt
b2ZmbG9hZC5oIHwgIDUgKysrLS0NCiAzIGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyks
IDM5IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
YyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IGUzNTA4M2ZmMzFlZS4uZjc0MjA3
N2U4ZjkzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KKysrIGIvZHJp
dmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KQEAgLTc4OSwxNCArNzg5LDE1IEBAIHN0YXRpYyBpbmxp
bmUgc3RydWN0IGZsZXhjYW5fcHJpdiAqcnhfb2ZmbG9hZF90b19wcml2KHN0cnVjdCBjYW5fcnhf
b2ZmbG9hZCAqb2ZmDQogCXJldHVybiBjb250YWluZXJfb2Yob2ZmbG9hZCwgc3RydWN0IGZsZXhj
YW5fcHJpdiwgb2ZmbG9hZCk7DQogfQ0KIA0KLXN0YXRpYyB1bnNpZ25lZCBpbnQgZmxleGNhbl9t
YWlsYm94X3JlYWQoc3RydWN0IGNhbl9yeF9vZmZsb2FkICpvZmZsb2FkLA0KLQkJCQkJIHN0cnVj
dCBjYW5fZnJhbWUgKmNmLA0KLQkJCQkJIHUzMiAqdGltZXN0YW1wLCB1bnNpZ25lZCBpbnQgbikN
CitzdGF0aWMgdW5zaWduZWQgaW50IGZsZXhjYW5fbWFpbGJveF9yZWFkKHN0cnVjdCBjYW5fcnhf
b2ZmbG9hZCAqb2ZmbG9hZCwgYm9vbCBkcm9wLA0KKwkJCQkJIHN0cnVjdCBza19idWZmICoqc2ti
LCB1MzIgKnRpbWVzdGFtcCwNCisJCQkJCSB1bnNpZ25lZCBpbnQgbikNCiB7DQogCXN0cnVjdCBm
bGV4Y2FuX3ByaXYgKnByaXYgPSByeF9vZmZsb2FkX3RvX3ByaXYob2ZmbG9hZCk7DQogCXN0cnVj
dCBmbGV4Y2FuX3JlZ3MgX19pb21lbSAqcmVncyA9IHByaXYtPnJlZ3M7DQogCXN0cnVjdCBmbGV4
Y2FuX21iIF9faW9tZW0gKm1iOw0KIAl1MzIgcmVnX2N0cmwsIHJlZ19pZCwgcmVnX2lmbGFnMTsN
CisJc3RydWN0IGNhbl9mcmFtZSAqY2Y7DQogCWludCBpOw0KIA0KIAltYiA9IGZsZXhjYW5fZ2V0
X21iKHByaXYsIG4pOw0KQEAgLTgyNywyMiArODI4LDI3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQg
ZmxleGNhbl9tYWlsYm94X3JlYWQoc3RydWN0IGNhbl9yeF9vZmZsb2FkICpvZmZsb2FkLA0KIAkJ
cmVnX2N0cmwgPSBwcml2LT5yZWFkKCZtYi0+Y2FuX2N0cmwpOw0KIAl9DQogDQotCS8qIGluY3Jl
YXNlIHRpbXN0YW1wIHRvIGZ1bGwgMzIgYml0ICovDQotCSp0aW1lc3RhbXAgPSByZWdfY3RybCA8
PCAxNjsNCisJaWYgKCFkcm9wKQ0KKwkJKnNrYiA9IGFsbG9jX2Nhbl9za2Iob2ZmbG9hZC0+ZGV2
LCAmY2YpOw0KIA0KLQlyZWdfaWQgPSBwcml2LT5yZWFkKCZtYi0+Y2FuX2lkKTsNCi0JaWYgKHJl
Z19jdHJsICYgRkxFWENBTl9NQl9DTlRfSURFKQ0KLQkJY2YtPmNhbl9pZCA9ICgocmVnX2lkID4+
IDApICYgQ0FOX0VGRl9NQVNLKSB8IENBTl9FRkZfRkxBRzsNCi0JZWxzZQ0KLQkJY2YtPmNhbl9p
ZCA9IChyZWdfaWQgPj4gMTgpICYgQ0FOX1NGRl9NQVNLOw0KKwlpZiAoKnNrYikgew0KKwkJLyog
aW5jcmVhc2UgdGltc3RhbXAgdG8gZnVsbCAzMiBiaXQgKi8NCisJCSp0aW1lc3RhbXAgPSByZWdf
Y3RybCA8PCAxNjsNCiANCi0JaWYgKHJlZ19jdHJsICYgRkxFWENBTl9NQl9DTlRfUlRSKQ0KLQkJ
Y2YtPmNhbl9pZCB8PSBDQU5fUlRSX0ZMQUc7DQotCWNmLT5jYW5fZGxjID0gZ2V0X2Nhbl9kbGMo
KHJlZ19jdHJsID4+IDE2KSAmIDB4Zik7DQorCQlyZWdfaWQgPSBwcml2LT5yZWFkKCZtYi0+Y2Fu
X2lkKTsNCisJCWlmIChyZWdfY3RybCAmIEZMRVhDQU5fTUJfQ05UX0lERSkNCisJCQljZi0+Y2Fu
X2lkID0gKChyZWdfaWQgPj4gMCkgJiBDQU5fRUZGX01BU0spIHwgQ0FOX0VGRl9GTEFHOw0KKwkJ
ZWxzZQ0KKwkJCWNmLT5jYW5faWQgPSAocmVnX2lkID4+IDE4KSAmIENBTl9TRkZfTUFTSzsNCiAN
Ci0JZm9yIChpID0gMDsgaSA8IGNmLT5jYW5fZGxjOyBpICs9IHNpemVvZih1MzIpKSB7DQotCQlf
X2JlMzIgZGF0YSA9IGNwdV90b19iZTMyKHByaXYtPnJlYWQoJm1iLT5kYXRhW2kgLyBzaXplb2Yo
dTMyKV0pKTsNCi0JCSooX19iZTMyICopKGNmLT5kYXRhICsgaSkgPSBkYXRhOw0KKwkJaWYgKHJl
Z19jdHJsICYgRkxFWENBTl9NQl9DTlRfUlRSKQ0KKwkJCWNmLT5jYW5faWQgfD0gQ0FOX1JUUl9G
TEFHOw0KKwkJY2YtPmNhbl9kbGMgPSBnZXRfY2FuX2RsYygocmVnX2N0cmwgPj4gMTYpICYgMHhm
KTsNCisNCisJCWZvciAoaSA9IDA7IGkgPCBjZi0+Y2FuX2RsYzsgaSArPSBzaXplb2YodTMyKSkg
ew0KKwkJCV9fYmUzMiBkYXRhID0gY3B1X3RvX2JlMzIocHJpdi0+cmVhZCgmbWItPmRhdGFbaSAv
IHNpemVvZih1MzIpXSkpOw0KKwkJCSooX19iZTMyICopKGNmLT5kYXRhICsgaSkgPSBkYXRhOw0K
KwkJfQ0KIAl9DQogDQogCS8qIG1hcmsgYXMgcmVhZCAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2Nhbi9yeC1vZmZsb2FkLmMgYi9kcml2ZXJzL25ldC9jYW4vcngtb2ZmbG9hZC5jDQppbmRl
eCAyY2U0ZmE4Njk4YzcuLjYzMjkxOTQ4NGZmNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2Nh
bi9yeC1vZmZsb2FkLmMNCisrKyBiL2RyaXZlcnMvbmV0L2Nhbi9yeC1vZmZsb2FkLmMNCkBAIC0x
MjEsMzIgKzEyMSwxOSBAQCBzdGF0aWMgaW50IGNhbl9yeF9vZmZsb2FkX2NvbXBhcmUoc3RydWN0
IHNrX2J1ZmYgKmEsIHN0cnVjdCBza19idWZmICpiKQ0KIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAq
Y2FuX3J4X29mZmxvYWRfb2ZmbG9hZF9vbmUoc3RydWN0IGNhbl9yeF9vZmZsb2FkICpvZmZsb2Fk
LCB1bnNpZ25lZCBpbnQgbikNCiB7DQogCXN0cnVjdCBza19idWZmICpza2IgPSBOVUxMOw0KLQlz
dHJ1Y3QgY2FuX3J4X29mZmxvYWRfY2IgKmNiOw0KLQlzdHJ1Y3QgY2FuX2ZyYW1lICpjZjsNCi0J
aW50IHJldDsNCisJdTMyIHRpbWVzdGFtcDsNCiANCiAJLyogSWYgcXVldWUgaXMgZnVsbCBvciBz
a2Igbm90IGF2YWlsYWJsZSwgcmVhZCB0byBkaXNjYXJkIG1haWxib3ggKi8NCi0JaWYgKGxpa2Vs
eShza2JfcXVldWVfbGVuKCZvZmZsb2FkLT5za2JfcXVldWUpIDw9DQotCQkgICBvZmZsb2FkLT5z
a2JfcXVldWVfbGVuX21heCkpDQotCQlza2IgPSBhbGxvY19jYW5fc2tiKG9mZmxvYWQtPmRldiwg
JmNmKTsNCisJYm9vbCBkcm9wID0gdW5saWtlbHkoc2tiX3F1ZXVlX2xlbigmb2ZmbG9hZC0+c2ti
X3F1ZXVlKSA+DQorCQkJICAgICBvZmZsb2FkLT5za2JfcXVldWVfbGVuX21heCk7DQogDQotCWlm
ICghc2tiKSB7DQotCQlzdHJ1Y3QgY2FuX2ZyYW1lIGNmX292ZXJmbG93Ow0KLQkJdTMyIHRpbWVz
dGFtcDsNCisJaWYgKG9mZmxvYWQtPm1haWxib3hfcmVhZChvZmZsb2FkLCBkcm9wLCAmc2tiLCAm
dGltZXN0YW1wLCBuKSAmJiAhc2tiKQ0KKwkJb2ZmbG9hZC0+ZGV2LT5zdGF0cy5yeF9kcm9wcGVk
Kys7DQogDQotCQlyZXQgPSBvZmZsb2FkLT5tYWlsYm94X3JlYWQob2ZmbG9hZCwgJmNmX292ZXJm
bG93LA0KLQkJCQkJICAgICZ0aW1lc3RhbXAsIG4pOw0KLQkJaWYgKHJldCkNCi0JCQlvZmZsb2Fk
LT5kZXYtPnN0YXRzLnJ4X2Ryb3BwZWQrKzsNCisJaWYgKHNrYikgew0KKwkJc3RydWN0IGNhbl9y
eF9vZmZsb2FkX2NiICpjYiA9IGNhbl9yeF9vZmZsb2FkX2dldF9jYihza2IpOw0KIA0KLQkJcmV0
dXJuIE5VTEw7DQotCX0NCi0NCi0JY2IgPSBjYW5fcnhfb2ZmbG9hZF9nZXRfY2Ioc2tiKTsNCi0J
cmV0ID0gb2ZmbG9hZC0+bWFpbGJveF9yZWFkKG9mZmxvYWQsIGNmLCAmY2ItPnRpbWVzdGFtcCwg
bik7DQotCWlmICghcmV0KSB7DQotCQlrZnJlZV9za2Ioc2tiKTsNCi0JCXJldHVybiBOVUxMOw0K
KwkJY2ItPnRpbWVzdGFtcCA9IHRpbWVzdGFtcDsNCiAJfQ0KIA0KIAlyZXR1cm4gc2tiOw0KZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvY2FuL3J4LW9mZmxvYWQuaCBiL2luY2x1ZGUvbGludXgv
Y2FuL3J4LW9mZmxvYWQuaA0KaW5kZXggODI2ODgxMWE2OTdlLi5jNTRkODBlZjQzMTQgMTAwNjQ0
DQotLS0gYS9pbmNsdWRlL2xpbnV4L2Nhbi9yeC1vZmZsb2FkLmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvY2FuL3J4LW9mZmxvYWQuaA0KQEAgLTIzLDggKzIzLDkgQEANCiBzdHJ1Y3QgY2FuX3J4X29m
ZmxvYWQgew0KIAlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2Ow0KIA0KLQl1bnNpZ25lZCBpbnQgKCpt
YWlsYm94X3JlYWQpKHN0cnVjdCBjYW5fcnhfb2ZmbG9hZCAqb2ZmbG9hZCwgc3RydWN0IGNhbl9m
cmFtZSAqY2YsDQotCQkJCSAgICAgdTMyICp0aW1lc3RhbXAsIHVuc2lnbmVkIGludCBtYik7DQor
CXVuc2lnbmVkIGludCAoKm1haWxib3hfcmVhZCkoc3RydWN0IGNhbl9yeF9vZmZsb2FkICpvZmZs
b2FkLCBib29sIGRyb3AsDQorCQkJCSAgICAgc3RydWN0IHNrX2J1ZmYgKipza2IsIHUzMiAqdGlt
ZXN0YW1wLA0KKwkJCQkgICAgIHVuc2lnbmVkIGludCBtYik7DQogDQogCXN0cnVjdCBza19idWZm
X2hlYWQgc2tiX3F1ZXVlOw0KIAl1MzIgc2tiX3F1ZXVlX2xlbl9tYXg7DQotLSANCjIuMTcuMQ0K
DQo=
