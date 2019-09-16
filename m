Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84A7B38EB
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfIPK5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:57:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:57744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPK5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:57:21 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9oDG-0004Qb-Fv; Mon, 16 Sep 2019 12:26:30 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-09-16
Date:   Mon, 16 Sep 2019 12:26:30 +0200
Message-Id: <20190916102630.14491-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25574/Mon Sep 16 10:25:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

The main changes are:

1) Now that initial BPF backend for gcc has been merged upstream, enable
   BPF kselftest suite for bpf-gcc. Also fix a BE issue with access to
   bpf_sysctl.file_pos, from Ilya.

2) Follow-up fix for link-vmlinux.sh to remove bash-specific extensions
   related to recent work on exposing BTF info through sysfs, from Andrii.

3) AF_XDP zero copy fixes for i40e and ixgbe driver which caused umem
   headroom to be added twice, from Ciara.

4) Refactoring work to convert sock opt tests into test_progs framework
   in BPF kselftests, from Stanislav.

5) Fix a general protection fault in dev_map_hash_update_elem(), from Toke.

6) Cleanup to use BPF_PROG_RUN() macro in KCM, from Sami.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 1e46c09ec10049a9e366153b32e41cc557383fdb:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2019-09-06 16:49:17 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to d895a0f16fadb26d22ab531c49768f7642ae5c3e:

  bpf: fix accessing bpf_sysctl.file_pos on s390 (2019-09-16 11:44:05 +0200)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'move-sockopt-tests'

Andrii Nakryiko (1):
      kbuild: replace BASH-specific ${@:2} with shift and ${@}

Ciara Loftus (3):
      i40e: fix xdp handle calculations
      ixgbe: fix xdp handle calculations
      samples/bpf: fix xdpsock l2fwd tx for unaligned mode

Daniel Borkmann (1):
      Merge branch 'bpf-af-xdp-unaligned-fixes'

Ilya Leoshkevich (2):
      selftests/bpf: add bpf-gcc support
      bpf: fix accessing bpf_sysctl.file_pos on s390

Sami Tolvanen (1):
      kcm: use BPF_PROG_RUN

Stanislav Fomichev (6):
      selftests/bpf: test_progs: add test__join_cgroup helper
      selftests/bpf: test_progs: convert test_sockopt
      selftests/bpf: test_progs: convert test_sockopt_sk
      selftests/bpf: test_progs: convert test_sockopt_multi
      selftests/bpf: test_progs: convert test_sockopt_inherit
      selftests/bpf: test_progs: convert test_tcp_rtt

Toke Høiland-Jørgensen (1):
      xdp: Fix race in dev_map_hash_update_elem() when replacing element

 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 include/linux/filter.h                             |   8 +-
 kernel/bpf/cgroup.c                                |  10 +-
 kernel/bpf/devmap.c                                |  17 +++-
 kernel/bpf/verifier.c                              |   4 +-
 net/kcm/kcmsock.c                                  |   2 +-
 samples/bpf/xdpsock_user.c                         |   2 +-
 scripts/link-vmlinux.sh                            |  16 +++-
 tools/testing/selftests/bpf/.gitignore             |   5 -
 tools/testing/selftests/bpf/Makefile               |  77 +++++++++++-----
 tools/testing/selftests/bpf/bpf_helpers.h          |  24 +++--
 .../bpf/{test_sockopt.c => prog_tests/sockopt.c}   |  50 ++--------
 .../sockopt_inherit.c}                             | 102 +++++++++------------
 .../sockopt_multi.c}                               |  62 ++-----------
 .../{test_sockopt_sk.c => prog_tests/sockopt_sk.c} |  60 +++---------
 .../bpf/{test_tcp_rtt.c => prog_tests/tcp_rtt.c}   |  83 ++++++-----------
 tools/testing/selftests/bpf/progs/test_tc_edt.c    |   1 +
 tools/testing/selftests/bpf/test_progs.c           |  38 ++++++++
 tools/testing/selftests/bpf/test_progs.h           |   4 +-
 tools/testing/selftests/bpf/test_sysctl.c          |   9 +-
 21 files changed, 260 insertions(+), 322 deletions(-)
 rename tools/testing/selftests/bpf/{test_sockopt.c => prog_tests/sockopt.c} (96%)
 rename tools/testing/selftests/bpf/{test_sockopt_inherit.c => prog_tests/sockopt_inherit.c} (72%)
 rename tools/testing/selftests/bpf/{test_sockopt_multi.c => prog_tests/sockopt_multi.c} (83%)
 rename tools/testing/selftests/bpf/{test_sockopt_sk.c => prog_tests/sockopt_sk.c} (79%)
 rename tools/testing/selftests/bpf/{test_tcp_rtt.c => prog_tests/tcp_rtt.c} (76%)
