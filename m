Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102AC2F5D9A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbhANJbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:31:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:57777 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727324AbhANJbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:31:04 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-168-4vWQi2tZNvCQACouP4RCUg-1; Thu, 14 Jan 2021 09:29:24 +0000
X-MC-Unique: 4vWQi2tZNvCQACouP4RCUg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 14 Jan 2021 09:29:23 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 14 Jan 2021 09:29:23 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Greg Thelen" <gthelen@google.com>
Subject: RE: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Thread-Topic: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Thread-Index: AQHW6cgHRTEecj4eIU+21eAugdAvOaomIBlQgAB1MYCAAEJBAA==
Date:   Thu, 14 Jan 2021 09:29:23 +0000
Message-ID: <787e2b85cd2f4f0f90d7fe871dce85ff@AcuMS.aculab.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <b0c5b2164e90492c99752584070510d7@AcuMS.aculab.com>
 <CANn89iKS-J8BzMd+_PmFV67C+3hPx-C0saY0yFMdDWfHPwazHQ@mail.gmail.com>
In-Reply-To: <CANn89iKS-J8BzMd+_PmFV67C+3hPx-C0saY0yFMdDWfHPwazHQ@mail.gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDE0IEphbnVhcnkgMjAyMSAwNToxNw0KPiANCj4g
T24gV2VkLCBKYW4gMTMsIDIwMjEgYXQgMTE6MjMgUE0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWln
aHRAYWN1bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBFcmljIER1bWF6ZXQNCj4gPiA+
IFNlbnQ6IDEzIEphbnVhcnkgMjAyMSAxNjoxOA0KPiA+ID4NCj4gPiA+IEZyb206IEVyaWMgRHVt
YXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiA+DQo+ID4gPiBCb3RoIHZpcnRpbyBuZXQg
YW5kIG5hcGlfZ2V0X2ZyYWdzKCkgYWxsb2NhdGUgc2ticw0KPiA+ID4gd2l0aCBhIHZlcnkgc21h
bGwgc2tiLT5oZWFkDQo+ID4gPg0KPiA+ID4gV2hpbGUgdXNpbmcgcGFnZSBmcmFnbWVudHMgaW5z
dGVhZCBvZiBhIGttYWxsb2MgYmFja2VkIHNrYi0+aGVhZCBtaWdodCBnaXZlDQo+ID4gPiBhIHNt
YWxsIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IGluIHNvbWUgY2FzZXMsIHRoZXJlIGlzIGEgaHVn
ZSByaXNrIG9mDQo+ID4gPiB1bmRlciBlc3RpbWF0aW5nIG1lbW9yeSB1c2FnZS4NCj4gPg0KPiA+
IFRoZXJlIGlzIChvciB3YXMgbGFzdCB0aW1lIEkgbG9va2VkKSBhbHNvIGEgcHJvYmxlbSB3aXRo
DQo+ID4gc29tZSBvZiB0aGUgVVNCIGV0aGVybmV0IGRyaXZlcnMuDQo+ID4NCj4gPiBJSVJDIG9u
ZSBvZiB0aGUgQVNYbm5ubm5uICg/Pz8pIFVTQjMgb25lcyBhbGxvY2F0ZXMgNjRrIHNrYiB0byBw
YXNzDQo+ID4gdG8gdGhlIFVTQiBzdGFjayBhbmQgdGhlbiBqdXN0IGxpZXMgYWJvdXQgc2tiLT50
cnVlc2l6ZSB3aGVuIHBhc3NpbmcNCj4gPiB0aGVtIGludG8gdGhlIG5ldHdvcmsgc3RhY2suDQo+
IA0KPiBZb3Ugc3VyZSA/IEkgdGhpbmsgSSBoYXZlIGZpeGVkIHRoaXMgYXQgc29tZSBwb2ludA0K
PiANCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV0
ZGV2L25ldC5naXQvY29tbWl0Lz9pZD1hOWUwYWNhNGIzNzg4NWI1NTk5ZTUyMjExZjA5DQo+IDhi
ZDdmNTY1ZTc0OQ0KDQpJIG1pZ2h0IGhhdmUgZm9yZ290dGVuIHRoYXQgcGF0Y2ggOi0pDQpPciBw
b3NzaWJseSBvbmx5IHJlbWVtYmVyZWQgaXQgY2hhbmdpbmcgc21hbGwgcGFja2V0cy4NCg0KPiA+
IFRoZSBVU0IgaGFyZHdhcmUgd2lsbCBtZXJnZSBUQ1AgcmVjZWl2ZXMgYW5kIHB1dCBtdWx0aXBs
ZSBldGhlcm5ldA0KPiA+IHBhY2tldHMgaW50byBhIHNpbmdsZSBVU0IgbWVzc2FnZS4NCj4gPiBC
dXQgc2luZ2xlIGZyYW1lcyBjYW4gZW5kIHVwIGluIHZlcnkgYmlnIGtlcm5lbCBtZW1vcnkgYnVm
ZmVycy4NCj4gPg0KPiANCj4gWWVhaCwgdGhpcyBpcyBhIGtub3duIHByb2JsZW0uDQoNClRoZSB3
aG9sZSBVU0IgZXRoZXJuZXQgYmxvY2sgaXMgc29tZXdoYXQgaG9ycmlkIGFuZCBpbmVmZmljaWVu
dA0KZXNwZWNpYWxseSBmb3IgWEhDSS9VU0IzIC0gd2hpY2ggY291bGQgaGF2ZSBoaWdoIHNwZWVk
IGV0aGVybmV0Lg0KSXQgcmVhbGx5IG5lZWRzIHRvIGVpdGhlciBkaXJlY3RseSBpbnRlcmZhY2Ug
dG8gdGhlIFhIQ0kgcmluZw0KKGxpa2UgYSBub3JtYWwgZXRoZXJuZXQgZHJpdmVyKSBvciBiZSBn
aXZlbiB0aGUgc2VxdWVuY2Ugb2YNClVTQiByeCBwYWNrZXRzIHRvIHNwbGl0L2pvaW4gaW50byBl
dGhlcm5ldCBmcmFtZXMuDQoNCkhvd2V2ZXIgSSBkb24ndCBoYXZlIHRoZSB0aW1lIHRvIG1ha2Ug
dGhvc2UgY2hhbmdlcy4NCldoZW4gSSB3YXMgbG9va2luZyBhdCB0aGF0IGRyaXZlciAnZGF5am9i
JyB3YXMgYWN0dWFsbHkNCnRyeWluZyB0byBtYWtlIGl0IHdvcmsuDQpUaGV5IGRyb3BwZWQgdGhh
dCBpZGVhIGxhdGVyLg0KSSd2ZSBub3QgZ290IHRoZSBldGhlcm5ldCBkb25nbGUgYW55IG1vcmUg
ZWl0aGVyLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

