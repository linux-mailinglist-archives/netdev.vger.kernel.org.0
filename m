Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5541EC3D2
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFBUlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:41:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:58912 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgFBUlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:41:04 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jgDiO-00040o-DE; Tue, 02 Jun 2020 22:40:52 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-06-02
Date:   Tue,  2 Jun 2020 22:40:51 +0200
Message-Id: <20200602204051.29623-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25831/Tue Jun  2 14:41:03 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF _fixes-only_ for your *net-next*
tree.

We've added 10 non-merge commits during the last 1 day(s) which contain
a total of 15 files changed, 229 insertions(+), 74 deletions(-).

The main changes are:

1) Several fixes to s390 BPF JIT e.g. fixing kernel panic when BPF stack is
   not 8-byte aligned, from Ilya Leoshkevich.

2) Fix bpf_skb_adjust_room() helper's CHECKSUM_UNNECESSARY handling which
   was wrongly bypassing TCP checksum verification, from Daniel Borkmann.

3) Fix tools/bpf/ build under MAKEFLAGS=rR which causes built-in CXX and
   others vars to be undefined, also from Ilya Leoshkevich.

4) Fix BPF ringbuf's selftest shared sample_cnt variable to avoid compiler
   optimizations on it, from Andrii Nakryiko.

5) Fix up test_verifier selftest due to addition of rx_queue_mapping to
   the bpf_sock structure, from Alexei Starovoitov.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Lorenz Bauer, Song Liu

----------------------------------------------------------------

The following changes since commit 9a25c1df24a6fea9dc79eec950453c4e00f707fd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2020-06-01 15:53:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to e7ad28e6fdbffa2b9b1bd376431fb81a5403bcfd:

  selftests/bpf: Add a default $(CXX) value (2020-06-02 22:03:25 +0200)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'csum-fixes'
      selftests/bpf: Fix verifier test

Andrii Nakryiko (1):
      selftests/bpf: Fix sample_cnt shared between two threads

Daniel Borkmann (3):
      bpf: Fix up bpf_skb_adjust_room helper's skb csum setting
      bpf: Add csum_level helper for fixing up csum levels
      bpf, selftests: Adapt cls_redirect to call csum_level helper

Ilya Leoshkevich (5):
      s390/bpf: Maintain 8-byte stack alignment
      s390/bpf: Use bcr 0,%0 as tail call nop filler
      bpf, selftests: Use bpf_probe_read_kernel
      tools/bpf: Don't use $(COMPILE.c)
      selftests/bpf: Add a default $(CXX) value

 arch/s390/net/bpf_jit_comp.c                       | 22 +++++-----
 include/linux/skbuff.h                             |  8 ++++
 include/uapi/linux/bpf.h                           | 51 +++++++++++++++++++++-
 net/core/filter.c                                  | 46 ++++++++++++++++++-
 tools/bpf/Makefile                                 |  6 +--
 tools/bpf/bpftool/Makefile                         |  8 ++--
 tools/include/uapi/linux/bpf.h                     | 51 +++++++++++++++++++++-
 tools/testing/selftests/bpf/Makefile               |  2 +
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |  2 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |  9 ++--
 tools/testing/selftests/bpf/verifier/const_or.c    |  8 ++--
 .../selftests/bpf/verifier/helper_access_var_len.c | 44 +++++++++----------
 .../selftests/bpf/verifier/helper_value_access.c   | 36 +++++++--------
 tools/testing/selftests/bpf/verifier/precise.c     |  8 ++--
 tools/testing/selftests/bpf/verifier/sock.c        |  2 +-
 15 files changed, 229 insertions(+), 74 deletions(-)
