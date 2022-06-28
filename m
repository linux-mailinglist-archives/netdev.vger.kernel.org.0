Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A9555ED22
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiF1TAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiF1TAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:14 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A672764A;
        Tue, 28 Jun 2022 11:59:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z7so18862477edm.13;
        Tue, 28 Jun 2022 11:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5svx5LwjLEEoN4gETD1VRjFETGWrIKeBab47sR6QxQ=;
        b=gBsgfrXhzDpMZG/uB1HEIAh8ul/REXioVN/FTh/1X2T4t2y7Ht43pNoarj1FLNOYRG
         9oknH/ocoEsmauWwT93Nqe49Y3WtPlTCPCj0fsHOelyplkHXOj1W/8zL6ORteF3MYTx5
         UwM3b/JO1GeySOonAuQgNw8yXDw6SdBdpAi6Zici3spAd/q6C104xQCtiniWuk2/5hYl
         lHZUdweAKbXKhvEz9rlUFIOJId4i1un1RXbyAmhOOxl3P5A9KQ0TrV974dp94W5CPRac
         2aOimt2FSTltpNNcnuyNIpGTkspG8V0xpUb8vxkgThCIgSSNKpI8dGGOqxhlDPjV9yD6
         LQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5svx5LwjLEEoN4gETD1VRjFETGWrIKeBab47sR6QxQ=;
        b=H1oCMOMJqzw0IdtK5M6ZS0yRDRhwbef24rXOY7078GFKfrt8olVh/uT6R0mnRDi7ng
         yh00FIe2GHDTfamdLPq94l18QKAtgbf9V0YZcqLp0fSIFfsNYK6fz82xV8bg1xhXF7u8
         IsIxssmLQ4hp1Bhlr6FfOffQFuvvp7wRAXWC+8ng2eOsRMErZCxSaq5AM4yRXUafAjyY
         Sr/RNPBMvbOavoA4o9zv8o/fadR0pUPwJX9Lmy9a8QBljpMu+ekPIZ3X4XNgI2660EKp
         bD2pmceMsB+b/KvS+lAWnUZ6TJRZ8mzfEh6FZgjS24BZGA9upcHEH7bxLWgcZjfUgAam
         2f7g==
X-Gm-Message-State: AJIora+P/727QXGVty2ZTASFL0hYtpdncCXar2UdDaVeX5yNSGaVB/XP
        f2dn6GRGpkIDEwybfX2INBR9BTkzCXluMA==
X-Google-Smtp-Source: AGRyM1vS7ZvW2V/yomp7fG86RmudHB9XbPpcXCZSGU4ezs3/2UisA33JqF1qB8Ns+EVE/6Wi9lTbpA==
X-Received: by 2002:a05:6402:e83:b0:435:a9bd:8134 with SMTP id h3-20020a0564020e8300b00435a9bd8134mr24664533eda.243.1656442792470;
        Tue, 28 Jun 2022 11:59:52 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:59:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 00/29] io_uring zerocopy send
Date:   Tue, 28 Jun 2022 19:56:22 +0100
Message-Id: <cover.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The third iteration of patches for zerocopy io_uring sends. I fixed
all known issues since the previous version and reshuffled io_uring
patches, but the net/ code didn't change much. I think it's ready
and will send it as a non-RFC soon.

All tests below are done using io_uring with all relevant performance
options turned on. Numbers look good, send + flush per request, which
is the worst case, is on par with non-zerocopy with the payload size
lower than 600 bytes with dummy netdev and b/w 1200-1500 for NIC tests.
Without "buffer-free" notification flushing at all it's on par with NIC
at around 600 bytes.

dummy:
IO size | non-zc (tx/s) | zc (tx/s)      | zc + flush (tx/s)
8000    | 1299916       | 2396600 (+84%) | 2224219 (+71%)
4000    | 1869230       | 2344146 (+25%) | 2170069 (+16%)
1200    | 2071617       | 2361960 (+14%) | 2203052 (+6%)
600     | 2106794       | 2381527 (+13%) | 2195295 (+4%)

NIC:
IO size | non-zc (tx/s) | zc (tx/s)      | zc + flush (tx/s)
4000    | 495134        | 606420 (+22%)  | 558971 (+12%)
1500    | 551808        | 577116 (+4.5%) | 565803 (+2.5%)
1000    | 584677        | 592088 (+1.2%) | 560885 (-4%)
600     | 596292        | 598550 (+0.4%) | 555366 (-6.7%)

