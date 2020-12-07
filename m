Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4572D17F0
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 18:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgLGRzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 12:55:17 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46716 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgLGRzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 12:55:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607363716; x=1638899716;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=DxhoOxY3Snlz0AlYX3OqaKrveIdDfacZacRO30hH30w=;
  b=NwAg1hSVuvxIG20uGDchQ52jQe+AWWhwhxUooXrvl9BErrVCgoEQIee4
   JNMXpnT/qv96NUJ5SuMX/yGJJfIeJft2JU6fQEtmmAH7BcW4J5j+nY13m
   NE8IZwO4El7BXiPr6Ud7D/cGMS5aRt493jb3a0WbVSrhNnCRhRnrKs8k0
   s=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="71060851"
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning initialisation
 for high latency connections
Thread-Topic: [PATCH net-next] tcp: optimise receiver buffer autotuning initialisation for
 high latency connections
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 07 Dec 2020 17:54:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 21DCD226063;
        Mon,  7 Dec 2020 17:54:34 +0000 (UTC)
Received: from EX13D35UWB004.ant.amazon.com (10.43.161.230) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 17:54:33 +0000
Received: from EX13D18EUA004.ant.amazon.com (10.43.165.164) by
 EX13D35UWB004.ant.amazon.com (10.43.161.230) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 17:54:32 +0000
Received: from EX13D18EUA004.ant.amazon.com ([10.43.165.164]) by
 EX13D18EUA004.ant.amazon.com ([10.43.165.164]) with mapi id 15.00.1497.006;
 Mon, 7 Dec 2020 17:54:31 +0000
From:   "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Thread-Index: AQHWym1GjWRxI1tB2UKaX8lFVs4qcanoaEaAgANdNICAAAxqgIAAA6oAgAADYgCAABPjgIAAAlmA
Date:   Mon, 7 Dec 2020 17:54:31 +0000
Message-ID: <D78D31DF-F032-4EFB-BB79-31750797908D@amazon.com>
References: <20201204180622.14285-1-abuehaze@amazon.com>
 <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com>
 <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com>
 <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
 <05E336BF-BAF7-432D-85B5-4B06CD02D34C@amazon.com>
 <X85qX19mo5XesW8b@kroah.com>
In-Reply-To: <X85qX19mo5XesW8b@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5226238BFAB94F4CBAAE16665DC56A53@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PjUuNC4wLXJjNiBpcyBhIHZlcnkgb2xkIGFuZCBvZGQga2VybmVsIHRvIGJlIGRvaW5nIGFueXRo
aW5nIHdpdGguICBBcmUNCj55b3Ugc3VyZSB5b3UgZG9uJ3QgbWVhbiAiNS4xMC1yYzYiIGhlcmU/
DQoNCkkgd2FzIGFibGUgdG8gcmVwcm9kdWNlIGl0IG9uIHRoZSBsYXRlc3QgbWFpbmxpbmUga2Vy
bmVsIGFzIHdlbGwgIHNvIGFueXRoaW5nIG5ld2VyIHRoYW4gNC4xOS44NSBpcyBqdXN0IGJyb2tl
bi4NCg0KVGhhbmsgeW91Lg0KDQpIYXplbQ0KDQrvu79PbiAwNy8xMi8yMDIwLCAxNzo0NSwgIkdy
ZWcgS0giIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQoNCiAgICBDQVVUSU9O
OiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24u
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNv
bmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAg
IE9uIE1vbiwgRGVjIDA3LCAyMDIwIGF0IDA0OjM0OjU3UE0gKzAwMDAsIE1vaGFtZWQgQWJ1ZWxm
b3RvaCwgSGF6ZW0gd3JvdGU6DQogICAgPiAxMDBtcyBSVFQNCiAgICA+DQogICAgPiA+V2hpY2gg
ZXhhY3QgdmVyc2lvbiBvZiBsaW51eCBrZXJuZWwgYXJlIHlvdSB1c2luZyA/DQogICAgPiBPbiB0
aGUgcmVjZWl2ZXIgc2lkZSBJIGNvdWxkIHNlZSB0aGUgaXNzdWUgd2l0aCBhbnkgbWFpbmxpbmUg
a2VybmVsDQogICAgPiB2ZXJzaW9uID49NC4xOS44NiB3aGljaCBpcyB0aGUgZmlyc3Qga2VybmVs
IHZlcnNpb24gdGhhdCBoYXMgcGF0Y2hlcw0KICAgID4gWzFdICYgWzJdIGluY2x1ZGVkLiAgT24g
dGhlIHNlbmRlciBJIGFtIHVzaW5nIGtlcm5lbCA1LjQuMC1yYzYuDQoNCiAgICA1LjQuMC1yYzYg
aXMgYSB2ZXJ5IG9sZCBhbmQgb2RkIGtlcm5lbCB0byBiZSBkb2luZyBhbnl0aGluZyB3aXRoLiAg
QXJlDQogICAgeW91IHN1cmUgeW91IGRvbid0IG1lYW4gIjUuMTAtcmM2IiBoZXJlPw0KDQogICAg
dGhhbmtzLA0KDQogICAgZ3JlZyBrLWgNCg0KCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBFTUVBIFNB
UkwsIDM4IGF2ZW51ZSBKb2huIEYuIEtlbm5lZHksIEwtMTg1NSBMdXhlbWJvdXJnLCBSLkMuUy4g
THV4ZW1ib3VyZyBCMTg2Mjg0CgpBbWF6b24gV2ViIFNlcnZpY2VzIEVNRUEgU0FSTCwgSXJpc2gg
QnJhbmNoLCBPbmUgQnVybGluZ3RvbiBQbGF6YSwgQnVybGluZ3RvbiBSb2FkLCBEdWJsaW4gNCwg
SXJlbGFuZCwgYnJhbmNoIHJlZ2lzdHJhdGlvbiBudW1iZXIgOTA4NzA1CgoK

