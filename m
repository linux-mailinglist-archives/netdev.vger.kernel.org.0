Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2B7638EBC
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiKYRDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiKYRDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:03:11 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A073A26AC8;
        Fri, 25 Nov 2022 09:03:09 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0D0AA5FD0B;
        Fri, 25 Nov 2022 20:03:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669395788;
        bh=hIsvyQKroiddHpaTVR2wY29J7IQ5VqM86kcghxyeuSM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=ggMFBYROTK0lyPJPUDAbCu1X+1e9Jl/HQMoliWUPNJ9lwXOXNhitBph374CaykvuH
         ZRMqCFhCoB+56aaTIZHL3KF0ePPKNERNkUQWsJM2+OQxn07+H490NxHzR164UTUTv3
         EyQP9n2Sz0hl76z4HTBPDhuc3jI7LcaPWgwdaQBCmQiqi0tntWgOOk2olsN0+fsBX+
         TXTMSAk0YLxVxPQj9doIYlVU879LRh01P1kYS6gRnui5LnVEGlEN7wUwk6URQ8BiX7
         jaKSY1/LyXv/rAPnP9k/SH4nHGBP+seWTTHqlcIB7lPZtpCyMNearrL9nV2N1eKKNV
         uO0j+weZ1Rv7A==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 25 Nov 2022 20:03:06 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 1/6] vsock: return errors other than -ENOMEM to socket
Thread-Topic: [RFC PATCH v2 1/6] vsock: return errors other than -ENOMEM to
 socket
Thread-Index: AQHZAO/JdW+nx2oM60ahOLF9t/m+FQ==
Date:   Fri, 25 Nov 2022 17:03:06 +0000
Message-ID: <84f44358-dd8b-de8f-b782-7b6f03e0a759@sberdevices.ru>
In-Reply-To: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <816FF44AD1235C4FAB598C4AD43152C1@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/25 14:59:00 #20610704
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
aXMgcmVtb3ZlcyBiZWhhdmlvdXIsIHdoZXJlIGVycm9yIGNvZGUgcmV0dXJuZWQgZnJvbSBhbnkN
CnRyYW5zcG9ydCB3YXMgYWx3YXlzIHN3aXRjaGVkIHRvIEVOT01FTS4NCg0KU2lnbmVkLW9mZi1i
eTogQm9iYnkgRXNobGVtYW4gPGJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0K
IG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyB8IDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9h
Zl92c29jay5jIGIvbmV0L3Ztd192c29jay9hZl92c29jay5jDQppbmRleCA4ODRlY2E3ZjY3NDMu
LjYxZGRhYjY2NGMzMyAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KKysr
IGIvbmV0L3Ztd192c29jay9hZl92c29jay5jDQpAQCAtMTg2Miw4ICsxODYyLDkgQEAgc3RhdGlj
IGludCB2c29ja19jb25uZWN0aWJsZV9zZW5kbXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVj
dCBtc2doZHIgKm1zZywNCiAJCQl3cml0dGVuID0gdHJhbnNwb3J0LT5zdHJlYW1fZW5xdWV1ZSh2
c2ssDQogCQkJCQltc2csIGxlbiAtIHRvdGFsX3dyaXR0ZW4pOw0KIAkJfQ0KKw0KIAkJaWYgKHdy
aXR0ZW4gPCAwKSB7DQotCQkJZXJyID0gLUVOT01FTTsNCisJCQllcnIgPSB3cml0dGVuOw0KIAkJ
CWdvdG8gb3V0X2VycjsNCiAJCX0NCiANCi0tIA0KMi4yNS4xDQo=
