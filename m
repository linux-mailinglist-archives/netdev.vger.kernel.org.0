Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2A34639C3
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245194AbhK3PX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245054AbhK3PX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0D6C061375;
        Tue, 30 Nov 2021 07:19:19 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d24so45283310wra.0;
        Tue, 30 Nov 2021 07:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xyNcpqxcIBBNZJQ9OcGvMY0NcQfvE16HAkocAw8GQTE=;
        b=QTujXjit+MlFkHiJKOfEXVYlvgYo9CSoXvzuCein02qKaQavN+gvUUKj9uQc9ynAtT
         eNR6xBUgKr7KbceD80X0jzawZO0a7RodXAm4VLfmDMen+4hlsORK4yIMoQXuNBHv9/HS
         MVc3d4XXWfoHXI2D7K+8SywMgvSwT9jAdGnnx3YIGPygWKAgb3lnVscDlQcfjMpoDVIC
         uAzMfUwoqReq7vm5YdLWUME4rP4yQJmFb1/VvVxnWxIi3n1A1pByRFNpHkCRu+Mjs8qz
         gX7/YGwtRD3vGRBCB9ASkzo4nVTiTJy9wWxer7LYWfvDV+2PqbnQt/Z+kEygV+vvLVrr
         7MqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xyNcpqxcIBBNZJQ9OcGvMY0NcQfvE16HAkocAw8GQTE=;
        b=v5MK48f55CwRjg4NVIMDetzOnd0UjpR8mfXIKesneAe9apmmlOG9p91A6vLHfsAa8o
         Zc4QJ8dxlWkoYE+PjHpPYuw0N6ThoZHw5Yn9jNerGQUNiHgKpwzr4FbNfbhdwgyaoCDo
         S2zGB8jBzQIi76Mp9jcS45yjMSN6how0N/CcrfYcHjiq6Pjg98gvep4wxyQDAEPDLfcg
         Ehc9hWzOFVdqYk5rNM36Pbzj3jg9A1j6bhRgmH3IibV1RYPMP0YVMgYLJroevezn5i4L
         jqfuGDI2VBt9GHb8ZS9oWB8gyKWnYDt68UyVnCFgqCoyWXca6LTmNRRcvgoNrgBJ1/L8
         JkLQ==
X-Gm-Message-State: AOAM533AKrBPq0MHfVsGOLVLwdByozLODEa84/RTlXi90NTh3KanwZ7g
        P8DEEbaHTD3ZPcPX1U3Pj3AxB5y3K5I=
X-Google-Smtp-Source: ABdhPJw+r1T8O0TgAUQ4SiiUmL95Nc1MPH1cEBwNrha5H8w+EdjC644VghcD0gH58OlGyv559uR+eg==
X-Received: by 2002:adf:a404:: with SMTP id d4mr42045080wra.556.1638285557933;
        Tue, 30 Nov 2021 07:19:17 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 00/12] io_uring zerocopy send
Date:   Tue, 30 Nov 2021 15:18:48 +0000
Message-Id: <cover.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Early proof of concept for zerocopy send via io_uring. This is just
an RFC, there are details yet to be figured out, but hope to gather
some feedback.

Benchmarking udp (65435 bytes) with a dummy net device (mtu=0xffff):
The best case io_uring=116079 MB/s vs msg_zerocopy=47421 MB/s,
or 2.44 times faster.

№ | test:                                | BW (MB/s)  | speedup
1 | msg_zerocopy (non-zc)                |  18281     | 0.38
2 | msg_zerocopy -z (baseline)           |  47421     | 1
3 | io_uring (@flush=false, nr_reqs=1)   |  96534     | 2.03
4 | io_uring (@flush=true,  nr_reqs=1)   |  89310     | 1.88
5 | io_uring (@flush=false, nr_reqs=8)   | 116079     | 2.44
6 | io_uring (@flush=true,  nr_reqs=8)   | 109722     | 2.31

Based on selftests/.../msg_zerocopy but more limited. You can use
msg_zerocopy -r as usual for receive side.

@nr_reqs controls how many io_uring requests we submit per syscall, e.g.
nr_reqs=1 avoids any io_uring batching, which is wasteful.
@flush controls whether to generate "buffer not used" event per request
or not at all. The API and implementation is more flexible, e.g. allows
to have one notification per N requests, but not added to the benchmark.

It's ipv4/udp only for now. The concept works well with tcp as well, but
omitted patches for now.

# design

The userspace design is briefly outlined in the message to 06/12. In
short, it allows to attach several io_uring send requests to one of
pre-registered notification contexts, and the userspace can "flush"
a notification from that context making it to post an event into
the io_uring's completion queue when buffers are no more in use.

