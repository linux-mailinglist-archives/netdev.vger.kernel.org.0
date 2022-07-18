Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7742E577D54
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiGRISZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiGRISX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:18:23 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C51518E0D;
        Mon, 18 Jul 2022 01:18:22 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id E4C595FD02;
        Mon, 18 Jul 2022 11:18:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658132300;
        bh=qE3oICe7EFjo8tBFXaB+54QUv+zuKwoUREtOQS9uPkI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=UWMKMHr/QTzKS6bP877LWnR1qzAfuH4KhypdiAI33Emzzn//E84vDckRKMy4tprK1
         9qhrDYFqmageiypiPv6G716fe1I1e2Wfpt3pp9hn5W4LyPmXzrKymp9DxhGrJrLj6V
         iFCMfZj2Lv7Q+gllGsjn96pix0wybVQdBBdgYbLPRSeLSh/aZlYp49PW/x946Nqz7X
         g9PAkctNKp+IHqvVFXfJ5UNuf+pfrmAbWIkhp/K7NFRn6jYvZEK2ePvb99Wz5Lk0Do
         /tLBuHkx7tz4r93gNcJb0Fu6+pt2XNmwYXkh2C4cjsVRx+xwB+cWzKDApB/DdGCr/X
         2gD3Xyaes4yIQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 18 Jul 2022 11:18:20 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Topic: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Index: AQHYmn7T+PqKYxwQ8USiiecixCHJYQ==
Date:   Mon, 18 Jul 2022 08:17:31 +0000
Message-ID: <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
In-Reply-To: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A2B7E3D9075EA4E817DC70C89877970@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/18 02:31:00 #19923013
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
dCBiaXRzDQpvZiBwb2xsKCkgc3lzY2FsbCxidXQgaW4gc29tZSBjYXNlcyxpdCBpcyBpbmNvcnJl
Y3RseSB0byBzZXQgaXQsDQp3aGVuIHNvY2tldCBoYXMgYXQgbGVhc3QgMSBieXRlcyBvZiBhdmFp
bGFibGUgZGF0YS4gVXNlICd0YXJnZXQnDQp3aGljaCBpcyBhbHJlYWR5IGV4aXN0cyBhbmQgZXF1
YWwgdG8gc2tfcmN2bG93YXQgaW4gdGhpcyBjYXNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5
IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIG5ldC92bXdfdnNvY2sv
dmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmly
dGlvX3RyYW5zcG9ydF9jb21tb24uYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9j
b21tb24uYw0KaW5kZXggZWMyYzJhZmJmMGQwLi41OTE5MDg3NDA5OTIgMTAwNjQ0DQotLS0gYS9u
ZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCisrKyBiL25ldC92bXdfdnNv
Y2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KQEAgLTYzNCw3ICs2MzQsNyBAQCB2aXJ0aW9f
dHJhbnNwb3J0X25vdGlmeV9wb2xsX2luKHN0cnVjdCB2c29ja19zb2NrICp2c2ssDQogCQkJCXNp
emVfdCB0YXJnZXQsDQogCQkJCWJvb2wgKmRhdGFfcmVhZHlfbm93KQ0KIHsNCi0JaWYgKHZzb2Nr
X3N0cmVhbV9oYXNfZGF0YSh2c2spKQ0KKwlpZiAodnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykg
Pj0gdGFyZ2V0KQ0KIAkJKmRhdGFfcmVhZHlfbm93ID0gdHJ1ZTsNCiAJZWxzZQ0KIAkJKmRhdGFf
cmVhZHlfbm93ID0gZmFsc2U7DQotLSANCjIuMjUuMQ0K
