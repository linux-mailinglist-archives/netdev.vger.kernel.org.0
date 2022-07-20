Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2457B4D9
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiGTKxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiGTKx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:53:26 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCFC7173A;
        Wed, 20 Jul 2022 03:52:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id C851A5FD2F;
        Wed, 20 Jul 2022 13:52:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658314361;
        bh=Reu0fuSf+RtOwElI8k8f5OiCjMhFmisHomzOclTNIRc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=N3gwopGugWOONNgObmfj2QjNpW+/oJAJV9LTye8vjSxMraUowYebGdh1Wz0wFGbsb
         33flSeW587hQ/ouMb0rkf2DQQr1OTm0h+Ap+sWSPk4nWxnCrhgsjOKJJzaaBilDU+A
         RFufZyaWZFg2TeJxa0CY+K9AKGZOaCBnrgSvjazVD3ynqGETzUI2ecOPYSeLhznm1r
         ZYSx5whjO16VPBcLY448f2qWEW+s4psKD5/OG5NEjFEuDP4ZWINifEjW1OofeyWnzU
         gBqw4pogXwV366eG/inIA0IrMt5SrJBdeLbyi9aQZ0CCkBauw5dwVEKIzBnG6hQOL/
         VrISluw0z7WkQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 20 Jul 2022 13:52:37 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
Thread-Index: AQHYmn4tqUccpAClwkSIQKaYrjmRMa2Fd1UAgAEfggCAADh4gIAAFxCA
Date:   Wed, 20 Jul 2022 10:52:25 +0000
Message-ID: <3e954621-4496-17be-4b73-d0971372b8c5@sberdevices.ru>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <20220719125856.a6bfwrvy66gxxzqe@sgarzare-redhat>
 <ac05e1ee-23b3-75e0-f9a4-1056a68934d8@sberdevices.ru>
 <20220720093005.2unej4jnnvrn55f2@sgarzare-redhat>
