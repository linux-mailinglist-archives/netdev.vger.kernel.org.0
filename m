Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C0234734
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgGaNv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:51:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:42674 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbgGaNv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:51:57 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1VRp-0005M1-Hp; Fri, 31 Jul 2020 15:51:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        jolsa@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-07-31
Date:   Fri, 31 Jul 2020 15:51:45 +0200
Message-Id: <20200731135145.15003-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25889/Thu Jul 30 17:03:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 21 day(s) which contain
a total of 5 files changed, 126 insertions(+), 18 deletions(-).

The main changes are:

1) Fix a map element leak in HASH_OF_MAPS map type, from Andrii Nakryiko.

2) Fix a NULL pointer dereference in __btf_resolve_helper_id() when no
   btf_vmlinux is available, from Peilin Ye.

3) Init pos variable in __bpfilter_process_sockopt(), from Christoph Hellwig.

4) Fix a cgroup sockopt verifier test by specifying expected attach type,
   from Jean-Philippe Brucker.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Note that when net gets merged into net-next later on, there is a small
merge conflict in kernel/bpf/btf.c between commit 5b801dfb7feb ("bpf: Fix
NULL pointer dereference in __btf_resolve_helper_id()") from the bpf tree
and commit 138b9a0511c7 ("bpf: Remove btf_id helpers resolving") from the
net-next tree.

Resolve as follows: remove the old hunk with the __btf_resolve_helper_id()
function. Change the btf_resolve_helper_id() so it actually tests for a
NULL btf_vmlinux and bails out:

int btf_resolve_helper_id(struct bpf_verifier_log *log,
                          const struct bpf_func_proto *fn, int arg)
{
        int id;

        if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID || !btf_vmlinux)
                return -EINVAL;
        id = fn->btf_id[arg];
        if (!id || id > btf_vmlinux->nr_types)
                return -EINVAL;
        return id;
}

Let me know if you run into any others issues (CC'ing Jiri Olsa so he's in
the loop with regards to merge conflict resolution).

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Christian Brauner, Jakub Sitnicki, Rodrigo Madera, Song Liu

----------------------------------------------------------------

The following changes since commit c8b1d7436045d3599bae56aef1682813ecccaad7:

  bnxt_en: fix NULL dereference in case SR-IOV configuration fails (2020-07-10 14:20:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 4f010246b4087ab931b060481014ec110e6a8a46:

  net/bpfilter: Initialize pos in __bpfilter_process_sockopt (2020-07-31 01:07:32 +0200)

----------------------------------------------------------------
Andrii Nakryiko (2):
      bpf: Fix map leak in HASH_OF_MAPS map
      selftests/bpf: Extend map-in-map selftest to detect memory leaks

Christoph Hellwig (1):
      net/bpfilter: Initialize pos in __bpfilter_process_sockopt

Jean-Philippe Brucker (1):
      selftests/bpf: Fix cgroup sockopt verifier test

Peilin Ye (1):
      bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()

 kernel/bpf/btf.c                                   |   5 +
 kernel/bpf/hashtab.c                               |  12 +-
 net/bpfilter/bpfilter_kern.c                       |   2 +-
 .../selftests/bpf/prog_tests/btf_map_in_map.c      | 124 ++++++++++++++++++---
 .../testing/selftests/bpf/verifier/event_output.c  |   1 +
 5 files changed, 126 insertions(+), 18 deletions(-)
