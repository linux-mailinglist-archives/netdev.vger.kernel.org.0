Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11035244AE
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349049AbiELFHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348960AbiELFHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:07:40 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0A63916D;
        Wed, 11 May 2022 22:07:38 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 457255FD07;
        Thu, 12 May 2022 08:07:36 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1652332056;
        bh=uWyeWhV+o14znQk2Sqg83unLL60ICf31MFs9KoLPASs=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=pGLINxJ/56ycahbSatBg9ZCY4q8VwMiaMCH2kC7QP7n6A4woJNffqyiqyLSmGedMh
         R7MgKWCcHi3x6cHqr2IB/mZ2j82Benqnq1N48czy6pN/rRjzVlH3huWEWzup9vBnfr
         aztnighBWkjJ/x3QfrLjXnsV/scazcNHBAnAzNEyEkQe26SiEOFG4NIZZxeXQjDJk8
         MiH50Roq/+evLRhZR2ruhJ1tCMSq+g5KooNdUP5Nz3YB5STiiqI1X1egbZ9sXI/ZT9
         N5uMENn7xq6B9UPRboMqrASZr0wSzi+6gWtQY38Fnz1OcKqPwt6YCMMkA26HMCA7O2
         E2pFB71B8do9w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 12 May 2022 08:07:35 +0300 (MSK)
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
Subject: [RFC PATCH v1 1/8] virtio/vsock: rework packet allocation logic
Thread-Topic: [RFC PATCH v1 1/8] virtio/vsock: rework packet allocation logic
Thread-Index: AQHYZb4YktEgwRFewE2DI8rAWLS0Dw==
Date:   Thu, 12 May 2022 05:06:52 +0000
Message-ID: <3a8d9936-fc88-62ce-8c35-060b7d09b1bc@sberdevices.ru>
In-Reply-To: <7cdcb1e1-7c97-c054-19cf-5caeacae981d@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A4315244458694AA50C5403D95B603F@sberdevices.ru>
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

