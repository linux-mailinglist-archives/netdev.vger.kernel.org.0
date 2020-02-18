Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4B162BA1
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgBRRK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37460 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgBRRK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so24890574wru.4
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0XiHdhttAxAt35KvQ6gLI6mAOK6DrCeSAtJNjRoQiOg=;
        b=ZsqEreAA266BWljineYHPLkmK04ccmo8CPzRH35ATmDHcl8K/Itc68qvlYwMgxZUKZ
         d/kKobu8Ybx9Jy/2yCKd5wrzE1GhvW1dbKC6LhwpjGsSqHYnUBQ8H32lzLUIQZ1Lv5WO
         M3uHbywuc42CiP8Swmpptz/Z1dC7QlkTN8AHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0XiHdhttAxAt35KvQ6gLI6mAOK6DrCeSAtJNjRoQiOg=;
        b=KZIZD+M8CFFvGqWRFWQBoETODzKR9O7zbFfwaoYyuo5fqVv0cyRdn7awoGrHbFgSH9
         sLQlW7X4zzv6bTRyC+tYv8U9hX1DfAsmghqYKqPhFNoOvDBX5QGjNNxXMZoMKKYCW6GH
         xUZGTJuSd7O6nswq5zslbYHfTqFMa49AyyT4XiCHYGSKE+R1C0/VJEUsN9PJvT5N0ZGj
         qTI0njx040NMxo9Ic+uL1qRADCqw0pBVWd6XCefp9W2r9H7GP1T2Y3Nuhr2NXbo7nqlX
         82YANg7gox8ViIW9p8QpBkZNi5hoYz/PCX8OpekOsc6vOO+gmjCtsmOkNZ8AcRBEpcHT
         b4eg==
X-Gm-Message-State: APjAAAXmFJA6iVyN2MTvaCqfjD8pf6SZ1HEX8anRnnwJC+uSsLbu2oZA
        GSgypHPNYvmd1bgncrvnMMxBrg==
X-Google-Smtp-Source: APXvYqwljHPASYzgkoUzqpSvNi7K4IE7+8KngP6y8OAKJj37kG7H7mFY6oMbz86xqvQFG7arW32Iqg==
X-Received: by 2002:a5d:4481:: with SMTP id j1mr29823196wrq.348.1582045825759;
        Tue, 18 Feb 2020 09:10:25 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id r3sm7037921wrn.34.2020.02.18.09.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:25 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 00/11] Extend SOCKMAP/SOCKHASH to store listening sockets
Date:   Tue, 18 Feb 2020 17:10:12 +0000
Message-Id: <20200218171023.844439-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set turns SOCK{MAP,HASH} into generic collections for TCP
sockets, both listening and established. Adding support for listening
sockets enables us to use these BPF map types with reuseport BPF programs.

Why? SOCKMAP and SOCKHASH, in comparison to REUSEPORT_SOCKARRAY, allow the
socket to be in more than one map at the same time.

Having a BPF map type that can hold listening sockets, and gracefully
co-exist with reuseport BPF is important if, in the future, we want
BPF programs that run at socket lookup time [0]. Cover letter for v1 of
this series tells the full story of how we got here [1].

Although SOCK{MAP,HASH} are not a drop-in replacement for SOCKARRAY just
yet, because UDP support is lacking, it's a step in this direction. We're
working with Lorenz on extending SOCK{MAP,HASH} to hold UDP sockets, and
expect to post RFC series for sockmap + UDP in the near future.

I've dropped Acks from all patches that have been touched since v6.

The audit for missing READ_ONCE annotations for access to sk_prot is
ongoing. Thus far I've found one location specific to TCP listening sockets
that needed annotating. This got fixed it in this iteration. I wonder if
sparse checker could be put to work to identify places where we have
sk_prot access while not holding sk_lock...

The patch series depends on another one, posted earlier [2], that has been
split out of it.

Thanks,
jkbs

