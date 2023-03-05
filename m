Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7D6AB1F4
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 21:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCEUHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 15:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCEUHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 15:07:52 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AA916AD3;
        Sun,  5 Mar 2023 12:07:48 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id A395F5FD04;
        Sun,  5 Mar 2023 23:07:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678046865;
        bh=HJc6SOI5RX3x6uTZNKZKhZWULwHOcmQ+GQH6cylyxbA=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=MKH3GAre/bXpUfp/gEA84lbVBHhrYRHZBzoJg+Okm7xqYI+czrX71EzhYe8sFniNk
         DDNcoy+YQ75czEIUd4KbrxCuRBo/MroVSesCn55keVJ+zuMaMPoi9EO8YWm+BswKnR
         a2dn8+8i2SLOcAe8ixZ7aE2zMxlOQLnGSOOJS55YrHXuevwqxAN26ani4DWMsvjHhP
         dbkneNJHwSRgt1nTvCJZpMHkNZP0Xc3+6r10Rt02dTfG0dKMCwDidnVkC88xTwDK6E
         r0QbcjaDDt4CszFaApUAC4ZBg2TYcJgmZOxmzHoAuZd4v2qaTPVkjxYMJG9l6BSH89
         gvzu43ryxZqfA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  5 Mar 2023 23:07:40 +0300 (MSK)
Message-ID: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
Date:   Sun, 5 Mar 2023 23:04:45 +0300
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
Subject: [RFC PATCH v2 0/4] virtio/vsock: fix credit update logic
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/05 16:13:00 #20917262
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

this patchset fixes three things in skbuff handling:
1) Current implementation of 'virtio_transport_dec_rx_pkt()':

   value to update 'rx_bytes' and 'fwd_cnt' is calculated as:

   skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;

   i'm a little bit confused about subtracting 'skb->len'. It is clear,
   that difference between first two components is number of bytes copied
   to user. 'skb_headroom()' is delta between 'data' and 'head'. 'data'
   is incremented on each copy data to user from skb by call 'skb_pull()'
   (at the same moment, 'skb->len' is decremented to the same amount of
   bytes). 'head' points to the header of the packet. But what is purpose
   of 'skb->len' here? For SOCK_STREAM is has no effect because this
   logic is called only when 'skb->len' == 0, but for SOCK_SEQPACKET and
   other future calls i think it is buggy.

2) For SOCK_SEQPACKET all sk_buffs are handled only once - after dequeue
   each sk_buff is removed, so user will never read rest of the data.
   Thus we need to update credit parameters of the socket ('rx_bytes' and
   'fwd_cnt') like whole sk_buff is read - so call 'skb_pull()' for the
   whole buffer.

3) For SOCK_STREAM when 'memcpy_to_msg()' fails it fixes 'rx_bytes'
   update (like in 2)) and frees current skbuff.

Test is also added to vsock_test. It does two attempts to read data from
socket - first attempt to invalid buffer (kernel must drop skb). Second
attempt is performed with valid buffer and MSG_DONTWAIT flag. If socket's
queue will be empty (skbuff was dropped due to 'memcpy_to_msg()' fail
and 'rx_bytes' which controls data waiting set to 0), such call will
return immediately with EAGAIN.

Link to v1 on lore:
https://lore.kernel.org/netdev/c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru/

Change log:

v1 -> v2:
 - For SOCK_SEQPACKET call 'skb_pull()' also in case of copy failure or
   dropping skbuff (when we just waiting message end).
 - Handle copy failure for SOCK_STREAM in the same manner (plus free
   current skbuff).
 - Replace bug repdroducer with new test in vsock_test.c

Arseniy Krasnov (4):
  virtio/vsock: fix 'rx_bytes'/'fwd_cnt' calculation
  virtio/vsock: remove all data from sk_buff
  virtio/vsock: free skb on data copy failure
  test/vsock: invalid buffer tests

 net/vmw_vsock/virtio_transport_common.c |  10 ++-
 tools/testing/vsock/vsock_test.c        | 106 ++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 3 deletions(-)

-- 
2.25.1