From the net perspective, as ubuf_info's are controlled by io_uring, we
need a way to pass it from outside, which is currently done through a
new struct msghdr::msg_ubuf field.

Note: one great aspect ubufs being controlled from outside is that
it doesn't matter whether the net actually uses the ubuf or not, the
userspace gets the same API in terms of events delivery: it'll get
that additional event about buffers even it wasn't zerocopy.

Another big part is 5/12, which allows to skip get/put_page() for
io_uring's fixed buffers. io_uring ensures that the pages stay alive
until the corresponding ubuf_info is released.

# performance:

The worst case for io_uring is (4), still 1.88 times faster than
msg_zerocopy (2), and there are a couple of "easy" optimisations left
out from the patchset. For 4096 bytes payload zc is only slightly
outperforms non-zc version, the larger payload the wider gap.
I'll get more numbers next time.

Comparing (3) and (4), and (5) vs (6), @flush doesn't affect it too
much. Notification posting is not a big problem for now, but need
to compare the performance for when io_uring_tx_zerocopy_callback()
is called from IRQ context, and possible rework it to use task_work.

It supports both, regular buffers and fixed ones, but there is a bunch of
optimisations exclusively for io_uring's fixed buffers. For comparison,
normal vs fixed buffers (@nr_reqs=8, @flush=0): 75677 vs 116079 MB/s

1) we pass a bvec, so no page table walks.
2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
   still doing page get/put (see 4/12) slashed 4-5%.
3) avoiding get_page/put_page in 5/12
4) completion events are posted into io_uring's CQ, so no
   extra recvmsg for getting events
5) no poll(2) in the code because of io_uring
6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
   io_uring caches the structures reducing it to nearly zero-overhead.

io_uring adds some overhead but there are also benefits of using it,
e.g. fixed files and submission batching (@nr_reqs). We can look at
@nr_reqs=1 test cases for more of a "net-only" optimisations.

# discussion / questions

I haven't got a grasp on many aspects of the net stack yet, so would
appreciate feedback in general and there are a couple of questions
thoughts.

1) What are initialisation rules for adding a new field into
struct mshdr? E.g. many users (mainly LLD) hand code initialisation not
filling all the fields.

2) I don't like too much ubuf_info propagation from udp_sendmsg() into
__ip_append_data() (see 3/12). Ideas how to do it better?

3) 5/12 is a quick'n'dirty patch for letting upper layer to manage page
references but likely needs more work. One problem is to prevent mixing
such pages managed by upper layer and normal referenced ones, that's
what SKBFL_MANAGED_FRAGS is about and many chunk trying to make the
accounting of it right. Any pitfalls I missed? Would really love some
ideas and advice here, e.g. how to make it cleaner and/or remove
overhead from non-zc path.

# references

Kernel git branch for convenience:
https://github.com/isilence/linux.git zc_v1

Benchmark:
https://github.com/isilence/liburing.git zc_v1

or this file in particular:
https://github.com/isilence/liburing/blob/zc_v1/test/send-zc.c

To run the benchmark:
```
cd <liburing_dir> && make && cd test
# ./send-zc -4 [-p <port>] [-s <payload_size>] -D <destination> udp
./send-zc -4 -D 127.0.0.1 udp
```

msg_zerocopy can be used for the server side, e.g.
```
cd <linux-kernel>/tools/testing/selftests/net && make
./msg_zerocopy -4 -r [-p <port>] [-t <sec>] udp
```

Pavel Begunkov (12):
  skbuff: add SKBFL_DONT_ORPHAN flag
  skbuff: pass a struct ubuf_info in msghdr
  net/udp: add support msgdr::msg_ubuf
  net: add zerocopy_sg_from_iter for bvec
  net: optimise page get/free for bvec zc
  io_uring: add send notifiers registration
  io_uring: infrastructure for send zc notifications
  io_uring: wire send zc request type
  io_uring: add an option to flush zc notifications
  io_uring: opcode independent fixed buf import
  io_uring: sendzc with fixed buffers
  io_uring: cache struct ubuf_info

 fs/io_uring.c                 | 397 +++++++++++++++++++++++++++++++++-
 include/linux/skbuff.h        |  15 +-
 include/linux/socket.h        |   1 +
 include/net/ip.h              |   3 +-
 include/uapi/linux/io_uring.h |  14 ++
 net/compat.c                  |   1 +
 net/core/datagram.c           |  59 +++++
 net/core/skbuff.c             |  18 +-
 net/ipv4/ip_output.c          |  35 ++-
 net/ipv4/udp.c                |   2 +-
 net/socket.c                  |   3 +
 11 files changed, 521 insertions(+), 27 deletions(-)

-- 
2.34.0

