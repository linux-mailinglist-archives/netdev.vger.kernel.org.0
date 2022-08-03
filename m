Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45E0588E06
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiHCN4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiHCNz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:55:56 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B30D6B;
        Wed,  3 Aug 2022 06:55:51 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 46B5A5FD2E;
        Wed,  3 Aug 2022 16:55:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659534950;
        bh=Ktbbd9hXNDd86/yoPDR8TGlX/txvLJI7Vez6o0MPzn4=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=gptFyj2SysmD7IKDZmNL6DDgi4KG/CWC6l7FxpDsQWCEcX83qtv/3lIDZEb/JkZko
         EToijo1GA/oeNFlLCKsR3ayuXn44nSi+qJ3slzeP5G5X6BupEMZpRW2Cz3nlf+AL/m
         67OKltGJv1OcRe3GBYDZWskQbQMtoz9WGb0Xh9weqOQNJ5FIgZ99+MIRxcFDlsfOq8
         1kwTb0uhkxdkUKADWIRim8ISpCXgeqHbpJ0HWhyaGE9wcxOWkKiL1DBhVaBulOIh2e
         L62Vf/9zDJqkVMQtoiq8n6n49PhwlASbDOef5neJEJpefLt2ZQ/38PxvWNz5OKrMjb
         gXnCkiTxOCQoQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 16:55:49 +0300 (MSK)
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
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 3/9] virtio/vsock: use 'target' in notify_poll_in
 callback
Thread-Topic: [RFC PATCH v3 3/9] virtio/vsock: use 'target' in notify_poll_in
 callback
Thread-Index: AQHYp0C1oRdUPWQ9EEOsL2TJh6981g==
Date:   Wed, 3 Aug 2022 13:55:36 +0000
Message-ID: <a6844149-6ffc-09a6-b858-f24a27264c83@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9DCBA63484F784C95A01E3DF696131F@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/03 07:41:00 #20041172
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
