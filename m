Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B159638ED1
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiKYRIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKYRIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:08:12 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0852165A8;
        Fri, 25 Nov 2022 09:08:09 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 1E46B5FD0C;
        Fri, 25 Nov 2022 20:08:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669396088;
        bh=KXyYR4VF9sCYOsS3NPi6MuVELIEouxGMJZ8BpfDIAZo=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=cyQDFrMQ8vzelcVlsjJps0cLRUAWlLytI/uP3q6P9R+5SdbJCbaQvZ9W5CFsZinZG
         oXPE+FxBfkfA98sqOGxND2adWai2xXOoqJxype2JDn4RvKQ0WGTSJa1cf+OVxwXPET
         M7YLm1wFzcDzkew3sNVRvf+RyL+RAbqVYmWFM0MSMhEvqEOMrde3dVBKl4Tf27CLQo
         fAXA2NWFMrHZ+0U1q5MHQAtZHnXADT3RRDanIbKJyB8kssS7BzHVmKps4/A8tK+Lrp
         lHgpvnTbrkVVYuoDx1KVWlDcinJwCV5u/awtMa2LCkStr7Egyuas+d0Azb3kQchsPn
         ddqI560AwAOHQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 25 Nov 2022 20:08:06 +0300 (MSK)
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 3/6] vsock/vmci: always return ENOMEM in case of error
Thread-Topic: [RFC PATCH v2 3/6] vsock/vmci: always return ENOMEM in case of
 error
Thread-Index: AQHZAPB8vpTNk9Cz/UiwVhA3FAXi7Q==
Date:   Fri, 25 Nov 2022 17:08:06 +0000
Message-ID: <675b1f93-dc07-0a70-0622-c3fc6236c8bb@sberdevices.ru>
In-Reply-To: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE8E26C4524E094488B07003CE426ABC@sberdevices.ru>
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
LnJ1Pg0KLS0tDQogbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydC5jIHwgOSArKysrKysrKy0N
CiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYg
LS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0LmMgYi9uZXQvdm13X3Zzb2NrL3Zt
Y2lfdHJhbnNwb3J0LmMNCmluZGV4IDg0MmM5NDI4NmQzMS4uMjg5YTM2YTIwM2EyIDEwMDY0NA0K
LS0tIGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydC5jDQorKysgYi9uZXQvdm13X3Zzb2Nr
L3ZtY2lfdHJhbnNwb3J0LmMNCkBAIC0xODM4LDcgKzE4MzgsMTQgQEAgc3RhdGljIHNzaXplX3Qg
dm1jaV90cmFuc3BvcnRfc3RyZWFtX2VucXVldWUoDQogCXN0cnVjdCBtc2doZHIgKm1zZywNCiAJ
c2l6ZV90IGxlbikNCiB7DQotCXJldHVybiB2bWNpX3FwYWlyX2VucXVldih2bWNpX3RyYW5zKHZz
ayktPnFwYWlyLCBtc2csIGxlbiwgMCk7DQorCWludCBlcnI7DQorDQorCWVyciA9IHZtY2lfcXBh
aXJfZW5xdWV2KHZtY2lfdHJhbnModnNrKS0+cXBhaXIsIG1zZywgbGVuLCAwKTsNCisNCisJaWYg
KGVyciA8IDApDQorCQllcnIgPSAtRU5PTUVNOw0KKw0KKwlyZXR1cm4gZXJyOw0KIH0NCiANCiBz
dGF0aWMgczY0IHZtY2lfdHJhbnNwb3J0X3N0cmVhbV9oYXNfZGF0YShzdHJ1Y3QgdnNvY2tfc29j
ayAqdnNrKQ0KLS0gDQoyLjI1LjENCg==
