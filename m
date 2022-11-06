Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10861E5A7
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiKFTog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiKFToe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:44:34 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827DC5FF0;
        Sun,  6 Nov 2022 11:44:32 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9F4DF5FD04;
        Sun,  6 Nov 2022 22:44:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667763870;
        bh=Z6oRYbVeFw0g+nrdQFitukonMwA9rcY/1A4nrqySmrs=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=faJzqqiq51dEe/HKUIM/zX8RewjNgVOscJEuKRN+PlyILw5cb/A/FUZF3YERwAump
         oXJ1PEKjynCZDt/PxN1O/ckwIpeuIOlxEvodJdn2S+szcHzmBxlJzw/L7Y9wCJeHvE
         IjZsCXHBOr0W3UfY6Pj9uZ46Dc0penD7JmXB6GWmGFBRgDI/V3Ewsn8xY6ckK3+f2W
         M/ug+yD9yziT0p0aIRXThpGhlBpnKub6ZKePZHjik+VN9MUJ44NVexH9cIa6LZwxig
         IMOR8z08s89EHLQY9k/0cARdGDW/pr6a3oSIbCh0mMr/BZ4q8mlksU9VGXnfclUa9j
         3BojpOMUhyRfA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  6 Nov 2022 22:44:30 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 05/11] vhost/vsock: switch packet's buffer allocation
Thread-Topic: [RFC PATCH v3 05/11] vhost/vsock: switch packet's buffer
 allocation
