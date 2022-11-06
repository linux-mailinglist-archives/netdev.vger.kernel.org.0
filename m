Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0E61E58F
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiKFTgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiKFTgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:36:37 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0998BE084;
        Sun,  6 Nov 2022 11:36:35 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 5438B5FD04;
        Sun,  6 Nov 2022 22:36:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667763393;
        bh=yQ6suEWJBzxoUrocwoSmUoXHvbi6PvhSnqawY+nZJZ8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=YV1yrrDKglvFQLa34c6eqjzoqkTQQDdNQdyDxpaC6X/S6vOK5GLypskjvi+zp++Dm
         AhAfoS6eplCCgnaql70kq2zZIgZ4x20bZ15dsHACujm9LlO/N2UjuvrVMWWaIVbmy6
         /q8GXlCZXIo9wDlCZKG/+dDz7dr2VwRtVrDXVsEl97SFZ3HreObFKRGRnZOBbn+P8v
         K9cSd98Nbz19+MBQq04/Y386P6CS1NzpglnFgdgaJwbgJFSzYpStKvR15+PLcozJUf
         E+6Mi/7mMASbAzeDOfaC75mlFgGA73t1xEFi0/+4kOB7mrjmx0Rl7/LceX84b6e8qq
         wlREl7z+nWDVw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  6 Nov 2022 22:36:33 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 01/11] virtio/vsock: rework packet allocation logic
Thread-Topic: [RFC PATCH v3 01/11] virtio/vsock: rework packet allocation
 logic
