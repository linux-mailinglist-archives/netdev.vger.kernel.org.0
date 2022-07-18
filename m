Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7F7577D4D
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiGRIQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGRIQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:16:36 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBFA18B34;
        Mon, 18 Jul 2022 01:16:34 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 379A85FD02;
        Mon, 18 Jul 2022 11:16:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658132193;
        bh=P1nJrkr4Sn5U/iYTmAgG12ArGGHsfWi2OJp13EVm0cA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=JatiyhM0hARi6p2do309wBi/iTOndctex3kl1O5m7NBQyoRn+R0yaoRyBjEQL+Uo9
         zA5k+SGXqldQLx6CZMhyGZdcgFB0YFUiokKzC7cfu/8n/udA1saE3fa1FX5fQeH6Ux
         tTbU8vT4pX0rQQaJU1HOLyGXDD++5/qbxQmir1l2BitHYtJ4vAG6yD94GV9AVQiDBh
         MMKpjjV3k6BxIXQ+NzqNonD3sTOquqxNtxNkuaGJ89jI7Jm4QZJVBJUcJt4Re9RqNo
         qsWWWFLlGYmJwtOXe0Vw3NPeMI7FbDJ6tZHrGI7Wz9IW6EESVXMlcNVcmlIS6/IlKM
         lmm2eNSqOZNmg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 18 Jul 2022 11:16:32 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 1/3] vsock: use sk_skrcvlowat to set POLLIN,POLLRDNORM,
 bits.
Thread-Topic: [RFC PATCH v1 1/3] vsock: use sk_skrcvlowat to set
 POLLIN,POLLRDNORM, bits.
Thread-Index: AQHYmn6SAU6pAMObZUmsS+bpsPqTqA==
Date:   Mon, 18 Jul 2022 08:15:42 +0000
Message-ID: <637e945f-f28a-86d9-a242-1f4be85d9840@sberdevices.ru>
In-Reply-To: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B69C12E9E4B158499F9DC95EFEB3E7C1@sberdevices.ru>
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

Qm90aCBiaXRzIGluZGljYXRlLCB0aGF0IG5leHQgZGF0YSByZWFkIGNhbGwgd29uJ3QgYmUgYmxv
Y2tlZCwNCmJ1dCB3aGVuIHNrX3Jjdmxvd2F0IGlzIG5vdCAxLHRoZXNlIGJpdHMgd2lsbCBiZSBz
ZXQgYnkgcG9sbA0KYW55d2F5LHRodXMgd2hlbiB1c2VyIHRyaWVzIHRvIGRlcXVldWUgZGF0YSwg
aXQgd2lsbCB3YWl0IHVudGlsDQpza19yY3Zsb3dhdCBieXRlcyBvZiBkYXRhIHdpbGwgYmUgYXZh
aWxhYmxlLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVy
ZGV2aWNlcy5ydT4NCi0tLQ0KIG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyB8IDIgKy0NCiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBh
L25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KaW5k
ZXggZjA0YWJmNjYyZWM2Li4wMjI1ZjM1NThlMzAgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2Nr
L2FmX3Zzb2NrLmMNCisrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KQEAgLTEwNjcsNyAr
MTA2Nyw3IEBAIHN0YXRpYyBfX3BvbGxfdCB2c29ja19wb2xsKHN0cnVjdCBmaWxlICpmaWxlLCBz
dHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJICAgICEoc2stPnNrX3NodXRkb3duICYgUkNWX1NIVVRE
T1dOKSkgew0KIAkJCWJvb2wgZGF0YV9yZWFkeV9ub3cgPSBmYWxzZTsNCiAJCQlpbnQgcmV0ID0g
dHJhbnNwb3J0LT5ub3RpZnlfcG9sbF9pbigNCi0JCQkJCXZzaywgMSwgJmRhdGFfcmVhZHlfbm93
KTsNCisJCQkJCXZzaywgc2stPnNrX3Jjdmxvd2F0LCAmZGF0YV9yZWFkeV9ub3cpOw0KIAkJCWlm
IChyZXQgPCAwKSB7DQogCQkJCW1hc2sgfD0gRVBPTExFUlI7DQogCQkJfSBlbHNlIHsNCi0tIA0K
Mi4yNS4xDQo=
