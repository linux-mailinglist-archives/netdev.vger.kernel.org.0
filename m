Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB7661972
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 21:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbjAHUmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 15:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbjAHUmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 15:42:12 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF94EB7E9;
        Sun,  8 Jan 2023 12:42:10 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 3554B5FD04;
        Sun,  8 Jan 2023 23:42:09 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1673210529;
        bh=ANEKJ6F8QuXnin42o/uUpelhBVJ43NT/3G5MapBsZtg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Ah43FrNSP2uI2dIe678uY/6TdUTRa7ZwfHkgqpdmLfnr5mmuUScIy/TVtIfb2KX6U
         kPcltWqT/cVasigXc+qa6E75bn39bfdBnn9N4KO/mSSiPEFmIC8cy3B/sd3qmh/Lvv
         DL1rauFyaersSZ9xEjzcF9oDmF9pR65cm4qVjnk0eTQi/FE8FGoglO6NaBbC/gakVL
         P+5IYyUgCGzjgjlL7+CUZbs6hGqMJwqIZafF+reRghAzHALVpKhqzkzOO6v19luN5N
         Aium2RaPOaCaQB7h4pNraQYBxLM6hpudtbCFRphuPa3BlvByUGz/Em3sVonMW1F8q1
         HDHSrN7SgVW2g==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  8 Jan 2023 23:42:08 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: [PATCH net-next v6 3/4] test/vsock: add big message test
Thread-Topic: [PATCH net-next v6 3/4] test/vsock: add big message test
Thread-Index: AQHZI6Gtyb60bltUoEi5UXHBE/ekKA==
Date:   Sun, 8 Jan 2023 20:42:08 +0000
Message-ID: <39b92af5-96b9-b4d2-b6a8-125b3f060680@sberdevices.ru>
In-Reply-To: <9ad41d2b-bbe9-fe55-3aba-6a1281b6aa1b@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E684EA2101AC246A1FDD08F00A2096D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/01/08 17:38:00 #20747751
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHRlc3QgZm9yIHNlbmRpbmcgbWVzc2FnZSwgYmlnZ2VyIHRoYW4gcGVlcidzIGJ1
ZmZlciBzaXplLg0KRm9yIFNPQ0tfU0VRUEFDS0VUIHNvY2tldCBpdCBtdXN0IGZhaWwsIGFzIHRo
aXMgdHlwZSBvZiBzb2NrZXQgaGFzDQptZXNzYWdlIHNpemUgbGltaXQuDQoNClNpZ25lZC1vZmYt
Ynk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KUmV2aWV3ZWQt
Ynk6IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCi0tLQ0KIHRvb2xz
L3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgNjkgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNjkgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgYi90b29scy90ZXN0aW5nL3Zzb2Nr
L3Zzb2NrX3Rlc3QuYw0KaW5kZXggMjZjMzhhZDlkMDdiLi42N2U5ZjlkZjNhOGMgMTAwNjQ0DQot
LS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KKysrIGIvdG9vbHMvdGVzdGlu
Zy92c29jay92c29ja190ZXN0LmMNCkBAIC01NjksNiArNTY5LDcwIEBAIHN0YXRpYyB2b2lkIHRl
c3Rfc2VxcGFja2V0X3RpbWVvdXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMp
DQogCWNsb3NlKGZkKTsNCiB9DQogDQorc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfYmlnbXNn
X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJdW5zaWduZWQgbG9u
ZyBzb2NrX2J1Zl9zaXplOw0KKwlzc2l6ZV90IHNlbmRfc2l6ZTsNCisJc29ja2xlbl90IGxlbjsN
CisJdm9pZCAqZGF0YTsNCisJaW50IGZkOw0KKw0KKwlsZW4gPSBzaXplb2Yoc29ja19idWZfc2l6
ZSk7DQorDQorCWZkID0gdnNvY2tfc2VxcGFja2V0X2Nvbm5lY3Qob3B0cy0+cGVlcl9jaWQsIDEy
MzQpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImNvbm5lY3QiKTsNCisJCWV4aXQoRVhJ
VF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoZ2V0c29ja29wdChmZCwgQUZfVlNPQ0ssIFNPX1ZN
X1NPQ0tFVFNfQlVGRkVSX1NJWkUsDQorCQkgICAgICAgJnNvY2tfYnVmX3NpemUsICZsZW4pKSB7
DQorCQlwZXJyb3IoImdldHNvY2tvcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0K
Kw0KKwlzb2NrX2J1Zl9zaXplKys7DQorDQorCWRhdGEgPSBtYWxsb2Moc29ja19idWZfc2l6ZSk7
DQorCWlmICghZGF0YSkgew0KKwkJcGVycm9yKCJtYWxsb2MiKTsNCisJCWV4aXQoRVhJVF9GQUlM
VVJFKTsNCisJfQ0KKw0KKwlzZW5kX3NpemUgPSBzZW5kKGZkLCBkYXRhLCBzb2NrX2J1Zl9zaXpl
LCAwKTsNCisJaWYgKHNlbmRfc2l6ZSAhPSAtMSkgew0KKwkJZnByaW50ZihzdGRlcnIsICJleHBl
Y3RlZCAnc2VuZCgyKScgZmFpbHVyZSwgZ290ICV6aVxuIiwNCisJCQlzZW5kX3NpemUpOw0KKwkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWlmIChlcnJubyAhPSBFTVNHU0laRSkgew0K
KwkJZnByaW50ZihzdGRlcnIsICJleHBlY3RlZCBFTVNHU0laRSBpbiAnZXJybm8nLCBnb3QgJWlc
biIsDQorCQkJZXJybm8pOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRy
b2xfd3JpdGVsbigiQ0xJU0VOVCIpOw0KKw0KKwlmcmVlKGRhdGEpOw0KKwljbG9zZShmZCk7DQor
fQ0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19zZXJ2ZXIoY29uc3Qgc3Ry
dWN0IHRlc3Rfb3B0cyAqb3B0cykNCit7DQorCWludCBmZDsNCisNCisJZmQgPSB2c29ja19zZXFw
YWNrZXRfYWNjZXB0KFZNQUREUl9DSURfQU5ZLCAxMjM0LCBOVUxMKTsNCisJaWYgKGZkIDwgMCkg
ew0KKwkJcGVycm9yKCJhY2NlcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0K
Kwljb250cm9sX2V4cGVjdGxuKCJDTElTRU5UIik7DQorDQorCWNsb3NlKGZkKTsNCit9DQorDQog
I2RlZmluZSBCVUZfUEFUVEVSTl8xICdhJw0KICNkZWZpbmUgQlVGX1BBVFRFUk5fMiAnYicNCiAN
CkBAIC04NTEsNiArOTE1LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNb
XSA9IHsNCiAJCS5ydW5fY2xpZW50ID0gdGVzdF9zdHJlYW1fcG9sbF9yY3Zsb3dhdF9jbGllbnQs
DQogCQkucnVuX3NlcnZlciA9IHRlc3Rfc3RyZWFtX3BvbGxfcmN2bG93YXRfc2VydmVyLA0KIAl9
LA0KKwl7DQorCQkubmFtZSA9ICJTT0NLX1NFUVBBQ0tFVCBiaWcgbWVzc2FnZSIsDQorCQkucnVu
X2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19jbGllbnQsDQorCQkucnVuX3NlcnZlciA9
IHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07DQogDQotLSAN
CjIuMjUuMQ0K
