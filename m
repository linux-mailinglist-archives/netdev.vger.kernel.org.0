Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843524D6041
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348121AbiCKK74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346129AbiCKK7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:59:54 -0500
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A9813C39F;
        Fri, 11 Mar 2022 02:58:50 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 2683C5FD03;
        Fri, 11 Mar 2022 13:58:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1646996328;
        bh=WyQa/Gu+vWVCPA15DPgEI2x5TX1alJGD8E5F+CE4TPE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=LWFMqCacZCmAYwL9jnJ1qoHMCKSQ2Ov1UF0/5/3U3sVUr08UEsdiUUta3GCIHmdh6
         +C11Q+nms9NSIO2Jd10gXbphwuFn8NFJH1RhDcL8uw9+cWdyvndMyY02s8ie5xw7u7
         /q5vKWeHzsv/qGcALZ0Kr0aeN1Cuq2qpKUbCSVWjFhaoJyhIQmLTlBzHw63LaRK1q4
         9+MZfpVCKNlTbcwDZH2x6+4MdD1Rxs1t4zHNTrLe+61qPXXuIcOt6oOOi8XVDwiyg/
         aSkPGfN1lYeXxawti09Y59wKlo5FLK7oxb4ZcFE0CFPMP1a9nDztahrG+/G5gm+kmo
         r+ijCfwu/zamA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 11 Mar 2022 13:58:48 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 3/3] af_vsock: SOCK_SEQPACKET broken buffer test
