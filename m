Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3386C67F0B7
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 22:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjA0V61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 16:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjA0V60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 16:58:26 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6A893DA;
        Fri, 27 Jan 2023 13:58:24 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pLWjk-000Fg7-P6; Fri, 27 Jan 2023 22:58:21 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-01-27
Date:   Fri, 27 Jan 2023 22:58:20 +0100
Message-Id: <20230127215820.4993-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26794/Fri Jan 27 09:44:08 2023)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 9 day(s) which contain
a total of 10 files changed, 170 insertions(+), 59 deletions(-).

The main changes are:

1) Fix preservation of register's parent/live fields when copying range-info, from Eduard Zingerman.

2) Fix an off-by-one bug in bpf_mem_cache_idx() to select the right cache, from Hou Tao.

3) Fix stack overflow from infinite recursion in sock_map_close(), from Jakub Sitnicki.

4) Fix missing btf_put() in register_btf_id_dtor_kfuncs()'s error path, from Jiri Olsa.

5) Fix a splat from bpf_setsockopt() via lsm_cgroup/socket_sock_rcv_skb, from Kui-Feng Lee.

6) Fix bpf_send_signal[_thread]() helpers to hold a reference on the task, from Yonghong Song.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Hao Sun, John Fastabend, Kumar Kartikeya Dwivedi, Yonghong Song

----------------------------------------------------------------

The following changes since commit b9fb10d131b8c84af9bb14e2078d5c63600c7dea:

  l2tp: prevent lockdep issue in l2tp_tunnel_register() (2023-01-18 14:44:54 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 5416c9aea8323583e8696f0500b6142dfae80821:

  bpf: Fix the kernel crash caused by bpf_setsockopt(). (2023-01-26 23:26:40 -0800)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'bpf: Fix to preserve reg parent/live fields when copying range info'
      Merge branch 'bpf, sockmap: Fix infinite recursion in sock_map_close'

Eduard Zingerman (2):
      bpf: Fix to preserve reg parent/live fields when copying range info
      selftests/bpf: Verify copy_register_state() preserves parent/live fields

Hou Tao (1):
      bpf: Fix off-by-one error in bpf_mem_cache_idx()

Jakub Sitnicki (4):
      bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself
      bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
      selftests/bpf: Pass BPF skeleton to sockmap_listen ops tests
      selftests/bpf: Cover listener cloning with progs attached to sockmap

Jiri Olsa (1):
      bpf: Add missing btf_put to register_btf_id_dtor_kfuncs

Kui-Feng Lee (1):
      bpf: Fix the kernel crash caused by bpf_setsockopt().

Yonghong Song (1):
      bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

 include/linux/util_macros.h                        | 12 ++++
 kernel/bpf/bpf_lsm.c                               |  1 -
 kernel/bpf/btf.c                                   |  4 +-
 kernel/bpf/memalloc.c                              |  2 +-
 kernel/bpf/verifier.c                              | 25 +++++--
 kernel/trace/bpf_trace.c                           |  3 +-
 net/core/sock_map.c                                | 61 ++++++++--------
 net/ipv4/tcp_bpf.c                                 |  4 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 81 +++++++++++++++++-----
 .../selftests/bpf/verifier/search_pruning.c        | 36 ++++++++++
 10 files changed, 170 insertions(+), 59 deletions(-)
