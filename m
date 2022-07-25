Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD54A57FA8D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiGYHyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiGYHyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:54:43 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0EC12ADE;
        Mon, 25 Jul 2022 00:54:37 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 85C7D5FD0C;
        Mon, 25 Jul 2022 10:54:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658735673;
        bh=Jlqwz8Mf0SX+vFvr8bsEZwYRgZFGP2xbuZquqH8x8g4=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=BEI7uEFQVoAxVHxTvWWYevPIQjqaIvHrKIRspdaYFgpKxFafEMFZXVcgtZR/WAKFC
         7YIxpUYoG8mMaEn77lC1W8S3C/EpcivFR3h+uO1yGDkrWTEzfVERFj4mUu2UoKZMT7
         d9jgfNqCo9E94slr2h1KcV4HVZnPmbrhjiVpxbgb9dqAJhukv/4cOU/rJu84kWrLEn
         ckrMz7C+fMhSzA9NOs147nWzeHX6nfgvvQjMfZ6okAFH0i9mbKgxqYcb3ysexkYYwJ
         JHFlJRm2D7Yuqc6LHc3cxMQ4pLpKtPIIYwp4JzysxaP3etbozUD9DDkkeseQRyc3FH
         SAiup18Qa9Vng==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 10:54:24 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYn/u277di/gNdd06E3+5muuhZow==
