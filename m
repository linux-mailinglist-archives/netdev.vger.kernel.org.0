Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C398E4742B3
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhLNMgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:36:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:47909 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231984AbhLNMgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:36:11 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-126-ciDdlnKxPsGDPzgly2ZQ2g-1; Tue, 14 Dec 2021 12:36:08 +0000
X-MC-Unique: ciDdlnKxPsGDPzgly2ZQ2g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Tue, 14 Dec 2021 12:36:07 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Tue, 14 Dec 2021 12:36:07 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Noah Goldstein' <goldstein.w.n@gmail.com>,
        'Eric Dumazet' <edumazet@google.com>
CC:     "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        "'dave.hansen@linux.intel.com'" <dave.hansen@linux.intel.com>,
        'X86 ML' <x86@kernel.org>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'peterz@infradead.org'" <peterz@infradead.org>,
        "'alexanderduyck@fb.com'" <alexanderduyck@fb.com>,
        'open list' <linux-kernel@vger.kernel.org>,
        'netdev' <netdev@vger.kernel.org>
Subject: RE: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Topic: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Index: AdfwSx7jhGb9mOkwS12sTJ1p5oR1JQAmTp2g
Date:   Tue, 14 Dec 2021 12:36:07 +0000
Message-ID: <3107b1e365f34df080feefb68be8a422@AcuMS.aculab.com>
References: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
In-Reply-To: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT4NCj4gU2VudDogMTMg
RGVjZW1iZXIgMjAyMSAxODowMQ0KPiANCj4gQWRkIGluIHRoZSB0cmFpbGluZyBieXRlcyBmaXJz
dCBzbyB0aGF0IHRoZXJlIGlzIG5vIG5lZWQgdG8gd29ycnkNCj4gYWJvdXQgdGhlIHN1bSBleGNl
ZWRpbmcgNjQgYml0cy4NCg0KVGhpcyBpcyBhbiBhbHRlcm5hdGUgdmVyc2lvbiB0aGF0IChtb3N0
bHkpIGNvbXBpbGVzIHRvIHJlYXNvbmFibGUgY29kZS4NCkkndmUgYWxzbyBib290ZWQgYSBrZXJu
ZWwgd2l0aCBpdCAtIG5ldHdvcmtpbmcgc3RpbGwgd29ya3MhDQoNCmh0dHBzOi8vZ29kYm9sdC5v
cmcvei9LNnZZMzFHcXMNCg0KSSBjaGFuZ2VkIHRoZSB3aGlsZSAobGVuID49IDY0KSBsb29wIGlu
dG8gYW4NCmlmIChsZW4gPj0gNjQpIGRvICguLi4pIHdoaWxlKGxlbiA+PSA2NCkgb25lLg0KQnV0
IGdjYyBtYWtlcyBhIHBpZ3MgYnJlYWtmYXN0IG9mIGNvbXBpbGluZyBpdCAtIGl0IG9wdGltaXNl
cw0KaXQgc28gdGhhdCBpdCBpcyB3aGlsZSAocHRyIDwgbGltKSBidXQgYWRkcyBhIGxvdCBvZiBj
b2RlLg0KU28gSSd2ZSBkb25lIHRoYXQgYnkgaGFuZC4NClRoZW4gaXQgc3RpbGwgbWFrZXMgYSBt
ZWFsIG9mIGl0IGJlY2F1c2UgaXQgcmVmdXNlcyB0byB0YWtlDQonYnVmZicgZnJvbSB0aGUgZmlu
YWwgbG9vcCBpdGVyYXRpb24uDQpBbiBhc3NpZ25tZW50IHRvIHRoZSBsaW1pdCBoZWxwcy4NCg0K
VGhlbiB0aGVyZSBpcyB0aGUgY2FsY3VsYXRpb24gb2YgKDggLSAobGVuICYgNykpICogOC4NCmdj
YyBwcmlvciB0byA5LjIganVzdCBuZWdhdGUgKGxlbiAmIDcpIHRoZW4gdXNlIGxlYWwgNTYoLCVy
czEsOCksJXJjeC4NCkJ1dCBsYXRlciBvbmVzIGFuZCBmYWlsIHRvIG5vdGljZS4NCkV2ZW4gZ2l2
ZW4gKDY0ICsgOCAqIC0obGVuICYgNykpIGNsYW5nIGZhaWxzIHRvIHVzZSBsZWFsLg0KDQpJJ20g
bm90IGV2ZW4gc3VyZSB0aGUgY29kZSBjbGFuZyBnZW5lcmF0ZXMgaXMgcmlnaHQ6DQooJXJzaSBp
cyAobGVuICYgNykpDQogICAgICAgIG1vdnEgICAgLTgoJXJzaSwlcmF4KSwgJXJkeA0KICAgICAg
ICBsZWFsICAgICgsJXJzaSw4KSwgJWVjeA0KICAgICAgICBhbmRiICAgICQ1NiwgJWNsDQogICAg
ICAgIG5lZ2IgICAgJWNsDQogICAgICAgIHNocnEgICAgJWNsLCAlcmR4DQoNClRoZSAnbmVnYicg
aXMgdGhlIHdyb25nIHNpemUgb2YgdGhlICdhbmRiJy4NCkl0IG1pZ2h0IGJlIG9rIGlmIGl0IGlz
IGFzc3VtaW5nIHRoZSBjcHUgaWdub3JlcyB0aGUgaGlnaCAyIGJpdHMgb2YgJWNsLg0KQnV0IHRo
YXQgaXMgYSBob3JyaWQgYXNzdW1wdGlvbiB0byBiZSBtYWtpbmcuDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

