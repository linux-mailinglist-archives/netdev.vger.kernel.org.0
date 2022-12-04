Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15D2641F3A
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 20:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiLDTT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 14:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiLDTTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 14:19:25 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA85E0C9;
        Sun,  4 Dec 2022 11:19:23 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 87A465FD03;
        Sun,  4 Dec 2022 22:19:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1670181561;
        bh=hIsvyQKroiddHpaTVR2wY29J7IQ5VqM86kcghxyeuSM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=jtCanZOOdFSJsyPk4hGtaNuwD7iSkkHRfHhYfHKoE3jLUx0anOR+UJIbHfx0jtCKU
         P/HPrTpnvJeosJYBcILYylYDwk5npVdbf7pRskiZwJXgpLB7f3T7jsymUAS8lwLitR
         eCstq7GozPKRV9AaOIpomhGn5QeyKpT71Iit35/Qaz2pZKy+wmzkBumJD2CfFbj/7E
         ivNRKnQxs4+wKqF72wF1nHiLADcokxazqa6Uy9gL9UtnUrwLQ69LgDGiTL4GzFrulX
         64zEGk8e4lE/Z+7ryvXLc6kqVOLYvvmFZOd3CZZ1Yny8qYd4b1Lb5q/y1ntsoFrh8I
         39EutZxqRsafw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  4 Dec 2022 22:19:21 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 1/4] vsock: return errors other than -ENOMEM to socket
Thread-Topic: [RFC PATCH v3 1/4] vsock: return errors other than -ENOMEM to
 socket
Thread-Index: AQHZCBVPUxodrmNfCUeS2ScEDlgfUQ==
Date:   Sun, 4 Dec 2022 19:19:20 +0000
Message-ID: <b9ea0ff4-3aef-030e-0a9b-e2fcb67b305b@sberdevices.ru>
In-Reply-To: <6bd77692-8388-8693-f15f-833df1fa6afd@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A8C54714356D4498F9AC846A04E186C@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/04 13:44:00 #20647742
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
