Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C330168B5ED
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 07:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBFG6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 01:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjBFG6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 01:58:52 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412CF193F7;
        Sun,  5 Feb 2023 22:58:26 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9C6BE5FD03;
        Mon,  6 Feb 2023 09:58:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666704;
        bh=gM89Sds61a/Ke4wkFmjf14TzPo7acoM8k0Ezfh/OfTE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=c6de/MpSk/4xBtTgl+FzdDqL4UQ8O5WOgcgBI394fValuTI9p58AwowKSqDOZ/lXn
         QD9TyM4RcoP9LztoDZWlf7cdBMILvlcrQla9VlTO4SLx3WmmUGBPZBNTDJy6rT+kVB
         3gvXKIeKzZYiyr3Dwr7FXUVthyCyugQnK8PP8VHd3IzPkaI4oaVdv/BtJ/nZusHnob
         NyyIO67bd2t0wrPJagdL8EuwKxYscc3iwc2Ag2i1zN5U56brTP7DoI4I9NmGpPSZdP
         Uryemcx0D+wdJq3E9LQH6QGAwheuKy+lLP08eXqQ8tucs4vQoxZ0StrIytrXrUOEpZ
         9cQ86pcyNzbGg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 09:58:24 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 05/12] vsock/virtio: non-linear skb support
Thread-Topic: [RFC PATCH v1 05/12] vsock/virtio: non-linear skb support
Thread-Index: AQHZOfhn3a4rtLPBJ0ikS/zrL9u2kw==
Date:   Mon, 6 Feb 2023 06:58:24 +0000
Message-ID: <b3060caf-df19-f1df-6d27-4e58f894c417@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C7B0332DEEF004C81506DE1E7C21622@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/02/06 01:18:00 #20834045
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VXNlIHBhZ2VzIG9mIG5vbi1saW5lYXIgc2tiIGFzIGJ1ZmZlcnMgaW4gdmlydGlvIHR4IHF1ZXVl
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNl
cy5ydT4NCi0tLQ0KIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIHwgMzEgKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay92aXJ0aW9f
dHJhbnNwb3J0LmMgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYw0KaW5kZXggMjhi
NWE4ZThlMDk0Li5iOGE3ZDZkYzlmNDYgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL3ZpcnRp
b190cmFuc3BvcnQuYw0KKysrIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCkBA
IC0xMDAsNyArMTAwLDggQEAgdmlydGlvX3RyYW5zcG9ydF9zZW5kX3BrdF93b3JrKHN0cnVjdCB3
b3JrX3N0cnVjdCAqd29yaykNCiAJdnEgPSB2c29jay0+dnFzW1ZTT0NLX1ZRX1RYXTsNCiANCiAJ
Zm9yICg7Oykgew0KLQkJc3RydWN0IHNjYXR0ZXJsaXN0IGhkciwgYnVmLCAqc2dzWzJdOw0KKwkJ
c3RydWN0IHNjYXR0ZXJsaXN0ICpzZ3NbTUFYX1NLQl9GUkFHUyArIDFdOw0KKwkJc3RydWN0IHNj
YXR0ZXJsaXN0IGJ1ZnNbTUFYX1NLQl9GUkFHUyArIDFdOw0KIAkJaW50IHJldCwgaW5fc2cgPSAw
LCBvdXRfc2cgPSAwOw0KIAkJc3RydWN0IHNrX2J1ZmYgKnNrYjsNCiAJCWJvb2wgcmVwbHk7DQpA
QCAtMTExLDEyICsxMTIsMzAgQEAgdmlydGlvX3RyYW5zcG9ydF9zZW5kX3BrdF93b3JrKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yaykNCiANCiAJCXZpcnRpb190cmFuc3BvcnRfZGVsaXZlcl90YXBf
cGt0KHNrYik7DQogCQlyZXBseSA9IHZpcnRpb192c29ja19za2JfcmVwbHkoc2tiKTsNCisJCXNn
X2luaXRfb25lKCZidWZzWzBdLCB2aXJ0aW9fdnNvY2tfaGRyKHNrYiksIHNpemVvZigqdmlydGlv
X3Zzb2NrX2hkcihza2IpKSk7DQorCQlzZ3Nbb3V0X3NnKytdID0gJmJ1ZnNbMF07DQorDQorCQlp
ZiAoc2tiX2lzX25vbmxpbmVhcihza2IpKSB7DQorCQkJaW50IGk7DQorDQorCQkJZm9yIChpID0g
MDsgaSA8IHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3M7IGkrKykgew0KKwkJCQlzdHJ1Y3QgcGFn
ZSAqZGF0YV9wYWdlID0gc2tiX3NoaW5mbyhza2IpLT5mcmFnc1tpXS5idl9wYWdlOw0KKw0KKwkJ
CQkvKiBXZSB3aWxsIHVzZSAncGFnZV90b192aXJ0KCknIGZvciB1c2Vyc3BhY2UgcGFnZSBoZXJl
LA0KKwkJCQkgKiBiZWNhdXNlIHZpcnRpbyBsYXllciB3aWxsIGNhbGwgJ3ZpcnRfdG9fcGh5cygp
JyBsYXRlcg0KKwkJCQkgKiB0byBmaWxsIGJ1ZmZlciBkZXNjcmlwdG9yLiBXZSBkb24ndCB0b3Vj
aCBtZW1vcnkgYXQNCisJCQkJICogInZpcnR1YWwiIGFkZHJlc3Mgb2YgdGhpcyBwYWdlLg0KKwkJ
CQkgKi8NCisJCQkJc2dfaW5pdF9vbmUoJmJ1ZnNbaSArIDFdLA0KKwkJCQkJICAgIHBhZ2VfdG9f
dmlydChkYXRhX3BhZ2UpLCBQQUdFX1NJWkUpOw0KKwkJCQlzZ3Nbb3V0X3NnKytdID0gJmJ1ZnNb
aSArIDFdOw0KKwkJCX0NCisJCX0gZWxzZSB7DQorCQkJaWYgKHNrYi0+bGVuID4gMCkgew0KKwkJ
CQlzZ19pbml0X29uZSgmYnVmc1sxXSwgc2tiLT5kYXRhLCBza2ItPmxlbik7DQorCQkJCXNnc1tv
dXRfc2crK10gPSAmYnVmc1sxXTsNCisJCQl9DQogDQotCQlzZ19pbml0X29uZSgmaGRyLCB2aXJ0
aW9fdnNvY2tfaGRyKHNrYiksIHNpemVvZigqdmlydGlvX3Zzb2NrX2hkcihza2IpKSk7DQotCQlz
Z3Nbb3V0X3NnKytdID0gJmhkcjsNCi0JCWlmIChza2ItPmxlbiA+IDApIHsNCi0JCQlzZ19pbml0
X29uZSgmYnVmLCBza2ItPmRhdGEsIHNrYi0+bGVuKTsNCi0JCQlzZ3Nbb3V0X3NnKytdID0gJmJ1
ZjsNCiAJCX0NCiANCiAJCXJldCA9IHZpcnRxdWV1ZV9hZGRfc2dzKHZxLCBzZ3MsIG91dF9zZywg
aW5fc2csIHNrYiwgR0ZQX0tFUk5FTCk7DQotLSANCjIuMjUuMQ0K
