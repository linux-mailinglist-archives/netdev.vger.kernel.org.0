Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9DB61E5AB
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiKFTqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKFTqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:46:10 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB6B5FF0;
        Sun,  6 Nov 2022 11:46:09 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id E8D395FD03;
        Sun,  6 Nov 2022 22:46:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667763967;
        bh=KB7/nCwB5US3fSlJ/o7Lc7D8vetXoSvCwrP1v/i0ne8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=XeGSlEKE/VjncH5U7TdNwzy9UxBlJcIT2/xTuGWgLBB12Hglf9PApiqWwlHapALc8
         XA7Quq+EcrxEZJIKVN70LwA/61i09ERzTAodu16jaf35sKSBS0d5VvhOAxbfS58WBA
         tkqsAD3IoacKrmIh+DEMAFjfeADcDn5CcvXZyjozqLZRl2nxF80p0/9YLH6ckEOm9F
         1ZyE1cv6AZ7YkkutrzJX+QwbaB2u1V0fIFfF2EZJxhVLxVcly6J0uReDooTaFvN1ag
         1txwynxHvvhiuNpC/f+vqYJCbR84FawafpIwL9r3LIEm7yqslkmA+CfMXBQYjSaEv8
         Qx8m2V8PXd4Hg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  6 Nov 2022 22:46:07 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 06/11] vhost/vsock: enable zerocopy callback
Thread-Topic: [RFC PATCH v3 06/11] vhost/vsock: enable zerocopy callback
Thread-Index: AQHY8hhXqtpTwM0Q2ka0p5q420lJUQ==
Date:   Sun, 6 Nov 2022 19:45:36 +0000
Message-ID: <7a7f6f28-aff2-8e4b-140a-c47be778febf@sberdevices.ru>
In-Reply-To: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F0BA688F5AE444C9C5C493604D9E891@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 18:31:00 #20575158
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHplcm9jb3B5IGNhbGxiYWNrIHRvIHZob3N0IHRyYW5zcG9ydC4NCg0KU2lnbmVk
LW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQotLS0N
CiBkcml2ZXJzL3Zob3N0L3Zzb2NrLmMgfCAyICsrDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC92c29jay5jIGIvZHJpdmVycy92
aG9zdC92c29jay5jDQppbmRleCAxOTFhNWI5NGFhN2MuLmZjNmM2ZTY2N2UzNiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KKysrIGIvZHJpdmVycy92aG9zdC92c29jay5jDQpA
QCAtNDg2LDYgKzQ4Niw4IEBAIHN0YXRpYyBzdHJ1Y3QgdmlydGlvX3RyYW5zcG9ydCB2aG9zdF90
cmFuc3BvcnQgPSB7DQogCQkuc3RyZWFtX3Jjdmhpd2F0ICAgICAgICAgID0gdmlydGlvX3RyYW5z
cG9ydF9zdHJlYW1fcmN2aGl3YXQsDQogCQkuc3RyZWFtX2lzX2FjdGl2ZSAgICAgICAgID0gdmly
dGlvX3RyYW5zcG9ydF9zdHJlYW1faXNfYWN0aXZlLA0KIAkJLnN0cmVhbV9hbGxvdyAgICAgICAg
ICAgICA9IHZpcnRpb190cmFuc3BvcnRfc3RyZWFtX2FsbG93LA0KKwkJLnplcm9jb3B5X2RlcXVl
dWUJICA9IHZpcnRpb190cmFuc3BvcnRfemVyb2NvcHlfZGVxdWV1ZSwNCisJCS56ZXJvY29weV9y
eF9tbWFwCSAgPSB2aXJ0aW9fdHJhbnNwb3J0X3plcm9jb3B5X2luaXQsDQogDQogCQkuc2VxcGFj
a2V0X2RlcXVldWUgICAgICAgID0gdmlydGlvX3RyYW5zcG9ydF9zZXFwYWNrZXRfZGVxdWV1ZSwN
CiAJCS5zZXFwYWNrZXRfZW5xdWV1ZSAgICAgICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3NlcXBhY2tl
dF9lbnF1ZXVlLA0KLS0gDQoyLjM1LjANCg==
