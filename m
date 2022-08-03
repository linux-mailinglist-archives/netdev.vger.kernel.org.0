Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C5F588E30
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiHCOEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbiHCOEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:04:15 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0332F003;
        Wed,  3 Aug 2022 07:04:13 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 116565FD2E;
        Wed,  3 Aug 2022 17:04:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659535452;
        bh=6XZQtWxl9pDfCffcJW86vuM5/TgZ8YvSCAXMREbLKGk=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=HGsGwwldJ5JnGyr5nIzZMkNbnQvF6r2IxyQl45jcOp5iFbbHMoJBoDEYFxJ0YDM7Q
         zMUEnauI5wEb98/DEFRuCmz1twxbIpOP6gkBbjPNNqbPGsMr2RkFv0ppQm2uZQqVKQ
         US+VgwLAcUXj4vCkFYsTrkKNdMrbsas1yUCmE5P/tT30pR0pEO7wsZRDqYDMjhqCuo
         JPLtZcPQvIxv5C6BXcKydlHnkdn+yzfss8q6KQU+j2NlgLd1y/f3zuCocDoV0nKoYu
         z5TopP9mXas3/ONsLTExUGdUcOX7AIgzdiMPoYEhZPR9feTg4dbqLxRAS3MQf+clWB
         t02DRwRFk77Kw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 17:04:11 +0300 (MSK)
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
Subject: [RFC PATCH v3 7/9] virtio/vsock: check SO_RCVLOWAT before wake up
 reader
Thread-Topic: [RFC PATCH v3 7/9] virtio/vsock: check SO_RCVLOWAT before wake
 up reader
Thread-Index: AQHYp0Hf6rlyzBtLk0aQZEnBg4ReJg==
Date:   Wed, 3 Aug 2022 14:03:58 +0000
Message-ID: <e08064c5-fd4a-7595-3138-67aa2f46c955@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C63DE3F717DDC54096594E3577522BEB@sberdevices.ru>
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

VGhpcyBhZGRzIGV4dHJhIGNvbmRpdGlvbiB0byB3YWtlIHVwIGRhdGEgcmVhZGVyOiBkbyBpdCBv
bmx5IHdoZW4gbnVtYmVyDQpvZiByZWFkYWJsZSBieXRlcyA+PSBTT19SQ1ZMT1dBVC4gT3RoZXJ3
aXNlLCB0aGVyZSBpcyBubyBzZW5zZSB0byBraWNrDQp1c2VyLGJlY2F1c2UgaXQgd2lsbCB3YWl0
IHVudGlsIFNPX1JDVkxPV0FUIGJ5dGVzIHdpbGwgYmUgZGVxdWV1ZWQuDQoNClNpZ25lZC1vZmYt
Ynk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogbmV0
L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIHwgMiArLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3Zt
d192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIGIvbmV0L3Ztd192c29jay92aXJ0aW9f
dHJhbnNwb3J0X2NvbW1vbi5jDQppbmRleCA4ZjYzNTZlYmNkZDEuLjM1ODYzMTMyZjRmMSAxMDA2
NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KKysrIGIv
bmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQpAQCAtMTA4MSw3ICsxMDgx
LDcgQEAgdmlydGlvX3RyYW5zcG9ydF9yZWN2X2Nvbm5lY3RlZChzdHJ1Y3Qgc29jayAqc2ssDQog
CXN3aXRjaCAobGUxNl90b19jcHUocGt0LT5oZHIub3ApKSB7DQogCWNhc2UgVklSVElPX1ZTT0NL
X09QX1JXOg0KIAkJdmlydGlvX3RyYW5zcG9ydF9yZWN2X2VucXVldWUodnNrLCBwa3QpOw0KLQkJ
c2stPnNrX2RhdGFfcmVhZHkoc2spOw0KKwkJdnNvY2tfZGF0YV9yZWFkeShzayk7DQogCQlyZXR1
cm4gZXJyOw0KIAljYXNlIFZJUlRJT19WU09DS19PUF9DUkVESVRfUkVRVUVTVDoNCiAJCXZpcnRp
b190cmFuc3BvcnRfc2VuZF9jcmVkaXRfdXBkYXRlKHZzayk7DQotLSANCjIuMjUuMQ0K
