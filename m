Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EB2651941
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 04:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiLTDGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 22:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLTDGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 22:06:21 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7213E49
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 19:06:18 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9EFBE2C0610;
        Tue, 20 Dec 2022 16:06:16 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671505576;
        bh=coJwZx9OcIkwe118qlrFPGDOp2O1asTa1akFMg+g+zY=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=x3tjk/yHD9bgGoaCxNLTLCBCOwl3qBDA6cuUEe4ouPtKjZve67plnZh8gQZZG0NsR
         ISx87ei47rYrLnjfF5PArVPXv49jw3I4oMBZt15zZ3f1cnVew8VaFtZIuIACe6WcZV
         klJGq23HAHhi+hf0gwqXCPHDUeUQxbroMOIoQ41W51kecfoOqwFvzQzAvNDmu4ukep
         zZ1My7zt0MVHCGkg8HL13ilzW0d+SuBweaN7kCjepNuL5AyzNLp7YD0oz42fdOnuno
         cS3pbl6zuVS/WJFvy/Zy3EkghfcVanCgdnLlgaMQH5HaDoHN5oAHr8F4KltKQlRoLv
         sLdGWnLMyKDsw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63a126a80001>; Tue, 20 Dec 2022 16:06:16 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Dec 2022 16:06:16 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.044; Tue, 20 Dec 2022 16:06:16 +1300
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "a@unstable.cc" <a@unstable.cc>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Topic: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Index: AQHZE0Ycfe03IB9Xf02n6IMCicN9p651NCqAgAACGACAAAlQAA==
Date:   Tue, 20 Dec 2022 03:06:16 +0000
Message-ID: <90c749975ea3940b37cfae95f224da25bee6f577.camel@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
         <8e4ad680-4406-e6df-5335-ffe53a60aa83@alliedtelesis.co.nz>
         <b9e601b5-c220-0c3f-5499-317f9fd706b9@alliedtelesis.co.nz>
