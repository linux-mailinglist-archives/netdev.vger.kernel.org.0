Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1782E466B6D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356316AbhLBVPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:15:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47595 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhLBVPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:15:07 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-283-q5l0cWmjOraT5uYWJuky4w-1; Thu, 02 Dec 2021 21:11:42 +0000
X-MC-Unique: q5l0cWmjOraT5uYWJuky4w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 2 Dec 2021 21:11:41 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 2 Dec 2021 21:11:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Noah Goldstein' <goldstein.w.n@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH v1] x86/lib: Optimize 8x loop and memory clobbers in
 csum_partial.c
Thread-Topic: [PATCH v1] x86/lib: Optimize 8x loop and memory clobbers in
 csum_partial.c
Thread-Index: AQHX4nNzHa79im/GnUeKV4t1ya1z3awZWESAgAAYhYCABdIhIIAAbAaSgAALIYA=
Date:   Thu, 2 Dec 2021 21:11:41 +0000
Message-ID: <ca8dcc5b6fbf47b29d55a2ab9815c182@AcuMS.aculab.com>
References: <20211125193852.3617-1-goldstein.w.n@gmail.com>
 <CANn89iLnH5B11CtzZ14nMFP7b--7aOfnQqgmsER+NYNzvnVurQ@mail.gmail.com>
 <CAFUsyfK-znRWJN7FTMdJaDTd45DgtBQ9ckKGyh8qYqn0eFMMFA@mail.gmail.com>
 <CAFUsyfLKqonuKAh4k2qdBa24H1wQtR5FkAmmtXQGBpyizi6xvQ@mail.gmail.com>
 <CAFUsyfJ619Jx_BS515Se0V_zRdypOg3_2YzbKUk5zDBNaixhaQ@mail.gmail.com>
 <8e4961ae0cf04a5ca4dffdec7da2e57b@AcuMS.aculab.com>
 <CAFUsyfLoEckBrnYKUgqWC7AJPTBDfarjBOgBvtK7eGVZj9muYQ@mail.gmail.com>
 <29cf408370b749069f3b395781fe434c@AcuMS.aculab.com>
 <CANn89iJgNie40sGqAyJ8CM3yKNqRXGGPkMtTPwXQ4S_9jVspgw@mail.gmail.com>
 <CAFUsyfJticWKb3fv12r5L5QZ0AVxytWqtPVkYKeFYLW3K1SMNw@mail.gmail.com>
In-Reply-To: <CAFUsyfJticWKb3fv12r5L5QZ0AVxytWqtPVkYKeFYLW3K1SMNw@mail.gmail.com>
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

