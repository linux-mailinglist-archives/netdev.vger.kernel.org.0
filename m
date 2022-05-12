Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F8D5244CE
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349519AbiELFTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbiELFTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:19:35 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B41ACFAD;
        Wed, 11 May 2022 22:19:33 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 8533E5FD06;
        Thu, 12 May 2022 08:19:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1652332771;
        bh=q2RcWNsdgZuAprNCwQFszNeiGtFEWlS8dk+02jxT2tA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=smckDdrLTKHxtZhvHPL7axP5nLbobUR3Y4cLISMmnYb+LBwbjapbc+RPJQOPSJ/bU
         06BeTURqEzjzKRUzepNhRppD4Z2odOblSELi2jfcD9dYQpo29PoZMwlAnwMOG7TEyn
         ibu+nPgh0zYUeNmPPj3NIGZYtt98a5lGzz6zufex+NxUiVXINFZ2H+uKpLKcpA/mhU
         2Ln96+t7R94hHLqBN95OrhiFbcbPWb1tGjGnsRNCsyBVIKP/2llOTIo8IP4xmDG6hj
         rY4x6njPwVb917p+PsMHiobH3zxVGdjBR1du0KZw2v695OL+LKlXYrUKKFEMzzPuLz
         IHlPE4pRHKcxQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 12 May 2022 08:19:30 +0300 (MSK)
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
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 6/8] virtio/vsock: enable zerocopy callback
Thread-Topic: [RFC PATCH v1 6/8] virtio/vsock: enable zerocopy callback
Thread-Index: AQHYZb/CBCCGHsRsTEumsu3XsE8R1A==
Date:   Thu, 12 May 2022 05:18:47 +0000
Message-ID: <f8d9658f-73e8-e28a-3942-9fa07c90f21f@sberdevices.ru>
In-Reply-To: <7cdcb1e1-7c97-c054-19cf-5caeacae981d@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <163A9CE28E0AAF4CABE7459E5DE429D6@sberdevices.ru>
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

VGhpcyBhZGRzIHplcm9jb3B5IGNhbGxiYWNrIGZvciB2aXJ0aW8gdHJhbnNwb3J0Lg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0t
LQ0KIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIHwgMSArDQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspDQoNCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190
cmFuc3BvcnQuYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQppbmRleCA0M2I3
YjA5YjRhMGEuLmVhMGUxNTY3Y2ZhOCAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlv
X3RyYW5zcG9ydC5jDQorKysgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYw0KQEAg
LTQ3OCw2ICs0NzgsNyBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb190cmFuc3BvcnQgdmlydGlvX3Ry
YW5zcG9ydCA9IHsNCiAJCS5zdHJlYW1fcmN2aGl3YXQgICAgICAgICAgPSB2aXJ0aW9fdHJhbnNw
b3J0X3N0cmVhbV9yY3ZoaXdhdCwNCiAJCS5zdHJlYW1faXNfYWN0aXZlICAgICAgICAgPSB2aXJ0
aW9fdHJhbnNwb3J0X3N0cmVhbV9pc19hY3RpdmUsDQogCQkuc3RyZWFtX2FsbG93ICAgICAgICAg
ICAgID0gdmlydGlvX3RyYW5zcG9ydF9zdHJlYW1fYWxsb3csDQorCQkuemVyb2NvcHlfZGVxdWV1
ZQkgID0gdmlydGlvX3RyYW5zcG9ydF96ZXJvY29weV9kZXF1ZXVlLA0KIA0KIAkJLnNlcXBhY2tl
dF9kZXF1ZXVlICAgICAgICA9IHZpcnRpb190cmFuc3BvcnRfc2VxcGFja2V0X2RlcXVldWUsDQog
CQkuc2VxcGFja2V0X2VucXVldWUgICAgICAgID0gdmlydGlvX3RyYW5zcG9ydF9zZXFwYWNrZXRf
ZW5xdWV1ZSwNCi0tIA0KMi4yNS4xDQo=