In-Reply-To: <b9e601b5-c220-0c3f-5499-317f9fd706b9@alliedtelesis.co.nz>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:642:1aff:fe08:1270]
Content-Type: text/plain; charset="utf-8"
Content-ID: <33EB2EFA9C91C9448B697136F7F608B8@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=sHyYjHe8cH0A:10 a=VwQbUJbxAAAA:8 a=QLyIet8_fZOiKdzATmUA:9 a=QEXdDO2ut3YA:10 a=sCYvTA3s4OUA:10 a=5imOhvl-4yYA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTEyLTIwIGF0IDE1OjMyICsxMzAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0K
PiBPbiAyMC8xMi8yMiAxNToyNSwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4gPiBIaSBUaG9tYXMs
DQo+ID4gDQo+ID4gT24gMTkvMTIvMjIgMTQ6MDYsIFRob21hcyBXaW50ZXIgd3JvdGU6DQo+ID4g
PiBGb3Igb3VyIHBvaW50LXRvLXBvaW50IEdSRSB0dW5uZWxzLCB0aGV5IGhhdmUNCj4gPiA+IElO
Nl9BRERSX0dFTl9NT0RFX05PTkUNCj4gPiA+IHdoZW4gdGhleSBhcmUgY3JlYXRlZCB0aGVuIHdl
IHNldCBJTjZfQUREUl9HRU5fTU9ERV9FVUk2NCB3aGVuDQo+ID4gPiB0aGV5DQo+ID4gPiBjb21l
IHVwIHRvIGdlbmVyYXRlIHRoZSBJUHY2IGxpbmsgbG9jYWwgYWRkcmVzcyBmb3IgdGhlDQo+ID4g
PiBpbnRlcmZhY2UuDQo+ID4gPiBSZWNlbnRseSB3ZSBmb3VuZCB0aGF0IHRoZXkgd2VyZSBubyBs
b25nZXIgZ2VuZXJhdGluZyBJUHY2DQo+ID4gPiBhZGRyZXNzZXMuDQo+ID4gPiANCj4gPiA+IEFs
c28sIG5vbi1wb2ludC10by1wb2ludCB0dW5uZWxzIHdlcmUgbm90IGdlbmVyYXRpbmcgYW55IElQ
djYNCj4gPiA+IGxpbmsNCj4gPiA+IGxvY2FsIGFkZHJlc3MgYW5kIGluc3RlYWQgZ2VuZXJhdGlu
ZyBhbiBJUHY2IGNvbXBhdCBhZGRyZXNzLA0KPiA+ID4gYnJlYWtpbmcgSVB2NiBjb21tdW5pY2F0
aW9uIG9uIHRoZSB0dW5uZWwuDQo+ID4gPiANCj4gPiA+IFRoZXNlIGZhaWx1cmVzIHdlcmUgY2F1
c2VkIGJ5IGNvbW1pdCBlNWRkNzI5NDYwY2EgYW5kIHRoaXMgcGF0Y2gNCj4gPiA+IHNldA0KPiA+
ID4gYWltcyB0byByZXNvbHZlIHRoZXNlIGlzc3Vlcy4NCj4gPiANCj4gPiBUaGlzIGFwcGVhcnMg
dG8gYmUgYSB2MiBvZiANCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjEyMTgy
MTU3MTguMTQ5MTQ0NC0xLVRob21hcy5XaW50ZXJAYWxsaWVkdGVsZXNpcy5jby5uei8jdCANCj4g
PiBidXQgeW91IGhhdmVuJ3Qgc2FpZCBzbyBpbiB0aGUgc3ViamVjdCBub3IgaGF2ZSB5b3UgaW5j
bHVkZWQgYSANCj4gPiBjaGFuZ2Vsb2cgaW4gdGhlIHBhdGNoZXMgb3IgaW4gdGhlIGNvdmVyIGxl
dHRlci4NCj4gPiANCj4gPiBBbHNvIGZvciBuZXR3b3JraW5nIHBhdGNoZXMgeW91IHNob3VsZCBp
bmNsdWRlIGVpdGhlciAibmV0IiBvciANCj4gPiAibmV0LW5leHQiIGluIHRoZSBzdWJqZWN0IHBy
ZWZpeC4gQXMgdGhpcyBhcHBlYXJzIHRvIGJlIGEgYnVnZml4DQo+ID4gIm5ldCIgDQo+ID4gaXMg
YXBwcm9wcmlhdGUuDQo+ID4gDQo+IFRvb2sgbWUgYSBiaXQgb2YgbG9va2luZyBidXQgbW9zdCBv
ZiB0aGlzIHN0dWZmIGlzIGNvdmVyZWQgYnkgDQo+IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9j
L2h0bWwvbGF0ZXN0L3Byb2Nlc3MvbWFpbnRhaW5lci1uZXRkZXYuaHRtbCNuZXRkZXYtZmFxDQoN
ClRoYW5rcywgdGhlIGdpdCBjb21tYW5kIEkgdXNlZCBkaWQgbm90IHB1dCBpbiB0aGUgdjIgdGhh
dCBJIGV4cGVjdGVkDQphbmQgSSBkaWRuJ3QgY2hlY2sgdGhlIG91dHB1dCBwcm9wZXJseS4gSSB3
aWxsIHNlbmQgYSBuZXcgcGF0Y2ggc2V0IGFzDQp2My4NCg0KPiA+ID4gVGhvbWFzIFdpbnRlciAo
Mik6DQo+ID4gPiAgICBpcC9pcDZfZ3JlOiBGaXggY2hhbmdpbmcgYWRkciBnZW4gbW9kZSBub3Qg
Z2VuZXJhdGluZyBJUHY2DQo+ID4gPiBsaW5rIGxvY2FsDQo+ID4gPiAgICAgIGFkZHJlc3MNCj4g
PiA+ICAgIGlwL2lwNl9ncmU6IEZpeCBub24tcG9pbnQtdG8tcG9pbnQgdHVubmVsIG5vdCBnZW5l
cmF0aW5nIElQdjYNCj4gPiA+IGxpbmsNCj4gPiA+ICAgICAgbG9jYWwgYWRkcmVzcw0KPiA+ID4g
DQo+ID4gPiAgIG5ldC9pcHY2L2FkZHJjb25mLmMgfCA1NyArKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0NCj4gPiA+IC0tLS0tLS0tLQ0KPiA+ID4gICAxIGZpbGUgY2hhbmdlZCwg
MzEgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pDQo=
