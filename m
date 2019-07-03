Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD50A5E7DD
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGCPbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:31:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:58772 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:31:10 -0400
Received: from [178.193.45.231] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hihDu-0004Ry-OM; Wed, 03 Jul 2019 17:31:06 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-07-03
Date:   Wed,  3 Jul 2019 17:31:06 +0200
Message-Id: <20190703153106.26356-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix the interpreter to properly handle BPF_ALU32 | BPF_ARSH
   on BE architectures, from Jiong.

2) Fix several bugs in the x32 BPF JIT for handling shifts by 0,
   from Luke and Xi.

3) Fix NULL pointer deref in btf_type_is_resolve_source_only(),
   from Stanislav.

4) Properly handle the check that forwarding is enabled on the device
   in bpf_ipv6_fib_lookup() helper code, from Anton.

5) Fix UAPI bpf_prog_info fields alignment for archs that have 16 bit
   alignment such as m68k, from Baruch.

6) Fix kernel hanging in unregister_netdevice loop while unregistering
   device bound to XDP socket, from Ilya.

7) Properly terminate tail update in xskq_produce_flush_desc(), from Nathan.

8) Fix broken always_inline handling in test_lwt_seg6local, from Jiri.

9) Fix bpftool to use correct argument in cgroup errors, from Jakub.

10) Fix detaching dummy prog in XDP redirect sample code, from Prashant.

11) Add Jonathan to AF_XDP reviewers, from Björn.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 4fddbf8a99ee5a65bdd31b3ebbf5a84b9395d496:

  Merge branch 'tcp-fixes' (2019-06-17 10:39:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 455302d1c9ae9318660aaeb9748a01ff414c9741:

  xdp: fix hang while unregistering device bound to xdp socket (2019-07-03 15:10:55 +0200)

----------------------------------------------------------------
Anton Protopopov (1):
      bpf: fix the check that forwarding is enabled in bpf_ipv6_fib_lookup

Baruch Siach (1):
      bpf: fix uapi bpf_prog_info fields alignment

Björn Töpel (1):
      MAINTAINERS: add reviewer to maintainers entry

Ilya Maximets (2):
      xdp: hold device for umem regardless of zero-copy mode
      xdp: fix hang while unregistering device bound to xdp socket

Jakub Kicinski (1):
      tools: bpftool: use correct argument in cgroup errors

Jiong Wang (1):
      bpf: fix BPF_ALU32 | BPF_ARSH on BE arches

Jiri Benc (1):
      selftests: bpf: fix inlines in test_lwt_seg6local

Luke Nelson (3):
      bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_X shift by 0
      bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by 0
      selftests: bpf: add tests for shifts by zero

Nathan Chancellor (1):
      xsk: Properly terminate assignment in xskq_produce_flush_desc

Prashant Bhole (1):
      samples/bpf: xdp_redirect, correctly get dummy program id

Stanislav Fomichev (1):
      bpf: fix NULL deref in btf_type_is_resolve_source_only

 MAINTAINERS                                        |   1 +
 arch/x86/net/bpf_jit_comp32.c                      | 284 +++------------------
 include/net/xdp_sock.h                             |   5 +
 include/uapi/linux/bpf.h                           |   1 +
 kernel/bpf/btf.c                                   |  12 +-
 kernel/bpf/core.c                                  |   4 +-
 net/core/filter.c                                  |   2 +-
 net/xdp/xdp_umem.c                                 |  21 +-
 net/xdp/xdp_umem.h                                 |   1 +
 net/xdp/xsk.c                                      |  87 ++++++-
 net/xdp/xsk_queue.h                                |   2 +-
 samples/bpf/xdp_redirect_user.c                    |   2 +-
 tools/bpf/bpftool/cgroup.c                         |   6 +-
 tools/include/uapi/linux/bpf.h                     |   1 +
 .../selftests/bpf/progs/test_lwt_seg6local.c       |  12 +-
 tools/testing/selftests/bpf/verifier/basic_instr.c |  85 ++++++
 16 files changed, 230 insertions(+), 296 deletions(-)
