Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211CB57B0D0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbiGTGIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbiGTGIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:08:04 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAE06872B;
        Tue, 19 Jul 2022 23:08:02 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 9664B5FD30;
        Wed, 20 Jul 2022 09:08:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658297280;
        bh=jPmZtSU8mSGJMcL/aUVhmt1r9yC+Cy2vPtW5d7Pmaeo=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=NAIL0hPGnmaH6Z5zRiAaJDKOYlTyS94NhP2JnApnVyBr09iLWdzhorcIUh9PbtPSK
         8YM572klcFf0LvoM1SKdLeszyIKtKg3tBAzZYGvmYiMeIPvKCAYM0k2In3EqIKNjqM
         xMF6JLkCyVm1KRPo2Nj593uANC12dYx/Cdy/m5tn00p5JXA8zD0/mSUV1h+jw1oDL3
         BqsNbIuyYD6fbS2U/ty7d+hJqaA9eYPVqm7sP+yAXO14l7w13Emrl+dcKpbY+FD2tS
         F2UkfYRs4Y8TP3sBqAvssnOKQ8Gp0/CTPXIxXBwkmhsKwi3D7AiS3zPb52eptyior+
         FhuF9kKsqJt/Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 20 Jul 2022 09:07:59 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Thread-Topic: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Thread-Index: AQHYmn4tqUccpAClwkSIQKaYrjmRMa2Fd1UAgAEfggA=
