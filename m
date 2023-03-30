Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664126CFC3F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjC3HIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjC3HIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:08:15 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E65116;
        Thu, 30 Mar 2023 00:08:12 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 379325FD25;
        Thu, 30 Mar 2023 10:08:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680160090;
        bh=ameKgIhmOWR/h0sAwznCSg6y9mitDBYPG10YKFQsEJg=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=N8PAHDYIcv8y9zBbl0jJLCtUoWmXN9xHv+qdP0DtylsZRPPtHGKJZQuUkOjLMRW0o
         u5rb2oSri2sOcK0DqvCKEvp8FYiV0pEeIXwmdEXbuFMCNfEyMmdjp5AINBWlmCXzUX
         oBOD8DBqew2n8JJDp93VLCyuBIfVCyiPjqwwVhydZFJrzh5xd9F9pSusUiy2yMyFVd
         FsJx8YFrSIHcVvPPLMAAOHVRC1RS+rJYwXoY8sNsn5syJxf6yVu7ssDY3XiRLi982U
         NdJs+/wmvbMrSEjsMDEVfchOOOGboCMq3lhuBtcAjyeDt3zk3ibAEEyeJ4/5H46DOp
         gJJH5KWuwEd1A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 10:08:05 +0300 (MSK)
Message-ID: <60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru>
Date:   Thu, 30 Mar 2023 10:04:41 +0300
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
Subject: vsock: return errors other than -ENOMEM to socket
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/30 01:24:00 #21043458
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
af_vsock.c (like VMCI_ERROR_*). At the same time, virtio and Hyper-V
transports are using general error codes, so there is no need to update
them.

vsock_test suite is also updated.

Link to v1:
https://lore.kernel.org/netdev/97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru/

Changelog:

v1 -> v2:
 - Add patch for VMCI as Vishnu Dasa suggested.

Arseniy Krasnov (3):
  vsock: return errors other than -ENOMEM to socket
  vsock/vmci: convert VMCI error code to -ENOMEM
  vsock/test: update expected return values

 net/vmw_vsock/af_vsock.c         |  4 ++--
 net/vmw_vsock/vmci_transport.c   | 19 ++++++++++++++++---
 tools/testing/vsock/vsock_test.c |  4 ++--
 3 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.25.1
