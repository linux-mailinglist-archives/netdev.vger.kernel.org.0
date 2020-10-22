Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771662960C8
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900764AbgJVORi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:17:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:45056 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895076AbgJVORh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:17:37 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kVbPB-0005lw-Dm; Thu, 22 Oct 2020 16:17:25 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-10-22
Date:   Thu, 22 Oct 2020 16:17:24 +0200
Message-Id: <20201022141724.11010-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25965/Thu Oct 22 14:59:23 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 8 non-merge commits during the last 4 day(s) which contain
a total of 16 files changed, 426 insertions(+), 102 deletions(-).

The main changes are:

1) Fix enforcing NULL check in verifier for new helper return types of
   RET_PTR_TO_{BTF_ID,MEM_OR_BTF_ID}_OR_NULL, from Martin KaFai Lau.

2) Fix bpf_redirect_neigh() helper API before it becomes frozen by adding
   nexthop information as argument, from Toke Høiland-Jørgensen.

3) Guard & fix compilation of bpf_tail_call_static() when __bpf__ arch is
   not defined by compiler or clang too old, from Daniel Borkmann.

4) Remove misplaced break after return in attach_type_to_prog_type(), from
   Tom Rix.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, David Ahern, Yaniv Agman, Yonghong Song

----------------------------------------------------------------

The following changes since commit 0e8b8d6a2d85344d80dda5beadd98f5f86e8d3d3:

  net: core: use list_del_init() instead of list_del() in netdev_run_todo() (2020-10-18 14:50:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 3652c9a1b1fe6cbdd4510eb220db548bff8704ae:

  bpf, libbpf: Guard bpf inline asm from bpf_tail_call_static (2020-10-22 01:46:52 +0200)

----------------------------------------------------------------
Daniel Borkmann (2):
      bpf, doc: Fix patchwork URL to point to kernel.org instance
      bpf, libbpf: Guard bpf inline asm from bpf_tail_call_static

Martin KaFai Lau (3):
      bpf: Enforce id generation for all may-be-null register type
      bpf: selftest: Ensure the return value of bpf_skc_to helpers must be checked
      bpf: selftest: Ensure the return value of the bpf_per_cpu_ptr() must be checked

Toke Høiland-Jørgensen (2):
      bpf: Fix bpf_redirect_neigh helper api to support supplying nexthop
      bpf, selftests: Extend test_tc_redirect to use modified bpf_redirect_neigh()

Tom Rix (1):
      bpf: Remove unneeded break

 MAINTAINERS                                        |   3 +-
 include/linux/filter.h                             |   9 ++
 include/uapi/linux/bpf.h                           |  22 ++-
 kernel/bpf/syscall.c                               |   1 -
 kernel/bpf/verifier.c                              |  11 +-
 net/core/filter.c                                  | 158 +++++++++++++--------
 samples/bpf/sockex3_kern.c                         |   8 +-
 scripts/bpf_helpers_doc.py                         |   1 +
 tools/include/uapi/linux/bpf.h                     |  22 ++-
 tools/lib/bpf/bpf_helpers.h                        |   2 +
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |  57 +++++---
 .../bpf/progs/test_ksyms_btf_null_check.c          |  31 ++++
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |   5 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c        | 155 ++++++++++++++++++++
 tools/testing/selftests/bpf/test_tc_redirect.sh    |  18 ++-
 tools/testing/selftests/bpf/verifier/sock.c        |  25 ++++
 16 files changed, 426 insertions(+), 102 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c
