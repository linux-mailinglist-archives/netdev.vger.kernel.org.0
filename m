Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6A0618D19
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 01:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKDAEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 20:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKDAEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 20:04:51 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA7B1CB1F;
        Thu,  3 Nov 2022 17:04:49 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1oqkCT-000Lhk-CZ; Fri, 04 Nov 2022 01:04:45 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-11-04
Date:   Fri,  4 Nov 2022 01:04:45 +0100
Message-Id: <20221104000445.30761-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26709/Thu Nov  3 08:56:21 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 8 non-merge commits during the last 3 day(s) which contain
a total of 10 files changed, 113 insertions(+), 16 deletions(-).

The main changes are:

1) Fix memory leak upon allocation failure in BPF verifier's stack state
   tracking, from Kees Cook.

2) Fix address leakage when BPF progs release reference to an object, from Youlin Li.

3) Fix BPF CI breakage from buggy in.h uapi header dependency, from Andrii Nakryiko.

4) Fix bpftool pin sub-command's argument parsing, from Pu Lehui.

5) Fix BPF sockmap lockdep warning by cancelling psock work outside of socket
   lock, from Cong Wang.

6) Follow-up for BPF sockmap to fix sk_forward_alloc accounting, from Wang Yufen.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Bill Wendling, Jakub Sitnicki, John Fastabend, Kees Cook, Quentin 
Monnet, Stanislav Fomichev, Zhengchao Shao

----------------------------------------------------------------

The following changes since commit 363a5328f4b0517e59572118ccfb7c626d81dca9:

  net: tun: fix bugs for oversize packet when napi frags enabled (2022-10-31 20:04:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 475244f5e06beeda7b557d9dde46a5f439bf3379:

  selftests/bpf: Add verifier test for release_reference() (2022-11-04 00:24:29 +0100)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Andrii Nakryiko (2):
      net/ipv4: Fix linux/in.h header dependencies
      tools/headers: Pull in stddef.h to uapi to fix BPF selftests build in CI

Cong Wang (1):
      bpf, sock_map: Move cancel_work_sync() out of sock lock

Kees Cook (1):
      bpf, verifier: Fix memory leak in array reallocation for stack state

Pu Lehui (1):
      bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE

Wang Yufen (1):
      bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues

Youlin Li (2):
      bpf: Fix wrong reg type conversion in release_reference()
      selftests/bpf: Add verifier test for release_reference()

 include/linux/skmsg.h                              |  2 +-
 include/uapi/linux/in.h                            |  1 +
 kernel/bpf/verifier.c                              | 17 ++++++--
 net/core/skmsg.c                                   |  7 +---
 net/core/sock_map.c                                |  7 ++--
 net/ipv4/tcp_bpf.c                                 |  8 ++--
 tools/bpf/bpftool/common.c                         |  3 ++
 tools/include/uapi/linux/in.h                      |  1 +
 tools/include/uapi/linux/stddef.h                  | 47 ++++++++++++++++++++++
 .../testing/selftests/bpf/verifier/ref_tracking.c  | 36 +++++++++++++++++
 10 files changed, 113 insertions(+), 16 deletions(-)
 create mode 100644 tools/include/uapi/linux/stddef.h
