Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF4E45DC5C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355646AbhKYOef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:34:35 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:29875 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351733AbhKYOce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:32:34 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-24-mchceWOrN9-mORPjxbuWFw-1; Thu, 25 Nov 2021 14:29:15 +0000
X-MC-Unique: mchceWOrN9-mORPjxbuWFw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 25 Nov 2021 14:29:14 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 25 Nov 2021 14:29:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Topic: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Index: AQHX4XFaeNlULo4wpkmTYyB+DTu/bKwT/kEAgABAnYCAAAZdAA==
Date:   Thu, 25 Nov 2021 14:29:14 +0000
Message-ID: <58ea0edf987e47ea9795b03e70f58d9a@AcuMS.aculab.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <06864387ba644a58816ab3a82a8b5f82@AcuMS.aculab.com>
 <CANn89i+HmN3DbfAtH+Uq_pBWYHXp5ioH8LyhGRAiHZhRLbs1nw@mail.gmail.com>
In-Reply-To: <CANn89i+HmN3DbfAtH+Uq_pBWYHXp5ioH8LyhGRAiHZhRLbs1nw@mail.gmail.com>
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

VGhlcmUgaXMgYW5vdGhlciBvcHRpbWlzYXRpb24geW91IGNhbiBkbyB0aGF0IHJlbW92ZXMgYSBj
b25kaXRpb25hbA0KZnJvbSB0aGUgZW5kIG9mIHRoZSBjaGVja3N1bSBnZW5lcmF0aW9uLg0KDQpU
aGUgJ2FkYycgc3VtIGlzIHJlZHVjZWQgdG8gMTYgYml0cyBsZWF2aW5nIGEgdmFsdWUgWzEuLjB4
ZmZmZl0uDQpUaGlzIGlzIHRoZW4gaW52ZXJ0ZWQgdG8gZ2V0IHRoZSBjaGVja3N1bSwgYnV0IHRo
ZSByYW5nZSBpcw0KdGhlbiBbMC4uMHhmZmZlXS4NClNvIDAgdGhlbiBoYXMgdG8gYmUgY29udmVy
dGVkIHRvIDB4ZmZmZi4NCg0KSWYgeW91IGFkZCAxIHRvIHRodyBpbnV0IGNoZWNrc3VtIG9uZSBv
ZiB0aGUgY3N1bV9wYXJ0aWFsKCkgY2FsbHMNCnRoZSBhZGMgc3VtIGlzIG9uZSB0b28gYmlnLCBz
byB0aGUgaW52ZXJ0ZWQgdmFsdWUgaXMgb25lIHRvbyBzbWFsbC4NCkFkZGluZyAxIHRvIHRoZSBp
bnZlcnRlZCB2YWx1ZSBmaXhlcyB0aGlzIGFuZCBsZWF2ZXMgYSBjaGVja3N1bQ0KaW4gdGhlIGNv
cnJlY3QgcmFuZ2UuDQoNClBvdGVudGlhbGx5IHRoZSBpbnZlcnQraW5jcmVtZW50IGNhbiBiZSBk
b25lIGFzIGEgbmVnYXRlIHByaW9yDQp0byB0aGUgZmluYWwgbWFza2luZyB3aXRoIDB4ZmZmZi4N
CihXaGljaCB0aGUgY29tcGlsZXIgbWF5IHdlbGwgc29ydCBvdXQgZm9yIHlvdS4pDQoNCllvdSBk
byBuZWVkIHRvIGtub3cgJ2Vhcmx5JyB0aGF0IHRoZSBjaGVja3N1bSBpcyBnb2luZyB0byBnZXQN
CmludmVydGVkIC0gb3IgdG9vIG1hbnkgcGxhY2VzIG1pZ2h0IGFkZCBpbiB0aGUgZXh0cmEgJ29u
ZScuDQoNCk9uIDY0Yml0IHN5c3RlbXMgdGhlICdpbnB1dCBjaGVja3N1bScgdG8gY3N1bV9wYXJ0
aWFsKCkgY2FuDQooYWxtb3N0IGNlcnRhaW5seSkgYmUgbWFkZSBhIGxvbmcgLSB3aXRoIGEgcHJv
dmlzbyB0aGF0IHRoZQ0KdmFsdWUgbXVzdCBub3QgZXhjZWVkIDIqKjU2IGJlY2F1c2UgdGhlIGZ1
bmN0aW9uIG1pZ2h0IHdhbnQNCnRvIGFkZCBhIHBhcnRpYWwgd29yZCB0byBpdC4NCg0KSSdtIGFs
c28gbm90IHN1cmUgaG93IHdlbGwgYW55IG9mIHRoaXMgcnVucyBvbiBtaXBzLWxpa2UgY3B1DQp0
aGF0IGRvbid0IGhhdmUgYSBjYXJyeSBmbGFnIChJIHRoaW5rIHRoaXMgaW5jbHVkZXMgcmlzY1Yp
Lg0KT24gNjRiaXQgY3B1IGl0IG1heSBiZSBiZXN0IHRvIGFkZCAzMmJpdCB2YWx1ZXMgdG8gNjRi
aXQgcmVnaXN0ZXJzLg0KDQpXaXRoIDIgbWVtb3J5IHJlYWQgcG9ydHMgaXQgaXMgZXZlbiBwb3Nz
aWJseSB0aGF0IGFuIHg4NiBjcHUNCmNhbiBkbyA4IGJ5dGVzL2Nsb2NrIGJ5IGFkZGluZyAzMiBi
aXQgdmFsdWVzIHRvIHR3byByZWdpc3RlcnMuDQpIb3dldmVyIHRoZSByZWFkcyB3b3VsZCBoYXZl
IHRvIGJlIGFsaWduZWQgYW5kIGFycmFuZ2VkIHRvDQphdm9pZCBjYWNoZSBiYW5rIGNvbmZsaWN0
cy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

