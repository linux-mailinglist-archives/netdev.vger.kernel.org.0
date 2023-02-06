Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E3768B600
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjBFHDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBFHDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:03:37 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18FA6EAB;
        Sun,  5 Feb 2023 23:03:35 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 4C3175FD03;
        Mon,  6 Feb 2023 10:03:34 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675667014;
        bh=B+7PRVOOaI2lvcTHzeaPsvVUOzr1Zjh3HhP1m2qoBFo=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=l4uIPL1D9fJB9FFBwrk1cI7jtL23oGVWWZooJQ1YQ4irLYuQtpGJBAjh/4NGrEQZf
         ewRwJZTqzIyslWE/AZ8nvxzyXe+Z39p2cFOp5lLQac0IyVlDskHY4A/sZ51465bgxz
         uzriKAYIyOaixZxClp+/G/tDAwsk5mgU+OJlrzqssvopbJO1ai8s5kmpRBiIFn40sB
         YOfJaTSjDQ6XBnqf2hcnExUD89blFvCvGZy9FIVo+llsC2QHQYP8NRLFXyzimWw//Y
         CZF6R6Xl8O7hF7n58x4McXuDa8JDslAAKgEAcztPuTkr+C7aZZQcumvtpblpONTLxW
         e/SfuHiuAXTtw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:03:34 +0300 (MSK)
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
Subject: [RFC PATCH v1 10/12] net/sock: enable setting SO_ZEROCOPY for
 PF_VSOCK
Thread-Topic: [RFC PATCH v1 10/12] net/sock: enable setting SO_ZEROCOPY for
 PF_VSOCK
Thread-Index: AQHZOfkgd8nezKwWuky7m6WWWc9yqw==
Date:   Mon, 6 Feb 2023 07:03:33 +0000
Message-ID: <0ad20428-b93a-b1e5-ea10-60449d25e0b4@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B6138F15C68B647A82F25C1F6E32944@sberdevices.ru>
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

UEZfVlNPQ0sgc3VwcG9ydHMgTVNHX1pFUk9DT1BZIHRyYW5zbWlzc2lvbiwgc28gU09fWkVST0NP
UFkgY291bGQNCmJlIGVuYWJsZWQuDQoNClNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8
QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogbmV0L2NvcmUvc29jay5jIHwgNCArKyst
DQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZm
IC0tZ2l0IGEvbmV0L2NvcmUvc29jay5jIGIvbmV0L2NvcmUvc29jay5jDQppbmRleCA3YmE0ODkx
NDYwYWQuLjYxZjE1ZGU4NGU4MiAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL3NvY2suYw0KKysrIGIv
bmV0L2NvcmUvc29jay5jDQpAQCAtMTQ1Nyw5ICsxNDU3LDExIEBAIGludCBza19zZXRzb2Nrb3B0
KHN0cnVjdCBzb2NrICpzaywgaW50IGxldmVsLCBpbnQgb3B0bmFtZSwNCiAJCQkgICAgICAoc2st
PnNrX3R5cGUgPT0gU09DS19ER1JBTSAmJg0KIAkJCSAgICAgICBzay0+c2tfcHJvdG9jb2wgPT0g
SVBQUk9UT19VRFApKSkNCiAJCQkJcmV0ID0gLUVPUE5PVFNVUFA7DQotCQl9IGVsc2UgaWYgKHNr
LT5za19mYW1pbHkgIT0gUEZfUkRTKSB7DQorCQl9IGVsc2UgaWYgKHNrLT5za19mYW1pbHkgIT0g
UEZfUkRTICYmDQorCQkJICAgc2stPnNrX2ZhbWlseSAhPSBQRl9WU09DSykgew0KIAkJCXJldCA9
IC1FT1BOT1RTVVBQOw0KIAkJfQ0KKw0KIAkJaWYgKCFyZXQpIHsNCiAJCQlpZiAodmFsIDwgMCB8
fCB2YWwgPiAxKQ0KIAkJCQlyZXQgPSAtRUlOVkFMOw0KLS0gDQoyLjI1LjENCg==
