Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250952CEA77
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgLDJFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:05:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:37884 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728279AbgLDJFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:05:17 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-288-Em2-OAYzMgCuFHGmlXnaDQ-1; Fri, 04 Dec 2020 09:03:38 +0000
X-MC-Unique: Em2-OAYzMgCuFHGmlXnaDQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 4 Dec 2020 09:03:37 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 4 Dec 2020 09:03:37 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arjun Roy' <arjunroy@google.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "soheil@google.com" <soheil@google.com>
Subject: RE: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
Thread-Topic: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data
 for TCP Rx. zerocopy.
Thread-Index: AQHWyQnnIy5Nhf4BLE+JcVO2pr+xUKnl/WUAgAAHm0eAAKF2IA==
Date:   Fri, 4 Dec 2020 09:03:37 +0000
Message-ID: <99eb2611ce8a47289a6c6360f29acdd7@AcuMS.aculab.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com>
 <20201202161527.51fcdcd7@hermes.local>
 <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
 <CAOFY-A07C=TEfob3S3-Dqm8tFTavFfEGqQwbisnNd+yKgDEGFA@mail.gmail.com>
 <CAOFY-A2vTwyA_45oUQR-91CMZya5i1y-4yzDboL+CnKceLzXPw@mail.gmail.com>
In-Reply-To: <CAOFY-A2vTwyA_45oUQR-91CMZya5i1y-4yzDboL+CnKceLzXPw@mail.gmail.com>
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

RnJvbTogQXJqdW4gUm95DQo+IFNlbnQ6IDAzIERlY2VtYmVyIDIwMjAgMjM6MjUNCi4uLg0KPiA+
ID4gWW91IGFsc28gaGF2ZSB0byBhbGxvdyBmb3Igb2xkICh3b3JraW5nKSBhcHBsaWNhdGlvbnMg
YmVpbmcgcmVjb21waWxlZA0KPiA+ID4gd2l0aCB0aGUgbmV3IGhlYWRlcnMuDQo+ID4gPiBTbyB5
b3UgY2Fubm90IHJlbHkgb24gdGhlIGZpZWxkcyBiZWluZyB6ZXJvIGV2ZW4gaWYgeW91IGFyZSBw
YXNzZWQNCj4gPiA+IHRoZSBzaXplIG9mIHRoZSBzdHJ1Y3R1cmUuDQo+ID4gPg0KPiA+DQo+ID4g
SSB0aGluayB0aGlzIHNob3VsZCBhbHJlYWR5IGJlIHRha2VuIGNhcmUgb2YgaW4gdGhlIGN1cnJl
bnQgY29kZTsgdGhlDQo+ID4gZnVsbC1zaXplZCBzdHJ1Y3Qgd2l0aCBuZXcgZmllbGRzIGlzIGJl
aW5nIHplcm8taW5pdGlhbGl6ZWQsIHRoZW4NCj4gPiB3ZSdyZSBnZXR0aW5nIHRoZSB1c2VyLXBy
b3ZpZGVkIG9wdGxlbiwgdGhlbiBjb3B5aW5nIGZyb20gdXNlcnNwYWNlDQo+ID4gb25seSB0aGF0
IG11Y2ggZGF0YS4gU28gdGhlIG5ld2VyIGZpZWxkcyB3b3VsZCBiZSB6ZXJvIGluIHRoYXQgY2Fz
ZSwNCj4gPiBzbyB0aGlzIHNob3VsZCBoYW5kbGUgdGhlIGNhc2Ugb2YgbmV3IGtlcm5lbHMgYnV0
IG9sZCBhcHBsaWNhdGlvbnMuDQo+ID4gRG9lcyB0aGlzIGFkZHJlc3MgdGhlIGNvbmNlcm4sIG9y
IGFtIEkgbWlzdW5kZXJzdGFuZGluZz8NCj4gPg0KPiANCj4gQWN0dWFsbHksIG9uIGNsb3NlciBy
ZWFkLCBwZXJoYXBzIHRoZSBmb2xsb3dpbmcgaXMgd2hhdCB5b3UgaGF2ZSBpbg0KPiBtaW5kIGZv
ciB0aGUgb2xkIGFwcGxpY2F0aW9uPw0KPiANCj4gc3RydWN0IHplcm9jb3B5X2FyZ3MgYXJnczsN
Cj4gYXJncy5hZGRyZXNzID0gLi4uOw0KPiBhcmdzLmxlbmd0aCA9IC4uLjsNCj4gYXJncy5yZWN2
X3NraXBfaGludCA9IC4uLjsNCj4gYXJncy5pbnEgPSAuLi47DQo+IGFyZ3MuZXJyID0gLi4uOw0K
PiBnZXRzb2Nrb3B0KGZkLCBJUFBST1RPX1RDUCwgVENQX1pFUk9DT1BZX1JFQ0VJVkUsICZhcmdz
LCBzaXplb2YoYXJncykpOw0KPiAvLyBzaXplb2YoYXJncykgaXMgbm93IGJpZ2dlciB3aGVuIHJl
Y29tcGlsZWQgd2l0aCBuZXcgaGVhZGVycywgYnV0IHdlDQo+IGRpZCBub3QgZXhwbGljaXRseSBz
ZXQgdGhlIG5ldyBmaWVsZHMgdG8gMCwgdGhlcmVmb3JlIGlzc3Vlcw0KDQpUaGF0J3MgdGhlIG9u
ZS4uLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

