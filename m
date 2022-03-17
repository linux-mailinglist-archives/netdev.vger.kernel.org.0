Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D624DC166
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiCQIfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiCQIfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:35:42 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFA619EC7A;
        Thu, 17 Mar 2022 01:34:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A2E855FD05;
        Thu, 17 Mar 2022 11:34:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647506062;
        bh=LGU09vhzRvbaXVh4zCZLvOQiYSoxLgPwllmoT//4/MI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=p+ZIgJEpcWVTFVby4bh7EgOzxA8YRNbOmwBtURWIA29Y5FxCzUJvvxY1j5IdcW16O
         sbwTlrNUP4hCztuQ/QzZ57feLkQLWyWe93C6dCDM/EP9iq3687+RUHUB6aZPhPb6zl
         uY5KHhpZaWbUj0We2fdpYV8gMD/CVcsHdBuk8bGNQEU0VwsfE1oQtb0b5Bzx/IB0im
         tkbFGab569KUrPvZP9p3TPCmqCNv+p8dCWUgaHbY3YoxfCuvos7Btqk/HideW+TxdM
         dTrPSVHCExq7ZnwBAyQtWcDwrpeW4UjDSELHNcJ3/3XO0Syfk2+RaLecnnsUSKjoSx
         seGT6Nq+hEHFw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 11:34:22 +0300 (MSK)
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
Subject: [PATCH net-next v4 2/2] af_vsock: SOCK_SEQPACKET broken buffer test
Thread-Topic: [PATCH net-next v4 2/2] af_vsock: SOCK_SEQPACKET broken buffer
 test
