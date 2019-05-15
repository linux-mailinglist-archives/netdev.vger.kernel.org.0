Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1981F60B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 15:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfEONyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 09:54:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:57300 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbfEONyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 09:54:45 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-3-OyRg268PPrOZk6NUYmL0yQ-1;
 Wed, 15 May 2019 14:54:38 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 15 May 2019 14:54:37 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 15 May 2019 14:54:37 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Robin Murphy' <robin.murphy@arm.com>,
        'Will Deacon' <will.deacon@arm.com>
CC:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "huanglingyan (A)" <huanglingyan2@huawei.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>
Subject: RE: [PATCH] arm64: do_csum: implement accelerated scalar version
Thread-Topic: [PATCH] arm64: do_csum: implement accelerated scalar version
Thread-Index: AQHVCwMrtYHa1Y0LVUWOb1uB691U/KZr90eg///8CQCAABRdMIAACBiAgAAenMA=
Date:   Wed, 15 May 2019 13:54:37 +0000
Message-ID: <b69d404a5de74e3db115c335e56a21af@AcuMS.aculab.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
 <6e755b2daaf341128cb3b54f36172442@AcuMS.aculab.com>
 <3d4fdbb5-7c7f-9331-187e-14c09dd1c18d@arm.com>
 <9f72aecd99e74c1a939df6562ed9c18c@AcuMS.aculab.com>
 <083f8222-971c-0d8e-4650-0d88b193e316@arm.com>
