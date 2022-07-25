Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA13857FAC3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiGYICI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiGYIBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:01:43 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8F0C4D;
        Mon, 25 Jul 2022 01:01:23 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 6D3C55FD0D;
        Mon, 25 Jul 2022 11:01:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658736081;
        bh=clwHLJbaAdIOxlNPZw2nq1Q/tNfbQXWFX/0A1JAfY1A=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=JSJb3jvdz27xbfWwjpzAyXwjiBz1t+R9hEP6DBSuP/icxq/lSxSJpirmts2mZVpHc
         3sdJE6TbMr69rpJFKvE+rdlw1eQ6tjrf4PPKRCGKl39BoTWWrMXSpp5mLwudktu36m
         NQ0eBeIASqh8WIh5xWzseHOSLEMqczHpYXoPIbdC5cPqICzXM7mIhG5hcozWHLFxeI
         bxZmU9JOIbqWDz3bCLomb44FZtw1rHyRp7ISFILWyps08JXbY04ljpQqiJDsn1Du8f
         kPnsBctDmZTNDPktCzgohpBjTIC/qbZ5d9emSDvICqowJeUH9xnHfXl8ISdALO4hBm
         1uTzFKHlJWZTA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 11:01:20 +0300 (MSK)
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 3/9] vmci/vsock: use 'target' in notify_poll_in,
 callback
Thread-Topic: [RFC PATCH v2 3/9] vmci/vsock: use 'target' in notify_poll_in,
 callback
Thread-Index: AQHYn/yuG7nDISN+mkeT5PR9a2L0xw==
Date:   Mon, 25 Jul 2022 08:01:01 +0000
Message-ID: <355f4bb6-82e7-2400-83e9-c704a7ef92f3@sberdevices.ru>
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD38239CDF18C146A28B84A9E185D3E7@sberdevices.ru>
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
dm1jaV90cmFuc3BvcnRfbm90aWZ5LmMgICAgICAgIHwgMiArLQ0KIG5ldC92bXdfdnNvY2svdm1j
aV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jIHwgMiArLQ0KIDIgZmlsZXMgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29j
ay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRf
bm90aWZ5LmMNCmluZGV4IGQ2OWZjNGI1OTVhZC4uMTY4NGI4NWIwNjYwIDEwMDY0NA0KLS0tIGEv
bmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYw0KKysrIGIvbmV0L3Ztd192c29j
ay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYw0KQEAgLTM0MCw3ICszNDAsNyBAQCB2bWNpX3RyYW5z
cG9ydF9ub3RpZnlfcGt0X3BvbGxfaW4oc3RydWN0IHNvY2sgKnNrLA0KIHsNCiAJc3RydWN0IHZz
b2NrX3NvY2sgKnZzayA9IHZzb2NrX3NrKHNrKTsNCiANCi0JaWYgKHZzb2NrX3N0cmVhbV9oYXNf
ZGF0YSh2c2spKSB7DQorCWlmICh2c29ja19zdHJlYW1faGFzX2RhdGEodnNrKSA+PSB0YXJnZXQp
IHsNCiAJCSpkYXRhX3JlYWR5X25vdyA9IHRydWU7DQogCX0gZWxzZSB7DQogCQkvKiBXZSBjYW4n
dCByZWFkIHJpZ2h0IG5vdyBiZWNhdXNlIHRoZXJlIGlzIG5vdGhpbmcgaW4gdGhlDQpkaWZmIC0t
Z2l0IGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMgYi9uZXQv
dm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeV9xc3RhdGUuYw0KaW5kZXggMGYzNmQ3YzQ1
ZGIzLi5hNDA0MDc4NzJiNTMgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNw
b3J0X25vdGlmeV9xc3RhdGUuYw0KKysrIGIvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9u
b3RpZnlfcXN0YXRlLmMNCkBAIC0xNjEsNyArMTYxLDcgQEAgdm1jaV90cmFuc3BvcnRfbm90aWZ5
X3BrdF9wb2xsX2luKHN0cnVjdCBzb2NrICpzaywNCiB7DQogCXN0cnVjdCB2c29ja19zb2NrICp2
c2sgPSB2c29ja19zayhzayk7DQogDQotCWlmICh2c29ja19zdHJlYW1faGFzX2RhdGEodnNrKSkg
ew0KKwlpZiAodnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykgPj0gdGFyZ2V0KSB7DQogCQkqZGF0
YV9yZWFkeV9ub3cgPSB0cnVlOw0KIAl9IGVsc2Ugew0KIAkJLyogV2UgY2FuJ3QgcmVhZCByaWdo
dCBub3cgYmVjYXVzZSB0aGVyZSBpcyBub3RoaW5nIGluIHRoZQ0KLS0gDQoyLjI1LjENCg==
