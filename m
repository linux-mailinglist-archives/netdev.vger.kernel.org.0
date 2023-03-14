Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68706B9133
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCNLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjCNLKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:10:45 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E19D95E1A;
        Tue, 14 Mar 2023 04:10:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 957EA5FD1A;
        Tue, 14 Mar 2023 13:44:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678790657;
        bh=uFGjRE3j4zXGby/VPz50ex9laPK7eGiO5HSk7DnBtqc=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=FhIFDc6j+6MgccoCqfw2omY3M7oR/MHVpiu9SMAAMMd81pue8CPDk7vY27aXe0YyK
         MiLL+jLilOMOCy8w2voJmtUgB+2ILNeVJTes0ZmOqbJCDcPhedwlm9M/KgN23HwytU
         0XFkegLx8GG8NAG3vFdB7lAC5l9xXKYm4a6H4qzlusx5NYfZYRqGdhn0G+GfqmMt5T
         Zr5d6H7r2cJZAnmh0pYUVAa/VQlzqAoLknw18UV+17b/N9hlMsB91iPt7/x72Wd8Hw
         uMbyuCTvLYMBcTvAw+3oEWFBCd9/BxtuYgUeCdBZ0eOiaYnm3oFcCSha++LnGh+VEJ
         0Bt3flwdMXHFQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Mar 2023 13:44:12 +0300 (MSK)
Message-ID: <34d65539-015e-23c8-cf5e-f34bd5795e52@sberdevices.ru>
Date:   Tue, 14 Mar 2023 13:41:03 +0300
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
Subject: [PATCH net v4 0/4] several updates to virtio/vsock
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/14 06:01:00 #20942017
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patchset evolved from previous v2 version (see link below). It does
several updates to virtio/vsock:
1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
   and 'rx_bytes', integer value is passed as an input argument. This
   makes code more simple, because in this case we don't need to update
   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
   more common words - we don't need to change skbuff state to update
   'rx_bytes' and 'fwd_cnt' correctly.
2) For SOCK_STREAM, when copying data to user fails, current skbuff is
   not dropped. Next read attempt will use same skbuff and last offset.
   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
   This behaviour was implemented before skbuff support.
3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
   this type of socket each skbuff is used only once: after removing it
   from socket's queue, it will be freed anyway.

Test for 2) also added:
Test tries to 'recv()' data to NULL buffer, then does 'recv()' with valid
buffer. For SOCK_STREAM second 'recv()' must return data, because skbuff
must not be dropped, but for SOCK_SEQPACKET skbuff will be dropped by
kernel, and 'recv()' will return EAGAIN.

Link to v1 on lore:
https://lore.kernel.org/netdev/c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru/

Link to v2 on lore:
https://lore.kernel.org/netdev/a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru/

Link to v3 on lore:
https://lore.kernel.org/netdev/0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru/

Change log:

v1 -> v2:
 - For SOCK_SEQPACKET call 'skb_pull()' also in case of copy failure or
   dropping skbuff (when we just waiting message end).
 - Handle copy failure for SOCK_STREAM in the same manner (plus free
   current skbuff).
 - Replace bug repdroducer with new test in vsock_test.c

v2 -> v3:
 - Replace patch which removes 'skb->len' subtraction from function
   'virtio_transport_dec_rx_pkt()' with patch which updates functions
   'virtio_transport_inc/dec_rx_pkt()' by passing integer argument
   instead of skbuff pointer.
 - Replace patch which drops skbuff when copying to user fails with
   patch which changes this behaviour by keeping skbuff in queue until
   it has no data.
 - Add patch for SOCK_SEQPACKET which removes redundant 'skb_pull()'
   call on read.
 - I remove "Fixes" tag from all patches, because all of them now change
   code logic, not only fix something.

v3 -> v4:
 - Update commit messages in all patches except test.
 - Add "Fixes" tag to all patches except test.

Arseniy Krasnov (4):
  virtio/vsock: don't use skbuff state to account credit
  virtio/vsock: remove redundant 'skb_pull()' call
  virtio/vsock: don't drop skbuff on copy failure
  test/vsock: copy to user failure test

 net/vmw_vsock/virtio_transport_common.c |  29 +++---
 tools/testing/vsock/vsock_test.c        | 118 ++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 16 deletions(-)

-- 
2.25.1
