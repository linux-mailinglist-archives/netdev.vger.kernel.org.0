Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D949E68B5F2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 07:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjBFG72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 01:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBFG71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 01:59:27 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFB130F0;
        Sun,  5 Feb 2023 22:59:23 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 934FF5FD03;
        Mon,  6 Feb 2023 09:59:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666761;
        bh=iyACDNtFEIsHltnXG+ySQX2fasSDQiF7Yuq0gz9yqsQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=d6MsAvATUavP20XbY45f8BnjkeT4HelwAa47K+EmXLQJBgIPLkEBtTxBabq9Wb49O
         CkAwduOWqsKVrRISbwq9xq1bI0hhhsrhmkX3Syapz6xLLI0Nj+JbXDD8e/JmhMqWOu
         BdjD/ZS58bZ3gFSGhn1MpjkSG2pN+WlC81X4zGqtisXSGQVgg+7mNSaxX9KJdRxQlX
         dVRNc5GTARksDDgyJG/FubDwmAeZ7qgOBtiq25zWRRHy8YiASBw0/IcsXSLb9q6fWH
         EP/qq0QIST6Pg+gjES8znN4UGtS/PxEUwUnVuH/q/AMnuEARRt/hKbMdH4/S8mOS07
         GSq8FB6ac6cmg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 09:59:21 +0300 (MSK)
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
Subject: [RFC PATCH v1 06/12] vsock/virtio: non-linear skb handling for TAP
 dev
Thread-Topic: [RFC PATCH v1 06/12] vsock/virtio: non-linear skb handling for
 TAP dev
Thread-Index: AQHZOfiJxMkNoIhc8E+iz5K/W09Rxg==
Date:   Mon, 6 Feb 2023 06:59:21 +0000
Message-ID: <ebee740a-95df-ed52-6274-a9340e8dc9d2@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A34F74EA281224884E6A4D1F6C61275@sberdevices.ru>
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

