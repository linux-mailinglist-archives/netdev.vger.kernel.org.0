Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5956C14A496
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgA0NLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:01 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46208 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgA0NLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:01 -0500
Received: by mail-lf1-f65.google.com with SMTP id z26so6122611lfg.13
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZpwxmMsGW52ttZ8q51qiuMqluh1AV3yKSX/KJD4SpEk=;
        b=lkcdWxoc6CUk2NEu66UaGET6sC80h/uGLWQTUaj9lBLDD6X8AlRSr8GZQxmcBlpCSF
         xnUz9qq54TQRZpJ9ceZipgCOYuxjv0SGP8QAE1Ew2xURHn3Mcs+DOzVt2JzghZaS22rS
         XdMXN3sy+A813qsNhg5ViF1Vc1a2jHlJ4RGMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZpwxmMsGW52ttZ8q51qiuMqluh1AV3yKSX/KJD4SpEk=;
        b=sdlKPHJFQTV3nzB1zdI9lrDp8Y5pxHhRKo5lveOBGXkIvbCeaBCutqzf745prN1eZV
         FRO30OMZwM10+0s4aXYyBOQTxPW4vmT4KikF0kGXalGh7VJfJqGf4ORne8bKb18VfTuO
         u9ldNGVjfE6jXbURnuOgMXYABtd6r+CUmXDwGvOKYkOBz9ikvhiCb6n7zSHJ7MktZjKy
         zfbuu8E5GY0YGJ38lyhs1KfHuQ1EJl36miSF+zYFuk2XhFa2/Aryexc0Mr7qgoX7GDbM
         n+92Av2vsssiTKrx9X+7zmeQ/31ka2TCqCShD22oPE0jMJrh7dNxF5neugDeIZ0/shW8
         rBjA==
X-Gm-Message-State: APjAAAUqsAwUiHnkPecRp8jMXBjmk3tlKDI5e/ax5h726XHSuw9QuVnQ
        1fRnDGBQgtPyqBaX9+lTFnvq4A==
X-Google-Smtp-Source: APXvYqw+vxc7Uk2KNQHNdXJ5Ej9aOYPmNhcaFOiU6lbwyOxEN5OZwCH1nemWM65AXb9FtofFJ5h/ng==
X-Received: by 2002:a19:f610:: with SMTP id x16mr7300059lfe.80.1580130659033;
        Mon, 27 Jan 2020 05:10:59 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id r21sm8220620ljn.64.2020.01.27.05.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:10:58 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v6 00/12] Extend SOCKMAP to store listening sockets
Date:   Mon, 27 Jan 2020 14:10:45 +0100
Message-Id: <20200127131057.150941-1-jakub@cloudflare.com>
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

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
[2] https://lore.kernel.org/bpf/20200111061206.8028-1-john.fastabend@gmail.com/

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

 include/linux/skmsg.h                         |   21 +-
 include/net/sock.h                            |   37 +-
 include/net/sock_reuseport.h                  |    2 -
 include/net/tcp.h                             |    7 +
 kernel/bpf/reuseport_array.c                  |    5 -
 kernel/bpf/verifier.c                         |    6 +-
 net/core/filter.c                             |   27 +-
 net/core/skmsg.c                              |    2 +-
 net/core/sock.c                               |   11 +-
 net/core/sock_map.c                           |  133 +-
 net/core/sock_reuseport.c                     |   50 +-
 net/ipv4/tcp_bpf.c                            |   17 +-
 net/ipv4/tcp_minisocks.c                      |    2 +
 net/ipv4/tcp_ulp.c                            |    3 +-
 net/tls/tls_main.c                            |    3 +-
 .../bpf/prog_tests/select_reuseport.c         |   60 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
 tools/testing/selftests/bpf/test_maps.c       |    6 +-
 19 files changed, 1811 insertions(+), 113 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

-- 
2.24.1

