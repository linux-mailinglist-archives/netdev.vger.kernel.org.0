Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4A44F85F
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 15:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhKNOP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 09:15:29 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:20676 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233961AbhKNOP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 09:15:27 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-54-JJ0Irg0UPAO8TwtbIwVRZg-1; Sun, 14 Nov 2021 14:12:29 +0000
X-MC-Unique: JJ0Irg0UPAO8TwtbIwVRZg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sun, 14 Nov 2021 14:12:28 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sun, 14 Nov 2021 14:12:28 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [RFC] x86/csum: rewrite csum_partial()
Thread-Topic: [RFC] x86/csum: rewrite csum_partial()
Thread-Index: AQHX1sjWUoYmK80LukOvYdZq9v09u6wC9SrggAAat/A=
Date:   Sun, 14 Nov 2021 14:12:28 +0000
Message-ID: <3f7414264ba0456b9102dd63c695272e@AcuMS.aculab.com>
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <e6fcc05d59974ba9afa49ba07a7251aa@AcuMS.aculab.com>
In-Reply-To: <e6fcc05d59974ba9afa49ba07a7251aa@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDE0IE5vdmVtYmVyIDIwMjEgMTM6MDcNCj4gDQou
Lg0KPiBJZiB5b3UgYXJlbid0IHdvcnJpZWQgKHRvbyBtdWNoKSBhYm91dCBjcHUgYmVmb3JlIEJy
YWR3ZWxsIHRoZW4gSUlSQw0KPiB0aGlzIGxvb3AgZ2V0cyBjbG9zZSB0byA4IGJ5dGVzL2Nsb2Nr
Og0KPiANCj4gKyAgICAgICAgICAgICAgICIxMDogICAgamVjeHogMjBmXG4iDQo+ICsgICAgICAg
ICAgICAgICAiICAgICAgIGFkYyAgICglW2J1ZmZdLCAlW2xlbl0pLCAlW3N1bV1cbiINCj4gKyAg
ICAgICAgICAgICAgICIgICAgICAgYWRjICAgOCglW2J1ZmZdLCAlW2xlbl0pLCAlW3N1bV1cbiIN
Cj4gKyAgICAgICAgICAgICAgICIgICAgICAgbGVhICAgMTYoJVtsZW5dKSwgJVt0bXBdXG4iDQo+
ICsgICAgICAgICAgICAgICAiICAgICAgIGptcCAgIDEwYlxuIg0KPiArICAgICAgICAgICAgICAg
IiAyMDoiDQoNCkl0IGlzIGV2ZW4gcG9zc2libGUgYSBsb29wIGJhc2VkIG9uOg0KCTEwOglhZGMJ
KCVbYnVmZl0sICVbbGVuXSwgOCksICVzdW0NCgkJaW5jCSVbbGVuXQ0KCQlqbnoJMTBiDQp3aWxs
IHJ1biBhdCA4IGJ5dGVzIHBlciBjbG9jayBvbiB2ZXJ5IHJlY2VudCBJbnRlbCBjcHUuDQpUaGUg
J2FkYycgbmVlZHMgUDA2IGFuZCBQMjMsIHRoZSAnaW5jJyBQMDE1NiBhbmQgdGhlDQonam56JyBQ
NiAocHJlZGljdGVkIHRha2VuKSAob24gQnJvYWR3ZWxsIGFuZCBwcm9iYWJseSBsYXRlcikuDQoo
VGhlICdpbmMnIGFuZCAnam56JyBtaWdodCBhbHNlIGJlIGZ1c2FibGUgdG8gYSBzaW5nbGUgUDYg
dS1vcC4pDQoNClVzaW5nICdsZWEnIGluc3RlYWQgb2YgJ2luYycgY29uc3RyYWlucyBpdCB0byBQ
MTUuDQpUaGF0IG1pZ2h0IGFjdHVhbGx5IGdlbmVyYXRlIGJldHRlciBzY2hlZHVsaW5nIHNpbmNl
IGl0DQppcyBndWFyYW50ZWVkIHRvICdtaXNzJyB0aGUgJ2FkYycuDQoNClNvIGlmIHRoZSByaWdo
dCBwb3J0cyBhcmUgc2VsZWN0ZWQgaXQgaXMgcG9zc2libGUgdG8NCmV4ZWN1dGUgYWxsIHRoZSBp
bnN0cnVjdGlvbnMgaW4gcGFyYWxsZWwuDQoNCkl0IGNlcnRhaW5seSBpc24ndCBuZWNlc3Nhcnkg
dG8gdW5yb2xsIHRoZSBsb29wIGFueSBtb3JlDQp0aGFuIHR3byByZWFkcyBmb3IgQnJhZHdlbGwg
b253YXJkcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

