Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53614DABD1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354157AbiCPH36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 03:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiCPH35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 03:29:57 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828FAB878;
        Wed, 16 Mar 2022 00:28:39 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id C71BD5FD04;
        Wed, 16 Mar 2022 10:28:36 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647415716;
        bh=2IlBHxR34MTy4N3KHRTBgHnJ2xxkKsv6pow01JHAr2E=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=aiZQcrSk0UxNXLP8lYuD/GlPiqP+/tOv77ygcczSwDKPCB2P0/l2uk6HVTvqrW65Y
         YvP5XJ3YzecjESk1EKop5WoxigAM8xdkmm4RI07nZvAHjV3gQS2ucDOfTgbS6HIGrU
         CR3ewPvUJzvHSF2Fbl9n+jg1FAO10ed+gKexoe0JiSCDs/BTEsiLmsVVDyAyxM/pOI
         C5vms8eX8n393OfBuJ8EXapW+vwIyocP+QIpBaHA/LlVg7yeVZHHzTy61zZHjZDrjo
         GS1uoFbSMIRrYGy308fdMown/eLgAzLkgGRXJWRNgv/p/0hPQueTg74a3VBl9JNMXb
         To9Mp5sMgE7QQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 16 Mar 2022 10:28:36 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Topic: [RFC PATCH v2 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Index: AQHYOQdQb7ugiPNDrEajiUcKS1B+hw==
Date:   Wed, 16 Mar 2022 07:27:45 +0000
Message-ID: <2bc15104-37e6-088a-1699-dc27d0e2dadf@sberdevices.ru>
In-Reply-To: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <07689CD41ED3BF48AF8196A35B35777C@sberdevices.ru>
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

VGVzdCBmb3IgcmVjZWl2ZSB0aW1lb3V0IGNoZWNrOiBjb25uZWN0aW9uIGlzIGVzdGFibGlzaGVk
LA0KcmVjZWl2ZXIgc2V0cyB0aW1lb3V0LCBidXQgc2VuZGVyIGRvZXMgbm90aGluZy4gUmVjZWl2
ZXIncw0KJ3JlYWQoKScgY2FsbCBtdXN0IHJldHVybiBFQUdBSU4uDQoNClNpZ25lZC1vZmYtYnk6
IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogdjEgLT4g
djI6DQogMSkgQ2hlY2sgYW1vdW50IG9mIHRpbWUgc3BlbnQgaW4gJ3JlYWQoKScuDQoNCiB0b29s
cy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyB8IDc5ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDc5IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdp
dCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy92c29j
ay92c29ja190ZXN0LmMNCmluZGV4IDJhMzYzOGMwYTAwOC4uNmQ3NjQ4Y2NlNWFhIDEwMDY0NA0K
LS0tIGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCisrKyBiL3Rvb2xzL3Rlc3Rp
bmcvdnNvY2svdnNvY2tfdGVzdC5jDQpAQCAtMTYsNiArMTYsNyBAQA0KICNpbmNsdWRlIDxsaW51
eC9rZXJuZWwuaD4NCiAjaW5jbHVkZSA8c3lzL3R5cGVzLmg+DQogI2luY2x1ZGUgPHN5cy9zb2Nr
ZXQuaD4NCisjaW5jbHVkZSA8dGltZS5oPg0KIA0KICNpbmNsdWRlICJ0aW1lb3V0LmgiDQogI2lu
Y2x1ZGUgImNvbnRyb2wuaCINCkBAIC0zOTEsNiArMzkyLDc5IEBAIHN0YXRpYyB2b2lkIHRlc3Rf
c2VxcGFja2V0X21zZ190cnVuY19zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykN
CiAJY2xvc2UoZmQpOw0KIH0NCiANCitzdGF0aWMgdGltZV90IGN1cnJlbnRfbnNlYyh2b2lkKQ0K
K3sNCisJc3RydWN0IHRpbWVzcGVjIHRzOw0KKw0KKwlpZiAoY2xvY2tfZ2V0dGltZShDTE9DS19S
RUFMVElNRSwgJnRzKSkgew0KKwkJcGVycm9yKCJjbG9ja19nZXR0aW1lKDMpIGZhaWxlZCIpOw0K
KwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCXJldHVybiAodHMudHZfc2VjICogMTAw
MDAwMDAwMFVMTCkgKyB0cy50dl9uc2VjOw0KK30NCisNCisjZGVmaW5lIFJDVlRJTUVPX1RJTUVP
VVRfU0VDIDENCisjZGVmaW5lIFJFQURfT1ZFUkhFQURfTlNFQyAyNTAwMDAwMDAgLyogMC4yNSBz
ZWMgKi8NCisNCitzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X2NsaWVudChjb25z
dCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKwlzdHJ1Y3QgdGltZXZh
bCB0djsNCisJY2hhciBkdW1teTsNCisJdGltZV90IHJlYWRfZW50ZXJfbnM7DQorCXRpbWVfdCBy
ZWFkX292ZXJoZWFkX25zOw0KKw0KKwlmZCA9IHZzb2NrX3NlcXBhY2tldF9jb25uZWN0KG9wdHMt
PnBlZXJfY2lkLCAxMjM0KTsNCisJaWYgKGZkIDwgMCkgew0KKwkJcGVycm9yKCJjb25uZWN0Iik7
DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJdHYudHZfc2VjID0gUkNWVElNRU9f
VElNRU9VVF9TRUM7DQorCXR2LnR2X3VzZWMgPSAwOw0KKw0KKwlpZiAoc2V0c29ja29wdChmZCwg
U09MX1NPQ0tFVCwgU09fUkNWVElNRU8sICh2b2lkICopJnR2LCBzaXplb2YodHYpKSA9PSAtMSkg
ew0KKwkJcGVycm9yKCJzZXRzb2Nrb3B0ICdTT19SQ1ZUSU1FTyciKTsNCisJCWV4aXQoRVhJVF9G
QUlMVVJFKTsNCisJfQ0KKw0KKwlyZWFkX2VudGVyX25zID0gY3VycmVudF9uc2VjKCk7DQorDQor
CWlmICgocmVhZChmZCwgJmR1bW15LCBzaXplb2YoZHVtbXkpKSAhPSAtMSkgfHwNCisJICAgIChl
cnJubyAhPSBFQUdBSU4pKSB7DQorCQlwZXJyb3IoIkVBR0FJTiBleHBlY3RlZCIpOw0KKwkJZXhp
dChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCXJlYWRfb3ZlcmhlYWRfbnMgPSBjdXJyZW50X25z
ZWMoKSAtIHJlYWRfZW50ZXJfbnMgLQ0KKwkJCTEwMDAwMDAwMDBVTEwgKiBSQ1ZUSU1FT19USU1F
T1VUX1NFQzsNCisNCisJaWYgKHJlYWRfb3ZlcmhlYWRfbnMgPiBSRUFEX09WRVJIRUFEX05TRUMp
IHsNCisJCWZwcmludGYoc3RkZXJyLA0KKwkJCSJ0b28gbXVjaCB0aW1lIGluIHJlYWQoMikgd2l0
aCBTT19SQ1ZUSU1FTzogJWx1IG5zXG4iLA0KKwkJCXJlYWRfb3ZlcmhlYWRfbnMpOw0KKwkJZXhp
dChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfd3JpdGVsbigiV0FJVERPTkUiKTsN
CisJY2xvc2UoZmQpOw0KK30NCisNCitzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF90aW1lb3V0
X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKw0K
KwlmZCA9IHZzb2NrX3NlcXBhY2tldF9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwp
Ow0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZB
SUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfZXhwZWN0bG4oIldBSVRET05FIik7DQorCWNsb3Nl
KGZkKTsNCit9DQorDQogc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0K
IAl7DQogCQkubmFtZSA9ICJTT0NLX1NUUkVBTSBjb25uZWN0aW9uIHJlc2V0IiwNCkBAIC00MzEs
NiArNTA1LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCiAJ
CS5ydW5fY2xpZW50ID0gdGVzdF9zZXFwYWNrZXRfbXNnX3RydW5jX2NsaWVudCwNCiAJCS5ydW5f
c2VydmVyID0gdGVzdF9zZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZlciwNCiAJfSwNCisJew0KKwkJ
Lm5hbWUgPSAiU09DS19TRVFQQUNLRVQgdGltZW91dCIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rf
c2VxcGFja2V0X3RpbWVvdXRfY2xpZW50LA0KKwkJLnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tl
dF90aW1lb3V0X3NlcnZlciwNCisJfSwNCiAJe30sDQogfTsNCiANCi0tIA0KMi4yNS4xDQo=
