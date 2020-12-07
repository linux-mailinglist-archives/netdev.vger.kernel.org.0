Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47942D15B3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgLGQKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:10:37 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4001 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgLGQKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607357436; x=1638893436;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=X6Pnz/VS2dUkzkOXEYaW+HQ5ULk5mIZGqzHX1tDx63Q=;
  b=OtU3zCwhffRMzFbKGuf9yj2b16dFDbqsYxsVAbjeWDlnTUPOWCx431WH
   Lu727rPNByOWGi8u982cv3xSM5r0hmVxcvO4NU2vzQmqK8u92ykfw2rKR
   1cju3bYaUg8TegmsNi15aXQxc9qmC6GJ5Emo9+x9mkO1wJT0qhk0NFYlP
   c=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="102322107"
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning initialisation
 for high latency connections
Thread-Topic: [PATCH net-next] tcp: optimise receiver buffer autotuning initialisation for
 high latency connections
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Dec 2020 16:09:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id E37AD14175A;
        Mon,  7 Dec 2020 16:09:46 +0000 (UTC)
Received: from EX13D21UWB001.ant.amazon.com (10.43.161.108) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 16:09:46 +0000
Received: from EX13D18EUA004.ant.amazon.com (10.43.165.164) by
 EX13D21UWB001.ant.amazon.com (10.43.161.108) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 16:09:45 +0000
Received: from EX13D18EUA004.ant.amazon.com ([10.43.165.164]) by
 EX13D18EUA004.ant.amazon.com ([10.43.165.164]) with mapi id 15.00.1497.006;
 Mon, 7 Dec 2020 16:09:44 +0000
From:   "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Thread-Index: AQHWym1GjWRxI1tB2UKaX8lFVs4qcanoaEaAgANdNICAAAxqgA==
Date:   Mon, 7 Dec 2020 16:09:44 +0000
Message-ID: <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com>
References: <20201204180622.14285-1-abuehaze@amazon.com>
 <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com>
 <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
