Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A872D4DBEC7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 06:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiCQFz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 01:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCQFz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 01:55:26 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A282220EE;
        Wed, 16 Mar 2022 22:27:58 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id B01A25FD05;
        Thu, 17 Mar 2022 08:27:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647494875;
        bh=Ompi4xbRQbnpUpOJ16sHOJ+JWKY7vg+02Db2wCk8mCA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=irhKgrfoFShVO8afiyTqqzR5u3hxZudUmTx7dEcPsaHh8ohvQUKsEito67HvQt9aT
         zwxg1odSk5K6yC3jnDCFqUQYfQ1Z7MDjuVvYA458ebXxPEq8dzf4x9KQ7NLo8W7vVq
         C3jnMT93zUWMDs3rAqkfT3ngfMsDeZ8oyqMxRx1o8UasHrr9Spjb9XEB2UEdeHGUZA
         nvdauIlUwxPYZwStQtGo/pV2Iea1vToRKitC51AZMNyiLKKPPjfc7B4u9BHEf3V2oE
         jQT1HsKAeALd9td8mJT4P7+5mieCmsw+kddX2GDC0ha2YgcQdRstDK3NniSWSfyGIf
         l3W5yzny+Rd4w==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 08:27:55 +0300 (MSK)
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
Subject: [PATCH net-next v3 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Topic: [PATCH net-next v3 1/2] af_vsock: SOCK_SEQPACKET receive timeout
 test
Thread-Index: AQHYOb+Ukv8XF38YE06ap5RsA4YM1g==
Date:   Thu, 17 Mar 2022 05:26:45 +0000
Message-ID: <a3f95812-d5bb-86a0-46a0-78935651e39e@sberdevices.ru>
In-Reply-To: <4ecfa306-a374-93f6-4e66-be62895ae4f7@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <92CA1A604E01A842AC5098FE117172E4@sberdevices.ru>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGVzdCBmb3IgcmVjZWl2ZSB0aW1lb3V0IGNoZWNrOiBjb25uZWN0aW9uIGlzIGVzdGFibGlzaGVk
LA0KcmVjZWl2ZXIgc2V0cyB0aW1lb3V0LCBidXQgc2VuZGVyIGRvZXMgbm90aGluZy4gUmVjZWl2
ZXIncw0KJ3JlYWQoKScgY2FsbCBtdXN0IHJldHVybiBFQUdBSU4uDQoNClNpZ25lZC1vZmYtYnk6
IEtyYXNub3YgQXJzZW5peSBWbGFkaW1pcm92aWNoIDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+
DQotLS0NCiB2MiAtPiB2MzoNCiAxKSBVc2UgJ2ZwcmludGYoKScgaW5zdGVhZCBvZiAncGVycm9y
KCknIHdoZXJlICdlcnJubycgdmFyaWFibGUNCiAgICBpcyBub3QgYWZmZWN0ZWQuDQogMikgUHJp
bnQgJ3JlYWQoKScgb3ZlcmhlYWQuDQoNCiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3Qu
YyB8IDg0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQs
IDg0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNv
Y2tfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCmluZGV4IDJhMzYz
OGMwYTAwOC4uZjU0OThkZTY3NTFkIDEwMDY0NA0KLS0tIGEvdG9vbHMvdGVzdGluZy92c29jay92
c29ja190ZXN0LmMNCisrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQpAQCAt
MTYsNiArMTYsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4NCiAjaW5jbHVkZSA8c3lz
L3R5cGVzLmg+DQogI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4NCisjaW5jbHVkZSA8dGltZS5oPg0K
IA0KICNpbmNsdWRlICJ0aW1lb3V0LmgiDQogI2luY2x1ZGUgImNvbnRyb2wuaCINCkBAIC0zOTEs
NiArMzkyLDg0IEBAIHN0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X21zZ190cnVuY19zZXJ2ZXIo
Y29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCiAJY2xvc2UoZmQpOw0KIH0NCiANCitzdGF0
aWMgdGltZV90IGN1cnJlbnRfbnNlYyh2b2lkKQ0KK3sNCisJc3RydWN0IHRpbWVzcGVjIHRzOw0K
Kw0KKwlpZiAoY2xvY2tfZ2V0dGltZShDTE9DS19SRUFMVElNRSwgJnRzKSkgew0KKwkJcGVycm9y
KCJjbG9ja19nZXR0aW1lKDMpIGZhaWxlZCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9
DQorDQorCXJldHVybiAodHMudHZfc2VjICogMTAwMDAwMDAwMFVMTCkgKyB0cy50dl9uc2VjOw0K
K30NCisNCisjZGVmaW5lIFJDVlRJTUVPX1RJTUVPVVRfU0VDIDENCisjZGVmaW5lIFJFQURfT1ZF
UkhFQURfTlNFQyAyNTAwMDAwMDAgLyogMC4yNSBzZWMgKi8NCisNCitzdGF0aWMgdm9pZCB0ZXN0
X3NlcXBhY2tldF90aW1lb3V0X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0K
K3sNCisJaW50IGZkOw0KKwlzdHJ1Y3QgdGltZXZhbCB0djsNCisJY2hhciBkdW1teTsNCisJdGlt
ZV90IHJlYWRfZW50ZXJfbnM7DQorCXRpbWVfdCByZWFkX292ZXJoZWFkX25zOw0KKw0KKwlmZCA9
IHZzb2NrX3NlcXBhY2tldF9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCisJaWYgKGZk
IDwgMCkgew0KKwkJcGVycm9yKCJjb25uZWN0Iik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQor
CX0NCisNCisJdHYudHZfc2VjID0gUkNWVElNRU9fVElNRU9VVF9TRUM7DQorCXR2LnR2X3VzZWMg
PSAwOw0KKw0KKwlpZiAoc2V0c29ja29wdChmZCwgU09MX1NPQ0tFVCwgU09fUkNWVElNRU8sICh2
b2lkICopJnR2LCBzaXplb2YodHYpKSA9PSAtMSkgew0KKwkJcGVycm9yKCJzZXRzb2Nrb3B0ICdT
T19SQ1ZUSU1FTyciKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlyZWFkX2Vu
dGVyX25zID0gY3VycmVudF9uc2VjKCk7DQorDQorCWlmIChlcnJubyAhPSBFQUdBSU4pIHsNCisJ
CXBlcnJvcigiRUFHQUlOIGV4cGVjdGVkIik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0N
CisNCisJaWYgKHJlYWQoZmQsICZkdW1teSwgc2l6ZW9mKGR1bW15KSkgIT0gLTEpIHsNCisJCWZw
cmludGYoc3RkZXJyLA0KKwkJCSJleHBlY3RlZCAnZHVtbXknIHJlYWQoMikgZmFpbHVyZVxuIik7
DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJcmVhZF9vdmVyaGVhZF9ucyA9IGN1
cnJlbnRfbnNlYygpIC0gcmVhZF9lbnRlcl9ucyAtDQorCQkJMTAwMDAwMDAwMFVMTCAqIFJDVlRJ
TUVPX1RJTUVPVVRfU0VDOw0KKw0KKwlpZiAocmVhZF9vdmVyaGVhZF9ucyA+IFJFQURfT1ZFUkhF
QURfTlNFQykgew0KKwkJZnByaW50ZihzdGRlcnIsDQorCQkJInRvbyBtdWNoIHRpbWUgaW4gcmVh
ZCgyKSwgJWx1ID4gJWkgbnNcbiIsDQorCQkJcmVhZF9vdmVyaGVhZF9ucywgUkVBRF9PVkVSSEVB
RF9OU0VDKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwljb250cm9sX3dyaXRl
bG4oIldBSVRET05FIik7DQorCWNsb3NlKGZkKTsNCit9DQorDQorc3RhdGljIHZvaWQgdGVzdF9z
ZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCit7
DQorCWludCBmZDsNCisNCisJZmQgPSB2c29ja19zZXFwYWNrZXRfYWNjZXB0KFZNQUREUl9DSURf
QU5ZLCAxMjM0LCBOVUxMKTsNCisJaWYgKGZkIDwgMCkgew0KKwkJcGVycm9yKCJhY2NlcHQiKTsN
CisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwljb250cm9sX2V4cGVjdGxuKCJXQUlU
RE9ORSIpOw0KKwljbG9zZShmZCk7DQorfQ0KKw0KIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRl
c3RfY2FzZXNbXSA9IHsNCiAJew0KIAkJLm5hbWUgPSAiU09DS19TVFJFQU0gY29ubmVjdGlvbiBy
ZXNldCIsDQpAQCAtNDMxLDYgKzUxMCwxMSBAQCBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0
X2Nhc2VzW10gPSB7DQogCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X21zZ190cnVuY19j
bGllbnQsDQogCQkucnVuX3NlcnZlciA9IHRlc3Rfc2VxcGFja2V0X21zZ190cnVuY19zZXJ2ZXIs
DQogCX0sDQorCXsNCisJCS5uYW1lID0gIlNPQ0tfU0VRUEFDS0VUIHRpbWVvdXQiLA0KKwkJLnJ1
bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X2NsaWVudCwNCisJCS5ydW5fc2VydmVy
ID0gdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07DQogDQot
LSANCjIuMjUuMQ0K
