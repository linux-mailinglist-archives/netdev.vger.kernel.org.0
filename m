Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828FB5994B6
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344979AbiHSFmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240299AbiHSFmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:42:06 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C434DCFC6;
        Thu, 18 Aug 2022 22:42:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id ACBC65FD07;
        Fri, 19 Aug 2022 08:42:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887722;
        bh=egIuAYw3jj8vWXZAF+IIfbzmFTudXDhkHlSaeT+dExQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=DmdsI+NOeUlo5mBvYG62MF/q/YMIvZ9sgdEjWm20iGcCu12A+QHC83AXeU9JN2sZk
         YkZvJFbbh2EOEVa1pOSC3dEXNxFsDtVqyBnzg9o8/waY6iKfIQZKo4CK7/kC+o4Y8S
         z/M9rH//VG5Q7N8wOwuY2nwbjMepbvdp/hRSPOzQtyX6sWkCFHbpbivfJNd+iC6m8W
         QBciN1OPT5JX6+51IDf4kBOHdH2UR08jdw62M+ywu48eTNOjAXCMgfl4xXv0MLxLjW
         M9toKlU66n0ENv0j3sFoGAXCQGiNSYghzCNQeLKaaD31V/tMbclowC/m2ura+VEqeE
         5A3rZInx2G2dQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:42:01 +0300 (MSK)
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
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: [PATCH net-next v4 8/9] vmci/vsock: check SO_RCVLOWAT before wake up
 reader
Thread-Topic: [PATCH net-next v4 8/9] vmci/vsock: check SO_RCVLOWAT before
 wake up reader
Thread-Index: AQHYs45Y9ikKdLgboEifUIJqsMZamw==
Date:   Fri, 19 Aug 2022 05:41:35 +0000
Message-ID: <af99d280-b525-5729-5eba-2fd67b9a9b67@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A640246ABEC5814AA7F3F8F0CE479B2A@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/19 00:26:00 #20118704
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIGV4dHJhIGNvbmRpdGlvbiB0byB3YWtlIHVwIGRhdGEgcmVhZGVyOiBkbyBpdCBv
bmx5IHdoZW4gbnVtYmVyDQpvZiByZWFkYWJsZSBieXRlcyA+PSBTT19SQ1ZMT1dBVC4gT3RoZXJ3
aXNlLCB0aGVyZSBpcyBubyBzZW5zZSB0byBraWNrDQp1c2VyLCBiZWNhdXNlIGl0IHdpbGwgd2Fp
dCB1bnRpbCBTT19SQ1ZMT1dBVCBieXRlcyB3aWxsIGJlIGRlcXVldWVkLiBUaGlzDQpjaGVjayBp
cyBwZXJmb3JtZWQgaW4gdnNvY2tfZGF0YV9yZWFkeSgpLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNl
bml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NClJldmlld2VkLWJ5OiBWaXNo
bnUgRGFzYSA8dmRhc2FAdm13YXJlLmNvbT4NCi0tLQ0KIG5ldC92bXdfdnNvY2svdm1jaV90cmFu
c3BvcnRfbm90aWZ5LmMgICAgICAgIHwgMiArLQ0KIG5ldC92bXdfdnNvY2svdm1jaV90cmFuc3Bv
cnRfbm90aWZ5X3FzdGF0ZS5jIHwgNCArKy0tDQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZtY2lf
dHJhbnNwb3J0X25vdGlmeS5jIGIvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnku
Yw0KaW5kZXggODUyMDk3ZTJiOWU2Li43YzNhN2RiMTM0YjIgMTAwNjQ0DQotLS0gYS9uZXQvdm13
X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeS5jDQorKysgYi9uZXQvdm13X3Zzb2NrL3ZtY2lf
dHJhbnNwb3J0X25vdGlmeS5jDQpAQCAtMzA3LDcgKzMwNyw3IEBAIHZtY2lfdHJhbnNwb3J0X2hh
bmRsZV93cm90ZShzdHJ1Y3Qgc29jayAqc2ssDQogCXN0cnVjdCB2c29ja19zb2NrICp2c2sgPSB2
c29ja19zayhzayk7DQogCVBLVF9GSUVMRCh2c2ssIHNlbnRfd2FpdGluZ19yZWFkKSA9IGZhbHNl
Ow0KICNlbmRpZg0KLQlzay0+c2tfZGF0YV9yZWFkeShzayk7DQorCXZzb2NrX2RhdGFfcmVhZHko
c2spOw0KIH0NCiANCiBzdGF0aWMgdm9pZCB2bWNpX3RyYW5zcG9ydF9ub3RpZnlfcGt0X3NvY2tl
dF9pbml0KHN0cnVjdCBzb2NrICpzaykNCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZtY2lf
dHJhbnNwb3J0X25vdGlmeV9xc3RhdGUuYyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRf
bm90aWZ5X3FzdGF0ZS5jDQppbmRleCAxMmYwY2I4ZmU5OTguLmU5NmE4OGQ4NTBhOCAxMDA2NDQN
Ci0tLSBhL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jDQorKysg
Yi9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeV9xc3RhdGUuYw0KQEAgLTg0LDcg
Kzg0LDcgQEAgdm1jaV90cmFuc3BvcnRfaGFuZGxlX3dyb3RlKHN0cnVjdCBzb2NrICpzaywNCiAJ
CQkgICAgYm9vbCBib3R0b21faGFsZiwNCiAJCQkgICAgc3RydWN0IHNvY2thZGRyX3ZtICpkc3Qs
IHN0cnVjdCBzb2NrYWRkcl92bSAqc3JjKQ0KIHsNCi0Jc2stPnNrX2RhdGFfcmVhZHkoc2spOw0K
Kwl2c29ja19kYXRhX3JlYWR5KHNrKTsNCiB9DQogDQogc3RhdGljIHZvaWQgdnNvY2tfYmxvY2tf
dXBkYXRlX3dyaXRlX3dpbmRvdyhzdHJ1Y3Qgc29jayAqc2spDQpAQCAtMjgyLDcgKzI4Miw3IEBA
IHZtY2lfdHJhbnNwb3J0X25vdGlmeV9wa3RfcmVjdl9wb3N0X2RlcXVldWUoDQogCQkvKiBTZWUg
dGhlIGNvbW1lbnQgaW4NCiAJCSAqIHZtY2lfdHJhbnNwb3J0X25vdGlmeV9wa3Rfc2VuZF9wb3N0
X2VucXVldWUoKS4NCiAJCSAqLw0KLQkJc2stPnNrX2RhdGFfcmVhZHkoc2spOw0KKwkJdnNvY2tf
ZGF0YV9yZWFkeShzayk7DQogCX0NCiANCiAJcmV0dXJuIGVycjsNCi0tIA0KMi4yNS4xDQo=
