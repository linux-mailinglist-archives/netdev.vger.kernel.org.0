Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D402F4BFFA5
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiBVRGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbiBVRGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:06:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0383353B55;
        Tue, 22 Feb 2022 09:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 753CFCE13B3;
        Tue, 22 Feb 2022 17:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6639C340E8;
        Tue, 22 Feb 2022 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549572;
        bh=envM6Pe0RNjwRRahtg36RWvOnQB8p5h1bqAvG1iwJ+I=;
        h=From:To:Cc:Subject:Date:From;
        b=Syn4hZMdM6n/VYkbbMBLZAjyLuBnppJIiMfpb0T6F01VJwhCiqvE2HOxlmTlpbmnV
         lLqzT2xz5cg6eIO23M3nxa1DeS80goZ/PhA+M39IXcsHZ96eAl73EbIGaLmtstKWX9
         CyYkiCMWnVs6IbkS71rIfiVmvkjvhzXjmYS6tvlPsNMjhIr8eTJFvA5XgSi8LGhSiP
         jM6O0mD86X79zMb9miol1YVf+fhNgxhYO6q7XmHoW++uESkCXiV9ls67SkoD1xr85N
         ZBwafFXF/RX7dYXeBYJgDW6LUkmqqnsz9PPYD4HI8A8heW/moUBWZG1L5VeKgO0PLH
         WGf6uZQB7o6Wg==
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
Subject: [PATCHv2 bpf-next 0/8] bpf: Add kprobe multi link
Date:   Tue, 22 Feb 2022 18:05:50 +0100
Message-Id: <20220222170600.611515-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
Jiri Olsa (10):
      lib/sort: Add priv pointer to swap function
      bpf: Add multi kprobe link
      bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
      bpf: Add support to inline bpf_get_func_ip helper on x86
      bpf: Add cookie support to programs attached with kprobe multi link
      libbpf: Add libbpf_kallsyms_parse function
      libbpf: Add bpf_link_create support for multi kprobes
      libbpf: Add bpf_program__attach_kprobe_opts support for multi kprobes
      selftest/bpf: Add kprobe_multi attach test
      selftest/bpf: Add kprobe_multi test for bpf_cookie values

 include/linux/bpf_types.h                                   |   1 +
 include/linux/sort.h                                        |   4 +-
 include/linux/trace_events.h                                |   6 ++
 include/linux/types.h                                       |   1 +
 include/uapi/linux/bpf.h                                    |  14 ++++
 kernel/bpf/syscall.c                                        |  26 ++++++--
 kernel/bpf/verifier.c                                       |  21 +++++-
 kernel/trace/bpf_trace.c                                    | 331 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/sort.c                                                  |  42 +++++++++---
 tools/include/uapi/linux/bpf.h                              |  14 ++++
 tools/lib/bpf/bpf.c                                         |   7 ++
 tools/lib/bpf/bpf.h                                         |   9 ++-
 tools/lib/bpf/libbpf.c                                      | 192 +++++++++++++++++++++++++++++++++++++++++++++--------
 tools/lib/bpf/libbpf_internal.h                             |   5 ++
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c         |  72 ++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c  | 115 ++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi.c            |  58 ++++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c |  62 +++++++++++++++++
 18 files changed, 930 insertions(+), 50 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
