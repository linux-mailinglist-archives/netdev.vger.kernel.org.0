Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357DEECBCC
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfKAXS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:18:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:50410 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAXS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:18:56 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgBy-0000SO-FY; Sat, 02 Nov 2019 00:18:54 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v3 0/8] Fix BPF probe memory helpers
Date:   Sat,  2 Nov 2019 00:17:55 +0100
Message-Id: <cover.1572649915.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds probe_read_{user,kernel}(), probe_read_str_{user,kernel}()
helpers, fixes probe_write_user() helper and selftests. For details please
see individual patches.

Thanks!

v2 -> v3:
  - noticed two more things that are fixed in here:
   - bpf uapi helper description used 'int size' for *_str helpers, now u32
   - we need TASK_SIZE_MAX + guard page on x86-64 in patch 2 otherwise
     we'll trigger the 00c42373d397 warn as well, so full range covered now
v1 -> v2:
  - standardize unsafe_ptr terminology in uapi header comment (Andrii)
  - probe_read_{user,kernel}[_str] naming scheme (Andrii)
  - use global data in last test case, remove relaxed_maps (Andrii)
  - add strict non-pagefault kernel read funcs to avoid warning in
    kernel probe read helpers (Alexei)

Daniel Borkmann (8):
  uaccess: Add non-pagefault user-space write function
  uaccess: Add strict non-pagefault kernel-space read function
  bpf: Make use of probe_user_write in probe write helper
  bpf: Add probe_read_{user,kernel} and probe_read_{user,kernel}_str helpers
  bpf: Switch BPF probe insns to bpf_probe_read_kernel
  bpf, samples: Use bpf_probe_read_user where appropriate
  bpf, testing: Convert prog tests to probe_read_{user,kernel}{,_str} helper
  bpf, testing: Add selftest to read/write sockaddr from user space

 arch/x86/mm/Makefile                          |   2 +-
 arch/x86/mm/maccess.c                         |  43 ++++
 include/linux/uaccess.h                       |  16 ++
 include/uapi/linux/bpf.h                      | 122 ++++++++----
 kernel/bpf/core.c                             |   9 +-
 kernel/trace/bpf_trace.c                      | 187 +++++++++++++-----
 mm/maccess.c                                  |  70 ++++++-
 samples/bpf/map_perf_test_kern.c              |   4 +-
 samples/bpf/test_map_in_map_kern.c            |   4 +-
 samples/bpf/test_probe_write_user_kern.c      |   2 +-
 tools/include/uapi/linux/bpf.h                | 122 ++++++++----
 .../selftests/bpf/prog_tests/probe_user.c     |  78 ++++++++
 tools/testing/selftests/bpf/progs/kfree_skb.c |   4 +-
 tools/testing/selftests/bpf/progs/pyperf.h    |  67 ++++---
 .../testing/selftests/bpf/progs/strobemeta.h  |  36 ++--
 .../selftests/bpf/progs/test_probe_user.c     |  26 +++
 .../selftests/bpf/progs/test_tcp_estats.c     |   2 +-
 17 files changed, 597 insertions(+), 197 deletions(-)
 create mode 100644 arch/x86/mm/maccess.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c

-- 
2.21.0

