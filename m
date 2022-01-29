Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE8E4A2F9C
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 14:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344938AbiA2NDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 08:03:23 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:49182
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S245328AbiA2NDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 08:03:22 -0500
Received: from integral2.. (unknown [36.81.38.25])
        by gnuweeb.org (Postfix) with ESMTPSA id 9B4D9C32BA;
        Sat, 29 Jan 2022 13:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1643461399;
        bh=esyoix7dI6V5J0buSuffpV0/NwoGCHX9L6wXtIYgymQ=;
        h=From:To:Cc:Subject:Date:From;
        b=j8ooXZG8ZT3Ob+s6o8ME5fl1wRf0G93PgaPT33QSHi9KnujyXkGt7NvysPATJgHwk
         1oEKtS7m7TH9pf+0rl9nJUc/hVBEXYlEzp0Vfx+2UhsMffW+CrJ2QWGmeYXt5fs3a5
         RUnyduPd6usV2Ws24w4hSVdjLT6aqICaVjeEE/4/wKrK8n+KK6/55B6ao96dezSPJ5
         rD9D3YbFVPOY9emu+dnCJnH9cma7gLkgyVqVF8N1W40EERdQ8oGk1kNo+FprWT0lFP
         L+GsXxbkvG5uHkksbtKJfA2420S/pumE4tB4P+36TB5/CRp4CaZLijo0Tqa7VXwPg8
         MdxkVitshXrrA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Nugra <richiisei@gmail.com>,
        Praveen Kumar <kpraveen.lkml@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Subject: [PATCH for-5.18 v1 0/3] Add `sendto(2)` and `recvfrom(2)` support
Date:   Sat, 29 Jan 2022 19:50:18 +0700
Message-Id: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This patchset adds sendto(2) and recvfrom(2) support for io_uring. It
also addresses an issue in the liburing GitHub repository [1].

## Motivations:

1) By using `sendto()` and `recvfrom()` we can make the submission
   simpler compared to always using `sendmsg()` and `recvmsg()` from
   the userspace. Especially for UDP socket.

2) There is a historical patch that tried to add the same
   functionality, but did not end up being applied. [2]

On Tue, 7 Jul 2020 12:29:18 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> In a private conversation with the author, a good point was brought
> up that the sendto/recvfrom do not require an allocation of an async
> context, if we need to defer or go async with the request. I think
> that's a major win, to be honest. There are other benefits as well
> (like shorter path), but to me, the async less part is nice and will
> reduce overhead

## Changes summary:

1)  Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
    _____________________________________________________
    The following call
    
        send(sockfd, buf, len, flags);
    
    is equivalent to
    
        sendto(sockfd, buf, len, flags, NULL, 0);
    _____________________________________________________
    The following call
    
        recv(sockfd, buf, len, flags);
    
    is equivalent to
    
        recvfrom(sockfd, buf, len, flags, NULL, NULL);
    _____________________________________________________

    Currently, io_uring supports send() and recv() operation. Now, we are
    going to add sendto() and recvfrom() support. Since the latter is the
    superset of the former, change the function name to the latter.

2)  Make `move_addr_to_user()` be a non static function. This is required for
    adding recvfrom() support for io_uring.

3)  Add `sendto(2)` and `recvfrom(2)` support.

    New opcodes:
      - IORING_OP_SENDTO
      - IORING_OP_RECVFROM

## How to apply

This work is based on Jens' tree, branch "io-uring-5.17".

The following changes since commit f6133fbd373811066c8441737e65f384c8f31974:

  io_uring: remove unused argument from io_rsrc_node_alloc (2022-01-27 10:18:53 -0700)

are available in the Git repository at:

  git://github.com/ammarfaizi2/linux-block.git tags/io_uring-sendto-recvfrom.v1

for you to fetch changes up to 68d110c39241b887ec388cd3316dbedb85b0cbcf:

  io_uring: Add `sendto(2)` and `recvfrom(2)` support (2022-01-29 13:08:13 +0700)
```
----------------------------------------------------------------
io_uring-sendto-recvfrom.v1

----------------------------------------------------------------
```
## liburing support and test program:

  git://github.com/ammarfaizi2/liburing.git tags/sendto-recvfrom.v1-2022-01-29

  Run the test program from liburing:
```
    ./configure;
    make -j$(nproc);
    test/sendto_recvfrom;
    echo $?;
```
## Changelog:

v1:
    - Rebase the work (sync with "io_uring-5.17" branch in Jens' tree).
    - Add BUILD_BUG_SQE_ELEM(48, __u64,  addr3); for compile time
      assertion.
    - Reword the commit messages.
    - Add Alviro Iskandar Setiawan to CC list (tester).

RFC v4:
    - Rebase the work (sync with "for-next" branch in Jens' tree).
    - Remove Tested-by tag from Nugra as this patch changes.
    - (Address Praveen's comment) Zero `sendto_addr_len` and
      `recvfrom_addr_len` on prep when the `req->opcode` is not
      `IORING_OP_{SENDTO,RECVFROM}`.

RFC v3:
    - Fix build error when CONFIG_NET is undefined for PATCH 1/3. I
      tried to fix it in PATCH 3/3, but it should be fixed in PATCH 1/3,
      otherwise it breaks the build in PATCH 1/3.
    - Add `io_uring_prep_{sendto,recvfrom}` docs to the liburing.

RFC v2:
    - Rebase the work, now this patchset is based on commit
      bb3294e22482db4b7ec ("Merge branch 'for-5.17/drivers' into
      for-next").
    - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
      call as unlikely.
    - Fix build error when CONFIG_NET is undefined.
    - Update liburing test (the branch is still the same, just force
      pushed).
    - Add Nugra to CC list (tester).

## Refs
[1]: https://github.com/axboe/liburing/issues/397
[2]: https://lore.kernel.org/io-uring/a2399c89-2c45-375c-7395-b5caf556ec3d@kernel.dk/

---
RFC v4: https://lore.kernel.org/io-uring/20220107000006.1194026-1-ammarfaizi2@gnuweeb.org/
RFC v3: https://lore.kernel.org/io-uring/20211230114846.137954-1-ammar.faizi@intel.com/
RFC v2: https://lore.kernel.org/io-uring/20211230114846.137954-1-ammar.faizi@intel.com/
RFC v1: https://lore.kernel.org/io-uring/20211230013154.102910-1-ammar.faizi@intel.com/
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Ammar Faizi (3):
  io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
  net: Make `move_addr_to_user()` be a non static function
  io_uring: Add `sendto(2)` and `recvfrom(2)` support

 fs/io_uring.c                 | 95 +++++++++++++++++++++++++++++++----
 include/linux/socket.h        |  2 +
 include/uapi/linux/io_uring.h |  5 +-
 net/socket.c                  |  4 +-
 4 files changed, 93 insertions(+), 13 deletions(-)


base-commit: f6133fbd373811066c8441737e65f384c8f31974
-- 
Ammar Faizi
