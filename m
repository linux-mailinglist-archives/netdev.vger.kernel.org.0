Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAB1AA2AD
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505663AbgDOM7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:59:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:47350 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505660AbgDOM7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 08:59:22 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jOhdB-00037I-7N; Wed, 15 Apr 2020 14:59:05 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-04-15
Date:   Wed, 15 Apr 2020 14:59:04 +0200
Message-Id: <20200415125904.22480-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25783/Wed Apr 15 14:03:13 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 3 day(s) which contain
a total of 11 files changed, 238 insertions(+), 95 deletions(-).

The main changes are:

1) Fix offset overflow for BPF_MEM BPF_DW insn mapping on arm32 JIT,
   from Luke Nelson and Xi Wang.

2) Prevent mprotect() to make frozen & mmap()'ed BPF map writeable
   again, from Andrii Nakryiko and Jann Horn.

3) Fix type of old_fd in bpf_xdp_set_link_opts to int in libbpf and add
   selftests, from Toke Høiland-Jørgensen.

4) Fix AF_XDP to check that headroom cannot be larger than the available
   space in the chunk, from Magnus Karlsson.

5) Fix reset of XDP prog when expected_fd is set, from David Ahern.

6) Fix a segfault in bpftool's struct_ops command when BTF is not
   available, from Daniel T. Lee.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrey Ignatov, Bui Quang Minh, David Ahern, Hulk Robot, Jakub Kicinski, 
Jann Horn, Martin KaFai Lau, Song Liu, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit e154659ba39a1c2be576aaa0a5bda8088d707950:

  mptcp: fix double-unlock in mptcp_poll (2020-04-12 21:04:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to c6c111523d9e697bfb463870759825be5d6caff6:

  selftests/bpf: Check for correct program attach/detach in xdp_attach test (2020-04-15 13:26:08 +0200)

----------------------------------------------------------------
Andrii Nakryiko (3):
      bpf: Prevent re-mmap()'ing BPF map as writable for initially r/o mapping
      selftests/bpf: Validate frozen map contents stays frozen
      libbpf: Always specify expected_attach_type on program load if supported

Daniel T. Lee (1):
      tools, bpftool: Fix struct_ops command invalid pointer free

David Ahern (1):
      xdp: Reset prog in dev_change_xdp_fd when fd is negative

Luke Nelson (1):
      arm, bpf: Fix offset overflow for BPF_MEM BPF_DW

Magnus Karlsson (1):
      xsk: Add missing check on user supplied headroom size

Toke Høiland-Jørgensen (2):
      libbpf: Fix type of old_fd in bpf_xdp_set_link_opts
      selftests/bpf: Check for correct program attach/detach in xdp_attach test

Zou Wei (1):
      bpf: remove unneeded conversion to bool in __mark_reg_unknown

 arch/arm/net/bpf_jit_32.c                          |  40 ++++---
 kernel/bpf/syscall.c                               |  16 ++-
 kernel/bpf/verifier.c                              |   3 +-
 net/core/dev.c                                     |   3 +-
 net/xdp/xdp_umem.c                                 |   5 +-
 tools/bpf/bpftool/struct_ops.c                     |   4 +-
 tools/lib/bpf/libbpf.c                             | 126 ++++++++++++++-------
 tools/lib/bpf/libbpf.h                             |   2 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |  62 +++++++++-
 .../selftests/bpf/prog_tests/section_names.c       |  42 ++++---
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |  30 ++++-
 11 files changed, 238 insertions(+), 95 deletions(-)
