Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB2124C63
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLRQEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:04:01 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:60398 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfLRQEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:04:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576685040; x=1608221040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=voDwMOHiGrrwCVnh2V1kj4q6+XDfi45vtiaEg06Myxo=;
  b=ibKMEcojTafqAWUdRwiwvVwzXc1LxRsAEYhpvqvyEWcqruyQFRNomjZn
   QLilM3YoeV8Z3T4gRswGX/FlWyEX/lkL8yVGthaxXLo6rpRZ95n9S23ad
   nR4xeCEPro0uxc0yCuhjeBHYMec33UFR55KdyakEw+GsLAOvP9SAjIpT1
   k=;
IronPort-SDR: ZTRqmG3AKG4q4F5FiXVlYAZgb62eAdav4BmS3Z6HutJNkNoK4WgZweKfxSbNw7hTQA84ZbdVoR
 1KfgYxh8YCMA==
X-IronPort-AV: E=Sophos;i="5.69,330,1571702400"; 
   d="scan'208";a="9128141"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 18 Dec 2019 16:03:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id 7C1DBA180A;
        Wed, 18 Dec 2019 16:03:56 +0000 (UTC)
Received: from EX13D10EUB002.ant.amazon.com (10.43.166.66) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 18 Dec 2019 16:03:55 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D10EUB002.ant.amazon.com (10.43.166.66) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 18 Dec 2019 16:03:54 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Wed, 18 Dec 2019 16:03:54 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Luigi Rizzo <rizzo@iet.unipi.it>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: RE: XDP multi-buffer design discussion
Thread-Topic: XDP multi-buffer design discussion
Thread-Index: AQHVtBpASGPq4yH+3UGFRZGKpkgdhKe9uPIAgABL04CAAOYogIABEm1w
Date:   Wed, 18 Dec 2019 16:03:54 +0000
Message-ID: <fda0d409b60b4e0a94a0ed4f53f4a3cc@EX13D11EUB003.ant.amazon.com>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
 <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net>
 <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
 <20190823084704.075aeebd@carbon>
 <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
 <20191204155509.6b517f75@carbon>
 <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
 <20191216150728.38c50822@carbon>
 <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
 <20191217094635.7e4cac1c@carbon>
 <CA+hQ2+jzz2dZONYbW_+H6rE+u50a+r8p5yLtAWWSJFvjmnBz1g@mail.gmail.com>
