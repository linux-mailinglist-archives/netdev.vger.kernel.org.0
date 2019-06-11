Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034693C498
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404199AbfFKG6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:58:38 -0400
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:29085
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403758AbfFKG6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 02:58:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x31bpzNhQAPwsNqF4u9x7C60redJ0ERVIvrvhVnFHfQ=;
 b=sdEnoq4Ub2g3r8DzJTBPcjmykbdk9eQqHdRM+XKUCR+4NzcP/7h+Q8H4S2S+PYNIMW4LXSEE/vhZNXqY5IvVTh+BPAFtDc/+NGWqVs7SegoZYOqErVisJG8nmK193ss4+LhS2ChY5UYoqWvctP4S2vPaqrf89kaP0dgDT5ddFOE=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5579.eurprd04.prod.outlook.com (20.178.106.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Tue, 11 Jun 2019 06:58:31 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c%6]) with mapi id 15.20.1987.010; Tue, 11 Jun 2019
 06:58:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVDFm06ozNDmulK0GLXWOup5sGAaaSKhwAgAQCnFA=
Date:   Tue, 11 Jun 2019 06:58:31 +0000
Message-ID: <DB7PR04MB46181EE74BF030D728042FD6E6ED0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
 <fbbe474f-bdf7-a97a-543d-da17dfd2a114@geanix.com>
In-Reply-To: <fbbe474f-bdf7-a97a-543d-da17dfd2a114@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24c3af61-0d6f-4942-28e3-08d6ee3a36ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5579;
x-ms-traffictypediagnostic: DB7PR04MB5579:
x-microsoft-antispam-prvs: <DB7PR04MB55790CA0735DFD19FF5D3D8AE6ED0@DB7PR04MB5579.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(39860400002)(376002)(136003)(396003)(366004)(346002)(13464003)(189003)(199004)(110136005)(54906003)(8676002)(25786009)(229853002)(66946007)(8936002)(2501003)(53936002)(4326008)(26005)(14444005)(81156014)(3846002)(7736002)(14454004)(305945005)(2906002)(81166006)(33656002)(6246003)(256004)(66066001)(2201001)(6506007)(66476007)(316002)(52536014)(74316002)(476003)(6436002)(99286004)(66556008)(64756008)(478600001)(486006)(66446008)(186003)(7696005)(76116006)(53546011)(71200400001)(446003)(9686003)(11346002)(86362001)(68736007)(55016002)(102836004)(5660300002)(71190400001)(73956011)(76176011)(6116002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5579;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0tpGHDchMzICFZdz+76b2bOF6hOBw8uRw5xuka1R9r785oat84n8DsS//+j2ORZ51Y+qOxjrTXN3kfdcNQjUzVSDMrv1Tt8pME8mRQbjkc2TVH38fealVnzMc6zWIkmwJYZtmqXLbIJKwLRCw0tf3qCt9DM+pHw8+V312v//f2q3oJhacoPFSTii0tSPPw4FPHxB9Akhux1uWrUD91NndxO+iWaubp7fvazPE4XTAKUanC3suOLas7KAI0M08yH3KijxWvL/R6QfmqxZo96j4Mi5fyoLt2OTBMPL7i44xq/wA0hyf1mlXn1uAikZtmWHiPh+JQfY0Hi1zSytKQkHQ7bfWX58cOLVXvowhPwzv6APOrUVKsrxh4Ssm6Tzse9D6AfxBkj4MU+HCDncRyNRy6iyKXQdHNGSO/z1ORB4ttk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c3af61-0d6f-4942-28e3-08d6ee3a36ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 06:58:31.2869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5579
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDbmnIg55pelIDE6NDINCj4gVG86IEpvYWtp
bSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7DQo+
IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+OyB3Z0BncmFuZGVnZ2VyLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBSZTogW1BBVENIXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVz
aW5nIHNlbGYgd2FrZXVwDQo+IA0KPiANCj4gDQo+IE9uIDE3LzA1LzIwMTkgMDQuMzksIEpvYWtp
bSBaaGFuZyB3cm90ZToNCj4gPiBBcyByZXByb3RlZCBieSBTZWFuIE55ZWtqYWVyIGJlbGxvdzoN
Cj4gPiBXaGVuIHN1c3BlbmRpbmcsIHdoZW4gdGhlcmUgaXMgc3RpbGwgY2FuIHRyYWZmaWMgb24g
dGhlIGludGVyZmFjZXMgdGhlDQo+ID4gZmxleGNhbiBpbW1lZGlhdGVseSB3YWtlcyB0aGUgcGxh
dGZvcm0gYWdhaW4uDQo+ID4gQXMgaXQgc2hvdWxkIDotKQ0KPiA+IEJ1dCBpdCB0aHJvd3MgdGhp
cyBlcnJvciBtc2c6DQo+ID4gWyAzMTY5LjM3ODY2MV0gUE06IG5vaXJxIHN1c3BlbmQgb2YgZGV2
aWNlcyBmYWlsZWQNCj4gPg0KPiA+IE9uIHRoZSB3YXkgZG93biB0byBzdXNwZW5kIHRoZSBpbnRl
cmZhY2UgdGhhdCB0aHJvd3MgdGhlIGVycm9yIG1lc3NhZ2UNCj4gPiBkb2VzIGNhbGwgZmxleGNh
bl9zdXNwZW5kIGJ1dCBmYWlscyB0byBjYWxsIGZsZXhjYW5fbm9pcnFfc3VzcGVuZC4NCj4gPiBU
aGF0IG1lYW5zIHRoZSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZSBpcyBjYWxsZWQsIGJ1dCBvbiB0
aGUgd2F5IG91dA0KPiA+IG9mIHN1c3BlbmQgdGhlIGRyaXZlciBvbmx5IGNhbGxzIGZsZXhjYW5f
cmVzdW1lIGFuZCBza2lwcw0KPiA+IGZsZXhjYW5fbm9pcnFfcmVzdW1lLCB0aHVzIGl0IGRvZXNu
J3QgY2FsbCBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlLg0KPiA+IFRoaXMgbGVhdmVzIHRoZSBmbGV4
Y2FuIGluIHN0b3AgbW9kZSwgYW5kIHdpdGggdGhlIGN1cnJlbnQgZHJpdmVyIGl0DQo+ID4gY2Fu
J3QgcmVjb3ZlciBmcm9tIHRoaXMgZXZlbiB3aXRoIGEgc29mdCByZWJvb3QsIGl0IHJlcXVpcmVz
IGEgaGFyZA0KPiA+IHJlYm9vdC4NCj4gPg0KPiA+IEZpeGVzOiBkZTM1NzhjMTk4YzYgKCJjYW46
IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gPg0KPiA+IFRoaXMgcGF0Y2gg
aW50ZW5kcyB0byBmaXggdGhlIGlzc3VlLCBhbmQgYWxzbyBhZGQgY29tbWVudCB0byBleHBsYWlu
DQo+ID4gdGhlIHdha2V1cCBmbG93Lg0KPiA+IFJlcG9ydGVkLWJ5OiBTZWFuIE55ZWtqYWVyIDxz
ZWFuQGdlYW5peC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCj4gDQo+IEhvdyBpcyBpdCBnb2luZyB3aXRoIHRoZSB1cGRhdGVk
IHBhdGNoPw0KDQpIaSBTZWFuLA0KDQoJSSBzdGlsbCBuZWVkIGRpc2N1c3Mgd2l0aCBNYXJjIGFi
b3V0IHRoZSBzb2x1dGlvbi4NCg0KSm9ha2ltIFpoYW5nDQo+IC9TZWFuDQo=
