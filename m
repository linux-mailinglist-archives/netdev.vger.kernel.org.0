Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6110466196B
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbjAHUjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 15:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAHUjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 15:39:11 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F06B7CB;
        Sun,  8 Jan 2023 12:39:10 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9FA1F5FD04;
        Sun,  8 Jan 2023 23:39:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1673210348;
        bh=iOSW3XOkz3vBuWBorAhdOl6FUa5r6JrH7kwqFKyZgWc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=pyPHzIVXFcJ8xl6A8vXhxv1KudWLzMBJjp1Jz3k6Qq8srPamSkJKvCp8MpTfrRK/m
         vDrGKqCHHSQgI4Z8iHObErLksM6gJnOdCPyNsbQXRxV3N+zprQbinwrrc4aiHetwBI
         TQZyKk45ByRcsdi6MobVqBT4AifOVrpyiodmhh0EqHd8eztbE0kNyqNvtNByJat/uH
         cD4sp3QpXt4x21BFy/25mBKncE4qFKaDhhZ+WoFc+b9Exe1faw2N5gJjsz4NToNgUt
         3W4tfovaC9P+9xetYQJPUhPttclj2ajCxXqumptQoyoLN/c+68DC5BNHsVJkdVDuro
         oiLQQsWq5REBg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  8 Jan 2023 23:39:08 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH net-next v6 1/4] vsock: return errors other than -ENOMEM to
 socket
Thread-Topic: [PATCH net-next v6 1/4] vsock: return errors other than -ENOMEM
 to socket
Thread-Index: AQHZI6FBMAzTipZPIkK5jsNMAwReeQ==
Date:   Sun, 8 Jan 2023 20:39:07 +0000
Message-ID: <ebd09c5b-667b-6908-90af-8f0fd4dfc53d@sberdevices.ru>
In-Reply-To: <9ad41d2b-bbe9-fe55-3aba-6a1281b6aa1b@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4B4B13E6A928A4BADCDCBB308C4179B@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/01/08 17:38:00 #20747751
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