In-Reply-To: <CA+hQ2+jzz2dZONYbW_+H6rE+u50a+r8p5yLtAWWSJFvjmnBz1g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.72]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHVpZ2kgUml6em8gPHJp
enpvQGlldC51bmlwaS5pdD4NCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAxOCwgMjAxOSAx
MjozMCBBTQ0KPiBUbzogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+
DQo+IENjOiBKdWJyYW4sIFNhbWloIDxzYW1lZWhqQGFtYXpvbi5jb20+OyBNYWNodWxza3ksIFpv
cmlrDQo+IDx6b3Jpa0BhbWF6b24uY29tPjsgRGFuaWVsIEJvcmttYW5uIDxib3JrbWFubkBpb2dl
YXJib3gubmV0PjsgRGF2aWQNCj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgVHphbGlr
LCBHdXkgPGd0emFsaWtAYW1hem9uLmNvbT47IElsaWFzDQo+IEFwYWxvZGltYXMgPGlsaWFzLmFw
YWxvZGltYXNAbGluYXJvLm9yZz47IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbg0KPiA8dG9rZUBy
ZWRoYXQuY29tPjsgS2l5YW5vdnNraSwgQXJ0aHVyIDxha2l5YW5vQGFtYXpvbi5jb20+OyBBbGV4
ZWkNCj4gU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgRGF2aWQgQWhlcm4NCj4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogWERQ
IG11bHRpLWJ1ZmZlciBkZXNpZ24gZGlzY3Vzc2lvbg0KPiANCj4gT24gVHVlLCBEZWMgMTcsIDIw
MTkgYXQgMTI6NDYgQU0gSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0KPiA8YnJvdWVyQHJlZGhhdC5j
b20+IHdyb3RlOg0KPiA+DQo+ID4gT24gTW9uLCAxNiBEZWMgMjAxOSAyMDoxNToxMiAtMDgwMA0K
PiA+IEx1aWdpIFJpenpvIDxyaXp6b0BpZXQudW5pcGkuaXQ+IHdyb3RlOg0KPiA+Li4uDQo+ID4g
PiBGb3Igc29tZSB1c2UgY2FzZXMsIHRoZSBicGYgcHJvZ3JhbSBjb3VsZCBkZWR1Y3QgdGhlIHRv
dGFsIGxlbmd0aA0KPiA+ID4gbG9va2luZyBhdCB0aGUgTDMgaGVhZGVyLg0KPiA+DQo+ID4gWWVz
LCB0aGF0IGFjdHVhbGx5IGdvb2QgaW5zaWdodC4gIEkgZ3Vlc3MgdGhlIEJQRi1wcm9ncmFtIGNv
dWxkIGFsc28NCj4gPiB1c2UgdGhpcyB0byBkZXRlY3QgdGhhdCBpdCBkb2Vzbid0IGhhdmUgYWNj
ZXNzIHRvIHRoZSBmdWxsLWxpbmVhcnkNCj4gPiBwYWNrZXQgdGhpcyB3YXkoPykNCj4gPg0KPiA+
ID4gSXQgd29uJ3Qgd29yayBmb3IgWERQX1RYIHJlc3BvbnNlIHRob3VnaC4NCj4gPg0KPiA+IFRo
ZSBYRFBfVFggY2FzZSBhbHNvIG5lZWQgdG8gYmUgZGlzY3Vzc2VkL2hhbmRsZWQuIElNSE8gbmVl
ZCB0bw0KPiA+IHN1cHBvcnQgWERQX1RYIGZvciBtdWx0aS1idWZmZXIgZnJhbWVzLiAgWERQX1RY
ICpjYW4qIGJlIGRyaXZlcg0KPiA+IHNwZWNpZmljLCBidXQgbW9zdCBkcml2ZXJzIGNob29zZSB0
byBjb252ZXJ0IHhkcF9idWZmIHRvIHhkcF9mcmFtZSwNCj4gPiB3aGljaCBtYWtlcyBpdCBwb3Nz
aWJsZSB0byB1c2Uvc2hhcmUgcGFydCBvZiB0aGUgWERQX1JFRElSRUNUIGNvZGUgZnJvbQ0KPiBu
ZG9feGRwX3htaXQuDQo+ID4NCj4gPiBXZSBhbHNvIG5lZWQgdG8gaGFuZGxlIFhEUF9SRURJUkVD
VCwgd2hpY2ggYmVjb21lcyBjaGFsbGVuZ2luZywgYXMgdGhlDQo+ID4gbmRvX3hkcF94bWl0IGZ1
bmN0aW9ucyBvZiAqYWxsKiBkcml2ZXJzIG5lZWQgdG8gYmUgdXBkYXRlZCAob3INCj4gPiBpbnRy
b2R1Y2UgYSBmbGFnIHRvIGhhbmRsZSB0aGlzIGluY3JlbWVudGFsbHkpLg0KPiANCj4gSGVyZSBp
cyBhIHBvc3NpYmxlIGNvdXJzZSBvZiBhY3Rpb24gKHBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3Ug
ZmluZCBsb29zZSBlbmRzKQ0KPiANCj4gMS4gZXh0ZW5kIHN0cnVjdCB4ZHBfYnVmZiB3aXRoIGEg
dG90YWwgbGVuZ3RoIGFuZCBza19idWZmICogKE5VTEwgYnkgZGVmYXVsdCk7DQo+IDIuIGFkZCBh
IG5ldGRldiBjYWxsYmFjayB0byBjb25zdHJ1Y3QgdGhlIHNrYiBmb3IgdGhlIGN1cnJlbnQgcGFj
a2V0Lg0KPiAgIFRoaXMgY29kZSBvYnZpb3VzbHkgYWxyZWFkeSBpbiBhbGwgZHJpdmVycywganVz
dCBuZWVkcyB0byBiZSBleHBvc2VkIGFzDQo+IGZ1bmN0aW9uDQo+ICAgY2FsbGFibGUgYnkgYSBi
cGYgaGVscGVyIChuZXh0IGJ1bGxldCk7IDMuIGFkZCBhIG5ldyBoZWxwZXIgJ2JwZl9jcmVhdGVf
c2tiJw0KPiB0aGF0IHdoZW4gaW52b2tlZCBjYWxscyB0aGUgcHJldmlvdXNseQ0KPiAgIG1lbnRp
b25lZCBuZXRkZXYgY2FsbGJhY2sgdG8gIGNvbnN0cnVjdHMgYW4gc2tiIGZvciB0aGUgY3VycmVu
dCBwYWNrZXQsDQo+ICAgYW5kIHNldHMgdGhlIHBvaW50ZXIgaW4gdGhlIHhkcF9idWZmLCBpZiBu
b3QgdGhlcmUgYWxyZWFkeS4NCj4gICBBIGJwZiBwcm9ncmFtIHRoYXQgbmVlZHMgdG8gYWNjZXNz
IHNlZ21lbnRzIGJleW9uZCB0aGUgZmlyc3Qgb25lIGNhbg0KPiAgIGNhbGwgYnBmX2NyZWF0ZV9z
a2IoKSBpZiBuZWVkZWQsIGFuZCB0aGVuIHVzZSBleGlzdGluZyBoZWxwZXJzDQo+ICAgc2tiX2xv
YWRfYnl0ZXMsIHNrYl9zdG9yZV9ieXRlcywgZXRjKSB0byBhY2Nlc3MgdGhlIHNrYi4NCj4gDQo+
ICAgTXkgcmF0aW9uYWxlIGlzIHRoYXQgaWYgd2UgbmVlZCB0byBhY2Nlc3MgbXVsdGlwbGUgc2Vn
bWVudHMsIHdlIGFyZSBhbHJlYWR5DQo+ICAgaW4gYW4gZXhwZW5zaXZlIHRlcnJpdG9yeSBhbmQg
aXQgbWFrZXMgbGl0dGxlIHNlbnNlIHRvIGRlZmluZSBhIG11bHRpIHNlZ21lbnQNCj4gICBmb3Jt
YXQgdGhhdCB3b3VsZCBlc3NlbnRpYWxseSBiZSBhbiBza2IuDQo+IA0KPiA0LiBpbXBsZW1lbnQg
YSBtZWNoYW5pc20gdG8gbGV0IHNvIHRoZSBkcml2ZXIga25vdyB3aGV0aGVyIHRoZSBjdXJyZW50
bHkNCj4gICBsb2FkZWQgYnBmIHByb2dyYW0gdW5kZXJzdGFuZHMgdGhlIG5ldyBmb3JtYXQuDQo+
ICAgVGhlcmUgYXJlIG11bHRpcGxlIHdheXMgdG8gZG8gdGhhdCwgYSB0cml2aWFsIG9uZSB3b3Vs
ZCBiZSB0byBjaGVjaywgZHVyaW5nDQo+IGxvYWQsDQo+ICAgdGhhdCB0aGUgcHJvZ3JhbSBjYWxs
cyBzb21lIGtub3duIGhlbHBlciBlZw0KPiBicGZfdW5kZXJzdGFuZHNfZnJhZ21lbnRzKCkNCj4g
ICB3aGljaCBpcyB0aGVuIGppdC1lZCB0byBzb21ldGhpam5nIGluZXhwZW5zaXZlDQo+IA0KPiAg
IE5vdGUgdGhhdCB0b2RheSwgYSBuZXRkZXYgdGhhdCBjYW5ub3QgZ3VhcmFudGVlIHNpbmdsZSBz
ZWdtZW50IHBhY2tldHMNCj4gd291bGQgbm90DQo+ICAgYmUgYWJsZSB0byBlbmFibGUgeGRwLiBI
ZW5jZSwgd2l0aG91dCBsb3NzIG9mIGZ1bmN0aW9uYWxpdHksIHN1Y2ggbmV0ZGV2IGNhbg0KPiBy
ZWZ1c2UgdG8NCj4gICBsb2FkIGEgcHJvZ3JhbSB3aXRob3V0IGJwZl91bmRlcnNkYW5kc19mcmFn
bWVudHMoKS4NCj4gDQo+IFdpdGggYWxsIHRoZSBhYm92ZSwgdGhlIGdlbmVyaWMgeGRwIGhhbmRs
ZXIgd291bGQgZG8gdGhlIGZvbGxvd2luZzoNCj4gIGlmICghc2tiX2lzX2xpbmVhcigpICYmICFi
cGZfdW5kZXJzdGFuZHNfZnJhZ21lbnRzKCkpIHsNCj4gICAgIDwgbGluZWFyaXplIHNrYj47DQo+
ICB9DQo+ICAgPGNvbnN0cnVjdCB4ZHBfYnVmZiB3aXRoIGZpcnN0IHNlZ21lbnQgYW5kIHNrYj4g
Ly8gc2tiIGlzIHVudXNlZCBieSBvbGQNCj4gc3R5bGUgcHJvZ3JhbXMNCj4gICA8Y2FsbCBicGYg
cHJvZ3JhbT4NCj4gDQo+IFRoZSBuYXRpdmUgZHJpdmVyIGZvciBhIGRldmljZSB0aGF0IGNhbm5v
dCBndWFyYW50ZWUgYSBzaW5nbGUgc2VnbWVudCB3b3VsZA0KPiBqdXN0IHJlZnVzZSB0byBsb2Fk
IGEgcHJvZ3JhbSB0aGF0IGRvZXMgbm90IHVuZGVyc3RhbmQgdGhlbSAoc2FtZSBhcw0KPiB0b2Rh
eSksIHNvIHRoZSBjb2RlIHdvdWxkIGJlOg0KPiANCj4gPGNvbnN0cnVjdCB4ZHBfYnVmZiB3aXRo
IGZpcnN0IHNlZ21lbnQgYW5kIGVtcHR5IHNrYj4gIDxjYWxsIGJwZiBwcm9ncmFtPg0KPiANCj4g
T24gcmV0dXJuLCB3ZSBtaWdodCBmaW5kIHRoYXQgYW4gc2tiIGhhcyBiZWVuIGJ1aWx0IGJ5IHRo
ZSB4ZHAgcHJvZ3JhbSwgYW5kDQo+IGNhbiBiZSBpbW1lZGlhdGVseSB1c2VkIGZvciBYRFBfUEFT
UyAob3IgZHJvcHBlZCBpbiBjYXNlIG9mIFhEUF9EUk9QKQ0KPiBGb3IgWERQX1RYIGFuZCBYRFBf
UkVESVJFQ1QsIHNvbWV0aGluZyBzaW1pbGFyOiBpZiB0aGUgcGFja2V0IGlzIGEgc2luZ2xlDQo+
IHNlZ21lbnQgYW5kIHRoZXJlIGlzIG5vIHNrYiwgdXNlIHRoZSBleGlzdGluZyBhY2NlbGVyYXRl
ZCBwYXRoLiBJZiB0aGVyZSBhcmUNCj4gbXVsdGlwbGUgc2VnbWVudHMsIGNvbnN0cnVjdCB0aGUg
c2tiIGlmIG5vdCBleGlzdGluZyBhbHJlYWR5LCBhbmQgcGFzcyBpdCB0byB0aGUNCj4gc3RhbmRh
cmQgdHggcGF0aC4NCj4gDQo+IGNoZWVycw0KPiBsdWlnaQ0KDQpJIGhhdmUgd2VudCBvdmVyIHlv
dXIgc3VnZ2VzdGlvbiwgaXQgbG9va3MgZ29vZCB0byBtZSEgSSBjb3VsZG4ndCBmaW5kIGFueSBs
b29zZSBlbmRzLiBPbmUgdGhpbmcgdG8gbm90ZSBpcyB0aGF0IHRoZSBkcml2ZXIgbm93IG5lZWRz
DQp0byBzYXZlIHRoZSBjb250ZXh0IG9mIHRoZSBjdXJyZW50bHkgcHJvY2Vzc2VkIHBhY2tldCBp
biBmb3IgZWFjaCBxdWV1ZSBzbyB0aGF0IGl0IGNhbiBzdXBwb3J0IHRoZSBuZXRkZXYgY2FsbGJh
Y2sgZm9yIGNyZWF0aW5nIHRoZSBza2IuDQpUaGlzIHNvdW5kcyBhIGJpdCBtZXNzeSwgYnV0IEkg
dGhpbmsgaXQgc2hvdWxkIHdvcmsuDQoNCkknZCBsb3ZlIHRvIGhlYXIgbW9yZSB0aG91Z2h0cyBv
biB0aGlzLA0KSmFzcGVyLCBUb2tlIHdoYXQgZG8geW91IGd1eXMgdGhpbms/DQo=
