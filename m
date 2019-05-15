Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4121FD84
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 03:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfEPBqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 21:46:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:59164 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfEOXyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 19:54:32 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hR3jA-0003PW-IQ; Thu, 16 May 2019 01:54:28 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-05-16
Date:   Thu, 16 May 2019 01:54:28 +0200
Message-Id: <20190515235428.16904-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25450/Wed May 15 09:59:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix a use after free in __dev_map_entry_free(), from Eric.

2) Several sockmap related bug fixes: a splat in strparser if
   it was never initialized, remove duplicate ingress msg list
   purging which can race, fix msg->sg.size accounting upon
   skb to msg conversion, and last but not least fix a timeout
   bug in tcp_bpf_wait_data(), from John.

3) Fix LRU map to avoid messing with eviction heuristics upon
   syscall lookup, e.g. map walks from user space side will
   then lead to eviction of just recently created entries on
   updates as it would mark all map entries, from Daniel.

4) Don't bail out when libbpf feature probing fails. Also
   various smaller fixes to flow_dissector test, from Stanislav.

5) Fix missing brackets for BTF_INT_OFFSET() in UAPI, from Gary.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit d4c26eb6e721683a0f93e346ce55bc8dc3cbb175:

  net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering (2019-05-13 09:59:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 5fa2ca7c4a3fc176f31b495e1a704862d8188b53:

  bpf, tcp: correctly handle DONT_WAIT flags and timeo == 0 (2019-05-16 01:36:13 +0200)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'lru-map-fix'

Daniel Borkmann (3):
      bpf: add map_lookup_elem_sys_only for lookups from syscall side
      bpf, lru: avoid messing with eviction heuristics upon syscall lookup
      bpf: test ref bit from data path and add new tests for syscall path

Eric Dumazet (1):
      bpf: devmap: fix use-after-free Read in __dev_map_entry_free

Gary Lin (2):
      bpf: btf: fix the brackets of BTF_INT_OFFSET()
      tools/bpf: Sync kernel btf.h header

John Fastabend (4):
      bpf: sockmap, only stop/flush strp if it was enabled at some point
      bpf: sockmap remove duplicate queue free
      bpf: sockmap fix msg->sg.size account on ingress skb
      bpf, tcp: correctly handle DONT_WAIT flags and timeo == 0

Stanislav Fomichev (4):
      bpf: mark bpf_event_notify and bpf_event_init as static
      libbpf: don't fail when feature probing fails
      selftests/bpf: add missing \n to flow_dissector CHECK errors
      selftests/bpf: add prog detach to flow_dissector test

 Documentation/bpf/btf.rst                          |   2 +-
 include/linux/bpf.h                                |   1 +
 include/uapi/linux/btf.h                           |   2 +-
 kernel/bpf/devmap.c                                |   3 +
 kernel/bpf/hashtab.c                               |  23 +-
 kernel/bpf/syscall.c                               |   5 +-
 kernel/trace/bpf_trace.c                           |   5 +-
 net/core/skmsg.c                                   |   7 +-
 net/ipv4/tcp_bpf.c                                 |   7 +-
 tools/include/uapi/linux/btf.h                     |   2 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   9 +-
 tools/testing/selftests/bpf/test_lru_map.c         | 288 ++++++++++++++++++++-
 13 files changed, 321 insertions(+), 35 deletions(-)
