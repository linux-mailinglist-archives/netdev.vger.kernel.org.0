Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45BB68B5FD
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjBFHCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBFHCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:02:45 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C45D5249;
        Sun,  5 Feb 2023 23:02:43 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id B9F9B5FD03;
        Mon,  6 Feb 2023 10:02:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666961;
        bh=ks9MrMlvcf/mwHZsnaRwSHAcjAk0PfgI9BorakSSCfA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=iLsm55ho5IXRcNXv68DhERTg+d4OMF7NPcOecauZcewk3vfvfRvXkm+CCBo+f+Lr7
         4PWeXQ4mHJWjdmNgDIJUC6Cr5n9uh2HQ/3oj/9hcuOpeLQLD7URWLQ9wLf/VZp0RwH
         pJ69tjHmrmtQ7zf8H3LP3Zwy3QgQ/6er7RXm1fO99VSInfVsd+FJDIH4VPT8ESFEjI
         E1ojrsUHWdsLc5MWlcigrOHg2K1/U+LMLv8MeJ8tmtQDZ0ZzC1aoIf1rCArMOwRHiJ
         uzad5TpxjzePg7C3yqxVJ2szjUOWWdWWrwysq25okBvRpoEpKPMNlBrDBm3yKXLzRy
         YtHQUinlwpEUg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:02:41 +0300 (MSK)
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
Subject: [RFC PATCH v1 09/12] vsock/virtio: support MSG_ZEROCOPY for transport
Thread-Topic: [RFC PATCH v1 09/12] vsock/virtio: support MSG_ZEROCOPY for
 transport
Thread-Index: AQHZOfkBclfV0p5QrkafxT61PfKC7g==
Date:   Mon, 6 Feb 2023 07:02:41 +0000
Message-ID: <787cee22-43b7-82d9-1273-27a2d5544282@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBADECBCD9A6244CAF714E3AA55BF810@sberdevices.ru>
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

U2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+
DQotLS0NCiBuZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYyB8IDcgKysrKysrKw0KIDEg
ZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNv
Y2svdmlydGlvX3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMN
CmluZGV4IGI4YTdkNmRjOWY0Ni4uNGM1ZjE5MDE1ZGY3IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192
c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCisrKyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5z
cG9ydC5jDQpAQCAtNDMyLDYgKzQzMiwxMSBAQCBzdGF0aWMgdm9pZCB2aXJ0aW9fdnNvY2tfcnhf
ZG9uZShzdHJ1Y3QgdmlydHF1ZXVlICp2cSkNCiAJcXVldWVfd29yayh2aXJ0aW9fdnNvY2tfd29y
a3F1ZXVlLCAmdnNvY2stPnJ4X3dvcmspOw0KIH0NCiANCitzdGF0aWMgYm9vbCB2aXJ0aW9fdHJh
bnNwb3J0X21zZ3plcm9jb3B5X2FsbG93KHZvaWQpDQorew0KKwlyZXR1cm4gdHJ1ZTsNCit9DQor
DQogc3RhdGljIGJvb2wgdmlydGlvX3RyYW5zcG9ydF9zZXFwYWNrZXRfYWxsb3codTMyIHJlbW90
ZV9jaWQpOw0KIA0KIHN0YXRpYyBzdHJ1Y3QgdmlydGlvX3RyYW5zcG9ydCB2aXJ0aW9fdHJhbnNw
b3J0ID0gew0KQEAgLTQ3Niw2ICs0ODEsOCBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb190cmFuc3Bv
cnQgdmlydGlvX3RyYW5zcG9ydCA9IHsNCiAJCS5ub3RpZnlfc2VuZF9wcmVfZW5xdWV1ZSAgPSB2
aXJ0aW9fdHJhbnNwb3J0X25vdGlmeV9zZW5kX3ByZV9lbnF1ZXVlLA0KIAkJLm5vdGlmeV9zZW5k
X3Bvc3RfZW5xdWV1ZSA9IHZpcnRpb190cmFuc3BvcnRfbm90aWZ5X3NlbmRfcG9zdF9lbnF1ZXVl
LA0KIAkJLm5vdGlmeV9idWZmZXJfc2l6ZSAgICAgICA9IHZpcnRpb190cmFuc3BvcnRfbm90aWZ5
X2J1ZmZlcl9zaXplLA0KKw0KKwkJLm1zZ3plcm9jb3B5X2FsbG93ICAgICAgICA9IHZpcnRpb190
cmFuc3BvcnRfbXNnemVyb2NvcHlfYWxsb3csDQogCX0sDQogDQogCS5zZW5kX3BrdCA9IHZpcnRp
b190cmFuc3BvcnRfc2VuZF9wa3QsDQotLSANCjIuMjUuMQ0K
