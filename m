Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167412D166A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgLGQfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:35:53 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:49477 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbgLGQfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607358952; x=1638894952;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=1TE/vjdhrdIfe9x3MEMLWWN4x0Rmc9u1j0P86dQkVqY=;
  b=V1/n3xn7TYxJrNIqkTUFUH5VpnK8dZb1Q43FGffVN0Hp81KNK9bbLqsa
   N+KmmI0+LnIUzZNpxvXCk2LhsVJomFcI7eRUWe/1PUiYw+CV16YkM9Q8B
   1/x/WCIzpKydk6aAjs1X/X2kCR4y+lmBIZq4OSnKi/iuvdTbrzvZ+pz1X
   o=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="94053379"
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning initialisation
 for high latency connections
Thread-Topic: [PATCH net-next] tcp: optimise receiver buffer autotuning initialisation for
 high latency connections
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Dec 2020 16:35:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 0BB08C089F;
        Mon,  7 Dec 2020 16:34:59 +0000 (UTC)
Received: from EX13D21UWB001.ant.amazon.com (10.43.161.108) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 16:34:59 +0000
Received: from EX13D18EUA004.ant.amazon.com (10.43.165.164) by
 EX13D21UWB001.ant.amazon.com (10.43.161.108) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 16:34:58 +0000
Received: from EX13D18EUA004.ant.amazon.com ([10.43.165.164]) by
 EX13D18EUA004.ant.amazon.com ([10.43.165.164]) with mapi id 15.00.1497.006;
 Mon, 7 Dec 2020 16:34:57 +0000
From:   "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Thread-Index: AQHWym1GjWRxI1tB2UKaX8lFVs4qcanoaEaAgANdNICAAAxqgIAAA6oAgAADYgA=
Date:   Mon, 7 Dec 2020 16:34:57 +0000
Message-ID: <05E336BF-BAF7-432D-85B5-4B06CD02D34C@amazon.com>
References: <20201204180622.14285-1-abuehaze@amazon.com>
 <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com>
 <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com>
 <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
