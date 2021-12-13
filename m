Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F390F47337A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241678AbhLMSBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:01:02 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:53966 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234319AbhLMSBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:01:00 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-33-MkGeTNzxOuqL-NcoU0yNBg-1; Mon, 13 Dec 2021 18:00:57 +0000
X-MC-Unique: MkGeTNzxOuqL-NcoU0yNBg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 13 Dec 2021 18:00:56 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 13 Dec 2021 18:00:56 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Noah Goldstein' <goldstein.w.n@gmail.com>,
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
Subject: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Topic: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Index: AdfwSx7jhGb9mOkwS12sTJ1p5oR1JQ==
Date:   Mon, 13 Dec 2021 18:00:56 +0000
Message-ID: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
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

DQpBZGQgaW4gdGhlIHRyYWlsaW5nIGJ5dGVzIGZpcnN0IHNvIHRoYXQgdGhlcmUgaXMgbm8gbmVl
ZCB0byB3b3JyeQ0KYWJvdXQgdGhlIHN1bSBleGNlZWRpbmcgNjQgYml0cy4NCg0KU2lnbmVkLW9m
Zi1ieTogRGF2aWQgTGFpZ2h0IDxkYXZpZC5sYWlnaHRAYWN1bGFiLmNvbT4NCi0tLQ0KDQpUaGlz
IG91Z2h0IHRvIGJlIGZhc3RlciAtIGJlY2F1c2Ugb2YgYWxsIHRoZSByZW1vdmVkICdhZGMgJDAn
Lg0KR3Vlc3NpbmcgaG93IGZhc3QgeDg2IGNvZGUgd2lsbCBydW4gaXMgaGFyZCENClRoZXJlIGFy
ZSBvdGhlciB3YXlzIG9mIGhhbmRpbmcgYnVmZmVycyB0aGF0IGFyZSBzaG9ydGVyIHRoYW4gOCBi
eXRlcywNCmJ1dCBJJ2QgcmF0aGVyIGhvcGUgdGhleSBkb24ndCBoYXBwZW4gaW4gYW55IGhvdCBw
YXRocy4NCg0KTm90ZSAtIEkndmUgbm90IGV2ZW4gY29tcGlsZSB0ZXN0ZWQgaXQuDQooQnV0IGhh
dmUgdGVzdGVkIGFuIGVxdWl2YWxlbnQgY2hhbmdlIGJlZm9yZS4pDQoNCiBhcmNoL3g4Ni9saWIv
Y3N1bS1wYXJ0aWFsXzY0LmMgfCA1NSArKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQogMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDM2IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jIGIvYXJjaC94ODYvbGli
L2NzdW0tcGFydGlhbF82NC5jDQppbmRleCBhYmY4MTlkZDg1MjUuLmZiY2MwNzNmYzJiNSAxMDA2
NDQNCi0tLSBhL2FyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYw0KKysrIGIvYXJjaC94ODYv
bGliL2NzdW0tcGFydGlhbF82NC5jDQpAQCAtMzcsNiArMzcsMjQgQEAgX193c3VtIGNzdW1fcGFy
dGlhbChjb25zdCB2b2lkICpidWZmLCBpbnQgbGVuLCBfX3dzdW0gc3VtKQ0KIAl1NjQgdGVtcDY0
ID0gKF9fZm9yY2UgdTY0KXN1bTsNCiAJdW5zaWduZWQgcmVzdWx0Ow0KIA0KKwlpZiAobGVuICYg
Nykgew0KKwkJaWYgKHVubGlrZWx5KGxlbiA8IDgpKSB7DQorCQkJLyogQXZvaWQgZmFsbGluZyBv
ZmYgdGhlIHN0YXJ0IG9mIHRoZSBidWZmZXIgKi8NCisJCQlpZiAobGVuICYgNCkgew0KKwkJCQl0
ZW1wNjQgKz0gKih1MzIgKilidWZmOw0KKwkJCQlidWZmICs9IDQ7DQorCQkJfQ0KKwkJCWlmIChs
ZW4gJiAyKSB7DQorCQkJCXRlbXA2NCArPSAqKHUxNiAqKWJ1ZmY7DQorCQkJCWJ1ZmYgKz0gMjsN
CisJCQl9DQorCQkJaWYgKGxlbiAmIDEpDQorCQkJCXRlbXA2NCArPSAqKHU4ICopYnVmZjsNCisJ
CQlnb3RvIHJlZHVjZV90bzMyOw0KKwkJfQ0KKwkJdGVtcDY0ICs9ICoodTY0ICopKGJ1ZmYgKyBs
ZW4gLSA4KSA8PCAoOCAtIChsZW4gJiA3KSkgKiA4Ow0KKwl9DQorDQogCXdoaWxlICh1bmxpa2Vs
eShsZW4gPj0gNjQpKSB7DQogCQlhc20oImFkZHEgMCo4KCVbc3JjXSksJVtyZXNdXG5cdCINCiAJ
CSAgICAiYWRjcSAxKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KQEAgLTgyLDQzICsxMDAsOCBAQCBf
X3dzdW0gY3N1bV9wYXJ0aWFsKGNvbnN0IHZvaWQgKmJ1ZmYsIGludCBsZW4sIF9fd3N1bSBzdW0p
DQogCQkJOiAibWVtb3J5Iik7DQogCQlidWZmICs9IDg7DQogCX0NCi0JaWYgKGxlbiAmIDcpIHsN
Ci0jaWZkZWYgQ09ORklHX0RDQUNIRV9XT1JEX0FDQ0VTUw0KLQkJdW5zaWduZWQgaW50IHNoaWZ0
ID0gKDggLSAobGVuICYgNykpICogODsNCi0JCXVuc2lnbmVkIGxvbmcgdHJhaWw7DQotDQotCQl0
cmFpbCA9IChsb2FkX3VuYWxpZ25lZF96ZXJvcGFkKGJ1ZmYpIDw8IHNoaWZ0KSA+PiBzaGlmdDsN
CiANCi0JCWFzbSgiYWRkcSAlW3RyYWlsXSwlW3Jlc11cblx0Ig0KLQkJICAgICJhZGNxICQwLCVb
cmVzXSINCi0JCQk6IFtyZXNdICIrciIgKHRlbXA2NCkNCi0JCQk6IFt0cmFpbF0gInIiICh0cmFp
bCkpOw0KLSNlbHNlDQotCQlpZiAobGVuICYgNCkgew0KLQkJCWFzbSgiYWRkcSAlW3ZhbF0sJVty
ZXNdXG5cdCINCi0JCQkgICAgImFkY3EgJDAsJVtyZXNdIg0KLQkJCQk6IFtyZXNdICIrciIgKHRl
bXA2NCkNCi0JCQkJOiBbdmFsXSAiciIgKCh1NjQpKih1MzIgKilidWZmKQ0KLQkJCQk6ICJtZW1v
cnkiKTsNCi0JCQlidWZmICs9IDQ7DQotCQl9DQotCQlpZiAobGVuICYgMikgew0KLQkJCWFzbSgi
YWRkcSAlW3ZhbF0sJVtyZXNdXG5cdCINCi0JCQkgICAgImFkY3EgJDAsJVtyZXNdIg0KLQkJCQk6
IFtyZXNdICIrciIgKHRlbXA2NCkNCi0JCQkJOiBbdmFsXSAiciIgKCh1NjQpKih1MTYgKilidWZm
KQ0KLQkJCQk6ICJtZW1vcnkiKTsNCi0JCQlidWZmICs9IDI7DQotCQl9DQotCQlpZiAobGVuICYg
MSkgew0KLQkJCWFzbSgiYWRkcSAlW3ZhbF0sJVtyZXNdXG5cdCINCi0JCQkgICAgImFkY3EgJDAs
JVtyZXNdIg0KLQkJCQk6IFtyZXNdICIrciIgKHRlbXA2NCkNCi0JCQkJOiBbdmFsXSAiciIgKCh1
NjQpKih1OCAqKWJ1ZmYpDQotCQkJCTogIm1lbW9yeSIpOw0KLQkJfQ0KLSNlbmRpZg0KLQl9DQor
cmVkdWNlX3RvMzI6DQogCXJlc3VsdCA9IGFkZDMyX3dpdGhfY2FycnkodGVtcDY0ID4+IDMyLCB0
ZW1wNjQgJiAweGZmZmZmZmZmKTsNCiAJcmV0dXJuIChfX2ZvcmNlIF9fd3N1bSlyZXN1bHQ7DQog
fQ0KLS0gDQoyLjE3LjENCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

