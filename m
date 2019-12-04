Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2D4112136
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 02:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfLDB6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 20:58:32 -0500
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:24997
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbfLDB6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 20:58:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZjpvd72lvU5ipLflS/fe3T9NL2EowHXgrVaJm4mOLQQhGZBWDtBhWtPr4RmGqPZBdW2fdQA5f8rGjFXHLSHtkPHrSlIPRdRqR2e4WZyEu+OwH6cBPL27Aas0CikkWALqjztWJCyUntUM756dsnMo+GxNkl1YoH0KMCRuMVTrFR7ejEXFoJZgTlghAKtj9jcNYIcP9+WS+Tqah6BgO6+AvQhW8cKhhVhd8qcfdnTGuAcbiLJH79jPpBcX34KKw/eZdSijhMZG4Q5TeGq3AWSQeHKeGyu+1ytrJ5xDsXgjz3MJUEUD4qWOT9SdrlfMbKytjEBAly+KjBvLu2yIPNGHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nqWFtamH5j9itVYjriZmXRp7Ail4OnEBrjPOd77ATo=;
 b=A0YXC21rq4LnAbtWNcIwxjXC/FZZaRJ+TJZY97uvZOVUX+xDnk7KfDHIoqlErVzUUYOmrdKBbf8sKPYjuLp/OSFFEyjNCSKQtvH0bJveybXyX40DqNWwhKiruzs+Pm9vwTrfgEbsqca/iqsXgTS7uVqX1e2O7Ivmlr9KQ7lW6/vmilWj9j8xl+7tfUarVGfc+vl9LN01NPQ9w1Nb7XRTpE0acu1++Ht+9ukaHvYDKJvjGktCaToSx8XDh30IIwmb0BtdDKbuNk2BXUoP7BTt9aJFX368QO0Ffl4rY2htKdg51WUXzvg8F+z+2J9zuNolKezJoQt1qdH5itJbZETmnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nqWFtamH5j9itVYjriZmXRp7Ail4OnEBrjPOd77ATo=;
 b=CGlnN/OgBiLP6LbW5wNItV8d0CffZ12MwOwyaIZpMpi4n8VVt6sZ42rBpQe6FW+s2rEpTLxsppF3GUhLudXRQaYHvNNP5Rh5wsE4lIAo7SnzEsR3aJwJIU8sauLychzV+Z+DbgmiyIGd2W6SfYQvLABRT+Nyc292et/szRbwxZE=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4665.eurprd04.prod.outlook.com (52.135.139.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Wed, 4 Dec 2019 01:58:24 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 01:58:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVpOdz4P6zsP3HCk29mcugpy847aeos2gAgACJGRA=
Date:   Wed, 4 Dec 2019 01:58:24 +0000
Message-ID: <DB7PR04MB46183730127339DAC15ABF33E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-2-qiangqing.zhang@nxp.com>
 <b77829d5-9eda-a244-3ee8-2ccdbdfb6524@pengutronix.de>
In-Reply-To: <b77829d5-9eda-a244-3ee8-2ccdbdfb6524@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dda10bab-0840-4d97-08d8-08d7785d729d
x-ms-traffictypediagnostic: DB7PR04MB4665:|DB7PR04MB4665:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4665E1E05BFFD3B4797DACCBE65D0@DB7PR04MB4665.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(13464003)(189003)(199004)(52536014)(316002)(71190400001)(99286004)(478600001)(256004)(11346002)(446003)(54906003)(110136005)(64756008)(33656002)(966005)(71200400001)(2201001)(14454004)(66556008)(66476007)(86362001)(8936002)(4326008)(66446008)(6436002)(55016002)(6246003)(229853002)(74316002)(2501003)(5660300002)(305945005)(6306002)(9686003)(6116002)(53546011)(7736002)(81166006)(3846002)(25786009)(26005)(81156014)(76176011)(102836004)(186003)(7696005)(8676002)(76116006)(66946007)(6506007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4665;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YKbtEIbtyfFQC4bO9VYDnFUnG4yrN8v+qHT5PmrZtw5LsGFnJe72opZuzPwLFEqluHYDRtcNBW+QByVSyJl/tV+Fc44qH2PmdlvffH1HHhhoAsOsVYUoGePYFeVg7y24o7aivmaRPNeaqEDRZkX8YN91JYT6VKKaSPTf96xJArvubNl1yJM4STvvHljKjYzg9QZ9nd6in3j7kw9WzDsDGQCJJkZqgxTEzY6csIH5AczwadIKCLUTjLaQ4OqGG5ej0BYt4Y3Rh1I2rmzR3eoVYfy52/Wh0vg88PXLoZ+2I0VBKIbvfibvT813IrIhJA9pPLck8jvQjdIlkeijg87neU0N871AFH514ruaMOpSf+RaQYPaUHuFCjG9kOs5ssZkVgcdSMn5vWqGGXAvRBvq5uSi9BE8AoNAzUSzUIMzUpEBdsPR18oQo+bQS0fcRyOVUO3nUHF+zoT9qmqVS8d1CzKr8z899xOrmD05s6hxAlvTXB9kgo4VLeyBP9CWNw00u6AsODJTJdlNcWQ58u8XwwL2f5+R4xC762G7QKDT92w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda10bab-0840-4d97-08d8-08d7785d729d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 01:58:24.5450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pQY8ABGVhoPQP+n6PnWBkSlpLHaRUIFOzyaqWvGPJykrToIXDwJfUmcDCNoXbvxgEbiyw38ej1RiDHJ4TpI5kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4665
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMToyNQ0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IHNlYW5AZ2Vhbml4LmNv
bTsNCj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogZGwtbGludXgtaW14IDxsaW51
eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBWMiAxLzRdIGNhbjogZmxleGNhbjogZml4IGRlYWRsb2NrIHdoZW4gdXNpbmcgc2VsZiB3
YWtldXANCg0KWy4uLl0NCj4gPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDE5ICsrKysr
KysrKysrLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDgg
ZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhj
YW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPiBpbmRleCAyZWZhMDYxMTlmNjgu
LjIyOTc2NjNjYWNiMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5j
DQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IEBAIC0xMzQsOCArMTM0
LDcgQEANCj4gPiAgCShGTEVYQ0FOX0VTUl9FUlJfQlVTIHwgRkxFWENBTl9FU1JfRVJSX1NUQVRF
KSAgI2RlZmluZQ0KPiA+IEZMRVhDQU5fRVNSX0FMTF9JTlQgXA0KPiA+ICAJKEZMRVhDQU5fRVNS
X1RXUk5fSU5UIHwgRkxFWENBTl9FU1JfUldSTl9JTlQgfCBcDQo+ID4gLQkgRkxFWENBTl9FU1Jf
Qk9GRl9JTlQgfCBGTEVYQ0FOX0VTUl9FUlJfSU5UIHwgXA0KPiA+IC0JIEZMRVhDQU5fRVNSX1dB
S19JTlQpDQo+ID4gKwkgRkxFWENBTl9FU1JfQk9GRl9JTlQgfCBGTEVYQ0FOX0VTUl9FUlJfSU5U
KQ0KPiANCj4gV2h5IGRvIHlvdSByZW1vdmUgdGhlIEZMRVhDQU5fRVNSX1dBS19JTlQgZnJvbSB0
aGUNCj4gRkxFWENBTl9FU1JfQUxMX0lOVD8NCj4gDQo+ID4NCj4gPiAgLyogRkxFWENBTiBpbnRl
cnJ1cHQgZmxhZyByZWdpc3RlciAoSUZMQUcpIGJpdHMgKi8NCj4gPiAgLyogRXJyYXRhIEVSUjAw
NTgyOSBzdGVwNzogUmVzZXJ2ZSBmaXJzdCB2YWxpZCBNQiAqLyBAQCAtOTYwLDYNCj4gPiArOTU5
LDEyIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBmbGV4Y2FuX2lycShpbnQgaXJxLCB2b2lkICpkZXZf
aWQpDQo+ID4NCj4gPiAgCXJlZ19lc3IgPSBwcml2LT5yZWFkKCZyZWdzLT5lc3IpOw0KPiA+DQo+
ID4gKwkvKiBBQ0sgd2FrZXVwIGludGVycnVwdCAqLw0KPiA+ICsJaWYgKHJlZ19lc3IgJiBGTEVY
Q0FOX0VTUl9XQUtfSU5UKSB7DQo+ID4gKwkJaGFuZGxlZCA9IElSUV9IQU5ETEVEOw0KPiA+ICsJ
CXByaXYtPndyaXRlKHJlZ19lc3IgJiBGTEVYQ0FOX0VTUl9XQUtfSU5ULCAmcmVncy0+ZXNyKTsN
Cj4gPiArCX0NCj4gPiArDQo+IA0KPiBJZiBGTEVYQ0FOX0VTUl9XQUtfSU5UIHN0YXlzIGluIEZM
RVhDQU5fRVNSX0FMTF9JTlQsIHlvdSBkb24ndCBuZWVkDQo+IHRoYXQgZXhwbGljaXQgQUNLIGhl
cmUuDQoNCkhpIE1hcmMsDQoNCkkgcmVtb3ZlIHRoZSBGTEVYQ0FOX0VTUl9XQUtfSU5UIGZyb20g
dGhlIEZMRVhDQU5fRVNSX0FMTF9JTlQgc2luY2UgRkxFWENBTl9FU1JfQUxMX0lOVCBpcyBmb3IN
CmFsbCBidXMgZXJyb3IgYW5kIHN0YXRlIGNoYW5nZSBJUlEgc291cmNlcywgd2FrZXVwIGludGVy
cnVwdCBkb2VzIG5vdCBiZWxvbmcgdG8gdGhlc2UuIElmIHlvdSB0aGluayB0aGlzIGRvZXMNCm5v
dCBuZWVkLCBJIGNhbiByZW1vdmUgdGhpcyBjaGFuZ2UuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtp
bSBaaGFuZw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAg
ICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAg
ICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJl
dHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAg
fA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0y
MDY5MTctNTU1NSB8DQoNCg==