[0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
[2] https://lore.kernel.org/bpf/20200217121530.754315-1-jakub@cloudflare.com/

v6 -> v7:

- Extended the series to cover SOCKHASH. (patches 4-8, 10-11) (John)

- Rebased onto recent bpf-next. Resolved conflicts in recent fixes to
  sk_state checks on sockmap/sockhash update path. (patch 4)

- Added missing READ_ONCE annotation in sock_copy. (patch 1)

- Split out patches that simplify sk_psock_restore_proto [2].

v5 -> v6:

- Added a fix-up for patch 1 which I forgot to commit in v5. Sigh.

v4 -> v5:

- Rebase onto recent bpf-next to resolve conflicts. (Daniel)

v3 -> v4:

- Make tcp_bpf_clone parameter names consistent across function declaration
  and definition. (Martin)

- Use sock_map_redirect_okay helper everywhere we need to take a different
  action for listening sockets. (Lorenz)

- Expand comment explaining the need for a callback from reuseport to
  sockarray code in reuseport_detach_sock. (Martin)

- Mention the possibility of using a u64 counter for reuseport IDs in the
  future in the description for patch 10. (Martin)

v2 -> v3:

- Generate reuseport ID when group is created. Please see patch 10
  description for details. (Martin)

- Fix the build when CONFIG_NET_SOCK_MSG is not selected by either
  CONFIG_BPF_STREAM_PARSER or CONFIG_TLS. (kbuild bot & John)

- Allow updating sockmap from BPF on BPF_SOCK_OPS_TCP_LISTEN_CB callback. An
  oversight in previous iterations. Users may want to populate the sockmap with
  listening sockets from BPF as well.

- Removed RCU read lock assertion in sock_map_lookup_sys. (Martin)

- Get rid of a warning when child socket was cloned with parent's psock
  state. (John)

- Check for tcp_bpf_unhash rather than tcp_bpf_recvmsg when deciding if
  sk_proto needs restoring on clone. Check for recvmsg in the context of
  listening socket cloning was confusing. (Martin)

- Consolidate sock_map_sk_is_suitable with sock_map_update_okay. This led
  to adding dedicated predicates for sockhash. Update self-tests
  accordingly. (John)

- Annotate unlikely branch in bpf_{sk,msg}_redirect_map when socket isn't
  in a map, or isn't a valid redirect target. (John)

- Document paired READ/WRITE_ONCE annotations and cover shared access in
  more detail in patch 2 description. (John)

- Correct a couple of log messages in sockmap_listen self-tests so the
  message reflects the actual failure.

- Rework reuseport tests from sockmap_listen suite so that ENOENT error
  from bpf_sk_select_reuseport handler does not happen on happy path.

v1 -> v2:

- af_ops->syn_recv_sock callback is no longer overridden and burdened with
  restoring sk_prot and clearing sk_user_data in the child socket. As child
  socket is already hashed when syn_recv_sock returns, it is too late to
  put it in the right state. Instead patches 3 & 4 address restoring
  sk_prot and clearing sk_user_data before we hash the child socket.
  (Pointed out by Martin Lau)

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
  net, sk_msg: Annotate lockless access to sk_prot on clone
  net, sk_msg: Clear sk_user_data pointer on clone if tagged
  tcp_bpf: Don't let child socket inherit parent protocol ops on copy
  bpf, sockmap: Allow inserting listening TCP sockets into sockmap
  bpf, sockmap: Don't set up upcalls and progs for listening sockets
  bpf, sockmap: Return socket cookie on lookup from syscall
  bpf, sockmap: Let all kernel-land lookup values in SOCKMAP/SOCKHASH
  bpf: Allow selecting reuseport socket from a SOCKMAP/SOCKHASH
  net: Generate reuseport group ID on group creation
  selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP/SOCKHASH
  selftests/bpf: Tests for sockmap/sockhash holding listening sockets

 include/linux/skmsg.h                         |    3 +-
 include/net/sock.h                            |   37 +-
 include/net/sock_reuseport.h                  |    2 -
 include/net/tcp.h                             |    7 +
 kernel/bpf/reuseport_array.c                  |    5 -
 kernel/bpf/verifier.c                         |   10 +-
 net/core/filter.c                             |   27 +-
 net/core/skmsg.c                              |    2 +-
 net/core/sock.c                               |   14 +-
 net/core/sock_map.c                           |  167 +-
 net/core/sock_reuseport.c                     |   50 +-
 net/ipv4/tcp_bpf.c                            |   18 +-
 net/ipv4/tcp_minisocks.c                      |    2 +
 net/ipv4/tcp_ulp.c                            |    3 +-
 net/tls/tls_main.c                            |    3 +-
 .../bpf/prog_tests/select_reuseport.c         |   63 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c | 1496 +++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |   98 ++
 tools/testing/selftests/bpf/test_maps.c       |    6 +-
 19 files changed, 1910 insertions(+), 103 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

-- 
2.24.1

