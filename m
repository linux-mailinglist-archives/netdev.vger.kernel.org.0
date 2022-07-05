Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C065671BB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiGEPBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiGEPBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:50 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3725140F8;
        Tue,  5 Jul 2022 08:01:48 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m184so7223333wme.1;
        Tue, 05 Jul 2022 08:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k8doTZH0uHPouLnAYumMUTnWYzvf/OOelwfmnhTubXY=;
        b=W+NStBQLWXIGoemzIBzrNwwIJKixdg/7SZw4ramY1DdU2iAxiXjQAyxromMljbDt/W
         zPUdlwKjwrTygg/Ga4IzdvS4T1I1OAVLieVP/3XgTKYxFc8r4ftk5NXzBR5a8FZ5b7qb
         BrVCz3pdke0YEm5VLaOGZXiS5QCWqYO5VuNhsp19grocOcohizuL254My2DmLMOOOz+K
         ULs0BSJ++2pJ1ayubRTr/QTx3y+i7Q+CmSOxpSP2mkUPPgJYrw6mrdGrK9WODr8XDocQ
         ba27Hl6R/iHf+GXVnFnMXNw78GUNDSxPTn18Lw3m2cgCloxsQAhD2KSSvrHo3vb46jqC
         uBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k8doTZH0uHPouLnAYumMUTnWYzvf/OOelwfmnhTubXY=;
        b=jRcKS3R2DTGW1DAb23VrW4NSRVKTq2QhCrhziDnLbf1lvQvcjMNAr4cj+ISME8XG0u
         q7jercSkS4SvkLV/kM768VTrAUimzjt/MecIfcRBN+BKg0wcvnvTSFs5kGTXedfUm3rP
         /5YESJDktfudpL8FdnMptrRzuWzSJm/uY42eTVH2CwZfuOT7p1+jGwvW5bD6WWuREgiu
         EkAYgA/YveY/v4JKeTDMdXziZ/j/v+DvR0+HGypaK5YA2jF1R2unoxVcXXOTRQKO2bqo
         7LsOYYu6+KoD7NNmoJ2V+qs1zVpzyrNzTSC9ryYgYMwZmzB3k9Dcd5mNIbRknOPJh8Mc
         q2Kw==
X-Gm-Message-State: AJIora/tzpoYGmTVr1G4LwtknuX/EJ5Kd/34I3Srb40/VygtjEcJf1ug
        bWeMgMWhIkuOIoHtJ3KHuz3LQ8um1x5rLQ==
X-Google-Smtp-Source: AGRyM1t9Y9ETUe84X5xEdo61ZYaQg2jaW5+Ym3J5PbSY2MDFmbogOjZM1LEgs210V+KAEhY7hoeQuQ==
X-Received: by 2002:a05:600c:4e49:b0:3a0:4c17:c67f with SMTP id e9-20020a05600c4e4900b003a04c17c67fmr39910449wmq.1.1657033306794;
        Tue, 05 Jul 2022 08:01:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 00/25] io_uring zerocopy send
Date:   Tue,  5 Jul 2022 16:01:00 +0100
Message-Id: <cover.1656318994.git.asml.silence@gmail.com>
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

The patchset implements io_uring zerocopy send. It works with both registered
and normal buffers, mixing is allowed but not recommended. Apart from usual
request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
the userspace when buffers are freed and can be reused (see API design below),
which is delivered into io_uring's Completion Queue. Those "buffer-free"
notifications are not necessarily per request, but the userspace has control
over it and should explicitly attaching a number of requests to a single
notification. The series also adds some internal optimisations when used with
registered buffers like removing page referencing.

From the kernel networking perspective there are two main changes. The first
one is passing ubuf_info into the network layer from io_uring (inside of an
in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
caching on the io_uring side, but also helps to avoid cross-referencing
and synchronisation problems. The second part is an optional optimisation
removing page referencing for requests with registered buffers.

Benchmarking with an optimised version of the selftest (see [1]), which in a
loop sends a bunch of requests and then waits for their completions. "+ flush"
column posts one additional "buffer-free" notification per request, and
just "zc" doesn't post buffer notifications at all.

NIC (requests / second):
IO size | non-zc    | zc             | zc + flush
4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)

dummy (requests / second):
IO size | non-zc    | zc             | zc + flush
8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)

