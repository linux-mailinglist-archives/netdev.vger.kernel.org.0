Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD955588E13
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbiHCN6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbiHCN6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:58:13 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D106DF46;
        Wed,  3 Aug 2022 06:58:10 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 677FC5FD2E;
        Wed,  3 Aug 2022 16:58:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659535088;
        bh=J9ER1HEmraVRx9h4m7Z/Hk7Bb9oPnBAWW3L1QrdyfYY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=kn/GaERL4M8G6sFAX1LPUGgkXbjOoyQU8UQX5Ai8IreW1Sv3Am839Z1n39MG0xaG5
         Wd4/t6EICVjXSsadyhFlvpdRfh7gkepaUVSGgbRxOkapjcfb8HrbCEveaW4LQKIXax
         IrZpbzJC7MIC1h1UfmM0n3BjH8ZaT63g+Z+WZaxbn0ECVrmqaw1KTDnzd9AsG21+R1
         5QJZq9EYtt0cBrQQD6KwfIG3Fk+fRXGKMBsNpI0tuLg45Txb4UJd5VLUeIVM8VP8L/
         psxM3bIE1D2Yn5qLg3SM4xs3Sjvk+03ajg9lH4NaG0blyTP12E0SFtUC0jhcVmnsRI
         an/c2LSRKkTeA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 16:58:07 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 4/9] vmci/vsock: use 'target' in notify_poll_in
 callback
Thread-Topic: [RFC PATCH v3 4/9] vmci/vsock: use 'target' in notify_poll_in
 callback
Thread-Index: AQHYp0EHffgjd/zij0eqhutm7RAwxw==
Date:   Wed, 3 Aug 2022 13:57:54 +0000
Message-ID: <2e420c8e-9550-c8c5-588f-e13b79a057ff@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBC437AB8ABBA54AB5A398157F78EA17@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/03 07:41:00 #20041172
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBjYWxsYmFjayBjb250cm9scyBzZXR0aW5nIG9mIFBPTExJTixQT0xMUkROT1JNIG91dHB1
dCBiaXRzIG9mIHBvbGwoKQ0Kc3lzY2FsbCxidXQgaW4gc29tZSBjYXNlcyxpdCBpcyBpbmNvcnJl
Y3RseSB0byBzZXQgaXQsIHdoZW4gc29ja2V0IGhhcw0KYXQgbGVhc3QgMSBieXRlcyBvZiBhdmFp
bGFibGUgZGF0YS4gVXNlICd0YXJnZXQnIHdoaWNoIGlzIGFscmVhZHkgZXhpc3RzDQphbmQgZXF1
YWwgdG8gc2tfcmN2bG93YXQgaW4gdGhpcyBjYXNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5
IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIG5ldC92bXdfdnNvY2sv
dm1jaV90cmFuc3BvcnRfbm90aWZ5LmMgICAgICAgIHwgOCArKysrLS0tLQ0KIG5ldC92bXdfdnNv
Y2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jIHwgOCArKysrLS0tLQ0KIDIgZmlsZXMg
Y2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
bmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYyBiL25ldC92bXdfdnNvY2svdm1j
aV90cmFuc3BvcnRfbm90aWZ5LmMNCmluZGV4IGQ2OWZjNGI1OTVhZC4uODUyMDk3ZTJiOWU2IDEw
MDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYw0KKysrIGIv
bmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYw0KQEAgLTM0MCwxMiArMzQwLDEy
IEBAIHZtY2lfdHJhbnNwb3J0X25vdGlmeV9wa3RfcG9sbF9pbihzdHJ1Y3Qgc29jayAqc2ssDQog
ew0KIAlzdHJ1Y3QgdnNvY2tfc29jayAqdnNrID0gdnNvY2tfc2soc2spOw0KIA0KLQlpZiAodnNv
Y2tfc3RyZWFtX2hhc19kYXRhKHZzaykpIHsNCisJaWYgKHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2
c2spID49IHRhcmdldCkgew0KIAkJKmRhdGFfcmVhZHlfbm93ID0gdHJ1ZTsNCiAJfSBlbHNlIHsN
Ci0JCS8qIFdlIGNhbid0IHJlYWQgcmlnaHQgbm93IGJlY2F1c2UgdGhlcmUgaXMgbm90aGluZyBp
biB0aGUNCi0JCSAqIHF1ZXVlLiBBc2sgZm9yIG5vdGlmaWNhdGlvbnMgd2hlbiB0aGVyZSBpcyBz
b21ldGhpbmcgdG8NCi0JCSAqIHJlYWQuDQorCQkvKiBXZSBjYW4ndCByZWFkIHJpZ2h0IG5vdyBi
ZWNhdXNlIHRoZXJlIGlzIG5vdCBlbm91Z2ggZGF0YQ0KKwkJICogaW4gdGhlIHF1ZXVlLiBBc2sg
Zm9yIG5vdGlmaWNhdGlvbnMgd2hlbiB0aGVyZSBpcyBzb21ldGhpbmcNCisJCSAqIHRvIHJlYWQu
DQogCQkgKi8NCiAJCWlmIChzay0+c2tfc3RhdGUgPT0gVENQX0VTVEFCTElTSEVEKSB7DQogCQkJ
aWYgKCFzZW5kX3dhaXRpbmdfcmVhZChzaywgMSkpDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29j
ay92bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMgYi9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJh
bnNwb3J0X25vdGlmeV9xc3RhdGUuYw0KaW5kZXggMGYzNmQ3YzQ1ZGIzLi4xMmYwY2I4ZmU5OTgg
MTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeV9xc3RhdGUu
Yw0KKysrIGIvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMNCkBA
IC0xNjEsMTIgKzE2MSwxMiBAQCB2bWNpX3RyYW5zcG9ydF9ub3RpZnlfcGt0X3BvbGxfaW4oc3Ry
dWN0IHNvY2sgKnNrLA0KIHsNCiAJc3RydWN0IHZzb2NrX3NvY2sgKnZzayA9IHZzb2NrX3NrKHNr
KTsNCiANCi0JaWYgKHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2c2spKSB7DQorCWlmICh2c29ja19z
dHJlYW1faGFzX2RhdGEodnNrKSA+PSB0YXJnZXQpIHsNCiAJCSpkYXRhX3JlYWR5X25vdyA9IHRy
dWU7DQogCX0gZWxzZSB7DQotCQkvKiBXZSBjYW4ndCByZWFkIHJpZ2h0IG5vdyBiZWNhdXNlIHRo
ZXJlIGlzIG5vdGhpbmcgaW4gdGhlDQotCQkgKiBxdWV1ZS4gQXNrIGZvciBub3RpZmljYXRpb25z
IHdoZW4gdGhlcmUgaXMgc29tZXRoaW5nIHRvDQotCQkgKiByZWFkLg0KKwkJLyogV2UgY2FuJ3Qg
cmVhZCByaWdodCBub3cgYmVjYXVzZSB0aGVyZSBpcyBub3QgZW5vdWdoIGRhdGENCisJCSAqIGlu
IHRoZSBxdWV1ZS4gQXNrIGZvciBub3RpZmljYXRpb25zIHdoZW4gdGhlcmUgaXMgc29tZXRoaW5n
DQorCQkgKiB0byByZWFkLg0KIAkJICovDQogCQlpZiAoc2stPnNrX3N0YXRlID09IFRDUF9FU1RB
QkxJU0hFRCkNCiAJCQl2c29ja19ibG9ja191cGRhdGVfd3JpdGVfd2luZG93KHNrKTsNCi0tIA0K
Mi4yNS4xDQo=
