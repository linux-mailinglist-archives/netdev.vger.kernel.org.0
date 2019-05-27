Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF362BB09
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 22:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfE0UFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 16:05:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:12646 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfE0UFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 16:05:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 13:05:14 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2019 13:05:14 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 27 May 2019 13:05:13 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.57]) with mapi id 14.03.0415.000;
 Mon, 27 May 2019 13:05:13 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] vmalloc: Fix calculation of direct map addr range
Thread-Topic: [PATCH v4 1/2] vmalloc: Fix calculation of direct map addr
 range
Thread-Index: AQHVEBc70xeDpvMdbkm+DpMWjEkdYqZ/YkYAgACB4AA=
Date:   Mon, 27 May 2019 20:05:13 +0000
Message-ID: <dbf5f298d51183589c92cbd94da3b1e078457f4d.camel@intel.com>
References: <20190521205137.22029-1-rick.p.edgecombe@intel.com>
         <20190521205137.22029-2-rick.p.edgecombe@intel.com>
         <20190527122022.GP2606@hirez.programming.kicks-ass.net>
In-Reply-To: <20190527122022.GP2606@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.251.0.167]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F500BEE106FE694D98FD28E43C08884B@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTI3IGF0IDE0OjIwICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBNYXkgMjEsIDIwMTkgYXQgMDE6NTE6MzZQTSAtMDcwMCwgUmljayBFZGdlY29t
YmUgd3JvdGU6DQo+ID4gVGhlIGNhbGN1bGF0aW9uIG9mIHRoZSBkaXJlY3QgbWFwIGFkZHJlc3Mg
cmFuZ2UgdG8gZmx1c2ggd2FzIHdyb25nLg0KPiA+IFRoaXMgY291bGQgY2F1c2UgcHJvYmxlbXMg
b24geDg2IGlmIGEgUk8gZGlyZWN0IG1hcCBhbGlhcyBldmVyIGdvdA0KPiA+IGxvYWRlZA0KPiA+
IGludG8gdGhlIFRMQi4gVGhpcyBzaG91bGRuJ3Qgbm9ybWFsbHkgaGFwcGVuLCBidXQgaXQgY291
bGQgY2F1c2UNCj4gPiB0aGUNCj4gPiBwZXJtaXNzaW9ucyB0byByZW1haW4gUk8gb24gdGhlIGRp
cmVjdCBtYXAgYWxpYXMsIGFuZCB0aGVuIHRoZSBwYWdlDQo+ID4gd291bGQgcmV0dXJuIGZyb20g
dGhlIHBhZ2UgYWxsb2NhdG9yIHRvIHNvbWUgb3RoZXIgY29tcG9uZW50IGFzIFJPDQo+ID4gYW5k
DQo+ID4gY2F1c2UgYSBjcmFzaC4NCj4gPiANCj4gPiBTbyBmaXggZml4IHRoZSBhZGRyZXNzIHJh
bmdlIGNhbGN1bGF0aW9uIHNvIHRoZSBmbHVzaCB3aWxsIGluY2x1ZGUNCj4gPiB0aGUNCj4gPiBk
aXJlY3QgbWFwIHJhbmdlLg0KPiA+IA0KPiA+IEZpeGVzOiA4NjhiMTA0ZDczNzkgKCJtbS92bWFs
bG9jOiBBZGQgZmxhZyBmb3IgZnJlZWluZyBvZiBzcGVjaWFsDQo+ID4gcGVybXNpc3Npb25zIikN
Cj4gPiBDYzogTWVlbGlzIFJvb3MgPG1yb29zQGxpbnV4LmVlPg0KPiA+IENjOiBQZXRlciBaaWps
c3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+ID4gQ2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxk
YXZlbUBkYXZlbWxvZnQubmV0Pg0KPiA+IENjOiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50
ZWwuY29tPg0KPiA+IENjOiBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT4NCj4gPiBDYzog
QW5keSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5vcmc+DQo+ID4gQ2M6IEluZ28gTW9sbmFyIDxt
aW5nb0ByZWRoYXQuY29tPg0KPiA+IENjOiBOYWRhdiBBbWl0IDxuYW1pdEB2bXdhcmUuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiAgbW0vdm1hbGxvYy5jIHwgNSArKystLQ0KPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9tbS92bWFsbG9jLmMgYi9tbS92bWFsbG9jLmMNCj4gPiBpbmRleCBjNDI4NzJlZDgy
YWMuLjgzNjg4OGFlMDFmNiAxMDA2NDQNCj4gPiAtLS0gYS9tbS92bWFsbG9jLmMNCj4gPiArKysg
Yi9tbS92bWFsbG9jLmMNCj4gPiBAQCAtMjE1OSw5ICsyMTU5LDEwIEBAIHN0YXRpYyB2b2lkIHZt
X3JlbW92ZV9tYXBwaW5ncyhzdHJ1Y3QNCj4gPiB2bV9zdHJ1Y3QgKmFyZWEsIGludCBkZWFsbG9j
YXRlX3BhZ2VzKQ0KPiA+ICAJICogdGhlIHZtX3VubWFwX2FsaWFzZXMoKSBmbHVzaCBpbmNsdWRl
cyB0aGUgZGlyZWN0IG1hcC4NCj4gPiAgCSAqLw0KPiA+ICAJZm9yIChpID0gMDsgaSA8IGFyZWEt
Pm5yX3BhZ2VzOyBpKyspIHsNCj4gPiAtCQlpZiAocGFnZV9hZGRyZXNzKGFyZWEtPnBhZ2VzW2ld
KSkgew0KPiA+ICsJCWFkZHIgPSAodW5zaWduZWQgbG9uZylwYWdlX2FkZHJlc3MoYXJlYS0+cGFn
ZXNbaV0pOw0KPiA+ICsJCWlmIChhZGRyKSB7DQo+ID4gIAkJCXN0YXJ0ID0gbWluKGFkZHIsIHN0
YXJ0KTsNCj4gPiAtCQkJZW5kID0gbWF4KGFkZHIsIGVuZCk7DQo+ID4gKwkJCWVuZCA9IG1heChh
ZGRyICsgUEFHRV9TSVpFLCBlbmQpOw0KPiA+ICAJCX0NCj4gPiAgCX0NCj4gPiAgDQo+IA0KPiBJ
bmRlZWQ7IGhvd2V2ciBJJ20gdGhpbmtpbmcgdGhpcyBidWcgd2FzIGNhdXNlZCB0byBleGlzdCBi
eSB0aGUgZHVhbA0KPiB1c2UNCj4gb2YgQGFkZHIgaW4gdGhpcyBmdW5jdGlvbiwgc28gc2hvdWxk
IHdlIG5vdCwgcGVyaGFwcywgZG8gc29tZXRoaW5nDQo+IGxpa2UNCj4gdGhlIGJlbG93IGluc3Rl
YWQ/DQo+IA0KPiBBbHNvOyBoYXZpbmcgbG9va2VkIGF0IHRoaXMsIGl0IG1ha2VzIG1lIHF1ZXN0
aW9uIHRoZSB1c2Ugb2YNCj4gZmx1c2hfdGxiX2tlcm5lbF9yYW5nZSgpIGluIF92bV91bm1hcF9h
bGlhc2VzKCkgYW5kDQo+IF9fcHVyZ2Vfdm1hcF9hcmVhX2xhenkoKSwgaXQncyBwb3RlbnRpYWxs
eSBjb21iaW5pbmcgbXVsdGlwbGUgcmFuZ2VzLA0KPiB3aGljaCBuZXZlciByZWFsbHkgd29ya3Mg
d2VsbC4NCj4gDQo+IEFyZ3VhYmx5LCB3ZSBzaG91bGQganVzdCBkbyBmbHVzaF90bGJfYWxsKCkg
aGVyZSwgYnV0IHRoYXQncyBmb3INCj4gYW5vdGhlcg0KPiBwYXRjaCBJJ20gdGhpbmtpbmcuDQoN
ClRoYW5rcy4gSXQgbW9zdGx5IGdvdCBicm9rZW4gaW1wbGVtZW50aW5nIGEgc3R5bGUgc3VnZ2Vz
dGlvbiBsYXRlIGluDQp0aGUgc2VyaWVzLiBJJ2xsIGNoYW5nZSB0aGUgYWRkciB2YXJpYWJsZSBh
cm91bmQgbGlrZSB5b3Ugc3VnZ2VzdCB0bw0KbWFrZSBpdCBtb3JlIHJlc2lzdGFudC4NCg0KVGhl
IGZsdXNoX3RsYl9hbGwoKSBzdWdnZXN0aW9uIG1ha2VzIHNlbnNlIHRvIG1lLCBidXQgSSdsbCBs
ZWF2ZSBpdCBmb3INCm5vdy4NCg0KPiAtLS0NCj4gLS0tIGEvbW0vdm1hbGxvYy5jDQo+ICsrKyBi
L21tL3ZtYWxsb2MuYw0KPiBAQCAtMjEyMyw3ICsyMTIzLDYgQEAgc3RhdGljIGlubGluZSB2b2lk
IHNldF9hcmVhX2RpcmVjdF9tYXAoYw0KPiAgLyogSGFuZGxlIHJlbW92aW5nIGFuZCByZXNldHRp
bmcgdm0gbWFwcGluZ3MgcmVsYXRlZCB0byB0aGUNCj4gdm1fc3RydWN0LiAqLw0KPiAgc3RhdGlj
IHZvaWQgdm1fcmVtb3ZlX21hcHBpbmdzKHN0cnVjdCB2bV9zdHJ1Y3QgKmFyZWEsIGludA0KPiBk
ZWFsbG9jYXRlX3BhZ2VzKQ0KPiAgew0KPiAtCXVuc2lnbmVkIGxvbmcgYWRkciA9ICh1bnNpZ25l
ZCBsb25nKWFyZWEtPmFkZHI7DQo+ICAJdW5zaWduZWQgbG9uZyBzdGFydCA9IFVMT05HX01BWCwg
ZW5kID0gMDsNCj4gIAlpbnQgZmx1c2hfcmVzZXQgPSBhcmVhLT5mbGFncyAmIFZNX0ZMVVNIX1JF
U0VUX1BFUk1TOw0KPiAgCWludCBpOw0KPiBAQCAtMjEzNSw4ICsyMTM0LDggQEAgc3RhdGljIHZv
aWQgdm1fcmVtb3ZlX21hcHBpbmdzKHN0cnVjdCB2bQ0KPiAgCSAqIGV4ZWN1dGUgcGVybWlzc2lv
bnMsIHdpdGhvdXQgbGVhdmluZyBhIFJXK1ggd2luZG93Lg0KPiAgCSAqLw0KPiAgCWlmIChmbHVz
aF9yZXNldCAmJiAhSVNfRU5BQkxFRChDT05GSUdfQVJDSF9IQVNfU0VUX0RJUkVDVF9NQVApKQ0K
PiB7DQo+IC0JCXNldF9tZW1vcnlfbngoYWRkciwgYXJlYS0+bnJfcGFnZXMpOw0KPiAtCQlzZXRf
bWVtb3J5X3J3KGFkZHIsIGFyZWEtPm5yX3BhZ2VzKTsNCj4gKwkJc2V0X21lbW9yeV9ueCgodW5z
aWduZWQgbG9uZylhcmVhLT5hZGRyLCBhcmVhLQ0KPiA+bnJfcGFnZXMpOw0KPiArCQlzZXRfbWVt
b3J5X3J3KCh1bnNpZ25lZCBsb25nKWFyZWEtPmFkZHIsIGFyZWEtDQo+ID5ucl9wYWdlcyk7DQo+
ICAJfQ0KPiAgDQo+ICAJcmVtb3ZlX3ZtX2FyZWEoYXJlYS0+YWRkcik7DQo+IEBAIC0yMTYwLDkg
KzIxNTksMTAgQEAgc3RhdGljIHZvaWQgdm1fcmVtb3ZlX21hcHBpbmdzKHN0cnVjdCB2bQ0KPiAg
CSAqIHRoZSB2bV91bm1hcF9hbGlhc2VzKCkgZmx1c2ggaW5jbHVkZXMgdGhlIGRpcmVjdCBtYXAu
DQo+ICAJICovDQo+ICAJZm9yIChpID0gMDsgaSA8IGFyZWEtPm5yX3BhZ2VzOyBpKyspIHsNCj4g
LQkJaWYgKHBhZ2VfYWRkcmVzcyhhcmVhLT5wYWdlc1tpXSkpIHsNCj4gKwkJdW5zaWduZWQgbG9u
ZyBhZGRyID0gKHVuc2lnbmVkIGxvbmcpcGFnZV9hZGRyZXNzKGFyZWEtDQo+ID5wYWdlc1tpXSk7
DQo+ICsJCWlmIChhZGRyKSB7DQo+ICAJCQlzdGFydCA9IG1pbihhZGRyLCBzdGFydCk7DQo+IC0J
CQllbmQgPSBtYXgoYWRkciwgZW5kKTsNCj4gKwkJCWVuZCA9IG1heChhZGRyICsgUEFHRV9TSVpF
LCBlbmQpOw0KPiAgCQl9DQo+ICAJfQ0KPiAgDQo=
