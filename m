Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3743C119AC
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfEBNDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:03:42 -0400
Received: from mail-eopbgr800045.outbound.protection.outlook.com ([40.107.80.45]:54176
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726295AbfEBNDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 09:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JW4XPgFDsXQJa5k67B4n9DPlHcQfpWP5ZoXLjXxQvrs=;
 b=Geq3ySXFMlALoIABE6L3xoDDLZ7iwzY8tdWH3F9/UMvFZUhqxNoHkTMkOU7yyoJ08fGtSEgo3Q437rIyvXGDjZ5gMvRItIYPMv3iKMr9mlO2a/7cszGXGr54+dndvKTtmDbLOniA7dfzQ5bZ05hFiENQ7Y8sA5MRGgVUXtvbrGg=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.78.205) by
 BN8PR10MB3265.namprd10.prod.outlook.com (20.179.138.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Thu, 2 May 2019 13:03:38 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::24c5:ea68:cff3:4a16]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::24c5:ea68:cff3:4a16%7]) with mapi id 15.20.1856.008; Thu, 2 May 2019
 13:03:38 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "madalin.bucur@nxp.com" <madalin.bucur@nxp.com>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "laurentiu.tudor@nxp.com" <laurentiu.tudor@nxp.com>,
        "roy.pledge@nxp.com" <roy.pledge@nxp.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Topic: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Index: AQHU/MpTw42IuR0fykCaI1+07jqDiqZQPr+AgAdUG4CAABlegIAAJ48AgAABjYA=
Date:   Thu, 2 May 2019 13:03:38 +0000
Message-ID: <da2c4ec6e08d39aff6fb3baa39e84e0f3966d84c.camel@infinera.com>
References: <20190427071031.6563-1-laurentiu.tudor@nxp.com>
         <20190427071031.6563-10-laurentiu.tudor@nxp.com>
         <2c6f5d170edab346e0a87b1dfeb12e2f65801685.camel@infinera.com>
         <VI1PR04MB5134C0D6707E78D674B96898EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
         <728fe477849debcc14bb1af01e35bc7b184a0a03.camel@infinera.com>
         <VI1PR04MB5134872815E02B053B383C08EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5134872815E02B053B383C08EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82caffae-9918-4a35-2597-08d6cefe97d0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BN8PR10MB3265;
