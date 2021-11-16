Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0052E4533CE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhKPOOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:14:34 -0500
Received: from www62.your-server.de ([213.133.104.62]:59430 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbhKPOOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:14:33 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mmzBO-000CTx-NC; Tue, 16 Nov 2021 15:11:34 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-11-16
Date:   Tue, 16 Nov 2021 15:11:34 +0100
Message-Id: <20211116141134.6490-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26355/Tue Nov 16 10:24:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 5 day(s) which contain
a total of 23 files changed, 573 insertions(+), 73 deletions(-).

The main changes are:

1) Fix pruning regression where verifier went overly conservative rejecting
   previsouly accepted programs, from Alexei Starovoitov and Lorenz Bauer.

2) Fix verifier TOCTOU bug when using read-only map's values as constant
   scalars during verification, from Daniel Borkmann.

3) Fix a crash due to a double free in XSK's buffer pool, from Magnus Karlsson.

4) Fix libbpf regression when cross-building runqslower, from Jean-Philippe Brucker.

5) Forbid use of bpf_ktime_get_coarse_ns() and bpf_timer_*() helpers in tracing
   programs due to deadlock possibilities, from Dmitrii Banshchikov.

6) Fix checksum validation in sockmap's udp_read_sock() callback, from Cong Wang.

7) Various BPF sample fixes such as XDP stats in xdp_sample_user, from Alexander Lobakin.

8) Fix libbpf gen_loader error handling wrt fd cleanup, from Kumar Kartikeya Dwivedi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Lobakin, Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, 
Daniel Borkmann, Jesse Brandeburg, John Fastabend, Kumar Kartikeya 
Dwivedi, Lorenz Bauer, Michal Swiatkowski, Quentin Monnet

----------------------------------------------------------------

The following changes since commit 5833291ab6de9c3e2374336b51c814e515e8f3a5:

  Merge tag 'pci-v5.16-fixes-1' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2021-11-11 15:10:18 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 099f896f498a2b26d84f4ddae039b2c542c18b48:

  udp: Validate checksum in udp_read_sock() (2021-11-16 13:18:23 +0100)

----------------------------------------------------------------
Alexander Lobakin (2):
      samples/bpf: Fix summary per-sec stats in xdp_sample_user
      samples/bpf: Fix build error due to -isystem removal

Alexei Starovoitov (2):
      bpf: Fix inner map state pruning regression.
      Merge branch 'Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs'

Cong Wang (1):
      udp: Validate checksum in udp_read_sock()

Daniel Borkmann (1):
      bpf: Fix toctou on read-only map's constant scalar tracking

Dmitrii Banshchikov (2):
      bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs
      selftests/bpf: Add tests for restricted helpers

Jean-Philippe Brucker (1):
      tools/runqslower: Fix cross-build

Kumar Kartikeya Dwivedi (2):
      samples/bpf: Fix incorrect use of strlen in xdp_redirect_cpu
      libbpf: Perform map fd cleanup for gen_loader in case of error

Lorenz Bauer (1):
      selftests/bpf: Check map in map pruning

Magnus Karlsson (1):
      xsk: Fix crash on double free in buffer pool

 include/linux/bpf.h                                |   3 +-
 kernel/bpf/cgroup.c                                |   2 +
 kernel/bpf/helpers.c                               |   2 -
 kernel/bpf/syscall.c                               |  57 +++---
 kernel/bpf/verifier.c                              |  27 ++-
 kernel/trace/bpf_trace.c                           |   2 -
 net/core/filter.c                                  |   6 +
 net/ipv4/bpf_tcp_ca.c                              |   2 +
 net/ipv4/udp.c                                     |  11 ++
 net/xdp/xsk_buff_pool.c                            |   7 +-
 samples/bpf/hbm_kern.h                             |   2 -
 samples/bpf/xdp_redirect_cpu_user.c                |   5 +-
 samples/bpf/xdp_sample_user.c                      |  28 +--
 tools/bpf/runqslower/Makefile                      |   3 +-
 tools/lib/bpf/bpf_gen_internal.h                   |   4 +-
 tools/lib/bpf/gen_loader.c                         |  47 +++--
 tools/lib/bpf/libbpf.c                             |   4 +-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 .../selftests/bpf/prog_tests/helper_restricted.c   |  33 ++++
 .../selftests/bpf/progs/test_helper_restricted.c   | 123 +++++++++++++
 tools/testing/selftests/bpf/test_verifier.c        |  46 ++++-
 .../selftests/bpf/verifier/helper_restricted.c     | 196 +++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/map_in_map.c  |  34 ++++
 23 files changed, 573 insertions(+), 73 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/verifier/helper_restricted.c