Thread-Index: AQHYOdmmZPUuaFrjOkW5sEESwiVkGg==
Date:   Thu, 17 Mar 2022 08:33:23 +0000
Message-ID: <c35b79ff-ca96-2cc7-68a5-cfcec3b0eca9@sberdevices.ru>
In-Reply-To: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2E9406776EC6444B553A1D6304345E0@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/17 04:52:00 #18991242
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
c2JlcmRldmljZXMucnU+DQpSZXZpZXdlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFy
ZUByZWRoYXQuY29tPg0KLS0tDQogdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCAx
MzEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMzEg
aW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190
ZXN0LmMgYi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KaW5kZXggNWI4NTYxYjgw
OTE0Li5kYzU3NzQ2MWFmYzIgMTAwNjQ0DQotLS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2Nr
X3Rlc3QuYw0KKysrIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCkBAIC0xNyw2
ICsxNyw3IEBADQogI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KICNpbmNsdWRlIDxzeXMvc29ja2V0
Lmg+DQogI2luY2x1ZGUgPHRpbWUuaD4NCisjaW5jbHVkZSA8c3lzL21tYW4uaD4NCiANCiAjaW5j
bHVkZSAidGltZW91dC5oIg0KICNpbmNsdWRlICJjb250cm9sLmgiDQpAQCAtNDcwLDYgKzQ3MSwx
MzEgQEAgc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIoY29uc3Qgc3Ry
dWN0IHRlc3Rfb3B0cyAqb3B0cykNCiAJY2xvc2UoZmQpOw0KIH0NCiANCisjZGVmaW5lIEJVRl9Q
QVRURVJOXzEgJ2EnDQorI2RlZmluZSBCVUZfUEFUVEVSTl8yICdiJw0KKw0KK3N0YXRpYyB2b2lk
IHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9jbGllbnQoY29uc3Qgc3RydWN0IHRl
c3Rfb3B0cyAqb3B0cykNCit7DQorCWludCBmZDsNCisJdW5zaWduZWQgY2hhciAqYnVmMTsNCisJ
dW5zaWduZWQgY2hhciAqYnVmMjsNCisJaW50IGJ1Zl9zaXplID0gZ2V0cGFnZXNpemUoKSAqIDM7
DQorDQorCWZkID0gdnNvY2tfc2VxcGFja2V0X2Nvbm5lY3Qob3B0cy0+cGVlcl9jaWQsIDEyMzQp
Ow0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImNvbm5lY3QiKTsNCisJCWV4aXQoRVhJVF9G
QUlMVVJFKTsNCisJfQ0KKw0KKwlidWYxID0gbWFsbG9jKGJ1Zl9zaXplKTsNCisJaWYgKCFidWYx
KSB7DQorCQlwZXJyb3IoIidtYWxsb2MoKScgZm9yICdidWYxJyIpOw0KKwkJZXhpdChFWElUX0ZB
SUxVUkUpOw0KKwl9DQorDQorCWJ1ZjIgPSBtYWxsb2MoYnVmX3NpemUpOw0KKwlpZiAoIWJ1ZjIp
IHsNCisJCXBlcnJvcigiJ21hbGxvYygpJyBmb3IgJ2J1ZjInIik7DQorCQlleGl0KEVYSVRfRkFJ
TFVSRSk7DQorCX0NCisNCisJbWVtc2V0KGJ1ZjEsIEJVRl9QQVRURVJOXzEsIGJ1Zl9zaXplKTsN
CisJbWVtc2V0KGJ1ZjIsIEJVRl9QQVRURVJOXzIsIGJ1Zl9zaXplKTsNCisNCisJaWYgKHNlbmQo
ZmQsIGJ1ZjEsIGJ1Zl9zaXplLCAwKSAhPSBidWZfc2l6ZSkgew0KKwkJcGVycm9yKCJzZW5kIGZh
aWxlZCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWlmIChzZW5kKGZkLCBi
dWYyLCBidWZfc2l6ZSwgMCkgIT0gYnVmX3NpemUpIHsNCisJCXBlcnJvcigic2VuZCBmYWlsZWQi
KTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwljbG9zZShmZCk7DQorfQ0KKw0K
K3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9zZXJ2ZXIoY29u
c3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCit7DQorCWludCBmZDsNCisJdW5zaWduZWQgY2hh
ciAqYnJva2VuX2J1ZjsNCisJdW5zaWduZWQgY2hhciAqdmFsaWRfYnVmOw0KKwlpbnQgcGFnZV9z
aXplID0gZ2V0cGFnZXNpemUoKTsNCisJaW50IGJ1Zl9zaXplID0gcGFnZV9zaXplICogMzsNCisJ
c3NpemVfdCByZXM7DQorCWludCBwcm90ID0gUFJPVF9SRUFEIHwgUFJPVF9XUklURTsNCisJaW50
IGZsYWdzID0gTUFQX1BSSVZBVEUgfCBNQVBfQU5PTllNT1VTOw0KKwlpbnQgaTsNCisNCisJZmQg
PSB2c29ja19zZXFwYWNrZXRfYWNjZXB0KFZNQUREUl9DSURfQU5ZLCAxMjM0LCBOVUxMKTsNCisJ
aWYgKGZkIDwgMCkgew0KKwkJcGVycm9yKCJhY2NlcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJF
KTsNCisJfQ0KKw0KKwkvKiBTZXR1cCBmaXJzdCBidWZmZXIuICovDQorCWJyb2tlbl9idWYgPSBt
bWFwKE5VTEwsIGJ1Zl9zaXplLCBwcm90LCBmbGFncywgLTEsIDApOw0KKwlpZiAoYnJva2VuX2J1
ZiA9PSBNQVBfRkFJTEVEKSB7DQorCQlwZXJyb3IoIm1tYXAgZm9yICdicm9rZW5fYnVmJyIpOw0K
KwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCS8qIFVubWFwICJob2xlIiBpbiBidWZm
ZXIuICovDQorCWlmIChtdW5tYXAoYnJva2VuX2J1ZiArIHBhZ2Vfc2l6ZSwgcGFnZV9zaXplKSkg
ew0KKwkJcGVycm9yKCInYnJva2VuX2J1Zicgc2V0dXAiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJF
KTsNCisJfQ0KKw0KKwl2YWxpZF9idWYgPSBtbWFwKE5VTEwsIGJ1Zl9zaXplLCBwcm90LCBmbGFn
cywgLTEsIDApOw0KKwlpZiAodmFsaWRfYnVmID09IE1BUF9GQUlMRUQpIHsNCisJCXBlcnJvcigi
bW1hcCBmb3IgJ3ZhbGlkX2J1ZiciKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0K
KwkvKiBUcnkgdG8gZmlsbCBidWZmZXIgd2l0aCB1bm1hcHBlZCBtaWRkbGUuICovDQorCXJlcyA9
IHJlYWQoZmQsIGJyb2tlbl9idWYsIGJ1Zl9zaXplKTsNCisJaWYgKHJlcyAhPSAtMSkgew0KKwkJ
ZnByaW50ZihzdGRlcnIsDQorCQkJImV4cGVjdGVkICdicm9rZW5fYnVmJyByZWFkKDIpIGZhaWx1
cmUsIGdvdCAlemlcbiIsDQorCQkJcmVzKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0K
Kw0KKwlpZiAoZXJybm8gIT0gRU5PTUVNKSB7DQorCQlwZXJyb3IoInVuZXhwZWN0ZWQgZXJybm8g
b2YgJ2Jyb2tlbl9idWYnIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJLyog
VHJ5IHRvIGZpbGwgdmFsaWQgYnVmZmVyLiAqLw0KKwlyZXMgPSByZWFkKGZkLCB2YWxpZF9idWYs
IGJ1Zl9zaXplKTsNCisJaWYgKHJlcyA8IDApIHsNCisJCXBlcnJvcigidW5leHBlY3RlZCAndmFs
aWRfYnVmJyByZWFkKDIpIGZhaWx1cmUiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0K
Kw0KKwlpZiAocmVzICE9IGJ1Zl9zaXplKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwNCisJCQkiaW52
YWxpZCAndmFsaWRfYnVmJyByZWFkKDIpLCBleHBlY3RlZCAlaSwgZ290ICV6aVxuIiwNCisJCQli
dWZfc2l6ZSwgcmVzKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlmb3IgKGkg
PSAwOyBpIDwgYnVmX3NpemU7IGkrKykgew0KKwkJaWYgKHZhbGlkX2J1ZltpXSAhPSBCVUZfUEFU
VEVSTl8yKSB7DQorCQkJZnByaW50ZihzdGRlcnIsDQorCQkJCSJpbnZhbGlkIHBhdHRlcm4gZm9y
ICd2YWxpZF9idWYnIGF0ICVpLCBleHBlY3RlZCAlaGhYLCBnb3QgJWhoWFxuIiwNCisJCQkJaSwg
QlVGX1BBVFRFUk5fMiwgdmFsaWRfYnVmW2ldKTsNCisJCQlleGl0KEVYSVRfRkFJTFVSRSk7DQor
CQl9DQorCX0NCisNCisJLyogVW5tYXAgYnVmZmVycy4gKi8NCisJbXVubWFwKGJyb2tlbl9idWYs
IHBhZ2Vfc2l6ZSk7DQorCW11bm1hcChicm9rZW5fYnVmICsgcGFnZV9zaXplICogMiwgcGFnZV9z
aXplKTsNCisJbXVubWFwKHZhbGlkX2J1ZiwgYnVmX3NpemUpOw0KKwljbG9zZShmZCk7DQorfQ0K
Kw0KIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCiAJew0KIAkJLm5h
bWUgPSAiU09DS19TVFJFQU0gY29ubmVjdGlvbiByZXNldCIsDQpAQCAtNTE1LDYgKzY0MSwxMSBA
QCBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7DQogCQkucnVuX2NsaWVu
dCA9IHRlc3Rfc2VxcGFja2V0X3RpbWVvdXRfY2xpZW50LA0KIAkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0
X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlciwNCiAJfSwNCisJew0KKwkJLm5hbWUgPSAiU09DS19T
RVFQQUNLRVQgaW52YWxpZCByZWNlaXZlIGJ1ZmZlciIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rf
c2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9jbGllbnQsDQorCQkucnVuX3NlcnZlciA9IHRl
c3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07
DQogDQotLSANCjIuMjUuMQ0K
