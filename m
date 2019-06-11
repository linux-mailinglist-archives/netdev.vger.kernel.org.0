Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F090F3C48C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbfFKGz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:55:57 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:38222
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbfFKGz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 02:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgTuunBRBWV+BC1HDj8DxD3jZxCBnQFkKDIIMHcTFr4=;
 b=IZ+St1z2lEjBTdk436zvX/p0/BevJh9MCJSW7hlV4MNZSvQwA3ztZ7jdEVRuQS+egYaPbwOFeRRQJXI6ZjYOQD6QCmcnGfwekgPD5i3moyqd8SfEb45otI/kfvfTw42fzlMR+9cpVh66oNmDlGTZ05YjcMQv5Izhhi8qRSZQwgA=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB4777.eurprd04.prod.outlook.com (20.176.233.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 11 Jun 2019 06:55:53 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c%6]) with mapi id 15.20.1987.010; Tue, 11 Jun 2019
 06:55:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVDFm06ozNDmulK0GLXWOup5sGAaZvkHSAgCaZ9aA=
Date:   Tue, 11 Jun 2019 06:55:53 +0000
Message-ID: <DB7PR04MB4618C578AD958D6DF30618F8E6ED0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
 <39410a95-0eb9-d266-7210-920fa5198a23@pengutronix.de>
