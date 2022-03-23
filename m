Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8706B4E4AAA
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 02:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiCWB7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 21:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCWB7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 21:59:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBC1D5621F
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:57:45 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-130-lFQCKZA0NSGnTdW-G_mNsQ-1; Wed, 23 Mar 2022 01:57:41 +0000
X-MC-Unique: lFQCKZA0NSGnTdW-G_mNsQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 23 Mar 2022 01:57:41 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 23 Mar 2022 01:57:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Torin Carey' <torin@tcarey.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] udp: change MSG_TRUNC return behaviour for MSG_PEEK in
 recvmsg
Thread-Topic: [PATCH] udp: change MSG_TRUNC return behaviour for MSG_PEEK in
 recvmsg
Thread-Index: AQHYPh+fV1aILsQYJkGFKR0h1ZEPnazMNg+w
Date:   Wed, 23 Mar 2022 01:57:41 +0000
Message-ID: <eff8db769c314119a8867e968e4dddea@AcuMS.aculab.com>
References: <YjodjXHN7j69h/kd@kappa>
In-Reply-To: <YjodjXHN7j69h/kd@kappa>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9yaW4gQ2FyZXkNCj4gU2VudDogMjIgTWFyY2ggMjAyMiAxOTowNA0KPiANCj4gTWFr
ZSBVRFAgcmVjdm1zZyBvbmx5IHJldHVybiB0aGUgTVNHX1RSVU5DIGZsYWcgaWYgdGhlIHJlYWQg
ZG9lcyBub3QNCj4gY29weSB0aGUgdGFpbCBlbmQgb2YgdGhlIGRhdGFncmFtLiAgU3BlY2lmaWNh
bGx5LCB0aGlzIHRhcmdldHMgTVNHX1BFRUsNCj4gd2hlbiB3ZSdyZSB1c2luZyBhIHBvc2l0aXZl
IHBlZWsgb2Zmc2V0Lg0KPiANCj4gVGhlIGN1cnJlbnQgYmVoYXZpb3VyIG1lYW5zIHRoYXQgaWYg
d2UgaGF2ZSBhIHBvc2l0aXZlIHBlZWsgb2Zmc2V0IGBvZmZgDQo+IGFuZCB3ZSdyZSByZWFkaW5n
IGByYCBieXRlcyBmcm9tIGEgZGF0YWdyYW0gb2YgYHVsZW5gIGxlbmd0aCwgd2UgcmVzcG9uZA0K
PiB3aXRoIE1TR19UUlVOQyBpZiBhbmQgb25seSBpZiBgciA8PSB1bGVuIC0gb2ZmYC4gIFRoaXMg
aXMgb2RkIGJlaGF2aW91cg0KPiBhcyB3ZSByZXR1cm4gTVNHX1RSVU5DIGlmIHRoZSB1c2VyIHJl
cXVlc3RzIGV4YWN0bHkgYHVsZW4gLSBvZmZgIHdoaWNoDQo+IGhhcyBubyB0cnVuY2F0aW9uLg0K
PiANCj4gVGhlIGJlaGF2aW91ciBjb3VsZCBiZSBjb3JyZWN0ZWQgaW4gdHdvIHdheXM6DQo+IA0K
PiBUaGlzIHBhdGNoIHJldHVybnMgTVNHX1RSVU5DIG9ubHkgZm9yIHRhaWwtZW5kIHRydW5jYXRp
b24gYW5kIG5vdCBoZWFkDQo+IHRydW5jYXRpb24uICBUaGlzIGlzIG1vcmUgY29uc2lzdGVudCB3
aXRoIHJlY3YoMik6DQo+ID4gTVNHX1RSVU5DDQo+ID4gICAgIGluZGljYXRlcyB0aGF0IHRoZSB0
cmFpbGluZyBwb3J0aW9uIG9mIGEgZGF0YWdyYW0gd2FzIGRpc2NhcmRlZA0KPiA+ICAgICBiZWNh
dXNlIHRoZSBkYXRhZ3JhbSB3YXMgbGFyZ2VyIHRoYW4gdGhlIGJ1ZmZlciBzdXBwbGllZC4NCj4g
YWx0aG91Z2ggdGhpcyBpc24ndCB3cml0dGVuIHdpdGggU09fUEVFS19PRkYgaW4gbWluZC4NCj4g
DQo+IFRoZSBzZWNvbmQgb3B0aW9uIGlzIHRvIGFsd2F5cyByZXR1cm4gTVNHX1RSVU5DIGlmIGBv
ZmYgPiAwYCBsaWtlIHRoZQ0KPiBtYW4tcGFnZXMgc29ja2V0KDcpIHBhZ2Ugc3RhdGVzOg0KPiA+
IEZvciBkYXRhZ3JhbSBzb2NrZXRzLCBpZiB0aGUgInBlZWsgb2Zmc2V0IiBwb2ludHMgdG8gdGhl
IG1pZGRsZSBvZiBhDQo+ID4gcGFja2V0LCB0aGUgZGF0YSByZXR1cm5lZCB3aWxsIGJlIG1hcmtl
ZCB3aXRoIHRoZSBNU0dfVFJVTkMgZmxhZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRvcmluIENh
cmV5IDx0b3JpbkB0Y2FyZXkudWs+DQo+IC0tLQ0KPiAgbmV0L2lwdjQvdWRwLmMgfCAyICstDQo+
ICBuZXQvaXB2Ni91ZHAuYyB8IDIgKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9pcHY0L3VkcC5jIGIv
bmV0L2lwdjQvdWRwLmMNCj4gaW5kZXggMzE5ZGQ3YmJmZTMzLi5lNTc3NDBhMmMzMDggMTAwNjQ0
DQo+IC0tLSBhL25ldC9pcHY0L3VkcC5jDQo+ICsrKyBiL25ldC9pcHY0L3VkcC5jDQo+IEBAIC0x
ODU1LDcgKzE4NTUsNyBAQCBpbnQgdWRwX3JlY3Ztc2coc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qg
bXNnaGRyICptc2csIHNpemVfdCBsZW4sIGludCBub2Jsb2NrLA0KPiAgCWNvcGllZCA9IGxlbjsN
Cj4gIAlpZiAoY29waWVkID4gdWxlbiAtIG9mZikNCj4gIAkJY29waWVkID0gdWxlbiAtIG9mZjsN
Cj4gLQllbHNlIGlmIChjb3BpZWQgPCB1bGVuKQ0KPiArCWVsc2UgaWYgKGNvcGllZCA8IHVsZW4g
LSBvZmYpDQo+ICAJCW1zZy0+bXNnX2ZsYWdzIHw9IE1TR19UUlVOQzsNCg0KWW91IGNhbiByZW1v
dmUgYSB0ZXN0Og0KCWlmIChjb3BpZWQgPj0gdWxlbiAtIG9mZikNCgkJY29waWVkID0gdWxlbiAt
IG9mZjsNCgllbHNlDQoJCW1zZy0+bXNnX2ZsYWdzIHw9IE1TR19UUlVOQzsNCg0KICAgIERhdmlk
DQoNCj4gDQo+ICAJLyoNCj4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L3VkcC5jIGIvbmV0L2lwdjYv
dWRwLmMNCj4gaW5kZXggMTRhOTRjZGRjZjBiLi5kNmMwZWVkOTQ1NjQgMTAwNjQ0DQo+IC0tLSBh
L25ldC9pcHY2L3VkcC5jDQo+ICsrKyBiL25ldC9pcHY2L3VkcC5jDQo+IEBAIC0zNDgsNyArMzQ4
LDcgQEAgaW50IHVkcHY2X3JlY3Ztc2coc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICpt
c2csIHNpemVfdCBsZW4sDQo+ICAJY29waWVkID0gbGVuOw0KPiAgCWlmIChjb3BpZWQgPiB1bGVu
IC0gb2ZmKQ0KPiAgCQljb3BpZWQgPSB1bGVuIC0gb2ZmOw0KPiAtCWVsc2UgaWYgKGNvcGllZCA8
IHVsZW4pDQo+ICsJZWxzZSBpZiAoY29waWVkIDwgdWxlbiAtIG9mZikNCj4gIAkJbXNnLT5tc2df
ZmxhZ3MgfD0gTVNHX1RSVU5DOw0KPiANCj4gIAlpc191ZHA0ID0gKHNrYi0+cHJvdG9jb2wgPT0g
aHRvbnMoRVRIX1BfSVApKTsNCj4gLS0NCj4gMi4zNC4xDQo+IA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

