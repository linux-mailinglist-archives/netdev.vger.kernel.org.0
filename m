Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199E66822DE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjAaDdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjAaDdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:33:05 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729FDB778
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:33:01 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8CE7D2C0424;
        Tue, 31 Jan 2023 16:32:56 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1675135976;
        bh=pAofpme7zrgGYuxzotW8YdvJY4zRXAp/0MRHk+ANOYQ=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=AEk6KWBUOO+ZKz4U5vCkgezHxW0pPY9qkBv5wxQcBBZbhng1uRK4nffCIW+oXHKAB
         7yshoCEtciHxbwLJHD/xcNJXxYlA4GvfSsC6oiTDv+tdMtLaweriShlMSC5aLOk/Z/
         eD4brEOA16oB9S9dyFI0ZiPEHq+4jGBQL9jjyHubUjHjtuJQgXMYQ9bYAGioz1fe56
         PVdO7sg0elTVC6Q2ADqWTHDh8PKXARkdopJQdYBpI6QAsR68+bghFIc3WUwofeAz+Q
         0vatkgpxyT0l9nGZF0F8gydDkTj1JuyiQVgisjV0FM+fB02QNYTRerZFquNl085JFr
         IDKXc/ibLuBWg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63d88be80001>; Tue, 31 Jan 2023 16:32:56 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.45; Tue, 31 Jan 2023 16:32:56 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.045; Tue, 31 Jan 2023 16:32:56 +1300
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "a@unstable.cc" <a@unstable.cc>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v4 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Thread-Topic: [PATCH v4 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Thread-Index: AQHZMftpU3nXhE6KVEm07vwYj8Sov6603S8AgAIuVYA=
Date:   Tue, 31 Jan 2023 03:32:55 +0000
Message-ID: <8ecf823a13c7375aa6d86c9fe244a6481410f982.camel@alliedtelesis.co.nz>
References: <20230127025941.2813766-1-Thomas.Winter@alliedtelesis.co.nz>
         <20230127025941.2813766-2-Thomas.Winter@alliedtelesis.co.nz>
         <a4f4392f-cc15-86e0-9b63-12678b65d58f@kernel.org>
In-Reply-To: <a4f4392f-cc15-86e0-9b63-12678b65d58f@kernel.org>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:642:1aff:fe08:1270]
Content-Type: text/plain; charset="utf-8"
Content-ID: <82192CA47AD10741BF6BEF088BAF6D2C@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=a6lOCnaF c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RvmDmJFTN0MA:10 a=XFRO4y6jSu2azTGKomUA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIzLTAxLTI5IGF0IDExOjE0IC0wNzAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
QSBjb3VwbGUgb2Ygbml0cy4NCj4gDQo+IE9uIDEvMjYvMjMgNzo1OSBQTSwgVGhvbWFzIFdpbnRl
ciB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvYWRkcmNvbmYuYyBiL25ldC9pcHY2
L2FkZHJjb25mLmMNCj4gPiBpbmRleCBmN2E4NGE0YWNmZmMuLjAwNjViMzhmYzg1YiAxMDA2NDQN
Cj4gPiAtLS0gYS9uZXQvaXB2Ni9hZGRyY29uZi5jDQo+ID4gKysrIGIvbmV0L2lwdjYvYWRkcmNv
bmYuYw0KPiA+IEBAIC0zMzU1LDcgKzMzNTUsNyBAQCBzdGF0aWMgdm9pZCBhZGRyY29uZl9hZGRy
X2dlbihzdHJ1Y3QNCj4gPiBpbmV0Nl9kZXYgKmlkZXYsIGJvb2wgcHJlZml4X3JvdXRlKQ0KPiA+
ICAJfQ0KPiA+ICB9DQo+ID4gIA0KPiA+IC1zdGF0aWMgdm9pZCBhZGRyY29uZl9kZXZfY29uZmln
KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ID4gK3N0YXRpYyB2b2lkIGFkZHJjb25mX2V0aF9j
b25maWcoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gDQo+IHdoeSB0aGUgcmVuYW1lIG9mIHRo
aXMgZnVuY3Rpb24/IEl0IGRvZXMgbW9yZSB0aGFuIGV0aGVybmV0IGNvbmZpZy4NCg0KQSByZW1u
YW50IG9mIGEgcHJldmlvdXMgdmVyc2lvbiB3aGVyZSBJIG5hbWVkIHRoZSBuZXcgZnVuY3Rpb24N
CmFkZHJjb25mX2Rldl9jb25maWcgd2hpY2ggdGhlbiBjYWxscyBhZGRyY29uZl9ldGhfY29uZmln
LA0KYWRkcmNvbmZfZ3JlX2NvbmZpZywgZXRjLg0KDQpUaGVyZSBpcyBhbHNvIHRoZSBmb2xsb3dp
bmcgY29tbWVudCBpbiB0aGUgZnVuY3Rpb24gIkFsYXMsIHdlIHN1cHBvcnQNCm9ubHkgRXRoZXJu
ZXQgYXV0b2NvbmZpZ3VyYXRpb24uIi4NCg0KSSBjb3VsZCByZW5hbWUgaXQgYmFjayBpbiB0aGUg
bmV4dCBwYXRjaHNldCB2ZXJzaW9uLg0KDQo+IA0KPiANCj4gPiAgew0KPiA+ICAJc3RydWN0IGlu
ZXQ2X2RldiAqaWRldjsNCj4gPiAgDQo+ID4gQEAgLTM0NDcsNiArMzQ0NywzMCBAQCBzdGF0aWMg
dm9pZCBhZGRyY29uZl9ncmVfY29uZmlnKHN0cnVjdA0KPiA+IG5ldF9kZXZpY2UgKmRldikNCj4g
PiAgfQ0KPiA+ICAjZW5kaWYNCj4gPiAgDQo+ID4gK3N0YXRpYyB2b2lkIGFkZHJjb25maWdfaW5p
dF9hdXRvX2FkZHJzKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+IA0KPiB0aGlzIG9uZSBzaG91
bGQgYmUgJ2FkZHJjb25mXycgdG8gYmUgY29uc2lzdGVudCB3aXRoIHJlbGF0ZWQgZnVuY3Rpb24N
Cj4gbmFtZXMuDQo+IA0KPiANCg0KV2lsbCB1cGRhdGUgaW4gbmV3IHBhdGNoIHNldC4NCg==
