Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CA551856B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiECNbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiECNbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:31:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C17BF1103
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 06:27:34 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-281-NrXSpE7mPDKXmd5uSu6LLg-1; Tue, 03 May 2022 14:27:31 +0100
X-MC-Unique: NrXSpE7mPDKXmd5uSu6LLg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Tue, 3 May 2022 14:27:31 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Tue, 3 May 2022 14:27:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Dumazet <edumazet@google.com>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH v2] net: rds: acquire refcount on TCP sockets
Thread-Topic: [PATCH v2] net: rds: acquire refcount on TCP sockets
Thread-Index: AQHYXsyW1iInROXA4UOMkVmM8/hvqK0NI0Qg
Date:   Tue, 3 May 2022 13:27:30 +0000
Message-ID: <8783dad64b0d41af9624f923cb4e4f03@AcuMS.aculab.com>
References: <00000000000045dc96059f4d7b02@google.com>
         <000000000000f75af905d3ba0716@google.com>
         <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
         <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
         <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
         <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
         <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
         <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
In-Reply-To: <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMDMgTWF5IDIwMjIgMTA6MDMNCj4gDQo+IEhlbGxv
LA0KPiANCj4gT24gTW9uLCAyMDIyLTA1LTAyIGF0IDEwOjQwICswOTAwLCBUZXRzdW8gSGFuZGEg
d3JvdGU6DQo+ID4gc3l6Ym90IGlzIHJlcG9ydGluZyB1c2UtYWZ0ZXItZnJlZSByZWFkIGluIHRj
cF9yZXRyYW5zbWl0X3RpbWVyKCkgWzFdLA0KPiA+IGZvciBUQ1Agc29ja2V0IHVzZWQgYnkgUkRT
IGlzIGFjY2Vzc2luZyBzb2NrX25ldCgpIHdpdGhvdXQgYWNxdWlyaW5nIGENCj4gPiByZWZjb3Vu
dCBvbiBuZXQgbmFtZXNwYWNlLiBTaW5jZSBUQ1AncyByZXRyYW5zbWlzc2lvbiBjYW4gaGFwcGVu
IGFmdGVyDQo+ID4gYSBwcm9jZXNzIHdoaWNoIGNyZWF0ZWQgbmV0IG5hbWVzcGFjZSB0ZXJtaW5h
dGVkLCB3ZSBuZWVkIHRvIGV4cGxpY2l0bHkNCj4gPiBhY3F1aXJlIGEgcmVmY291bnQuDQo+ID4N
Cj4gPiBMaW5rOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/ZXh0aWQ9Njk0MTIw
ZTEwMDJjMTE3NzQ3ZWQgWzFdDQo+ID4gUmVwb3J0ZWQtYnk6IHN5emJvdCA8c3l6Ym90KzY5NDEy
MGUxMDAyYzExNzc0N2VkQHN5emthbGxlci5hcHBzcG90bWFpbC5jb20+DQo+ID4gRml4ZXM6IDI2
YWJlMTQzNzlmOGUyZmEgKCJuZXQ6IE1vZGlmeSBza19hbGxvYyB0byBub3QgcmVmZXJlbmNlIGNv
dW50IHRoZSBuZXRucyBvZiBrZXJuZWwgc29ja2V0cy4iKQ0KPiA+IEZpeGVzOiA4YTY4MTczNjkx
ZjAzNjYxICgibmV0OiBza19jbG9uZV9sb2NrKCkgc2hvdWxkIG9ubHkgZG8gZ2V0X25ldCgpIGlm
IHRoZSBwYXJlbnQgaXMgbm90IGENCj4ga2VybmVsIHNvY2tldCIpDQo+ID4gU2lnbmVkLW9mZi1i
eTogVGV0c3VvIEhhbmRhIDxwZW5ndWluLWtlcm5lbEBJLWxvdmUuU0FLVVJBLm5lLmpwPg0KPiA+
IFRlc3RlZC1ieTogc3l6Ym90IDxzeXpib3QrNjk0MTIwZTEwMDJjMTE3NzQ3ZWRAc3l6a2FsbGVy
LmFwcHNwb3RtYWlsLmNvbT4NCj4gPiAtLS0NCj4gPiBDaGFuZ2VzIGluIHYyOg0KPiA+ICAgQWRk
IEZpeGVzOiB0YWcuDQo+ID4gICBNb3ZlIHRvIGluc2lkZSBsb2NrX3NvY2soKSBzZWN0aW9uLg0K
PiA+DQo+ID4gSSBjaG9zZSAyNmFiZTE0Mzc5ZjhlMmZhIGFuZCA4YTY4MTczNjkxZjAzNjYxIHdo
aWNoIHdlbnQgdG8gNC4yIGZvciBGaXhlczogdGFnLA0KPiA+IGZvciByZWZjb3VudCB3YXMgaW1w
bGljaXRseSB0YWtlbiB3aGVuIDcwMDQxMDg4ZTNiOTc2NjIgKCJSRFM6IEFkZCBUQ1AgdHJhbnNw
b3J0DQo+ID4gdG8gUkRTIikgd2FzIGFkZGVkIHRvIDIuNi4zMi4NCj4gPg0KPiA+ICBuZXQvcmRz
L3RjcC5jIHwgOCArKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCsp
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3Jkcy90Y3AuYyBiL25ldC9yZHMvdGNwLmMNCj4g
PiBpbmRleCA1MzI3ZDEzMGM0YjUuLjJmNjM4ZjhiN2IxZSAxMDA2NDQNCj4gPiAtLS0gYS9uZXQv
cmRzL3RjcC5jDQo+ID4gKysrIGIvbmV0L3Jkcy90Y3AuYw0KPiA+IEBAIC00OTUsNiArNDk1LDE0
IEBAIHZvaWQgcmRzX3RjcF90dW5lKHN0cnVjdCBzb2NrZXQgKnNvY2spDQo+ID4NCj4gPiAgCXRj
cF9zb2NrX3NldF9ub2RlbGF5KHNvY2stPnNrKTsNCj4gPiAgCWxvY2tfc29jayhzayk7DQo+ID4g
KwkvKiBUQ1AgdGltZXIgZnVuY3Rpb25zIG1pZ2h0IGFjY2VzcyBuZXQgbmFtZXNwYWNlIGV2ZW4g
YWZ0ZXINCj4gPiArCSAqIGEgcHJvY2VzcyB3aGljaCBjcmVhdGVkIHRoaXMgbmV0IG5hbWVzcGFj
ZSB0ZXJtaW5hdGVkLg0KPiA+ICsJICovDQo+ID4gKwlpZiAoIXNrLT5za19uZXRfcmVmY250KSB7
DQo+ID4gKwkJc2stPnNrX25ldF9yZWZjbnQgPSAxOw0KPiA+ICsJCWdldF9uZXRfdHJhY2sobmV0
LCAmc2stPm5zX3RyYWNrZXIsIEdGUF9LRVJORUwpOw0KPiA+ICsJCXNvY2tfaW51c2VfYWRkKG5l
dCwgMSk7DQo+ID4gKwl9DQo+ID4gIAlpZiAocnRuLT5zbmRidWZfc2l6ZSA+IDApIHsNCj4gPiAg
CQlzay0+c2tfc25kYnVmID0gcnRuLT5zbmRidWZfc2l6ZTsNCj4gPiAgCQlzay0+c2tfdXNlcmxv
Y2tzIHw9IFNPQ0tfU05EQlVGX0xPQ0s7DQo+IA0KPiBUaGlzIGxvb2tzIGVxdWl2YWxlbnQgdG8g
dGhlIGZpeCBwcmVzZW50ZWQgaGVyZToNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fs
bC9DQU5uODlpKzQ4NGZmcWI5M2FRbTFOLXRqeHh2YjNXREtYMEViRDczMThSd1Jnc2F0andAbWFp
bC5nbWFpbC5jb20vDQo+IA0KPiBidXQgdGhlIGxhdHRlciBsb29rcyBhIG1vcmUgZ2VuZXJpYyBz
b2x1dGlvbi4gQFRldHN1byBjb3VsZCB5b3UgcGxlYXNlDQo+IHRlc3QgdGhlIGFib3ZlIGluIHlv
dXIgc2V0dXA/DQoNCldvdWxkbid0IGEgbW9yZSBnZW5lcmljIHNvbHV0aW9uIGJlIHRvIGFkZCBh
IGZsYWcgdG8gc29ja19jcmVhdGVfa2VybigpDQpzbyB0aGF0IGl0IGFjcXVpcmVzIGEgcmVmZXJl
bmNlIHRvIHRoZSBuYW1lc3BhY2U/DQpUaGlzIGNvdWxkIGJlIGEgYml0IG9uIG9uZSBvZiB0aGUg
ZXhpc3RpbmcgcGFyYW1ldGVycyAtIGxpa2UgU09DS19OT05CTE9DSy4NCg0KSSd2ZSBhIGRyaXZl
ciB0aGF0IHVzZXMgX19zb2NrX2NyZWF0ZSgpIGluIG9yZGVyIHRvIGdldCB0aGF0IHJlZmVyZW5j
ZS4NCkknbSBwcmV0dHkgc3VyZSB0aGUgZXh0cmEgJ3NlY3VyaXR5JyBjaGVjayB3aWxsIG5ldmVy
IGZhaWwuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