RnJvbTogTm9haCBHb2xkc3RlaW4NCj4gU2VudDogMDIgRGVjZW1iZXIgMjAyMSAyMDoxOQ0KPiAN
Cj4gT24gVGh1LCBEZWMgMiwgMjAyMSBhdCA5OjAxIEFNIEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRA
Z29vZ2xlLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBUaHUsIERlYyAyLCAyMDIxIGF0IDY6MjQg
QU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNvbT4gd3JvdGU6DQo+ID4gPg0K
PiA+ID4gSSd2ZSBkdWcgb3V0IG15IHRlc3QgcHJvZ3JhbSBhbmQgbWVhc3VyZWQgdGhlIHBlcmZv
cm1hbmNlIG9mDQo+ID4gPiB2YXJpb3VzIGNvcGllZCBvZiB0aGUgaW5uZXIgbG9vcCAtIHVzdWFs
bHkgNjQgYnl0ZXMvaXRlcmF0aW9uLg0KPiA+ID4gQ29kZSBpcyBiZWxvdy4NCj4gPiA+DQo+ID4g
PiBJdCB1c2VzIHRoZSBoYXJkd2FyZSBwZXJmb3JtYW5jZSBjb3VudGVyIHRvIGdldCB0aGUgbnVt
YmVyIG9mDQo+ID4gPiBjbG9ja3MgdGhlIGlubmVyIGxvb3AgdGFrZXMuDQo+ID4gPiBUaGlzIGlz
IHJlYXNvbmFibGUgc3RhYmxlIG9uY2UgdGhlIGJyYW5jaCBwcmVkaWN0b3IgaGFzIHNldHRsZWQg
ZG93bi4NCj4gPiA+IFNvIHRoZSBkaWZmZXJlbnQgaW4gY2xvY2tzIGJldHdlZW4gYSA2NCBieXRl
IGJ1ZmZlciBhbmQgYSAxMjggYnl0ZQ0KPiA+ID4gYnVmZmVyIGlzIHRoZSBudW1iZXIgb2YgY2xv
Y2tzIGZvciA2NCBieXRlcy4NCj4gDQo+IEludHVpdGl2ZWx5IDEwIHBhc3NlcyBpcyBhIGJpdCBs
b3cuDQoNCkknbSBkb2luZyAxMCBzZXBhcmF0ZSBtZWFzdXJlbWVudHMuDQpUaGUgZmlyc3Qgb25l
IGlzIG11Y2ggc2xvd2VyIGJlY2F1c2UgdGhlIGNhY2hlIGlzIGNvbGQuDQpBbGwgdGhlIG9uZXMg
YWZ0ZXIgKHR5cGljYWxseSkgbnVtYmVyIDUgb3IgNiB0ZW5kIHRvIGdpdmUgdGhlIHNhbWUgYW5z
d2VyLg0KMTAgaXMgcGxlbnR5IHRvIGdpdmUgeW91IHRoYXQgJ3dhcm0gZnV6enkgZmVlbGluZycg
dGhhdCB5b3UndmUgZ290DQphIGNvbnNpc3RlbnQgYW5zd2VyLg0KDQpSdW4gdGhlIHByb2dyYW0g
NSBvciA2IHRpbWVzIHdpdGggdGhlIHNhbWUgcGFyYW1ldGVycyBhbmQgeW91IHNvbWV0aW1lcw0K
Z2V0IGEgZGlmZmVyZW50IHN0YWJsZSB2YWx1ZSAtIHByb2JhYmx5IHNvbWV0aGluZyB0byBkbyB3
aXRoIHN0YWNrIGFuZA0KZGF0YSBwaHlzaWNhbCBwYWdlcy4NCldhcyBtb3JlIG9idmlvdXMgd2hl
biBJIHdhcyB0aW1pbmcgYSBzeXN0ZW0gY2FsbC4NCg0KPiBBbHNvIHlvdSBtaWdodCBjb25zaWRl
ciBhbGlnbmluZw0KPiB0aGUgYGNzdW02NGAgZnVuY3Rpb24gYW5kIHBvc3NpYmx5IHRoZSBsb29w
cy4NCg0KV29uJ3QgbWF0dGVyIGhlcmUsIGluc3RydWN0aW9uIGRlY29kZSBpc24ndCB0aGUgcHJv
YmxlbS4NCkFsc28gdGhlIHVvcHMgYWxsIGNvbWUgb3V0IG9mIHRoZSBsb29wIHVvcCBjYWNoZS4N
Cg0KPiBUaGVyZSBhIHJlYXNvbiB5b3UgcHV0IGAganJjeHpgIGF0IHRoZSBiZWdpbm5pbmcgb2Yg
dGhlIGxvb3BzIGluc3RlYWQNCj4gb2YgdGhlIGVuZD8NCg0KanJjeHogaXMgJ2p1bXAgaWYgY3gg
emVybycgLSBoYXJkIHRvIHVzZSBhdCB0aGUgYm90dG9tIG9mIGEgbG9vcCENCg0KVGhlICdwYWly
ZWQnIGxvb3AgZW5kIGluc3RydWN0aW9uIGlzICdsb29wJyAtIGRlY3JlbWVudCAlY3ggYW5kIGp1
bXAgbm9uLXplcm8uDQpCdXQgdGhhdCBpcyA3KyBjeWNsZXMgb24gY3VycmVudCBJbnRlbCBjcHUg
KG9rIG9uIGFtZCBvbmVzKS4NCg0KSSBjYW4gZ2V0IGEgdHdvIGNsb2NrIGxvb3Agd2l0aCBqcmN4
eiBhbmQgam1wIC0gYXMgaW4gdGhlIGV4YW1wbGVzLg0KQnV0IGl0IGlzIG1vcmUgc3RhYmxlIHRh
a2VuIG91dCB0byA0IGNsb2Nrcy4NCg0KWW91IGNhbid0IGRvIGEgb25lIGNsb2NrIGxvb3AgOi0o
DQoNCj4gPiA+IChVbmxpa2UgdGhlIFRTQyB0aGUgcG1jIGNvdW50IGRvZXNuJ3QgZGVwZW5kIG9u
IHRoZSBjcHUgZnJlcXVlbmN5LikNCj4gPiA+DQo+ID4gPiBXaGF0IGlzIGludGVyZXN0aW5nIGlz
IHRoYXQgZXZlbiBzb21lIG9mIHRoZSB0cml2aWFsIGxvb3BzIGFwcGVhcg0KPiA+ID4gdG8gYmUg
ZG9pbmcgMTYgYnl0ZXMgcGVyIGNsb2NrIGZvciBzaG9ydCBidWZmZXJzIC0gd2hpY2ggaXMgaW1w
b3NzaWJsZS4NCj4gPiA+IENoZWNrc3VtIDFrIGJ5dGVzIGFuZCB5b3UgZ2V0IGFuIGVudGlyZWx5
IGRpZmZlcmVudCBhbnN3ZXIuDQo+ID4gPiBUaGUgb25seSBsb29wIHRoYXQgcmVhbGx5IGV4Y2Vl
ZHMgOCBieXRlcy9jbG9jayBmb3IgbG9uZyBidWZmZXJzDQo+ID4gPiBpcyB0aGUgYWR4Yy9hZG9j
IG9uZS4NCj4gPiA+DQo+ID4gPiBXaGF0IGlzIGFsbW9zdCBjZXJ0YWlubHkgaGFwcGVuaW5nIGlz
IHRoYXQgYWxsIHRoZSBtZW1vcnkgcmVhZHMgYW5kDQo+ID4gPiB0aGUgZGVwZW5kYW50IGFkZC9h
ZGMgaW5zdHJ1Y3Rpb25zIGFyZSBhbGwgcXVldWVkIHVwIGluIHRoZSAnb3V0IG9mDQo+ID4gPiBv
cmRlcicgZXhlY3V0aW9uIHVuaXQuDQo+ID4gPiBTaW5jZSAncmRwbWMnIGlzbid0IGEgc2VyaWFs
aXNpbmcgaW5zdHJ1Y3Rpb24gdGhleSBjYW4gc3RpbGwgYmUNCj4gPiA+IG91dHN0YW5kaW5nIHdo
ZW4gdGhlIGZ1bmN0aW9uIHJldHVybnMuDQo+ID4gPiBVbmNvbW1lbnQgdGhlICdyZHRzYycgYW5k
IHlvdSBnZXQgbXVjaCBzbG93ZXIgdmFsdWVzIGZvciBzaG9ydCBidWZmZXJzLg0KPiANCj4gTWF5
YmUgYWRkIGFuIGBsZmVuY2VgIGJlZm9yZSAvIGFmdGVyIGBjc3VtNjRgDQoNClRoYXQncyBwcm9i
YWJseSBsZXNzIHN0cm9uZyB0aGFuIHJkdHNjLCBJIG1pZ2h0IHRyeSBpdC4NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==