In-Reply-To: <39410a95-0eb9-d266-7210-920fa5198a23@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f52f909-c6df-4691-1f61-08d6ee39d88c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4777;
x-ms-traffictypediagnostic: DB7PR04MB4777:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB7PR04MB4777C2887183719CB8E5A4A0E6ED0@DB7PR04MB4777.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(39860400002)(136003)(346002)(189003)(13464003)(199004)(316002)(33656002)(53386004)(99286004)(14454004)(6246003)(2501003)(53936002)(478600001)(966005)(74316002)(6306002)(6436002)(81166006)(229853002)(86362001)(9686003)(71190400001)(2906002)(486006)(81156014)(110136005)(54906003)(8676002)(55016002)(26005)(476003)(71200400001)(8936002)(186003)(66066001)(64756008)(305945005)(7736002)(66946007)(66556008)(66446008)(25786009)(76116006)(68736007)(5660300002)(66476007)(256004)(14444005)(6116002)(3846002)(53546011)(6506007)(76176011)(446003)(11346002)(7696005)(73956011)(52536014)(4326008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4777;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kW4rA5Psh+e3BJIhtrb5XgJ55OLLi+C7J+lDIz19OpWqYnbYsMkRqulmiRm1JpM1/WPi4XdmBFepy/bq0QAKOEtqEQaxsjK2hA9Z8d74Bt7NHq8+znO6DRpPs23enkFgjPpPuG2v3O0ETl5iGWFW1lwm2MtczoEjl4M9+QNQChr+WmFwxUtPnKA/R1504Ittag+pm9InvQiRUGATkZ+jV/sppxjcu30TBCRJpo7fykxs3z3SzB+3BunIr1XwTm4dGG8lPvR9nPCjFvcyP8yPBBWA60biFzcxzQy+8EPip1AgWJrMIz9RyNLxJ2NdGk28RfoFvKa9J/yjy+ug4jSmG6QHepm/JdfKk+9A95EILyha3dk+4stGxUs48XNGmjEYUAOWFSXEFv1M9f8zN/P/dhqfzov40UnZnqPJMh+aPWA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f52f909-c6df-4691-1f61-08d6ee39d88c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 06:55:53.1742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4777
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQ15pyIMTjml6UgMToxOQ0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyB3Z0Bn
cmFuZGVnZ2VyLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQWlzaGVuZyBEb25nIDxh
aXNoZW5nLmRvbmdAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY2FuOiBmbGV4Y2Fu
OiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxmIHdha2V1cA0KPiANCj4gT24gNS8xNy8xOSA0
OjM5IEFNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gQXMgcmVwcm90ZWQgYnkgU2VhbiBOeWVr
amFlciBiZWxsb3c6DQo+ID4gV2hlbiBzdXNwZW5kaW5nLCB3aGVuIHRoZXJlIGlzIHN0aWxsIGNh
biB0cmFmZmljIG9uIHRoZSBpbnRlcmZhY2VzIHRoZQ0KPiA+IGZsZXhjYW4gaW1tZWRpYXRlbHkg
d2FrZXMgdGhlIHBsYXRmb3JtIGFnYWluLg0KPiA+IEFzIGl0IHNob3VsZCA6LSkNCj4gPiBCdXQg
aXQgdGhyb3dzIHRoaXMgZXJyb3IgbXNnOg0KPiA+IFsgMzE2OS4zNzg2NjFdIFBNOiBub2lycSBz
dXNwZW5kIG9mIGRldmljZXMgZmFpbGVkDQo+ID4NCj4gPiBPbiB0aGUgd2F5IGRvd24gdG8gc3Vz
cGVuZCB0aGUgaW50ZXJmYWNlIHRoYXQgdGhyb3dzIHRoZSBlcnJvciBtZXNzYWdlDQo+ID4gZG9l
cyBjYWxsIGZsZXhjYW5fc3VzcGVuZCBidXQgZmFpbHMgdG8gY2FsbCBmbGV4Y2FuX25vaXJxX3N1
c3BlbmQuDQo+ID4gVGhhdCBtZWFucyB0aGUgZmxleGNhbl9lbnRlcl9zdG9wX21vZGUgaXMgY2Fs
bGVkLCBidXQgb24gdGhlIHdheSBvdXQNCj4gPiBvZiBzdXNwZW5kIHRoZSBkcml2ZXIgb25seSBj
YWxscyBmbGV4Y2FuX3Jlc3VtZSBhbmQgc2tpcHMNCj4gPiBmbGV4Y2FuX25vaXJxX3Jlc3VtZSwg
dGh1cyBpdCBkb2Vzbid0IGNhbGwgZmxleGNhbl9leGl0X3N0b3BfbW9kZS4NCj4gPiBUaGlzIGxl
YXZlcyB0aGUgZmxleGNhbiBpbiBzdG9wIG1vZGUsIGFuZCB3aXRoIHRoZSBjdXJyZW50IGRyaXZl
ciBpdA0KPiA+IGNhbid0IHJlY292ZXIgZnJvbSB0aGlzIGV2ZW4gd2l0aCBhIHNvZnQgcmVib290
LCBpdCByZXF1aXJlcyBhIGhhcmQNCj4gPiByZWJvb3QuDQo+ID4NCj4gPiBGaXhlczogZGUzNTc4
YzE5OGM2ICgiY2FuOiBmbGV4Y2FuOiBhZGQgc2VsZiB3YWtldXAgc3VwcG9ydCIpDQo+ID4NCj4g
PiBUaGlzIHBhdGNoIGludGVuZHMgdG8gZml4IHRoZSBpc3N1ZSwgYW5kIGFsc28gYWRkIGNvbW1l
bnQgdG8gZXhwbGFpbg0KPiA+IHRoZSB3YWtldXAgZmxvdy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IA0KPiBUaGUgZXhp
c3Rpbmcgc2VsZiB3YWtldXAgc3VwcG9ydDoNCj4gDQo+IHwgZGUzNTc4YzE5OGM2ICgiY2FuOiBm
bGV4Y2FuOiBhZGQgc2VsZiB3YWtldXAgc3VwcG9ydCIpDQo+IA0KPiBsb29rcyBicm9rZW4gdG8g
bWUuDQo+IA0KPiBBY2NvcmRpbmcgdG8gdGhlIGRhdGEgc2hlZXQ6DQo+IA0KPiA+IFRvIGVudGVy
IHN0b3AgbW9kZSwgdGhlIENQVSBzaG91bGQgbWFudWFsbHkgYXNzZXJ0IGEgZ2xvYmFsIFN0b3Ag
TW9kZQ0KPiA+IHJlcXVlc3QgKHNlZSB0aGUgQ0FOMV9TVE9QX1JFUSBhbmQgQ0FOMl9TVE9QX1JF
USBiaXQgaW4gdGhlIHJlZ2lzdGVyDQo+ID4gSU9NVVhDX0dQUjQpIGFuZCBjaGVjayB0aGUgYWNr
bm93bGVkZ2VtZW50IGFzc2VydGVkIGJ5IHRoZSBGbGV4Q0FODQo+ID4gKHNlZSB0aGUgQ0FOMV9T
VE9QX0FDSyBhbmQgQ0FOMl9TVE9QX0FDSyBpbiB0aGUgcmVnaXN0ZXINCj4gSU9NVVhDX0dQUjQp
Lg0KPiA+IFRoZSBDUFUgbXVzdCBvbmx5IGNvbnNpZGVyIHRoZSBGbGV4Q0FOIGluIFN0b3AgTW9k
ZSB3aGVuIGJvdGggcmVxdWVzdA0KPiA+IGFuZCBhY2tub3dsZWRnZW1lbnQgY29uZGl0aW9ucyBh
cmUgc2F0aXNmaWVkLg0KPiB5b3UgaGF2ZSB0byBwb2xsIGZvciB0aGUgYWNrbm93bGVkZ2VtZW50
LCB3aGljaCBpcyBub3QgZG9uZSBpbiB0aGUgZHJpdmVyLg0KPiBQbGVhc2UgZml4IHRoYXQgZmly
c3QuDQoNCkhpIE1hcmMsDQoNCiAgUGF0Y2ggaGFzIHNlbnQgb3V0IHRvIGZpeCBpdC4gVGhhbmsg
eW91IQ0KDQo+IEFzIGZhciBhcyBJIHVuZGVyc3RhbmQgdGhlIGRvY3VtZW50YXRpb24gdGhlIHN1
c3BlbmQoKSBhbmQgcmVzdW1lIGZ1bmN0aW9ucw0KPiBzaG91bGQgYmUgc3ltbWV0cmljLiBJZiB0
aGV5IGFyZSwgeW91IHNob3VsZG4ndCBuZWVkIHRoZSBpbl9zdG9wX21vZGUgaGFjay4NCg0KICBZ
ZXMsIHdlIGRvbid0IG5lZWQgaW5fc3RvcF9tb2RlIGhhY2sgaWYgd2UgY2FuIGxldCBGbGV4Q0FO
IHN0b3AgbW9kZSBtZWNoYW5pc20gYmUgc3ltbWV0cmljDQppbiBzdXNwZW5kKCkgYW5kIHJlc3Vt
ZSgpLiBIb3dldmVyLCBpdCBjYW4ndCBiZSByZWFsaXplZCBhcyBJIGV4cGxhaW5lZCBpbiB0aGUg
cGF0Y2guDQogIEFuZyBzdWdnZXN0aW9uIGNhbiBwcm92aWRlPw0KIA0KQmVzdCBSZWdhcmRzLA0K
Sm9ha2ltIFpoYW5nDQoNCj4gcmVnYXJkcywNCj4gTWFyYw0KPiANCj4gLS0NCj4gUGVuZ3V0cm9u
aXggZS5LLiAgICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwN
Cj4gSW5kdXN0cmlhbCBMaW51eCBTb2x1dGlvbnMgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgy
Ni05MjQgICAgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgIHwgRmF4OiAg
ICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCj4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2
ODYgIHwgaHR0cDovL3d3dy5wZW5ndXRyb25peC5kZSAgIHwNCg0K