Thread-Index: AQHY8hcBEbxDmf4aG021vuOLUMusCQ==
Date:   Sun, 6 Nov 2022 19:36:02 +0000
Message-ID: <f896b8fd-50d2-2512-3966-3775245e9b96@sberdevices.ru>
In-Reply-To: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9B2370EC071AE4DB1F3A0C4C342CA7C@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 12:52:00 #20573807
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VG8gc3VwcG9ydCB6ZXJvY29weSByZWNlaXZlLCBwYWNrZXQncyBidWZmZXIgYWxsb2NhdGlvbiBp
cyBjaGFuZ2VkOiBmb3INCmJ1ZmZlcnMgd2hpY2ggY291bGQgYmUgbWFwcGVkIHRvIHVzZXIncyB2
bWEgd2UgY2FuJ3QgdXNlICdrbWFsbG9jKCknKGFzDQprZXJuZWwgcmVzdHJpY3RzIHRvIG1hcCBz
bGFiIHBhZ2VzIHRvIHVzZXIncyB2bWEpIGFuZCByYXcgYnVkZHkNCmFsbG9jYXRvciBub3cgY2Fs
bGVkLiBCdXQsIGZvciB0eCBwYWNrZXRzKHN1Y2ggcGFja2V0cyB3b24ndCBiZSBtYXBwZWQNCnRv
IHVzZXIpLCBwcmV2aW91cyAna21hbGxvYygpJyB3YXkgaXMgdXNlZCwgYnV0IHdpdGggc3BlY2lh
bCBmbGFnIGluDQpwYWNrZXQncyBzdHJ1Y3R1cmUgd2hpY2ggYWxsb3dzIHRvIGRpc3Rpbmd1aXNo
IGJldHdlZW4gJ2ttYWxsb2MoKScgYW5kDQpyYXcgcGFnZXMgYnVmZmVycy4NCg0KU2lnbmVkLW9m
Zi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQotLS0NCiBk
cml2ZXJzL3Zob3N0L3Zzb2NrLmMgICAgICAgICAgICAgICAgICAgfCAgMSArDQogaW5jbHVkZS9s
aW51eC92aXJ0aW9fdnNvY2suaCAgICAgICAgICAgIHwgIDEgKw0KIG5ldC92bXdfdnNvY2svdmly
dGlvX3RyYW5zcG9ydC5jICAgICAgICB8ICA4ICsrKysrKy0tDQogbmV0L3Ztd192c29jay92aXJ0
aW9fdHJhbnNwb3J0X2NvbW1vbi5jIHwgMTAgKysrKysrKysrLQ0KIDQgZmlsZXMgY2hhbmdlZCwg
MTcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmhvc3QvdnNvY2suYyBiL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KaW5kZXggNTcwMzc3NWFmMTI5
Li42NTQ3NWQxMjhhMWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCisrKyBi
L2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KQEAgLTM5OSw2ICszOTksNyBAQCB2aG9zdF92c29ja19h
bGxvY19wa3Qoc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEsDQogCQlyZXR1cm4gTlVMTDsNCiAJ
fQ0KIA0KKwlwa3QtPnNsYWJfYnVmID0gdHJ1ZTsNCiAJcGt0LT5idWZfbGVuID0gcGt0LT5sZW47
DQogDQogCW5ieXRlcyA9IGNvcHlfZnJvbV9pdGVyKHBrdC0+YnVmLCBwa3QtPmxlbiwgJmlvdl9p
dGVyKTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oIGIvaW5jbHVk
ZS9saW51eC92aXJ0aW9fdnNvY2suaA0KaW5kZXggMzVkN2VlZGI1ZThlLi5kMDJjYjdhYTkyMmYg
MTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oDQorKysgYi9pbmNsdWRl
L2xpbnV4L3ZpcnRpb192c29jay5oDQpAQCAtNTAsNiArNTAsNyBAQCBzdHJ1Y3QgdmlydGlvX3Zz
b2NrX3BrdCB7DQogCXUzMiBvZmY7DQogCWJvb2wgcmVwbHk7DQogCWJvb2wgdGFwX2RlbGl2ZXJl
ZDsNCisJYm9vbCBzbGFiX2J1ZjsNCiB9Ow0KIA0KIHN0cnVjdCB2aXJ0aW9fdnNvY2tfcGt0X2lu
Zm8gew0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIGIvbmV0
L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCmluZGV4IGFkNjRmNDAzNTM2YS4uMTk5MDlj
MWU5YmEzIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCisr
KyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQpAQCAtMjU1LDE2ICsyNTUsMjAg
QEAgc3RhdGljIHZvaWQgdmlydGlvX3Zzb2NrX3J4X2ZpbGwoc3RydWN0IHZpcnRpb192c29jayAq
dnNvY2spDQogCXZxID0gdnNvY2stPnZxc1tWU09DS19WUV9SWF07DQogDQogCWRvIHsNCisJCXN0
cnVjdCBwYWdlICpidWZfcGFnZTsNCisNCiAJCXBrdCA9IGt6YWxsb2Moc2l6ZW9mKCpwa3QpLCBH
RlBfS0VSTkVMKTsNCiAJCWlmICghcGt0KQ0KIAkJCWJyZWFrOw0KIA0KLQkJcGt0LT5idWYgPSBr
bWFsbG9jKGJ1Zl9sZW4sIEdGUF9LRVJORUwpOw0KLQkJaWYgKCFwa3QtPmJ1Zikgew0KKwkJYnVm
X3BhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOw0KKw0KKwkJaWYgKCFidWZfcGFnZSkgew0K
IAkJCXZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3QocGt0KTsNCiAJCQlicmVhazsNCiAJCX0NCiAN
CisJCXBrdC0+YnVmID0gcGFnZV90b192aXJ0KGJ1Zl9wYWdlKTsNCiAJCXBrdC0+YnVmX2xlbiA9
IGJ1Zl9sZW47DQogCQlwa3QtPmxlbiA9IGJ1Zl9sZW47DQogDQpkaWZmIC0tZ2l0IGEvbmV0L3Zt
d192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIGIvbmV0L3Ztd192c29jay92aXJ0aW9f
dHJhbnNwb3J0X2NvbW1vbi5jDQppbmRleCBhOTk4MGU5YjkzMDQuLjM3ZThkYmZlMmY1ZCAxMDA2
NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KKysrIGIv
bmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQpAQCAtNjksNiArNjksNyBA
QCB2aXJ0aW9fdHJhbnNwb3J0X2FsbG9jX3BrdChzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdF9pbmZv
ICppbmZvLA0KIAkJaWYgKCFwa3QtPmJ1ZikNCiAJCQlnb3RvIG91dF9wa3Q7DQogDQorCQlwa3Qt
PnNsYWJfYnVmID0gdHJ1ZTsNCiAJCXBrdC0+YnVmX2xlbiA9IGxlbjsNCiANCiAJCWVyciA9IG1l
bWNweV9mcm9tX21zZyhwa3QtPmJ1ZiwgaW5mby0+bXNnLCBsZW4pOw0KQEAgLTEzMzksNyArMTM0
MCwxNCBAQCBFWFBPUlRfU1lNQk9MX0dQTCh2aXJ0aW9fdHJhbnNwb3J0X3JlY3ZfcGt0KTsNCiAN
CiB2b2lkIHZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3Qoc3RydWN0IHZpcnRpb192c29ja19wa3Qg
KnBrdCkNCiB7DQotCWt2ZnJlZShwa3QtPmJ1Zik7DQorCWlmIChwa3QtPmJ1Zl9sZW4pIHsNCisJ
CWlmIChwa3QtPnNsYWJfYnVmKQ0KKwkJCWt2ZnJlZShwa3QtPmJ1Zik7DQorCQllbHNlDQorCQkJ
ZnJlZV9wYWdlcygodW5zaWduZWQgbG9uZylwa3QtPmJ1ZiwNCisJCQkJICAgZ2V0X29yZGVyKHBr
dC0+YnVmX2xlbikpOw0KKwl9DQorDQogCWtmcmVlKHBrdCk7DQogfQ0KIEVYUE9SVF9TWU1CT0xf
R1BMKHZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3QpOw0KLS0gDQoyLjM1LjANCg==
