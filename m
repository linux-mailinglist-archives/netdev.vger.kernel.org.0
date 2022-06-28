Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4122955E675
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346674AbiF1Nkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346651AbiF1Nkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:40:51 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80707240B6
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:40:50 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-50-YWi63-uoNrW8kmPB3ciyCQ-1; Tue, 28 Jun 2022 14:40:35 +0100
X-MC-Unique: YWi63-uoNrW8kmPB3ciyCQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 28 Jun 2022 14:38:07 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 28 Jun 2022 14:38:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christian Brauner' <brauner@kernel.org>,
        Ralph Corderoy <ralph@inputplus.co.uk>
CC:     Matthew Wilcox <willy@infradead.org>,
        Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Jeff Layton" <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH v2] Implement close-on-fork
Thread-Topic: [PATCH v2] Implement close-on-fork
Thread-Index: AQHYivDThpuxuu360k2l3JKLwphwnK1k0dbQ
Date:   Tue, 28 Jun 2022 13:38:07 +0000
Message-ID: <35d0facc934748f995c2e7ab695301f7@AcuMS.aculab.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
 <20220618114111.61EC71F981@orac.inputplus.co.uk>
 <Yq4qIxh5QnhQZ0SJ@casper.infradead.org>
 <20220619104228.A9789201F7@orac.inputplus.co.uk>
 <20220628131304.gbiqqxamg6pmvsxf@wittgenstein>