VG8gc3VwcG9ydCB6ZXJvY29weSByZWNlaXZlLCBwYWNrZXQncyBidWZmZXIgYWxsb2NhdGlvbg0K
aXMgY2hhbmdlZDogZm9yIGJ1ZmZlcnMgd2hpY2ggY291bGQgYmUgbWFwcGVkIHRvIHVzZXIncw0K
dm1hIHdlIGNhbid0IHVzZSAna21hbGxvYygpJyhhcyBrZXJuZWwgcmVzdHJpY3RzIHRvIG1hcA0K
c2xhYiBwYWdlcyB0byB1c2VyJ3Mgdm1hKSBhbmQgcmF3IGJ1ZGR5IGFsbG9jYXRvciBub3cNCmNh
bGxlZC4gQnV0LCBmb3IgdHggcGFja2V0cyhzdWNoIHBhY2tldHMgd29uJ3QgYmUgbWFwcGVkDQp0
byB1c2VyKSwgcHJldmlvdXMgJ2ttYWxsb2MoKScgd2F5IGlzIHVzZWQsIGJ1dCB3aXRoIHNwZWNp
YWwNCmZsYWcgaW4gcGFja2V0J3Mgc3RydWN0dXJlIHdoaWNoIGFsbG93cyB0byBkaXN0aW5ndWlz
aA0KYmV0d2VlbiAna21hbGxvYygpJyBhbmQgcmF3IHBhZ2VzIGJ1ZmZlcnMuDQoNClNpZ25lZC1v
ZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQog
aW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaCAgICAgICAgICAgIHwgMSArDQogbmV0L3Ztd192
c29jay92aXJ0aW9fdHJhbnNwb3J0LmMgICAgICAgIHwgOCArKysrKystLQ0KIG5ldC92bXdfdnNv
Y2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8IDkgKysrKysrKystDQogMyBmaWxlcyBjaGFu
Z2VkLCAxNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC92aXJ0aW9fdnNvY2suaCBiL2luY2x1ZGUvbGludXgvdmlydGlvX3Zzb2NrLmgN
CmluZGV4IDM1ZDdlZWRiNWU4ZS4uZDAyY2I3YWE5MjJmIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9s
aW51eC92aXJ0aW9fdnNvY2suaA0KKysrIGIvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0K
QEAgLTUwLDYgKzUwLDcgQEAgc3RydWN0IHZpcnRpb192c29ja19wa3Qgew0KIAl1MzIgb2ZmOw0K
IAlib29sIHJlcGx5Ow0KIAlib29sIHRhcF9kZWxpdmVyZWQ7DQorCWJvb2wgc2xhYl9idWY7DQog
fTsNCiANCiBzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdF9pbmZvIHsNCmRpZmYgLS1naXQgYS9uZXQv
dm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5z
cG9ydC5jDQppbmRleCBmYjMzMDJmZmY2MjcuLjQzYjdiMDliNGEwYSAxMDA2NDQNCi0tLSBhL25l
dC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQorKysgYi9uZXQvdm13X3Zzb2NrL3ZpcnRp
b190cmFuc3BvcnQuYw0KQEAgLTI1NCwxNiArMjU0LDIwIEBAIHN0YXRpYyB2b2lkIHZpcnRpb192
c29ja19yeF9maWxsKHN0cnVjdCB2aXJ0aW9fdnNvY2sgKnZzb2NrKQ0KIAl2cSA9IHZzb2NrLT52
cXNbVlNPQ0tfVlFfUlhdOw0KIA0KIAlkbyB7DQorCQlzdHJ1Y3QgcGFnZSAqYnVmX3BhZ2U7DQor
DQogCQlwa3QgPSBremFsbG9jKHNpemVvZigqcGt0KSwgR0ZQX0tFUk5FTCk7DQogCQlpZiAoIXBr
dCkNCiAJCQlicmVhazsNCiANCi0JCXBrdC0+YnVmID0ga21hbGxvYyhidWZfbGVuLCBHRlBfS0VS
TkVMKTsNCi0JCWlmICghcGt0LT5idWYpIHsNCisJCWJ1Zl9wYWdlID0gYWxsb2NfcGFnZShHRlBf
S0VSTkVMKTsNCisNCisJCWlmICghYnVmX3BhZ2UpIHsNCiAJCQl2aXJ0aW9fdHJhbnNwb3J0X2Zy
ZWVfcGt0KHBrdCk7DQogCQkJYnJlYWs7DQogCQl9DQogDQorCQlwa3QtPmJ1ZiA9IHBhZ2VfdG9f
dmlydChidWZfcGFnZSk7DQogCQlwa3QtPmJ1Zl9sZW4gPSBidWZfbGVuOw0KIAkJcGt0LT5sZW4g
PSBidWZfbGVuOw0KIA0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9y
dF9jb21tb24uYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KaW5k
ZXggZWMyYzJhZmJmMGQwLi4yNzg1NjdmNzQ4ZjIgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2Nr
L3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCisrKyBiL25ldC92bXdfdnNvY2svdmlydGlvX3Ry
YW5zcG9ydF9jb21tb24uYw0KQEAgLTY5LDYgKzY5LDcgQEAgdmlydGlvX3RyYW5zcG9ydF9hbGxv
Y19wa3Qoc3RydWN0IHZpcnRpb192c29ja19wa3RfaW5mbyAqaW5mbywNCiAJCWlmICghcGt0LT5i
dWYpDQogCQkJZ290byBvdXRfcGt0Ow0KIA0KKwkJcGt0LT5zbGFiX2J1ZiA9IHRydWU7DQogCQlw
a3QtPmJ1Zl9sZW4gPSBsZW47DQogDQogCQllcnIgPSBtZW1jcHlfZnJvbV9tc2cocGt0LT5idWYs
IGluZm8tPm1zZywgbGVuKTsNCkBAIC0xMzQyLDcgKzEzNDMsMTMgQEAgRVhQT1JUX1NZTUJPTF9H
UEwodmlydGlvX3RyYW5zcG9ydF9yZWN2X3BrdCk7DQogDQogdm9pZCB2aXJ0aW9fdHJhbnNwb3J0
X2ZyZWVfcGt0KHN0cnVjdCB2aXJ0aW9fdnNvY2tfcGt0ICpwa3QpDQogew0KLQlrZnJlZShwa3Qt
PmJ1Zik7DQorCWlmIChwa3QtPmJ1Zl9sZW4pIHsNCisJCWlmIChwa3QtPnNsYWJfYnVmKQ0KKwkJ
CWtmcmVlKHBrdC0+YnVmKTsNCisJCWVsc2UNCisJCQlmcmVlX3BhZ2VzKGJ1ZiwgZ2V0X29yZGVy
KHBrdC0+YnVmX2xlbikpOw0KKwl9DQorDQogCWtmcmVlKHBrdCk7DQogfQ0KIEVYUE9SVF9TWU1C
T0xfR1BMKHZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3QpOw0KLS0gDQoyLjI1LjENCg==
