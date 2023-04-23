Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F264D6EC1DD
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDWTb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjDWTb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:26 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD546E52;
        Sun, 23 Apr 2023 12:31:22 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id D83D55FD09;
        Sun, 23 Apr 2023 22:31:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278278;
        bh=y4Egk/708JJqjWP2KzzQDBOfQ8z1vDmQRhJfk6cWA40=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=qX3fQLxeNjQsI+3SrBDilWHgyOp/FSZYqYgK9Uq+iAqdebior5KBPt+uFaCQ36Nw6
         SyPkfKMBNRuthlrS4ED8rtyreySIIVBjEYJ+u6bBBYcaE13+OFEnQcrxLZcyZTJjGf
         K+m0ZVIUYcKFZMBoz0AlvtScjQOE6LQE1cxHY/tf5x0JjuDKNjeKPh061zUMa8xq9D
         HT2pvlD88QoyXOSYK797wzHH092iPqXuEyPPrd7jTGQCvXG/mt2Egje8vaEX0ayu30
         pRRMtcmzzt/YZ3BL5oYBFgy3Q4vcjjkrqq4EsbeSveM0NQXfSUtk042elqOfTQ0FVG
         9qqEWTSBYY0sw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:13 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 00/15] vsock: MSG_ZEROCOPY flag support
Date:   Sun, 23 Apr 2023 22:26:28 +0300
Message-ID: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

                           DESCRIPTION

this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
current implementation for TCP as much as possible:

1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
   flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
   flag will be ignored (e.g. without completion).

2) Kernel uses completions from socket's error queue. Single completion
   for single tx syscall (or it can merge several completions to single
   one). I used already implemented logic for MSG_ZEROCOPY support:
   'msg_zerocopy_realloc()' etc.

Difference with copy way is not significant. During packet allocation,
non-linear skb is created, then I call 'pin_user_pages()' for each page
from user's iov iterator and add each returned page to the skb as fragment.
There are also some updates for vhost and guest parts of transport - in
both cases i've added handling of non-linear skb for virtio part. vhost
copies data from such skb to the guest's rx virtio buffers. In the guest,
virtio transport fills tx virtio queue with pages from skb.

This version has several limits/problems:

1) As this feature totally depends on transport, there is no way (or it
   is difficult) to check whether transport is able to handle it or not
   during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
   setsockopt callback from setsockopt callback for SOL_SOCKET, but this
   leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
   are not considered to be called from each other. So in current version
   SO_ZEROCOPY is set successfully to any type (e.g. transport) of
   AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
   tx routine will fail with EOPNOTSUPP.

2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
   one completion. In each completion there is flag which shows how tx
   was performed: zerocopy or copy. This leads that whole message must
   be send in zerocopy or copy way - we can't send part of message with
   copying and rest of message with zerocopy mode (or vice versa). Now,
   we need to account vsock credit logic, e.g. we can't send whole data
   once - only allowed number of bytes could sent at any moment. In case
   of copying way there is no problem as in worst case we can send single
   bytes, but zerocopy is more complex because smallest transmission
   unit is single page. So if there is not enough space at peer's side
   to send integer number of pages (at least one) - we will wait, thus
   stalling tx side. To overcome this problem i've added simple rule -
   zerocopy is possible only when there is enough space at another side
   for whole message (to check, that current 'msghdr' was already used
   in previous tx iterations i use 'iov_offset' field of it's iov iter).

3) loopback transport is not supported, because it requires to implement
   non-linear skb handling in dequeue logic (as we "send" fragged skb
   and "receive" it from the same queue). I'm going to implement it in
   next versions.

   ^^^ fixed in v2

4) Current implementation sets max length of packet to 64KB. IIUC this
   is due to 'kmalloc()' allocated data buffers. I think, in case of
   MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
   not touched for data - user space pages are used as buffers. Also
   this limit trims every message which is > 64KB, thus such messages
   will be send in copy mode due to 'iov_offset' check in 2).

   ^^^ fixed in v2

                         PATCHSET STRUCTURE

Patchset has the following structure:
1) Handle non-linear skbuff on receive in virtio/vhost.
2) Handle non-linear skbuff on send in virtio/vhost.
3) Updates for AF_VSOCK.
4) Enable MSG_ZEROCOPY support on transports.
5) Tests/tools/docs updates.

                            PERFORMANCE

Performance: it is a little bit tricky to compare performance between
copy and zerocopy transmissions. In zerocopy way we need to wait when
user buffers will be released by kernel, so it something like synchronous
path (wait until device driver will process it), while in copy way we
can feed data to kernel as many as we want, don't care about device
driver. So I compared only time which we spend in the 'send()' syscall.
Then if this value will be combined with total number of transmitted
bytes, we can get Gbit/s parameter. Also to avoid tx stalls due to not
enough credit, receiver allocates same amount of space as sender needs.

