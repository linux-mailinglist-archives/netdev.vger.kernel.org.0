Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754F828DABD
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 09:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgJNH6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 03:58:53 -0400
Received: from mail-eopbgr1310110.outbound.protection.outlook.com ([40.107.131.110]:31377
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727306AbgJNH6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 03:58:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgwkV1M32bbZoipJo33026sUIGvOw9uanAhirXuN5T7PWCFq/ZavDijLr07VPmHW86MNzKRSkjzZz03DMc6lo8ye28efkw2vcBRmP/LJhGQQ3FMokElFkaUUpEfIssiWzJg/S4V6aryM0CZLaq3BWroqxrPq0aj1C3IdifMiAEg0HOyPExulJYGyt5btnRbgCXGEhtbQul/O/AQ7ku1zdok9abOGBLWZmnpSajWyrBDxhWHY/daw5HK03aHJ+eZy9krTXvDe9AlSGz94sFTYJLWwBo0TmcO3k90wLxcd3QbouWpFmnzzZvZyvh/NUmZn3RCBWg7XE03QbGDTuUucrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDEWj+SU6qifVTyhdbqgpqRQXzNHgmVRGLuNFLOfDI0=;
 b=ZyJkP1n+PodjselF55V2oGuDTD2RT9S9HCCfEWiqxXji6kxJbS1VKq+IHRUx5xWKlMNGVpmSpWdY+sdksw75c1op6WohIC4oHH1QbHBX+P1dv1UVeJiznlRKU9JZEGMn1e5gnzn7O24/exJCuhiH0Yjmqv3vvNMi1941zj6CaNv9LFgVZsanxYb4/xwOlEuFiLoElT15yBl2IiFpseV2HkbUswdJLtbP/HpG9+92am07+inH3DpgrWvcEl/gKHWQVTGIta+AaM2Snz2ZTtMrDDEfTHT33Bbj6oQJp3Vzax7iRB0jhe2pQyzpQHeiPZETfemyuomnzHw8piu8C4cIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com (2603:1096:803:6::17)
 by PS1PR06MB2616.apcprd06.prod.outlook.com (2603:1096:803:45::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 14 Oct
 2020 07:58:45 +0000
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc]) by PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc%7]) with mapi id 15.20.3455.031; Wed, 14 Oct 2020
 07:58:44 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
Thread-Topic: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
Thread-Index: AQHWofAzDvWchifNuUyQtsmFJfPVT6mWpi2AgAAOHMA=
Date:   Wed, 14 Oct 2020 07:58:44 +0000
Message-ID: <PS1PR0601MB1849DAC59EDA6A9DB62B4EE09C050@PS1PR0601MB1849.apcprd06.prod.outlook.com>
References: <20201014060632.16085-1-dylan_hung@aspeedtech.com>
 <20201014060632.16085-2-dylan_hung@aspeedtech.com>
 <CACPK8Xe_O44BUaPCEm2j3ZN+d4q6JbjEttLsiCLbWF6GnaqSPg@mail.gmail.com>
In-Reply-To: <CACPK8Xe_O44BUaPCEm2j3ZN+d4q6JbjEttLsiCLbWF6GnaqSPg@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: jms.id.au; dkim=none (message not signed)
 header.d=none;jms.id.au; dmarc=none action=none header.from=aspeedtech.com;
