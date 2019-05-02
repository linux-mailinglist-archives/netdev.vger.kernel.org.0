Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9111995
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEBM6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:58:10 -0400
Received: from mail-eopbgr40075.outbound.protection.outlook.com ([40.107.4.75]:21618
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfEBM6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 08:58:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXKzJUgPgE5wSsL1xuganqMQcLHfdvaxVMsbcvTAPIw=;
 b=mTS8Vp+pAqohTzInZHEYm4TuZ3vryiFF2IiAzSlK0f2CSuUO+QZhTFvnSuRavtAAJoZ84538i3x4QOeWm/Z6l0nzuDc9fKyaGwnRhFnRtZakzkElYTQLduNPOyDbInLbQeGLI/fU9O7C6FHFKCPpy2yX3DXvM0UHEOcX6oEvNG8=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) by
 VI1PR04MB4430.eurprd04.prod.outlook.com (20.177.55.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Thu, 2 May 2019 12:58:05 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::81d8:f74b:f91e:f071]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::81d8:f74b:f91e:f071%7]) with mapi id 15.20.1835.018; Thu, 2 May 2019
 12:58:05 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "jocke@infinera.com" <joakim.tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Topic: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Index: AQHU/MhUOSfNbgWjXk28jO3/UbT5S6ZQPsaAgAdTq4CAABnMAIAAIyeg
Date:   Thu, 2 May 2019 12:58:04 +0000
Message-ID: <VI1PR04MB5134872815E02B053B383C08EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
References: <20190427071031.6563-1-laurentiu.tudor@nxp.com>
         <20190427071031.6563-10-laurentiu.tudor@nxp.com>
         <2c6f5d170edab346e0a87b1dfeb12e2f65801685.camel@infinera.com>
         <VI1PR04MB5134C0D6707E78D674B96898EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
 <728fe477849debcc14bb1af01e35bc7b184a0a03.camel@infinera.com>
