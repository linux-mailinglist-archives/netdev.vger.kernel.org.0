Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD919651B70
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 08:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiLTHTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 02:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiLTHSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 02:18:52 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC40E36;
        Mon, 19 Dec 2022 23:18:50 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id D47015FD04;
        Tue, 20 Dec 2022 10:18:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671520728;
        bh=gfJ1Wma4/Hix29ezKPf1BskSsFg9wHKm3F+uGRcLIc8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=PzvFDntaH3xlMg9EKiv5JUBq5YjAv4vQnSQH+05tkDJKTwcfGe+n25mxou2kzlcnW
         sK3eHc98X+9Vam/cjPt8j05X5OPiJGL20LBdg/XKAxO03wl6/Cm1qKtwX/TDK9L72W
         tiEGELmQxBZkdUGa8Agn+EndYFH+5zPIrzJs7gh9Ri3hgnWS7nZ8J/1zKqYRCJqIa0
         FM7BFF6oEYYO1fqfxSlPRNQU5IXEv6lpf2vSNl0CGjz5BOWSFgalcGvhVZtzByTnAO
         WAZqNL2ZLkCWEXxn/FuwFkZLj/l7AhzzFZvJ8IseiSan0JajjK1LM6N0KxDKuvYO6c
         Ku+UCzR4QhbFQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 20 Dec 2022 10:18:48 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v5 1/4] vsock: return errors other than -ENOMEM to socket
Thread-Topic: [RFC PATCH v5 1/4] vsock: return errors other than -ENOMEM to
 socket
Thread-Index: AQHZFENNrsKIykYAGk6rMUuI0TO6ow==
Date:   Tue, 20 Dec 2022 07:18:48 +0000
Message-ID: <c22a2ad3-1670-169b-7184-8f4a6d90ba06@sberdevices.ru>
In-Reply-To: <e04f749e-f1a7-9a1d-8213-c633ffcc0a69@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <63ACCD85517FFA40975768490B61028C@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/20 03:38:00 #20687629
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyByZW1vdmVzIGJlaGF2aW91ciwgd2hlcmUgZXJyb3IgY29kZSByZXR1cm5lZCBmcm9tIGFu
eSB0cmFuc3BvcnQNCndhcyBhbHdheXMgc3dpdGNoZWQgdG8gRU5PTUVNLiBGb3IgZXhhbXBsZSB3
aGVuIHVzZXIgdHJpZXMgdG8gc2VuZCB0b28NCmJpZyBtZXNzYWdlIHZpYSBTRVFQQUNLRVQgc29j
a2V0LCB0cmFuc3BvcnQgbGF5ZXJzIHJldHVybiBFTVNHU0laRSwgYnV0DQp0aGlzIGVycm9yIGNv
ZGUgd2FzIGFsd2F5cyByZXBsYWNlZCB3aXRoIEVOT01FTSBhbmQgcmV0dXJuZWQgdG8gdXNlci4N
Cg0KU2lnbmVkLW9mZi1ieTogQm9iYnkgRXNobGVtYW4gPGJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5j
ZS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2
aWNlcy5ydT4NCi0tLQ0KIG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyB8IDMgKystDQogMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEv
bmV0L3Ztd192c29jay9hZl92c29jay5jIGIvbmV0L3Ztd192c29jay9hZl92c29jay5jDQppbmRl
eCBkNTkzZDViNmQ0YjEuLjE5YWVhN2NiYTI2ZSAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2sv
YWZfdnNvY2suYw0KKysrIGIvbmV0L3Ztd192c29jay9hZl92c29jay5jDQpAQCAtMTg2MSw4ICsx
ODYxLDkgQEAgc3RhdGljIGludCB2c29ja19jb25uZWN0aWJsZV9zZW5kbXNnKHN0cnVjdCBzb2Nr
ZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCiAJCQl3cml0dGVuID0gdHJhbnNwb3J0LT5z
dHJlYW1fZW5xdWV1ZSh2c2ssDQogCQkJCQltc2csIGxlbiAtIHRvdGFsX3dyaXR0ZW4pOw0KIAkJ
fQ0KKw0KIAkJaWYgKHdyaXR0ZW4gPCAwKSB7DQotCQkJZXJyID0gLUVOT01FTTsNCisJCQllcnIg
PSB3cml0dGVuOw0KIAkJCWdvdG8gb3V0X2VycjsNCiAJCX0NCiANCi0tIA0KMi4yNS4xDQo=
