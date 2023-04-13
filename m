Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A673C6E033F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjDMAeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMAeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:34:09 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF2A49D6
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 17:34:06 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9B1EA2C049B;
        Thu, 13 Apr 2023 12:34:00 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1681346040;
        bh=Qxr33iwm9m6CXp1bUCnx6jPjAULl17u+OX+At1olu+A=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=KcVHD4aOv55fz5/4ZSM4k6vepLStAmKlbrD1943BtBxE6TknL4TxPwmbKMab0Ds7G
         xIGJxTv+Lm6d3s0FsfhIaN87hxc0fkruSWztPgLjULaK+4dufeZo5TpIN7fbeynpmo
         hXboJdB9DHBvsR6Xsxn0P69/8hB1t4WqZLj6yzGtkYX1xQaNq/DCAPdJ4csEqntyDe
         VvHdk/CBOS7pWp8JXaeFqLf4xUhm8QhA+tRMZOGen6Wx594nMdEQP2imW88EAPFiq1
         Yomg3YB9OGa4mZN4dmKt3YdFtTBms/eSHStTS/muK/ZjnHtkJ+YVXuthdVWHwJdydo
         pWma7GODKiJ+g==
Received: from svr-chch-ex2.atlnz.lc (Not Verified[2001:df5:b000:bc8::76]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B64374df80003>; Thu, 13 Apr 2023 12:34:00 +1200
Received: from svr-chch-ex2.atlnz.lc (2001:df5:b000:bc8::76) by
 svr-chch-ex2.atlnz.lc (2001:df5:b000:bc8::76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 13 Apr 2023 12:33:59 +1200
Received: from svr-chch-ex2.atlnz.lc ([fe80::a9eb:c9b7:8b52:9567]) by
 svr-chch-ex2.atlnz.lc ([fe80::a9eb:c9b7:8b52:9567%15]) with mapi id
 15.02.1118.026; Thu, 13 Apr 2023 12:33:59 +1200
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     "ashumnik9@gmail.com" <ashumnik9@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "a@unstable.cc" <a@unstable.cc>
Subject: Re: [BUG] gre interface incorrectly generates link-local addresses
Thread-Topic: [BUG] gre interface incorrectly generates link-local addresses
Thread-Index: AQHZXqDEeI+88FfXw0GKYKB5JOW0Tq8dq8aAgACEbgCACYhgAA==
Date:   Thu, 13 Apr 2023 00:33:59 +0000
Message-ID: <f06f7aafb9fd122f2ff62a37d1f6dec163aa562c.camel@alliedtelesis.co.nz>
References: <CAJGXZLhL-LLjiA-ge8O5A5NDoZ5JABqZHqix0y-8ThcJjBSe=A@mail.gmail.com>
         <20230324153407.096d6248@kernel.org>
         <CAJGXZLi7LedV_MYr==1RsN6goth73Y4txA=neci_QQcwa5Oqvw@mail.gmail.com>
         <be4cd6bf2103caa42f475739a3dc6a841e1c6542.camel@alliedtelesis.co.nz>
In-Reply-To: <be4cd6bf2103caa42f475739a3dc6a841e1c6542.camel@alliedtelesis.co.nz>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:df5:b000:25:642:1aff:fe08:1270]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFAA4D0D906DC846ABC1A0377085F385@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=VfuJw2h9 c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dKHAf1wccvYA:10 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8 a=PjmhsBtKUkMwRgke3vUA:9 a=gTO1l0DTZEyz3MbD:21 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gQWxla3NleSBhbmQgbWFpbnRhaW5lcnMsDQoNCkNvbW1pdCBlNWRkNzI5NDYwY2EgbWFk
ZSBpdCBzbyB0aGUgbGluayBsb2NhbCBhZGRyZXNzIGZvciB0dW5uZWxzIGlzDQpiYXNlZCBvbiB0
aGUgc291cmNlIGFkZHJlc3Mgb2YgdGhlIHR1bm5lbCBpbnN0ZWFkIG9mIHRoZSBldWk2NA0KYWxn
b3JpdGhtLiBCdXQgaXQgYWxzbyBicm9rZSBjaGFuZ2luZyBhZGRyX2dlbl9tb2RlIHRvIGNyZWF0
ZSB0aGUgbGluaw0KbG9jYWwgYWRkcmVzcyB3aGljaCBpcyB3aGF0IG15IHBhdGNoIDIzY2EwYzJj
OTM0MCBhaW1lZCB0byBmaXguDQoNCklmIHRoZSBsYXN0IDQgYnl0ZXMgb2YgYSBzb3VyY2UgaXB2
NiBhZGRyZXNzIGFyZSB6ZXJvIG9yIGluIHlvdXIgY2FzZQ0Kd2hlcmUgdGhlIGlwdjQgc291cmNl
IGFkZHJlc3MgaXMgbm90IHByZXNlbnQgImxpbmsvZ3JlIDAuMC4wLjAiIHRoZW4gaXQNCmdlbmVy
YXRlcyBpcHY2IGxpbmsgbG9jYWwgYWRkcmVzc2VzIGJhc2VkIG9uIGlwdjQgYWRkcmVzc2VzIG9m
IGFsbA0Kb3RoZXIgaW50ZXJmYWNlcy4NCg0KPiA+IFRoZSBwcm9ibGVtIGlzIG5vdCBvbmx5IGlu
IGdlbmVyYXRpbmcgdGhlIG51bWJlciBvZiBsaW5rLWxvY2FsDQo+ID4gYWRkcmVzc2VzIGluIGFu
IGFtb3VudCBlcXVhbCB0byB0aGUgbnVtYmVyIG9mIGFkZHJlc3NlcyBvbiBhbGwNCj4gPiBpbnRl
cmZhY2VzIGRlZmluZWQgaW4gL2V0Yy9uZXR3b3JrL2ludGVyZmFjZXMgYmVmb3JlIHRoZSBncmUN
Cj4gPiBpbnRlcmZhY2UuDQpUaGUgc2ltcGxlIGZpeCBmb3IgdGhpcyB0byBzdG9wIHRoZSBmb3Jf
ZWFjaF9uZXRkZXYgbG9vcCBvbmNlIG9uZQ0KYWRkcmVzcyBoYXMgYmVlbiBnZW5lcmF0ZWQuDQoN
Cj4gPiBEdWUgdG8gdGhlIG5ldyBtZXRob2Qgb2YgbGluay1sb2NhbCBhZGRyZXNzIGdlbmVyYXRp
b24sIHRoZSBzYW1lDQo+ID4gbGluay1sb2NhbCBhZGRyZXNzIG1heSBiZSBmb3JtZWQgb24gc2V2
ZXJhbCBncmUgaW50ZXJmYWNlcywgd2hpY2gNCj4gPiBtYXkNCj4gPiBsZWFkIHRvIGVycm9ycyBp
biB0aGUgb3BlcmF0aW9uIG9mIHNvbWUgbmV0d29yayBzZXJ2aWNlcw0KQ2FuIHlvdSBleHBsYWlu
IHRoaXMgaW4gbW9yZSBkZXRhaWwgb3IgbGlzdCBzb21lIGV4YW1wbGUgbmV0d29yaw0Kc2Vydmlj
ZXMgd2hlcmUgdGhpcyBpcyBhIHByb2JsZW0/DQpNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgcmVm
ZXJlbmNpbmcgbGluayBsb2NhbCBhZGRyZXNzIHNob3VsZCBiZSB1c2VkDQp3aXRoIGFuIGlmaW5k
ZXgvbmFtZSBiZWNhdXNlIG9mIHRoZSBsb2NhbCBzY29wZSBidXQgbm90IGFsbCBzb2Z0d2FyZQ0K
ZW5mb3JjZXMgdGhpcy4NCg0KVGhlIG90aGVyIHNvbHV0aW9uIHRvIHRoaXMgaXMgdG8gbW92ZSBi
YWNrIHRvIGV1aTY0IGdlbmVyYXRpb24gYXMgd2FzDQp0aGUgY2FzZSBiZWZvcmUgdGhlIGNoYW5n
ZXMgaW4gZTVkZDcyOTQ2MGNhIGZvciBncmUvc2l0IHR1bm5lbHMuDQoNClJlZ2FyZHMsDQpUaG9t
YXMgV2ludGVyDQoNCg0KT24gRnJpLCAyMDIzLTA0LTA3IGF0IDEwOjU4ICsxMjAwLCBUaG9tYXMg
V2ludGVyIHdyb3RlOg0KPiBIZWxsbyBBbGVrc2V5LA0KPiANCj4gU29ycnksIEkgd2FzIG9uIGxl
YXZlIGR1cmluZyBNYXJjaCBzbyBvbmx5IGdldHRpbmcgdG8gdGhpcyBub3cuIEkNCj4gd2lsbA0K
PiBoYXZlIGEgcHJvcGVyIGxvb2sgYXQgdGhpcyB3aGVuIEkgZ2V0IGJhY2sgdG8gd29yayBvbiBU
dWVzZGF5IGFuZCB0cnkNCj4gdG8gcmVwcm9kdWNlIHlvdXIgaXNzdWUuDQo+IA0KPiBNeSBpc3N1
ZSB3YXMgb24gb3VyIHJvdXRlcnMgdXNpbmcga2VybmVsIDUuMTUuODkgYW5kIHdlIGRvbid0DQo+
IHVzZSAvZXRjL25ldHdvcmsvaW50ZXJmYWNlcyBmb3IgY29uZmlndXJhdGlvbi4gVGhlIHR1bm5l
bCB3YXMgY3JlYXRlZA0KPiB3aXRoIG5ldGxpbmsgbWVzc2FnZXMgbGlrZSB3aXRoIHRoZSAiaXAg
bGluayIgY29tbWFuZCBhbmQgYW4gSVB2Ng0KPiBsaW5rDQo+IGxvY2FsIGFkZHJlc3MgaXMgZ2Vu
ZXJhdGVkIGJ5DQo+IHNldHRpbmcgL3Byb2Mvc3lzL25ldC9pcHY2L2NvbmYvdHVubmVsMC9hZGRy
X2dlbl9tb2RlIGJ1dCB0aGlzIGJyb2tlDQo+IGFmdGVyIGNvbW1pdCBlNWRkNzI5NDYwY2EuIEkg
ZGlkIG5vdCBzZWUgYW55IGhhbmdpbmcgYWRkcmVzc2VzIGxpa2UNCj4geW91DQo+IGRlc2NyaWJl
ZC4NCj4gDQo+IFJlZ2FyZHMsDQo+IFRob21hcw0KPiANCj4gT24gVGh1LCAyMDIzLTA0LTA2IGF0
IDE4OjA0ICswMzAwLCBBbGVrc2V5IFNodW1uaWsgd3JvdGU6DQo+ID4gRGVhciBtYWludGFpbmVy
cywNCj4gPiANCj4gPiBJIHJlbWluZCB5b3UgdGhhdCB0aGUgcHJvYmxlbSBpcyBzdGlsbCByZWxl
dmFudC4NCj4gPiBUaGUgcHJvYmxlbSBpcyBub3Qgb25seSBpbiBnZW5lcmF0aW5nIHRoZSBudW1i
ZXIgb2YgbGluay1sb2NhbA0KPiA+IGFkZHJlc3NlcyBpbiBhbiBhbW91bnQgZXF1YWwgdG8gdGhl
IG51bWJlciBvZiBhZGRyZXNzZXMgb24gYWxsDQo+ID4gaW50ZXJmYWNlcyBkZWZpbmVkIGluIC9l
dGMvbmV0d29yay9pbnRlcmZhY2VzIGJlZm9yZSB0aGUgZ3JlDQo+ID4gaW50ZXJmYWNlLg0KPiA+
IER1ZSB0byB0aGUgbmV3IG1ldGhvZCBvZiBsaW5rLWxvY2FsIGFkZHJlc3MgZ2VuZXJhdGlvbiwg
dGhlIHNhbWUNCj4gPiBsaW5rLWxvY2FsIGFkZHJlc3MgbWF5IGJlIGZvcm1lZCBvbiBzZXZlcmFs
IGdyZSBpbnRlcmZhY2VzLCB3aGljaA0KPiA+IG1heQ0KPiA+IGxlYWQgdG8gZXJyb3JzIGluIHRo
ZSBvcGVyYXRpb24gb2Ygc29tZSBuZXR3b3JrIHNlcnZpY2VzDQo+ID4gDQo+ID4gV291bGQgeW91
IHBsZWFzZSBhbnN3ZXIgdGhlIGZvbGxvd2luZyBxdWVzdGlvbnMNCj4gPiA+IFdoaWNoIGxpbnV4
IGRpc3RyaWJ1dGlvbiBkaWQgeW91IHVzZSB3aGVuIHlvdSBmb3VuZCBhbiBlcnJvciB3aXRoDQo+
ID4gPiB0aGUNCj4gPiA+IGxhY2sgb2YgbGluay1sb2NhbCBhZGRyZXNzIGdlbmVyYXRpb24gb24g
dGhlIGdyZSBpbnRlcmZhY2U/DQo+ID4gPiBBZnRlciBmaXhpbmcgdGhlIGVycm9yLCBvbmx5IG9u
ZSBsaW5rLWxvY2FsIGFkZHJlc3MgaXMgZ2VuZXJhdGVkPw0KPiA+IElzIHRoaXMgYSBidWcgb3Ig
YW4gZXhwZWN0ZWQgYmVoYXZpb3I/DQo+ID4gDQo+ID4gT24gU2F0LCBNYXIgMjUsIDIwMjMgYXQg
MTozNOKAr0FNIEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4gd3JvdGU6DQo+
ID4gPiBBZGRpbmcgVGhvbWFzIGFzIHdlbGwuDQo+ID4gPiANCj4gPiA+IE9uIEZyaSwgMjQgTWFy
IDIwMjMgMTk6MzU6MDYgKzAzMDAgQWxla3NleSBTaHVtbmlrIHdyb3RlOg0KPiA+ID4gPiBEZWFy
IE1haW50YWluZXJzLA0KPiA+ID4gPiANCj4gPiA+ID4gSSBmb3VuZCB0aGF0IEdSRSBhcmJpdHJh
cmlseSBoYW5ncyBJUCBhZGRyZXNzZXMgZnJvbSBvdGhlcg0KPiA+ID4gPiBpbnRlcmZhY2VzDQo+
ID4gPiA+IGRlc2NyaWJlZCBpbiAvZXRjL25ldHdvcmsvaW50ZXJmYWNlcyBhYm92ZSBpdHNlbGYg
KGZyb20gYm90dG9tDQo+ID4gPiA+IHRvDQo+ID4gPiA+IHRvcCkuIE1vcmVvdmVyLCB0aGlzIGVy
cm9yIG9jY3VycyBvbiBib3RoIGlwNGdyZSBhbmQgaXA2Z3JlLg0KPiA+ID4gPiANCj4gPiA+ID4g
RXhhbXBsZSBvZiBtZ3JlIGludGVyZmFjZToNCj4gPiA+ID4gDQo+ID4gPiA+IDEzOiBtZ3JlMUBO
T05FOiA8TVVMVElDQVNULE5PQVJQLFVQLExPV0VSX1VQPiBtdHUgMTQwMCBxZGlzYw0KPiA+ID4g
PiBub3F1ZXVlDQo+ID4gPiA+IHN0YXRlIFVOS05PV04gZ3JvdXAgZGVmYXVsdCBxbGVuIDEwMDAN
Cj4gPiA+ID4gICAgIGxpbmsvZ3JlIDAuMC4wLjAgYnJkIDAuMC4wLjANCj4gPiA+ID4gICAgIGlu
ZXQgMTAuMTAuMTAuMTAwLzggYnJkIDEwLjI1NS4yNTUuMjU1IHNjb3BlIGdsb2JhbCBtZ3JlMQ0K
PiA+ID4gPiAgICAgICAgdmFsaWRfbGZ0IGZvcmV2ZXIgcHJlZmVycmVkX2xmdCBmb3JldmVyDQo+
ID4gPiA+ICAgICBpbmV0NiBmZTgwOjphMGE6YTY0LzY0IHNjb3BlIGxpbmsNCj4gPiA+ID4gICAg
ICAgIHZhbGlkX2xmdCBmb3JldmVyIHByZWZlcnJlZF9sZnQgZm9yZXZlcg0KPiA+ID4gPiAgICAg
aW5ldDYgZmU4MDo6N2YwMDoxLzY0IHNjb3BlIGhvc3QNCj4gPiA+ID4gICAgICAgIHZhbGlkX2xm
dCBmb3JldmVyIHByZWZlcnJlZF9sZnQgZm9yZXZlcg0KPiA+ID4gPiAgICAgaW5ldDYgZmU4MDo6
YTA6Njg0Mi82NCBzY29wZSBob3N0DQo+ID4gPiA+ICAgICAgICB2YWxpZF9sZnQgZm9yZXZlciBw
cmVmZXJyZWRfbGZ0IGZvcmV2ZXINCj4gPiA+ID4gICAgIGluZXQ2IGZlODA6OmMwYTg6MTI2NC82
NCBzY29wZSBob3N0DQo+ID4gPiA+ICAgICAgICB2YWxpZF9sZnQgZm9yZXZlciBwcmVmZXJyZWRf
bGZ0IGZvcmV2ZXINCj4gPiA+ID4gDQo+ID4gPiA+IEl0IHNlZW1zIHRoYXQgYWZ0ZXIgdGhlIGNv
cnJlY3Rpb25zIGluIHRoZSBmb2xsb3dpbmcgY29tbWl0cw0KPiA+ID4gPiBodHRwczovL2dpdGh1
Yi5jb20vdG9ydmFsZHMvbGludXgvY29tbWl0L2U1ZGQ3Mjk0NjBjYThkMmRhMDIwMjhkYmYyNjRi
NjViZThjZDRiNWYNCj4gPiA+ID4gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2Nv
bW1pdC8zMGUyMjkxZjYxZjkzZjcxMzJjMDYwMTkwZjgzNjBkZjUyNjQ0ZWMxDQo+ID4gPiA+IGh0
dHBzOi8vZ2l0aHViLmNvbS90b3J2YWxkcy9saW51eC9jb21taXQvMjNjYTBjMmM5MzQwNmJkYjEx
NTA2NTllNzIwYmRhMWNlYzFmYWQwNA0KPiA+ID4gPiANCj4gPiA+ID4gaW4gZnVuY3Rpb24gYWRk
X3Y0X2FkZHJzKCkgaW5zdGVhZCBvZiBzdG9wcGluZyBhZnRlciB0aGlzDQo+ID4gPiA+IGNoZWNr
Og0KPiA+ID4gPiANCj4gPiA+ID4gaWYgKGFkZHIuczZfYWRkcjMyWzNdKSB7DQo+ID4gPiA+ICAg
ICAgICAgICAgICAgICBhZGRfYWRkcihpZGV2LCAmYWRkciwgcGxlbiwgc2NvcGUsDQo+ID4gPiA+
IElGQVBST1RfVU5TUEVDKTsNCj4gPiA+ID4gICAgICAgICAgICAgICAgIGFkZHJjb25mX3ByZWZp
eF9yb3V0ZSgmYWRkciwgcGxlbiwgMCwgaWRldi0NCj4gPiA+ID4gPmRldiwNCj4gPiA+ID4gMCwg
cGZsYWdzLA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCj4gPiA+ID4gIEcNCj4gPiA+ID4gRlBfS0VSTkVMKTsN
Cj4gPiA+ID4gICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gPiA+IH0NCj4gPiA+ID4gDQo+
ID4gPiA+IGl0IGdvZXMgZnVydGhlciBhbmQgaW4gdGhpcyBjeWNsZSBoYW5ncyBhZGRyZXNzZXMg
ZnJvbSBhbGwNCj4gPiA+ID4gaW50ZXJmYWNlcyBvbiB0aGUgZ3JlDQo+ID4gPiA+IA0KPiA+ID4g
PiBmb3JfZWFjaF9uZXRkZXYobmV0LCBkZXYpIHsNCj4gPiA+ID4gICAgICAgc3RydWN0IGluX2Rl
dmljZSAqaW5fZGV2ID0gX19pbl9kZXZfZ2V0X3J0bmwoZGV2KTsNCj4gPiA+ID4gICAgICAgaWYg
KGluX2RldiAmJiAoZGV2LT5mbGFncyAmIElGRl9VUCkpIHsNCj4gPiA+ID4gICAgICAgc3RydWN0
IGluX2lmYWRkciAqaWZhOw0KPiA+ID4gPiAgICAgICBpbnQgZmxhZyA9IHNjb3BlOw0KPiA+ID4g
PiAgICAgICBpbl9kZXZfZm9yX2VhY2hfaWZhX3J0bmwoaWZhLCBpbl9kZXYpIHsNCj4gPiA+ID4g
ICAgICAgICAgICAgYWRkci5zNl9hZGRyMzJbM10gPSBpZmEtPmlmYV9sb2NhbDsNCj4gPiA+ID4g
ICAgICAgICAgICAgaWYgKGlmYS0+aWZhX3Njb3BlID09IFJUX1NDT1BFX0xJTkspDQo+ID4gPiA+
ICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ID4gPiAgICAgICAgICAgICBpZiAo
aWZhLT5pZmFfc2NvcGUgPj0gUlRfU0NPUEVfSE9TVCkgew0KPiA+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICBpZiAoaWRldi0+ZGV2LT5mbGFncyZJRkZfUE9JTlRPUE9JTlQpDQo+ID4gPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ID4gPiAgICAgICAgICAg
ICAgICAgICAgICBmbGFnIHw9IElGQV9IT1NUOw0KPiA+ID4gPiAgICAgICAgICAgICB9DQo+ID4g
PiA+ICAgICAgICAgICAgIGFkZF9hZGRyKGlkZXYsICZhZGRyLCBwbGVuLCBmbGFnLA0KPiA+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBJRkFQUk9UX1VOU1BFQyk7DQo+
ID4gPiA+ICAgICAgICAgICAgIGFkZHJjb25mX3ByZWZpeF9yb3V0ZSgmYWRkciwgcGxlbiwgMCwg
aWRldi0+ZGV2LA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
MCwgcGZsYWdzLCBHRlBfS0VSTkVMKTsNCj4gPiA+ID4gICAgICAgICAgICAgfQ0KPiA+ID4gPiB9
DQo+ID4gPiA+IA0KPiA+ID4gPiBNb3Jlb3ZlciwgYmVmb3JlIHN3aXRjaGluZyB0byBEZWJpYW4g
MTIga2VybmVsIHZlcnNpb24gNi4xLjE1LA0KPiA+ID4gPiBJDQo+ID4gPiA+IHVzZWQNCj4gPiA+
ID4gRGViaWFuIDExIG9uIDUuMTAuMTQwLCBhbmQgdGhlcmUgd2FzIG5vIGVycm9yIGRlc2NyaWJl
ZCBpbiB0aGUNCj4gPiA+ID4gY29tbWl0DQo+ID4gPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2
YWxkcy9saW51eC9jb21taXQvZTVkZDcyOTQ2MGNhOGQyZGEwMjAyOGRiZjI2NGI2NWJlOGNkNGI1
Zi4NCj4gPiA+ID4gT25lIGxpbmstbG9jYWwgYWRkcmVzcyB3YXMgYWx3YXlzIGdlbmVyYXRlZCBv
biB0aGUgZ3JlDQo+ID4gPiA+IGludGVyZmFjZSwNCj4gPiA+ID4gcmVnYXJkbGVzcyBvZiB3aGV0
aGVyIHRoZSBkZXN0aW5hdGlvbiBvciB0aGUgbG9jYWwgYWRkcmVzcyBvZg0KPiA+ID4gPiB0aGUN
Cj4gPiA+ID4gdHVubmVsIHdhcyBzcGVjaWZpZWQuDQo+ID4gPiA+IA0KPiA+ID4gPiBXaGljaCBs
aW51eCBkaXN0cmlidXRpb24gZGlkIHlvdSB1c2Ugd2hlbiB5b3UgZm91bmQgYW4gZXJyb3INCj4g
PiA+ID4gd2l0aA0KPiA+ID4gPiB0aGUNCj4gPiA+ID4gbGFjayBvZiBsaW5rLWxvY2FsIGFkZHJl
c3MgZ2VuZXJhdGlvbiBvbiB0aGUgZ3JlIGludGVyZmFjZT8NCj4gPiA+ID4gQWZ0ZXIgZml4aW5n
IHRoZSBlcnJvciwgb25seSBvbmUgbGluay1sb2NhbCBhZGRyZXNzIGlzDQo+ID4gPiA+IGdlbmVy
YXRlZD8NCj4gPiA+ID4gSSB0aGluayB0aGlzIGlzIGEgYnVnIGFuZCBtb3N0IGxpa2VseSB0aGUg
cHJvYmxlbSBpcyBpbg0KPiA+ID4gPiBnZW5lcmF0aW5nDQo+ID4gPiA+IGRldi0+ZGV2X2FkZHIs
IHNpbmNlIGxpbmstbG9jYWwgaXMgZm9ybWVkIGZyb20gaXQuDQo+ID4gPiA+IA0KPiA+ID4gPiBJ
IHN1Z2dlc3Qgc29sdmluZyB0aGlzIHByb2JsZW0gb3Igcm9sbCBiYWNrIHRoZSBjb2RlIGNoYW5n
ZXMNCj4gPiA+ID4gbWFkZQ0KPiA+ID4gPiBpbg0KPiA+ID4gPiB0aGUgY29tbWVudHMgYWJvdmUu
DQo=
