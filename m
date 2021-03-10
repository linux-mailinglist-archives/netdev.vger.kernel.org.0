Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52975334A2F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCJVzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:55:44 -0500
Received: from www62.your-server.de ([213.133.104.62]:58102 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbhCJVze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:55:34 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lK6ni-000CCL-Q3; Wed, 10 Mar 2021 22:55:30 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-03-10
Date:   Wed, 10 Mar 2021 22:55:30 +0100
Message-Id: <20210310215530.26047-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26104/Wed Mar 10 13:08:51 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 8 non-merge commits during the last 5 day(s) which contain
a total of 11 files changed, 136 insertions(+), 17 deletions(-).

The main changes are:

1) Reject bogus use of vmlinux BTF as map/prog creation BTF, from Alexei Starovoitov.

2) Fix allocation failure splat in x86 JIT for large progs. Also fix overwriting
   percpu cgroup storage from tracing programs when nested, from Yonghong Song.

3) Fix rx queue retrieval in XDP for multi-queue veth, from Maciej Fijalkowski.

4) Fix bpf_check_mtu() helper API before freeze to have mtu_len as custom skb/xdp
   L3 input length, from Jesper Dangaard Brouer.

5) Fix inode_storage's lookup_elem return value upon having bad fd, from Tal Lossos.

6) Fix bpftool and libbpf cross-build on MacOS, from Georgi Valkov.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

John Fastabend, KP Singh, Roman Gushchin, Toshiaki Makita, Yonghong Song

----------------------------------------------------------------

The following changes since commit d8861bab48b6c1fc3cdbcab8ff9d1eaea43afe7f:

  gianfar: fix jumbo packets+napi+rx overrun crash (2021-03-05 13:13:32 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to de920fc64cbaa031f947e9be964bda05fd090380:

  bpf, x86: Use kvmalloc_array instead kmalloc_array in bpf_jit_comp (2021-03-10 00:10:23 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Dont allow vmlinux BTF to be used in map_create and prog_load.

Georgi Valkov (1):
      libbpf: Fix INSTALL flag order

Jesper Dangaard Brouer (2):
      bpf: BPF-helper for MTU checking add length input
      selftests/bpf: Tests using bpf_check_mtu BPF-helper input mtu_len param

Maciej Fijalkowski (1):
      veth: Store queue_mapping independently of XDP prog presence

Tal Lossos (1):
      bpf: Change inode_storage's lookup_elem return value from NULL to -EBADF

Yonghong Song (2):
      bpf: Don't do bpf_cgroup_storage_set() for kuprobe/tp programs
      bpf, x86: Use kvmalloc_array instead kmalloc_array in bpf_jit_comp

 arch/x86/net/bpf_jit_comp.c                        |  4 +-
 drivers/net/veth.c                                 |  3 +-
 include/linux/bpf.h                                |  9 ++-
 include/uapi/linux/bpf.h                           | 16 ++--
 kernel/bpf/bpf_inode_storage.c                     |  2 +-
 kernel/bpf/syscall.c                               |  5 ++
 kernel/bpf/verifier.c                              |  4 +
 net/core/filter.c                                  | 12 ++-
 tools/lib/bpf/Makefile                             |  2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |  4 +
 tools/testing/selftests/bpf/progs/test_check_mtu.c | 92 ++++++++++++++++++++++
 11 files changed, 136 insertions(+), 17 deletions(-)
