Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1B8588E1F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiHCOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbiHCOAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:00:07 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A6AB8A;
        Wed,  3 Aug 2022 07:00:05 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id DDC235FD2F;
        Wed,  3 Aug 2022 17:00:03 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659535203;
        bh=ZKMXpCA9Ey3wdzBNP+gXLnhyO45OV7iXKTbsieEn9NI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=nBsWoYp0gXHeJkZUq0y+1zuiM+x8y2iDCV5d//JxA36M1kJMBu3y/1J3F0zxmuI+N
         BqtPoHFKqABGbBsU+ajMZIH0kNWWfDi298My4nETIadzE6Wz/dTbWbWDEG+ajR8Km6
         MF5u7zryJXGaKpzLlTfFvVQAI033RJwzcL42uIYBeMcoNR72HlucfW1NwSg4oqwWIV
         wWsyjxYlVJ4EezJsadCMSMmO6eXTDvabu0A+GcgyzaQRjV4E0tsmF0FU6JeSvF/rxS
         aiop8S64qAhW1FAr9rUKc2FUpkKcnliGuHYzQmhOPaKIlCrTD8E0worXqN1JAglCMf
         9cA7PAy7Nrh3g==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 17:00:02 +0300 (MSK)
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
Subject: [RFC PATCH v3 5/9] vsock: pass sock_rcvlowat to notify_poll_in as
 target
Thread-Topic: [RFC PATCH v3 5/9] vsock: pass sock_rcvlowat to notify_poll_in
 as target
Thread-Index: AQHYp0FLSVsieEsYCEKStjqm/Ox4tQ==
Date:   Wed, 3 Aug 2022 13:59:49 +0000
Message-ID: <5e343101-8172-d0fa-286f-5de422c6db0b@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B80F0681314D6C4E922F57A91A26F18B@sberdevices.ru>
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
bGFibGUgZGF0YS4NCg0KU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZA
c2JlcmRldmljZXMucnU+DQotLS0NCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgfCAzICsrLQ0K
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAt
LWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2su
Yw0KaW5kZXggMDE2YWQ1ZmY3OGI3Li4zYTE0MjZlYjhiYWEgMTAwNjQ0DQotLS0gYS9uZXQvdm13
X3Zzb2NrL2FmX3Zzb2NrLmMNCisrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KQEAgLTEw
NjYsOCArMTA2Niw5IEBAIHN0YXRpYyBfX3BvbGxfdCB2c29ja19wb2xsKHN0cnVjdCBmaWxlICpm
aWxlLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJaWYgKHRyYW5zcG9ydCAmJiB0cmFuc3BvcnQt
PnN0cmVhbV9pc19hY3RpdmUodnNrKSAmJg0KIAkJICAgICEoc2stPnNrX3NodXRkb3duICYgUkNW
X1NIVVRET1dOKSkgew0KIAkJCWJvb2wgZGF0YV9yZWFkeV9ub3cgPSBmYWxzZTsNCisJCQlpbnQg
dGFyZ2V0ID0gc29ja19yY3Zsb3dhdChzaywgMCwgSU5UX01BWCk7DQogCQkJaW50IHJldCA9IHRy
YW5zcG9ydC0+bm90aWZ5X3BvbGxfaW4oDQotCQkJCQl2c2ssIDEsICZkYXRhX3JlYWR5X25vdyk7
DQorCQkJCQl2c2ssIHRhcmdldCwgJmRhdGFfcmVhZHlfbm93KTsNCiAJCQlpZiAocmV0IDwgMCkg
ew0KIAkJCQltYXNrIHw9IEVQT0xMRVJSOw0KIAkJCX0gZWxzZSB7DQotLSANCjIuMjUuMQ0K