In-Reply-To: <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.16]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2391D8E89807640A75CF4FDB4BDF54C@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MTAwbXMgUlRUDQoNCj5XaGljaCBleGFjdCB2ZXJzaW9uIG9mIGxpbnV4IGtlcm5lbCBhcmUgeW91
IHVzaW5nID8NCk9uIHRoZSByZWNlaXZlciBzaWRlIEkgY291bGQgc2VlIHRoZSBpc3N1ZSB3aXRo
IGFueSBtYWlubGluZSBrZXJuZWwgdmVyc2lvbiA+PTQuMTkuODYgd2hpY2ggaXMgdGhlIGZpcnN0
IGtlcm5lbCB2ZXJzaW9uIHRoYXQgaGFzIHBhdGNoZXMgWzFdICYgWzJdIGluY2x1ZGVkLg0KT24g
dGhlIHNlbmRlciBJIGFtIHVzaW5nIGtlcm5lbCA1LjQuMC1yYzYuDQoNCkxpbmtzOg0KDQpbMV0g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcGF0Y2h3b3JrL3BhdGNoLzExNTc5MzYvDQpbMl0gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcGF0Y2h3b3JrL3BhdGNoLzExNTc4ODMvDQoNClRoYW5rIHlv
dS4NCg0KSGF6ZW0NCg0KDQoNCu+7v09uIDA3LzEyLzIwMjAsIDE2OjI0LCAiRXJpYyBEdW1hemV0
IiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWls
IG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGlj
ayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNl
bmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIE9uIE1vbiwgRGVj
IDcsIDIwMjAgYXQgNTowOSBQTSBNb2hhbWVkIEFidWVsZm90b2gsIEhhemVtDQogICAgPGFidWVo
YXplQGFtYXpvbi5jb20+IHdyb3RlOg0KICAgID4NCiAgICA+ICAgICA+U2luY2UgSSBjYW4gbm90
IHJlcHJvZHVjZSB0aGlzIHByb2JsZW0gd2l0aCBhbm90aGVyIE5JQyBvbiB4ODYsIEkNCiAgICA+
ICAgICA+cmVhbGx5IHdvbmRlciBpZiB0aGlzIGlzIG5vdCBhbiBpc3N1ZSB3aXRoIEVOQSBkcml2
ZXIgb24gUG93ZXJQQw0KICAgID4gICAgID5wZXJoYXBzID8NCiAgICA+DQogICAgPg0KICAgID4g
SSBhbSBhYmxlIHRvIHJlcHJvZHVjZSBpdCBvbiB4ODYgYmFzZWQgRUMyIGluc3RhbmNlcyB1c2lu
ZyBFTkEgIG9yICBYZW4gbmV0ZnJvbnQgb3IgSW50ZWwgaXhnYmV2ZiBkcml2ZXIgb24gdGhlIHJl
Y2VpdmVyIHNvIGl0J3Mgbm90IHNwZWNpZmljIHRvIEVOQSwgd2Ugd2VyZSBhYmxlIHRvIGVhc2ls
eSByZXByb2R1Y2UgaXQgYmV0d2VlbiAyIFZNcyBydW5uaW5nIGluIHZpcnR1YWwgYm94IG9uIHRo
ZSBzYW1lIHBoeXNpY2FsIGhvc3QgY29uc2lkZXJpbmcgdGhlIGVudmlyb25tZW50IHJlcXVpcmVt
ZW50cyBJIG1lbnRpb25lZCBpbiBteSBmaXJzdCBlLW1haWwuDQogICAgPg0KICAgID4gV2hhdCdz
IHRoZSBSVFQgYmV0d2VlbiB0aGUgc2VuZGVyICYgcmVjZWl2ZXIgaW4geW91ciByZXByb2R1Y3Rp
b24/IEFyZSB5b3UgdXNpbmcgYmJyIG9uIHRoZSBzZW5kZXIgc2lkZT8NCg0KDQogICAgMTAwbXMg
UlRUDQoNCiAgICBXaGljaCBleGFjdCB2ZXJzaW9uIG9mIGxpbnV4IGtlcm5lbCBhcmUgeW91IHVz
aW5nID8NCg0KDQoNCiAgICA+DQogICAgPiBUaGFuayB5b3UuDQogICAgPg0KICAgID4gSGF6ZW0N
CiAgICA+DQogICAgPiBPbiAwNy8xMi8yMDIwLCAxNToyNiwgIkVyaWMgRHVtYXpldCIgPGVkdW1h
emV0QGdvb2dsZS5jb20+IHdyb3RlOg0KICAgID4NCiAgICA+ICAgICBDQVVUSU9OOiBUaGlzIGVt
YWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBj
bGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhl
IHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KICAgID4NCiAgICA+DQogICAg
Pg0KICAgID4gICAgIE9uIFNhdCwgRGVjIDUsIDIwMjAgYXQgMTowMyBQTSBNb2hhbWVkIEFidWVs
Zm90b2gsIEhhemVtDQogICAgPiAgICAgPGFidWVoYXplQGFtYXpvbi5jb20+IHdyb3RlOg0KICAg
ID4gICAgID4NCiAgICA+ICAgICA+IFVuZm9ydHVuYXRlbHkgZmV3IHRoaW5ncyBhcmUgbWlzc2lu
ZyBpbiB0aGlzIHJlcG9ydC4NCiAgICA+ICAgICA+DQogICAgPiAgICAgPiAgICAgV2hhdCBpcyB0
aGUgUlRUIGJldHdlZW4gaG9zdHMgaW4geW91ciB0ZXN0ID8NCiAgICA+ICAgICA+ICAgICAgPj4+
Pj5SVFQgaW4gbXkgdGVzdCBpcyAxNjIgbXNlYywgYnV0IEkgYW0gYWJsZSB0byByZXByb2R1Y2Ug
aXQgd2l0aCBsb3dlciBSVFRzIGZvciBleGFtcGxlIEkgY291bGQgc2VlIHRoZSBpc3N1ZSBkb3du
bG9hZGluZyBmcm9tIGdvb2dsZSAgIGVuZHBvaW50IHdpdGggUlRUIG9mIDE2LjcgbXNlYywgYXMg
bWVudGlvbmVkIGluIG15IHByZXZpb3VzIGUtbWFpbCB0aGUgaXNzdWUgaXMgcmVwcm9kdWNpYmxl
IHdoZW5ldmVyIFJUVCBleGNlZWRlZCAxMm1zZWMgZ2l2ZW4gdGhhdCAgICB0aGUgc2VuZGVyIGlz
IHVzaW5nIGJici4NCiAgICA+ICAgICA+DQogICAgPiAgICAgPiAgICAgICAgIFJUVCBiZXR3ZWVu
IGhvc3RzIHdoZXJlIEkgcnVuIHRoZSBpcGVyZiB0ZXN0Lg0KICAgID4gICAgID4gICAgICAgICAj
IHBpbmcgNTQuMTk5LjE2My4xODcNCiAgICA+ICAgICA+ICAgICAgICAgUElORyA1NC4xOTkuMTYz
LjE4NyAoNTQuMTk5LjE2My4xODcpIDU2KDg0KSBieXRlcyBvZiBkYXRhLg0KICAgID4gICAgID4g
ICAgICAgICA2NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMuMTg3OiBpY21wX3NlcT0xIHR0bD0zMyB0
aW1lPTE2MiBtcw0KICAgID4gICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMu
MTg3OiBpY21wX3NlcT0yIHR0bD0zMyB0aW1lPTE2MiBtcw0KICAgID4gICAgID4gICAgICAgICA2
NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMuMTg3OiBpY21wX3NlcT0zIHR0bD0zMyB0aW1lPTE2MiBt
cw0KICAgID4gICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMuMTg3OiBpY21w
X3NlcT00IHR0bD0zMyB0aW1lPTE2MiBtcw0KICAgID4gICAgID4NCiAgICA+ICAgICA+ICAgICAg
ICAgUlRUIGJldHdlZW4gbXkgRUMyIGluc3RhbmNlcyBhbmQgZ29vZ2xlIGVuZHBvaW50Lg0KICAg
ID4gICAgID4gICAgICAgICAjIHBpbmcgMTcyLjIxNy40LjI0MA0KICAgID4gICAgID4gICAgICAg
ICBQSU5HIDE3Mi4yMTcuNC4yNDAgKDE3Mi4yMTcuNC4yNDApIDU2KDg0KSBieXRlcyBvZiBkYXRh
Lg0KICAgID4gICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDE3Mi4yMTcuNC4yNDA6IGljbXBf
c2VxPTEgdHRsPTEwMSB0aW1lPTE2LjcgbXMNCiAgICA+ICAgICA+ICAgICAgICAgNjQgYnl0ZXMg
ZnJvbSAxNzIuMjE3LjQuMjQwOiBpY21wX3NlcT0yIHR0bD0xMDEgdGltZT0xNi43IG1zDQogICAg
PiAgICAgPiAgICAgICAgIDY0IGJ5dGVzIGZyb20gMTcyLjIxNy40LjI0MDogaWNtcF9zZXE9MyB0
dGw9MTAxIHRpbWU9MTYuNyBtcw0KICAgID4gICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDE3
Mi4yMTcuNC4yNDA6IGljbXBfc2VxPTQgdHRsPTEwMSB0aW1lPTE2LjcgbXMNCiAgICA+ICAgICA+
DQogICAgPiAgICAgPiAgICAgV2hhdCBkcml2ZXIgaXMgdXNlZCBhdCB0aGUgcmVjZWl2aW5nIHNp
ZGUgPw0KICAgID4gICAgID4gICAgICAgPj4+Pj4+SSBhbSB1c2luZyBFTkEgZHJpdmVyIHZlcnNp
b24gdmVyc2lvbjogMi4yLjEwZyBvbiB0aGUgcmVjZWl2ZXIgd2l0aCBzY2F0dGVyIGdhdGhlcmlu
ZyBlbmFibGVkLg0KICAgID4gICAgID4NCiAgICA+ICAgICA+ICAgICAgICAgIyBldGh0b29sIC1r
IGV0aDAgfCBncmVwIHNjYXR0ZXItZ2F0aGVyDQogICAgPiAgICAgPiAgICAgICAgIHNjYXR0ZXIt
Z2F0aGVyOiBvbg0KICAgID4gICAgID4gICAgICAgICAgICAgICAgIHR4LXNjYXR0ZXItZ2F0aGVy
OiBvbg0KICAgID4gICAgID4gICAgICAgICAgICAgICAgIHR4LXNjYXR0ZXItZ2F0aGVyLWZyYWds
aXN0OiBvZmYgW2ZpeGVkXQ0KICAgID4NCiAgICA+ICAgICBUaGlzIGV0aHRvb2wgb3V0cHV0IHJl
ZmVycyB0byBUWCBzY2F0dGVyIGdhdGhlciwgd2hpY2ggaXMgbm90IHJlbGV2YW50DQogICAgPiAg
ICAgZm9yIHRoaXMgYnVnLg0KICAgID4NCiAgICA+ICAgICBJIHNlZSBFTkEgZHJpdmVyIG1pZ2h0
IHVzZSAxNiBLQiBwZXIgaW5jb21pbmcgcGFja2V0IChpZiBFTkFfUEFHRV9TSVpFIGlzIDE2IEtC
KQ0KICAgID4NCiAgICA+ICAgICBTaW5jZSBJIGNhbiBub3QgcmVwcm9kdWNlIHRoaXMgcHJvYmxl
bSB3aXRoIGFub3RoZXIgTklDIG9uIHg4NiwgSQ0KICAgID4gICAgIHJlYWxseSB3b25kZXIgaWYg
dGhpcyBpcyBub3QgYW4gaXNzdWUgd2l0aCBFTkEgZHJpdmVyIG9uIFBvd2VyUEMNCiAgICA+ICAg
ICBwZXJoYXBzID8NCiAgICA+DQogICAgPg0KICAgID4NCiAgICA+DQogICAgPiBBbWF6b24gV2Vi
IFNlcnZpY2VzIEVNRUEgU0FSTCwgMzggYXZlbnVlIEpvaG4gRi4gS2VubmVkeSwgTC0xODU1IEx1
eGVtYm91cmcsIFIuQy5TLiBMdXhlbWJvdXJnIEIxODYyODQNCiAgICA+DQogICAgPiBBbWF6b24g
V2ViIFNlcnZpY2VzIEVNRUEgU0FSTCwgSXJpc2ggQnJhbmNoLCBPbmUgQnVybGluZ3RvbiBQbGF6
YSwgQnVybGluZ3RvbiBSb2FkLCBEdWJsaW4gNCwgSXJlbGFuZCwgYnJhbmNoIHJlZ2lzdHJhdGlv
biBudW1iZXIgOTA4NzA1DQogICAgPg0KICAgID4NCg0KCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBF
TUVBIFNBUkwsIDM4IGF2ZW51ZSBKb2huIEYuIEtlbm5lZHksIEwtMTg1NSBMdXhlbWJvdXJnLCBS
LkMuUy4gTHV4ZW1ib3VyZyBCMTg2Mjg0CgpBbWF6b24gV2ViIFNlcnZpY2VzIEVNRUEgU0FSTCwg
SXJpc2ggQnJhbmNoLCBPbmUgQnVybGluZ3RvbiBQbGF6YSwgQnVybGluZ3RvbiBSb2FkLCBEdWJs
aW4gNCwgSXJlbGFuZCwgYnJhbmNoIHJlZ2lzdHJhdGlvbiBudW1iZXIgOTA4NzA1CgoK

