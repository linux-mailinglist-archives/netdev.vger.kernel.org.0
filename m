Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604AD6C03E7
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCSSxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCSSw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:52:59 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF4518B21;
        Sun, 19 Mar 2023 11:52:57 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 4DB515FD08;
        Sun, 19 Mar 2023 21:52:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679251976;
        bh=rNqOAJGw/6GrUIXjEJsOP/jJqHM6rXH03ASMfQB3ny8=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=ka82PZ1Q9aVD7cB3sDdLTy71ODRwZNutmhO6ol185+GIWegzLpRNaAoV9K/xk5n1L
         UPg/QlrrpPxhAZrN1Yj65nljpC9BW+MtA8vuPnrSK6SBBUuawf7/rxbmjE/dy//PwF
         NDIZIQZjahfb8kWwKklkrSawJgUdWdDE/8Z8i/ioWAbOq9uTPBiJLhG6U+EBf4dnMa
         I/ErzW9jp3e/8EB+JV29toqJMHRWLrV+g2wRla3Evtp/83qQrZqDSPEhDID0r96d4/
         SHDiPb417TNv8pQoVo6dIfwmnPlwWFU57BFyU9qNl1FcDfj8M72H/4n+SWmEvAxALO
         GD8hW2Am/CUEQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 19 Mar 2023 21:52:55 +0300 (MSK)
Message-ID: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
Date:   Sun, 19 Mar 2023 21:49:36 +0300
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
Subject: [RFC PATCH v1 0/3] fix header length on skb merging
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/19 16:43:00 #20974059
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patchset fixes skbuff merging during rx path. Problem fires when
we are trying to append data to skbuff which is processed in dequeue
callback at the same time. Dequeue callback calls 'skb_pull()' which
changes 'skb->len'. While appending data, this dynamic 'skb->len' will
be used to update length in header of last skbuff. This is wrong, because
length in header is used to update credit parameters ('rx_bytes' and
'fwd_cnt') and must be constant. To set valid length in header of last
skbuff after appending new data to it, we need to sum header values from
both last and new skbuff.

This bug was introduced by:
Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")

I really forgot about this branch in rx path when implemented patch
above.

This patchset contains 3 patches:
1) Fix itself.
2) Patch with WARN() as kernel part of reproducer. I've added error
   return from dequeue callback if this bug fires, otherwise you'll
   get busyloop in kernel: callback always returns 0, but rx loop in
   af_vsock.c sees that rx_bytes is non-zero thus trying to call
   dequeue callback again and again.
3) Patch with reproducer in vsock_test.c. It looks like new test, but
   i'm not sure how to test this branch (appending data to last skbuff)
   of virtio transport. So only way to detect problem is WARN() in 2).

May be, it will be good practice to add some WARN() checks like in 2)
to different parts of virtio/vsock, because such bugs are difficult to
detect.

Arseniy Krasnov (3):
  virtio/vsock: fix header length on skb merging
  virtio/vsock: add WARN() for invalid state of socket
  test/vsock: skbuff merging test

 net/vmw_vsock/virtio_transport_common.c |  9 ++-
 tools/testing/vsock/vsock_test.c        | 81 +++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 1 deletion(-)

-- 
2.25.1
