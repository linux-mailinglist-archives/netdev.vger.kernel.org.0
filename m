Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360F047C2E2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbhLUPfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbhLUPfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:35:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE7DC061574;
        Tue, 21 Dec 2021 07:35:53 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id e5so27695276wrc.5;
        Tue, 21 Dec 2021 07:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yc56LLfXK6SYtMIN4zcrimz/IY8lh9/epsMY2SVJP4w=;
        b=jNDG0OsRpy+KIkvl4S0uzuIzyXZWtlTzbZ52XviZymSrXjzak1kxnRLBvxEvL8zJfT
         YKMTBk/8e5BC0snq3n+H69CJuB683lkndx6D3M/4wiII2QlinjYxKDXe5MWRcf43ZgU0
         xFT5Mn6K6qY5yCrCmNUt6vO/jPrL8zmkA29rqqzDZi3/U1nExpMj6pD3q+z0HZ1eQe6V
         TxDdqHW8Ych7tq9rwFvEUufhpvJLyTl3uZVHpn78UFN6QduLndkkGeXqkuymbNEPARJT
         wWHvaJeEYCSEBINFJIA8587dAVtHQvQ17Gt7fKqdwmB7jeLIb4z+6Xnkb5o5u7EVL9bx
         H6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yc56LLfXK6SYtMIN4zcrimz/IY8lh9/epsMY2SVJP4w=;
        b=nr+1m6eS7GKkBugjvxHM1b1vF5tn7AW9gwPyO2Ilq2XZAOhImNVvrAdZ8iDNovK9ub
         Rrb+wh+tB9BRdhv6M6gen7IPHDpzeNIVs93V0Q7iUr2NLdgNCMtUu/kzgEpxRt7moHn8
         KTMEnOWtx3iP216FovyqFx4y25LRxqCebMm/dubZynhVig5hLfCVLVIANrRkWZXUErw4
         iKZ54fKFWjD4Ma1gskV7x+r+oPnMYvDq36mqW6iKKL/ZrBPCkGrYqPYD+VCAl+KzvS4O
         bbmHjnEpb3ADTVh0el6PbkUyqDEXyvPwkKQX8W60WvLZSdQkMzlM0x+vAEueNoK10sxk
         NeTw==
X-Gm-Message-State: AOAM530KmURgS9qrl/h6OAfwIffNYoZ7oLrY0Eqj5oGtBq90BOkoA+fA
        X8z0z9vGmTK1p2zfuGHeok5eGMPmdHU=
X-Google-Smtp-Source: ABdhPJwx+J/hSTikbl8ZWQrnGgLilkieScBUVKA3zN780q75A91P/vA6O+3m3Hx5PNm00hmqR/yCQw==
X-Received: by 2002:a5d:66d2:: with SMTP id k18mr3136399wrw.430.1640100951867;
        Tue, 21 Dec 2021 07:35:51 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 00/19] io_uring zerocopy tx
Date:   Tue, 21 Dec 2021 15:35:22 +0000
Message-Id: <cover.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update on io_uring zerocopy tx, still RFC. For v1 and design notes see

https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/

Absolute numbers (against dummy) got higher since v1, + ~10-12% requests/s for
the peak performance case. 5/19 brought a couple of percents, but most of it
came with 8/19 and 9/19 (+8-11% in numbers, 5-7% in profiles). It will also
be needed in the future for p2p. Any reason not to do alike for paged non-zc?
Small (under 100-150B) packets?

Most of checks are removed from non-zc paths. Implemented a bit trickier in
__ip_append_data(), but considering already existing assumptions around "from"
argument it should be fine.

Benchmarks for dummy netdev, UDP/IPv4, payload size=4096:
 -n<N> is how many requests we submit per syscall. From io_uring perspective -n1
       is wasteful and far from optimal, but included for comparison.
 -z0   disables zerocopy, just normal io_uring send requests
 -f    makes to flush "buffer free" notifications for every request

                        | K reqs/s | speedup
msg_zerocopy (non-zc)   | 1120     | 1.12
msg_zerocopy (zc)       | 997      | 1
io_uring -n1 -z0        | 1469     | 1.47
io_uring -n8 -z0        | 1780     | 1.78
io_uring -n1 -f         | 1688     | 1.69
io_uring -n1            | 1774     | 1.77
io_uring -n8 -f         | 2075     | 2.08
io_uring -n8            | 2265     | 2.27

note: it might be not too interesting to compare zc vs non-zc, the performance
relative difference can be shifted in favour of zerocopy by cutting constant
per-request overhead, and there are easy ways of doing that, e.g. by compiling
out unused features. Even more true for the table below as there was additional
noise taking a good quarter of CPU cycles.