In-Reply-To: <20220628131304.gbiqqxamg6pmvsxf@wittgenstein>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMjggSnVuZSAyMDIyIDE0OjEzDQo+IA0K
PiBPbiBTdW4sIEp1biAxOSwgMjAyMiBhdCAxMTo0MjoyOEFNICswMTAwLCBSYWxwaCBDb3JkZXJv
eSB3cm90ZToNCj4gPiBIaSBNYXR0aGV3LCB0aGFua3MgZm9yIHJlcGx5aW5nLg0KPiA+DQo+ID4g
PiA+IFRoZSBuZWVkIGZvciBPX0NMT0ZPUksgbWlnaHQgYmUgbWFkZSBtb3JlIGNsZWFyIGJ5IGxv
b2tpbmcgYXQgYQ0KPiA+ID4gPiBsb25nLXN0YW5kaW5nIEdvIGlzc3VlLCBpLmUuIHVucmVsYXRl
ZCB0byBzeXN0ZW0oMyksIHdoaWNoIHdhcyBzdGFydGVkDQo+ID4gPiA+IGluIDIwMTcgYnkgUnVz
cyBDb3ggd2hlbiBoZSBzdW1tZWQgdXAgdGhlIGN1cnJlbnQgcmFjZS1jb25kaXRpb24NCj4gPiA+
ID4gYmVoYXZpb3VyIG9mIHRyeWluZyB0byBleGVjdmUoMikgYSBuZXdseSBjcmVhdGVkIGZpbGU6
DQo+ID4gPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9nb2xhbmcvZ28vaXNzdWVzLzIyMzE1Lg0KPiA+
ID4NCj4gPiA+IFRoZSBwcm9ibGVtIGlzIHRoYXQgcGVvcGxlIGFkdm9jYXRpbmcgZm9yIE9fQ0xP
Rk9SSyB1bmRlcnN0YW5kIGl0cw0KPiA+ID4gdmFsdWUsIGJ1dCBub3QgaXRzIGNvc3QuICBPdGhl
ciBnb29nbGUgZW1wbG95ZWVzIGhhdmUgYSBzeXN0ZW0gd2hpY2gNCj4gPiA+IGhhcyBsaXRlcmFs
bHkgbWlsbGlvbnMgb2YgZmlsZSBkZXNjcmlwdG9ycyBpbiBhIHNpbmdsZSBwcm9jZXNzLg0KPiA+
ID4gSGF2aW5nIHRvIG1haW50YWluIHRoaXMgZXh0cmEgc3RhdGUgcGVyLWZkIGlzIGEgY29zdCB0
aGV5IGRvbid0IHdhbnQNCj4gPiA+IHRvIHBheSAoYW5kIGhhdmUgYmVlbiBxdWl0ZSB2b2NhbCBh
Ym91dCBlYXJsaWVyIGluIHRoaXMgdGhyZWFkKS4NCj4gPg0KPiA+IFNvIGRvIHlvdSBhZ3JlZSB0
aGUgdXNlcnNwYWNlIGlzc3VlIGlzIGJlc3Qgc29sdmVkIGJ5ICpfQ0xPRk9SSyBhbmQgdGhlDQo+
ID4gcHJvYmxlbSBpcyBob3cgdG8gaW1wbGVtZW50ICpfQ0xPRk9SSyBhdCBhbiBhY2NlcHRhYmxl
IGNvc3Q/DQo+ID4NCj4gPiBPVE9IIERhdmlkIExhaWdodCB3YXMgbWFraW5nIHN1Z2dlc3Rpb25z
IG9uIG1vdmluZyB0aGUgbG9hZCB0byB0aGUNCj4gPiBmb3JrL2V4ZWMgcGF0aCBlYXJsaWVyIGlu
IHRoZSB0aHJlYWQsIGJ1dCBPVE9IIEFsIFZpcm8gbWVudGlvbmVkIGENCj4gPiDigJhwb3J0YWJs
ZSBzb2x1dGlvbuKAmSwgdGhvdWdoIHRoYXQgY291bGQgaGF2ZSBiZWVuIHRvIGEgc3BlY2lmaWMg
aXNzdWUNCj4gPiByYXRoZXIgdGhhbiB0aGUgbW9yZSBnZW5lcmFsIGNhc2UuDQo+ID4NCj4gPiBI
b3cgd291bGQgeW91IHJlY29tbWVuZCBhcHByb2FjaGluZyBhbiBhY2NlcHRhYmxlIGNvc3QgaXMg
cHJvZ3Jlc3NlZD8NCj4gPiBJdGVyYXRlIG9uIHBhdGNoIHZlcnNpb25zPyAgT3BlbiBhIGJ1Z3pp
bGxhLmtlcm5lbC5vcmcgZm9yIGNlbnRyYWwNCj4gPiB0cmFja2luZyBhbmQgbGlua2luZyBmcm9t
IHRoZSBvdGhlciBwcm9qZWN0cz8gIC4uPw0KPiANCj4gUXVvdGluZyBmcm9tIHRoYXQgZ28gdGhy
ZWFkDQo+IA0KPiAiSWYgdGhlIE9TIGhhZCBhICJjbG9zZSBhbGwgZmRzIGFib3ZlIHgiLCB3ZSBj
b3VsZCB1c2UgdGhhdC4gKEkgZG9uJ3Qga25vdyBvZiBhbnkgdGhhdCBkbywgYnV0IGl0IHN1cmUN
Cj4gd291bGQgaGVscC4pIg0KPiANCj4gU28gd2h5IGNhbid0IHRoaXMgYmUgc29sdmVkIHdpdGg6
DQo+IGNsb3NlX3JhbmdlKGZkX2ZpcnN0LCBmZF9sYXN0LCBDTE9TRV9SQU5HRV9DTE9FWEVDIHwg
Q0xPU0VfUkFOR0VfVU5TSEFSRSk/DQo+IGUuZy4NCj4gY2xvc2VfcmFuZ2UoMTAwLCB+MFUsIENM
T1NFX1JBTkdFX0NMT0VYRUMgfCBDTE9TRV9SQU5HRV9VTlNIQVJFKT8NCg0KVGhhdCBpcyBhIHJl
bGF0aXZlbHkgcmVjZW50IGxpbnV4IHN5c3RlbSBjYWxsLg0KQWx0aG91Z2ggaXQgY2FuIGJlICht
b3N0bHkpIGVtdWxhdGVkIGJ5IHJlYWRpbmcgL3Byb2MvZmQNCi0gYnV0IHRoYXQgbWF5IG5vdCBi
ZSBtb3VudGVkLg0KDQpJbiBhbnkgY2FzZSBhbm90aGVyIHRocmVhZCBjYW4gb3BlbiBhbiBmZCBi
ZXR3ZWVuIHRoZSBjbG9zZV9yYW5nZSgpDQphbmQgZm9yaygpIGNhbGxzLg0KDQooSSBjYW4ndCBy
ZW1lbWJlciB3aGF0IEkgc2FpZCBiZWZvcmUgOi0pDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVk
IEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5l
cywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

