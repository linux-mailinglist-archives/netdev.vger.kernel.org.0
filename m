Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CE757B064
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 07:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiGTFfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 01:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGTFfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 01:35:40 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EFEBF7A;
        Tue, 19 Jul 2022 22:35:37 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 47A2A5FD2F;
        Wed, 20 Jul 2022 08:35:35 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658295335;
        bh=wHNiqnWd0RGmK5OZnjwp2crbkr5P/zdhM6NVaNYsCOQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=gn68/nJVFQ6ElcixJ0LQ4fXPSBGOOsY014funwjoBGLsHehO/RTlzkV7weMv1lbRT
         XII/ShcjR6txRA6qwuGEqiHH0mglNRelHLkzJe28qCkAzloEi55TQR4lsUEhPRLEDq
         CNaVCHv/EAFlriRQdM+r+JEE0+imjYqsTBgOwHjNSapXNFdCMLo+Gp5dbK9f/aup4Y
         byoM8IiykQQd27B8npH+TF93B76jtYZJ4HOrxXGRqBMfayQKcaQo0JiMcqzh5EpiuF
         eJoVTDUUsOnaDU7SzplTpzIQ5YsN6FsiHzLl30iUAXQOioKEpAzVes4GuHOAM4JYfI
         1gacomTDmgwtg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 20 Jul 2022 08:35:31 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 1/3] vsock: use sk_skrcvlowat to set
 POLLIN,POLLRDNORM, bits.
Thread-Topic: [RFC PATCH v1 1/3] vsock: use sk_skrcvlowat to set
 POLLIN,POLLRDNORM, bits.
Thread-Index: AQHYmn6SAU6pAMObZUmsS+bpsPqTqK2Fc0qAgAEaegA=
Date:   Wed, 20 Jul 2022 05:35:20 +0000
Message-ID: <8a8aa9e8-cc8f-41a6-504d-163a73231788@sberdevices.ru>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <637e945f-f28a-86d9-a242-1f4be85d9840@sberdevices.ru>
 <20220719124429.3y5hi7itx4hdkqbz@sgarzare-redhat>
In-Reply-To: <20220719124429.3y5hi7itx4hdkqbz@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <35B3DE191BA5A24DAD76A101E67E6C29@sberdevices.ru>
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

T24gMTkuMDcuMjAyMiAxNTo0NCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAxOCwgMjAyMiBhdCAwODoxNTo0MkFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBCb3RoIGJpdHMgaW5kaWNhdGUsIHRoYXQgbmV4dCBkYXRhIHJlYWQgY2FsbCB3b24ndCBi
ZSBibG9ja2VkLA0KPj4gYnV0IHdoZW4gc2tfcmN2bG93YXQgaXMgbm90IDEsdGhlc2UgYml0cyB3
aWxsIGJlIHNldCBieSBwb2xsDQo+PiBhbnl3YXksdGh1cyB3aGVuIHVzZXIgdHJpZXMgdG8gZGVx
dWV1ZSBkYXRhLCBpdCB3aWxsIHdhaXQgdW50aWwNCj4+IHNrX3Jjdmxvd2F0IGJ5dGVzIG9mIGRh
dGEgd2lsbCBiZSBhdmFpbGFibGUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFz
bm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+PiAtLS0NCj4+IG5ldC92bXdfdnNvY2sv
YWZfdnNvY2suYyB8IDIgKy0NCj4+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMg
Yi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+IGluZGV4IGYwNGFiZjY2MmVjNi4uMDIyNWYz
NTU4ZTMwIDEwMDY0NA0KPj4gLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+PiArKysg
Yi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+IEBAIC0xMDY3LDcgKzEwNjcsNyBAQCBzdGF0
aWMgX19wb2xsX3QgdnNvY2tfcG9sbChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHNvY2tldCAq
c29jaywNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIShzay0+c2tfc2h1dGRvd24gJiBSQ1Zf
U0hVVERPV04pKSB7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgZGF0YV9yZWFkeV9u
b3cgPSBmYWxzZTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHJldCA9IHRyYW5zcG9y
dC0+bm90aWZ5X3BvbGxfaW4oDQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdnNrLCAxLCAmZGF0YV9yZWFkeV9ub3cpOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHZzaywgc2stPnNrX3Jjdmxvd2F0LCAmZGF0YV9yZWFkeV9ub3cp
Ow0KPiANCj4gSW4gdGNwX3BvbGwoKSB3ZSBoYXZlIHRoZSBmb2xsb3dpbmc6DQo+IMKgwqDCoCBp
bnQgdGFyZ2V0ID0gc29ja19yY3Zsb3dhdChzaywgMCwgSU5UX01BWCk7DQo+IA0KPiBNYXliZSB3
ZSBjYW4gZG8gdGhlIHNhbWUgaGVyZS4NCg0KWW91IGFyZSByaWdodCwgYWNrDQoNCj4gDQo+IFRo
YW5rcywNCj4gU3RlZmFubw0KPiANCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCA8
IDApIHsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtYXNrIHw9IEVQT0xMRVJS
Ow0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9IGVsc2Ugew0KPj4gLS3CoA0KPj4gMi4yNS4x
DQo+IA0KDQo=
