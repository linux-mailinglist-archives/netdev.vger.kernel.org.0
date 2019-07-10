Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE11E64C69
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfGJSyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:54:02 -0400
Received: from LLMX2.LL.MIT.EDU ([129.55.12.48]:46980 "EHLO llmx2.ll.mit.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbfGJSyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 14:54:01 -0400
Received: from LLE2K16-MBX02.mitll.ad.local (LLE2K16-MBX02.mitll.ad.local) by llmx2.ll.mit.edu (unknown) with ESMTPS id x6AIrmiW024499; Wed, 10 Jul 2019 14:53:48 -0400
From:   "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Dustin Marquess" <dmarquess@apple.com>
Subject: RE: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Thread-Topic: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Thread-Index: AQKw2gvaIH+7kp/NrCmbg6L94CyO5gHbs90WAiPXn9kCN14y2gIOoPmspMqxmMCAAEuhgP//vbsQ
Date:   Wed, 10 Jul 2019 18:53:45 +0000
Message-ID: <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
In-Reply-To: <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.1.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8xMC8xOSAyOjI5IFBNLCBFcmljIER1bWF6ZXQgPGVyaWMuZHVtYXpldEBnbWFpbC5jb20+
IHdyb3RlOg0KPiBPbiA3LzEwLzE5IDg6MjMgUE0sIFByb3V0LCBBbmRyZXcgLSBMTFNDIC0gTUlU
TEwgd3JvdGU6DQo+PiBPbiA2LzE3LzE5IDg6MTkgUE0sIENocmlzdG9waCBQYWFzY2ggd3JvdGU6
DQo+Pj4NCj4+PiBZZXMsIHRoaXMgZG9lcyB0aGUgdHJpY2sgZm9yIG15IHBhY2tldGRyaWxsLXRl
c3QuDQo+Pj4NCj4+PiBJIHdvbmRlciwgaXMgdGhlcmUgYSB3YXkgd2UgY291bGQgZW5kIHVwIGlu
IGEgc2l0dWF0aW9uIHdoZXJlIHdlIGNhbid0DQo+Pj4gcmV0cmFuc21pdCBhbnltb3JlPw0KPj4+
IEZvciBleGFtcGxlLCBza193bWVtX3F1ZXVlZCBoYXMgZ3Jvd24gc28gbXVjaCB0aGF0IHRoZSBu
ZXcgdGVzdCBmYWlscy4NCj4+PiBUaGVuLCBpZiB3ZSBsZWdpdGltYXRlbHkgbmVlZCB0byBmcmFn
bWVudCBpbiBfX3RjcF9yZXRyYW5zbWl0X3NrYigpIHdlDQo+Pj4gd29uJ3QgYmUgYWJsZSB0byBk
byBzby4gU28gd2Ugd2lsbCBuZXZlciByZXRyYW5zbWl0LiBBbmQgaWYgbm8gQUNLDQo+Pj4gY29t
ZXMgYmFjayBpbiB0byBtYWtlIHNvbWUgcm9vbSB3ZSBhcmUgc3R1Y2ssIG5vPw0KPj4gDQo+PiBX
ZSBzZWVtIHRvIGJlIGhhdmluZyBleGFjdGx5IHRoaXMgcHJvYmxlbS4gV2XigJlyZSBydW5uaW5n
IG9uIHRoZSA0LjE0IGJyYW5jaC4gQWZ0ZXIgcmVjZW50bHkgdXBkYXRpbmcgb3VyIGtlcm5lbCwg
d2XigJl2ZSBiZWVuIGhhdmluZyBhIHByb2JsZW0gd2l0aCBUQ1AgY29ubmVjdGlvbnMgc3RhbGxp
bmcgLyBkeWluZyBvZmYgd2l0aG91dCBkaXNjb25uZWN0aW5nLiBUaGV5J3JlIHN0dWNrIGFuZCBu
ZXZlciByZWNvdmVyLg0KPj4gDQo+PiBJIGJpc2VjdGVkIHRoZSBwcm9ibGVtIHRvIDQuMTQuMTI3
IGNvbW1pdCA5ZGFmMjI2ZmY5MjY3OWQwOWFlY2ExYjVjMTI0MGUzNjA3MTUzMzM2IChjb21taXQg
ZjA3MGVmMmFjNjY3MTYzNTcwNjZiNjgzZmIwYmFmNTVmODE5MWEyZSB1cHN0cmVhbSk6IHRjcDog
dGNwX2ZyYWdtZW50KCkgc2hvdWxkIGFwcGx5IHNhbmUgbWVtb3J5IGxpbWl0cy4gVGhhdCBsZWFk
IG1lIHRvIHRoaXMgdGhyZWFkLg0KPj4gDQo+PiBPdXIgZW52aXJvbm1lbnQgaXMgYSBzdXBlcmNv
bXB1dGluZyBjZW50ZXI6IGxvdHMgb2Ygc2VydmVycyBpbnRlcmNvbm5lY3RlZCB3aXRoIGEgbm9u
LWJsb2NraW5nIDEwR2JpdCBldGhlcm5ldCBuZXR3b3JrLiBXZeKAmXZlIHplcm9lZCBpbiBvbiB0
aGUgcHJvYmxlbSBpbiB0d28gc2l0dWF0aW9uczogcmVtb3RlIHVzZXJzIG9uIFZQTiBhY2Nlc3Np
bmcgbGFyZ2UgZmlsZXMgdmlhIHNhbWJhIGFuZCBjb21wdXRlIGpvYnMgdXNpbmcgSW50ZWwgTVBJ
IG92ZXIgVENQL0lQL2V0aGVybmV0LiBJdCBjZXJ0YWlubHkgYWZmZWN0cyBvdGhlciBzaXR1YXRp
b25zLCBtYW55IG9mIG91ciB3b3JrbG9hZHMgaGF2ZSBiZWVuIHVuc3RhYmxlIHNpbmNlIHRoaXMg
cGF0Y2ggd2VudCBpbnRvIHByb2R1Y3Rpb24sIGJ1dCB0aG9zZSBhcmUgdGhlIHR3byB3ZSBjbGVh
cmx5IGlkZW50aWZpZWQgYXMgdGhleSBmYWlsIHJlbGlhYmx5IGV2ZXJ5IHRpbWUuIFdlIGhhZCB0
byB0YWtlIHRoZSBzeXN0ZW0gZG93biBmb3IgdW5zY2hlZHVsZWQgbWFpbnRlbmFuY2UgdG8gcm9s
bCBiYWNrIHRvIGFuIG9sZGVyIGtlcm5lbC4NCj4+IA0KPj4gVGhlIFRDUFdxdWV1ZVRvb0JpZyBj
b3VudCBpcyBpbmNyZW1lbnRpbmcgd2hlbiB0aGUgcHJvYmxlbSBvY2N1cnMuDQo+PiANCj4+IFVz
aW5nIGZ0cmFjZS90cmFjZS1jbWQgb24gYW4gYWZmZWN0ZWQgcHJvY2VzcywgaXQgYXBwZWFycyB0
aGUgY2FsbCBzdGFjayBpczoNCj4+IHJ1bl90aW1lcl9zb2Z0aXJxDQo+PiBleHBpcmVfdGltZXJz
DQo+PiBjYWxsX3RpbWVyX2ZuDQo+PiB0Y3Bfd3JpdGVfdGltZXINCj4+IHRjcF93cml0ZV90aW1l
cl9oYW5kbGVyDQo+PiB0Y3BfcmV0cmFuc21pdF90aW1lcg0KPj4gdGNwX3JldHJhbnNtaXRfc2ti
DQo+PiBfX3RjcF9yZXRyYW5zbWl0X3NrYg0KPj4gdGNwX2ZyYWdtZW50DQo+PiANCj4+IEFuZHJl
dyBQcm91dA0KPj4gTUlUIExpbmNvbG4gTGFib3JhdG9yeSBTdXBlcmNvbXB1dGluZyBDZW50ZXIN
Cj4+IA0KPg0KPiBXaGF0IHdhcyB0aGUga2VybmVsIHZlcnNpb24geW91IHVzZWQgZXhhY3RseSA/
DQo+DQo+IFRoaXMgcHJvYmxlbSBpcyBzdXBwb3NlZCB0byBiZSBmaXhlZCBpbiB2NC4xNC4xMzEN
Cg0KT3VyIGluaXRpYWwgcm9sbG91dCB3YXMgdjQuMTQuMTMwLCBidXQgSSByZXByb2R1Y2VkIGl0
IHdpdGggdjQuMTQuMTMyIGFzIHdlbGwsIHJlbGlhYmx5IGZvciB0aGUgc2FtYmEgdGVzdCBhbmQg
b25jZSAobm90IHJlbGlhYmx5KSB3aXRoIHN5bnRoZXRpYyB0ZXN0IEkgd2FzIHRyeWluZy4gQSBw
YXRjaGVkIHY0LjE0LjEzMiB3aXRoIHRoaXMgcGF0Y2ggcGFydGlhbGx5IHJldmVydGVkIChqdXN0
IHRoZSBmb3VyIGxpbmVzIGZyb20gdGNwX2ZyYWdtZW50IGRlbGV0ZWQpIHBhc3NlZCB0aGUgc2Ft
YmEgdGVzdC4NCg0KVGhlIHN5bnRoZXRpYyB0ZXN0IHdhcyBhIHBhaXIgb2Ygc2ltcGxlIHNlbmQv
cmVjdiB0ZXN0IHByb2dyYW1zIHVuZGVyIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoNCi1UaGUg
c2VuZCBzb2NrZXQgd2FzIG5vbi1ibG9ja2luZw0KLVNPX1NOREJVRiBzZXQgdG8gMTI4S2lCDQot
VGhlIHJlY2VpdmVyIE5JQyB3YXMgYmVpbmcgZmxvb2RlZCB3aXRoIHRyYWZmaWMgZnJvbSBtdWx0
aXBsZSBob3N0cyAodG8gaW5kdWNlIHBhY2tldCBsb3NzL3JldHJhbnNtaXRzKQ0KLUxvYWQgd2Fz
IG9uIGJvdGggc3lzdGVtczogYSB3aGlsZSgxKSBwcm9ncmFtIHNwaW5uaW5nIG9uIGVhY2ggQ1BV
IGNvcmUNCi1UaGUgcmVjZWl2ZXIgd2FzIG9uIGFuIG9sZGVyIHVuYWZmZWN0ZWQga2VybmVsDQoN
Cg==
