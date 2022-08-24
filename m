Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9358859F22B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 05:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiHXDsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 23:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiHXDsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 23:48:37 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3298605E;
        Tue, 23 Aug 2022 20:48:31 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 639B65FD07;
        Wed, 24 Aug 2022 06:48:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1661312908;
        bh=fnA9Nt1Ywd1nfnWQwBPTMvpdGpF+Nr3h9cCXqMrnzrs=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=V+xDBjH5TQ6EnF5Fo4tIL7IrsLZhcXi0PW5MpOboStnRjdaAL2eYyZfY35m/ptZw6
         RTDENNeuQTAmNr8Zbt2bHqs5KCAmYDlNJk3dIxIWaNt5ob+CtyKZKq4BgAjNwKthFe
         5u5u0uj+RgLC81a1OR1Vww4xaZqGPmhoo/pkEb7CcpmtpEk2qap3UuQvvxD5gs/w6X
         pBJrB1jc55fZGP3JEkclhMYlAXwAYbr2diyXIzFM7GP3kKUy+M5aGRPTytcWNqtinO
         XPoRBUU0S5aB4ANUp9i7r5WSh5NZVH9hmmLAwZJnZe4akIx02yfrcNGUHveeXdL4iC
         ufJ0x/QpOiKfQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 24 Aug 2022 06:48:23 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYs4uayjgwUp42sUeXUj6ZEfA4aa28r6kAgAABUQCAABQAgIAAB2yAgABy74A=
Date:   Wed, 24 Aug 2022 03:48:13 +0000
Message-ID: <7f3bce7a-2b20-0760-5695-f103fbff0b1f@sberdevices.ru>
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
 <YwUnAhWauSFSJX+g@fedora> <20220823121852.1fde7917@kernel.org>
 <YwU443jzc/N4fV3A@fedora>
 <5174d4ef7fe3928472d5a575c87ee627bfb4c129.camel@redhat.com>
In-Reply-To: <5174d4ef7fe3928472d5a575c87ee627bfb4c129.camel@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F7891390FDB5C48949731F677295938@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/23 22:02:00 #20146374
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMuMDguMjAyMiAyMzo1NywgUGFvbG8gQWJlbmkgd3JvdGU6DQo+IE9uIFR1ZSwgMjAyMi0w
OC0yMyBhdCAxNjozMCAtMDQwMCwgU3RlZmFuIEhham5vY3ppIHdyb3RlOg0KPj4gT24gVHVlLCBB
dWcgMjMsIDIwMjIgYXQgMTI6MTg6NTJQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+
Pj4gT24gVHVlLCAyMyBBdWcgMjAyMiAxNToxNDoxMCAtMDQwMCBTdGVmYW4gSGFqbm9jemkgd3Jv
dGU6DQo+Pj4+IFN0ZWZhbm8gd2lsbCBiZSBvbmxpbmUgYWdhaW4gb24gTW9uZGF5LiBJIHN1Z2dl
c3Qgd2Ugd2FpdCBmb3IgaGltIHRvDQo+Pj4+IHJldmlldyB0aGlzIHNlcmllcy4gSWYgaXQncyB1
cmdlbnQsIHBsZWFzZSBsZXQgbWUga25vdyBhbmQgSSdsbCB0YWtlIGENCj4+Pj4gbG9vay4NCkhp
LA0KDQpzdXJlLCBub3RoaW5nIHVyZ2VudCwgbm8gcHJvYmxlbS4gTGV0J3Mgd2FpdCBmb3IgU3Rl
ZmFubyEgSXMgdGhlcmUgc29tZXRoaW5nDQp3cm9uZyB3aXRoIHRoaXMgcGF0Y2hzZXQ/IEkndmUg
cmVwbGFjZWQgUkZDIC0+IG5ldC1uZXh0IHNpbmNlIFN0ZWZhbm8gcmV2aWV3ZWQNCmFsbCBwYXRj
aGVzIGV4Y2VwdCAwMDAxIGFuZCBzdWdnZXN0ZWQgdG8gdXNlIG5ldC1uZXh0IGluIHY0Lg0KPj4+
DQo+Pj4gSXQgd2FzIGFscmVhZHkgYXBwbGllZCwgc29ycnkgYWJvdXQgdGhhdC4gQnV0IHBsZWFz
ZSBjb250aW51ZSB3aXRoDQo+Pj4gcmV2aWV3IGFzIGlmIGl0IHdhc24ndC4gV2UnbGwganVzdCBy
ZXZlcnQgYmFzZWQgb24gU3RlZmFubydzIGZlZWRiYWNrDQo+Pj4gYXMgbmVlZGVkLg0KPj4NCj4+
IE9rYXksIG5vIHByb2JsZW0uDQo+IA0KPiBGb3IgdGhlIHJlY29yZHMsIEkgYXBwbGllZCB0aGUg
c2VyaWVzIHNpbmNlIGl0IGxvb2tlZCB0byBtZSBBcnNlbml5DQo+IGFkZHJlc3NlZCBhbGwgdGhl
IGZlZWRiYWNrIGZyb20gU3RlZmFubyBvbiB0aGUgZmlyc3QgcGF0Y2ggKHRoZSBvbmx5DQo+IG9u
ZSBzdGlsbCBsYWNraW5nIGFuIGFja2VkLWJ5L3Jldmlld2VkLWJ5IHRhZykgYW5kIEkgdGhvdWdo
dCBpdCB3b3VsZA0KPiBiZSBiZXR0ZXIgYXZvaWRpbmcgc3VjaCBkZWxheS4NClllcywgb25seSAw
MDAxIGxhY2tzIHJldmlld2VkLWJ5DQo+IA0KPiBXZSBhcmUgc3RpbGwgZWFybHkgaW4gdGhpcyBu
ZXQtbmV4dCBjeWNsZSwgSSB0aGluayBpdCBjYW4gYmUgaW1wcm92ZWQNCj4gaW5jcmVtZW50YWxs
eSBhcyBuZWVkZWQuDQo+IA0KPiBQYW9sbw0KPiANClRoYW5rIFlvdSwgQXJzZW5peQ0KDQo=