Rm9yIFRBUCBkZXZpY2UgbmV3IHNrYiBpcyBjcmVhdGVkIGFuZCBkYXRhIGZyb20gdGhlIGN1cnJl
bnQgc2tiIGlzDQpjb3BpZWQgdG8gaXQuIFRoaXMgYWRkcyBjb3B5aW5nIGRhdGEgZnJvbSBub24t
bGluZWFyIHNrYiB0byBuZXcNCnRoZSBza2IuDQoNClNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jh
c25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogbmV0L3Ztd192c29jay92aXJ0
aW9fdHJhbnNwb3J0X2NvbW1vbi5jIHwgNDMgKysrKysrKysrKysrKysrKysrKysrKystLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCA0MCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIGIvbmV0L3Ztd192
c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQppbmRleCBhMTU4MWM3N2NmODQuLjA1Y2U5
N2I5NjdhZCAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21t
b24uYw0KKysrIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQpAQCAt
MTAxLDYgKzEwMSwzOSBAQCB2aXJ0aW9fdHJhbnNwb3J0X2FsbG9jX3NrYihzdHJ1Y3QgdmlydGlv
X3Zzb2NrX3BrdF9pbmZvICppbmZvLA0KIAlyZXR1cm4gTlVMTDsNCiB9DQogDQorc3RhdGljIHZv
aWQgdmlydGlvX3RyYW5zcG9ydF9jb3B5X25vbmxpbmVhcl9za2Ioc3RydWN0IHNrX2J1ZmYgKnNr
YiwNCisJCQkJCQl2b2lkICpkc3QsDQorCQkJCQkJc2l6ZV90IGxlbikNCit7DQorCXNpemVfdCBy
ZXN0X2xlbiA9IGxlbjsNCisNCisJd2hpbGUgKHJlc3RfbGVuICYmIHZpcnRpb192c29ja19za2Jf
aGFzX2ZyYWdzKHNrYikpIHsNCisJCXN0cnVjdCBiaW9fdmVjICpjdXJyX3ZlYzsNCisJCXNpemVf
dCBjdXJyX3ZlY19lbmQ7DQorCQlzaXplX3QgdG9fY29weTsNCisJCWludCBjdXJyX2ZyYWc7DQor
CQlpbnQgY3Vycl9vZmZzOw0KKw0KKwkJY3Vycl9mcmFnID0gVklSVElPX1ZTT0NLX1NLQl9DQihz
a2IpLT5jdXJyX2ZyYWc7DQorCQljdXJyX29mZnMgPSBWSVJUSU9fVlNPQ0tfU0tCX0NCKHNrYikt
PmZyYWdfb2ZmOw0KKwkJY3Vycl92ZWMgPSAmc2tiX3NoaW5mbyhza2IpLT5mcmFnc1tjdXJyX2Zy
YWddOw0KKw0KKwkJY3Vycl92ZWNfZW5kID0gY3Vycl92ZWMtPmJ2X29mZnNldCArIGN1cnJfdmVj
LT5idl9sZW47DQorCQl0b19jb3B5ID0gbWluKHJlc3RfbGVuLCAoc2l6ZV90KShjdXJyX3ZlY19l
bmQgLSBjdXJyX29mZnMpKTsNCisNCisJCW1lbWNweShkc3QsIHBhZ2VfdG9fdmlydChjdXJyX3Zl
Yy0+YnZfcGFnZSkgKyBjdXJyX29mZnMsDQorCQkgICAgICAgdG9fY29weSk7DQorDQorCQlyZXN0
X2xlbiAtPSB0b19jb3B5Ow0KKwkJVklSVElPX1ZTT0NLX1NLQl9DQihza2IpLT5mcmFnX29mZiAr
PSB0b19jb3B5Ow0KKw0KKwkJaWYgKFZJUlRJT19WU09DS19TS0JfQ0Ioc2tiKS0+ZnJhZ19vZmYg
PT0gKGN1cnJfdmVjX2VuZCkpIHsNCisJCQlWSVJUSU9fVlNPQ0tfU0tCX0NCKHNrYiktPmN1cnJf
ZnJhZysrOw0KKwkJCVZJUlRJT19WU09DS19TS0JfQ0Ioc2tiKS0+ZnJhZ19vZmYgPSAwOw0KKwkJ
fQ0KKwl9DQorfQ0KKw0KIC8qIFBhY2tldCBjYXB0dXJlICovDQogc3RhdGljIHN0cnVjdCBza19i
dWZmICp2aXJ0aW9fdHJhbnNwb3J0X2J1aWxkX3NrYih2b2lkICpvcGFxdWUpDQogew0KQEAgLTEw
OSw3ICsxNDIsNiBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKnZpcnRpb190cmFuc3BvcnRfYnVp
bGRfc2tiKHZvaWQgKm9wYXF1ZSkNCiAJc3RydWN0IGFmX3Zzb2NrbW9uX2hkciAqaGRyOw0KIAlz
dHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KIAlzaXplX3QgcGF5bG9hZF9sZW47DQotCXZvaWQgKnBheWxv
YWRfYnVmOw0KIA0KIAkvKiBBIHBhY2tldCBjb3VsZCBiZSBzcGxpdCB0byBmaXQgdGhlIFJYIGJ1
ZmZlciwgc28gd2UgY2FuIHJldHJpZXZlDQogCSAqIHRoZSBwYXlsb2FkIGxlbmd0aCBmcm9tIHRo
ZSBoZWFkZXIgYW5kIHRoZSBidWZmZXIgcG9pbnRlciB0YWtpbmcNCkBAIC0xMTcsNyArMTQ5LDYg
QEAgc3RhdGljIHN0cnVjdCBza19idWZmICp2aXJ0aW9fdHJhbnNwb3J0X2J1aWxkX3NrYih2b2lk
ICpvcGFxdWUpDQogCSAqLw0KIAlwa3RfaGRyID0gdmlydGlvX3Zzb2NrX2hkcihwa3QpOw0KIAlw
YXlsb2FkX2xlbiA9IHBrdC0+bGVuOw0KLQlwYXlsb2FkX2J1ZiA9IHBrdC0+ZGF0YTsNCiANCiAJ
c2tiID0gYWxsb2Nfc2tiKHNpemVvZigqaGRyKSArIHNpemVvZigqcGt0X2hkcikgKyBwYXlsb2Fk
X2xlbiwNCiAJCQlHRlBfQVRPTUlDKTsNCkBAIC0xNjAsNyArMTkxLDEzIEBAIHN0YXRpYyBzdHJ1
Y3Qgc2tfYnVmZiAqdmlydGlvX3RyYW5zcG9ydF9idWlsZF9za2Iodm9pZCAqb3BhcXVlKQ0KIAlz
a2JfcHV0X2RhdGEoc2tiLCBwa3RfaGRyLCBzaXplb2YoKnBrdF9oZHIpKTsNCiANCiAJaWYgKHBh
eWxvYWRfbGVuKSB7DQotCQlza2JfcHV0X2RhdGEoc2tiLCBwYXlsb2FkX2J1ZiwgcGF5bG9hZF9s
ZW4pOw0KKwkJaWYgKHNrYl9pc19ub25saW5lYXIoc2tiKSkgew0KKwkJCXZvaWQgKmRhdGEgPSBz
a2JfcHV0KHNrYiwgcGF5bG9hZF9sZW4pOw0KKw0KKwkJCXZpcnRpb190cmFuc3BvcnRfY29weV9u
b25saW5lYXJfc2tiKHNrYiwgZGF0YSwgcGF5bG9hZF9sZW4pOw0KKwkJfSBlbHNlIHsNCisJCQlz
a2JfcHV0X2RhdGEoc2tiLCBwa3QtPmRhdGEsIHBheWxvYWRfbGVuKTsNCisJCX0NCiAJfQ0KIA0K
IAlyZXR1cm4gc2tiOw0KLS0gDQoyLjI1LjENCg==
