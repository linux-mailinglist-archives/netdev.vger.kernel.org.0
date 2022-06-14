Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9B954A7D0
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 06:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbiFNEXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 00:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiFNEXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 00:23:39 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB32A251;
        Mon, 13 Jun 2022 21:23:35 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id B6B4B5FD06;
        Tue, 14 Jun 2022 07:23:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1655180612;
        bh=UgDB4oIyHwb+2ENFZYb+y44PmEnt5wBt6YnBuWTPn+g=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=XxkpFcZ+v6SVsgDcQ4/wh0xxpJwZemuUNrelHfW3n4cpLaJH+b4Mj7YnILj4i21cv
         Fvq/g23OJUNC7qifcg/SfIfZt/h3WNcyXmtgbi4Yt1Lk7uq9qdvZBIdyDb/7YKk0qT
         dq0SDLCWu09NRe++nzC5h0Rg6fnTFlENmz5PN/L7DuTKZj+W47nzKEsTYE+l9Q1CBI
         2G5qaWgok5XDVkt10VHwk9VrY79qipXuSkmPSca3VaPcD6kX6ZEWhPdmQOIwFPecl6
         gyfcz6d1e9lIMN6dwQG6bAxTf25bUhQdCf/J7O1OgpVgjzhi3c+P3F8vyOmkQP8g7x
         OByX1uaZHWGwg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Jun 2022 07:23:29 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 0/8] virtio/vsock: experimental zerocopy receive
Thread-Topic: [RFC PATCH v2 0/8] virtio/vsock: experimental zerocopy receive
Thread-Index: AQHYdwquMlGCdyA1qUCtor+NkIn5wa1GnK0AgAA9TQCABgv9AIABRqQA
Date:   Tue, 14 Jun 2022 04:23:25 +0000
Message-ID: <0883100c-1a40-537a-fb53-d33658383c8c@sberdevices.ru>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <20220609085428.idi4qzydhdpzszzw@sgarzare-redhat>
 <1c58ec1f-f991-4527-726a-9f45c2ff5684@sberdevices.ru>
 <20220613085420.e4limzn3dneuhu6y@sgarzare-redhat>
