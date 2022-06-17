Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21754FE3A
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242932AbiFQUV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbiFQUV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:21:26 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6108850031;
        Fri, 17 Jun 2022 13:21:22 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2IT2-000G49-3o; Fri, 17 Jun 2022 22:21:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-06-17
Date:   Fri, 17 Jun 2022 22:21:19 +0200
Message-Id: <20220617202119.2421-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26575/Fri Jun 17 10:08:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 4 day(s) which contain
a total of 14 files changed, 305 insertions(+), 107 deletions(-).

The main changes are:

1) Fix x86 JIT tailcall count offset on BPF-2-BPF call, from Jakub Sitnicki.

2) Fix a kprobe_multi link bug which misplaces BPF cookies, from Jiri Olsa.

3) Fix an infinite loop when processing a module's BTF, from Kumar Kartikeya Dwivedi.

4) Fix getting a rethook only in RCU available context, from Masami Hiramatsu.

5) Fix request socket refcount leak in sk lookup helpers, from Jon Maxwell.

6) Fix xsk xmit behavior which wrongly adds skb to already full cq, from Ciara Loftus.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Curtis Taylor, Daniel Borkmann, 
Jiri Olsa, John Fastabend, Maciej Fijalkowski, Magnus Karlsson, Song 
Liu, Steven Rostedt (Google), Yonghong Song

----------------------------------------------------------------

The following changes since commit 4b7a632ac4e7101ceefee8484d5c2ca505d347b3:

  mlxsw: spectrum_cnt: Reorder counter pools (2022-06-14 16:00:37 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to c0f3bb4054ef036e5f67e27f2e3cad9e6512cf00:

  rethook: Reject getting a rethook if RCU is not watching (2022-06-17 21:53:35 +0200)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'bpf: Fix cookie values for kprobe multi'

Ciara Loftus (1):
      xsk: Fix generic transmit when completion queue reservation fails

Daniel Borkmann (1):
      bpf, docs: Update some of the JIT/maintenance entries

Jakub Sitnicki (2):
      bpf, x86: Fix tail call count offset calculation on bpf2bpf call
      selftests/bpf: Test tail call counting with bpf2bpf and data on stack

Jiri Olsa (4):
      selftests/bpf: Shuffle cookies symbols in kprobe multi test
      ftrace: Keep address offset in ftrace_lookup_symbols
      bpf: Force cookies array to follow symbols sorting
      selftest/bpf: Fix kprobe_multi bench test

Jon Maxwell (1):
      bpf: Fix request_sock leak in sk lookup helpers

Kumar Kartikeya Dwivedi (1):
      bpf: Limit maximum modifier chain length in btf_check_type_tags

Masami Hiramatsu (Google) (2):
      fprobe, samples: Add use_trace option and show hit/missed counter
      rethook: Reject getting a rethook if RCU is not watching

 MAINTAINERS                                        | 41 ++++++------
 arch/x86/net/bpf_jit_comp.c                        |  3 +-
 kernel/bpf/btf.c                                   |  5 ++
 kernel/trace/bpf_trace.c                           | 60 ++++++++++++-----
 kernel/trace/ftrace.c                              | 13 +++-
 kernel/trace/rethook.c                             |  9 +++
 net/core/filter.c                                  | 34 ++++++++--
 net/xdp/xsk.c                                      | 16 +++--
 samples/fprobe/fprobe_example.c                    | 29 ++++++--
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  | 78 +++++++++++-----------
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  3 +
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 55 +++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi.c   | 24 +++----
 .../selftests/bpf/progs/tailcall_bpf2bpf6.c        | 42 ++++++++++++
 14 files changed, 305 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