Apart from zerocopy, it also removes page referencing for reigstered
buffers (used in all zc tests). I'm experimenting with notificaiton
optimsation, which should improve the 3rd column, but that will go
separately from this series. I've also seen good CPU usage reduction
for TCP comparing to non-zc, but not posting numbers as had problems
saturating CPU.

Links:

  RFC v1:
  https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/

  RFC v2:
  https://lore.kernel.org/io-uring/cover.1640029579.git.asml.silence@gmail.com/

  liburing (copy of the benchmark + some tests):
  https://github.com/isilence/liburing/tree/zc_v3

  kernel repo:
  https://github.com/isilence/linux/tree/zc_v3

API design overview:

  First we take an internal zerocopy handler, aka struct ubuf_info, and let
  io_uring to pass it into the network layer in struct msghdr. io_uring
  stores them as wrapping into struct io_notif.

  It also has an array of so called notification slots, each keeps one and
  only one active notifier at a time, to which the userspace can bind requests
  by specifying the slot index. Then the userspace can request to flush a
  notifier, so when all buffers and requests used with this notifier
  complete/freed it'll post one CQE.

  The userspace can't bind new requests to a flushed notifier, however,
  it can use the slot as flushing automatically replaces the notifier with
  a new one.

Changelog:

  RFC v2 -> RFC v3:
    TCP support
    accounting for normal (non-registered) buffers
    allow to combine reg and normal requests within a notifier
    notification flushing via IORING_OP_RSRC_UPDATE
    overriding io_uring notification tag/user_data
    add ubuf_info submmision side reference caching/batching
    fix buffer indexing
    fix io-wq ->uring_lock locking
    fix bugs when mixing with MSG_ZEROCOPY
    fix managed refs bugs in skbuff.c
    numerous cleanups

  RFC -> RFC v2:
    remove additional overhead for non-zc from skb_release_data()
    avoid msg propagation, hide extra bits of non-zc overhead
    task_work based "buffer free" notifications
    improve io_uring's notification refcounting
    added 5/19, (no pfmemalloc tracking)
    added 8/19 and 9/19 preventing small copies with zc
    misc small changes

Pavel Begunkov (29):
  ipv4: avoid partial copy for zc
  ipv6: avoid partial copy for zc
  skbuff: add SKBFL_DONT_ORPHAN flag
  skbuff: carry external ubuf_info in msghdr
  net: bvec specific path in zerocopy_sg_from_iter
  net: optimise bvec-based zc page referencing
  net: don't track pfmemalloc for managed frags
  skbuff: don't mix ubuf_info of different types
  ipv4/udp: support zc with managed data
  ipv6/udp: support zc with managed data
  tcp: support zc with managed data
  tcp: kill extra io_uring's uarg refcounting
  net: let callers provide extra ubuf_info refs
  io_uring: opcode independent fixed buf import
  io_uring: add zc notification infrastructure
  io_uring: cache struct io_notif
  io_uring: complete notifiers in tw
  io_uring: add notification slot registration
  io_uring: rename IORING_OP_FILES_UPDATE
  io_uring: add zc notification flush requests
  io_uring: wire send zc request type
  io_uring: account locked pages for non-fixed zc
  io_uring: allow to pass addr into sendzc
  io_uring: add rsrc referencing for notifiers
  io_uring: sendzc with fixed buffers
  io_uring: flush notifiers after sendzc
  io_uring: allow to override zc tag on flush
  io_uring: batch submission notif referencing
  selftests/io_uring: test zerocopy send

 fs/io_uring.c                                 | 566 +++++++++++++++-
 include/linux/skbuff.h                        |  59 +-
 include/linux/socket.h                        |   8 +
 include/uapi/linux/io_uring.h                 |  43 +-
 net/compat.c                                  |   2 +
 net/core/datagram.c                           |  53 +-
 net/core/skbuff.c                             |  35 +-
 net/ipv4/ip_output.c                          |  66 +-
 net/ipv4/tcp.c                                |  56 +-
 net/ipv6/ip6_output.c                         |  65 +-
 net/socket.c                                  |   6 +
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
 .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
 14 files changed, 1613 insertions(+), 83 deletions(-)
 create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
 create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh

-- 
2.36.1