Some data for UDP/IPv6 between a pair of NICs. 9/19 wasn't there at the time of
testing. All tests are CPU bound and so as expected reqs/s for zerocopy doesn't
vary much between different payload sizes. io_uring to msg_zerocopy ratio is not
too representative for reasons similar to described above.

payload | test                   | K reqs/s
___________________________________________ 
 8192   | io_uring -n8 (dummy)   | 599
        | io_uring -n1 -z0       | 264
        | io_uring -n8 -z0       | 302
        | msg_zerocopy           | 248
        | msg_zerocopy -z        | 183
        | io_uring -n1 -f        | 306
        | io_uring -n1           | 318
        | io_uring -n8 -f        | 373
        | io_uring -n8           | 401

 4096   | io_uring -n8 (dummy)   | 601
        | io_uring -n1 -z0       | 303
        | io_uring -n8 -z0       | 366
        | msg_zerocopy           | 278
        | msg_zerocopy -z        | 187
        | io_uring -n1 -f        | 317
        | io_uring -n1           | 325
        | io_uring -n8 -f        | 387
        | io_uring -n8           | 405

 1024   | io_uring -n8 (dummy)   | 601
        | io_uring -n1 -z0       | 329
        | io_uring -n8 -z0       | 407
        | msg_zerocopy           | 301
        | msg_zerocopy -z        | 186
        | io_uring -n1 -f        | 317
        | io_uring -n1           | 327
        | io_uring -n8 -f        | 390
        | io_uring -n8           | 403

 512    | io_uring -n8 (dummy)   | 601
        | io_uring -n1 -z0       | 340
        | io_uring -n8 -z0       | 417
        | msg_zerocopy           | 310
        | msg_zerocopy -z        | 186
        | io_uring -n1 -f        | 317
        | io_uring -n1           | 328
        | io_uring -n8 -f        | 392
        | io_uring -n8           | 406

 128    | io_uring -n8 (dummy)   | 602
        | io_uring -n1 -z0       | 341
        | io_uring -n8 -z0       | 428
        | msg_zerocopy           | 317
        | msg_zerocopy -z        | 188
        | io_uring -n1 -f        | 318
        | io_uring -n1           | 331
        | io_uring -n8 -f        | 391
        | io_uring -n8           | 408

https://github.com/isilence/linux/tree/zc_v2
https://github.com/isilence/liburing/tree/zc_v2

The Benchmark is <liburing>/test/send-zc,

send-zc [-f] [-n<N>] [-z0] -s<payload size> -D<dst ip> (-6|-4) [-t<sec>] udp

As a server you can use msg_zerocopy from in kernel's selftests, or a copy of
it at <liburing>/test/msg_zerocopy. No server is needed for dummy testing.

dummy setup:
sudo ip li add dummy0 type dummy && sudo ip li set dummy0 up mtu 65536
# make traffic for the specified IP to go through dummy0
sudo ip route add <ip_address> dev dummy0

v2: remove additional overhead for non-zc from skb_release_data() (Jonathan)
    avoid msg propagation, hide extra bits of non-zc overhead
    task_work based "buffer free" notifications
    improve io_uring's notification refcounting
    added 5/19, (no pfmemalloc tracking)
    added 8/19 and 9/19 preventing small copies with zc
    misc small changes

Pavel Begunkov (19):
  skbuff: add SKBFL_DONT_ORPHAN flag
  skbuff: pass a struct ubuf_info in msghdr
  net: add zerocopy_sg_from_iter for bvec
  net: optimise page get/free for bvec zc
  net: don't track pfmemalloc for zc registered mem
  ipv4/udp: add support msgdr::msg_ubuf
  ipv6/udp: add support msgdr::msg_ubuf
  ipv4: avoid partial copy for zc
  ipv6: avoid partial copy for zc
  io_uring: add send notifiers registration
  io_uring: infrastructure for send zc notifications
  io_uring: wire send zc request type
  io_uring: add an option to flush zc notifications
  io_uring: opcode independent fixed buf import
  io_uring: sendzc with fixed buffers
  io_uring: cache struct ubuf_info
  io_uring: unclog ctx refs waiting with zc notifiers
  io_uring: task_work for notification delivery
  io_uring: optimise task referencing by notifiers

 fs/io_uring.c                 | 440 +++++++++++++++++++++++++++++++++-
 include/linux/skbuff.h        |  46 ++--
 include/linux/socket.h        |   1 +
 include/uapi/linux/io_uring.h |  14 ++
 net/compat.c                  |   1 +
 net/core/datagram.c           |  58 +++++
 net/core/skbuff.c             |  16 +-
 net/ipv4/ip_output.c          |  55 +++--
 net/ipv6/ip6_output.c         |  54 ++++-
 net/socket.c                  |   3 +
 10 files changed, 633 insertions(+), 55 deletions(-)

-- 
2.34.1

