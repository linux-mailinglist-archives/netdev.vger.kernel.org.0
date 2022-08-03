Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2569D588DFA
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiHCNzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiHCNym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:54:42 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37DE1BE89;
        Wed,  3 Aug 2022 06:53:38 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 01A875FD2E;
        Wed,  3 Aug 2022 16:53:37 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659534817;
        bh=nnYK5AF7IXASVKt2x9D81EypjgxYuAncKx57rnzfkjs=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=DDe8UalE1UXpmPiUrNKvyr3q8U+qtNqvqs+HkU5lnSzpA7lc0PYd5H5CwJK3ctC+6
         NoinId9Bqz9BZ+zxJQdxtjlpC/ZUS16VFbTEt/fXg+JaIbkJqeJi1ydifvqO6XKyt5
         s1irYSREyhy8roLIJwX2gGJuscoKVmb5rjW7Q2FstrDA5ysAEaZbPnsRcKL3Te+kcd
         yopACSBSqE8gvCN1vm+BmM5Y/WPbClgje5UnF65MLECyLmdOUzPXLDdMkLb5Xqw9p1
         1WX0glQGYGhcQqr141PhcynxN/XT/vchXk1a0mBq6t3iZuoDgYUVFrntsB87qB2dMN
         Cc2dqVOPIZmTw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 16:53:36 +0300 (MSK)
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
Subject: [RFC PATCH v3 2/9] hv_sock: disable SO_RCVLOWAT support
Thread-Topic: [RFC PATCH v3 2/9] hv_sock: disable SO_RCVLOWAT support
Thread-Index: AQHYp0Bljfm95oVfx0uveIUuJk0cZQ==
Date:   Wed, 3 Aug 2022 13:53:23 +0000
Message-ID: <58f53bef-62f4-fd63-472c-dcd158439b09@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <54AD54030CEE524CB16E568E60E1402B@sberdevices.ru>
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

Rm9yIEh5cGVyLVYgaXQgaXMgcXVpZXQgZGlmZmljdWx0IHRvIHN1cHBvcnQgdGhpcyBzb2NrZXQg
b3B0aW9uLGR1ZSB0bw0KdHJhbnNwb3J0IGludGVybmFscywgc28gZGlzYWJsZSBpdC4NCg0KU2ln
bmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQpS
ZXZpZXdlZC1ieTogRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4NCi0tLQ0KIG5ldC92
bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jIHwgNyArKysrKysrDQogMSBmaWxlIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9oeXBlcnZfdHJh
bnNwb3J0LmMgYi9uZXQvdm13X3Zzb2NrL2h5cGVydl90cmFuc3BvcnQuYw0KaW5kZXggZTExMWUx
M2I2NjYwLi41ZmFiOGYzNTZhODYgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL2h5cGVydl90
cmFuc3BvcnQuYw0KKysrIGIvbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMNCkBAIC04
MDIsNiArODAyLDEyIEBAIGludCBodnNfbm90aWZ5X3NlbmRfcG9zdF9lbnF1ZXVlKHN0cnVjdCB2
c29ja19zb2NrICp2c2ssIHNzaXplX3Qgd3JpdHRlbiwNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0
YXRpYw0KK2ludCBodnNfc2V0X3Jjdmxvd2F0KHN0cnVjdCB2c29ja19zb2NrICp2c2ssIGludCB2
YWwpDQorew0KKwlyZXR1cm4gLUVPUE5PVFNVUFA7DQorfQ0KKw0KIHN0YXRpYyBzdHJ1Y3QgdnNv
Y2tfdHJhbnNwb3J0IGh2c190cmFuc3BvcnQgPSB7DQogCS5tb2R1bGUgICAgICAgICAgICAgICAg
ICAgPSBUSElTX01PRFVMRSwNCiANCkBAIC04MzcsNiArODQzLDcgQEAgc3RhdGljIHN0cnVjdCB2
c29ja190cmFuc3BvcnQgaHZzX3RyYW5zcG9ydCA9IHsNCiAJLm5vdGlmeV9zZW5kX3ByZV9lbnF1
ZXVlICA9IGh2c19ub3RpZnlfc2VuZF9wcmVfZW5xdWV1ZSwNCiAJLm5vdGlmeV9zZW5kX3Bvc3Rf
ZW5xdWV1ZSA9IGh2c19ub3RpZnlfc2VuZF9wb3N0X2VucXVldWUsDQogDQorCS5zZXRfcmN2bG93
YXQgICAgICAgICAgICAgPSBodnNfc2V0X3Jjdmxvd2F0DQogfTsNCiANCiBzdGF0aWMgYm9vbCBo
dnNfY2hlY2tfdHJhbnNwb3J0KHN0cnVjdCB2c29ja19zb2NrICp2c2spDQotLSANCjIuMjUuMQ0K
