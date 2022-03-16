Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3774DAF90
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344632AbiCPMZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244567AbiCPMZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679C54C42B;
        Wed, 16 Mar 2022 05:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF48B81AE6;
        Wed, 16 Mar 2022 12:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2428C340E9;
        Wed, 16 Mar 2022 12:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433466;
        bh=toBYF2ccw+sUX2uf+591DZP/y4Fc7XGQSyfSxHJ4OBA=;
        h=From:To:Cc:Subject:Date:From;
        b=V+KoEnT2o+XavLJqR3tS5Q6sK09CFwU2BzjDiFZf2++oUwogpuW5V6jzpPSTEv8c1
         3IujHvQGhStgnMhd2kug7IVmsEJo8VzMOY//r60rTx/Sg1tuyG9q/SBnxyII+dXUzY
         cOm8yiyxbLK1opk+w3RlNaxmHfzIyuXTAGjDBYxRxDz4NvcbW6YWfmMDOQkdZFvsfq
         /QkiWekGL6BjBI/Q2YVKqorHDrbh/+GruqVM7EHEMWa/3MA4RvUUqQznVTUh5G1UJp
         dq3ceQ72d2POxA2WHX9HAnT13HlaugJJlPsBWZEdmWMopU99/nqBYPaQRX7qNLN1MI
         ln1c+VH2a2UbA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 00/13] bpf: Add kprobe multi link
Date:   Wed, 16 Mar 2022 13:24:06 +0100
Message-Id: <20220316122419.933957-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
this patchset adds new link type BPF_TRACE_KPROBE_MULTI that attaches
kprobe program through fprobe API [1] instroduced by Masami.

The fprobe API allows to attach probe on multiple functions at once very
fast, because it works on top of ftrace. On the other hand this limits
the probe point to the function entry or return.


With bpftrace support I see following attach speed:

  # perf stat --null -r 5 ./src/bpftrace -e 'kprobe:x* { } i:ms:1 { exit(); } '
  Attaching 2 probes...
  Attaching 3342 functions
  ...

  1.4960 +- 0.0285 seconds time elapsed  ( +-  1.91% )

v3 changes:
  - based on latest fprobe post from Masami [2]
  - add acks
  - add extra comment to kprobe_multi_link_handler wrt entry ip setup [Masami]
  - keep swap_words_64 static and swap values directly in
    bpf_kprobe_multi_cookie_swap [Andrii]
  - rearrange locking/migrate setup in kprobe_multi_link_prog_run [Andrii]
  - move uapi fields [Andrii]
  - add bpf_program__attach_kprobe_multi_opts function [Andrii]
  - many small test changes [Andrii]
  - added tests for bpf_program__attach_kprobe_multi_opts
  - make kallsyms_lookup_name check for empty string [Andrii]

v2 changes:
  - based on latest fprobe changes [1]
  - renaming the uapi interface to kprobe multi
  - adding support for sort_r to pass user pointer for swap functions
    and using that in cookie support to keep just single functions array
  - moving new link to kernel/trace/bpf_trace.c file
  - using single fprobe callback function for entry and exit
  - using kvzalloc, libbpf_ensure_mem functions
  - adding new k[ret]probe.multi sections instead of using current kprobe
  - used glob_match from test_progs.c, added '?' matching
  - move bpf_get_func_ip verifier inline change to seprate change
  - couple of other minor fixes


Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/kprobe_multi

thanks,
jirka


[1] https://lore.kernel.org/bpf/164458044634.586276.3261555265565111183.stgit@devnote2/
[2] https://lore.kernel.org/bpf/164735281449.1084943.12438881786173547153.stgit@devnote2/
---
Jiri Olsa (13):
      lib/sort: Add priv pointer to swap function
      kallsyms: Skip the name search for empty string
      bpf: Add multi kprobe link
      bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
      bpf: Add support to inline bpf_get_func_ip helper on x86
      bpf: Add cookie support to programs attached with kprobe multi link
      libbpf: Add libbpf_kallsyms_parse function
      libbpf: Add bpf_link_create support for multi kprobes
      libbpf: Add bpf_program__attach_kprobe_multi_opts function
      selftests/bpf: Add kprobe_multi attach test
      selftests/bpf: Add kprobe_multi bpf_cookie test
      selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
      selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts

 include/linux/bpf_types.h                                  |   1 +
 include/linux/sort.h                                       |   2 +-
 include/linux/trace_events.h                               |   7 ++
 include/linux/types.h                                      |   1 +
 include/uapi/linux/bpf.h                                   |  14 ++++
 kernel/bpf/syscall.c                                       |  26 +++++--
 kernel/bpf/verifier.c                                      |  21 +++++-
 kernel/kallsyms.c                                          |   4 ++
 kernel/trace/bpf_trace.c                                   | 342 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/sort.c                                                 |  40 ++++++++---
 tools/include/uapi/linux/bpf.h                             |  14 ++++
 tools/lib/bpf/bpf.c                                        |   9 +++
 tools/lib/bpf/bpf.h                                        |   9 ++-
 tools/lib/bpf/libbpf.c                                     | 222 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h                                     |  23 +++++++
 tools/lib/bpf/libbpf.map                                   |   1 +
 tools/lib/bpf/libbpf_internal.h                            |   5 ++
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c        | 177 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 323 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi.c           |  98 +++++++++++++++++++++++++++
 tools/testing/selftests/bpf/trace_helpers.c                |   7 ++
 21 files changed, 1302 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
