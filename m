Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EBB25DB6A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgIDOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:23:30 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:40614 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730609AbgIDOXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1599229384; x=1630765384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=vH690Cqxrcylr2PVLuTGgi3D0oEEZ51aZ51EqmMwu4Q=;
  b=ZnX4KtQrCfaMpTYPFUKOk2Sub485EuPQW0OcX1tvf9EWIVb8Sc+XvjaM
   XIlemR3UdbZMu9kcfu3Ua9Rc1HJzMeX4ddCC1rnn1kWoi+hpMz4S02Dzu
   t6EhX9zDPrXnQeRv+Ls7/QRQjHnbl/iVT1teUDlhydaeBgYyr6+5zEYVA
   E=;
X-IronPort-AV: E=Sophos;i="5.76,389,1592870400"; 
   d="scan'208";a="51899594"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Sep 2020 14:22:48 +0000
Received: from EX13D07EUA004.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 47877A26A2;
        Fri,  4 Sep 2020 14:22:47 +0000 (UTC)
Received: from EX13D07EUA004.ant.amazon.com (10.43.165.172) by
 EX13D07EUA004.ant.amazon.com (10.43.165.172) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 14:22:46 +0000
Received: from EX13D07EUA004.ant.amazon.com ([10.43.165.172]) by
 EX13D07EUA004.ant.amazon.com ([10.43.165.172]) with mapi id 15.00.1497.006;
 Fri, 4 Sep 2020 14:22:46 +0000
From:   "Nuernberger, Stefan" <snu@amazon.de>
To:     "Nuernberger, Stefan" <snu@amazon.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "orcohen@paloaltonetworks.com" <orcohen@paloaltonetworks.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Shah, Amit" <aams@amazon.de>
Subject: Re: [PATCH] net/packet: fix overflow in tpacket_rcv
Thread-Topic: [PATCH] net/packet: fix overflow in tpacket_rcv
Thread-Index: AQHWgsbcpzUESa8rkEuLvoGYqY0e/g==
Date:   Fri, 4 Sep 2020 14:22:46 +0000
Message-ID: <1599229365.17829.3.camel@amazon.de>
References: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
         <20200904133052.20299-1-snu@amazon.com>
         <20200904141617.GA3185752@kroah.com>
In-Reply-To: <20200904141617.GA3185752@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.192]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C9CD7EB534B9D49BA01A1EB67EE8E60@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTA0IGF0IDE2OjE2ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IE9uIEZyaSwgU2VwIDA0LCAyMDIwIGF0IDAzOjMwOjUyUE0gKzAyMDAsIFN0ZWZhbiBO
dWVybmJlcmdlciB3cm90ZToNCj4gPiANCj4gPiBGcm9tOiBPciBDb2hlbiA8b3Jjb2hlbkBwYWxv
YWx0b25ldHdvcmtzLmNvbT4NCj4gPiANCj4gPiBVc2luZyB0cF9yZXNlcnZlIHRvIGNhbGN1bGF0
ZSBuZXRvZmYgY2FuIG92ZXJmbG93IGFzDQo+ID4gdHBfcmVzZXJ2ZSBpcyB1bnNpZ25lZCBpbnQg
YW5kIG5ldG9mZiBpcyB1bnNpZ25lZCBzaG9ydC4NCj4gPiANCj4gPiBUaGlzIG1heSBsZWFkIHRv
IG1hY29mZiByZWNldmluZyBhIHNtYWxsZXIgdmFsdWUgdGhlbg0KPiA+IHNpemVvZihzdHJ1Y3Qg
dmlydGlvX25ldF9oZHIpLCBhbmQgaWYgcG8tPmhhc192bmV0X2hkcg0KPiA+IGlzIHNldCwgYW4g
b3V0LW9mLWJvdW5kcyB3cml0ZSB3aWxsIG9jY3VyIHdoZW4NCj4gPiBjYWxsaW5nIHZpcnRpb19u
ZXRfaGRyX2Zyb21fc2tiLg0KPiA+IA0KPiA+IFRoZSBidWcgaXMgZml4ZWQgYnkgY29udmVydGlu
ZyBuZXRvZmYgdG8gdW5zaWduZWQgaW50DQo+ID4gYW5kIGNoZWNraW5nIGlmIGl0IGV4Y2VlZHMg
VVNIUlRfTUFYLg0KPiA+IA0KPiA+IFRoaXMgYWRkcmVzc2VzIENWRS0yMDIwLTE0Mzg2DQo+ID4g
DQo+ID4gRml4ZXM6IDg5MTMzMzZhN2U4ZCAoInBhY2tldDogYWRkIFBBQ0tFVF9SRVNFUlZFIHNv
Y2tvcHQiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IE9yIENvaGVuIDxvcmNvaGVuQHBhbG9hbHRvbmV0
d29ya3MuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29v
Z2xlLmNvbT4NCj4gPiANCj4gPiBbIHNudTogYmFja3BvcnRlZCB0byA0LjksIGNoYW5nZWQgdHBf
ZHJvcHMgY291bnRpbmcvbG9ja2luZyBdDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RlZmFu
IE51ZXJuYmVyZ2VyIDxzbnVAYW1hem9uLmNvbT4NCj4gPiBDQzogRGF2aWQgV29vZGhvdXNlIDxk
d213QGFtYXpvbi5jby51az4NCj4gPiBDQzogQW1pdCBTaGFoIDxhYW1zQGFtYXpvbi5jb20+DQo+
ID4gQ0M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiAtLS0NCj4gPiDCoG5ldC9wYWNrZXQv
YWZfcGFja2V0LmMgfCA5ICsrKysrKysrLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiBXaGF0IGlzIHRoZSBnaXQgY29tbWl0IGlkIG9mIHRo
aXMgcGF0Y2ggaW4gTGludXMncyB0cmVlPw0KPiANCg0KU29ycnksIHRoaXMgaXNuJ3QgbWVyZ2Vk
IG9uIExpbnVzJyB0cmVlIHlldC4gSXQncyBhIGhlYWRzIHVwIHRoYXQgdGhlDQpiYWNrcG9ydCBp
c24ndCBzdHJhaWdodGZvcndhcmQuDQoNCkJlc3QsDQpTdGVmYW4NCg0KPiB0aGFua3MsDQo+IA0K
PiBncmVnIGstaAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1
c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2No
bGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90
dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIz
NyA4NzkKCgo=

