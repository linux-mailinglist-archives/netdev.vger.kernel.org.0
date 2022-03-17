Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDFA4DBEDA
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 06:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiCQGAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCQGAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:00:06 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B1B642E;
        Wed, 16 Mar 2022 22:29:34 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id E26FF5FD05;
        Thu, 17 Mar 2022 08:29:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647494971;
        bh=tc4Xqjuow4fJhCGYjA0+j55/jP1xzKSQOWMLd3ai/FM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Edqk9DKTQ8oyIjQe784h9Ed7H1fyGCm/MgDr/0/PaHL11xQ+oqEEjjVnsFer4CzSQ
         UaQj1e6tb0Nu7H0osyO8xzgROlIjWJplB5XDvVhB4vmkbchb7rjYMm92GfA8bfUAOg
         TGKAX/3yetTZlsfJbPwznZiiFDZ03wz2mMF222snl4IlDc4SwfUHGdbVSfYUua9ZB2
         f7sIeOQsC2yaDJCftRHYJAiEJn8Ws/mlfkt4mQdBX89hdHmByfA2JXW3ca2xbvaEPn
         KyUWKqU6flSaQl3FElBcNII4UzGvaZfP/IIPrSdQIdcov0LjefOqQSNU838xAsaQkG
         9zP3a03uDs1FA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 08:29:31 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 2/2] af_vsock: SOCK_SEQPACKET broken buffer test
Thread-Topic: [PATCH net-next v3 2/2] af_vsock: SOCK_SEQPACKET broken buffer
 test
