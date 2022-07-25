Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AFC57FA99
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiGYH5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGYH5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:57:22 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3305FD135;
        Mon, 25 Jul 2022 00:57:20 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 7EEF45FD0B;
        Mon, 25 Jul 2022 10:57:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658735838;
        bh=3yFDKShsdzLtXczy78DAfWUgL5KDQChLK4zk2QgRds0=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=EGu2Dbrm/JzyVU9s17oiJ4dY2K+UGlqrAuSJazSarGzav5+kEnjvT9NLhiO3MAtzY
         B4hY3uiJuy4ewR9VYVJXcWjwWTg6AfDWEZ0g8AGlQuE/P5ZcNThMwenBSLnpt1oK7r
         /zV/5iPkuwnITY+xbjl5T5j21MrKqfi69r7bM33ZHZh/X2CDTOSLhfykFOs7glH47Z
         gH6wryAX5DRKyndQQUSkZuooBhlv4akGpTjyoCVIxRHmRxPXBHNLFFqCGQ0dYEoW4c
         wT7xlN4kG8QUZNIgyWvYvbffFoKMuh1FYgZjxMmzfgGupPCvE7U1yE2AieaC4kweBj
         ODTc/xd9LblQQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 10:57:18 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 1/9] vsock: use sk_rcvlowat to set POLLIN/POLLRDNORM
Thread-Topic: [RFC PATCH v2 1/9] vsock: use sk_rcvlowat to set
 POLLIN/POLLRDNORM
Thread-Index: AQHYn/weV9iJ1kN02k+zjfwbZg+ycw==
Date:   Mon, 25 Jul 2022 07:56:59 +0000
Message-ID: <aafc654d-5b42-aa18-bf74-f5277d549f73@sberdevices.ru>
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ED96AEDE2917D419B416B6B7150A4C0@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/25 03:52:00 #19956163
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qm90aCBiaXRzIGluZGljYXRlLCB0aGF0IG5leHQgZGF0YSByZWFkIGNhbGwgd29uJ3QgYmUgYmxv
Y2tlZCwgYnV0IHdoZW4NCnNrX3Jjdmxvd2F0IGlzIG5vdCAxLCB0aGVzZSBiaXRzIHdpbGwgYmUg
c2V0IGJ5IHBvbGwgYW55d2F5LCB0aHVzIHdoZW4NCnVzZXIgdHJpZXMgdG8gZGVxdWV1ZSBkYXRh
LGl0IHdpbGwgd2FpdCB1bnRpbCBza19yY3Zsb3dhdCBieXRlcyBvZiBkYXRhDQp3aWxsIGJlIGF2
YWlsYWJsZS4NCg0KU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2Jl
cmRldmljZXMucnU+DQotLS0NCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgfCAzICsrLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdp
dCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0K
aW5kZXggZjA0YWJmNjYyZWM2Li42M2ExM2ZhMjY4NmEgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zz
b2NrL2FmX3Zzb2NrLmMNCisrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KQEAgLTEwNjYs
OCArMTA2Niw5IEBAIHN0YXRpYyBfX3BvbGxfdCB2c29ja19wb2xsKHN0cnVjdCBmaWxlICpmaWxl
LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJaWYgKHRyYW5zcG9ydCAmJiB0cmFuc3BvcnQtPnN0
cmVhbV9pc19hY3RpdmUodnNrKSAmJg0KIAkJICAgICEoc2stPnNrX3NodXRkb3duICYgUkNWX1NI
VVRET1dOKSkgew0KIAkJCWJvb2wgZGF0YV9yZWFkeV9ub3cgPSBmYWxzZTsNCisJCQlpbnQgdGFy
Z2V0ID0gc29ja19yY3Zsb3dhdChzaywgMCwgSU5UX01BWCk7DQogCQkJaW50IHJldCA9IHRyYW5z
cG9ydC0+bm90aWZ5X3BvbGxfaW4oDQotCQkJCQl2c2ssIDEsICZkYXRhX3JlYWR5X25vdyk7DQor
CQkJCQl2c2ssIHRhcmdldCwgJmRhdGFfcmVhZHlfbm93KTsNCiAJCQlpZiAocmV0IDwgMCkgew0K
IAkJCQltYXNrIHw9IEVQT0xMRVJSOw0KIAkJCX0gZWxzZSB7DQotLSANCjIuMjUuMQ0K
