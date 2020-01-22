Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37D11454B5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAVNFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:05:54 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35340 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAVNFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:05:54 -0500
Received: by mail-lf1-f65.google.com with SMTP id z18so5277969lfe.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRnNAB924GpTs62Z19Cma93bgPESghc6dBSswJPm4PY=;
        b=XwT8CzmaTF5DBrYaSPmZX8G1AYPhrEmqyhvSFSLlRgKjybzIpsCBiCAeKrWpojvtNR
         RvKXEIU2+TIFu4bZp4ol+Ck4aL/nJdfNBHHYGvukn+b0V+RKhXqv1EQthHl9LhJhLlBy
         mJlESaPcLOdua/wYJkGWybKdQO/gqaYL0/Hv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRnNAB924GpTs62Z19Cma93bgPESghc6dBSswJPm4PY=;
        b=ROAcqh5Q74qQF5pGY7uuHLqwLEoBdyWNJcU0csyx1zohAFhA3SgEaZBjzHY4HNhvkw
         Dc8dG8uCGVKfUK7b++VdWRLSvfoaniYMWLtJ9c5VR7GnDXKbnbSY8eTdXlFCA4SvYUMH
         QCrDEHWhM7fMJYb1DFBk7LSPqgSGgFoLVXPIA1PUlMo3FEqiARCUgx35XUxTxClmZCMc
         ieRwjkJWUquxrJjq070bHGwfaeEtD/Tx+029ETQsQFwwA1Xe1/g+n7iHkCZ+HKUzutu6
         wB+HNrwy/URUsxmIFvaJeuOITU+lqqNTxMfeKltQzOXpCJydvQmONbMLvWGochXDkcDT
         FJBw==
X-Gm-Message-State: APjAAAUHSFnzhroy61c5ti43auUkM0Rm6S8NAfZUOzzh0jZpgRtDW0op
        mNsPUA9psLhhi7v54dzykuGkDw==
X-Google-Smtp-Source: APXvYqxRrgdcHE0xO61XB6UagW9FAd+EXMeLJUndw7zPGgGYPiFkpKwNZorAhu8D5UCEOySb8EE0pg==
X-Received: by 2002:a19:84d:: with SMTP id 74mr1713830lfi.122.1579698351262;
        Wed, 22 Jan 2020 05:05:51 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e8sm24164385ljb.45.2020.01.22.05.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:05:50 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 00/12] Extend SOCKMAP to store listening sockets
Date:   Wed, 22 Jan 2020 14:05:37 +0100
Message-Id: <20200122130549.832236-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make SOCKMAP a generic collection for listening as well as established
sockets. This lets us use SOCKMAP BPF maps with reuseport BPF programs.

The biggest advantage of SOCKMAP over REUSEPORT_SOCKARRAY is that the
former allows the socket can be in more than one map at the same time.
However, until SOCKMAP gets extended to work with UDP, it is not a drop in
replacement for REUSEPORT_SOCKARRAY.

Having a BPF map type that can hold listening sockets, and can gracefully
co-exist with reuseport BPF is important if, in the future, we want to have
BPF programs that run at socket lookup time [0]. Cover letter for v1 of
this series tells the full background story of how we got here [1].

So what has changed in v3? The problem of selecting sockets from another
reuseport group with BPF and SOCKMAP has been addressed. Patch 10 contains
the changes. Broken build also has been fixed. Change log below calls out
all other minor fixes that happened.

John, Martin, thank you for patiently reviewing all the iterations of this
series. I carried over your Acks from v2 where the code hasn't changed, or
changed but only according to your comments.

John, I admit it's not ideal that the series doesn't cover SOCKHASH as
well. Otherwise patch 5 could have been simpler. Please treat it as a
temporary situation. I plan to bring SOCKHASH back on par with SOCKMAP.

Alexei, Daniel, patches 1 & 2 will be in conflict with what we currently
have in bpf branch. "Fixes for sockmap/tls from more complex BPF progs" v2
series [2] that landed recently in bpf branch also touch the psock
tear-down path. I'll be happy to respin if bpf gets merged into bpf-next.

Series is also available on GH [3].

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
[2] https://lore.kernel.org/bpf/20200111061206.8028-1-john.fastabend@gmail.com/
[3] https://github.com/jsitnicki/linux/commits/sockmap-reuseport-v3

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


Jakub Sitnicki (12):
  bpf, sk_msg: Don't clear saved sock proto on restore
  net, sk_msg: Annotate lockless access to sk_prot on clone
  net, sk_msg: Clear sk_user_data pointer on clone if tagged
  tcp_bpf: Don't let child socket inherit parent protocol ops on copy
  bpf, sockmap: Allow inserting listening TCP sockets into sockmap
  bpf, sockmap: Don't set up sockmap progs for listening sockets
  bpf, sockmap: Return socket cookie on lookup from syscall
  bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
  bpf: Allow selecting reuseport socket from a SOCKMAP
  net: Generate reuseport group ID on group creation
  selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
  selftests/bpf: Tests for SOCKMAP holding listening sockets

 include/linux/skmsg.h                         |   15 +-
 include/net/sock.h                            |   37 +-
 include/net/sock_reuseport.h                  |    2 -
 include/net/tcp.h                             |    7 +
 kernel/bpf/reuseport_array.c                  |    5 -
 kernel/bpf/verifier.c                         |    6 +-
 net/core/filter.c                             |   27 +-
 net/core/skmsg.c                              |    2 +-
 net/core/sock.c                               |   11 +-
 net/core/sock_map.c                           |  134 +-
 net/core/sock_reuseport.c                     |   45 +-
 net/ipv4/tcp_bpf.c                            |   17 +-
 net/ipv4/tcp_minisocks.c                      |    2 +
 net/ipv4/tcp_ulp.c                            |    3 +-
 net/tls/tls_main.c                            |    3 +-
 .../bpf/prog_tests/select_reuseport.c         |   60 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
 tools/testing/selftests/bpf/test_maps.c       |    6 +-
 19 files changed, 1807 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

-- 
2.24.1

