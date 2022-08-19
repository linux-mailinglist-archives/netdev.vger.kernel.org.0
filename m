Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE506599475
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346313AbiHSFaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345200AbiHSFaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:30:03 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648CDD573F;
        Thu, 18 Aug 2022 22:30:02 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 98D675FD07;
        Fri, 19 Aug 2022 08:30:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887000;
        bh=HkUmGO8BR4mvsCDioUDHVxe6cFrtTj9VNblWxBkjvUY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=ToD49HiAHMATFc3HmtcrWHGzvOO3K5HC/19fw+fGQxKWZDKEGEINyJtdSPh5Ca5OJ
         8ncHFb8oWaMqKVWN/9Hs1X4sha4RtNOv33MpwhqZz7xGqIKldijd2FYUPlDxkNsJ3A
         /Cl9EaQg+psPqazAuT/xpZNDZh2JhUFeLj8MmTXSyI2wY/OVmAF5ilCacuFVWxlO8a
         yOov7nXCnUxg5zjqqOU9A2sKvWWOHUDKT5b4heSqR8ZU23CXzZGEKaNdCo9840ot1Q
         HhMyt9BTvm+WBlnOhqw1LQQx9aLC9uoChP1JwcLPNtGb17lF/blynP79raqI34lT+m
         s2Ep/1Fb3cdXA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:29:59 +0300 (MSK)
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
Subject: [PATCH net-next v4 3/9] virtio/vsock: use 'target' in notify_poll_in
 callback
Thread-Topic: [PATCH net-next v4 3/9] virtio/vsock: use 'target' in
 notify_poll_in callback
Thread-Index: AQHYs4yqyCPs/xU05EWXDbxbWPV2ow==
Date:   Fri, 19 Aug 2022 05:29:34 +0000
Message-ID: <61ef8a18-24fe-d16c-b093-764d3b66804a@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ECC2C8816C4704D8DC273A24207C7C9@sberdevices.ru>
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

VGhpcyBjYWxsYmFjayBjb250cm9scyBzZXR0aW5nIG9mIFBPTExJTiwgUE9MTFJETk9STSBvdXRw
dXQgYml0cyBvZiBwb2xsKCkNCnN5c2NhbGwsIGJ1dCBpbiBzb21lIGNhc2VzLCBpdCBpcyBpbmNv
cnJlY3RseSB0byBzZXQgaXQsIHdoZW4gc29ja2V0IGhhcw0KYXQgbGVhc3QgMSBieXRlcyBvZiBh
dmFpbGFibGUgZGF0YS4gVXNlICd0YXJnZXQnIHdoaWNoIGlzIGFscmVhZHkgZXhpc3RzLg0KDQpT
aWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4N
ClJldmlld2VkLWJ5OiBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5jb20+DQot
LS0NCiBuZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMgfCA1ICstLS0tDQog
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIGIvbmV0L3Ztd192
c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQppbmRleCBlYzJjMmFmYmYwZDAuLjhmNjM1
NmViY2RkMSAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21t
b24uYw0KKysrIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQpAQCAt
NjM0LDEwICs2MzQsNyBAQCB2aXJ0aW9fdHJhbnNwb3J0X25vdGlmeV9wb2xsX2luKHN0cnVjdCB2
c29ja19zb2NrICp2c2ssDQogCQkJCXNpemVfdCB0YXJnZXQsDQogCQkJCWJvb2wgKmRhdGFfcmVh
ZHlfbm93KQ0KIHsNCi0JaWYgKHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2c2spKQ0KLQkJKmRhdGFf
cmVhZHlfbm93ID0gdHJ1ZTsNCi0JZWxzZQ0KLQkJKmRhdGFfcmVhZHlfbm93ID0gZmFsc2U7DQor
CSpkYXRhX3JlYWR5X25vdyA9IHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2c2spID49IHRhcmdldDsN
CiANCiAJcmV0dXJuIDA7DQogfQ0KLS0gDQoyLjI1LjENCg==
