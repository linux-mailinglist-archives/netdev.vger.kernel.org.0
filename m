Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581986AA60E
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCDADc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCDAD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:03:27 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61F4BBBB;
        Fri,  3 Mar 2023 16:03:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 04D7B5FD06;
        Sat,  4 Mar 2023 01:00:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677880844;
        bh=7L0edCMAkGUC4DPvTm9asbeHzX24JhAHEcdZKa63fyE=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=afB1VWAPjwtq5RXaaUh09yB0lUke4N4f5j0Zk+Q8iuzTXiezFUfPqlQPcdgBvcKNT
         f7uHceGGgJLx1lM/msZ7kiV8I8cyXDELvPi8FyYC4QB/NKd1KrjgWx/jWLI/w2pEXK
         5QnA1DlXwBqglDCITOWpR2z3rfnWw+BAdbDDnz1jPOWb4MchEb1uFEdquSBkN7N2HI
         gWeNXtvvcqONKVdPZ2nTfJAdi8ID6L3PQf/Pp77J4a6IhTAC6WPcpqjCS8jvjCREC5
         IDIxVFfBPYbY9GJAphiI7gHx7LkvXIJ1rz17UQ0hJYqpk+fc5/UGuIj+SStkad5t/h
         GvchH8/Bw9LTw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  4 Mar 2023 01:00:38 +0300 (MSK)
Message-ID: <c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru>
Date:   Sat, 4 Mar 2023 00:57:48 +0300
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
Subject: [RFC PATCH v1 0/3] virtio/vsock: fix credit update logic
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/03 17:09:00 #20912733
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

this patchset fixes two things in credit account logic:
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

Reproducer is included. To trigger problem run vsock_test without two
patches with fix - You will see 'Negative len:'. Patches with fixes
depends on reproducer due to 'pr_emerg()', but i can resend them, seems
not a big deal.


Arseniy Krasnov (3):
  test/vsock: SOCK_SEQPACKET 'rx_bytes'/'fwd_cnt' bug reproducer
  virtio/vsock: fix 'rx_bytes'/'fwd_cnt' calculation
  virtio/vsock: remove all data from sk_buff

 net/vmw_vsock/virtio_transport_common.c |  8 +++--
 tools/testing/vsock/vsock_test.c        | 44 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.25.1
