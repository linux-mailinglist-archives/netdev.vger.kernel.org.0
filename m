Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D264DABD7
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351573AbiCPHbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 03:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiCPHbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 03:31:36 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3662C33EBC;
        Wed, 16 Mar 2022 00:30:22 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id CA8C75FD06;
        Wed, 16 Mar 2022 10:30:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647415819;
        bh=G7IFLtrcWjFV4L5ioI5uaKBhVq+8Tp4JEmzJtfNcbiw=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Eq0Ud9/rOxauW+WpqRtLdSP9lislPCO/QFcQuZuRfAjBlrqgnY10cxlgzNQv1oCwp
         I3CxMlAL0EyqWxfIWiFzv7H3ZcUbvFtwW9pJ4FFhAEfbFwQcoM5EHNChiGkRy2WfBj
         xl2+NG7HIEgLeeCWK4RUVAjyFp4Slth0c9HI7BC4oK3VbAkJVu/mSUBkXEnDa3VH0Z
         rZ1tb6vruNOwjOxcCyk7CmUoDU8P5vq+RYpGyQbCfsja1/MdTAWlyYeS9HIBvxzHT/
         WPVViyF0khV7Gb7Op29yj/TjpQt6EfInEix7rEqq+uxqkOdv19UUqccNhvFf3R46BE
         EArDcniZ/2Cjw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 16 Mar 2022 10:30:19 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 2/2] af_vsock: SOCK_SEQPACKET broken buffer test
Thread-Topic: [RFC PATCH v2 2/2] af_vsock: SOCK_SEQPACKET broken buffer test
Thread-Index: AQHYOQeRPBC2SmOdIke73RmK57AUvg==
Date:   Wed, 16 Mar 2022 07:29:28 +0000
Message-ID: <415368cd-81b3-e2fd-fbed-65cacfc43850@sberdevices.ru>
In-Reply-To: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BC0C9FC87BFF94CB3FAAA3F9A1C14FF@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/16 03:19:00 #18979713
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
Pg0KLS0tDQogdjEgLT4gdjI6DQogMSkgVXNlICdmcHJpbnRmKCknIGluc3RlYWQgb2YgJ3BlcnJv
cigpJyB3aGVyZSAnZXJybm8nIHZhcmlhYmxlDQogICAgaXMgbm90IGFmZmVjdGVkLg0KIDIpIFJl
cGxhY2Ugd29yZCAiaW52YWxpZCIgLT4gInVuZXhwZWN0ZWQiLg0KICAgIA0KIHRvb2xzL3Rlc3Rp
bmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgMTMyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCiAxIGZpbGUgY2hhbmdlZCwgMTMyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL3Rv
b2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy92c29jay92c29j
a190ZXN0LmMNCmluZGV4IDZkNzY0OGNjZTVhYS4uMTEzMmJjZDhkZGI3IDEwMDY0NA0KLS0tIGEv
dG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCisrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNv
Y2svdnNvY2tfdGVzdC5jDQpAQCAtMTcsNiArMTcsNyBAQA0KICNpbmNsdWRlIDxzeXMvdHlwZXMu
aD4NCiAjaW5jbHVkZSA8c3lzL3NvY2tldC5oPg0KICNpbmNsdWRlIDx0aW1lLmg+DQorI2luY2x1
ZGUgPHN5cy9tbWFuLmg+DQogDQogI2luY2x1ZGUgInRpbWVvdXQuaCINCiAjaW5jbHVkZSAiY29u
dHJvbC5oIg0KQEAgLTQ2NSw2ICs0NjYsMTMyIEBAIHN0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0
X3RpbWVvdXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQogCWNsb3NlKGZk
KTsNCiB9DQogDQorI2RlZmluZSBCVUZfUEFUVEVSTl8xICdhJw0KKyNkZWZpbmUgQlVGX1BBVFRF
Uk5fMiAnYicNCisNCitzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZm
ZXJfY2xpZW50KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwlpbnQgZmQ7DQor
CXVuc2lnbmVkIGNoYXIgKmJ1ZjE7DQorCXVuc2lnbmVkIGNoYXIgKmJ1ZjI7DQorCWludCBidWZf
c2l6ZSA9IGdldHBhZ2VzaXplKCkgKiAzOw0KKw0KKwlmZCA9IHZzb2NrX3NlcXBhY2tldF9jb25u
ZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCisJaWYgKGZkIDwgMCkgew0KKwkJcGVycm9yKCJj
b25uZWN0Iik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJYnVmMSA9IG1hbGxv
YyhidWZfc2l6ZSk7DQorCWlmIChidWYxID09IE5VTEwpIHsNCisJCXBlcnJvcigiJ21hbGxvYygp
JyBmb3IgJ2J1ZjEnIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJYnVmMiA9
IG1hbGxvYyhidWZfc2l6ZSk7DQorCWlmIChidWYyID09IE5VTEwpIHsNCisJCXBlcnJvcigiJ21h
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
ZWFkKDIpLCBnb3QgJXppLCBleHBlY3RlZCAlaVxuIiwNCisJCQlyZXMsIGJ1Zl9zaXplKTsNCisJ
CWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlmb3IgKGkgPSAwOyBpIDwgYnVmX3NpemU7
IGkrKykgew0KKwkJaWYgKHZhbGlkX2J1ZltpXSAhPSBCVUZfUEFUVEVSTl8yKSB7DQorCQkJZnBy
aW50ZihzdGRlcnIsDQorCQkJCSJpbnZhbGlkIHBhdHRlcm4gZm9yICd2YWxpZF9idWYnIGF0ICVp
LCBleHBlY3RlZCAlaGhYLCBnb3QgJWhoWFxuIiwNCisJCQkJaSwgQlVGX1BBVFRFUk5fMiwgdmFs
aWRfYnVmW2ldKTsNCisJCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCQl9DQorCX0NCisNCisNCisJ
LyogVW5tYXAgYnVmZmVycy4gKi8NCisJbXVubWFwKGJyb2tlbl9idWYsIHBhZ2Vfc2l6ZSk7DQor
CW11bm1hcChicm9rZW5fYnVmICsgcGFnZV9zaXplICogMiwgcGFnZV9zaXplKTsNCisJbXVubWFw
KHZhbGlkX2J1ZiwgYnVmX3NpemUpOw0KKwljbG9zZShmZCk7DQorfQ0KKw0KIHN0YXRpYyBzdHJ1
Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCiAJew0KIAkJLm5hbWUgPSAiU09DS19TVFJF
QU0gY29ubmVjdGlvbiByZXNldCIsDQpAQCAtNTEwLDYgKzYzNywxMSBAQCBzdGF0aWMgc3RydWN0
IHRlc3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7DQogCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFj
a2V0X3RpbWVvdXRfY2xpZW50LA0KIAkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF90aW1l
b3V0X3NlcnZlciwNCiAJfSwNCisJew0KKwkJLm5hbWUgPSAiU09DS19TRVFQQUNLRVQgaW52YWxp
ZCByZWNlaXZlIGJ1ZmZlciIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2ludmFs
aWRfcmVjX2J1ZmZlcl9jbGllbnQsDQorCQkucnVuX3NlcnZlciA9IHRlc3Rfc2VxcGFja2V0X2lu
dmFsaWRfcmVjX2J1ZmZlcl9zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07DQogDQotLSANCjIuMjUu
MQ0K
