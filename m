Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB141644D7D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLFUtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiLFUtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:49:23 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F8043AD2;
        Tue,  6 Dec 2022 12:49:22 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8CF5C5FD0B;
        Tue,  6 Dec 2022 23:49:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1670359760;
        bh=0st0OtNKvLNHxb42ZDSNL0oBxw5QegXYyh0QDx6NkXU=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=YJ90tUWKjberRXpA+lsN5hE4pGiZvV+nDpV2/2Yf8p/JvpNIRIxX0M+Bf9rzsci5R
         7OYXOK8yioTIH9pxu+x7rnUbAoP8Sl2rHVYE8lBAIEx7bQX2JyAIYeCoSj7IRMqbbE
         BVNx/6Y6e7f3PAGXsCVY6F3sALeSX2HHTw2Sk7BEn/EHNzREY36yeH67Wi9iDtIc1E
         /Fcd+8cVPI08cPWEB90rtMFg73JQdpTmaJRSjCZuxKvLFmQNj5u2S6jWSMpKf02pQQ
         l3rviQmGnFdUMQz1DLFp32BlJd17ziCgEepuqUHP5nReCvFtGy7TIWHEAEG1UwZTQf
         oLUcvT7Mf6BpA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue,  6 Dec 2022 23:49:20 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v4 1/4] vsock: return errors other than -ENOMEM to socket
Thread-Topic: [RFC PATCH v4 1/4] vsock: return errors other than -ENOMEM to
 socket
Thread-Index: AQHZCbQ2qBrFeLHJokud7/6u9taBOw==
Date:   Tue, 6 Dec 2022 20:49:19 +0000
Message-ID: <727f2c9e-a909-a3d3-c04f-a16529df7bb2@sberdevices.ru>
In-Reply-To: <6be11122-7cf2-641f-abd8-6e379ee1b88f@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <05667300B7E0DB499FEA5DE844DEF0F9@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/06 12:14:00 #20663216
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
IHdpbGwgYmUgcmVwbGFjZWQgdG8gRU5PTUVNIGFuZCByZXR1cm5lZCB0byB1c2VyLg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBCb2JieSBFc2hsZW1hbiA8Ym9iYnkuZXNobGVtYW5AYnl0ZWRhbmNlLmNvbT4N
ClNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1
Pg0KLS0tDQogbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgMyArKy0NCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvdm13
X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4IDg4NGVj
YTdmNjc0My4uNjFkZGFiNjY0YzMzIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29j
ay5jDQorKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC0xODYyLDggKzE4NjIsOSBA
QCBzdGF0aWMgaW50IHZzb2NrX2Nvbm5lY3RpYmxlX3NlbmRtc2coc3RydWN0IHNvY2tldCAqc29j
aywgc3RydWN0IG1zZ2hkciAqbXNnLA0KIAkJCXdyaXR0ZW4gPSB0cmFuc3BvcnQtPnN0cmVhbV9l
bnF1ZXVlKHZzaywNCiAJCQkJCW1zZywgbGVuIC0gdG90YWxfd3JpdHRlbik7DQogCQl9DQorDQog
CQlpZiAod3JpdHRlbiA8IDApIHsNCi0JCQllcnIgPSAtRU5PTUVNOw0KKwkJCWVyciA9IHdyaXR0
ZW47DQogCQkJZ290byBvdXRfZXJyOw0KIAkJfQ0KIA0KLS0gDQoyLjI1LjENCg==
