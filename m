Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE05994AA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346464AbiHSFe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345646AbiHSFe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:34:26 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FB1E115F;
        Thu, 18 Aug 2022 22:34:15 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 667605FD07;
        Fri, 19 Aug 2022 08:34:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887253;
        bh=oAbKHrPUMqucBfyHil78hHVDn5WAShR1TtVtIynYbkY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=kRO4SK6kY7hQ5vRkMd70+6712roNzQ4s7XvA/TFvNI8O2+sP7oRfUxHVx8QZZ8gn1
         r8LGBMzePfCAh8YQUdOV4CsGEd/ilXtgNCgjuoJRqE3qVzX3mxDjeHkPoW3kPgKkUL
         upcr3MPuiswzUJrmGHgOV68TuX7pW+HL808SUUo5fKF9XJuPthv4IYZsPpibufMX3Y
         0EeFPx2JXChw5sQ/Bn0j1gvKyhZTDIMldkgleNPqMaMs9vl0hS5RZOADu620dpDKf5
         IpKEmT5nIPxyWmsBeDm7/8NdYGolRwfGV3Fg3u8A8l1W/HYbFNdxXEJnxkV2dpGK32
         7s2Oy5elwcVjw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:34:12 +0300 (MSK)
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
Subject: [PATCH net-next v4 5/9] vsock: pass sock_rcvlowat to notify_poll_in
 as target
Thread-Topic: [PATCH net-next v4 5/9] vsock: pass sock_rcvlowat to
 notify_poll_in as target
Thread-Index: AQHYs41Ba2I9J1kMc0GcNZuEs3vtJA==
Date:   Fri, 19 Aug 2022 05:33:47 +0000
Message-ID: <90aebdb6-aece-d78c-8393-ec187ebf238f@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9935DDFF722F743BBE8624BDFE791E7@sberdevices.ru>
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

UGFzc2luZyAxIGFzIHRoZSB0YXJnZXQgdG8gbm90aWZ5X3BvbGxfaW4oKSwgd2UgZG9uJ3QgaG9u
b3INCndoYXQgdGhlIHVzZXIgaGFzIHNldCB2aWEgU09fUkNWTE9XQVQsIGdvaW5nIHRvIHNldCBQ
T0xMSU4NCmFuZCBQT0xMUkROT1JNLCBldmVuIGlmIHdlIGRvbid0IGhhdmUgdGhlIGFtb3VudCBv
ZiBieXRlcw0KZXhwZWN0ZWQgYnkgdGhlIHVzZXIuDQoNCkxldCdzIHVzZSBzb2NrX3Jjdmxvd2F0
KCkgdG8gZ2V0IHRoZSByaWdodCB0YXJnZXQgdG8gcGFzcyB0bw0Kbm90aWZ5X3BvbGxfaW4oKTsN
Cg0KU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMu
cnU+DQpSZXZpZXdlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29t
Pg0KLS0tDQogbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgMyArKy0NCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvdm13
X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4IDBhNjc3
NzUyNmM3My4uYjVjYmM4NDk4NDRiIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29j
ay5jDQorKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC0xMDY2LDggKzEwNjYsOSBA
QCBzdGF0aWMgX19wb2xsX3QgdnNvY2tfcG9sbChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHNv
Y2tldCAqc29jaywNCiAJCWlmICh0cmFuc3BvcnQgJiYgdHJhbnNwb3J0LT5zdHJlYW1faXNfYWN0
aXZlKHZzaykgJiYNCiAJCSAgICAhKHNrLT5za19zaHV0ZG93biAmIFJDVl9TSFVURE9XTikpIHsN
CiAJCQlib29sIGRhdGFfcmVhZHlfbm93ID0gZmFsc2U7DQorCQkJaW50IHRhcmdldCA9IHNvY2tf
cmN2bG93YXQoc2ssIDAsIElOVF9NQVgpOw0KIAkJCWludCByZXQgPSB0cmFuc3BvcnQtPm5vdGlm
eV9wb2xsX2luKA0KLQkJCQkJdnNrLCAxLCAmZGF0YV9yZWFkeV9ub3cpOw0KKwkJCQkJdnNrLCB0
YXJnZXQsICZkYXRhX3JlYWR5X25vdyk7DQogCQkJaWYgKHJldCA8IDApIHsNCiAJCQkJbWFzayB8
PSBFUE9MTEVSUjsNCiAJCQl9IGVsc2Ugew0KLS0gDQoyLjI1LjENCg==
