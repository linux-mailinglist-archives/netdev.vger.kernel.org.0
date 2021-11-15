Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9020A450259
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhKOK0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:26:35 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:23242 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230419AbhKOK0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 05:26:30 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-ImlIfi6GNAykwqR4SDA7fg-1; Mon, 15 Nov 2021 10:23:32 +0000
X-MC-Unique: ImlIfi6GNAykwqR4SDA7fg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 15 Nov 2021 10:23:31 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 15 Nov 2021 10:23:31 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [RFC] x86/csum: rewrite csum_partial()
Thread-Topic: [RFC] x86/csum: rewrite csum_partial()
Thread-Index: AQHX1sjWUoYmK80LukOvYdZq9v09u6wC9SrggAAat/CAAVPUkA==
Date:   Mon, 15 Nov 2021 10:23:31 +0000
Message-ID: <e08af965e5b4422e9b38d8ccd90f8e7b@AcuMS.aculab.com>
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <e6fcc05d59974ba9afa49ba07a7251aa@AcuMS.aculab.com>
 <3f7414264ba0456b9102dd63c695272e@AcuMS.aculab.com>
In-Reply-To: <3f7414264ba0456b9102dd63c695272e@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDE0IE5vdmVtYmVyIDIwMjEgMTQ6MTINCj4gLi4N
Cj4gPiBJZiB5b3UgYXJlbid0IHdvcnJpZWQgKHRvbyBtdWNoKSBhYm91dCBjcHUgYmVmb3JlIEJy
b2Fkd2VsbCB0aGVuIElJUkMNCj4gPiB0aGlzIGxvb3AgZ2V0cyBjbG9zZSB0byA4IGJ5dGVzL2Ns
b2NrOg0KPiA+DQo+ID4gKyAgICAgICAgICAgICAgICIxMDogICAgamVjeHogMjBmXG4iDQo+ID4g
KyAgICAgICAgICAgICAgICIgICAgICAgYWRjICAgKCVbYnVmZl0sICVbbGVuXSksICVbc3VtXVxu
Ig0KPiA+ICsgICAgICAgICAgICAgICAiICAgICAgIGFkYyAgIDgoJVtidWZmXSwgJVtsZW5dKSwg
JVtzdW1dXG4iDQo+ID4gKyAgICAgICAgICAgICAgICIgICAgICAgbGVhICAgMTYoJVtsZW5dKSwg
JVt0bXBdXG4iDQo+ID4gKyAgICAgICAgICAgICAgICIgICAgICAgam1wICAgMTBiXG4iDQo+ID4g
KyAgICAgICAgICAgICAgICIgMjA6Ig0KPiANCj4gSXQgaXMgZXZlbiBwb3NzaWJsZSBhIGxvb3Ag
YmFzZWQgb246DQo+IAkxMDoJYWRjCSglW2J1ZmZdLCAlW2xlbl0sIDgpLCAlc3VtDQo+IAkJaW5j
CSVbbGVuXQ0KPiAJCWpuegkxMGINCj4gd2lsbCBydW4gYXQgOCBieXRlcyBwZXIgY2xvY2sgb24g
dmVyeSByZWNlbnQgSW50ZWwgY3B1Lg0KDQpJdCBkb2Vzbid0IG9uIGk3LTc3MDAuDQood2hpY2gg
SSBwcm9iYWJseSB0ZXN0ZWQgbGFzdCB5ZWFyKS4NCg0KQnV0IHRoZSBmaXJzdCBsb29wIGRvZXMg
cnVuIHR3aWNlIGFzIGZhc3QgLSBhbmQgd2lsbCBvbmx5DQpiZSBiZWF0ZW4gYnkgdGhlIGFkY3gv
YWRveCBsb29wLg0KU28gdGhlcmUgaXMgbm8gbmVlZCB0byB1bnJvbGwgdG8gbW9yZSB0aGFuIDIg
cmVhZHMvbG9vcC4NCg0KRm9yIGNwdSBiZXR3ZWVuIEl2eSBicmlkZ2UgYW5kIEJyb2Fkd2VsbCB5
b3Ugd2FudCB0byB1c2UNCnNlcGFyYXRlICdzdW0nIHJlZ2lzdGVycyB0byBhdm9pZCB0aGUgMiBj
bG9jayBsYXRlbmN5DQpvZiB0aGUgYWRjIHJlc3VsdC4NClRoYXQgc2hvdWxkIGJlYXQgdGhlIDQg
Ynl0ZXMvY2xvY2sgb2YgdGhlIGN1cnJlbnQgbG9vcC4NCkJ1dCBkb2VzIG5lZWQgYW4gZXh0cmEg
dW5yb2xsIHRvIGdldCBuZWFyIDggYnl0ZXMvY2xvY2suDQoNCkZvciBvbGRlciBjcHUgKG5laGFs
ZW0vY29yZTIpIHRoZSAnamVjeHonIGxvb3AgaXMgYWJvdXQgdGhlDQpvbmx5IHdheSB0byAnbG9v
cCBjYXJyeScgdGhlIGNhcnJ5IGZsYWcgd2l0aG91dCB0aGUNCjYgY2xvY2sgcGVuYWx0eSBmb3Ig
dGhlIHBhcnRpYWwgZmxhZ3MgcmVnaXN0ZXIgdXBkYXRlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

