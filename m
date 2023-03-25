Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168836C9121
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjCYWK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjCYWKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:10:25 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DBE40E3;
        Sat, 25 Mar 2023 15:10:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 3E8665FD02;
        Sun, 26 Mar 2023 01:10:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782222;
        bh=fgF6s5R3U6VGsdB/76CfdbRQ/kHWhdlTZAEkRxHRzOU=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=iTjZCzqqvkvHNC4fPC01IAwWRMJV4u+8bQHj8MNii9ziKxmjwKxbRhIt8ON1j5NZS
         fJ6Y1/kkJfRhKSXyc3ncWGKu84OaN6OR7S3GK7XEouS7s4rG7exPqoTq5AHuv+KC/2
         vG+6QVm6iJucexsLFx377/IkmLXxBehCtfYVC8fsxJi+/g6qRZwmPHc96fwJkQDaoE
         tGFDxbxgZW4NVdi4/8iXBG6YqRYSorVJDk1QoEAZU1n7p+YbBylOqQSiWY0BDRvl/k
         0TOq8FArtPx9XBsAtYgwJuz8Ieao36Cjsj0MEMhhJ2H69ymVXeOtmbttyNk3/O51WZ
         YLqS64FKcSrbw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:10:22 +0300 (MSK)
Message-ID: <728181e9-6b35-0092-3d01-3d7aff4521b6@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:07:05 +0300
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
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 0/3] fix header length on skb merging
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 20:38:00 #21009968
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

this patchset fixes appending newly arrived skbuff to the last skbuff of
the socket's queue during rx path. Problem fires when we are trying to
append data to skbuff which was already processed in dequeue callback
at least once. Dequeue callback calls function 'skb_pull()' which changes
'skb->len'. In current implementation 'skb->len' is used to update length
in header of last skbuff after new data was copied to it. This is bug,
because value in header is used to calculate 'rx_bytes'/'fwd_cnt' and
thus must be constant during skbuff lifetime. Here is example, we have
two skbuffs: skb0 with length 10 and skb1 with length 4.

1) skb0 arrives, hdr->len == skb->len == 10, rx_bytes == 10
2) Read 3 bytes from skb0, skb->len == 7, hdr->len == 10, rx_bytes == 10
3) skb1 arrives, hdr->len == skb->len == 4, rx_bytes == 14
4) Append skb1 to skb0, skb0 now has skb->len == 11, hdr->len == 11.
   But value of 11 in header is invalid.
5) Read whole skb0, update rx_bytes by 11 from skb0's header.
6) At this moment rx_bytes == 3, but socket's queue is empty.

This bug starts to fire since:

commit
077706165717 ("virtio/vsock: don't use skbuff state to account credit")

In fact, it presents before, but didn't triggered due to a little bit
buggy implementation of credit calculation logic. So i'll use Fixes tag
for it.

I really forgot about this branch in rx path when implemented patch
077706165717.

This patchset contains 3 patches:
1) Fix itself.
2) Patch with WARN_ONCE() to catch such problems in future.
3) Patch with test which triggers skb appending logic. It looks like
   simple test with several 'send()' and 'recv()', but it checks, that
   skbuff appending works ok.

Link to v1:
https://lore.kernel.org/netdev/e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru/

Changelog:

v1 -> v2:
 - Replace 'WARN()' with 'WARN_ONCE()'.
 - Clean and refactor source code of the reproducer, now it is test for
   vsock_test suite.
 - Commit messages update.

Arseniy Krasnov (3):
  virtio/vsock: fix header length on skb merging
  virtio/vsock: WARN_ONCE() for invalid state of socket
  test/vsock: new skbuff appending test

 net/vmw_vsock/virtio_transport_common.c |  9 ++-
 tools/testing/vsock/vsock_test.c        | 90 +++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 1 deletion(-)

-- 
2.25.1
