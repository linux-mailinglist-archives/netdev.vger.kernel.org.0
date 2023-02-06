Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DC568B60B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjBFHGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjBFHGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:06:40 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6361ABC3;
        Sun,  5 Feb 2023 23:06:34 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0B0025FD03;
        Mon,  6 Feb 2023 10:06:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675667193;
        bh=6pMqrPyHGPQW1VgQ8Akh86QM+ETIOMVEMR7fJ2NeMG8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=IGO63hiBq7CW+U4nicOdwQ0xr1f/HcwilSpOFPbuMFJ/sZGQEMyzvz3Blh72Mexz1
         9Mb6QcD4SPSQdhnvIl0NaeBT7++gaG/ZOkTuxrLv/sVIroJfl0QcppQTMw/X5IajvL
         aueaHKIeYE+L0RARt5or1Jqk7G8NJHCzXV1gSg+9ogb0n6/jwOdGhEZ4wIm4GPG0xW
         T3hJhbs68KjhurIknbSfklgLiEiLzwsAm7E1OtmFvwXa4l5P1z4oQk3ZhThlVvKRWp
         zwATTx+GyuxEZqYrlb/czAJRol2CX5zbbC9i0JaSZWEjV+7qCSrVWYxhFWncXGwu8Y
         ofKoMfgqI+UUA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:06:32 +0300 (MSK)
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
Subject: [RFC PATCH v1 12/12] test/vsock: MSG_ZEROCOPY support for vsock_perf
Thread-Topic: [RFC PATCH v1 12/12] test/vsock: MSG_ZEROCOPY support for
 vsock_perf
Thread-Index: AQHZOfmKbgKypo6Z8EmH8tGoyYFWVw==
Date:   Mon, 6 Feb 2023 07:06:32 +0000
Message-ID: <03570f48-f56a-2af4-9579-15a685127aeb@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <26536C37BB13B643B0FDC846754C9890@sberdevices.ru>
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

