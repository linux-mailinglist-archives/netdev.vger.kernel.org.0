Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA1657FA9D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiGYH71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGYH7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:59:25 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44368D135;
        Mon, 25 Jul 2022 00:59:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A53335FD0B;
        Mon, 25 Jul 2022 10:59:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658735962;
        bh=Ktbbd9hXNDd86/yoPDR8TGlX/txvLJI7Vez6o0MPzn4=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=gFDyn5lzlgkq+1RPQOn85zVANkvBlwyYpykkMIJY6UypfMMHCTtgI3V261SMRQmoM
         OEaiMZRkJBeIgBP0TBhaVDfXr2rgbxXJup8k5IHzw0e+Z1sOLk/O9hTkW/R/vdSeJw
         Cm+EUAhhdUkv/BBELOryaT+XCGy2TJvvUEbwh6ON79jddLMI9oWAvTuqk0s0kuNFoO
         TV5r+6XUM12EO+/dPIZdQ9wqEDpIwHU0IZs2viw5e2+HtibjdgElKHPiyWEDDzShwp
         4GSt4btMauaGAt0WgK1BQeoIxmbNrScyFihaaEzKtDtnz/1XQjiWCbwDY1rwAntkUR
         wiAWTT4GD/e/g==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 10:59:21 +0300 (MSK)
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
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 2/9] virtio/vsock: use 'target' in notify_poll_in,
 callback
Thread-Topic: [RFC PATCH v2 2/9] virtio/vsock: use 'target' in notify_poll_in,
 callback
Thread-Index: AQHYn/xnBQBRPJKwbEuxzxqKhyN7Rw==
Date:   Mon, 25 Jul 2022 07:59:02 +0000
Message-ID: <c708aae5-b8fe-bc66-7942-8be4e2ccfed5@sberdevices.ru>
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7273D71A27B7C4392A2E0610B9A95A5@sberdevices.ru>
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

VGhpcyBjYWxsYmFjayBjb250cm9scyBzZXR0aW5nIG9mIFBPTExJTixQT0xMUkROT1JNIG91dHB1
dCBiaXRzIG9mIHBvbGwoKQ0Kc3lzY2FsbCxidXQgaW4gc29tZSBjYXNlcyxpdCBpcyBpbmNvcnJl
Y3RseSB0byBzZXQgaXQsIHdoZW4gc29ja2V0IGhhcw0KYXQgbGVhc3QgMSBieXRlcyBvZiBhdmFp
bGFibGUgZGF0YS4gVXNlICd0YXJnZXQnIHdoaWNoIGlzIGFscmVhZHkgZXhpc3RzDQphbmQgZXF1
YWwgdG8gc2tfcmN2bG93YXQgaW4gdGhpcyBjYXNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5
IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIG5ldC92bXdfdnNvY2sv
dmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8IDUgKy0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2Nr
L3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3Bv
cnRfY29tbW9uLmMNCmluZGV4IGVjMmMyYWZiZjBkMC4uOGY2MzU2ZWJjZGQxIDEwMDY0NA0KLS0t
IGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQorKysgYi9uZXQvdm13
X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCkBAIC02MzQsMTAgKzYzNCw3IEBAIHZp
cnRpb190cmFuc3BvcnRfbm90aWZ5X3BvbGxfaW4oc3RydWN0IHZzb2NrX3NvY2sgKnZzaywNCiAJ
CQkJc2l6ZV90IHRhcmdldCwNCiAJCQkJYm9vbCAqZGF0YV9yZWFkeV9ub3cpDQogew0KLQlpZiAo
dnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykpDQotCQkqZGF0YV9yZWFkeV9ub3cgPSB0cnVlOw0K
LQllbHNlDQotCQkqZGF0YV9yZWFkeV9ub3cgPSBmYWxzZTsNCisJKmRhdGFfcmVhZHlfbm93ID0g
dnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykgPj0gdGFyZ2V0Ow0KIA0KIAlyZXR1cm4gMDsNCiB9
DQotLSANCjIuMjUuMQ0K
