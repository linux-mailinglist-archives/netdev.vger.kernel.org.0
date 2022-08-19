Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226F5599476
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbiHSF2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243197AbiHSF2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:28:05 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300AAE01FC;
        Thu, 18 Aug 2022 22:28:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 856AF5FD07;
        Fri, 19 Aug 2022 08:28:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660886882;
        bh=xZcFr0g066QLn34YVo/DnULMO+Ugg56rtAsgSG8AMHo=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=DB+pr+ENO0x1YGOBXcl32mEz9ySWuycsdn6ARa3p/0E/aMxJh8ffXDZpeNOy8Y2YB
         ebMeLKGYxUcPKVDsz9P+34TY4E2cYpvKTZIDgoSPTH1LKq1Y/RSKVbYM5qdiTBhjWD
         3bmJViJCa6JbzwQbdgj7sMil02xG3vb7m8V7xYGQoxBm4M8fWcdWsZ+6ayYFsNgTAK
         ugVLrepfBhjzeGfOYzVo8lNzAJyAeq6fRUvmGtTaRtiZCVPSJ8fmlwAzASa+KijlJW
         NADTgi8/c1+0QOpxM934CqLfebC7dZ7jhny1A4PLZzTaOct6t75PDHujWcYhDlOh/U
         fV6/v7yNw/m3A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:28:00 +0300 (MSK)
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
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: [PATCH net-next v4 2/9] hv_sock: disable SO_RCVLOWAT support
Thread-Topic: [PATCH net-next v4 2/9] hv_sock: disable SO_RCVLOWAT support
Thread-Index: AQHYs4xj57UzSxktpUO3tU97mRUOyg==
Date:   Fri, 19 Aug 2022 05:27:34 +0000
Message-ID: <1772ff39-a197-3f11-73b9-7deeb015e1ee@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CA4519B157AC347835CA4E08DEE6B12@sberdevices.ru>
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

Rm9yIEh5cGVyLVYgaXQgaXMgcXVpZXQgZGlmZmljdWx0IHRvIHN1cHBvcnQgdGhpcyBzb2NrZXQg
b3B0aW9uLGR1ZSB0bw0KdHJhbnNwb3J0IGludGVybmFscywgc28gZGlzYWJsZSBpdC4NCg0KU2ln
bmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQpS
ZXZpZXdlZC1ieTogRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4NClJldmlld2VkLWJ5
OiBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5jb20+DQotLS0NCiBuZXQvdm13
X3Zzb2NrL2h5cGVydl90cmFuc3BvcnQuYyB8IDcgKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA3
IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5z
cG9ydC5jIGIvbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMNCmluZGV4IGZkOTgyMjll
M2RiMy4uNTljM2UyNjk3MDY5IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9oeXBlcnZfdHJh
bnNwb3J0LmMNCisrKyBiL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jDQpAQCAtODE1
LDYgKzgxNSwxMiBAQCBpbnQgaHZzX25vdGlmeV9zZW5kX3Bvc3RfZW5xdWV1ZShzdHJ1Y3QgdnNv
Y2tfc29jayAqdnNrLCBzc2l6ZV90IHdyaXR0ZW4sDQogCXJldHVybiAwOw0KIH0NCiANCitzdGF0
aWMNCitpbnQgaHZzX3NldF9yY3Zsb3dhdChzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLCBpbnQgdmFs
KQ0KK3sNCisJcmV0dXJuIC1FT1BOT1RTVVBQOw0KK30NCisNCiBzdGF0aWMgc3RydWN0IHZzb2Nr
X3RyYW5zcG9ydCBodnNfdHJhbnNwb3J0ID0gew0KIAkubW9kdWxlICAgICAgICAgICAgICAgICAg
ID0gVEhJU19NT0RVTEUsDQogDQpAQCAtODUwLDYgKzg1Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgdnNv
Y2tfdHJhbnNwb3J0IGh2c190cmFuc3BvcnQgPSB7DQogCS5ub3RpZnlfc2VuZF9wcmVfZW5xdWV1
ZSAgPSBodnNfbm90aWZ5X3NlbmRfcHJlX2VucXVldWUsDQogCS5ub3RpZnlfc2VuZF9wb3N0X2Vu
cXVldWUgPSBodnNfbm90aWZ5X3NlbmRfcG9zdF9lbnF1ZXVlLA0KIA0KKwkuc2V0X3Jjdmxvd2F0
ICAgICAgICAgICAgID0gaHZzX3NldF9yY3Zsb3dhdA0KIH07DQogDQogc3RhdGljIGJvb2wgaHZz
X2NoZWNrX3RyYW5zcG9ydChzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKQ0KLS0gDQoyLjI1LjENCg==
