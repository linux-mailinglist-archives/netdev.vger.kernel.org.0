Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9639D48678C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbiAFQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:21:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:44412 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241162AbiAFQVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 11:21:05 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-46-2FcQvvipNPu80R9wmBi3Mg-2; Thu, 06 Jan 2022 16:20:05 +0000
X-MC-Unique: 2FcQvvipNPu80R9wmBi3Mg-2
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 6 Jan 2022 16:19:54 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 6 Jan 2022 16:19:54 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        'Peter Zijlstra' <peterz@infradead.org>
CC:     "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        "'dave.hansen@linux.intel.com'" <dave.hansen@linux.intel.com>,
        'X86 ML' <x86@kernel.org>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'alexanderduyck@fb.com'" <alexanderduyck@fb.com>,
        'open list' <linux-kernel@vger.kernel.org>,
        'netdev' <netdev@vger.kernel.org>,
        "'Noah Goldstein'" <goldstein.w.n@gmail.com>
Subject: [PATCH ] x86/lib: Optimise copy loop for long buffers in
 csum-partial_64.c
Thread-Topic: [PATCH ] x86/lib: Optimise copy loop for long buffers in
 csum-partial_64.c
Thread-Index: AdgDF7MJrv4d4sxmRYSm5doCrHN7tQ==
Date:   Thu, 6 Jan 2022 16:19:54 +0000
Message-ID: <04c41a96f4eb4fe782d10ae2691ad93e@AcuMS.aculab.com>
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

Z2NjIGNvbnZlcnRzIHRoZSBsb29wIGludG8gb25lIHRoYXQgb25seSBpbmNyZW1lbnRzIHRoZSBw
b2ludGVyDQpidXQgbWFrZXMgYSBtZXNzIG9mIGNhbGN1bGF0aW5nIHRoZSBsaW1pdCBhbmQgZ2Nj
IDkuMSsgY29tcGxldGVseQ0KcmVmdXNlcyB0byB1c2UgdGhlIGZpbmFsIHZhbHVlIG9mICdidWZm
JyBmcm9tIHRoZSBsYXN0IGl0ZXJhdGlvbi4NCg0KRXhwbGljaXRseSBjb2RlIGEgcG9pbnRlciBj
b21wYXJpc29uIGFuZCBkb24ndCBib3RoZXIgY2hhbmdpbmcgbGVuLg0KDQpTaWduZWQtb2ZmLWJ5
OiBEYXZpZCBMYWlnaHQgPGRhdmlkLmxhaWdodEBhY3VsYWIuY29tPg0KLS0tDQoNClRoZSBhc20o
IiIgOiAiK3IiIChidWZmKSk7IGZvcmNlcyBnY2MgdG8gdXNlIHRoZSBsb29wLXVwZGF0ZWQNCnZh
bHVlIG9mICdidWZmJyBhbmQgcmVtb3ZlcyBhdCBsZWFzdCA2IGluc3RydWN0aW9ucy4NCg0KVGhl
IGdjYyBmb2xrIHJlYWxseSBvdWdodCB0byBsb29rIGF0IHdoeSBnY2MgOS4xIG9ud2FyZHMgaXMg
c28NCm11Y2ggd29yc2UgdGhhdCBnY2MgOC4NClNlZSBodHRwczovL2dvZGJvbHQub3JnL3ovVDM5
UGNudmZFDQoNCg0KIGFyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYyB8IDMzICsrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25z
KCspLCAxNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi9jc3VtLXBh
cnRpYWxfNjQuYyBiL2FyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYw0KaW5kZXggZWRkM2U1
NzljMmE3Li4zNDJkZTVmMjRmY2IgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9saWIvY3N1bS1wYXJ0
aWFsXzY0LmMNCisrKyBiL2FyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYw0KQEAgLTI3LDIx
ICsyNywyNCBAQCBfX3dzdW0gY3N1bV9wYXJ0aWFsKGNvbnN0IHZvaWQgKmJ1ZmYsIGludCBsZW4s
IF9fd3N1bSBzdW0pDQogCXU2NCB0ZW1wNjQgPSAoX19mb3JjZSB1NjQpc3VtOw0KIAl1bnNpZ25l
ZCByZXN1bHQ7DQogDQotCXdoaWxlICh1bmxpa2VseShsZW4gPj0gNjQpKSB7DQotCQlhc20oImFk
ZHEgMCo4KCVbc3JjXSksJVtyZXNdXG5cdCINCi0JCSAgICAiYWRjcSAxKjgoJVtzcmNdKSwlW3Jl
c11cblx0Ig0KLQkJICAgICJhZGNxIDIqOCglW3NyY10pLCVbcmVzXVxuXHQiDQotCQkgICAgImFk
Y3EgMyo4KCVbc3JjXSksJVtyZXNdXG5cdCINCi0JCSAgICAiYWRjcSA0KjgoJVtzcmNdKSwlW3Jl
c11cblx0Ig0KLQkJICAgICJhZGNxIDUqOCglW3NyY10pLCVbcmVzXVxuXHQiDQotCQkgICAgImFk
Y3EgNio4KCVbc3JjXSksJVtyZXNdXG5cdCINCi0JCSAgICAiYWRjcSA3KjgoJVtzcmNdKSwlW3Jl
c11cblx0Ig0KLQkJICAgICJhZGNxICQwLCVbcmVzXSINCi0JCSAgICA6IFtyZXNdICIrciIgKHRl
bXA2NCkNCi0JCSAgICA6IFtzcmNdICJyIiAoYnVmZikNCi0JCSAgICA6ICJtZW1vcnkiKTsNCi0J
CWJ1ZmYgKz0gNjQ7DQotCQlsZW4gLT0gNjQ7DQorCWlmICh1bmxpa2VseShsZW4gPj0gNjQpKSB7
DQorCQljb25zdCB2b2lkICpsaW0gPSBidWZmICsgKGxlbiAmIH42M3UpOw0KKwkJZG8gew0KKwkJ
CWFzbSgiYWRkcSAwKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KKwkJCSAgICAiYWRjcSAxKjgoJVtz
cmNdKSwlW3Jlc11cblx0Ig0KKwkJCSAgICAiYWRjcSAyKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0K
KwkJCSAgICAiYWRjcSAzKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KKwkJCSAgICAiYWRjcSA0Kjgo
JVtzcmNdKSwlW3Jlc11cblx0Ig0KKwkJCSAgICAiYWRjcSA1KjgoJVtzcmNdKSwlW3Jlc11cblx0
Ig0KKwkJCSAgICAiYWRjcSA2KjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KKwkJCSAgICAiYWRjcSA3
KjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KKwkJCSAgICAiYWRjcSAkMCwlW3Jlc10iDQorCQkJICAg
IDogW3Jlc10gIityIiAodGVtcDY0KQ0KKwkJCSAgICA6IFtzcmNdICJyIiAoYnVmZikNCisJCQkg
ICAgOiAibWVtb3J5Iik7DQorCQkJYXNtKCIiIDogIityIiAoYnVmZikpOw0KKwkJCWJ1ZmYgKz0g
NjQ7DQorCQl9IHdoaWxlIChidWZmIDwgbGltKTsNCiAJfQ0KIA0KIAlpZiAobGVuICYgMzIpIHsN
Ci0tIA0KMi4xNy4xDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

