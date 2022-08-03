Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C3C588DE3
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiHCNvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237977AbiHCNvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:51:01 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F809205E3;
        Wed,  3 Aug 2022 06:48:26 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id E6DFA5FD2E;
        Wed,  3 Aug 2022 16:48:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659534503;
        bh=mAMukG4zOFmQ0mJDgVLGygbis/vBX4+8MbEbbiDl3IA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=BebLyj5e7Y5KXiXpPs0JrRIufDwlxbC/JjpQwjuHLL+FBwf71SlHuX0qHgpUgjL9H
         80uBQ+gQ+3Bj8pavJHhFP06JKpSIEhXfZ2bVbo4YQSXDS2C/AQbvO8rFDVHMmPkBEv
         HdaWaUSM/uJH9R/fau3Pp/ibEhRv6HnElQmMkZXN55CAjzkme2s/nvtM6mVf7t6vXY
         5OWRLdWg+1bxdvJAPneCyecCC0QDOGBfxDvf207wFQmkQPw8LL3H0QhJXQ3TrBMWki
         85XZKHUpOWW5xKZ6aFJmZ0gtges7c0PnanWDFHonWuMv/xg0gHlXoW1yFohp2B7SDE
         16kzR2xaonDlw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 16:48:19 +0300 (MSK)
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
Subject: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYpz+pcvNrW+Wes06KlvYKyF5H+Q==
Date:   Wed, 3 Aug 2022 13:48:06 +0000
Message-ID: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <70E7F8912CC1A849924AB89DEEDC1AD3@sberdevices.ru>
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
Cg0KQXJzZW5peSBLcmFzbm92KDkpOg0KIHZzb2NrOiBTT19SQ1ZMT1dBVCB0cmFuc3BvcnQgc2V0
IGNhbGxiYWNrDQogaHZfc29jazogZGlzYWJsZSBTT19SQ1ZMT1dBVCBzdXBwb3J0DQogdmlydGlv
L3Zzb2NrOiB1c2UgJ3RhcmdldCcgaW4gbm90aWZ5X3BvbGxfaW4gY2FsbGJhY2sNCiB2bWNpL3Zz
b2NrOiB1c2UgJ3RhcmdldCcgaW4gbm90aWZ5X3BvbGxfaW4gY2FsbGJhY2sNCiB2c29jazogcGFz
cyBzb2NrX3Jjdmxvd2F0IHRvIG5vdGlmeV9wb2xsX2luIGFzIHRhcmdldA0KIHZzb2NrOiBhZGQg
QVBJIGNhbGwgZm9yIGRhdGEgcmVhZHkNCiB2aXJ0aW8vdnNvY2s6IGNoZWNrIFNPX1JDVkxPV0FU
IGJlZm9yZSB3YWtlIHVwIHJlYWRlcg0KIHZtY2kvdnNvY2s6IGNoZWNrIFNPX1JDVkxPV0FUIGJl
Zm9yZSB3YWtlIHVwIHJlYWRlcg0KIHZzb2NrX3Rlc3Q6IFBPTExJTiArIFNPX1JDVkxPV0FUIHRl
c3QNCg0KIGluY2x1ZGUvbmV0L2FmX3Zzb2NrLmggICAgICAgICAgICAgICAgICAgICAgIHwgICAy
ICsNCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgICAgICAgICAgICAgICAgICAgICB8ICAzOCAr
KysrKysrKystDQogbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMgICAgICAgICAgICAg
fCAgIDcgKysNCiBuZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMgICAgICB8
ICAgNyArLQ0KIG5ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMgICAgICAgIHwg
IDEwICstLQ0KIG5ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jIHwg
IDEyICstLQ0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jICAgICAgICAgICAgIHwg
MTA3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKw0KIDcgZmlsZXMgY2hhbmdlZCwgMTY2IGlu
c2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KDQogQ2hhbmdlbG9nOg0KDQogdjEgLT4gdjI6
DQogMSkgUGF0Y2hlcyBmb3IgVk1DSSB0cmFuc3BvcnQoc2FtZSBhcyBmb3IgdmlydGlvLXZzb2Nr
KS4NCiAyKSBQYXRjaGVzIGZvciBIeXBlci1WIHRyYW5zcG9ydChkaXNhYmxpbmcgU09fUkNWTE9X
QVQgc2V0dGluZykuDQogMykgV2FpdGluZyBsb2dpYyBpbiB0ZXN0IHdhcyB1cGRhdGVkKHNsZWVw
KCkgLT4gcG9sbCgpKS4NCg0KIHYyIC0+IHYzOg0KIDEpIFBhdGNoZXMgd2VyZSByZW9yZGVyZWQu
DQogMikgQ29tbWl0IG1lc3NhZ2UgdXBkYXRlZCBpbiAwMDA1Lg0KIDMpIENoZWNrICd0cmFuc3Bv
cnQnIHBvaW50ZXIgaW4gMDAwMSBmb3IgTlVMTC4NCiA0KSBDaGVjayAndmFsdWUnIGluIDAwMDEg
Zm9yID4gYnVmZmVyX3NpemUuDQoNCi0tIA0KMi4yNS4xDQo=
