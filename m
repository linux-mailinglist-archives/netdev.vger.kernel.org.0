Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A20E6518C4
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 03:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiLTCZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 21:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiLTCZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 21:25:36 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D31117D
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 18:25:33 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id D67642C04E6;
        Tue, 20 Dec 2022 15:25:27 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671503127;
        bh=t6cFuNQ2LnmXhrjxApGRATADLMRoFZkTZNyrVhsq+Z0=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=KVmBEhjZlIGLtuPo4NxBnHkqAjCOQnpz9VRCo6GyDMnoeavIkWSVt31qZKry3x2XK
         O57Z0ZEQwMCu15RtqMRzTxYvuG7BTOQ5ALgTjGoGk/uo5Mnc1/jJXTMRymuIr+SQ7v
         eAw/brKtoF7nUpqyVNpvlQnqQIunxRoBDcGEMtdX/anIDORCL/7bTTC5YGlIvaZb2f
         mw7KCN/BdBNPSI+jlDwDd0bqYqfsbY24UseZVSowrZNqSYF/dCE+G+d1WCWHRnPILh
         BoZJRY1otbG5V6g6s8Oo9fWIK+QxVXXnxPxiApO0qhLe1E7GtV4IMZJhQlV/o+EneY
         yxJ6CoOE3sxeg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63a11d170001>; Tue, 20 Dec 2022 15:25:27 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Tue, 20 Dec 2022 15:25:27 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.044; Tue, 20 Dec 2022 15:25:27 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "a@unstable.cc" <a@unstable.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Topic: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Index: AQHZFBpSn9BtuUDucEWGwn1kCNMLnQ==
Date:   Tue, 20 Dec 2022 02:25:27 +0000
Message-ID: <8e4ad680-4406-e6df-5335-ffe53a60aa83@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
In-Reply-To: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BA6A3B56D8E1146AFA84300D1EE8928@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=sHyYjHe8cH0A:10 a=VwQbUJbxAAAA:8 a=ycHaLhVXlY9nsrgXMBQA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVGhvbWFzLA0KDQpPbiAxOS8xMi8yMiAxNDowNiwgVGhvbWFzIFdpbnRlciB3cm90ZToNCj4g
Rm9yIG91ciBwb2ludC10by1wb2ludCBHUkUgdHVubmVscywgdGhleSBoYXZlIElONl9BRERSX0dF
Tl9NT0RFX05PTkUNCj4gd2hlbiB0aGV5IGFyZSBjcmVhdGVkIHRoZW4gd2Ugc2V0IElONl9BRERS
X0dFTl9NT0RFX0VVSTY0IHdoZW4gdGhleQ0KPiBjb21lIHVwIHRvIGdlbmVyYXRlIHRoZSBJUHY2
IGxpbmsgbG9jYWwgYWRkcmVzcyBmb3IgdGhlIGludGVyZmFjZS4NCj4gUmVjZW50bHkgd2UgZm91
bmQgdGhhdCB0aGV5IHdlcmUgbm8gbG9uZ2VyIGdlbmVyYXRpbmcgSVB2NiBhZGRyZXNzZXMuDQo+
DQo+IEFsc28sIG5vbi1wb2ludC10by1wb2ludCB0dW5uZWxzIHdlcmUgbm90IGdlbmVyYXRpbmcg
YW55IElQdjYgbGluaw0KPiBsb2NhbCBhZGRyZXNzIGFuZCBpbnN0ZWFkIGdlbmVyYXRpbmcgYW4g
SVB2NiBjb21wYXQgYWRkcmVzcywNCj4gYnJlYWtpbmcgSVB2NiBjb21tdW5pY2F0aW9uIG9uIHRo
ZSB0dW5uZWwuDQo+DQo+IFRoZXNlIGZhaWx1cmVzIHdlcmUgY2F1c2VkIGJ5IGNvbW1pdCBlNWRk
NzI5NDYwY2EgYW5kIHRoaXMgcGF0Y2ggc2V0DQo+IGFpbXMgdG8gcmVzb2x2ZSB0aGVzZSBpc3N1
ZXMuDQoNClRoaXMgYXBwZWFycyB0byBiZSBhIHYyIG9mIA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsLzIwMjIxMjE4MjE1NzE4LjE0OTE0NDQtMS1UaG9tYXMuV2ludGVyQGFsbGllZHRlbGVz
aXMuY28ubnovI3QgDQpidXQgeW91IGhhdmVuJ3Qgc2FpZCBzbyBpbiB0aGUgc3ViamVjdCBub3Ig
aGF2ZSB5b3UgaW5jbHVkZWQgYSBjaGFuZ2Vsb2cgDQppbiB0aGUgcGF0Y2hlcyBvciBpbiB0aGUg
Y292ZXIgbGV0dGVyLg0KDQpBbHNvIGZvciBuZXR3b3JraW5nIHBhdGNoZXMgeW91IHNob3VsZCBp
bmNsdWRlIGVpdGhlciAibmV0IiBvciANCiJuZXQtbmV4dCIgaW4gdGhlIHN1YmplY3QgcHJlZml4
LiBBcyB0aGlzIGFwcGVhcnMgdG8gYmUgYSBidWdmaXggIm5ldCIgDQppcyBhcHByb3ByaWF0ZS4N
Cg0KPg0KPiBUaG9tYXMgV2ludGVyICgyKToNCj4gICAgaXAvaXA2X2dyZTogRml4IGNoYW5naW5n
IGFkZHIgZ2VuIG1vZGUgbm90IGdlbmVyYXRpbmcgSVB2NiBsaW5rIGxvY2FsDQo+ICAgICAgYWRk
cmVzcw0KPiAgICBpcC9pcDZfZ3JlOiBGaXggbm9uLXBvaW50LXRvLXBvaW50IHR1bm5lbCBub3Qg
Z2VuZXJhdGluZyBJUHY2IGxpbmsNCj4gICAgICBsb2NhbCBhZGRyZXNzDQo+DQo+ICAgbmV0L2lw
djYvYWRkcmNvbmYuYyB8IDU3ICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlv
bnMoLSkNCj4=
