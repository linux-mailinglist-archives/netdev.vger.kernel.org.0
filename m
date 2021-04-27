Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72CD36CF97
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 01:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhD0XkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 19:40:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:47896 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbhD0Xi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 19:38:26 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbXGu-0006Bv-NO; Wed, 28 Apr 2021 01:37:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-04-28
Date:   Wed, 28 Apr 2021 01:37:40 +0200
Message-Id: <20210427233740.22238-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26153/Tue Apr 27 13:09:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 19 non-merge commits during the last 2 day(s) which contain
a total of 36 files changed, 494 insertions(+), 313 deletions(-).

The main changes are:

1) Add link detach and following re-attach for trampolines, from Jiri Olsa.

2) Use kernel's "binary printf" lib for formatted output BPF helpers (which
   avoids the needs for variadic argument handling), from Florent Revest.

3) Fix verifier 64 to 32 bit min/max bound propagation, from Daniel Borkmann.

4) Convert cpumap to use netif_receive_skb_list(), from Lorenzo Bianconi.

5) Add generic batched-ops support to percpu array map, from Pedro Tammela.

6) Various CO-RE relocation BPF selftests fixes, from Andrii Nakryiko.

7) Misc doc rst fixes, from Hengqi Chen.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Jesper Dangaard Brouer, John 
Fastabend, Julia Lawall, kernel test robot, KP Singh, Lorenz Bauer, 
Rasmus Villemoes, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 0ea1041bfa3aa2971f858edd9e05477c2d3d54a0:

  Merge branch 'bnxt_en-next' (2021-04-25 18:37:39 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 3733bfbbdd28f7a65340d0058d15d15190a4944a:

  bpf, selftests: Update array map tests for per-cpu batched ops (2021-04-28 01:18:12 +0200)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'bpf: Tracing and lsm programs re-attach'
      Merge branch 'CO-RE relocation selftests fixes'
      Merge branch 'Implement formatted output helpers with bstr_printf'

Andrii Nakryiko (5):
      selftests/bpf: Add remaining ASSERT_xxx() variants
      libbpf: Support BTF_KIND_FLOAT during type compatibility checks in CO-RE
      selftests/bpf: Fix BPF_CORE_READ_BITFIELD() macro
      selftests/bpf: Fix field existence CO-RE reloc tests
      selftests/bpf: Fix core_reloc test runner

Daniel Borkmann (1):
      bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds

Florent Revest (3):
      bpf: Lock bpf_trace_printk's tmp buf before it is written to
      seq_file: Add a seq_bprintf function
      bpf: Implement formatted output helpers with bstr_printf

Hengqi Chen (1):
      bpf, docs: Fix literal block for example code

Jiri Olsa (6):
      bpf: Allow trampoline re-attach for tracing and lsm programs
      selftests/bpf: Add re-attach test to fentry_test
      selftests/bpf: Add re-attach test to fexit_test
      selftests/bpf: Add re-attach test to lsm test
      selftests/bpf: Test that module can't be unloaded with attached trampoline
      selftests/bpf: Use ASSERT macros in lsm test

Lorenzo Bianconi (1):
      bpf, cpumap: Bulk skb using netif_receive_skb_list

Pedro Tammela (2):
      bpf: Add batched ops support for percpu array
      bpf, selftests: Update array map tests for per-cpu batched ops

 Documentation/networking/filter.rst                |   2 +-
 fs/seq_file.c                                      |  18 ++
 include/linux/bpf.h                                |  22 +--
 include/linux/seq_file.h                           |   4 +
 init/Kconfig                                       |   1 +
 kernel/bpf/arraymap.c                              |   2 +
 kernel/bpf/cpumap.c                                |  18 +-
 kernel/bpf/helpers.c                               | 188 +++++++++++----------
 kernel/bpf/syscall.c                               |  23 ++-
 kernel/bpf/trampoline.c                            |   4 +-
 kernel/bpf/verifier.c                              |  10 +-
 kernel/trace/bpf_trace.c                           |  36 ++--
 tools/lib/bpf/bpf_core_read.h                      |  16 +-
 tools/lib/bpf/libbpf.c                             |   6 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  | 104 ++++++++----
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   2 +-
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |   4 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |   2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  51 +++---
 .../testing/selftests/bpf/prog_tests/fentry_test.c |  52 ++++--
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |  52 ++++--
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   2 +-
 .../selftests/bpf/prog_tests/module_attach.c       |  23 +++
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   7 +-
 .../selftests/bpf/prog_tests/snprintf_btf.c        |   4 +-
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |  61 ++++---
 ...tf__core_reloc_existence___err_wrong_arr_kind.c |   3 -
 ...re_reloc_existence___err_wrong_arr_value_type.c |   3 -
 ...tf__core_reloc_existence___err_wrong_int_kind.c |   3 -
 .../btf__core_reloc_existence___err_wrong_int_sz.c |   3 -
 ...tf__core_reloc_existence___err_wrong_int_type.c |   3 -
 ..._core_reloc_existence___err_wrong_struct_type.c |   3 -
 .../btf__core_reloc_existence___wrong_field_defs.c |   3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  20 +--
 tools/testing/selftests/bpf/test_progs.h           |  50 +++++-
 .../testing/selftests/bpf/verifier/array_access.c  |   2 +-
 36 files changed, 494 insertions(+), 313 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c
