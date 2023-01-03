Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F243E65C9AC
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbjACWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbjACW35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:29:57 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1349167F4
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 14:28:52 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id E8E7C2C04CE;
        Wed,  4 Jan 2023 11:28:46 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1672784926;
        bh=JRWZa7XT61MuOPz2uMwn6TQBmyVi2wPHD2zVocENAkk=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=jYGiQeHYjk7ih2Lpkd2kTlZka775pKzEQ7t6468J8vp7cYgMOKt3uUYZXwaArJYhi
         FK3GYO70wYNYUxZYc4xJkrBwgb4kBvceYnUmzHlp0N5VDuI4Y+rQrC0hgk1czPzNkY
         781fBRnzqbx3yqIB2Rg2kXFiynsuXXek9spBjrFK/fRYjOBB3nz8Y0RQtfJEJlajpu
         3WscxD64cEuDfPADSksXJnYd5a0KyaTKwVUmPwVfc/40l/RxsrNzTTI7Wpw4pg7ykv
         RPkKDUVVNGJMmcMETOV2PDZa2briV1pudEUziZIhzwDwVYJCB18P8Vol4cJfa0e6Au
         LRELE4hcmgQeQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63b4ac1e0001>; Wed, 04 Jan 2023 11:28:46 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 4 Jan 2023 11:28:46 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.044; Wed, 4 Jan 2023 11:28:46 +1300
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "a@unstable.cc" <a@unstable.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH 1/2] ip/ip6_gre: Fix changing addr gen mode not generating
 IPv6 link local address