In-Reply-To: <20220720093005.2unej4jnnvrn55f2@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7D43A9AB1AF3341827A5BC6EA70248A@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/20 09:26:00 #19927092
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAuMDcuMjAyMiAxMjozMCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBXZWQs
IEp1bCAyMCwgMjAyMiBhdCAwNjowNzo0N0FNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBPbiAxOS4wNy4yMDIyIDE1OjU4LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+Pj4g
T24gTW9uLCBKdWwgMTgsIDIwMjIgYXQgMDg6MTI6NTJBTSArMDAwMCwgQXJzZW5peSBLcmFzbm92
IHdyb3RlOg0KPj4+PiBIZWxsbywNCj4+Pj4NCj4+Pj4gZHVyaW5nIG15IGV4cGVyaW1lbnRzIHdp
dGggemVyb2NvcHkgcmVjZWl2ZSwgaSBmb3VuZCwgdGhhdCBpbiBzb21lDQo+Pj4+IGNhc2VzLCBw
b2xsKCkgaW1wbGVtZW50YXRpb24gdmlvbGF0ZXMgUE9TSVg6IHdoZW4gc29ja2V0IGhhcyBub24t
DQo+Pj4+IGRlZmF1bHQgU09fUkNWTE9XQVQoZS5nLiBub3QgMSksIHBvbGwoKSB3aWxsIGFsd2F5
cyBzZXQgUE9MTElOIGFuZA0KPj4+PiBQT0xMUkROT1JNIGJpdHMgaW4gJ3JldmVudHMnIGV2ZW4g
bnVtYmVyIG9mIGJ5dGVzIGF2YWlsYWJsZSB0byByZWFkDQo+Pj4+IG9uIHNvY2tldCBpcyBzbWFs
bGVyIHRoYW4gU09fUkNWTE9XQVQgdmFsdWUuIEluIHRoaXMgY2FzZSx1c2VyIHNlZXMNCj4+Pj4g
UE9MTElOIGZsYWcgYW5kIHRoZW4gdHJpZXMgdG8gcmVhZCBkYXRhKGZvciBleGFtcGxlIHVzaW5n
wqAgJ3JlYWQoKScNCj4+Pj4gY2FsbCksIGJ1dCByZWFkIGNhbGwgd2lsbCBiZSBibG9ja2VkLCBi
ZWNhdXNlwqAgU09fUkNWTE9XQVQgbG9naWMgaXMNCj4+Pj4gc3VwcG9ydGVkIGluIGRlcXVldWUg
bG9vcCBpbiBhZl92c29jay5jLiBCdXQgdGhlIHNhbWUgdGltZSzCoCBQT1NJWA0KPj4+PiByZXF1
aXJlcyB0aGF0Og0KPj4+Pg0KPj4+PiAiUE9MTElOwqDCoMKgwqAgRGF0YSBvdGhlciB0aGFuIGhp
Z2gtcHJpb3JpdHkgZGF0YSBtYXkgYmUgcmVhZCB3aXRob3V0DQo+Pj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGJsb2NraW5nLg0KPj4+PiBQT0xMUkROT1JNIE5vcm1hbCBkYXRhIG1heSBiZSByZWFk
IHdpdGhvdXQgYmxvY2tpbmcuIg0KPj4+Pg0KPj4+PiBTZWUgaHR0cHM6Ly93d3cub3Blbi1zdGQu
b3JnL2p0YzEvc2MyMi9vcGVuL240MjE3LnBkZiwgcGFnZSAyOTMuDQo+Pj4+DQo+Pj4+IFNvLCB3
ZSBoYXZlLCB0aGF0IHBvbGwoKSBzeXNjYWxsIHJldHVybnMgUE9MTElOLCBidXQgcmVhZCBjYWxs
IHdpbGwNCj4+Pj4gYmUgYmxvY2tlZC4NCj4+Pj4NCj4+Pj4gQWxzbyBpbiBtYW4gcGFnZSBzb2Nr
ZXQoNykgaSBmb3VuZCB0aGF0Og0KPj4+Pg0KPj4+PiAiU2luY2UgTGludXggMi42LjI4LCBzZWxl
Y3QoMiksIHBvbGwoMiksIGFuZCBlcG9sbCg3KSBpbmRpY2F0ZSBhDQo+Pj4+IHNvY2tldCBhcyBy
ZWFkYWJsZSBvbmx5IGlmIGF0IGxlYXN0IFNPX1JDVkxPV0FUIGJ5dGVzIGFyZSBhdmFpbGFibGUu
Ig0KPj4+Pg0KPj4+PiBJIGNoZWNrZWQgVENQIGNhbGxiYWNrIGZvciBwb2xsKCkobmV0L2lwdjQv
dGNwLmMsIHRjcF9wb2xsKCkpLCBpdA0KPj4+PiB1c2VzIFNPX1JDVkxPV0FUIHZhbHVlIHRvIHNl
dCBQT0xMSU4gYml0LCBhbHNvIGkndmUgdGVzdGVkIFRDUCB3aXRoDQo+Pj4+IHRoaXMgY2FzZSBm
b3IgVENQIHNvY2tldCwgaXQgd29ya3MgYXMgUE9TSVggcmVxdWlyZWQuDQo+Pj4NCj4+PiBJIHRy
aWVkIHRvIGxvb2sgYXQgdGhlIGNvZGUgYW5kIGl0IHNlZW1zIHRoYXQgb25seSBUQ1AgY29tcGxp
ZXMgd2l0aCBpdCBvciBhbSBJIHdyb25nPw0KPj4gWWVzLCBpIGNoZWNrZWQgQUZfVU5JWCwgaXQg
YWxzbyBkb24ndCBjYXJlIGFib3V0IHRoYXQuIEl0IGNhbGxzIHNrYl9xdWV1ZV9lbXB0eSgpIHRo
YXQgb2YNCj4+IGNvdXJzZSBpZ25vcmVzIFNPX1JDVkxPV0FULg0KPj4+DQo+Pj4+DQo+Pj4+IEkn
dmUgYWRkZWQgc29tZSBmaXhlcyB0byBhZl92c29jay5jIGFuZCB2aXJ0aW9fdHJhbnNwb3J0X2Nv
bW1vbi5jLA0KPj4+PiB0ZXN0IGlzIGFsc28gaW1wbGVtZW50ZWQuDQo+Pj4+DQo+Pj4+IFdoYXQg
ZG8gWW91IHRoaW5rIGd1eXM/DQo+Pj4NCj4+PiBOaWNlLCB0aGFua3MgZm9yIGZpeGluZyB0aGlz
IGFuZCBmb3IgdGhlIHRlc3QhDQo+Pj4NCj4+PiBJIGxlZnQgc29tZSBjb21tZW50cywgYnV0IEkg
dGhpbmsgdGhlIHNlcmllcyBpcyBmaW5lIGlmIHdlIHdpbGwgc3VwcG9ydCBpdCBpbiBhbGwgdHJh
bnNwb3J0cy4NCj4+IEFjaw0KPj4+DQo+Pj4gSSdkIGp1c3QgbGlrZSB0byB1bmRlcnN0YW5kIGlm
IGl0J3MganVzdCBUQ1AgY29tcGx5aW5nIHdpdGggaXQgb3IgSSdtIG1pc3Npbmcgc29tZSBjaGVj
ayBpbmNsdWRlZCBpbiB0aGUgc29ja2V0IGxheWVyIHRoYXQgd2UgY291bGQgcmV1c2UuDQo+PiBT
ZWVtcyBzb2NrX3BvbGwoKSB3aGljaCBpcyBzb2NrZXQgbGF5ZXIgZW50cnkgcG9pbnQgZm9yIHBv
bGwoKSBkb2Vzbid0IGNvbnRhaW4gYW55IHN1Y2ggY2hlY2tzDQo+Pj4NCj4+PiBARGF2aWQsIEBK
YWt1YiwgQFBhb2xvLCBhbnkgYWR2aWNlPw0KPj4+DQo+Pj4gVGhhbmtzLA0KPj4+IFN0ZWZhbm8N
Cj4+Pg0KPj4NCj4+IFBTOiBtb3Jlb3ZlciwgaSBmb3VuZCBvbmUgbW9yZSBpbnRlcmVzdGluZyB0
aGluZyB3aXRoIFRDUCBhbmQgcG9sbDogVENQIHJlY2VpdmUgbG9naWMgd2FrZXMgdXAgcG9sbCB3
YWl0ZXINCj4+IG9ubHkgd2hlbiBudW1iZXIgb2YgYXZhaWxhYmxlIGJ5dGVzID4gU09fUkNWTE9X
QVQuIEUuZy4gaXQgcHJldmVudHMgInNwdXJpb3VzIiB3YWtlIHVwcywgd2hlbiBwb2xsIHdpbGwg
YmUNCj4+IHdva2VuIHVwIGJlY2F1c2UgbmV3IGRhdGEgYXJyaXZlZCwgYnV0IFBPTExJTiB0byBh
bGxvdyB1c2VyIGRlcXVldWUgdGhpcyBkYXRhIHdvbid0IGJlIHNldChhcyBhbW91bnQgb2YgZGF0
YQ0KPj4gaXMgdG9vIHNtYWxsKS4NCj4+IFNlZSB0Y3BfZGF0YV9yZWFkeSgpIGluIG5ldC9pcHY0
L3RjcF9pbnB1dC5jDQo+IA0KPiBEbyB5b3UgbWVhbiB0aGF0IHdlIHNob3VsZCBjYWxsIHNrLT5z
a19kYXRhX3JlYWR5KHNrKSBjaGVja2luZyBTT19SQ1ZMT1dBVD8NClllcywgbGlrZSB0Y3BfZGF0
YV9yZWFkKCkuDQo+IA0KPiBJdCBzZWVtcyBmaW5lLCBtYXliZSB3ZSBjYW4gYWRkIHZzb2NrX2Rh
dGFfcmVhZHkoKSBpbiBhZl92c29jay5jIHRoYXQgdHJhbnNwb3J0cyBzaG91bGQgY2FsbCBpbnN0
ZWFkIG9mIGNhbGxpbmcgc2stPnNrX2RhdGFfcmVhZHkoc2spIGRpcmVjdGx5Lg0KWWVzLCB0aGlz
IHdpbGwgYWxzbyB1cGRhdGUgbG9naWMgaW4gdm1jaSBhbmQgaHlwZXJ2IHRyYW5zcG9ydHMNCj4g
DQo+IFRoZW4gd2UgY2FuIHNvbWV0aGluZyBzaW1pbGFyIHRvIHRjcF9kYXRhX3JlYWR5KCkuDQo+
IA0KPiBUaGFua3MsDQo+IFN0ZWZhbm8NCj4gDQoNCg==
