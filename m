Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C4DC061D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfI0NPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:15:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:51496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfI0NPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 09:15:14 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDq5V-0007Ak-0x; Fri, 27 Sep 2019 15:15:09 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-09-27
Date:   Fri, 27 Sep 2019 15:15:08 +0200
Message-Id: <20190927131508.24576-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25585/Fri Sep 27 10:25:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix libbpf's BTF dumper to not skip anonymous enum definitions, from Andrii.

2) Fix BTF verifier issues when handling the BTF of vmlinux, from Alexei.

3) Fix nested calls into bpf_event_output() from TCP sockops BPF
   programs, from Allan.

4) Fix NULL pointer dereference in AF_XDP's xsk map creation when
   allocation fails, from Jonathan.

5) Remove unneeded 64 byte alignment requirement of the AF_XDP UMEM
   headroom, from Bjorn.

6) Remove unused XDP_OPTIONS getsockopt() call which results in an error
   on older kernels, from Toke.

7) Fix a client/server race in tcp_rtt BPF kselftest case, from Stanislav.

8) Fix indentation issue in BTF's btf_enum_check_kflag_member(), from Colin.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 280ceaed79f18db930c0cc8bb21f6493490bf29c:

  usbnet: sanity checking of packet sizes and device mtu (2019-09-19 13:27:11 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 768fb61fcc13b2acaca758275d54c09a65e2968b:

  bpf: Fix bpf_event_output re-entry issue (2019-09-27 11:24:29 +0200)

----------------------------------------------------------------
Alexei Starovoitov (2):
      bpf: fix BTF verification of enums
      bpf: fix BTF limits

Allan Zhang (1):
      bpf: Fix bpf_event_output re-entry issue

Andrii Nakryiko (4):
      libbpf: fix false uninitialized variable warning
      selftests/bpf: delete unused variables in test_sysctl
      selftests/bpf: adjust strobemeta loop to satisfy latest clang
      libbpf: Teach btf_dumper to emit stand-alone anonymous enum definitions

Björn Töpel (1):
      xsk: relax UMEM headroom alignment

Colin Ian King (1):
      bpf: Clean up indentation issue in BTF kflag processing

Jonathan Lemon (1):
      bpf/xskmap: Return ERR_PTR for failure case instead of NULL.

Stanislav Fomichev (1):
      selftests/bpf: test_progs: fix client/server race in tcp_rtt

Toke Høiland-Jørgensen (1):
      libbpf: Remove getsockopt() check for XDP_OPTIONS

 include/uapi/linux/btf.h                         |  4 +-
 kernel/bpf/btf.c                                 |  7 +-
 kernel/bpf/xskmap.c                              |  2 +-
 kernel/trace/bpf_trace.c                         | 26 +++++--
 net/xdp/xdp_umem.c                               |  2 -
 tools/lib/bpf/btf_dump.c                         | 94 ++++++++++++++++++++++--
 tools/lib/bpf/xsk.c                              | 11 ---
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 21 +++++-
 tools/testing/selftests/bpf/progs/strobemeta.h   |  5 +-
 tools/testing/selftests/bpf/test_sysctl.c        |  1 -
 10 files changed, 138 insertions(+), 35 deletions(-)