Thread-Index: AQHY8hgdDSQFggGg1UqSYuJmlIYHyQ==
Date:   Sun, 6 Nov 2022 19:43:59 +0000
Message-ID: <6ec232ab-fcc6-3afb-8c38-849ad25ef6c5@sberdevices.ru>
In-Reply-To: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4547A82DCB7E9943BE87B15E62BD6DE3@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 12:52:00 #20573807
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBjaGFuZ2VzIHBhY2tldHMgYnVmZmVyIGFsbG9jYXRpb24gbG9naWMsaXQgZGVwZW5kcyBv
biB3aGV0aGVyIHJ4DQp6ZXJvY29weSBlbmFibGVkIG9yIGRpc2FibGVkIG9uIGRlc3RpbmF0aW9u
IHNvY2tldC4gVGh1cywgbm93IHNvY2tldA0KbG9va3VwIHBlcmZvcm1lZCBoZXJlLCBub3QgaW4g
J3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMnLCBhbmQgZm9yDQp6ZXJvY29weSBjYXNlLCBidWZm
ZXIgaXMgYWxsb2NhdGVkIHVzaW5nIHJhdyBjYWxscyB0byB0aGUgYnVkZHkNCmFsbG9jYXRvci4g
SWYgemVyb2NvcHkgaXMgZGlzYWJsZWQsIHRoZW4gYnVmZmVycyBhbGxvY2F0ZWQgYnkNCidrbWFs
bG9jKCknKGxpa2UgYmVmb3JlIHRoaXMgcGF0Y2gpLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5
IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIGRyaXZlcnMvdmhvc3Qv
dnNvY2suYyB8IDU2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0N
CiAxIGZpbGUgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMgYi9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMN
CmluZGV4IDZmM2Q5ZjAyY2MxZC4uMTkxYTViOTRhYTdjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy92
aG9zdC92c29jay5jDQorKysgYi9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCkBAIC0zNTQsMTAgKzM1
NCwxNCBAQCB2aG9zdF90cmFuc3BvcnRfY2FuY2VsX3BrdChzdHJ1Y3QgdnNvY2tfc29jayAqdnNr
KQ0KIA0KIHN0YXRpYyBzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdCAqDQogdmhvc3RfdnNvY2tfYWxs
b2NfcGt0KHN0cnVjdCB2aG9zdF92aXJ0cXVldWUgKnZxLA0KLQkJICAgICAgdW5zaWduZWQgaW50
IG91dCwgdW5zaWduZWQgaW50IGluKQ0KKwkJICAgICAgdW5zaWduZWQgaW50IG91dCwgdW5zaWdu
ZWQgaW50IGluLA0KKwkJICAgICAgc3RydWN0IHNvY2sgKipzaykNCiB7DQogCXN0cnVjdCB2aXJ0
aW9fdnNvY2tfcGt0ICpwa3Q7DQorCXN0cnVjdCBzb2NrYWRkcl92bSBzcmMsIGRzdDsNCisJc3Ry
dWN0IHZob3N0X3Zzb2NrICp2c29jazsNCiAJc3RydWN0IGlvdl9pdGVyIGlvdl9pdGVyOw0KKwlz
dHJ1Y3QgdnNvY2tfc29jayAqdnNrOw0KIAlzaXplX3QgbmJ5dGVzOw0KIAlzaXplX3QgbGVuOw0K
IA0KQEAgLTM4MSw2ICszODUsMTggQEAgdmhvc3RfdnNvY2tfYWxsb2NfcGt0KHN0cnVjdCB2aG9z
dF92aXJ0cXVldWUgKnZxLA0KIAkJcmV0dXJuIE5VTEw7DQogCX0NCiANCisJdnNvY2tfYWRkcl9p
bml0KCZzcmMsIGxlNjRfdG9fY3B1KHBrdC0+aGRyLnNyY19jaWQpLA0KKwkJCWxlMzJfdG9fY3B1
KHBrdC0+aGRyLnNyY19wb3J0KSk7DQorCXZzb2NrX2FkZHJfaW5pdCgmZHN0LCBsZTY0X3RvX2Nw
dShwa3QtPmhkci5kc3RfY2lkKSwNCisJCQlsZTMyX3RvX2NwdShwa3QtPmhkci5kc3RfcG9ydCkp
Ow0KKw0KKwkqc2sgPSB2c29ja19maW5kX2Nvbm5lY3RlZF9zb2NrZXQoJnNyYywgJmRzdCk7DQor
CWlmICghKCpzaykpIHsNCisJCSpzayA9IHZzb2NrX2ZpbmRfYm91bmRfc29ja2V0KCZkc3QpOw0K
KwkJaWYgKCEoKnNrKSkNCisJCQlyZXR1cm4gcGt0Ow0KKwl9DQorDQogCXBrdC0+bGVuID0gbGUz
Ml90b19jcHUocGt0LT5oZHIubGVuKTsNCiANCiAJLyogTm8gcGF5bG9hZCAqLw0KQEAgLTM5Mywx
NCArNDA5LDMyIEBAIHZob3N0X3Zzb2NrX2FsbG9jX3BrdChzdHJ1Y3Qgdmhvc3RfdmlydHF1ZXVl
ICp2cSwNCiAJCXJldHVybiBOVUxMOw0KIAl9DQogDQotCXBrdC0+YnVmID0ga3ZtYWxsb2MocGt0
LT5sZW4sIEdGUF9LRVJORUwpOw0KLQlpZiAoIXBrdC0+YnVmKSB7DQotCQlrZnJlZShwa3QpOw0K
LQkJcmV0dXJuIE5VTEw7DQotCX0NCi0NCi0JcGt0LT5zbGFiX2J1ZiA9IHRydWU7DQogCXBrdC0+
YnVmX2xlbiA9IHBrdC0+bGVuOw0KKwl2c29jayA9IGNvbnRhaW5lcl9vZih2cS0+ZGV2LCBzdHJ1
Y3Qgdmhvc3RfdnNvY2ssIGRldik7DQorDQorCXZzayA9IHZzb2NrX3NrKCpzayk7DQorDQorCWlm
ICghdnNrLT5yeF96ZXJvY29weV9vbikgew0KKwkJcGt0LT5idWYgPSBrdm1hbGxvYyhwa3QtPmxl
biwgR0ZQX0tFUk5FTCk7DQorDQorCQlpZiAoIXBrdC0+YnVmKSB7DQorCQkJa2ZyZWUocGt0KTsN
CisJCQlyZXR1cm4gTlVMTDsNCisJCX0NCisNCisJCXBrdC0+c2xhYl9idWYgPSB0cnVlOw0KKwl9
IGVsc2Ugew0KKwkJc3RydWN0IHBhZ2UgKmJ1Zl9wYWdlOw0KKw0KKwkJYnVmX3BhZ2UgPSBhbGxv
Y19wYWdlcyhHRlBfS0VSTkVMLCBnZXRfb3JkZXIocGt0LT5sZW4pKTsNCisNCisJCWlmIChidWZf
cGFnZSA9PSBOVUxMKSB7DQorCQkJa2ZyZWUocGt0KTsNCisJCQlyZXR1cm4gTlVMTDsNCisJCX0N
CisNCisJCXBrdC0+YnVmID0gcGFnZV90b192aXJ0KGJ1Zl9wYWdlKTsNCisJfQ0KIA0KIAluYnl0
ZXMgPSBjb3B5X2Zyb21faXRlcihwa3QtPmJ1ZiwgcGt0LT5sZW4sICZpb3ZfaXRlcik7DQogCWlm
IChuYnl0ZXMgIT0gcGt0LT5sZW4pIHsNCkBAIC01MTIsNiArNTQ2LDggQEAgc3RhdGljIHZvaWQg
dmhvc3RfdnNvY2tfaGFuZGxlX3R4X2tpY2soc3RydWN0IHZob3N0X3dvcmsgKndvcmspDQogDQog
CXZob3N0X2Rpc2FibGVfbm90aWZ5KCZ2c29jay0+ZGV2LCB2cSk7DQogCWRvIHsNCisJCXN0cnVj
dCBzb2NrICpzayA9IE5VTEw7DQorDQogCQlpZiAoIXZob3N0X3Zzb2NrX21vcmVfcmVwbGllcyh2
c29jaykpIHsNCiAJCQkvKiBTdG9wIHR4IHVudGlsIHRoZSBkZXZpY2UgcHJvY2Vzc2VzIGFscmVh
ZHkNCiAJCQkgKiBwZW5kaW5nIHJlcGxpZXMuICBMZWF2ZSB0eCB2aXJ0cXVldWUNCkBAIC01MzMs
NyArNTY5LDcgQEAgc3RhdGljIHZvaWQgdmhvc3RfdnNvY2tfaGFuZGxlX3R4X2tpY2soc3RydWN0
IHZob3N0X3dvcmsgKndvcmspDQogCQkJYnJlYWs7DQogCQl9DQogDQotCQlwa3QgPSB2aG9zdF92
c29ja19hbGxvY19wa3QodnEsIG91dCwgaW4pOw0KKwkJcGt0ID0gdmhvc3RfdnNvY2tfYWxsb2Nf
cGt0KHZxLCBvdXQsIGluLCAmc2spOw0KIAkJaWYgKCFwa3QpIHsNCiAJCQl2cV9lcnIodnEsICJG
YXVsdGVkIG9uIHBrdFxuIik7DQogCQkJY29udGludWU7DQpAQCAtNTQ4LDcgKzU4NCw3IEBAIHN0
YXRpYyB2b2lkIHZob3N0X3Zzb2NrX2hhbmRsZV90eF9raWNrKHN0cnVjdCB2aG9zdF93b3JrICp3
b3JrKQ0KIAkJaWYgKGxlNjRfdG9fY3B1KHBrdC0+aGRyLnNyY19jaWQpID09IHZzb2NrLT5ndWVz
dF9jaWQgJiYNCiAJCSAgICBsZTY0X3RvX2NwdShwa3QtPmhkci5kc3RfY2lkKSA9PQ0KIAkJICAg
IHZob3N0X3RyYW5zcG9ydF9nZXRfbG9jYWxfY2lkKCkpDQotCQkJdmlydGlvX3RyYW5zcG9ydF9y
ZWN2X3BrdCgmdmhvc3RfdHJhbnNwb3J0LCBOVUxMLCBwa3QpOw0KKwkJCXZpcnRpb190cmFuc3Bv
cnRfcmVjdl9wa3QoJnZob3N0X3RyYW5zcG9ydCwgc2ssIHBrdCk7DQogCQllbHNlDQogCQkJdmly
dGlvX3RyYW5zcG9ydF9mcmVlX3BrdChwa3QpOw0KIA0KLS0gDQoyLjM1LjANCg==