x-ms-traffictypediagnostic: BN8PR10MB3265:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BN8PR10MB326539BEBBFBF4667553E1CCF4340@BN8PR10MB3265.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(13464003)(199004)(189003)(7416002)(66946007)(54906003)(68736007)(110136005)(316002)(6306002)(2501003)(86362001)(476003)(45080400002)(446003)(71200400001)(11346002)(2201001)(256004)(5660300002)(71190400001)(2616005)(478600001)(6512007)(7736002)(91956017)(14444005)(66476007)(73956011)(76116006)(486006)(66446008)(64756008)(305945005)(66556008)(6116002)(81156014)(6436002)(6246003)(229853002)(3846002)(4326008)(102836004)(25786009)(8676002)(2906002)(36756003)(26005)(186003)(118296001)(53936002)(14454004)(66066001)(76176011)(99286004)(8936002)(81166006)(6506007)(966005)(72206003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3265;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iaU6lYL+GJbgbD4A6ntM50Fg1kNUjByUjOEtSUVQ1wsu/0q331h5Ovm/5hCzIuL/e6VrEDV/MeXTNnFghn5Nla7i37POaBuLRbljgh4m31ad27rxPSmdXbuxgn8pUbf9BUcTDidK60dyvMSOt22r9MG68jPvzQT9lWcaNszWyLf5/AmRaU+9Jq6ePQ4isAgDW3ExZeYA+BXc5kNaciLn6AYSJWYtOzUIsN1SAu18aeW9ebr9tm2ijtA8DzFjdnpPSlu/jsQXsJDmc3+sFecn8UnRyGufASDuGOtipiaqbyDTf7wYWEfc/CLgPOz3ha/r/LKZ/rCcflmB/T3ULy9lKOJrnPvwQgVDWpF1kRlk6+4Ds/bt2ukEknJrNrYIsTMe8gg+Rf4diNIp4oufO3dbgX1sUAUnijCTHShMJS9GwCM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08443AE914E9FA43B03F2C49BA1D8A6C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82caffae-9918-4a35-2597-08d6cefe97d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 13:03:38.2220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3265
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA1LTAyIGF0IDEyOjU4ICswMDAwLCBMYXVyZW50aXUgVHVkb3Igd3JvdGU6
DQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogSm9ha2ltIFRq
ZXJubHVuZCA8Sm9ha2ltLlRqZXJubHVuZEBpbmZpbmVyYS5jb20+DQo+ID4gU2VudDogVGh1cnNk
YXksIE1heSAyLCAyMDE5IDE6MzcgUE0NCj4gPiANCj4gPiBPbiBUaHUsIDIwMTktMDUtMDIgYXQg
MDk6MDUgKzAwMDAsIExhdXJlbnRpdSBUdWRvciB3cm90ZToNCj4gPiA+IEhpIEpvYWtpbSwNCj4g
PiA+IA0KPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiBGcm9tOiBK
b2FraW0gVGplcm5sdW5kIDxKb2FraW0uVGplcm5sdW5kQGluZmluZXJhLmNvbT4NCj4gPiA+ID4g
U2VudDogU2F0dXJkYXksIEFwcmlsIDI3LCAyMDE5IDg6MTEgUE0NCj4gPiA+ID4gDQo+ID4gPiA+
IE9uIFNhdCwgMjAxOS0wNC0yNyBhdCAxMDoxMCArMDMwMCwgbGF1cmVudGl1LnR1ZG9yQG54cC5j
b20gd3JvdGU6DQo+ID4gPiA+ID4gRnJvbTogTGF1cmVudGl1IFR1ZG9yIDxsYXVyZW50aXUudHVk
b3JAbnhwLmNvbT4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBGaXggaXNzdWUgd2l0aCB0aGUgZW50
cnkgaW5kZXhpbmcgaW4gdGhlIHNnIGZyYW1lIGNsZWFudXAgY29kZSBiZWluZw0KPiA+ID4gPiA+
IG9mZi1ieS0xLiBUaGlzIHByb2JsZW0gc2hvd2VkIHVwIHdoZW4gZG9pbmcgc29tZSBiYXNpYyBp
cGVyZiB0ZXN0cw0KPiA+IGFuZA0KPiA+ID4gPiA+IG1hbmlmZXN0ZWQgaW4gdHJhZmZpYyBjb21p
bmcgdG8gYSBoYWx0Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IExhdXJl
bnRpdSBUdWRvciA8bGF1cmVudGl1LnR1ZG9yQG54cC5jb20+DQo+ID4gPiA+ID4gQWNrZWQtYnk6
IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+
IFdhc24ndCB0aGlzIGEgc3RhYmxlIGNhbmRpZGF0ZSB0b28/DQo+ID4gPiANCj4gPiA+IFllcywg
aXQgaXMuIEkgZm9yZ290IHRvIGFkZCB0aGUgY2M6c3RhYmxlIHRhZywgc29ycnkgYWJvdXQgdGhh
dC4NCj4gPiANCj4gPiBUaGVuIHRoaXMgaXMgYSBidWcgZml4IHRoYXQgc2hvdWxkIGdvIGRpcmVj
dGx5IHRvIGxpbnVzL3N0YWJsZS4NCj4gPiANCj4gPiBJIG5vdGUgdGhhdA0KPiA+IGh0dHBzOi8v
bmFtMDMuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUy
RmdpdC5rZXJuZWwub3JnJTJGcHViJTJGc2NtJTJGbGludXglMkZrZXJuZWwlMkZnaXQlMkZzdGFi
bGUlMkZsaW51eC5naXQlMkZsb2clMkZkcml2ZXJzJTJGbmV0JTJGZXRoZXJuZXQlMkZmcmVlc2Nh
bGUlMkZkcGFhJTNGaCUzRGxpbnV4LTQuMTkueSZhbXA7ZGF0YT0wMiU3QzAxJTdDSm9ha2ltLlRq
ZXJubHVuZCU0MGluZmluZXJhLmNvbSU3Q2I4OGVjYzk1MWRlNjQ5ZTVhNTU4MDhkNmNlZmRkMjg2
JTdDMjg1NjQzZGU1ZjViNGIwM2ExNTMwYWUyZGM4YWFmNzclN0MxJTdDMCU3QzYzNjkyMzk4Njg5
NTEzMzAzNyZhbXA7c2RhdGE9dWVVV0kxJTJCbU5CSHRsQ29ZOSUyQjFGcmVPVU04YkhHaVRZV2hJ
U3k1blJvSmslM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IE5vdCBzdXJlIEkgdW5kZXJzdGFuZCAu
Li4gSSBkb24ndCBzZWUgdGhlIHBhdGNoIGluIHRoZSBsaW5rLg0KDQpTb3JyeSwgSSBjb3BpZWQg
dGhlIHdyb25nIGxpbms6DQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2NvbW1pdC9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZHBhYT9oPWxpbnV4LTQuMTkueSZpZD0wYWFmZWE1ZDRiMjJmZTk0MDNlODlkODJlMDI1
OTdlNDQ5M2Q1ZDBmDQoNCj4gDQo+ID4gaXMgaW4gNC4xOSBidXQgbm90IGluIDQuMTQgLCBpcyBp
dCBub3QgYXBwcm9wcmlhdGUgZm9yIDQuMTQ/DQo+IA0KPiBJIHRoaW5rIGl0IG1ha2VzIHNlbnNl
IHRvIGdvIGluIGJvdGggc3RhYmxlIHRyZWVzLg0KPiANCj4gLS0tDQo+IEJlc3QgUmVnYXJkcywg
TGF1cmVudGl1DQo+IA0KPiA+ID4gPiA+IC0tLQ0KPiA+ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jIHwgMiArLQ0KPiA+ID4gPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBh
YV9ldGguYw0KPiA+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2Rw
YWFfZXRoLmMNCj4gPiA+ID4gPiBpbmRleCBkYWVkZTcyNzI3NjguLjQwNDIwZWRjOWNlNiAxMDA2
NDQNCj4gPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9k
cGFhX2V0aC5jDQo+ID4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2RwYWEvZHBhYV9ldGguYw0KPiA+ID4gPiA+IEBAIC0xNjYzLDcgKzE2NjMsNyBAQCBzdGF0aWMg
c3RydWN0IHNrX2J1ZmYNCj4gPiAqZHBhYV9jbGVhbnVwX3R4X2ZkKGNvbnN0DQo+ID4gPiA+IHN0
cnVjdCBkcGFhX3ByaXYgKnByaXYsDQo+ID4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgcW1fc2dfZW50cnlfZ2V0X2xlbigmc2d0WzBdKSwNCj4gPiBkbWFfZGlyKTsNCj4g
PiA+ID4gPiAgICAgICAgICAgICAgICAgLyogcmVtYWluaW5nIHBhZ2VzIHdlcmUgbWFwcGVkIHdp
dGgNCj4gPiBza2JfZnJhZ19kbWFfbWFwKCkNCj4gPiA+ID4gKi8NCj4gPiA+ID4gPiAtICAgICAg
ICAgICAgICAgZm9yIChpID0gMTsgaSA8IG5yX2ZyYWdzOyBpKyspIHsNCj4gPiA+ID4gPiArICAg
ICAgICAgICAgICAgZm9yIChpID0gMTsgaSA8PSBucl9mcmFnczsgaSsrKSB7DQo+ID4gPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgV0FSTl9PTihxbV9zZ19lbnRyeV9pc19leHQoJnNndFtp
XSkpOw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGRtYV91
bm1hcF9wYWdlKGRldiwgcW1fc2dfYWRkcigmc2d0W2ldKSwNCj4gPiA+ID4gPiAtLQ0KPiA+ID4g
PiA+IDIuMTcuMQ0KPiA+ID4gPiA+IA0KDQo=
