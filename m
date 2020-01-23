Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3034146D6E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAWPzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:55:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51963 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAWPzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so3100656wmi.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YQdgWZakor9UpewkosavHchgak3obgMhwGLov7azvTA=;
        b=RrMGDWvFd9COh4qIsCbgVs0i05vAUxZAd14nyGqfz10J9FqIWYgBhExzLTJOnCkslY
         27/6XejKfzjACkAcsLSDDVEo0SXN000wteV9MgEH4EXV1vJHfzM4fwnwYttbb85j/AQ6
         /GZUSSAQggMcC5JUSrnPEXNWD4f9Pccq9o0vM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YQdgWZakor9UpewkosavHchgak3obgMhwGLov7azvTA=;
        b=F2B2c4XjnpwfXd5ENdbOftJKDrJEEJI0xiqU0qfPXlYaxFaAY3jl9BlVhWNuwV+lfv
         xS/adViYzEshhEJTcUe1cq8FFg44JX4N8+wK8eTMgiGzp5Pylxt0KR5d+aUDPDZdX8cb
         9eXFB0DgNwura3Zqf2y/hWSbDZRHaNZ+klegMX/xIF4YcSviUmgq2sBjhV+bEW/kHfUy
         x1p24kVIF0jT+eZVfEopfJ6DN3Za/ZmTzKZ8gT7uJ7s53VesJa8pEQ9ANVvYxfawK/s/
         R9JWuykmtCeXCX7S6shBGcfJNK+4Kysg2hO2xOHru6fjd67fFsy+zRulOHEBCViAKgdW
         yoOA==
X-Gm-Message-State: APjAAAUCKa+fz8cwRadwzBiLIzBwyFtPHQBrddoXdicSRb2QN4ZZFiDv
        2sKbPvgLSnK/dkb/N+9NSy0vMYgF+LcEPg==
X-Google-Smtp-Source: APXvYqyvMyXDUZihewE1n3b7kgfp7W453hgyGkio2AmOHarhdf9mA4R6xubjs0MY2tErh8RqZbTPYA==
X-Received: by 2002:a1c:8055:: with SMTP id b82mr4940016wmd.127.1579794935538;
        Thu, 23 Jan 2020 07:55:35 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id u7sm3185584wmj.3.2020.01.23.07.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:34 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 00/12] Extend SOCKMAP to store listening sockets
Date:   Thu, 23 Jan 2020 16:55:22 +0100
Message-Id: <20200123155534.114313-1-jakub@cloudflare.com>
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

v4 doesn't bring any major changes. I've carried over Acks from v3 [2].

As I mentioned in v3, patches 1 & 2 will be in conflict with what we currently
have in bpf branch. "Fixes for sockmap/tls from more complex BPF progs" v2
series [3] that landed recently in bpf branch also touch the psock tear-down
path. I'll be happy to respin if bpf gets merged into bpf-next.

Series is also available on GH [4].

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
[2] https://lore.kernel.org/bpf/20200122130549.832236-1-jakub@cloudflare.com/T/#t
[3] https://lore.kernel.org/bpf/20200111061206.8028-1-john.fastabend@gmail.com/
[4] https://github.com/jsitnicki/linux/commits/sockmap-reuseport-v4

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

 include/linux/skmsg.h                         |   15 +-
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
 19 files changed, 1811 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

-- 
2.24.1

