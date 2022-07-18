Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE766577D5D
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiGRIUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiGRIT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:19:59 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C9417056;
        Mon, 18 Jul 2022 01:19:57 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 1A3DF5FD02;
        Mon, 18 Jul 2022 11:19:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658132396;
        bh=3T6O41NlBXfvtTgteoGhbCjYTT3urPlJ/Ul1XBHbcwI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=meEgdfCrGtogIlee0jzKtl7NK3aKaY+Yxds0yzc7qbhWtM3dY36yJQat6q5Bw1f6U
         uGxJ/FXDLklqRLlzLka6HPc9dhAuDUxMuBbpv8KQArv3g5Iv6iHUdnTWnU+iOggZbr
         +imj63QLGWA3mnjtVHq5ih7SoTqMN+BsUnmlwAJPcmmjiuHInfXaNkK+/s+w0l4zM6
         OVMRdC/VE/dykBX4jDXMPWaZWtGY58L1DE1Xhhahwr4THc9d7AqsEcvZ5bN5GZdShL
         6rh8L//wc1F1fxI33OPGKHOT/b9giqtYg0uhNbHQqd+GjOoXna1QTG5broXLhWqv08
         61J/nrDNFiPzw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 18 Jul 2022 11:19:55 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Thread-Topic: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Thread-Index: AQHYmn8L0QxAqOPQQUWV5xnNPUkeXw==
