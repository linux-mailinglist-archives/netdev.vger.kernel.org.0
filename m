Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E0261E5AE
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiKFTrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKFTrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:47:39 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0015FF5;
        Sun,  6 Nov 2022 11:47:38 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id AFA625FD03;
        Sun,  6 Nov 2022 22:47:36 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667764056;
        bh=rkPnlyhLuVRW8SnsMpIB4rs4sReUJk836iqZy6DVi/8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=KQp6oe7xLJx2SI+CN2IxqnylOlMZXZNSluMyFmJKgx02ot9NKrYdAHjC7BELJG8fO
         o5YOgqbp+8Bn/w27DavoaapCqMXK2F2E1Aw2d3YLYiYb1U+al/nyQ+sl/RhvpnMyJV
         MUolT/KsqjsfwHORV3veNki2ELsL/EnZFLDH2aux87wjHS2HIdrC6ETumvjej2qobU
         CFmSZWQoWh/Ld4OaGu+vHN1KnVd5X9ZuzwC6iFVFQhOI+U/k+tLMAZEss1zPY5IBCp
         XVdawsIHR+5zJ/xEWzAxGw7bUFmctmW1UYHLPZd1Uf0SkAl0dh1QJq1b+MxcuMsyx8
         hnqf0I0gEq/mA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  6 Nov 2022 22:47:36 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 07/11] virtio/vsock: enable zerocopy callback
Thread-Topic: [RFC PATCH v3 07/11] virtio/vsock: enable zerocopy callback
Thread-Index: AQHY8hiMyajXktRACUOON+IpWz23oQ==
Date:   Sun, 6 Nov 2022 19:47:05 +0000
Message-ID: <bd5969b0-3184-7298-25b1-110a5e04c46b@sberdevices.ru>
In-Reply-To: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFE261704A3EEB4FA6F71D255F403BB5@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 18:31:00 #20575158
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHplcm9jb3B5IGNhbGxiYWNrIGZvciB2aXJ0aW8gdHJhbnNwb3J0Lg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0t
LQ0KIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIHwgMiArKw0KIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlv
X3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCmluZGV4IDAz
MDVmOTRjOThiYi4uY2JkYzkxYWNkOWQ0IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay92aXJ0
aW9fdHJhbnNwb3J0LmMNCisrKyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQpA
QCAtNDgwLDYgKzQ4MCw4IEBAIHN0YXRpYyBzdHJ1Y3QgdmlydGlvX3RyYW5zcG9ydCB2aXJ0aW9f
dHJhbnNwb3J0ID0gew0KIAkJLnN0cmVhbV9yY3ZoaXdhdCAgICAgICAgICA9IHZpcnRpb190cmFu
c3BvcnRfc3RyZWFtX3Jjdmhpd2F0LA0KIAkJLnN0cmVhbV9pc19hY3RpdmUgICAgICAgICA9IHZp
cnRpb190cmFuc3BvcnRfc3RyZWFtX2lzX2FjdGl2ZSwNCiAJCS5zdHJlYW1fYWxsb3cgICAgICAg
ICAgICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3N0cmVhbV9hbGxvdywNCisJCS56ZXJvY29weV9kZXF1
ZXVlICAgICAgICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3plcm9jb3B5X2RlcXVldWUsDQorCQkuemVy
b2NvcHlfcnhfbW1hcCAgICAgICAgID0gdmlydGlvX3RyYW5zcG9ydF96ZXJvY29weV9pbml0LA0K
IA0KIAkJLnNlcXBhY2tldF9kZXF1ZXVlICAgICAgICA9IHZpcnRpb190cmFuc3BvcnRfc2VxcGFj
a2V0X2RlcXVldWUsDQogCQkuc2VxcGFja2V0X2VucXVldWUgICAgICAgID0gdmlydGlvX3RyYW5z
cG9ydF9zZXFwYWNrZXRfZW5xdWV1ZSwNCi0tIA0KMi4zNS4wDQo=