Previously it also brought a massive performance speedup compared to the
msg_zerocopy tool (see [3]), which is probably not super interesting.

There is an additional bunch of refcounting optimisations that was omitted from
the series for simplicity and as they don't change the picture drastically,
they will be sent as follow up, as well as flushing optimisations closing the
performance gap b/w two last columns.

Note: the series is based on net-next + for-5.20/io_uring, but as vanilla
net-next fails for me the repo (see [2]) is on top of for-5.20/io_uring.

Links:

  liburing (benchmark + some tests):
  [1] https://github.com/isilence/liburing/tree/zc_v3

  kernel repo:
  [2] https://github.com/isilence/linux/tree/zc_v3

  RFC v1:
  [3] https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/

  RFC v2:
  https://lore.kernel.org/io-uring/cover.1640029579.git.asml.silence@gmail.com/

API design overview:

  The series introduces an io_uring concept of notifactors. From the userspace
  perspective it's an entity to which it can bind one or more requests and then
  requesting to flush it. Flushing a notifier makes it impossible to attach new
  requests to it, and instructs the notifier to post a completion once all
  requests attached to it are completed and the kernel doesn't need the buffers
  anymore.

  Notifications are stored in notification slots, which should be registered as
  an array in io_uring. Each slot stores only one notifier at any particular
  moment. Flushing removes it from the slot and the slot automatically replaces
  it with a new notifier. All operations with notifiers are done by specifying
  an index of a slot it's currently in.

  When registering a notification the userspace specifies a u64 tag for each
  slot, which will be copied in notification completion entries as
  cqe::user_data. cqe::res is 0 and cqe::flags is equal to wrap around u32
  sequence number counting notifiers of a slot.

Changelog:

  RFC v2 -> v3:
    mem accounting for non-registered buffers
    allow mixing registered and normal requests per notifier
    notification flushing via IORING_OP_RSRC_UPDATE
    TCP support
    fix buffer indexing
    fix io-wq ->uring_lock locking
    fix bugs when mixing with MSG_ZEROCOPY
    fix managed refs bugs in skbuff.c

  RFC -> RFC v2:
    remove additional overhead for non-zc from skb_release_data()
    avoid msg propagation, hide extra bits of non-zc overhead
    task_work based "buffer free" notifications
    improve io_uring's notification refcounting
    added 5/19, (no pfmemalloc tracking)
    added 8/19 and 9/19 preventing small copies with zc
    misc small changes

Pavel Begunkov (25):
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
  io_uring: add zc notification infrastructure
  io_uring: export task put
  io_uring: cache struct io_notif
  io_uring: complete notifiers in tw
  io_uring: add notification slot registration
  io_uring: wire send zc request type
  io_uring: account locked pages for non-fixed zc
  io_uring: allow to pass addr into sendzc
  io_uring: add rsrc referencing for notifiers
  io_uring: sendzc with fixed buffers
  io_uring: flush notifiers after sendzc
  io_uring: rename IORING_OP_FILES_UPDATE
  io_uring: add zc notification flush requests
  selftests/io_uring: test zerocopy send

 include/linux/io_uring_types.h                |  37 ++
 include/linux/skbuff.h                        |  59 +-
 include/linux/socket.h                        |   7 +
 include/uapi/linux/io_uring.h                 |  43 +-
 io_uring/Makefile                             |   2 +-
 io_uring/io_uring.c                           |  40 +-
 io_uring/io_uring.h                           |  21 +
 io_uring/net.c                                | 134 ++++
 io_uring/net.h                                |   4 +
 io_uring/notif.c                              | 215 +++++++
 io_uring/notif.h                              |  87 +++
 io_uring/opdef.c                              |  24 +-
 io_uring/rsrc.c                               |  55 +-
 io_uring/rsrc.h                               |  16 +-
 io_uring/tctx.h                               |  26 -
 net/compat.c                                  |   2 +
 net/core/datagram.c                           |  53 +-
 net/core/skbuff.c                             |  35 +-
 net/ipv4/ip_output.c                          |  63 +-
 net/ipv4/tcp.c                                |  52 +-
 net/ipv6/ip6_output.c                         |  62 +-
 net/socket.c                                  |   6 +
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
 .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
 25 files changed, 1652 insertions(+), 128 deletions(-)
 create mode 100644 io_uring/notif.c
 create mode 100644 io_uring/notif.h
 create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
 create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh

-- 
2.36.1

