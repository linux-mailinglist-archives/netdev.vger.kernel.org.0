Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E626663DA7
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjAJKNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjAJKN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:13:26 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C3EC759;
        Tue, 10 Jan 2023 02:13:25 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 08CBD5FD07;
        Tue, 10 Jan 2023 13:13:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1673345604;
        bh=iOSW3XOkz3vBuWBorAhdOl6FUa5r6JrH7kwqFKyZgWc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=YxIMQZyeVu4QYb0mxSG13oEx7g9nNg5nI28Rn5To2pcGD4jlUin9290rMziGxhac+
         XbHEDdL7kFqOHSNSEdVbkDemTmFEDIgiN535bdG9/yayiC//YtLY12BWUv8WBLRgJa
         K6hy+K5Qi4hZfnJagwS2QItRGA96wNmelLO0X0T+w7TC7d4sVReckiQOJn8L4WS4vC
         a9C1z8Vdf5wlSteoUB1c2Yqx0RC/7Gn0M8huT82BY++gDNHBgIM0VAAS095Ti9aJnr
         jDxKj8nUK0S+i2YQjcRQTJfTbJuLNBRVqmwgkdox56OEvVTw5ZJQL8IOPH10S9dxGj
         /40cUKHYC2LBQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 10 Jan 2023 13:13:23 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>,
        kernel <kernel@sberdevices.ru>
Subject: [PATCH net-next v7 1/4] vsock: return errors other than -ENOMEM to
 socket
Thread-Topic: [PATCH net-next v7 1/4] vsock: return errors other than -ENOMEM
 to socket
Thread-Index: AQHZJNwrTpggmvOgXEC/s2dfrPctDA==
Date:   Tue, 10 Jan 2023 10:13:23 +0000
Message-ID: <65324bbb-7414-3c27-9dd3-7565010aa6b1@sberdevices.ru>
In-Reply-To: <67cd2d0a-1c58-baac-7b39-b8d4ea44f719@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <32CA6C2BC35ED243A98EBDA9F3BC5DAE@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/01/10 08:25:00 #20754977
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9iYnkgRXNobGVtYW4gPGJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20+DQoNClRo
aXMgcmVtb3ZlcyBiZWhhdmlvdXIsIHdoZXJlIGVycm9yIGNvZGUgcmV0dXJuZWQgZnJvbSBhbnkg
dHJhbnNwb3J0DQp3YXMgYWx3YXlzIHN3aXRjaGVkIHRvIEVOT01FTS4gRm9yIGV4YW1wbGUgd2hl
biB1c2VyIHRyaWVzIHRvIHNlbmQgdG9vDQpiaWcgbWVzc2FnZSB2aWEgU0VRUEFDS0VUIHNvY2tl
dCwgdHJhbnNwb3J0IGxheWVycyByZXR1cm4gRU1TR1NJWkUsIGJ1dA0KdGhpcyBlcnJvciBjb2Rl
IHdhcyBhbHdheXMgcmVwbGFjZWQgd2l0aCBFTk9NRU0gYW5kIHJldHVybmVkIHRvIHVzZXIuDQoN
ClNpZ25lZC1vZmYtYnk6IEJvYmJ5IEVzaGxlbWFuIDxib2JieS5lc2hsZW1hbkBieXRlZGFuY2Uu
Y29tPg0KU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmlj
ZXMucnU+DQpSZXZpZXdlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQu
Y29tPg0KLS0tDQogbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgMyArKy0NCiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQv
dm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4IGQ1
OTNkNWI2ZDRiMS4uMTlhZWE3Y2JhMjZlIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9hZl92
c29jay5jDQorKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC0xODYxLDggKzE4NjEs
OSBAQCBzdGF0aWMgaW50IHZzb2NrX2Nvbm5lY3RpYmxlX3NlbmRtc2coc3RydWN0IHNvY2tldCAq
c29jaywgc3RydWN0IG1zZ2hkciAqbXNnLA0KIAkJCXdyaXR0ZW4gPSB0cmFuc3BvcnQtPnN0cmVh
bV9lbnF1ZXVlKHZzaywNCiAJCQkJCW1zZywgbGVuIC0gdG90YWxfd3JpdHRlbik7DQogCQl9DQor
DQogCQlpZiAod3JpdHRlbiA8IDApIHsNCi0JCQllcnIgPSAtRU5PTUVNOw0KKwkJCWVyciA9IHdy
aXR0ZW47DQogCQkJZ290byBvdXRfZXJyOw0KIAkJfQ0KIA0KLS0gDQoyLjI1LjENCg==
