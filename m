Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D3A5244C6
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349548AbiELFRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242790AbiELFRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:17:48 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527DE37A3B;
        Wed, 11 May 2022 22:17:46 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 661C85FD06;
        Thu, 12 May 2022 08:17:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1652332664;
        bh=42jDnDX08klVXS7FSnmeXaJxIYwIwhgFNvH0ZzzZhLE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=H+Ybw6Csrazqt4x432PVXOPb1J7Z9p40cNcLl/G30tF51yRo5IFBpaG14STYemCS4
         VF4YZl/jWoIP2mE5IG/4kQJtj0cc89e2EK77UE32K3UIZX4hlp1X3smOFRWGYnY/tn
         MKdMCs+FhxFFQ58Jv9USRedoShRaiqyq8VH9PEs0OsscwudIrXGPEe3VoST1T3l4yM
         w1BsNcP78QoZa+viEBqwOKVVEgPrDMX332TmBWU9yYniO0keZg6RlJAL2vtuP4s3xF
         g+JVAgg/CkFBR9B5f0Ff7ucgxwSe49wdZR1gndNncnS32KPl4HfjNRfWsZwQmpNBrE
         2smAwEK1kGJdA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 12 May 2022 08:17:44 +0300 (MSK)
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
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 5/8] vhost/vsock: enable zerocopy callback
Thread-Topic: [RFC PATCH v1 5/8] vhost/vsock: enable zerocopy callback
Thread-Index: AQHYZb+Chv+MF/2wWEaC/fTa33nAOg==
Date:   Thu, 12 May 2022 05:17:01 +0000
Message-ID: <cef192f7-45ce-839a-91a4-a6996f6a6f29@sberdevices.ru>
In-Reply-To: <7cdcb1e1-7c97-c054-19cf-5caeacae981d@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7F6E37C94EAD8439CE0EFD97F2AD119@sberdevices.ru>
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

VGhpcyBhZGRzIHplcm9jb3B5IGNhbGxiYWNrIHRvIHZob3N0IHRyYW5zcG9ydC4NCg0KU2lnbmVk
LW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQotLS0N
CiBkcml2ZXJzL3Zob3N0L3Zzb2NrLmMgfCAxICsNCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYyBiL2RyaXZlcnMvdmhv
c3QvdnNvY2suYw0KaW5kZXggMTU3Nzk4OTg1Mzg5Li45MzExOWQ1MjlmYjAgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCisrKyBiL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KQEAg
LTQ4NCw2ICs0ODQsNyBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb190cmFuc3BvcnQgdmhvc3RfdHJh
bnNwb3J0ID0gew0KIAkJLnN0cmVhbV9yY3ZoaXdhdCAgICAgICAgICA9IHZpcnRpb190cmFuc3Bv
cnRfc3RyZWFtX3Jjdmhpd2F0LA0KIAkJLnN0cmVhbV9pc19hY3RpdmUgICAgICAgICA9IHZpcnRp
b190cmFuc3BvcnRfc3RyZWFtX2lzX2FjdGl2ZSwNCiAJCS5zdHJlYW1fYWxsb3cgICAgICAgICAg
ICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3N0cmVhbV9hbGxvdywNCisJCS56ZXJvY29weV9kZXF1ZXVl
CSAgPSB2aXJ0aW9fdHJhbnNwb3J0X3plcm9jb3B5X2RlcXVldWUsDQogDQogCQkuc2VxcGFja2V0
X2RlcXVldWUgICAgICAgID0gdmlydGlvX3RyYW5zcG9ydF9zZXFwYWNrZXRfZGVxdWV1ZSwNCiAJ
CS5zZXFwYWNrZXRfZW5xdWV1ZSAgICAgICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3NlcXBhY2tldF9l
bnF1ZXVlLA0KLS0gDQoyLjI1LjENCg==
