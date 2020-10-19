Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26B12923A7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgJSIdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:33:32 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:30781 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729059AbgJSIdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 04:33:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-157-Det2cm1DPsyTr-zNjVOxGQ-1; Mon, 19 Oct 2020 09:33:28 +0100
X-MC-Unique: Det2cm1DPsyTr-zNjVOxGQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 19 Oct 2020 09:33:27 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 19 Oct 2020 09:33:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Florian Fainelli' <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Christian Eggers" <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: RE: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2covbenUJHrUGBeBnvt72Q+6mcR6aAgAADAwCAAk7l4A==
Date:   Mon, 19 Oct 2020 08:33:27 +0000
Message-ID: <049e7fd8f46c43819a05689fe464df25@AcuMS.aculab.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
In-Reply-To: <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
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

RnJvbTogRmxvcmlhbiBGYWluZWxsaT4NCj4gU2VudDogMTcgT2N0b2JlciAyMDIwIDIzOjEyDQou
Lg0KPiBOb3QgcG9zaXRpdmUgeW91IG5lZWQgdGhhdCBiZWNhdXNlIHlvdSBtYXkgYmUgYWNjb3Vu
dCBmb3IgbW9yZSBoZWFkIG9yDQo+IHRhaWwgcm9vbSB0aGFuIG5lY2Vzc2FyeS4NCj4gDQo+IEZv
ciBpbnN0YW5jZSB3aXRoIHRhZ19icmNtLmMgYW5kIHN5c3RlbXBvcnQuYyB3ZSBuZWVkIDQgYnl0
ZXMgb2YgaGVhZA0KPiByb29tIGZvciB0aGUgQnJvYWRjb20gdGFnIGFuZCBhbiBhZGRpdGlvbmFs
IDggYnl0ZXMgZm9yIHB1c2hpbmcgdGhlDQo+IHRyYW5zbWl0IHN0YXR1cyBibG9jayBkZXNjcmlw
dG9yIGluIGZyb250IG9mIHRoZSBFdGhlcm5ldCBmcmFtZSBhYm91dCB0bw0KPiBiZSB0cmFuc21p
dHRlZC4gVGhlc2UgYWRkaXRpb25hbCA4IGJ5dGVzIGFyZSBhIHJlcXVpcmVtZW50IG9mIHRoZSBE
U0ENCj4gbWFzdGVyIGhlcmUgYW5kIGV4aXN0IHJlZ2FyZGxlc3Mgb2YgRFNBIGJlaW5nIHVzZWQs
IGJ1dCB3ZSBzaG91bGQgbm90IGJlDQo+IHByb3BhZ2F0aW5nIHRoZW0gdG8gdGhlIERTQSBzbGF2
ZS4NCg0KSXMgaXQgcG9zc2libGUgdG8gc2VuZCB0aGUgZXh0cmEgYnl0ZXMgZnJvbSBhIHNlcGFy
YXRlIGJ1ZmZlciBmcmFnbWVudD8NClRoZSBlbnRpcmUgYXJlYSBjb3VsZCBiZSBhbGxvY2F0ZWQg
KGNvaGVyZW50KSB3aGVuIHRoZSByaW5ncyBhcmUNCmFsbG9jYXRlZC4NClRoYXQgd291bGQgc2F2
ZSBoYXZpbmcgdG8gbW9kaWZ5IHRoZSBza2IgYXQgYWxsLg0KDQpFdmVuIGlmIHNvbWUgYnl0ZXMg
b2YgdGhlIGZyYW1lIGhlYWRlciBuZWVkICdhZGp1c3RpbmcnIHRyYW5zbWl0dGluZw0KZnJvbSBh
IGNvcHkgbWF5IGJlIGZhc3RlciAtIGVzcGVjaWFsbHkgb24gc3lzdGVtcyB3aXRoIGFuIGlvbW11
Lg0KDQpNYW55IChtYW55KSBtb29ucyBhZ28gd2UgZm91bmQgdGhlIGN1dG9mZiBwb2ludCBmb3Ig
Y29weWluZyBmcmFtZXMNCm9uIGEgc3lzdGVtIHdpdGggYW4gaW9tbXUgdG8gYmUgYXJvdW5kIDFr
IGJ5dGVzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

