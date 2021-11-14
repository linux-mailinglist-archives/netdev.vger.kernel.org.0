Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1C44F89A
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 15:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhKNOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 09:47:54 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:37983 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229959AbhKNOrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 09:47:46 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-83-LGuh3S-uPgitSF1DdzrSjg-1; Sun, 14 Nov 2021 14:44:43 +0000
X-MC-Unique: LGuh3S-uPgitSF1DdzrSjg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sun, 14 Nov 2021 14:44:36 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sun, 14 Nov 2021 14:44:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: RE: [PATCH v1] x86/csum: rewrite csum_partial()
Thread-Topic: [PATCH v1] x86/csum: rewrite csum_partial()
Thread-Index: AQHX10vTenZORMUT80K7BTOhs+/or6wDGPzg
Date:   Sun, 14 Nov 2021 14:44:36 +0000
Message-ID: <226c88f6446d43afb6d9b5dffda5ab2a@AcuMS.aculab.com>
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
In-Reply-To: <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDExIE5vdmVtYmVyIDIwMjEgMjI6MzENCi4uDQo+
IFRoYXQgcmVxdWlyZXMgYW4gZXh0cmEgYWRkMzJfd2l0aF9jYXJyeSgpLCB3aGljaCB1bmZvcnR1
bmF0ZWx5IG1hZGUNCj4gdGhlIHRoaW5nIHNsb3dlciBmb3IgbWUuDQo+IA0KPiBJIGV2ZW4gaGFy
ZGNvZGVkIGFuIGlubGluZSBmYXN0X2NzdW1fNDBieXRlcygpIGFuZCBnb3QgYmVzdCByZXN1bHRz
DQo+IHdpdGggdGhlIDEwKzEgYWRkbCwNCj4gaW5zdGVhZCBvZg0KPiAgKDUgKyAxKSBhY3FsICsg
IG1vdiAobmVlZGluZyBvbmUgZXh0cmEgIHJlZ2lzdGVyKSArIHNoaWZ0ICsgYWRkbCArIGFkY2wN
Cg0KRGlkIHlvdSB0cnkgc29tZXRoaW5nIGxpa2U6DQoJc3VtID0gYnVmWzBdOw0KCXZhbCA9IGJ1
ZlsxXToNCglhc20oDQoJCWFkZDY0IHN1bSwgdmFsDQoJCWFkYzY0IHN1bSwgYnVmWzJdDQoJCWFk
YzY0IHN1bSwgYnVmWzNdDQoJCWFkYzY0IHN1bSwgYnVmWzRdDQoJCWFkYzY0IHN1bSwgMA0KCX0N
CglzdW1faGkgPSBzdW0gPj4gMzI7DQoJYXNtKA0KCQlhZGQzMiBzdW0sIHN1bV9oaQ0KCQlhZGMz
MiBzdW0sIDANCgkpDQpTcGxpdHRpbmcgaXQgbGlrZSB0aGF0IHNob3VsZCBhbGxvdyB0aGV3IGNv
bXBpbGVyIHRvIGluc2VydA0KYWRkaXRpb25hbCBpbnN0cnVjdGlvbnMgYmV0d2VlbiB0aGUgdHdv
ICdhZGMnIGJsb2Nrcw0KbWFraW5nIGl0IG11Y2ggbW9yZSBsaWtlbHkgdGhhdCB0aGUgY3B1IHdp
bGwgc2NoZWR1bGUgdGhlbQ0KaW4gcGFyYWxsZWwgd2l0aCBvdGhlciBpbnN0cnVjdGlvbnMuDQoN
ClRoZSBleHRyYSA1IGFkYzMyIGhhdmUgdG8gYWRkIDUgY2xvY2tzIChyZWdpc3RlciBkZXBlbmRl
bmN5IGNoYWluKS4NClRoZSAnbW92JyBvdWdodCB0byBiZSBmcmVlIChyZWdpc3RlciByZW5hbWUp
IGFuZCB0aGUgZXh0cmEgc2hpZnQNCmFuZCBhZGRzIG9uZSBjbG9jayBlYWNoIC0gc28gMyAobWF5
YmUgNCkgY2xvY2tzLg0KU28gdGhlIDY0Yml0IHZlcnNpb24gcmVhbGx5IG91Z2h0IHRvIGJlIGZh
c3RlciBldmVuIGEgcyBzaW5nbGUNCmFzbSBibG9jay4NCg0KVHJ5aW5nIHRvIHNlY29uZC1ndWVz
cyB0aGUgeDg2IGNwdSBpcyBsYXJnZWx5IGltcG9zc2libGUgOi0pDQoNCk9oLCBhbmQgdGhlbiB0
cnkgdGhlIGJlbmNobWFya3Mgb2Ygb25lIG9mIHRoZSA2NGJpdCBBdG9tIGNwdXMNCnVzZWQgaW4g
ZW1iZWRkZWQgc3lzdGVtcy4uLi4NCldlJ3ZlIHNvbWUgNGNvcmUraHlwZXJ0aHJlYWRpbmcgb25l
cyB0aGF0IGFyZW4ndCBleGFjdGx5IHNsb3cuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