Date:   Mon, 18 Jul 2022 08:19:06 +0000
Message-ID: <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
In-Reply-To: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <530D1D0E04DDF84FACFB4AB9CB69387E@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/18 02:31:00 #19923013
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHRlc3QgdG8gY2hlY2ssIHRoYXQgd2hlbiBwb2xsKCkgcmV0dXJucyBQT0xMSU4g
YW5kDQpQT0xMUkROT1JNIGJpdHMsIG5leHQgcmVhZCBjYWxsIHdvbid0IGJsb2NrLg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0t
LQ0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgOTAgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgOTAgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgYi90b29scy90ZXN0
aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KaW5kZXggZGM1Nzc0NjFhZmMyLi44ZTM5NDQ0M2VhZjYg
MTAwNjQ0DQotLS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KKysrIGIvdG9v
bHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCkBAIC0xOCw2ICsxOCw3IEBADQogI2luY2x1
ZGUgPHN5cy9zb2NrZXQuaD4NCiAjaW5jbHVkZSA8dGltZS5oPg0KICNpbmNsdWRlIDxzeXMvbW1h
bi5oPg0KKyNpbmNsdWRlIDxwb2xsLmg+DQogDQogI2luY2x1ZGUgInRpbWVvdXQuaCINCiAjaW5j
bHVkZSAiY29udHJvbC5oIg0KQEAgLTU5Niw2ICs1OTcsOTAgQEAgc3RhdGljIHZvaWQgdGVzdF9z
ZXFwYWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRz
ICpvcHQNCiAJY2xvc2UoZmQpOw0KIH0NCiANCitzdGF0aWMgdm9pZCB0ZXN0X3N0cmVhbV9wb2xs
X3Jjdmxvd2F0X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisjZGVm
aW5lIFJDVkxPV0FUX0JVRl9TSVpFIDEyOA0KKwlpbnQgZmQ7DQorCWludCBpOw0KKw0KKwlmZCA9
IHZzb2NrX3N0cmVhbV9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0KKwlpZiAo
ZmQgPCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0K
Kwl9DQorDQorCS8qIFNlbmQgMSBieXRlLiAqLw0KKwlzZW5kX2J5dGUoZmQsIDEsIDApOw0KKw0K
Kwljb250cm9sX3dyaXRlbG4oIlNSVlNFTlQiKTsNCisNCisJLyogSnVzdCBlbXBpcmljYWxseSBk
ZWxheSB2YWx1ZS4gKi8NCisJc2xlZXAoNCk7DQorDQorCWZvciAoaSA9IDA7IGkgPCBSQ1ZMT1dB
VF9CVUZfU0laRSAtIDE7IGkrKykNCisJCXNlbmRfYnl0ZShmZCwgMSwgMCk7DQorDQorCS8qIEtl
ZXAgc29ja2V0IGluIGFjdGl2ZSBzdGF0ZS4gKi8NCisJY29udHJvbF9leHBlY3RsbigiUE9MTERP
TkUiKTsNCisNCisJY2xvc2UoZmQpOw0KK30NCisNCitzdGF0aWMgdm9pZCB0ZXN0X3N0cmVhbV9w
b2xsX3Jjdmxvd2F0X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJ
dW5zaWduZWQgbG9uZyBsb3dhdF92YWwgPSBSQ1ZMT1dBVF9CVUZfU0laRTsNCisJY2hhciBidWZb
UkNWTE9XQVRfQlVGX1NJWkVdOw0KKwlzdHJ1Y3QgcG9sbGZkIGZkczsNCisJc3NpemVfdCByZWFk
X3JlczsNCisJc2hvcnQgcG9sbF9mbGFnczsNCisJaW50IGZkOw0KKw0KKwlmZCA9IHZzb2NrX3N0
cmVhbV9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCisJaWYgKGZkIDwgMCkgew0KKwkJ
cGVycm9yKCJjb25uZWN0Iik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJaWYg
KHNldHNvY2tvcHQoZmQsIFNPTF9TT0NLRVQsIFNPX1JDVkxPV0FULA0KKwkJCSZsb3dhdF92YWws
IHNpemVvZihsb3dhdF92YWwpKSkgew0KKwkJcGVycm9yKCJzZXRzb2Nrb3B0Iik7DQorCQlleGl0
KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJY29udHJvbF9leHBlY3RsbigiU1JWU0VOVCIpOw0K
Kw0KKwkvKiBBdCB0aGlzIHBvaW50LCBzZXJ2ZXIgc2VudCAxIGJ5dGUuICovDQorCWZkcy5mZCA9
IGZkOw0KKwlwb2xsX2ZsYWdzID0gUE9MTElOIHwgUE9MTFJETk9STTsNCisJZmRzLmV2ZW50cyA9
IHBvbGxfZmxhZ3M7DQorDQorCWlmIChwb2xsKCZmZHMsIDEsIC0xKSA8IDApIHsNCisJCXBlcnJv
cigicG9sbCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCS8qIE9ubHkgdGhl
c2UgdHdvIGJpdHMgYXJlIGV4cGVjdGVkLiAqLw0KKwlpZiAoZmRzLnJldmVudHMgIT0gcG9sbF9m
bGFncykgew0KKwkJZnByaW50ZihzdGRlcnIsICJVbmV4cGVjdGVkIHBvbGwgcmVzdWx0ICVoeFxu
IiwNCisJCQlmZHMucmV2ZW50cyk7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJ
LyogVXNlIE1TR19ET05UV0FJVCwgaWYgY2FsbCBpcyBnb2luZyB0byB3YWl0LCBFQUdBSU4NCisJ
ICogd2lsbCBiZSByZXR1cm5lZC4NCisJICovDQorCXJlYWRfcmVzID0gcmVjdihmZCwgYnVmLCBz
aXplb2YoYnVmKSwgTVNHX0RPTlRXQUlUKTsNCisJaWYgKHJlYWRfcmVzICE9IFJDVkxPV0FUX0JV
Rl9TSVpFKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwgIlVuZXhwZWN0ZWQgcmVjdiByZXN1bHQgJXpp
XG4iLA0KKwkJCXJlYWRfcmVzKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlj
b250cm9sX3dyaXRlbG4oIlBPTExET05FIik7DQorDQorCWNsb3NlKGZkKTsNCit9DQorDQogc3Rh
dGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0KIAl7DQogCQkubmFtZSA9ICJT
T0NLX1NUUkVBTSBjb25uZWN0aW9uIHJlc2V0IiwNCkBAIC02NDYsNiArNzMxLDExIEBAIHN0YXRp
YyBzdHJ1Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCiAJCS5ydW5fY2xpZW50ID0gdGVz
dF9zZXFwYWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX2NsaWVudCwNCiAJCS5ydW5fc2VydmVyID0g
dGVzdF9zZXFwYWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX3NlcnZlciwNCiAJfSwNCisJew0KKwkJ
Lm5hbWUgPSAiU09DS19TVFJFQU0gcG9sbCgpICsgU09fUkNWTE9XQVQiLA0KKwkJLnJ1bl9jbGll
bnQgPSB0ZXN0X3N0cmVhbV9wb2xsX3Jjdmxvd2F0X2NsaWVudCwNCisJCS5ydW5fc2VydmVyID0g
dGVzdF9zdHJlYW1fcG9sbF9yY3Zsb3dhdF9zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07DQogDQot
LSANCjIuMjUuMQ0K
