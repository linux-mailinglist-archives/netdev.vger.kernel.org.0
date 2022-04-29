Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D68514CDB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377309AbiD2Obp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377303AbiD2Obl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:31:41 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CCCA146B;
        Fri, 29 Apr 2022 07:28:23 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e3so6178563ios.6;
        Fri, 29 Apr 2022 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWFctTI+mXIW9rm2Z4IJhom0SL/RWdmtfrY+iQvt6FA=;
        b=jHKhliWrqbQoVow7fGCTJdPFqzggfhuWVKTRIWSPuWhXKVYJ80krZWklu04o9V6Fd8
         hhMCQw2L7yT0oPHMhQhZGJDTcaYrTC2DlX+AVI95wE2hlgexONqHGa36puC0yxFPGgYG
         3XsLK7W4um51+z3cc8onQkPOYbNJnyJVWe4HH4wV8lDs2iQIPoo5XXbtavGiGs48lqtE
         u3gXFJG7HiktowaHujwN1V6hNye2rTR2ahOQfj7VTwJiJZ7BLTmdbxEuR6qVGGIOBnyN
         vxou52POOf7DvdjaagR9BjD9nMgbNBP7zQtWwokfmrbdGAOTP3im69zSNzdhlOg5EynW
         ZE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWFctTI+mXIW9rm2Z4IJhom0SL/RWdmtfrY+iQvt6FA=;
        b=oklFnoFKIfymBuwM50GJWj25vqzPJS2QVbvsmZQpOs9fYf4NRM058GmzExPFXyHBza
         Xmj9q13oy51J70GxYsZH6MFoPp6ztlbC0WHWBFLLogkZ9U7yf8kkY2D2w4wa15OkMb2V
         Rf+V/AHtz4hJ+Meigl+NakNkhjC4FvRWDcV+vo7sfGdz0LX0aVnctKhZ3qOaz8eDocKk
         wbtNa5X0x0r03265gwRt3g633H+8Jm3mfsaFfmdXhmwPZxk/7FS0ncYqDuasHgs3YZeP
         knX+ajHVTJEXWMmYtULetaROi+TXQamhU1bbZnrWxoYXulh9xx3q9hNnjPUx8L/7FTNI
         nX/w==
X-Gm-Message-State: AOAM533Y7p7YQ9vstAyjS1nImK/8qBFba+khR8xlwSAKxhvueaQBWGtM
        QrLu5u7aXZBpaMYgdY2aZPRCgka0Cr28vWkiZmPhSc7JcEI=
X-Google-Smtp-Source: ABdhPJyyCIOvdRCtqPahekmTcRuVSJ2yQfDwIjwiwzZSYsa5H8jfW5J6Y97ndORmFNp37BD6XiDRj58+gRkvavDe6EY=
X-Received: by 2002:a5e:8e42:0:b0:657:bc82:64e5 with SMTP id
 r2-20020a5e8e42000000b00657bc8264e5mr4118248ioo.112.1651242502506; Fri, 29
 Apr 2022 07:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220428201207.954552-1-jolsa@kernel.org>
In-Reply-To: <20220428201207.954552-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 Apr 2022 07:28:11 -0700
Message-ID: <CAEf4BzYtXWvBWzmadhLGqwf8_e2sruK6999th6c=b=O0WLkHOA@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 0/5] bpf: Speed up symbol resolving in kprobe
 multi link
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 1:12 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> sending additional fix for symbol resolving in kprobe multi link
> requested by Alexei and Andrii [1].
>
> This speeds up bpftrace kprobe attachment, when using pure symbols
> (3344 symbols) to attach:
>
> Before:
>
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
>
> After:
>
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
>
> v4 changes:
>   - fix compile issue [kernel test robot]
>   - added acks [Andrii]
>
> v3 changes:
>   - renamed kallsyms_lookup_names to ftrace_lookup_symbols
>     and moved it to ftrace.c [Masami]
>   - added ack [Andrii]
>   - couple small test fixes [Andrii]
>
> v2 changes (first version [2]):
>   - removed the 2 seconds check [Alexei]
>   - moving/forcing symbols sorting out of kallsyms_lookup_names function [Alexei]
>   - skipping one array allocation and copy_from_user [Andrii]
>   - several small fixes [Masami,Andrii]
>   - build fix [kernel test robot]
>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com/
> [2] https://lore.kernel.org/bpf/20220407125224.310255-1-jolsa@kernel.org/
> ---
> Jiri Olsa (5):
>       kallsyms: Fully export kallsyms_on_each_symbol function
>       ftrace: Add ftrace_lookup_symbols function
>       fprobe: Resolve symbols with ftrace_lookup_symbols
>       bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
>       selftests/bpf: Add attach bench test
>

Please check [0], it reports rcu_read_unlock() misuse

  [0] https://github.com/kernel-patches/bpf/runs/6223167405?check_suite_focus=true

>  include/linux/ftrace.h                                     |   6 ++++++
>  include/linux/kallsyms.h                                   |   7 ++++++-
>  kernel/kallsyms.c                                          |   3 +--
>  kernel/trace/bpf_trace.c                                   | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
>  kernel/trace/fprobe.c                                      |  32 ++++++++++++--------------------
>  kernel/trace/ftrace.c                                      |  62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/kprobe_multi_empty.c     |  12 ++++++++++++
>  8 files changed, 298 insertions(+), 69 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
