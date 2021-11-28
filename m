Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3270A4605B0
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 11:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357107AbhK1KkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 05:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhK1KiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 05:38:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDBBC061574;
        Sun, 28 Nov 2021 02:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D88F260F17;
        Sun, 28 Nov 2021 10:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3F1C004E1;
        Sun, 28 Nov 2021 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638095698;
        bh=+8T3JcjffAOWYDApIveGl9HhTHeoo4rTTyhbueXv0QI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q/2TbPHtAaSsEKff9XOEXMGU1xfRPZTrMxRtH1qzxYWwGLCS+Ucw59axB7CeqKkTL
         aJOIf3/Za+8U4Ajcc5S9YWVYztV7HkuGSi5lIVHfIAcY0ni0CZXihirmlgaFH8F7Yr
         QE31eqW/NUz7bg0mALlcHlZ1p1kiKqaM8FwvJW8rTs1xpVGbVr3/m8AmAwhKXU2SUw
         e2CSH6rpD7r8Fq6GX0m5S95aBpVuFO7Ryd4xoa6e8lRcbINArqn5AXY+Ex9xRTj2IN
         tv55Gf+cSsvyPhGcPN+7DarOAZFrR4mPFK8g9dsTrxc21l0XotbujLEKWYp6+9ngjW
         okUnX0rKuyP6A==
Date:   Sun, 28 Nov 2021 19:34:50 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [RFC 0/8] perf/bpf: Add batch support for [ku]probes attach
Message-Id: <20211128193450.8147832ab7d0d10494102ffb@kernel.org>
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Wed, 24 Nov 2021 09:41:11 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> hi,
> adding support to create multiple kprobes/uprobes within single
> perf event. This way we can associate single bpf program with
> multiple kprobes.

Thanks for the change, basically, you can repeatedly call the
create_local_trace_kprobe() and register it.

> 
> Sending this as RFC because I'm not completely sure I haven't
> missed anything in the trace/events area.

OK let me check that.

Thanks,

> 
> Also it needs following uprobe fix to work properly:
>   https://lore.kernel.org/lkml/20211123142801.182530-1-jolsa@kernel.org/
> 
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/kuprobe_batch
> 
> thanks,
> jirka
> 
> 
> ---
> Jiri Olsa (8):
>       perf/kprobe: Add support to create multiple probes
>       perf/uprobe: Add support to create multiple probes
>       libbpf: Add libbpf__kallsyms_parse function
>       libbpf: Add struct perf_event_open_args
>       libbpf: Add support to attach multiple [ku]probes
>       libbpf: Add support for k[ret]probe.multi program section
>       selftest/bpf: Add kprobe multi attach test
>       selftest/bpf: Add uprobe multi attach test
> 
>  include/uapi/linux/perf_event.h                            |   1 +
>  kernel/trace/trace_event_perf.c                            | 214 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
>  kernel/trace/trace_kprobe.c                                |  47 ++++++++++++++++---
>  kernel/trace/trace_probe.c                                 |   2 +-
>  kernel/trace/trace_probe.h                                 |   6 ++-
>  kernel/trace/trace_uprobe.c                                |  43 +++++++++++++++--
>  tools/include/uapi/linux/perf_event.h                      |   1 +
>  tools/lib/bpf/libbpf.c                                     | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
>  tools/lib/bpf/libbpf.h                                     |  25 +++++++++-
>  tools/lib/bpf/libbpf_internal.h                            |   5 ++
>  tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c |  83 +++++++++++++++++++++++++++++++++
>  tools/testing/selftests/bpf/prog_tests/multi_uprobe_test.c |  97 ++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/multi_kprobe.c           |  58 +++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/multi_uprobe.c           |  26 +++++++++++
>  14 files changed, 765 insertions(+), 78 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_uprobe_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/multi_kprobe.c
>  create mode 100644 tools/testing/selftests/bpf/progs/multi_uprobe.c
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
