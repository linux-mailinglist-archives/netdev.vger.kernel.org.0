Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57D257FB01
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiGYIL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiGYILz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:11:55 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56FB13CE5;
        Mon, 25 Jul 2022 01:11:53 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 031455FD0B;
        Mon, 25 Jul 2022 11:11:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658736712;
        bh=6XZQtWxl9pDfCffcJW86vuM5/TgZ8YvSCAXMREbLKGk=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=eYz29V8S80mjj6Cu3OXN/JPf+FO5amHW3qjlJXQnM1fB7txMjH/sIdNnoTMm68HTK
         SVprIGXmR+/grmDp/MmjWirkAnciVVILfoG34W2XtG3BlHMFJlEPPOLqBX97mu4w6k
         Ieqz//IqdKPi/0vjlqDnyetGnixehtAzwccq0sG4an0GbNGDg//nb8N10ocowWohoR
         GirePWBGl9lgBiro/jEOM4sCiCyEiOXNaD8YmhkJPqcSv36Tia4LN5M9BtpZZaAY5h
         d0cF2EP02CP8+rVFVGMTSE5rkr9KUX+N/GMHoSvnugjjZehQ9fraGe1M3koK8JdCnQ
         prqlLVwOlgmGQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 11:11:51 +0300 (MSK)
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
Subject: [RFC PATCH v2 8/9] virtio/vsock: check SO_RCVLOWAT before wake up
 reader
Thread-Topic: [RFC PATCH v2 8/9] virtio/vsock: check SO_RCVLOWAT before wake
 up reader
Thread-Index: AQHYn/4msdZhsnhzrEat7NUwhk8xxA==
Date:   Mon, 25 Jul 2022 08:11:32 +0000
Message-ID: <821eea3a-f449-c889-4c43-6665e9421d95@sberdevices.ru>
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <12F1E4F7463A144DB443C3811EAC5452@sberdevices.ru>
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
