Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0220473804
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243961AbhLMWwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:52:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:58518 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237296AbhLMWwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:52:19 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-236-RVzOHFxaPKeIAG20wAJ41w-1; Mon, 13 Dec 2021 22:52:16 +0000
X-MC-Unique: RVzOHFxaPKeIAG20wAJ41w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 13 Dec 2021 22:52:15 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 13 Dec 2021 22:52:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Duyck' <alexanderduyck@fb.com>,
        'Noah Goldstein' <goldstein.w.n@gmail.com>,
        'Eric Dumazet' <edumazet@google.com>
CC:     "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        "'dave.hansen@linux.intel.com'" <dave.hansen@linux.intel.com>,
        'X86 ML' <x86@kernel.org>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'peterz@infradead.org'" <peterz@infradead.org>,
        'open list' <linux-kernel@vger.kernel.org>,
        'netdev' <netdev@vger.kernel.org>
Subject: RE: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Topic: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Index: AdfwSx7jhGb9mOkwS12sTJ1p5oR1JQABEUYAAAftMsA=
Date:   Mon, 13 Dec 2021 22:52:15 +0000
Message-ID: <db7346b355f14be0bbd450906252e4ab@AcuMS.aculab.com>
References: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
 <MW4PR15MB47622E3EB6776AEDB531F4A6BD749@MW4PR15MB4762.namprd15.prod.outlook.com>
In-Reply-To: <MW4PR15MB47622E3EB6776AEDB531F4A6BD749@MW4PR15MB4762.namprd15.prod.outlook.com>
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

RnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXJkdXlja0BmYi5jb20+DQo+IFNlbnQ6IDEz
IERlY2VtYmVyIDIwMjEgMTg6NDANCi4uLg0KPiA+IEFkZCBpbiB0aGUgdHJhaWxpbmcgYnl0ZXMg
Zmlyc3Qgc28gdGhhdCB0aGVyZSBpcyBubyBuZWVkIHRvIHdvcnJ5IGFib3V0IHRoZSBzdW0NCj4g
PiBleGNlZWRpbmcgNjQgYml0cy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIExhaWdo
dCA8ZGF2aWQubGFpZ2h0QGFjdWxhYi5jb20+DQo+ID4gLS0tDQo+ID4NCj4gPiBUaGlzIG91Z2h0
IHRvIGJlIGZhc3RlciAtIGJlY2F1c2Ugb2YgYWxsIHRoZSByZW1vdmVkICdhZGMgJDAnLg0KPiA+
IEd1ZXNzaW5nIGhvdyBmYXN0IHg4NiBjb2RlIHdpbGwgcnVuIGlzIGhhcmQhDQo+ID4gVGhlcmUg
YXJlIG90aGVyIHdheXMgb2YgaGFuZGluZyBidWZmZXJzIHRoYXQgYXJlIHNob3J0ZXIgdGhhbiA4
IGJ5dGVzLCBidXQgSSdkDQo+ID4gcmF0aGVyIGhvcGUgdGhleSBkb24ndCBoYXBwZW4gaW4gYW55
IGhvdCBwYXRocy4NCj4gPg0KPiA+IE5vdGUgLSBJJ3ZlIG5vdCBldmVuIGNvbXBpbGUgdGVzdGVk
IGl0Lg0KPiA+IChCdXQgaGF2ZSB0ZXN0ZWQgYW4gZXF1aXZhbGVudCBjaGFuZ2UgYmVmb3JlLikN
Cj4gPg0KPiA+ICBhcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMgfCA1NSArKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRp
b25zKCspLCAzNiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9s
aWIvY3N1bS1wYXJ0aWFsXzY0LmMgYi9hcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMNCj4g
PiBpbmRleCBhYmY4MTlkZDg1MjUuLmZiY2MwNzNmYzJiNSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNo
L3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9saWIvY3N1bS1w
YXJ0aWFsXzY0LmMNCj4gPiBAQCAtMzcsNiArMzcsMjQgQEAgX193c3VtIGNzdW1fcGFydGlhbChj
b25zdCB2b2lkICpidWZmLCBpbnQgbGVuLA0KPiA+IF9fd3N1bSBzdW0pDQo+ID4gIAl1NjQgdGVt
cDY0ID0gKF9fZm9yY2UgdTY0KXN1bTsNCj4gPiAgCXVuc2lnbmVkIHJlc3VsdDsNCj4gPg0KPiA+
ICsJaWYgKGxlbiAmIDcpIHsNCj4gPiArCQlpZiAodW5saWtlbHkobGVuIDwgOCkpIHsNCj4gPiAr
CQkJLyogQXZvaWQgZmFsbGluZyBvZmYgdGhlIHN0YXJ0IG9mIHRoZSBidWZmZXIgKi8NCj4gPiAr
CQkJaWYgKGxlbiAmIDQpIHsNCj4gPiArCQkJCXRlbXA2NCArPSAqKHUzMiAqKWJ1ZmY7DQo+ID4g
KwkJCQlidWZmICs9IDQ7DQo+ID4gKwkJCX0NCj4gPiArCQkJaWYgKGxlbiAmIDIpIHsNCj4gPiAr
CQkJCXRlbXA2NCArPSAqKHUxNiAqKWJ1ZmY7DQo+ID4gKwkJCQlidWZmICs9IDI7DQo+ID4gKwkJ
CX0NCj4gPiArCQkJaWYgKGxlbiAmIDEpDQo+ID4gKwkJCQl0ZW1wNjQgKz0gKih1OCAqKWJ1ZmY7
DQo+ID4gKwkJCWdvdG8gcmVkdWNlX3RvMzI7DQo+ID4gKwkJfQ0KPiA+ICsJCXRlbXA2NCArPSAq
KHU2NCAqKShidWZmICsgbGVuIC0gOCkgPDwgKDggLSAobGVuICYgNykpICogODsNCj4gPiArCX0N
Cj4gPiArDQo+IA0KPiBJIGRvbid0IHRoaW5rIHlvdXIgc2hpZnQgaXMgaGVhZGVkIGluIHRoZSBy
aWdodCBkaXJlY3Rpb24uIElmIHlvdXIgc3RhcnRpbmcgb2Zmc2V0IGlzICJidWZmICsgbGVuIC0g
OCINCj4gdGhlbiB5b3VyIHJlbWFpbmluZyBiaXRzIHNob3VsZCBiZSBpbiB0aGUgdXBwZXIgYnl0
ZXMgb2YgdGhlIHF3b3JkLCBub3QgdGhlIGxvd2VyIGJ5dGVzIHNob3VsZG4ndA0KPiB0aGV5PyBT
byBJIHdvdWxkIHRoaW5rIGl0IHNob3VsZCBiZSAiPj4iIG5vdCAiPDwiLg0KDQpCcmFpbi1mYXJ0
IDotKQ0KSXQgbmVlZHMgdG8gZGlzY2FyZCB0aGUgbG93IGJ5dGVzIC0gc28gPj4gaXMgaW5kZWVk
IHJpZ2h0Lg0KSSBkaWQgc2F5IEkgaGFkbid0IHRlc3RlZCBpdC4NCg0KQ2FjaGUgbGluZSB3aXNl
IEknbSBub3Qgc3VyZSB3aGV0aGVyIGl0IG1hdHRlcnMuDQpJZiB0aGUgZGF0YSBpcyBpbiB0aGUg
Y2FjaGUgaXQgZG9lc24ndCBtYXR0ZXIuDQpJZiB0aGUgZGF0YSBpc24ndCBpbiB0aGUgY2FjaGUg
dGhlbiB0aGUgb25seSByZWFsIHByb2JsZW0gaXMgaWYgdGhlDQpsaW5lIGdldHMgZXZpY3RlZCAt
IG9ubHkgbGlrZWx5IGZvciA0ay1pc2grIGJ1ZmZlcnMuDQpJJ2QgZ3Vlc3MgdGhlIGxhcmdlc3Qg
Y2hlY2tzdW0gaXMgdW5kZXIgMTUwMCBieXRlcyAtIGhhcmR3YXJlIGRvaW5nDQpUU08gd2lsbCBi
ZSBkb2luZyBoYXJkd2FyZSBjaGVja3N1bXMuIFNvIGV2ZWN0aW9ucyBhcmUgdW5saWtlbHkuDQoN
ClBsYXVzaWJseSB0aGUgKihidWYgKyBsZW4gLSA4KSByZWFkIGNvdWxkIGJlIGRvbmUgYWZ0ZXIg
dGhlIHdoaWxlKCkgbG9vcC4NClRoYXQgd291bGQgbmVlZCBhbiBhZGMgYW5kIGEgc2F2ZWQgY29w
eSBvZiB0aGUgbGVuZ3RoIChvciBhIHJlYWQgdGhhdCB3b3VsZCB0cmFwKQ0KYnV0IHdvdWxkIG9u
bHkgYmUgbG9hZGluZyB0aGUgJ25leHQnIGNhY2hlIGxpbmUuDQoNClNvIHlvdSdkIGVuZCB1cCB3
aXRoIHNvbWV0aGluZyBsaWtlOg0KCQl3aGlsZSAobGVuID49IDY0KSB7DQoJCQkuLi4NCgkJfQ0K
CQlpZiAobGVuICYgNykNCgkJCXRyYWlsID0gKih1NjQgKikoYnVmZiArIGxlbiAtIDgpID4+ICg4
IC0gKGxlbiAmIDcpKSAqIDg7DQoJCWlmIChsZW4gJiAzMikNCgkJCS4uLg0KCQlpZiAobGVuICYg
MTYpDQoJCQkuLi4NCgkJaWYgKGxlbiAmIDgpDQoJCQkuLi4NCgkJdGVtcDY0ICs9IHRyYWlsDQoJ
CWFkYyAkMCwgdGVtcDY0DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