Thread-Topic: [RFC PATCH v1 3/3] af_vsock: SOCK_SEQPACKET broken buffer test
Thread-Index: AQHYNTbvjWQnm44js0u5mxZaYZpaaQ==
Date:   Fri, 11 Mar 2022 10:58:32 +0000
Message-ID: <bc309cf9-5bcf-b645-577f-8e5b0cf6f220@sberdevices.ru>
In-Reply-To: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <067E1A7C5BB85447BE521D93922C4087@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/11 07:23:00 #18938550
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIHRlc3Qgd2hlcmUgc2VuZGVyIHNlbmRzIHR3byBtZXNzYWdlLCBlYWNoIHdpdGggb3duDQpk
YXRhIHBhdHRlcm4uIFJlYWRlciB0cmllcyB0byByZWFkIGZpcnN0IHRvIGJyb2tlbiBidWZmZXI6
DQppdCBoYXMgdGhyZWUgcGFnZXMgc2l6ZSwgYnV0IG1pZGRsZSBwYWdlIGlzIHVubWFwcGVkLiBU
aGVuLA0KcmVhZGVyIHRyaWVzIHRvIHJlYWQgc2Vjb25kIG1lc3NhZ2UgdG8gdmFsaWQgYnVmZmVy
LiBUZXN0DQpjaGVja3MsIHRoYXQgdW5jb3BpZWQgcGFydCBvZiBmaXJzdCBtZXNzYWdlIHdhcyBk
cm9wcGVkDQphbmQgdGh1cyBub3QgY29waWVkIGFzIHBhcnQgb2Ygc2Vjb25kIG1lc3NhZ2UuDQoN
ClNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1
Pg0KLS0tDQogdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCAxMjEgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMjEgaW5zZXJ0aW9ucygr
KQ0KDQpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgYi90b29s
cy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KaW5kZXggYWEyZGUyN2QwZjc3Li42ODZhZjcx
MmI0YWQgMTAwNjQ0DQotLS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KKysr
IGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCkBAIC0xNiw2ICsxNiw3IEBADQog
I2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KICNpbmNsdWRlIDxzeXMvdHlwZXMuaD4NCiAjaW5j
bHVkZSA8c3lzL3NvY2tldC5oPg0KKyNpbmNsdWRlIDxzeXMvbW1hbi5oPg0KIA0KICNpbmNsdWRl
ICJ0aW1lb3V0LmgiDQogI2luY2x1ZGUgImNvbnRyb2wuaCINCkBAIC00MzUsNiArNDM2LDEyMSBA
QCBzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlcihjb25zdCBzdHJ1Y3Qg
dGVzdF9vcHRzICpvcHRzKQ0KIAljbG9zZShmZCk7DQogfQ0KIA0KKyNkZWZpbmUgQlVGX1BBVFRF
Uk5fMSAnYScNCisjZGVmaW5lIEJVRl9QQVRURVJOXzIgJ2InDQorDQorc3RhdGljIHZvaWQgdGVz
dF9zZXFwYWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9v
cHRzICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKwl1bnNpZ25lZCBjaGFyICpidWYxOw0KKwl1bnNp
Z25lZCBjaGFyICpidWYyOw0KKwlpbnQgYnVmX3NpemUgPSBnZXRwYWdlc2l6ZSgpICogMzsNCisN
CisJZmQgPSB2c29ja19zZXFwYWNrZXRfY29ubmVjdChvcHRzLT5wZWVyX2NpZCwgMTIzNCk7DQor
CWlmIChmZCA8IDApIHsNCisJCXBlcnJvcigiY29ubmVjdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxV
UkUpOw0KKwl9DQorDQorCWJ1ZjEgPSBtYWxsb2MoYnVmX3NpemUpOw0KKwlpZiAoYnVmMSA9PSBO
VUxMKSB7DQorCQlwZXJyb3IoIidtYWxsb2MoKScgZm9yICdidWYxJyIpOw0KKwkJZXhpdChFWElU
X0ZBSUxVUkUpOw0KKwl9DQorDQorCWJ1ZjIgPSBtYWxsb2MoYnVmX3NpemUpOw0KKwlpZiAoYnVm
MiA9PSBOVUxMKSB7DQorCQlwZXJyb3IoIidtYWxsb2MoKScgZm9yICdidWYyJyIpOw0KKwkJZXhp
dChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCW1lbXNldChidWYxLCBCVUZfUEFUVEVSTl8xLCBi
dWZfc2l6ZSk7DQorCW1lbXNldChidWYyLCBCVUZfUEFUVEVSTl8yLCBidWZfc2l6ZSk7DQorDQor
CWlmIChzZW5kKGZkLCBidWYxLCBidWZfc2l6ZSwgMCkgIT0gYnVmX3NpemUpIHsNCisJCXBlcnJv
cigic2VuZCBmYWlsZWQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAo
c2VuZChmZCwgYnVmMiwgYnVmX3NpemUsIDApICE9IGJ1Zl9zaXplKSB7DQorCQlwZXJyb3IoInNl
bmQgZmFpbGVkIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJY2xvc2UoZmQp
Ow0KK30NCisNCitzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZmZXJf
c2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwlpbnQgZmQ7DQorCXVu
c2lnbmVkIGNoYXIgKmJyb2tlbl9idWY7DQorCXVuc2lnbmVkIGNoYXIgKnZhbGlkX2J1ZjsNCisJ
aW50IHBhZ2Vfc2l6ZSA9IGdldHBhZ2VzaXplKCk7DQorCWludCBidWZfc2l6ZSA9IHBhZ2Vfc2l6
ZSAqIDM7DQorCXNzaXplX3QgcmVzOw0KKwlpbnQgcHJvdCA9IFBST1RfUkVBRCB8IFBST1RfV1JJ
VEU7DQorCWludCBmbGFncyA9IE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUzsNCisJaW50IGk7
DQorDQorCWZkID0gdnNvY2tfc2VxcGFja2V0X2FjY2VwdChWTUFERFJfQ0lEX0FOWSwgMTIzNCwg
TlVMTCk7DQorCWlmIChmZCA8IDApIHsNCisJCXBlcnJvcigiYWNjZXB0Iik7DQorCQlleGl0KEVY
SVRfRkFJTFVSRSk7DQorCX0NCisNCisJLyogU2V0dXAgZmlyc3QgYnVmZmVyLiAqLw0KKwlicm9r
ZW5fYnVmID0gbW1hcChOVUxMLCBidWZfc2l6ZSwgcHJvdCwgZmxhZ3MsIC0xLCAwKTsNCisJaWYg
KGJyb2tlbl9idWYgPT0gTUFQX0ZBSUxFRCkgew0KKwkJcGVycm9yKCJtbWFwIGZvciAnYnJva2Vu
X2J1ZiciKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwkvKiBVbm1hcCAiaG9s
ZSIgaW4gYnVmZmVyLiAqLw0KKwlpZiAobXVubWFwKGJyb2tlbl9idWYgKyBwYWdlX3NpemUsIHBh
Z2Vfc2l6ZSkpIHsNCisJCXBlcnJvcigiJ2Jyb2tlbl9idWYnIHNldHVwIik7DQorCQlleGl0KEVY
SVRfRkFJTFVSRSk7DQorCX0NCisNCisJdmFsaWRfYnVmID0gbW1hcChOVUxMLCBidWZfc2l6ZSwg
cHJvdCwgZmxhZ3MsIC0xLCAwKTsNCisJaWYgKHZhbGlkX2J1ZiA9PSBNQVBfRkFJTEVEKSB7DQor
CQlwZXJyb3IoIm1tYXAgZm9yICd2YWxpZF9idWYnIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7
DQorCX0NCisNCisJLyogVHJ5IHRvIGZpbGwgYnVmZmVyIHdpdGggdW5tYXBwZWQgbWlkZGxlLiAq
Lw0KKwlyZXMgPSByZWFkKGZkLCBicm9rZW5fYnVmLCBidWZfc2l6ZSk7DQorCWlmIChyZXMgIT0g
LTEpIHsNCisJCXBlcnJvcigiaW52YWxpZCByZWFkIHJlc3VsdCBvZiAnYnJva2VuX2J1ZiciKTsN
CisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoZXJybm8gIT0gRU5PTUVNKSB7
DQorCQlwZXJyb3IoImludmFsaWQgZXJybm8gb2YgJ2Jyb2tlbl9idWYnIik7DQorCQlleGl0KEVY
SVRfRkFJTFVSRSk7DQorCX0NCisNCisJLyogVHJ5IHRvIGZpbGwgdmFsaWQgYnVmZmVyLiAqLw0K
KwlyZXMgPSByZWFkKGZkLCB2YWxpZF9idWYsIGJ1Zl9zaXplKTsNCisJaWYgKHJlcyAhPSBidWZf
c2l6ZSkgew0KKwkJcGVycm9yKCJpbnZhbGlkIHJlYWQgcmVzdWx0IG9mICd2YWxpZF9idWYnIik7
DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJZm9yIChpID0gMDsgaSA8IGJ1Zl9z
aXplOyBpKyspIHsNCisJCWlmICh2YWxpZF9idWZbaV0gIT0gQlVGX1BBVFRFUk5fMikgew0KKwkJ
CXBlcnJvcigiaW52YWxpZCBwYXR0ZXJuIGZvciB2YWxpZCBidWYiKTsNCisJCQlleGl0KEVYSVRf
RkFJTFVSRSk7DQorCQl9DQorCX0NCisNCisNCisJLyogVW5tYXAgYnVmZmVycy4gKi8NCisJbXVu
bWFwKGJyb2tlbl9idWYsIHBhZ2Vfc2l6ZSk7DQorCW11bm1hcChicm9rZW5fYnVmICsgcGFnZV9z
aXplICogMiwgcGFnZV9zaXplKTsNCisJbXVubWFwKHZhbGlkX2J1ZiwgYnVmX3NpemUpOw0KKwlj
bG9zZShmZCk7DQorfQ0KKw0KIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNbXSA9
IHsNCiAJew0KIAkJLm5hbWUgPSAiU09DS19TVFJFQU0gY29ubmVjdGlvbiByZXNldCIsDQpAQCAt
NDgwLDYgKzU5NiwxMSBAQCBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7
DQogCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X3RpbWVvdXRfY2xpZW50LA0KIAkJLnJ1
bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlciwNCiAJfSwNCisJew0KKwkJ
Lm5hbWUgPSAiU09DS19TRVFQQUNLRVQgaW52YWxpZCByZWNlaXZlIGJ1ZmZlciIsDQorCQkucnVu
X2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9jbGllbnQsDQorCQku
cnVuX3NlcnZlciA9IHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9zZXJ2ZXIsDQor
CX0sDQogCXt9LA0KIH07DQogDQotLSANCjIuMjUuMQ0K
