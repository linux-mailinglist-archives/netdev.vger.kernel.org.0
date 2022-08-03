Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375ED588E3A
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiHCOGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbiHCOGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:06:12 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0DB1B790;
        Wed,  3 Aug 2022 07:06:08 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 936A85FD2E;
        Wed,  3 Aug 2022 17:06:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659535566;
        bh=wpo5GG48uOb0QHU/IVYOrfHKygO1N8dbLInG7RU2KME=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=sR/N9NRjM2iMLwo/DNzqSwWRFSB3536YjyrLmV5Pcvcjdgc6OF5IOg7DR/S82Ct/z
         SFr+uR0KKa12x66xvvBE5WmUzPhc8EzrvZ/lJBldG6KVAV9TWJVXUDVdDOBJ5Ugg4x
         8JP8Xfh3E1uvPO8cpOzYa1gtpBhJAky6GjHqZuWfdtcKYQ0iYMQzKR1+b+uNQ/LUaO
         Mcv2QX1M0qCeUmlN8iXKjcYsJTZuQRHWlM+vvbabb5FP+PXPopnPNjim4hMmu0Fq4q
         nB/9QcR5hOhp+RF4i5Fp5kdbuzn7lXScCLkZI1+Iu8M54535CWqJEDvCMZEUTnWiJd
         fgTlbv1gSumEw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 17:06:05 +0300 (MSK)
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
Subject: [RFC PATCH v3 8/9] vmci/vsock: check SO_RCVLOWAT before wake up
 reader
Thread-Topic: [RFC PATCH v3 8/9] vmci/vsock: check SO_RCVLOWAT before wake up
 reader
Thread-Index: AQHYp0Iky9TC5FSTTUiSWqj6+AelWw==
Date:   Wed, 3 Aug 2022 14:05:52 +0000
Message-ID: <5b7e133e-f8e1-1f71-9a3c-ac0265cffb63@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D61839FB6E20C943BBB27E411A293E3B@sberdevices.ru>
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

VGhpcyBhZGRzIGV4dHJhIGNvbmRpdGlvbiB0byB3YWtlIHVwIGRhdGEgcmVhZGVyOiBkbyBpdCBv
bmx5IHdoZW4gbnVtYmVyDQpvZiByZWFkYWJsZSBieXRlcyA+PSBTT19SQ1ZMT1dBVC4gT3RoZXJ3
aXNlLCB0aGVyZSBpcyBubyBzZW5zZSB0byBraWNrDQp1c2VyLGJlY2F1c2UgaXQgd2lsbCB3YWl0
IHVudGlsIFNPX1JDVkxPV0FUIGJ5dGVzIHdpbGwgYmUgZGVxdWV1ZWQuDQoNClNpZ25lZC1vZmYt
Ynk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogbmV0
L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYyAgICAgICAgfCAyICstDQogbmV0L3Zt
d192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMgfCA0ICsrLS0NCiAyIGZpbGVz
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMgYi9uZXQvdm13X3Zzb2NrL3Zt
Y2lfdHJhbnNwb3J0X25vdGlmeS5jDQppbmRleCA4NTIwOTdlMmI5ZTYuLjdjM2E3ZGIxMzRiMiAx
MDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMNCisrKyBi
L25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMNCkBAIC0zMDcsNyArMzA3LDcg
QEAgdm1jaV90cmFuc3BvcnRfaGFuZGxlX3dyb3RlKHN0cnVjdCBzb2NrICpzaywNCiAJc3RydWN0
IHZzb2NrX3NvY2sgKnZzayA9IHZzb2NrX3NrKHNrKTsNCiAJUEtUX0ZJRUxEKHZzaywgc2VudF93
YWl0aW5nX3JlYWQpID0gZmFsc2U7DQogI2VuZGlmDQotCXNrLT5za19kYXRhX3JlYWR5KHNrKTsN
CisJdnNvY2tfZGF0YV9yZWFkeShzayk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIHZtY2lfdHJhbnNw
b3J0X25vdGlmeV9wa3Rfc29ja2V0X2luaXQoc3RydWN0IHNvY2sgKnNrKQ0KZGlmZiAtLWdpdCBh
L25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jIGIvbmV0L3Ztd192
c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMNCmluZGV4IDEyZjBjYjhmZTk5OC4u
ZTk2YTg4ZDg1MGE4IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9u
b3RpZnlfcXN0YXRlLmMNCisrKyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5
X3FzdGF0ZS5jDQpAQCAtODQsNyArODQsNyBAQCB2bWNpX3RyYW5zcG9ydF9oYW5kbGVfd3JvdGUo
c3RydWN0IHNvY2sgKnNrLA0KIAkJCSAgICBib29sIGJvdHRvbV9oYWxmLA0KIAkJCSAgICBzdHJ1
Y3Qgc29ja2FkZHJfdm0gKmRzdCwgc3RydWN0IHNvY2thZGRyX3ZtICpzcmMpDQogew0KLQlzay0+
c2tfZGF0YV9yZWFkeShzayk7DQorCXZzb2NrX2RhdGFfcmVhZHkoc2spOw0KIH0NCiANCiBzdGF0
aWMgdm9pZCB2c29ja19ibG9ja191cGRhdGVfd3JpdGVfd2luZG93KHN0cnVjdCBzb2NrICpzaykN
CkBAIC0yODIsNyArMjgyLDcgQEAgdm1jaV90cmFuc3BvcnRfbm90aWZ5X3BrdF9yZWN2X3Bvc3Rf
ZGVxdWV1ZSgNCiAJCS8qIFNlZSB0aGUgY29tbWVudCBpbg0KIAkJICogdm1jaV90cmFuc3BvcnRf
bm90aWZ5X3BrdF9zZW5kX3Bvc3RfZW5xdWV1ZSgpLg0KIAkJICovDQotCQlzay0+c2tfZGF0YV9y
ZWFkeShzayk7DQorCQl2c29ja19kYXRhX3JlYWR5KHNrKTsNCiAJfQ0KIA0KIAlyZXR1cm4gZXJy
Ow0KLS0gDQoyLjI1LjENCg==
