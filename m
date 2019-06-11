Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F423C4EF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404395AbfFKHVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:21:32 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:47620
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404172AbfFKHVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 03:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWWNKVep2Wj9wVubE7u2DAC6r60yPNxVqgZpipxXK/k=;
 b=JZgRHM2PV73C9eieSvbQNTM9+REgJC7289yD+TIA18vl/+5mcLu04BME311WbENsHETQ9HEsgFUXmDhxLgcwfqPhW4/EXJj3prwURnaw6VTkHgqb3RHYiWQD4WzFbJTG1XLAcsxH7kBb8h9yEZbXL/o7SXNPkfuOrkhn830BC8c=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5483.eurprd04.prod.outlook.com (20.178.105.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.16; Tue, 11 Jun 2019 07:21:28 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c%6]) with mapi id 15.20.1987.010; Tue, 11 Jun 2019
 07:21:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>
CC:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVDFm06ozNDmulK0GLXWOup5sGAaaSKhwAgAQCnFCAAAN3gIAAAxLA
Date:   Tue, 11 Jun 2019 07:21:28 +0000
Message-ID: <DB7PR04MB46189DAF8C292DD7F00718F8E6ED0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
 <fbbe474f-bdf7-a97a-543d-da17dfd2a114@geanix.com>
 <DB7PR04MB46181EE74BF030D728042FD6E6ED0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <23fcfa1b-a664-7768-a793-26627b14463e@geanix.com>
In-Reply-To: <23fcfa1b-a664-7768-a793-26627b14463e@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 387b14a5-565a-44b8-23ee-08d6ee3d6b7d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5483;
x-ms-traffictypediagnostic: DB7PR04MB5483:
x-microsoft-antispam-prvs: <DB7PR04MB5483E36EF3C4A8EF54339B41E6ED0@DB7PR04MB5483.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(13464003)(53936002)(486006)(14454004)(446003)(66476007)(68736007)(476003)(478600001)(76176011)(66446008)(186003)(33656002)(81156014)(64756008)(66556008)(71190400001)(6246003)(316002)(102836004)(71200400001)(6506007)(74316002)(6916009)(11346002)(66946007)(76116006)(26005)(25786009)(73956011)(53546011)(8936002)(5660300002)(99286004)(3846002)(81166006)(8676002)(86362001)(256004)(54906003)(55016002)(305945005)(229853002)(66066001)(4744005)(6116002)(14444005)(2906002)(6436002)(52536014)(4326008)(9686003)(7736002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5483;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YEz3ae3WjBRJwDDW7+CAcPTVHYIE83ctcD2zW/iErOrIYK6Uz3/7DyC1VRIoylty9APsAfzO9ZECuasiCGXzyPygj1uhjxTaUWO4tcDcNjL4IWybCHGBrOAYx0ctlrVWzDUCh+6XKYCBnKrY4Ezug0t2YpV9twQlEOJRI3N5qDPhQKs/4ARSZ3gfv+67osIw1x+en91+r/z/A4w1WLCodKb9cwLcky3KvZHBj9EFopNE3Xjfd+wsm9iXLUN1Ros9vSJdeKnya1nN9+Q00Oo+boUG2Eo2Beo22nQe9NWg02NPnzONqTSz7EoRkvj/n/QkRbwrPc3UfTTdzc8qh+7u01gCgJTYurBLTo1HUUJ6c4dhbEohVbe0KCnB6hUkok57bVsi/HUs2aL9TZUANyR7DIw/ExIE3C4Dj8EIhBrfEAo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387b14a5-565a-44b8-23ee-08d6ee3d6b7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 07:21:28.1823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5483
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDbmnIgxMeaXpSAxNTowOA0KPiBUbzogSm9h
a2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IG1rbEBwZW5ndXRyb25p
eC5kZTsgbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1p
bXhAbnhwLmNvbT47IHdnQGdyYW5kZWdnZXIuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGNhbjogZmxleGNhbjogZml4IGRlYWRsb2NrIHdoZW4gdXNp
bmcgc2VsZiB3YWtldXANCj4gDQo+IA0KPiANCj4gT24gMTEvMDYvMjAxOSAwOC41OCwgSm9ha2lt
IFpoYW5nIHdyb3RlOg0KPiA+Pg0KPiA+PiBIb3cgaXMgaXQgZ29pbmcgd2l0aCB0aGUgdXBkYXRl
ZCBwYXRjaD8NCj4gPg0KPiA+IEhpIFNlYW4sDQo+ID4NCj4gPiAJSSBzdGlsbCBuZWVkIGRpc2N1
c3Mgd2l0aCBNYXJjIGFib3V0IHRoZSBzb2x1dGlvbi4NCj4gPg0KPiA+IEpvYWtpbSBaaGFuZw0K
PiANCj4gSGksIEpvYWtpbQ0KPiANCj4gUGxlYXNlIGluY2x1ZGUgbWUgaW4gdGhlIGxvb3AgOi0p
DQoNCk9rYXksIHdpbGwgYWRkIHlvdSBpZiBhbnl0aGluZyB1cGRhdGUuDQoNCkpvYWtpbSBaaGFu
Zw0KPiANCj4gL1NlYW4NCg==