Sender:
./vsock_perf --sender <CID> --buf-size <buf size> --bytes 256M [--zc]

Receiver:
./vsock_perf --vsk-size 256M

G2H transmission (values are Gbit/s):

*-------------------------------*
|          |         |          |
| buf size |   copy  | zerocopy |
|          |         |          |
*-------------------------------*
|   4KB    |    3    |    10    |
*-------------------------------*
|   32KB   |    9    |    45    |
*-------------------------------*
|   256KB  |    24   |    195   |
*-------------------------------*
|    1M    |    27   |    270   |
*-------------------------------*
|    8M    |    22   |    277   |
*-------------------------------*

H2G:

*-------------------------------*
|          |         |          |
| buf size |   copy  | zerocopy |
|          |         |          |
*-------------------------------*
|   4KB    |    17   |    11    |
*-------------------------------*
|   32KB   |    30   |    66    |
*-------------------------------*
|   256KB  |    38   |    179   |
*-------------------------------*
|    1M    |    38   |    234   |
*-------------------------------*
|    8M    |    28   |    279   |
*-------------------------------*

Loopback:

*-------------------------------*
|          |         |          |
| buf size |   copy  | zerocopy |
|          |         |          |
*-------------------------------*
|   4KB    |    8    |    7     |
*-------------------------------*
|   32KB   |    34   |    42    |
*-------------------------------*
|   256KB  |    43   |    83    |
*-------------------------------*
|    1M    |    40   |    109   |
*-------------------------------*
|    8M    |    40   |    171   |
*-------------------------------*

I suppose that huge difference above between both modes has two reasons:
1) We don't need to copy data.
2) We don't need to allocate buffer for data, only for header.

Zerocopy is faster than classic copy mode, but of course it requires
specific architecture of application due to user pages pinning, buffer
size and alignment.

If host fails to send data with "Cannot allocate memory", check value
/proc/sys/net/core/optmem_max - it is accounted during completion skb
allocation.

                            TESTING

This patchset includes set of tests for MSG_ZEROCOPY feature. I tried to
cover new code as much as possible so there are different cases for
MSG_ZEROCOPY transmissions: with disabled SO_ZEROCOPY and several io
vector types (different sizes, alignments, with unmapped pages). I also
run tests with loopback transport and running vsockmon.

Thanks, Arseniy

Link to v1:
https://lore.kernel.org/netdev/0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru/

Changelog:
v1 -> v2:
 - Replace 'get_user_pages()' with 'pin_user_pages()'.
 - Loopback transport support.

Arseniy Krasnov (15):
  vsock/virtio: prepare for non-linear skb support
  vhost/vsock: non-linear skb handling support
  vsock/virtio: non-linear skb handling support
  vsock/virtio: non-linear skb handling for tap
  vsock/virtio: MSG_ZEROCOPY flag support
  vsock: check error queue to set EPOLLERR
  vsock: read from socket's error queue
  vsock: check for MSG_ZEROCOPY support
  vhost/vsock: support MSG_ZEROCOPY for transport
  vsock/virtio: support MSG_ZEROCOPY for transport
  vsock/loopback: support MSG_ZEROCOPY for transport
  net/sock: enable setting SO_ZEROCOPY for PF_VSOCK
  test/vsock: MSG_ZEROCOPY flag tests
  test/vsock: MSG_ZEROCOPY support for vsock_perf
  docs: net: description of MSG_ZEROCOPY for AF_VSOCK

 Documentation/networking/msg_zerocopy.rst |  12 +-
 drivers/vhost/vsock.c                     |  29 +-
 include/linux/socket.h                    |   1 +
 include/linux/virtio_vsock.h              |   7 +
 include/net/af_vsock.h                    |   3 +
 net/core/sock.c                           |   4 +-
 net/vmw_vsock/af_vsock.c                  |  16 +-
 net/vmw_vsock/virtio_transport.c          |  39 +-
 net/vmw_vsock/virtio_transport_common.c   | 497 ++++++++++++++++++---
 net/vmw_vsock/vsock_loopback.c            |   8 +
 tools/testing/vsock/Makefile              |   2 +-
 tools/testing/vsock/util.h                |   1 +
 tools/testing/vsock/vsock_perf.c          | 139 +++++-
 tools/testing/vsock/vsock_test.c          |  11 +
 tools/testing/vsock/vsock_test_zerocopy.c | 501 ++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  12 +
 16 files changed, 1194 insertions(+), 88 deletions(-)
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h

-- 
2.25.1

