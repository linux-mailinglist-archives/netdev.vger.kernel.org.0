Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EE94F7F82
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245469AbiDGMyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiDGMyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E4259B41;
        Thu,  7 Apr 2022 05:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C6060F8A;
        Thu,  7 Apr 2022 12:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B977C385A4;
        Thu,  7 Apr 2022 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649335959;
        bh=Efh9KZBTUFq/nJ++UsePBAQq4hIBUOTLc1DIbRgJ1Bg=;
        h=From:To:Cc:Subject:Date:From;
        b=OQ92ngDFwY+aYn6FxBtIm3WlGnTxQJAc8YV4jSbGv6OdA3IALRgCBdntcUUEIjY2s
         bt1XeMemV/OdaAyhGIBncslMeP32mOk2qWL3fD2ULF4Ar0kqbgzfZjuL+2h8s37Lsr
         hzk8Z9y4g9MYBZI0IRh4E2RHCrsJ7gGW5tVWq9Hb1JxFhuPNvfAWIWv/PlZ2MHABNH
         X6p3P78PlYtq6q0cLtWpKmmbFK5n7COGi6x6Wod4ykpnXUcfjKfLKRdUlnCMq4/Z6L
         7s8s15WHa61b6FpAy1WFyFuXLDz5NR7ub3xulKG01RYZG1qc9iJMxDOhpggYpoDiwS
         QwHuuNMudRMyA==
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
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next 0/4] bpf: Speed up symbol resolving in kprobe multi link
Date:   Thu,  7 Apr 2022 14:52:20 +0200
Message-Id: <20220407125224.310255-1-jolsa@kernel.org>
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
sending additional fix for symbol resolving in kprobe multi link
requested by Alexei and Andrii [1].

This speeds up bpftrace kprobe attachment, when using pure symbols
(3344 symbols) to attach:

Before:

  # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
  ...
  6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )

After:

  # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
  ...
  0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )


There are 2 reasons I'm sending this as RFC though..

  - I added test that meassures attachment speed on all possible functions
    from available_filter_functions, which is 48712 functions on my setup.
    The attach/detach speed for that is under 2 seconds and the test will
    fail if it's bigger than that.. which might fail on different setups
    or loaded machine.. I'm not sure what's the best solution yet, separate
    bench application perhaps?

  - copy_user_syms function potentially allocates lot of memory (~6MB in my
    tests with attaching ~48k functions). I haven't seen this to fail yet,
    but it might need to be changed to allocate memory gradually if needed,
    do we care? ;-)

thanks,
jirka


[1] https://lore.kernel.org/bpf/CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com/
---
Jiri Olsa (4):
      kallsyms: Add kallsyms_lookup_names function
      fprobe: Resolve symbols with kallsyms_lookup_names
      bpf: Resolve symbols with kallsyms_lookup_names for kprobe multi link
      selftests/bpf: Add attach bench test

 include/linux/kallsyms.h                                   |   6 ++++
 kernel/kallsyms.c                                          |  50 ++++++++++++++++++++++++++++++++-
 kernel/trace/bpf_trace.c                                   | 123 +++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 kernel/trace/fprobe.c                                      |  23 ++-------------
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c     |  12 ++++++++
 6 files changed, 283 insertions(+), 72 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
