Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2349D583862
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiG1GE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiG1GE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:04:57 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CE65C952;
        Wed, 27 Jul 2022 23:04:51 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 565445FD0D;
        Thu, 28 Jul 2022 09:04:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658988289;
        bh=MoEuNgethiYS1LyovyEQkePt4IF0Rd4EfDLSvvIR3tU=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=HjQ+X93Dlp5K0j56HqHFvWdixdQMCd2tusGXewSlLr+gpH4QzJ+ufmFfeavAoqWqu
         TECFjSNH66CQpoKWUlu9oAt2nTicz/f7jYjGEaCC7E2OXCctj/W2txY4NBN3wS72dQ
         GOJ5ioRC1PPUrW74/S1yY5mRVlWnc5KJGs9bICR0WYlAdvetJ4i7HUWroQhwmvIrLM
         uhJ0lEd2xJCYGpGPrOqrQcNP3zslWGRefz3Y+dIDQDf6Us062YREuSqw1RNnpb8MJh
         Owri1gz5iqp9z7HxHijAcqHa4GmEMdvfwx/2DObsofzLfZTm/tg9k1RvmZmlC09d4m
         8xHcqxjzTLnvw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 28 Jul 2022 09:04:44 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 1/9] vsock: use sk_rcvlowat to set
 POLLIN/POLLRDNORM
Thread-Topic: [RFC PATCH v2 1/9] vsock: use sk_rcvlowat to set
 POLLIN/POLLRDNORM
Thread-Index: AQHYn/weV9iJ1kN02k+zjfwbZg+yc62R81OAgAEqRoA=
Date:   Thu, 28 Jul 2022 06:04:25 +0000
Message-ID: <bc6328cf-ddf8-5e7c-31d9-ea346c81c5b0@sberdevices.ru>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <aafc654d-5b42-aa18-bf74-f5277d549f73@sberdevices.ru>
 <20220727121709.z26dspwegqeiv55x@sgarzare-redhat>
In-Reply-To: <20220727121709.z26dspwegqeiv55x@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CD917DE2BA46949973DDFDA04BE97E5@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/28 02:09:00 #19985101
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcuMDcuMjAyMiAxNToxNywgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAyNSwgMjAyMiBhdCAwNzo1Njo1OUFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBCb3RoIGJpdHMgaW5kaWNhdGUsIHRoYXQgbmV4dCBkYXRhIHJlYWQgY2FsbCB3b24ndCBi
ZSBibG9ja2VkLCBidXQgd2hlbg0KPj4gc2tfcmN2bG93YXQgaXMgbm90IDEsIHRoZXNlIGJpdHMg
d2lsbCBiZSBzZXQgYnkgcG9sbCBhbnl3YXksIHRodXMgd2hlbg0KPj4gdXNlciB0cmllcyB0byBk
ZXF1ZXVlIGRhdGEsaXQgd2lsbCB3YWl0IHVudGlsIHNrX3Jjdmxvd2F0IGJ5dGVzIG9mIGRhdGEN
Cj4+IHdpbGwgYmUgYXZhaWxhYmxlLg0KPj4NCj4gDQo+IFRoZSBwYXRjaCBMR1RNLCBidXQgSSBz
dWdnZXN0IHlvdSB0byByZXdyaXRlIHRoZSB0aXRsZSBhbmQgY29tbWl0IG9mIHRoZSBtZXNzYWdl
IHRvIGJldHRlciBleHBsYWluIHdoYXQgdGhpcyBwYXRjaCBkb2VzIChwYXNzIHNvY2tfcmN2bG93
YXQgdG8gbm90aWZ5X3BvbGxfaW4gYXMgdGFyZ2V0KSBhbmQgdGhlbiBleHBsYWluIHdoeSBhcyB5
b3UgYWxyZWFkeSBkaWQgKHRvIHNldCBQT0xMSU4vUE9MTFJETk9STSBvbmx5IHdoZW4gdGFyZ2V0
IGlzIHJlYWNoZWQpLg0KT2ssIGkgc2VlLiBBY2sNCj4gDQo+IFRoYW5rcywNCj4gU3RlZmFubw0K
PiANCj4+IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZp
Y2VzLnJ1Pg0KPj4gLS0tDQo+PiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgfCAzICsrLQ0KPj4g
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRp
ZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zz
b2NrLmMNCj4+IGluZGV4IGYwNGFiZjY2MmVjNi4uNjNhMTNmYTI2ODZhIDEwMDY0NA0KPj4gLS0t
IGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+PiArKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zz
b2NrLmMNCj4+IEBAIC0xMDY2LDggKzEwNjYsOSBAQCBzdGF0aWMgX19wb2xsX3QgdnNvY2tfcG9s
bChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHNvY2tldCAqc29jaywNCj4+IMKgwqDCoMKgwqDC
oMKgIGlmICh0cmFuc3BvcnQgJiYgdHJhbnNwb3J0LT5zdHJlYW1faXNfYWN0aXZlKHZzaykgJiYN
Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIShzay0+c2tfc2h1dGRvd24gJiBSQ1ZfU0hVVERP
V04pKSB7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgZGF0YV9yZWFkeV9ub3cgPSBm
YWxzZTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCB0YXJnZXQgPSBzb2NrX3Jjdmxv
d2F0KHNrLCAwLCBJTlRfTUFYKTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHJldCA9
IHRyYW5zcG9ydC0+bm90aWZ5X3BvbGxfaW4oDQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdnNrLCAxLCAmZGF0YV9yZWFkeV9ub3cpOw0KPj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZzaywgdGFyZ2V0LCAmZGF0YV9yZWFkeV9ub3cp
Ow0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0IDwgMCkgew0KPj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1hc2sgfD0gRVBPTExFUlI7DQo+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIH0gZWxzZSB7DQo+PiAtLcKgDQo+PiAyLjI1LjENCj4gDQoNCg==