In-Reply-To: <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.102]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1921906471BEC4428650D69C3DA68767@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgID5TaW5jZSBJIGNhbiBub3QgcmVwcm9kdWNlIHRoaXMgcHJvYmxlbSB3aXRoIGFub3RoZXIg
TklDIG9uIHg4NiwgSQ0KICAgID5yZWFsbHkgd29uZGVyIGlmIHRoaXMgaXMgbm90IGFuIGlzc3Vl
IHdpdGggRU5BIGRyaXZlciBvbiBQb3dlclBDDQogICAgPnBlcmhhcHMgPw0KDQoNCkkgYW0gYWJs
ZSB0byByZXByb2R1Y2UgaXQgb24geDg2IGJhc2VkIEVDMiBpbnN0YW5jZXMgdXNpbmcgRU5BICBv
ciAgWGVuIG5ldGZyb250IG9yIEludGVsIGl4Z2JldmYgZHJpdmVyIG9uIHRoZSByZWNlaXZlciBz
byBpdCdzIG5vdCBzcGVjaWZpYyB0byBFTkEsIHdlIHdlcmUgYWJsZSB0byBlYXNpbHkgcmVwcm9k
dWNlIGl0IGJldHdlZW4gMiBWTXMgcnVubmluZyBpbiB2aXJ0dWFsIGJveCBvbiB0aGUgc2FtZSBw
aHlzaWNhbCBob3N0IGNvbnNpZGVyaW5nIHRoZSBlbnZpcm9ubWVudCByZXF1aXJlbWVudHMgSSBt
ZW50aW9uZWQgaW4gbXkgZmlyc3QgZS1tYWlsLg0KDQpXaGF0J3MgdGhlIFJUVCBiZXR3ZWVuIHRo
ZSBzZW5kZXIgJiByZWNlaXZlciBpbiB5b3VyIHJlcHJvZHVjdGlvbj8gQXJlIHlvdSB1c2luZyBi
YnIgb24gdGhlIHNlbmRlciBzaWRlPw0KDQpUaGFuayB5b3UuDQoNCkhhemVtDQoNCu+7v09uIDA3
LzEyLzIwMjAsIDE1OjI2LCAiRXJpYyBEdW1hemV0IiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4gd3Jv
dGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9m
IHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBp
cyBzYWZlLg0KDQoNCg0KICAgIE9uIFNhdCwgRGVjIDUsIDIwMjAgYXQgMTowMyBQTSBNb2hhbWVk
IEFidWVsZm90b2gsIEhhemVtDQogICAgPGFidWVoYXplQGFtYXpvbi5jb20+IHdyb3RlOg0KICAg
ID4NCiAgICA+IFVuZm9ydHVuYXRlbHkgZmV3IHRoaW5ncyBhcmUgbWlzc2luZyBpbiB0aGlzIHJl
cG9ydC4NCiAgICA+DQogICAgPiAgICAgV2hhdCBpcyB0aGUgUlRUIGJldHdlZW4gaG9zdHMgaW4g
eW91ciB0ZXN0ID8NCiAgICA+ICAgICAgPj4+Pj5SVFQgaW4gbXkgdGVzdCBpcyAxNjIgbXNlYywg
YnV0IEkgYW0gYWJsZSB0byByZXByb2R1Y2UgaXQgd2l0aCBsb3dlciBSVFRzIGZvciBleGFtcGxl
IEkgY291bGQgc2VlIHRoZSBpc3N1ZSBkb3dubG9hZGluZyBmcm9tIGdvb2dsZSAgIGVuZHBvaW50
IHdpdGggUlRUIG9mIDE2LjcgbXNlYywgYXMgbWVudGlvbmVkIGluIG15IHByZXZpb3VzIGUtbWFp
bCB0aGUgaXNzdWUgaXMgcmVwcm9kdWNpYmxlIHdoZW5ldmVyIFJUVCBleGNlZWRlZCAxMm1zZWMg
Z2l2ZW4gdGhhdCAgICB0aGUgc2VuZGVyIGlzIHVzaW5nIGJici4NCiAgICA+DQogICAgPiAgICAg
ICAgIFJUVCBiZXR3ZWVuIGhvc3RzIHdoZXJlIEkgcnVuIHRoZSBpcGVyZiB0ZXN0Lg0KICAgID4g
ICAgICAgICAjIHBpbmcgNTQuMTk5LjE2My4xODcNCiAgICA+ICAgICAgICAgUElORyA1NC4xOTku
MTYzLjE4NyAoNTQuMTk5LjE2My4xODcpIDU2KDg0KSBieXRlcyBvZiBkYXRhLg0KICAgID4gICAg
ICAgICA2NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMuMTg3OiBpY21wX3NlcT0xIHR0bD0zMyB0aW1l
PTE2MiBtcw0KICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMuMTg3OiBpY21w
X3NlcT0yIHR0bD0zMyB0aW1lPTE2MiBtcw0KICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDU0
LjE5OS4xNjMuMTg3OiBpY21wX3NlcT0zIHR0bD0zMyB0aW1lPTE2MiBtcw0KICAgID4gICAgICAg
ICA2NCBieXRlcyBmcm9tIDU0LjE5OS4xNjMuMTg3OiBpY21wX3NlcT00IHR0bD0zMyB0aW1lPTE2
MiBtcw0KICAgID4NCiAgICA+ICAgICAgICAgUlRUIGJldHdlZW4gbXkgRUMyIGluc3RhbmNlcyBh
bmQgZ29vZ2xlIGVuZHBvaW50Lg0KICAgID4gICAgICAgICAjIHBpbmcgMTcyLjIxNy40LjI0MA0K
ICAgID4gICAgICAgICBQSU5HIDE3Mi4yMTcuNC4yNDAgKDE3Mi4yMTcuNC4yNDApIDU2KDg0KSBi
eXRlcyBvZiBkYXRhLg0KICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDE3Mi4yMTcuNC4yNDA6
IGljbXBfc2VxPTEgdHRsPTEwMSB0aW1lPTE2LjcgbXMNCiAgICA+ICAgICAgICAgNjQgYnl0ZXMg
ZnJvbSAxNzIuMjE3LjQuMjQwOiBpY21wX3NlcT0yIHR0bD0xMDEgdGltZT0xNi43IG1zDQogICAg
PiAgICAgICAgIDY0IGJ5dGVzIGZyb20gMTcyLjIxNy40LjI0MDogaWNtcF9zZXE9MyB0dGw9MTAx
IHRpbWU9MTYuNyBtcw0KICAgID4gICAgICAgICA2NCBieXRlcyBmcm9tIDE3Mi4yMTcuNC4yNDA6
IGljbXBfc2VxPTQgdHRsPTEwMSB0aW1lPTE2LjcgbXMNCiAgICA+DQogICAgPiAgICAgV2hhdCBk
cml2ZXIgaXMgdXNlZCBhdCB0aGUgcmVjZWl2aW5nIHNpZGUgPw0KICAgID4gICAgICAgPj4+Pj4+
SSBhbSB1c2luZyBFTkEgZHJpdmVyIHZlcnNpb24gdmVyc2lvbjogMi4yLjEwZyBvbiB0aGUgcmVj
ZWl2ZXIgd2l0aCBzY2F0dGVyIGdhdGhlcmluZyBlbmFibGVkLg0KICAgID4NCiAgICA+ICAgICAg
ICAgIyBldGh0b29sIC1rIGV0aDAgfCBncmVwIHNjYXR0ZXItZ2F0aGVyDQogICAgPiAgICAgICAg
IHNjYXR0ZXItZ2F0aGVyOiBvbg0KICAgID4gICAgICAgICAgICAgICAgIHR4LXNjYXR0ZXItZ2F0
aGVyOiBvbg0KICAgID4gICAgICAgICAgICAgICAgIHR4LXNjYXR0ZXItZ2F0aGVyLWZyYWdsaXN0
OiBvZmYgW2ZpeGVkXQ0KDQogICAgVGhpcyBldGh0b29sIG91dHB1dCByZWZlcnMgdG8gVFggc2Nh
dHRlciBnYXRoZXIsIHdoaWNoIGlzIG5vdCByZWxldmFudA0KICAgIGZvciB0aGlzIGJ1Zy4NCg0K
ICAgIEkgc2VlIEVOQSBkcml2ZXIgbWlnaHQgdXNlIDE2IEtCIHBlciBpbmNvbWluZyBwYWNrZXQg
KGlmIEVOQV9QQUdFX1NJWkUgaXMgMTYgS0IpDQoNCiAgICBTaW5jZSBJIGNhbiBub3QgcmVwcm9k
dWNlIHRoaXMgcHJvYmxlbSB3aXRoIGFub3RoZXIgTklDIG9uIHg4NiwgSQ0KICAgIHJlYWxseSB3
b25kZXIgaWYgdGhpcyBpcyBub3QgYW4gaXNzdWUgd2l0aCBFTkEgZHJpdmVyIG9uIFBvd2VyUEMN
CiAgICBwZXJoYXBzID8NCg0KCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBFTUVBIFNBUkwsIDM4IGF2
ZW51ZSBKb2huIEYuIEtlbm5lZHksIEwtMTg1NSBMdXhlbWJvdXJnLCBSLkMuUy4gTHV4ZW1ib3Vy
ZyBCMTg2Mjg0CgpBbWF6b24gV2ViIFNlcnZpY2VzIEVNRUEgU0FSTCwgSXJpc2ggQnJhbmNoLCBP
bmUgQnVybGluZ3RvbiBQbGF6YSwgQnVybGluZ3RvbiBSb2FkLCBEdWJsaW4gNCwgSXJlbGFuZCwg
YnJhbmNoIHJlZ2lzdHJhdGlvbiBudW1iZXIgOTA4NzA1CgoK

