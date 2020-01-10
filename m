Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB22136B4D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgAJKuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34071 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbgAJKub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so1370136wrr.1
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IjThV9OS0Wopmdl3TAa4LjOlOjIBPkiMjuaQhWbmimQ=;
        b=fNCdagR42tt9NqWoAbZtBAyCEfw+3CAp5OSg02NWSlmikpSQjlugLenW0u0VixSqXO
         Zh9LRB61BRBRwtscmEh9u7WRf9Z77Q72PWG7+Hk0gBehfgaeotnLW30NggXw7OHbkC8O
         SntM8fRjIzjUxJgbecU1Fv4H9hMhnYVcbETBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IjThV9OS0Wopmdl3TAa4LjOlOjIBPkiMjuaQhWbmimQ=;
        b=VW+PHnybukS8gv/LPIf3bn6p+6fMV9q4d5f8J2+vUJ02xPVUXude4JOvq8bX/UY2xJ
         MWiK5DZFW31bdopctFq9O6xXhQX0K5xx+Y5i4TDUSEen++UvHzJyt38r/nrw7qwihV8U
         4p38z047aCG0nPRt6tLMQ9Aj9pT2DVACYQunwiZ2rTbDRrBu9CcXyJU7cP9ngOCxz62C
         5/xXyhmXxhNpTkEYJi8XHLMUDkV120Q6AQzegpq8IZvqHXCOyunAPj1iBOe4+hok5Z/h
         N/Rr4pU7zu1xAYHhPYXvmSXJs8nsCU7gRTg4VeVhN4laKfnK/3+DSknq5tGh4flTPB8c
         4abw==
X-Gm-Message-State: APjAAAUeCMW4zMErn9UO6628PTsreXlmY3TvbChkoIVfxTMj7YAGYMVX
        pXCHtzWZSRc52RRUQthu+3HDDA==
X-Google-Smtp-Source: APXvYqxwfnZPV7yT8UvTaHriAV6/7en6RTmG44bOkm/nVicbELbbWe/hdl0M1rJQzJagOdQXUyb6Jg==
X-Received: by 2002:adf:e78a:: with SMTP id n10mr2948609wrm.62.1578653429324;
        Fri, 10 Jan 2020 02:50:29 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id f12sm1737608wmf.28.2020.01.10.02.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:28 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 00/11] Extend SOCKMAP to store listening sockets
Date:   Fri, 10 Jan 2020 11:50:16 +0100
Message-Id: <20200110105027.257877-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the realization that properly cloning listening sockets that have
psock state/callbacks is tricky, comes the second version of patches.

The spirit of the patch set stays the same - make SOCKMAP a generic
collection for listening and established sockets. This would let us use the
SOCKMAP with reuseport today, and in the future hopefully with BPF programs
that run at socket lookup time [0]. For a bit more context, please see v1
cover letter [1].

The biggest change that happened since v1 is how we deal with clearing
psock state in a copy of parent socket when cloning it (patches 3 & 4).

As much as I did not want to touch icsk/tcp clone path, it seems
unavoidable. The changes were kept down to a minimum, with attention to not
break existing users. That said, a review from the TCP maintainer would be
invaluable (patches 3 & 4).

Patches 1 & 2 will conflict with recently posted "Fixes for sockmap/tls
from more complex BPF progs" series [0]. I'll adapt or split them out this
series once sockmap/tls fixes from John land in bpf-next branch.

Some food for thought - is mixing listening and established sockets in the
same BPF map a good idea? I don't know but I couldn't find a good reason to
restrict the user.

Considering how much the code evolved, I didn't carry over Acks from v1.

Thanks,
jkbs

[0] https://lore.kernel.org/bpf/157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2/T/#t
[1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/

v1 -> v2:

- af_ops->syn_recv_sock callback is no longer overridden and burdened with
  restoring sk_prot and clearing sk_user_data in the child socket. As child
  socket is already hashed when syn_recv_sock returns, it is too late to
  put it in the right state. Instead patches 3 & 4 restore sk_prot and
  clear sk_user_data before we hash the child socket. (Pointed out by
  Martin Lau)

- Annotate shared access to sk->sk_prot with READ_ONCE/WRITE_ONCE macros as
  we write to it from sk_msg while socket might be getting cloned on
  another CPU. (Suggested by John Fastabend)

- Convert tests for SOCKMAP holding listening sockets to return-on-error
  style, and hook them up to test_progs. Also use BPF skeleton for setup.
  Add new tests to cover the race scenario discovered during v1 review.

RFC -> v1:

- Switch from overriding proto->accept to af_ops->syn_recv_sock, which
  happens earlier. Clearing the psock state after accept() does not work
  for child sockets that become orphaned (never got accepted). v4-mapped
  sockets need special care.

- Return the socket cookie on SOCKMAP lookup from syscall to be on par with
  REUSEPORT_SOCKARRAY. Requires SOCKMAP to take u64 on lookup/update from
  syscall.

- Make bpf_sk_redirect_map (ingress) and bpf_msg_redirect_map (egress)
  SOCKMAP helpers fail when target socket is a listening one.

- Make bpf_sk_select_reuseport helper fail when target is a TCP established
  socket.

- Teach libbpf to recognize SK_REUSEPORT program type from section name.

- Add a dedicated set of tests for SOCKMAP holding listening sockets,
  covering map operations, overridden socket callbacks, and BPF helpers.


Jakub Sitnicki (11):
  bpf, sk_msg: Don't reset saved sock proto on restore
  net, sk_msg: Annotate lockless access to sk_prot on clone
  net, sk_msg: Clear sk_user_data pointer on clone if tagged
  tcp_bpf: Don't let child socket inherit parent protocol ops on copy
  bpf, sockmap: Allow inserting listening TCP sockets into sockmap
  bpf, sockmap: Don't set up sockmap progs for listening sockets
  bpf, sockmap: Return socket cookie on lookup from syscall
  bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
  bpf: Allow selecting reuseport socket from a SOCKMAP
  selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
  selftests/bpf: Tests for SOCKMAP holding listening sockets

 include/linux/skmsg.h                         |   14 +-
 include/net/sock.h                            |   37 +-
 include/net/tcp.h                             |    1 +
 kernel/bpf/verifier.c                         |    6 +-
 net/core/filter.c                             |   15 +-
 net/core/skmsg.c                              |    2 +-
 net/core/sock.c                               |   11 +-
 net/core/sock_map.c                           |  120 +-
 net/ipv4/tcp_bpf.c                            |   19 +-
 net/ipv4/tcp_minisocks.c                      |    2 +
 net/ipv4/tcp_ulp.c                            |    2 +-
 net/tls/tls_main.c                            |    2 +-
 .../bpf/prog_tests/select_reuseport.c         |   60 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c | 1378 +++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |   76 +
 tools/testing/selftests/bpf/test_maps.c       |    6 +-
 16 files changed, 1696 insertions(+), 55 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

-- 
2.24.1

