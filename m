Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE27D68B5E0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 07:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBFG4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 01:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBFG4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 01:56:23 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B268A1C334;
        Sun,  5 Feb 2023 22:55:41 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EFD595FD03;
        Mon,  6 Feb 2023 09:54:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666492;
        bh=O6cNhFQfaQVbXViC73z339ui0JNnZlXbWLyqE8Ijrl8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=iyMC2qGOlxJHnyrtSHhiLmBbkFt1ReQMWF6JCPtKx1U3BHXEZzSg/vvvrhTRxOBHQ
         SARUIdXkMVs4hgCp+RjZT3HFbSIn7thgeGXq1S7Q9/73C3ae4bGoc8m7qroQIysiXe
         gUK6ZTwdE0IeB4CNRQJ6YiovOZSIIl+4gD00vpovkGqSVFToVlvhdrt2csc81sOvfr
         ahuKwjdBHwzkx5hsGImwK2Z1f+/R5LgAldHJTjzI7pnuQ5xSG8cKpKwFDqWWkvNfK4
         9vAtQnpkZQf9Rsyol7bryGyBe8zVDCwJ7uqjcdUvzHYFT/+q1Ke+wyYMh5fkRM0BjV
         qe9nS0kFeRteA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 09:54:51 +0300 (MSK)
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
Subject: [RFC PATCH v1 02/12] vsock: read from socket's error queue
Thread-Topic: [RFC PATCH v1 02/12] vsock: read from socket's error queue
Thread-Index: AQHZOffoRZzBrg9vIUiTEqCzeANM9A==
Date:   Mon, 6 Feb 2023 06:54:51 +0000
Message-ID: <7b2f00ce-296c-3f59-9861-468c6340300e@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E161FFF127651478A2DC3B377174E34@sberdevices.ru>
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

VGhpcyBhZGRzIGhhbmRsaW5nIG9mIE1TR19FUlJRVUVVRSBpbnB1dCBmbGFnIGZvciByZWNlaXZl
IGNhbGwsIHRodXMNCnNrYiBmcm9tIHNvY2tldCdzIGVycm9yIHF1ZXVlIGlzIHJlYWQuDQoNClNp
Z25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0K
LS0tDQogaW5jbHVkZS9saW51eC9zb2NrZXQuaCAgIHwgIDEgKw0KIG5ldC92bXdfdnNvY2svYWZf
dnNvY2suYyB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2Vk
LCAyNyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NvY2tldC5o
IGIvaW5jbHVkZS9saW51eC9zb2NrZXQuaA0KaW5kZXggMTNjM2EyMzdiOWM5Li4xOWE2ZjM5ZmEw
MTQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3NvY2tldC5oDQorKysgYi9pbmNsdWRlL2xp
bnV4L3NvY2tldC5oDQpAQCAtMzc5LDYgKzM3OSw3IEBAIHN0cnVjdCB1Y3JlZCB7DQogI2RlZmlu
ZSBTT0xfTVBUQ1AJMjg0DQogI2RlZmluZSBTT0xfTUNUUAkyODUNCiAjZGVmaW5lIFNPTF9TTUMJ
CTI4Ng0KKyNkZWZpbmUgU09MX1ZTT0NLCTI4Nw0KIA0KIC8qIElQWCBvcHRpb25zICovDQogI2Rl
ZmluZSBJUFhfVFlQRQkxDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9hZl92c29jay5jIGIv
bmV0L3Ztd192c29jay9hZl92c29jay5jDQppbmRleCBiNWU1MWVmNGE3NGMuLmY3NTJiMzBiNzFk
NiAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KKysrIGIvbmV0L3Ztd192
c29jay9hZl92c29jay5jDQpAQCAtMTEwLDYgKzExMCw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3dv
cmtxdWV1ZS5oPg0KICNpbmNsdWRlIDxuZXQvc29jay5oPg0KICNpbmNsdWRlIDxuZXQvYWZfdnNv
Y2suaD4NCisjaW5jbHVkZSA8bGludXgvZXJycXVldWUuaD4NCiANCiBzdGF0aWMgaW50IF9fdnNv
Y2tfYmluZChzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBzb2NrYWRkcl92bSAqYWRkcik7DQogc3Rh
dGljIHZvaWQgdnNvY2tfc2tfZGVzdHJ1Y3Qoc3RydWN0IHNvY2sgKnNrKTsNCkBAIC0yMDg2LDYg
KzIwODcsMjcgQEAgc3RhdGljIGludCBfX3Zzb2NrX3NlcXBhY2tldF9yZWN2bXNnKHN0cnVjdCBz
b2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLA0KIAlyZXR1cm4gZXJyOw0KIH0NCiANCitzdGF0
aWMgaW50IHZzb2NrX2Vycl9yZWN2bXNnKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAq
bXNnKQ0KK3sNCisJc3RydWN0IHNvY2tfZXh0ZW5kZWRfZXJyICplZTsNCisJc3RydWN0IHNrX2J1
ZmYgKnNrYjsNCisJaW50IGVycjsNCisNCisJbG9ja19zb2NrKHNrKTsNCisJc2tiID0gc29ja19k
ZXF1ZXVlX2Vycl9za2Ioc2spOw0KKwlyZWxlYXNlX3NvY2soc2spOw0KKw0KKwlpZiAoIXNrYikN
CisJCXJldHVybiAtRUFHQUlOOw0KKw0KKwllZSA9ICZTS0JfRVhUX0VSUihza2IpLT5lZTsNCisJ
ZXJyID0gcHV0X2Ntc2cobXNnLCBTT0xfVlNPQ0ssIDAsIHNpemVvZigqZWUpLCBlZSk7DQorCW1z
Zy0+bXNnX2ZsYWdzIHw9IE1TR19FUlJRVUVVRTsNCisJY29uc3VtZV9za2Ioc2tiKTsNCisNCisJ
cmV0dXJuIGVycjsNCit9DQorDQogc3RhdGljIGludA0KIHZzb2NrX2Nvbm5lY3RpYmxlX3JlY3Zt
c2coc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0IG1zZ2hkciAqbXNnLCBzaXplX3QgbGVuLA0K
IAkJCSAgaW50IGZsYWdzKQ0KQEAgLTIwOTYsNiArMjExOCwxMCBAQCB2c29ja19jb25uZWN0aWJs
ZV9yZWN2bXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6ZV90
IGxlbiwNCiAJaW50IGVycjsNCiANCiAJc2sgPSBzb2NrLT5zazsNCisNCisJaWYgKHVubGlrZWx5
KGZsYWdzICYgTVNHX0VSUlFVRVVFKSkNCisJCXJldHVybiB2c29ja19lcnJfcmVjdm1zZyhzaywg
bXNnKTsNCisNCiAJdnNrID0gdnNvY2tfc2soc2spOw0KIAllcnIgPSAwOw0KIA0KLS0gDQoyLjI1
LjENCg==
