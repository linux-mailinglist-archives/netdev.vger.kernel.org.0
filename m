Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C5248ED91
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243076AbiANP7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:59:30 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:26821 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238959AbiANP73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:59:29 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-190-J5jrWq3oPyyS4GLy2VXbAQ-1; Fri, 14 Jan 2022 15:59:27 +0000
X-MC-Unique: J5jrWq3oPyyS4GLy2VXbAQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 14 Jan 2022 15:59:21 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 14 Jan 2022 15:59:21 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Network Development" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: RE: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag
 calculation
Thread-Topic: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag
 calculation
Thread-Index: AQHYCVpULjtSZ105lEeo5rcLfvZFjaxiq4hw
Date:   Fri, 14 Jan 2022 15:59:21 +0000
Message-ID: <13d51088799746469d26a442fb3c6fd5@AcuMS.aculab.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <20220112131204.800307-2-Jason@zx2c4.com> <87tue8ftrm.fsf@toke.dk>
 <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
 <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
 <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
 <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
 <CAHmME9oa8dAeRQfgj-U00gUtVOJ_CTGwtyBxUB4=8+XO_fFjNQ@mail.gmail.com>
In-Reply-To: <CAHmME9oa8dAeRQfgj-U00gUtVOJ_CTGwtyBxUB4=8+XO_fFjNQ@mail.gmail.com>
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

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDE0IEphbnVhcnkgMjAyMiAxNToyMQ0K
PiANCj4gT24gRnJpLCBKYW4gMTQsIDIwMjIgYXQgNDowOCBQTSBBcmQgQmllc2hldXZlbCA8YXJk
YkBrZXJuZWwub3JnPiB3cm90ZToNCj4gPiBZZWFoLCBzbyB0aGUgaXNzdWUgaXMgdGhhdCwgYXQg
KnNvbWUqIHBvaW50LCBTSEEtMSBpcyBnb2luZyB0byBoYXZlIHRvDQo+ID4gZ28uIFNvIGl0IHdv
dWxkIGJlIGhlbHBmdWwgaWYgQWxleGVpIGNvdWxkIGNsYXJpZnkgKndoeSogaGUgZG9lc24ndA0K
PiA+IHNlZSB0aGlzIGFzIGEgcHJvYmxlbS4gVGhlIGZhY3QgdGhhdCBpdCBpcyBicm9rZW4gbWVh
bnMgdGhhdCBpdCBpcyBubw0KPiA+IGxvbmdlciBpbnRyYWN0YWJsZSB0byBmb3JnZSBjb2xsaXNp
b25zLCB3aGljaCBsaWtsZXkgbWVhbnMgdGhhdCBTSEEtMQ0KPiA+IG5vIGxvbmdlciBmdWxmaWxs
cyB0aGUgdGFzayB0aGF0IHlvdSB3YW50ZWQgaXQgdG8gZG8gaW4gdGhlIGZpcnN0DQo+ID4gcGxh
Y2UuDQo+IA0KPiBJIHRoaW5rIHRoZSByZWFzb24gdGhhdCBBbGV4ZWkgZG9lc24ndCB0aGluayB0
aGF0IHRoZSBTSEEtMSBjaG9pY2UNCj4gcmVhbGx5IG1hdHRlcnMgaXMgYmVjYXVzZSB0aGUgcmVz
dWx0IGlzIGJlaW5nIHRydW5jYXRlZCB0byA2NC1iaXRzLCBzbw0KPiBjb2xsaXNpb25zIGFyZSBl
YXN5IGFueXdheS4uLg0KDQpXaGljaCBwcm9iYWJseSBtZWFucyB0aGF0IFNIQS0xIGlzIGNvbXBs
ZXRlIG92ZXJraWxsIGFuZCBzb21ldGhpbmcNCm11Y2ggc2ltcGxlciBjb3VsZCBoYXZlIGJlZW4g
dXNlZCBpbnN0ZWFkLg0KSXMgdGhlIGJ1ZmZlciBldmVuIGJpZyBlbm91Z2ggdG8gaGF2ZSBldmVy
IHdhcnJhbnRlZCB0aGUgbWFzc2l2ZQ0KdW5yb2xsaW5nIG9mIHRoZSBzaGEtMSBmdW5jdGlvbi4N
CihJIHN1c3BlY3QgdGhhdCBqdXN0IGRlc3Ryb3lzIHRoZSBJLWNhY2hlIG9uIG1vc3QgY3B1LikN
Cg0KVGhlIElQdjYgYWRkcmVzcyBjYXNlIHNlZW1zIGV2ZW4gbW9yZSBpbnNhbmUgLSBob3cgbWFu
eSBieXRlcw0KYXJlIGFjdHVhbGx5IGJlaW5nIGhhc2hlZC4NClRoZSB1bnJvbGxlZCBsb29wIGlz
IG9ubHkgbGlrZWx5IHRvIGJlIHNhbmUgZm9yIGxhcmdlIChtZWdhYnl0ZSkNCmJ1ZmZlcnMuDQoN
CglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwg
TW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzog
MTM5NzM4NiAoV2FsZXMpDQo=

