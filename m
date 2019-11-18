Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712BC100000
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKRIEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:04:45 -0500
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:56293
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbfKRIEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 03:04:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEzY6pbAGkTLpPKnUGr/jMIIaPH3Ybl6XpSAnBxea/euF2CL8ZJ0K81J7GfFB0YgpbjqSvjAiy1ceDtB344A5x3ZCX7TdUcsvFxxywOXEHX5zdOAt34BSceaM42Ie8AnE35Sx0W+Osqpehmgc4GtIGdGjXvhoVI6wNV08Hu22UdB52OQNxx+OlPjyV+crQxb0e5ie1Axmiw4hekYG41BU3RbaatqJwL16X5KXge4CCYmx6uTrV9mqZrikuQxWVHBML/tPwlTobkFGfCVR8Xt+xxllGdfqK+QMEcIHDXguuvZgxxKviqhp4anKHOqdlytFlNoohYVVigDHWYQRyf4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1Ni7KvWuNSEhlD8MpJUXHJUYlLoTYUluSIyTo8ds4M=;
 b=JXVH/8g/Qrx+fsS8ebUqOPQ1i2zIEsGaTvziqQObKrLkWBaZM5Slp/azJo7gW0+qnYXli3+xgpUhyDiXl2sDZt8bXl5Is+lv9ibwDj6u8i8EqJHbk5hAgFygSoOnq5V+hliZCNIangt4O/xrP0qoUil4oG37Q5Baq37GBuhObUdhhOkAlNILfjV8GP5R65rJVBg9i+bhFqBvaaugqksUU9SIOZ23exfJWDAwQoAdakbEjiGZgqgf/fktKqIcUBVSwHW1dKvTYyxmqHOiYRJr8on0CxmqBLNaXUR6oKGuRoCkb7EoF0V0HX1UQMEEH1Q95sdUUC6Ee8yPf0FDli+b1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1Ni7KvWuNSEhlD8MpJUXHJUYlLoTYUluSIyTo8ds4M=;
 b=roAYRjREfxyTO03yz8SBmhowFFBjhkoZskcbDtFnGxI+Hy+oRvGHr7yOSb98WkGijjoiZWie0e8phF4fUtboiwPkFor8Hm46AU9dIeOi9kDZRjcEalXq9IV11YDJ94r14oM+AAjih1+s3QNORKJstz0oUyfjhMzZw30P61Xq7Hs=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4714.eurprd04.prod.outlook.com (20.176.233.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Mon, 18 Nov 2019 08:04:39 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 08:04:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcKeL8V8AgAQ78GCAAGYugIAAAcOw
Date:   Mon, 18 Nov 2019 08:04:39 +0000
Message-ID: <DB7PR04MB461895F57FD4F360A723D2FAE64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
 <DB7PR04MB4618220095E1F844A44DB480E64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <16a0aa7b-875e-8dd9-085c-3341d3f1ac51@geanix.com>
In-Reply-To: <16a0aa7b-875e-8dd9-085c-3341d3f1ac51@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f4cea5e4-93b1-46b6-63ba-08d76bfdf61e
x-ms-traffictypediagnostic: DB7PR04MB4714:|DB7PR04MB4714:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4714FF8DA09469BCB842CDCEE64D0@DB7PR04MB4714.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(13464003)(199004)(189003)(66476007)(8936002)(9686003)(54906003)(76116006)(6436002)(55016002)(4326008)(110136005)(71190400001)(71200400001)(2501003)(316002)(256004)(478600001)(14454004)(14444005)(6246003)(26005)(186003)(64756008)(66446008)(3846002)(6116002)(76176011)(2906002)(7696005)(102836004)(6506007)(53546011)(66556008)(33656002)(486006)(476003)(446003)(11346002)(229853002)(8676002)(5660300002)(52536014)(74316002)(86362001)(305945005)(7736002)(81166006)(81156014)(99286004)(25786009)(66066001)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4714;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QOecrODRp/I1Deshorq5WjGcjN+MCKySHXPWyNS3uTbqD+Ppa3bWXTyvXdsVkkxdL/JLuKzHEMPEo2dchLWsNWMBG/INKlgHPN1RMEsOJKlhaKbLsh+pifYorIOhtlsqNGWlKQZzF0jhH0QGrr3jocZDzS3Q4JqxgmSPkfgXynO/Oqr/KwoFjK9d49vpOuDwNettJGnunQn9HZasgcoAStMVWW4avZPJn79O2Py4HItzg7O5a0Wodt6yoetKvAKhLMTd2D+6gJXqzk5gQxcj9rI2BP+Qku6O+7rVzHvx4wiAbaMwwrffDjP3N05F4LQIesZ6tBeWlm6F08A3DtUr9hRBQ7XGG6GDw1f3VdQjyN0Ggq1E5vxw6QTnAD2hjLz/qDNIoAeOKXRHP120JLKr5bEkp2hvFVt6QQ2B4llZBPHZyIwuDCLZlFhgTXzaBd+5
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cea5e4-93b1-46b6-63ba-08d76bfdf61e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 08:04:39.5939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRUXy7MtkvHXbaLxR0i+PtNjJroQfbVY01t1sKJSEJCQAu5pvS67Qp0Zc0PG1ffKc1wrDPJkZV3EW3wtrw4Lgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4714
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEx5pyIMTjml6UgMTU6NTMNCj4gVG86IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGUN
Cj4gQ2M6IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggMS8zXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVw
DQo+IA0KPiANCj4gDQo+IE9uIDE4LzExLzIwMTkgMDguMDUsIEpvYWtpbSBaaGFuZyB3cm90ZToN
Cj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBsaW51eC1j
YW4tb3duZXJAdmdlci5rZXJuZWwub3JnDQo+ID4+IDxsaW51eC1jYW4tb3duZXJAdmdlci5rZXJu
ZWwub3JnPiBPbiBCZWhhbGYgT2YgU2VhbiBOeWVramFlcg0KPiA+PiBTZW50OiAyMDE55bm0MTHm
nIgxNeaXpSAxNzowOA0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT47IG1rbEBwZW5ndXRyb25peC5kZQ0KPiA+PiBDYzogbGludXgtY2FuQHZnZXIua2VybmVs
Lm9yZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+ID4+IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzNdIGNhbjogZmxleGNhbjog
Zml4IGRlYWRsb2NrIHdoZW4gdXNpbmcgc2VsZg0KPiA+PiB3YWtldXANCj4gPj4NCj4gPj4NCj4g
Pj4NCj4gPj4gT24gMTUvMTEvMjAxOSAwNi4wMywgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+Pj4g
RnJvbTogU2VhbiBOeWVramFlciA8c2VhbkBnZWFuaXguY29tPg0KPiA+Pj4NCj4gPj4+IFdoZW4g
c3VzcGVuZGluZywgd2hlbiB0aGVyZSBpcyBzdGlsbCBjYW4gdHJhZmZpYyBvbiB0aGUgaW50ZXJm
YWNlcw0KPiA+Pj4gdGhlIGZsZXhjYW4gaW1tZWRpYXRlbHkgd2FrZXMgdGhlIHBsYXRmb3JtIGFn
YWluLiBBcyBpdCBzaG91bGQgOi0pLg0KPiA+Pj4gQnV0IGl0IHRocm93cyB0aGlzIGVycm9yIG1z
ZzoNCj4gPj4+IFsgMzE2OS4zNzg2NjFdIFBNOiBub2lycSBzdXNwZW5kIG9mIGRldmljZXMgZmFp
bGVkDQo+ID4+Pg0KPiA+Pj4gT24gdGhlIHdheSBkb3duIHRvIHN1c3BlbmQgdGhlIGludGVyZmFj
ZSB0aGF0IHRocm93cyB0aGUgZXJyb3INCj4gPj4+IG1lc3NhZ2UgZG9lcyBjYWxsIGZsZXhjYW5f
c3VzcGVuZCBidXQgZmFpbHMgdG8gY2FsbCBmbGV4Y2FuX25vaXJxX3N1c3BlbmQuDQo+ID4+PiBU
aGF0IG1lYW5zIHRoZSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZSBpcyBjYWxsZWQsIGJ1dCBvbiB0
aGUgd2F5IG91dA0KPiA+Pj4gb2Ygc3VzcGVuZCB0aGUgZHJpdmVyIG9ubHkgY2FsbHMgZmxleGNh
bl9yZXN1bWUgYW5kIHNraXBzDQo+ID4+PiBmbGV4Y2FuX25vaXJxX3Jlc3VtZSwgdGh1cyBpdCBk
b2Vzbid0IGNhbGwgZmxleGNhbl9leGl0X3N0b3BfbW9kZS4NCj4gPj4+IFRoaXMgbGVhdmVzIHRo
ZSBmbGV4Y2FuIGluIHN0b3AgbW9kZSwgYW5kIHdpdGggdGhlIGN1cnJlbnQgZHJpdmVyIGl0DQo+
ID4+PiBjYW4ndCByZWNvdmVyIGZyb20gdGhpcyBldmVuIHdpdGggYSBzb2Z0IHJlYm9vdCwgaXQg
cmVxdWlyZXMgYSBoYXJkIHJlYm9vdC4NCj4gPj4+DQo+ID4+PiBUaGlzIHBhdGNoIGNhbiBmaXgg
ZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxmIHdha2V1cCwgaXQgaGFwcGVuZXMgdG8NCj4gPj4+IGJl
IGFibGUgdG8gZml4IGFub3RoZXIgaXNzdWUgdGhhdCBmcmFtZXMgb3V0LW9mLW9yZGVyIGluIGZp
cnN0IElSUQ0KPiA+Pj4gaGFuZGxlciBydW4gYWZ0ZXIgd2FrZXVwLg0KPiA+Pj4NCj4gPj4+IElu
IHdha2V1cCBjYXNlLCBhZnRlciBzeXN0ZW0gcmVzdW1lLCBmcmFtZXMgcmVjZWl2ZWQNCj4gPj4+
IG91dC1vZi1vcmRlcix0aGUgcHJvYmxlbSBpcyB3YWtldXAgbGF0ZW5jeSBmcm9tIGZyYW1lIHJl
Y2VwdGlvbiB0bw0KPiA+Pj4gSVJRIGhhbmRsZXIgaXMgbXVjaCBiaWdnZXIgdGhhbiB0aGUgY291
bnRlciBvdmVyZmxvdy4gVGhpcyBtZWFucw0KPiA+Pj4gaXQncyBpbXBvc3NpYmxlIHRvIHNvcnQg
dGhlIENBTiBmcmFtZXMgYnkgdGltZXN0YW1wLiBUaGUgcmVhc29uIGlzDQo+ID4+PiB0aGF0IGNv
bnRyb2xsZXIgZXhpdHMgc3RvcCBtb2RlIGR1cmluZyBub2lycSByZXN1bWUsIHRoZW4gaXQgY2Fu
IHJlY2VpdmUgdGhlDQo+IGZyYW1lIGltbWVkaWF0ZWx5Lg0KPiA+Pj4gSWYgbm9pcnEgcmV1c21l
IHN0YWdlIGNvbnN1bWVzIG11Y2ggdGltZSwgaXQgd2lsbCBleHRlbmQgaW50ZXJydXB0DQo+ID4+
PiByZXNwb25zZSB0aW1lLg0KPiA+Pj4NCj4gPj4+IEZpeGVzOiBkZTM1NzhjMTk4YzYgKCJjYW46
IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gPj4+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gTnlla2phZXIgPHNlYW5AZ2Vhbml4LmNvbT4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4+DQo+ID4+IEhpIEpvYWtp
bSBhbmQgTWFyYw0KPiA+Pg0KPiA+PiBXZSBoYXZlIHF1aXRlIGEgZmV3IGRldmljZXMgaW4gdGhl
IGZpZWxkIHdoZXJlIGZsZXhjYW4gaXMgc3R1Y2sgaW4gU3RvcC1Nb2RlLg0KPiA+PiBXZSBkbyBu
b3QgaGF2ZSB0aGUgcG9zc2liaWxpdHkgdG8gY29sZCByZWJvb3QgdGhlbSwgYW5kIGhvdCByZWJv
b3QNCj4gPj4gd2lsbCBub3QgZ2V0IGZsZXhjYW4gb3V0IG9mIHN0b3AtbW9kZS4NCj4gPj4gU28g
ZmxleGNhbiBjb21lcyB1cCB3aXRoOg0KPiA+PiBbICAyNzkuNDQ0MDc3XSBmbGV4Y2FuOiBwcm9i
ZSBvZiAyMDkwMDAwLmZsZXhjYW4gZmFpbGVkIHdpdGggZXJyb3INCj4gPj4gLTExMCBbICAyNzku
NTAxNDA1XSBmbGV4Y2FuOiBwcm9iZSBvZiAyMDk0MDAwLmZsZXhjYW4gZmFpbGVkIHdpdGgNCj4g
Pj4gZXJyb3IgLTExMA0KPiA+Pg0KPiA+PiBUaGV5IGFyZSBvbiwgZGUzNTc4YzE5OGM2ICgiY2Fu
OiBmbGV4Y2FuOiBhZGQgc2VsZiB3YWtldXAgc3VwcG9ydCIpDQo+ID4+DQo+ID4+IFdvdWxkIGl0
IGJlIGEgc29sdXRpb24gdG8gYWRkIGEgY2hlY2sgaW4gdGhlIHByb2JlIGZ1bmN0aW9uIHRvIHB1
bGwNCj4gPj4gaXQgb3V0IG9mIHN0b3AtbW9kZT8NCj4gPg0KPiA+IEhpIFNlYW4sDQo+ID4NCj4g
PiBTb2Z0IHJlc2V0IGNhbm5vdCBiZSBhcHBsaWVkIHdoZW4gY2xvY2tzIGFyZSBzaHV0IGRvd24g
aW4gYSBsb3cgcG93ZXIgbW9kZS4NCj4gVGhlIG1vZHVsZSBzaG91bGQgYmUgZmlyc3QgcmVtb3Zl
ZCBmcm9tIGxvdyBwb3dlciBtb2RlLCBhbmQgdGhlbiBzb2Z0IHJlc2V0DQo+IGNhbiBiZSBhcHBs
aWVkLg0KPiA+IEFuZCBleGl0IGZyb20gc3RvcCBtb2RlIGhhcHBlbnMgd2hlbiB0aGUgU3RvcCBt
b2RlIHJlcXVlc3QgaXMgcmVtb3ZlZCwNCj4gb3Igd2hlbiBhY3Rpdml0eSBpcyBkZXRlY3RlZCBv
biB0aGUgQ0FOIGJ1cyBhbmQgdGhlIFNlbGYgV2FrZSBVcCBtZWNoYW5pc20gaXMNCj4gZW5hYmxl
ZC4NCj4gPg0KPiA+IFNvIGZyb20gbXkgcG9pbnQgb2Ygdmlldywgd2UgY2FuIGFkZCBhIGNoZWNr
IGluIHRoZSBwcm9iZSBmdW5jdGlvbiB0bw0KPiA+IHB1bGwgaXQgb3V0IG9mIHN0b3AgbW9kZSwg
c2luY2UgY29udHJvbGxlciBhY3R1YWxseSBjb3VsZCBiZSBzdHVjayBpbiBzdG9wIG1vZGUNCj4g
aWYgc3VzcGVuZC9yZXN1bWUgZmFpbGVkIGFuZCB1c2VycyBqdXN0IHdhbnQgYSB3YXJtIHJlc2V0
IGZvciB0aGUgc3lzdGVtLg0KPiANCj4gRXhhY3RseSB3aGF0IEkgdGhvdWdodCBjb3VsZCBiZSBk
b25lIDopDQo+IA0KPiA+DQo+ID4gQ291bGQgeW91IHBsZWFzZSB0ZWxsIG1lIGhvdyBjYW4gSSBn
ZW5lcmF0ZSBhIHdhcm0gcmVzZXQ/IEFGQUlLLCBib3RoDQo+ICJyZWJvb3QiIGNvbW1hbmQgcHV0
IGludG8gcHJvbXB0IGFuZCBSU1QgS0VZIGluIG91ciBFVksgYm9hcmQgYWxsIHBsYXkgYSByb2xl
DQo+IG9mIGNvbGQgcmVzZXQuDQo+IA0KPiBXYXJtIHJlc2V0IGlzIGp1c3QgYHJlYm9vdGAgOi0p
IENvbGQgaXMgcG93ZXJvZmYuLi4NCg0KSSBhZGQgdGhlIGNvZGUgZmxleGNhbl9lbnRlcl9zdG9w
X21vZGUocHJpdikgYXQgdGhlIGVuZCBvZiB0aGUgcHJvYmUgZnVuY3Rpb24sICdyZWJvb3QnIHRo
ZSBzeXN0ZW0gZGlyZWN0bHkgYWZ0ZXIgc3lzdGVtIGFjdGl2ZS4NCkhvd2V2ZXIsIEkgZG8gbm90
IG1lZXQgdGhlIHByb2JlIGVycm9yLCBpdCBjYW4gcHJvYmUgc3VjY2Vzc2Z1bGx5LiBEbyB5b3Ug
a25vdyB0aGUgcmVhc29uPw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gL1NlYW4N
Cj4gDQo+ID4NCj4gPiBCZXN0IFJlZ2FyZHMsDQo+ID4gSm9ha2ltIFpoYW5nDQo+ID4+IC9TZWFu
DQo=
