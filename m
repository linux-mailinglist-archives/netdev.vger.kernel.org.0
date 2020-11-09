Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5852AC374
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgKISQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:16:39 -0500
Received: from mail-dm6nam12on2110.outbound.protection.outlook.com ([40.107.243.110]:15200
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729119AbgKISQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:16:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfzcNQpXY88cwe7kkRArF9+J4ttNlYuDXSzNiqXbWwqo6IbCyR3zErXzWr51UmzmXtBLtJ5jIJPBR5ZHUfqm/xtjihXbr9sLVsrwki0U2w03WRrpXmymhSGYjQ7g1xIAqhU3FLTMlufPmqO4YgRKNRKIaHbWDK6zLmdYrUCw+y/9L2gCV5/XuY2xzEH4EHHipg3q0XwyMgiMDu/yldWb+Kac024syckMIqPSyAOt4MVBDPupfu8j+TkVl4xJrlSjg/ASSmK9/o2n/j2XiV9y+aXTA0B9/+fhDeexS507EMQs/zQC05mEKNi4CvIr2x8XWvZvT2YXv8FU3c1foH2n7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDG/YCBbbN/W1GuejYWwWS6/XKO0AJ2KhEAJayJIMPk=;
 b=nufoD9CdqyFO+EYcVNRnPdT7wG23AvmQX2xfXvwDzFhXixphZ4nodtyqsfDUSeOmkL4LX4LZrd/NMcZFANFnP91Y6BQr5Y9uzoH1yv9UGb0H6GSdQzcbUtq55845O9xyXe9xqmCV26msZxe5MXUpzysXqwWxJZd8nQQrdeUytmfngJzbm9vuN21q7MSmoxZsZQOu1tJLPCmDFjE2FaHHRXZrVOQ1/lAaIi0zNaLCjdn6KOxL3C2NgweWoxyHgUaLniEhUXNI9pS5Z2KKFQ2A/w/ebihHMIKIL4KOeqBO6q+qpC3GNcK2dv3Y+SHNmP3BjHztqZSqzVJvKyvyzqWz8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDG/YCBbbN/W1GuejYWwWS6/XKO0AJ2KhEAJayJIMPk=;
 b=E3azoGbbu4HhDaVwq38GTyz3mcDj8Myv2HLRjO2fMtIiwAQitGiHx2dy42xfu/hzguAhjIQs7cPXorjKJNvjJW3MjFDPlUAngapDNzKBtf4nNxuJ2TdlF8rMnxwLvUYISPXonauxYYFLsWxxU2tASqR0x50XDCzjzAhXKmhIfAQ=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11)
 by BL0PR13MB4210.namprd13.prod.outlook.com (2603:10b6:207:38::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13; Mon, 9 Nov
 2020 18:16:34 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210%9]) with mapi id 15.20.3541.018; Mon, 9 Nov 2020
 18:16:34 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Thread-Topic: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Thread-Index: AQHWtrHgQGMAEXnlr0WTJWA0fWWPg6nACJ0AgAABGQCAAAWNAIAAAP6AgAALQgA=
Date:   Mon, 9 Nov 2020 18:16:34 +0000
Message-ID: <3194609c525610dc502d69f11c09cff1c9b21f2d.camel@hammerspace.com>
References: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
         <9ce015245c916b2c90de72440a22f801142f2c6e.camel@hammerspace.com>
         <0313136F-6801-434F-8304-72B9EADD389E@oracle.com>
         <f03dae6d36c0f008796ae01bbb6de3673e783571.camel@hammerspace.com>
         <5056C7C7-7B26-4667-9691-D2F634C02FB1@oracle.com>
