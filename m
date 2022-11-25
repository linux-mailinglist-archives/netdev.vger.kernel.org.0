Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D7C638EC6
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiKYRF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKYRF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:05:57 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12C64509E;
        Fri, 25 Nov 2022 09:05:56 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 216685FD0B;
        Fri, 25 Nov 2022 20:05:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669395955;
        bh=6S4rZ+E4xI3yfUr3aYJ38SvqnWz2eVSuw2pv6/QpiK8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=r1T5ehDxv8YVZlA5nOFJ9LzIPKkiUXT6333nm/rTdPH0LX6W+e6PF1fd7LkHxMrMr
         XFDB3pYhv3VmidVeaO6vnGnLNUqbreGVaj2XORwqIUfzKzPzCIX/RnymjWD33ItOVA
         WmwDxpNNuFUQ+Jsz/10mza82fn4fAcoTsC1WxNO2e+hOhB+aJIuqndSzM6utWc5ISN
         SofdJbAVTmrMV4JarvyPSPMN+/cyTbySixH3NXETMZMxqM8alurRANZMLadUE4aVGl
         Ti82ieK4EGFcnvg0OHOcRNKqGgVx4lMZmsWJYz9uxGw/+6zg5MCBcXrx0FEd/57LRM
         it8WNLdzEEn3Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 25 Nov 2022 20:05:54 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 2/6] hv_sock: always return ENOMEM in case of error
Thread-Topic: [RFC PATCH v2 2/6] hv_sock: always return ENOMEM in case of
 error
Thread-Index: AQHZAPAtTYc9d9ztWkmT9FbeEy5mXA==
Date:   Fri, 25 Nov 2022 17:05:53 +0000
Message-ID: <a10ffbed-848d-df8c-ec4e-ba25c4c8e3e8@sberdevices.ru>
In-Reply-To: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <77BCA4140E868A459BF33144BC93E2B5@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/25 14:59:00 #20610704
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9iYnkgRXNobGVtYW4gPGJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20+DQoNClRo
aXMgc2F2ZXMgb3JpZ2luYWwgYmVoYXZpb3VyIGZyb20gYWZfdnNvY2suYyAtIHN3aXRjaCBhbnkg
ZXJyb3INCmNvZGUgcmV0dXJuZWQgZnJvbSB0cmFuc3BvcnQgbGF5ZXIgdG8gRU5PTUVNLg0KDQpT
aWduZWQtb2ZmLWJ5OiBCb2JieSBFc2hsZW1hbiA8Ym9iYnkuZXNobGVtYW5AYnl0ZWRhbmNlLmNv
bT4NClNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2Vz
LnJ1Pg0KLS0tDQogbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMgfCAyICstDQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQg
YS9uZXQvdm13X3Zzb2NrL2h5cGVydl90cmFuc3BvcnQuYyBiL25ldC92bXdfdnNvY2svaHlwZXJ2
X3RyYW5zcG9ydC5jDQppbmRleCA1OWMzZTI2OTcwNjkuLmZiYmU1NTEzM2RhMiAxMDA2NDQNCi0t
LSBhL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jDQorKysgYi9uZXQvdm13X3Zzb2Nr
L2h5cGVydl90cmFuc3BvcnQuYw0KQEAgLTY4Nyw3ICs2ODcsNyBAQCBzdGF0aWMgc3NpemVfdCBo
dnNfc3RyZWFtX2VucXVldWUoc3RydWN0IHZzb2NrX3NvY2sgKnZzaywgc3RydWN0IG1zZ2hkciAq
bXNnLA0KIAlpZiAoYnl0ZXNfd3JpdHRlbikNCiAJCXJldCA9IGJ5dGVzX3dyaXR0ZW47DQogCWtm
cmVlKHNlbmRfYnVmKTsNCi0JcmV0dXJuIHJldDsNCisJcmV0dXJuIHJldCA8IDAgPyAtRU5PTUVN
IDogcmV0Ow0KIH0NCiANCiBzdGF0aWMgczY0IGh2c19zdHJlYW1faGFzX2RhdGEoc3RydWN0IHZz
b2NrX3NvY2sgKnZzaykNCi0tIA0KMi4yNS4xDQo=
