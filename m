Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8047C5244B5
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349148AbiELFKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242098AbiELFKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:10:08 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44B1D80A3;
        Wed, 11 May 2022 22:10:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id DA33F5FD07;
        Thu, 12 May 2022 08:10:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1652332202;
        bh=hWa5wc59WhjDEzgjj/klRlZ7K1TFeSjuuN1vkJ+Q9iM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=jCB4baASDxwDw5GXa4bdVExVXKvJvmoCO1AtQGwuMqN96IOAkx8SPgbzaqHsuX36T
         j+NBBCc1TjkAGeLX6PDi8b1IC8mXG62/BDo0Mcgf+liUBZ87Z97wQ2oRFHxriUrC31
         mAylAeV9XZYmiC4/dEgEJnZI1tX4pwwUZ+w4pakX6n8wvAcJRCSjkLJlOGIYzNQPf9
         75X1MAQnShc/Zd26mciTl2xfuKbRWXzGtjP3AEeQi0rFaVswThas8GkBvbk4LnbYCQ
         AmHdjnpanf9zPT3hTqf+QMHhNmcP+QPhu1puqW5+Yobk3c0qkDpnHQ9OeDpV9J5ic9
         ES77S9D2KVtLQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 12 May 2022 08:10:02 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 2/8] vhost/vsock: rework packet allocation logic
