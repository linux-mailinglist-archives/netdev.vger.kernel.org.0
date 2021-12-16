Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5973A477E03
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 22:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbhLPVAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 16:00:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:47890 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhLPVAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 16:00:08 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mxxrC-000EsM-9L; Thu, 16 Dec 2021 22:00:06 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-12-16
Date:   Thu, 16 Dec 2021 22:00:05 +0100
Message-Id: <20211216210005.13815-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26389/Thu Dec 16 07:02:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 15 non-merge commits during the last 7 day(s) which contain
a total of 12 files changed, 434 insertions(+), 30 deletions(-).

The main changes are:

1) Fix incorrect verifier state pruning behavior for <8B register spill/fill,
   from Paul Chaignon.

2) Fix x86-64 JIT's extable handling for fentry/fexit when return pointer
   is an ERR_PTR(), from Alexei Starovoitov.

3) Fix 3 different possibilities that BPF verifier missed where unprivileged
   could leak kernel addresses, from Daniel Borkmann.

4) Fix xsk's poll behavior under need_wakeup flag, from Magnus Karlsson.

5) Fix an oob-write in test_verifier due to a missed MAX_NR_MAPS bump,
   from Kumar Kartikeya Dwivedi.

6) Fix a race in test_btf_skc_cls_ingress selftest, from Martin KaFai Lau.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Brendan Jackman, Daniel Borkmann, 
John Fastabend, Keith Wiles, Kuee K1r0a, Lorenzo Fontana, Maciej 
Fijalkowski, Ryota Shiga (Flatt Security)

----------------------------------------------------------------

The following changes since commit ab443c53916730862cec202078d36fd4008bea79:

  sch_cake: do not call cake_destroy() from cake_init() (2021-12-10 08:11:36 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to c2fcbf81c332b42382a0c439bfe2414a241e4f5b:

  bpf, selftests: Fix racing issue in btf_skc_cls_ingress test (2021-12-16 21:41:18 +0100)

----------------------------------------------------------------
Alexei Starovoitov (3):
      bpf: Fix extable fixup offset.
      bpf: Fix extable address check.
      selftest/bpf: Add a test that reads various addresses.

Daniel Borkmann (7):
      bpf: Fix kernel address leakage in atomic fetch
      bpf, selftests: Add test case for atomic fetch on spilled pointer
      bpf: Fix kernel address leakage in atomic cmpxchg's r0 aux reg
      bpf, selftests: Update test case for atomic cmpxchg on r0 with pointer
      bpf: Fix signed bounds propagation after mov32
      bpf: Make 32->64 bounds propagation slightly more robust
      bpf, selftests: Add test case trying to taint map value pointer

Kumar Kartikeya Dwivedi (1):
      selftests/bpf: Fix OOB write in test_verifier

Magnus Karlsson (1):
      xsk: Do not sleep in poll() when need_wakeup set

Martin KaFai Lau (1):
      bpf, selftests: Fix racing issue in btf_skc_cls_ingress test

Paul Chaignon (2):
      bpf: Fix incorrect state pruning for <8B spill/fill
      selftests/bpf: Tests for state pruning with u32 spill/fill

 arch/x86/net/bpf_jit_comp.c                        | 51 ++++++++++--
 kernel/bpf/verifier.c                              | 53 ++++++++----
 net/xdp/xsk.c                                      |  4 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        | 20 +++++
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c | 16 +++-
 .../selftests/bpf/progs/test_module_attach.c       | 12 +++
 tools/testing/selftests/bpf/test_verifier.c        |  2 +-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        | 86 ++++++++++++++++++++
 .../testing/selftests/bpf/verifier/atomic_fetch.c  | 94 ++++++++++++++++++++++
 .../selftests/bpf/verifier/search_pruning.c        | 71 ++++++++++++++++
 tools/testing/selftests/bpf/verifier/spill_fill.c  | 32 ++++++++
 .../selftests/bpf/verifier/value_ptr_arith.c       | 23 ++++++
 12 files changed, 434 insertions(+), 30 deletions(-)
