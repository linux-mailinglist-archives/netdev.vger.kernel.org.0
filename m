Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBF068B5E4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 07:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjBFG4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 01:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjBFG4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 01:56:47 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7F01BAFE;
        Sun,  5 Feb 2023 22:56:17 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0A8535FD0A;
        Mon,  6 Feb 2023 09:55:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666547;
        bh=jKp9H6Gl8+dpKJMrNsPP4bgIPg00ur5gUBmdQBd30+A=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=myKw0kJTJWPZcUUzr+ic9NSsNN78CsbnOLPu9EvN6QY+EwKU30KYqP3PP3UQnydSy
         2AtycgAaILRUybm61fyYNyv22cgvUKRD0Pgj+4LVIv4QllAEu8YnC/QxAiw6Q7AOne
         K7MR6Ha/2gzXYIizt54FPfllLYLM1mtXEo4a6w0Fv5d+2QmzcOYA1AkRtOfwvCVdvl
         Tia/7spzmxrC4p9vYDQ71nha5tRl84aPNaVpQGxNOfzLfl3IZQ/UPvl5YWMSWsWl/K
         ITraHe4ZRnWomtJCGXATOP9LcBTEUMIbUWQEyXeDOGUzzkX7RC+j4hHaIhHjflUdbp
         LlhPhj0eaufxw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 09:55:47 +0300 (MSK)
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
Subject: [RFC PATCH v1 03/12] vsock: check for MSG_ZEROCOPY support
Thread-Topic: [RFC PATCH v1 03/12] vsock: check for MSG_ZEROCOPY support
Thread-Index: AQHZOfgJ1YmcF1NMGkqzPZVVHI90wA==
Date:   Mon, 6 Feb 2023 06:55:46 +0000
Message-ID: <d6c8c90f-bf0b-b310-2737-27d3741f2043@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6875DB21EF0B2A4184A9CDEF0D4F4475@sberdevices.ru>
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

VGhpcyBmZWF0dXJlIHRvdGFsbHkgZGVwZW5kcyBvbiB0cmFuc3BvcnQsIHNvIGlmIHRyYW5zcG9y
dCBkb2Vzbid0DQpzdXBwb3J0IGl0LCByZXR1cm4gZXJyb3IuDQoNClNpZ25lZC1vZmYtYnk6IEFy
c2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogaW5jbHVkZS9u
ZXQvYWZfdnNvY2suaCAgIHwgMiArKw0KIG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyB8IDcgKysr
KysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9p
bmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZfdnNvY2suaA0KaW5kZXggNTY4
YTg3YzVlMGQwLi45NmQ4MjkwMDRjODEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL25ldC9hZl92c29j
ay5oDQorKysgYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQpAQCAtMTczLDYgKzE3Myw4IEBAIHN0
cnVjdCB2c29ja190cmFuc3BvcnQgew0KIA0KIAkvKiBBZGRyZXNzaW5nLiAqLw0KIAl1MzIgKCpn
ZXRfbG9jYWxfY2lkKSh2b2lkKTsNCisNCisJYm9vbCAoKm1zZ3plcm9jb3B5X2FsbG93KSh2b2lk
KTsNCiB9Ow0KIA0KIC8qKioqIENPUkUgKioqKi8NCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2Nr
L2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4IGY3NTJiMzBiNzFk
Ni4uZmIwZmNiMzkwMTEzIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQor
KysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC0xNzg4LDYgKzE3ODgsMTMgQEAgc3Rh
dGljIGludCB2c29ja19jb25uZWN0aWJsZV9zZW5kbXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0
cnVjdCBtc2doZHIgKm1zZywNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQorCWlmIChtc2ctPm1zZ19m
bGFncyAmIE1TR19aRVJPQ09QWSAmJg0KKwkgICAgKCF0cmFuc3BvcnQtPm1zZ3plcm9jb3B5X2Fs
bG93IHx8DQorCSAgICAgIXRyYW5zcG9ydC0+bXNnemVyb2NvcHlfYWxsb3coKSkpIHsNCisJCWVy
ciA9IC1FT1BOT1RTVVBQOw0KKwkJZ290byBvdXQ7DQorCX0NCisNCiAJLyogV2FpdCBmb3Igcm9v
bSBpbiB0aGUgcHJvZHVjZSBxdWV1ZSB0byBlbnF1ZXVlIG91ciB1c2VyJ3MgZGF0YS4gKi8NCiAJ
dGltZW91dCA9IHNvY2tfc25kdGltZW8oc2ssIG1zZy0+bXNnX2ZsYWdzICYgTVNHX0RPTlRXQUlU
KTsNCiANCi0tIA0KMi4yNS4xDQo=
