Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A6444F879
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 15:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhKNO0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 09:26:03 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:45639 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhKNOZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 09:25:59 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-8-P1MU69xVMHCi7EFyDeY1OA-1; Sun, 14 Nov 2021 14:21:21 +0000
X-MC-Unique: P1MU69xVMHCi7EFyDeY1OA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sun, 14 Nov 2021 14:21:20 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sun, 14 Nov 2021 14:21:20 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Duyck' <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: RE: [PATCH v1] x86/csum: rewrite csum_partial()
Thread-Topic: [PATCH v1] x86/csum: rewrite csum_partial()
Thread-Index: AQHX10cAOpi9KQuB9k+ZIH1JOmLVy6wDFk1Q
Date:   Sun, 14 Nov 2021 14:21:20 +0000
Message-ID: <3518c78fab894d01b391c764efffbb62@AcuMS.aculab.com>
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
In-Reply-To: <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
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

RnJvbTogQWxleGFuZGVyIER1eWNrDQo+IFNlbnQ6IDExIE5vdmVtYmVyIDIwMjEgMjE6NTYNCi4u
Lg0KPiBJdCBtaWdodCBiZSB3b3J0aHdoaWxlIHRvIGJlZWYgdXAgdGhlIG9kZCBjaGVjayB0byBh
Y2NvdW50IGZvcg0KPiBhbnl0aGluZyA3IGJ5dGVzIG9yIGxlc3MuIFRvIGFkZHJlc3MgaXQgeW91
IGNvdWxkIGRvIHNvbWV0aGluZyBhbG9uZw0KPiB0aGUgbGluZXMgb2Y6DQo+ICAgICB1bmFsaWdu
ZWQgPSA3ICYgKHVuc2lnbmVkIGxvbmcpIGJ1ZmY7DQo+ICAgICBpZiAodW5hbGlnbmVkKSB7DQo+
ICAgICAgICAgc2hpZnQgPSB1bmFsaWduZWQgKiA4Ow0KPiAgICAgICAgIHRlbXA2NCA9ICgqKHVu
c2lnbmVkIGxvbmcpYnVmZiA+PiBzaGlmdCkgPDwgc2hpZnQ7DQo+ICAgICAgICAgYnVmZiArPSA4
IC0gdW5hbGlnbmVkOw0KPiAgICAgICAgIGlmIChsZW4gPCA4IC0gdW5hbGlnbmVkKSB7DQo+ICAg
ICAgICAgICAgIHNoaWZ0ID0gKDggLSBsZW4gLSB1bmFsaWduZWQpICogODsNCj4gICAgICAgICAg
ICAgdGVtcDY0IDw8PSBzaGlmdDsNCj4gICAgICAgICAgICAgdGVtcDY0ID4+PSBzaGlmdDsNCj4g
ICAgICAgICAgICAgbGVuID0gMDsNCj4gICAgICAgICB9IGVsc2Ugew0KPiAgICAgICAgICAgICBs
ZW4gLT0gOCAtIHVuYWxpZ25lZDsNCj4gICAgICAgICB9DQo+ICAgICAgICAgcmVzdWx0ICs9IHRl
bXA2NDsNCj4gICAgICAgICByZXN1bHQgKz0gcmVzdWx0IDwgdGVtcDY0Ow0KPiAgICB9DQoNCkkg
dHJpZWQgZG9pbmcgdGhhdC4NCkJhc2ljYWxseSBpdCBpcyBsaWtlbHkgdG8gdGFrZSBsb25nZXIg
dGhhdCBqdXN0IGRvaW5nIHRoZSBtZW1vcnkgcmVhZHMuDQpUaGUgcmVnaXN0ZXIgZGVwZW5kZW5j
eSBjaGFpbiBpcyBqdXN0IHRvbyBsb25nLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