In-Reply-To: <728fe477849debcc14bb1af01e35bc7b184a0a03.camel@infinera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80670efb-ec53-4f70-4c2e-08d6cefdd122
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4430;
x-ms-traffictypediagnostic: VI1PR04MB4430:
x-ms-exchange-purlcount: 1
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB44307FD8A6DB5FA45E44F0A8EC340@VI1PR04MB4430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(376002)(136003)(366004)(39860400002)(189003)(199004)(13464003)(66556008)(64756008)(7736002)(99286004)(5660300002)(6636002)(26005)(478600001)(8676002)(110136005)(54906003)(186003)(2906002)(66446008)(102836004)(2501003)(76176011)(316002)(229853002)(52536014)(25786009)(66476007)(66946007)(73956011)(76116006)(7696005)(4326008)(6506007)(6246003)(44832011)(6436002)(33656002)(14454004)(6306002)(66066001)(81156014)(55016002)(71200400001)(71190400001)(81166006)(305945005)(8936002)(53936002)(446003)(486006)(3846002)(74316002)(86362001)(11346002)(6116002)(14444005)(256004)(966005)(9686003)(476003)(68736007)(491001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4430;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0LPv1EluzdhCWa85usBocVjm6uEOT0wlatyrvLOoS8VQKA6lbazybzkM3heUWLIGNQcBJoYsGGtKn1hi9xRUVCZOqjI9rGb1bT599gTk/FRLk+snMt/EyPlS7B+P+DWwSVs5RZKzygOGySe5TtC1wegh1AEe6ccQXAqM3sEZpANdpkDzC8zHY2BBBov7+wAosd9cAye1pg4/CuhU8mxizcvUQHLOeB4yTZADM06+ugjksjWhvXMubKMe2RSScskczzJrEEiO9+mjJF7WcorsPhr6nwiJJbYTdWGMpcIZcftlYR3LVUYuXurAODamAmZDTHFlEwCAILbaT+r5kJDf3EUSPz4iq/+63FMIn5tcLQjFyTBA0qPlO6+p/Ri6AZ24mkPHj5j4pbpTtMnuZkihqj2QrP2r9W2ckoqii3WYhZQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80670efb-ec53-4f70-4c2e-08d6cefdd122
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 12:58:04.6674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9ha2ltIFRqZXJubHVu
ZCA8Sm9ha2ltLlRqZXJubHVuZEBpbmZpbmVyYS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXkg
MiwgMjAxOSAxOjM3IFBNDQo+IA0KPiBPbiBUaHUsIDIwMTktMDUtMDIgYXQgMDk6MDUgKzAwMDAs
IExhdXJlbnRpdSBUdWRvciB3cm90ZToNCj4gPiBIaSBKb2FraW0sDQo+ID4NCj4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBKb2FraW0gVGplcm5sdW5kIDxKb2Fr
aW0uVGplcm5sdW5kQGluZmluZXJhLmNvbT4NCj4gPiA+IFNlbnQ6IFNhdHVyZGF5LCBBcHJpbCAy
NywgMjAxOSA4OjExIFBNDQo+ID4gPg0KPiA+ID4gT24gU2F0LCAyMDE5LTA0LTI3IGF0IDEwOjEw
ICswMzAwLCBsYXVyZW50aXUudHVkb3JAbnhwLmNvbSB3cm90ZToNCj4gPiA+ID4gRnJvbTogTGF1
cmVudGl1IFR1ZG9yIDxsYXVyZW50aXUudHVkb3JAbnhwLmNvbT4NCj4gPiA+ID4NCj4gPiA+ID4g
Rml4IGlzc3VlIHdpdGggdGhlIGVudHJ5IGluZGV4aW5nIGluIHRoZSBzZyBmcmFtZSBjbGVhbnVw
IGNvZGUgYmVpbmcNCj4gPiA+ID4gb2ZmLWJ5LTEuIFRoaXMgcHJvYmxlbSBzaG93ZWQgdXAgd2hl
biBkb2luZyBzb21lIGJhc2ljIGlwZXJmIHRlc3RzDQo+IGFuZA0KPiA+ID4gPiBtYW5pZmVzdGVk
IGluIHRyYWZmaWMgY29taW5nIHRvIGEgaGFsdC4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9m
Zi1ieTogTGF1cmVudGl1IFR1ZG9yIDxsYXVyZW50aXUudHVkb3JAbnhwLmNvbT4NCj4gPiA+ID4g
QWNrZWQtYnk6IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT4NCj4gPiA+DQo+
ID4gPiBXYXNuJ3QgdGhpcyBhIHN0YWJsZSBjYW5kaWRhdGUgdG9vPw0KPiA+DQo+ID4gWWVzLCBp
dCBpcy4gSSBmb3Jnb3QgdG8gYWRkIHRoZSBjYzpzdGFibGUgdGFnLCBzb3JyeSBhYm91dCB0aGF0
Lg0KPiANCj4gVGhlbiB0aGlzIGlzIGEgYnVnIGZpeCB0aGF0IHNob3VsZCBnbyBkaXJlY3RseSB0
byBsaW51cy9zdGFibGUuDQo+IA0KPiBJIG5vdGUgdGhhdA0KPiBodHRwczovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2xvZy9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYT9oPWxpbnV4LTQuMTkueQ0KDQpOb3Qgc3VyZSBJ
IHVuZGVyc3RhbmQgLi4uIEkgZG9uJ3Qgc2VlIHRoZSBwYXRjaCBpbiB0aGUgbGluay4NCg0KPiBp
cyBpbiA0LjE5IGJ1dCBub3QgaW4gNC4xNCAsIGlzIGl0IG5vdCBhcHByb3ByaWF0ZSBmb3IgNC4x
ND8NCg0KSSB0aGluayBpdCBtYWtlcyBzZW5zZSB0byBnbyBpbiBib3RoIHN0YWJsZSB0cmVlcy4N
Cg0KLS0tDQpCZXN0IFJlZ2FyZHMsIExhdXJlbnRpdQ0KDQo+ID4NCj4gPiA+ID4gLS0tDQo+ID4g
PiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jIHwgMiAr
LQ0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9kcGFhL2RwYWFfZXRoLmMNCj4gPiA+ID4gaW5kZXggZGFlZGU3MjcyNzY4Li40MDQyMGVk
YzljZTYgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9kcGFhL2RwYWFfZXRoLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJl
ZXNjYWxlL2RwYWEvZHBhYV9ldGguYw0KPiA+ID4gPiBAQCAtMTY2Myw3ICsxNjYzLDcgQEAgc3Rh
dGljIHN0cnVjdCBza19idWZmDQo+ICpkcGFhX2NsZWFudXBfdHhfZmQoY29uc3QNCj4gPiA+IHN0
cnVjdCBkcGFhX3ByaXYgKnByaXYsDQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHFtX3NnX2VudHJ5X2dldF9sZW4oJnNndFswXSksDQo+IGRtYV9kaXIpOw0KPiA+ID4g
Pg0KPiA+ID4gPiAgICAgICAgICAgICAgICAgLyogcmVtYWluaW5nIHBhZ2VzIHdlcmUgbWFwcGVk
IHdpdGgNCj4gc2tiX2ZyYWdfZG1hX21hcCgpDQo+ID4gPiAqLw0KPiA+ID4gPiAtICAgICAgICAg
ICAgICAgZm9yIChpID0gMTsgaSA8IG5yX2ZyYWdzOyBpKyspIHsNCj4gPiA+ID4gKyAgICAgICAg
ICAgICAgIGZvciAoaSA9IDE7IGkgPD0gbnJfZnJhZ3M7IGkrKykgew0KPiA+ID4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICBXQVJOX09OKHFtX3NnX2VudHJ5X2lzX2V4dCgmc2d0W2ldKSk7DQo+
ID4gPiA+DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGRtYV91bm1hcF9wYWdlKGRl
diwgcW1fc2dfYWRkcigmc2d0W2ldKSwNCj4gPiA+ID4gLS0NCj4gPiA+ID4gMi4xNy4xDQo+ID4g
PiA+DQo=