Date:   Mon, 25 Jul 2022 07:54:05 +0000
Message-ID: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D097A725E2DA8643AE756956EE8C3728@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/25 03:52:00 #19956163
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNClRoaXMgcGF0Y2hzZXQgaW5jbHVkZXMgc29tZSB1cGRhdGVzIGZvciBTT19SQ1ZM
T1dBVDoNCg0KMSkgYWZfdnNvY2s6DQogICBEdXJpbmcgbXkgZXhwZXJpbWVudHMgd2l0aCB6ZXJv
Y29weSByZWNlaXZlLCBpIGZvdW5kLCB0aGF0IGluIHNvbWUNCiAgIGNhc2VzLCBwb2xsKCkgaW1w
bGVtZW50YXRpb24gdmlvbGF0ZXMgUE9TSVg6IHdoZW4gc29ja2V0IGhhcyBub24tDQogICBkZWZh
dWx0IFNPX1JDVkxPV0FUKGUuZy4gbm90IDEpLCBwb2xsKCkgd2lsbCBhbHdheXMgc2V0IFBPTExJ
TiBhbmQNCiAgIFBPTExSRE5PUk0gYml0cyBpbiAncmV2ZW50cycgZXZlbiBudW1iZXIgb2YgYnl0
ZXMgYXZhaWxhYmxlIHRvIHJlYWQNCiAgIG9uIHNvY2tldCBpcyBzbWFsbGVyIHRoYW4gU09fUkNW
TE9XQVQgdmFsdWUuIEluIHRoaXMgY2FzZSx1c2VyIHNlZXMNCiAgIFBPTExJTiBmbGFnIGFuZCB0
aGVuIHRyaWVzIHRvIHJlYWQgZGF0YShmb3IgZXhhbXBsZSB1c2luZyAgJ3JlYWQoKScNCiAgIGNh
bGwpLCBidXQgcmVhZCBjYWxsIHdpbGwgYmUgYmxvY2tlZCwgYmVjYXVzZSAgU09fUkNWTE9XQVQg
bG9naWMgaXMNCiAgIHN1cHBvcnRlZCBpbiBkZXF1ZXVlIGxvb3AgaW4gYWZfdnNvY2suYy4gQnV0
IHRoZSBzYW1lIHRpbWUsICBQT1NJWA0KICAgcmVxdWlyZXMgdGhhdDoNCg0KICAgIlBPTExJTiAg
ICAgRGF0YSBvdGhlciB0aGFuIGhpZ2gtcHJpb3JpdHkgZGF0YSBtYXkgYmUgcmVhZCB3aXRob3V0
DQogICAgICAgICAgICAgICBibG9ja2luZy4NCiAgICBQT0xMUkROT1JNIE5vcm1hbCBkYXRhIG1h
eSBiZSByZWFkIHdpdGhvdXQgYmxvY2tpbmcuIg0KDQogICBTZWUgaHR0cHM6Ly93d3cub3Blbi1z
dGQub3JnL2p0YzEvc2MyMi9vcGVuL240MjE3LnBkZiwgcGFnZSAyOTMuDQoNCiAgIFNvLCB3ZSBo
YXZlLCB0aGF0IHBvbGwoKSBzeXNjYWxsIHJldHVybnMgUE9MTElOLCBidXQgcmVhZCBjYWxsIHdp
bGwNCiAgIGJlIGJsb2NrZWQuDQoNCiAgIEFsc28gaW4gbWFuIHBhZ2Ugc29ja2V0KDcpIGkgZm91
bmQgdGhhdDoNCg0KICAgIlNpbmNlIExpbnV4IDIuNi4yOCwgc2VsZWN0KDIpLCBwb2xsKDIpLCBh
bmQgZXBvbGwoNykgaW5kaWNhdGUgYQ0KICAgc29ja2V0IGFzIHJlYWRhYmxlIG9ubHkgaWYgYXQg
bGVhc3QgU09fUkNWTE9XQVQgYnl0ZXMgYXJlIGF2YWlsYWJsZS4iDQoNCiAgIEkgY2hlY2tlZCBU
Q1AgY2FsbGJhY2sgZm9yIHBvbGwoKShuZXQvaXB2NC90Y3AuYywgdGNwX3BvbGwoKSksIGl0DQog
ICB1c2VzIFNPX1JDVkxPV0FUIHZhbHVlIHRvIHNldCBQT0xMSU4gYml0LCBhbHNvIGkndmUgdGVz
dGVkIFRDUCB3aXRoDQogICB0aGlzIGNhc2UgZm9yIFRDUCBzb2NrZXQsIGl0IHdvcmtzIGFzIFBP
U0lYIHJlcXVpcmVkLg0KDQogICBJJ3ZlIGFkZGVkIHNvbWUgZml4ZXMgdG8gYWZfdnNvY2suYyBh
bmQgdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYywNCiAgIHRlc3QgaXMgYWxzbyBpbXBsZW1lbnRl
ZC4NCg0KMikgdmlydGlvL3Zzb2NrOg0KICAgSXQgYWRkcyBzb21lIG9wdGltaXphdGlvbiB0byB3
YWtlIHVwcywgd2hlbiBuZXcgZGF0YSBhcnJpdmVkLiBOb3csDQogICBTT19SQ1ZMT1dBVCBpcyBj
b25zaWRlcmVkIGJlZm9yZSB3YWtlIHVwIHNsZWVwZXJzIHdobyB3YWl0IG5ldyBkYXRhLg0KICAg
VGhlcmUgaXMgbm8gc2Vuc2UsIHRvIGtpY2sgd2FpdGVyLCB3aGVuIG51bWJlciBvZiBhdmFpbGFi
bGUgYnl0ZXMNCiAgIGluIHNvY2tldCdzIHF1ZXVlIDwgU09fUkNWTE9XQVQsIGJlY2F1c2UgaWYg
d2Ugd2FrZSB1cCByZWFkZXIgaW4NCiAgIHRoaXMgY2FzZSwgaXQgd2lsbCB3YWl0IGZvciBTT19S
Q1ZMT1dBVCBkYXRhIGFueXdheSBkdXJpbmcgZGVxdWV1ZSwNCiAgIG9yIGluIHBvbGwoKSBjYXNl
LCBQT0xMSU4vUE9MTFJETk9STSBiaXRzIHdvbid0IGJlIHNldCwgc28gc3VjaA0KICAgZXhpdCBm
cm9tIHBvbGwoKSB3aWxsIGJlICJzcHVyaW91cyIuIFRoaXMgbG9naWMgaXMgYWxzbyB1c2VkIGlu
IFRDUA0KICAgc29ja2V0cy4NCg0KMykgdm1jaS92c29jazoNCiAgIFNhbWUgYXMgMiksIGJ1dCBp
J20gbm90IHN1cmUgYWJvdXQgdGhpcyBjaGFuZ2VzLiBXaWxsIGJlIHZlcnkgZ29vZCwNCiAgIHRv
IGdldCBjb21tZW50cyBmcm9tIHNvbWVvbmUgd2hvIGtub3dzIHRoaXMgY29kZS4NCg0KNCkgSHlw
ZXItVjoNCiAgIEFzIERleHVhbiBDdWkgbWVudGlvbmVkLCBmb3IgSHlwZXItViB0cmFuc3BvcnQg
aXQgaXMgZGlmZmljdWx0IHRvDQogICBzdXBwb3J0IFNPX1JDVkxPV0FULCBzbyBoZSBzdWdnZXN0
ZWQgdG8gZGlzYWJsZSB0aGlzIGZlYXR1cmUgZm9yDQogICBIeXBlci1WLg0KDQpUaGFuayBZb3UN
Cg0KQXJzZW5peSBLcmFzbm92KDkpOg0KIHZzb2NrOiB1c2Ugc2tfcmN2bG93YXQgdG8gc2V0IFBP
TExJTi9QT0xMUkROT1JNDQogdmlydGlvL3Zzb2NrOiB1c2UgJ3RhcmdldCcgaW4gbm90aWZ5X3Bv
bGxfaW4gY2FsbGJhY2sNCiB2bWNpL3Zzb2NrOiB1c2UgJ3RhcmdldCcgaW4gbm90aWZ5X3BvbGxf
aW4gY2FsbGJhY2sNCiB2c29ja190ZXN0OiBQT0xMSU4gKyBTT19SQ1ZMT1dBVCB0ZXN0DQogdnNv
Y2s6IFNPX1JDVkxPV0FUIHRyYW5zcG9ydCBzZXQgY2FsbGJhY2sNCiBodl9zb2NrOiBkaXNhYmxl
IFNPX1JDVkxPV0FUIHN1cHBvcnQNCiB2c29jazogYWRkIEFQSSBjYWxsIGZvciBkYXRhIHJlYWR5
DQogdmlydGlvL3Zzb2NrOiBjaGVjayBTT19SQ1ZMT1dBVCBiZWZvcmUgd2FrZSB1cCByZWFkZXIN
CiB2bWNpL3Zzb2NrOiBjaGVjayBTT19SQ1ZMT1dBVCBiZWZvcmUgd2FrZSB1cCByZWFkZXINCg0K
IGluY2x1ZGUvbmV0L2FmX3Zzb2NrLmggICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsNCiBu
ZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgICAgICAgICAgICAgICAgICAgICB8ICAzMiArKysrKysr
LQ0KIG5ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jICAgICAgICAgICAgIHwgICA3ICsr
DQogbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jICAgICAgfCAgIDcgKy0N
CiBuZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeS5jICAgICAgICB8ICAgNCArLQ0K
IG5ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jIHwgICA2ICstDQog
dG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgICAgICAgICAgICAgfCAxMDcgKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQogNyBmaWxlcyBjaGFuZ2VkLCAxNTQgaW5zZXJ0aW9ucygr
KSwgMTEgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4yNS4xDQo=
