Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2777166D28D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbjAPXIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjAPXHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:07:51 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58A1234F4;
        Mon, 16 Jan 2023 15:07:48 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pHYZt-000IXw-Me; Tue, 17 Jan 2023 00:07:45 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-01-16
Date:   Tue, 17 Jan 2023 00:07:45 +0100
Message-Id: <20230116230745.21742-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26783/Mon Jan 16 09:28:30 2023)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 8 day(s) which contain
a total of 6 files changed, 22 insertions(+), 24 deletions(-).

The main changes are:

1) Mitigate a Spectre v4 leak in unprivileged BPF from speculative
   pointer-as-scalar type confusion, from Luis Gerhorst.

2) Fix a splat when pid 1 attaches a BPF program that attempts to
   send killing signal to itself, from Hao Sun.

3) Fix BPF program ID information in BPF_AUDIT_UNLOAD as well as
   PERF_BPF_EVENT_PROG_UNLOAD events, from Paul Moore.

4) Fix BPF verifier warning triggered from invalid kfunc call in
   backtrack_insn, also from Hao Sun.

5) Fix potential deadlock in htab_lock_bucket from same bucket index
   but different map_locked index, from Tonghao Zhang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Burn Alting, Henriette Hofmeier, Hou Tao, Jiri Olsa, Stanislav Fomichev, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit c244c092f1ed2acfb5af3d3da81e22367d3dd733:

  tipc: fix unexpected link reset due to discovery messages (2023-01-06 12:53:10 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to e4f4db47794c9f474b184ee1418f42e6a07412b6:

  bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation (2023-01-13 17:18:35 +0100)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Hao Sun (2):
      bpf: Skip invalid kfunc call in backtrack_insn
      bpf: Skip task with pid=1 in send_signal_common()

Luis Gerhorst (1):
      bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Paul Moore (2):
      bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD
      bpf: remove the do_idr_lock parameter from bpf_prog_free_id()

Tonghao Zhang (1):
      bpf: hash map, avoid deadlock with suitable hash mask

 include/linux/bpf.h      |  2 +-
 kernel/bpf/hashtab.c     |  4 ++--
 kernel/bpf/offload.c     |  3 ---
 kernel/bpf/syscall.c     | 24 +++++++-----------------
 kernel/bpf/verifier.c    | 10 +++++++++-
 kernel/trace/bpf_trace.c |  3 +++
 6 files changed, 22 insertions(+), 24 deletions(-)
