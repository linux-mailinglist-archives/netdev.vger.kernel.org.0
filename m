Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEA439B147
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 06:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhFDESt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 00:18:49 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54829 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhFDESs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 00:18:48 -0400
Received: by mail-wm1-f48.google.com with SMTP id o127so4554417wmo.4
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 21:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gt5r+lBwCuoOA7rfQIlaZBhTcz5xyY6ZuYMcbufKUos=;
        b=pXfVS0SZxq556lEc4rP04GJ+qgvT/OfgZ6GWjum1lWJGmFlLn0UIhfcmvLozoTMPl6
         dFTZer+0saAoVGELO7+tFHPmONEOIFsP/2B24YoqJOSbVT1Qbp8MhvrOythK2lI8ZcSK
         lfYFhogf0BkpuuMQ2vgzYsV8SBe/Z3umeGLXeDHcPOzyosYXZtapt4idJ2Vgt79tiV9A
         AcbR/UUZJt4JO0HYV6GSl49RUNE1HAZ2Z0kxIct7cR2hyhnysXQ8LN/yGMV/3gz1E023
         MEqggsPvjm0V4piYAYa5Td9JqYxf4aWJnqMAdcuRpsoKH9W/EmMQmuiHJ3kT+W4xV1Va
         zFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gt5r+lBwCuoOA7rfQIlaZBhTcz5xyY6ZuYMcbufKUos=;
        b=drDlEifBWHu16tMJ1mDumWZSO5CjSJGVALk5Py4DLJVAjz/eKcq4veu7CkrjJvTBbG
         Z957ipdVmzlotwYZ1x6F91P6bqD7ybCk/h5QSOKblukcBP9HlW+sJG54oUzL0xlsuTm0
         +wOlGlG5au6EFozPi0xb2G8o7X2bgovj49eLzg26qbGp3K+5e0zyRMAVeiifQr4ruPPI
         eYMSX7JkZBmGTqJeQ8hPges6yGl46d57nRNIvV/uw9E0c43eC2zX8xLTZIRFCR1EA4kQ
         TyFs74NXSE3CReod6Trg4XA46RfGeN0ZLB1L2hEKw2O/w+5M0cxtZY4FN1RsM2q7/T9x
         CEmg==
X-Gm-Message-State: AOAM531VSY/GeFv2wtWAz7JodbgqLpqnIQlEdoJIxJo6AX27ucPf/lod
        WJt4Wo5ep0AZwHbqTTWeE5/lg3xg0U8GbwQjZR3agg==
X-Google-Smtp-Source: ABdhPJx2vWndMsU19H1kNaO6+JL/13qRYUi8/RATBdr+TJtyTLGIJgpuoWpiH5i1lF4ag++WCkz/IclGw42XD007YWQ=
X-Received: by 2002:a1c:b603:: with SMTP id g3mr1451928wmf.58.1622780145144;
 Thu, 03 Jun 2021 21:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210602224024.300485-1-rickyman7@gmail.com>
In-Reply-To: <20210602224024.300485-1-rickyman7@gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 3 Jun 2021 21:15:32 -0700
Message-ID: <CAP-5=fW5btkb9izxcUy+XgAQPCTRZAUMa4uQMUR_+N_d=17Mfg@mail.gmail.com>
Subject: Re: [PATCH] perf env: fix memory leak: free bpf_prog_info_linear
To:     Riccardo Mancini <rickyman7@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 3:41 PM Riccardo Mancini <rickyman7@gmail.com> wrote:
>
> ASan reported a memory leak caused by info_linear not being
> deallocated. The info_linear was allocated during
> perf_event__synthesize_one_bpf_prog.
> This patch adds the corresponding free() when bpf_prog_info_node
> is freed in perf_env__purge_bpf.
>
> $ sudo ./perf record -- sleep 5
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.025 MB perf.data (8 samples) ]
>
> =================================================================
> ==297735==ERROR: LeakSanitizer: detected memory leaks
>
> Direct leak of 7688 byte(s) in 19 object(s) allocated from:
>     #0 0x4f420f in malloc (/home/user/linux/tools/perf/perf+0x4f420f)
>     #1 0xc06a74 in bpf_program__get_prog_info_linear /home/user/linux/tools/lib/bpf/libbpf.c:11113:16
>     #2 0xb426fe in perf_event__synthesize_one_bpf_prog /home/user/linux/tools/perf/util/bpf-event.c:191:16
>     #3 0xb42008 in perf_event__synthesize_bpf_events /home/user/linux/tools/perf/util/bpf-event.c:410:9
>     #4 0x594596 in record__synthesize /home/user/linux/tools/perf/builtin-record.c:1490:8
>     #5 0x58c9ac in __cmd_record /home/user/linux/tools/perf/builtin-record.c:1798:8
>     #6 0x58990b in cmd_record /home/user/linux/tools/perf/builtin-record.c:2901:8
>     #7 0x7b2a20 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
>     #8 0x7b12ff in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
>     #9 0x7b2583 in run_argv /home/user/linux/tools/perf/perf.c:409:2
>     #10 0x7b0d79 in main /home/user/linux/tools/perf/perf.c:539:3
>     #11 0x7fa357ef6b74 in __libc_start_main /usr/src/debug/glibc-2.33-8.fc34.x86_64/csu/../csu/libc-start.c:332:16
>
> Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/env.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
> index 9130f6fad8d54..bc5e4f294e9e9 100644
> --- a/tools/perf/util/env.c
> +++ b/tools/perf/util/env.c
> @@ -144,6 +144,7 @@ static void perf_env__purge_bpf(struct perf_env *env)
>                 node = rb_entry(next, struct bpf_prog_info_node, rb_node);
>                 next = rb_next(&node->rb_node);
>                 rb_erase(&node->rb_node, root);
> +               free(node->info_linear);
>                 free(node);
>         }
>
> --
> 2.31.1
>
