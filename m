Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F03A4866A8
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbiAFPWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:22:05 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:46735 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240422AbiAFPWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:22:05 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-132-q9hJDqqMPxmmiZ5MKZZQew-1; Thu, 06 Jan 2022 15:21:52 +0000
X-MC-Unique: q9hJDqqMPxmmiZ5MKZZQew-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 6 Jan 2022 15:21:51 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 6 Jan 2022 15:21:51 +0000
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
Subject: [PATCH ] x86/lib: Simplify code for !CONFIG_DCACHE_WORD_ACCESS in
 csum-partial_64.c
Thread-Topic: [PATCH ] x86/lib: Simplify code for !CONFIG_DCACHE_WORD_ACCESS
 in csum-partial_64.c
Thread-Index: AdgDEH+mtMhrZ9ynRvybrK9s3y5Pbw==
Date:   Thu, 6 Jan 2022 15:21:51 +0000
Message-ID: <5f848b1cd6f844f6bc66fbec44237e08@AcuMS.aculab.com>
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

SWYgbG9hZF91bmFsaWduZWRfemVyb3BhZCgpIGNhbid0IGJlIHVzZWQgKHVtIGJ1aWxkcykNCnRo
ZW4ganVzdCBhZGQgdG9nZXRoZXIgdGhlIGZpbmFsIGJ5dGVzIGFuZCBkbyBhIHNpbmdsZSAnYWRj
Jw0KdG8gYWRkIHRvIHRoZSA2NGJpdCBzdW0uDQoNClNpZ25lZC1vZmYtYnk6IERhdmlkIExhaWdo
dCA8ZGF2aWQubGFpZ2h0QGFjdWxhYi5jb20+DQotLS0NCg0KSXQgaXMgYSBzaGFtZSB0aGF0IHRo
aXMgY29kZSBpcyBuZWVkZWQgYXQgYWxsLg0KSSBkb3VidCB1bSB3b3VsZCBldmVyIGZhdWx0IGp1
c3QgcmVhZGluZyB0aGUgMzJiaXQgdmFsdWUuDQoNCiBhcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFs
XzY0LmMgfCAzMyArKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMgYi9hcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFs
XzY0LmMNCmluZGV4IDA2MWIxZWQ3NGQ2YS4uZWRkM2U1NzljMmE3IDEwMDY0NA0KLS0tIGEvYXJj
aC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jDQorKysgYi9hcmNoL3g4Ni9saWIvY3N1bS1wYXJ0
aWFsXzY0LmMNCkBAIC03Myw0MSArNzMsMjggQEAgX193c3VtIGNzdW1fcGFydGlhbChjb25zdCB2
b2lkICpidWZmLCBpbnQgbGVuLCBfX3dzdW0gc3VtKQ0KIAkJYnVmZiArPSA4Ow0KIAl9DQogCWlm
IChsZW4gJiA3KSB7DQorCQl1bnNpZ25lZCBsb25nIHRyYWlsOw0KICNpZmRlZiBDT05GSUdfRENB
Q0hFX1dPUkRfQUNDRVNTDQogCQl1bnNpZ25lZCBpbnQgc2hpZnQgPSAoOCAtIChsZW4gJiA3KSkg
KiA4Ow0KLQkJdW5zaWduZWQgbG9uZyB0cmFpbDsNCiANCiAJCXRyYWlsID0gKGxvYWRfdW5hbGln
bmVkX3plcm9wYWQoYnVmZikgPDwgc2hpZnQpID4+IHNoaWZ0Ow0KLQ0KLQkJYXNtKCJhZGRxICVb
dHJhaWxdLCVbcmVzXVxuXHQiDQotCQkgICAgImFkY3EgJDAsJVtyZXNdIg0KLQkJCTogW3Jlc10g
IityIiAodGVtcDY0KQ0KLQkJCTogW3RyYWlsXSAiciIgKHRyYWlsKSk7DQogI2Vsc2UNCisJCXRy
YWlsID0gMDsNCiAJCWlmIChsZW4gJiA0KSB7DQotCQkJYXNtKCJhZGRxICVbdmFsXSwlW3Jlc11c
blx0Ig0KLQkJCSAgICAiYWRjcSAkMCwlW3Jlc10iDQotCQkJCTogW3Jlc10gIityIiAodGVtcDY0
KQ0KLQkJCQk6IFt2YWxdICJyIiAoKHU2NCkqKHUzMiAqKWJ1ZmYpDQotCQkJCTogIm1lbW9yeSIp
Ow0KKwkJCXRyYWlsICs9ICoodTMyICopYnVmZjsNCiAJCQlidWZmICs9IDQ7DQogCQl9DQogCQlp
ZiAobGVuICYgMikgew0KLQkJCWFzbSgiYWRkcSAlW3ZhbF0sJVtyZXNdXG5cdCINCi0JCQkgICAg
ImFkY3EgJDAsJVtyZXNdIg0KLQkJCQk6IFtyZXNdICIrciIgKHRlbXA2NCkNCi0JCQkJOiBbdmFs
XSAiciIgKCh1NjQpKih1MTYgKilidWZmKQ0KLQkJCQk6ICJtZW1vcnkiKTsNCisJCQl0cmFpbCAr
PSAqKHUxNiAqKWJ1ZmY7DQogCQkJYnVmZiArPSAyOw0KIAkJfQ0KLQkJaWYgKGxlbiAmIDEpIHsN
Ci0JCQlhc20oImFkZHEgJVt2YWxdLCVbcmVzXVxuXHQiDQotCQkJICAgICJhZGNxICQwLCVbcmVz
XSINCi0JCQkJOiBbcmVzXSAiK3IiICh0ZW1wNjQpDQotCQkJCTogW3ZhbF0gInIiICgodTY0KSoo
dTggKilidWZmKQ0KLQkJCQk6ICJtZW1vcnkiKTsNCi0JCX0NCisJCWlmIChsZW4gJiAxKQ0KKwkJ
CXRyYWlsICs9ICoodTggKilidWZmOw0KICNlbmRpZg0KKwkJYXNtKCJhZGRxICVbdHJhaWxdLCVb
cmVzXVxuXHQiDQorCQkgICAgImFkY3EgJDAsJVtyZXNdIg0KKwkJCTogW3Jlc10gIityIiAodGVt
cDY0KQ0KKwkJCTogW3RyYWlsXSAiciIgKHRyYWlsKSk7DQogCX0NCiAJcmVzdWx0ID0gYWRkMzJf
d2l0aF9jYXJyeSh0ZW1wNjQgPj4gMzIsIHRlbXA2NCAmIDB4ZmZmZmZmZmYpOw0KIAlyZXR1cm4g
KF9fZm9yY2UgX193c3VtKXJlc3VsdDsNCi0tIA0KMi4xNy4xDQoNCi0NClJlZ2lzdGVyZWQgQWRk
cmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBN
SzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