Date:   Wed, 20 Jul 2022 06:07:47 +0000
Message-ID: <ac05e1ee-23b3-75e0-f9a4-1056a68934d8@sberdevices.ru>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <20220719125856.a6bfwrvy66gxxzqe@sgarzare-redhat>
In-Reply-To: <20220719125856.a6bfwrvy66gxxzqe@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C98D0D7F5C1ABC439235ABF83F2C9D0B@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/19 23:44:00 #19926989
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkuMDcuMjAyMiAxNTo1OCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAxOCwgMjAyMiBhdCAwODoxMjo1MkFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBIZWxsbywNCj4+DQo+PiBkdXJpbmcgbXkgZXhwZXJpbWVudHMgd2l0aCB6ZXJvY29weSBy
ZWNlaXZlLCBpIGZvdW5kLCB0aGF0IGluIHNvbWUNCj4+IGNhc2VzLCBwb2xsKCkgaW1wbGVtZW50
YXRpb24gdmlvbGF0ZXMgUE9TSVg6IHdoZW4gc29ja2V0IGhhcyBub24tDQo+PiBkZWZhdWx0IFNP
X1JDVkxPV0FUKGUuZy4gbm90IDEpLCBwb2xsKCkgd2lsbCBhbHdheXMgc2V0IFBPTExJTiBhbmQN
Cj4+IFBPTExSRE5PUk0gYml0cyBpbiAncmV2ZW50cycgZXZlbiBudW1iZXIgb2YgYnl0ZXMgYXZh
aWxhYmxlIHRvIHJlYWQNCj4+IG9uIHNvY2tldCBpcyBzbWFsbGVyIHRoYW4gU09fUkNWTE9XQVQg
dmFsdWUuIEluIHRoaXMgY2FzZSx1c2VyIHNlZXMNCj4+IFBPTExJTiBmbGFnIGFuZCB0aGVuIHRy
aWVzIHRvIHJlYWQgZGF0YShmb3IgZXhhbXBsZSB1c2luZ8KgICdyZWFkKCknDQo+PiBjYWxsKSwg
YnV0IHJlYWQgY2FsbCB3aWxsIGJlIGJsb2NrZWQsIGJlY2F1c2XCoCBTT19SQ1ZMT1dBVCBsb2dp
YyBpcw0KPj4gc3VwcG9ydGVkIGluIGRlcXVldWUgbG9vcCBpbiBhZl92c29jay5jLiBCdXQgdGhl
IHNhbWUgdGltZSzCoCBQT1NJWA0KPj4gcmVxdWlyZXMgdGhhdDoNCj4+DQo+PiAiUE9MTElOwqDC
oMKgwqAgRGF0YSBvdGhlciB0aGFuIGhpZ2gtcHJpb3JpdHkgZGF0YSBtYXkgYmUgcmVhZCB3aXRo
b3V0DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBibG9ja2luZy4NCj4+IFBPTExSRE5PUk0gTm9y
bWFsIGRhdGEgbWF5IGJlIHJlYWQgd2l0aG91dCBibG9ja2luZy4iDQo+Pg0KPj4gU2VlIGh0dHBz
Oi8vd3d3Lm9wZW4tc3RkLm9yZy9qdGMxL3NjMjIvb3Blbi9uNDIxNy5wZGYsIHBhZ2UgMjkzLg0K
Pj4NCj4+IFNvLCB3ZSBoYXZlLCB0aGF0IHBvbGwoKSBzeXNjYWxsIHJldHVybnMgUE9MTElOLCBi
dXQgcmVhZCBjYWxsIHdpbGwNCj4+IGJlIGJsb2NrZWQuDQo+Pg0KPj4gQWxzbyBpbiBtYW4gcGFn
ZSBzb2NrZXQoNykgaSBmb3VuZCB0aGF0Og0KPj4NCj4+ICJTaW5jZSBMaW51eCAyLjYuMjgsIHNl
bGVjdCgyKSwgcG9sbCgyKSwgYW5kIGVwb2xsKDcpIGluZGljYXRlIGENCj4+IHNvY2tldCBhcyBy
ZWFkYWJsZSBvbmx5IGlmIGF0IGxlYXN0IFNPX1JDVkxPV0FUIGJ5dGVzIGFyZSBhdmFpbGFibGUu
Ig0KPj4NCj4+IEkgY2hlY2tlZCBUQ1AgY2FsbGJhY2sgZm9yIHBvbGwoKShuZXQvaXB2NC90Y3Au
YywgdGNwX3BvbGwoKSksIGl0DQo+PiB1c2VzIFNPX1JDVkxPV0FUIHZhbHVlIHRvIHNldCBQT0xM
SU4gYml0LCBhbHNvIGkndmUgdGVzdGVkIFRDUCB3aXRoDQo+PiB0aGlzIGNhc2UgZm9yIFRDUCBz
b2NrZXQsIGl0IHdvcmtzIGFzIFBPU0lYIHJlcXVpcmVkLg0KPiANCj4gSSB0cmllZCB0byBsb29r
IGF0IHRoZSBjb2RlIGFuZCBpdCBzZWVtcyB0aGF0IG9ubHkgVENQIGNvbXBsaWVzIHdpdGggaXQg
b3IgYW0gSSB3cm9uZz8NClllcywgaSBjaGVja2VkIEFGX1VOSVgsIGl0IGFsc28gZG9uJ3QgY2Fy
ZSBhYm91dCB0aGF0LiBJdCBjYWxscyBza2JfcXVldWVfZW1wdHkoKSB0aGF0IG9mDQpjb3Vyc2Ug
aWdub3JlcyBTT19SQ1ZMT1dBVC4NCj4gDQo+Pg0KPj4gSSd2ZSBhZGRlZCBzb21lIGZpeGVzIHRv
IGFmX3Zzb2NrLmMgYW5kIHZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMsDQo+PiB0ZXN0IGlzIGFs
c28gaW1wbGVtZW50ZWQuDQo+Pg0KPj4gV2hhdCBkbyBZb3UgdGhpbmsgZ3V5cz8NCj4gDQo+IE5p
Y2UsIHRoYW5rcyBmb3IgZml4aW5nIHRoaXMgYW5kIGZvciB0aGUgdGVzdCENCj4gDQo+IEkgbGVm
dCBzb21lIGNvbW1lbnRzLCBidXQgSSB0aGluayB0aGUgc2VyaWVzIGlzIGZpbmUgaWYgd2Ugd2ls
bCBzdXBwb3J0IGl0IGluIGFsbCB0cmFuc3BvcnRzLg0KQWNrDQo+IA0KPiBJJ2QganVzdCBsaWtl
IHRvIHVuZGVyc3RhbmQgaWYgaXQncyBqdXN0IFRDUCBjb21wbHlpbmcgd2l0aCBpdCBvciBJJ20g
bWlzc2luZyBzb21lIGNoZWNrIGluY2x1ZGVkIGluIHRoZSBzb2NrZXQgbGF5ZXIgdGhhdCB3ZSBj
b3VsZCByZXVzZS4NClNlZW1zIHNvY2tfcG9sbCgpIHdoaWNoIGlzIHNvY2tldCBsYXllciBlbnRy
eSBwb2ludCBmb3IgcG9sbCgpIGRvZXNuJ3QgY29udGFpbiBhbnkgc3VjaCBjaGVja3MNCj4gDQo+
IEBEYXZpZCwgQEpha3ViLCBAUGFvbG8sIGFueSBhZHZpY2U/DQo+IA0KPiBUaGFua3MsDQo+IFN0
ZWZhbm8NCj4gDQoNClBTOiBtb3Jlb3ZlciwgaSBmb3VuZCBvbmUgbW9yZSBpbnRlcmVzdGluZyB0
aGluZyB3aXRoIFRDUCBhbmQgcG9sbDogVENQIHJlY2VpdmUgbG9naWMgd2FrZXMgdXAgcG9sbCB3
YWl0ZXINCm9ubHkgd2hlbiBudW1iZXIgb2YgYXZhaWxhYmxlIGJ5dGVzID4gU09fUkNWTE9XQVQu
IEUuZy4gaXQgcHJldmVudHMgInNwdXJpb3VzIiB3YWtlIHVwcywgd2hlbiBwb2xsIHdpbGwgYmUN
Cndva2VuIHVwIGJlY2F1c2UgbmV3IGRhdGEgYXJyaXZlZCwgYnV0IFBPTExJTiB0byBhbGxvdyB1
c2VyIGRlcXVldWUgdGhpcyBkYXRhIHdvbid0IGJlIHNldChhcyBhbW91bnQgb2YgZGF0YQ0KaXMg
dG9vIHNtYWxsKS4NClNlZSB0Y3BfZGF0YV9yZWFkeSgpIGluIG5ldC9pcHY0L3RjcF9pbnB1dC5j
DQoNClRoYW5rcw0K