Thread-Index: AQHYOb/NiHIFmSegRUWQFT4fmoBTow==
Date:   Thu, 17 Mar 2022 05:28:21 +0000
Message-ID: <c3ce3c67-1bbd-8172-0c98-e0c3cd5a80b6@sberdevices.ru>
In-Reply-To: <4ecfa306-a374-93f6-4e66-be62895ae4f7@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <59C59A4B571B994688BB6554B360AE8D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/17 01:49:00 #18989990
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
ClNpZ25lZC1vZmYtYnk6IEtyYXNub3YgQXJzZW5peSBWbGFkaW1pcm92aWNoIDxBVktyYXNub3ZA
c2JlcmRldmljZXMucnU+DQotLS0NCiB2MiAtPiB2MzoNCiAxKSAiZ290IFgsIGV4cGVjdGVkIFki
IC0+ICJleHBlY3RlZCBYLCBnb3QgWSIuDQogMikgU29tZSBjaGVja3BhdGNoLnBsIGZpeGVzLg0K
DQogdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCAxMzEgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMzEgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgYi90b29scy90ZXN0
aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KaW5kZXggZjU0OThkZTY3NTFkLi45YjYzZTQxMjE2NWUg
MTAwNjQ0DQotLS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KKysrIGIvdG9v
bHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCkBAIC0xNyw2ICsxNyw3IEBADQogI2luY2x1
ZGUgPHN5cy90eXBlcy5oPg0KICNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+DQogI2luY2x1ZGUgPHRp
bWUuaD4NCisjaW5jbHVkZSA8c3lzL21tYW4uaD4NCiANCiAjaW5jbHVkZSAidGltZW91dC5oIg0K
ICNpbmNsdWRlICJjb250cm9sLmgiDQpAQCAtNDcwLDYgKzQ3MSwxMzEgQEAgc3RhdGljIHZvaWQg
dGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0
cykNCiAJY2xvc2UoZmQpOw0KIH0NCiANCisjZGVmaW5lIEJVRl9QQVRURVJOXzEgJ2EnDQorI2Rl
ZmluZSBCVUZfUEFUVEVSTl8yICdiJw0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X2lu
dmFsaWRfcmVjX2J1ZmZlcl9jbGllbnQoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCit7
DQorCWludCBmZDsNCisJdW5zaWduZWQgY2hhciAqYnVmMTsNCisJdW5zaWduZWQgY2hhciAqYnVm
MjsNCisJaW50IGJ1Zl9zaXplID0gZ2V0cGFnZXNpemUoKSAqIDM7DQorDQorCWZkID0gdnNvY2tf
c2VxcGFja2V0X2Nvbm5lY3Qob3B0cy0+cGVlcl9jaWQsIDEyMzQpOw0KKwlpZiAoZmQgPCAwKSB7
DQorCQlwZXJyb3IoImNvbm5lY3QiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0K
KwlidWYxID0gbWFsbG9jKGJ1Zl9zaXplKTsNCisJaWYgKCFidWYxKSB7DQorCQlwZXJyb3IoIidt
YWxsb2MoKScgZm9yICdidWYxJyIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQor
CWJ1ZjIgPSBtYWxsb2MoYnVmX3NpemUpOw0KKwlpZiAoIWJ1ZjIpIHsNCisJCXBlcnJvcigiJ21h
bGxvYygpJyBmb3IgJ2J1ZjInIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJ
bWVtc2V0KGJ1ZjEsIEJVRl9QQVRURVJOXzEsIGJ1Zl9zaXplKTsNCisJbWVtc2V0KGJ1ZjIsIEJV
Rl9QQVRURVJOXzIsIGJ1Zl9zaXplKTsNCisNCisJaWYgKHNlbmQoZmQsIGJ1ZjEsIGJ1Zl9zaXpl
LCAwKSAhPSBidWZfc2l6ZSkgew0KKwkJcGVycm9yKCJzZW5kIGZhaWxlZCIpOw0KKwkJZXhpdChF
WElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWlmIChzZW5kKGZkLCBidWYyLCBidWZfc2l6ZSwgMCkg
IT0gYnVmX3NpemUpIHsNCisJCXBlcnJvcigic2VuZCBmYWlsZWQiKTsNCisJCWV4aXQoRVhJVF9G
QUlMVVJFKTsNCisJfQ0KKw0KKwljbG9zZShmZCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rf
c2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0
cyAqb3B0cykNCit7DQorCWludCBmZDsNCisJdW5zaWduZWQgY2hhciAqYnJva2VuX2J1ZjsNCisJ
dW5zaWduZWQgY2hhciAqdmFsaWRfYnVmOw0KKwlpbnQgcGFnZV9zaXplID0gZ2V0cGFnZXNpemUo
KTsNCisJaW50IGJ1Zl9zaXplID0gcGFnZV9zaXplICogMzsNCisJc3NpemVfdCByZXM7DQorCWlu
dCBwcm90ID0gUFJPVF9SRUFEIHwgUFJPVF9XUklURTsNCisJaW50IGZsYWdzID0gTUFQX1BSSVZB
VEUgfCBNQVBfQU5PTllNT1VTOw0KKwlpbnQgaTsNCisNCisJZmQgPSB2c29ja19zZXFwYWNrZXRf
YWNjZXB0KFZNQUREUl9DSURfQU5ZLCAxMjM0LCBOVUxMKTsNCisJaWYgKGZkIDwgMCkgew0KKwkJ
cGVycm9yKCJhY2NlcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwkvKiBT
ZXR1cCBmaXJzdCBidWZmZXIuICovDQorCWJyb2tlbl9idWYgPSBtbWFwKE5VTEwsIGJ1Zl9zaXpl
LCBwcm90LCBmbGFncywgLTEsIDApOw0KKwlpZiAoYnJva2VuX2J1ZiA9PSBNQVBfRkFJTEVEKSB7
DQorCQlwZXJyb3IoIm1tYXAgZm9yICdicm9rZW5fYnVmJyIpOw0KKwkJZXhpdChFWElUX0ZBSUxV
UkUpOw0KKwl9DQorDQorCS8qIFVubWFwICJob2xlIiBpbiBidWZmZXIuICovDQorCWlmIChtdW5t
YXAoYnJva2VuX2J1ZiArIHBhZ2Vfc2l6ZSwgcGFnZV9zaXplKSkgew0KKwkJcGVycm9yKCInYnJv
a2VuX2J1Zicgc2V0dXAiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwl2YWxp
ZF9idWYgPSBtbWFwKE5VTEwsIGJ1Zl9zaXplLCBwcm90LCBmbGFncywgLTEsIDApOw0KKwlpZiAo
dmFsaWRfYnVmID09IE1BUF9GQUlMRUQpIHsNCisJCXBlcnJvcigibW1hcCBmb3IgJ3ZhbGlkX2J1
ZiciKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwkvKiBUcnkgdG8gZmlsbCBi
dWZmZXIgd2l0aCB1bm1hcHBlZCBtaWRkbGUuICovDQorCXJlcyA9IHJlYWQoZmQsIGJyb2tlbl9i
dWYsIGJ1Zl9zaXplKTsNCisJaWYgKHJlcyAhPSAtMSkgew0KKwkJZnByaW50ZihzdGRlcnIsDQor
CQkJImV4cGVjdGVkICdicm9rZW5fYnVmJyByZWFkKDIpIGZhaWx1cmUsIGdvdCAlemlcbiIsDQor
CQkJcmVzKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoZXJybm8gIT0g
RU5PTUVNKSB7DQorCQlwZXJyb3IoInVuZXhwZWN0ZWQgZXJybm8gb2YgJ2Jyb2tlbl9idWYnIik7
DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJLyogVHJ5IHRvIGZpbGwgdmFsaWQg
YnVmZmVyLiAqLw0KKwlyZXMgPSByZWFkKGZkLCB2YWxpZF9idWYsIGJ1Zl9zaXplKTsNCisJaWYg
KHJlcyA8IDApIHsNCisJCXBlcnJvcigidW5leHBlY3RlZCAndmFsaWRfYnVmJyByZWFkKDIpIGZh
aWx1cmUiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAocmVzICE9IGJ1
Zl9zaXplKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwNCisJCQkiaW52YWxpZCAndmFsaWRfYnVmJyBy
ZWFkKDIpLCBleHBlY3RlZCAlaSwgZ290ICV6aVxuIiwNCisJCQlidWZfc2l6ZSwgcmVzKTsNCisJ
CWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlmb3IgKGkgPSAwOyBpIDwgYnVmX3NpemU7
IGkrKykgew0KKwkJaWYgKHZhbGlkX2J1ZltpXSAhPSBCVUZfUEFUVEVSTl8yKSB7DQorCQkJZnBy
aW50ZihzdGRlcnIsDQorCQkJCSJpbnZhbGlkIHBhdHRlcm4gZm9yICd2YWxpZF9idWYnIGF0ICVp
LCBleHBlY3RlZCAlaGhYLCBnb3QgJWhoWFxuIiwNCisJCQkJaSwgQlVGX1BBVFRFUk5fMiwgdmFs
aWRfYnVmW2ldKTsNCisJCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCQl9DQorCX0NCisNCisJLyog
VW5tYXAgYnVmZmVycy4gKi8NCisJbXVubWFwKGJyb2tlbl9idWYsIHBhZ2Vfc2l6ZSk7DQorCW11
bm1hcChicm9rZW5fYnVmICsgcGFnZV9zaXplICogMiwgcGFnZV9zaXplKTsNCisJbXVubWFwKHZh
bGlkX2J1ZiwgYnVmX3NpemUpOw0KKwljbG9zZShmZCk7DQorfQ0KKw0KIHN0YXRpYyBzdHJ1Y3Qg
dGVzdF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCiAJew0KIAkJLm5hbWUgPSAiU09DS19TVFJFQU0g
Y29ubmVjdGlvbiByZXNldCIsDQpAQCAtNTE1LDYgKzY0MSwxMSBAQCBzdGF0aWMgc3RydWN0IHRl
c3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7DQogCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0
X3RpbWVvdXRfY2xpZW50LA0KIAkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF90aW1lb3V0
X3NlcnZlciwNCiAJfSwNCisJew0KKwkJLm5hbWUgPSAiU09DS19TRVFQQUNLRVQgaW52YWxpZCBy
ZWNlaXZlIGJ1ZmZlciIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2ludmFsaWRf
cmVjX2J1ZmZlcl9jbGllbnQsDQorCQkucnVuX3NlcnZlciA9IHRlc3Rfc2VxcGFja2V0X2ludmFs
aWRfcmVjX2J1ZmZlcl9zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07DQogDQotLSANCjIuMjUuMQ0K
