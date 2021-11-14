Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75D344FA0F
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 20:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhKNTNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 14:13:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:29080 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231128AbhKNTMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 14:12:52 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-113-7zMf2WlYNGya6_H3Xv8G5g-1; Sun, 14 Nov 2021 19:09:55 +0000
X-MC-Unique: 7zMf2WlYNGya6_H3Xv8G5g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sun, 14 Nov 2021 19:09:54 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sun, 14 Nov 2021 19:09:54 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH v1] x86/csum: rewrite csum_partial()
Thread-Topic: [PATCH v1] x86/csum: rewrite csum_partial()
Thread-Index: AQHX10vTenZORMUT80K7BTOhs+/or6wDGPzggAAKHwCAADq5sA==
Date:   Sun, 14 Nov 2021 19:09:54 +0000
Message-ID: <31bd81df79c4488c92c6a149eeceee3c@AcuMS.aculab.com>
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
 <226c88f6446d43afb6d9b5dffda5ab2a@AcuMS.aculab.com>
 <CANn89iJtqTGuJL6JgfOAuHxbkej9faURhj3yf2a9Y43Uh_4+Kg@mail.gmail.com>
In-Reply-To: <CANn89iJtqTGuJL6JgfOAuHxbkej9faURhj3yf2a9Y43Uh_4+Kg@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDE0IE5vdmVtYmVyIDIwMjEgMTU6MDQNCj4gDQo+
IE9uIFN1biwgTm92IDE0LCAyMDIxIGF0IDY6NDQgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWln
aHRAYWN1bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBFcmljIER1bWF6ZXQNCj4gPiA+
IFNlbnQ6IDExIE5vdmVtYmVyIDIwMjEgMjI6MzENCj4gPiAuLg0KPiA+ID4gVGhhdCByZXF1aXJl
cyBhbiBleHRyYSBhZGQzMl93aXRoX2NhcnJ5KCksIHdoaWNoIHVuZm9ydHVuYXRlbHkgbWFkZQ0K
PiA+ID4gdGhlIHRoaW5nIHNsb3dlciBmb3IgbWUuDQo+ID4gPg0KPiA+ID4gSSBldmVuIGhhcmRj
b2RlZCBhbiBpbmxpbmUgZmFzdF9jc3VtXzQwYnl0ZXMoKSBhbmQgZ290IGJlc3QgcmVzdWx0cw0K
PiA+ID4gd2l0aCB0aGUgMTArMSBhZGRsLA0KPiA+ID4gaW5zdGVhZCBvZg0KPiA+ID4gICg1ICsg
MSkgYWNxbCArICBtb3YgKG5lZWRpbmcgb25lIGV4dHJhICByZWdpc3RlcikgKyBzaGlmdCArIGFk
ZGwgKyBhZGNsDQo+ID4NCj4gPiBEaWQgeW91IHRyeSBzb21ldGhpbmcgbGlrZToNCj4gPiAgICAg
ICAgIHN1bSA9IGJ1ZlswXTsNCj4gPiAgICAgICAgIHZhbCA9IGJ1ZlsxXToNCj4gPiAgICAgICAg
IGFzbSgNCj4gPiAgICAgICAgICAgICAgICAgYWRkNjQgc3VtLCB2YWwNCj4gPiAgICAgICAgICAg
ICAgICAgYWRjNjQgc3VtLCBidWZbMl0NCj4gPiAgICAgICAgICAgICAgICAgYWRjNjQgc3VtLCBi
dWZbM10NCj4gPiAgICAgICAgICAgICAgICAgYWRjNjQgc3VtLCBidWZbNF0NCj4gPiAgICAgICAg
ICAgICAgICAgYWRjNjQgc3VtLCAwDQo+ID4gICAgICAgICB9DQo+ID4gICAgICAgICBzdW1faGkg
PSBzdW0gPj4gMzI7DQo+ID4gICAgICAgICBhc20oDQo+ID4gICAgICAgICAgICAgICAgIGFkZDMy
IHN1bSwgc3VtX2hpDQo+ID4gICAgICAgICAgICAgICAgIGFkYzMyIHN1bSwgMA0KPiA+ICAgICAg
ICAgKQ0KPiANCj4gVGhpcyBpcyB3aGF0IEkgdHJpZWQuIGJ1dCB0aGUgbGFzdCBwYXJ0IHdhcyB1
c2luZyBhZGQzMl93aXRoX2NhcnJ5KCksDQo+IGFuZCBjbGFuZyB3YXMgYWRkaW5nIHN0dXBpZCBt
b3YgdG8gdGVtcCB2YXJpYWJsZSBvbiB0aGUgc3RhY2ssDQo+IGtpbGxpbmcgdGhlIHBlcmYuDQoN
ClBlcnN1YWRpbmcgdGhlIGNvbXBpbGUgdGhlIGdlbmVyYXRlIHRoZSByZXF1aXJlZCBhc3NlbWJs
ZXIgaXMgYW4gYXJ0IQ0KDQpJIGFsc28gZW5kZWQgdXAgdXNpbmcgX19idWlsdGluX2Jzd2FwMzIo
c3VtKSB3aGVuIHRoZSBhbGlnbm1lbnQNCndhcyAnb2RkJyAtIHRoZSBzaGlmdCBleHByZXNzaW9u
IGRpZG4ndCBhbHdheXMgZ2V0IGNvbnZlcnRlZA0KdG8gYSByb3RhdGUuIEJ5dGVzd2FwMzIgRFRS
VC4NCg0KSSBhbHNvIG5vdGljZWQgdGhhdCBhbnkgaW5pdGlhbCBjaGVja3N1bSB3YXMgYmVpbmcg
YWRkZWQgaW4gYXQgdGhlIGVuZC4NClRoZSA2NGJpdCBjb2RlIGNhbiBhbG1vc3QgYWx3YXlzIGhh
bmRsZSBhIDMyIGJpdCAob3IgbWF5YmUgNTZiaXQhKQ0KaW5wdXQgdmFsdWUgYW5kIGFkZCBpdCBp
biAnZm9yIGZyZWUnIGludG8gdGhlIGNvZGUgdGhhdCBkb2VzIHRoZQ0KaW5pdGlhbCBhbGlnbm1l
bnQuDQoNCkkgZG9uJ3QgcmVtZW1iZXIgdGVzdGluZyBtaXNhbGlnbmVkIGJ1ZmZlcnMuDQpCdXQg
SSB0aGluayBpdCBkb2Vzbid0IG1hdHRlciAob24gY3B1IGFueW9uZSBjYXJlcyBhYm91dCEpLg0K
RXZlbiBTYW5keSBicmlkZ2UgY2FuIGRvIHR3byBtZW1vcnkgcmVhZHMgaW4gb25lIGNsb2NrLg0K
U28gc2hvdWxkIGJlIGFibGUgdG8gZG8gYSBzaW5nbGUgbWlzYWxpZ25lZCByZWFkIGV2ZXJ5IGNs
b2NrLg0KV2hpY2ggYWxtb3N0IGNlcnRhaW5seSBtZWFucyB0aGF0IGFsaWduaW5nIHRoZSBhZGRy
ZXNzZXMgaXMgcG9pbnRsZXNzLg0KKEdpdmVuIHlvdSdyZSBub3QgdHJ5aW5nIHRvIGRvIHRoZSBh
ZGN4L2Fkb3ggbG9vcC4pDQooUGFnZSBzcGFubmluZyBzaG91bGRuJ3QgbWF0dGVyLikNCg0KRm9y
IGJ1ZmZlcnMgdGhhdCBhcmVuJ3QgYSBtdWx0aXBsZSBvZiA4IGJ5dGVzIGl0IG1pZ2h0IGJlIGJl
c3QgdG8NCnJlYWQgdGhlIGxhc3QgOCBieXRlcyBmaXJzdCBhbmQgc2hpZnQgbGVmdCB0byBkaXNj
YXJkIHRoZSBvbmVzIHRoYXQNCndvdWxkIGdldCBhZGRlZCBpbiB0d2ljZS4NClRoaXMgdmFsdWUg
Y2FuIGJlIGFkZGVkIHRvIHRoZSAzMmJpdCAnaW5wdXQnIGNoZWNrc3VtLg0KU29tZXRoaW5nIGxp
a2U6DQoJc3VtX2luICs9IGJ1ZltsZW5ndGggLSA4XSA8PCAoNjQgLSAobGVuZ3RoICYgNykgKiA4
KSk7DQpBbm5veWluZ2x5IGEgc3BlY2lhbCBjYXNlIGlzIG5lZWRlZCBmb3IgYnVmZmVycyBzaG9y
dGVyIHRoYW4gOCBieXRlcw0KdG8gYXZvaWQgZmFsbGluZyBvZmYgdGhlIHN0YXJ0IG9mIGEgcGFn
ZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