In-Reply-To: <5056C7C7-7B26-4667-9691-D2F634C02FB1@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca57c4f2-23eb-4acb-8431-08d884db977d
x-ms-traffictypediagnostic: BL0PR13MB4210:
x-microsoft-antispam-prvs: <BL0PR13MB4210CFD5DB296D8AD64C1DA4B8EA0@BL0PR13MB4210.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ith/O4DgJMELVqjzgseQGppLjn6ui7ZPQipFC6IzZqv3MhtFchjDRKgtnZ8scj7GK8cwWbSZ2CGwEkfbUIjesvs7oMSHvzNc3ocn0chNKdUVUV5eedHxT7A2ZfV2CozsO53aBvYqrhFfHVY6mwLVAqbKU0UAKufMJhGIvSdmNo5UxegmE864KindaK7qgZe+Mbu4yHD4LSwAD2p/JA1+H8kKKwLbWncAfp1sbB1RSWw6WIVy+W0S3K5bvJhAPuVgWFnVLbJMaRS9XetNh3EO272uJoaliXFzSzESxBP10Xw5NZxwhHK/QjdvlZLdplti/mdnJxBi3gMSMpcbiTuOqr0OYtyxGc8wmY0LPtcIFowIPDc2o85z4hnWCZE4MIr1/Gp7xPgQOjJUPCeMtvqGxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(346002)(39830400003)(966005)(8936002)(36756003)(66556008)(8676002)(6916009)(86362001)(91956017)(2906002)(71200400001)(66946007)(64756008)(6486002)(66476007)(478600001)(76116006)(6512007)(53546011)(2616005)(6506007)(186003)(5660300002)(54906003)(83380400001)(316002)(4326008)(66446008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9FigtwzNvxmpZ7leYEzeLOkUvZFw124JSrmvwZuXYtv8bwrpIV8Ygm6yjqi2ivnqW/nmzusNWO9xF4soqwF3DjXGv9vbmCFiIyN+x1wIjI1VtAZzdzf8itOI+V8ld+czvbMJ4F7BAbBjBsFnRY1634+GppOtZf8I5l+ND/nQlgW9uCMeCAOpKeeDERDDiY1VKXzLRlOJs1yVdj71qL7JtchaY8tHD+X6uAlGsEXStFK1i4X6YYecxpNb3h65KBd9tH5n4HumgwTYjSE3NVFWfcXgV/ZjdmeNgwLRAg3no5HTstpD225220alnR7J/UBemhgsBzuOm6aaKyya8tDkF+Oj9yJy4J6+L5yn1/wgSv0YMHHUMgP48tbYJD/k7iL1tKI/xK5yfvdx8Bqnk5Unb4RFef/BtpyU23r5fzxIrfVTZAOMFlIuY5cSHiljQ/g9weBwtzj4g8bupLNaWjRl75gkuC+x41sZMGDsJtey0L0owW+i1pYfrqSyZfCbXKjb/0HTrvwzKF9WLG5AvyHEgmSXRKaSGDdcJ+FCaxkTJHHjFzMDVFJg5ljzHmhWOfukChlqjg9MZW/EDoGLt6Gr+yXmlnf12ecaIWi4POuNft5Mm8vxPCnL16cMR8Qp7875GpzySzGHd5HXMVwzSuRcaQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03D260971BDF8C42A44F937CAE9BD256@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca57c4f2-23eb-4acb-8431-08d884db977d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 18:16:34.4725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DASb09sS8FV3RUqyJX8AiD32cVoK82z9pL+YNMbMIHwjdbhm9aHOBKQSX82nb7V+LjtXHpevd7gmkSZipwQAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4210
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTA5IGF0IDEyOjM2IC0wNTAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
DQo+IA0KPiA+IE9uIE5vdiA5LCAyMDIwLCBhdCAxMjozMiBQTSwgVHJvbmQgTXlrbGVidXN0IDwN
Cj4gPiB0cm9uZG15QGhhbW1lcnNwYWNlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAy
MDIwLTExLTA5IGF0IDEyOjEyIC0wNTAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4gPiA+IA0KPiA+
ID4gDQo+ID4gPiA+IE9uIE5vdiA5LCAyMDIwLCBhdCAxMjowOCBQTSwgVHJvbmQgTXlrbGVidXN0
DQo+ID4gPiA+IDx0cm9uZG15QGhhbW1lcnNwYWNlLmNvbT4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+
ID4gPiBPbiBNb24sIDIwMjAtMTEtMDkgYXQgMTE6MDMgLTA1MDAsIENodWNrIExldmVyIHdyb3Rl
Og0KPiA+ID4gPiA+IERhaXJlIEJ5cm5lIHJlcG9ydHMgYSB+NTAlIGFnZ3JlZ3JhdGUgdGhyb3Vn
aHB1dCByZWdyZXNzaW9uDQo+ID4gPiA+ID4gb24NCj4gPiA+ID4gPiBoaXMNCj4gPiA+ID4gPiBM
aW51eCBORlMgc2VydmVyIGFmdGVyIGNvbW1pdCBkYTE2NjFiOTNiZjQgKCJTVU5SUEM6IFRlYWNo
DQo+ID4gPiA+ID4gc2VydmVyDQo+ID4gPiA+ID4gdG8NCj4gPiA+ID4gPiB1c2UgeHBydF9zb2Nr
X3NlbmRtc2cgZm9yIHNvY2tldCBzZW5kcyIpLCB3aGljaCByZXBsYWNlZA0KPiA+ID4gPiA+IGtl
cm5lbF9zZW5kX3BhZ2UoKSBjYWxscyBpbiBORlNEJ3Mgc29ja2V0IHNlbmQgcGF0aCB3aXRoDQo+
ID4gPiA+ID4gY2FsbHMgdG8NCj4gPiA+ID4gPiBzb2NrX3NlbmRtc2coKSB1c2luZyBpb3ZfaXRl
ci4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJbnZlc3RpZ2F0aW9uIHNob3dlZCB0aGF0IHRjcF9z
ZW5kbXNnKCkgd2FzIG5vdCB1c2luZyB6ZXJvLQ0KPiA+ID4gPiA+IGNvcHkNCj4gPiA+ID4gPiB0
bw0KPiA+ID4gPiA+IHNlbmQgdGhlIHhkcl9idWYncyBidmVjIHBhZ2VzLCBidXQgaW5zdGVhZCB3
YXMgcmVseWluZyBvbg0KPiA+ID4gPiA+IG1lbWNweS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBT
ZXQgdXAgdGhlIHNvY2tldCBhbmQgZWFjaCBtc2doZHIgdGhhdCBiZWFycyBidmVjIHBhZ2VzIHRv
DQo+ID4gPiA+ID4gdXNlDQo+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gemVyby1jb3B5IG1lY2hh
bmlzbSBpbiB0Y3Bfc2VuZG1zZy4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBSZXBvcnRlZC1ieTog
RGFpcmUgQnlybmUgPGRhaXJlQGRuZWcuY29tPg0KPiA+ID4gPiA+IEJ1Z0xpbms6IGh0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjA5NDM5DQo+ID4gPiA+ID4gRml4
ZXM6IGRhMTY2MWI5M2JmNCAoIlNVTlJQQzogVGVhY2ggc2VydmVyIHRvIHVzZQ0KPiA+ID4gPiA+
IHhwcnRfc29ja19zZW5kbXNnDQo+ID4gPiA+ID4gZm9yIHNvY2tldCBzZW5kcyIpDQo+ID4gPiA+
ID4gU2lnbmVkLW9mZi1ieTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+DQo+
ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gwqBuZXQvc3VucnBjL3NvY2tsaWIuY8KgIHzCoMKgwqAg
NSArKysrLQ0KPiA+ID4gPiA+IMKgbmV0L3N1bnJwYy9zdmNzb2NrLmPCoCB8wqDCoMKgIDEgKw0K
PiA+ID4gPiA+IMKgbmV0L3N1bnJwYy94cHJ0c29jay5jIHzCoMKgwqAgMSArDQo+ID4gPiA+ID4g
wqAzIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IFRoaXMgcGF0Y2ggZG9lcyBub3QgZnVsbHkgcmVzb2x2ZSB0aGUgaXNz
dWUuIERhaXJlIHJlcG9ydHMNCj4gPiA+ID4gPiBoaWdoDQo+ID4gPiA+ID4gc29mdElSUSBhY3Rp
dml0eSBhZnRlciB0aGUgcGF0Y2ggaXMgYXBwbGllZCwgYW5kIHRoaXMNCj4gPiA+ID4gPiBhY3Rp
dml0eQ0KPiA+ID4gPiA+IHNlZW1zIHRvIHByZXZlbnQgZnVsbCByZXN0b3JhdGlvbiBvZiBwcmV2
aW91cyBwZXJmb3JtYW5jZS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBkaWZm
IC0tZ2l0IGEvbmV0L3N1bnJwYy9zb2NrbGliLmMgYi9uZXQvc3VucnBjL3NvY2tsaWIuYw0KPiA+
ID4gPiA+IGluZGV4IGQ1MjMxM2FmODJiYy4uYWY0NzU5NmE3YmRkIDEwMDY0NA0KPiA+ID4gPiA+
IC0tLSBhL25ldC9zdW5ycGMvc29ja2xpYi5jDQo+ID4gPiA+ID4gKysrIGIvbmV0L3N1bnJwYy9z
b2NrbGliLmMNCj4gPiA+ID4gPiBAQCAtMjI2LDkgKzIyNiwxMiBAQCBzdGF0aWMgaW50IHhwcnRf
c2VuZF9wYWdlZGF0YShzdHJ1Y3QNCj4gPiA+ID4gPiBzb2NrZXQNCj4gPiA+ID4gPiAqc29jaywg
c3RydWN0IG1zZ2hkciAqbXNnLA0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgIGlmIChlcnIgPCAw
KQ0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZXJyOw0K
PiA+ID4gPiA+IMKgDQo+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoCBtc2ctPm1zZ19mbGFncyB8PSBN
U0dfWkVST0NPUFk7DQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqAgaW92X2l0ZXJfYnZlYygmbXNn
LT5tc2dfaXRlciwgV1JJVEUsIHhkci0+YnZlYywNCj4gPiA+ID4gPiB4ZHJfYnVmX3BhZ2Vjb3Vu
dCh4ZHIpLA0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB4ZHItPnBhZ2VfbGVuICsgeGRyLT5wYWdlX2Jhc2UpOw0KPiA+ID4gPiA+IC3CoMKgwqDC
oMKgwqAgcmV0dXJuIHhwcnRfc2VuZG1zZyhzb2NrLCBtc2csIGJhc2UgKyB4ZHItDQo+ID4gPiA+
ID4gPnBhZ2VfYmFzZSk7DQo+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoCBlcnIgPSB4cHJ0X3NlbmRt
c2coc29jaywgbXNnLCBiYXNlICsgeGRyLT5wYWdlX2Jhc2UpOw0KPiA+ID4gPiA+ICvCoMKgwqDC
oMKgwqAgbXNnLT5tc2dfZmxhZ3MgJj0gfk1TR19aRVJPQ09QWTsNCj4gPiA+ID4gPiArwqDCoMKg
wqDCoMKgIHJldHVybiBlcnI7DQo+ID4gPiA+ID4gwqB9DQo+ID4gPiA+ID4gwqANCj4gPiA+ID4g
PiDCoC8qIENvbW1vbiBjYXNlOg0KPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL3N2
Y3NvY2suYyBiL25ldC9zdW5ycGMvc3Zjc29jay5jDQo+ID4gPiA+ID4gaW5kZXggYzI3NTJlMmI5
Y2UzLi5jODE0YjQ5NTNiMTUgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy9zdmNz
b2NrLmMNCj4gPiA+ID4gPiArKysgYi9uZXQvc3VucnBjL3N2Y3NvY2suYw0KPiA+ID4gPiA+IEBA
IC0xMTc2LDYgKzExNzYsNyBAQCBzdGF0aWMgdm9pZCBzdmNfdGNwX2luaXQoc3RydWN0DQo+ID4g
PiA+ID4gc3ZjX3NvY2sNCj4gPiA+ID4gPiAqc3ZzaywNCj4gPiA+ID4gPiBzdHJ1Y3Qgc3ZjX3Nl
cnYgKnNlcnYpDQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN2c2st
PnNrX2RhdGFsZW4gPSAwOw0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBtZW1zZXQoJnN2c2stPnNrX3BhZ2VzWzBdLCAwLCBzaXplb2Yoc3Zzay0NCj4gPiA+ID4gPiA+
IHNrX3BhZ2VzKSk7DQo+ID4gPiA+ID4gwqANCj4gPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBzb2NrX3NldF9mbGFnKHNrLCBTT0NLX1pFUk9DT1BZKTsNCj4gPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGNwX3NrKHNrKS0+bm9uYWdsZSB8PSBUQ1Bf
TkFHTEVfT0ZGOw0KPiA+ID4gPiA+IMKgDQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHNldF9iaXQoWFBUX0RBVEEsICZzdnNrLT5za194cHJ0LnhwdF9mbGFncyk7DQo+
ID4gPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMveHBydHNvY2suYyBiL25ldC9zdW5ycGMv
eHBydHNvY2suYw0KPiA+ID4gPiA+IGluZGV4IDcwOTBiYmVlMGVjNS4uMzQzYzYzOTZiMjk3IDEw
MDY0NA0KPiA+ID4gPiA+IC0tLSBhL25ldC9zdW5ycGMveHBydHNvY2suYw0KPiA+ID4gPiA+ICsr
KyBiL25ldC9zdW5ycGMveHBydHNvY2suYw0KPiA+ID4gPiA+IEBAIC0yMTc1LDYgKzIxNzUsNyBA
QCBzdGF0aWMgaW50DQo+ID4gPiA+ID4geHNfdGNwX2ZpbmlzaF9jb25uZWN0aW5nKHN0cnVjdA0K
PiA+ID4gPiA+IHJwY194cHJ0ICp4cHJ0LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPiA+ID4gPiA+
IMKgDQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIHNvY2tldCBv
cHRpb25zICovDQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNvY2tf
cmVzZXRfZmxhZyhzaywgU09DS19MSU5HRVIpOw0KPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNvY2tfc2V0X2ZsYWcoc2ssIFNPQ0tfWkVST0NPUFkpOw0KPiA+ID4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0Y3Bfc2soc2spLT5ub25hZ2xlIHw9IFRD
UF9OQUdMRV9PRkY7DQo+ID4gPiA+ID4gwqANCj4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgeHBydF9jbGVhcl9jb25uZWN0ZWQoeHBydCk7DQo+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gDQo+ID4gPiA+IEknbSB0aGlua2luZyB3ZSBhcmUgbm90IHJlYWxseSBhbGxvd2VkIHRv
IGRvIHRoYXQgaGVyZS4gVGhlDQo+ID4gPiA+IHBhZ2VzDQo+ID4gPiA+IHdlDQo+ID4gPiA+IHBh
c3MgaW4gdG8gdGhlIFJQQyBsYXllciBhcmUgbm90IGd1YXJhbnRlZWQgdG8gY29udGFpbiBzdGFi
bGUNCj4gPiA+ID4gZGF0YQ0KPiA+ID4gPiBzaW5jZSB0aGV5IGluY2x1ZGUgdW5sb2NrZWQgcGFn
ZSBjYWNoZSBwYWdlcyBhcyB3ZWxsIGFzDQo+ID4gPiA+IE9fRElSRUNUDQo+ID4gPiA+IHBhZ2Vz
Lg0KPiA+ID4gDQo+ID4gPiBJIGFzc3VtZSB5b3UgbWVhbiB0aGUgY2xpZW50IHNpZGUgb25seS4g
VGhvc2UgaXNzdWVzIGFyZW4ndCBhDQo+ID4gPiBmYWN0b3INCj4gPiA+IG9uIHRoZSBzZXJ2ZXIu
IE5vdCBzZXR0aW5nIFNPQ0tfWkVST0NPUFkgaGVyZSBzaG91bGQgYmUgZW5vdWdoIHRvDQo+ID4g
PiBwcmV2ZW50IHRoZSB1c2Ugb2YgemVyby1jb3B5IG9uIHRoZSBjbGllbnQuDQo+ID4gPiANCj4g
PiA+IEhvd2V2ZXIsIHRoZSBjbGllbnQgbG9zZXMgdGhlIGJlbmVmaXRzIG9mIHNlbmRpbmcgYSBw
YWdlIGF0IGENCj4gPiA+IHRpbWUuDQo+ID4gPiBJcyB0aGVyZSBhIGRlc2lyZSB0byByZW1lZHkg
dGhhdCBzb21laG93Pw0KPiA+IA0KPiA+IFdoYXQgYWJvdXQgc3BsaWNlIHJlYWRzIG9uIHRoZSBz
ZXJ2ZXIgc2lkZT8NCj4gDQo+IE9uIHRoZSBzZXJ2ZXIsIHRoaXMgcGF0aCBmb3JtZXJseSB1c2Vk
IGtlcm5lbF9zZW5kcGFnZXMoKSwgd2hpY2ggSQ0KPiBhc3N1bWVkIGlzIHNpbWlsYXIgdG8gdGhl
IHNlbmRtc2cgemVyby1jb3B5IG1lY2hhbmlzbS4gSG93IGRvZXMNCj4ga2VybmVsX3NlbmRwYWdl
cygpIG1pdGlnYXRlIGFnYWluc3QgcGFnZSBpbnN0YWJpbGl0eT8NCj4gDQoNCkl0IGNvcGllcyB0
aGUgZGF0YS4g8J+Zgg0KDQotLSANClRyb25kIE15a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBt
YWludGFpbmVyLCBIYW1tZXJzcGFjZQ0KdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0K
DQoNCg==
