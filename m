Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A0512701B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLSV6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:58:17 -0500
Received: from www62.your-server.de ([213.133.104.62]:37282 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSV6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:58:17 -0500
Received: from 31.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.31] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ii3oD-0007Lh-5b; Thu, 19 Dec 2019 22:58:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-12-19
Date:   Thu, 19 Dec 2019 22:58:12 +0100
Message-Id: <20191219215812.20451-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 8 day(s) which contain
a total of 21 files changed, 269 insertions(+), 108 deletions(-).

The main changes are:

1) Fix lack of synchronization between xsk wakeup and destroying resources
   used by xsk wakeup, from Maxim Mikityanskiy.

2) Fix pruning with tail call patching, untrack programs in case of verifier
   error and fix a cgroup local storage tracking bug, from Daniel Borkmann.

3) Fix clearing skb->tstamp in bpf_redirect() when going from ingress to
   egress which otherwise cause issues e.g. on fq qdisc, from Lorenz Bauer.

4) Fix compile warning of unused proc_dointvec_minmax_bpf_restricted() when
   only cBPF is present, from Alexander Lobakin.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Eric Dumazet, Yonghong Song

----------------------------------------------------------------

The following changes since commit 0af67e49b018e7280a4227bfe7b6005bc9d3e442:

  qede: Fix multicast mac configuration (2019-12-12 11:08:36 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 3123d8018d4686cf193806c4e27a9853550ed895:

  bpf: Add further test_verifier cases for record_func_key (2019-12-19 13:39:22 -0800)

----------------------------------------------------------------
Alexander Lobakin (1):
      net, sysctl: Fix compiler warning when only cBPF is present

Daniel Borkmann (5):
      bpf: Fix missing prog untrack in release_maps
      bpf: Fix cgroup local storage prog tracking
      Merge branch 'bpf-fix-xsk-wakeup'
      bpf: Fix record_func_key to perform backtracking on r3
      bpf: Add further test_verifier cases for record_func_key

Lorenz Bauer (1):
      bpf: Clear skb->tstamp in bpf_redirect when necessary

Maxim Mikityanskiy (4):
      xsk: Add rcu_read_lock around the XSK wakeup
      net/mlx5e: Fix concurrency issues between config flow and XSK
      net/i40e: Fix concurrency issues between config flow and XSK
      net/ixgbe: Fix concurrency issues between config flow and XSK

 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  22 ++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +--
 include/linux/bpf-cgroup.h                         |   8 +-
 include/linux/bpf.h                                |   2 +
 kernel/bpf/core.c                                  |  17 ++-
 kernel/bpf/local_storage.c                         |  24 ++--
 kernel/bpf/verifier.c                              |  24 ++--
 net/core/filter.c                                  |   1 +
 net/core/sysctl_net_core.c                         |   2 +
 net/xdp/xsk.c                                      |  22 +--
 tools/testing/selftests/bpf/test_verifier.c        |  43 +++---
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   6 +-
 tools/testing/selftests/bpf/verifier/runtime_jit.c | 151 +++++++++++++++++++++
 21 files changed, 269 insertions(+), 108 deletions(-)
