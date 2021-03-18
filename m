Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E65D33FC47
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 01:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhCRAhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 20:37:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:55264 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhCRAgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 20:36:38 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMgeR-0001Cj-KS; Thu, 18 Mar 2021 01:36:35 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-03-18
Date:   Thu, 18 Mar 2021 01:36:35 +0100
Message-Id: <20210318003635.18127-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26111/Wed Mar 17 12:08:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 4 day(s) which contain
a total of 14 files changed, 336 insertions(+), 94 deletions(-).

The main changes are:

1) Fix fexit/fmod_ret trampoline for sleepable programs, and also fix a ftrace
   splat in modify_ftrace_direct() on address change, from Alexei Starovoitov.

2) Fix two oob speculation possibilities that allows unprivileged to leak mem
   via side-channel, from Piotr Krysiuk and Daniel Borkmann.

3) Fix libbpf's netlink handling wrt SOCK_CLOEXEC, from Kumar Kartikeya Dwivedi.

4) Fix libbpf's error handling on failure in getting section names, from Namhyung Kim.

5) Fix tunnel collect_md BPF selftest wrt Geneve option handling, from Hangbin Liu.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Paul E. McKenney, Steven Rostedt 
(VMware), Toke Høiland-Jørgensen, William Tu

----------------------------------------------------------------

The following changes since commit a25f822285420486f5da434efc8d940d42a83bce:

  flow_dissector: fix byteorder of dissected ICMP ID (2021-03-14 14:30:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 58bfd95b554f1a23d01228672f86bb489bdbf4ba:

  libbpf: Use SOCK_CLOEXEC when opening the netlink socket (2021-03-18 00:50:21 +0100)

----------------------------------------------------------------
Alexei Starovoitov (2):
      ftrace: Fix modify_ftrace_direct.
      bpf: Fix fexit trampoline.

Hangbin Liu (1):
      selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed

Kumar Kartikeya Dwivedi (1):
      libbpf: Use SOCK_CLOEXEC when opening the netlink socket

Namhyung Kim (1):
      libbpf: Fix error path in bpf_object__elf_init()

Piotr Krysiuk (5):
      bpf: Prohibit alu ops for pointer types not defining ptr_limit
      bpf: Fix off-by-one for area size in creating mask to left
      bpf: Simplify alu_limit masking for pointer arithmetic
      bpf: Add sanity check for upper ptr_limit
      bpf, selftests: Fix up some test_verifier cases for unprivileged

 arch/x86/net/bpf_jit_comp.c                        |  26 ++-
 include/linux/bpf.h                                |  24 ++-
 kernel/bpf/bpf_struct_ops.c                        |   2 +-
 kernel/bpf/core.c                                  |   4 +-
 kernel/bpf/trampoline.c                            | 218 ++++++++++++++++-----
 kernel/bpf/verifier.c                              |  33 ++--
 kernel/trace/ftrace.c                              |  43 +++-
 tools/lib/bpf/libbpf.c                             |   3 +-
 tools/lib/bpf/netlink.c                            |   2 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   6 +-
 .../selftests/bpf/verifier/bounds_deduction.c      |  27 ++-
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   4 +
 tools/testing/selftests/bpf/verifier/unpriv.c      |  15 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 ++-
 14 files changed, 336 insertions(+), 94 deletions(-)