In-Reply-To: <083f8222-971c-0d8e-4650-0d88b193e316@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: OyRg268PPrOZk6NUYmL0yQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUm9iaW4gTXVycGh5DQo+IFNlbnQ6IDE1IE1heSAyMDE5IDEzOjQwDQo+IE9uIDE1LzA1
LzIwMTkgMTI6MTMsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBGcm9tOiBSb2JpbiBNdXJwaHkN
Cj4gPj4gU2VudDogMTUgTWF5IDIwMTkgMTE6NTgNCj4gPj4gVG86IERhdmlkIExhaWdodDsgJ1dp
bGwgRGVhY29uJw0KPiA+PiBDYzogWmhhbmdzaGFva3VuOyBBcmQgQmllc2hldXZlbDsgbGludXgt
YXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiA+PiBpbGlhcy5hcGFsb2RpbWFzQGxpbmFyby5vcmc7IGh1YW5nbGluZ3lhbiAoQSk7IHN0ZXZl
LmNhcHBlckBhcm0uY29tDQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGFybTY0OiBkb19jc3Vt
OiBpbXBsZW1lbnQgYWNjZWxlcmF0ZWQgc2NhbGFyIHZlcnNpb24NCj4gPj4NCj4gPj4gT24gMTUv
MDUvMjAxOSAxMToxNSwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+Pj4gLi4uDQo+ID4+Pj4+IAlw
dHIgPSAodTY0ICopKGJ1ZmYgLSBvZmZzZXQpOw0KPiA+Pj4+PiAJc2hpZnQgPSBvZmZzZXQgKiA4
Ow0KPiA+Pj4+Pg0KPiA+Pj4+PiAJLyoNCj4gPj4+Pj4gCSAqIEhlYWQ6IHplcm8gb3V0IGFueSBl
eGNlc3MgbGVhZGluZyBieXRlcy4gU2hpZnRpbmcgYmFjayBieSB0aGUgc2FtZQ0KPiA+Pj4+PiAJ
ICogYW1vdW50IHNob3VsZCBiZSBhdCBsZWFzdCBhcyBmYXN0IGFzIGFueSBvdGhlciB3YXkgb2Yg
aGFuZGxpbmcgdGhlDQo+ID4+Pj4+IAkgKiBvZGQvZXZlbiBhbGlnbm1lbnQsIGFuZCBtZWFucyB3
ZSBjYW4gaWdub3JlIGl0IHVudGlsIHRoZSB2ZXJ5IGVuZC4NCj4gPj4+Pj4gCSAqLw0KPiA+Pj4+
PiAJZGF0YSA9ICpwdHIrKzsNCj4gPj4+Pj4gI2lmZGVmIF9fTElUVExFX0VORElBTg0KPiA+Pj4+
PiAJZGF0YSA9IChkYXRhID4+IHNoaWZ0KSA8PCBzaGlmdDsNCj4gPj4+Pj4gI2Vsc2UNCj4gPj4+
Pj4gCWRhdGEgPSAoZGF0YSA8PCBzaGlmdCkgPj4gc2hpZnQ7DQo+ID4+Pj4+ICNlbmRpZg0KPiA+
Pj4NCj4gPj4+IEkgc3VzcGVjdCB0aGF0DQo+ID4+PiAjaWZkZWYgX19MSVRUTEVfRU5ESUFODQo+
ID4+PiAJZGF0YSAmPSB+MHVsbCA8PCBzaGlmdDsNCj4gPj4+ICNlbHNlDQo+ID4+PiAJZGF0YSAm
PSB+MHVsbCA+PiBzaGlmdDsNCj4gPj4+ICNlbmRpZg0KPiA+Pj4gaXMgbGlrZWx5IHRvIGJlIGJl
dHRlci4NCj4gPj4NCj4gPj4gT3V0IG9mIGludGVyZXN0LCBiZXR0ZXIgaW4gd2hpY2ggcmVzcGVj
dHM/IEZvciB0aGUgQTY0IElTQSBhdCBsZWFzdCwNCj4gPj4gdGhhdCB3b3VsZCB0YWtlIDMgaW5z
dHJ1Y3Rpb25zIHBsdXMgYW4gYWRkaXRpb25hbCBzY3JhdGNoIHJlZ2lzdGVyLCBlLmcuOg0KPiA+
Pg0KPiA+PiAJTU9WCXgyLCAjfjANCj4gPj4gCUxTTAl4MiwgeDIsIHgxDQo+ID4+IAlBTkQJeDAs
IHgwLCB4MQ0KPiANCj4gW1RoYXQgc2hvdWxkIGhhdmUgYmVlbiAiQU5EIHgwLCB4MSwgeDIiLCBv
YnZpb3VzbHkuLi5dDQo+IA0KPiA+Pg0KPiA+PiAoYWx0ZXJuYXRpdmVseSAiQU5EIHgwLCB4MCwg
eDEgTFNMIHgyIiB0byBzYXZlIDQgYnl0ZXMgb2YgY29kZSwgYnV0IHRoYXQNCj4gPj4gd2lsbCB0
eXBpY2FsbHkgdGFrZSBhcyBtYW55IGN5Y2xlcyBpZiBub3QgbW9yZSB0aGFuIGp1c3QgcGlwZWxp
bmluZyB0aGUNCj4gPj4gdHdvICdzaW1wbGUnIEFMVSBpbnN0cnVjdGlvbnMpDQo+ID4+DQo+ID4+
IFdoZXJlYXMgdGhlIG9yaWdpbmFsIGlzIGp1c3QgdHdvIHNoaWZ0IGluc3RydWN0aW9uIGluLXBs
YWNlLg0KPiA+Pg0KPiA+PiAJTFNSCXgwLCB4MCwgeDENCj4gPj4gCUxTTAl4MCwgeDAsIHgxDQo+
ID4+DQo+ID4+IElmIHRoZSBvcGVyYXRpb24gd2VyZSByZXBlYXRlZCwgdGhlIGNvbnN0YW50IGdl
bmVyYXRpb24gY291bGQgY2VydGFpbmx5DQo+ID4+IGJlIGFtb3J0aXNlZCBvdmVyIG11bHRpcGxl
IHN1YnNlcXVlbnQgQU5EcyBmb3IgYSBuZXQgd2luLCBidXQgdGhhdCBpc24ndA0KPiA+PiB0aGUg
Y2FzZSBoZXJlLg0KPiA+DQo+ID4gT24gYSBzdXBlcnNjYWxlciBwcm9jZXNzb3IgeW91IHJlZHVj
ZSB0aGUgcmVnaXN0ZXIgZGVwZW5kZW5jeQ0KPiA+IGNoYWluIGJ5IG9uZSBpbnN0cnVjdGlvbi4N
Cj4gPiBUaGUgb3JpZ2luYWwgY29kZSBpcyBwcmV0dHkgbXVjaCBhIHNpbmdsZSBkZXBlbmRlbmN5
IGNoYWluIHNvDQo+ID4geW91IGFyZSBsaWtlbHkgdG8gYmUgYWJsZSB0byBnZW5lcmF0ZSB0aGUg
bWFzayAnZm9yIGZyZWUnLg0KPiANCj4gR290Y2hhLCBhbHRob3VnaCAnZnJlZScgc3RpbGwgbWVh
bnMgYWRkaXRpb25hbCBJJCBhbmQgcmVnaXN0ZXIgcmVuYW1lDQo+IGZvb3RwcmludCwgdnMuICh0
eXBpY2FsbHkpIGp1c3QgMSBleHRyYSBjeWNsZSB0byBmb3J3YXJkIGFuIEFMVSByZXN1bHQuDQo+
IEl0J3MgYW4gaW50ZXJlc3RpbmcgY29uc2lkZXJhdGlvbiwgYnV0IGluIG91ciBjYXNlIHRoZXJl
IGFyZSBhbG1vc3QNCj4gY2VydGFpbmx5IGZhciBtb3JlIGxpdHRsZSBpbi1vcmRlciBjb3JlcyBv
dXQgaW4gdGhlIHdpbGQgdGhhbiBiaWcgT29PDQo+IG9uZXMsIGFuZCB0aGUgZG91YmxlLXNoaWZ0
IHdpbGwgYWx3YXlzIGJlIG9iamVjdGl2ZWx5IGJldHRlciBmb3IgdGhvc2UuDQoNCklzIHRoZXJl
IGEgcGlwZWxpbmUgZGVsYXkgYmVmb3JlIHRoZSByZXN1bHQgb2YgdGhlIG1lbW9yeSByZWFkICgq
cHRyKQ0KY2FuIGJlIHVzZWQ/IChFdmVuIGFzc3VtaW5nIHRoZSBkYXRhIGlzIGluIHRoZSBMMSBj
YWNoZT8/KQ0KRXZlbiBvbiBhbiBpbi1vcmRlciBjcHUgdGhhdCBjYW4gZ2l2ZSB5b3UgYSBzcGFy
ZSBjeWNsZSBvciB0d28NCnRoYXQgdGhlIGNvZGUgbWF5IG5vdCBub3JtYWxseSBmaWxsLg0KDQpG
V0lXIEkndmUgYmVlbiBrbm93biB0byB1c2UgKCsrcHRyKVstMV0gKGluc3RlYWQgb2YgKnB0cisr
KSB0byBtb3ZlDQp0aGUgaW5jcmVtZW50IGludG8gYW4gYXZhaWxhYmxlIGRlbGF5IHNsb3QgKG9m
IGFuIGVhcmxpZXIgbG9hZCkuDQoNCkFueXdheSBpdCBpc24ndCB0aGF0IG9idmlvdXMgdGhhdCBp
dCBpcyB0aGUgZmFzdGVzdCB3YXkuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

