Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5868B5DC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 07:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBFGxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 01:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBFGxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 01:53:30 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CAD125AF;
        Sun,  5 Feb 2023 22:53:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0C29E5FD03;
        Mon,  6 Feb 2023 09:53:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666403;
        bh=b+WXxyeJ81HGb6IFMi06G8yU3v92PAG7EK/RD2ptgY8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Aa8jT9wNyLowGiBAYqbhMsZncW4BQel/ZsVMj+rtsxCalYLEn+9h3IzlomxOeIl6Q
         xWBkNEpPXf0bWbhmWWddEVEB1EmihB60lEkScFU0rwbXILzycJ41n2ALtQ89G8xd8A
         iw0ZCvQ2BPBT44W5w8P3tqws/cF1KgXd5QaVrEqJ3qIvEaJ7waEXRkjGMsglXbuuSA
         Oc+zFjuqgiS4M/YKm4aQ+pr3vgT/M1gEqChKMwkaYXXK1pawB31PcWb8MmUq2q9obK
         rPJN3HehJ3K4xYotwZewWOqxWM0/vHuBusxFgAP+ZAtmKvvrCI/DbGnZATHN28V3sU
         NLfj5iCOypX5A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 09:53:22 +0300 (MSK)
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
Subject: [RFC PATCH v1 01/12] vsock: check error queue to set EPOLLERR
Thread-Topic: [RFC PATCH v1 01/12] vsock: check error queue to set EPOLLERR
Thread-Index: AQHZOfe0xY93Ok9p00a/1VHxin2e2Q==
Date:   Mon, 6 Feb 2023 06:53:22 +0000
Message-ID: <17a276d3-1112-3431-2a33-c17f3da67470@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0000EB679691B848B3AE40385576936D@sberdevices.ru>
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

SWYgc29ja2V0J3MgZXJyb3IgcXVldWUgaXMgbm90IGVtcHR5LCBFUE9MTEVSUiBtdXN0IGJlIHNl
dC4NCg0KU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmlj
ZXMucnU+DQotLS0NCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgfCAyICstDQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQv
dm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4IDE5
YWVhN2NiYTI2ZS4uYjVlNTFlZjRhNzRjIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9hZl92
c29jay5jDQorKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC0xMDI2LDcgKzEwMjYs
NyBAQCBzdGF0aWMgX19wb2xsX3QgdnNvY2tfcG9sbChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0
IHNvY2tldCAqc29jaywNCiAJcG9sbF93YWl0KGZpbGUsIHNrX3NsZWVwKHNrKSwgd2FpdCk7DQog
CW1hc2sgPSAwOw0KIA0KLQlpZiAoc2stPnNrX2VycikNCisJaWYgKHNrLT5za19lcnIgfHwgIXNr
Yl9xdWV1ZV9lbXB0eV9sb2NrbGVzcygmc2stPnNrX2Vycm9yX3F1ZXVlKSkNCiAJCS8qIFNpZ25p
ZnkgdGhhdCB0aGVyZSBoYXMgYmVlbiBhbiBlcnJvciBvbiB0aGlzIHNvY2tldC4gKi8NCiAJCW1h
c2sgfD0gRVBPTExFUlI7DQogDQotLSANCjIuMjUuMQ0K