x-originating-ip: [211.20.114.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d976cc0f-b323-419a-5806-08d87016f975
x-ms-traffictypediagnostic: PS1PR06MB2616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PS1PR06MB261690EBF2C77A435318CFFE9C050@PS1PR06MB2616.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SAjARkfB5FNoxVlsdEmOaoXLU/XlcZTiXNHvIpDJIOyLUFhrqlF8xJCZjj/rDKiWznwYXOVNakh0z4RdqpE8ws3ivWCtaCJ+4gruYQO7lrUeDYYXIKgVLXq9zzd6pGe7nagtQMd3bgHxcngcGV7OVQTBgPu7+5jkTNy4MW4C/ahCzOPtpPjPeJAVNFdTWlAhs5pd/eviuVzKsAVnTlj9GFZqc5bw91jMjUtIw5n3PnhYt9y8DrpVGSEALpoyk7W3Iy5Yrrr+D9TzNBJ4G2RNur5cdYpiSTdb3RnEaPkbGcAnpuZ01Uh74KuUxazcQdHYGKZPFP/UMFX0oOaImVPiTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB1849.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(376002)(39840400004)(86362001)(6916009)(4326008)(55236004)(83380400001)(8936002)(55016002)(107886003)(6506007)(71200400001)(2906002)(8676002)(26005)(53546011)(66476007)(9686003)(52536014)(64756008)(5660300002)(186003)(478600001)(66446008)(66946007)(54906003)(316002)(76116006)(66556008)(7696005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rlXi6klrJNsWzqzvd2bcVIwlUOfWrpIe8YpRNBDfihmsaCYG9nod8a6CPAXbpYdVpOhrKXCrAaMRswZ+d3dqPPqjZhYQ2rHPECuT5kQxw+vA+BfdZ+helIzmpaOSb4sisSuLnZ8a7QJJHstlsa8D/B6RON9mDjZZY+skgr3wijnmVdgvI6FrBpsDZJFfffEQL79LxN1WMA/aqyiRo605zdMe/mwBdlTvYyL76mRfsERQD461Dl9jHlF3jI9v2WrtEKJDNieh0uoU/0OypKCIhAzA3FiDKYuybro1b9n6kMEdR6Q182TwO3fSTrDVgKOQCGogSvm3HhVR35u/TvusrgDQavKzHCQRDP3r9eBPGoWIzLSZMWfkBIqVrdflZk2g2ndGwp3Muu7oCdSrQSYRQ00ieRYt7AZdu41X5i4SVnj9qaerkSdNpwatOl2Kcq7QEqAjF9wh/EPdiYz1ur5X5u8Gjif0bEDjZl0kzvwBuatRYZzAlHCVyba5OLxk5WJuNDrXNCs3EdeKzeuiVUnUt4Od/RK9wEGTUYO2VeLOeY+FhIQiMZoNStNoYk6znmWpvtkYc0Bw6yst4g+450BhFOwi5n6GIg3uWrHCJYltYuENJbRl0GO0dntP0dM+6yEqFRuldIsHSFI6dK7YlxRUBQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB1849.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d976cc0f-b323-419a-5806-08d87016f975
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 07:58:44.8524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HDNegYESYgLml6tBe5j5El7t1+w4mFuw9n+XxtnOPs6m0OuvCHbA/+qpF6kqmylOMMZHrwLqsePBS9gUDchBWmgpcab0umzzhAeW7Nd9L9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR06MB2616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9lbCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2VsIFN0
YW5sZXkgW21haWx0bzpqb2VsQGptcy5pZC5hdV0NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDE0LCAyMDIwIDI6NDEgUE0NCj4gVG86IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVj
aC5jb20+DQo+IENjOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFr
dWIgS2ljaW5za2kNCj4gPGt1YmFAa2VybmVsLm9yZz47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IExpbnV4IEtlcm5lbCBNYWlsaW5nIExpc3QNCj4gPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc+OyBQby1ZdSBDaHVhbmcgPHJhdGJlcnRAZmFyYWRheS10ZWNoLmNvbT47DQo+IGxpbnV4LWFz
cGVlZCA8bGludXgtYXNwZWVkQGxpc3RzLm96bGFicy5vcmc+OyBPcGVuQk1DIE1haWxsaXN0DQo+
IDxvcGVuYm1jQGxpc3RzLm96bGFicy5vcmc+OyBCTUMtU1cgPEJNQy1TV0Bhc3BlZWR0ZWNoLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzFdIG5ldDogZnRnbWFjMTAwOiBGaXggQXNwZWVk
IGFzdDI2MDAgVFggaGFuZyBpc3N1ZQ0KPiANCj4gT24gV2VkLCAxNCBPY3QgMjAyMCBhdCAwNjow
NywgRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gd3JvdGU6DQo+ID4N
Cj4gPiBUaGUgbmV3IEhXIGFyYml0cmF0aW9uIGZlYXR1cmUgb24gQXNwZWVkIGFzdDI2MDAgd2ls
bCBjYXVzZSBNQUMgVFggdG8NCj4gPiBoYW5nIHdoZW4gaGFuZGxpbmcgc2NhdHRlci1nYXRoZXIg
RE1BLiAgRGlzYWJsZSB0aGUgcHJvYmxlbWF0aWMNCj4gPiBmZWF0dXJlIGJ5IHNldHRpbmcgTUFD
IHJlZ2lzdGVyIDB4NTggYml0MjggYW5kIGJpdDI3Lg0KPiANCj4gSGkgRHlsYW4sDQo+IA0KPiBX
aGF0IGFyZSB0aGUgc3ltcHRvbXMgb2YgdGhpcyBpc3N1ZT8gV2UgYXJlIHNlZWluZyB0aGlzIG9u
IG91ciBzeXN0ZW1zOg0KPiANCj4gWzI5Mzc2LjA5MDYzN10gV0FSTklORzogQ1BVOiAwIFBJRDog
OSBhdCBuZXQvc2NoZWQvc2NoX2dlbmVyaWMuYzo0NDINCj4gZGV2X3dhdGNoZG9nKzB4MmYwLzB4
MmY0DQo+IFsyOTM3Ni4wOTk4OThdIE5FVERFViBXQVRDSERPRzogZXRoMCAoZnRnbWFjMTAwKTog
dHJhbnNtaXQgcXVldWUgMA0KPiB0aW1lZCBvdXQNCj4gDQoNCk1heSBJIGtub3cgeW91ciBzb2Mg
dmVyc2lvbj8gVGhpcyBpc3N1ZSBoYXBwZW5zIG9uIGFzdDI2MDAgdmVyc2lvbiBBMS4gIFRoZSBy
ZWdpc3RlcnMgdG8gZml4IHRoaXMgaXNzdWUgYXJlIG1lYW5pbmdsZXNzL3Jlc2VydmVkIG9uIEEw
IGNoaXAsIHNvIGl0IGlzIG9rYXkgdG8gc2V0IHRoZW0gb24gZWl0aGVyIEEwIG9yIEExLg0KSSB3
YXMgZW5jb3VudGVyaW5nIHRoaXMgaXNzdWUgd2hlbiBJIHdhcyBydW5uaW5nIHRoZSBpcGVyZiBU
WCB0ZXN0LiAgVGhlIHN5bXB0b20gaXMgdGhlIFRYIGRlc2NyaXB0b3JzIGFyZSBjb25zdW1lZCwg
YnV0IG5vIGNvbXBsZXRlIHBhY2tldCBpcyBzZW50IG91dC4NCg0KPiA+IFNpZ25lZC1vZmYtYnk6
IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVjaC5jb20+DQo+IA0KPiBUaGlzIGZpeGVz
IHN1cHBvcnQgZm9yIHRoZSBhc3QyNjAwLCBzbyB3ZSBjYW4gcHV0Og0KPiANCj4gRml4ZXM6IDM5
YmZhYjg4NDRhMCAoIm5ldDogZnRnbWFjMTAwOiBBZGQgc3VwcG9ydCBmb3IgRFQgcGh5LWhhbmRs
ZQ0KPiBwcm9wZXJ0eSIpDQo+IA0KPiBSZXZpZXdlZC1ieTogSm9lbCBTdGFubGV5IDxqb2VsQGpt
cy5pZC5hdT4NCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkv
ZnRnbWFjMTAwLmMgfCA1ICsrKysrDQo+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9m
dGdtYWMxMDAuaCB8IDggKysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRp
b25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRh
eS9mdGdtYWMxMDAuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMx
MDAuYw0KPiA+IGluZGV4IDg3MjM2MjA2MzY2Zi4uMDAwMjRkZDQxMTQ3IDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCj4gPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQo+ID4gQEAgLTE4MTcsNiAr
MTgxNywxMSBAQCBzdGF0aWMgaW50IGZ0Z21hYzEwMF9wcm9iZShzdHJ1Y3QNCj4gcGxhdGZvcm1f
ZGV2aWNlICpwZGV2KQ0KPiA+ICAgICAgICAgICAgICAgICBwcml2LT5yeGRlczBfZWRvcnJfbWFz
ayA9IEJJVCgzMCk7DQo+ID4gICAgICAgICAgICAgICAgIHByaXYtPnR4ZGVzMF9lZG90cl9tYXNr
ID0gQklUKDMwKTsNCj4gPiAgICAgICAgICAgICAgICAgcHJpdi0+aXNfYXNwZWVkID0gdHJ1ZTsN
Cj4gPiArICAgICAgICAgICAgICAgLyogRGlzYWJsZSBhc3QyNjAwIHByb2JsZW1hdGljIEhXIGFy
Yml0cmF0aW9uICovDQo+ID4gKyAgICAgICAgICAgICAgIGlmIChvZl9kZXZpY2VfaXNfY29tcGF0
aWJsZShucCwgImFzcGVlZCxhc3QyNjAwLW1hYyIpKQ0KPiB7DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgaW93cml0ZTMyKEZUR01BQzEwMF9UTV9ERUZBVUxULA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBwcml2LT5iYXNlICsNCj4gRlRHTUFDMTAwX09GRlNFVF9U
TSk7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiAgICAgICAgIH0gZWxzZSB7DQo+ID4gICAg
ICAgICAgICAgICAgIHByaXYtPnJ4ZGVzMF9lZG9ycl9tYXNrID0gQklUKDE1KTsNCj4gPiAgICAg
ICAgICAgICAgICAgcHJpdi0+dHhkZXMwX2Vkb3RyX21hc2sgPSBCSVQoMTUpOyBkaWZmIC0tZ2l0
DQo+ID4gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5oDQo+ID4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5oDQo+ID4gaW5kZXggZTU4NzZh
M2ZkYTkxLi42M2IzZTAyZmFiMTYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZmFyYWRheS9mdGdtYWMxMDAuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Zh
cmFkYXkvZnRnbWFjMTAwLmgNCj4gPiBAQCAtMTY5LDYgKzE2OSwxNCBAQA0KPiA+ICAjZGVmaW5l
IEZUR01BQzEwMF9NQUNDUl9GQVNUX01PREUgICAgICAoMSA8PCAxOSkNCj4gPiAgI2RlZmluZSBG
VEdNQUMxMDBfTUFDQ1JfU1dfUlNUICAgICAgICAgKDEgPDwgMzEpDQo+ID4NCj4gPiArLyoNCj4g
PiArICogdGVzdCBtb2RlIGNvbnRyb2wgcmVnaXN0ZXINCj4gPiArICovDQo+ID4gKyNkZWZpbmUg
RlRHTUFDMTAwX1RNX1JRX1RYX1ZBTElEX0RJUyAoMSA8PCAyOCkgI2RlZmluZQ0KPiA+ICtGVEdN
QUMxMDBfVE1fUlFfUlJfSURMRV9QUkVWICgxIDw8IDI3KQ0KPiA+ICsjZGVmaW5lIEZUR01BQzEw
MF9UTV9ERUZBVUxUDQo+IFwNCj4gPiArICAgICAgIChGVEdNQUMxMDBfVE1fUlFfVFhfVkFMSURf
RElTIHwNCj4gRlRHTUFDMTAwX1RNX1JRX1JSX0lETEVfUFJFVikNCj4gDQo+IFdpbGwgYXNwZWVk
IGlzc3VlIGFuIHVwZGF0ZWQgZGF0YXNoZWV0IHdpdGggdGhpcyByZWdpc3RlciBkb2N1bWVudGVk
Pw0KPiANCj4gDQo+ID4gKw0KPiA+ICAvKg0KPiA+ICAgKiBQSFkgY29udHJvbCByZWdpc3Rlcg0K
PiA+ICAgKi8NCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo=