In-Reply-To: <20220613085420.e4limzn3dneuhu6y@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC5EFF7F1208E84F9459444415E52184@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/06/13 16:53:00 #19760221
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTMuMDYuMjAyMiAxMTo1NCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUaHUs
IEp1biAwOSwgMjAyMiBhdCAxMjozMzozMlBNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBPbiAwOS4wNi4yMDIyIDExOjU0LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+Pj4g
SGkgQXJzZW5peSwNCj4+PiBJIGxlZnQgc29tZSBjb21tZW50cyBpbiB0aGUgcGF0Y2hlcywgYW5k
IEknbSBhZGRpbmcgc29tZXRoaW5nIGFsc28gaGVyZToNCj4+IFRoYW5rcyBmb3IgY29tbWVudHMN
Cj4+Pg0KPj4+IE9uIEZyaSwgSnVuIDAzLCAyMDIyIGF0IDA1OjI3OjU2QU0gKzAwMDAsIEFyc2Vu
aXkgS3Jhc25vdiB3cm90ZToNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSU5UUk9EVUNUSU9ODQo+Pj4+DQo+Pj4+IMKgwqDCoMKg
SGVsbG8sIHRoaXMgaXMgZXhwZXJpbWVudGFsIGltcGxlbWVudGF0aW9uIG9mIHZpcnRpbyB2c29j
ayB6ZXJvY29weQ0KPj4+PiByZWNlaXZlLiBJdCB3YXMgaW5zcGlyZWQgYnkgVENQIHplcm9jb3B5
IHJlY2VpdmUgYnkgRXJpYyBEdW1hemV0LiBUaGlzIEFQSSB1c2VzDQo+Pj4+IHNhbWUgaWRlYTog
Y2FsbCAnbW1hcCgpJyBvbiBzb2NrZXQncyBkZXNjcmlwdG9yLCB0aGVuIGV2ZXJ5ICdnZXRzb2Nr
b3B0KCknIHdpbGwNCj4+Pj4gZmlsbCBwcm92aWRlZCB2bWEgYXJlYSB3aXRoIHBhZ2VzIG9mIHZp
cnRpbyBSWCBidWZmZXJzLiBBZnRlciByZWNlaXZlZCBkYXRhIHdhcw0KPj4+PiBwcm9jZXNzZWQg
YnkgdXNlciwgcGFnZXMgbXVzdCBiZSBmcmVlZCBieSAnbWFkdmlzZSgpJ8KgIGNhbGwgd2l0aCBN
QURWX0RPTlRORUVEDQo+Pj4+IGZsYWcgc2V0KGlmIHVzZXIgd29uJ3QgY2FsbCAnbWFkdmlzZSgp
JywgbmV4dCAnZ2V0c29ja29wdCgpJyB3aWxsIGZhaWwpLg0KPj4+DQo+Pj4gSWYgaXQgaXMgbm90
IHRvbyB0aW1lLWNvbnN1bWluZywgY2FuIHdlIGhhdmUgYSB0YWJsZS9saXN0IHRvIGNvbXBhcmUg
dGhpcyBhbmQgdGhlIFRDUCB6ZXJvY29weT8NCj4+IFlvdSBtZWFuIGNvbXBhcmUgQVBJIHdpdGgg
bW9yZSBkZXRhaWxzPw0KPiANCj4gWWVzLCBtYXliZSBhIGNvbXBhcmlzb24gZnJvbSB0aGUgdXNl
cidzIHBvaW50IG9mIHZpZXcgdG8gZG8gemVyby1jb3B5IHdpdGggVENQIGFuZCBWU09DSy4NCj4g
DQo+Pj4NCj4+Pj4NCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgREVUQUlMUw0KPj4+Pg0KPj4+PiDCoMKgwqDCoEhlcmUg
aXMgaG93IG1hcHBpbmcgd2l0aCBtYXBwZWQgcGFnZXMgbG9va3MgZXhhY3RseTogZmlyc3QgcGFn
ZSBtYXBwaW5nDQo+Pj4+IGNvbnRhaW5zIGFycmF5IG9mIHRyaW1tZWQgdmlydGlvIHZzb2NrIHBh
Y2tldCBoZWFkZXJzIChpbiBjb250YWlucyBvbmx5IGxlbmd0aA0KPj4+PiBvZiBkYXRhIG9uIHRo
ZSBjb3JyZXNwb25kaW5nIHBhZ2UgYW5kICdmbGFncycgZmllbGQpOg0KPj4+Pg0KPj4+PiDCoMKg
wqDCoHN0cnVjdCB2aXJ0aW9fdnNvY2tfdXNyX2hkciB7DQo+Pj4+IMKgwqDCoMKgwqDCoMKgIHVp
bnQzMl90IGxlbmd0aDsNCj4+Pj4gwqDCoMKgwqDCoMKgwqAgdWludDMyX3QgZmxhZ3M7DQo+Pj4+
IMKgwqDCoMKgwqDCoMKgIHVpbnQzMl90IGNvcHlfbGVuOw0KPj4+PiDCoMKgwqDCoH07DQo+Pj4+
DQo+Pj4+IEZpZWxkwqAgJ2xlbmd0aCcgYWxsb3dzIHVzZXIgdG8ga25vdyBleGFjdCBzaXplIG9m
IHBheWxvYWQgd2l0aGluIGVhY2ggc2VxdWVuY2UNCj4+Pj4gb2YgcGFnZXMgYW5kICdmbGFncycg
YWxsb3dzIHVzZXIgdG8gaGFuZGxlIFNPQ0tfU0VRUEFDS0VUIGZsYWdzKHN1Y2ggYXMgbWVzc2Fn
ZQ0KPj4+PiBib3VuZHMgb3IgcmVjb3JkIGJvdW5kcykuIEZpZWxkICdjb3B5X2xlbicgaXMgZGVz
Y3JpYmVkIGJlbG93IGluICd2MS0+djInIHBhcnQuDQo+Pj4+IEFsbCBvdGhlciBwYWdlcyBhcmUg
ZGF0YSBwYWdlcyBmcm9tIFJYIHF1ZXVlLg0KPj4+Pg0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIFBhZ2UgMMKgwqDCoMKgwqAgUGFnZSAxwqDCoMKgwqDCoCBQYWdlIE4NCj4+Pj4NCj4+Pj4g
wqDCoMKgwqBbIGhkcjEgLi4gaGRyTiBdWyBkYXRhIF0gLi4gWyBkYXRhIF0NCj4+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgIF7CoMKgwqDCoMKgwqDC
oMKgwqDCoCBeDQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqAgfMKgwqDC
oMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqAgfA0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
fMKgwqDCoMKgwqDCoMKgICotLS0tLS0tLS0tLS0tLS0tLS0tKg0KPj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8DQo+Pj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwNCj4+Pj4gwqDCoMKgwqDC
oMKgwqDCoMKgICotLS0tLS0tLS0tLS0tLS0tKg0KPj4+Pg0KPj4+PiDCoMKgwqDCoE9mIGNvdXJz
ZSwgc2luZ2xlIGhlYWRlciBjb3VsZCByZXByZXNlbnQgYXJyYXkgb2YgcGFnZXMgKHdoZW4gcGFj
a2V0J3MNCj4+Pj4gYnVmZmVyIGlzIGJpZ2dlciB0aGFuIG9uZSBwYWdlKS5TbyBoZXJlIGlzIGV4
YW1wbGUgb2YgZGV0YWlsZWQgbWFwcGluZyBsYXlvdXQNCj4+Pj4gZm9yIHNvbWUgc2V0IG9mIHBh
Y2thZ2VzLiBMZXRzIGNvbnNpZGVyIHRoYXQgd2UgaGF2ZSB0aGUgZm9sbG93aW5nIHNlcXVlbmNl
wqAgb2YNCj4+Pj4gcGFja2FnZXM6IDU2IGJ5dGVzLCA0MDk2IGJ5dGVzIGFuZCA4MjAwIGJ5dGVz
LiBBbGwgcGFnZXM6IDAsMSwyLDMsNCBhbmQgNSB3aWxsDQo+Pj4+IGJlIGluc2VydGVkIHRvIHVz
ZXIncyB2bWEodm1hIGlzIGxhcmdlIGVub3VnaCkuDQo+Pj4NCj4+PiBJbiBvcmRlciB0byBoYXZl
IGEgInVzZXJzcGFjZSBwb2xsaW5nLWZyaWVuZGx5IGFwcHJvYWNoIiBhbmQgcmVkdWNlIG51bWJl
ciBvZiBzeXNjYWxsLCBjYW4gd2UgYWxsb3cgZm9yIGV4YW1wbGUgdGhlIHVzZXJzcGFjZSB0byBt
bWFwIGF0IGxlYXN0IHRoZSBmaXJzdCBoZWFkZXIgYmVmb3JlIHBhY2tldHMgYXJyaXZlLg0KPj4+
IFRoZW4gdGhlIHVzZXJzcGFjZSBjYW4gcG9sbCBhIGZsYWcgb3Igb3RoZXIgZmllbGRzIGluIHRo
ZSBoZWFkZXIgdG8gdW5kZXJzdGFuZCB0aGF0IHRoZXJlIGFyZSBuZXcgcGFja2V0cy4NCj4+IFlv
dSBtZWFuIHRvIGF2b2lkICdwb2xsKCknIHN5c2NhbGwsIHVzZXIgd2lsbCBzcGluIG9uIHNvbWUg
ZmxhZywgcHJvdmlkZWQgYnkga2VybmVsIG9uIHNvbWUgbWFwcGVkIHBhZ2U/IEkgdGhpbmsgeWVz
LiBUaGlzIGlzIG9rLiBBbHNvIGkgdGhpbmssIHRoYXQgaSBjYW4gYXZvaWQgJ21hZHZpc2UnIGNh
bGwNCj4+IHRvIGNsZWFyIG1lbW9yeSBtYXBwaW5nIGJlZm9yZSBlYWNoICdnZXRzb2Nrb3B0KCkn
IC0gbGV0ICdnZXRzb2Nrb3B0KCknIGRvICdtYWR2aXNlKCknIGpvYiBieSByZW1vdmluZyBwYWdl
cyBmcm9tIHByZXZpb3VzIGRhdGEuIEluIHRoaXMgY2FzZSBvbmx5IG9uZSBzeXN0ZW0gY2FsbCBp
cyBuZWVkZWQgLSAnZ2V0c29ja29wdCgpJy4NCj4gDQo+IFllcywgdGhhdCdzIHJpZ2h0LiBJIG1l
YW4gdG8gc3VwcG9ydCBib3RoLCBwb2xsKCkgZm9yIGludGVycnVwdC1iYXNlZCBhcHBsaWNhdGlv
bnMgYW5kIHRoZSBhYmlsaXR5IHRvIGFjdGl2ZWx5IHBvbGwgYSB2YXJpYWJsZSBpbiB0aGUgc2hh
cmVkIG1lbW9yeSBmb3IgYXBwbGljYXRpb25zIHRoYXQgd2FudCB0byBtaW5pbWl6ZSBsYXRlbmN5
Lg0KSSBzZWUsIGluIHRoaXMgY2FzZSBzZWVtcyAndnNvY2tfc29jaycgd2lsbCBtYWludGFpbiBs
aXN0IG9mIHN1Y2ggc2hhcmVkIHBhZ2VzLCB0byB1cGRhdGUgZXZlcnkgcGFnZSB3aGVuIG5ldyBk
YXRhIGlzIGF2YWlsYWJsZS4gQW5kIHNvbWV0aW1lcyBjaGVjayB0aGF0IG1hcHBpbmcgd2FzIHJl
bW92ZWQNCmJ5IHVzZXIoYmVjYXVzZSB3ZSBkb24ndCBoYXZlIG11bm1hcCBjYWxsYmFjayBpbiAn
cHJvdG9fb3BzJywgbW1hcCBvbmx5KSwgZm9yIGV4YW1wbGUgdXNpbmcgcmVmIGNvdW50ZXIgZm9y
IHN1Y2ggc2hhcmVkIHBhZ2UuDQoNClRoYW5rcw0KPiANCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+
IA0KDQo=
