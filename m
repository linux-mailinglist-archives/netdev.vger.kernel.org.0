Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BDC65EB4
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 19:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfGKRey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 13:34:54 -0400
Received: from LLMX3.LL.MIT.EDU ([129.55.12.49]:52154 "EHLO llmx3.ll.mit.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfGKRey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 13:34:54 -0400
X-Greylist: delayed 1184 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jul 2019 13:34:53 EDT
Received: from LLE2K16-MBX02.mitll.ad.local (LLE2K16-MBX02.mitll.ad.local) by llmx3.ll.mit.edu (unknown) with ESMTPS id x6BHExdT002065; Thu, 11 Jul 2019 13:14:59 -0400
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
Thread-Index: AQKw2gvaIH+7kp/NrCmbg6L94CyO5gHbs90WAiPXn9kCN14y2gIOoPmspMqxmMCAAEuhgP//vbsQgABSeoCAASdFwA==
Date:   Thu, 11 Jul 2019 17:14:58 +0000
Message-ID: <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
In-Reply-To: <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.1.84]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907110191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8xMC8xOSAzOjI3IFBNLCBFcmljIER1bWF6ZXQgPGVyaWMuZHVtYXpldEBnbWFpbC5jb20+
IHdyb3RlOg0KPiBPbiA3LzEwLzE5IDg6NTMgUE0sIFByb3V0LCBBbmRyZXcgLSBMTFNDIC0gTUlU
TEwgd3JvdGU6DQo+PiANCj4+IE91ciBpbml0aWFsIHJvbGxvdXQgd2FzIHY0LjE0LjEzMCwgYnV0
IEkgcmVwcm9kdWNlZCBpdCB3aXRoIHY0LjE0LjEzMiBhcyB3ZWxsLCByZWxpYWJseSBmb3IgdGhl
IHNhbWJhIHRlc3QgYW5kIG9uY2UgKG5vdCByZWxpYWJseSkgd2l0aCBzeW50aGV0aWMgdGVzdCBJ
IHdhcyB0cnlpbmcuIEEgcGF0Y2hlZCB2NC4xNC4xMzIgd2l0aCB0aGlzIHBhdGNoIHBhcnRpYWxs
eSByZXZlcnRlZCAoanVzdCB0aGUgZm91ciBsaW5lcyBmcm9tIHRjcF9mcmFnbWVudCBkZWxldGVk
KSBwYXNzZWQgdGhlIHNhbWJhIHRlc3QuDQo+PiANCj4+IFRoZSBzeW50aGV0aWMgdGVzdCB3YXMg
YSBwYWlyIG9mIHNpbXBsZSBzZW5kL3JlY3YgdGVzdCBwcm9ncmFtcyB1bmRlciB0aGUgZm9sbG93
aW5nIGNvbmRpdGlvbnM6DQo+PiAtVGhlIHNlbmQgc29ja2V0IHdhcyBub24tYmxvY2tpbmcNCj4+
IC1TT19TTkRCVUYgc2V0IHRvIDEyOEtpQg0KPj4gLVRoZSByZWNlaXZlciBOSUMgd2FzIGJlaW5n
IGZsb29kZWQgd2l0aCB0cmFmZmljIGZyb20gbXVsdGlwbGUgaG9zdHMgKHRvIGluZHVjZSBwYWNr
ZXQgbG9zcy9yZXRyYW5zbWl0cykNCj4+IC1Mb2FkIHdhcyBvbiBib3RoIHN5c3RlbXM6IGEgd2hp
bGUoMSkgcHJvZ3JhbSBzcGlubmluZyBvbiBlYWNoIENQVSBjb3JlDQo+PiAtVGhlIHJlY2VpdmVy
IHdhcyBvbiBhbiBvbGRlciB1bmFmZmVjdGVkIGtlcm5lbA0KPj4gDQo+DQo+IFNPX1NOREJVRiB0
byAxMjhLQiBkb2VzIG5vdCBwZXJtaXQgdG8gcmVjb3ZlciBmcm9tIGhlYXZ5IGxvc3NlcywNCj4g
c2luY2Ugc2ticyBuZWVkcyB0byBiZSBhbGxvY2F0ZWQgZm9yIHJldHJhbnNtaXRzLg0KPg0KPiBU
aGUgYnVnIHdlIGZpeGVkIGFsbG93ZWQgcmVtb3RlIGF0dGFja2VycyB0byBjcmFzaCBhbGwgbGlu
dXggaG9zdHMsDQo+DQo+IEkgYW0gYWZyYWlkIHdlIGhhdmUgdG8gZW5mb3JjZSB0aGUgcmVhbCBT
T19TTkRCVUYgbGltaXQsIGZpbmFsbHkuDQo+DQo+IEV2ZW4gYSBjdXNoaW9uIG9mIDEyOEtCIHBl
ciBzb2NrZXQgaXMgZGFuZ2Vyb3VzLCBmb3Igc2VydmVycyB3aXRoIG1pbGxpb25zIG9mIFRDUCBz
b2NrZXRzLg0KPg0KPiBZb3Ugd2lsbCBlaXRoZXIgaGF2ZSB0byBzZXQgU09fU05EQlVGIHRvIGhp
Z2hlciB2YWx1ZXMsIG9yIGxldCBhdXRvdHVuaW5nIGluIHBsYWNlLg0KPiBPciByZXZlcnQgdGhl
IHBhdGNoZXMgYW5kIGFsbG93IGF0dGFja2VycyBoaXQgeW91IGJhZGx5Lg0KDQpJIGluIG5vIHdh
eSBpbnRlbmRlZCB0byBpbXBseSB0aGF0IEkgaGFkIGNvbmZpcm1lZCB0aGUgc21hbGwgU09fU05E
QlVGIHdhcyBhIHByZXJlcXVpc2l0ZSB0byBvdXIgcHJvYmxlbS4gV2l0aCBteSBzeW50aGV0aWMg
dGVzdCwgSSB3YXMgbG9va2luZyBmb3IgYSBjb25jaXNlIHJlcHJvZHVjZXIgYW5kIHRyeWluZyB0
aGluZ3MgdG8gc3RyZXNzIHRoZSBzeXN0ZW0uDQoNClVuZm9ydHVuYXRlbHkgd2UncmUgb2Z0ZW4g
c3R1Y2sgYmVpbmcgZm9yY2VkIHRvIHN1cHBvcnQgdmVyeSBvbGQgY29kZSwgcmlnaHQgYWxvbmdz
aWRlIHRoZSBsYXRlc3QgYW5kIGdyZWF0ZXN0LiBXZSBzdGlsbCBydW4gYSBsb3Qgb2YgRk9SVFJB
Ti4gVGVsbGluZyB1c2VycyBlbi1tYXNzIHRvIHNlYXJjaCBhbmQgcmV2aXNlIHRoZWlyIGNvZGUg
aXMgbm90IGFuIG9wdGlvbiBmb3IgdXMuDQoNCkluIG15IG9waW5pb24sIGlmIGEgc21hbGwgU09f
U05EQlVGIGJlbG93IGEgY2VydGFpbiB2YWx1ZSBpcyBubyBsb25nZXIgc3VwcG9ydGVkLCB0aGVu
IFNPQ0tfTUlOX1NOREJVRiBzaG91bGQgYmUgYWRqdXN0ZWQgdG8gcmVmbGVjdCB0aGlzLiBUaGUg
UkNWQlVGL1NOREJVRiBzaXplcyBhcmUgc3VwcG9zZWQgdG8gYmUgaGludHMsIG5vIGVycm9yIGlz
IHJldHVybmVkIGlmIHRoZXkgYXJlIG5vdCBob25vcmVkLiBUaGUga2VybmVsIHNob3VsZCBjb250
aW51ZSB0byBmdW5jdGlvbiByZWdhcmRsZXNzIG9mIHdoYXQgdXNlcnNwYWNlIHJlcXVlc3RzIGZv
ciB0aGVpciB2YWx1ZXMuDQoNCkFsdGVybmF0aXZlbHksIGEgY29uZmlnIG9wdGlvbiBjb3VsZCBi
ZSBhZGRlZC4gSSBhbSBub3QgY29uY2VybmVkIGFib3V0IERvUyBhdHRhY2tzLCBvdXIgc3lzdGVt
IGlzIG5vdCBjb25uZWN0ZWQgdG8gdGhlIGludGVybmV0LCBhbmQgd2Ugc2hvdWxkbid0IGhhdmUg
dG8gbWFpbnRhaW4gYW4gb3V0LW9mLXRyZWUgcGF0Y2ggZm9yIGJhc2ljIGZ1bmN0aW9uYWxpdHku
DQo=
