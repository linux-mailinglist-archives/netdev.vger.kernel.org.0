Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A5564FC23
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 20:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLQTqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 14:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQTp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 14:45:59 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE916478;
        Sat, 17 Dec 2022 11:45:57 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0A95B5FD03;
        Sat, 17 Dec 2022 22:45:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671306356;
        bh=fRQaScZUwNSlmdqZ+Io2YTz+G50P34agK3PANG8xcpg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=SYrU7wwJjd48bsmEyayCo3z+n3YukZqN12mu5SGqHo5v6byneL+q+3U7GIzPE7BMP
         hmLUetTPQpw+Xq4pT08RTy7t/sxOwMLs4tCjrK1TSwypxP6GoRAqcxmR6LglHr+wD7
         CMpEOtvMSWP4l2zk7yrry12hitXe50XR/Uwwk7a+r/IhTV/qCpMQ3c4gnKKP+txJfh
         MyAx8n9c8v4GaquwxhFAqnxjuYDiePj0cSKs54jCxtM5uBo8p6MrT8g/0KbsUCkv9v
         qJnONB7m5fISmnFOsCWgv8/itgjGEX9GLyFY/IGrGmp3yMeEMY4wgcreYpN8cSd6t/
         a91p7St8NxhrA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat, 17 Dec 2022 22:45:55 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 1/2] virtio/vsock: send credit update depending on
 SO_RCVLOWAT
Thread-Topic: [RFC PATCH v1 1/2] virtio/vsock: send credit update depending on
 SO_RCVLOWAT
Thread-Index: AQHZElAtpIjfFhXnAkiL/v8iyYioYA==
Date:   Sat, 17 Dec 2022 19:45:55 +0000
Message-ID: <f304eabe-d2ef-11b1-f115-6967632f0339@sberdevices.ru>
In-Reply-To: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <34A3F028C08A3C47A856A1176E2EEEFC@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/17 15:49:00 #20678428
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIGV4dHJhIGNvbmRpdGlvbiB0byBzZW5kIGNyZWRpdCB1cGRhdGUgbWVzc2FnZSBk
dXJpbmcgZGF0YQ0KcmVhZCB0byB1c2Vyc3BhY2UuIFByb2JsZW0gYXJpc2VzLCB3aGVuIHNlbmRl
ciB3YWl0cyBmb3IgdGhlIGZyZWUgc3BhY2UNCm9uIHRoZSByZWNlaXZlciB3aGlsZSByZWNlaXZl
ciB3YWl0cyBpbiAncG9sbCgpJyB1bnRpbCAncnhfYnl0ZXMnIHJlYWNoZXMNClNPX1JDVkxPV0FU
IHZhbHVlIG9mIHRoZSBzb2NrZXQuIFdpdGggdGhpcyBwYXRjaCwgcmVjZWl2ZXIgc2VuZHMgY3Jl
ZGl0DQp1cGRhdGUgbWVzc2FnZSB3aGVuIG51bWJlciBvZiBieXRlcyBpbiBpdCdzIHJ4IHF1ZXVl
IGlzIHRvbyBzbWFsbCB0bw0KYXZvaWQgc2xlZXBpbmcgaW4gJ3BvbGwoKScuDQoNClNpZ25lZC1v
ZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQog
bmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIHwgOSArKysrKysrLS0NCiAx
IGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIGIvbmV0L3Ztd192
c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQppbmRleCBhMTU4MWM3N2NmODQuLjRjZjI2
Y2Y4YTc1NCAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21t
b24uYw0KKysrIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQpAQCAt
MzYyLDYgKzM2Miw3IEBAIHZpcnRpb190cmFuc3BvcnRfc3RyZWFtX2RvX2RlcXVldWUoc3RydWN0
IHZzb2NrX3NvY2sgKnZzaywNCiAJc3RydWN0IHZpcnRpb192c29ja19zb2NrICp2dnMgPSB2c2st
PnRyYW5zOw0KIAlzaXplX3QgYnl0ZXMsIHRvdGFsID0gMDsNCiAJc3RydWN0IHNrX2J1ZmYgKnNr
YjsNCisJYm9vbCBsb3dfcnhfYnl0ZXM7DQogCWludCBlcnIgPSAtRUZBVUxUOw0KIAl1MzIgZnJl
ZV9zcGFjZTsNCiANCkBAIC0zOTYsNiArMzk3LDggQEAgdmlydGlvX3RyYW5zcG9ydF9zdHJlYW1f
ZG9fZGVxdWV1ZShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLA0KIAl9DQogDQogCWZyZWVfc3BhY2Ug
PSB2dnMtPmJ1Zl9hbGxvYyAtICh2dnMtPmZ3ZF9jbnQgLSB2dnMtPmxhc3RfZndkX2NudCk7DQor
CWxvd19yeF9ieXRlcyA9ICh2dnMtPnJ4X2J5dGVzIDwNCisJCQlzb2NrX3Jjdmxvd2F0KHNrX3Zz
b2NrKHZzayksIDAsIElOVF9NQVgpKTsNCiANCiAJc3Bpbl91bmxvY2tfYmgoJnZ2cy0+cnhfbG9j
ayk7DQogDQpAQCAtNDA1LDkgKzQwOCwxMSBAQCB2aXJ0aW9fdHJhbnNwb3J0X3N0cmVhbV9kb19k
ZXF1ZXVlKHN0cnVjdCB2c29ja19zb2NrICp2c2ssDQogCSAqIHRvbyBoaWdoIGNhdXNlcyBleHRy
YSBtZXNzYWdlcy4gVG9vIGxvdyBjYXVzZXMgdHJhbnNtaXR0ZXINCiAJICogc3RhbGxzLiBBcyBz
dGFsbHMgYXJlIGluIHRoZW9yeSBtb3JlIGV4cGVuc2l2ZSB0aGFuIGV4dHJhDQogCSAqIG1lc3Nh
Z2VzLCB3ZSBzZXQgdGhlIGxpbWl0IHRvIGEgaGlnaCB2YWx1ZS4gVE9ETzogZXhwZXJpbWVudA0K
LQkgKiB3aXRoIGRpZmZlcmVudCB2YWx1ZXMuDQorCSAqIHdpdGggZGlmZmVyZW50IHZhbHVlcy4g
QWxzbyBzZW5kIGNyZWRpdCB1cGRhdGUgbWVzc2FnZSB3aGVuDQorCSAqIG51bWJlciBvZiBieXRl
cyBpbiByeCBxdWV1ZSBpcyBub3QgZW5vdWdoIHRvIHdha2UgdXAgcmVhZGVyLg0KIAkgKi8NCi0J
aWYgKGZyZWVfc3BhY2UgPCBWSVJUSU9fVlNPQ0tfTUFYX1BLVF9CVUZfU0laRSkNCisJaWYgKGZy
ZWVfc3BhY2UgPCBWSVJUSU9fVlNPQ0tfTUFYX1BLVF9CVUZfU0laRSB8fA0KKwkgICAgbG93X3J4
X2J5dGVzKQ0KIAkJdmlydGlvX3RyYW5zcG9ydF9zZW5kX2NyZWRpdF91cGRhdGUodnNrKTsNCiAN
CiAJcmV0dXJuIHRvdGFsOw0KLS0gDQoyLjI1LjENCg==