Thread-Topic: [PATCH 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Thread-Index: AQHZE0Yc/HEj69L5sEuPv3e5J9ynEq516fqAgBabB4A=
Date:   Tue, 3 Jan 2023 22:28:45 +0000
Message-ID: <97d9344408b6c0909680a13f4d76ce51dbb064cb.camel@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
         <20221219010619.1826599-2-Thomas.Winter@alliedtelesis.co.nz>
         <2264ca933c234539774d9ae1d1de5a27dd1c12ae.camel@redhat.com>
In-Reply-To: <2264ca933c234539774d9ae1d1de5a27dd1c12ae.camel@redhat.com>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:642:1aff:fe08:1270]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5760ED8948ED1A43BEC793BF70CB3CC0@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RvmDmJFTN0MA:10 a=z7uzfsv5lQW8y230lpoA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTEyLTIwIGF0IDE0OjE2ICswMTAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
T24gTW9uLCAyMDIyLTEyLTE5IGF0IDE0OjA2ICsxMzAwLCBUaG9tYXMgV2ludGVyIHdyb3RlOg0K
PiA+IENvbW1pdCBlNWRkNzI5NDYwY2EgY2hhbmdlZCB0aGUgY29kZSBwYXRoIHNvIHRoYXQgR1JF
IHR1bm5lbHMNCj4gPiBnZW5lcmF0ZSBhbiBJUHY2IGFkZHJlc3MgYmFzZWQgb24gdGhlIHR1bm5l
bCBzb3VyY2UgYWRkcmVzcy4NCj4gPiBJdCBhbHNvIGNoYW5nZWQgdGhlIGNvZGUgcGF0aCBzbyBH
UkUgdHVubmVscyBkb24ndCBjYWxsDQo+ID4gYWRkcmNvbmZfYWRkcl9nZW4NCj4gPiBpbiBhZGRy
Y29uZl9kZXZfY29uZmlnIHdoaWNoIGlzIGNhbGxlZCBieQ0KPiA+IGFkZHJjb25mX3N5c2N0bF9h
ZGRyX2dlbl9tb2RlDQo+ID4gd2hlbiB0aGUgSU42X0FERFJfR0VOX01PREUgaXMgY2hhbmdlZC4N
Cj4gPiANCj4gPiBUaGlzIHBhdGNoIGFpbXMgdG8gZml4IHRoaXMgaXNzdWUgYnkgbW92aW5nIHRo
ZSBjb2RlIGluDQo+ID4gYWRkcmNvbmZfbm90aWZ5DQo+ID4gd2hpY2ggY2FsbHMgdGhlIGFkZHIg
Z2VuIGZvciBHUkUgYW5kIFNJVCBpbnRvIGEgc2VwYXJhdGUgZnVuY3Rpb24NCj4gPiBhbmQgY2Fs
bGluZyBpdCBpbiB0aGUgcGxhY2VzIHRoYXQgZXhwZWN0IHRoZSBJUHY2IGFkZHJlc3MgdG8gYmUN
Cj4gPiBnZW5lcmF0ZWQuDQo+ID4gDQo+ID4gVGhlIHByZXZpb3VzIGFkZHJjb25mX2Rldl9jb25m
aWcgaXMgcmVuYW1lZCB0byBhZGRyY29uZl9ldGhfY29uZmlnDQo+ID4gc2luY2UgaXQgb25seSBl
eHBlY3RlZCBldGggdHlwZSBpbnRlcmZhY2VzIGFuZCBmb2xsb3dzIHRoZQ0KPiA+IGFkZHJjb25m
X2dyZS9zaXRfY29uZmlnIGZvcm1hdC4NCj4gPiANCj4gPiBGaXhlczogZTVkZDcyOTQ2MGNhICgi
aXAvaXA2X2dyZTogdXNlIHRoZSBzYW1lIGxvZ2ljIGFzIFNJVA0KPiA+IGludGVyZmFjZXMgd2hl
biBjb21wdXRpbmcgdjZMTCBhZGRyZXNzIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgV2lu
dGVyIDxUaG9tYXMuV2ludGVyQGFsbGllZHRlbGVzaXMuY28ubno+DQo+ID4gLS0tDQo+ID4gIG5l
dC9pcHY2L2FkZHJjb25mLmMgfCA0NyArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0NCj4gPiAtLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyks
IDIxIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9hZGRyY29u
Zi5jIGIvbmV0L2lwdjYvYWRkcmNvbmYuYw0KPiA+IGluZGV4IDZkY2YwMzQ4MzVlYy4uZTlkN2Vj
MDMzMTZkIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9pcHY2L2FkZHJjb25mLmMNCj4gPiArKysgYi9u
ZXQvaXB2Ni9hZGRyY29uZi5jDQo+ID4gQEAgLTMzNTUsNyArMzM1NSw3IEBAIHN0YXRpYyB2b2lk
IGFkZHJjb25mX2FkZHJfZ2VuKHN0cnVjdA0KPiA+IGluZXQ2X2RldiAqaWRldiwgYm9vbCBwcmVm
aXhfcm91dGUpDQo+ID4gIAl9DQo+ID4gIH0NCj4gPiAgDQo+ID4gLXN0YXRpYyB2b2lkIGFkZHJj
b25mX2Rldl9jb25maWcoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiArc3RhdGljIHZvaWQg
YWRkcmNvbmZfZXRoX2NvbmZpZyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiANCj4gWW91IGFy
ZSBjcmVhdGluZyBhIG5ldyBmdW5jdGlvbiB3aXRoIHRoZSBuYW1lIG9mIGFuIGV4aXN0aW5nIG9u
ZSwNCj4gd2hpbGUNCj4gcmVuYW1pbmcgdGhlIGxhdHRlci4gSU1ITyB0aGlzIG1ha2VzIHRoZSBw
YXRjaCBoYXJkIHRvIHJldmlldyBhcw0KPiB0aGVyZQ0KPiBhcmUgc29tZSBleGlzdGluZyBjYWxs
IHNpZGUgZm9yIHRoZSBvbGQgbmFtZSwgd2hpY2ggd2UgbGlrZWxseSB3YW50DQo+IHRvDQo+IGV4
cGxpY2l0bHkgc2VlIGhlcmUuDQo+IA0KDQpQZXJoYXBzIHRoZXNlIGZ1bmN0aW9ucyBjYW4gYmUg
bmFtZWQgc29tZXRoaW5nIGxpa2UNCiJhZGRyY29uZmlnX2luaXRfYXV0b19hZGRycyIuDQoNCj4g
PiAgew0KPiA+ICAJc3RydWN0IGluZXQ2X2RldiAqaWRldjsNCj4gPiAgDQo+ID4gQEAgLTM0NDcs
NiArMzQ0NywzMCBAQCBzdGF0aWMgdm9pZCBhZGRyY29uZl9ncmVfY29uZmlnKHN0cnVjdA0KPiA+
IG5ldF9kZXZpY2UgKmRldikNCj4gPiAgfQ0KPiA+ICAjZW5kaWYNCj4gPiAgDQo+ID4gK3N0YXRp
YyB2b2lkIGFkZHJjb25mX2Rldl9jb25maWcoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiAr
ew0KPiA+ICsJc3dpdGNoIChkZXYtPnR5cGUpIHsNCj4gPiArI2lmIElTX0VOQUJMRUQoQ09ORklH
X0lQVjZfU0lUKQ0KPiA+ICsJY2FzZSBBUlBIUkRfU0lUOg0KPiA+ICsJCWFkZHJjb25mX3NpdF9j
b25maWcoZGV2KTsNCj4gPiArCQlicmVhazsNCj4gPiArI2VuZGlmDQo+ID4gKyNpZiBJU19FTkFC
TEVEKENPTkZJR19ORVRfSVBHUkUpIHx8IElTX0VOQUJMRUQoQ09ORklHX0lQVjZfR1JFKQ0KPiA+
ICsJY2FzZSBBUlBIUkRfSVA2R1JFOg0KPiA+ICsJY2FzZSBBUlBIUkRfSVBHUkU6DQo+ID4gKwkJ
YWRkcmNvbmZfZ3JlX2NvbmZpZyhkZXYpOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsjZW5kaWYNCj4g
PiArCWNhc2UgQVJQSFJEX0xPT1BCQUNLOg0KPiA+ICsJCWluaXRfbG9vcGJhY2soZGV2KTsNCj4g
PiArCQlicmVhazsNCj4gDQo+IElmIEkgcmVhZCBjb3JyZWN0bHksIHRoaXMgY2hhbmdlIHdpbGwg
Y2F1c2UgdW5uZWVkZWQgYXR0ZW1wdCB0byByZS0NCj4gYWRkDQo+IHRoZSBsb29wYmFjayBhZGRy
ZXNzIG9uIHRoZSBsb29wYmFjayBkZXZpY2Ugd2hlbiB0aGUgbG8uYWRkcl9nZW5fbW9kZQ0KPiBz
eXNmcyBlbnRyeSBpcyB0b3VjaGVkLiBJIHRoaW5rIHN1Y2ggc2lkZSBlZmZlY3Qgc2hvdWxkIGJl
IGF2b2lkZWQuDQoNCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB0aGVzZSBhZGRyZXNzZXMgc2hv
dWxkIGFsd2F5cyBleGlzdC4gSXQNCmRvZXNuJ3QgbG9vayBsaWtlIGFueSBwcm9ibGVtIHdpbGwg
aGFwcGVuIGlmIHRoZSBsb29wYmFjayBhZGRyZXNzDQphbHJlYWR5IGV4aXN0cyBhbmQgdGhpcyBj
YWxsZWQuDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IFBhb2xvDQo+IA0K
