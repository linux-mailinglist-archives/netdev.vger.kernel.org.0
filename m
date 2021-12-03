Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4ED467BBD
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382127AbhLCQu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:50:59 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:37874 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhLCQu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:50:59 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-12-BOM5Khu5PZeik7s3oZpz4g-1; Fri, 03 Dec 2021 16:47:33 +0000
X-MC-Unique: BOM5Khu5PZeik7s3oZpz4g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 3 Dec 2021 16:47:32 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 3 Dec 2021 16:47:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Topic: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Index: AQHX57zbDWxMByH9C0Scwj/3q1CYoawfrjxggAAMpYCAASAbAIAAG8JygAADGpA=
Date:   Fri, 3 Dec 2021 16:47:32 +0000
Message-ID: <43cc0ca9a0e14fc995c0c28d31440c15@AcuMS.aculab.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf>
 <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
 <20211202214009.5hm3diwom4qsbsjd@skbuf>
 <eb25fee06370430d8cd14e25dff5e653@AcuMS.aculab.com>
 <20211203161429.htqt4vuzd22rlwkf@skbuf>
 <CANn89iKk=DZEbwAeaborF-Q5pE9=Jahc0TP1_wk59s2eqB0o1A@mail.gmail.com>
In-Reply-To: <CANn89iKk=DZEbwAeaborF-Q5pE9=Jahc0TP1_wk59s2eqB0o1A@mail.gmail.com>
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

PiA+IEVyaWMsIGNvdWxkIHlvdSBwbGVhc2Ugc2VuZCBhIHBhdGNoIHdpdGggdGhpcyBjaGFuZ2U/
DQo+IA0KPiBTdXJlLCBJIHdpbGwgZG8gdGhpcyB0b2RheSwgYWZ0ZXIgbW9yZSB0ZXN0aW5nLg0K
DQpJJ3ZlIGp1c3QgZG9uZSBhIHF1aWNrIGdyZXAgYW5kIGZvdW5kIHR3byB+Y3N1bV9wYXJ0aWFs
KCkgaW4NCmluY2x1ZGUvbmV0L3NlZzYuaC4NCkJvdGggYXJlIHdyb25nIChhbmQgY29tcGxldGVs
eSBob3JyaWQpLg0KDQpUaGVyZSBhcmUgYWxzbyA0MCBjc3VtX3BhcnRpYWwoYnVmLCBsZW4sIDAp
Lg0KSWYgYWxsIHRoZSBidWZmZXIgaXMgemVybyB0aGV5J2xsIHJldHVybiB6ZXJvIC0gaW52YWxp
ZC4NClRoZXkgb3VnaHQgdG8gYmUgY2hhbmdlZCB0byBjc3VtX3BhcnRpYWwoYnVmLCBsZW4sIDB4
ZmZmZikuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

