Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D67F6D4370
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjDCL0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDCL0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:26:44 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB0F10C3;
        Mon,  3 Apr 2023 04:26:41 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id D02235FD22;
        Mon,  3 Apr 2023 14:26:37 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680521197;
        bh=s4eKgbhgNv4f1gYW15n6VyDdSflCXwAy8F8mScWFz1Y=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=N1fUn7HlplUsCBt69oiXkW3iJYH1erjbGgmUNz6XOV0trL6r0ifCm6efGiBgZaaYn
         n0GyArgAJlVSOMA/1C7RApPNudst0UJt88eqrCvfwnOv/e8vhPi9PAO/LnoEpXgVm4
         S2KElDs8pdwL4Mf5/wl/4BKUOqXSGkNh7rJ7/ye64/rczXHP2sf8ND1ltIscS8dRwx
         6MNYt81yFqMBjBI7xpf8fq4TgFYM5cIHQe3y0C1rrL0URdAoIHHlpSXc6vurdR9OkD
         Bv1cE3bOdrktc46rJsaYorKDTJsIHutqqUs2X3lIQm+Xe/woSX25ylmEhsITMiZ7p1
         dpLflBm5xsnyg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  3 Apr 2023 14:26:31 +0300 (MSK)
Message-ID: <0d20e25a-640c-72c1-2dcb-7a53a05e3132@sberdevices.ru>
Date:   Mon, 3 Apr 2023 14:23:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>, <pv-drivers@vmware.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [PATCH net-next v4 0/3] vsock: return errors other than -ENOMEM to
 socket
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/03 05:35:00 #21028078
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patchset removes behaviour, where error code returned from any
transport was always switched to ENOMEM. This works in the same way as
patch from Bobby Eshleman:
commit c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
but for receive calls. VMCI transport is also updated (both tx and rx
SOCK_STREAM callbacks), because it returns VMCI specific error code to
af_vsock.c (like VMCI_ERROR_*). Tx path is already merged to net, so it
was excluded from patchset in v4. At the same time, virtio and Hyper-V
transports are using general error codes, so there is no need to update
them.

vsock_test suite is also updated.

Link to v1:
https://lore.kernel.org/netdev/97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru/
Link to v2:
https://lore.kernel.org/netdev/60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru/
Link to v3:
https://lore.kernel.org/netdev/dead4842-333a-015e-028b-302151336ff9@sberdevices.ru/

Changelog:

v1 -> v2:
 - Add patch for VMCI as Vishnu Dasa suggested.
v2 -> v3:
 - Change type of 'err' var in VMCI patches from 'int' to 'ssize_t'.
 - Split VMCI patch to two patches: for send and for receive cases.
 - Reorder patches: move VMCI before af_vsock.c.
v3 -> v4:
 - Exclude VMCI patch for send from patchset (merged to 'net').
 - Update commit message of VMCI patch for receive.

Arseniy Krasnov (3):
  vsock/vmci: convert VMCI error code to -ENOMEM on receive
  vsock: return errors other than -ENOMEM to socket
  vsock/test: update expected return values

 net/vmw_vsock/af_vsock.c         |  4 ++--
 net/vmw_vsock/vmci_transport.c   | 11 +++++++++--
 tools/testing/vsock/vsock_test.c |  4 ++--
 3 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.25.1
