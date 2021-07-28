Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3443D995F
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhG1XU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:20:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:35348 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhG1XU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:20:26 -0400
Received: from [2a01:118f:54a:7f00:89b1:4cb8:1a49:dc0f] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m8sqc-000Bg2-Hb; Thu, 29 Jul 2021 01:20:22 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-07-29
Date:   Thu, 29 Jul 2021 01:20:21 +0200
Message-Id: <20210728232021.17617-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26246/Wed Jul 28 10:18:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 9 non-merge commits during the last 14 day(s) which contain
a total of 20 files changed, 446 insertions(+), 138 deletions(-).

The main changes are:

1) Fix UBSAN out-of-bounds splat for showing XDP link fdinfo, from Lorenz Bauer.

2) Fix insufficient Spectre v4 mitigation in BPF runtime, from Daniel Borkmann,
   Piotr Krysiuk and Benedict Schlueter.

3) Batch of fixes for BPF sockmap found under stress testing, from John Fastabend.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Jakub Sitnicki, Martin KaFai Lau

----------------------------------------------------------------

The following changes since commit 20192d9c9f6ae447c461285c915502ffbddf5696:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-07-15 14:39:45 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 2039f26f3aca5b0e419b98f65dd36481337b86ee:

  bpf: Fix leakage due to insufficient speculative store bypass mitigation (2021-07-29 00:27:52 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      Merge branch 'sockmap fixes picked up by stress tests'

Daniel Borkmann (5):
      bpf: Remove superfluous aux sanitation on subprog rejection
      bpf: Fix pointer arithmetic mask tightening under state pruning
      bpf, selftests: Add test cases for pointer alu from multiple paths
      bpf: Introduce BPF nospec instruction for mitigating Spectre v4
      bpf: Fix leakage due to insufficient speculative store bypass mitigation

John Fastabend (3):
      bpf, sockmap: Zap ingress queues after stopping strparser
      bpf, sockmap: On cleanup we additionally need to remove cached skb
      bpf, sockmap: Fix memleak on ingress msg enqueue

Lorenz Bauer (1):
      bpf: Fix OOB read when printing XDP link fdinfo

 arch/arm/net/bpf_jit_32.c                          |   3 +
 arch/arm64/net/bpf_jit_comp.c                      |  13 ++
 arch/mips/net/ebpf_jit.c                           |   3 +
 arch/powerpc/net/bpf_jit_comp32.c                  |   6 +
 arch/powerpc/net/bpf_jit_comp64.c                  |   6 +
 arch/riscv/net/bpf_jit_comp32.c                    |   4 +
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +
 arch/s390/net/bpf_jit_comp.c                       |   5 +
 arch/sparc/net/bpf_jit_comp_64.c                   |   3 +
 arch/x86/net/bpf_jit_comp.c                        |   7 +
 arch/x86/net/bpf_jit_comp32.c                      |   6 +
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |   3 +-
 include/linux/filter.h                             |  15 ++
 include/linux/skmsg.h                              |  54 +++--
 kernel/bpf/core.c                                  |  19 +-
 kernel/bpf/disasm.c                                |  16 +-
 kernel/bpf/verifier.c                              | 148 +++++--------
 net/core/skmsg.c                                   |  39 +++-
 .../selftests/bpf/verifier/value_ptr_arith.c       | 229 +++++++++++++++++++++
 20 files changed, 446 insertions(+), 138 deletions(-)
