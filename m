Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E2919BE8
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfEJKuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 06:50:16 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:55334
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727261AbfEJKuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 06:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRJLFskhBZ3Idvkyic7a+xonJQZtqLBXTWMknXtKZ/A=;
 b=Fh5nP7kOXZQeA4J9+hqof0P2MiQweeMOQJCvB/K+6gIay3Td3YiS+PrA31o/l0pY/4f252FRg6DHTIhMr20rXBR1Iy309AMUcbT6WSixS4LdXQr9ixkbv1W2mplxOa/HO2RF0HDU1+fuZoXIuEAk+ZM8y/a9ekvTDPWJxS5dPN4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5994.eurprd04.prod.outlook.com (20.178.107.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Fri, 10 May 2019 10:50:08 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%5]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 10:50:08 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan-gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 5/7] can: flexcan: add CANFD BRS support
Thread-Topic: [PATCH V3 5/7] can: flexcan: add CANFD BRS support
Thread-Index: AQHVBx4iCuXpE6ibpkugP1YRzCfHOw==
Date:   Fri, 10 May 2019 10:50:08 +0000
Message-ID: <20190510104639.15170-6-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: 372ea60f-2657-41ae-9120-08d6d5354471
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5994;
x-ms-traffictypediagnostic: DB7PR04MB5994:
x-microsoft-antispam-prvs: <DB7PR04MB59945EE7EE363A50EA9B27CCE60C0@DB7PR04MB5994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(54534003)(14454004)(11346002)(478600001)(66066001)(4326008)(66556008)(64756008)(66446008)(53936002)(66476007)(8936002)(81166006)(6436002)(81156014)(25786009)(8676002)(1076003)(6486002)(2501003)(6116002)(3846002)(186003)(2906002)(50226002)(305945005)(73956011)(14444005)(71190400001)(6512007)(71200400001)(446003)(66946007)(5660300002)(54906003)(2616005)(476003)(36756003)(86362001)(26005)(110136005)(7736002)(76176011)(102836004)(386003)(68736007)(99286004)(52116002)(6506007)(486006)(256004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5994;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DBH3fUwbTtO5/5k49jUb9VBmjJ4hFgVtEbZN/SQFZUc6GS25nGAZ6YhPhx8KsMT/hrHNQVpL0GD7D8gp/a5UWo4+7IM2aRxCLCgG6a++jiEmGkIo5keOEI2RHpEL48p2uOG6OZ0NXC8EpXHeDiBDNDfCdJJ3XSTSmt5b+mw2fuBN9ic50I1nSRGN/J/IMVolsdyrg3WRAAgAnJdMTR5AegHNmJThl0BFLqORKrLKZJ+zs+fnqCgAa2nTcUDVraSQXnNIxmKifzlZGw3abuACiyQ+PGoz0gJNMBDeWys7ucpe4eEm8izijHnq/HYaaUTGUsfAaFCzXnUYoh91oMMzbD8mL3nKI+LptrcoxUggFHAwpfDARmtyFB7sAlQhcs4vxkNuexinkBL/lOpXjfttyOZHTz6yQbSG7JHhULUB70o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372ea60f-2657-41ae-9120-08d6d5354471
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 10:50:08.2053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5994
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG9uZyBBaXNoZW5nIDxhaXNoZW5nLmRvbmdAbnhwLmNvbT4NCg0KVGhpcyBwYXRjaCBp
bnRlbmRzIHRvIGFkZCBDQU4gRkQgQml0UmF0ZSBTd2l0Y2goQlJTKSBzdXBwb3J0IGluIGRyaXZl
ci4NCg0KU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNv
bT4NClNpZ25lZC1vZmYtYnk6IERvbmcgQWlzaGVuZyA8YWlzaGVuZy5kb25nQG54cC5jb20+DQoN
CkNoYW5nZUxvZzoNCi0tLS0tLS0tLS0NClYyLT5WMzoNCgkqc3BsaXQgZnJvbSBhbm90aGVyIHBh
dGNoDQotLS0NCiBkcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIHwgOSArKysrKysrKy0NCiAxIGZp
bGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0K
aW5kZXggYzQ1YzkyOTQ4MTk1Li5jYTcyNDBkNjkwNDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC9jYW4vZmxleGNhbi5jDQorKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQpAQCAtNjg3
LDggKzY4NywxMiBAQCBzdGF0aWMgbmV0ZGV2X3R4X3QgZmxleGNhbl9zdGFydF94bWl0KHN0cnVj
dCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZQ0KIAkJY3RybCB8PSBGTEVYQ0FO
X01CX0NOVF9SVFI7DQogDQogCWlmIChwcml2LT5jYW4uY3RybG1vZGUgJiBDQU5fQ1RSTE1PREVf
RkQpIHsNCi0JCWlmIChjYW5faXNfY2FuZmRfc2tiKHNrYikpDQorCQlpZiAoY2FuX2lzX2NhbmZk
X3NrYihza2IpKSB7DQogCQkJY3RybCB8PSBGTEVYQ0FOX01CX0NOVF9FREw7DQorDQorCQkJaWYg
KGNmLT5mbGFncyAmIENBTkZEX0JSUykNCisJCQkJY3RybCB8PSBGTEVYQ0FOX01CX0NOVF9CUlM7
DQorCQl9DQogCX0NCiANCiAJZm9yIChpID0gMDsgaSA8IGNmLT5sZW47IGkgKz0gc2l6ZW9mKHUz
MikpIHsNCkBAIC05MDksNiArOTEzLDkgQEAgc3RhdGljIHVuc2lnbmVkIGludCBmbGV4Y2FuX21h
aWxib3hfcmVhZChzdHJ1Y3QgY2FuX3J4X29mZmxvYWQgKm9mZmxvYWQsIGJvb2wgZHINCiANCiAJ
CWlmIChyZWdfY3RybCAmIEZMRVhDQU5fTUJfQ05UX0VETCkgew0KIAkJCWNmLT5sZW4gPSBjYW5f
ZGxjMmxlbigocmVnX2N0cmwgPj4gMTYpICYgMHgwRik7DQorDQorCQkJaWYgKHJlZ19jdHJsICYg
RkxFWENBTl9NQl9DTlRfQlJTKQ0KKwkJCQljZi0+ZmxhZ3MgfD0gQ0FORkRfQlJTOw0KIAkJfSBl
bHNlIHsNCiAJCQljZi0+bGVuID0gZ2V0X2Nhbl9kbGMoKHJlZ19jdHJsID4+IDE2KSAmIDB4MEYp
Ow0KIA0KLS0gDQoyLjE3LjENCg0K
