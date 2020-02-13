Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1722915BB56
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgBMJQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:16:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:7677 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbgBMJQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:16:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 01:16:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,436,1574150400"; 
   d="scan'208,223";a="252223674"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga002.jf.intel.com with ESMTP; 13 Feb 2020 01:16:12 -0800
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 13 Feb 2020 01:16:12 -0800
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.100]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.240]) with mapi id 14.03.0439.000;
 Thu, 13 Feb 2020 01:16:12 -0800
From:   "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Thread-Topic: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Thread-Index: AQHV4k47o+FvdyeZdUa5OLpq2zu4Pg==
Date:   Thu, 13 Feb 2020 09:16:11 +0000
Message-ID: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.24.191]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6705580ED78DAE4EA3246B2B113F2667@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSAyZjEyNzZkMDJmNWExMmQ4NWFlYzVhZGMxMWRmZTFlYWI3ZTE2MGQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogU2ViYXN0aWVuIEJvZXVmIDxzZWJhc3RpZW4uYm9ldWZAaW50
ZWwuY29tPg0KRGF0ZTogVGh1LCAxMyBGZWIgMjAyMCAwODo1MDozOCArMDEwMA0KU3ViamVjdDog
W1BBVENIXSBuZXQ6IHZpcnRpb192c29jazogRml4IHJhY2UgY29uZGl0aW9uIGJldHdlZW4gYmlu
ZCBhbmQgbGlzdGVuDQoNCldoZW5ldmVyIHRoZSB2c29jayBiYWNrZW5kIG9uIHRoZSBob3N0IHNl
bmRzIGEgcGFja2V0IHRocm91Z2ggdGhlIFJYDQpxdWV1ZSwgaXQgZXhwZWN0cyBhbiBhbnN3ZXIg
b24gdGhlIFRYIHF1ZXVlLiBVbmZvcnR1bmF0ZWx5LCB0aGVyZSBpcyBvbmUNCmNhc2Ugd2hlcmUg
dGhlIGhvc3Qgc2lkZSB3aWxsIGhhbmcgd2FpdGluZyBmb3IgdGhlIGFuc3dlciBhbmQgd2lsbA0K
ZWZmZWN0aXZlbHkgbmV2ZXIgcmVjb3Zlci4NCg0KVGhpcyBpc3N1ZSBoYXBwZW5zIHdoZW4gdGhl
IGd1ZXN0IHNpZGUgc3RhcnRzIGJpbmRpbmcgdG8gdGhlIHNvY2tldCwNCndoaWNoIGluc2VydCBh
IG5ldyBib3VuZCBzb2NrZXQgaW50byB0aGUgbGlzdCBvZiBhbHJlYWR5IGJvdW5kIHNvY2tldHMu
DQpBdCB0aGlzIHRpbWUsIHdlIGV4cGVjdCB0aGUgZ3Vlc3QgdG8gYWxzbyBzdGFydCBsaXN0ZW5p
bmcsIHdoaWNoIHdpbGwNCnRyaWdnZXIgdGhlIHNrX3N0YXRlIHRvIG1vdmUgZnJvbSBUQ1BfQ0xP
U0UgdG8gVENQX0xJU1RFTi4gVGhlIHByb2JsZW0NCm9jY3VycyBpZiB0aGUgaG9zdCBzaWRlIHF1
ZXVlZCBhIFJYIHBhY2tldCBhbmQgdHJpZ2dlcmVkIGFuIGludGVycnVwdA0KcmlnaHQgYmV0d2Vl
biB0aGUgZW5kIG9mIHRoZSBiaW5kaW5nIHByb2Nlc3MgYW5kIHRoZSBiZWdpbm5pbmcgb2YgdGhl
DQpsaXN0ZW5pbmcgcHJvY2Vzcy4gSW4gdGhpcyBzcGVjaWZpYyBjYXNlLCB0aGUgZnVuY3Rpb24g
cHJvY2Vzc2luZyB0aGUNCnBhY2tldCB2aXJ0aW9fdHJhbnNwb3J0X3JlY3ZfcGt0KCkgd2lsbCBm
aW5kIGEgYm91bmQgc29ja2V0LCB3aGljaCBtZWFucw0KaXQgd2lsbCBoaXQgdGhlIHN3aXRjaCBz
dGF0ZW1lbnQgY2hlY2tpbmcgZm9yIHRoZSBza19zdGF0ZSwgYnV0IHRoZQ0Kc3RhdGUgd29uJ3Qg
YmUgY2hhbmdlZCBpbnRvIFRDUF9MSVNURU4geWV0LCB3aGljaCBsZWFkcyB0aGUgY29kZSB0byBw
aWNrDQp0aGUgZGVmYXVsdCBzdGF0ZW1lbnQuIFRoaXMgZGVmYXVsdCBzdGF0ZW1lbnQgd2lsbCBv
bmx5IGZyZWUgdGhlIGJ1ZmZlciwNCndoaWxlIGl0IHNob3VsZCBhbHNvIHJlc3BvbmQgdG8gdGhl
IGhvc3Qgc2lkZSwgYnkgc2VuZGluZyBhIHBhY2tldCBvbg0KaXRzIFRYIHF1ZXVlLg0KDQpJbiBv
cmRlciB0byBzaW1wbHkgZml4IHRoaXMgdW5mb3J0dW5hdGUgY2hhaW4gb2YgZXZlbnRzLCBpdCBp
cyBpbXBvcnRhbnQNCnRoYXQgaW4gY2FzZSB0aGUgZGVmYXVsdCBzdGF0ZW1lbnQgaXMgZW50ZXJl
ZCwgYW5kIGJlY2F1c2UgYXQgdGhpcyBzdGFnZQ0Kd2Uga25vdyB0aGUgaG9zdCBzaWRlIGlzIHdh
aXRpbmcgZm9yIGFuIGFuc3dlciwgd2UgbXVzdCBzZW5kIGJhY2sgYQ0KcGFja2V0IGNvbnRhaW5p
bmcgdGhlIG9wZXJhdGlvbiBWSVJUSU9fVlNPQ0tfT1BfUlNULg0KDQpTaWduZWQtb2ZmLWJ5OiBT
ZWJhc3RpZW4gQm9ldWYgPHNlYmFzdGllbi5ib2V1ZkBpbnRlbC5jb20+DQotLS0NCiBuZXQvdm13
X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMgfCAxICsNCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKykNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5z
cG9ydF9jb21tb24uYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0K
aW5kZXggZTVlYTI5YzZiY2E3Li45MDkzMzRkNTgzMjggMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zz
b2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCisrKyBiL25ldC92bXdfdnNvY2svdmlydGlv
X3RyYW5zcG9ydF9jb21tb24uYw0KQEAgLTExNDMsNiArMTE0Myw3IEBAIHZvaWQgdmlydGlvX3Ry
YW5zcG9ydF9yZWN2X3BrdChzdHJ1Y3QgdmlydGlvX3RyYW5zcG9ydCAqdCwNCiAJCXZpcnRpb190
cmFuc3BvcnRfZnJlZV9wa3QocGt0KTsNCiAJCWJyZWFrOw0KIAlkZWZhdWx0Og0KKwkJKHZvaWQp
dmlydGlvX3RyYW5zcG9ydF9yZXNldF9ub19zb2NrKHQsIHBrdCk7DQogCQl2aXJ0aW9fdHJhbnNw
b3J0X2ZyZWVfcGt0KHBrdCk7DQogCQlicmVhazsNCiAJfQ0KLS0gDQoyLjIwLjENCg0KLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCkludGVsIENvcnBvcmF0aW9uIFNBUyAoRnJlbmNoIHNpbXBsaWZpZWQgam9pbnQgc3Rv
Y2sgY29tcGFueSkKUmVnaXN0ZXJlZCBoZWFkcXVhcnRlcnM6ICJMZXMgTW9udGFsZXRzIi0gMiwg
cnVlIGRlIFBhcmlzLCAKOTIxOTYgTWV1ZG9uIENlZGV4LCBGcmFuY2UKUmVnaXN0cmF0aW9uIE51
bWJlcjogIDMwMiA0NTYgMTk5IFIuQy5TLiBOQU5URVJSRQpDYXBpdGFsOiA0LDU3MiwwMDAgRXVy
b3MKClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4gY29uZmlkZW50
aWFsIG1hdGVyaWFsIGZvcgp0aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChz
KS4gQW55IHJldmlldyBvciBkaXN0cmlidXRpb24KYnkgb3RoZXJzIGlzIHN0cmljdGx5IHByb2hp
Yml0ZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZApyZWNpcGllbnQsIHBsZWFzZSBjb250
YWN0IHRoZSBzZW5kZXIgYW5kIGRlbGV0ZSBhbGwgY29waWVzLgo=

