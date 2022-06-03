Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA90F53C44F
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbiFCFdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbiFCFdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:33:51 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5787738DB4;
        Thu,  2 Jun 2022 22:33:49 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 5D6555FD02;
        Fri,  3 Jun 2022 08:33:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1654234427;
        bh=b9GzNc2WzHZEJq4QtMm9PZjoUEvGtrSFFwftlDQ1gMs=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=AersA+wy3i1Sk0Ws4oMv1WxulXlzA+iGQxmqXhbV2j1N6py8peQFv0YK6tUPUnAYF
         TUpaOvWba1FveyVgL4Djk3bSa8eyxZFObmW9QsC8MXgvsZvkmjq0iibmE+oP6RVDiz
         QDY02l1rpzP1kx0glOveb/LzLK2iDh9mFNoiWbR+rUbe/7KwN3yx3nfj3d5u2VogUV
         y75vSn53WbjmrVipNUhnZ9VGdERbFsDnFBFetWfR86g917FXPYaYWGbGmtODTn8pND
         JTv/7h3iusStTJyE6NASEsbUMYlfC3ncWK0A01WJHCZOdbATZP8JWrEctwvmiu/q8M
         7WwmP2REVwN0Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri,  3 Jun 2022 08:33:32 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 2/8] vhost/vsock: rework packet allocation logic
