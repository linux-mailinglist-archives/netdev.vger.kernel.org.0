Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEDE2E6C52
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgL1Wzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:54814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbgL1V3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:29:16 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ku047-0009jH-BM; Mon, 28 Dec 2020 22:28:31 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org, bsd@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-12-28
Date:   Mon, 28 Dec 2020 22:28:30 +0100
Message-Id: <20201228212830.32406-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26031/Mon Dec 28 13:43:18 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

There is a small merge conflict between bpf tree commit 69ca310f3416
("bpf: Save correct stopping point in file seq iteration") and net tree
commit 66ed594409a1 ("bpf/task_iter: In task_file_seq_get_next use
task_lookup_next_fd_rcu"). The get_files_struct() does not exist anymore
in net, so take the hunk in HEAD and add the `info->tid = curr_tid` to
the error path:

  [...]
                curr_task = task_seq_get_next(ns, &curr_tid, true);
                if (!curr_task) {
                        info->task = NULL;
                        info->tid = curr_tid;
                        return NULL;
                }

                /* set info->task and info->tid */
  [...]

We've added 10 non-merge commits during the last 9 day(s) which contain
a total of 11 files changed, 75 insertions(+), 20 deletions(-).

The main changes are:

1) Various AF_XDP fixes such as fill/completion ring leak on failed bind and
   fixing a race in skb mode's backpressure mechanism, from Magnus Karlsson.

2) Fix latency spikes on lockdep enabled kernels by adding a rescheduling
   point to BPF hashtab initialization, from Eric Dumazet.

3) Fix a splat in task iterator by saving the correct stopping point in the
   seq file iteration, from Jonathan Lemon.

4) Fix BPF maps selftest by adding retries in case hashtab returns EBUSY
   errors on update/deletes, from Andrii Nakryiko.

5) Fix BPF selftest error reporting to something more user friendly if the
   vmlinux BTF cannot be found, from Kamal Mostafa.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, John Sperbeck, Song Liu, Xuan Zhuo

----------------------------------------------------------------

The following changes since commit 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9:

  Merge tag 'staging-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2020-12-15 14:18:40 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to a61daaf351da7c8493f2586437617d60c24350b0:

  bpf: Use thread_group_leader() (2020-12-24 02:04:53 +0100)

----------------------------------------------------------------
Andrii Nakryiko (1):
      selftests/bpf: Work-around EBUSY errors from hashmap update/delete

Colin Ian King (1):
      selftests/bpf: Fix spelling mistake "tranmission" -> "transmission"

Eric Dumazet (1):
      bpf: Add schedule point in htab_init_buckets()

Jonathan Lemon (2):
      bpf: Save correct stopping point in file seq iteration
      bpf: Use thread_group_leader()

Kamal Mostafa (1):
      selftests/bpf: Clarify build error if no vmlinux

Magnus Karlsson (3):
      xsk: Fix memory leak for failed bind
      xsk: Fix race in SKB mode transmit with shared cq
      xsk: Rollback reservation at NETDEV_TX_BUSY

Tian Tao (1):
      bpf: Remove unused including <linux/version.h>

 include/net/xdp_sock.h                   |  4 ---
 include/net/xsk_buff_pool.h              |  5 ++++
 kernel/bpf/hashtab.c                     |  1 +
 kernel/bpf/syscall.c                     |  1 -
 kernel/bpf/task_iter.c                   |  5 ++--
 net/xdp/xsk.c                            | 16 +++++++++--
 net/xdp/xsk_buff_pool.c                  |  3 +-
 net/xdp/xsk_queue.h                      |  5 ++++
 tools/testing/selftests/bpf/Makefile     |  3 ++
 tools/testing/selftests/bpf/test_maps.c  | 48 ++++++++++++++++++++++++++++----
 tools/testing/selftests/bpf/xdpxceiver.c |  4 +--
 11 files changed, 75 insertions(+), 20 deletions(-)