VG8gdXNlIHRoaXMgb3B0aW9uIHBhc3MgJy0temMnIHBhcmFtZXRlcjoNCg0KLi92c29ja19wZXJm
IC0temMgLS1zZW5kZXIgPGNpZD4gLS1wb3J0IDxwb3J0PiAtLWJ5dGVzIDxieXRlcyB0byBzZW5k
Pg0KDQpXaXRoIHRoaXMgb3B0aW9uIE1TR19aRVJPQ09QWSBmbGFnIHdpbGwgYmUgcGFzc2VkIHRv
IHRoZSAnc2VuZCgpJyBjYWxsLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFW
S3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tf
cGVyZi5jIHwgMTI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCiAxIGZpbGUgY2hh
bmdlZCwgMTIwIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS90
b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3BlcmYuYyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNv
Y2tfcGVyZi5jDQppbmRleCBhNzI1MjAzMzhmODQuLjFkNDM1YmU5YjQ4ZSAxMDA2NDQNCi0tLSBh
L3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfcGVyZi5jDQorKysgYi90b29scy90ZXN0aW5nL3Zz
b2NrL3Zzb2NrX3BlcmYuYw0KQEAgLTE4LDYgKzE4LDggQEANCiAjaW5jbHVkZSA8cG9sbC5oPg0K
ICNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3ZtX3NvY2tldHMuaD4N
CisjaW5jbHVkZSA8c3lzL21tYW4uaD4NCisjaW5jbHVkZSA8bGludXgvZXJycXVldWUuaD4NCiAN
CiAjZGVmaW5lIERFRkFVTFRfQlVGX1NJWkVfQllURVMJKDEyOCAqIDEwMjQpDQogI2RlZmluZSBE
RUZBVUxUX1RPX1NFTkRfQllURVMJKDY0ICogMTAyNCkNCkBAIC0yOCw5ICszMCwxNCBAQA0KICNk
ZWZpbmUgQllURVNfUEVSX0dCCQkoMTAyNCAqIDEwMjQgKiAxMDI0VUxMKQ0KICNkZWZpbmUgTlNF
Q19QRVJfU0VDCQkoMTAwMDAwMDAwMFVMTCkNCiANCisjaWZuZGVmIFNPTF9WU09DSw0KKyNkZWZp
bmUgU09MX1ZTT0NLIDI4Nw0KKyNlbmRpZg0KKw0KIHN0YXRpYyB1bnNpZ25lZCBpbnQgcG9ydCA9
IERFRkFVTFRfUE9SVDsNCiBzdGF0aWMgdW5zaWduZWQgbG9uZyBidWZfc2l6ZV9ieXRlcyA9IERF
RkFVTFRfQlVGX1NJWkVfQllURVM7DQogc3RhdGljIHVuc2lnbmVkIGxvbmcgdnNvY2tfYnVmX2J5
dGVzID0gREVGQVVMVF9WU09DS19CVUZfQllURVM7DQorc3RhdGljIGJvb2wgemVyb2NvcHk7DQog
DQogc3RhdGljIHZvaWQgZXJyb3IoY29uc3QgY2hhciAqcykNCiB7DQpAQCAtMjQ3LDE1ICsyNTQs
NzQgQEAgc3RhdGljIHZvaWQgcnVuX3JlY2VpdmVyKHVuc2lnbmVkIGxvbmcgcmN2bG93YXRfYnl0
ZXMpDQogCWNsb3NlKGZkKTsNCiB9DQogDQorc3RhdGljIHZvaWQgcmVjdl9jb21wbGV0aW9uKGlu
dCBmZCkNCit7DQorCXN0cnVjdCBzb2NrX2V4dGVuZGVkX2VyciAqc2VycjsNCisJY2hhciBjbXNn
X2RhdGFbMTI4XTsNCisJc3RydWN0IGNtc2doZHIgKmNtOw0KKwlzdHJ1Y3QgbXNnaGRyIG1zZzsN
CisJaW50IHJldDsNCisNCisJbXNnLm1zZ19jb250cm9sID0gY21zZ19kYXRhOw0KKwltc2cubXNn
X2NvbnRyb2xsZW4gPSBzaXplb2YoY21zZ19kYXRhKTsNCisNCisJcmV0ID0gcmVjdm1zZyhmZCwg
Jm1zZywgTVNHX0VSUlFVRVVFKTsNCisJaWYgKHJldCA9PSAtMSkNCisJCXJldHVybjsNCisNCisJ
Y20gPSBDTVNHX0ZJUlNUSERSKCZtc2cpOw0KKwlpZiAoIWNtKSB7DQorCQlmcHJpbnRmKHN0ZGVy
ciwgImNtc2c6IG5vIGNtc2dcbiIpOw0KKwkJcmV0dXJuOw0KKwl9DQorDQorCWlmIChjbS0+Y21z
Z19sZXZlbCAhPSBTT0xfVlNPQ0spIHsNCisJCWZwcmludGYoc3RkZXJyLCAiY21zZzogdW5leHBl
Y3RlZCAnY21zZ19sZXZlbCdcbiIpOw0KKwkJcmV0dXJuOw0KKwl9DQorDQorCWlmIChjbS0+Y21z
Z190eXBlKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwgImNtc2c6IHVuZXhwZWN0ZWQgJ2Ntc2dfdHlw
ZSdcbiIpOw0KKwkJcmV0dXJuOw0KKwl9DQorDQorCXNlcnIgPSAodm9pZCAqKUNNU0dfREFUQShj
bSk7DQorCWlmIChzZXJyLT5lZV9vcmlnaW4gIT0gU09fRUVfT1JJR0lOX1pFUk9DT1BZKSB7DQor
CQlmcHJpbnRmKHN0ZGVyciwgInNlcnI6IHdyb25nIG9yaWdpblxuIik7DQorCQlyZXR1cm47DQor
CX0NCisNCisJaWYgKHNlcnItPmVlX2Vycm5vKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwgInNlcnI6
IHdyb25nIGVycm9yIGNvZGVcbiIpOw0KKwkJcmV0dXJuOw0KKwl9DQorDQorCWlmICh6ZXJvY29w
eSAmJiAoc2Vyci0+ZWVfY29kZSAmIFNPX0VFX0NPREVfWkVST0NPUFlfQ09QSUVEKSkNCisJCWZw
cmludGYoc3RkZXJyLCAid2FybmluZzogY29weSBpbnN0ZWFkIG9mIHplcm9jb3B5XG4iKTsNCit9
DQorDQorc3RhdGljIHZvaWQgZW5hYmxlX3NvX3plcm9jb3B5KGludCBmZCkNCit7DQorCWludCB2
YWwgPSAxOw0KKw0KKwlpZiAoc2V0c29ja29wdChmZCwgU09MX1NPQ0tFVCwgU09fWkVST0NPUFks
ICZ2YWwsIHNpemVvZih2YWwpKSkNCisJCWVycm9yKCJzZXRzb2Nrb3B0KFNPX1pFUk9DT1BZKSIp
Ow0KK30NCisNCiBzdGF0aWMgdm9pZCBydW5fc2VuZGVyKGludCBwZWVyX2NpZCwgdW5zaWduZWQg
bG9uZyB0b19zZW5kX2J5dGVzKQ0KIHsNCiAJdGltZV90IHR4X2JlZ2luX25zOw0KIAl0aW1lX3Qg
dHhfdG90YWxfbnM7DQogCXNpemVfdCB0b3RhbF9zZW5kOw0KKwl0aW1lX3QgdGltZV9pbl9zZW5k
Ow0KIAl2b2lkICpkYXRhOw0KIAlpbnQgZmQ7DQogDQotCXByaW50ZigiUnVuIGFzIHNlbmRlclxu
Iik7DQorCWlmICh6ZXJvY29weSkNCisJCXByaW50ZigiUnVuIGFzIHNlbmRlciBNU0dfWkVST0NP
UFlcbiIpOw0KKwllbHNlDQorCQlwcmludGYoIlJ1biBhcyBzZW5kZXJcbiIpOw0KKw0KIAlwcmlu
dGYoIkNvbm5lY3QgdG8gJWk6JXVcbiIsIHBlZXJfY2lkLCBwb3J0KTsNCiAJcHJpbnRmKCJTZW5k
ICVsdSBieXRlc1xuIiwgdG9fc2VuZF9ieXRlcyk7DQogCXByaW50ZigiVFggYnVmZmVyICVsdSBi
eXRlc1xuIiwgYnVmX3NpemVfYnl0ZXMpOw0KQEAgLTI2NSwyNSArMzMxLDU4IEBAIHN0YXRpYyB2
b2lkIHJ1bl9zZW5kZXIoaW50IHBlZXJfY2lkLCB1bnNpZ25lZCBsb25nIHRvX3NlbmRfYnl0ZXMp
DQogCWlmIChmZCA8IDApDQogCQlleGl0KEVYSVRfRkFJTFVSRSk7DQogDQotCWRhdGEgPSBtYWxs
b2MoYnVmX3NpemVfYnl0ZXMpOw0KKwlpZiAoemVyb2NvcHkpIHsNCisJCWVuYWJsZV9zb196ZXJv
Y29weShmZCk7DQogDQotCWlmICghZGF0YSkgew0KLQkJZnByaW50ZihzdGRlcnIsICInbWFsbG9j
KCknIGZhaWxlZFxuIik7DQotCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCQlkYXRhID0gbW1hcChO
VUxMLCBidWZfc2l6ZV9ieXRlcywgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwNCisJCQkgICAgTUFQ
X1BSSVZBVEUgfCBNQVBfQU5PTllNT1VTLCAtMSwgMCk7DQorCQlpZiAoZGF0YSA9PSBNQVBfRkFJ
TEVEKSB7DQorCQkJcGVycm9yKCJtbWFwIik7DQorCQkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwkJ
fQ0KKwl9IGVsc2Ugew0KKwkJZGF0YSA9IG1hbGxvYyhidWZfc2l6ZV9ieXRlcyk7DQorDQorCQlp
ZiAoIWRhdGEpIHsNCisJCQlmcHJpbnRmKHN0ZGVyciwgIidtYWxsb2MoKScgZmFpbGVkXG4iKTsN
CisJCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCQl9DQogCX0NCiANCiAJbWVtc2V0KGRhdGEsIDAs
IGJ1Zl9zaXplX2J5dGVzKTsNCiAJdG90YWxfc2VuZCA9IDA7DQorCXRpbWVfaW5fc2VuZCA9IDA7
DQogCXR4X2JlZ2luX25zID0gY3VycmVudF9uc2VjKCk7DQogDQogCXdoaWxlICh0b3RhbF9zZW5k
IDwgdG9fc2VuZF9ieXRlcykgew0KIAkJc3NpemVfdCBzZW50Ow0KKwkJc2l6ZV90IHJlc3RfYnl0
ZXM7DQorCQl0aW1lX3QgYmVmb3JlOw0KKw0KKwkJcmVzdF9ieXRlcyA9IHRvX3NlbmRfYnl0ZXMg
LSB0b3RhbF9zZW5kOw0KIA0KLQkJc2VudCA9IHdyaXRlKGZkLCBkYXRhLCBidWZfc2l6ZV9ieXRl
cyk7DQorCQliZWZvcmUgPSBjdXJyZW50X25zZWMoKTsNCisJCXNlbnQgPSBzZW5kKGZkLCBkYXRh
LCAocmVzdF9ieXRlcyA+IGJ1Zl9zaXplX2J5dGVzKSA/DQorCQkJICAgIGJ1Zl9zaXplX2J5dGVz
IDogcmVzdF9ieXRlcywNCisJCQkgICAgemVyb2NvcHkgPyBNU0dfWkVST0NPUFkgOiAwKTsNCisJ
CXRpbWVfaW5fc2VuZCArPSAoY3VycmVudF9uc2VjKCkgLSBiZWZvcmUpOw0KIA0KIAkJaWYgKHNl
bnQgPD0gMCkNCiAJCQllcnJvcigid3JpdGUiKTsNCiANCisJCWlmICh6ZXJvY29weSkgew0KKwkJ
CXN0cnVjdCBwb2xsZmQgZmRzID0geyAwIH07DQorDQorCQkJZmRzLmZkID0gZmQ7DQorDQorCQkJ
aWYgKHBvbGwoJmZkcywgMSwgLTEpIDwgMCkgew0KKwkJCQlwZXJyb3IoInBvbGwiKTsNCisJCQkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwkJCX0NCisNCisJCQlyZWN2X2NvbXBsZXRpb24oZmQpOw0K
KwkJfQ0KKw0KIAkJdG90YWxfc2VuZCArPSBzZW50Ow0KIAl9DQogDQpAQCAtMjk0LDkgKzM5Mywx
NCBAQCBzdGF0aWMgdm9pZCBydW5fc2VuZGVyKGludCBwZWVyX2NpZCwgdW5zaWduZWQgbG9uZyB0
b19zZW5kX2J5dGVzKQ0KIAkgICAgICAgZ2V0X2dicHModG90YWxfc2VuZCAqIDgsIHR4X3RvdGFs
X25zKSk7DQogCXByaW50ZigidG90YWwgdGltZSBpbiAnd3JpdGUoKSc6ICVmIHNlY1xuIiwNCiAJ
ICAgICAgIChmbG9hdCl0eF90b3RhbF9ucyAvIE5TRUNfUEVSX1NFQyk7DQorCXByaW50ZigidGlt
ZSBpbiBzZW5kICVmXG4iLCAoZmxvYXQpdGltZV9pbl9zZW5kIC8gTlNFQ19QRVJfU0VDKTsNCiAN
CiAJY2xvc2UoZmQpOw0KLQlmcmVlKGRhdGEpOw0KKw0KKwlpZiAoemVyb2NvcHkpDQorCQltdW5t
YXAoZGF0YSwgYnVmX3NpemVfYnl0ZXMpOw0KKwllbHNlDQorCQlmcmVlKGRhdGEpOw0KIH0NCiAN
CiBzdGF0aWMgY29uc3QgY2hhciBvcHRzdHJpbmdbXSA9ICIiOw0KQEAgLTMzNiw2ICs0NDAsMTEg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCBvcHRpb24gbG9uZ29wdHNbXSA9IHsNCiAJCS5oYXNfYXJn
ID0gcmVxdWlyZWRfYXJndW1lbnQsDQogCQkudmFsID0gJ1InLA0KIAl9LA0KKwl7DQorCQkubmFt
ZSA9ICJ6YyIsDQorCQkuaGFzX2FyZyA9IG5vX2FyZ3VtZW50LA0KKwkJLnZhbCA9ICdaJywNCisJ
fSwNCiAJe30sDQogfTsNCiANCkBAIC0zNTEsNiArNDYwLDcgQEAgc3RhdGljIHZvaWQgdXNhZ2Uo
dm9pZCkNCiAJICAgICAgICIgIC0taGVscAkJCVRoaXMgbWVzc2FnZVxuIg0KIAkgICAgICAgIiAg
LS1zZW5kZXIgICA8Y2lkPgkJU2VuZGVyIG1vZGUgKHJlY2VpdmVyIGRlZmF1bHQpXG4iDQogCSAg
ICAgICAiICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8Y2lkPiBvZiB0aGUgcmVjZWl2
ZXIgdG8gY29ubmVjdCB0b1xuIg0KKwkgICAgICAgIiAgLS16YwkJCQlFbmFibGUgemVyb2NvcHlc
biINCiAJICAgICAgICIgIC0tcG9ydCAgICAgPHBvcnQ+CQlQb3J0IChkZWZhdWx0ICVkKVxuIg0K
IAkgICAgICAgIiAgLS1ieXRlcyAgICA8Ynl0ZXM+S01HCQlCeXRlcyB0byBzZW5kIChkZWZhdWx0
ICVkKVxuIg0KIAkgICAgICAgIiAgLS1idWYtc2l6ZSA8Ynl0ZXM+S01HCQlEYXRhIGJ1ZmZlciBz
aXplIChkZWZhdWx0ICVkKS4gSW4gc2VuZGVyIG1vZGVcbiINCkBAIC00MTMsNiArNTIzLDkgQEAg
aW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KIAkJY2FzZSAnSCc6IC8qIEhlbHAuICov
DQogCQkJdXNhZ2UoKTsNCiAJCQlicmVhazsNCisJCWNhc2UgJ1onOiAvKiBaZXJvY29weS4gKi8N
CisJCQl6ZXJvY29weSA9IHRydWU7DQorCQkJYnJlYWs7DQogCQlkZWZhdWx0Og0KIAkJCXVzYWdl
KCk7DQogCQl9DQotLSANCjIuMjUuMQ0KDQo=