Thread-Topic: [RFC PATCH v2 2/8] vhost/vsock: rework packet allocation logic
Thread-Index: AQHYdwtmNyMIn8KDWEakLUC7mf1LGg==
Date:   Fri, 3 Jun 2022 05:33:04 +0000
Message-ID: <72ae7f76-ffee-3e64-d445-7a0f4261d891@sberdevices.ru>
In-Reply-To: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <45162A55C80F4745A2F2E93FE9A70961@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/06/03 01:19:00 #19656765
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
c3QvdnNvY2suYyB8IDgxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0NCiAxIGZpbGUgY2hhbmdlZCwgNjkgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMgYi9kcml2ZXJzL3Zob3N0L3Zzb2Nr
LmMNCmluZGV4IGU2YzlkNDFkYjFkZS4uMGRjMjIyOWYxOGY3IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy92aG9zdC92c29jay5jDQorKysgYi9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCkBAIC01OCw2ICs1
OCw3IEBAIHN0cnVjdCB2aG9zdF92c29jayB7DQogDQogCXUzMiBndWVzdF9jaWQ7DQogCWJvb2wg
c2VxcGFja2V0X2FsbG93Ow0KKwlib29sIHplcm9jb3B5X3J4X29uOw0KIH07DQogDQogc3RhdGlj
IHUzMiB2aG9zdF90cmFuc3BvcnRfZ2V0X2xvY2FsX2NpZCh2b2lkKQ0KQEAgLTM1Nyw2ICszNTgs
NyBAQCB2aG9zdF92c29ja19hbGxvY19wa3Qoc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEsDQog
CQkgICAgICB1bnNpZ25lZCBpbnQgb3V0LCB1bnNpZ25lZCBpbnQgaW4pDQogew0KIAlzdHJ1Y3Qg
dmlydGlvX3Zzb2NrX3BrdCAqcGt0Ow0KKwlzdHJ1Y3Qgdmhvc3RfdnNvY2sgKnZzb2NrOw0KIAlz
dHJ1Y3QgaW92X2l0ZXIgaW92X2l0ZXI7DQogCXNpemVfdCBuYnl0ZXM7DQogCXNpemVfdCBsZW47
DQpAQCAtMzkzLDIwICszOTUsNzUgQEAgdmhvc3RfdnNvY2tfYWxsb2NfcGt0KHN0cnVjdCB2aG9z
dF92aXJ0cXVldWUgKnZxLA0KIAkJcmV0dXJuIE5VTEw7DQogCX0NCiANCi0JcGt0LT5idWYgPSBr
bWFsbG9jKHBrdC0+bGVuLCBHRlBfS0VSTkVMKTsNCi0JaWYgKCFwa3QtPmJ1Zikgew0KLQkJa2Zy
ZWUocGt0KTsNCi0JCXJldHVybiBOVUxMOw0KLQl9DQotDQogCXBrdC0+YnVmX2xlbiA9IHBrdC0+
bGVuOw0KKwl2c29jayA9IGNvbnRhaW5lcl9vZih2cS0+ZGV2LCBzdHJ1Y3Qgdmhvc3RfdnNvY2ss
IGRldik7DQogDQotCW5ieXRlcyA9IGNvcHlfZnJvbV9pdGVyKHBrdC0+YnVmLCBwa3QtPmxlbiwg
Jmlvdl9pdGVyKTsNCi0JaWYgKG5ieXRlcyAhPSBwa3QtPmxlbikgew0KLQkJdnFfZXJyKHZxLCAi
RXhwZWN0ZWQgJXUgYnl0ZSBwYXlsb2FkLCBnb3QgJXp1IGJ5dGVzXG4iLA0KLQkJICAgICAgIHBr
dC0+bGVuLCBuYnl0ZXMpOw0KLQkJdmlydGlvX3RyYW5zcG9ydF9mcmVlX3BrdChwa3QpOw0KLQkJ
cmV0dXJuIE5VTEw7DQorCWlmICghdnNvY2stPnplcm9jb3B5X3J4X29uKSB7DQorCQlwa3QtPmJ1
ZiA9IGttYWxsb2MocGt0LT5sZW4sIEdGUF9LRVJORUwpOw0KKw0KKwkJaWYgKCFwa3QtPmJ1Zikg
ew0KKwkJCWtmcmVlKHBrdCk7DQorCQkJcmV0dXJuIE5VTEw7DQorCQl9DQorDQorCQlwa3QtPnNs
YWJfYnVmID0gdHJ1ZTsNCisJCW5ieXRlcyA9IGNvcHlfZnJvbV9pdGVyKHBrdC0+YnVmLCBwa3Qt
PmxlbiwgJmlvdl9pdGVyKTsNCisJCWlmIChuYnl0ZXMgIT0gcGt0LT5sZW4pIHsNCisJCQl2cV9l
cnIodnEsICJFeHBlY3RlZCAldSBieXRlIHBheWxvYWQsIGdvdCAlenUgYnl0ZXNcbiIsDQorCQkJ
CXBrdC0+bGVuLCBuYnl0ZXMpOw0KKwkJCXZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3QocGt0KTsN
CisJCQlyZXR1cm4gTlVMTDsNCisJCX0NCisJfSBlbHNlIHsNCisJCXN0cnVjdCBwYWdlICpidWZf
cGFnZTsNCisJCXNzaXplX3QgcGt0X2xlbjsNCisJCWludCBwYWdlX2lkeDsNCisNCisJCS8qIFRo
aXMgY3JlYXRlcyBtZW1vcnkgb3ZlcnJ1biwgYXMgd2UgYWxsb2NhdGUNCisJCSAqIGF0IGxlYXN0
IG9uZSBwYWdlIGZvciBlYWNoIHBhY2tldC4NCisJCSAqLw0KKwkJYnVmX3BhZ2UgPSBhbGxvY19w
YWdlcyhHRlBfS0VSTkVMLCBnZXRfb3JkZXIocGt0LT5sZW4pKTsNCisNCisJCWlmIChidWZfcGFn
ZSA9PSBOVUxMKSB7DQorCQkJa2ZyZWUocGt0KTsNCisJCQlyZXR1cm4gTlVMTDsNCisJCX0NCisN
CisJCXBrdC0+YnVmID0gcGFnZV90b192aXJ0KGJ1Zl9wYWdlKTsNCisNCisJCXBhZ2VfaWR4ID0g
MDsNCisJCXBrdF9sZW4gPSBwa3QtPmxlbjsNCisNCisJCS8qIEFzIGFsbG9jYXRlZCBwYWdlcyBh
cmUgbm90IG1hcHBlZCwgcHJvY2Vzcw0KKwkJICogcGFnZXMgb25lIGJ5IG9uZS4NCisJCSAqLw0K
KwkJd2hpbGUgKHBrdF9sZW4gPiAwKSB7DQorCQkJdm9pZCAqbWFwcGVkOw0KKwkJCXNpemVfdCB0
b19jb3B5Ow0KKw0KKwkJCW1hcHBlZCA9IGttYXAoYnVmX3BhZ2UgKyBwYWdlX2lkeCk7DQorDQor
CQkJaWYgKG1hcHBlZCA9PSBOVUxMKSB7DQorCQkJCXZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3Qo
cGt0KTsNCisJCQkJcmV0dXJuIE5VTEw7DQorCQkJfQ0KKw0KKwkJCXRvX2NvcHkgPSBtaW4ocGt0
X2xlbiwgKChzc2l6ZV90KVBBR0VfU0laRSkpOw0KKw0KKwkJCW5ieXRlcyA9IGNvcHlfZnJvbV9p
dGVyKG1hcHBlZCwgdG9fY29weSwgJmlvdl9pdGVyKTsNCisJCQlpZiAobmJ5dGVzICE9IHRvX2Nv
cHkpIHsNCisJCQkJdnFfZXJyKHZxLCAiRXhwZWN0ZWQgJXp1IGJ5dGUgcGF5bG9hZCwgZ290ICV6
dSBieXRlc1xuIiwNCisJCQkJICAgICAgIHRvX2NvcHksIG5ieXRlcyk7DQorCQkJCWt1bm1hcCht
YXBwZWQpOw0KKwkJCQl2aXJ0aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KHBrdCk7DQorCQkJCXJldHVy
biBOVUxMOw0KKwkJCX0NCisNCisJCQlrdW5tYXAobWFwcGVkKTsNCisNCisJCQlwa3RfbGVuIC09
IHRvX2NvcHk7DQorCQkJcGFnZV9pZHgrKzsNCisJCX0NCiAJfQ0KIA0KIAlyZXR1cm4gcGt0Ow0K
LS0gDQoyLjI1LjENCg==
