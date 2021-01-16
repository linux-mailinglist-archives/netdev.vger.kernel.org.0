Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51C32F89DE
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbhAPAVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:21:10 -0500
Received: from www62.your-server.de ([213.133.104.62]:51546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPAVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 19:21:10 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l0ZKM-0009Hd-I4; Sat, 16 Jan 2021 01:20:26 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-01-16
Date:   Sat, 16 Jan 2021 01:20:25 +0100
Message-Id: <20210116002025.15706-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26050/Fri Jan 15 13:34:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 11 non-merge commits during the last 6 day(s) which contain
a total of 14 files changed, 128 insertions(+), 115 deletions(-).

The main changes are:

1) Fix a double bpf_prog_put() for BPF_PROG_{TYPE_EXT,TYPE_TRACING} types in
   link creation's error path causing a refcount underflow, from Jiri Olsa.

2) Fix BTF validation errors for the case where kernel modules don't declare
   any new types and end up with an empty BTF, from Andrii Nakryiko.

3) Fix BPF local storage helpers to first check their {task,inode} owners for
   being NULL before access, from KP Singh.

4) Fix a memory leak in BPF setsockopt handling for the case where optlen is
   zero and thus temporary optval buffer should be freed, from Stanislav Fomichev.

5) Fix a syzbot memory allocation splat in BPF_PROG_TEST_RUN infra for
   raw_tracepoint caused by too big ctx_size_in, from Song Liu.

6) Fix LLVM code generation issues with verifier where PTR_TO_MEM{,_OR_NULL}
   registers were spilled to stack but not recognized, from Gilad Reti.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Christopher William Snowhill, Gilad Reti, KP Singh, 
Martin KaFai Lau, Toke Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit f97844f9c518172f813b7ece18a9956b1f70c1bb:

  dt-bindings: net: renesas,etheravb: RZ/G2H needs tx-internal-delay-ps (2021-01-09 19:12:21 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 235ecd36c7a93e4d6c73ac71137b8f1fa31148dd:

  MAINTAINERS: Update my email address (2021-01-15 23:55:16 +0100)

----------------------------------------------------------------
Andrii Nakryiko (2):
      bpf: Allow empty module BTFs
      libbpf: Allow loading empty BTFs

Björn Töpel (1):
      MAINTAINERS: Update my email address

Gilad Reti (2):
      bpf: Support PTR_TO_MEM{,_OR_NULL} register spilling
      selftests/bpf: Add verifier test for PTR_TO_MEM spill

Jiri Olsa (1):
      bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach

KP Singh (3):
      bpf: Local storage helpers should check nullness of owner ptr passed
      bpf: Fix typo in bpf_inode_storage.c
      bpf: Update local storage test to check handling of null ptrs

Song Liu (1):
      bpf: Reject too big ctx_size_in for raw_tp test run

Stanislav Fomichev (1):
      bpf: Don't leak memory in bpf getsockopt when optlen == 0

 .mailmap                                           |  2 +
 MAINTAINERS                                        |  4 +-
 kernel/bpf/bpf_inode_storage.c                     |  9 +-
 kernel/bpf/bpf_task_storage.c                      |  5 +-
 kernel/bpf/btf.c                                   |  2 +-
 kernel/bpf/cgroup.c                                |  5 +-
 kernel/bpf/syscall.c                               |  6 +-
 kernel/bpf/verifier.c                              |  2 +
 net/bpf/test_run.c                                 |  3 +-
 tools/lib/bpf/btf.c                                |  5 --
 .../selftests/bpf/prog_tests/test_local_storage.c  | 96 ++++++----------------
 tools/testing/selftests/bpf/progs/local_storage.c  | 62 ++++++++------
 tools/testing/selftests/bpf/test_verifier.c        | 12 ++-
 tools/testing/selftests/bpf/verifier/spill_fill.c  | 30 +++++++
 14 files changed, 128 insertions(+), 115 deletions(-)