Thread-Topic: [RFC PATCH v1 2/8] vhost/vsock: rework packet allocation logic
Thread-Index: AQHYZb5v345nmTI7vUa/Rih0CKpclA==
Date:   Thu, 12 May 2022 05:09:19 +0000
Message-ID: <988e9e3c-7993-d6e2-626d-deb46248ed9f@sberdevices.ru>
In-Reply-To: <7cdcb1e1-7c97-c054-19cf-5caeacae981d@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <947E2EBC49D02E47ACB875C40CBF0AF2@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/05/12 02:55:00 #19424207
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rm9yIHBhY2tldHMgcmVjZWl2ZWQgZnJvbSB2aXJ0aW8gUlggcXVldWUsIHVzZSBidWRkeQ0KYWxs
b2NhdG9yIGluc3RlYWQgb2YgJ2ttYWxsb2MoKScgdG8gYmUgYWJsZSB0byBpbnNlcnQNCnN1Y2gg
cGFnZXMgdG8gdXNlciBwcm92aWRlZCB2bWEuIFNpbmdsZSBjYWxsIHRvDQonY29weV9mcm9tX2l0
ZXIoKScgcmVwbGFjZWQgd2l0aCBwZXItcGFnZSBsb29wLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNl
bml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIGRyaXZlcnMvdmhv
c3QvdnNvY2suYyB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0NCiAxIGZpbGUgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYyBiL2RyaXZlcnMvdmhvc3QvdnNvY2su
Yw0KaW5kZXggMzdmMGI0Mjc0MTEzLi4xNTc3OTg5ODUzODkgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Zob3N0L3Zzb2NrLmMNCisrKyBiL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KQEAgLTM2MCw2ICsz
NjAsOSBAQCB2aG9zdF92c29ja19hbGxvY19wa3Qoc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEs
DQogCXN0cnVjdCBpb3ZfaXRlciBpb3ZfaXRlcjsNCiAJc2l6ZV90IG5ieXRlczsNCiAJc2l6ZV90
IGxlbjsNCisJc3RydWN0IHBhZ2UgKmJ1Zl9wYWdlOw0KKwlzc2l6ZV90IHBrdF9sZW47DQorCWlu
dCBwYWdlX2lkeDsNCiANCiAJaWYgKGluICE9IDApIHsNCiAJCXZxX2Vycih2cSwgIkV4cGVjdGVk
IDAgaW5wdXQgYnVmZmVycywgZ290ICV1XG4iLCBpbik7DQpAQCAtMzkzLDIwICszOTYsNTAgQEAg
dmhvc3RfdnNvY2tfYWxsb2NfcGt0KHN0cnVjdCB2aG9zdF92aXJ0cXVldWUgKnZxLA0KIAkJcmV0
dXJuIE5VTEw7DQogCX0NCiANCi0JcGt0LT5idWYgPSBrbWFsbG9jKHBrdC0+bGVuLCBHRlBfS0VS
TkVMKTsNCi0JaWYgKCFwa3QtPmJ1Zikgew0KKwkvKiBUaGlzIGNyZWF0ZXMgbWVtb3J5IG92ZXJy
dW4sIGFzIHdlIGFsbG9jYXRlDQorCSAqIGF0IGxlYXN0IG9uZSBwYWdlIGZvciBlYWNoIHBhY2tl
dC4NCisJICovDQorCWJ1Zl9wYWdlID0gYWxsb2NfcGFnZXMoR0ZQX0tFUk5FTCwgZ2V0X29yZGVy
KHBrdC0+bGVuKSk7DQorDQorCWlmIChidWZfcGFnZSA9PSBOVUxMKSB7DQogCQlrZnJlZShwa3Qp
Ow0KIAkJcmV0dXJuIE5VTEw7DQogCX0NCiANCisJcGt0LT5idWYgPSBwYWdlX3RvX3ZpcnQoYnVm
X3BhZ2UpOw0KIAlwa3QtPmJ1Zl9sZW4gPSBwa3QtPmxlbjsNCiANCi0JbmJ5dGVzID0gY29weV9m
cm9tX2l0ZXIocGt0LT5idWYsIHBrdC0+bGVuLCAmaW92X2l0ZXIpOw0KLQlpZiAobmJ5dGVzICE9
IHBrdC0+bGVuKSB7DQotCQl2cV9lcnIodnEsICJFeHBlY3RlZCAldSBieXRlIHBheWxvYWQsIGdv
dCAlenUgYnl0ZXNcbiIsDQotCQkgICAgICAgcGt0LT5sZW4sIG5ieXRlcyk7DQotCQl2aXJ0aW9f
dHJhbnNwb3J0X2ZyZWVfcGt0KHBrdCk7DQotCQlyZXR1cm4gTlVMTDsNCisJcGFnZV9pZHggPSAw
Ow0KKwlwa3RfbGVuID0gcGt0LT5sZW47DQorDQorCS8qIEFzIGFsbG9jYXRlZCBwYWdlcyBhcmUg
bm90IG1hcHBlZCwgcHJvY2Vzcw0KKwkgKiBwYWdlcyBvbmUgYnkgb25lLg0KKwkgKi8NCisJd2hp
bGUgKHBrdF9sZW4gPiAwKSB7DQorCQl2b2lkICptYXBwZWQ7DQorCQlzaXplX3QgdG9fY29weTsN
CisNCisJCW1hcHBlZCA9IGttYXAoYnVmX3BhZ2UgKyBwYWdlX2lkeCk7DQorDQorCQlpZiAobWFw
cGVkID09IE5VTEwpIHsNCisJCQl2aXJ0aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KHBrdCk7DQorCQkJ
cmV0dXJuIE5VTEw7DQorCQl9DQorDQorCQl0b19jb3B5ID0gbWluKHBrdF9sZW4sICgoc3NpemVf
dClQQUdFX1NJWkUpKTsNCisNCisJCW5ieXRlcyA9IGNvcHlfZnJvbV9pdGVyKG1hcHBlZCwgdG9f
Y29weSwgJmlvdl9pdGVyKTsNCisJCWlmIChuYnl0ZXMgIT0gdG9fY29weSkgew0KKwkJCXZxX2Vy
cih2cSwgIkV4cGVjdGVkICV6dSBieXRlIHBheWxvYWQsIGdvdCAlenUgYnl0ZXNcbiIsDQorCQkJ
ICAgICAgIHRvX2NvcHksIG5ieXRlcyk7DQorCQkJdmlydGlvX3RyYW5zcG9ydF9mcmVlX3BrdChw
a3QpOw0KKwkJCXJldHVybiBOVUxMOw0KKwkJfQ0KKw0KKwkJa3VubWFwKG1hcHBlZCk7DQorDQor
CQlwa3RfbGVuIC09IHRvX2NvcHk7DQorCQlwYWdlX2lkeCsrOw0KIAl9DQogDQogCXJldHVybiBw
a3Q7DQotLSANCjIuMjUuMQ0K
