Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A5968B5F9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBFHBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBFHBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:01:35 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10845249;
        Sun,  5 Feb 2023 23:01:33 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 398595FD03;
        Mon,  6 Feb 2023 10:01:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666892;
        bh=3pLjGLtvlR8PtX7rjjJnNKnHtt2owD8Qpbd28G3wgTc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=onzOMuKAQfwMyuJ/bb2FZ3lNAZFz2PRq07Mwmq6Wec3iQ4Iw8DZeRMefd0EXQcks2
         fbpXuATimxr/R9HoeqFOV8SsthAKGxyyepzTv0mm7JPyOYc24m0ze7eI1q9IWFzuxO
         YWCv/4RTYITWqs9Du2Fgt3m8i16JFmEdIcFu83Sb7IGm8HfjfkbWTZk96boS3RuxtN
         0AqtBQzyOffEt15g+e0qDrcJA6aTVvuJ/DqX8fL2ClxcS9X9RVNwICFT0BQoylgmII
         ElRDaXZl2Q5RbUpfzT9R21wAt6bGS2G28RStcasQv8ixx1tYBDrDlzW6ps6sk1Y8KW
         ZggL4iFV9cWDQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:01:32 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 08/12] vhost/vsock: support MSG_ZEROCOPY for transport
Thread-Topic: [RFC PATCH v1 08/12] vhost/vsock: support MSG_ZEROCOPY for
 transport
Thread-Index: AQHZOfjX+En7ow/L9km3iEiQmRP5IA==
Date:   Mon, 6 Feb 2023 07:01:31 +0000
Message-ID: <e324f3f4-261f-52e4-4907-8344cae209c2@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <52482C1304B05940BFFBE0D5E6351FA8@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/02/06 01:18:00 #20834045
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+
DQotLS0NCiBkcml2ZXJzL3Zob3N0L3Zzb2NrLmMgfCA2ICsrKysrKw0KIDEgZmlsZSBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYyBi
L2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KaW5kZXggNjBiOWNhZmEzZTMxLi5hZmFhODAyMDM1Mjgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCisrKyBiL2RyaXZlcnMvdmhvc3Qv
dnNvY2suYw0KQEAgLTQ0MCw2ICs0NDAsMTEgQEAgc3RhdGljIGJvb2wgdmhvc3RfdnNvY2tfbW9y
ZV9yZXBsaWVzKHN0cnVjdCB2aG9zdF92c29jayAqdnNvY2spDQogCXJldHVybiB2YWwgPCB2cS0+
bnVtOw0KIH0NCiANCitzdGF0aWMgYm9vbCB2aG9zdF90cmFuc3BvcnRfbXNnemVyb2NvcHlfYWxs
b3codm9pZCkNCit7DQorCXJldHVybiB0cnVlOw0KK30NCisNCiBzdGF0aWMgYm9vbCB2aG9zdF90
cmFuc3BvcnRfc2VxcGFja2V0X2FsbG93KHUzMiByZW1vdGVfY2lkKTsNCiANCiBzdGF0aWMgc3Ry
dWN0IHZpcnRpb190cmFuc3BvcnQgdmhvc3RfdHJhbnNwb3J0ID0gew0KQEAgLTQ4NSw2ICs0OTAs
NyBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb190cmFuc3BvcnQgdmhvc3RfdHJhbnNwb3J0ID0gew0K
IAkJLm5vdGlmeV9zZW5kX3Bvc3RfZW5xdWV1ZSA9IHZpcnRpb190cmFuc3BvcnRfbm90aWZ5X3Nl
bmRfcG9zdF9lbnF1ZXVlLA0KIAkJLm5vdGlmeV9idWZmZXJfc2l6ZSAgICAgICA9IHZpcnRpb190
cmFuc3BvcnRfbm90aWZ5X2J1ZmZlcl9zaXplLA0KIA0KKwkJLm1zZ3plcm9jb3B5X2FsbG93ICAg
ICAgICA9IHZob3N0X3RyYW5zcG9ydF9tc2d6ZXJvY29weV9hbGxvdywNCiAJfSwNCiANCiAJLnNl
bmRfcGt0ID0gdmhvc3RfdHJhbnNwb3J0X3NlbmRfcGt0LA0KLS0gDQoyLjI1LjENCg==
